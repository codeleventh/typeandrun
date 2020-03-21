// tar_hotkeys - забивает системные хоткеи и ассоциирует их с запускаемыми строками в консоли
// Copyright © Evgeniy Galantsev 2003-2005

library tar_hotkeys;

uses
	Windows,
  SysUtils,
  frmTARHookUnit in 'frmTARHookUnit.pas' {frmTARHook};

type
	TInfo=record
  	size: integer; // Размер структуры
  	plugin: PChar; // Обязательно строка 'Hello! I am the TypeAndRun plugin.' - это распознание плагина
		name: PChar; // Название плагина
		version: PChar; // Его версия
    description: PChar; // Краткое описание функциональности
    author: PChar; // Автор плагина
    copyright: PChar; // Права на плагин
		homepage: PChar; // Домашняя страница плагина
  end;
  TExec=record
  	size: integer; // Размер структуры  
    run: integer; // Возвращает, запустилась ли строка
    con_text: PChar; // Если надо отобразить текст в консоли
    con_sel_start: integer; // Начало выделения текста в консоли
    con_sel_length: integer; // Длина выделения
	end;

// Выполняется при загрузке dll
// WinHWND - хендл главного окна
procedure Load(WinHWND: HWND); cdecl;
var
	i: integer;
	hAlt, hShift, hCtrl, hWin: boolean;
begin
	frmTARHook:=TfrmTARHook.Create(nil);
	ConsoleHWND:=WinHWND;
	GetModuleFileName(HInstance, DllFileName, MAX_PATH); // Вычисляем полный путь к dll
	frmTARHook.ReadConfig(ExtractFilePath(DllFileName)+'\tar_hotkeys.ini');
	for i:=0 to ConfigStr.Count-1 do begin
		if Pos('A', UpperCase(frmTARHook.GetName('mods', ConfigStr.Strings[i])))<>0 then hAlt:=True else hAlt:=False;
		if Pos('S', UpperCase(frmTARHook.GetName('mods', ConfigStr.Strings[i])))<>0 then hShift:=True else hShift:=False;
		if Pos('C', UpperCase(frmTARHook.GetName('mods', ConfigStr.Strings[i])))<>0 then hCtrl:=True else hCtrl:=False;
		if Pos('W', UpperCase(frmTARHook.GetName('mods', ConfigStr.Strings[i])))<>0 then hWin:=True else hWin:=False;
		frmTARHook.BindHotKey(hAlt, hCtrl, hShift, hWin, frmTARHook.getCode(frmTARHook.GetName('hotkey', ConfigStr.Strings[i])), 1000+i, frmTARHook.Handle);
	end;
end;
exports Load;

// Выполняется при выгрузке dll
procedure Unload; cdecl;
var
	i: integer;
begin
	for i:=0 to ConfigStr.Count-1 do
		frmTARHook.UnBindHotKey(1000+i, frmTARHook.Handle);
  ConfigStr.Free;
  frmTARHook.Free;
end;
exports Unload;

// Проверка при принадледность dll к плагинам TypeAndRun
// И возврат информации о плагине
function GetInfo: TInfo; cdecl;
var
	info: TInfo;
begin
	info.size:=SizeOf(TInfo);
	info.plugin:='Hello! I am the TypeAndRun plugin.';
	info.name:='tar_hotkeys';
	info.version:='1.0';
	info.description:='Hotkey manager (string executing) for TypeAndRun';
	info.author:='Evgeniy Galantsev (-=GaLaN=-)';
  info.copyright:='Copyright © Evgeniy Galantsev 2003-2005';
  info.homepage:='http://galanc.com/';
	Result:=info;
end;
exports GetInfo;

// Запуск строки с помощью плагина - возвращает, прошел ли запуск и строку, отображаемую в консоли
// str - запускаемая строка
function RunString(str: PChar): TExec; cdecl;
var
	exec: TExec;
begin
	// Инициализация возвращаемой структуры
	exec.size:=SizeOf(TExec);
	exec.run:=0;
	exec.con_text:='';
	exec.con_sel_start:=0;
	exec.con_sel_length:=0;
  Result:=exec;
end;
exports RunString;

end.
