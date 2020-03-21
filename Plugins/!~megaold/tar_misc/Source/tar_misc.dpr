library tar_misc;
uses
  Windows,
  Messages,
  SysUtils,
  Forms,
  IniFiles,
  Ren in 'Ren.pas' {Renum},
  Exe2Swf in 'Exe2Swf.pas' {AntiFlash},
  Patcher in 'Patcher.pas' {MyPatch},
  PCopy in 'PCopy.pas' {TheCopy},
  Common in 'Common.pas',
  m3uf in 'M3uf.pas' {M3update},
  FmxUtils in 'FMXUtils.pas',
  Id3er in 'Id3er.pas' {ID3Maker},
  Id3Obj in 'Id3Obj.pas',
  Booklet in 'Booklet.pas' {Reprint},
  Media in 'Media.pas',
  Main in 'Main.pas' {ACDGen},
  Rew in 'Rew.pas' {Verify},
  TextProc in 'TextProc.pas',
  Txt2htm in 'Txt2htm.pas' {InData},
  Scan in 'Scan.pas' {Scaner},
  Param in 'Param.pas' {Opts},
  Lister2 in 'Lister2.pas' {URLLister},
  Cutter in 'Cutter.pas' {CutForm};

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
 TimerID:=0;
 GetMem(X,512);
 GetModuleFileName(hInstance,X,512);
 Ini:=TIniFile.Create(ChangeFileExt(StrPas(X),'.INI'));
 FreeMem(X,512);
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
 Result.name:=StrPCopy(X1,Ini.ReadString(Language,'Name','Misc. operations'));
 Result.version:='1.0';
 Result.description:=StrPCopy(X2,Replace(Ini.ReadString(Language,'Description','Misc. files processing'),'\n',#13));
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
   1:begin
    Application.CreateForm(TAntiFlash, AntiFlash);
    AntiFlash.ShowModal;
    AntiFlash.Free;
   end;
   2:begin
    Application.CreateForm(TRenum, Renum);
    Renum.ShowModal;
    Renum.Free;
   end;
   3:begin
    Application.CreateForm(TMyPatch,MyPatch);
    MyPatch.ShowModal;
    MyPatch.Free;
   end;
   4:begin
    Application.CreateForm(TTheCopy,TheCopy);
    TheCopy.ShowModal;
    TheCopy.Free;
   end;
   5:begin
    Application.CreateForm(TM3update,M3update);
    M3update.ShowModal;
    M3update.Free;
   end;
   6:begin
    Application.CreateForm(TReprint,Reprint);
    Reprint.ShowModal;
    Reprint.Free;
   end;
   7:begin
    Application.CreateForm(TID3Maker,ID3Maker);
    ID3Maker.ShowModal;
    ID3Maker.Free;
   end;
   8:begin
    Application.CreateForm(TACDGen, ACDGen);
    ACDGen.ShowModal;
    ACDGen.Free;
   end;
   9:begin
    Application.CreateForm(TInData, InData);
    InData.ShowModal;
    InData.Free;
   end;
   10:begin
    Application.CreateForm(TScaner, Scaner);
    Scaner.ShowModal;
    Scaner.Free;
   end;
   11:begin
    Application.CreateForm(TURLLister, URLLister);
    URLLister.ShowModal;
    URLLister.Free;
   end;
   12:begin
    Application.CreateForm(TCutForm, CutForm);
    CutForm.ShowModal;
    CutForm.Free;
   end;
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
 I:=pos(' ',S);
 if I=0 then I:=Length(S)+1; // ошибка задания параметров
 CommandId:=0;
 For J:=Low(Commands) to High(Commands) do if CompareText(copy(S,1,I-1),Commands[J])=0 then CommandId:=J;
 if CommandId<>0 then begin
  Result.run:=1;
  TimerId:=SetTimer(0,0,100,@TimerProc);
 end;
end;
exports RunString;

begin
end.
