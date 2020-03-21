unit Cutter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TCutForm = class(TForm)
    Label1: TLabel;
    InName: TEdit;
    InBr: TButton;
    Label2: TLabel;
    OutName: TEdit;
    OutBr: TButton;
    Label3: TLabel;
    Mode: TComboBox;
    Label4: TLabel;
    Sizes: TEdit;
    ReqMode: TCheckBox;
    OK: TButton;
    Cancel: TButton;
    Open: TOpenDialog;
    Status: TLabel;
    DelSrc: TCheckBox;
    BrL: TButton;
    MakeBat: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure InBrClick(Sender: TObject);
    procedure OutBrClick(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure ModeChange(Sender: TObject);
    procedure BrLClick(Sender: TObject);
  end;

var
  CutForm: TCutForm;

implementation

{$R *.dfm}

{$ifdef debug}
Uses IniFiles;
var Ini:TIniFile;
{$else}
Uses Media;
{$endif}

Const MainGroup='FileCutter';

procedure TCutForm.FormCreate(Sender: TObject);
begin
 {$ifdef debug}
 Ini:=TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
 {$endif}
 Caption:=Ini.ReadString(MainGroup,'Caption','File cutter');
 Label1.Caption:=Ini.ReadString(MainGroup,'InputCap','Input (output) file');
 Label2.Caption:=Ini.ReadString(MainGroup,'OutputCap','Output (input) files');
 Label3.Caption:=Ini.ReadString(MainGroup,'ModeCap','Mode');
 Mode.Items.Strings[0]:=Ini.ReadString(MainGroup,'CutCap','Cut');
 Mode.Items.Strings[1]:=Ini.ReadString(MainGroup,'RestoreCap','Restore');
 ReqMode.Caption:=Ini.ReadString(MainGroup,'RequestCap','Request after each file');
 Ok.Caption:=Ini.ReadString(MainGroup,'Ok','Start');
 Cancel.Caption:=Ini.ReadString(MainGroup,'Cancel','Close');
 DelSrc.Caption:=Ini.ReadString(MainGroup,'DelSrcCap','Delete source files');
 MakeBat.Caption:=Ini.ReadString(MainGroup,'MakeBatCap','Create batch file');

 InName.Text:=Ini.ReadString(MainGroup,'Input','');
 OutName.Text:=Ini.ReadString(MainGroup,'Output','');
 Mode.ItemIndex:=Ini.ReadInteger(MainGroup,'Mode',0);
 ReqMode.Checked:=Ini.ReadBool(MainGroup,'Request',false);
 DelSrc.Checked:=Ini.ReadBool(MainGroup,'DelSrc',false);
 MakeBat.Checked:=Ini.ReadBool(MainGroup,'MakeBat',false);
 ModeChange(Sender);
end;

procedure TCutForm.FormDestroy(Sender: TObject);
begin
 Ini.WriteString(MainGroup,'Input',InName.Text);
 Ini.WriteString(MainGroup,'Output',OutName.Text);
 Ini.WriteInteger(MainGroup,'Mode',Mode.ItemIndex);
 Ini.WriteBool(MainGroup,'Request',ReqMode.Checked);
 Ini.WriteBool(MainGroup,'DelSrc',DelSrc.Checked);
 Ini.WriteBool(MainGroup,'MakeBat',MakeBat.Checked);
 ModeChange(Sender);
 {$ifdef debug}
 Ini.Free;
 {$endif}
end;

procedure TCutForm.InBrClick(Sender: TObject);
begin
 Open.Title:=Ini.ReadString(MainGroup,'InTitle','Select input file');
 Open.Filter:=Ini.ReadString(MainGroup,'AllFile','All files')+'|*.*';
 if Open.Execute then InName.Text:=Open.FileName;
end;

procedure TCutForm.OutBrClick(Sender: TObject);
begin
 Open.Title:=Ini.ReadString(MainGroup,'OutTitle','Select output file mask');
 Open.Filter:=Ini.ReadString(MainGroup,'AllFile','All files')+'|*.*';
 if Open.Execute then OutName.Text:=Open.FileName;
end;

Function GetSize(var Line:string):integer;
var I,R1:integer;
    S:string;
begin Result:=0;
 if Line='' then exit;
 I:=pos(';',Line);if I=0 then I:=Length(Line)+1;
 S:=trim(Copy(Line,1,I-1));
 Delete(Line,1,I);Line:=trim(Line);
 R1:=0;
 for I:=1 to Length(S) do case upcase(S[I]) of
  '0'..'9':R1:=10*R1+ord(S[I])-ord('0');
  'G':begin Inc(Result,R1*1024*1024*1024);R1:=0;end;
  'M':begin Inc(Result,R1*1024*1024);R1:=0;end;
  'K':begin Inc(Result,R1*1024);R1:=0;end;
 end;
 Inc(Result,R1);
end;

Function FileNo(Name:string;Index:integer):string;
var I:integer;
    S:string[10];
    J:byte;
begin
 Result:='';
 I:=1;While(I<=Length(Name))do
  if Name[I]='%' then
   if Name[I+1]='%' then begin Result:=Result+'%';Inc(I,2);
   end else if(upcase(Name[I+2])<>'D')then inc(I,3)
   else begin
    J:=ord(Name[I+1])-ord('0');
    Str(Index,S);
    while(length(S)<J)do S:='0'+S;
    Result:=Result+S;
    Inc(I,3);
  end else begin
   Result:=Result+Name[I];
   Inc(I);
  end;
end;

Function Min(X,Y:integer):integer;
begin if X>Y then Result:=Y else Result:=X;end;

procedure TCutForm.OKClick(Sender: TObject);
Const BufLen=1024;
var S:string;
    F,Fo,R,W,Count,Size,OldSize,Test,I:cardinal;
    Buf:array[1..BufLen]of char;
    First:boolean;
    T:TextFile;
    X,Y:PChar;
function AppendFile(Name:string):boolean;
begin
 StrPCopy(X,Name);
 if ReqMode.Checked then MessageBox(Handle,X,StrPCopy(Y,Ini.ReadString(MainGroup,'Confirmation','Confirmation')),MB_ICONINFORMATION);
 Fo:=CreateFile(X,GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,
  FILE_FLAG_SEQUENTIAL_SCAN,0);
 if Fo<>INVALID_HANDLE_VALUE then begin
  repeat
   if not ReadFile(Fo,Buf,BufLen,R,nil) then R:=0;
   if(R=0)or(not WriteFile(F,Buf,R,W,nil))then W:=0;
   if Test>=10 then begin Application.ProcessMessages;Test:=0;end;
   Inc(Test);
  until(R=0)or(W=0);
  CloseHandle(Fo);
  if DelSrc.Checked then DeleteFile(X);
  Result:=false;
 end else
  Result:=MessageBox(Handle,StrPCopy(X,Format(Ini.ReadString(MainGroup,'Filenotexist','File %s not exists. Continue?'),[X])),
   StrPCopy(Y,Ini.ReadString(MainGroup,'Confirmation','Confirmation')),MB_YESNO or MB_ICONEXCLAMATION or MB_DEFBUTTON2)=IDNO;
end;
begin
 GetMem(X,1024);GetMem(Y,1024);
 OldSize:=0;Count:=0;Test:=0;
 Ok.Enabled:=false;Cancel.Tag:=1;
 First:=true;
 if Mode.ItemIndex=0 then begin // разрезание файлов
  StrPCopy(X,InName.Text);
  F:=CreateFile(X,GENERIC_READ,FILE_SHARE_READ,nil,
   OPEN_EXISTING,FILE_ATTRIBUTE_ARCHIVE or FILE_FLAG_SEQUENTIAL_SCAN,0);
  if F=INVALID_HANDLE_VALUE then
   MessageBox(Handle,StrPCopy(X,Ini.ReadString(MainGroup,'InputFileErrorCap','Error opening input file')),
    StrPCopy(Y,Ini.ReadString(MainGroup,'Confirmation','Confirmation')),MB_OK or MB_ICONSTOP)
  else begin
   if MakeBat.Checked then begin
    S:='';
    R:=1;while R<=Length(OutName.Text) do if OutName.Text[R]='%' then
     if OutName.Text[R+1]='%' then begin
      S:=S+'%';
      Inc(R,2);
     end else Inc(R,3)
    else begin
     S:=S+OutName.Text[R];
     Inc(R);
    end;
    AssignFile(T,ChangeFileExt(S,'.bat'));{$I-}Rewrite(T);{$I+}
    if IOResult<>0 then MakeBat.Checked:=false else Write(T,'copy /b ');
   end;
   S:=Sizes.Text;
   repeat  // начали разрезание
    Size:=GetSize(S);
    if Size=0 then Size:=OldSize else OldSize:=Size;
    if Size<>0 then begin
     StrPCopy(X,FileNo(OutName.Text,Count));
     Status.Caption:=X;
     if(FileExists(X))then
      case MessageBox(Handle,StrPCopy(X,Format(Ini.ReadString(MainGroup,'RewriteFile','File %s exists. Overwrite?'),[X])),
       StrPCopy(Y,Ini.ReadString(MainGroup,'Confirmation','Confirmation')),MB_YESNOCANCEL or MB_APPLMODAL) of
       IDNO:continue;
       IDCANCEL:break;
      end;
     if ReqMode.Checked then MessageBox(Handle,X,StrPCopy(Y,Ini.ReadString(MainGroup,'Confirmation','Confirmation')),MB_ICONINFORMATION);
     Fo:=CreateFile(X,GENERIC_WRITE,0,nil,
      CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE or FILE_FLAG_WRITE_THROUGH or FILE_FLAG_SEQUENTIAL_SCAN,0);
     Inc(Count);
     if Fo<>INVALID_HANDLE_VALUE then begin
      if MakeBat.Checked then
       if First then begin Write(T,ExtractFileName(X));First:=false;end
       else Write(T,'+',ExtractFileName(X));
      repeat // блок копирования указанного размера
       if not ReadFile(F,Buf,Min(BufLen,Size),R,nil) then R:=0;
       if(R=0)or(not WriteFile(Fo,Buf,R,W,nil))then W:=0 else Dec(Size,W);
       if Test>=10 then begin Application.ProcessMessages;Test:=0;end;
       Inc(Test);
      until(Size=0)or(W=0)or(R=0)or(Cancel.Tag<>1);
      CloseHandle(Fo);
      if Cancel.Tag<>1 then DeleteFile(X);
     end else case MessageBox(Handle,StrPCopy(X,Format(Ini.ReadString(MainGroup,'OutputFileErrorCap','File %s does not exist. Continue?'),[X])),
      StrPCopy(Y,Ini.ReadString(MainGroup,'Confirmation','Confirmation')),MB_YESNO or MB_DEFBUTTON2 or MB_ICONEXCLAMATION) of
      IDNO:break;
     end;
    end;
   until(R=0)or(Cancel.Tag<>1);
   CloseHandle(F);
   StrPCopy(X,InName.Text);
   if MakeBat.Checked then begin
    Writeln(T,' ',ExtractFileName(InName.Text));
    CloseFile(T);
   end;
   if DelSrc.Checked then DeleteFile(X);
  end;
 end else if(Sizes.Text='')and(Mode.ItemIndex=1)then begin  // объединение файлов с жесткого диска
  OldSize:=10001;Size:=0;
  For R:=0 to 10000 do
   if FileExists(FileNo(OutName.Text,R))then
    if OldSize=10001 then begin OldSize:=R;Size:=R;end
    else Size:=R
   else
    if OldSize<>10001 then break;
  if OldSize<>10001 then begin
   StrPCopy(X,InName.Text);
   F:=CreateFile(X,GENERIC_WRITE,FILE_SHARE_READ,nil,CREATE_ALWAYS,
    FILE_ATTRIBUTE_ARCHIVE or FILE_FLAG_SEQUENTIAL_SCAN,0);
   if F<>INVALID_HANDLE_VALUE then begin
    For Count:=OldSize to Size do begin
     if AppendFile(FileNo(OutName.Text,Count)) then break;
     if Test>=10 then begin Application.ProcessMessages;Test:=0;end;
     Inc(Test);
     if Cancel.Tag<>1 then break;
    end;
    CloseHandle(F);
   end else MessageBox(Handle,StrPCopy(X,Ini.ReadString(MainGroup,'InputFileErrorCap','Error creating output file!')),
    StrPCopy(Y,Ini.ReadString(MainGroup,'Confirmation','Confirmation')),MB_ICONSTOP);
  end;
 end else if(Mode.ItemIndex=1) then begin  // объединение файлов с носителей
  StrPCopy(X,InName.Text);
  F:=CreateFile(X,GENERIC_WRITE,FILE_SHARE_READ,nil,CREATE_ALWAYS,
   FILE_ATTRIBUTE_ARCHIVE or FILE_FLAG_SEQUENTIAL_SCAN,0);
  if F<>INVALID_HANDLE_VALUE then begin
   R:=0;S:=Sizes.Text+',';OldSize:=0;Size:=0;
   For I:=1 to Length(S) do begin case S[I] of
    '0'..'9':if R=0 then OldSize:=10*OldSize+ord(S[I])-ord('0')
     else Size:=10*Size+ord(S[I])-ord('0');
    '-':begin Size:=0;R:=1;end;
    ',':if R=0 then begin
      if AppendFile(FileNo(OutName.Text,OldSize)) then break;
      OldSize:=0;R:=0;
     end else begin
      For Count:=OldSize to Size do begin
       if AppendFile(FileNo(OutName.Text,Count)) then break;
       if Test>=10 then begin Application.ProcessMessages;Test:=0;end;
       Inc(Test);
       if Cancel.Tag<>1 then break;
      end;
      if Count<=Size then break; // повторный выход
      R:=0;
     end;
    end;
    if Test>=10 then begin Application.ProcessMessages;Test:=0;end;
    Inc(Test);
    if Cancel.Tag<>1 then break;
   end;
   CloseHandle(F);
  end else MessageBox(Handle,StrPCopy(X,Ini.ReadString(MainGroup,'InputFileErrorCap','Error creating output file!')),
   StrPCopy(Y,Ini.ReadString(MainGroup,'Confirmation','Confirmation')),MB_ICONSTOP);
 end else if Mode.ItemIndex=2 then begin
  StrPCopy(X,InName.Text);
  F:=CreateFile(X,GENERIC_WRITE,FILE_SHARE_READ,nil,CREATE_ALWAYS,
   FILE_ATTRIBUTE_ARCHIVE or FILE_FLAG_SEQUENTIAL_SCAN,0);
  if F<>INVALID_HANDLE_VALUE then begin
   AssignFile(T,Sizes.Text);{$I-}Reset(T);{$I+}
   if IOResult=0 then begin
    while not EOF(T) do begin
     Readln(T,S);
     if(S[1]=';')or(S='')then continue;
     if AppendFile(S) then break;
     if Test>=10 then begin Application.ProcessMessages;Test:=0;end;
     Inc(Test);
     if Cancel.Tag<>1 then break;
    end;
    CloseFile(T);
    CloseHandle(F);
   end else begin
    CloseHandle(F);
    DeleteFile(X);
    MessageBox(Handle,StrPCopy(X,Ini.ReadString(MainGroup,'ListFileErrorCap','List file open error')),
     StrPCopy(Y,Ini.ReadString(MainGroup,'Confirmation','Confirmation')),MB_ICONSTOP);
   end;
  end else MessageBox(Handle,StrPCopy(X,Ini.ReadString(MainGroup,'InputFileErrorCap','Error creating output file!')),
   StrPCopy(Y,Ini.ReadString(MainGroup,'Confirmation','Confirmation')),MB_ICONSTOP);
 end;
 Cancel.Tag:=0;Cancel.Enabled:=true;Ok.Enabled:=true;
 Status.Caption:='';
 FreeMem(Y,1024);FreeMem(X,1024);
end;

procedure TCutForm.CancelClick(Sender: TObject);
begin
 if Cancel.Tag=1 then begin
  Cancel.Tag:=2;
  Cancel.Enabled:=false;
 end else begin
  ModalResult:=mrCancel;
  {$ifdef debug}
  Close;
  {$endif}
 end;
end;

procedure TCutForm.ModeChange(Sender: TObject);
begin
 case Mode.Tag of
  0:Ini.WriteString(MainGroup,'Sizes',Sizes.Text);
  1:Ini.WriteString(MainGroup,'Number',Sizes.Text);
  2:Ini.WriteString(MainGroup,'ListFile',Sizes.Text);
 end;
 case Mode.ItemIndex of
  0:begin
   Label4.Caption:=Ini.ReadString(MainGroup,'SizeCap','Sizes:');
   Sizes.Text:=Ini.ReadString(Maingroup,'Sizes','');
   Sizes.Width:=193;
   BrL.Visible:=false;
  end;
  1:begin
   Label4.Caption:=Ini.ReadString(MainGroup,'NumberCap','Numbers:');
   Sizes.Text:=Ini.ReadString(Maingroup,'Number','');
   Sizes.Width:=193;
   BrL.Visible:=false;
  end;
  2:begin
   Label4.Caption:=Ini.ReadString(MainGroup,'ListCap','File list:');
   Sizes.Text:=Ini.ReadString(Maingroup,'List','');
   Sizes.Width:=169;
   BrL.Visible:=true;
  end;
 end;
 Mode.Tag:=Mode.ItemIndex;
end;

procedure TCutForm.BrLClick(Sender: TObject);
begin
 Open.Title:=Ini.ReadString(MainGroup,'ListTitle','Select file list');
 Open.Filter:=Ini.ReadString(MainGroup,'AllFile','All files')+'|*.*';
 if Open.Execute then Sizes.Text:=Open.FileName;
end;

end.
