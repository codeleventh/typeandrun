unit Patcher;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, Buttons;

type
  TMyPatch = class(TForm)
    Info1: TLabel;
    FName: TEdit;
    Offs: TEdit;
    Info2: TLabel;
    NewHex: TEdit;
    Info3: TLabel;
    Backup: TCheckBox;
    Br: TButton;
    Open: TOpenDialog;
    Go: TButton;
    Ex: TButton;
    procedure GoClick(Sender: TObject);
    procedure BrClick(Sender: TObject);
    procedure FNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MyPatch: TMyPatch;

implementation

{$R *.dfm}

Uses FMXUtils,Media;

Const PatchNode='Patcher';

procedure TMyPatch.GoClick(Sender: TObject);
const hexval:set of char=['0'..'9','A'..'F'];
      maxcpy=128;
Function CtoI(C:char):byte;
begin
 case C of
  '0'..'9':Result:=ord(C)-ord('0');
  'A'..'F':Result:=ord(C)-ord('A')+10;
  else Result:=0;
 end;
end;
Function StoI(S:string):dword;
var I:integer;
begin
 Result:=0;
 For I:=1 to Length(S) do Result:=Result shl 4+CtoI(S[I]);
end;
var F:file;
    L,K:longint;
    I:byte;
    Res:boolean;
begin
 if Length(NewHex.Text) mod 2<>0 then begin
  MessageBox(Handle,'Неверное число байт!','Status',0);
  exit;
 end;
 AssignFile(F,FName.Text);{$I-}Reset(F,1);{$I+}
 if backup.checked then
  CopyFile(FName.Text,ChangeFileExt(FName.Text,'.bak'));
 L:=StoI(Offs.Text);
 if L>FileSize(F)then begin
  MessageBox(Handle,'Длина файла меньше смешения!','Status',0);
  CloseFile(F);Exit;
 end;
 Seek(F,L);Res:=true;
 For L:=1 to Length(NewHex.Text) div 2 do begin
  I:=CtoI(NewHex.Text[2*L-1])shl 4+CtoI(NewHex.Text[2*L]);
  BlockWrite(F,I,1,K);
  if K<>1 then Res:=false;
 end;
 CloseFile(F);
 if Res then MessageBox(Handle,'Изменение завершено!','Status',0)
 else MessageBox(Handle,'Запись неудачна!','Status',0);
end;

procedure TMyPatch.BrClick(Sender: TObject);
begin
 if Open.Execute then FName.Text:=Open.FileName;
end;

procedure TMyPatch.FNameKeyPress(Sender: TObject; var Key: Char);
begin
 if not(Key in ['0'..'9','A'..'F','a'..'f',#8])then Key:=#0;
end;

procedure TMyPatch.FormCreate(Sender: TObject);
begin
 Color:=clBtnFace;
 Info1.Caption:=Ini.ReadString(PatchNode,'FileName','File name:');
 Info2.Caption:=Ini.ReadString(PatchNode,'Offset','Offset (Hex):');
 Info3.Caption:=Ini.ReadString(PatchNode,'NewData','New data:');
 Backup.Caption:=Ini.ReadString(PatchNode,'Backup','Create backup file (.BAK)');
 Go.Caption:=Ini.ReadString(PatchNode,'Ok','&Start');
 Ex.Caption:=Ini.ReadString(PatchNode,'Cancel','&Close');
 Caption:=Ini.ReadString(PatchNode,'Caption','Hex file patcher');
 FName.Text:=Ini.ReadString(PatchNode,'File','');
 Offs.Text:=Ini.ReadString(PatchNode,'Offs','0');
 NewHex.Text:=Ini.ReadString(PatchNode,'New','0000');
end;

procedure TMyPatch.FormDestroy(Sender: TObject);
begin
 Ini.WriteString(PatchNode,'File',FName.Text);
 Ini.WriteString(PatchNode,'Offs',Offs.Text);
 Ini.WriteString(PatchNode,'New',NewHex.Text);
end;

end.
