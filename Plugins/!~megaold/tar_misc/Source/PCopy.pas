unit PCopy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons;

type
  TTheCopy = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Br1: TButton;
    Open: TOpenDialog;
    Br2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    MaxLevel: TTrackBar;
    Status: TLabel;
    BitBtn1: TButton;
    BitBtn2: TButton;
    procedure Br1Click(Sender: TObject);
    procedure Br2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TheCopy: TTheCopy;

implementation

{$R *.dfm}

Uses Common,FileCtrl,Media;

Const PCopyNode='PartCopy';

var I1,I2,Count:integer;

procedure TTheCopy.Br1Click(Sender: TObject);
begin
 Open.FileName:=ExtractFileName(Edit1.Text);
 Open.InitialDir:=ExtractFileDir(ExpandFileName(Edit1.Text));
 Open.DefaultExt:='.*';
 Open.Filter:=Ini.ReadString(PCopyNode,'AllType','All Files')+'|*.*';
 Open.Title:=Ini.ReadString(PCopyNode,'LoadTitle','Select source files');
 if Open.Execute then Edit1.Text:=Open.FileName;
end;

procedure TTheCopy.Br2Click(Sender: TObject);
begin
 Open.FileName:=ExtractFileName(Edit2.Text);
 Open.InitialDir:=ExtractFileDir(ExpandFileName(Edit2.Text));
 Open.DefaultExt:='.*';
 Open.Filter:=Ini.ReadString(PCopyNode,'AllType','All Files')+'|*.*';
 Open.Title:=Ini.ReadString(PcopyNode,'SaveTitle','Select target files');
 if Open.Execute then Edit2.Text:=ExpandFileName(Open.FileName);
end;

procedure TTheCopy.FormCreate(Sender: TObject);
begin
 Caption:=Ini.ReadString(PCopyNode,'Caption','Part copy manager');
 Label1.Caption:=Ini.ReadString(PCopyNode,'Input','Input file');
 Label2.Caption:=Ini.ReadString(PCopyNode,'Output','Output file');
 Label3.Caption:=Ini.ReadString(PCopyNode,'CopyFrom','Copy from');
 Label4.Caption:=Ini.ReadString(PCopyNode,'CopySize','Copy size');
 Label5.Caption:=Ini.ReadString(PCopyNode,'Level','Level');
 BitBtn1.Caption:=Ini.ReadString(PCopyNode,'Ok','&Start');
 BitBtn2.Caption:=Ini.ReadString(PCopyNode,'Cancel','&Close');
 Status.Caption:=Ini.ReadString(PCopyNode,'Status','Status');
 Edit1.Text:=Ini.ReadString(PCopyNode,'InDir','');
 Edit2.Text:=Ini.ReadString(PCopyNode,'OutDirKey','');
 Edit3.Text:=Ini.ReadString(PCopyNode,'FirstKey','0');
 Edit4.Text:=Ini.ReadString(PCopyNode,'SizeKey','4k');
 MaxLevel.Position:=Ini.ReadInteger(PCopyNode,'EncloseKey',4);
end;

procedure TTheCopy.FormDestroy(Sender: TObject);
begin
 Ini.WriteString(PCopyNode,'InDir',Edit1.Text);
 Ini.WriteString(PCopyNode,'OutDirKey',Edit2.Text);
 Ini.WriteString(PCopyNode,'FirstKey',Edit3.Text);
 Ini.WriteString(PCopyNode,'SizeKey',Edit4.Text);
 Ini.WriteInteger(PCopyNode,'EncloseKey',MaxLevel.Position);
end;

procedure TTheCopy.BitBtn2Click(Sender: TObject);
begin
 if Stat=None then ModalResult:=mrCancel
 else if Stat=Running then begin
  Stat:=Stopping;
  BitBtn2.Enabled:=false;
  Application.ProcessMessages;
 end;
end;

procedure Process(const S1,S2:string);
begin
 with TheCopy do Status.Caption:=MinimizeName(S1,TheCopy.Canvas,Status.Width shr 1)+
  '->'+MinimizeName(S2,TheCopy.Canvas,Status.Width shr 1);
 PartCopy(S1,S2,I1,I2);
 Application.ProcessMessages;
 Inc(Count);
end;

procedure TTheCopy.BitBtn1Click(Sender: TObject);
begin
 BitBtn1.Enabled:=false;
 BitBtn2.Caption:=Ini.ReadString(PCopyNode,'Stop','Stop');
 Count:=0;
 I1:=DetectSize(Edit3.Text);
 I2:=DetectSize(Edit4.Text);
 Process2Files(Edit1.Text,Edit2.Text,MaxLevel.Position,Process,true);
 BitBtn1.Enabled:=true;
 BitBtn2.Enabled:=true;
 BitBtn2.Caption:=Ini.ReadString(PCopyNode,'Cancel','Exit');
 Status.Caption:=Ini.ReadString(PCopyNode,'FileStatus','Processed files:')+' '+inttostr(Count);
end;

procedure TTheCopy.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if Stat=None then Action:=caFree else Action:=caNone;
end;

end.

