unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Spin, StdCtrls,IniFiles, Buttons;

type
  TACDGen = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    InFolder: TEdit;
    InMask: TEdit;
    OutFolder: TEdit;
    OutMask: TEdit;
    InBr: TButton;
    OutBr: TButton;
    Label5: TLabel;
    Label7: TLabel;
    LowLimit: TSpinEdit;
    HighLimit: TSpinEdit;
    Renaming: TButton;
    RemoveOrg: TCheckBox;
    BackConv: TCheckBox;
    BufPage: TEdit;
    BrBuf: TButton;
    Label8: TLabel;
    Open: TOpenDialog;
    BitBtn1: TButton;
    procedure InBrClick(Sender: TObject);
    procedure RenamingClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BrBufClick(Sender: TObject);
    procedure OutBrClick(Sender: TObject);
  private
    Function PageToFile(S:string;Od:byte;Page:integer):string;
  end;

var
  ACDGen: TACDGen;

implementation

{$R *.DFM}

Uses FileCtrl,FMXUtils,Rew,Common,Media;

Const BookNode='BookGen2';

procedure TACDGen.FormCreate(Sender: TObject);
begin
 Label1.Caption:=Ini.ReadString(BookNode,'InFolderCap','Input folder');
 Label2.Caption:=Ini.ReadString(BookNode,'InMaskCap','Input mask');
 Label8.Caption:=Ini.ReadString(BookNode,'BufferCap','Blank page');
 Label3.Caption:=Ini.ReadString(BookNode,'OutFolderCap','Output folder');
 Label4.Caption:=Ini.ReadString(BookNode,'OutMaskCap','Output mask');
 Label5.Caption:=Ini.ReadString(BookNode,'BoundFrom','Bound: from');
 Label7.Caption:=Ini.ReadString(BookNode,'BoundTo','to');
 RemoveOrg.Caption:=Ini.ReadString(BookNode,'RemoveOrg','Remove original files');
 BackConv.Caption:=Ini.ReadString(BookNode,'BackConv','Reverse processing');
 Caption:=Ini.ReadString(BookNode,'Caption','BookMaker 2 - for ACDSee');
 Renaming.Caption:=Ini.ReadString(BookNode,'Ok','&Start');
 BitBtn1.Caption:=Ini.ReadString(BookNode,'Cancel','&Close');
 InFolder.Text:=Ini.ReadString(BookNode,'InFolder','');
 InMask.Text:=Ini.ReadString(BookNode,'InMask','%3N.TIF');
 BufPage.Text:=Ini.ReadString(BookNode,'Buffer','');
 LowLimit.Value:=Ini.ReadInteger(BookNode,'Low',0);
 HighLimit.Value:=Ini.ReadInteger(BookNode,'High',999);
 OutFolder.Text:=Ini.ReadString(BookNode,'OutFolder','');
 OutMask.Text:=Ini.ReadString(BookNode,'OutMask','%S%3N.TIF');
 RemoveOrg.Checked:=Ini.ReadBool(BookNode,'Remove',false);
 BackConv.Checked:=Ini.ReadBool(BookNode,'Reverse',false);
 Open.Filter:=Ini.ReadString(BookNode,'Filter','BMP files|*.bmp|Tif files|*.tif|All files|*.*');
 Open.Title:=Ini.ReadString(BookNode,'Title','Select blank page');
end;

procedure TACDGen.FormDestroy(Sender: TObject);
begin {сохранение параметров формы в ini файле, открытом при создании формы}
 Ini.WriteString(BookNode,'InFolder',InFolder.Text);
 Ini.WriteString(BookNode,'InMask',InMask.Text);
 Ini.WriteString(BookNode,'Buffer',BufPage.Text);
 Ini.WriteInteger(BookNode,'Low',LowLimit.Value);
 Ini.WriteInteger(BookNode,'High',HighLimit.Value);
 Ini.WriteString(BookNode,'OutFolder',OutFolder.Text);
 Ini.WriteString(BookNode,'OutMask',OutMask.Text);
 Ini.WriteBool(BookNode,'Remove',RemoveOrg.Checked);
 Ini.WriteBool(BookNode,'Reverse',BackConv.Checked);
end;

procedure TACDGen.BrBufClick(Sender: TObject);
begin {поиск буферной страницы}
 Open.InitialDir:=InFolder.Text;
 if Open.Execute then BufPage.Text:=Open.FileName;
end;

procedure TACDGen.OutBrClick(Sender: TObject);
var S:string;
begin {создание выходного каталога}
 S:=OutFolder.Text;
 if SelectDirectory(S,[sdAllowCreate],0) then OutFolder.Text:=S;
end;

procedure TACDGen.InBrClick(Sender: TObject);
var S:String;
begin
 S:=InFolder.Text;
 if SelectDirectory(S,[],0) then
  if DirectoryExists(S) then InFolder.Text:=S;
end;

procedure TACDGen.RenamingClick(Sender: TObject);
Type TMode=(None,Yes,No,YesAll,NoAll,Cancel);
var NumPages,NormPages,Count:word;
    Start,Stop,I:integer;
    S:string;
    Mode:TMode;
    Mode2:TMode;
Procedure TryFile(S1,S2:string;Rem:boolean);
begin
 if(Mode in [Yes,No])then Mode:=None;
 if(FileExists(S2))and(Mode=None)then begin
  Application.CreateForm(TVerify,Verify);
  Verify.Caption:=Ini.ReadString(BookNode,'Caption2','File already exists');
  Verify.Status.Caption:=Replace(Format(Ini.ReadString(BookNode,'Status2','File named\n%s\nalready exists. Rewrite with\n%s?'),[S2,S1]),'\n',#13);
  Verify.BitBtn1.Caption:=Ini.ReadString(BookNode,'Yes','&Yes');
  Verify.BitBtn2.Caption:=Ini.ReadString(BookNode,'No','&No');
  Verify.BitBtn3.Caption:=Ini.ReadString(BookNode,'Ignore','&Stop');
  Verify.ForAll.Caption:=Ini.ReadString(BookNode,'ForAll','Always use this option');
  case Verify.ShowModal of
   mrYes:if Verify.ForAll.Checked then Mode:=YesAll else Mode:=Yes;
   mrNo:if Verify.ForAll.Checked then Mode:=NoAll else Mode:=No;
   mrCancel:Mode:=cancel;
  end;
  if(Rem)and(Mode in [No,NoAll])and(Mode2<>YesAll)and(Mode2<>NoAll)then begin
   Verify.Caption:=Ini.ReadString(BookNode,'Caption3','File wasn''t moved');
   Verify.Status.Caption:=Replace(Format(Ini.ReadString(BookNode,'Status3','File named\n%s\nwas not moved. Delete?'),[S1]),'\n',#13);
   case Verify.ShowModal of
    mrYes:if Verify.ForAll.Checked then Mode2:=YesAll else Mode2:=Yes;
    mrNo:if Verify.ForAll.Checked then Mode2:=NoAll else Mode2:=No;
    mrCancel:Mode:=Cancel;
   end;
  end;
  Verify.Free;
 end;
 if Mode=Cancel then Exit;
 try
  if FileExists(S2)and(Mode in [Yes,YesAll])then DeleteFile(S2);
  if not FileExists(S2)then if Rem then MoveFile(S1,S2) else CopyFile(S1,S2);
  if(Rem)and(FileExists(S1))and(Mode2 in [Yes,YesAll])then DeleteFile(S1);
 except
  if MessageDlg(Format(Ini.ReadString(BookNode,'CopyError','Unable to copy file %s. Continue?'),[S2]),mtWarning,[mbYes,MbNo],0)=mrNo then Mode:=Cancel;
 end;
end;
Procedure PrintPage(Od:byte;Page1,Page2:word);
var S:string;
begin
 S:=PageToFile(OutMask.Text,Od,Count);
 if Page1<=NumPages then
  TryFile(InFolder.Text+'\'+PageToFile(InMask.Text,0,Page1+Start-1),OutFolder.Text+'\'+PageToFile(OutMask.Text,Od,Count),RemoveOrg.Checked)
 else
  TryFile(InFolder.Text+'\'+BufPage.Text,OutFolder.Text+'\'+PageToFile(OutMask.Text,Od,Count),False);
 Inc(Count);
 if Page2<=NumPages then
  TryFile(InFolder.Text+'\'+PageToFile(InMask.Text,0,Page2+Start-1),OutFolder.Text+'\'+PageToFile(OutMask.Text,Od,Count),RemoveOrg.Checked)
 else
  TryFile(InFolder.Text+'\'+BufPage.Text,OutFolder.Text+'\'+PageToFile(OutMask.Text,Od,Count),False);
 Inc(Count);
end;
begin
 Renaming.Enabled:=false;Mode:=None;Mode2:=None;
 Start:=-1;Stop:=-1;
 {$I-}ChDir(InFolder.Text);{$I+}
 if IOResult<>0 then begin
  MessageDlg(Ini.ReadString(BookNode,'InputError','Input folder does not exists!'),mtError,[mbOk],0);
  Renaming.Enabled:=true;Exit;
 end;
 For I:=LowLimit.Value to HighLimit.Value+1 do begin  {поиск первого непрерывного диапазона файлов с заданной маской в искомых пределах}
  S:=PagetoFile(InMask.Text,0,I);
  if(Start<>-1)then
   if not FileExists(S) then break
   else Stop:=I
  else if FileExists(S) then Start:=I;
 end;
 if Start=-1 then begin Renaming.Enabled:=true;Exit;end;
 NumPages:=Stop-Start+1;
 if NumPages mod 4=0 then NormPages:=NumPages else begin {для распечатки необходима пустая страница для заполнения}
  if BufPage.Text='' then begin
   MessageDlg(Ini.ReadString(BookNode,'NoBlankPage','Need blank page to print!'),mtError,[mbOk],0);
   Renaming.Enabled:=true;Exit;end;
  NormPages:=NumPages+4-(NumPages mod 4);
 end;
 ForceDirectories(OutFolder.Text);
 Count:=1;For I:=0 to NormPages div 4-1 do begin   {вывод на печать первой партии страниц}
  if Mode=Cancel then break;
  PrintPage(1,NormPages div 2-2*I,NormPages div 2+2*I+1);
 end;
 Count:=1;For I:=0 to NormPages div 4-1 do begin  {печать второй партии страниц}
  if Mode=Cancel then break;
  PrintPage(2,NormPages div 2+2*I+2,NormPages div 2-2*I-1);
 end;
 MessageDlg(Format(Ini.ReadString(BookNode,'Result','You need %d lists of paper'),[NormPages div 4]),mtInformation,[mbOk],0);
 Renaming.Enabled:=true;
end;

/////////////////////////////////////////////////////

Function TACDGen.PageToFile(S:string;Od:byte;Page:integer):string;
var Mask:boolean;
    I,Digits:byte;
Function VerifyOdd:boolean;
Const MyStr='S';
begin
 if Od=0 then Result:=false else
 Result:=CompareText(Copy(S,I+1,Length(MyStr)),MyStr)=0; // проверка пройдена, если флаг совпал
 if Result then Inc(I,Length(MyStr)); // переместиться на предпоследний символ поля
end;
Function VerifyPage:boolean;
Const MyStr='N';
var J:byte;
begin Digits:=0;
 J:=I+1;while(S[J]in['0'..'9'])do begin // пропуск ширины поля
  if 10.0*Digits+ord(S[J])-ord('0')<256 then Digits:=10*Digits+ord(S[J])-ord('0')
  else break;
  inc(J);
 end;
 Result:=CompareText(Copy(S,J,Length(MyStr)),MyStr)=0; // проверка пройдена, если флаг совпал
 if Result then I:=J+Length(MyStr)-1; // переместиться на предпоследний символ поля
end;
Function PageasStr:string;
begin
 Str(Page,Result);
 While(Length(Result)<Digits)do Result:='0'+Result;
end;
begin Result:='';Mask:=false;
 I:=1;While(I<=Length(S))do begin
  case S[I] of
   '\':if Mask then begin Result:=Result+'\';Mask:=false;end else Mask:=true;
   '%':if Mask then begin Result:=Result+'%';Mask:=false;end else begin
    if VerifyOdd then if Od=1 then Result:=Result+'1' else Result:=Result+'2'
    else if VerifyPage then Result:=Result+PageasStr
    else Result:=Result+'%';
   end;
  else begin Mask:=false;Result:=Result+S[I];end;
  end;
  Inc(I);
 end;
end;

end.
