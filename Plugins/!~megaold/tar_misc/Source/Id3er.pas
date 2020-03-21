unit Id3er;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons,Id3Obj, ComCtrls;

type
  TID3Maker = class(TForm)
    FileGroup: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Name1: TEdit;
    Name2: TEdit;
    Br1: TButton;
    Br2: TButton;
    TagGroup: TGroupBox;
    ProfGroup: TGroupBox;
    Profile: TComboBox;
    Add: TButton;
    Del: TButton;
    Modify: TButton;
    Present: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Title: TEdit;
    Artist: TEdit;
    Album: TEdit;
    Year: TEdit;
    Comment: TEdit;
    Genre: TEdit;
    Open: TOpenDialog;
    Label9: TLabel;
    Level: TTrackBar;
    Status: TLabel;
    BitBtn1: TButton;
    BitBtn2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AddClick(Sender: TObject);
    procedure ProfileChange(Sender: TObject);
    procedure ModifyClick(Sender: TObject);
    procedure DelClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Br1Click(Sender: TObject);
    procedure Br2Click(Sender: TObject);
    procedure PresentClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
   private
    Function FillNewID3(const Id3:TId3):TId3;
  end;

var ID3Maker: TID3Maker;

implementation

{$R *.dfm}

Uses FileCtrl,Common,Media;

Const ID3Node='ID3Work';

var Count,Errors:integer;

procedure TID3Maker.FormCreate(Sender: TObject);
var ProfNum,I:integer;
begin
 Caption:=Ini.ReadString(ID3Node,'Caption','ID3 header editor');
 FileGroup.Caption:=Ini.ReadString(ID3Node,'FileGroup','Files');
 Label1.Caption:=Ini.ReadString(ID3Node,'Input','Input');
 Label2.Caption:=Ini.ReadString(ID3Node,'Output','Output');
 ProfGroup.Caption:=Ini.ReadString(ID3Node,'ProfileName','Profiles');
 TagGroup.Caption:=Ini.ReadString(ID3Node,'NewTag','New ID3 tag');
 Present.Caption:=Ini.ReadString(ID3Node,'TagPresent','Tag present');
 Label3.Caption:=Ini.ReadString(ID3Node,'TagTitle','Title');
 Label4.Caption:=Ini.ReadString(ID3Node,'TagArtist','Artist');
 Label5.Caption:=Ini.ReadString(ID3Node,'TagAlbum','Album');
 Label6.Caption:=Ini.ReadString(Id3Node,'TagYear','Year');
 Label7.Caption:=Ini.ReadString(Id3Node,'TagComment','Comment');
 Label8.Caption:=Ini.ReadString(ID3Node,'TagGenre','Genre');
 Label9.Caption:=Ini.ReadString(ID3Node,'Level','Level');
 BitBtn1.Caption:=Ini.ReadString(ID3Node,'Ok','&Start');
 BitBtn2.Caption:=Ini.ReadString(ID3Node,'Cancel','&Close');
 Name1.Text:=Ini.ReadString(ID3Node,'File1','');
 Name2.Text:=Ini.ReadString(ID3Node,'File2','');
 Present.Checked:=Ini.ReadBool(ID3Node,'Use',true);
 Title.Text:=Ini.ReadString(Id3Node,'Title','{Title}');
 Artist.Text:=Ini.ReadString(ID3Node,'Artist','{Artist}');
 Album.Text:=Ini.ReadString(ID3Node,'Album','{Album}');
 Year.Text:=Ini.ReadString(ID3Node,'Year','{Year}');
 Comment.Text:=Ini.ReadString(ID3Node,'Comment','{Comment}');
 Genre.Text:=Ini.ReadString(ID3Node,'Genre','{Genre}');
 ProfNum:=Ini.ReadInteger(ID3Node,'Profiles',0);
 Level.Position:=Ini.ReadInteger(ID3Node,'LevelPos',8);
 For I:=1 to ProfNum do Profile.Items.Add(Ini.ReadString(ID3Node,'Name'+inttostr(I),'Error!'));
end;

procedure TID3Maker.FormDestroy(Sender: TObject);
begin
 Ini.WriteString(ID3Node,'File1',Name1.Text);
 Ini.WriteString(ID3Node,'File2',Name2.Text);
 Ini.WriteBool(ID3Node,'Use',Present.Checked);
 Ini.WriteString(ID3Node,'Title',Title.Text);
 Ini.WriteString(ID3Node,'Actor',Artist.Text);
 Ini.WriteString(ID3Node,'Album',Album.Text);
 Ini.WriteString(ID3Node,'Year',Year.Text);
 Ini.WriteString(ID3Node,'Comment',Comment.Text);
 Ini.WriteString(ID3Node,'Genre',Genre.Text);
 Ini.WriteInteger(ID3Node,'LevelPos',Level.Position);
end;

procedure TID3Maker.AddClick(Sender: TObject);
var S:string;
    Old:integer;
begin
 if Present.Checked then begin
 S:='';
 if InputQuery('Введите имя профиля','Имя профиля',S) then begin
  Profile.Items.Add(S);
  Profile.ItemIndex:=Profile.Items.Count-1;
  Old:=Ini.ReadInteger(ID3Node,'Profiles',0)+1;
  Assert(Profile.Items.Count=Old,'Profile and INI differ!');
  Ini.WriteInteger(ID3Node,'Profiles',Old);
  Ini.WriteString(ID3Node,'Title'+inttostr(Old),Title.Text);
  Ini.WriteString(ID3Node,'Artist'+inttostr(Old),Artist.Text);
  Ini.WriteString(ID3Node,'Album'+inttostr(Old),Album.Text);
  Ini.WriteString(ID3Node,'Comment'+inttostr(Old),Comment.Text);
  Ini.WriteString(ID3Node,'Year'+inttostr(Old),Year.Text);
  Ini.WriteString(ID3Node,'Genre'+inttostr(Old),Genre.Text);
  Ini.WriteString(ID3Node,'Name'+inttostr(Old),S);
 end;
 end;
end;

procedure TID3Maker.ModifyClick(Sender: TObject);
var S:string;
    Old:integer;
begin
 if Present.Checked then begin
  Old:=Profile.ItemIndex+1;
  S:=Profile.Items.Strings[Profile.ItemIndex];
  if InputQuery('Введите новое имя профиля','Имя профиля',S) then begin
   Profile.Items.Strings[Profile.ItemIndex]:=S;
   Ini.WriteString(ID3Node,'Title'+inttostr(Old),Title.Text);
   Ini.WriteString(ID3Node,'Artist'+inttostr(Old),Artist.Text);
   Ini.WriteString(ID3Node,'Album'+inttostr(Old),Album.Text);
   Ini.WriteString(ID3Node,'Comment'+inttostr(Old),Comment.Text);
   Ini.WriteString(ID3Node,'Year'+inttostr(Old),Year.Text);
   Ini.WriteString(ID3Node,'Genre'+inttostr(Old),Genre.Text);
   Ini.WriteString(ID3Node,'Name'+inttostr(Old),S);
   Profile.ItemIndex:=Old-1;
  end;
 end;
end;

procedure TID3Maker.DelClick(Sender: TObject);
var Old,I,Count:integer;
begin
 Count:=Ini.ReadInteger(ID3Node,'Profiles',0);
 Old:=Profile.ItemIndex+1;
 For I:=Old to Count-1 do begin
  Ini.WriteString(ID3Node,'Title'+inttostr(I),Ini.ReadString(ID3Node,'Title'+inttostr(I+1),'{Title}'));
  Ini.WriteString(ID3Node,'Artist'+inttostr(I),Ini.ReadString(ID3Node,'Artist'+inttostr(I+1),'{Artist}'));
  Ini.WriteString(ID3Node,'Album'+inttostr(I),Ini.ReadString(ID3Node,'Album'+inttostr(I+1),'{Album}'));
  Ini.WriteString(ID3Node,'Comment'+inttostr(I),Ini.ReadString(ID3Node,'Comment'+inttostr(I+1),'{Comment}'));
  Ini.WriteString(ID3Node,'Year'+inttostr(I),Ini.ReadString(ID3Node,'Year'+inttostr(I+1),'{Year}'));
  Ini.WriteString(ID3Node,'Genre'+inttostr(I),Ini.ReadString(ID3Node,'Genre'+inttostr(I+1),'{Genre}'));
  Ini.WriteString(ID3Node,'Name'+inttostr(I),Ini.ReadString(ID3Node,'Name'+inttostr(I+1),'Error!'));
 end;
 Ini.DeleteKey(ID3Node,'Title'+inttostr(Count));
 Ini.DeleteKey(ID3Node,'Artist'+inttostr(Count));
 Ini.DeleteKey(ID3Node,'Album'+inttostr(Count));
 Ini.DeleteKey(ID3Node,'Comment'+inttostr(Count));
 Ini.DeleteKey(ID3Node,'Year'+inttostr(Count));
 Ini.DeleteKey(ID3Node,'Genre'+inttostr(Count));
 Ini.DeleteKey(ID3Node,'Name'+inttostr(Count));
 Ini.WriteInteger(ID3Node,'Profiles',Count-1);
 Profile.Items.Delete(Profile.ItemIndex);
 if Profile.Items.Count=0 then Profile.ItemIndex:=-1;
end;

procedure TID3Maker.ProfileChange(Sender: TObject);
var Old:integer;
begin
 Old:=Profile.ItemIndex+1;
 Present.Checked:=true;
 Title.Text:=Ini.ReadString(ID3Node,'Title'+inttostr(Old),'{Title}');
 Artist.Text:=Ini.ReadString(ID3Node,'Artist'+inttostr(Old),'{Artist}');
 Album.Text:=Ini.ReadString(ID3Node,'Album'+inttostr(Old),'{Album}');
 Comment.Text:=Ini.ReadString(ID3Node,'Comment'+inttostr(Old),'{Comment}');
 Year.Text:=Ini.ReadString(ID3Node,'Year'+inttostr(Old),'{Year}');
 Genre.Text:=Ini.ReadString(ID3Node,'Genre'+inttostr(Old),'{Genre}');
end;

procedure TID3Maker.PresentClick(Sender: TObject);
begin
 Title.Enabled:=Present.Checked;
 Artist.Enabled:=Present.Checked;
 Album.Enabled:=Present.Checked;
 Comment.Enabled:=Present.Checked;
 Year.Enabled:=Present.Checked;
 Genre.Enabled:=Present.Checked;
end;

Function TID3Maker.FillNewID3(const Id3:TId3):TId3;
Function Replacer(S:string):string;
begin
 Result:=Replace2(S,'Title',ID3.Title);
 Result:=Replace2(Result,'Artist',ID3.Artist);
 Result:=Replace2(Result,'Album',ID3.Album);
 Result:=Replace2(Result,'Year',ID3.Year);
 Result:=Replace2(Result,'Comment',ID3.Comment);
 Result:=Replace2(Result,'Genre',ID3.Genre);
 Result:=Replace2(Result,'FileName',ID3.FileName);
end;
begin
 Result.Title:=Replacer(Title.Text);
 Result.Artist:=Replacer(Artist.Text);
 Result.Album:=Replacer(Album.Text);
 Result.Year:=Replacer(Year.Text);
 Result.Comment:=Replacer(Comment.Text);
 Result.Genre:=Replacer(Genre.Text);
 Result.FileName:=ID3.FileName;
end;

Procedure Process2(const S1,S2:string);
var ID3:TId3;
begin
 with ID3Maker do Status.Caption:=MinimizeName(S1,Status.Canvas,Status.Width shr 1)+'->'+
  MinimizeName(S2,Status.Canvas,Status.Width shr 1);
 Application.ProcessMessages;
 if FileExists(S2) then begin // only if destination file defined correctly
  ReadID3(S1,ID3); // receive source header
  Id3:=ID3Maker.FillNewID3(Id3); // create new header
  if ID3Maker.Present.Checked then WriteID3(S2,ID3) // save new ID3 tag
  else RemoveID3(S2); // or remove, if not required
  Inc(Count); // good work
 end else inc(Errors); // file not found
end;

procedure TID3Maker.Br1Click(Sender: TObject);
begin
 Open.Title:=Ini.ReadString(ID3Node,'LoadTitle','Select source files');
 Open.DefaultExt:='.mp3';
 Open.FileName:=ExtractFileName(Name1.Text);
 Open.InitialDir:=ExtractFileDir(Name1.Text);
 Open.Filter:=Format('%s|*.mp3|%s|*.*',[Ini.ReadString(ID3Node,'Mp3Type','MP3 files'),Ini.ReadString(ID3Node,'AllType','All files')]);
 if(Open.Execute)and(FileExists(Open.FileName))then Name1.Text:=ExpandFileName(Open.FileName);
end;

procedure TID3Maker.Br2Click(Sender: TObject);
begin
 Open.Title:=Ini.ReadString(ID3Node,'SaveTitle','Select target files');
 Open.DefaultExt:='.mp3';
 Open.FileName:=ExtractFileName(Name2.Text);
 Open.InitialDir:=ExtractFileDir(Name1.Text);
 Open.Filter:=Format('%s|*.mp3|%s|*.*',[Ini.ReadString(ID3Node,'MP3Type','MP3 files'),Ini.ReadString(ID3Node,'AllType','All files')]);
 if Open.Execute then Name2.Text:=ExpandFileName(Open.FileName);
end;

///////////////////////////

procedure TID3Maker.BitBtn1Click(Sender: TObject);
begin
 Count:=0;Errors:=0;
 BitBtn1.Enabled:=false;
 BitBtn2.Caption:=Ini.ReadString(ID3Node,'Stop','Stop!');
 Process2Files(Name1.Text,Name2.Text,Level.Position,Process2,false);
 BitBtn1.Enabled:=true;
 BitBtn2.Enabled:=true;
 BitBtn2.Caption:=Ini.ReadString(ID3Node,'Cancel','Exit');
 Status.Caption:=Format(Ini.ReadString(ID3Node,'ResStatus','Processed %d, errors %d'),[Count,Errors]);
end;

procedure TID3Maker.BitBtn2Click(Sender: TObject);
begin
 if Stat=None then ModalResult:=mrCancel
 else if Stat=Running then begin
  Stat:=Stopping;
  BitBtn2.Enabled:=false;
  Application.ProcessMessages;
 end;
end;

procedure TID3Maker.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if Stat=None then Action:=caFree else Action:=caNone;
end;

end.
