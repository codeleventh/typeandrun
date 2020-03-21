library tar_amp;
uses
  Windows,
  Messages,
  SysUtils,
  LangProc,
  Media;

{$R *.res}

Type TInfo=record
      size: integer; // Structure size, bytes
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

var TimerId,CommandId:integer;
    S:string;

procedure Load(WinHWND:integer);
var X:PChar;
begin
 GetMem(X,512);
 GetModuleFileName(hInstance,X,512);
 Ini:=TLangIni.Create(ChangeFileExt(StrPas(X),'.INI'));
 FreeMem(X,512);
 TimerID:=0;
end;
exports Load;

procedure Unload;cdecl;
begin
 Ini.Free;
end;
exports Unload;

function GetInfo: TInfo; cdecl; // информация о плагине
var X1,X2:PChar;
begin
 GetMem(X1,256);GetMem(X2,1024);
 Result.size:=SizeOf(TInfo);
 Result.plugin:='Hello! I am the TypeAndRun plugin.';
 Result.name:=StrPCopy(X1,Ini.ReadString(Language,'Name','Media control'));
 Result.version:='1.15';
 Result.description:=StrPCopy(X2,Replace(Ini.ReadString(Language,'Description','Winamp+BSPlayer control\nSome media processing'),'\n',#13));
 Result.author:='Python';
 Result.copyright:='SmiSoft (SA)';
 Result.homepage:='smisoft@rambler.ru';
end;
exports GetInfo;

function GetCount:integer;cdecl;
begin Result:=High(Commands);end;
exports GetCount;

function GetString(num:integer):PChar;cdecl;
begin Result:=PChar(Commands[Num+1]);end;
exports GetString;

Procedure TimerProc(hWnd,uMsg,idEvent,dwTime:integer);
begin
 if TimerID<>0 then begin
  KillTimer(0,TimerId);
  TimerID:=0;
  case CommandId of
   1,2:if PresentFoo then CommandFoo(S) else CommandWinamp(S);
   6:CommandWinamp(S);
   12:CommandBSP(S);
   3,4,5,7,8,9,10,11,13,14,15:if PresentFoo then CommandFoo(S)
          else if PresentBSP then CommandBSP(S)
          else if PresentWinamp then CommandWinamp(S)
          else MessageBox(0,PChar(Ini.ReadString(Language,'waNo','Players not found')),
           PChar(Ini.ReadString(Language,'waStatus','Player status')),0);
  end;
  CommandId:=0;
 end;
end;

function RunString(Str:PChar):TExec;cdecl; // выполнение переданной команды
var I,J:integer;
begin
 Result.size:=SizeOf(TExec);
 Result.run:=0;
 Result.con_text:='';
 Result.con_sel_start:=0;
 Result.con_sel_length:=0;
 S:=StrPas(Str);
 I:=pos(' ',S);if I=0 then I:=Length(S)+1; // ошибка задания параметров
 CommandId:=0;
 For J:=Low(Commands) to High(Commands) do if CompareText(copy(S,1,I-1),Commands[J])=0 then CommandId:=J;
 if CommandId<>0 then begin
  Result.run:=1;
  TimerId:=SetTimer(0,0,100,@TimerProc);
  // проблема вот в чем: видимо, сперва отрабатывает процедура, а лишь потом - скрывается консоль.
  // чтобы сперва убрать консоль, приходится использовать вот такую фигню.
 end;
end;
exports RunString;

begin
end.
