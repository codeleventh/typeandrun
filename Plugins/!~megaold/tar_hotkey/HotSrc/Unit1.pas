unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, ExtCtrls;

type
  TxJournal = class(TForm)
    List: TListBox;
    GroupBox2: TGroupBox;
    Control: TCheckBox;
    Alt: TCheckBox;
    Shift: TCheckBox;
    Win: TCheckBox;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Kind: TComboBox;
    Label3: TLabel;
    Line: TEdit;
    Br: TButton;
    Open: TOpenDialog;
    Cap1: TEdit;
    Cap2: TEdit;
    Cap3: TEdit;
    Cap4: TEdit;
    Id: TEdit;
    DelHotkey: TButton;
    Label1: TLabel;
    AddHotkey: TButton;
    Bevel1: TBevel;
    BitBtn1: TButton;
    BitBtn2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BrClick(Sender: TObject);
    procedure DelHotkeyClick(Sender: TObject);
    procedure ListClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure AddHotkeyClick(Sender: TObject);
    procedure IdChange(Sender: TObject);
    procedure ListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn2Click(Sender: TObject);
   protected
    procedure WndProc(var M:TMessage);override;
   private
    IsActive:boolean;
    Procedure SetCode(Cap:TEdit;Code:integer);
  end;

var xJournal: TxJournal;

implementation

{$R *.dfm}

Uses Hotkey;

Procedure TxJournal.SetCode(Cap:TEdit;Code:integer);
var J:SpecKeys;
begin
 Cap.Text:='';
 For J:=Low(SpecKeys) to High(SpecKeys) do if SpecScan[J]=Code then Cap.Text:=SpecName[J];
  // пр€мой поиск в таблице известных имен
 if Cap.Text='' then Cap.Text:=Format('$%x',[Code]);
 Cap.Tag:=Code; // в теге хранитс€ код - чтобы не анализировать строки лишний раз
end;

procedure TxJournal.FormCreate(Sender: TObject);
var J:word;
begin
 IsActive:=false;
 xJournal.Caption:=Ini.ReadString(Language,'Caption','Hot key editor');
 Label1.Caption:=Ini.ReadString(Language,'Hotkeyname','Hot key name');
 GroupBox2.Caption:=Ini.ReadString(Language,'Hotkeys','Hotkeys');
 GroupBox3.Caption:=Ini.ReadString(Language,'Task','Task');
 Label2.Caption:=Ini.ReadString(Language,'Type','Type');
 Label3.Caption:=Ini.ReadString(Language,'Line','Line');
 AddHotkey.Caption:=Ini.ReadString(Language,'AddHotkey','New hotkey')+' (&N)';
 DelHotkey.Caption:=Ini.ReadString(Language,'RemHotkey','Remove hotkey')+' (&D)';
 BitBtn1.Caption:=Ini.ReadString(Language,'OK','Ok');
 BitBtn2.Caption:=Ini.ReadString(Language,'Cancel','Cancel');
 Kind.Items[0]:=Ini.ReadString(Language,'RunProgram','Run program');
 Kind.Items[1]:=Ini.ReadString(Language,'RunTar','Pass to TaR');
 For J:=1 to HotCount do List.Items.AddObject(Hotkeys[J].Name,TMyHotkey.Copy(Hotkeys[J])); // копирование данных на форму
 if List.Count>0 then begin   // активировать первый элемент
  List.MultiSelect:=true; // из-за глюка в реализации списка, приходитс€ вместо List.Selected[0]:=true; писать такую фигню :-[
  For J:=0 to List.Count-1 do List.Selected[J]:=J=0;
  List.MultiSelect:=false;
  IsActive:=true;
  ListClick(Sender);  // скопировать данные в редактор
 end;
 IsActive:=true;
 LastTime:=0;
end;

procedure TxJournal.ListClick(Sender: TObject);
var I:word;
    H:TMyHotkey;
begin
 if IsActive then begin
  IsActive:=false;List.Tag:=-1;
  For I:=0 to List.Count-1 do if List.Selected[I] then List.Tag:=I; // найти выделенный элемент
  if List.Tag>=0 then begin
   H:=List.Items.Objects[List.Tag] as TMyHotkey;  // получит соответствующий гор€чий ключ
   if H<>nil then begin
    Id.Text:=H.Name;
    Control.Checked:=H.Ctrl;Alt.Checked:=H.Alt; // переслать информацию в редактор
    Win.Checked:=H.Win;Shift.Checked:=H.Shift;
    SetCode(Cap1,H.Codes[1]);SetCode(Cap2,H.Codes[2]);
    SetCode(Cap3,H.Codes[3]);SetCode(Cap4,H.Codes[4]);
    Kind.ItemIndex:=H.Kind;Line.Text:=H.Line;
    Br.Enabled:=H.Kind=0;
   end else begin
    Id.Text:='';
    Control.Checked:=false;Alt.Checked:=false; // переслать информацию в редактор
    Win.Checked:=false;Shift.Checked:=false;
    SetCode(Cap1,0);SetCode(Cap2,0);
    SetCode(Cap3,0);SetCode(Cap4,0);
    Kind.ItemIndex:=0;Line.Text:='';
    Br.Enabled:=true;
   end;
  end;
  IsActive:=true;
 end;
end;

procedure TxJournal.WndProc(var M:TMessage);
var H:TMyHotkey;
begin
 if(M.Msg=WM_KeyGet)then begin  // пришло сообщение от процедуры перехвата клавиатуры!!!
  IsActive:=false;
  if((ActiveControl=Cap1)or(ActiveControl=Cap2)or(ActiveControl=Cap3)or(ActiveControl=Cap4))and((M.lParam and $1FF)<>$F)and
   ((M.lParam and $8000)=0)and(LastTime+Ability<GetTickCount)then begin
   // игнорировать клавишу Tab
   LastTime:=GetTickCount;
   if(ActiveControl=Cap4)and(Cap3.Tag=0)then ActiveControl:=Cap3;
   if(ActiveControl=Cap3)and(Cap2.Tag=0)then ActiveControl:=Cap2;
   if(ActiveControl=Cap2)and(Cap1.Tag=0)then ActiveControl:=Cap1;
   if(M.lParam and $1FF)=(ActiveControl as TEdit).Tag then SetCode(ActiveControl as TEdit,0) // повторное нажатие клавиши стирает ее
   else SetCode(ActiveControl as TEdit,M.lParam and $1FF);   // нова€ гор€ча€ клавиша - инсталлировать
   H:=List.Items.Objects[List.Tag] as TMyHotkey;
   if H<>nil then begin // динамическа€ корректировка таблицы кодов
    if ActiveControl=Cap1 then begin H.Codes[1]:=Cap1.Tag;H.Count:=1;end;
    if ActiveControl=Cap2 then begin H.Codes[2]:=Cap2.Tag;H.Count:=2;end;
    if ActiveControl=Cap3 then begin H.Codes[3]:=Cap3.Tag;H.Count:=3;end;
    if ActiveControl=Cap4 then begin H.Codes[4]:=Cap4.Tag;H.Count:=4;end;
   end;
  end;
  IsActive:=true;
 end else inherited; // остальное пусть обрабатывает Delphi
end;

procedure TxJournal.IdChange(Sender: TObject); // динамическое изменение параметров
var H:TMyHotkey;
begin
 if IsActive then begin // если нужно
  IsActive:=false;
  H:=List.Items.Objects[List.Tag] as TMyHotkey;
  if H<>nil then
   if Sender=Id then begin  // изменение имени
    H.Name:=Id.Text;
    if Line.Tag=-1 then begin
     Line.Text:=Id.Text;
     H.Line:=Id.Text;
    end;
    List.Items.Strings[List.Tag]:=Id.Text;
   end else if(Sender=Control)and(H.Ctrl xor Control.Checked)then begin // изменение флагов
    H.Ctrl:=Control.Checked;
    if H.Ctrl then Inc(H.Count2) else Dec(H.Count2);
   end else if(Sender=Alt)and(H.Alt xor Alt.Checked)then begin
    H.Alt:=Alt.Checked;
    if H.Alt then Inc(H.Count2) else Dec(H.Count2);
   end else if(Sender=Shift)and(H.Shift xor Shift.Checked)then begin
    H.Shift:=Shift.Checked;
    if H.Shift then Inc(H.Count2) else Dec(H.Count2);
   end else if(Sender=Win)and(H.Win xor Win.Checked)then begin
    H.Win:=Win.Checked;
    if H.Win then Inc(H.Count2) else Dec(H.Count2);
   end else if Sender=Kind then begin // изменение типа
    Br.Enabled:=Kind.ItemIndex=0;
    H.Kind:=Kind.ItemIndex;
   end else if Sender=Line then begin
    H.Line:=Line.Text; // изменение строки
    Line.Tag:=0;
   end;
  IsActive:=true;
 end;
end;

procedure TxJournal.AddHotkeyClick(Sender: TObject); // добавление нового гор€чего ключа
var H:TMyHotkey;
    J:word;
begin
 if IsActive then begin
  if List.Count>=Max then begin
   MessageDlg(Ini.ReadString(Language,'MaxHotkeysError','Too many hotkeys!'),mtWarning,[mbOk],0);
   exit;
  end;
  IsActive:=false;
  H:=TMyHotkey.Create(''); // создаем новый гор€чий ключ
  if H=nil then IsActive:=true else begin
   List.AddItem(H.Name,H);  // добавл€ем в список
   List.MultiSelect:=true;  // выдел€ем его
   For J:=0 to List.Count-1 do List.Selected[J]:=J=List.Count-1;
   List.MultiSelect:=false;
   IsActive:=true;
   ListClick(Sender);     // и прописываем в редактор параметры
   ActiveControl:=Id;
   Line.Tag:=-1;
  end;
 end;
end;

procedure TxJournal.DelHotkeyClick(Sender: TObject);
var J:word;
begin
 if IsActive then begin
  IsActive:=false;
  List.DeleteSelected;  // стираем текущий ключ
  if List.Tag>=List.Count then List.Tag:=List.Count-1; // корректируем активный элемент
  if List.Tag>=0 then begin // элементы остались
   List.MultiSelect:=true;  // выдел€ем нужный элемент
   For J:=0 to List.Count-1 do List.Selected[J]:=J=List.Tag;
   List.MultiSelect:=false;
   IsActive:=true;
   ListClick(Sender);   // и пишем данные в редактор
  end else begin // не осталось больше элементов
   Id.Text:='';
   Control.Checked:=false;Shift.Checked:=false;
   Alt.Checked:=false;Win.Checked:=false;
   Cap1.Text:='$0';Cap2.Text:='$0';
   Cap3.Text:='$0';Cap4.Text:='$0';
   Kind.ItemIndex:=0;Line.Text:='';
   IsActive:=true;
  end;
 end;
end;

procedure TxJournal.BitBtn1Click(Sender: TObject);  // нажали на кнопку OK
var I:integer;
begin
 IsActive:=false;
 For I:=1 to HotCount do if Hotkeys[I]<>nil then Hotkeys[I].Free;  // стираем старые гор€чие ключи
 For I:=0 to List.Count-1 do Hotkeys[I+1]:=TMyHotkey.Copy(List.Items.Objects[I] as TMyHotkey);
  // записываем новые гор€чие ключи
 HotCount:=List.Count; // прописываем новое количество
 ModalResult:=mrOk;
end;

procedure TxJournal.BrClick(Sender: TObject);
var S:string;
    I:integer;
begin
 if IsActive then begin
  IsActive:=false;
  Open.FileName:='';Open.Title:=Ini.ReadString(Language,'SelectFile','Select file to insert...');
  if Open.Execute then begin   // пользователь выбрал файл
   S:=Line.Text;
   I:=Line.SelStart;
   Insert(Open.FileName+' ',S,Line.SelStart+1); // вставить строку на место курсора!
   Line.Text:=S;    // вывести модифицированную строку
   Line.SelStart:=I+Length(Open.FileName)+1; // модифицировать положение курсора
  end;
  IsActive:=true;
 end;
end;

procedure TxJournal.ListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var I:word;
begin
 with List do if(Key=vk_Up)and(ssCtrl in Shift)then begin
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
 end;
end;

procedure TxJournal.BitBtn2Click(Sender: TObject);
begin
 ModalResult:=mrCancel;
end;

end.
