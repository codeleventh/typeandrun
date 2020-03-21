unit WinTimer;

interface

Uses Windows,Classes,Common;

Type TMyTimer=class(TObject)
      Time,Delta:integer;
      Kind:byte;
      Msg:string;
      Id:byte;
      Active:byte;
      Loop,Late,Start:boolean;
      Constructor Create(Line:string;IsIni:boolean=false);overload;
      Constructor Create(Z:TMyTimer);overload;
      function Verify:boolean;
      procedure Run;
      Function Get:string;
     end;

Type TTimers=array[1..Max]of TMyTimer;

Type TRunner=class(TThread)
      Timers:TTimers;
      TimerNum:integer;
      Constructor Create;
      Procedure ReadTimers;
      Procedure WriteTimers;
      Procedure Free;
      protected
       Procedure Execute;override;
     end;

var Runner:TRunner;

implementation

Uses SysUtils,Messages,DateUtils,Types,Dialogs;

Const MainGroup='Timers';

Constructor TMyTimer.Create(Line:string;IsIni:boolean);
var K:integer;
    _GetTime:boolean;
    _GetNumber:boolean;
    Tm:TDateTime;
    X:string;
begin
 inherited Create;
 Time:=0;Delta:=0;Kind:=255;Msg:='';Id:=0; // заполняем результат значениями по умолчанию
 _GetTime:=true;_GetNumber:=true;Active:=0;Loop:=false;Late:=false;Start:=false;
 if IsIni then begin
  Tm:=GetStringDate(Line);
  X:=GetNext(Line);Val(X,Delta,K);
  _GetTime:=false;
 end;
 while Length(Line)>0 do begin
  X:=GetNext(Line);
  if(CompareText(X,'/a')=0)then Active:=1 // идентифицируем ключи - они могут быть где угодно
  else if(CompareText(X,'/d')=0)then Active:=2
  else if(CompareText(X,'/run')=0)then begin Kind:=1;Msg:=Line;break;
  end else if(CompareText(X,'/msg')=0)then begin Kind:=0;Msg:=Line;break;
  end else if(CompareText(X,'/osd')=0)then begin Kind:=2;Msg:=Line;break;
  end else if(CompareText(X,'/tar')=0)then begin Kind:=3;Msg:=Line;break;
  end else if(CompareText(X,'/loop')=0)then Loop:=true
  else if(CompareText(X,'/late')=0)then Late:=true
  else if(CompareText(X,'/start')=0)then Start:=true
  else if X[1]='/' then continue
  else if _GetTime then begin // получаем ВРЕМЯ - сперва должно идти оно!
   Delta:=Str2Time(X);
   if Delta>0 then _GetTime:=false;
  end else if _GetNumber then begin // получаем номер таймера
   val(X,Id,K);
   if K<>0 then begin Id:=0;Msg:=X+' '+Line;Kind:=0;break;end;
   _GetNumber:=false;
  end else begin Msg:=Line;Kind:=0;break;end;
 end;
 if(Kind=0)and(Msg='')then Msg:='Время закончилось';
 if(Kind>3)or(Delta=0)or(((Kind=1)or(Kind=2)or(Kind=3))and(Msg=''))then
  raise Exception.Create(Ini.ReadString(Language,'TaskNotDef','Task not defined!'));
 if IsIni then
  if(CompareDateTime(Now,Tm)<>GreaterThanValue)then Time:=SecondsBetween(Tm,Now) else begin
   if Late then Run;
   if Loop then
    if Start then Time:=Delta+GetTickCount div 1000
    else begin
     while CompareDateTime(Now,Tm)=GreaterThanValue do Tm:=IncSecond(Tm,Delta);
     Time:=SecondsBetween(Tm,Now);
    end
   else raise Exception.Create(Ini.ReadString(Language,'NoMoreTask','Task will never execute!'));
  end
 else Time:=Delta+GetTickCount div 1000;
end;

Constructor TMyTimer.Create(Z:TMyTimer);
begin
 inherited Create;
 Id:=Z.Id;Active:=Z.Active;
 Time:=Z.Time;Delta:=Z.Delta;
 Kind:=Z.Kind;Msg:=Z.Msg;
 Loop:=Z.Loop;Late:=Z.Late;Start:=Z.Start;
end;

function TMyTimer.Verify:boolean;
begin Result:=(GetTickCount div 1000)>Time;end;

procedure TMyTimer.Run;
var X,Y:PChar;
    Mode:byte;
    I,I1,I2,I3:integer;
begin
 GetMem(X,512);GetMem(Y,512);
 case Kind of
  0:MessageBox(0,strpcopy(X,Filter(Msg)),strpcopy(Y,'Таймер '+inttostr(Id)),MB_OK or MB_ICONINFORMATION or MB_SYSTEMMODAL);
  1:begin Mode:=0;I1:=1;I2:=1;I3:=1;
   For I:=1 to Length(Msg) do case Msg[I] of
    '"':case Mode of
     0:begin I1:=I+1;Mode:=1;end;
     1:begin I2:=I-1;I3:=I+2;break;end;
    end;
    ' ':case Mode of
     2:begin I2:=I-1;I3:=I+1;break;end;
    end;
    else case Mode of
     0:begin I1:=I;Mode:=2;end;
    end;
   end;
   ExecuteFile(copy(Msg,I1,I2-I1+1),copy(Msg,I3,Length(Msg)-I3+1),'',SW_SHOW);
  end;
  2:DrawOSD(Msg);
  3:SendText(TarHandle,Msg);
 end;
 FreeMem(Y,512);FreeMem(X,512);
 if Loop then Time:=GetTickCount div 1000+Delta;
end;

Function TMyTimer.Get:string;
begin
 Result:=PutStringDate(IncSecond(Now,Time))+Format(' %d %d',[Delta,Id]);
 if Active=1 then Result:=Result+' /a';
 if Active=2 then Result:=Result+' /d';
 if Loop then Result:=Result+' /Loop';
 if Late then Result:=Result+' /Late';
 if Start then Result:=Result+' /start';
 if Kind=0 then Result:=Result+' /msg';
 if Kind=1 then Result:=Result+' /run';
 if Kind=2 then Result:=Result+' /osd';
 if Kind=3 then Result:=Result+' /tar';
 Result:=Result+' '+Msg;
end;

Constructor TRunner.Create;
begin
 Inherited Create(false);
 TimerNum:=0;
 ReadTimers;
 Priority:=tpIdle;
end;

Procedure TRunner.ReadTimers;
var I:word;
    Count,Errors:word;
begin
 Suspend;
 Count:=Ini.ReadInteger(MainGroup,'Count',0);
 TimerNum:=0;Errors:=0;
 For I:=1 to Count do begin
  try
   Timers[TimerNum+1]:=TMyTimer.Create(Ini.ReadString(MainGroup,'T'+inttostr(I),''),true);
   Inc(TimerNum);
  except
   Inc(Errors);
  end;
 end;
 if Errors>0 then
  MessageDlg(Format(Ini.ReadString(Language,'ErrorIniLoad','%d errors during loading from INI'),[Errors]),mtError,[mbOK],0);
 Resume;
end;

Procedure TRunner.WriteTimers;
var I,Old:word;
begin
 Suspend;
 Old:=Ini.ReadInteger(MainGroup,'Count',0);
 For I:=1 to Old do Ini.DeleteKey(MainGroup,'T'+inttostr(I));
 Ini.WriteInteger(MainGroup,'Count',TimerNum);
 For I:=1 to TimerNum do Ini.WriteString(MainGroup,'T'+inttostr(I),Timers[I].Get);
 Resume;
end;

Procedure TRunner.Free;
var I:integer;
begin
 WriteTimers;
 For I:=1 to TimerNum do Timers[I].Free;
 inherited Free;
end;

Procedure TRunner.Execute;
var I,J:integer;
    Show:boolean;
begin
 repeat Show:=true;
  For I:=1 to TimerNum do if Timers[I].Verify then begin
   Timers[I].Run;       // выполнить операцию
   if Timers[I].Verify then begin
    For J:=I to TimerNum-1 do Timers[I].Create(Timers[I+1]); // стереть таймер
    Timers[TimerNum].Free;
    Dec(TimerNum);
   end;
  end else if((Timers[I].Active=1)and Show)then begin
   DrawClock(Timers[I].Time-GetTickCount div 1000); // отобразить остаток времени
   Show:=false;
  end;
  Sleep(500);
 until Terminated;
end;

end.
