unit Common;

interface

Type TFile1Proc=procedure(const S:string);
Type TFile2Proc=Procedure(const Name1,Name2:string);

Function Replace(const S:string;const Src,Dst:string):string;
 // заменяет все вхождения строки Src в S на Dst
Function Replace2(const Data:string;const Src:string;const Dst:string):string;
 // заменяет все вхождения вида {Src} на Dst, {Src num1} на вырезку из Dst
 // с num1 символа до конца, {Src num1 num2} на вырезку из Dst с num1 символа
 // до num2 символа
function Mask(const S:string):string;
function Unmask(const S:string):string;
Function ExtractName(const Name:string):string;
Procedure Process1File(const aName:string;aLevel:byte;File1Proc:TFile1Proc);
Procedure Process2Files(const aName1,aName2:string;Level:byte;File2Proc:TFile2Proc;Reality:boolean);
Function DetectSize(S:string):integer;
procedure PartCopy(const S1,S2:string;Index,Size:integer);
Function AbsToRel(S1,S2:string):string;
function Abstorel2(NowPath,FileName:string):string;

var Stat:(None,Running,Stopping);
var TempDir,WinDir:shortstring;

implementation

Uses Windows,SysUtils;

Function AbsToRel(S1,S2:string):string;
var I:word;
begin S1:=AnsiUpperCase(S1);S2:=AnsiUpperCase(S2);
 I:=1;While(I<=Length(S1))and(I<=Length(S2))and(S1[I]=S2[I])do Inc(I);
 if(I<=Length(S1))and(I<=Length(S2))then while(I>0)and(S1[I]<>'\')and(S2[I]<>'\')do Dec(I);
 Delete(S2,1,I);
 For I:=I to Length(S1) do if S1[I]='\' then S2:='..\'+S2;
 if S2<>'' then if S2[Length(S2)]='\' then SetLength(S2,Length(S2)-1);
 AbsToRel:=S2;
end;

function Abstorel2(NowPath,FileName:string):string;
var X,T:string;
begin
 FileName:=ExpandFileName(FileName);
 if NowPath[Length(NowPath)]='\' then SetLength(NowPath,Length(NowPath)-1);
 X:=ExtractFileName(FileName);SetLength(FileName,Length(FileName)-Length(X)-1);
 T:=AbsTorel(NowPath,FileName);
 if AnsiUpperCase(copy(FileName,1,2))=AnsiUpperCase(copy(NowPath,1,2)) then Delete(FileName,1,2);
 if Length(T)>Length(FileName) then T:=FileName;
 if(T<>'')and(T[Length(T)]<>'\')then T:=T+'\';
 Result:=T+X;
end;

Function Replace(const S:string;const Src,Dst:string):string;
var I:word;
begin
 Result:='';I:=1;
 if Src<>'' then begin
  While(I<=Length(S)-Length(Src)+1)do
   if Copy(S,I,Length(Src))=Src then begin Result:=Result+Dst;Inc(I,Length(Src));end
   else begin Result:=Result+S[I];Inc(I);end;
  While(I<=Length(S))do begin Result:=Result+S[I];Inc(I);end;
 end;
end;

Function Replace2(const Data:string;const Src:string;const Dst:string):string;
var Flag:string;
    Mode:(None,ReadFlag,Read1,Read2,Notsup);
    Data1,Data2,Start,I:word;
begin
 Result:='';Mode:=None;Data1:=0;Data2:=0;Start:=1;
 For I:=1 to Length(Data) do
  case Data[I] of
   '{':case Mode of
     None:begin Flag:='';Data1:=0;Data2:=0;Start:=I;Mode:=ReadFlag;end;
     ReadFlag:if Flag='' then begin Result:=Result+'{';Mode:=None;end;
    end;
   ' ':case Mode of
     None:Result:=Result+' ';
     ReadFlag:Mode:=Read1;
     Read1:Mode:=Read2;
     Read2:Mode:=Notsup;
    end;
   '0'..'9':case Mode of
     None:Result:=Result+Data[I];
     ReadFlag:Flag:=Flag+Data[I];
     Read1:Data1:=10*Data1+ord(Data[I])-ord('0');
     Read2:Data2:=10*Data2+ord(Data[I])-ord('0');
    end;
   '}':begin case Mode of
     None:Result:=Result+Data[I];
     ReadFlag:if CompareText(Flag,Src)=0 then Result:=Result+Dst
      else Result:=Result+copy(Data,Start,I-Start+1);
     Read1:if CompareText(Flag,Src)=0 then Result:=Result+copy(Dst,Data1,Length(Data)-Data1+1)
      else Result:=Result+copy(Data,Start,I-Start+1);
     Read2,Notsup:if CompareText(Flag,Src)=0 then Result:=Result+copy(Dst,Data1,Data2-Data1+1)
      else Result:=Result+copy(Data,Start,I-Start+1);
    end;Mode:=None;end;
   else case Mode of
    None:Result:=Result+Data[I];
    ReadFlag:Flag:=Flag+Data[I];
   end;
  end;
end;

function Mask(const S:string):string;
var I:integer;
begin
 Result:='';
 For I:=1 to Length(S) do
  if S[I]='\' then Result:=Result+'\\'
  else Result:=Result+S[I];
end;

function Unmask(const S:string):string;
var I:integer;
    Masked:boolean;
begin
 Masked:=false;Result:='';
 For I:=1 to Length(S) do
  if Masked then begin
   Result:=Result+S[I];
   Masked:=false;
  end else if S[I]='\' then Masked:=true
  else Result:=Result+S[I];
end;

Function ExtractName(const Name:string):string;
var I:word;
begin
 I:=Length(ExtractFilePath(Name))+1;
 Result:=copy(Name,I,Length(Name)-I+1-Length(ExtractFileExt(Name)));
end;

Procedure Process1File(const aName:string;aLevel:byte;File1Proc:TFile1Proc);
Procedure Recursive(Layer:byte);
var SR:TSearchRec;
    Found:integer;
begin
 Found:=FindFirst(ExtractFileName(aName),faAnyFile,Sr);
 while(Found=0)and(Stat=Running)do begin
  if FileExists(Sr.Name)then File1Proc(ExpandFileName(Sr.Name));
  Found:=FindNext(Sr);
 end;
 FindClose(Sr);
 if Layer>0 then begin
  Found:=FindFirst('*.*',faAnyFile,Sr);
  while(Found=0)and(Stat=Running)do begin // folder processing
   if Sr.Name[1]<>'.' then begin
    {$I-}ChDir(SR.Name);{$I+}
    if IOResult=0 then begin
     Recursive(Layer-1);
     ChDir('..');
    end;
   end;
   Found:=FindNext(SR);
  end;
  FindClose(SR);
 end;
end;
var OldFolder:string;
begin
 {$I-}
 GetDir(0,OldFolder);
 Stat:=Running;
 ChDir(ExtractFileDir(aName));
 if IOResult=0 then begin
  Recursive(aLevel);
  ChDir(OldFolder);IOResult;
 end;
 Stat:=None;
 {$I+}
end;

Procedure Process2Files(const aName1,aName2:string;Level:byte;File2Proc:TFile2Proc;Reality:boolean);
var Target,RelDir,FilePart,ExtPart:string;
    SrcLen:word;
Procedure Process(Level:byte);
var SR:TSearchRec;
    Found:integer;
begin
 if Level>0 then begin
  Found:=FindFirst('*.*',faAnyFile,SR);
  while(Found=0)and(Stat=Running)do begin
   with Sr do if(not FileExists(Name))and(Name[1]<>'.')and(Name[Length(Name)]<>'.')then begin
    {$I-}ChDir(Name);{$I-}
    if IOResult=0 then begin Process(Level-1);ChDir('..');end;
   end;
   Found:=FindNext(Sr);
  end;
  FindClose(SR);
 end;
 Found:=FindFirst(ExtractFileName(aName1),faAnyFile,SR);
 while(Found=0)and(Stat=Running)do begin
  if FileExists(Sr.Name) then begin
   Target:=Replace2(aName2,'FileName',Sr.Name);
   Target:=Replace2(Target,'Name',ExtractName(Sr.Name));
   Target:=Replace2(Target,'Ext',ExtractFileExt(Sr.Name));
   if ExtractFileName(Target)='*' then begin
    FilePart:=Sr.Name;
    ExtPart:='';
   end else begin
    FilePart:=ExtractName(Target);
    if FilePart='*' then FilePart:=ExtractName(Sr.Name);
    ExtPart:=ExtractFileExt(Target);
    if ExtPart='.*' then ExtPart:=ExtractFileExt(Sr.Name);
   end;
   Target:=ExtractFilePath(ExpandFileName(Target));
   RelDir:=ExtractFilePath(ExpandFileName(Sr.Name));
   Delete(RelDir,1,SrcLen);
   {$I-}if(Reality)and(RelDir<>'')then MkDir(Target+RelDir);IOResult;{$I+}
   File2Proc(ExpandFileName(Sr.Name),Target+RelDir+FilePart+ExtPart);
  end;
  Found:=FindNext(SR);
 end;
 FindClose(SR);
end;
var OldDir:string;
begin
 {$I-}
 Stat:=Running;
 GetDir(0,OldDir);
 ChDir(ExtractFileDir(aName1));
 if IOResult=0 then begin
  SrcLen:=Length(ExtractFilePath(ExpandFileName(aName1)));
  Process(Level);
  ChDir(OldDir);
 end;
 Stat:=None;
 {$I+}
end;

Function DetectSize(S:string):integer;
var I,Temp:integer;
begin
 Temp:=0;Result:=0;
 For I:=1 to Length(S) do case upcase(S[I]) of
  '0'..'9':Temp:=10*Temp+ord(S[I])-ord('0');
  'G':begin Inc(Result,Temp*1024*1024*1024);Temp:=0;end;
  'M':begin Inc(Result,Temp*1024*1024);Temp:=0;end;
  'K':begin Inc(Result,Temp*1024);Temp:=0;end;
 end;
 Inc(Result,Temp);
end;

procedure PartCopy(const S1,S2:string;Index,Size:integer);
Const Max=512;
Type TBuffer=array[1..Max]of char;
var Buf:TBuffer;
    F1,F2:file;
    Need,Has,Wrote:integer;
begin
 {$I-}
 AssignFile(F1,S1);Reset(F1,1);
 if IOResult<>0 then begin CloseFile(F1);exit;end;
 ForceDirectories(ExtractFileDir(S2));
 AssignFile(f2,S2);{$I-}Rewrite(F2,1);{$I+}
 if IOResult<>0 then begin CloseFile(F1);CloseFile(F2);exit;end;
 Seek(F1,Index);Need:=Size;
 repeat
  if Need<Max then BlockRead(F1,Buf,Need,Has) else BlockRead(F1,Buf,Max,Has);
  if Has<>0 then BlockWrite(F2,Buf,Has,Wrote);Dec(Need,Has);
 until(Need=0)or(Has=0)or(Wrote<>Has);
 CloseFile(F1);CloseFile(F2);
 {$I+}
end;

Procedure TDir;
var Z:array[0..179]of char;
begin
 GetTempPath(180,Z);
 TempDir:=z;
end;

Procedure WDir;
var Z:array[0..179]of char;
begin
 GetWindowsDirectory(Z,180);
 WinDir:=Z+'\';
end;

begin
 TDir;WDir;
end.



