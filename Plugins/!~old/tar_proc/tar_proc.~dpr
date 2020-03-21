library tar_proc;

uses Windows, SysUtils, ShellApi, tlhelp32, Classes;

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

var
	Buf: TStringList;

procedure LoadBuf;
var pe:TProcessEntry32;
    b:boolean;
    H: THandle;
begin
Buf.Clear;
H := CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);
try
  pe.dwSize:=sizeof(pe);
  b:=Process32First(H,pe);
  while b do begin
    Buf.Add(pe.szExeFile);
    b:=Process32Next(H,pe);
  end;
finally
  CloseHandle(H);
end;
end;

// Выполняется при загрузке dll
// WinHWND - хендл текстового поля
procedure Load(WinHWND: HWND); cdecl;
begin
  Buf:=TStringList.Create;
  LoadBuf;
end;
exports Load;

// Выполняется при выгрузке dll
procedure Unload; cdecl;
begin
  Buf.Free;
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
	info.name:='tar_proc';
  info.version:='0.0.0.1 prealfa';
  info.description:='Processes Lister';
  info.author:='Konstantin Milez Frolov';
  info.copyright:='Copyright ©2003 Konstantin Frolov';
  info.homepage:='http://lavka.lib.ru/bujold/';
	Result:=info;
end;
exports GetInfo;

// Возвращает количество строк в списке в dll
function GetCount: integer; cdecl;
begin
  LoadBuf;
	Result:=Buf.Count;
end;
exports GetCount;

// Возвращает нужную строку из списка в dll
// num - номер нужной строки
function GetString(num: integer): PChar; cdecl;
begin
  Result:=PChar(Buf.Strings[num]);
end;
exports GetString;

end.
