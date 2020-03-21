library Timer;
uses SysUtils,
  Classes,
  Windows,
  FMXUtils,Forms,
  Common in 'Common.pas',
  FTimer in 'FTimer.pas' {FormTimer};

Type TMyTimer=record
      Time:integer;
      TimerType:byte;
      Eliminate:byte;
      Msg:string;
      Form:TFormTimer;
     end;

Type TRunner=class(TThread)
       Timers:array[1..Max]of TMyTimer;
       Constructor Create;
       Function SetTimer(const Timer:TSetTimer):boolean;
       Function KillTimer(const Timer:integer):boolean;
       Function GetTimer(const Timer:integer):string;
       Procedure Free;
      protected
       Procedure Execute;override;
      private
       Function FinishTimer(const Timer:integer):boolean;
       Procedure Run;
     end;

var Runner:TRunner;

Constructor TRunner.Create;
var I:integer;
begin
 inherited Create(true);
 For I:=1 to Max do begin
  FillChar(Timers[I],sizeof(TMyTimer),0);
  Timers[I].Time:=-1;
 end;
 Priority:=tpIdle;
end;

Procedure TRunner.Free;
begin
 KillTimer(0);
 inherited Free;
end;

Function TRunner.SetTimer(const Timer:TSetTimer):boolean;
var Num:integer;
begin Result:=false;
 if(Timer.Time<0)or(Timer.Number<0)then exit; // ошибка - команда не распознана
 if Timer.Number=0 then begin
  For Num:=1 to Max do if Timers[Num].Time<0 then break;
  if Num>Max then exit; // не найдено свободного таймера
 end else if(Timer.Number<=Max)then Num:=Timer.Number
 else exit; // ошибка - номер таймера больше максимально возможного
 Suspended:=true;
 if Timers[Num].Form<>nil then begin Timers[Num].Form.Release;Timers[Num].Form:=nil;end;
 Timers[Num].Time:=GetTickCount+Timer.Time*1000;  // время указывается в секундах, а GetTickCount возвращает миллисекунды!
 Timers[Num].TimerType:=Timer.TimerType;
 Timers[Num].Eliminate:=Timer.Eliminate;
 Timers[Num].Msg:=Timer.Msg;
 if Timer.TimerType in [1,2] then with Timers[Num] do begin // для таймеров этого типа нужно создать окно
  Form:=TFormTimer.Create(nil);
  Form.SelectType(TimerType);
  Form.Time:=Timers[Num].Time;
 end;
 Suspended:=false;
end;

Function TRunner.KillTimer(const Timer:integer):boolean;
var I,J:byte;
begin Result:=false;
 if(Timer<0)or(Timer>Max)then exit;
 Suspended:=true;
 if Timer=0 then begin
  For I:=1 to Max do if Timers[I].Time>0 then begin
   if Timers[I].Form<>nil then begin Timers[I].Form.Release;Timers[I].Form:=nil;end;
   FillChar(Timers[I],sizeof(TMyTimer),0);
   Timers[I].Time:=-1;
  end;
  Result:=true;
 end else begin
  if Timers[Timer].Form<>nil then begin Timers[Timer].Form.Release;Timers[Timer].Form:=nil;end;
  FillChar(Timers[Timer],sizeof(TMyTimer),0);
  Timers[Timer].Time:=-1;
  J:=0;For I:=1 to Max do if Timers[I].Time>0 then Inc(J);
  if J>0 then Suspended:=false;
 end;
end;

Function TRunner.GetTimer(const Timer:integer):string;
var I:byte;
begin Result:='';
 if(Timer<0)or(Timer>Max)then exit; // обрабатывать только корректные таймеры
 Suspended:=true; // пусть не мешает при запросах
 if Timer=0 then begin
  For I:=1 to Max do if Timers[I].Time>0 then
   Result:=Result+inttostr(I)+':'+Timers[I].Msg+'('+Time2str2((Timers[I].Time-GetTickCount)div 1000)+')'#13;
  if Result<>'' then begin
   SetLength(Result,pred(Length(Result)));  // удалить последний перенос строки
   Result:='Активные таймеры:'#13+Result;  // скомпоновать ответ
  end else Result:='Активных таймеров нет.'; // нет активных таймеров
 end else with Timers[Timer] do if Time>0 then Result:=inttostr(Timer)+':'+Msg+'('+Time2str2((Time-GetTickCount)div 1000)+')'
 else Result:='Таймер '+inttostr(Timer)+' неактивен.'; // проверка на активность
 Suspended:=false; // возобновить работу
end;

Function TRunner.FinishTimer(const Timer:integer):boolean;
var X,Y:PChar;
    I,J:byte;
begin Result:=false;
 if(Timer<=0)or(Timer>Max)then Exit; // обрабатывать только одиночные таймеры
 if Timers[Timer].Time<GetTickCount then begin
  Suspended:=true; // приостановить, чтобы не мешал
  if Timers[Timer].Form<>nil then begin Timers[Timer].Form.Release;Timers[Timer].Form:=nil;end;
  if Timers[Timer].Eliminate=0 then begin
   GetMem(X,255);GetMem(Y,255);
   StrPCopy(X,Timers[Timer].Msg);
   StrPCopy(Y,'Таймер '+inttostr(Timer)); // сочиняем заголовок сообщения
   MessageBox(0,X,Y,MB_OK or MB_ICONINFORMATION or MB_SYSTEMMODAL);// показываем сообщение
   FreeMem(Y,255);FreeMem(X,255);  // освобождаем память
  end else if Timers[Timer].Eliminate=1 then with Timers[Timer] do begin // запуск внешней программы
   I:=Pos(' ',Msg);
   if I=0 then I:=Length(Msg)+1;
   ExecuteFile(copy(Msg,1,I-1),copy(Msg,I+1,Length(Msg)),'',SW_SHOW);
  end;
  FillChar(Timers[Timer],sizeof(TMyTimer),0); // устанавливаем признак освобожденности
  Timers[Timer].Time:=-1;
  J:=0;For I:=1 to Max do if Timers[I].Time>0 then Inc(J);
  if J>0 then Suspended:=false;  // остановить поток, если все таймеры закончились
 end;
end;

Procedure TRunner.Run;
var I:integer;
begin
 For I:=1 to Max do with Timers[I] do if(Time<>-1)then
  if(Time>=GetTickCount)then
   if Form<>nil then begin
    InvalidateRect(Form.Handle,nil,false);
    if Form.Time=0 then KillTimer(I); // принудительный останов таймера
   end else
  else FinishTimer(I);
end;

Procedure TRunner.Execute;
begin
 repeat
  Synchronize(Run);
  Sleep(500);
 until Terminated;
end;

procedure Load(WinHWND: HWND); cdecl;
begin
 Runner:=TRunner.Create; // подключить поток
end;
exports Load;

procedure Unload; cdecl;
begin
 Runner.Free;  // уничтожить поток
 Application.ProcessMessages;
end;
exports Unload;

function GetInfo: TInfo; cdecl; // информация о плагине
begin
 Result.size:=SizeOf(TInfo);
 Result.plugin:='Hello! I am the TypeAndRun plugin.';
 Result.name:='Timer plugin';
 Result.version:='1.1';
 Result.description:='Таймер с индикацией оставшегося времени';
 Result.author:='Python';
 Result.copyright:='SmiSoft (SA)';
 Result.homepage:='smisoft@rambler.ru';
end;
exports GetInfo;

function GetCount:integer;cdecl;
begin Result:=3;end;
exports GetCount;

function GetString(num:integer):PChar;cdecl;
begin Result:=PChar(Commands[Num]);end;
exports GetString;

function RunString(Str:PChar):TExec;cdecl; // выполнение переданной команды
var TST:TSetTimer;
    Num:integer;
    X:PChar;
begin
 Result.size:=SizeOf(TExec);
 Result.run:=0;
 Result.con_text:='';
 Result.con_sel_start:=0;
 Result.con_sel_length:=0;
 TST:=SetTimerCommandDetect(Str);  // попытаемся опознать команду установки
 if TST.Time>0 then begin Runner.SetTimer(TST);Result.Run:=1;exit;end; // команда установки таймера
 Num:=KillTimerCommandDetect(Str);
 if Num>=0 then begin Runner.KillTimer(Num);Result.Run:=1;exit;end; // команда уничтожения таймера получена
 Num:=GetTimerCommandDetect(Str);
 if Num>=0 then begin
  GetMem(X,1024);StrPCopy(X,Runner.GetTimer(Num));
  MessageBox(0,X,'Таймер',MB_OK or MB_ICONINFORMATION or MB_SYSTEMMODAL);
  FreeMem(X,1024);Result.Run:=1;exit;
 end;
 // команда не опознана...
end;
exports RunString;

end.
