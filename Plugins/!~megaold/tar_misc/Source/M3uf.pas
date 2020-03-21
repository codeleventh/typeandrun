unit m3uf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, Buttons;

type
  TM3update = class(TForm)
    Open: TOpenDialog;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Br1: TButton;
    Br2: TButton;
    Remover: TCheckBox;
    Rel: TCheckBox;
    Status: TLabel;
    BitBtn1: TButton;
    BitBtn2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Br1Click(Sender: TObject);
    procedure Br2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  end;

var
  M3update: TM3update;

implementation

{$R *.DFM}

Uses Common,Media;

Const M3uNode='M3ufresh';
var TempFile,S:string;
    Count:word;

procedure TM3update.FormCreate(Sender: TObject);
begin
 Caption:=Ini.ReadString(M3uNode,'Caption','M3U Updater');
 Label1.Caption:=Ini.ReadString(M3uNode,'Input','Input');
 Label2.Caption:=Ini.ReadString(M3uNode,'Output','Output');
 Status.Caption:=Ini.ReadString(M3uNode,'Status','Status');
 Remover.Caption:=Ini.ReadString(M3uNode,'RemFiles','Leave dead links');
 Rel.Caption:=Ini.ReadString(M3uNode,'RelAddr','Relative adressing');
 BitBtn1.Caption:=Ini.ReadString(M3uNode,'Ok','&Start');
 BitBtn2.Caption:=Ini.ReadString(M3uNode,'Cancel','&Close');
 Edit1.Text:=Ini.ReadString(M3uNode,'InFile','');
 Edit2.Text:=Ini.ReadString(M3uNode,'OutName','');
 Remover.Checked:=Ini.ReadBool(M3uNode,'RemStatus',true);
 Rel.Checked:=Ini.ReadBool(M3uNode,'RelStatus',true);
 TempFile:=TempDir+'m3u.tmp';
end;

procedure TM3update.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if Stat=Running then Action:=caNone else Action:=caFree;
end;

procedure TM3update.FormDestroy(Sender: TObject);
begin
 Ini.WriteString(M3uNode,'InFile',Edit1.Text);
 Ini.WriteString(M3uNode,'OutName',Edit2.Text);
 Ini.WriteBool(M3uNode,'RemStatus',Remover.Checked);
 Ini.ReadBool(M3uNode,'RelStatus',Rel.Checked);
end;

procedure TM3update.Br1Click(Sender: TObject);
begin
 Open.Title:=Ini.ReadString(M3uNode,'LoadTitle','Select source playlist');
 Open.DefaultExt:='.m3u';
 Open.FileName:=ExtractFileName(Edit1.Text);
 Open.InitialDir:=ExtractFileDir(Edit1.Text);
 Open.Filter:=Format('%s|*.m3u|%s|*.*',[Ini.ReadString(M3uNode,'M3uType','M3u playlist'),Ini.ReadString(M3uNode,'AllType','All files')]);
 if(Open.Execute)and(FileExists(Open.FileName))then Edit1.Text:=ExpandFileName(Open.FileName);
end;

procedure TM3update.Br2Click(Sender: TObject);
begin
 Open.Title:=Ini.ReadString(M3uNode,'SaveTitle','Select target playlist');
 Open.DefaultExt:='.m3u';
 Open.FileName:=ExtractFileName(Edit2.Text);
 Open.InitialDir:=ExtractFileDir(Edit1.Text);
 Open.Filter:=Format('%s|*.m3u|%s|*.*',[Ini.ReadString(M3uNode,'M3uType','M3u playlist'),Ini.ReadString(M3uNode,'AllType','All files')]);
 if Open.Execute then Edit2.Text:=ExpandFileName(Open.FileName);
end;

procedure FoundFile(const Name:string);
begin
 Inc(Count);
 S:=ExpandFileName(Name);
 Stat:=Stopping;
 Application.ProcessMessages;
end;

procedure TM3update.BitBtn1Click(Sender: TObject);
var Fi,Fo:textfile;
Procedure Leave(Level:byte);
begin
 {$I-}
 if Level>=2 then begin CloseFile(Fo);if Stat<>None then Erase(Fo);end;
 if Level>=1 then begin CloseFile(Fi);DeleteFile(TempFile);end;
 IOResult;
 {$I+}
 DeleteFile(TempFile);
 Stat:=None;
 BitBtn1.Enabled:=true;
 BitBtn2.Enabled:=true;
 BitBtn2.Caption:=Ini.ReadString(M3uNode,'Cancel','Exit');
end;
var S1:string;
begin
 Count:=0;
 Stat:=Running;
 BitBtn1.Enabled:=false;
 BitBtn2.Caption:=Ini.ReadString(M3uNode,'Stop','Stop');
 if CompareText(Edit1.Text,Edit2.Text)=0 then begin
  CopyFile(PChar(Edit1.Text),PChar(TempFile),false);
  AssignFile(Fi,TempFile);
  AssignFile(Fo,Edit1.Text);
 end else begin
  AssignFile(Fi,Edit1.Text);
  AssignFile(Fo,Edit2.Text);
 end;
 {$I-}Reset(Fi);{$I+}
 if IOResult<>0 then begin
  Status.Caption:=Ini.ReadString(M3unode,'ReadError','Error: input file not exist');
  Leave(1);Exit;end;
 {$I-}Rewrite(Fo);{$I+}
 if IOResult<>0 then begin
  Status.Caption:=Ini.ReadString(M3unode,'WriteError','Error: output file can''t be created');
  Leave(1);Exit;end;
 while(not EOF(FI))and(Stat=Running)do begin
  Readln(Fi,S);Status.Caption:=S;
  if(S[1]='#')then // this is a comment
  else if FileExists(S) then begin
   S:=ExpandFileName(S);
   if Rel.Checked then begin
    S1:=Abstorel(ExtractFileDir(Edit2.Text),ExtractFileDir(S));
    if S1='' then S:=ExtractFileName(S)
    else S:=S1+'\'+ExtractFileName(S);
   end;
  end else begin
   S1:=S;S:='';
   Process1File(ExtractFilePath(Edit2.Text)+ExtractFileName(S1),8,FoundFile);
   if S<>'' then begin
    if Rel.Checked then begin
     S1:=Abstorel(ExtractFileDir(Edit2.Text),ExtractFileDir(S));
     if S1='' then S:=ExtractFileName(S)
     else S:=S1+'\'+ExtractFileName(S);
    end;
   end else if Remover.Checked then S:=S1;
   Stat:=Running;
  end;
  if S<>'' then Writeln(Fo,S);
 end;
 Stat:=None;
 Status.Caption:=Format('%s: %d',[Ini.ReadString(M3uNode,'Done','Processed files'),Count]);
 Leave(255);
end;

procedure TM3update.BitBtn2Click(Sender: TObject);
begin
 if Stat=None then ModalResult:=mrCancel else
 if Stat=Running then begin
  Stat:=Stopping;
  BitBtn2.Enabled:=false;
  Application.ProcessMessages;
 end;
end;

end.
