library tar_timer;

uses
  SysUtils,
  Classes,
  Forms,
  Dialogs,
  Windows,
  IniFiles,
  WinTimer in 'WinTimer.pas',
  Common in 'Common.pas',
  WinCron in 'WinCron.pas',
  Main in 'Main.pas' {Base},
  InOut in 'InOut.pas';

{$R *.res}

Const Commands:array[0..12]of string=(
 '~SetShed','~KillShed','~GetShed',
 '~SetTimer','~KillTimer','~GetTimer',
 '~SetLoad','~KillLoad','~GetLoad',
 '~SetUnload','~KillUnload','~GetUnload',
 '~ForgetCD');

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

var CommandId,TimerId:integer;
    S:string;
    OnLoad,OnUnload:TLoads;
    NeedCD:boolean;
var TID,Cur:integer;

Procedure TimerLoad(Handle,uMsg,idEvent,dwTime:integer);stdcall;
begin
 KillTimer(0,TID);
 if TID<>0 then begin
  TID:=0;
  OnLoad.Loads[Cur].Run;
  if OnLoad.Loads[Cur].Once then OnLoad.Delete(inttostr(Cur)) else Inc(Cur);
  if Cur<OnLoad.Number then TID:=SetTimer(0,0,OnLoad.Loads[Cur].Timeout*1000,@TimerLoad);
 end;
end;

procedure Load(WinHWND:integer);
var X:PChar;
begin
 GetMem(X,128);
 GetModuleFileName(hInstance,X,512);
 Ini:=TIniFile.Create(ChangeFileExt(StrPas(X),'.INI'));
 FreeMem(X,128);
 TarHandle:=WinHWND;
 Sheduler:=TSheduler.Create;
 Runner:=TRunner.Create;
 OnLoad.Load('AutoStart');
 OnUnload.Load('AutoExit');
 Cur:=0;
 TID:=SetTimer(0,0,OnLoad.Loads[Cur].Timeout*1000,@TimerLoad);
 NeedCD:=Ini.ReadBool('AutoCD','Auto',false);
end;
exports Load;

procedure Unload;cdecl;
var I:byte;
    NewTime:DWORD;
begin
 Application.ProcessMessages;
 OnLoad.Store('AutoStart');
 if NeedCD then UnloadCDs;
 Ini.WriteBool('AutoCD','Auto',NeedCD);
 I:=0;while I<OnUnload.Number do begin
  NewTime:=GetTickCount+OnUnload.Loads[I].Timeout*1000;
  while NewTime>GetTickCount do begin Application.ProcessMessages;Sleep(10);end;
  OnUnload.Loads[I].Run;
  if OnUnload.Loads[I].Once then OnUnload.Delete(inttostr(I)) else Inc(I);
 end;
  // режим автовыгрузки
 OnUnload.Store('AutoExit');
 Sheduler.Free;
 Runner.Free;
 Ini.Free;
end;
exports Unload;

function GetInfo: TInfo; cdecl; // информация о плагине
var X1,X2:PChar;
begin
 GetMem(X1,128);GetMem(X2,256);
 Result.size:=SizeOf(TInfo);
 Result.plugin:='Hello! I am the TypeAndRun plugin.';
 Result.name:=StrPCopy(X1,Ini.ReadString(Language,'PluginName','Sheduler and timer'));
 Result.version:='1.4';
 Result.description:=StrPCopy(X2,Replace(Ini.ReadString(Language,'PluginDescr','Sheduled pluging execution'#13'Timer with analog indicator'),'\n',#13));
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

Procedure TimerProc(hWnd,uMsg,idEvent,dwTime:integer);
var I,J,K:integer;
    X,Y:PChar;
    T:TMyTimer;
    A:string;
begin
 KillTimer(0,TimerId);
 if TimerId<>0 then begin
 TimerId:=0;
 case CommandId of
  0:begin
   try
    A:=GetNext(S);if S='' then raise Exception.Create('Shed definition error'); // ошибка задания имени расписания
    For J:=1 to Sheduler.CronNum do if CompareText(Sheduler.Crons[J].Name,A)=0 then break;
    if(Sheduler.CronNum>=Max)and(J>Sheduler.CronNum)then MessageDlg(Ini.ReadString(Language,'MaxSheds','Maximal timer number reached!'),mtError,[mbOk],0)
    else if(J>Sheduler.CronNum)then begin
     Sheduler.Crons[Sheduler.CronNum+1]:=TCron.Create(S); // in case of error, exception wwill be generated
     Inc(Sheduler.CronNum);
     Sheduler.Crons[Sheduler.CronNum].Name:=A;
    end else Sheduler.Crons[J].Create(S);
   except
    MessageDlg(Ini.ReadString(Language,'TaskNotDef','Task not defined!'),mtError,[mbOk],0);
   end;
  end;
  1:begin // удалить расписание
   if Length(S)=0 then begin
    if MessageDlg(Ini.ReadString(Language,'EraseAllShed','Erase all sheds. Are you sure?'),mtConfirmation,mbOkCancel,0)=idOk then begin
     For I:=1 to Sheduler.CronNum do Sheduler.Crons[I].Free;
     Sheduler.CronNum:=0;
    end;
   end else begin
    A:=GetNext(S);
    For J:=1 to Sheduler.CronNum do if CompareText(Sheduler.Crons[J].Name,A)=0 then break; // найти такое имя
    if J<=Sheduler.CronNum then begin
     for I:=J to Sheduler.CronNum-1 do Sheduler.Crons[I].Create(Sheduler.Crons[I+1]);
     Sheduler.Crons[Sheduler.CronNum].Free;
     Dec(Sheduler.CronNum);
    end else MessageDlg(Ini.ReadString(Language,'NotFoundShed','This shed not found!'),mtWarning,[mbOk],0);
   end;
  end;
  2:begin // получить информацию о расписании
   if Length(S)=0 then begin
    Application.CreateForm(TBase, Base);
    Base.ShowModal;
    Base.Free;
    Sheduler.WriteCrons;
   end else begin
    A:=GetNext(S);
    For J:=1 to Sheduler.CronNum do if CompareText(Sheduler.Crons[J].Name,A)=0 then break; // найти такое имя
    if J<=Sheduler.CronNum then MessageDlg(Sheduler.Crons[J].Name+#13+Sheduler.Crons[J].Get,mtInformation,[mbOk],0)
    else MessageDlg(Ini.ReadString(Language,'NotFoundShed','This shed not found!'),mtWarning,[mbOk],0);
   end;
  end;
  3:begin // добавить таймер
   try
    T:=TMyTimer.Create(S);
    For J:=1 to Runner.TimerNum do if(Runner.Timers[J].Id=T.Id)then break;
    if(J>Runner.TimerNum)or(T.Id=0)then begin // нужно добавить новый таймер
     Inc(Runner.TimerNum);
     Runner.Timers[Runner.TimerNum]:=TMyTimer.Create(T);
    end else Runner.Timers[J].Create(T); // модифицирую существующий таймер
    T.Free;
   except
    MessageDlg(Ini.ReadString(Language,'TaskNotDef','Task not defined!'),mtError,[mbOk],0);
   end;
  end;
  4:begin // удалить таймер
   Runner.Suspend;A:=GetNext(S);Val(A,J,K);
   if K<>0 then begin // удалить все таймеры
    if MessageDlg(Ini.ReadString(Language,'EraseAllTimer','Erase all timers. Are you sure?'),mtConfirmation,mbOkCancel,0)=idOk then begin
     For I:=1 to Runner.TimerNum do Runner.Timers[I].Free;
     Runner.TimerNum:=0;
    end;
   end else begin
    For I:=1 to Runner.TimerNum do if Runner.Timers[I].Id=J then K:=I;
    if K=0 then MessageDlg(Ini.ReadString(Language,'NotFoundTimer','That timer not found!'),mtInformation,[mbOk],0)
    else begin
     For I:=K to Runner.TimerNum-1 do Runner.Timers[I].Create(Runner.Timers[I+1]);
     Runner.Timers[Runner.TimerNum].Free;
     Dec(Runner.TimerNum);
    end;
   end;
   Runner.Resume;
  end;
  5:begin // информация о таймерах
   Runner.Suspend;A:=GetNext(S);Val(A,J,K);
   if K<>0 then begin // получить полную информацию
    S:='';
    For I:=1 to Runner.TimerNum do S:=S+inttostr(Runner.Timers[I].Id)+':'+Runner.Timers[I].Msg+'('+Time2str2(Runner.Timers[I].Time-GetTickCount div 1000)+')'#13;
    if S<>'' then begin
     SetLength(S,pred(Length(S)));  // удалить последний перенос строки
     S:=Ini.ReadString(Language,'ActiveTimers','ActiveTimers')+':'#13+S;  // скомпоновать ответ
    end else S:=Ini.ReadString(Language,'NoActiveTimers','No active timers.'); // нет активных таймеров
   end else begin
    For I:=1 to Runner.TimerNum do if Runner.Timers[I].Id=J then break;
    if I>Runner.TimerNum then S:=Format(Ini.ReadString(Language,'TimerNoActive','Timer %d not active!'),[J])
    else S:=inttostr(Runner.Timers[I].Id)+':'+Runner.Timers[I].Msg+'('+Time2str2(Runner.Timers[I].Time-GetTickCount div 1000)+')';
   end;
   GetMem(X,512);GetMem(Y,128);
   MessageBox(0,strpcopy(X,S),StrPCopy(Y,Ini.ReadString(Language,'Status','Status')),MB_OK or MB_ICONINFORMATION or MB_SYSTEMMODAL);
   FreeMem(Y,128);FreeMem(X,512);
   Runner.WriteTimers;
   Runner.Resume;
  end;
  6:OnLoad.Modify(S); // добавить автозапуск
  7:OnLoad.Delete(S); // удалить автозапуск
  8:begin  // информация об автозапуске
   S:='';
   For I:=0 to OnLoad.Number-1 do S:=S+inttostr(I+1)+': '+OnLoad.Loads[I].Get+#13;
   if S<>'' then SetLength(S,pred(Length(S))) else S:=Ini.ReadString(Language,'noAutoStart','No auto load tasks');
   GetMem(X,512);GetMem(Y,128);
   MessageBox(0,strpcopy(X,S),StrPCopy(Y,Ini.ReadString(Language,'AutoStartCap','AutoStart')),MB_OK or MB_ICONINFORMATION or MB_SYSTEMMODAL);
   FreeMem(Y,128);FreeMem(X,512);
  end;
  9:OnUnload.Modify(S);  // добавить автовыгрузку
  10:OnUnload.Delete(S); // удалить автовыгрузку
  11:begin // информация о автовыгрузке
   S:='';
   For I:=0 to OnUnLoad.Number-1 do S:=S+inttostr(I+1)+': '+OnUnLoad.Loads[I].Get+#13;
   if S<>'' then SetLength(S,pred(Length(S))) else S:=Ini.ReadString(Language,'noAutoExit','No auto exit tasks');
   GetMem(X,512);GetMem(Y,128);
   MessageBox(0,strpcopy(X,S),StrPCopy(Y,Ini.ReadString(Language,'AutoExitCap','AutoExit')),MB_OK or MB_ICONINFORMATION or MB_SYSTEMMODAL);
   FreeMem(Y,128);FreeMem(X,512);
  end;
  12:begin  // автовыгрузка CD
   A:=GetNext(S);
   if A='' then begin
    GetMem(X,512);GetMem(Y,128);
    if NeedCD then S:=Ini.ReadString(Language,'ForgetCDOn','Noforget on')
    else S:=Ini.ReadString(Language,'ForgetCDOff','Noforget off');
    MessageBox(0,strpcopy(X,S),StrPCopy(Y,Ini.ReadString(Language,'ForgetCDCap','Noforget')),MB_OK or MB_ICONINFORMATION or MB_SYSTEMMODAL);
    FreeMem(Y,128);FreeMem(X,512);
   end;
   if A='1' then NeedCD:=true;
   if A='0' then NeedCD:=false;
  end;
 end;
 end;
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
  // проблема вот в чем: видимо, сперва отрабатывает процедура, а лишь потом - скрывается консоль.
  // чтобы сперва убрать консоль, приходится использовать вот такую фигню.
 end;
end;
exports RunString;

begin
end.
