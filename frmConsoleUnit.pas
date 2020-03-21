unit frmConsoleUnit;

interface

uses
  Forms, Windows, Messages, Dialogs, SysUtils, Classes, Controls, ComCtrls, StdCtrls, Menus, ShellAPI, ExtCtrls, AlignEdit,
	CoolTrayIcon, ImgList;

type
  TfrmTARConsole = class(TForm)
    txtConsole: TAlignEdit;
    mnuMain: TPopupMenu;
    mnuExit: TMenuItem;
    mnuBorder6: TMenuItem;
    mnuSelectAll: TMenuItem;
    mnuClear: TMenuItem;
    mnuBorder4: TMenuItem;
    mnuReread: TMenuItem;
    mnuUndo: TMenuItem;
    mnuSettings: TMenuItem;
    mnuEditor: TMenuItem;
    mnuBorder2: TMenuItem;
    mnuShowConsole: TMenuItem;
    mnuHideConsole: TMenuItem;
    mnuAbout: TMenuItem;
    mnuBorder7: TMenuItem;
    mnuHelp: TMenuItem;
    mnuToggleET: TMenuItem;
    mnuCut: TMenuItem;
    mnuCopy: TMenuItem;
    mnuPaste: TMenuItem;
    mnuBorder3: TMenuItem;
    mnuNewAlias: TMenuItem;
    mnuBorder5: TMenuItem;
    mnuDelString: TMenuItem;
    trayIcon: TCoolTrayIcon;
    mnuOpenFolder: TMenuItem;
    trayIcons: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure txtConsoleKeyPress(Sender: TObject; var Key: Char);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuSelectAllClick(Sender: TObject);
    procedure mnuClearClick(Sender: TObject);
    procedure txtConsoleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure txtConsoleKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
		procedure mnuRereadClick(Sender: TObject);
    procedure mnuUndoClick(Sender: TObject);
    procedure txtConsoleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure mnuSettingsClick(Sender: TObject);
    procedure mnuEditorClick(Sender: TObject);
    procedure mnuHideConsoleClick(Sender: TObject);
    procedure mnuShowConsoleClick(Sender: TObject);
		procedure AppDeActivate(Sender: TObject);
		procedure AppActivate(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
    procedure mnuHelpClick(Sender: TObject);
    procedure mnuToggleETClick(Sender: TObject);
    procedure mnuCutClick(Sender: TObject);
    procedure mnuCopyClick(Sender: TObject);
    procedure mnuPasteClick(Sender: TObject);
    procedure mnuNewAliasClick(Sender: TObject);
    procedure mnuDelStringClick(Sender: TObject);
    procedure trayIconDblClick(Sender: TObject);
    procedure trayIconMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormHide(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure mnuOpenFolderClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure mnuMainPopup(Sender: TObject);
	private
		procedure WMHotkey(var Msg: TWMHotkey); message WM_HOTKEY;
    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
		procedure WMOnMove(var Msg: TWMMove ); message WM_MOVE;
    procedure WMDialogKey(var Msg: TCMDialogKey); message CM_DIALOGKEY;
		procedure WMMouseWheel(var Msg: TMessage); message WM_MOUSEWHEEL;
	public
    procedure EasyTypeTimer(Sender: TObject);
    procedure AutoHideTimer(Sender: TObject);
    procedure AutoRereadTimer(Sender: TObject);
    procedure BallonTimer(Sender: TObject);
		procedure WndProc(var Message: TMessage); override;
	end;

var
	frmTARConsole: TfrmTARConsole;
	IsShift: boolean; // Зажат ли Shift
	Unded: boolean; // Флаг отмены
  Tabbed: boolean; // Флаг перебора по TAB'у
  tmrAutoReread: TTimer; // Автоперечитывание конфига
  tmrAutoHide: TTimer; // Автоскрытие программы
	tmrEasyType: TTimer; // Работа автодополнения
	CanUnload: boolean; // Идёт ли уже выгрузка программы
  MainMenuEvent: integer; // Откуда вызывается главное меню

implementation

{$R *.dfm}

uses Static, ForAll, Configs, frmSettingsUnit, frmAboutUnit, Plugins, frmTypeDownDropUnit, Settings, frmHintUnit;

// Колесико мыши
procedure TfrmTARConsole.WMMouseWheel(var Msg: TMessage);
begin
	if (Msg.WParam<0) xor (Options.History.InvertScroll) then
		HistoryDown
	else
		HistoryUp;
	inherited;
end;

// Перетаскивание формы.
procedure TfrmTARConsole.WMNcHitTest(var Msg: TWMNcHitTest);
var
	ScrPoint: TPoint;
begin
	if (GetKeyState(VK_CONTROL) and $8000)=0 then exit;
	with Msg do begin
		ScrPoint.x:=XPos;
		ScrPoint.y:=YPos;
		Result:=HTCAPTION;
	end;
end;

// Запускается при нажатии забитого системного хоткея
procedure TfrmTARConsole.WMHotkey(var Msg: TWMHotkey);
begin
	if Msg.HotKey=HotKeyId then begin
		if Options.Show.TriggerShow then
			if frmTARConsole.Visible then
      	frmTARConsole.Hide
      else
      	ShowCon
		else
			ShowCon;
  end;
end;

// Ловим запуск произвольной строки
procedure TfrmTARConsole.WMCopyData(var Msg: TMessage);
var
	txtString: string;
begin
  SetLength(txtString, PCopyDataStruct(Msg.LParam)^.cbData);
  Move(PCopyDataStruct(Msg.LParam)^.lpData^, txtString[1], Length(txtString));
  IsParseMessage:=True;
  ParseConsole(Trim(txtString));
end;

// Прилипание консоли к краям экрана.
procedure TfrmTARConsole.WMOnMove(var Msg: TWMMove);
const
	hitPix=7;
begin
	Inherited;
  if(txtConsole.Top=-txtConsole.Height) then begin
    if (frmTARConsole.Top<Screen.WorkAreaRect.Top+hitPix) and (frmTARConsole.Top>Screen.WorkAreaRect.Top-hitPix) then frmTARConsole.Top:=Screen.WorkAreaRect.Top;
    if (frmTARConsole.Top>Screen.WorkAreaRect.Bottom-frmTARConsole.Height-hitPix) and (frmTARConsole.Top<Screen.WorkAreaRect.Bottom-frmTARConsole.Height+hitPix) then frmTARConsole.Top:=Screen.WorkAreaRect.Bottom-frmTARConsole.Height;
    if (frmTARConsole.Left<Screen.WorkAreaRect.Left+hitPix) and (frmTARConsole.Left>Screen.WorkAreaRect.Left-hitPix) then frmTARConsole.Left:=Screen.WorkAreaRect.Left;
    if (frmTARConsole.Left>Screen.WorkAreaRect.Right-frmTARConsole.Width-hitPix) and (frmTARConsole.Left<Screen.WorkAreaRect.Right-frmTARConsole.Width+hitPix) then frmTARConsole.Left:=Screen.WorkAreaRect.Right-frmTARConsole.Width;
    if (frmTARConsole.Top<hitPix) and (frmTARConsole.Top>-hitPix) then frmTARConsole.Top:=0;
    if (frmTARConsole.Top>Screen.Height-frmTARConsole.Height-hitPix) and (frmTARConsole.Top<Screen.Height-frmTARConsole.Height+hitPix) then frmTARConsole.Top:=Screen.Height-frmTARConsole.Height;
    if (frmTARConsole.Left<hitPix) and (frmTARConsole.Left>-hitPix) then frmTARConsole.Left:=0;
    if (frmTARConsole.Left>Screen.Width-frmTARConsole.Width-hitPix) and (frmTARConsole.Left<Screen.Width-frmTARConsole.Width+hitPix) then frmTARConsole.Left:=Screen.Width-frmTARConsole.Width;
  end;
end;

// Деактивизация консоли
procedure TfrmTARConsole.AppDeActivate(Sender: TObject);
begin
	if frmTARConsole.Visible then begin
		tmrAutoHide.Enabled:=False;
		tmrAutoHide.Enabled:=Options.Show.AutoHide;
	end;
end;                                              

// Активизация консоли
procedure TfrmTARConsole.AppActivate(Sender: TObject);
begin
	tmrAutoHide.Enabled:=False;
end; // AppActivate

// Процесс инициализации при создании формы
procedure TfrmTARConsole.FormCreate(Sender: TObject);
begin
  // Инициализация таймеров
  tmrEasyType:=TTimer.Create(frmTARConsole);
  tmrEasyType.Enabled:=False;
  tmrEasyType.Interval:=1;
  tmrEasyType.OnTimer:=EasyTypeTimer;

  tmrAutoHide:=TTimer.Create(frmTARConsole);
  tmrAutoHide.Enabled:=False;
  tmrAutoHide.OnTimer:=AutoHideTimer;

  tmrAutoReread:=TTimer.Create(frmTARConsole);
  tmrAutoReread.Enabled:=False;
  tmrAutoReread.OnTimer:=AutoRereadTimer;

  tmrHide:=TTimer.Create(frmTARConsole);
  tmrHide.Enabled:=False;
	tmrHide.OnTimer:=frmTARConsole.BallonTimer;

	Options.ReadSettings;

	// Подсказка в трее
  setTrayIcon;
	trayIcon.Hint:=Program_Name+' '+Program_Version;
  MainMenuEvent:=0;

	// Можно выгружать
	CanUnload:=true;
end;

// Убираем кнопку на таскбаре при показе формы
procedure TfrmTARConsole.FormShow(Sender: TObject);
begin
	ShowWindow(Application.Handle, SW_HIDE);
	if frmTARConsole.Visible and frmTARConsole.Enabled and frmTARConsole.txtConsole.Visible and frmTARConsole.txtConsole.Enabled then txtConsole.SetFocus;
end;


procedure TfrmTARConsole.FormClose(Sender: TObject; var Action: TCloseAction);
begin

end;

// Нажатие клавиши в консоли
procedure TfrmTARConsole.txtConsoleKeyPress(Sender: TObject; var Key: Char);
var
	ConText: string;
begin
	tmrAutoHide.Enabled:=False;

	// Нажат TAB - автодополнение
	if Key=Char(VK_TAB) then begin
		Key:=#0;
		Tabbed:=True;
    if Options.EasyType.EasyType=1 then
      ET_Console(txtConsole.Text, txtConsole.SelStart, txtConsole.SelLength);
    if Options.EasyType.EasyType=2 then begin
      if ShortText='' then ShortText:=txtConsole.Text;
      ET_Console(txtConsole.Text, Length(ShortText), Length(txtConsole.Text)-Length(ShortText));
		end;
  end
	else begin
    ConText:=txtConsole.Text;
    ShortText:='';
    ET_Num:=0;
    if Key=Char(VK_RETURN) then begin
      Key:=#0;
      if ConText<>'' then begin
        ParseConsole(ConText);
      end;
    end
    else begin
      if (not Unded) and Options.Undo.UseUndo then
        AddUndo(txtConsole.Text, txtConsole.SelStart, txtConsole.SelLength);
      Unded:=FALSE;
    	if Options.EasyType.AdvancedSpace and (txtConsole.SelLength<>0) then begin
    		if Key=Char(VK_SPACE) then begin
          if not IsShift then begin
            txtConsole.SelStart:=txtConsole.SelStart+txtConsole.SelLength;
            txtConsole.SelLength:=0;
          end;
          if Options.EasyType.EasyType=1 then tmrEasyType.Enabled:=True;
        end;
      end;
      if (Key='\') and PB_Flag then begin // Если нажат слеш при автодополнении
        if SetBrowse then Key:=#0;
        PB_Flag:=False;
			end
			else if (Key=Char(VK_BACK)) then begin
				if Options.EasyType.AdvancedBackspace and (Options.EasyType.EasyType=1) and not IsShift then begin
					CoolBackSpace;
					if txtConsole.Text<>txtConsole.SelText then tmrEasyType.Enabled:=True;
				end;
			end
			else if (Key=#127) then begin
				Key:=#0;
        CtrlBackSpace;
			end
			else if (Key<>'"') then
        if Options.EasyType.EasyType=1 then
          tmrEasyType.Enabled:=True;
    end;
		if(txtConsole.Text = '') then ViewHint('');
  end;
end;

// Выход из консоли (меню)
procedure TfrmTARConsole.mnuExitClick(Sender: TObject);
begin
	frmTARConsole.Hide;
	frmTARConsole.Close;
end;

// Выделить весь текст (меню)
procedure TfrmTARConsole.mnuSelectAllClick(Sender: TObject);
begin
	txtConsole.SelectAll;
end;

// Очистить консоль (меню)
procedure TfrmTARConsole.mnuClearClick(Sender: TObject);
begin
	txtConsole.Clear;
end;

// Зажатие клавиши в консоли
procedure TfrmTARConsole.txtConsoleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Options.Font.LockEnglish then SetKeyboardLayout('00000409');
	if Shift = [ssShift]+[ssCtrl]+[ssAlt] then begin
		txtConsole.Top:=-txtConsole.Height;
	end;
	if Key = VK_SHIFT then IsShift:=True;
	// Кнопка вверх - история вперед
	if Key = VK_UP then begin
  	Key:=0;
    if Options.History.InvertScroll then HistoryDown else HistoryUp;
	end;
	// Кнопка вниз - история назад
	if Key = VK_DOWN then begin
		Key:=0;
		if Shift = [ssCtrl] then begin
			if ((frmHint<>nil) and frmHint.Visible) then
				ViewHint('')
			else
				ViewHint(txtConsole.Text)
		end
    else if Shift = [ssAlt] then
      DropDown(txtConsole.Text, txtConsole.SelStart, txtConsole.SelLength)
    else
	    if Options.History.InvertScroll then HistoryUp else HistoryDown;
	end;
end;

// Отжатие клавиши в консоли
procedure TfrmTARConsole.txtConsoleKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Options.Font.LockEnglish then SetKeyboardLayout('00000409');
  if Key = VK_SHIFT then IsShift:=False;
 	txtConsole.Top:=0;
	Options.Show.ConsoleX:=frmTARConsole.Left;
	Options.Show.ConsoleY:=frmTARConsole.Top;
	if(txtConsole.Text = '') then ViewHint('');
end;

// Перечитать конфиги (меню)
procedure TfrmTARConsole.mnuRereadClick(Sender: TObject);
begin
	Options.ReadSettings;
	ApplySettings;
	ReadConfig(Program_Config);
	ReadHistory(Program_History);
	Options.SystemAliases.ReadSystemAliases;
end;

// Инициализации отмены на один шаг (меню)
procedure TfrmTARConsole.mnuUndoClick(Sender: TObject);
begin
	if ((UndoMax>0) and (Options.Undo.UseUndo)) then begin
		txtConsole.Text:=Undo[UndoMax-1];
		txtConsole.SelStart:=UndoCur[UndoMax-1];
		txtConsole.SelLength:=UndoCurLength[UndoMax-1];
		Dec(UndoMax);
		SetLength(Undo, UndoMax);
		SetLength(UndoCur, UndoMax);
		SetLength(UndoCurLength, UndoMax);
	end;
end;

// Меню в консоли. Показываются менюхи, относящиеся к полю редактирования.
procedure TfrmTARConsole.txtConsoleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Options.Font.LockEnglish then SetKeyboardLayout('00000409');
	if (Button=mbRight) then MainMenuEvent:=0;
end;

// Вызов настроек
procedure TfrmTARConsole.mnuSettingsClick(Sender: TObject);
begin
	CreateSettingsForm;
  frmSettings.Show;
	AttachThreadInput(GetWindowThreadProcessId(GetForegroundWindow, nil), GetWindowThreadProcessId(frmSettings.Handle, nil), True);
	SetForegroundWindow(frmSettings.Handle);
	frmSettings.BringToFront;
	frmTARConsole.Hide;
end;

// Вызов настроек, сразу редактирование конфига
procedure TfrmTARConsole.mnuEditorClick(Sender: TObject);
var
  strCon: string;
  i: integer;
begin
	strCon:=Trim(txtConsole.Text);
	NumEditor:=0;
	if strCon<>'' then begin
		i:=0;
		while i<ConfigStr.Count do begin
			if strCon=GetName('alias', ConfigStr.Strings[i]) then begin
				NumEditor:=i;
				Break;
			end;
			Inc(i);
		end;
	end;
	IsEditor:=True;
	CreateSettingsForm;
	frmSettings.Show;
	AttachThreadInput(GetWindowThreadProcessId(GetForegroundWindow, nil), GetWindowThreadProcessId(frmSettings.Handle, nil), True);
	SetForegroundWindow(frmSettings.Handle);
	frmSettings.BringToFront;
	frmTARConsole.Hide;
end;

// Автодополнение срабатывает по таймеру
procedure TfrmTARConsole.EasyTypeTimer(Sender: TObject);
begin
	tmrEasyType.Enabled:=False;
	if Options.EasyType.EasyType=1 then
		ET_Console(txtConsole.Text, txtConsole.SelStart, txtConsole.SelLength);
	if Options.EasyType.EasyType=2 then
		ET_Console(txtConsole.Text, Length(ShortText), Length(txtConsole.Text)-Length(ShortText));
end;

// Показывает балун типс в трее и скрывает его через некоторое время
procedure TfrmTARConsole.BallonTimer(Sender: TObject);
begin
  tmrHide.Enabled:=False;
  trayIcon.HideBalloonHint;
end;

// Скрыть консоль (из меню)
procedure TfrmTARConsole.mnuHideConsoleClick(Sender: TObject);
begin
	frmTARConsole.Hide;
end;

// Показать консоль из меню
procedure TfrmTARConsole.mnuShowConsoleClick(Sender: TObject);
begin
	ShowCon;
end;

// Автоскрытие консоли по таймеру
procedure TfrmTARConsole.AutoHideTimer(Sender: TObject);
begin
	frmTARConsole.Hide;
	tmrAutoHide.Enabled:=False;
end;

// Перечитывание конфига по таймеру
procedure TfrmTARConsole.AutoRereadTimer(Sender: TObject);
begin
	ReadConfig(Program_Config);
  Options.SystemAliases.ReadSystemAliases;
end;

// Вызов окна О программе...
procedure TfrmTARConsole.mnuAboutClick(Sender: TObject);
begin
  CreateAboutForm;
	frmAbout.Show;
	frmTARConsole.Hide;
end;

// Вызов помощи
procedure TfrmTARConsole.mnuHelpClick(Sender: TObject);
begin
	HideCon;
	if FileExists(GetMyPath+'Lang\'+Options.Language.Language+'.chm') then
		RunShell(GetMyPath+'Lang\'+Options.Language.Language+'.chm')
	else
		RunShell(GetMyPath+'Lang\English.chm');
end;

// Переключение режима EasyType
procedure TfrmTARConsole.mnuToggleETClick(Sender: TObject);
begin
	mnuToggleET.Checked:=not mnuToggleET.Checked;
  frmTARConsole.BorderWidth:=0;
  if mnuToggleET.Checked then begin
  	Options.EasyType.EasyType:=1;
    frmTARConsole.txtConsole.Font.Color:=Options.Color[1].Text;
    frmTARConsole.txtConsole.Color:=Options.Color[1].Console;
    frmTARConsole.color:=Options.Color[1].Border;
  end
  else begin
  	Options.EasyType.EasyType:=0;
    frmTARConsole.txtConsole.Font.Color:=Options.Color[2].Text;
    frmTARConsole.txtConsole.Color:=Options.Color[2].Console;
    frmTARConsole.color:=Options.Color[2].Border;
  end;
  frmTARConsole.BorderWidth:=Options.Show.BorderSize;
end;

// Вырезает в буфер обмена
procedure TfrmTARConsole.mnuCutClick(Sender: TObject);
begin
	if (not Unded) and Options.Undo.UseUndo then
		AddUndo(txtConsole.Text, txtConsole.SelStart, txtConsole.SelLength);
	txtConsole.CutToClipboard;
end;                                                          

// Копирует в буфер обмена
procedure TfrmTARConsole.mnuCopyClick(Sender: TObject);
begin
	txtConsole.CopyToClipboard;
end;

// Вставляет из буфера обмена
procedure TfrmTARConsole.mnuPasteClick(Sender: TObject);
begin
	if (not Unded) and Options.Undo.UseUndo then
		AddUndo(txtConsole.Text, txtConsole.SelStart, txtConsole.SelLength);
	txtConsole.PasteFromClipboard;
end;

// Сразу создаем новый алиас
procedure TfrmTARConsole.mnuNewAliasClick(Sender: TObject);
begin
	if txtConsole.Text<>'' then
    AddToProgram('--add='+txtConsole.Text)
  else
    AddToProgram('--add=!@#$%^&*()');
end;

// Удаление строки прямо из консоли
procedure TfrmTARConsole.mnuDelStringClick(Sender: TObject);
var
  strCon: string;
  i: integer;
begin
	strCon:=Trim(txtConsole.Text);
	if strCon<>'' then begin
    i:=0;
    while i<ConfigStr.Count do begin
      if strCon=GetName('alias', ConfigStr.Strings[i]) then begin
        ConfigStr.Delete(i);
        SaveConfig(Program_Config);
        txtConsole.Clear;
      end;
      Inc(i);
    end;
    i:=0;
    while i<HistoryStr.Count do begin
      if strCon=HistoryStr.Strings[i] then begin
        HistoryStr.Delete(i);
        SaveHistory(Program_History);
        ReadHistory(Program_History);
        // Перемещение указателя в соседнюю позицию
        if HistoryStr.Count>0 then begin
      		HisViewPos:=i;
          if HisViewPos=0 then HisViewPos:=1;
	        HistoryUp;
        end
        else
        	txtConsole.Clear;
      end;
      Inc(i);
    end;
  end;
end;

// Обработка клавиши TAB
procedure TfrmTARConsole.WMDialogKey(var Msg: TCMDialogKey);
begin
	if Msg.Charcode<>VK_TAB then inherited;
end;

// Показывать консоль при двойном щелчке
procedure TfrmTARConsole.trayIconDblClick(Sender: TObject);
begin
	Showcon;
end;

// Меню в трее. Убираются менюхи, относящиеся к полю редактирования.
procedure TfrmTARConsole.trayIconMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	if (Button=mbRight) then MainMenuEvent:=1;
end;

// Ловим сообщение окну
procedure TfrmTARConsole.WndProc;
var
	Buf: array[Byte] of Char;
begin
	if Message.Msg=WM_SendFileNameToOpen then begin
		GlobalGetAtomName(Message.LParam, Buf, 255);
    AddToProgram(Buf);
	end
	else
		inherited WndProc(Message);
end;

// При скрытии формы убрать подсказку
procedure TfrmTARConsole.FormHide(Sender: TObject);
begin
	ViewHint('');
	if frmTypeDropDown<>nil then frmTypeDropDown.Close;
end;

// Удалить дропдаунную форму
procedure TfrmTARConsole.FormActivate(Sender: TObject);
begin
	if frmTypeDropDown<>nil then frmTypeDropDown.Close;
end;

// Открывает папку с этим алиасом
procedure TfrmTARConsole.mnuOpenFolderClick(Sender: TObject);
var
	strCon: string;
	i: integer;
begin
	strCon:=Trim(txtConsole.Text);
	HideCon;
	if strCon<>'' then begin
		for i:=0 to ConfigStr.Count-1 do begin
			if (GetProgName(strCon)=GetName('alias', ConfigStr.Strings[i])) or (not Options.EasyType.CaseSensitivity and (AnsiLowerCase(GetProgName(strCon))=AnsiLowerCase(GetName('alias', ConfigStr.Strings[i])))) then begin
				{if GetName('dir', ConfigStr.Strings[i])<>'' then
					ExecFolder(GetName('dir', ConfigStr.Strings[i]))
				else} if GetProgPath(GetName('action', ConfigStr.Strings[i]))<>'' then
					ExecFolder(GetProgPath(GetName('action', ConfigStr.Strings[i])));
			end;
		end;
		for i:=0 to Options.SystemAliases.Name.Count-1 do begin
			if (GetProgName(strCon)=Options.SystemAliases.Name.Strings[i]) or (not Options.EasyType.CaseSensitivity and (AnsiLowerCase(GetProgName(strCon))=AnsiLowerCase(Options.SystemAliases.Name.Strings[i]))) then begin
				{if GetSysName('path', i)<>'' then
					ExecFolder(GetSysName('path', i))
				else }if GetProgPath(Options.SystemAliases.Action.Strings[i])<>'' then
					ExecFolder(GetProgPath(Options.SystemAliases.Action.Strings[i]));
			end;
		end;
	end;
end;

// Закрытие формы
procedure TfrmTARConsole.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  FormDestroy(Sender);
end;

// Уничтожение формы
procedure TfrmTARConsole.FormDestroy(Sender: TObject);
begin
	if CanUnload then begin
		CanUnload:=false;
		ViewHint('');
		if frmTypeDropDown<>nil then begin
			frmTypeDropDown.Free;
			frmTypeDropDown:=nil;
		end;
		if frmHint<>nil then begin
			frmHint.Free;
			frmHint:=nil;
		end;
		if frmAbout<>nil then begin
			frmAbout.Free;
			frmAbout:=nil;
		end;
		if frmSettings<>nil then begin
			frmSettings.Free;
			frmSettings:=nil;
		end;

		UnBindHotKey(HotKeyId, frmTARConsole.Handle);
		trayIcon.Enabled:=False;

		// Сохраняет при выходе все настройки
		Options.SaveSettings;
		Options.Free;
		SaveConfig(Program_Config);
		SaveHistory(Program_History);
		SavePlugins(Program_Plugin);

		UnloadPlugins;

		tmpAliasStr.Free;
		ConfigStr.Free;
		HistoryStr.Free;
	end;
end;

// Показ главного меню программы
procedure TfrmTARConsole.mnuMainPopup(Sender: TObject);
begin
	if MainMenuEvent=0 then begin
		mnuShowConsole.Visible:=False;
		mnuHideConsole.Visible:=True;
		mnuBorder2.Visible:=True;
		mnuCut.Visible:=True;
		mnuCopy.Visible:=True;
		mnuPaste.Visible:=True;
    mnuBorder3.Visible:=True;
    mnuClear.Visible:=True;
    mnuSelectAll.Visible:=True;
    mnuUndo.Visible:=Options.Undo.UseUndo;
    mnuBorder4.Visible:=True;
    mnuNewAlias.Visible:=True;
		mnuDelString.Visible:=True;
    mnuOpenFolder.Visible:=True;
    mnuBorder5.Visible:=True;
    mnuToggleET.Visible:=True;
  end;
	if MainMenuEvent=1 then begin
    mnuShowConsole.Visible:=True;
    mnuHideConsole.Visible:=False;
    mnuBorder2.Visible:=False;
    mnuCut.Visible:=False;
    mnuCopy.Visible:=False;
    mnuPaste.Visible:=False;
    mnuBorder3.Visible:=False;
    mnuClear.Visible:=False;
    mnuSelectAll.Visible:=False;
    mnuUndo.Visible:=False;
    mnuBorder4.Visible:=False;
    mnuNewAlias.Visible:=False;
    mnuDelString.Visible:=False;
    mnuOpenFolder.Visible:=False;
    mnuBorder5.Visible:=False;
    mnuToggleET.Visible:=False;
  end;
  MainMenuEvent:=0;
end;

end.
