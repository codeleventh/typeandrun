library tar_change;

uses
  SysUtils,IniFiles,
  Windows,
  Classes,Forms,
  PicList in 'PicList.pas',
  ChMain in 'ChMain.pas' {Change};

type TInfo=record
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
      size: integer; // Structure size, bytes
      run: integer; // If string was processed then set non-zero value (0: not process, 1: process, 2: process and TaR console must be stay show)
      con_text: PChar; // New text in console (working with run=2!)
      con_sel_start: integer; // First symbol to select (working with run=2!)
      con_sel_length: integer; // Length of selection (working with run=2!)
     end;

Const Commands:array[1..1]of string=('~change');

var TimerId,CommandId:integer;
    S:string;

procedure Load(WinHWND:HWND);cdecl;
var X:PChar;
begin
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

function GetInfo:TInfo;cdecl; // информация о плагине
var X1,X2:PChar;
begin
 GetMem(X1,256);GetMem(X2,1024);
 Result.size:=SizeOf(TInfo);
 Result.plugin:='Hello! I am the TypeAndRun plugin.';
 Result.name:=StrPCopy(X1,Ini.ReadString(MainGroup,'Name','Wallpaper rotator'));
 Result.version:='1.0';
 Result.description:=StrPCopy(X2,Ini.ReadString(MainGroup,'Description','Replaces current wallpaper to another from the list'));
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

function GetNext(var X:string):string;
var I:integer;
begin
 I:=pos(' ',X);
 if I=0 then I:=succ(Length(X));
 Result:=trim(system.copy(X,1,I-1));
 Delete(X,1,I);
end;

Procedure ServeId(S:string;Delta:integer;Ab:boolean);
var Count1,Count2,I,Gen,P:word;
begin
 Gen:=Ini.ReadInteger(MainGroup,'Generator',1); // 1-ordered,0-random;
 if Gen=0 then Randomize;
 Count1:=Ini.ReadInteger(MainGroup,'Sources',0);
 For I:=1 to Count1 do
  if(S='*')or(CompareText(S,Ini.ReadString(MainGroup,'Source'+inttostr(I),''))=0)then begin
   Count2:=Ini.ReadInteger(MainGroup,'Count'+inttostr(I),1);
   P:=Ini.ReadInteger(MainGroup,'Pos'+inttostr(I),1);
   if Ab then P:=Delta
   else if Delta=-2 then
    if Gen=0 then P:=Random(Count2)+1
    else Inc(P)
   else if Delta=-3 then
    if Gen=0 then P:=Random(Count2)+1
    else Dec(P)
   else Inc(P,Delta);
   while(P>Count2)do Dec(P,Count2);
   while(P<=0)do Inc(P,Count2);
   Ini.WriteInteger(MainGroup,'Pos'+inttostr(I),P);
   CopyPic(Ini.ReadString(MainGroup,'Name'+inttostr(I)+'-'+inttostr(P),''),
           Ini.ReadString(MainGroup,'FileName'+inttostr(I),''),
           Ini.ReadBool(MainGroup,'Jpg'+inttostr(I),false));
   if Ini.ReadBool(MainGroup,'Wall'+inttostr(I),false) then SystemParametersInfo(SPI_SETDESKWALLPAPER,0,nil,SPIF_SENDWININICHANGE);
    // сообщить операционке, если мы меняли обои рабочего стола
  end;
end;

Procedure TimerProc(hWnd,uMsg,idEvent,dwTime:integer);
var S1:string;
    I,E:integer;
    Ab:boolean;
    X:TStringList;
begin
 if TimerID<>0 then begin
  KillTimer(0,TimerId);
  TimerID:=0;
  if CommandId=1 then
   if S='' then begin // нет параметров - выйти в режим редактирования
    Application.CreateForm(TChange,Change);
    Change.ShowModal;
    Change.Free;
   end else begin // есть параметры - детектируем
    I:=-1;Ab:=false;X:=TStringList.Create; // нет никаких команд
    while S<>'' do begin
     S1:=GetNext(S);
     if S1='+' then I:=-2   // переместиться на следующий файл
     else if S1='-' then I:=-3 // переместиться на предыдущий файл
     else if I=-1 then begin   // либо идентификатор, либо позиция
      val(S1,I,E); // детектируем
      if E<>0 then begin X.Add(S1);I:=-1;end
      else Ab:=(S1[1]='+')or(S1[1]='-'); // нет, позиция
     end else X.Add(S1);
    end; // конец разбора строки
    if I=-1 then I:=1; // by default
    For E:=0 to X.Count-1 do ServeId(X.Strings[E],I,Ab);
    X.Free;
   end; // конец разбора параметров
 end; // конец таймера
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
  Delete(S,1,Length(Commands[CommandId])+1); // delete command
  TimerId:=SetTimer(0,0,100,@TimerProc);
  // проблема вот в чем: видимо, сперва отрабатывает процедура, а лишь потом - скрывается консоль.
  // чтобы сперва убрать консоль, приходится использовать вот такую фигню.
 end;
end;
exports RunString;

begin
end.
