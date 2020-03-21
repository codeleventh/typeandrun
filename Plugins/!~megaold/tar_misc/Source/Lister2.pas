unit Lister2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin;

type
  TURLLister = class(TForm)
    Label1: TLabel;
    Link: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    I1_1: TSpinEdit;
    I1_2: TSpinEdit;
    I1_3: TSpinEdit;
    I1_4: TSpinEdit;
    I2_1: TSpinEdit;
    I2_2: TSpinEdit;
    I2_3: TSpinEdit;
    I2_4: TSpinEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Secondary: TCheckBox;
    Label7: TLabel;
    I1_5: TEdit;
    I2_5: TEdit;
    Data: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Save: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure SecondaryClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  end;

var
  URLLister: TURLLister;

implementation

{$R *.dfm}

Uses Media;

Const MainGroup='Lister2';

procedure TURLLister.FormCreate(Sender: TObject);
begin
 Caption:=Ini.ReadString(MainGroup,'Caption','URL List Generator');
 Label1.Caption:=Ini.ReadString(MainGroup,'LinkCap','Link');
 Label2.Caption:=Ini.ReadString(MainGroup,'PrimaryCap','Primary index');
 Label3.Caption:=Ini.ReadString(MainGroup,'Lim1Cap','From');
 Label4.Caption:=Ini.ReadString(MainGroup,'Lim2Cap','To');
 Label5.Caption:=Ini.ReadString(MainGroup,'StepCap','Step');
 Label6.Caption:=Ini.ReadString(MainGroup,'NumberCap','Numbers');
 Label7.Caption:=Ini.ReadString(MainGroup,'SubstCap','Subst');
 Secondary.Caption:=Ini.ReadString(MainGroup,'SecondaryCap','Secondary index');
 Button1.Caption:=Ini.ReadString(MainGroup,'Ok','Start');
 Button2.Caption:=Ini.ReadString(MainGroup,'FileCap','To file');
 Button3.Caption:=Ini.ReadString(Maingroup,'ClipCap','To clip');
 Button4.Caption:=Ini.ReadString(MainGroup,'Cancel','Exit');
 Save.Title:=Ini.ReadString(Maingroup,'SaveCap','Save to file...');
 Save.Filter:=Ini.ReadString(MainGroup,'TXTFiles','Text files')+'|*.txt|'+
  Ini.ReadString(MainGroup,'ALLFiles','All files')+'|*.*';
 Link.Text:=Ini.ReadString(MainGroup,'Link','');
 I1_1.Value:=Ini.ReadInteger(MainGroup,'I1_1',1);
 I1_2.Value:=Ini.ReadInteger(MainGroup,'I1_2',15);
 I1_3.Value:=Ini.ReadInteger(MainGroup,'I1_3',1);
 I1_4.Value:=Ini.ReadInteger(MainGroup,'I1_4',2);
 I1_5.Text:=Ini.ReadString(MainGroup,'I1_5','@');
 I2_1.Value:=Ini.ReadInteger(MainGroup,'I2_1',1);
 I2_2.Value:=Ini.ReadInteger(MainGroup,'I2_2',5);
 I2_3.Value:=Ini.ReadInteger(MainGroup,'I2_3',1);
 I2_4.Value:=Ini.ReadInteger(MainGroup,'I2_4',1);
 I2_5.Text:=Ini.ReadString(MainGroup,'I2_5','#');
 Secondary.Checked:=Ini.ReadBool(MainGroup,'Secondary',false);
 SecondaryClick(Sender);
end;

procedure TURLLister.SecondaryClick(Sender: TObject);
begin
 I2_1.Enabled:=Secondary.Checked;
 I2_2.Enabled:=Secondary.Checked;
 I2_3.Enabled:=Secondary.Checked;
 I2_4.Enabled:=Secondary.Checked;
 I2_5.Enabled:=Secondary.Checked;
end;

procedure TURLLister.FormDestroy(Sender: TObject);
begin
 Ini.WriteString(MainGroup,'Link',Link.Text);
 Ini.WriteInteger(MainGroup,'I1_1',I1_1.Value);
 Ini.WriteInteger(MainGroup,'I1_2',I1_2.Value);
 Ini.WriteInteger(MainGroup,'I1_3',I1_3.Value);
 Ini.WriteInteger(MainGroup,'I1_4',I1_4.Value);
 Ini.WriteString(MainGroup,'I1_5',I1_5.Text);
 Ini.WriteInteger(MainGroup,'I2_1',I2_1.Value);
 Ini.WriteInteger(MainGroup,'I2_2',I2_2.Value);
 Ini.WriteInteger(MainGroup,'I2_3',I2_3.Value);
 Ini.WriteInteger(MainGroup,'I2_4',I2_4.Value);
 Ini.WriteString(MainGroup,'I2_5',I2_5.Text);
 Ini.WriteBool(MainGroup,'Secondary',Secondary.Checked);
end;

procedure TURLLister.Button1Click(Sender: TObject);
Function Replacer(const S,C:string;I:integer;MinWid:byte):string;
var Sx:string[10];
    J:word;
begin
 Str(I,Sx);while Length(Sx)<MinWid do Sx:='0'+Sx;
 Result:='';
 J:=1;While(J<=Length(S))do
  if Copy(S,J,Length(C))=C then begin Result:=Result+Sx;Inc(J,Length(C));end
  else begin Result:=Result+S[J];Inc(J);end;
end;
var I,J:integer;
    S:string;
begin
 Data.Clear;
 if(Secondary.Checked)and(Pos(I2_5.Text,Link.Text)<>0)then begin
  J:=I2_1.Value;while(J<=I2_2.Value)do begin
   if(Pos(I1_5.Text,Link.Text)<>0)then begin
    I:=I1_1.Value;while(I<=I1_2.Value)do begin
     S:=Replacer(Link.Text,I1_5.Text,I,I1_4.Value);
     Data.Lines.Add(Replacer(S,I2_5.Text,J,I2_4.Value));
     Inc(I,I1_3.Value);
    end;
   end else Data.Lines.Add(Replacer(Link.Text,I2_5.Text,J,I2_4.Value));
   Inc(J,I2_3.Value);
  end;
 end else if(Pos(I1_5.Text,Link.Text)<>0)then begin
  I:=I1_1.Value;while(I<=I1_2.Value)do begin
   Data.Lines.Add(Replacer(Link.Text,I1_5.Text,I,I1_4.Value));
   Inc(I,I1_3.Value);
  end;
 end else Data.Lines.Add(Link.Text);
end;

procedure TURLLister.Button2Click(Sender: TObject);
begin
 if Save.Execute then Data.Lines.SaveToFile(Save.FileName);
end;

procedure TURLLister.Button3Click(Sender: TObject);
begin
 Data.SelectAll;
 Data.CopyToClipboard;
 Data.SelLength:=0;
end;

end.
