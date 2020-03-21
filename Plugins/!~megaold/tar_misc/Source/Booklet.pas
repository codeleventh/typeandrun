unit Booklet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TReprint = class(TForm)
    Label1: TLabel;
    N: TEdit;
    Label2: TLabel;
    Buf: TEdit;
    Label5: TLabel;
    Num: TEdit;
    Label6: TLabel;
    MaxLen: TEdit;
    StrOut: TMemo;
    CutPage: TCheckBox;
    BitBtn1: TButton;
    BitBtn2: TButton;
    procedure NKeyPress(Sender: TObject; var Key: Char);
    procedure GenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Reprint: TReprint;

implementation

{$R *.dfm}

Uses Media;

Const BookNode='BookGen';

procedure TReprint.NKeyPress(Sender: TObject; var Key: Char);
begin
 if not(Key in ['0'..'9',#8]) then Key:=#0;
end;

procedure TReprint.GenClick(Sender: TObject);
var NumPages,BufPage:word;
    MaxStrLen:word;
    S:string;
Procedure PrintPage(N:word);
var Sx:string[10];
begin
 if N>NumPages then Sx:=InttoStr(BufPage)+','
 else Sx:=InttoStr(N)+',';
 if Length(S)+Length(Sx)>MaxStrLen then begin
  SetLength(S,Length(S)-1);StrOut.Lines.Add(S);S:='';
 end;
 S:=S+Sx;
end;
var NormPages,I:word;
begin
 S:='';StrOut.Clear;
 try
  NumPages:=StrtoInt(N.Text);
  BufPage:=StrtoInt(Buf.Text);
  MaxStrLen:=StrtoInt(MaxLen.text);
 except
  ShowMessage('Один или несколько параметров заданы ошибочно!');
  Exit;
 end;
 if(MaxStrLen<10)or(MaxStrLen>250) then begin
  ShowMessage('Слишком большая, либо слишком маленькая макс. длина строки!');
  Exit;
 end;
 if NumPages mod 4=0 then NormPages:=NumPages else begin
  if BufPage=0 then begin ShowMessage('Ошибочно задана буферная страница!');Exit;end;
  NormPages:=NumPages+4-(NumPages mod 4);
 end;
 Num.Text:=InttoStr(NormPages shr 2);
 I:=NormPages div 2;While(I>=2)do begin PrintPage(I);PrintPage(NormPages-I+1);Dec(I,2);end;
 if CutPage.Checked then begin SetLength(S,Length(S)-1);StrOut.Lines.Add(S);S:='';StrOut.Lines.Add('-------');end;
 I:=NormPages div 2+2;While(I<=NormPages)do begin PrintPage(I);PrintPage(NormPages-I+1);Inc(I,2);end;
 SetLength(S,Length(S)-1);StrOut.Lines.Add(S);
end;

procedure TReprint.FormCreate(Sender: TObject);
begin
 Caption:=Ini.ReadString(BookNode,'Bookmaker','Book Maker');
 Label1.Caption:=Ini.ReadString(BookNode,'PageNumber','Number of pages in a book');
 Label2.Caption:=Ini.ReadString(BookNode,'BufferPage','Blank (buffer) page');
 Label6.Caption:=Ini.ReadString(BookNode,'LineLength','Max line length');
 CutPage.Caption:=Ini.ReadString(BookNode,'CutPage','Divide by side');
 Label5.Caption:=Ini.ReadString(BookNode,'PrintPage','Need paper lists');
 BitBtn1.Caption:=Ini.Readstring(BookNode,'Ok','&Start');
 BitBtn2.Caption:=Ini.ReadString(BookNode,'Cancel','&Close');
 N.Text:=Ini.ReadString(BookNode,'PagesNode','4');
 Buf.Text:=Ini.ReadString(BookNode,'Buffer','0');
 MaxLen.Text:=Ini.ReadString(BookNode,'Max','30');
 CutPage.Checked:=Ini.ReadBool(BookNode,'Cut',true);
end;

procedure TReprint.FormDestroy(Sender: TObject);
begin
 Ini.WriteString(BookNode,'PagesNode',N.Text);
 Ini.WriteString(BookNode,'Buffer',Buf.Text);
 Ini.WriteString(BookNode,'Max',MaxLen.Text);
 Ini.WriteBool(BookNode,'Cut',CutPage.Checked);
end;

end.
