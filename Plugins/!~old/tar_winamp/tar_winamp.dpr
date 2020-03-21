library tar_winamp;
uses Windows, SysUtils,Messages;
Const WinAmpClass='Winamp v1.x';
type TInfo=record
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
var tmpList: array of string; // Массив строк алиасов
procedure Load(WinHWND: HWND); cdecl;
begin
 SetLength(tmpList,5);
 tmpList[0]:='~prev';
 tmpList[1]:='~play';
 tmpList[2]:='~pause';
 tmpList[3]:='~stop';
 tmpList[4]:='~next';
end;
exports Load;
procedure Unload; cdecl;
begin
  SetLength(tmpList, 0);
end;
exports Unload;
function GetInfo: TInfo; cdecl;
var info: TInfo;
begin
 info.size:=SizeOf(TInfo);
 info.plugin:='Hello! I am the TypeAndRun plugin.';
 info.name:='Python''s winamp control plugin';
 info.version:='1.0 alpha';
 info.description:='Winamp interface';
 info.author:='Python';
 info.copyright:='SmiSoft (SA)';
 info.homepage:='smisoft@rambler.ru';
 Result:=info;
end;
exports GetInfo;
function GetCount: integer; cdecl;
begin
 Result:=High(tmpList)+1;
end;
exports GetCount;
function GetString(num: integer): PChar; cdecl;
begin
 Result:=PChar(tmpList[num]);
end;
exports GetString;
function RunString(str: PChar): TExec; cdecl;
var i,c:integer;
    exec:TExec;
begin
 exec.size:=SizeOf(TExec);
 exec.run:=0;
 exec.con_text:='';
 exec.con_sel_start:=0;
 exec.con_sel_length:=0;
 c:=-1;
 for i:=0 to High(tmpList) do if tmpList[i]=str then c:=i;
 if c<>-1 then begin
  exec.run:=1;
  exec.con_text:=nil;
  exec.con_sel_start:=0;
  exec.con_sel_length:=0;
  i:=findwindow(WinampClass,nil);
  if i<>0 then  // winamp is running
   SendMessage(i,WM_COMMAND,40044+c,0);
 end;
 Result:=exec;
end;
exports RunString;

end.
