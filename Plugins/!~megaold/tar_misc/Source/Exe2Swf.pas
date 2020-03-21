unit Exe2Swf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls;

type
  TAntiFlash = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    InTxt: TEdit;
    InBr: TButton;
    OutTxt: TEdit;
    OutBr: TButton;
    Open: TOpenDialog;
    Save: TSaveDialog;
    Extr: TRadioGroup;
    BitBtn1: TButton;
    BitBtn2: TButton;
    procedure InBrClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OutBrClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ExtrClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AntiFlash: TAntiFlash;

implementation

{$R *.dfm}

Uses Media;

Const Exe2SwfNode='Exe2Swf';

procedure TAntiFlash.InBrClick(Sender: TObject);
begin
 Open.FileName:=InTxt.Text;
 if Open.Execute then begin
  InTxt.Text:=Open.FileName;
  if Extr.ItemIndex=0 then OutTxt.Text:=ExtractFilePath(Open.FileName)+'Flash.exe'
  else OutTxt.Text:=ChangeFileExt(Open.FileName,'.swf');
 end;
end;

procedure TAntiFlash.FormCreate(Sender: TObject);
begin
 Open.Title:=Ini.ReadString(Exe2SwfNode,'OpenCaption','Input EXE file');
 Save.Title:=Ini.ReadString(Exe2SwfNode,'SaveCaption','Output Flash file');
 Open.Filter:=Ini.ReadString(Exe2SwfNode,'EXEFile','Execute file')+'|*.exe|'+
  Ini.ReadString(Exe2SwfNode,'ALLFile','All files')+'|*.*';
 Save.Filter:=Ini.ReadString(Exe2SwfNode,'SWFFile','Flash files')+'|*.swf|'+
  Ini.ReadString(Exe2SwfNode,'ALLFile','All files')+'|*.*';
 InTxt.Text:=Ini.ReadString(Exe2SwfNode,'In','');
 OutTxt.Text:=Ini.ReadString(Exe2SwfNode,'Out','');
 Extr.ItemIndex:=Ini.ReadInteger(Exe2SwfNode,'Extr',1);
 AntiFlash.Caption:=Ini.ReadString(Exe2SwfNode,'Caption','SFX-SWF data extractor');
 Label1.Caption:=Ini.ReadString(Exe2SwfNode,'Input','Input');
 Label2.Caption:=Ini.ReadString(Exe2SwfNode,'Output','Output');
 Extr.Caption:=Ini.ReadString(Exe2SwfNode,'Extract','Extract');
 Extr.Items[0]:=Ini.ReadString(Exe2SwfNode,'Module','Module');
 Extr.Items[1]:=Ini.ReadString(Exe2SwfNode,'Data','Data');
 BitBtn1.Caption:=Ini.ReadString(Exe2SwfNode,'Ok','&Start');
 BitBtn2.Caption:=Ini.ReadString(Exe2SwfNode,'Cancel','&Close');
end;

procedure TAntiFlash.FormDestroy(Sender: TObject);
begin
 Ini.WriteString(Exe2SwfNode,'In',InTxt.Text);
 Ini.WriteString(Exe2SwfNode,'Out',OutTxt.Text);
 Ini.WriteInteger(Exe2SwfNode,'Extr',Extr.Itemindex);
end;

procedure TAntiFlash.OutBrClick(Sender: TObject);
begin
 Save.FileName:=OutTxt.Text;
 if Save.Execute then OutTxt.Text:=Save.FileName;
end;

procedure TAntiFlash.BitBtn1Click(Sender: TObject);
Const Max=1024;
      Str1='About';
      Str2=#0#0#0'FWS';
      Str3=#0#0#0'SWF';
      Str4=#0#0#0#0#0'CWS';
var F1,F2:file;
    Wr,Rd:integer;
    I,K,K1,K2,K3,K4:integer;
    V:array[1..Max]of char;
begin
 // открытие входного файла с полным контролем ошибок
 AssignFile(F1,InTxt.Text);
 {$I-}Reset(F1,1);{$I+}
 if IOResult<>0 then begin
  MessageDlg(Ini.ReadString(Exe2SwfNode,'OpenFileError','Can''t open input file!'),mtWarning,[mbOk],0);
  Exit;
 end;

 // открытие выходного файла
 AssignFile(F2,OutTxt.Text);
 {$I-}Reset(F2,1);{$I+}
 If IOResult=0 then begin
  if MessageDlg(Ini.ReadString(Exe2SwfNode,'RewriteFile','Output file exist. Rewrite?'),mtConfirmation,[mbYes,mbNo],0)=mrNo then begin
   CloseFile(F1);CloseFile(F2);Exit;
  end;
  CloseFile(F2);
 end;

 // создание нового выходного файла
 {$I-}Rewrite(F2,1);{$I+}
 if IOResult<>0 then begin
  MessageDlg(Ini.ReadString(Exe2SwfNode,'RewriteFileError','Can''t write output file!'),mtError,[mbOk],0);
  CloseFile(F1);Exit;
 end;

 // начало поиска раздела данных - там должна быть строка About...
 K:=1;
 Repeat
  BlockRead(F1,V,Max,Rd);
  I:=1;While(I<=Rd)and(K<=Length(Str1))do begin
   if V[I]=Str1[K] then Inc(K)else K:=1;
   Inc(I);
  end;
 until(Rd<>Max)or(K>Length(Str1)); // находим строку About
 if K>Length(Str1) then Seek(F1,FilePos(F1)-Max+I) else begin
  MessageDlg(Ini.ReadString(Exe2SwfNode,'UnknownFile','Possibly, not a Flash file...'),mtWarning,[mbOk],0);
  Seek(F1,0);
 end;   // если строка About не найдена - попробуем прямой поиск

 // поиск первой строки в файле
 K:=1;K1:=FilePos(F1);
 repeat
  BlockRead(F1,V,Max,Rd);
  I:=1;While(I<=Rd)and(K<=Length(Str2))do begin
   if V[I]=Str2[K] then Inc(K) else begin Dec(I,K-1);K:=1;end;
   Inc(I);
  end;
 until(Rd<>Max)or(K>Length(Str2));
 if(K>Length(Str2))then K2:=FilePos(F1)-Rd+I else K2:=FileSize(F1);

 // поиск второй строки в файле
 K:=1;Seek(F1,K1);
 repeat
  BlockRead(F1,V,Max,Rd);
  I:=1;While(I<=Rd)and(K<=Length(Str3))do begin
   if V[I]=Str3[K] then Inc(K) else begin Dec(I,K-1);K:=1;end;
   Inc(I);
  end;
 until(Rd<>Max)or(K>Length(Str3));
 if(K>Length(Str3))then K3:=FilePos(F1)-Rd+I else K3:=FileSize(F1);

 // поиск третьей строки
 K:=1;Seek(F1,K1);
 repeat
  BlockRead(F1,V,Max,Rd);
  I:=1;While(I<=Rd)and(K<=Length(Str4))do begin
   if V[I]=Str4[K] then Inc(K) else begin Dec(I,K-1);K:=1;end;
   Inc(I);
  end;
 until(Rd<>Max)or(K>Length(Str4));
 if(K>Length(Str4))then K4:=FilePos(F1)-Rd+I else K4:=FileSize(F1);

 if K3<K2 then K2:=K3;if K4<K2 then K2:=K4;
 if K2>=FileSize(F1) then begin
  MessageDlg(Ini.ReadString(Exe2SwfNode,'ConvertError','This is not Flash file!'),mtWarning,[mbOk],0);
  CloseFile(F1);CloseFile(F2);Erase(F2);
  Exit;
 end;
 Dec(K2,4);
 if Extr.ItemIndex=0 then begin
  Seek(F1,0);
  repeat
   if K2<Max then K:=K2 else K:=Max;
   BlockRead(F1,V,K,Rd);
   BlockWrite(F2,V,Rd,Wr);
   Dec(K2,K);
  until(K<>Rd)or(Rd<>Wr)or(K2<=0);
  if K2<=0 then MessageDlg(Ini.ReadString(Exe2SwfNode,'ConvertComplete','Convert complete!'),mtInformation,[mbOk],0)
  else MessageDlg(Ini.ReadString(Exe2SwfNode,'RewriteFileError','Can''t write output file!'),mtWarning,[mbOk],0);
 end else begin
  Seek(F1,K2);
  repeat
   BlockRead(F1,V,Max,Rd);
   BlockWrite(F2,V,Rd,Wr);
  until(Rd<>Max)or(Wr<>Rd);
  if Wr=Rd then MessageDlg(Ini.ReadString(Exe2SwfNode,'ConvertComplete','Convert complete!'),mtInformation,[mbOk],0)
  else MessageDlg(Ini.ReadString(Exe2SwfNode,'RewriteFileError','Can''t write output file!'),mtWarning,[mbOk],0);
 end;
 CloseFile(F1);CloseFile(F2);
end;

procedure TAntiFlash.ExtrClick(Sender: TObject);
begin
 if Extr.ItemIndex=0 then OutTxt.Text:=ExtractFilePath(InTxt.Text)+'Flash.exe'
 else OutTxt.Text:=ChangeFileExt(InTxt.Text,'.swf');
end;

end.
