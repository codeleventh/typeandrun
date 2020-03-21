unit Common;

interface

Const Commands:array[0..2]of string=('~SetTimer','~KillTimer','~GetTimer');
      Max=10;
      Invisible=0; // типы таймера: невидимый, аналоговый, цифровой
      Analog=1;
      Digital=2;
      Mess=0; // что выполнять по окончанию: выводить сообщение, или выполнять программу
      Exec=1;

// специализированные типы данных для модуля таймера

Type TSetTimer=record
      Time:integer;
      Number:byte;
      TimerType:byte;
      Eliminate:byte;
      Msg:string;
     end;

// специализированные типы данных для TypeAndRun

Type TInfo=record
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

function Str2Time(S:string):integer; // выделяет время из строки
function Time2Str(Time:integer):string; // преобразует время в строку
function Time2Str2(Time:integer):string; // перевести в NN ч. NN м. NN с.
function SetTimerCommandDetect(Line:string):TSetTimer; // анализирует входящую строку для команды SetTimer
 // возвращает Result.Time<0 при ошибке
function KillTimerCommandDetect(Line:string):integer; // то же для команды KillTimer
 // возвращает Result<0 при ошибке
function GetTimerCommandDetect(Line:string):integer; // то же для команды GetTimer
 // возвращает Result<0 при ошибке

implementation

Uses SysUtils;

function KillTimerCommandDetect(Line:string):integer;
var I,K:integer;
    _Validate:boolean;
    _GetNumber:boolean;
begin
 Result:=-1;_Validate:=true;_GetNumber:=true; // заполняем результат значением ошибки
 while Length(Line)>0 do begin
  Line:=Trim(Line);
  I:=Pos(' ',Line);
  if I=0 then I:=Length(Line)+1;
  if _Validate then if CompareText(copy(Line,1,I-1),Commands[1])=0 then _Validate:=false else exit // идентифицируем команду
  else if _GetNumber then begin    // попытаемся получить номер таймера
   Val(copy(Line,1,I-1),Result,K);
   if K<>0 then Result:=-1 else _GetNumber:=false;
  end;
  Delete(Line,1,I);
 end;
 if(not _Validate)and(Result=-1)then Result:=0;
 if(Result>Max)then Result:=-1;
end;

function GetTimerCommandDetect(Line:string):integer;
var I,K:integer;
    _Validate:boolean;
    _GetNumber:boolean;
begin
 Result:=-1;_Validate:=true;_GetNumber:=true; // заполняем результат значением ошибки
 while Length(Line)>0 do begin
  Line:=Trim(Line);
  I:=Pos(' ',Line);
  if I=0 then I:=Length(Line)+1;
  if _Validate then if CompareText(copy(Line,1,I-1),Commands[2])=0 then _Validate:=false else exit // идентифицируем команду
  else if _GetNumber then begin    // попытаемся получить номер таймера
   Val(copy(Line,1,I-1),Result,K);
   if K<>0 then Result:=-1 else _GetNumber:=false;
  end;
  Delete(Line,1,I);
 end;
 if(not _Validate)and(Result=-1)then Result:=0;
 if(Result>Max)then Result:=-1;
end;

function SetTimerCommandDetect(Line:string):TSetTimer;
var I,K:integer;
    _Validate:boolean;
    _GetTime:boolean;
    _GetNumber:boolean;
begin
 FillChar(Result,sizeof(Result),0);Result.Time:=-1; // заполняем результат значениями по умолчанию
 _Validate:=true;_GetTime:=true;_GetNumber:=true;
 while Length(Line)>0 do begin
  Line:=Trim(Line);
  I:=Pos(' ',Line);
  if I=0 then I:=Length(Line)+1;
  if _Validate then if CompareText(copy(Line,1,I-1),Commands[0])=0 then _Validate:=false else exit // идентифицируем
  else if(CompareText(Copy(Line,1,I-1),'/a')=0)then Result.TimerType:=Analog // идентифицируем ключи - они могут быть где угодно
  else if(CompareText(Copy(Line,1,I-1),'/d')=0)then Result.TimerType:=Digital
  else if(CompareText(Copy(Line,1,I-1),'/run')=0)then begin // теперь опознать в остатке командную строку
   Delete(Line,1,I);Result.Eliminate:=Exec;
   Result.Msg:=trim(Line);exit;
  end else if(CompareText(Copy(Line,1,I-1),'/msg')=0)then begin // теперь остаток - это выводимое сообщение
   Delete(Line,1,I);Result.Eliminate:=Mess;
   Result.Msg:=Trim(Line);exit;
  end else if _GetTime then begin // получаем ВРЕМЯ - сперва должно идти оно!
   Result.Time:=Str2Time(Copy(Line,1,I-1));
   if Result.Time=0 then begin Result.Time:=-2;exit;end; // время задано с ошибкой - отбой
   _GetTime:=false;
  end else if _GetNumber then begin // получаем номер таймера
   val(Copy(Line,1,I-1),Result.Number,K);
   if K<>0 then begin Result.Number:=0; // тогда это не номер таймера, а сообщение
    Result.Msg:=Trim(Line);Delete(Line,1,I);
    Result.Eliminate:=Mess;exit;
   end;
   _GetNumber:=false;
  end else begin // неидентифицированный остаток - это выводимое текстовое сообщение
   Result.Msg:=Trim(Line);Delete(Line,1,I);
   Result.Eliminate:=Mess;exit;
  end;
  Delete(Line,1,I);
 end;
 if(Result.Eliminate=Mess)and(Result.Msg='')then Result.Msg:='Время закончилось';
 if(Result.Eliminate=Exec)and(Result.Msg='')then Result.Time:=-2;
 if Result.Number>Max then Result.Time:=-2;
end;

function Str2Time(S:string):integer; // выделяет время из строки
var I,J:integer;
    Mode:(Hr,Min,Sec);
begin Result:=0;J:=0;
 For I:=1 to Length(S) do if not(S[I]in[':','0'..'9'])then exit;
 For I:=1 to Length(S) do if S[I]=':' then Inc(J);
 if J=0 then Val(S,Result,J)else begin
  case J of
   1:Mode:=Min;
   2:Mode:=Hr;
   else exit;
  end;
  J:=0;For I:=1 to Length(S) do
   if S[I]=':' then case Mode of
    Hr:begin if J>24 then begin Result:=0;exit;end;Inc(Result,3600*J);J:=0;Mode:=Min;end;
    Min:begin if J>59 then begin Result:=0;exit;end;Inc(Result,60*J);J:=0;Mode:=Sec;end;
    Sec:begin Result:=0;exit;end;
   end else J:=10*J+ord(S[I])-ord('0');
  if Mode=Sec then Inc(Result,J);
 end;
end;

function Time2Str(Time:integer):string; // перевести в часы:минуты:секунды
var Use:boolean;
    S:string[5];
begin
 Result:='';Use:=false;
 if Time>3600 then begin
  Str(Time div 3600,S);
  if Length(S)<2 then S:='0'+S;
  Result:=S+':';
  Use:=true;
 end;
 Time:=Time mod 3600;
 if(Time>60)or Use then begin
  Str(Time div 60,S);
  if Length(S)<2 then S:='0'+S;
  Result:=Result+S+':';
  Use:=true;
 end;
 Time:=Time mod 60;
 Str(Time,S);
 if Use and(Length(S)<2)then S:='0'+S;
 Result:=Result+S;
end;

function Time2Str2(Time:integer):string; // перевести в NN ч. NN м. NN с.
begin
 if Time=0 then Result:='0с.' else Result:='';
 if Time>3600 then Result:=Result+inttostr(Time div 3600)+'ч.';
 Time:=Time mod 3600;
 if Time>60 then Result:=Result+inttostr(Time div 60)+'м.';
 Time:=Time mod 60;
 if Time>0 then Result:=Result+inttostr(Time)+'с.';
end;

end.
