unit WinCron;

interface

Uses Windows,Classes,Common;

Type TByteSet=set of byte;
     TWhen=array[0..5]of TByteSet;  // Min,Hour,Day,Mon,Dow,Year

Type TCron=class(TObject)
      When:TWhen;
      Kind:byte;
      Late:boolean;
      Line,Name:string;
      NextTime:TDateTime;
      Constructor Create(S:string;OldTime:TDateTime=0);overload;
      Constructor Create(Z:TCron);overload;
      function Get:string;
      function Verify:boolean;
      function Next(const Date:TDateTime):TDateTime;
      procedure Run;
     end;

Type TCrons=array[1..Max]of TCron;

Type TSheduler=class(TThread)
      Crons:TCrons;
      CronNum:integer;
      Constructor Create;
      Procedure ReadCrons;
      Procedure WriteCrons;
      Procedure Free;
      protected
       Procedure Execute;override;
      private
       OldMin:byte;
     end;

var Sheduler:TSheduler;

implementation

Uses SysUtils,DateUtils,Types,Dialogs;

Constructor TSheduler.Create;
begin
 Inherited Create(false);
 CronNum:=0;
 ReadCrons;
 Priority:=tpIdle;
 OldMin:=255; // такого времени не существует
end;

Procedure TSheduler.Free;
var I:integer;
begin
 WriteCrons;
 For I:=1 to CronNum do Crons[I].Free;
 inherited Free;
end;

Procedure TSheduler.Execute;
var SystemTime:TSystemTime;
var I:integer;
begin
 repeat
  GetLocalTime(SystemTime);
  if OldMin<>SystemTime.wMinute then begin
   For I:=1 to CronNum do if Crons[I].Verify then Crons[I].Run;
   OldMin:=SystemTime.wMinute;
  end;
  Sleep(500);
 until Terminated;
end;

Procedure TSheduler.WriteCrons;
var I,Num:integer;
begin
 Num:=Ini.ReadInteger(CronSection,CronNumber,0);
 For I:=1 to Num do begin
  Ini.DeleteKey(CronSection,'CronName'+inttostr(I));
  Ini.DeleteKey(CronSection,'CronString'+inttostr(I));
  Ini.DeleteKey(CronSection,'CronDate'+inttostr(I));
 end;
 Ini.WriteInteger(CronSection,CronNumber,CronNum);
 For I:=1 to CronNum do begin
  Ini.WriteString(CronSection,'CronName'+inttostr(I),Crons[I].Name);
  Ini.WriteString(CronSection,'CronString'+inttostr(I),Crons[I].Get);
  Ini.WriteString(CronSection,'CronDate'+inttostr(I),PutStringDate(Crons[I].NextTime));
 end;
end;

Procedure TSheduler.ReadCrons;
var I,Total:integer;
    S:string;
    Errors:word;
begin
 For I:=1 to CronNum do Crons[I].Free;
 Total:=Ini.ReadInteger(CronSection,CronNumber,0);
 CronNum:=0;Errors:=0;
 For I:=1 to Total do begin
  S:=Ini.ReadString(CronSection,'CronDate'+inttostr(I),'');
  try
   Crons[CronNum+1]:=TCron.Create(Ini.ReadString(CronSection,'CronString'+inttostr(I),'*'),GetStringDate(S));
   Inc(CronNum);
   Crons[CronNum].Name:=Ini.ReadString(CronSection,'CronName'+inttostr(I),'');
  except
   Inc(Errors);
  end;
 end;
 if Errors>0 then
  MessageDlg(Format(Ini.ReadString(Language,'ErrorIniLoad','%d errors during loading from INI'),[Errors]),mtError,[mbOK],0);
end;

Constructor TCron.Create(S:string;OldTime:TDateTime);
procedure DetectLoLevel(S:string;var Bs:TByteSet;IsYear:boolean);
var I:integer;
    J,I1,I2:integer;
    Mode:(Index1,Index1s,Index2,Index2s);
begin
 Mode:=Index1;I1:=0;I2:=0;
 FillChar(Bs,sizeof(TByteSet),0); // удалить все элементы из множества
 For I:=1 to Length(S) do case S[I] of
  '0'..'9':case Mode of
   Index1:begin I1:=ord(S[I])-ord('0');Mode:=Index1s;end;
   Index1s:I1:=10*I1+ord(S[I])-ord('0');
   Index2:begin I2:=ord(S[I])-ord('0');Mode:=Index2s;end;
   Index2s:I2:=10*I2+ord(S[I])-ord('0');
  end;
  ',':begin
   if Mode=Index1s then if IsYear then Include(Bs,I1-1980) else Include(Bs,I1);
   if Mode=Index2s then For J:=I1 to I2 do if IsYear then Include(Bs,J-1980) else Include(Bs,J);
   Mode:=Index1;
  end;
  '-':if Mode=Index1s then Mode:=Index2 else Exit; // либо переход на новый режим, либо ошибка
  '*':begin FillChar(Bs,sizeof(TByteSet),$FF);Exit;end;
 end;
 if Mode=Index1s then if IsYear then Include(Bs,I1-1980) else Include(Bs,I1);
 if Mode=Index2s then For J:=I1 to I2 do if IsYear then Include(Bs,J-1980) else Include(Bs,J);
end;

var Sr:string;
    Count:byte;
begin
 inherited Create;
 FillChar(When,sizeof(TWhen),$FF);
 Line:='';Name:='';Kind:=255;Late:=false;
 Count:=0;
 while Length(S)>0 do begin
  Sr:=GetNext(S);if(Sr[1]='/')then Count:=10;
  if Count<=5 then begin DetectLoLevel(Sr,When[Count],Count=5);Inc(Count);
  end else if CompareText(Sr,'/msg')=0 then begin Kind:=0;Line:=S;break; // замена служебных символов
  end else if CompareText(Sr,'/osd')=0 then begin Kind:=1;Line:=S;break;
  end else if CompareText(Sr,'/run')=0 then begin Kind:=2;Line:=S;break;
  end else if CompareText(Sr,'/tar')=0 then begin Kind:=3;Line:=S;break;
  end else if CompareText(Sr,'/late')=0 then Late:=true
  else if Sr[1]<>'/' then begin Kind:=0;Line:=S;break;end;
 end;
 if(Kind=0)and(Line='')then Line:=FormatDateTime('c',Next(Now));
 if(Kind>3)or(((Kind=1)or(Kind=2)or(Kind=3))and(Line=''))then
  raise Exception.Create(Ini.ReadString(Language,'TaskNotDef','Task not defined!'));
 if OldTime=0 then NextTime:=Next(IncMinute(Now))
 else if(CompareDateTime(Now,OldTime)=GreaterThanValue)then
  if Late then Run else NextTime:=Next(IncMinute(Now))
 else NextTime:=OldTime;
end;

Function TCron.Next(const Date:TDateTime):TDateTime;
Function FindNextValid(Index:byte):boolean;
var I:byte;
begin
 if Index>5 then begin Result:=false;exit;end; // перебор
 while(not(Words[Index] in When[Index])and(Words[Index]<=Index2(Index)))do Inc(Words[Index]);
 if Words[Index]<=Index2(Index) then Result:=true // нашли подходящий элемент
 else begin // подходящих элементов нет
  For I:=Index downto 0 do Words[I]:=Index1(I); // сброс нижележащих
  if Index=5 then Result:=false
  else if Index=3 then begin
   Inc(Words[Index+2]);
   Result:=FindNextValid(Index+2);
  end else begin
   Inc(Words[Index+1]);
   Result:=FindNextValid(Index+1);
  end;
  if Result then Result:=FindNextValid(Index);
 end;
end;
var I:byte;
begin
 DecodeDate(Date,Words[5],Words[3],Words[2]);
 DecodeTime(Date,Words[1],Words[0],Words[6],Words[7]);
 repeat
  Dec(Words[5],1980);
  For I:=5 downto 0 do
   if not FindNextValid(I) then begin Result:=0;exit;end;
    // невозможно найти подходящий результят
  Inc(Words[5],1980);
  Result:=EncodeDate(Words[5],Words[3],Words[2])+EncodeTime(Words[1],Words[0],Words[6],Words[7]);
  Words[4]:=DayOfWeek(Result)-1; // только для определения дня недели вызывалась предыдущая строка
  if(Words[4] in When[4])then exit else Inc(Words[2]);
 until false;
end;

Constructor TCron.Create(Z:TCron);
begin
 inherited Create;
 When:=Z.When;Kind:=Z.Kind;Late:=Z.Late;
 Line:=Z.Line;Name:=Z.Name;NextTime:=Z.NextTime;
end;

function TCron.Get:string;
function Detect(const BS:TByteSet;I1,I2:byte;IsYear:boolean):string;
var I:byte;
    J:boolean;
    St:integer;
begin
 J:=true;Result:='';
 For I:=I1 to I2 do if not(I in BS) then J:=false;
 if J then Result:='*' else begin
  St:=-1;
  For I:=I1 to I2 do
   if(I in Bs)then if St=-1 then St:=I else else if St<>-1 then begin
    if St=I-1 then if IsYear then Result:=Result+','+inttostr(St+1980) else Result:=Result+','+inttostr(St)
    else if IsYear then Result:=Result+','+inttostr(St+1980)+'-'+inttostr(I+1979) else Result:=Result+','+inttostr(St)+'-'+inttostr(I-1);
    St:=-1;
   end;
  if St<>-1 then
   if St=I2 then if IsYear then Result:=Result+','+inttostr(I2+1980) else Result:=Result+','+inttostr(I2)
   else if IsYear then Result:=Result+','+inttostr(St+1980)+'-'+inttostr(I2+1980) else Result:=Result+','+inttostr(St)+'-'+inttostr(I2-1);
  if Result<>'' then Delete(Result,1,1);
 end;
end;
var I,Last:byte;
begin Result:='';
 For Last:=5 downto 1 do if Detect(When[Last],Index1(Last),Index2(Last),Last=5)<>'*' then break;
 For I:=0 to Last do Result:=Result+Detect(When[I],Index1(I),Index2(I),I=5)+' ';
 if Late then Result:=Result+'/Late ';
 case Kind of
  0:Result:=Result+'/msg '+Line;
  1:Result:=Result+'/osd '+Line;
  2:Result:=Result+'/run '+Line;
  3:Result:=Result+'/tar '+Line;
 end;
end;

procedure TCron.Run;
var X,Y:PChar;
    Mode:byte;
    I,I1,I2,I3:integer;
begin
 GetMem(X,1024);GetMem(Y,1024);
 case Kind of
  0:MessageBox(0,strpcopy(X,Filter(Line)),strpcopy(y,Ini.ReadString('Language','Status','Status')),MB_OK or MB_ICONINFORMATION or MB_SYSTEMMODAL);
  1:begin
   DrawOSD(Line);
   Sleep(1000);
   InvalidateRect(0,nil,false);
  end;
  2:begin Mode:=0;I1:=1;I2:=1;I3:=1;
   For I:=1 to Length(Line) do case Line[I] of
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
   ExecuteFile(copy(Line,I1,I2-I1+1),copy(Line,I3,Length(Line)-I3+1),'',SW_SHOW);
  end;
  3:SendText(TarHandle,Line);
 end;
 FreeMem(Y,1024);FreeMem(X,1024);
 NextTime:=Next(IncMinute(Now));
end;

Function TCron.Verify:boolean;
var SysTime:TSystemTime;
begin
 GetLocalTime(SysTime);
 Result:=(SysTime.wYear-1980 in When[5])and(SysTime.wDayOfWeek in When[4])and
         (SysTime.wMonth in When[3])and(SysTime.wDay in When[2])and
         (SysTime.wHour in When[1])and(SysTime.wMinute in When[0]);
end;

end.
