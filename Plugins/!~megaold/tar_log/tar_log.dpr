library tar_log;

uses Windows, SysUtils;
type TInfo=record
      size: integer; 	// Structure size, bytes
      plugin: PChar; 	// plugin detection string, should be 'Hello! I am the TypeAndRun plugin.'
      name: PChar; 	// Plugin name
      version: PChar; 	// Plugin version
      description: PChar; // Plugin short description
      author: PChar; 	// Plugin author
      copyright: PChar; // Copyrights
      homepage: PChar; 	// Plugin or author homepage
     end;
     TExec=record
      size: integer; 		 // Structure size, bytes
      run: integer; 		 // If string was processed then set non-zero value (0: not process, 1: process, 2: process and TaR console must be stay show)
      con_text: PChar; 		 // New text in console (working with run=2!)
      con_sel_start: integer;  // First symbol to select (working with run=2!)
      con_sel_length: integer; // Length of selection (working with run=2!)
     end;

Const Commands:array[1..3]of string=('~Command','~Text','~Log');

var Log:textfile;
    StrET:string;

procedure Load(WinHWND: HWND); cdecl;
var X:PChar;
    S:string;
    Loaded:boolean;
begin
 GetMem(X,128);
 GetModuleFileName(hInstance,X,512);
 S:=ChangeFileExt(StrPas(X),'.LOG');
 FreeMem(X,128);
 AssignFile(Log,S);
 Loaded:=true;
 try
  Append(Log);
 except
  try
   Rewrite(Log);
  except
   Loaded:=false;
  end;
 end;
 if Loaded then Writeln(Log,'Loaded '+datetostr(Now)+' at '+timetostr(Now))
 else MessageBox(WinHWND,'Logger not loaded','Logger',0);
 CloseFile(Log);
end;
exports Load;

procedure Unload; cdecl;
var Loaded:boolean;
begin
 Loaded:=true;
 try
  Append(Log);
 except
  Loaded:=false;
 end;
 if Loaded then Writeln(Log,'Unloaded '+datetostr(Now)+' at '+timetostr(Now));
 CloseFile(Log);
end;
exports Unload;

function GetInfo: TInfo; cdecl;
var info: TInfo;
begin
 info.size:=SizeOf(TInfo);
 info.plugin:='Hello! I am the TypeAndRun plugin.';
 info.name:='Logger';
 info.version:='1.0';
 info.description:='Logs plugin loads and unloads';
 info.author:='Python';
 info.copyright:='Python SmiSoft (SA)';
 info.homepage:='smisoft@rambler.ru';
 Result:=info;
end;
exports GetInfo;

function GetCount:integer;cdecl;
begin
 Result:=High(Commands);
end;
exports GetCount;

function GetString(num:integer):PChar;cdecl;
begin
 Result:=PChar(Commands[succ(num)]);
end;
exports GetString;

function GetCountET(Str:PChar):integer;cdecl;
var I:integer;
begin
 StrET:=StrPas(Str);
 Result:=0;
 For I:=Low(Commands) to High(Commands) do
  if Copy(Commands[I],1,Length(StrET))=StrET then Inc(Result);
end;
exports GetCountET;

function GetStringET(num:integer):PChar;cdecl;
var I,Count:integer;
begin
 Count:=0;Result:=nil;
 For I:=Low(Commands) to High(Commands) do begin
  if Copy(Commands[I],1,Length(StrET))=StrET then Inc(Count);
  if num=Count then begin
   Result:=PChar(Commands[I]);
   break;
  end;
 end;
end;
exports GetStringET;

function RunString(str: PChar): TExec; cdecl;
var i:integer;
    S:string;
begin
 Result.size:=SizeOf(TExec);
 Result.run:=0;
 Result.con_text:='';
 Result.con_sel_start:=0;
 Result.con_sel_length:=0;
 For I:=Low(Commands) to High(Commands) do
  if CompareText(Commands[i],str)=0 then begin
   Result.run:=2;
   S:='Exec '+str;
   Result.con_text:=PChar(S);
   Result.con_sel_start:=5;
   Result.con_sel_length:=Length(S);
  end;
end;
exports RunString;

end.
