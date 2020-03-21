unit Ren;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, Spin;

type
  TRenum = class(TForm)
    Label1: TLabel;
    Pr: TProgressBar;
    Path: TEdit;
    Br: TButton;
    Label2: TLabel;
    Label3: TLabel;
    OldM: TEdit;
    NewM: TEdit;
    Label4: TLabel;
    Bnd1: TSpinEdit;
    Bnd2: TSpinEdit;
    Label5: TLabel;
    BitBtn1: TButton;
    BitBtn2: TButton;
    procedure BrClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Renum: TRenum;

implementation

{$R *.dfm}

Uses FileCtrl,Media;

Const RenNode='Renumber';

procedure TRenum.BrClick(Sender: TObject);
var S:string;
begin
 S:=Path.Text;
 if SelectDirectory(S,[],0) then Path.Text:=S;
end;

Function Inttofile(S:string;Page:integer):string;
var J,K,L:word;
    S1:string[10];
begin
 Result:=S;
 K:=Pos('%',Result);
 J:=K+1;L:=0;While(J<=Length(Result))and(Result[J]in['0'..'9'])do begin
  L:=10*L+ord(Result[J])-ord('0');Inc(J);end;
 Delete(Result,K,J-K+1);
 S1:=inttostr(Page);While(Length(S1)<L)do S1:='0'+S1;Insert(S1,Result,K);
end;

procedure TRenum.BitBtn1Click(Sender: TObject);
var I:smallint;
    X:string;
begin
 GetDir(0,X);
 Pr.Min:=Bnd1.Value;Pr.Max:=Bnd2.Value;Pr.Position:=Bnd1.Value;
 For I:=Bnd1.Value to Bnd2.Value do begin
  if FileExists(IntToFile(OldM.Text,I)) then
   RenameFile(IntToFile(OldM.Text,I),IntToFile(NewM.Text,I));
  Pr.Position:=I;
 end;
 ChDir(X);
end;

procedure TRenum.FormCreate(Sender: TObject);
begin
 Caption:=Ini.ReadString(RenNode,'Caption','Numeral corrector');
 Label1.Caption:=Ini.ReadString(RenNode,'Folder','Folder:');
 Label2.Caption:=Ini.ReadString(RenNode,'OldMask','Old mask:');
 Label3.Caption:=Ini.ReadString(RenNode,'NewMask','New mask:');
 Label4.Caption:=Ini.ReadString(RenNode,'From','From');
 Label5.Caption:=Ini.ReadString(RenNode,'To','To');
 BitBtn1.Caption:=Ini.ReadString(RenNode,'Ok','&Start');
 BitBtn2.Caption:=Ini.ReadString(RenNode,'Cancel','&Close');
 Path.Text:=Ini.ReadString(RenNode,'Path','');
 OldM.Text:=Ini.ReadString(RenNode,'Old','%d');
 NewM.Text:=Ini.ReadString(RenNode,'New','%3d');
 Bnd1.Value:=Ini.ReadInteger(RenNode,'Bnd1',0);
 Bnd2.Value:=Ini.ReadInteger(RenNode,'Bnd2',1000);
end;

procedure TRenum.FormDestroy(Sender: TObject);
begin
 Ini.WriteString(RenNode,'Path',Path.Text);
 Ini.WriteString(RenNode,'Old',OldM.Text);
 Ini.WriteString(RenNode,'New',NewM.Text);
 Ini.WriteInteger(RenNode,'Bnd1',Bnd1.Value);
 Ini.WriteInteger(RenNode,'Bnd2',Bnd2.Value);
end;

end.
