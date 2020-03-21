unit InOut;

interface

Const Max=25;

Type TLoad=object // there is no reason to define that as class
      Once:boolean;
      Kind:byte;
      Str:string;
      Timeout:longint;
      Constructor Create(S:string);
      Procedure Run;
      Function Get:string;
     end;

     TLoads=object
      Number:byte;
      Loads:array[0..Max-1]of TLoad;
      Procedure Delete(S:string);
      Procedure Modify(S:string);
      Procedure Load(Group:string);
      Procedure Store(Group:string);
     end;

Procedure UnloadCDs;

implementation

Uses Common,Windows,SysUtils;

Procedure UnloadCDs;
var C:char;
    P:PChar;
    Sr:TSearchRec;
begin
 GetMem(P,8);
 For C:='A' to 'Z' do begin
  StrPCopy(P,C+':\');
  if GetDriveType(P)=DRIVE_CDROM then begin
   if FindFirst(C+':\*.*',faAnyFile,Sr)=0 then begin
    SendText(TarHandle,'~cdeject +'+C);
    DrawOSD(C+':\');
   end;
   FindClose(Sr);
  end;
 end;
 FreeMem(P,8);
end;

Constructor TLoad.Create(S:string);
var X:string;
    J,K:integer;
begin
 Once:=false;Kind:=255;Str:='';Timeout:=0;
 while S<>'' do begin
  X:=GetNext(S);
  if CompareText(X,'/1')=0 then Once:=true
  else if CompareText(X,'/msg')=0 then begin Kind:=0;Str:=S;S:='';end
  else if CompareText(X,'/osd')=0 then begin Kind:=1;Str:=S;S:='';end
  else if CompareText(X,'/run')=0 then begin Kind:=2;Str:=S;S:='';end
  else if CompareText(X,'/tar')=0 then begin Kind:=3;Str:=S;S:='';end
  else if CompareText(X,'/timeout')=0 then begin
   X:=GetNext(S);
   Val(X,J,K);
   if K<>0 then begin S:=X+' '+S;Timeout:=1;end
   else Timeout:=J;
  end;
 end;
end;

Procedure TLoad.Run;
var I:integer;
    X,Y:PChar;
begin
 GetMem(X,1024);GetMem(Y,1024);
 case Kind of
  0:MessageBox(TarHandle,strpcopy(X,Filter(Str)),strpcopy(y,Ini.ReadString('Language','Status','Status')),MB_OK or MB_ICONINFORMATION);
  1:DrawOSD(Str);
  2:begin
   I:=Pos(' ',Str);if I=0 then I:=Length(Str)+1;
   ExecuteFile(copy(Str,1,I-1),copy(Str,I+1,Length(Str)-I),'',SW_SHOW);
  end;
  3:SendText(TarHandle,Str);
 end;
 FreeMem(Y,1024);FreeMem(X,1024);
end;

Function TLoad.Get:string;
begin
 if Once then Result:='/1 ' else Result:='';
 if Timeout<>0 then Result:=Result+'/timeout '+inttostr(Timeout)+' ';
 case Kind of
  0:Result:=Result+'/msg';
  1:Result:=Result+'/osd';
  2:Result:=Result+'/run';
  3:Result:=Result+'/tar';
 end;
 Result:=Result+' '+Str;
end;

Procedure TLoads.Delete(S:string);
var I,J,X:integer;
begin
 I:=pos(' ',S);if I=0 then I:=length(S)+1;
 val(copy(S,1,I-1),X,J);
 if J<>0 then X:=-1 else system.Delete(S,1,I);
 Dec(X);
 if X<0 then Number:=0
 else if X<Number then begin
  For I:=X to Number-2 do Loads[I]:=Loads[I+1];
  Dec(Number);
 end;
end;

Procedure TLoads.Modify(S:string);
var I,J,X:integer;
begin
 I:=pos(' ',S);if I=0 then I:=length(S)+1;
 val(copy(S,1,I-1),X,J);
 if J<>0 then X:=-1 else system.Delete(S,1,I);
 Dec(X);
 if(X>=0)and(X<Number)then Loads[X].Create(S)
 else begin
  Loads[Number].Create(S);
  if Loads[Number].Kind in [0..3] then Inc(Number);
 end;
end;

Procedure TLoads.Load(Group:string);
var I,Count:byte;
begin
 Number:=0;
 Count:=Ini.ReadInteger(Group,'Number',0);
 For I:=1 to Count do
  Modify(Ini.ReadString(Group,'Auto'+inttostr(I),''));
end;

Procedure TLoads.Store(Group:string);
var I,Count:integer;
begin
 Count:=Ini.ReadInteger(Group,'Number',0);
 For I:=1 to Count do Ini.DeleteKey(Group,'Auto'+inttostr(I));
 Ini.WriteInteger(Group,'Number',Number);
 For I:=1 to Number do Ini.WriteString(Group,'Auto'+inttostr(I),Loads[I-1].Get);
end;

end.
