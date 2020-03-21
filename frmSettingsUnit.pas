unit frmSettingsUnit;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ComCtrls, ShlObj, ExtCtrls, Menus,
	CoolTrayIcon, Configs, Settings;

type
  TfrmSettings = class(TForm)
    lstSettings: TListBox;
		btnOK: TButton;
		btnCancel: TButton;
		btnApply: TButton;
    fraAppearance: TGroupBox;
		chkShowConsoleOnStart: TCheckBox;
		chkHideConsole: TCheckBox;
		chkTriggerShow: TCheckBox;
    chkTrayIcon: TCheckBox;
    fraLook: TGroupBox;
    lblConsoleWidth: TLabel;
    lblConsoleHeight: TLabel;
    lblBorderSize: TLabel;
		fraColors: TGroupBox;
    lblTextcolor: TLabel;
    shpTextColor: TShape;
    lblConsoleColor: TLabel;
    shpConsoleColor: TShape;
    shpBorderColor: TShape;
		lblBorderColor: TLabel;
    fraFont: TGroupBox;
    lblFont: TLabel;
    btnFont: TButton;
    fraHotkey: TGroupBox;
    chkAlt: TCheckBox;
    chkCtrl: TCheckBox;
    chkShift: TCheckBox;
    chkWin: TCheckBox;
    htkHotkey: THotKey;
    fraExec: TGroupBox;
    chkExecInternal: TCheckBox;
    chkExecAlias: TCheckBox;
    chkExecWWW: TCheckBox;
    chkExecEMail: TCheckBox;
    chkExecFolder: TCheckBox;
    chkExecShell: TCheckBox;
    fraHistory: TGroupBox;
    optNoSaveHistory: TRadioButton;
    optSaveHistory: TRadioButton;
    chkSaveAlias: TCheckBox;
    chkSaveAliasParam: TCheckBox;
    chkSaveWWW: TCheckBox;
    chkSaveEMail: TCheckBox;
    chkSaveFolder: TCheckBox;
    chkSaveShell: TCheckBox;
    btnClearHistory: TButton;
    fraPathes: TGroupBox;
    lblBrowser: TLabel;
    txtBrowser: TEdit;
    btnBrowser: TButton;
		lblFileManager: TLabel;
    txtFileManager: TEdit;
    btnFileManager: TButton;
    lblShell: TLabel;
    txtShell: TEdit;
    btnShell: TButton;
    fraRegistry: TGroupBox;
		fraType: TGroupBox;
    optNoType: TRadioButton;
    optEasyType: TRadioButton;
    optLinuxType: TRadioButton;
    txtConsoleX: TEdit;
    txtConsoleY: TEdit;
    txtConsoleWidth: TEdit;
    txtConsoleHeight: TEdit;
    txtBorderSize: TEdit;
    fraConfig: TGroupBox;
    chkMoveTop: TCheckBox;
    fraLanguage: TGroupBox;
    fraEditor: TGroupBox;
    lstConfig: TListBox;
    lblAliasName: TLabel;
    txtAliasName: TEdit;
    lblAliasAction: TLabel;
    txtAliasAction: TEdit;
    lblAliasParams: TLabel;
    txtAliasParams: TEdit;
    lblAliasStartPath: TLabel;
    txtAliasStartPath: TEdit;
    lblAliasState: TLabel;
    boxAliasState: TComboBox;
    lblAliasHistory: TLabel;
    boxAliasHistory: TComboBox;
    lblAliasMoveTop: TLabel;
    boxAliasMoveTop: TComboBox;
    btnAliasAction: TButton;
    txtFullAlias: TEdit;
    btnApplyFullAlias: TButton;
    btnAddAlias: TButton;
    btnDeleteAlias: TButton;
    spnConfig: TUpDown;
    fraUndo: TGroupBox;
    chkUseUndo: TCheckBox;
    lblMaxHistory: TLabel;
    txtMaxHistory: TEdit;
    chkETInternal: TCheckBox;
    chkETAlias: TCheckBox;
    chkETPath: TCheckBox;
    chkETHistory: TCheckBox;
    btnStartPath: TButton;
    chkAutoHide: TCheckBox;
    txtAutoHide: TEdit;
    chkAutoReread: TCheckBox;
    txtAutoReread: TEdit;
    lblCmdParamClose: TLabel;
    txtCmdParamClose: TEdit;
    lblCmdParamNoclose: TLabel;
    txtCmdParamNoclose: TEdit;
    chkShowCenterX: TCheckBox;
    chkShowCenterY: TCheckBox;
    chkCase: TCheckBox;
    lblPriority: TLabel;
    boxPriority: TComboBox;
    chkExecSysAlias: TCheckBox;
    chkSaveSysAlias: TCheckBox;
    chkETSysAlias: TCheckBox;
    chkSaveSysAliasParam: TCheckBox;
    chkAddTo: TCheckBox;
    lblAliasPriori: TLabel;
    boxAliasPriori: TComboBox;
    optNoAutorun: TRadioButton;
    optAutostartLM: TRadioButton;
    optAutostartCU: TRadioButton;
    chkExecFile: TCheckBox;
    chkSpace: TCheckBox;
    boxLanguage: TComboBox;
    lblLanguage: TLabel;
    txtAuthor: TEdit;
    txtVersion: TEdit;
    lblAuthor: TLabel;
    lblVersion: TLabel;
    chkAutoSort: TCheckBox;
    chkRereadHotKey: TCheckBox;
    chkSaveInternalParam: TCheckBox;
    chkSaveInternal: TCheckBox;
    lblTextAlignment: TLabel;
    optAlignLeft: TRadioButton;
    optAlignCenter: TRadioButton;
    optAlignRight: TRadioButton;
    txtQuickSearch: TEdit;
    chkCreateOldFile: TCheckBox;
    chkConfirm: TCheckBox;
    btnCheckDeadAliases: TButton;
    chkStartCDA: TCheckBox;
    chkSearchFileCDA: TCheckBox;
    lblChecking: TLabel;
    spnConsoleX: TUpDown;
    spnConsoleY: TUpDown;
    spnConsoleWidth: TUpDown;
    spnConsoleHeight: TUpDown;
    spnBorderSize: TUpDown;
    spnMaxHistory: TUpDown;
    spnAutoReread: TUpDown;
    spnAutoHide: TUpDown;
    pbrCheckDA: TProgressBar;
    chkShowBalloonTips: TCheckBox;
    chkLockEnglish: TCheckBox;
    chkApplyEnglish: TCheckBox;
    fraPlugins: TGroupBox;
    lstPluginList: TListBox;
    lblPluginStatus: TLabel;
    lblPluginName: TLabel;
    txtPluginName: TEdit;
    lblPluginVersion: TLabel;
    txtPluginVersion: TEdit;
    lblPluginDescription: TLabel;
    lblPluginAuthor: TLabel;
    txtPluginAuthor: TEdit;
    lblPluginCopyright: TLabel;
    txtPluginCopyright: TEdit;
    lblPluginHomepage: TLabel;
    txtPluginHomepage: TEdit;
    btnPluginAdd: TButton;
    btnPluginDelete: TButton;
    chkETPlugins: TCheckBox;
    chkSavePlugins: TCheckBox;
    chkExecPlugins: TCheckBox;
    btnSelectPlugin: TButton;
    lblPluginPath: TLabel;
    txtPluginPath: TEdit;
    chkSearchPluginsCDA: TCheckBox;
    btnBackAllDA: TButton;
    chkEnableET: TCheckBox;
    chkAdvancedBackspace: TCheckBox;
    btnLoadPlugin: TButton;
    btnUnloadPlugin: TButton;
    chkLoadingPlugin: TCheckBox;
    boxETColor: TComboBox;
    chkPutMouseIntoConsole: TCheckBox;
    txtPluginDescription: TMemo;
    chkSaveCommandLine: TCheckBox;
    chkSaveMessage: TCheckBox;
    chkFontAutoSize: TCheckBox;
    treePluginStrings: TTreeView;
    chkAdvancedSpace: TCheckBox;
    txtAliasComment: TEdit;
    lblAliasComment: TLabel;
    lblHintTextColor: TLabel;
    shpHintTextColor: TShape;
    lblHintColor: TLabel;
    shpHintColor: TShape;
    chkInvertScroll: TCheckBox;
    lblDropdownTextColor: TLabel;
    lblDropdownColor: TLabel;
    shpDropdownColor: TShape;
    shpDropdownTextColor: TShape;
    chkSavePluginParam: TCheckBox;
    chkConsoleWidthPercent: TCheckBox;
    lblTransparent: TLabel;
    chkDestroyForm: TCheckBox;
    txtTransValue: TEdit;
    spnTransValue: TUpDown;
    fraHintPopup: TGroupBox;
    fraDropdownList: TGroupBox;
    chkShowHint: TCheckBox;
    lblDropdownLineNum: TLabel;
    txtDropDownLineCount: TEdit;
    spnDropDownLineCount: TUpDown;
    chkSaveHistoryPlugin: TCheckBox;
    chkExecUseDefaultAction: TCheckBox;
    chkDeleteDuplicate: TCheckBox;
    fraSounds: TGroupBox;
    chkEnableSounds: TCheckBox;
    lstSounds: TListBox;
    btnBrowseSound: TButton;
    txtSoundPath: TEdit;
    chkMultiUsers: TCheckBox;
    lblMultiUsers: TLabel;
    lstPluginAliases: TListBox;
    txtHintBorderSize: TEdit;
    spnHintBorderSize: TUpDown;
    lblHintBorderSize: TLabel;
    chkHintShowBorderOnly: TCheckBox;
    lblHintTransparent: TLabel;
    txtHintTransparent: TEdit;
    spnHintTransparent: TUpDown;
    lblHintBorderColor: TLabel;
    shpHintBorderColor: TShape;
    lblDropDownBorderColor: TLabel;
    shpDropdownBorderColor: TShape;
    lblDropdownBorderSize: TLabel;
    txtDropdownBorderSize: TEdit;
    spnDropdownBorderSize: TUpDown;
    spnDropdownTransparent: TUpDown;
    txtDropdownTransparent: TEdit;
    lblDropdownTransparent: TLabel;
    chkDropdownShowBorderOnly: TCheckBox;
    spnSortPlugins: TUpDown;
		procedure FormShow(Sender: TObject);
		procedure FormClose(Sender: TObject; var Action: TCloseAction);
		procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
		procedure lstSettingsClick(Sender: TObject);
		procedure shpTextColorMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
		procedure shpConsoleColorMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
		procedure shpBorderColorMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
		procedure btnFontClick(Sender: TObject);
		procedure optNoSaveHistoryClick(Sender: TObject);
		procedure optSaveHistoryClick(Sender: TObject);
		procedure btnClearHistoryClick(Sender: TObject);
		procedure btnBrowserClick(Sender: TObject);
		procedure btnFileManagerClick(Sender: TObject);
		procedure btnShellClick(Sender: TObject);
		procedure txtTransValueChange(Sender: TObject);
		procedure txtConsoleXChange(Sender: TObject);
		procedure txtConsoleYChange(Sender: TObject);
		procedure txtConsoleWidthChange(Sender: TObject);
		procedure txtConsoleHeightChange(Sender: TObject);
		procedure txtBorderSizeChange(Sender: TObject);
    procedure lstConfigClick(Sender: TObject);
    procedure txtAliasNameChange(Sender: TObject);
    procedure txtAliasActionChange(Sender: TObject);
    procedure txtAliasParamsChange(Sender: TObject);
    procedure txtAliasStartPathChange(Sender: TObject);
    procedure boxAliasStateChange(Sender: TObject);
    procedure boxAliasHistoryChange(Sender: TObject);
    procedure boxAliasMoveTopChange(Sender: TObject);
    procedure btnAliasActionClick(Sender: TObject);
    procedure btnApplyFullAliasClick(Sender: TObject);
    procedure btnAddAliasClick(Sender: TObject);
		procedure btnDeleteAliasClick(Sender: TObject);
    procedure spnConfigChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint;
      Direction: TUpDownDirection);
    procedure lstConfigMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure lstConfigMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure lstConfigMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure lstConfigKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure txtMaxHistoryChange(Sender: TObject);
    procedure lstConfigKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnStartPathClick(Sender: TObject);
    procedure txtAutoHideChange(Sender: TObject);
    procedure chkAutoHideClick(Sender: TObject);
    procedure txtAutoRereadChange(Sender: TObject);
    procedure chkAutoRereadClick(Sender: TObject);
    procedure chkShowCenterXClick(Sender: TObject);
    procedure chkShowCenterYClick(Sender: TObject);
    procedure boxAliasPrioriChange(Sender: TObject);
    procedure boxLanguageChange(Sender: TObject);
    procedure chkMoveTopClick(Sender: TObject);
    procedure chkAutoSortClick(Sender: TObject);
    procedure txtAliasNameKeyPress(Sender: TObject; var Key: Char);
    procedure txtQuickSearchChange(Sender: TObject);
    procedure lstConfigKeyPress(Sender: TObject; var Key: Char);
    procedure txtQuickSearchExit(Sender: TObject);
    procedure txtQuickSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCheckDeadAliasesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chkTrayIconClick(Sender: TObject);
    procedure chkShowBalloonTipsClick(Sender: TObject);
    procedure lstPluginListClick(Sender: TObject);
    procedure btnPluginAddClick(Sender: TObject);
    procedure btnPluginDeleteClick(Sender: TObject);
    procedure optNoTypeClick(Sender: TObject);
    procedure optEasyTypeClick(Sender: TObject);
    procedure optLinuxTypeClick(Sender: TObject);
    procedure btnSelectPluginClick(Sender: TObject);
    procedure btnBackAllDAClick(Sender: TObject);
    procedure btnLoadPluginClick(Sender: TObject);
    procedure btnUnloadPluginClick(Sender: TObject);
    procedure chkLoadingPluginClick(Sender: TObject);
    procedure boxETColorChange(Sender: TObject);
    procedure treePluginStringsExit(Sender: TObject);
    procedure treePluginStringsKeyPress(Sender: TObject; var Key: Char);
    procedure treePluginStringsDblClick(Sender: TObject);
    procedure txtAliasCommentChange(Sender: TObject);
		procedure shpHintTextColorMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
		procedure shpHintColorMoueDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
		procedure shpDropdownTextColorMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure shpDropdownColorMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure txtDropDownLineCountChange(Sender: TObject);
		procedure chkSaveHistoryPluginClick(Sender: TObject);
    procedure lstSoundsClick(Sender: TObject);
    procedure txtSoundPathChange(Sender: TObject);
    procedure btnBrowseSoundClick(Sender: TObject);
    procedure chkEnableSoundsClick(Sender: TObject);
    procedure txtQuickSearchKeyPress(Sender: TObject; var Key: Char);
    procedure lstPluginAliasesDblClick(Sender: TObject);
    procedure txtHintBorderSizeChange(Sender: TObject);
    procedure txtHintTransparentChange(Sender: TObject);
    procedure shpHintBorderColorMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure shpDropdownBorderColorMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure txtDropdownBorderSizeChange(Sender: TObject);
    procedure txtDropdownTransparentChange(Sender: TObject);
    procedure spnSortPluginsChangingEx(Sender: TObject;
      var AllowChange: Boolean; NewValue: Smallint;
      Direction: TUpDownDirection);
	private

	public

	end;

var
	frmSettings: TfrmSettings;
	dlgOpen: TOpenDialog; // Диалог для открытия файлов
	dlgFont: TFontDialog; // Диалог для выбора шрифта
	dlgColor: TColorDialog; // Диалог для выбора цвета
	TempColor: array[0..2] of TSettingsColor;
	IsEditor: boolean; // Если True, то показывается сразу editor
	NumEditor: integer; // Сразу нужный алиас в списке
	PathString: string; // Если не пустая, значит добавление из вне.
	TempConfigStr: TStringlist; // Временная переменная для редактирования конфига
	DragItem: integer; // Перетаскиваемый алиас мышкой

implementation

uses Static, ForAll, Plugins, frmConsoleUnit, StrUtils;

{$R *.dfm}

// Действия при показе формы
procedure TfrmSettings.FormShow(Sender: TObject);
begin
  // Убираем кнопку на таскбаре при показе формы
	ShowWindow(Application.Handle, SW_HIDE);

  // Заполнение настройками
	TempConfigStr:=TStringList.Create;
	TempColor[0]:=TSettingsColor.Create;
	TempColor[1]:=TSettingsColor.Create;
  TempColor[2]:=TSettingsColor.Create;

	FillSettings;

	// Переход на нужную настройку
  If IsEditor and not SearchDA then begin
    ShowFrame(16);
    if frmSettings.Visible and frmSettings.Enabled and frmSettings.lstConfig.Visible and frmSettings.lstConfig.Enabled and (lstConfig.Count>0) then lstConfig.SetFocus;
    IsEditor:=False;
  end
  else
    ShowFrame(0);

  // Настройка интерфейса редактирования конфига
  if not SearchDA then begin
    if lstConfig.Items.Count>0 then begin
      ShowEdit(True);
      GetEdit(NumEditor);
      GetFullEdit;
			SyncSpn(lstConfig.Items.Count+1);
			SyncPluginSpn(lstPluginList.Count+1);
    end
    else
      ShowEdit(False);
  end;

  // Если передана строка, то сразу создаем новый алиас
	if (PathString<>'') and not SearchDA then
		AddItem;
end;

// Выполняется при закрытии формы
procedure TfrmSettings.FormClose(Sender: TObject;
	var Action: TCloseAction);
begin
	TempConfigStr.Free;
	TempColor[0].Free;
  TempColor[1].Free;
  TempColor[2].Free;
  PathString:='';
  Action:=caFree;
  frmSettings:=nil;
end;

// Закрыть настройки без сохранения.
procedure TfrmSettings.btnCancelClick(Sender: TObject);
begin
	frmSettings.Close;
end;

// Форма закрывается с применением настроек
procedure TfrmSettings.btnOKClick(Sender: TObject);
begin
	Screen.Cursor:=crHourGlass;
	KeepSettings;
	Options.SaveSettings;
  Options.SaveRegSettings;
	if not SearchDA then SaveConfig(Program_Config);
	frmSettings.Close;
	ApplySettings;
	Screen.Cursor:=crDefault;
end;

// Применение настроек
procedure TfrmSettings.btnApplyClick(Sender: TObject);
var
	tmpMainListPos, tmpConfigListPos: integer;
begin
	Screen.Cursor:=crAppStart;
	tmpMainListPos:=lstSettings.ItemIndex;
	tmpConfigListPos:=0;
	if not SearchDA then tmpConfigListPos:=lstConfig.ItemIndex;
	KeepSettings;
	Options.SaveSettings;
  Options.SaveRegSettings;
	if not SearchDA then SaveConfig(Program_Config);
	ApplySettings;
	FillSettings;
	lstSettings.ItemIndex:=tmpMainListPos;

  // Настройка интерфейса редактирования конфига
  if not SearchDA then begin
		if lstConfig.Items.Count>0 then begin
			ShowEdit(True);
			GetEdit(tmpConfigListPos);
			GetFullEdit;
			SyncSpn(lstConfig.Items.Count+1);
			SyncPluginSpn(lstPluginList.Count+1);
		end
		else
			ShowEdit(False);
  end;

	Screen.Cursor:=crDefault;
end;

// Показать нужный фрейм
procedure TfrmSettings.lstSettingsClick(Sender: TObject);
begin
	ShowFrame(lstSettings.ItemIndex);
end;

// Смена цвета шрифта
procedure TfrmSettings.shpTextColorMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	dlgColor:=TColorDialog.Create(frmSettings);
	dlgColor.Color:=shpTextColor.Brush.Color;
	if dlgColor.Execute then begin
		shpTextColor.Brush.Color:=dlgColor.Color;
		TempColor[boxETColor.ItemIndex].Text:=shpTextColor.Brush.Color;
	end;
	dlgColor.Free;
end;

// Смена цвета консоли
procedure TfrmSettings.shpConsoleColorMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	dlgColor:=TColorDialog.Create(frmSettings);
	dlgColor.Color:=shpConsoleColor.Brush.Color;
	if dlgColor.Execute then begin
		shpConsoleColor.Brush.Color:=dlgColor.Color;
    TempColor[boxETColor.ItemIndex].Console:=shpConsoleColor.Brush.Color;
	end;
	dlgColor.Free;
end;

// Смена цвета рамки
procedure TfrmSettings.shpBorderColorMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	dlgColor:=TColorDialog.Create(frmSettings);
	dlgColor.Color:=shpBorderColor.Brush.Color;
	if dlgColor.Execute then begin
		shpBorderColor.Brush.Color:=dlgColor.Color;
    TempColor[boxETColor.ItemIndex].Border:=shpBorderColor.Brush.Color;
	end;
	dlgColor.Free;
end;

// Смена шрифта
procedure TfrmSettings.btnFontClick(Sender: TObject);
begin
	dlgFont:=TFontDialog.Create(frmSettings);
	dlgFont.Font:=lblFont.Font;
	if dlgFont.Execute then begin
		lblFont.Font:=dlgFont.Font;
		lblFont.Font.Color:=clWindowText;
		lblFont.Caption:=dlgFont.Font.Name+', '+IntToStr(dlgFont.Font.Size);
	end;
	dlgFont.Free;
end;

// Показ или скрытие дополнительных настроек
procedure TfrmSettings.optNoSaveHistoryClick(Sender: TObject);
begin
  chkSaveInternal.Enabled:=optSaveHistory.Checked;
  chkSaveInternalParam.Enabled:=optSaveHistory.Checked;
	chkSaveAlias.Enabled:=optSaveHistory.Checked;
	chkSaveAliasParam.Enabled:=optSaveHistory.Checked;
	chkSaveSysAlias.Enabled:=optSaveHistory.Checked;
	chkSaveSysAliasParam.Enabled:=optSaveHistory.Checked;
	chkSaveWWW.Enabled:=optSaveHistory.Checked;
	chkSaveEMail.Enabled:=optSaveHistory.Checked;
	chkSaveFolder.Enabled:=optSaveHistory.Checked;
	chkSaveShell.Enabled:=optSaveHistory.Checked;
	chkSavePlugins.Enabled:=optSaveHistory.Checked;
	chkSavePluginParam.Enabled:=optSaveHistory.Checked;
	chkSaveCommandLine.Enabled:=optSaveHistory.Checked;
	chkSaveMessage.Enabled:=optSaveHistory.Checked;
	lblMaxHistory.Enabled:=optSaveHistory.Checked;
	txtMaxHistory.Enabled:=optSaveHistory.Checked;
	spnMaxHistory.Enabled:=optSaveHistory.Checked;
	chkInvertScroll.Enabled:=optSaveHistory.Checked;
end;

// Показ или скрытие дополнительных настроек
procedure TfrmSettings.optSaveHistoryClick(Sender: TObject);
begin
	chkSaveInternal.Enabled:=optSaveHistory.Checked;
	chkSaveInternalParam.Enabled:=optSaveHistory.Checked;
	chkSaveAlias.Enabled:=optSaveHistory.Checked;
	chkSaveAliasParam.Enabled:=optSaveHistory.Checked;
	chkSaveSysAlias.Enabled:=optSaveHistory.Checked;
	chkSaveSysAliasParam.Enabled:=optSaveHistory.Checked;
	chkSaveWWW.Enabled:=optSaveHistory.Checked;
	chkSaveEMail.Enabled:=optSaveHistory.Checked;
	chkSaveFolder.Enabled:=optSaveHistory.Checked;
	chkSaveShell.Enabled:=optSaveHistory.Checked;
	chkSavePlugins.Enabled:=optSaveHistory.Checked;
	chkSavePluginParam.Enabled:=optSaveHistory.Checked;
	chkSaveCommandLine.Enabled:=optSaveHistory.Checked;
	chkSaveMessage.Enabled:=optSaveHistory.Checked;
	lblMaxHistory.Enabled:=optSaveHistory.Checked;
	txtMaxHistory.Enabled:=optSaveHistory.Checked;
	spnMaxHistory.Enabled:=optSaveHistory.Checked;
	chkInvertScroll.Enabled:=optSaveHistory.Checked;
end;

// Очистка истории
procedure TfrmSettings.btnClearHistoryClick(Sender: TObject);
begin
	HistoryStr.Clear;
	SaveHistory(Program_History);
	ReadHistory(Program_History);
  frmSettings.btnClearHistory.Caption:=GetLangStr('clearhistory')+' '+IntToStr(HistoryStr.Count)+' '+GetLangStr('clearhistory2');
  frmSettings.btnClearHistory.Enabled:=(HistoryStr.Count>0);
end;

// Выбор браузера
procedure TfrmSettings.btnBrowserClick(Sender: TObject);
begin
	dlgOpen:=TOpenDialog.Create(frmSettings);
	dlgOpen.Options:=[ofNoChangeDir, ofPathMustExist, ofFileMustExist, ofShareAware, ofNoDereferenceLinks,  ofEnableSizing, ofForceShowHidden];
	dlgOpen.Filter:=GetLangStr('allfiles')+' (*.*)|*.*';
	dlgOpen.InitialDir:=GetProgPath(txtBrowser.Text);
	if dlgOpen.Execute then begin
  	if(StrPos(PChar(dlgOpen.FileName), ' ') <> nil) then begin
			txtBrowser.Text:='"' + dlgOpen.FileName + '"';
    end
    else begin
			txtBrowser.Text:=dlgOpen.FileName;
    end;
	end;
	dlgOpen.Free;
end;

// Выбор файлового менеджера
procedure TfrmSettings.btnFileManagerClick(Sender: TObject);
begin
	dlgOpen:=TOpenDialog.Create(frmSettings);
	dlgOpen.Options:=[ofNoChangeDir, ofPathMustExist, ofFileMustExist, ofShareAware, ofNoDereferenceLinks,  ofEnableSizing, ofForceShowHidden];
	dlgOpen.Filter:=GetLangStr('allfiles')+' (*.*)|*.*';
	dlgOpen.InitialDir:=GetProgPath(txtFileManager.Text);
	if dlgOpen.Execute then begin
    if(StrPos(PChar(dlgOpen.FileName), ' ') <> nil) then begin
      txtFileManager.Text:='"' + dlgOpen.FileName + '"';
    end
    else begin
			txtFileManager.Text:=dlgOpen.FileName;
    end;
	end;
	dlgOpen.Free;
end;

// Выбор обработчика командной строки
procedure TfrmSettings.btnShellClick(Sender: TObject);
begin
	dlgOpen:=TOpenDialog.Create(frmSettings);
	dlgOpen.Options:=[ofNoChangeDir, ofPathMustExist, ofFileMustExist, ofShareAware, ofNoDereferenceLinks,  ofEnableSizing, ofForceShowHidden];
	dlgOpen.Filter:=GetLangStr('allfiles')+' (*.*)|*.*';
	dlgOpen.InitialDir:=GetProgPath(txtShell.Text);
	if dlgOpen.Execute then begin
    if(StrPos(PChar(dlgOpen.FileName), ' ') <> nil) then begin
      txtShell.Text:='"' + dlgOpen.FileName + '"';
    end
    else begin
			txtShell.Text:=dlgOpen.FileName;
    end;
	end;
	dlgOpen.Free;
end;

// Синхронизация скроллера и текстового поля
procedure TfrmSettings.txtTransValueChange(Sender: TObject);
begin
	SyncUpDown(txtTransValue, spnTransValue);
end;

// Синхронизация скроллера и текстового поля
procedure TfrmSettings.txtConsoleXChange(Sender: TObject);
begin
  SyncUpDown(txtConsoleX, spnConsoleX);
end;

// Синхронизация скроллера и текстового поля
procedure TfrmSettings.txtConsoleYChange(Sender: TObject);
begin
  SyncUpDown(txtConsoleY, spnConsoleY);
end;

// Синхронизация скроллера и текстового поля
procedure TfrmSettings.txtConsoleWidthChange(Sender: TObject);
begin
	SyncUpDown(txtConsoleWidth, spnConsoleWidth);
end;

// Синхронизация скроллера и текстового поля
procedure TfrmSettings.txtConsoleHeightChange(Sender: TObject);
begin
	SyncUpDown(txtConsoleHeight, spnConsoleHeight);
end;

// Синхронизация скроллера и текстового поля
procedure TfrmSettings.txtBorderSizeChange(Sender: TObject);
begin
	SyncUpDown(txtBorderSize, spnBorderSize);
end;

// Выбор пункта в конфиге
procedure TfrmSettings.lstConfigClick(Sender: TObject);
begin
	GetEdit(lstConfig.ItemIndex);
	GetFullEdit;
end;

// Изменение названия алиаса
procedure TfrmSettings.txtAliasNameChange(Sender: TObject);
begin
	lstConfig.Items[lstConfig.ItemIndex]:=txtAliasName.Text;
	SetEdit(lstConfig.ItemIndex, 'alias');
	GetFullEdit;
end;

// Изменение действия алиаса
procedure TfrmSettings.txtAliasActionChange(Sender: TObject);
begin
	SetEdit(lstConfig.ItemIndex, 'action');
	GetFullEdit;
end;

// Изменение параметров алиаса
procedure TfrmSettings.txtAliasParamsChange(Sender: TObject);
begin
	SetEdit(lstConfig.ItemIndex, 'param');
	GetFullEdit;
end;

// Изменение стартового пути алиаса
procedure TfrmSettings.txtAliasStartPathChange(Sender: TObject);
begin
	SetEdit(lstConfig.ItemIndex, 'dir');
	GetFullEdit;
end;

// Изменение состояния окна
procedure TfrmSettings.boxAliasStateChange(Sender: TObject);
begin
	SetEdit(lstConfig.ItemIndex, 'state');
	GetFullEdit;
end;

// Изменение параметров сохранения истории
procedure TfrmSettings.boxAliasHistoryChange(Sender: TObject);
begin
	SetEdit(lstConfig.ItemIndex, 'history');
	GetFullEdit;
end;

// Изменение параметров кидания алиаса вверх конфига
procedure TfrmSettings.boxAliasMoveTopChange(Sender: TObject);
begin
	SetEdit(lstConfig.ItemIndex, 'top');
	GetFullEdit;
end;

// Выбор действия алиаса из диалогового окна
procedure TfrmSettings.btnAliasActionClick(Sender: TObject);
begin
	dlgOpen:=TOpenDialog.Create(frmSettings);
  dlgOpen.Options:=[ofNoChangeDir, ofPathMustExist, ofFileMustExist, ofShareAware, ofNoDereferenceLinks,  ofEnableSizing, ofForceShowHidden];
	dlgOpen.Filter:=GetLangStr('allfiles')+' (*.*)|*.*|'+GetLangStr('exefiles')+' (*.exe;*.com;*.cmd;*.bat;*.lnk;*.pif)|*.exe;*.com;*.cmd;*.bat;*.lnk;*.pif';
	dlgOpen.Title:=GetLangStr('selectfile');
	dlgOpen.InitialDir:=GetProgPath(txtAliasAction.Text);
	if dlgOpen.Execute then begin
		if (((txtAliasName.Text='alias_name') or (txtAliasName.Text=AnsiReplaceStr(Copy(ExtractFileName(txtAliasAction.Text), 1, Length(ExtractFileName(txtAliasAction.Text))-Length(ExtractFileExt(txtAliasAction.Text))), ' ', '_'))) and (txtAliasName.Text<>txtAliasAction.Text)) then
			txtAliasName.Text:=AnsiReplaceStr(Copy(ExtractFileName(dlgOpen.FileName), 1, Length(ExtractFileName(dlgOpen.FileName))-Length(ExtractFileExt(dlgOpen.FileName))), ' ', '_');
		txtAliasAction.Text:=dlgOpen.FileName;
	end;
	dlgOpen.Free;
end;

// Выбор страртового пути из диалогового окна
procedure TfrmSettings.btnStartPathClick(Sender: TObject);
var
	lpItemID: PItemIDList;
	BrowseInfo: TBrowseInfo;
	DisplayName: array[0..MAX_PATH] of char;
	TempPath: array[0..MAX_PATH] of char;
begin
	FillChar(BrowseInfo, sizeof(TBrowseInfo), #0);
	BrowseInfo.hwndOwner:=frmSettings.Handle;
	BrowseInfo.pszDisplayName:=@DisplayName;
	BrowseInfo.lpszTitle:= PChar(GetLangStr('selectdirectory'));
	BrowseInfo.ulFlags:=BIF_RETURNONLYFSDIRS{ or BIF_BROWSEINCLUDEFILES};
	lpItemID:=SHBrowseForFolder(BrowseInfo);
	if lpItemId<>nil then begin
		SHGetPathFromIDList(lpItemID, TempPath);
    txtAliasStartPath.Text:=TempPath;
    if Length(txtAliasStartPath.Text)>3 then
    	txtAliasStartPath.Text:=txtAliasStartPath.Text+'\';
		GlobalFreePtr(lpItemID);
	end;
end;

// Прямое редактирование алиаса
procedure TfrmSettings.btnApplyFullAliasClick(Sender: TObject);
begin
	TempConfigStr.Strings[lstConfig.ItemIndex]:=txtFullAlias.Text;
	GetEdit(lstConfig.ItemIndex);
end;

// Добавление нового алиаса
procedure TfrmSettings.btnAddAliasClick(Sender: TObject);
begin
	AddItem;
end;

// Удаление алиаса
procedure TfrmSettings.btnDeleteAliasClick(Sender: TObject);
begin
	DelItem(lstConfig.ItemIndex);
end;

// Перемещение алиасов с помощью кнопок
procedure TfrmSettings.spnConfigChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint;
	Direction: TUpDownDirection);
begin
	if (NewValue>-1) and (NewValue<TempConfigStr.Count) then
		MoveItem(lstConfig.ItemIndex, NewValue);
end;

// Начало перетаскивания алиаса мышкой
procedure TfrmSettings.lstConfigMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	DragItem:=lstConfig.ItemIndex;
end;

// Конец перетаскивания алиаса мышкой
procedure TfrmSettings.lstConfigMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	DragItem:=-1;
end;

// Перетаскивание алиаса мышкой
procedure TfrmSettings.lstConfigMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
	FinishItem: integer;
begin
	if (DragItem<>-1) then begin
  	FinishItem:=lstConfig.ItemIndex;
		if (DragItem<>FinishItem) then begin
      MoveItem(DragItem, FinishItem);
	    DragItem:=FinishItem;
    end;
  end;
end;

// Нажатие клавиш на поле конфига
procedure TfrmSettings.lstConfigKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
	// Insert
	if (Key=45) then
  	AddItem
	// Delete
	else if ((Key=46) and (btnDeleteAlias.Visible)) then
  	DelItem(lstConfig.ItemIndex)
	// Зажат Shift
	else if (Key=VK_CONTROL) then
	  DragItem:=lstConfig.ItemIndex
	// Вверх
	else if (Key=38) then begin
		if (DragItem>0) then begin
			DragItem:=lstConfig.ItemIndex-1;
			MoveItem(DragItem+1, DragItem);
			lstConfig.ItemIndex:=DragItem+1;
		end;
	end
	// Вниз
	else if (Key=40) then begin
		if ((DragItem<>-1) and (DragItem<>lstConfig.Count-1)) then begin
			DragItem:=lstConfig.ItemIndex+1;
			MoveItem(DragItem-1, DragItem);
			lstConfig.ItemIndex:=DragItem-1;
		end;
	end
	// Home
	else if (Key=36) then begin
		if (DragItem>0) then begin
			MoveItem(DragItem, 0);
			DragItem:=0;
		end;
	end
	// End
	else if (Key=35) then begin
		if ((DragItem<>-1) and (DragItem<>lstConfig.Count-1)) then begin
			MoveItem(DragItem, lstConfig.Count-1);
			DragItem:=lstConfig.Count-1;
		end;
	end
end;

// Синхронизация скроллера и текстового поля
procedure TfrmSettings.txtMaxHistoryChange(Sender: TObject);
begin
  SyncUpDown(txtMaxHistory, spnMaxHistory);
end;

// Отжимание кнопки Ctrl в листе алиасов
procedure TfrmSettings.lstConfigKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
	if Key=VK_CONTROL then DragItem:=-1;
end;

// Синхронизация скроллера и текстового поля
procedure TfrmSettings.txtAutoHideChange(Sender: TObject);
begin
	SyncUpDown(txtAutoHide, spnAutoHide);
end;

// Показ или скрытие дополнительных настроек
procedure TfrmSettings.chkAutoHideClick(Sender: TObject);
begin
	txtAutoHide.Enabled:=chkAutoHide.Checked;
	spnAutoHide.Enabled:=chkAutoHide.Checked;
end;

// Синхронизация скроллера и текстового поля
procedure TfrmSettings.txtAutoRereadChange(Sender: TObject);
begin
	SyncUpDown(txtAutoReread, spnAutoReread);
end;

// Показ или скрытие дополнительных настроек
procedure TfrmSettings.chkAutoRereadClick(Sender: TObject);
begin
	txtAutoReread.Enabled:=chkAutoReread.Checked;
	spnAutoReread.Enabled:=chkAutoReread.Checked;
end;

// Показ или скрытие дополнительных настроек
procedure TfrmSettings.chkShowCenterXClick(Sender: TObject);
begin
	txtConsoleX.Enabled:=not chkShowCenterX.Checked;
	spnConsoleX.Enabled:=not chkShowCenterX.Checked;
end;

// Показ или скрытие дополнительных настроек
procedure TfrmSettings.chkShowCenterYClick(Sender: TObject);
begin
	txtConsoleY.Enabled:=not chkShowCenterY.Checked;
	spnConsoleY.Enabled:=not chkShowCenterY.Checked;
end;

// Изменение приоритета программы
procedure TfrmSettings.boxAliasPrioriChange(Sender: TObject);
begin
	SetEdit(lstConfig.ItemIndex, 'priori');
	GetFullEdit;
end;

// Выбор языка
procedure TfrmSettings.boxLanguageChange(Sender: TObject);
var
	tmpStr: TStringList;
begin
	tmpStr:=TStringList.Create;
  tmpStr.LoadFromFile(GetMyPath+'Lang\'+boxLanguage.Text+'.lng');
	txtAuthor.Text:=GetNumWord(tmpStr.Strings[0], ' = ', 2);
  txtVersion.Text:=GetNumWord(tmpStr.Strings[1], ' = ', 2);
  tmpStr.Free;
end;

// Показ или скрытие взаимоисключающих настроек
procedure TfrmSettings.chkMoveTopClick(Sender: TObject);
begin
	if chkMoveTop.Checked then chkAutoSort.Checked:=False;
end;

// Показ или скрытие взаимоисключающих настроек
procedure TfrmSettings.chkAutoSortClick(Sender: TObject);
begin
	if chkAutoSort.Checked then chkMoveTop.Checked:=False;
end;

// Запрещаем вводить пробелы
procedure TfrmSettings.txtAliasNameKeyPress(Sender: TObject;
  var Key: Char);
begin
	If Key=#32 then
  	Key:=#0;
end;

// Быстрый сик на алиас
procedure TfrmSettings.txtQuickSearchChange(Sender: TObject);
var
	i: integer;
begin
	if txtQuickSearch.Text<>'' then begin
    for i:=0 to TempConfigStr.Count-1 do begin
      if(AnsiLowerCase(txtQuickSearch.Text)=AnsiLowerCase(Copy(lstConfig.Items.Strings[i], 0, Length(txtQuickSearch.Text)))) then begin
        lstConfig.ItemIndex:=i;
       	GetEdit(lstConfig.ItemIndex);
				GetFullEdit;
        break;
      end;
    end;
  end;
end;

// Переход на сик
procedure TfrmSettings.lstConfigKeyPress(Sender: TObject; var Key: Char);
begin
  frmSettings.btnCancel.Cancel:=False;
  lstConfig.Height:=357;
  txtQuickSearch.Visible:=True;
  if frmSettings.Visible and frmSettings.Enabled and frmSettings.txtQuickSearch.Visible and frmSettings.txtQuickSearch.Enabled then txtQuickSearch.SetFocus;
	txtQuickSearch.Text:=Key;
  txtQuickSearch.SelStart:=Length(txtQuickSearch.Text);
  Key:=#0;
end;

// При выходе из сика очищать
procedure TfrmSettings.txtQuickSearchExit(Sender: TObject);
begin
	txtQuickSearch.Clear;
  txtQuickSearch.Visible:=False;
	lstConfig.Height:=383;
	frmSettings.btnCancel.Cancel:=True;
end;

// Вверх или вниз - возврат в лист алиасов
procedure TfrmSettings.txtQuickSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
	i, tmp: integer;
begin
	tmp:=lstConfig.ItemIndex;
	if Key=38 then  begin // вверх
		Key:=0;
		if txtQuickSearch.Text<>'' then begin
			for i:=tmp-1 downto 0 do begin
				if(AnsiLowerCase(txtQuickSearch.Text)=AnsiLowerCase(Copy(lstConfig.Items.Strings[i], 0, Length(txtQuickSearch.Text)))) then begin
					lstConfig.ItemIndex:=i;
					GetEdit(lstConfig.ItemIndex);
					GetFullEdit;
					break;
				end;
			end;
		end;
	end;
	if Key=40 then begin // вниз
		Key:=0;
		if txtQuickSearch.Text<>'' then begin
			for i:=tmp+1 to TempConfigStr.Count-1 do begin
				if(AnsiLowerCase(txtQuickSearch.Text)=AnsiLowerCase(Copy(lstConfig.Items.Strings[i], 0, Length(txtQuickSearch.Text)))) then begin
					lstConfig.ItemIndex:=i;
					GetEdit(lstConfig.ItemIndex);
					GetFullEdit;
					break;
				end;
			end;
		end;
	end;
end;

// Вызывает проверку на мертвые алиасы
procedure TfrmSettings.btnCheckDeadAliasesClick(Sender: TObject);
begin
	KeepSettings;
  CheckDeadAliases;
end;

// Инициализация настроек при создании формы
procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  lstConfig.Height:=383;
end;

// Показ или скрытие взаимоисключающих настроек
procedure TfrmSettings.chkTrayIconClick(Sender: TObject);
begin
  if chkTrayIcon.Checked then chkShowBalloonTips.Checked:=False;
end;

// Показ или скрытие взаимоисключающих настроек
procedure TfrmSettings.chkShowBalloonTipsClick(Sender: TObject);
begin
  if chkShowBalloonTips.Checked then chkTrayIcon.Checked:=True;
end;

// Показывает инфо по конкретному элементу
procedure TfrmSettings.lstPluginListClick(Sender: TObject);
begin
  ApplyPluginShow(lstPluginList.ItemIndex);
end;

// Показ или скрытие взаимоисключающих настроек
procedure TfrmSettings.optNoTypeClick(Sender: TObject);
begin
  chkETInternal.Enabled:=not optNoType.Checked;
  chkETAlias.Enabled:=not optNoType.Checked;
  chkETPath.Enabled:=not optNoType.Checked;
  chkETHistory.Enabled:=not optNoType.Checked;
  chkETSysAlias.Enabled:=not optNoType.Checked;
  chkETPlugins.Enabled:=not optNoType.Checked;
  chkSpace.Enabled:=not optNoType.Checked;
end;

// Показ или скрытие взаимоисключающих настроек
procedure TfrmSettings.optEasyTypeClick(Sender: TObject);
begin
  chkETInternal.Enabled:=not optNoType.Checked;
  chkETAlias.Enabled:=not optNoType.Checked;
  chkETPath.Enabled:=not optNoType.Checked;
  chkETHistory.Enabled:=not optNoType.Checked;
  chkETSysAlias.Enabled:=not optNoType.Checked;
  chkETPlugins.Enabled:=not optNoType.Checked;
  chkSpace.Enabled:=not optNoType.Checked;
end;

// Показ или скрытие взаимоисключающих настроек
procedure TfrmSettings.optLinuxTypeClick(Sender: TObject);
begin
  chkETInternal.Enabled:=not optNoType.Checked;
  chkETAlias.Enabled:=not optNoType.Checked;
  chkETPath.Enabled:=not optNoType.Checked;
  chkETHistory.Enabled:=not optNoType.Checked;
  chkETSysAlias.Enabled:=not optNoType.Checked;
  chkETPlugins.Enabled:=not optNoType.Checked;
  chkSpace.Enabled:=not optNoType.Checked;
end;

// Добавление плагина
procedure TfrmSettings.btnPluginAddClick(Sender: TObject);
begin
  AddPlugin;
end;

// Удаление плагина
procedure TfrmSettings.btnPluginDeleteClick(Sender: TObject);
begin
  DeletePlugin(lstPluginList.ItemIndex);
end;

// Выбор действия плагина из списка
procedure TfrmSettings.btnSelectPluginClick(Sender: TObject);
var
  i, j, counter: integer;
begin
  treePluginStrings.Left:=160;
  treePluginStrings.Top:=112;
  treePluginStrings.Width:=325;
  treePluginStrings.Height:=277;
  treePluginStrings.Items.Clear;
  counter:=0;
  for i:=0 to High(PluginDll) do begin
    if PluginDll[i].Loaded then begin
      treePluginStrings.Items.Add(nil, PluginDll[i].Name);
      counter:=counter+1;
      for j:=0 to PluginDll[i].GetCount-1 do begin
        treePluginStrings.Items.AddChild(treePluginStrings.Items.Item[counter-1], PluginDll[i].GetString(j));
        if j=PluginDll[i].GetCount-1 then
          counter:=counter+j+1;
      end;
    end;
  end;
  treePluginStrings.Visible:=not treePluginStrings.Visible;
  if frmSettings.Visible and frmSettings.Enabled and treePluginStrings.Visible and treePluginStrings.Enabled then treePluginStrings.SetFocus;
  btnOK.Default:=False;
end;
                                                  		
// Возврат удаленных алиасов
procedure TfrmSettings.btnBackAllDAClick(Sender: TObject);
begin
	KeepSettings;
	ReturnDeadAliases;
end;

// Загружает плагин
procedure TfrmSettings.btnLoadPluginClick(Sender: TObject);
begin
	PluginDll[lstPluginList.ItemIndex].Load;
	ApplyPluginShow(lstPluginList.ItemIndex);
	frmSettings.btnSelectPlugin.Enabled:=(PluginAliasCount>0);
	if btnUnloadPlugin.Visible then
  	if frmSettings.Visible and frmSettings.Enabled and frmSettings.btnUnloadPlugin.Visible and frmSettings.btnUnloadPlugin.Enabled then btnUnloadPlugin.SetFocus;
end;

// Выгружает плагин
procedure TfrmSettings.btnUnloadPluginClick(Sender: TObject);
begin
	PluginDll[lstPluginList.ItemIndex].Unload;
	ApplyPluginShow(lstPluginList.ItemIndex);
	frmSettings.btnSelectPlugin.Enabled:=(PluginAliasCount>0);
	if btnLoadPlugin.Visible then
  	if frmSettings.Visible and frmSettings.Enabled and frmSettings.btnLoadPlugin.Visible and frmSettings.btnLoadPlugin.Enabled then btnLoadPlugin.SetFocus;
end;

// Загружать ли плагин при старте программы
procedure TfrmSettings.chkLoadingPluginClick(Sender: TObject);
begin
	PluginDll[lstPluginList.ItemIndex].Loading:=chkLoadingPlugin.Checked;
end;

// Синхронизация цветов
procedure TfrmSettings.boxETColorChange(Sender: TObject);
begin
	shpTextColor.Brush.Color:=TempColor[boxETColor.ItemIndex].Text;
	shpConsoleColor.Brush.Color:=TempColor[boxETColor.ItemIndex].Console;
	shpBorderColor.Brush.Color:=TempColor[boxETColor.ItemIndex].Border;
	shpHintTextColor.Brush.Color:=TempColor[boxETColor.ItemIndex].HintText;
	shpHintColor.Brush.Color:=TempColor[boxETColor.ItemIndex].HintColor;
	shpHintBorderColor.Brush.Color:=TempColor[boxETColor.ItemIndex].HintBorder;
	shpDropdownTextColor.Brush.Color:=TempColor[boxETColor.ItemIndex].DropDownText;
	shpDropdownColor.Brush.Color:=TempColor[boxETColor.ItemIndex].DropDownColor;
	shpDropdownBorderColor.Brush.Color:=TempColor[boxETColor.ItemIndex].DropDownBorder;
end;

// Если список строк плагина теряет фокус, то он скрывается
procedure TfrmSettings.treePluginStringsExit(Sender: TObject);
begin
  treePluginStrings.Hide;
  btnOK.Default:=True;
  if frmSettings.Visible and frmSettings.Enabled and frmSettings.txtAliasAction.Visible and frmSettings.txtAliasAction.Enabled then txtAliasAction.SetFocus;
end;

// Если из списка строк плагина выбрано действие, то он скрывается
procedure TfrmSettings.treePluginStringsKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key=#13 then begin
    Key:=#0;
    if treePluginStrings.Selected.Level=0 then begin
	    if treePluginStrings.Selected.Expanded then
      	treePluginStrings.Selected.Collapse(false)
      else
	      treePluginStrings.Selected.Expand(false);
    end;
    if treePluginStrings.Selected.Level=1 then begin
      txtAliasAction.Text:=treePluginStrings.Selected.Text;
      treePluginStrings.Hide;
      btnOK.Default:=True;
      if frmSettings.Visible and frmSettings.Enabled and frmSettings.txtAliasAction.Visible and frmSettings.txtAliasAction.Enabled then txtAliasAction.SetFocus;
    end;
  end;
end;

// Если из списка строк плагина выбрано действие, то он скрывается
procedure TfrmSettings.treePluginStringsDblClick(Sender: TObject);
begin
  if treePluginStrings.Selected.Level=1 then begin
    txtAliasAction.Text:=treePluginStrings.Selected.Text;
    treePluginStrings.Hide;
    btnOK.Default:=True;
    if frmSettings.Visible and frmSettings.Enabled and frmSettings.txtAliasAction.Visible and frmSettings.txtAliasAction.Enabled then txtAliasAction.SetFocus;
  end;
end;

procedure TfrmSettings.txtAliasCommentChange(Sender: TObject);
begin
	SetEdit(lstConfig.ItemIndex, 'comment');
	GetFullEdit;
end;

// Смена цвета шрифта подсказки
procedure TfrmSettings.shpHintTextColorMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	dlgColor:=TColorDialog.Create(frmSettings);
	dlgColor.Color:=shpHintTextColor.Brush.Color;
	if dlgColor.Execute then begin
		shpHintTextColor.Brush.Color:=dlgColor.Color;
    TempColor[boxETColor.ItemIndex].HintText:=shpHintTextColor.Brush.Color;
	end;
	dlgColor.Free;
end;

// Смена цвета фона подсказки
procedure TfrmSettings.shpHintColorMoueDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	dlgColor:=TColorDialog.Create(frmSettings);
	dlgColor.Color:=shpHintColor.Brush.Color;
	if dlgColor.Execute then begin
		shpHintColor.Brush.Color:=dlgColor.Color;
		TempColor[boxETColor.ItemIndex].HintColor:=shpHintColor.Brush.Color;
	end;
	dlgColor.Free;
end;

// Смена цвета текста выпадающего листа с дополнениями
procedure TfrmSettings.shpDropdownTextColorMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	dlgColor:=TColorDialog.Create(frmSettings);
	dlgColor.Color:=shpDropdownTextColor.Brush.Color;
	if dlgColor.Execute then begin
		shpDropdownTextColor.Brush.Color:=dlgColor.Color;
		TempColor[boxETColor.ItemIndex].DropDownText:=shpDropdownTextColor.Brush.Color;
	end;
	dlgColor.Free;
end;

// Смена цвета фона выпадающего листа с дополнениями
procedure TfrmSettings.shpDropdownColorMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	dlgColor:=TColorDialog.Create(frmSettings);
	dlgColor.Color:=shpDropdownColor.Brush.Color;
	if dlgColor.Execute then begin
		shpDropdownColor.Brush.Color:=dlgColor.Color;
    TempColor[boxETColor.ItemIndex].DropDownColor:=shpDropdownColor.Brush.Color;
	end;
	dlgColor.Free;
end;

// Изменение числа линий
procedure TfrmSettings.txtDropDownLineCountChange(Sender: TObject);
begin
	SyncUpDown(txtDropDownLineCount, spnDropDownLineCount);
end;

// Сохранение истории для плагинов
procedure TfrmSettings.chkSaveHistoryPluginClick(Sender: TObject);
begin
	PluginDll[lstPluginList.ItemIndex].SaveHistory:=chkSaveHistoryPlugin.Checked;
end;

// Выбор звука
procedure TfrmSettings.lstSoundsClick(Sender: TObject);
begin
	txtSoundPath.Text:=Options.Sounds.ListSounds.Strings[lstSounds.ItemIndex];
end;

// Смена звука вручную
procedure TfrmSettings.txtSoundPathChange(Sender: TObject);
begin
	Options.Sounds.ListSounds.Strings[lstSounds.ItemIndex]:=txtSoundPath.Text;
end;

// Смена звука через обзор
procedure TfrmSettings.btnBrowseSoundClick(Sender: TObject);
var
	tmpStr: string;
begin
	dlgOpen:=TOpenDialog.Create(frmSettings);
  dlgOpen.Options:=[ofNoChangeDir, ofPathMustExist, ofFileMustExist, ofShareAware, ofNoDereferenceLinks,  ofEnableSizing, ofForceShowHidden];
	dlgOpen.Filter:=GetLangStr('allfiles')+' (*.*)|*.*|'+GetLangStr('wavfiles')+' (*.wav)|*.wav';
	dlgOpen.Title:=GetLangStr('selectfile');
	if DirectoryExists(GetProgPath(txtSoundPath.Text)) then
		dlgOpen.InitialDir:=GetProgPath(txtSoundPath.Text)
	else if DirectoryExists(GetMyPath + GetProgPath(txtSoundPath.Text)) then
		dlgOpen.InitialDir:=GetMyPath + GetProgPath(txtSoundPath.Text)
	else
    dlgOpen.InitialDir:=GetMyPath;
	if dlgOpen.Execute then begin
		if FileExists(dlgOpen.FileName) then begin
			if GetMyPath=Copy(dlgOpen.FileName, 0, Length(GetMyPath)) then begin
				tmpStr:=dlgOpen.FileName;
				Delete(tmpStr, 1, Length(GetMyPath));
			end
			else
				tmpStr:=dlgOpen.FileName;
		end
		else
			tmpStr:=GetMyPath+dlgOpen.FileName;
		txtSoundPath.Text:=tmpStr;
	end;
	dlgOpen.Free;
end;

// Включает\выключает звук в программе
procedure TfrmSettings.chkEnableSoundsClick(Sender: TObject);
begin
	lstSounds.Enabled:=chkEnableSounds.Checked;
	txtSoundPath.Enabled:=chkEnableSounds.Checked;
	btnBrowseSound.Enabled:=chkEnableSounds.Checked;
end;

// Escape в сике
procedure TfrmSettings.txtQuickSearchKeyPress(Sender: TObject; var Key: Char);
begin
	if Key=#27 then begin
		lstConfig.SetFocus;
		Key:=#0;
	end;
end;

// Запуск алиаса из плагина кликом
procedure TfrmSettings.lstPluginAliasesDblClick(Sender: TObject);
begin
	ExecPlugin(lstPluginList.ItemIndex, lstPluginAliases.Items.Strings[lstPluginAliases.ItemIndex]);
end;

// Синхронизация
procedure TfrmSettings.txtHintBorderSizeChange(Sender: TObject);
begin
	SyncUpDown(txtHintBorderSize, spnHintBorderSize);
end;

// Синхронизация
procedure TfrmSettings.txtHintTransparentChange(Sender: TObject);
begin
	SyncUpDown(txtHintTransparent, spnHintTransparent);
end;

// Выбор цвета рамки хинта
procedure TfrmSettings.shpHintBorderColorMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	dlgColor:=TColorDialog.Create(frmSettings);
	dlgColor.Color:=shpHintBorderColor.Brush.Color;
	if dlgColor.Execute then begin
		shpHintBorderColor.Brush.Color:=dlgColor.Color;
		TempColor[boxETColor.ItemIndex].HintBorder:=shpHintBorderColor.Brush.Color;
	end;
	dlgColor.Free;
end;

// Выбор цвета рамки выпадуна
procedure TfrmSettings.shpDropdownBorderColorMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	dlgColor:=TColorDialog.Create(frmSettings);
	dlgColor.Color:=shpDropdownBorderColor.Brush.Color;
	if dlgColor.Execute then begin
		shpDropdownBorderColor.Brush.Color:=dlgColor.Color;
		TempColor[boxETColor.ItemIndex].DropDownBorder:=shpDropdownBorderColor.Brush.Color;
	end;
	dlgColor.Free;
end;

// Синхронизация
procedure TfrmSettings.txtDropdownBorderSizeChange(Sender: TObject);
begin
	SyncUpDown(txtDropdownBorderSize, spnDropdownBorderSize);
end;

// Синхронизация
procedure TfrmSettings.txtDropdownTransparentChange(Sender: TObject);
begin
	SyncUpDown(txtDropdownTransparent, spnDropdownTransparent);
end;

// Изменения порядка плагинов
procedure TfrmSettings.spnSortPluginsChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint;
	Direction: TUpDownDirection);
begin
	if (NewValue>-1) and (NewValue<lstPluginList.Count) then
		MovePlugin(lstPluginList.ItemIndex, NewValue);
end;

end.

