program TypeAndRun;
uses
  Forms,
  Classes,
  Windows,
  SysUtils,
  frmConsoleUnit in 'frmConsoleUnit.pas' {frmTARConsole},
  ForAll in 'ForAll.pas',
  Configs in 'Configs.pas',
  Static in 'Static.pas',
  frmSettingsUnit in 'frmSettingsUnit.pas' {frmSettings},
  frmAboutUnit in 'frmAboutUnit.pas' {frmAbout},
  Plugins in 'Plugins.pas',
  frmTypeDownDropUnit in 'frmTypeDownDropUnit.pas' {frmTypeDropDown},
  Settings in 'Settings.pas',
  frmHintUnit in 'frmHintUnit.pas' {frmHint};

{$R *.res}
{$R XPTheme.RES}

begin
	Application.Initialize;

	// Инициализация массивов строк перед занесением в них конфига
	ConfigStr:=TStringList.Create;
	HistoryStr:=TStringList.Create;
	Options:=TSettings.Create;
	tmpAliasStr:=TStringList.Create;

  // Создаем семафор и смотрим, создался ли он
	CreateSemaphore(nil, 0, 1, 'TypeAndRunSemaphore');
	if GetLastError = Error_Already_Exists then begin
    // Если не создался, и параметр коммандной строки не пустой, то добавляем алиас
		if ParamCount <> 0 then begin
      //Application.CreateForm(TfrmAbout, frmAbout);
      Application.CreateForm(TfrmTARConsole, frmTARConsole);
			Application.CreateForm(TfrmHint, frmHint);
			ActivatePrevInst;
    end;
		Application.Terminate;
    Halt;
  end;

  ParseCmdLine(1);

	Application.CreateForm(TfrmTARConsole, frmTARConsole);
  //Application.CreateForm(TfrmSettings, frmSettings);
	//Application.CreateForm(TfrmAbout, frmAbout);

  // Обработка событий активизации/деактивизации приложения
	Application.OnDeactivate:=frmTARConsole.AppDeActivate;
	Application.OnActivate:=frmTARConsole.AppActivate;

  // Чтение всех настроек
	Options.ReadSettings;
  ReadConfig(Program_Config);
  ReadHistory(Program_History);
  Options.SystemAliases.ReadSystemAliases;
  ReadPlugins(Program_Plugin);
  LoadPlugins;

  // Установка начальных значений отмен
  UndoMax:=0;
	SetLength(Undo, UndoMax);
	SetLength(UndoCur, UndoMax);
	SetLength(UndoCurLength, UndoMax);

  ApplySettings;

  ParseCmdLine(2);

  if Options.Config.CDA_Startup then begin
  	ReturnDeadAliases;
  	CheckDeadAliases;
  end;

  if Options.Show.ShowConsoleOnStart then ShowCon;

  Application.Run;
end.
