library tar_clip;

uses
  Forms,
  SysUtils,
  Windows,Messages,
  Common in 'Common.pas',
  Main in 'Main.pas' {ClipEditor},
  Option in 'Option.pas' {OptionForm},
  Wins in 'Wins.pas' {WinList};

{$R *.res}

Const Commands:array[0..4]of string=('~puretext','~convert','~clipeditor','~translit','~paste');

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

var CommandId,TimerID:integer;
    S:string;
//    StrET:string;

procedure Load(WinHWND:integer);
begin
 Application.CreateForm(TClipEditor,ClipEditor); // создать основную форму
end;
exports Load;

procedure Unload;cdecl;
begin
 if OptionPresent then SendMessage(OptionForm.Handle,WM_CLOSE,0,0);
 if WinPresent then SendMessage(WinList.Handle,WM_CLOSE,0,0);
 Sleep(100); // подождем, пока формы закроются
 if ClipEditorPresent then begin
  ClipEditor.Store;
  ClipEditor.Free; // закроем главную форму
 end;
end;
exports Unload;

function GetInfo:TInfo;cdecl; // информация о плагине
var X,Y:PChar;
begin
 GetMem(X,32);GetMem(Y,256);
 StrPCopy(X,Ini.ReadString('Language','Name','Clipboarder'));
 StrPCopy(Y,Replace(Ini.ReadString('Language','Description','Clipboard processing\nMore than 1 clipboard\n"Static" clips'),'\n',#13));
 Result.size:=SizeOf(TInfo);
 Result.plugin:='Hello! I am the TypeAndRun plugin.';
 Result.name:=X;
 Result.version:='1.01 alpha';
 Result.description:=Y;
 Result.author:='Python';
 Result.copyright:='SmiSoft (SA)';
 Result.homepage:='smisoft@rambler.ru';
end;
exports GetInfo;

function GetCount:integer;cdecl;
begin Result:=succ(High(Commands));end;
exports GetCount;

function GetString(num:integer):PChar;cdecl;
begin Result:=PChar(Commands[Num]);end;
exports GetString;

{function GetCountET(Str:PChar):integer;cdecl;
var I:word;
begin
 Result:=0;strET:=Str;
 For I:=Low(Commands) to High(Commands) do if CompareText(Copy(Commands[I],1,Length(StrET)),StrET)=0 then Inc(Result);
end;
exports GetCountET;

function GetStringET(num:integer):PChar;cdecl;
var I:word;
begin
 Result:=nil;
 For I:=Low(Commands) to High(Commands) do begin
  if CompareText(Copy(Commands[I],1,Length(StrET)),StrET)=0 then Dec(num);
  if num=0 then begin
   Result:=PChar(Commands[I]);
   exit;
  end;
 end;
end;
exports GetStringET;}

Procedure TimerProc(hWnd,uMsg,idEvent,dwTime:integer);
Label Last;
var X:PChar;
    B:string[20];
    Mode:byte;
    L:integer;
    Auto:boolean;
begin
 GetMem(X,1024);
 if TimerID<>0 then begin
  KillTimer(0,TimerId);
  TimerID:=0;
  case CommandId of
   0:begin
    ClipEditor.AllowClipboard:=false;
    PureClip;
    ClipEditor.AllowClipboard:=true;
   end;
   1:begin
    ClipEditor.AllowClipboard:=false;
    try
     Convert(S);
    except
     on E:Exception do Application.MessageBox(StrPCopy(X,E.Message),'Warning',MB_ICONEXCLAMATION);
    end;
    ClipEditor.AllowClipboard:=true;
   end;
   2:with ClipEditor do begin
    Show;
    SetForegroundWindow(Handle);
   end;
   3:try
    Translit(S);
   except
    on E:Exception do Application.MessageBox(StrPCopy(X,E.Message),'Warning',MB_ICONEXCLAMATION);
   end;
   4:begin Mode:=PasteMode;Auto:=true;
    while(S<>'')and(S[1]='/')do begin
     B:=GetNext(S);
     if CompareText(B,'/reg')=0 then Mode:=0
     else if CompareText(B,'/key')=0 then Mode:=1
     else if CompareText(B,'/s1')=0 then Mode:=2
     else if CompareText(B,'/s2')=0 then Mode:=3
     else if CompareText(B,'/noauto')=0 then Auto:=false;
    end;
    if S<>'' then with ClipEditor do begin
     For L:=0 to Clips.Items.Count-1 do
      if CompareText(S,Clips.Items.Strings[L])=0 then break;
     if L<Clips.Items.Count then begin
      Clips.ItemIndex:=L;
      PutClipboard;
     end else Goto Last;
    end;
    if Auto then ClipEditor.SendClipboard(Mode);
   end;
  end;
 end;
 Last:FreeMem(X,1024);
end;

function RunString(Str:PChar):TExec;cdecl; // выполнение переданной команды
var J:integer;
    S2:string;
begin
 Result.size:=SizeOf(TExec);
 Result.run:=0;
 Result.con_text:='';
 Result.con_sel_start:=0;
 Result.con_sel_length:=0;
 S:=StrPas(Str);S2:=GetNext(S);
 CommandId:=-1;
 For J:=Low(Commands) to High(Commands) do if CompareText(S2,Commands[J])=0 then CommandId:=J;
 if CommandId<>-1 then begin
  Result.run:=1;
  TimerId:=SetTimer(0,0,100,@TimerProc);
 end;
end;
exports RunString;

begin
end.
