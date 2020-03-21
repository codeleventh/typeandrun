unit Txt2htm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, IniFiles,ComCtrls;

type
  TInData = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EName1: TEdit;
    EName2: TEdit;
    ENameP: TEdit;
    ENameD: TEdit;
    Label5: TLabel;
    ENameS: TEdit;
    BName1: TButton;
    BName2: TButton;
    ONameP: TButton;
    BNameP: TButton;
    BNameD: TButton;
    ONameD: TButton;
    ONameS: TButton;
    BNameS: TButton;
    Open: TOpenDialog;
    Label6: TLabel;
    ENameE: TEdit;
    BNameE: TButton;
    Label7: TLabel;
    InType: TComboBox;
    XFilter: TEdit;
    Label8: TLabel;
    ORes: TButton;
    OkBut: TButton;
    CanBut: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BName1Click(Sender: TObject);
    procedure BName2Click(Sender: TObject);
    procedure BNamePClick(Sender: TObject);
    procedure BNameDClick(Sender: TObject);
    procedure BNameSClick(Sender: TObject);
    procedure BNameEClick(Sender: TObject);
    procedure ONamePClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure InTypeChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OResClick(Sender: TObject);
    procedure ENameEChange(Sender: TObject);
    procedure EName1Change(Sender: TObject);
  private
    procedure Worker(Sender:TEdit);
  end;

var
  InData: TInData;
  D:string;

implementation

{$R *.DFM}

Uses TextProc,Common,FMXUtils,ShellAPI,Media;

const MainGroup='TxtHtm';

procedure TInData.FormDestroy(Sender: TObject);
begin
 Ini.WriteInteger(MainGroup,'InputType',InType.ItemIndex);
 Ini.WriteString(MainGroup,'Filter',XFilter.Text);
 Ini.WriteString(MainGroup,'InputFile',EName1.Text);
 Ini.WriteString(MainGroup,'OutputFile',EName2.Text);
 Ini.WriteString(MainGroup,'Prefix',AbsTorel2(D,ENameP.Text));
 Ini.WriteString(MainGroup,'Data',AbsTorel2(D,ENameD.Text));
 Ini.WriteString(MainGroup,'Suffix',AbsTorel2(D,ENameS.Text));
 Ini.WriteString(MainGroup,'Editor',ENameE.Text);
end;

procedure TInData.FormCreate(Sender: TObject);
begin
 GetDir(0,D);
 Caption:=Ini.ReadString(MainGroup,'Caption','Table convertor');
 Label1.Caption:=Ini.ReadString(MainGroup,'InputCap','Input file');
 Label2.Caption:=Ini.ReadString(MainGroup,'OutputCap','Output file');
 Label3.Caption:=Ini.ReadString(MainGroup,'PrefixCap','Prefix:');
 Label4.Caption:=Ini.ReadString(MainGroup,'DataCap','Data:');
 Label5.Caption:=Ini.ReadString(MainGroup,'SuffixCap','Suffix:');
 Label6.Caption:=Ini.ReadString(MainGroup,'EditorCap','Editor:');
 Label7.Caption:=Ini.ReadString(MainGroup,'InputTypeCap','Input file type');
 Label8.Caption:=Ini.ReadString(MainGroup,'FilterCap','Own type:');
 OkBut.Caption:=Ini.ReadString(MainGroup,'Ok','Run');
 CanBut.Caption:=Ini.ReadString(MainGroup,'Cancel','Exit');
 InType.Items.Strings[0]:=Ini.ReadString(MainGroup,'InTypeCap0','Manual text table format');
 InType.Items.Strings[1]:=Ini.ReadString(MainGroup,'InTypeCap1','Manual binary table format');
 InType.Items.Strings[2]:=Ini.ReadString(MainGroup,'InTypeCap2','Table (TAB dividers) with 3 columns');
 InType.Items.Strings[3]:=Ini.ReadString(MainGroup,'InTypeCap3','Table (TAB dividers) with 4 columns');
 EName1.Text:=ExpandFileName(Ini.ReadString(MainGroup,'InputFile','input.txt'));
 EName2.Text:=ExpandFileName(Ini.ReadString(MainGroup,'OutputFile','output.htm'));
 ENameP.Text:=ExpandFileName(Ini.ReadString(MainGroup,'Prefix',Extractfilepath(Application.ExeName)+'prefix.htm'));
 ENameD.Text:=ExpandFileName(Ini.ReadString(MainGroup,'Data',Extractfilepath(Application.ExeName)+'data.htm'));
 ENameS.Text:=ExpandFileName(Ini.ReadString(MainGroup,'Suffix',Extractfilepath(Application.ExeName)+'suffix.htm'));
 ENameE.Text:=Ini.ReadString(MainGroup,'Editor',WinDir+'notepad.exe');
 InType.ItemIndex:=Ini.ReadInteger(MainGroup,'InputType',0);
 InTypeChange(Sender);
 XFilter.Text:=Ini.ReadString(MainGroup,'Filter','');
end;

Procedure TInData.Worker(Sender:TEdit);
begin
 with Open do begin
  FileName:=ExtractFileName(Sender.Text);
  DefaultExt:=ExtractFileExt(Sender.Text);
  InitialDir:=ExtractFileDir(Sender.Text);
  if Execute then Sender.Text:=FileName;
 end;
end;

procedure TInData.BName1Click(Sender: TObject);
begin
 with Open do begin
  Title:=Ini.ReadString(MainGroup,'InputSel','Select input file');
  Filter:=Ini.ReadString(MainGroup,'TextFiles','Text files')+'|*.txt|'+
   Ini.ReadString(MainGroup,'AllFiles','All files')+'|*.*';
 end;
 Worker(EName1);
end;

procedure TInData.BName2Click(Sender: TObject);
begin
 with Open do begin
  Title:=Ini.ReadString(MainGroup,'OutputSel','Select output file');
  Filter:=Ini.ReadString(MainGroup,'HTMLFiles','Hypertext documents')+'|*.htm*|'+
   Ini.ReadString(MainGroup,'AllFiles','All files')+'|*.*';
 end;
 Worker(EName2);
end;

procedure TInData.BNamePClick(Sender: TObject);
begin
 with Open do begin
  Title:=Ini.ReadString(MainGroup,'PrefixSel','Select prefix file');
  Filter:=Ini.ReadString(MainGroup,'HTMLFiles','Hypertext documents')+'|*.htm*|'+
   Ini.ReadString(MainGroup,'AllFiles','All files')+'|*.*';
 end;
 Worker(ENameP);
end;

procedure TInData.BNameDClick(Sender: TObject);
begin
 with Open do begin
  Title:=Ini.ReadString(MainGroup,'DataSel','Select data file');
  Filter:=Ini.ReadString(MainGroup,'HTMLFiles','Hypertext documents')+'|*.htm*|'+
   Ini.ReadString(MainGroup,'AllFiles','All files')+'|*.*';
 end;
 Worker(ENameD);
end;

procedure TInData.BNameSClick(Sender: TObject);
begin
 with Open do begin
  Title:=Ini.ReadString(MainGroup,'SuffixSel','Select suffix file');
  Filter:=Ini.ReadString(MainGroup,'HTMLFiles','Hypertext documents')+'|*.htm*|'+
   Ini.ReadString(MainGroup,'AllFiles','All files')+'|*.*';
 end;
 Worker(ENameS);
end;

procedure TInData.BNameEClick(Sender: TObject);
begin
 with Open do begin
  Title:=Ini.ReadString(MainGroup,'EditorSel','Select external editor');
  Filter:=Ini.ReadString(MainGroup,'ExeFiles','Executable files')+'|*.exe|'+
   Ini.ReadString(MainGroup,'AllFiles','All files')+'|*.*';
 end;
 Worker(ENameE);
end;

procedure TInData.ONamePClick(Sender: TObject);
begin
 if Sender=ONameP then Sender:=ENameP;
 if Sender=ONameD then Sender:=ENameD;
 if Sender=ONameS then Sender:=ENameS;
 ExecuteFile(ENameE.Text,(Sender as TEdit).Text,ExtractFileDir((Sender as TEdit).Text),SW_MAXIMIZE);
end;

procedure TInData.ENameEChange(Sender: TObject);
begin
 ONameP.Enabled:=(ENameE.Text<>'')and(ENameP.Text<>'');
 ONameD.Enabled:=(ENameE.Text<>'')and(ENameD.Text<>'');
 ONameS.Enabled:=(ENameE.Text<>'')and(ENameS.Text<>'');
end;

procedure TInData.InTypeChange(Sender: TObject);
begin
 XFilter.Enabled:=Intype.ItemIndex in [0,1];
end;

procedure TInData.EName1Change(Sender: TObject);
begin
 ORes.Enabled:=false;
end;

procedure TInData.OResClick(Sender: TObject);
begin
 if FileExists(EName2.Text) then ExecuteFile(EName2.Text,'',ExtractFileDir(EName2.Text),SW_MAXIMIZE);
end;

procedure TInData.BitBtn2Click(Sender: TObject);
var F,Fi,F2:file;
begin
 if((FileExists(EName1.Text))and(FileExists(ENameP.Text))and
   (FileExists(ENameD.Text))and(FileExists(ENameS.Text)))then
 begin
  OkBut.Enabled:=false;
  case InType.ItemIndex of // определить тип входного файла
   0:IDDetect(XFilter.Text+#13#10);
   1:IDDetect(XFilter.Text);
   2:IDDetect('%*S1%#9%*S2%%*S3%'#13#10);
   3:IDDetect('%*S1%#9%*S2%%*S3%%*S4%'#13#10);
  end;
  with IDs[Id+1]do begin Name:='INNAME';Cont:=EName1.Text;Wid:=-1;end;
  with IDs[Id+2]do begin Name:='OUTNAME';Cont:=EName2.Text;Wid:=-1;end;
  with IDs[Id+3]do begin Name:='PREFIX';Cont:=ENameP.Text;Wid:=-1;end;
  with IDs[Id+4]do begin Name:='DATA';Cont:=ENameD.Text;Wid:=-1;end;
  with IDs[Id+5]do begin Name:='SUFFIX';Cont:=ENameS.Text;Wid:=-1;end;
  with IDs[Id+6]do begin Name:='AUTHOR';Cont:='Python, the member of SmiSoft (SA)';Wid:=-1;end;
  Inc(Id,6); // добавить в стандартную базу 6 служебных идентификаторов
  AssignFile(F,EName1.Text);Reset(F,1);
  AssignFile(F2,EName2.Text);Rewrite(F2,1);
  AssignFile(Fi,ENameP.Text);Reset(Fi,1);
  FormatDetect(Fi,F2);CloseFile(Fi);
  AssignFile(Fi,ENameD.Text);Reset(Fi,1);
  While not EOF(F) do begin
   ContDetect(F);
   if ValidID then FormatDetect(Fi,F2);
  end;
  CloseFile(Fi);
  AssignFile(Fi,ENameS.Text);Reset(Fi,1);
  FormatDetect(Fi,F2);CloseFile(Fi);
  CloseFile(F);CloseFile(F2);
  OkBut.Enabled:=true;
  ORes.Enabled:=true;
 end;
end;

end.

