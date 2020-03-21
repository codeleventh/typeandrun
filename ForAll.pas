unit ForAll;

interface

uses Windows, ShellApi, SysUtils, Graphics, Forms, Dialogs, Classes, ComCtrls, StdCtrls, ExtCtrls, CoolTrayIcon,
		 Plugins, Messages, Controls;

procedure ShowCon; // Показывает консоль на экране
procedure HideCon; // Скрывает консоль с экрана
procedure ExecInternal(Num: integer; ProgParam: string); // Запускает указанное действие внутренней команды
function InsertS(var MainStr: string; SubStr: string): boolean; // Делает замену %s на нужную строку и возвращает, была ли хоть одна замена
function InsertEnv(MainStr: string): string; // Заменяет в строке все системные переменные на их значения
procedure ExecAlias(Num: integer; Str: string); // Запускает указанный алиас
procedure ExecSysAlias(Num: integer; Str: string); // Запускает указанный системный алиас
procedure ExecWWW(Str: string); // Запускает указанный урл
procedure ExecEMail(Str: string); // Запускает указанный адрес почты
procedure ExecFolder(Str: string); // Запускает указанную папку
procedure ExecFile(Str, Param, Folder: string); // Запускает указанный файл
function ExecPlugin(Num: integer; Str: string): TExec; // Запускает плагин
procedure ExecDOS(Str: string); // Запускает указанный путь через shell
procedure AddUndo(Str: string; SelStart, SelLength: integer); // Добавляет строку истории отмен.
procedure FillSettings; // Расставляет галки в настройках
procedure KeepSettings; // Применяет расставленные галки в настройках
procedure ShowFrame(Num: integer); // Показывает нужный фрейм в настройках
procedure ShowEdit(Show: boolean); // // Показывает или скрывает поля для редактирования алиаса
procedure SyncSpn(Num: integer); // Синхронизирует перемещатель алиасов вверх и вниз
procedure SyncPluginSpn(Num: integer); // Синхронизирует перемещатель плагинов вверх и вниз
function SeekForMainWindow(Wnd: HWnd; LParam: PInteger): bool; stdcall; // Ищет окна с данным классом
procedure ActivatePrevInst; // Активизирует действие добавления алиаса через проводник
procedure GetET(List: Pointer; strCon: string; SelStart, SelLength: integer); // Забивает лист списком дополнения
function ET_Console(strCon: string; SelStart, SelLength: integer): boolean; // Парсит строку на автодополнение
procedure Make_ET(strCon: string; SelStart, SelLength: integer); // Вставляет автодополнение в консоль
function SetBrowse: boolean; // Добавляет слеш при браузере путей
procedure AddToProgram(Str: string); // Добавляет программу, переданную через командную строку
procedure CheckDeadAliases; // Проверяет мертвые алиасы
procedure ReturnDeadAliases; // Возвращает удаленные мертвые алиасы
procedure SyncUpDown(TextBox: TEdit; SpnBox: TUpDown); // Синхронизирует текстовое поле и прокрутку
procedure GetFileList(Dir: string; List: Pointer); // Возвращает список файлов в нужной папке.
procedure ShowTip(Title: string; Text: string; IconType: TBalloonHintIcon; Timeout: integer); // Показывает балун типс в трее
procedure CoolBackSpace; // Делает смартовый бэкспейс
procedure ParseCmdLine(What: integer); // Обработка переданных TypeAndRun параметров
procedure SendText(WinHandle: HWND; txtText: string); // Посылает текст окну
procedure CreateSettingsForm; // Создает форму настроек и применяет параметры к ней
procedure CreateAboutForm; // Создает форму о программе и применяет параметры к ней
procedure ViewHint(HintText: string); // Отображает подсказку
procedure DropDown(strCon: string; SelStart, SelLength: integer); // Отображает выдадающий список допустимых алиасов
procedure CtrlBackSpace; // Делает мегасмартовый бэкспейс
procedure ShowMes(text: string); // Показывает мессагу
procedure setTrayIcon; // Устанавливает правильную иконку в трее
function BadApp(): bool; // Проверяет, активно ли окно, несовместимое с TaR

var
	Undo: array of string; // Список отмен - строки
	UndoCur: array of integer; // Список отмен - позиция курсора
	UndoCurLength: array of integer; // Список отмен - длина выделения
	UndoMax: integer; // Список отмен - число их
	WM_SendFileNameToOpen: Integer; // Сообщение окну о том, что через проводник запустили прогу с параметром
	PB_Flag: boolean; // Флаг для браузера путей - найдено ли дополнение
	ShortText: string; // Короткая строка (для линуксового дополнения)
	ET_Num: integer; // Номер последнего добавления
	SearchDA: boolean; // Флаг что сейчас типа идет серч
	tmrHide: TTimer; // Скрытие балун типса
  IsParseCL: boolean;
	IsParseMessage: boolean;
	tmpAliasStr: TStringList;
  badApps: TStringList;

implementation

uses Static, Configs, frmConsoleUnit, frmSettingsUnit, frmAboutUnit, frmTypeDownDropUnit, StrUtils, Settings, frmHintUnit;

// Показывает консоль на экране
procedure ShowCon;
begin
	if(BadApp()) then
  	exit;

	frmTARConsole.txtConsole.Clear;
	if Options.Show.ConsoleWidthPercent then
		frmTARConsole.Width:=round(Options.Show.ConsoleWidth/100*Screen.Width)
	else
		frmTARConsole.Width:=Options.Show.ConsoleWidth;
	frmTARConsole.Height:=Options.Show.ConsoleHeight;
	if Options.Show.CenterScreenX then
		frmTARConsole.Left:=Screen.Width div 2-frmTARConsole.Width div 2
	else
		frmTARConsole.Left:=Options.Show.ConsoleX;
	if Options.Show.CenterScreenY then
		frmTARConsole.Top:=Screen.Height div 2-frmTARConsole.Height div 2
	else
		frmTARConsole.Top:=Options.Show.ConsoleY;
	frmTARConsole.txtConsole.Top:=0;
	frmTARConsole.txtConsole.Left:=0;
	frmTARConsole.txtConsole.Width:=frmTARConsole.Width-2*Options.Show.BorderSize;
	frmTARConsole.txtConsole.Height:=frmTARConsole.Height-2*Options.Show.BorderSize;

	frmTARConsole.Show;
	AttachThreadInput(GetWindowThreadProcessId(GetForegroundWindow, nil), GetWindowThreadProcessId(frmTARConsole.Handle, nil), True);
	SetForegroundWindow(frmTARConsole.Handle);
	frmTARConsole.BringToFront;

  if Options.Show.PutMouseIntoConsole then SetCursorPos(frmTARConsole.Left+frmTARConsole.Width div 2, frmTARConsole.Top+frmTARConsole.Height div 2);

	if Options.Config.RereadHotKey then begin
		ReadConfig(Program_Config);
    Options.SystemAliases.ReadSystemAliases;
	end;
	if Options.Font.ApplyEnglish then SetKeyboardLayout('00000409');
	if Options.EasyType.EnableET and (Options.EasyType.EasyType=0) then begin
		Options.EasyType.EasyType:=1;
    frmTARConsole.BorderWidth:=0;
		frmTARConsole.color:=Options.Color[1].Border;
		frmTARConsole.mnuToggleET.Checked:=True;
		frmTARConsole.BorderWidth:=Options.Show.BorderSize;
	end;

	HisViewPos:=HistoryStr.Count;

	IsShift:=False;
end;

// Скрывает консоль с экрана
procedure HideCon;
begin
	if Options.Show.HideConsole then begin
		frmTARConsole.Hide;
    frmTARConsole.txtConsole.Clear;
  end
	else
		frmTARConsole.txtConsole.Clear;
	ViewHint('');
end;

// Запускает указанное действие внутренней команды
// Num - номер запущенной команды
// ProgParam - переданные параметры
procedure ExecInternal(Num: integer; ProgParam: string);
var
	numInt, i: integer;
	tmpEnv: string;
begin
	numInt:=1;

	// about
	if numInt=Num then begin
    CreateAboutForm;
		frmAbout.Show;
	end;
	Inc(numInt);

	// checkconfig
	if numInt=Num then begin
		ReturnDeadAliases;
    CheckDeadAliases;		
	end;
	Inc(numInt);

	// config
	if numInt=Num then begin
		IsEditor:=True;
    CreateSettingsForm;
    frmSettings.Show;
	end;
	Inc(numInt);

	// exit
	if numInt=Num then begin
    frmTARConsole.Hide;
		frmTARConsole.Close;
	end;
	Inc(numInt);

	// help
	if numInt=Num then begin
		HideCon;
		if FileExists(GetMyPath+'Lang\'+Options.Language.Language+'.chm') then
			RunShell(GetMyPath+'Lang\'+Options.Language.Language+'.chm')
		else
			RunShell(GetMyPath+'Lang\English.chm');
	end;
	Inc(numInt);

	// hide
	if numInt=Num then begin
		frmTARConsole.Hide;
	end;
	Inc(numInt);

	// homedir
	if numInt=Num then begin
    ExecFolder(GetMyPath);
	end;
	Inc(numInt);

	// inidir
	if numInt=Num then begin
		ExecFolder(ExtractFilePath(Program_Config));
	end;
	Inc(numInt);

	// inifiles
	if numInt=Num then begin
		tmpEnv:=
			'Settings: [' + Options.FileName + ']' + #13 +
			'Config: ['+ Program_Config + ']' + #13 +
			'ConfigOld: [' + Program_Config_Old + ']' + #13 +
			'History: [' + Program_History + ']' + #13 +
			'Plugins: [' + Program_Plugin + ']'
		;
		frmTARConsole.Hide;
		ShowMessage(tmpEnv);
	end;
	Inc(numInt);

	// load
	if numInt=Num then begin
    if High(PluginDll)>-1 then begin
      for i:=0 to High(PluginDll) do begin
        if (PluginDll[i].Name=ProgParam) and not PluginDll[i].Loaded then
					PluginDll[i].Load;
      end;
    end
	end;
	Inc(numInt);

	// reread
	if numInt=Num then begin
		Options.ReadSettings;
    ApplySettings;
		ReadConfig(Program_Config);
		ReadHistory(Program_History);
		Options.SystemAliases.ReadSystemAliases;
	end;
	Inc(numInt);

	// settings
	if numInt=Num then begin
    CreateSettingsForm;
		frmSettings.Show;
	end;
	Inc(numInt);

  // show
	if numInt=Num then begin
  	ShowCon;  
	end;
	Inc(numInt);

	// unload
	if numInt=Num then begin
    if High(PluginDll)>-1 then begin
      for i:=0 to High(PluginDll) do begin
        if (PluginDll[i].Name=ProgParam) and PluginDll[i].Loaded then
					PluginDll[i].Unload;
      end;
    end
	end;
	Inc(numInt);

  // test
	if numInt=Num then begin

	end;

	PlayFile(Options.Sounds.ExecuteInternalSound);
end;

// Делает замену %s и %1,%2,%n на нужную строку и возвращает, была ли хоть одна замена
// MainStr - переменная, в которой нужно заменять
// SubStr - строка с переданным параметром
function InsertS(var MainStr: string; SubStr: string): boolean;
var
	i: integer;
  Flag: boolean;
begin
  Flag:=False;

	while Pos('%s', MainStr)<>0 do begin
  	Flag:=True;
		Insert(SubStr, MainStr, Pos('%s', MainStr));
		Delete(MainStr, Pos('%s', MainStr), 2);
	end;
	i:=1;
	while Pos('%'+IntToStr(i), MainStr)<>0 do begin
		Flag:=True;
		while Pos('%'+IntToStr(i), MainStr)<>0 do begin
			Insert(GetNumWord(SubStr, ' ', i), MainStr, Pos('%'+IntToStr(i), MainStr));
			Delete(MainStr, Pos('%'+IntToStr(i), MainStr), 2);
		end;
		Inc(i);
	end;
  Result:=Flag;
end;

// Заменяет в строке все системные переменные на их значения
// MainStr - переменная, в которой все нужно заменять
function InsertEnv(MainStr: string): string;
var
	p: pChar;
  tmp: TStringList;
  tmpNum: integer;
  tmpStr: string;
  i: integer;
begin
	tmp:=TStringList.Create;
  p:=GetEnvironmentStrings;
  while p^<>#0 do begin
  	tmp.Add(StrPas(p));
    inc(p, lStrLen(p)+1);
	end;
  for i:=0 to tmp.Count-1 do begin
  	tmpStr:=GetNumWord(tmp.Strings[i], '=', 1);
    while Pos(AnsiLowerCase('%'+tmpStr+'%'), AnsiLowerCase(MainStr))<>0 do begin
	    tmpNum:=Pos(AnsiLowerCase('%'+tmpStr+'%'), AnsiLowerCase(MainStr));
      Delete(MainStr, tmpNum, Length('%'+tmpStr+'%'));
      Insert(GetDOSEnvVar(tmpStr), MainStr, tmpNum);
    end;
    while Pos(AnsiLowerCase('%TARDIR%'), AnsiLowerCase(MainStr))<>0 do begin
	    tmpNum:=Pos(AnsiLowerCase('%TARDIR%'), AnsiLowerCase(MainStr));
      Delete(MainStr, tmpNum, Length('%TARDIR%'));
      Insert(Copy(GetMyPath(), 1, Length(GetMyPath())-1), MainStr, tmpNum);
    end;
  end;
  tmp.Free;
  Result:=MainStr;
end;

// Запускает указанный алиас, Num - его номер в списке
// Num - номер запущенного алиаса
// Str - переданные алиасу параметры
procedure ExecAlias(Num: integer; Str: string);
var
	Action: string;
	Param: string;
	Dir: string;
	State: integer;
	Priori: integer;
	ProcessInfo: TProcessInformation;
	StartUpInfo: TStartupInfo;
	FlagReplace: boolean;
  i, j: integer;
  IsPlug: boolean;
begin
	FlagReplace:=False;

  // Делает замену %s, %1,%2,%n и переменных окружения в действии алиаса
  Action:=GetName('action', ConfigStr.Strings[Num]);
  if InsertS(Action, Str) then FlagReplace:=True;
  Action:=InsertEnv(Action);

  // Делает замену %s, %1,%2,%n и переменных окружения в параметре алиаса
	Param:=GetName('param', ConfigStr.Strings[Num]);
  if InsertS(Param, Str) then FlagReplace:=True;
  Param:=InsertEnv(Param);

  // Если в конфиге не указана текущая папка, то берется та, где лежит запускаемый файл
	if GetName('dir', ConfigStr.Strings[Num])='' then
		Dir:=GetProgPath(GetName('action', ConfigStr.Strings[Num]))
	else
		Dir:=GetName('dir', ConfigStr.Strings[Num]);
  // Делает замену %s, %1,%2,%n и переменных окружения в текущей папке алиаса
	if InsertS(Dir, Str) then FlagReplace:=True;
  Dir:=InsertEnv(Dir);
	if Not DirectoryExists(Dir) then Dir:='';

  Action:=InsertEnv(Action);

  Str:=InsertEnv(Str);
	if not FlagReplace then
		Param:=Param+Str;
	Param:=AnsiReplaceStr(Param, '¦', '|');

	// Если состояние не указано, то ставится нормальное
	if GetName('state', ConfigStr.Strings[Num])='' then
		State:=1
	else
		// Адаптация к Дельфе ;)
		if GetName('state', ConfigStr.Strings[Num])='5' then
			State:=7
		else
			State:=StrToInt(GetName('state', ConfigStr.Strings[Num]));

	// Установка приоритета
	if GetName('priori', ConfigStr.Strings[Num])='-1' then
		Priori:=IDLE_PRIORITY_CLASS
	else if GetName('priori', ConfigStr.Strings[Num])='1' then
		Priori:=HIGH_PRIORITY_CLASS
	else if GetName('priori', ConfigStr.Strings[Num])='2' then
		Priori:=REALTIME_PRIORITY_CLASS
	else
		Priori:=NORMAL_PRIORITY_CLASS;

	// Если это плагин
  IsPlug:=False;
  for i:=0 to High(PluginDll) do begin
  	if PluginDll[i].Loaded then begin
    	for j:=0 to PluginDll[i].GetCount-1 do begin
      	if Trim(Action)=PluginDll[i].GetString(j) then begin
	        IsPlug:=True;
	        ParsePlugin(Trim(Action + ' ' + Param), True)
        end;
      end;
    end;
  end;

	if not IsPlug then begin
		if DirectoryExists(Action) then begin
			ExecFolder(Action);
		end
		else begin
			SetCurrentDir(Dir);
			if ExtractFileExt(Action)='.exe' then begin
				FillChar(StartUpInfo, SizeOf(StartUpInfo), $00);
				StartUpInfo.dwFlags:=STARTF_USESHOWWINDOW;
				StartUpInfo.wShowWindow:=State;
				if CreateProcess(nil, Pchar(Action + ' ' + Param), nil, nil, False, Priori, nil, PChar(Dir), StartUpInfo, ProcessInfo) then begin
					CloseHandle(ProcessInfo.hThread);
					CloseHandle(ProcessInfo.hProcess);
				end
				else
					RunShell(Action, Param, Dir, State, '');
			end
			else
      	RunShell(Action, Param, Dir, State, '');
			SetCurrentDir(GetMyPath);
			PlayFile(Options.Sounds.ExecuteAliasSound);
		end;
	end;
end;

// Запускает указанный системный алиас, Num - его номер в списке
// Num - номер запущенного алиаса
// Str - переданные алиасу параметры
procedure ExecSysAlias(Num: integer; Str: string);
var
	Action: string;
	Param: string;
	Dir: string;
begin
	Action:=Options.SystemAliases.Action.Strings[Num];
	Param:=Str;
	// Если в системном алиасе не указана текущая папка, то берется та, где лежит запускаемый файл
	if Options.SystemAliases.Path.Strings[Num]='' then
		Dir:=GetProgPath(Options.SystemAliases.Action.Strings[Num])
	else
		Dir:=Options.SystemAliases.Path.Strings[Num];
	if Not DirectoryExists(Dir) then Dir:='';
	SetCurrentDir(Dir);
  RunShell(Action, Param, Dir);
	SetCurrentDir(GetMyPath);
	PlayFile(Options.Sounds.ExecuteSysAliasSound);
end;

// Запускает указанный урл
// Если путь к браузеру не указан в конфиге, то используется указанный в системе
// Str - урл на запуск
procedure ExecWWW(Str: string);
var
	tmpProg, tmpParam: string;
begin
	if AnsiLowerCase(Copy(Str, 1, 4))=AnsiLowerCase('www.') then begin
		Delete(Str, 1, 4);
		Str:='www.'+Str;
	end;
	if AnsiLowerCase(Copy(Str, 1, 7))=AnsiLowerCase('http://') then begin
		Delete(Str, 1, 7);
		Str:='http://' + Str;
	end;
	if (Options.Path.Browser='') or IsShift then
		RunShell(Str)
	else begin
		tmpProg:=GetProgName(Options.Path.Browser);
		tmpParam:=GetProgParam(Options.Path.Browser);
		if tmpParam='' then
			RunShell(Options.Path.Browser, Str)
		else
			RunShell(tmpProg, tmpParam + ' ' + Str);
	end;
	PlayFile(Options.Sounds.ExecuteURLSound);
end;

// Запускает указанный адрес почты
// Почтовый клиент используется системный
// Str - адрес почты на запуск
procedure ExecEMail(Str: string);
begin
	RunShell('MAILTO:' + CorrectEMail(Str));
	PlayFile(Options.Sounds.ExecuteEmailSound);
end;

// Запускает указанную папку
// Используется файловый менеджер, указанный в конфиге
// Str - путь к папке на запуск
procedure ExecFolder(Str: string);
var
	tmpProg, tmpParam: string;
begin
	tmpParam:=GetProgParam(Options.Path.FM);
	tmpProg:=getProgName(Options.Path.FM);
	if tmpParam='' then
		tmpParam:='"'+Str+'"'
	else
		tmpParam:=tmpParam + ' "' + Str + '"';
	RunShell(tmpProg, tmpParam);
	PlayFile(Options.Sounds.ExecuteFolderSound);
end;

// Запускает указанный файл
// Str - путь к файлу
// Param - параметры
// Folder - текущая папка
procedure ExecFile(Str, Param, Folder: string);
var
	tmpParam: string;
	FlagReplace: boolean;
begin
	if IsShift then begin
		FlagReplace:=False;
		tmpParam:=Options.Path.ShellNoClose;
		// Делает замену %s, %1,%2,%n и переменных окружения в параметре алиаса
		if InsertS(tmpParam, Str+' '+Param) then FlagReplace:=True;
		tmpParam:=InsertEnv(tmpParam);

		Param:=InsertEnv(Str+' '+Param);
		if not FlagReplace then
			tmpParam:=Options.Path.ShellNoClose + ' ' + Param;
		tmpParam:=AnsiReplaceStr(tmpParam, '¦', '|');
		RunShell(Options.Path.Shell, tmpParam, Folder);
	end
	else
		if RunShell(Str, Param, Folder, SW_ShowNormal, '')=SE_ERR_NOASSOC then
			RunShell('rundll32', 'shell32,OpenAs_RunDLL ' + Str + ' ' + Param, Folder);
	PlayFile(Options.Sounds.ExecuteFileSound);
end;

// Запускает плагин
// Num - номер плагина
// Str - запускаемая строка
function ExecPlugin(Num: integer; Str: string): TExec;
var
	tmpResult: TExec;
begin
	tmpResult:=PluginDll[Num].RunString(Str);
	if tmpResult.run<>0 then
	  PlayFile(Options.Sounds.ExecutePluginSound);
	Result:=tmpResult;
end;

// Запускает указанный путь через shell
// Используется shell указанный в конфиге
// Str - строка на запуск через shell
procedure ExecDOS(Str: string);
var
	tmpParam: string;
	FlagReplace: boolean;
begin
	FlagReplace:=False;

	if IsShift then
		tmpParam:=Options.Path.ShellNoClose
	else
		tmpParam:=Options.Path.ShellClose;

	// Делает замену %s, %1,%2,%n и переменных окружения в параметре алиаса
	if InsertS(tmpParam, Str) then FlagReplace:=True;
	tmpParam:=InsertEnv(tmpParam);

	Str:=InsertEnv(Str);
	if not FlagReplace then
		tmpParam:=tmpParam + ' ' + Str;
	tmpParam:=AnsiReplaceStr(tmpParam, '¦', '|');

	RunShell(Options.Path.Shell, tmpParam);
	PlayFile(Options.Sounds.ExecuteShellSound);
end;

// Добавляет строку истории отмен.
// Отмены ограничены только свободной памятью
// Str - сама строка для сохранения
// SelStart - начало выделения для сохранения
// SelLength - длина выделения для сохранения
procedure AddUndo(Str: string; SelStart, SelLength: integer);
begin
	Inc(UndoMax);
	SetLength(Undo, UndoMax);
	SetLength(UndoCur, UndoMax);
	SetLength(UndoCurLength, UndoMax);
	Undo[UndoMax-1]:=Str;
	UndoCur[UndoMax-1]:=SelStart;
	UndoCurLength[UndoMax-1]:=SelLength;
	Unded:=True;
end;

// Расставляет галки в настройках
procedure FillSettings;
var
	i: integer;
	fi: TSearchRec;
begin
	if frmSettings=nil then exit;
  
	frmSettings.chkShowConsoleOnStart.Checked:=Options.Show.ShowConsoleOnStart;
	frmSettings.chkHideConsole.Checked:=Options.Show.HideConsole;
	frmSettings.chkTriggerShow.Checked:=Options.Show.TriggerShow;
	frmSettings.chkTrayIcon.Checked:=Options.Show.TrayIcon;
	frmSettings.chkShowBalloonTips.Checked:=Options.Show.BalloonTips;
	frmSettings.chkPutMouseIntoConsole.Checked:=Options.Show.PutMouseIntoConsole;
	frmSettings.spnAutoHide.Position:=Options.Show.AutoHideValue;
	frmSettings.chkAutoHide.Checked:=Options.Show.AutoHide;
	frmSettings.txtAutoHide.Enabled:=Options.Show.AutoHide;
	frmSettings.spnAutoHide.Enabled:=Options.Show.AutoHide;
	frmSettings.txtAutoHide.Text:=IntToStr(Options.Show.AutoHideValue);
	frmSettings.boxPriority.ItemIndex:=Options.Show.Priority+1;

	frmSettings.chkShowCenterX.Checked:=Options.Show.CenterScreenX;
	frmSettings.chkShowCenterY.Checked:=Options.Show.CenterScreenY;
	frmSettings.spnConsoleX.Max:=Screen.Width;
	frmSettings.spnConsoleY.Max:=Screen.Height;
	frmSettings.spnConsoleX.Position:=Options.Show.ConsoleX;
	frmSettings.spnConsoleY.Position:=Options.Show.ConsoleY;
	frmSettings.txtConsoleX.Text:=IntToStr(Options.Show.ConsoleX);
	frmSettings.txtConsoleY.Text:=IntToStr(Options.Show.ConsoleY);
	frmSettings.spnConsoleWidth.Max:=Screen.Width;
	frmSettings.spnConsoleHeight.Max:=Screen.Height;
	frmSettings.spnConsoleWidth.Position:=Options.Show.ConsoleWidth;
	frmSettings.chkConsoleWidthPercent.Checked:=Options.Show.ConsoleWidthPercent;
	frmSettings.spnConsoleHeight.Position:=Options.Show.ConsoleHeight;
	frmSettings.spnBorderSize.Max:=Screen.Width div 3;
	frmSettings.spnBorderSize.Position:=Options.Show.BorderSize;
	frmSettings.chkDestroyForm.Checked:=Options.Show.DestroyForm;
	frmSettings.spnTransValue.Position:=Options.Show.Transparent;

	frmSettings.chkShowHint.Checked:=Options.Hint.ShowHint;
	frmSettings.spnHintBorderSize.Max:=Screen.Width div 3;
	frmSettings.spnHintBorderSize.Position:=Options.Hint.BorderSize;
	frmSettings.chkHintShowBorderOnly.Checked:=Options.Hint.DestroyForm;
	frmSettings.spnHintTransparent.Position:=Options.Hint.Transparent;

	frmSettings.spnDropDownLineCount.Position:=Options.DownDrop.LineNum;
	frmSettings.spnDropdownBorderSize.Max:=Screen.Width div 3;
	frmSettings.spnDropdownBorderSize.Position:=Options.DownDrop.BorderSize;
	frmSettings.chkDropdownShowBorderOnly.Checked:=Options.DownDrop.DestroyForm;
	frmSettings.spnDropdownTransparent.Position:=Options.DownDrop.Transparent;

	for i:=0 to High(TempColor) do begin
		TempColor[i].Text:=Options.Color[i].Text;
		TempColor[i].Console:=Options.Color[i].Console;
		TempColor[i].Border:=Options.Color[i].Border;
		TempColor[i].HintText:=Options.Color[i].HintText;
		TempColor[i].HintColor:=Options.Color[i].HintColor;
		TempColor[i].HintBorder:=Options.Color[i].HintBorder;
		TempColor[i].DropDownText:=Options.Color[i].DropDownText;
		TempColor[i].DropDownColor:=Options.Color[i].DropDownColor;
		TempColor[i].DropDownBorder:=Options.Color[i].DropDownBorder;
	end;
	frmSettings.boxETColor.ItemIndex:=Options.EasyType.EasyType;
	frmSettings.shpTextColor.Brush.Color:=TempColor[Options.EasyType.EasyType].Text;
	frmSettings.shpConsoleColor.Brush.Color:=TempColor[Options.EasyType.EasyType].Console;
	frmSettings.shpBorderColor.Brush.Color:=TempColor[Options.EasyType.EasyType].Border;
	frmSettings.shpHintTextColor.Brush.Color:=TempColor[Options.EasyType.EasyType].HintText;
	frmSettings.shpHintColor.Brush.Color:=TempColor[Options.EasyType.EasyType].HintColor;
	frmSettings.shpHintBorderColor.Brush.Color:=TempColor[Options.EasyType.EasyType].HintBorder;
	frmSettings.shpDropdownTextColor.Brush.Color:=TempColor[Options.EasyType.EasyType].DropDownText;
	frmSettings.shpDropdownColor.Brush.Color:=TempColor[Options.EasyType.EasyType].DropDownColor;
	frmSettings.shpDropdownBorderColor.Brush.Color:=TempColor[Options.EasyType.EasyType].DropDownBorder;

	frmSettings.lblFont.Font.Name:=Options.Font.Name;
	frmSettings.lblFont.Font.Size:=Options.Font.Size;
	if Options.Font.Bold then frmSettings.lblFont.Font.Style:=frmSettings.lblFont.Font.Style+[fsBold];
	if Options.Font.Italic then frmSettings.lblFont.Font.Style:=frmSettings.lblFont.Font.Style+[fsItalic];
	if Options.Font.StrikeOut then frmSettings.lblFont.Font.Style:=frmSettings.lblFont.Font.Style+[fsStrikeOut];
	if Options.Font.UnderLine then frmSettings.lblFont.Font.Style:=frmSettings.lblFont.Font.Style+[fsUnderLine];
	frmSettings.lblFont.Caption:=Options.Font.Name+', '+IntToStr(Options.Font.Size);
	frmSettings.chkFontAutoSize.Checked:=Options.Font.AutoSize;
	if Options.Font.Align=1 then
		frmSettings.optAlignCenter.Checked:=True
	else if Options.Font.Align=2 then
		frmSettings.optAlignRight.Checked:=True
	else
		frmSettings.optAlignLeft.Checked:=True;

	frmSettings.chkAlt.Checked:=Options.Hotkey.AltKey;
	frmSettings.chkCtrl.Checked:=Options.Hotkey.CtrlKey;
	frmSettings.chkShift.Checked:=Options.Hotkey.ShiftKey;
	frmSettings.chkWin.Checked:=Options.Hotkey.WinKey;
	frmSettings.htkHotkey.HotKey:=Options.Hotkey.Key;
	frmSettings.chkApplyEnglish.Checked:=Options.Font.ApplyEnglish;
	frmSettings.chkLockEnglish.Checked:=Options.Font.LockEnglish;

	if Options.EasyType.EasyType=1 then
		frmSettings.optEasyType.Checked:=True
	else if Options.EasyType.EasyType=2 then
		frmSettings.optLinuxType.Checked:=True
	else
		frmSettings.optNoType.Checked:=True;
	frmSettings.chkETInternal.Checked:=Options.EasyType.Internal;
	frmSettings.chkETAlias.Checked:=Options.EasyType.Alias;
	frmSettings.chkETSysAlias.Checked:=Options.EasyType.SysAlias;
	frmSettings.chkETPath.Checked:=Options.EasyType.Path;
	frmSettings.chkETPlugins.Checked:=Options.EasyType.Plugins;
	frmSettings.chkETHistory.Checked:=Options.EasyType.History;
	frmSettings.chkCase.Checked:=Options.EasyType.CaseSensitivity;
	frmSettings.chkSpace.Checked:=Options.EasyType.Space;
	frmSettings.chkEnableET.Checked:=Options.EasyType.EnableET;
	frmSettings.chkAdvancedBackspace.Checked:=Options.EasyType.AdvancedBackspace;
	frmSettings.chkAdvancedSpace.Checked:=Options.EasyType.AdvancedSpace;
  frmSettings.chkDeleteDuplicate.Checked:=Options.EasyType.DeleteDuplicates;

	frmSettings.chkExecInternal.Checked:=Options.Exec.Internal;
	frmSettings.chkExecAlias.Checked:=Options.Exec.Alias;
	frmSettings.chkExecUseDefaultAction.Checked:=Options.Exec.DefaultAction;
	frmSettings.chkExecSysAlias.Checked:=Options.Exec.SysAlias;
	frmSettings.chkExecWWW.Checked:=Options.Exec.WWW;
	frmSettings.chkExecEMail.Checked:=Options.Exec.EMail;
	frmSettings.chkExecFolder.Checked:=Options.Exec.Folders;
	frmSettings.chkExecFile.Checked:=Options.Exec.Files;
	frmSettings.chkExecPlugins.Checked:=Options.Exec.Plugins;
	frmSettings.chkExecShell.Checked:=Options.Exec.Shell;

	frmSettings.optNoSaveHistory.Checked:=not Options.History.SaveHistory;
	frmSettings.optSaveHistory.Checked:=Options.History.SaveHistory;
	frmSettings.chkSaveInternal.Checked:=Options.History.SaveInternal;
	frmSettings.chkSaveInternalParam.Checked:=Options.History.SaveParamInternal;
	frmSettings.chkSaveAlias.Checked:=Options.History.SaveAlias;
	frmSettings.chkSaveAliasParam.Checked:=Options.History.SaveParamAlias;
	frmSettings.chkSaveSysAlias.Checked:=Options.History.SaveSysAlias;
	frmSettings.chkSaveSysAliasParam.Checked:=Options.History.SaveSysParamAlias;
	frmSettings.chkSaveWWW.Checked:=Options.History.SaveWWW;
	frmSettings.chkSaveEMail.Checked:=Options.History.SaveEMail;
	frmSettings.chkSaveFolder.Checked:=Options.History.SavePath;
	frmSettings.chkSavePlugins.Checked:=Options.History.SavePlugins;
  frmSettings.chkSavePluginParam.Checked:=Options.History.SaveParamPlugins;
	frmSettings.chkSaveShell.Checked:=Options.History.SaveUnknown;
  frmSettings.chkSaveCommandLine.Checked:=Options.History.SaveCommandLine;
	frmSettings.chkSaveMessage.Checked:=Options.History.SaveMessage;
  frmSettings.chkInvertScroll.Checked:=Options.History.InvertScroll;
	frmSettings.spnMaxHistory.Position:=Options.History.MaxHistory;
	frmSettings.btnClearHistory.Caption:=GetLangStr('clearhistory')+' '+IntToStr(HistoryStr.Count)+' '+GetLangStr('clearhistory2');
	frmSettings.btnClearHistory.Enabled:=(HistoryStr.Count>0);

	frmSettings.txtBrowser.Text:=Options.Path.Browser;
	frmSettings.txtFileManager.Text:=Options.Path.FM;
	frmSettings.txtShell.Text:=Options.Path.Shell;
	frmSettings.txtCmdParamClose.Text:=Options.Path.ShellClose;
	frmSettings.txtCmdParamNoclose.Text:=Options.Path.ShellNoClose;


	if Options.Registry.AutoRun=0 then
		frmSettings.optNoAutorun.Checked:=True
	else if Options.Registry.AutoRun=1 then
		frmSettings.optAutostartLM.Checked:=True
	else
		frmSettings.optAutostartCU.Checked:=True;
	if Options.Registry.AutoRunMayChange=0 then begin
		frmSettings.optNoAutorun.Enabled:=False;
		frmSettings.optAutostartLM.Enabled:=False;
		frmSettings.optAutostartCU.Enabled:=False;
	end
	else if Options.Registry.AutoRunMayChange=1 then begin
		frmSettings.optNoAutorun.Enabled:=True;
		frmSettings.optAutostartLM.Enabled:=True;
		frmSettings.optAutostartCU.Enabled:=True;
	end
	else if Options.Registry.AutoRunMayChange=2 then begin
		if Options.Registry.AutoRun<>1 then begin
			frmSettings.optNoAutorun.Enabled:=True;
			frmSettings.optAutostartLM.Enabled:=False;
			frmSettings.optAutostartCU.Enabled:=True;
		end
		else begin
			frmSettings.optNoAutorun.Enabled:=False;
			frmSettings.optAutostartLM.Enabled:=False;
			frmSettings.optAutostartCU.Enabled:=False;
		end;
	end;

	frmSettings.chkAddTo.Checked:=Options.Registry.ShellInt;
	frmSettings.chkAddTo.Enabled:=Options.Registry.ShellIntMayChange;
	frmSettings.chkMultiUsers.Checked:=Options.Registry.MultiUser;
	frmSettings.chkMultiUsers.Enabled:=Options.Registry.MultiUserMayChange;
	frmSettings.lblMultiUsers.Enabled:=Options.Registry.MultiUserMayChange;

	frmSettings.chkMoveTop.Checked:=Options.Config.MoveTop;
	frmSettings.chkAutoSort.Checked:=Options.Config.AutoSort;
	frmSettings.spnAutoReread.Position:=Options.Config.AutoRereadValue;
	frmSettings.chkAutoReread.Checked:=Options.Config.AutoReread;
	frmSettings.txtAutoReread.Enabled:=Options.Config.AutoReread;
	frmSettings.spnAutoReread.Enabled:=Options.Config.AutoReread;
	frmSettings.chkRereadHotKey.Checked:=Options.Config.RereadHotKey;
	frmSettings.chkCreateOldFile.Checked:=Options.Config.CDA_CreateOldFile;
	frmSettings.chkConfirm.Checked:=Options.Config.CDA_Confirmation;
	frmSettings.chkSearchFileCDA.Checked:=Options.Config.CDA_SearchFile;
	frmSettings.chkSearchPluginsCDA.Checked:=Options.Config.CDA_SearchPlugins;
	frmSettings.chkStartCDA.Checked:=Options.Config.CDA_Startup;
	frmSettings.btnBackAllDA.Enabled:=FileExists(Program_Config_Old);

	frmSettings.boxLanguage.Clear;
	if FindFirst(GetMyPath+'Lang\*.lng', faAnyFile, fi)=0 then begin
		repeat
			if(fi.Name[1]='.') then continue;
			frmSettings.boxLanguage.Items.Add(Copy(fi.Name, 0, Length(fi.Name)-4));
			if Copy(fi.Name, 0, Length(fi.Name)-4)=Options.Language.Language then
				frmSettings.boxLanguage.ItemIndex:=frmSettings.boxLanguage.Items.Count-1;
		until (FindNext(fi)<>0);
	end;
	FindClose(fi);
	frmSettings.txtAuthor.Text:=GetLangStr('author');
	frmSettings.txtVersion.Text:=GetLangStr('version');

	frmSettings.chkUseUndo.Checked:=Options.Undo.UseUndo;

	frmSettings.chkEnableSounds.Checked:=Options.Sounds.EnableSounds;
	Options.Sounds.ListSounds.Clear;
	Options.Sounds.ListSounds.Add(Options.Sounds.ExecuteInternalSound);
	Options.Sounds.ListSounds.Add(Options.Sounds.ExecuteAliasSound);
	Options.Sounds.ListSounds.Add(Options.Sounds.ExecuteSysAliasSound);
	Options.Sounds.ListSounds.Add(Options.Sounds.ExecuteURLSound);
	Options.Sounds.ListSounds.Add(Options.Sounds.ExecuteEmailSound);
	Options.Sounds.ListSounds.Add(Options.Sounds.ExecuteFolderSound);
	Options.Sounds.ListSounds.Add(Options.Sounds.ExecuteFileSound);
	Options.Sounds.ListSounds.Add(Options.Sounds.ExecutePluginSound);
	Options.Sounds.ListSounds.Add(Options.Sounds.ExecuteShellSound);
	frmSettings.lstSounds.ItemIndex:=0;
	frmSettings.txtSoundPath.Text:=Options.Sounds.ListSounds.Strings[frmSettings.lstSounds.ItemIndex];
	frmSettings.lstSounds.Enabled:=frmSettings.chkEnableSounds.Checked;
	frmSettings.txtSoundPath.Enabled:=frmSettings.chkEnableSounds.Checked;
	frmSettings.btnBrowseSound.Enabled:=frmSettings.chkEnableSounds.Checked;

	frmSettings.Left:=Options.Coordinates.SettingsX;
	frmSettings.Top:=Options.Coordinates.SettingsY;

	frmSettings.lstConfig.Clear;
	DragItem:=-1;
	if frmSettings.Visible and frmSettings.Enabled and frmSettings.lstSettings.Visible and frmSettings.lstSettings.Enabled then frmSettings.lstSettings.SetFocus;

	frmSettings.lstPluginList.Clear;
	if High(PluginDll)>-1 then begin
		for i:=0 to High(PluginDll) do
			frmSettings.lstPluginList.Items.Add(PluginDll[i].Name);
		frmSettings.lstPluginList.ItemIndex:=0;
		ApplyPluginShow(0);
	end
	else
		ShowPlugin(False);
	frmSettings.btnSelectPlugin.Enabled:=(PluginAliasCount>0);

	if not SearchDA then begin
		TempConfigStr.Clear;
		for i:=0 to ConfigStr.Count-1 do
			TempConfigStr.Add(ConfigStr.Strings[i]);
		for i:=0 to TempConfigStr.Count-1 do begin
			frmSettings.lstConfig.Items.Add(GetName('alias', ConfigStr.Strings[i]));
		end;
	end;
end;

// Применяет расставленные галки в настройках
procedure KeepSettings;
var
	i: integer;
begin
	if frmSettings=nil then exit;

	Options.Show.ShowConsoleOnStart:=frmSettings.chkShowConsoleOnStart.Checked;
	Options.Show.HideConsole:=frmSettings.chkHideConsole.Checked;
	Options.Show.TriggerShow:=frmSettings.chkTriggerShow.Checked;
	Options.Show.TrayIcon:=frmSettings.chkTrayIcon.Checked;
	Options.Show.BalloonTips:=frmSettings.chkShowBalloonTips.Checked;
	Options.Show.PutMouseIntoConsole:=frmSettings.chkPutMouseIntoConsole.Checked;
	Options.Show.AutoHideValue:=frmSettings.spnAutoHide.Position;
	Options.Show.AutoHide:=frmSettings.chkAutoHide.Checked;
	Options.Show.Priority:=frmSettings.boxPriority.ItemIndex-1;

	Options.Show.CenterScreenX:=frmSettings.chkShowCenterX.Checked;
	Options.Show.CenterScreenY:=frmSettings.chkShowCenterY.Checked;
	Options.Show.ConsoleX:=frmSettings.spnConsoleX.Position;
	Options.Show.ConsoleY:=frmSettings.spnConsoleY.Position;
	Options.Show.ConsoleWidth:=frmSettings.spnConsoleWidth.Position;
	Options.Show.ConsoleWidthPercent:=frmSettings.chkConsoleWidthPercent.Checked;
	Options.Show.ConsoleHeight:=frmSettings.spnConsoleHeight.Position;
	Options.Show.BorderSize:=frmSettings.spnBorderSize.Position;
	Options.Show.DestroyForm:=frmSettings.chkDestroyForm.Checked;
	Options.Show.Transparent:=frmSettings.spnTransValue.Position;

	Options.Hint.ShowHint:=frmSettings.chkShowHint.Checked;
	Options.Hint.BorderSize:=frmSettings.spnHintBorderSize.Position;
	Options.Hint.DestroyForm:=frmSettings.chkHintShowBorderOnly.Checked;
	Options.Hint.Transparent:=frmSettings.spnHintTransparent.Position;

	Options.DownDrop.LineNum:=frmSettings.spnDropDownLineCount.Position;
	Options.DownDrop.BorderSize:=frmSettings.spnDropdownBorderSize.Position;
	Options.DownDrop.DestroyForm:=frmSettings.chkDropdownShowBorderOnly.Checked;
	Options.DownDrop.Transparent:=frmSettings.spnDropdownTransparent.Position;

	for i:=0 to High(TempColor) do begin
		Options.Color[i].Text:=TempColor[i].Text;
		Options.Color[i].Console:=TempColor[i].Console;
		Options.Color[i].Border:=TempColor[i].Border;
		Options.Color[i].HintText:=TempColor[i].HintText;
		Options.Color[i].HintColor:=TempColor[i].HintColor;
		Options.Color[i].HintBorder:=TempColor[i].HintBorder;
		Options.Color[i].DropDownText:=TempColor[i].DropDownText;
		Options.Color[i].DropDownColor:=TempColor[i].DropDownColor;
		Options.Color[i].DropDownBorder:=TempColor[i].DropDownBorder;
	end;

	Options.Font.Name:=frmSettings.lblFont.Font.Name;
	Options.Font.Size:=frmSettings.lblFont.Font.Size;
	if frmSettings.lblFont.Font.Style-[fsBold]=frmSettings.lblFont.Font.Style then Options.Font.Bold:=False else Options.Font.Bold:=True;
	if frmSettings.lblFont.Font.Style-[fsItalic]=frmSettings.lblFont.Font.Style then Options.Font.Italic:=False else Options.Font.Italic:=True;
	if frmSettings.lblFont.Font.Style-[fsStrikeOut]=frmSettings.lblFont.Font.Style then Options.Font.StrikeOut:=False else Options.Font.StrikeOut:=True;
	if frmSettings.lblFont.Font.Style-[fsUnderLine]=frmSettings.lblFont.Font.Style then Options.Font.UnderLine:=False else Options.Font.UnderLine:=True;
  Options.Font.AutoSize:=frmSettings.chkFontAutoSize.Checked;
	if frmSettings.optAlignLeft.Checked then Options.Font.Align:=0
	else if frmSettings.optAlignCenter.Checked then
		Options.Font.Align:=1
	else
		Options.Font.Align:=2;

	Options.Hotkey.AltKey:=frmSettings.chkAlt.Checked;
	Options.Hotkey.CtrlKey:=frmSettings.chkCtrl.Checked;
	Options.Hotkey.ShiftKey:=frmSettings.chkShift.Checked;
	Options.Hotkey.WinKey:=frmSettings.chkWin.Checked;
	Options.Hotkey.Key:=frmSettings.htkHotkey.HotKey;
	Options.Font.ApplyEnglish:=frmSettings.chkApplyEnglish.Checked;
	Options.Font.LockEnglish:=frmSettings.chkLockEnglish.Checked;

	if frmSettings.optNoType.Checked then Options.EasyType.EasyType:=0;
	if frmSettings.optEasyType.Checked then Options.EasyType.EasyType:=1;
	if frmSettings.optLinuxType.Checked then Options.EasyType.EasyType:=2;
	Options.EasyType.Internal:=frmSettings.chkETInternal.Checked;
	Options.EasyType.Alias:=frmSettings.chkETAlias.Checked;
	Options.EasyType.SysAlias:=frmSettings.chkETSysAlias.Checked;
	Options.EasyType.Path:=frmSettings.chkETPath.Checked;
	Options.EasyType.Plugins:=frmSettings.chkETPlugins.Checked;
	Options.EasyType.History:=frmSettings.chkETHistory.Checked;
	Options.EasyType.CaseSensitivity:=frmSettings.chkCase.Checked;
	Options.EasyType.Space:=frmSettings.chkSpace.Checked;
	Options.EasyType.EnableET:=frmSettings.chkEnableET.Checked;
	Options.EasyType.AdvancedBackspace:=frmSettings.chkAdvancedBackspace.Checked;
	Options.EasyType.AdvancedSpace:=frmSettings.chkAdvancedSpace.Checked;
	Options.EasyType.DeleteDuplicates:=frmSettings.chkDeleteDuplicate.Checked;

	Options.Exec.Internal:=frmSettings.chkExecInternal.Checked;
	Options.Exec.Alias:=frmSettings.chkExecAlias.Checked;
	Options.Exec.DefaultAction:=frmSettings.chkExecUseDefaultAction.Checked;
	Options.Exec.SysAlias:=frmSettings.chkExecSysAlias.Checked;
	Options.Exec.WWW:=frmSettings.chkExecWWW.Checked;
	Options.Exec.EMail:=frmSettings.chkExecEMail.Checked;
	Options.Exec.Folders:=frmSettings.chkExecFolder.Checked;
	Options.Exec.Files:=frmSettings.chkExecFile.Checked;
	Options.Exec.Plugins:=frmSettings.chkExecPlugins.Checked;
	Options.Exec.Shell:=frmSettings.chkExecShell.Checked;

	Options.History.SaveHistory:=frmSettings.optSaveHistory.Checked;
	Options.History.SaveInternal:=frmSettings.chkSaveInternal.Checked;
	Options.History.SaveParamInternal:=frmSettings.chkSaveInternalParam.Checked;
	Options.History.SaveAlias:=frmSettings.chkSaveAlias.Checked;
	Options.History.SaveParamAlias:=frmSettings.chkSaveAliasParam.Checked;
	Options.History.SaveSysAlias:=frmSettings.chkSaveSysAlias.Checked;
	Options.History.SaveSysParamAlias:=frmSettings.chkSaveSysAliasParam.Checked;
	Options.History.SaveWWW:=frmSettings.chkSaveWWW.Checked;
	Options.History.SaveEMail:=frmSettings.chkSaveEMail.Checked;
	Options.History.SavePath:=frmSettings.chkSaveFolder.Checked;
	Options.History.SavePlugins:=frmSettings.chkSavePlugins.Checked;
	Options.History.SaveParamPlugins:=frmSettings.chkSavePluginParam.Checked;
	Options.History.SaveUnknown:=frmSettings.chkSaveShell.Checked;
  Options.History.SaveCommandLine:=frmSettings.chkSaveCommandLine.Checked;
	Options.History.SaveMessage:=frmSettings.chkSaveMessage.Checked;
	Options.History.InvertScroll:=frmSettings.chkInvertScroll.Checked;
	Options.History.MaxHistory:=frmSettings.spnMaxHistory.Position;

	Options.Path.Browser:=frmSettings.txtBrowser.Text;
	Options.Path.FM:=frmSettings.txtFileManager.Text;
	Options.Path.Shell:=frmSettings.txtShell.Text;
	Options.Path.ShellClose:=frmSettings.txtCmdParamClose.Text;
	Options.Path.ShellNoClose:=frmSettings.txtCmdParamNoclose.Text;

	if frmSettings.optNoAutorun.Checked then
		Options.Registry.AutoRun:=0
	else if frmSettings.optAutostartLM.Checked then
		Options.Registry.AutoRun:=1
	else
		Options.Registry.AutoRun:=2;
	Options.Registry.ShellInt:=frmSettings.chkAddTo.Checked;
	Options.Registry.MultiUser:=frmSettings.chkMultiUsers.Checked;

	Options.Config.MoveTop:=frmSettings.chkMoveTop.Checked;
	Options.Config.AutoSort:=frmSettings.chkAutoSort.Checked;
	Options.Config.AutoRereadValue:=frmSettings.spnAutoReread.Position;
	Options.Config.AutoReread:=frmSettings.chkAutoReread.Checked;
	Options.Config.RereadHotKey:=frmSettings.chkRereadHotKey.Checked;
	Options.Config.CDA_CreateOldFile:=frmSettings.chkCreateOldFile.Checked;
	Options.Config.CDA_Confirmation:=frmSettings.chkConfirm.Checked;
	Options.Config.CDA_SearchFile:=frmSettings.chkSearchFileCDA.Checked;
	Options.Config.CDA_SearchPlugins:=frmSettings.chkSearchPluginsCDA.Checked;  
	Options.Config.CDA_Startup:=frmSettings.chkStartCDA.Checked;

	if frmSettings.boxLanguage.Text<>'' then
		Options.Language.Language:=frmSettings.boxLanguage.Text;

	Options.Undo.UseUndo:=frmSettings.chkUseUndo.Checked;

	Options.Sounds.EnableSounds:=frmSettings.chkEnableSounds.Checked;
	Options.Sounds.ExecuteInternalSound:=Options.Sounds.ListSounds.Strings[0];
	Options.Sounds.ExecuteAliasSound:=Options.Sounds.ListSounds.Strings[1];
	Options.Sounds.ExecuteSysAliasSound:=Options.Sounds.ListSounds.Strings[2];
	Options.Sounds.ExecuteURLSound:=Options.Sounds.ListSounds.Strings[3];
	Options.Sounds.ExecuteEmailSound:=Options.Sounds.ListSounds.Strings[4];
	Options.Sounds.ExecuteFolderSound:=Options.Sounds.ListSounds.Strings[5];
	Options.Sounds.ExecuteFileSound:=Options.Sounds.ListSounds.Strings[6];
	Options.Sounds.ExecutePluginSound:=Options.Sounds.ListSounds.Strings[7];
	Options.Sounds.ExecuteShellSound:=Options.Sounds.ListSounds.Strings[8];

	Options.Coordinates.SettingsX:=frmSettings.Left;
	Options.Coordinates.SettingsY:=frmSettings.Top;

	if not SearchDA then begin
		ConfigStr.Clear;
		for i:=0 to TempConfigStr.Count-1 do
			ConfigStr.Add(TempConfigStr.Strings[i]);
	end;
end;

// Показывает нужный фрейм в настройках
// Num - номер фрейма, начиная с нуля
procedure ShowFrame(Num: integer);
begin
	if frmSettings=nil then exit;

	frmSettings.lstSettings.ItemIndex:=Num;

	frmSettings.fraAppearance.Visible:=False;
	frmSettings.fraLook.Visible:=False;
	frmSettings.fraHintPopup.Visible:=False;
  frmSettings.fraDropdownList.Visible:=False;
	frmSettings.fraColors.Visible:=False;
	frmSettings.fraFont.Visible:=False;
	frmSettings.fraHotkey.Visible:=False;
	frmSettings.fraType.Visible:=False;
	frmSettings.fraExec.Visible:=False;
	frmSettings.fraHistory.Visible:=False;
	frmSettings.fraPathes.Visible:=False;
	frmSettings.fraRegistry.Visible:=False;
	frmSettings.fraConfig.Visible:=False;
	frmSettings.fraLanguage.Visible:=False;
	frmSettings.fraUndo.Visible:=False;
  frmSettings.fraSounds.Visible:=False;
	frmSettings.fraEditor.Visible:=False;
  frmSettings.fraPlugins.Visible:=False;

	if Num=0 then frmSettings.fraAppearance.Visible:=True;
	if Num=1 then frmSettings.fraLook.Visible:=True;
	if Num=2 then frmSettings.fraHintPopup.Visible:=True;
	if Num=3 then frmSettings.fraDropdownList.Visible:=True;
	if Num=4 then frmSettings.fraColors.Visible:=True;
	if Num=5 then frmSettings.fraFont.Visible:=True;
	if Num=6 then frmSettings.frahotKey.Visible:=True;
	if Num=7 then frmSettings.fraType.Visible:=True;
	if Num=8 then frmSettings.fraExec.Visible:=True;
	if Num=9 then frmSettings.fraHistory.Visible:=True;
	if Num=10 then frmSettings.fraPathes.Visible:=True;
	if Num=11 then frmSettings.fraRegistry.Visible:=True;
	if Num=12 then frmSettings.fraLanguage.Visible:=True;
	if Num=13 then frmSettings.fraUndo.Visible:=True;
	if Num=14 then frmSettings.fraSounds.Visible:=True;
	if Num=15 then frmSettings.fraConfig.Visible:=True;
	if (Num=16) and not SearchDA then frmSettings.fraEditor.Visible:=True;
	if Num=17 then frmSettings.fraPlugins.Visible:=True;
end;

// Показывает или скрывает поля для редактирования алиаса
procedure ShowEdit(Show: boolean);
begin
	if frmSettings=nil then exit;

	frmSettings.lblAliasName.Visible:=Show;
	frmSettings.lblAliasAction.Visible:=Show;
	frmSettings.lblAliasParams.Visible:=Show;
	frmSettings.lblAliasStartPath.Visible:=Show;
	frmSettings.lblAliasState.Visible:=Show;
	frmSettings.lblAliasHistory.Visible:=Show;
	frmSettings.lblAliasMoveTop.Visible:=Show;
	frmSettings.lstConfig.Visible:=Show;
	frmSettings.lblAliasPriori.Visible:=Show;
	frmSettings.txtAliasName.Visible:=Show;
	frmSettings.txtAliasAction.Visible:=Show;
	frmSettings.txtAliasParams.Visible:=Show;
	frmSettings.txtAliasStartPath.Visible:=Show;
	frmSettings.boxAliasState.Visible:=Show;
	frmSettings.txtFullAlias.Visible:=Show;
	frmSettings.boxAliasHistory.Visible:=Show;
	frmSettings.boxAliasMoveTop.Visible:=Show;
	frmSettings.boxAliasPriori.Visible:=Show;
	frmSettings.btnAliasAction.Visible:=Show;
	frmSettings.btnDeleteAlias.Visible:=Show;
	frmSettings.btnStartPath.Visible:=Show;
	frmSettings.btnSelectPlugin.Visible:=Show;
	frmSettings.btnApplyFullAlias.Visible:=Show;
	frmSettings.lblAliasComment.Visible:=Show;
	frmSettings.txtAliasComment.Visible:=Show;

	frmSettings.spnConfig.Visible:=Show;
end;

// Синхронизирует перемещатель алиасов вверх и вниз
// Num - количество алиасов в конфиге
procedure SyncSpn(Num: integer);
begin
	if frmSettings=nil then exit;
  
	if Num<>1 then begin
		frmSettings.spnConfig.Enabled:=True;
		frmSettings.spnConfig.Min:=0;
		frmSettings.spnConfig.Max:=Num-1;
	end
	else
		frmSettings.spnConfig.Enabled:=False;
end;

// Синхронизирует перемещатель плагинов вверх и вниз
// Num - количество алиасов в конфиге
procedure SyncPluginSpn(Num: integer);
begin
	if frmSettings=nil then exit;

	if Num<>1 then begin
		frmSettings.spnSortPlugins.Enabled:=True;
		frmSettings.spnSortPlugins.Min:=0;
		frmSettings.spnSortPlugins.Max:=Num-1;
	end
	else
		frmSettings.spnSortPlugins.Enabled:=False;
end;

// Ищет окна
function SeekForMainWindow(Wnd: HWnd; LParam: PInteger): bool; stdcall;
var
	Buf: array[byte] of Char;
	ModuleName: string;
begin
	if (Wnd<>frmTARConsole.Handle) then begin
		GetModuleFileName(GetWindowLong(Wnd, GWL_HInstance), Buf, 255);
		ModuleName:=Buf;
		GetClassName(Wnd, Buf, 255);
		Result:=(CompareText(ModuleName, ParamStr(0))<>0) or (CompareText(Buf, frmTARConsole.ClassName)<>0);
		if not Result then LParam^:=Wnd;
	end
	else
		Result:=True;
end;

// Создает атом для уже запущенной копии программы
procedure ActivatePrevInst;
var
	MainWnd, AppWnd: HWnd;
	i: integer;
	AtomID: TAtom;
  totalString: string;
begin
	AppWnd:=0;
	repeat
		AppWnd:=FindWindowEx(0, AppWnd, 'TApplication', PChar(Application.Title))
	until AppWnd<>Application.Handle;
	if AppWnd<>0 then begin
		MainWnd:=0;
		EnumWindows(@SeekForMainWindow, Integer(@MainWnd));
		if MainWnd<>0 then begin
    	totalString:='';
			for i:=1 to ParamCount do begin
      	totalString:=totalString+ParamStr(i)+' ';
			end;
      AtomID:=GlobalAddAtom(PChar(totalString));
      SendMessage(MainWnd, WM_SendFileNameToOpen, 0, AtomID);
      GlobalDeleteAtom(AtomID);
		end;
	end;
end;

// Забивает лист списком дополнения
// List - указатель на список
// strCon - текст в консоли на момент запуска
// SelStart - начало выделения
// SelLength - длина выделения
procedure GetET(List: Pointer; strCon: string; SelStart, SelLength: integer);
var
	tmpAliasStr: ^TStringList;
  i, j: integer;
  Posit: integer;
	fi: TSearchRec;
	tmpStr, topStr{, selStr}: string;
begin
	tmpAliasStr:=List;
{	if(Copy(strCon, SelStart, 1)=' ') then
		topStr:=Copy(Copy(strCon, 0, SelStart), 1, SelStart)
	else}
		topStr:='';
	// Закидываем в лист внутренние команды
	if Options.EasyType.Internal then begin
		for i:=1 to High(InSide) do
			tmpAliasStr.Add(topStr + InSide[i]);
	end;
	// Закидываем в лист алиасы
	if Options.EasyType.Alias then begin
		for i:=0 to ConfigStr.Count-1 do begin
			if Options.EasyType.Space then
				tmpAliasStr.Add(topStr + GetName('alias', ConfigStr.Strings[i]) + ' ')
			else
				tmpAliasStr.Add(topStr + GetName('alias', ConfigStr.Strings[i]));
		end;
	end;
	// Закидываем в лист системные алиасы
	if Options.EasyType.SysAlias then begin
    for i:=0 to Options.SystemAliases.Name.Count-1 do
      tmpAliasStr.Add(Options.SystemAliases.Name.Strings[i]);
  end;
  // Закидываем в лист плагины
  if Options.EasyType.Plugins then begin
    for i:=0 to High(PluginDll) do begin
      if PluginDll[i].Loaded then begin
        for j:=0 to PluginDll[i].GetCount-1 do begin
          tmpAliasStr.Add(topStr + PluginDll[i].GetString(j));
        end;
				for j:=0 to PluginDll[i].GetCountET(strCon)-1 do begin
					tmpAliasStr.Add(topStr + PluginDll[i].GetStringET(j));
				end;
      end;
    end;
	end;
  // Закидываем в лист пути
  if Options.EasyType.Path then begin
    Posit:=GetTypePath(strCon, SelStart);
    if Posit<>0 then begin
      Dec(Posit);
      tmpStr:=Copy(Copy(strCon, 0, SelStart), Posit, Length(Copy(strCon, 0, SelStart))-Posit+1);
      topStr:=Copy(Copy(strCon, 0, SelStart), 1, Posit-1);
      //selStr:=Copy(strCon, SelStart+1, SelLength+1);
      if GetDriveType(PChar(ExtractFileDrive(tmpStr)+'\'))<>1 then begin
        if DriveState(ExtractFileDrive(tmpStr))<>21 then begin
          if FindFirst(GetProgPath(tmpStr)+'*', faAnyFile, fi)=0 then begin
            repeat
              if(fi.Name[1]='.') then continue;
              tmpAliasStr.Add(topStr + GetProgPath(tmpStr) + fi.name);
            until (FindNext(fi)<>0);
          end;
          FindClose(fi);
        end;
      end;
		end;
  end;
  tmpAliasStr.Add('www.');
  tmpAliasStr.Add('http://');
  tmpAliasStr.Add('http://www.');
  // Закидываем в лист историю
  if Options.EasyType.History then begin
    for i:=HistoryStr.Count-1 downto 0 do
			tmpAliasStr.Add(HistoryStr.Strings[i]);
	end;

  // Удаляем дубликаты из списка
	if Options.EasyType.DeleteDuplicates then begin
		i:=1;
		j:=2;
		while i<>tmpAliasStr.Count do begin
			while j<>tmpAliasStr.Count do begin
				if tmpAliasStr.Strings[i]=tmpAliasStr.Strings[j] then
					tmpAliasStr.Delete(j)
				else
					Inc(j);
			end;
			Inc(i);
			j:=i+1;
		end;
	end;
end;

// Парсит всю строку на автодополнение
// Возвращает TRUE, если что-то удалось автодополнить
// strCon - текст в консоли на момент запуска
// SelStart - начало выделения
// SelLength - длина выделения
function ET_Console(strCon: string; SelStart, SelLength: integer): boolean;
var
	i: integer;
	IfET: boolean;
begin
	IfET:=False;

	if (not Tabbed) or (Options.EasyType.EasyType<>1) then begin
    tmpAliasStr.Clear;
		tmpAliasStr.Add('');
		GetET(@tmpAliasStr, strCon, SelStart, SelLength);
	end;

  i:=1;
  while i<>tmpAliasStr.Count do begin
    if not ((Copy(strCon, 0, SelStart)=Copy(tmpAliasStr.Strings[i], 0, SelStart)) or (not Options.EasyType.CaseSensitivity and (AnsiLowerCase(Copy(strCon, 0, SelStart))=AnsiLowerCase(Copy(tmpAliasStr.Strings[i], 0, SelStart))))) then begin
      tmpAliasStr.Delete(i);
      dec(i);
    end;
    inc(i);
  end;

  // Проверка, вперед или назад смотреть автодополнение
  if IsShift and Tabbed then begin
    // Назад
    for i:=tmpAliasStr.Count-1 downto 1 do begin
      if (Copy(strCon, 0, SelStart)=Copy(tmpAliasStr.Strings[i], 0, SelStart)) or (not Options.EasyType.CaseSensitivity and (AnsiLowerCase(Copy(strCon, 0, SelStart))=AnsiLowerCase(Copy(tmpAliasStr.Strings[i], 0, SelStart)))) then begin
        if (SelLength=0) and (Length(strCon)=SelStart) then begin
          IfET:=True;
          Make_ET(tmpAliasStr.Strings[i], Length(strCon), Length(tmpAliasStr.Strings[i])-Length(strCon)+1);
          ET_Num:=i;
          Break;
        end;
        if (ET_Num>i) and (ET_Num<>0) then begin
          IfET:=True;
          Make_ET(tmpAliasStr.Strings[i], SelStart, Length(tmpAliasStr.Strings[i])-SelStart+1);
          ET_Num:=i;
          Break;
        end;
      end;
    end;
  end
  else begin
    // Вперед
    for i:=1 to tmpAliasStr.Count-1 do begin
      if (Copy(strCon, 0, SelStart)=Copy(tmpAliasStr.Strings[i], 0, SelStart)) or (not Options.EasyType.CaseSensitivity and (AnsiLowerCase(Copy(strCon, 0, SelStart))=AnsiLowerCase(Copy(tmpAliasStr.Strings[i], 0, SelStart)))) then begin
				if (SelLength=0) and (Length(strCon)=SelStart) then begin
					if (ET_Num=0) then begin
						if (not tabbed) then ET_Num:=0;
						IfET:=True;
						Make_ET(tmpAliasStr.Strings[i], Length(strCon), Length(tmpAliasStr.Strings[i])-Length(strCon)+1);
						ET_Num:=i;
						Break;
					end;
					if (ET_Num<i) then begin
						IfET:=True;
						Make_ET(tmpAliasStr.Strings[i], Length(strCon), Length(tmpAliasStr.Strings[i])-Length(strCon)+1);
						ET_Num:=i;
						Break;
					end;
				end;
				if (ET_Num<i) and (ET_Num<>0) then begin
          IfET:=True;
          Make_ET(tmpAliasStr.Strings[i], SelStart, Length(tmpAliasStr.Strings[i])-SelStart+1);
          ET_Num:=i;
          Break;
        end;
      end;
    end;
  end;
  // Если ничего не автодополнено, то зацикливание через пустое автодополнение
	if not IfET then begin
		if SelLength=0 then
			Make_ET(strCon, Length(Copy(strCon, 0, SelStart)), 0)
		else
			Make_ET(Copy(strCon, 0, SelStart), Length(Copy(strCon, 0, SelStart)), 0);
    ET_Num:=0;
  end;
  
  Tabbed:=False;
	PB_Flag:=IfET;
	Result:=IfET;
end;

// Вставляет автодополнение в консоль
// strCon - полученный текст
// SelStart - начало выделения
// SelLength - длина выделения
procedure Make_ET(strCon: string; SelStart, SelLength: integer);
begin
	if frmTARConsole.Visible and frmTARConsole.Enabled and frmTARConsole.txtConsole.Visible and frmTARConsole.txtConsole.Enabled then frmTARConsole.txtConsole.SetFocus;
  frmTARConsole.txtConsole.Text:=strCon;
	if Options.EasyType.EasyType=1 then begin
		frmTARConsole.txtConsole.SelStart:=SelStart;
		frmTARConsole.txtConsole.SelLength:=SelLength;
	end;
	if Options.EasyType.EasyType=2 then begin
		frmTARConsole.txtConsole.SelStart:=Length(frmTARConsole.txtConsole.Text);
		frmTARConsole.txtConsole.SelLength:=0;
	end;
  if Options.Hint.ShowHint then ViewHint(strCon);
end;

// Добавляет слеш при браузере путей
function SetBrowse: boolean;
var
	flag: boolean;
  strCon: string;
  Posit: integer;
begin
	flag:=False;
  strCon:=frmTARConsole.txtConsole.Text;
  Posit:=GetTypePath(strCon, frmTARConsole.txtConsole.SelStart);
  if Posit<>0 then
    strCon:=Copy(strCon, Posit-1, Length(strCon)-Posit+2);
  if FileExists(strCon) and not DirectoryExists(strCon) and (Copy(frmTARConsole.txtConsole.Text, frmTARConsole.txtConsole.SelStart, 1)<>':') then begin
    flag:=True;
    frmTARConsole.txtConsole.SelStart:=Length(frmTARConsole.txtConsole.Text);
    frmTARConsole.txtConsole.SelLength:=0;
  end;
  if Copy(frmTARConsole.txtConsole.Text, frmTARConsole.txtConsole.SelStart, 1)=':' then begin
		if Options.EasyType.EasyType=1 then
      tmrEasyType.Enabled:=True;
  end
  else if not FileExists(strCon) and DirectoryExists(strCon) then begin
    if Options.EasyType.EasyType=1 then
      tmrEasyType.Enabled:=True;
    frmTARConsole.txtConsole.SelStart:=Length(frmTARConsole.txtConsole.Text);
    frmTARConsole.txtConsole.SelLength:=0;
  end;
  Result:=flag;
end;

// Добавляет программу, переданную через командную строку
// Str - переданная строка
procedure AddToProgram(Str: string);
begin
  if Copy(Str, 0, 6)='--add=' then begin
    Str:=Copy(Str, 7, Length(Str)-6);
    if Str<>'' then begin
      frmTARConsole.Hide;
      IsEditor:=True;
      PathString:=Trim(Str);

      CreateSettingsForm;
      frmSettings.Show;
      AttachThreadInput(GetWindowThreadProcessId(GetForegroundWindow, nil), GetWindowThreadProcessId(frmSettings.Handle, nil), True);
      SetForegroundWindow(frmSettings.Handle);
      frmSettings.BringToFront;
    end;
  end
  else if Copy(Str, 0, 7)='--exec=' then begin
		Str:=Copy(Str, 8, Length(Str)-7);
    if(Length(Str)>0) then begin
	    IsParseCL:=True;
	    ParseConsole(Trim(Str));
    end;
  end
  else begin
    if(Length(Str)>0) then begin
    	IsParseCL:=True;
	    ParseConsole(Trim(Str));
    end;
  end;
end;

// Проверяет мертвые алиасы
procedure CheckDeadAliases;
var
  i, k, l: integer;
  CDA: TStringList;
  tmpStr, tmpFindStr: string;
	temp: integer;
  FilesList, PluginList: TStringList;
  j: char;
  msgResult: integer;
begin
  if ConfigStr.Count=0 then Exit;
	SearchDA:=True;
  // Инициализация настроек
  temp:=0;
  if frmSettings<>nil then begin
    frmSettings.btnCheckDeadAliases.Enabled:=False;
    frmSettings.btnBackAllDA.Enabled:=False;
    frmSettings.lblChecking.Visible:=True;
    frmSettings.pbrCheckDA.Visible:=True;
    temp:=frmSettings.lstSettings.ItemIndex;
  end;

  // Инициализация файла с удаленными мертвыми алиасами
  CDA:=TStringList.Create;
  if Options.Config.CDA_CreateOldFile then begin
    if FileExists(Program_Config_Old) then
      CDA.LoadFromFile(Program_Config_Old)
    else
      CDA.SaveToFile(Program_Config_Old);
	end;

  FilesList:=TStringList.Create;
  PluginList:=TStringList.Create;
  i:=0;
  if frmSettings<>nil then
  	frmSettings.pbrCheckDA.Max:=ConfigStr.Count-1;
  msgResult:=0;

  // Перебор всех алиасов
  while i<ConfigStr.Count do begin
    tmpStr:=InsertEnv(GetName('action', ConfigStr.Strings[i]));
    if frmSettings<>nil then
			frmSettings.lblChecking.Caption:=GetLangStr('checkingalias')+' '+GetName('alias', ConfigStr.Strings[i]);
    Application.ProcessMessages;
   	while Pos('"', tmpStr)<>0 do begin
     	Delete(tmpStr, Pos('"', tmpStr), 1);
    end;
    // Если строка не существующий файл, урл или адрес мыла - то это метрвый алиас
    if not (FileExists(tmpStr) or IsWWW(tmpStr) or IsEmail(tmpStr) or (GetPathFolder(tmpStr)<>'') or DirectoryExists(tmpStr)) then begin
      // Если разрешено искать алиасы в подключенный плагинах
      if Options.Config.CDA_SearchPlugins then begin
        if PluginList.Count=0 then begin
          for k:=0 to High(PluginDll) do begin
            if PluginDll[k].Loaded then begin
              for l:=0 to PluginDll[k].GetCount-1 do begin
                PluginList.Add(PluginDll[k].GetString(l));
              end;
            end;
          end;
        end;
        for k:=0 to PluginList.Count-1 do begin
          if PluginList.Strings[k]=GetName('action', ConfigStr.Strings[i]) then begin
            tmpStr:='';
            break;
          end;
        end;
      end;
      // Если разрешен поиск алиасов и файлов, то ищем замену мертвому алиасу
      if Options.Config.CDA_SearchFile and (tmpStr<>'') then begin
        // Если список файлов еще не заделан, то самое время заняться этим
        if FilesList.Count=0 then begin
          for j:='A' to 'Z' do begin
            if GetDriveType(pChar(j+':\'))=DRIVE_FIXED then
              GetFileList(j+':\', @FilesList);
          end;
        end;
        // Поиск замены мертвому алиасу в созданном списке файлов на всех дисках
        for k:=0 to FilesList.Count-1 do begin
          if AnsiLowerCase(ExtractFileName(tmpStr))=AnsiLowerCase(ExtractFileName(FilesList.Strings[k])) then begin
            tmpFindStr:=FilesList.Strings[k];
            // Если уместны вопросы, то спрашиваем - а надо ли делать эту замену
						if Options.Config.CDA_Confirmation then
							msgResult:=MessageDlg(GetLangStr('replacepath')+#13+ConfigStr.Strings[i]+#13+GetName('action', ConfigStr.Strings[i])+' >>'+#13+tmpFindStr, mtConfirmation, [mbYes, mbNo, mbCancel], 0)
            else
          		msgResult:=6;
						if msgResult=2 then Break;
            if msgResult=6 then begin
              ConfigStr.Strings[i]:=GetFullString(GetName('alias', ConfigStr.Strings[i]), tmpFindStr, GetName('param', ConfigStr.Strings[i]), GetName('dir', ConfigStr.Strings[i]), GetName('state', ConfigStr.Strings[i]), GetName('history', ConfigStr.Strings[i]), GetName('top', ConfigStr.Strings[i]), GetName('priori', ConfigStr.Strings[i]), GetName('comment', ConfigStr.Strings[i]));
              tmpStr:='';
              Break; // В случае удачной замены поиск не нужно продолжать
            end;
          end;
        end;
      end;
      if msgResult=2 then Break;
      // Если прошлые манипуляции с поиском файла не удались, то даем запрос на удаление алиаса
      if tmpStr<>'' then begin
	      if Options.Config.CDA_Confirmation then
	        msgResult:=MessageDlg(GetLangStr('deletethisalias')+#13+ConfigStr.Strings[i], mtConfirmation, [mbYes, mbNo, mbCancel], 0)
        else
					msgResult:=6;
        if msgResult=6 then begin
          // Зачем добавлять алиас, если он уже существует в списке мертвых алиасов?
          if CDA.IndexOf(ConfigStr.Strings[i])=-1 then
            CDA.Add(ConfigStr.Strings[i]);
          ConfigStr.Delete(i);
          Dec(i);
        end;
			end;
		end;
		if msgResult=2 then Break;
    if frmSettings<>nil then
			frmSettings.pbrCheckDA.Position:=i;
		Inc(i);
	end;

	// Сохраняем удаленные алиасы, если это разрешено
	FilesList.Free;
  PluginList.Free;
	if Options.Config.CDA_CreateOldFile then
		CDA.SaveToFile(Program_Config_Old);
	CDA.Free;

	// Разинициализация настроек
  SearchDA:=False;
  if frmSettings<>nil then begin
    frmSettings.lblChecking.Caption:=GetLangStr('decheckcomplete');
    frmSettings.btnCheckDeadAliases.Enabled:=True;
    frmSettings.pbrCheckDA.Visible:=False;
    ShowTip('', GetLangStr('decheckcomplete'), bitInfo, 3000);
    SaveConfig(Program_Config);
    if frmSettings.Visible then begin
      ApplySettings;
      FillSettings;
      frmSettings.lstSettings.ItemIndex:=temp;
      if TempConfigStr.Count<>0 then GetEdit(0);
    end;
  end;
end;

// Возвращает удаленные мертвые алиасы
procedure ReturnDeadAliases;
var
	CDA: TStringList;
	temp: integer;
begin
	if FileExists(Program_Config_Old) then begin
	  temp:=0;
    if frmSettings<>nil then temp:=frmSettings.lstSettings.ItemIndex;
		CDA:=TStringList.Create;
		CDA.LoadFromFile(Program_Config_Old);
		ConfigStr.AddStrings(CDA);
		CDA.Free;
		SaveConfig(Program_Config);
		DeleteFile(Program_Config_Old);
    if frmSettings<>nil then begin
			if frmSettings.Visible then begin
				ApplySettings;
        FillSettings;
        frmSettings.lstSettings.ItemIndex:=temp;
        if TempConfigStr.Count<>0 then GetEdit(0);
      end;
    end;
	end;
end;

// Синхронизирует текстовое поле и прокрутку
// TextBox - текстовое поле
// SpnBox - прокрутка
procedure SyncUpDown(TextBox: TEdit; SpnBox: TUpDown);
begin
	TextBox.Text:=KillZero(TextBox.Text);
	if TextBox.Text='' then TextBox.Text:='0';
	if not IsNumber(TextBox.Text) then TextBox.Text:=IntToStr(SpnBox.Position);
	if StrToInt(TextBox.Text)>SpnBox.Max then TextBox.Text:=IntToStr(SpnBox.Max);
	SpnBox.Position:=StrToInt(TextBox.Text);
end;

// Возвращает список файлов в нужной папке.
// Dir - начальная папка
// List - лист, в который идет добавление
procedure GetFileList(Dir: string; List: Pointer);
var
	tmpList: ^TStringList;
  // Ищет файлы и папки, начиная с текущей директории
  procedure FindDir;
  var
    fi: TSearchRec;
    tmp: string;
  begin
    if FindFirst('*.*', faAnyFile, fi)=0 then begin
      repeat
        if(fi.Name[1]='.') then Continue;
        Application.ProcessMessages;
        if(fi.Attr and faDirectory)=faDirectory then begin
          if SetCurrentDir(fi.name) then
            FindDir;
        end
        else begin
          if Length(GetCurrentDir)=3 then
            tmp:=GetCurrentDir+fi.Name
          else
            tmp:=GetCurrentDir+'\'+fi.Name;
          tmpList.Add(tmp);
        end;
      until (FindNext(fi)<>0);
      FindClose(fi);
    end;
    SetCurrentDir('..');
  end;
begin
  tmpList:=List;
	if frmSettings<>nil then
	  frmSettings.lblChecking.Caption:=GetLangStr('generationfilelist')+' ['+Dir+']';
  ShowTip('', GetLangStr('generationfilelist')+' ['+Dir+']', bitInfo, 3000);
  SetCurrentDir(Dir);
  FindDir;
end;

// Показывает балун типс в трее
// Title - заголовок
// Text - сам текст типса
// IconType - тип иконки (еррор, мессага, ничего)
// Timeout - таймаут в миллисекундах
procedure ShowTip(Title: string; Text: string; IconType: TBalloonHintIcon; Timeout: integer);
begin
  if Options.Show.BalloonTips then begin
    frmTARConsole.trayIcon.HideBalloonHint;
    frmTARConsole.trayIcon.ShowBalloonHint(Title, Text, IconType, 60);
    tmrHide.Enabled:=False;
    tmrHide.Interval:=Timeout;
    tmrHide.Enabled:=True;
  end;
end;

// Делает смартовый бэкспейс
procedure CoolBackSpace;
var
  tmpSelStart, tmpSelLength: integer;
begin
  if (Options.EasyType.EasyType=1) and ((frmTARConsole.txtConsole.SelLength<>0) or (Length(frmTARConsole.txtConsole.Text)=1)) then begin
    if frmTARConsole.txtConsole.SelStart>0 then tmpSelStart:=frmTARConsole.txtConsole.SelStart-1 else tmpSelStart:=frmTARConsole.txtConsole.SelStart;
    if frmTARConsole.txtConsole.SelLength<Length(frmTARConsole.txtConsole.Text) then tmpSelLength:=frmTARConsole.txtConsole.SelLength+1 else tmpSelLength:=frmTARConsole.txtConsole.SelLength;
    frmTARConsole.txtConsole.SelStart:=tmpSelStart;
    frmTARConsole.txtConsole.SelLength:=tmpSelLength;
  end;
end;

// Обработка переданных TypeAndRun параметров
// What - номер операции (1 - проверка на конфиги, 2 - добавление алиаса в конфиг)
procedure ParseCmdLine(What: integer);
var
	i: integer;
	tmpMyPath: string;
  tmpMU: boolean;
begin
	if What=2 then begin
		if ParamCount<>0 then begin
			for i:=1 to ParamCount do begin
				if Copy(ParamStr(i), 0, 6)='--add=' then
					AddToProgram(ParamStr(i));
				if Copy(ParamStr(i), 0, 7)='--exec=' then
					AddToProgram(ParamStr(i));
			end;
		end;
	end;
	if What=1 then begin
		Options.FileName:='';
    Program_Config:='';
    Program_History:='';
		Program_Config_Old:='';
		Program_Plugin:='';
		Options.ReadRegSettings;
    tmpMU:=Options.Registry.MultiUser;
		// Если параметры были переданы, то пытаемся их прочитать
		if ParamCount<>0 then begin
			for i:=1 to ParamCount do begin
				if Copy(ParamStr(i), 0, 11)='--settings=' then
					Options.FileName:=Copy(ParamStr(i), 12, Length(ParamStr(i))-11);
				if Copy(ParamStr(i), 0, 9)='--config=' then
					Program_Config:=Copy(ParamStr(i), 10, Length(ParamStr(i))-9);
				if Copy(ParamStr(i), 0, 10)='--history=' then
					Program_History:=Copy(ParamStr(i), 11, Length(ParamStr(i))-10);
				if Copy(ParamStr(i), 0, 12)='--configold=' then
					Program_Config_Old:=Copy(ParamStr(i), 13, Length(ParamStr(i))-12);
				if Copy(ParamStr(i), 0, 10)='--plugins=' then
					Program_Plugin:=Copy(ParamStr(i), 11, Length(ParamStr(i))-10);
				if Copy(ParamStr(i), 0, 13)='--multiusers=' then begin
					if Copy(ParamStr(i), 14, Length(ParamStr(i))-13)='1' then tmpMU:=True;
					if Copy(ParamStr(i), 14, Length(ParamStr(i))-13)='0' then tmpMU:=False;
				end;
			end;
		end;
		// Работа с реестром - мультиюзеры
		if (tmpMU) and (Pos('NT', GetWinVersion)<>0) then
			tmpMyPath:=GetDOSEnvVar('APPDATA') + '\' + 'TypeAndRun\'
		else
			tmpMyPath:=GetMyPath;
		if not (DirectoryExists(tmpMyPath)) then
			if not CreateDir(tmpMyPath) then
				tmpMyPath:=GetMyPath;
    // Теперь если что-то не проинициализировалось, то помогаем этому произойти
    if ExtractFilePath(Options.FileName)='' then begin
      if Options.FileName='' then
				Options.FileName:=tmpMyPath+'TypeAndRun.ini'
      else
        Options.FileName:=tmpMyPath+Options.FileName;
    end;
    if ExtractFilePath(Program_Config)='' then begin
      if Program_Config='' then
				Program_Config:=tmpMyPath+'Config.ini'
      else
				Program_Config:=tmpMyPath+Program_Config;
    end;
    if ExtractFilePath(Program_History)='' then begin
      if Program_History='' then
				Program_History:=tmpMyPath+'History.ini'
      else
        Program_History:=tmpMyPath+Program_History;
		end;
		if ExtractFilePath(Program_Config_Old)='' then begin
			if Program_Config_Old='' then
        Program_Config_Old:=ExtractFilePath(Program_Config)+'~'+ExtractFileName(Program_Config)
      else
        Program_Config_Old:=ExtractFilePath(Program_Config)+Program_Config_Old;
    end;
    if ExtractFilePath(Program_Plugin)='' then begin
      if Program_Plugin='' then
				Program_Plugin:=tmpMyPath+'Plugins.ini'
      else
        Program_Plugin:=tmpMyPath+Program_Plugin;
    end;
  end;
end;

// Посылает текст окну
// WinHandle - хендл окна
// txtText - посылаемая строка
procedure SendText(WinHandle: HWND; txtText: string);
var
	Data: TCopyDataStruct;
	s: string;
begin
  s:=txtText;
  Data.dwData := 0;
  Data.cbData := Length(s);
  Data.lpData := @s[1];
  SendMessage(WinHandle, WM_COPYDATA, 0, integer(@Data));
end;

// Создает форму настроек и применяет параметры к ней
procedure CreateSettingsForm;
begin
	if frmSettings=nil then begin
		Application.CreateForm(TfrmSettings, frmSettings);
		SetLanguages;
  end;
end;

// Создает форму о программе и применяет параметры к ней
procedure CreateAboutForm;
begin
  if frmAbout=nil then begin
		Application.CreateForm(TfrmAbout, frmAbout);
		SetLanguages;
	end;
end;

// Отображает подсказку
// HintText - строка для отображения
procedure ViewHint(HintText: string);
var
	i: integer;
	tmpHint: string;
	tmpAction: string;
	tmpParam: string;
	tmpComment: string;
	FlagReplace: boolean;
begin
	if frmHint=nil then Application.CreateForm(TfrmHint, frmHint);
	if HintText = '' then begin
		ShowWindow(frmHint.Handle, SW_HIDE);
		frmHint.Visible:=False;
	end
	else begin
		tmpHint:='';
		FlagReplace:=False;
		// Создание текста подсказки из алиасов
		for i:=0 to ConfigStr.Count-1 do begin
			if (GetProgName(HintText)=GetName('alias', ConfigStr.Strings[i])) or (not Options.EasyType.CaseSensitivity and (AnsiLowerCase(GetProgName(HintText))=AnsiLowerCase(GetName('alias', ConfigStr.Strings[i])))) then begin
				tmpAction:=GetName('action', ConfigStr.Strings[i]);
				if InsertS(tmpAction, GetProgParam(HintText)) then FlagReplace:=True;;
				tmpParam:=GetName('param', ConfigStr.Strings[i]);
				if InsertS(tmpParam, GetProgParam(HintText)) then FlagReplace:=True;
				if not FlagReplace then tmpParam:=GetName('param', ConfigStr.Strings[i]) + GetProgParam(HintText);
				if tmpParam<>'' then tmpParam:=' ' + tmpParam;
				tmpParam:=AnsiReplaceStr(tmpParam, '¦', '|');
				if(tmpHint<>'') then tmpHint:=tmpHint + #13;
				tmpHint:=tmpHint + GetLangStr('aliashint') + ' ''' + tmpAction + tmpParam + '''';
				tmpComment:=GetName('comment', ConfigStr.Strings[i]);
				if(tmpComment<>'') then tmpHint:=tmpHint + #13 + tmpComment;
			end;
		end;
		// Создание текста подсказки из системных алиасов
		if tmpHint=''  then begin
			for i:=0 to Options.SystemAliases.Name.Count-1 do begin
				if (GetProgName(HintText)=Options.SystemAliases.Name.Strings[i]) or (not Options.EasyType.CaseSensitivity and (AnsiLowerCase(GetProgName(HintText))=AnsiLowerCase(Options.SystemAliases.Name.Strings[i]))) then begin
					tmpAction:=Options.SystemAliases.Action.Strings[i];
					tmpParam:=GetProgParam(HintText);
					if tmpParam<>'' then tmpParam:=' ' + tmpParam;
					tmpParam:=AnsiReplaceStr(tmpParam, '¦', '|');
					tmpHint:=GetLangStr('sysaliashint') + ' ''' + tmpAction + tmpParam + '''';
				end;
			end;
		end;
		// Скрытие подсказки
		if tmpHint = ''  then begin
			ShowWindow(frmHint.Handle, SW_HIDE);
			frmHint.Visible:=False;
		end
		// Показ подсказки
		else begin
			frmHint.lblHint.Caption:=tmpHint;
			frmHint.lblHint.Font.Color:=Options.Color[Options.EasyType.EasyType].HintText;
			frmHint.lblHint.Color:=Options.Color[Options.EasyType.EasyType].HintColor;
			frmHint.lblBack.Color:=Options.Color[Options.EasyType.EasyType].HintColor;
			frmHint.Height:=frmHint.lblHint.Height + 4 + 2*Options.Hint.BorderSize;
			if frmHint.lblHint.Width>frmTARConsole.Width then
				frmHint.Width:=frmTARConsole.Width
			else
				frmHint.Width:=frmHint.lblHint.Width + 4 + 2*Options.Hint.BorderSize;
			frmHint.lblBack.Width:=frmHint.Width - 2*Options.Hint.BorderSize;
			frmHint.lblBack.Height:=frmHint.Height - 2*Options.Hint.BorderSize;
			frmHint.Left:=frmTARConsole.Left;
			if (frmTARConsole.Top-frmHint.Height)>0 then begin
				frmHint.Top:=frmTARConsole.Top-frmHint.Height;
			end
			else begin
				frmHint.Top:=frmTARConsole.Top+frmTARConsole.Height;
			end;
			if Options.Hint.Transparent=255 then begin
				frmHint.AlphaBlend:=False;
			end
			else begin
				frmHint.AlphaBlend:=True;
				frmHint.AlphaBlendValue:=Options.Hint.Transparent;
			end;
			frmHint.TransparentColorValue:=Options.Color[Options.EasyType.EasyType].HintColor;
			frmHint.TransparentColor:=Options.Hint.DestroyForm;
			frmHint.BorderWidth:=Options.Hint.BorderSize;
			frmHint.Color:=Options.Color[Options.EasyType.EasyType].HintBorder;
			ShowWindow(frmHint.Handle, SW_SHOWNOACTIVATE);
			frmHint.Visible:=True;
		end;
	end;
end;

// Отображает выдадающий список допустимых алиасов
// strCon - полученный текст консоли
// SelStart - начало выделения
// SelLength - длина выделения
procedure DropDown(strCon: string; SelStart, SelLength: integer);
var
	tmpList: TStringList;
  i: integer;
  newHight: integer;
begin
	if frmTypeDropDown=nil then Application.CreateForm(TfrmTypeDropDown, frmTypeDropDown);
  tmpList:=TStringList.Create;
	if(strCon<>'') then begin
		// Если автодополнение включено, то лист подсказок уже сформирован, иначе - делаем новый 
		if (Options.EasyType.EasyType<>1) then
			GetET(@tmpList, strCon, SelStart, SelLength)
		else
      tmpList:=tmpAliasStr;
	end
	else begin
		// Если консоль пустая, то заносим только историю
  	for i:=HistoryStr.Count-1 downto 0 do
  		tmpList.Add(HistoryStr.Strings[i]);
	end;

	// Чистка списка, не совпадающего с текстом в консоли
	if(StrCon<>'') then begin
		i:=0;
		while i<>tmpList.Count do begin
			if not ((Copy(strCon, 0, SelStart)=Copy(tmpList.Strings[i], 0, SelStart)) or (not Options.EasyType.CaseSensitivity and (AnsiLowerCase(Copy(strCon, 0, SelStart))=AnsiLowerCase(Copy(tmpList.Strings[i], 0, SelStart))))) then begin
				tmpList.Delete(i);
				dec(i);
			end;
			inc(i);
		end;
	end;

  // Список пуст
	if tmpList.Count=0 then begin
    frmTypeDropDown.Destroy;
    frmTypeDropDown:=nil;
	end
	// Показ списка
	else begin
    frmTypeDropDown.lstDropDown.Items.Clear;
    frmTypeDropDown.lstDropDown.Items:=tmpList;
    frmTypeDropDown.Width:=frmTARConsole.Width;
		frmTypeDropDown.Left:=frmTARConsole.Left;
		frmTypeDropDown.lstDropDown.Color:=Options.Color[Options.EasyType.EasyType].DropDownColor;
		frmTypeDropDown.lstDropDown.Font.Color:=Options.Color[Options.EasyType.EasyType].DropDownText;
				frmTypeDropDown.lstDropDown.Font.Name:=frmTARConsole.txtConsole.Font.Name;
    frmTypeDropDown.lstDropDown.Font.Style:=frmTARConsole.txtConsole.Font.Style;
    if frmTARConsole.txtConsole.Font.Height>0 then
    	frmTypeDropDown.lstDropDown.Font.Height:=frmTARConsole.txtConsole.Font.Height
    else
			frmTypeDropDown.lstDropDown.Font.Size:=frmTARConsole.txtConsole.Font.Size;
		if Options.DownDrop.Transparent=255 then begin
			frmTypeDropDown.AlphaBlend:=False;
		end
		else begin
			frmTypeDropDown.AlphaBlend:=True;
			frmTypeDropDown.AlphaBlendValue:=Options.DownDrop.Transparent;
		end;
		frmTypeDropDown.TransparentColorValue:=Options.Color[Options.EasyType.EasyType].DropDownColor;
		frmTypeDropDown.TransparentColor:=Options.DownDrop.DestroyForm;
    if tmpList.Count<Options.DownDrop.LineNum then newHight:=tmpList.Count else newHight:=Options.DownDrop.LineNum;
    frmTypeDropDown.Height:=newHight*(frmTypeDropDown.lstDropDown.Font.Height+1);
		frmTypeDropDown.Height:=newHight*(frmTARConsole.Height-2*Options.Show.BorderSize) + 2*Options.DownDrop.BorderSize;
		if(frmTARConsole.Top + frmTARConsole.Height + frmTypeDropDown.Height < Screen.Height) then
			frmTypeDropDown.Top:=frmTARConsole.Top + frmTARConsole.Height
		else
			frmTypeDropDown.Top:=frmTARConsole.Top - frmTypeDropDown.Height;
		frmTypeDropDown.BorderWidth:=Options.DownDrop.BorderSize;
		frmTypeDropDown.Color:=Options.Color[Options.EasyType.EasyType].DropDownBorder;
    TextSelStart:=SelStart;
    frmTypeDropDown.Show;
  end;
end;

// Делает мегасмартовый бэкспейс
procedure CtrlBackSpace;
var
	i: integer;
	txtCon: string;
	tmpSelStart, tmpSelLength: integer;
begin
	txtCon:=frmTARConsole.txtConsole.Text;
	tmpSelStart:=frmTARConsole.txtConsole.SelStart;
	tmpSelLength:=frmTARConsole.txtConsole.SelLength;
	Delete(txtCon, Length(txtCon), 1);
	for i:=length(txtCon) downto 0 do begin
		if Copy(txtCon, i, 1)='\' then Break;
		if Copy(txtCon, i, 1)='/' then Break;
	end;
	Inc(i);
	if i=0 then
		txtCon:=''
	else begin
		Delete(txtCon, i, Length(txtCon)-i+1);
		for i:=length(txtCon) downto 0 do begin
			if Copy(txtCon, i, 1)='\' then Break;
			if Copy(txtCon, i, 1)='/' then Break;
		end;
  end;
	frmTARConsole.txtConsole.Text:=txtCon;
	frmTARConsole.txtConsole.SelStart:=tmpSelStart;
	frmTARConsole.txtConsole.SelLength:=tmpSelLength;
end;

// Показывает мессагу
procedure ShowMes(text: string);
begin
	if Options.Show.BalloonTips then
		ShowTip('', text, bitInfo, 5000)
	else
		ShowMessage(text);
end;

// Устанавливает правильную иконку в трее
procedure setTrayIcon;
var
	tmpWinVer: string;
begin
	if FileExists(GetMyPath + 'TypeAndRun.ico') then
		frmTARConsole.trayIcon.Icon.LoadFromFile(GetMyPath + 'TypeAndRun.ico')
	else begin
		tmpWinVer:=GetWinVersion;
		if (pos('NT', tmpWinVer)<>0) and (StrToInt(GetName('action',tmpWinVer)+GetName('param',tmpWinVer)) >= 50) then
			frmTARConsole.trayIcons.GetIcon(0, frmTARConsole.trayIcon.Icon)
		else
      frmTARConsole.trayIcons.GetIcon(1, frmTARConsole.trayIcon.Icon);
	end;
end;

function BadApp(): bool;
var
	activeWnd: HWND;
  aName: array [0..255] of Char;
  Flag: bool;
  i: integer;
begin
	if(badApps = nil) then begin
	  badApps := TStringList.Create;
    if(FileExists(GetMyPath + 'ignores.ini')) then
      badApps.LoadFromFile(GetMyPath + 'ignores.ini');
  end;

	activeWnd := GetForegroundWindow();
  Flag := False;
  if activeWnd <> 0 then begin
	  //GetWindowText(activeWnd, txt, 100);
    if Boolean(GetClassName(activeWnd, aName, 255) ) then begin
    	for i:=0 to badApps.Count-1 do
      	if aName = badApps.Strings[i] then
      		Flag := True;
    end;
  end;
	Result := Flag;
end;

end.
