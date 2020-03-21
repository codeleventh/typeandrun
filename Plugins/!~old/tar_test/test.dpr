// Пример кода плагина TypeAndRun 4.5.0.
// Copyright ©2003 by -=GaLaN=- (Evgeniy Galantsev)

library test;

uses
  Windows,
  SysUtils,
  Forms;

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
	tmpList: array of string; // Массив строк алиасов
  tmp: TForm;

// Выполняется при загрузке dll
// WinHWND - хендл главного окна
procedure Load(WinHWND: HWND); cdecl;
begin
  // Инициализация 3-х алиасов для примера
	SetLength(tmpList, 1);
  tmpList[0]:='~showform';
end;
exports Load;

// Выполняется при выгрузке dll
procedure Unload; cdecl;
begin
  SetLength(tmpList, 0);
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
	info.name:='test';
  info.version:='0.0.0.1 prealfa';
  info.description:='Testing plugin interface';
  info.author:='Evgeniy Galanstev (-=GaLaN=-)';
  info.copyright:='Copyright ©2003 Evgeniy Galanstev';
  info.homepage:='http://galan.dogmalab.ru/';
	Result:=info;
end;
exports GetInfo;

// Возвращает количество строк в списке в dll
function GetCount: integer; cdecl;
begin
	Result:=High(tmpList)+1;
end;
exports GetCount;

// Возвращает нужную строку из списка в dll
// num - номер нужной строки
function GetString(num: integer): PChar; cdecl;
begin
	Result:=PChar(tmpList[num]);
end;
exports GetString;

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
    // Если запускаемая строка совпадает с одним из алиасов
  	if tmpList[0]=str then begin
      // То возвращаем 1 - если текст в консоль выводить не нужно и 2 - если нужно
      exec.run:=1;
		  tmp.Create(nil);
//		  tmp.Visible:=false;
//		  tmp.Run;
//			tmp.Show;
    end;
  Result:=exec;
end;
exports RunString;

end.
