unit ChMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls,IniFiles, Menus;

type
  TChange = class(TForm)
    Label1: TLabel;
    File1: TEdit;
    Br1: TButton;
    Box1: TListBox;
    Label2: TLabel;
    File2: TEdit;
    Br2: TButton;
    Box2: TListBox;
    Open: TOpenDialog;
    Gen: TComboBox;
    Label4: TLabel;
    AsWall: TCheckBox;
    Jpg2Bmp: TCheckBox;
    OkBut: TButton;
    CanBut: TButton;
    Add1: TButton;
    Add2: TButton;
    Name1: TEdit;
    procedure Box2DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OkButClick(Sender: TObject);
    procedure Box1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Box1DblClick(Sender: TObject);
    procedure Box2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Br1Click(Sender: TObject);
    procedure Br2Click(Sender: TObject);
    procedure Add1Click(Sender: TObject);
    procedure Add2Click(Sender: TObject);
    procedure Name1Change(Sender: TObject);
  private
    Online:boolean;
  public
    procedure FlashBox1;
    procedure Verify;
  end;

var
  Change: TChange;

implementation

{$R *.DFM}

Uses ExtCtrls,PicList;

procedure TChange.Verify;
var I:smallint;
begin
 For I:=0 to Box1.Count-1 do if Box1.Selected[I] then break;
 Br1.Enabled:=I<Box1.Count;
 Add2.Enabled:=I<Box1.Count;
 File1.Enabled:=I<Box1.Count;
 Name1.Enabled:=I<Box1.Count;
 For I:=0 to Box2.Count-1 do if Box2.Selected[I] then break;
 Br2.Enabled:=I<Box2.Count;
 File2.Enabled:=I<Box2.Count;
end;

procedure TChange.FormCreate(Sender: TObject);  // инициализация формы
var I,J,Count1,Count2:smallint;
    List:TMyList;
    FileName:string;
begin
 Online:=false;
 Caption:=Ini.ReadString(MainGroup,'Caption','Sequencer');
 Label4.Caption:=Ini.ReadString(MainGroup,'GeneratorCap','Sequence generator');
 Label1.Caption:=Ini.ReadString(MainGroup,'TargetCap','Target files');
 Label2.Caption:=Ini.ReadString(MainGroup,'SourceCap','Source files');
 AsWall.Caption:=Ini.ReadString(MainGroup,'WallCap','Desktop wallpaper');
 Jpg2Bmp.Caption:=Ini.ReadString(MainGroup,'Jpg2BmpCap','Convert JPGs');
 OkBut.Caption:=Ini.ReadString(MainGroup,'Ok','Change');
 CanBut.Caption:=Ini.ReadString(MainGroup,'Cancel','Close');
 Gen.Items.Strings[0]:=Ini.ReadString(MainGroup,'Shuffled','Shuffled');
 Gen.Items.Strings[1]:=Ini.ReadString(MainGroup,'Unshuffled','Ordered');
 Gen.ItemIndex:=Ini.ReadInteger(MainGroup,'Generator',1);
 Box1.Items.Clear;Box2.Items.Clear;
 Count1:=Ini.ReadInteger(MainGroup,'Sources',0);
 For I:=1 to Count1 do begin
  List:=TMyList.Create;
  FileName:=Ini.ReadString(MainGroup,'Source'+inttostr(I),'');
  List.Pos:=Ini.ReadInteger(MainGroup,'Pos'+inttostr(I),0);
  List.IsWall:=Ini.ReadBool(MainGroup,'Wall'+inttostr(I),false);
  List.IsJpeg2Bmp:=Ini.ReadBool(MainGroup,'Jpg'+inttostr(I),false);
  List.FileName:=Ini.ReadString(MainGroup,'FileName'+inttostr(I),'');
  Count2:=Ini.ReadInteger(MainGroup,'Count'+inttostr(I),0);
  if(Count2<>0)and(FileName<>'')then begin
   For J:=1 to Count2 do List.Add(Ini.ReadString(MainGroup,'Name'+inttostr(I)+'-'+inttostr(J),''));
   Box1.Items.AddObject(FileName,List);
  end else List.Free;
 end;
 Box1.Tag:=-1;
 Online:=true;
 if Box1.Count>0 then begin
  Box1.ClearSelection;
  Box1.Selected[0]:=true;
  Box1DblClick(Sender);
 end;
 Verify;
end;

procedure TChange.FlashBox1;  // переписывает информацию из правой колонки в память и очищает форму
var J:integer;
    L:TMyList;
begin
 For J:=0 to Box2.Count-1 do if Box2.Items.Strings[J]='' then Box2.Items.Delete(J);
 if Box1.Tag<>-1 then begin
  L:=TMyList(Box1.Items.Objects[Box1.Tag]);
  L.Clear;
  L.IsWall:=AsWall.Checked;
  L.IsJpeg2Bmp:=Jpg2Bmp.Checked;
  L.Pos:=-1;
  For J:=0 to Box2.Count-1 do L.Add(Box2.Items[J]); // перенос правого списка в память
  For J:=0 to Box2.Count-1 do if Box2.Selected[J] then L.Pos:=J; // поиск отмеченного элемента
 end;
 Verify;
end;

procedure TChange.OkButClick(Sender: TObject);
var I,J:smallint;
    List:TMyList;
    Old1,Old2:smallint;
begin
 FlashBox1;
 For I:=0 to Box1.Count-1 do if Box1.Items.Strings[I]='' then begin
  TMyList(Box1.Items.Objects[I]).Free;
  Box1.Items.Delete(I);
 end;
 Old1:=Ini.ReadInteger(MainGroup,'Sources',0);
 For I:=1 to Old1 do begin
  Old2:=Ini.ReadInteger(MainGroup,'Count'+inttostr(I),0);
  Ini.DeleteKey(MainGroup,'Source'+inttostr(I));
  Ini.DeleteKey(MainGroup,'Pos'+inttostr(I));
  Ini.DeleteKey(MainGroup,'Wall'+inttostr(I));
  Ini.DeleteKey(MainGroup,'Jpg'+inttostr(I));
  Ini.DeleteKey(MainGroup,'Count'+inttostr(I));
  Ini.DeleteKey(MainGroup,'FileName'+inttostr(I));
  For J:=1 to Old2 do Ini.DeleteKey(MainGroup,'Name'+inttostr(I)+'-'+inttostr(J));
 end;
 Ini.WriteInteger(MainGroup,'Generator',Gen.ItemIndex);
 Ini.WriteInteger(MainGroup,'Sources',Box1.Count);
 For I:=1 to Box1.Count do begin
  Ini.WriteString(MainGroup,'Source'+inttostr(I),Box1.Items.Strings[I-1]);
  List:=TMyList(Box1.Items.Objects[I-1]);
  Ini.WriteInteger(MainGroup,'Pos'+inttostr(I),List.Pos);
  Ini.WriteBool(MainGroup,'Wall'+inttostr(I),List.IsWall);
  Ini.WriteBool(MainGroup,'Jpg'+inttostr(I),List.IsJpeg2Bmp);
  Ini.WriteInteger(MainGroup,'Count'+inttostr(I),List.Count);
  Ini.WriteString(MainGroup,'FileName'+inttostr(I),List.FileName);
  For J:=1 to List.Count do Ini.WriteString(MainGroup,'Name'+inttostr(I)+'-'+inttostr(J),List.Strings[J-1]);
 end;
end;

procedure TChange.FormDestroy(Sender: TObject);
var I:integer;
begin
 For I:=0 to Box1.Count-1 do if Box1.Items.Objects[I]<>nil then TMyList(Box1.Items.Objects[I]).Free;
end;

procedure TChange.Box1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var I:integer;
begin
 with Box1 do if(Key=vk_Up)and(ssCtrl in Shift)then begin
  For I:=0 to Count-1 do if Selected[I] then break;
  if(I<Count)and(I>0)then begin
   Items.Exchange(I,I-1);
   ClearSelection;
   Selected[I]:=true;
  end;
 end else if(Key=vk_Down)and(ssCtrl in Shift)then begin
  For I:=0 to Count-1 do if Selected[I] then break;
  if(I<Count-1)then begin
   Items.Exchange(I,I+1);
   ClearSelection;
   Selected[I]:=true;
  end;
 end else if(Key=vk_Prior)and(ssCtrl in Shift)then begin
  For I:=0 to Count-1 do if Selected[I] then break;
  while(I<Count)and(I>0)do begin
   Items.Exchange(I,I-1);
   Dec(I);
  end;
  ClearSelection;
  Selected[0]:=true;
 end else if(Key=vk_Next)and(ssCtrl in Shift)then begin
  For I:=0 to Count-1 do if Selected[I] then break;
  while(I<Count-1)do begin
   Items.Exchange(I,I+1);
   Inc(I);
  end;
  ClearSelection;
  Selected[Count-1]:=true;
 end else if(Key=vk_Return)then Box1DblClick(Sender)
 else if(Key=vk_Delete)then begin
  For I:=0 to Count-1 do if Selected[I] then break;
  if I<Count then begin
   TMyList(Box1.Items.Objects[I]).Free;
   Items.Delete(I);
   ClearSelection;
  end;
 end else if(Key=vk_Insert)then begin
  Online:=false;
  FlashBox1;Box2.Clear;File1.Text:='';File2.Text:='';Name1.Text:='Noname';
  Jpg2Bmp.Checked:=false;AsWall.Checked:=false;
  ClearSelection;
  Items.AddObject('Noname',TMyList.Create);
  Name1.Text:='Noname';
  Selected[Count-1]:=true;
  Tag:=Count-1;
  Br1Click(Sender);
  if TMyList(Items.Objects[Count-1]).FileName='' then begin
   TMyList(Items.Objects[Count-1]).Free;
   Items.Delete(Count-1);
   Name1.Text:='';
   Tag:=-1;
  end;
  Online:=true;
 end;
 Verify;
end;

procedure TChange.Box1DblClick(Sender: TObject);
var I,J:smallint;
    List:TMyList;
begin
 FlashBox1;Box2.Clear;
 with Box1 do For I:=0 to Count-1 do if Selected[I] then break;
 with Box1 do if I<Count then with Box1 do begin
  Tag:=I;
  Name1.Text:=Items.Strings[I];
  List:=TMyList(Items.Objects[I]);
  File1.Text:=List.FileName;
  AsWall.Checked:=List.IsWall;
  Jpg2Bmp.Checked:=List.IsJpeg2Bmp;
  Box2.Clear;
  For J:=0 to List.Count-1 do Box2.Items.Add(List.Strings[J]);
  if List.Pos<>-1 then Box2.Selected[List.Pos]:=true;
  if List.Pos<>-1 then File2.Text:=List.Strings[List.Pos]
  else File2.Text:='';
 end else Tag:=-1;
 Verify;
end;

procedure TChange.Box2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var I:smallint;
begin
 with Box2 do if(Key=vk_Up)and(ssCtrl in Shift)then begin
  For I:=0 to Count-1 do if Selected[I] then break;
  if(I<Count)and(I>0)then begin
   Items.Exchange(I,I-1);
   ClearSelection;
   Selected[I]:=true;
  end;
 end else if(Key=vk_Down)and(ssCtrl in Shift)then begin
  For I:=0 to Count-1 do if Selected[I] then break;
  if(I<Count-1)then begin
   Items.Exchange(I,I+1);
   ClearSelection;
   Selected[I]:=true;
  end;
 end else if(Key=vk_Prior)and(ssCtrl in Shift)then begin
  For I:=0 to Count-1 do if Selected[I] then break;
  while(I<Count)and(I>0)do begin
   Items.Exchange(I,I-1);
   Dec(I);
  end;
  ClearSelection;
  Selected[0]:=true;
 end else if(Key=vk_Next)and(ssCtrl in Shift)then begin
  For I:=0 to Count-1 do if Selected[I] then break;
  while(I<Count-1)do begin
   Items.Exchange(I,I+1);
   Inc(I);
  end;
  ClearSelection;
  Selected[Count-1]:=true;
 end else if(Key=vk_Return)then Box2DblClick(Sender)
 else if(Key=vk_Delete)then begin
  DeleteSelected;
  File2.Text:='';
  AsWall.Checked:=false;
  Jpg2Bmp.Checked:=false;
 end else if(Key=vk_Insert)then begin
  For I:=0 to Box1.Count-1 do if Box1.Selected[I] then break;
  if I<Box1.Count then begin
   File2.Text:='';
   AsWall.Checked:=false;Jpg2Bmp.Checked:=false;
   ClearSelection;
   Items.AddObject('',TMyList.Create);
   Selected[Count-1]:=true;
   Br2Click(Sender);
   if Items.Strings[Count-1]='' then begin
    TMyList(Items.Objects[Count-1]).Free;
    Items.Delete(Count-1);
   end;
  end;
 end;
 Verify;
end;

procedure TChange.Box2DblClick(Sender: TObject); // загрузка имени файла в правый столбец
var J:smallint;
begin
 For J:=0 to Box2.Count-1 do if Box2.Selected[J] then break;
 File2.Text:=Box2.Items.Strings[J];
 Verify;
end;

procedure TChange.Br1Click(Sender: TObject);
var I:integer;
begin
 Open.Title:=Ini.ReadString(MainGroup,'OpenInCap','Select source file');
 Open.Filter:=Format('%s|*.bmp|%s|*.jpg|%s|*.*',[Ini.ReadString(MainGroup,'BmpFiles','BMP files'),
  Ini.ReadString(MainGroup,'JpgFiles','JPG files'),Ini.ReadString(MainGroup,'AllFiles','All files')]);
 Open.DefaultExt:='.bmp';
 Open.Options:=[ofEnableSizing,ofPathMustExist];
 Open.FileName:=File1.Text;
 if Open.Execute then begin
  For I:=0 to Box1.Count-1 do if Box1.Selected[I] then break;
  if I<Box1.Count then begin
   TMyList(Box1.Items.Objects[I]).FileName:=Open.FileName;
   File1.Text:=Open.FileName;
  end;
 end;
 ActiveControl:=Box1;
 Verify;
end;

procedure TChange.Br2Click(Sender: TObject);
var I,J:smallint;
begin
 Open.Title:=Ini.ReadString(MainGroup,'OpenOutCap','Select source file');
 Open.Filter:=Format('%s|*.bmp|%s|*.jpg|%s|*.*',[Ini.ReadString(MainGroup,'BmpFiles','BMP files'),
  Ini.ReadString(MainGroup,'JpgFiles','JPG files'),Ini.ReadString(MainGroup,'AllFiles','All files')]);
 Open.DefaultExt:='.bmp';
 Open.Options:=[ofEnableSizing,ofFileMustExist,ofAllowMultiSelect];
 Open.FileName:=File2.Text;
 if Open.Execute then begin
  For I:=0 to Box2.Count-1 do if Box2.Selected[I] then break;
  if I<Box2.Count then begin
   Box2.Items.Strings[I]:=Open.Files.Strings[0];
   if Open.Files.Count>1 then For J:=1 to Open.Files.Count-1 do Box2.Items.Add(Open.Files.Strings[J]);
   File2.Text:=Open.Files.Strings[0];
  end;
 end;
 ActiveControl:=Box2;
 Verify;
end;

procedure TChange.Add1Click(Sender: TObject);
var Key:word;
begin
 Key:=vk_Insert;
 ActiveControl:=Box1;
 Box1KeyDown(Box1,Key,[]);
end;

procedure TChange.Add2Click(Sender: TObject);
var Key:word;
begin
 Key:=vk_Insert;
 ActiveControl:=Box2;
 Box2KeyDown(Box2,Key,[]);
end;

procedure TChange.Name1Change(Sender: TObject);
begin
 if Online and (Box1.Tag<>-1)then Box1.Items.Strings[Box1.Tag]:=Name1.Text;
end;

end.
