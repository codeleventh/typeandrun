// Sample plugin for TypeAndRun 4.6
// Copyright © Evgeniy Galantsev 2003-2005

library tar_mydll;

uses Windows, SysUtils;

type
	TInfo=record
		size: integer; // Stricture size, bytes
		plugin: PChar; // plugin detection string, should be 'Hello! I am the TypeAndRun plugin.'
		name: PChar; // Plugin name
		version: PChar; // Plugin version
		description: PChar; // Plugin short description
		author: PChar; // Plugin author
		copyright: PChar; // Copyrights
		homepage: PChar; // Plugin or author homepage
	end;
	TExec=record
		size: integer; // Stricture size, bytes
		run: integer; // If string was processed then set non-zero value (0: not process, 1: process, 2: process and TaR console must be stay show)
		con_text: PChar; // New text in console (working with run=2!)
		con_sel_start: integer; // First symbol to select (working with run=2!)
		con_sel_length: integer; // Length of selection (working with run=2!)
	end;

var
	tmpList: array of string; // Plugin aliases array (for sample)
	strET: string; // EasyType string (for sample)

// Launch when plugin loaded
// WinHWND - handle console main window
// Warning - this function MUST be presented!
procedure Load(WinHWND: HWND); cdecl;
begin
	// Initializing plugin aliases (for sample)
	SetLength(tmpList, 3);
	tmpList[0]:='~alias1';
	tmpList[1]:='~alias2';
	tmpList[2]:='~alias3';
end;
exports Load;

// Launch when plugin unloaded dll
procedure Unload; cdecl;
begin
  SetLength(tmpList, 0);
end;
exports Unload;

// Getting infomation about plugin
// Warning - this function MUST be presented!
function GetInfo: TInfo; cdecl;
var
	info: TInfo;
begin
	info.size:=SizeOf(TInfo);
	info.plugin:='Hello! I am the TypeAndRun plugin.';
	info.name:='tar_mydll';
	info.version:='4.6';
	info.description:='Testing plugin interface';
	info.author:='Evgeniy Galantsev (-=GaLaN=-)';
	info.copyright:='Copyright © Evgeniy Galantsev 2003-2005';
	info.homepage:='http://galanc.com/';
	Result:=info;
end;
exports GetInfo;

// Return count of plugin aliases
function GetCount: integer; cdecl;
begin
	Result:=High(tmpList)+1;
end;
exports GetCount;

// Return plugin alias
// num - string number
function GetString(num: integer): PChar; cdecl;
begin
	Result:=PChar(tmpList[num]);
end;
exports GetString;

// Return EasyType (completion) count for Str string
function GetCountET(Str: PChar): integer; cdecl;
begin
	strET:=Str;
	Result:=1;
end;
exports GetCountET;

// Return EasyType (completion) string
// num - EasyType (completion) string number
function GetStringET(num: integer): PChar; cdecl;
begin
	strET:=Trim(strET + '~' + strET);
	Result:=PAnsiChar(strET);
end;
exports GetStringET;

// Launch string via plugin - return if string was processed
// str - launching string
// Warning - this function MUST be presented!
function RunString(str: PChar): TExec; cdecl;
var
	i: integer;
	exec: TExec;
	outtxt: string;
begin
	// Initializing returning structure
	exec.size:=SizeOf(TExec);
	exec.run:=0;
	exec.con_text:='';
	exec.con_sel_start:=0;
	exec.con_sel_length:=0;

	for i:=0 to High(tmpList) do
	if tmpList[i]=str then begin
		exec.run:=2;
		outtxt:='Exec alias '+str;
		exec.con_text:=PChar(outtxt);
		exec.con_sel_start:=11;
		exec.con_sel_length:=Length(outtxt);
	end;
	Result:=exec;
end;
exports RunString;

end.
