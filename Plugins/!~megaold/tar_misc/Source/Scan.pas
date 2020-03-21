unit Scan;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons, IniFiles;

type
  PMyFile=^TMyFile;
  TMyFile=object
   Directory,Name,Ext:string;
   Date:TDateTime;
   Size:integer;
   Constructor Init(AName:string);
   Destructor Done;
  end;

  PMyDir=^TMyDir;
  TMyDir=object
   Name:string;
   Date:TDateTime;
   Constructor Init(AName:string);
   Destructor Done;
  end;

  TScaner = class(TForm)
    Label2: TLabel;
    StartFolder: TEdit;
    Br: TButton;
    Save: TSaveDialog;
    Label3: TLabel;
    OutputFile: TEdit;
    BrF: TButton;
    Start: TButton;
    Opt: TButton;
    Status: TLabel;
    BtnExit: TButton;
    procedure BrClick(Sender: TObject);
    procedure BrFClick(Sender: TObject);
    procedure StartClick(Sender: TObject);
    procedure OptClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  end;

var
  Scaner: TScaner;

implementation

{$R *.DFM}

Uses FileCtrl,Param,FMXUtils,Media;

Const Common='Lister';
Const DefLineFiles='%DIR%Full';
      DefLineFolders='%NAME';

var UseFiles,UseFolders,CaseSens,Invert:boolean;
    LineFiles,LineFolders:string;
    MaskFile:string[20];
    SortFiles,SortFolders:byte;
    MaxValue:byte;
    FilesFirst,Local,ShortNames:boolean;
    LocalIndex:integer;

function AltFileName(const Name:string;Long:boolean):string;
var SearchRec:TSearchRec;
    Success:integer;
    S,D:PChar;
begin
 if Long then begin
  Success:=SysUtils.FindFirst(Name,faAnyFile,SearchRec);
  if Success=0 then Result:=StrPas(SearchRec.FindData.CFileName)
  else Result:=Name;
  SysUtils.FindClose(SearchRec);
 end else begin
  GetMem(S,512);GetMem(D,512);
  StrPCopy(S,Name);
  GetShortPathName(S,D,512);
  Result:=StrPas(D);
  FreeMem(S,512);FreeMem(D,512);
 end;
end;

Constructor TMyFile.Init(AName:string);  // загружает данные о файле в оперативную память
begin
 Directory:=ExtractFileDir(ExpandFileName(AName));
 if Directory[Length(Directory)]='\' then SetLength(Directory,Length(Directory)-1);
 Ext:=ExtractFileExt(AName);
 Name:=ExtractFileName(AName);
 if ShortNames then Name:=AltFileName(Name,false);
 if Ext<>'' then SetLength(Name,Length(Name)-Length(Ext));
 Date:=FileDateTime(AName);
 Size:=GetFileSize(AName);
end;

Destructor TMyFile.Done;
begin end;

Constructor TMyDir.Init(AName:string);
begin
 Name:=ExpandFileName(AName);
 if Name[Length(Name)]='\' then SetLength(Name,Length(Name)-1);
 if ShortNames then Name:=AltFileName(Name,false);
end;

Destructor TMyDir.Done;
begin end;

Function CompareFiles(Ap,Bp:pointer):integer; // процедура сравнения для сортировки файлов
var A,B:PMyFile;
    Res:integer;
Procedure CmpName;
begin
 if CaseSens then Res:=CompareStr(A^.Name,B^.Name)
 else Res:=CompareText(A^.Name,B^.Name);
end;
Procedure CmpExt;
begin
 if CaseSens then Res:=CompareStr(A^.Ext,B^.Ext)
 else Res:=CompareText(A^.Ext,B^.Ext);
end;
Procedure CmpSize;
begin
 if A^.Size<B^.Size then Res:=-1
 else if A^.Size=B^.Size then Res:=0
 else Res:=1;
end;
procedure CmpDate;
begin
 if A^.Date<B^.Date then Res:=-1
 else Res:=1;
end;
begin
 A:=PMyFile(Ap);B:=PMyFile(Bp);
 case SortFiles of
  0:begin // sort by name
   CmpName;if Res=0 then CmpExt;
  end;
  1:begin // sort by extension
   CmpExt;if Res=0 then CmpName;
  end;
  2:begin // sort by size
   CmpSize;if Res=0 then CmpName;if Res=0 then CmpExt;
  end;
  3:begin // sort by date
   CmpDate;if Res=0 then CmpName;if Res=0 then CmpExt;
  end;
  else Res:=0;
 end;
 if Invert then Result:=-Res else Result:=Res;
end;

Function CompareFolder(Ap,Bp:pointer):integer;
var A,B:PMyDir;
begin
 A:=PMyDir(Ap);B:=PMyDir(Bp);
 case SortFolders of
  0: // sort by name
   if CaseSens then Result:=CompareStr(A^.Name,B^.Name)
   else Result:=CompareText(A^.Name,B^.Name);
  1: // sort by date
   if A^.Date<B^.Date then Result:=-1
   else Result:=1;
  else Result:=0;
 end;
 if Invert then Result:=-Result;
end;

Function SubstFile(A:PMyFile):string;  // процедура подстановки для файлов
var I:word;
    Temp:string[120];
begin Result:='';
 I:=1;While(I<=Length(LineFiles))do begin
  if LineFiles[I]='%' then begin
   if LineFiles[I+1]='%' then begin Inc(I);Result:=Result+'%';end
   else if(CompareStr(Copy(LineFiles,I+1,3),'DIR')=0)then begin
    if Local then Temp:=Copy(AnsiUpperCase(A^.Directory),LocalIndex,Length(A^.Directory)-LocalIndex+1)
    else Temp:=AnsiUpperCase(A^.Directory);
    if Temp<>'' then Result:=Result+Temp+'\';
    Inc(I,3);
   end else if(CompareStr(Copy(LineFiles,I+1,3),'dir')=0)then begin
    if Local then Temp:=Copy(AnsiLowerCase(A^.Directory),LocalIndex,Length(A^.Directory)-LocalIndex+1)
    else Temp:=AnsiLowerCase(A^.Directory);
    if Temp<>'' then Result:=Result+Temp+'\';
    Inc(I,3);
   end else if(CompareText(Copy(LineFiles,I+1,3),'dir')=0)then begin
    if Local then Temp:=Copy(A^.Directory,LocalIndex,Length(A^.Directory)-LocalIndex+1)
    else Temp:=A^.Directory;
    if Temp<>'' then Result:=Result+Temp+'\';
    Inc(I,3);
   end else if(CompareStr(Copy(LineFiles,I+1,4),'NAME')=0)then begin
    Result:=Result+AnsiUpperCase(A^.Name);
    Inc(I,4);
   end else if(CompareStr(Copy(Linefiles,I+1,4),'name')=0)then begin
    Result:=Result+AnsilowerCase(A^.Name);
    Inc(I,4);
   end else if(CompareText(Copy(LineFiles,I+1,4),'name')=0)then begin
    Result:=Result+A^.Name;
    Inc(I,4);
   end else if(CompareStr(Copy(LineFiles,I+1,3),'EXT')=0)then begin
    Result:=Result+AnsiUpperCase(A^.Ext);
    Inc(I,3);
   end else if(CompareStr(Copy(LineFiles,I+1,3),'ext')=0)then begin
    Result:=Result+AnsiLowerCase(A^.Ext);
    Inc(I,3);
   end else if(CompareText(Copy(LineFiles,I+1,3),'ext')=0)then begin
    Result:=Result+A^.Ext;
    Inc(I,3);
   end else if(CompareStr(Copy(LineFiles,I+1,4),'FULL')=0)then begin
    if Local then Temp:=Copy(A^.Directory,LocalIndex,Length(A^.Directory)-LocalIndex+1)
    else Temp:=A^.Directory;
    if Temp<>'' then Result:=Result+AnsiUpperCase(Temp+'\'+A^.Name+A^.Ext)
    else Result:=Result+AnsiUpperCase(A^.Name+A^.Ext);
    Inc(I,4);
   end else if(CompareStr(Copy(Linefiles,I+1,4),'full')=0)then begin
    if Local then Temp:=Copy(A^.Directory,LocalIndex,Length(A^.Directory)-LocalIndex+1)
    else Temp:=A^.Directory;
    if Temp<>'' then Result:=Result+AnsilowerCase(Temp+'\'+A^.Name+A^.Ext)
    else Result:=Result+AnsilowerCase(A^.Name+A^.Ext);
    Inc(I,4);
   end else if(CompareText(Copy(LineFiles,I+1,4),'full')=0)then begin
    if Local then Temp:=Copy(A^.Directory,LocalIndex,Length(A^.Directory)-LocalIndex+1)
    else Temp:=A^.Directory;
    if Temp<>'' then Result:=Result+Temp+'\'+A^.Name+A^.Ext
    else Result:=Result+A^.Name+A^.Ext;
    Inc(I,4);
   end else if(CompareText(Copy(LineFiles,I+1,4),'date')=0)then begin
    Result:=Result+FormatDateTime('ddddd',A^.Date);
    Inc(I,4);
   end else if(CompareText(copy(LineFiles,I+1,4),'time')=0)then begin
    Result:=Result+FormatDateTime('t',A^.Date);
    Inc(I,4);
   end else if(CompareText(Copy(LineFiles,I+1,4),'size')=0)then begin
    case upcase(LineFiles[I+5])of
     'B':Result:=Result+inttostr(A^.Size);
     'K':Result:=Result+floattostrf(A^.Size/1024,ffFixed,1,1)+'k';
     'M':Result:=Result+floattostrf(A^.Size/1024/1024,ffFixed,1,1)+'M';
     else begin
      if A^.Size<1024 then Result:=Result+inttostr(A^.Size)
      else if(A^.Size>=1024)and(A^.Size<1024*1024)then Result:=Result+floattostrf(A^.Size/1024,ffFixed,1,1)+'k'
      else Result:=Result+floattostrf(A^.Size/1024/1024,ffFixed,1,1)+'M';
      Dec(I);
     end;
    end;
    Inc(I,5);
   end else Result:=Result+LineFiles[I];
  end else Result:=Result+LineFiles[I];
  Inc(I);
 end;
end;

Function SubstFolder(A:PMyDir):string;
var I:word;
begin Result:='';
 I:=1;While(I<=Length(LineFolders))do begin
  if LineFolders[I]='%' then begin
   if LineFolders[I+1]='%' then begin Inc(I);Result:=Result+'%';end
   else if CompareText(Copy(LineFolders,I+1,4),'date')=0 then begin
    Result:=Result+FormatDateTime('ddddd',A^.Date);
    Inc(I,4);
   end else if CompareText(copy(LineFolders,I+1,4),'time')=0 then begin
    Result:=Result+FormatDateTime('t',A^.Date);
    Inc(I,4);
   end else if CompareStr(Copy(LineFolders,I+1,4),'NAME')=0 then begin
    if Local then Result:=Result+Copy(AnsiUpperCase(A^.Name),LocalIndex,Length(A^.Name)-LocalIndex+1)
    else Result:=Result+AnsiUpperCase(A^.Name);
    Inc(I,4);
   end else if CompareStr(Copy(LineFolders,I+1,4),'name')=0 then begin
    if Local then Result:=Result+Copy(AnsiLowerCase(A^.Name),LocalIndex,Length(A^.Name)-LocalIndex+1)
    else Result:=Result+AnsilowerCase(A^.Name);
    Inc(I,4);
   end else if CompareText(Copy(LineFolders,I+1,4),'name')=0 then begin
    if Local then Result:=Result+Copy(A^.Name,LocalIndex,Length(A^.Name)-LocalIndex+1)
    else Result:=Result+A^.Name;
    Inc(I,4);
   end else Result:=Result+LineFolders[I];
  end else Result:=Result+LineFolders[I];
  Inc(I);
 end;
end;

procedure TScaner.BrClick(Sender: TObject);
var S:string;
begin
 if DirectoryExists(Startfolder.Text) then S:=StartFolder.Text
 else S:='';
 if SelectDirectory(S,[],0) then StartFolder.Text:=S;
end;

procedure TScaner.BrFClick(Sender: TObject);
begin
 Save.Filter:=Ini.ReadString(Common,'TXTFile','Text files')+'|*.txt|'+
  Ini.ReadString(Common,'ALLFiles','All files')+'|*.*';
 Save.Title:=Ini.ReadString(Common,'SaveTitle','Select output file');
 if Save.Execute then OutputFile.Text:=Save.FileName;
end;

procedure TScaner.StartClick(Sender: TObject);
var F:textfile;
procedure Recurse(Level:byte);
var List:TList;
    Sr:TSearchRec;
    I:integer;
begin
 Status.Caption:=GetCurrentDir;
 if(Level>0)then begin
  List:=TList.Create;
  I:=FindFirst('*.*',faAnyfile,Sr);
  while(I=0)and(Start.Tag=1)do begin
   if(DirectoryExists(Sr.Name))and(Sr.Name<>'.')and(Sr.Name<>'..')then
    List.Add(New(PMyDir,Init(Sr.Name)));
   I:=FindNext(Sr);
  end;
  FindClose(Sr);
  if SortFolders<>2 then List.Sort(CompareFolder);
  For I:=0 to List.Count-1 do
   if FilesFirst then begin
    {$I-}ChDir(PMyDir(List.Items[I])^.Name);{$I+}
    if IOResult=0 then begin Recurse(Level-1);ChDir('..');end;
    if UseFolders then Writeln(F,SubstFolder(List.Items[I]));
    Dispose(PMyDir(List.Items[I]),Done);
   end else begin
    if Usefolders then Writeln(F,SubstFolder(List.Items[I]));
    {$I-}ChDir(PMyDir(List.Items[I])^.Name);{$I+}
    if IOResult=0 then begin Recurse(Level-1);ChDir('..');end;
    Dispose(PMyDir(List.Items[I]),Done);
   end;
  List.Free;
 end;
 if UseFiles then begin
  I:=FindFirst(MaskFile,faAnyFile,Sr);
  List:=TList.Create;
  while(I=0)and(Start.Tag=1)do begin
   if(FileExists(Sr.Name))then
    List.Add(New(PMyFile,Init(Sr.Name)));
   I:=FindNext(Sr);
  end;
  FindClose(Sr);
  if SortFiles<>4 then List.Sort(CompareFiles);
  For I:=0 to List.Count-1 do begin
   Writeln(F,SubstFile(List.Items[I]));
   Dispose(PMyFile(List.Items[I]),Done);
  end;
  List.Free;
 end;
 Application.ProcessMessages;
end;
var X:string[99];
begin
 if Start.Tag<>0 then begin Start.Tag:=2;Start.Enabled:=false;Exit;end;
 GetDir(0,X);Start.Caption:=Ini.ReadString(Common,'Stop','Stop');Start.Tag:=1;
 if StartFolder.Text='' then StartFolder.Text:=X;
 BtnExit.Enabled:=false;Opt.Enabled:=false;

 if Local then if(Length(StartFolder.Text)=3)and(StartFolder.Text[2]=':')then LocalIndex:=Length(StartFolder.Text)+1
 else LocalIndex:=Length(StartFolder.Text)+2;
 // if use drive,then one extra symbol appeared
 {$I-}ChDir(StartFolder.Text);{$I+}
 if(IOResult=0)and(OutputFile.Text<>'')then begin
  AssignFile(F,OutputFile.Text);{$I-}Rewrite(F);{$I+}
  if IOResult=0 then begin Recurse(MaxValue);Closefile(F);
  end else MessageDlg(Ini.ReadString(Common,'WriteError','Unable to create output file'),mtError,[mbOk],0);
 end;

 ChDir(X);Start.Tag:=0;
 Start.Caption:=Ini.ReadString(Common,'Ok','Start');
 Status.Caption:='';
 BtnExit.Enabled:=true;Opt.Enabled:=true;Start.Enabled:=true;
end;

procedure TScaner.OptClick(Sender: TObject);
Const DefFileSort:array[0..4]of string=('By name','By extension','By size','By date','Unsorted');
      DefFolderSort:array[0..2]of string=('By name','By date','Unsorted');
var I:byte;
begin
 Application.CreateForm(TOpts, Opts);
 with Opts do begin
  XUseFiles.Checked:=UseFiles;
  UseDirs.Checked:=UseFolders;
  XFileString.Text:=LineFiles;
  XDirString.Text:=LineFolders;
  XFileMask.Text:=MaskFile;
  Layer.Position:=MaxValue;
  XSortFiles.ItemIndex:=SortFiles;
  XSortFolders.ItemIndex:=SortFolders;
  XCaseSens.Checked:=CaseSens;
  XInvert.Checked:=Invert;
  XUseFilesClick(nil);
  UseDirsClick(nil);
  XFilesFirst.Checked:=FilesFirst;
  XLocal.Checked:=Local;
  Shrt.Checked:=ShortNames;
  Button1.Caption:=Ini.ReadString(Common,'Accept','Accept');
  Button2.Caption:=Ini.ReadString(Common,'Decline','Decline');
  Caption:=Ini.ReadString(Common,'ParCap','Parameters');
  XUseFiles.Caption:=Ini.ReadString(Common,'UseFilesCap','Use files');
  UseDirs.Caption:=Ini.ReadString(Common,'UseFoldersCap','Use folders');
  Label1.Caption:=Ini.ReadString(Common,'MaskFileCap','File mask:');
  Label2.Caption:=Ini.ReadString(Common,'LineFilesCap','File output format');
  Label3.Caption:=Ini.ReadString(Common,'LineFoldersCap','Folder output format');
  XLocal.Caption:=Ini.ReadString(Common,'RelativeCap','Relative paths');
  Label4.Caption:=Ini.ReadString(Common,'ValueCap','Maximal level');
  XCaseSens.Caption:=Ini.ReadString(Common,'CaseSensCap','Case sensitive');
  XInvert.Caption:=Ini.ReadString(Common,'InvertCap','Inverse order');
  XFilesFirst.Caption:=Ini.ReadString(Common,'FilesFirstCap','Files first');
  Shrt.Caption:=Ini.ReadString(Common,'ShortCap','Short names');
  XSortFiles.Caption:=Ini.ReadString(Common,'SortFilesCap','Sort files');
  For I:=0 to 4 do XSortFiles.Items.Strings[I]:=Ini.ReadString(Common,'SortFilesCap'+inttostr(I),DefFileSort[I]);
  XSortFolders.Caption:=Ini.ReadString(Common,'SortFoldersCap','Sort folders');
  For I:=0 to 2 do XSortFolders.Items.Strings[I]:=Ini.ReadString(Common,'SortFoldersCap'+inttostr(I),DefFolderSort[I]);
  if ShowModal=mrOk then begin
   ShortNames:=Shrt.Checked;
   UseFiles:=XUseFiles.Checked;
   UseFolders:=UseDirs.Checked;
   LineFiles:=XFileString.Text;
   LineFolders:=XDirString.Text;
   MaskFile:=XFileMask.Text;
   MaxValue:=Layer.Position;
   SortFiles:=XSortFiles.ItemIndex;
   SortFolders:=XSortFolders.ItemIndex;
   CaseSens:=XCaseSens.Checked;
   Invert:=XInvert.Checked;
   FilesFirst:=XFilesFirst.Checked;
   Local:=XLocal.Checked;
  end;
  Free;
 end;
end;

procedure TScaner.FormCreate(Sender: TObject);
begin
 UseFiles:=Ini.ReadBool(Common,'UseFiles',true);
 UseFolders:=Ini.ReadBool(Common,'UseFolders',false);
 LineFiles:=Ini.ReadString(Common,'LineFiles',DefLineFiles);
 LineFolders:=Ini.ReadString(Common,'LineFolders',DefLineFolders);
 MaskFile:=Ini.ReadString(Common,'MaskFile','*.*');
 MaxValue:=Ini.ReadInteger(Common,'Value',6);
 SortFiles:=Ini.ReadInteger(Common,'SortFiles',0);
 SortFolders:=Ini.ReadInteger(Common,'SortFolders',2);
 CaseSens:=Ini.ReadBool(Common,'CaseSensitive',false);
 Invert:=Ini.ReadBool(Common,'Invert',false);
 StartFolder.Text:=Ini.ReadString(Common,'StartFolder','');
 OutputFile.Text:=Ini.ReadString(Common,'OutputFile','');
 FilesFirst:=Ini.ReadBool(Common,'FilesFirst',false);
 Local:=Ini.ReadBool(Common,'RelativePath',true);
 ShortNames:=Ini.ReadBool(Common,'ShortNames',false);
 Label2.Caption:=Ini.ReadString(Common,'FolderCap','Folder:');
 Label3.Caption:=Ini.ReadString(Common,'FileCap','List:');
 Start.Caption:=Ini.ReadString(Common,'Ok','&Start');
 BtnExit.Caption:=Ini.ReadString(Common,'Cancel','&Close');
 Opt.Caption:=Ini.ReadString(Common,'OptionCap','&Options');
 Caption:=Ini.ReadString(Common,'Caption','List generator');
end;

procedure TScaner.FormDestroy(Sender: TObject);
begin
 Ini.WriteBool(Common,'UseFiles',UseFiles);
 Ini.WriteBool(Common,'UseFolders',UseFolders);
 Ini.WriteString(Common,'LineFiles',LineFiles);
 Ini.WriteString(Common,'LineFolders',LineFolders);
 Ini.WriteString(Common,'MaskFile',MaskFile);
 Ini.WriteInteger(Common,'Value',MaxValue);
 Ini.WriteInteger(Common,'SortFiles',SortFiles);
 Ini.WriteInteger(Common,'SortFolders',SortFolders);
 Ini.WriteBool(Common,'CaseSensitive',CaseSens);
 Ini.WriteString(Common,'StartFolder',StartFolder.Text);
 Ini.WriteString(Common,'OutputFile',OutputFile.Text);
 Ini.WriteBool(Common,'FilesFirst',FilesFirst);
 Ini.WriteBool(Common,'RelativePath',Local);
 Ini.WriteBool(Common,'ShortNames',ShortNames);
 Ini.WriteBool(Common,'Invert',Invert);
end;

end.
