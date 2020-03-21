unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls;

type
  TClipEditor = class(TForm)
    MainMenu1: TMainMenu;
    N2: TMenuItem;
    Disappear: TMenuItem;
    AlwaysOnTop: TMenuItem;
    Memo1: TMemo;
    N3: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    Clips: TComboBox;
    Dummy: TPopupMenu;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    IsStatic: TCheckBox;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N21: TMenuItem;
    N20: TMenuItem;
    pureclip1: TMenuItem;
    pureclip2: TMenuItem;
    procedure DisappearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AlwaysOnTopClick(Sender: TObject);
    procedure ClipsChange(Sender: TObject);
    procedure ClipsSelect(Sender: TObject);
    procedure ClipsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure N5Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure N13Click(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure pureclip1Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure pureclip2Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
   protected
    Timer1,NextViewer:integer;
    procedure WndProc(var M:TMessage);override;
   public
    AllowClipboard:boolean;
    procedure SendClipboard(Mode:byte);
    procedure PutClipboard;
    procedure StockClipboard;
    procedure Store;
  end;

var
  ClipEditor: TClipEditor;

implementation

{$R *.dfm}

Uses Common,Option,Wins;

Const SpecGroup='Lang_main';

procedure TClipEditor.Store;
var I,Count:integer;
    C:TClip;
begin
 ClipsSelect(nil); // сохранить изменения содержимого клипа
 // запомнить данные текущей сессии
 Ini.WriteInteger(MainGroup,'Left',Left);
 Ini.WriteInteger(MainGroup,'Top',Top);
 Ini.WriteBool(MainGroup,'Disappear',Disappear.Checked);
 Ini.WriteBool(MainGroup,'AlwaysOnTop',AlwaysOnTop.Checked);
// UnregisterHotkey(Handle,1); // удалить отладочный горячий ключ
 if PasteMode in [1,2,3] then UnregisterHotkey(Handle,2); // и ключ работы с буфером, если был установлен
 if Timer1<>0 then KillTimer(Handle,1); // и таймер автоскрытия, если был установлен
 ChangeClipboardChain(Handle,NextViewer); // и отключиться от цепочки слежения за буфером
 Ini.ResetBinary; // перейти в режим записи двоичных данных
 Count:=Ini.ReadInteger(MainGroup,'ClipCount',0);
 For I:=1 to Count do begin // стереть старые клипы
  Ini.DeleteKey(MainGroup,'Clip'+inttostr(I));
  Ini.DeleteKey(MainGroup,'Static'+inttostr(I));
  Ini.DeleteKey(MainGroup,'Name'+inttostr(I));
 end;
 Ini.WriteInteger(MainGroup,'ClipCount',Clips.Items.Count);
 For I:=1 to Clips.Items.Count do begin // сохранить все клипы
  C:=Clips.Items.Objects[I-1] as TClip;
  Ini.WritePChar(Maingroup,'Clip'+inttostr(I),C.FData);
  Ini.WriteBoolean(MainGroup,'Static'+inttostr(I),C.Static);
  Ini.WriteString(MainGroup,'Name'+inttostr(I),Clips.Items.Strings[I-1]);
 end;
end;

Procedure TClipEditor.PutClipboard;
var Clip:TClip;
begin
 if(Clips.ItemIndex>0)then begin
  Clip:=Clips.Items.Objects[Clips.ItemIndex] as TClip;
  Clip.SetClipboard(Handle);
 end;
end;

procedure TClipEditor.StockClipboard;
var Current,I,Count,Last:integer;
    Clip:TClip;
begin
 Sleep(DelayCopy);
 Clip:=TClip.Create(GetForegroundWindow);
 if Clip.Empty then begin
  Clip.Free;
  AllowClipboard:=true;
  exit;
 end;
 Current:=-1;Count:=0;Last:=-1; // ищем такой же буфер в истории
 For I:=0 to Clips.Items.Count-1 do begin
  if lstrcmp(Clip.FData,(Clips.Items.Objects[I] as TClip).FData)=0 then Current:=I;
  if not (Clips.Items.Objects[I] as TClip).Static then begin Inc(Count);Last:=I;end;
 end;
 ClipsSelect(ClipEditor);Clips.Tag:=-1; // сохраняем возможные изменения
 if Current=-1 then begin // новый клип
  while(Count>=MaxDynamic)and(Last>0)do begin
   if not (Clips.Items.Objects[Last] as TClip).Static then begin Clips.Items.Delete(Last);Dec(Count);end;
   Dec(Last);
  end;
  Clips.Items.InsertObject(0,ExtractDescr(Clip.FData),Clip);
  Clips.ItemIndex:=0;
 end else begin // выделить данный клип
  while Current>0 do begin // перемещаем активный клип на самый верх
   Clips.Items.Exchange(Current,Current-1);
   Dec(Current);
  end;
  Clips.ItemIndex:=0; // выделяем верхний клип
  Clip.Free;
 end;
 ClipsSelect(ClipEditor); // обновляем содержимое поля Memo
end;

procedure TClipEditor.SendClipboard(Mode:byte);
var Data,I:integer;
    P:PChar;
begin
 if Mode=0 then begin
  if PasteMode in [1,2,3] then UnregisterHotkey(Handle,2);
  Wait(DelayCopy,GetForegroundWindow);
  SendHotkey(HotPaste);
  Wait(1,GetForegroundWindow);
  if PasteMode in [1,2,3] then RegisterDelphiHotkey(Handle,2,HotPaste); // установить горячие ключи обратно
 end else if OpenClipboard(GetForegroundWindow) then begin
  Data:=GetClipboardData(CF_TEXT);
  P:=GlobalLock(Data);
  For I:=0 to GlobalSize(Data)-1 do begin
   case Mode of
    1:if P[I]<>#10 then SendKey(P[I]);
    2:if P[I]='-' then SendKey(#9) else if P[I]<>#10 then SendKey(P[I]);
    3:if P[I]='-' then Sleep(DelayPrint) else if P[I]<>#10 then SendKey(P[I]);
   end;
   Sleep(DelayPrint);
  end;
  GlobalUnlock(Data);
  CloseClipboard;
 end;
end;

procedure TClipEditor.WndProc(var M:TMessage);
// лень было создавать большую кучу обработчиков, запихнул все сюда
var fActive:word;
begin
 if M.Msg=WM_ACTIVATE then begin // при активации и деактивации окна - OnActivate не подходит
  fActive:=M.WParam and $FFFF;
  if((M.WParam shr 16)=0)and(fActive=WA_INACTIVE)and(Disappear.Checked)then begin // автоматическое исчезновение
   M.Result:=0;
   Timer1:=SetTimer(Handle,1,DisappearDelay,nil);
  end;
  if(((M.WParam shr 16)=0)and(fActive=WA_INACTIVE))then PutClipboard;
   // если мы сменили текущий буфер, то заполним буфер Windows новыми данными
  if((M.WParam shr 16)=0)and((fActive=WA_ACTIVE)or(fActive=WA_CLICKACTIVE))and(Timer1<>0)then begin
   // Если мы активировались до автоисчезновения - прикончить таймер
   Timer1:=0;
   KillTimer(Handle,1);
  end;
 end else if(M.Msg=WM_TIMER)and(M.WParam=1)then begin // таймер автоисчезновения
  Timer1:=0;
  KillTimer(Handle,1); // уничтожить таймер
  Hide; // скрыться
  M.Result:=0;
 end else if M.Msg=WM_HOTKEY then begin
  if(M.WParam=2)then SendClipboard(PasteMode);// нажата клавиша вставки из буфера
  M.Result:=0; // горячие ключи обработаны
 end else if(M.Msg=WM_DRAWCLIPBOARD)and(AllowClipboard)then begin // при изменении содержимого буфера
  AllowClipboard:=false; // запретить дальнейшую обработку буфера
  if AutoPureClip then PureClip;// автоматическое удаление форматирования
  M.Result:=SendMessage(NextViewer,WM_DRAWCLIPBOARD,M.WParam,M.LParam);
  StockClipboard;// при внутренней работе с буфером это не сработает
  // это обязательно - переслать сообщение следующему перехватчику буфера
  AllowClipboard:=true; // включаем дальнейшую обработку буфера
 end else if(M.Msg=WM_CHANGECBCHAIN)then begin
  // если цепочка перехватчиков изменилась
  if NextViewer=M.WParam then NextViewer:=M.LParam // было уничтожено следующее окно - обновить указатель
  else M.Result:=SendMessage(NextViewer,WM_CHANGECBCHAIN,M.WParam,M.LParam);
   // это окно не относится к нашему - переслать сообщение по цепочке
 end else if M.Msg=WM_SYSCOMMAND then begin // обрабатывать системные сообщения
  if M.WParam=SC_MINIMIZE then begin // обработать кнопку "Свернуть" как "Минимизировать"
   Hide;M.Result:=0;
  end else if M.WParam=SC_CLOSE then begin // выход - нужно только скрыть
   Hide;M.Result:=0;
  end else inherited WndProc(M); // остальные системные системные сообщения - по умолчанию
 end else inherited WndProc(M); // Остальные сообщения обрабатывает Delphi
end;

procedure TClipEditor.DisappearClick(Sender: TObject);
begin // если необходимо автоскрываться
 Disappear.Checked:=not Disappear.Checked;
end;

procedure TClipEditor.FormCreate(Sender: TObject);
var I,Count:cardinal;
    C:TClip;
begin
 Caption:=Ini.ReadString(SpecGroup,'Caption','Clip editor');
 IsStatic.Caption:=Ini.ReadString(SpecGroup,'Static','Static clip');
 N2.Caption:=Ini.ReadString(SpecGroup,'Parameters','Parameters');
 Disappear.Caption:=Ini.ReadString(SpecGroup,'Disappear','Auto disappear');
 AlwaysOnTop.Caption:=Ini.ReadString(SpecGroup,'OnTop','Always on top');
 N5.Caption:=Ini.ReadString(SpecGroup,'BufOpt','Buffer options');
 N6.Caption:=Ini.ReadString(SpecGroup,'WinOpt','Exclusions');
 Pureclip1.Caption:=Ini.ReadString(SpecGroup,'PasteOnPureclip','Paste on ~pureclip');
 PureClip2.Caption:=Ini.ReadString(SpecGroup,'AutoPureclip','Auto ~pureclip');
 N11.Caption:=Ini.ReadString(SpecGroup,'Clips','Clips');
 N12.Caption:=Ini.ReadString(SpecGroup,'AddClip','Add clip');
 N13.Caption:=Ini.ReadString(SpecGroup,'DelClip','Delete clip');
 N17.Caption:=Ini.ReadString(SpecGroup,'DelDynClip','Delete dynamic clips');
 N18.Caption:=Ini.ReadString(SpecGroup,'DelAll','Delete all clips');
 N15.Caption:=Ini.ReadString(SpecGroup,'Regular','Regular paste');
 N16.Caption:=Ini.ReadString(SpecGroup,'KeyPaste','Simulate keyboard');
 N19.Caption:=Ini.ReadString(SpecGroup,'Serial1','Serial number 1');
 N21.Caption:=Ini.ReadString(SpecGroup,'Serial2','Serial number 2');
 N7.Caption:=Ini.ReadString(SpecGroup,'Help','Help');
 N8.Caption:=Ini.ReadString(SpecGroup,'Help','Help');
 N10.Caption:=Ini.ReadString(SpecGroup,'About','About');
 AllowClipboard:=true; // сразу разрешить работу - тогда буфер, с которым программа стартует, будет захвачен
// RegisterHotkey(Handle,1,MOD_CONTROL or MOD_ALT,ord('Q')); // пока только для отладки
 Timer1:=0;
 NextViewer:=SetClipboardViewer(Handle); // зарегистрировать как перехватчик буфера
 // читаем данные из INI
 Disappear.Checked:=Ini.ReadBool(MainGroup,'Disappear',false);
 AlwaysOnTop.Checked:=Ini.ReadBool(MainGroup,'AlwaysOnTop',false);
 if AlwaysOnTop.Checked then SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE);
 Pureclip1.Checked:=PasteOnPureclip;
 PureClip2.Checked:=AutoPureClip;
 case PasteMode of // возможно, нужно переставить галочки и регистрировать горячий ключ
  0:N15Click(N15);
  1:N15Click(N16);
  2:N15Click(N19);
  3:N15Click(N21);
 end;
 Count:=Ini.ReadInteger(MainGroup,'ClipCount',0);
 For I:=1 to Count do begin // прочитать клипы
  C:=TClip.Create;
  C.FData:=Ini.ReadPChar(Maingroup,'Clip'+inttostr(I));
  C.Static:=Ini.ReadBoolean(MainGroup,'Static'+inttostr(I),true);
  Clips.AddItem(Ini.ReadString(MainGroup,'Name'+inttostr(I),ExtractDescr(C.FData)),C);
 end;
 // установить позицию из прошлой сессии
 Left:=Ini.ReadInteger(MainGroup,'Left',GetSystemMetrics(SM_CXSCREEN)-Width);
 Top:=Ini.ReadInteger(MainGroup,'Top',0);
 // установить первый клип - только если буфер до этого был пуст (иначе ничего не сделает)
 Clips.ItemIndex:=0;
 ClipsSelect(Sender);
 ClipEditorPresent:=true;
end;

procedure TClipEditor.AlwaysOnTopClick(Sender: TObject);
begin // если необходимо, чтобы форма была всегда сверху
 AlwaysOnTop.Checked:=not AlwaysOnTop.Checked;
 if AlwaysOnTop.Checked then SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE)
 else SetWindowPos(Handle,HWND_NOTOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE);
end;

procedure TClipEditor.ClipsChange(Sender: TObject);
var Temp1,Temp2:integer;
begin // если клипы переименовывается (вообще то это не предусмотрено, но...)
 Temp1:=Clips.SelStart;
 Temp2:=Clips.SelLength;
 Clips.Items.Strings[Clips.Tag]:=Clips.Text;
 Clips.ItemIndex:=Clips.Tag;
 Clips.SelStart:=Temp1;
 Clips.SelLength:=Temp2;
end;

procedure TClipEditor.ClipsSelect(Sender: TObject);
var Clip:TClip;
begin // если клип сменился руками
 if(Clips.Tag>=0)and(Clips.Tag<Clips.Items.Count)then begin // созранить данные, если они изменились
  Clip:=Clips.Items.Objects[Clips.Tag] as TClip;
  Clip.Data:=Memo1.Text;
  Clip.Static:=IsStatic.Checked;
 end;
 if(Clips.Tag<>Clips.ItemIndex)and(Clips.ItemIndex<>-1)then begin // показать данные нового клипа
  Clips.Tag:=Clips.ItemIndex;
  Clip:=Clips.Items.Objects[Clips.ItemIndex] as TClip;
  Memo1.Text:=Clip.Data;
  IsStatic.Checked:=Clip.Static;
 end;
end;

procedure TClipEditor.ClipsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin // запретить вставку из клипа
 if((Key=VK_INSERT)and(Shift=[ssCtrl]))or
   ((Key=VK_INSERT)and(Shift=[ssShift]))or
   ((Key=VK_DELETE)and(Shift=[ssShift]))or
   ((Key=ord('C'))and(Shift=[ssCtrl]))or
   ((Key=ord('X'))and(Shift=[ssCtrl]))or
   ((Key=ord('V'))and(Shift=[ssCtrl]))then Key:=0;
end;

procedure TClipEditor.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin // сохранение параметров
 Store;
 ClipEditorPresent:=false;
end;

procedure TClipEditor.N5Click(Sender: TObject);
begin // это окно параметров программы
 UnregisterHotkey(Handle,2); // снять горячие ключи
 Application.CreateForm(TOptionForm, OptionForm);
 OptionForm.ShowModal; // вызвать окно параметров
 OptionForm.Free;
 if PasteMode in [1,2,3] then RegisterDelphiHotkey(Handle,2,HotPaste); // установить горячие ключи обратно
end;

procedure TClipEditor.N12Click(Sender: TObject);
begin // добавление нового клипа - не слишком то и нужная фича, но...
 ClipsSelect(Sender);Clips.Tag:=-1; // сохранить изменения
 if OpenClipboard(GetForegroundWindow) then begin
  EmptyClipboard; // уничтожить старый буфер (отражая изменение)
  CloseClipboard;
  Clips.AddItem('Noname',TClip.Create); // добавить новый, пустой буфер
  Clips.ItemIndex:=Clips.Items.Count-1; // сделать новый буфер активным
 end;
end;

procedure TClipEditor.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin // форменные "горячие ключи"
 if(Key=27)and(Shift=[])then begin Key:=0;Hide;end;
end;

procedure TClipEditor.N13Click(Sender: TObject);
var Old:integer;
begin // уничтожить текущий клип
 Old:=Clips.ItemIndex; // запомнить выделенный клип
 Clips.DeleteSelected; // стереть выделенный клип
 Clips.Tag:=-1; // стереть информацию о нем
 if Old>=Clips.Items.Count then Old:=Clips.Items.Count-1; // если удален последний клип
 Clips.ItemIndex:=Old; // выделить ближайший к старому клип
 if Clips.Items.Count>0 then ClipsSelect(Sender) // обновить информацию
 else begin Memo1.Text:='';IsStatic.Checked:=false;Clips.Text:='';end;
end;

procedure TClipEditor.N17Click(Sender: TObject);
var I,Sel:integer;
begin // стереть "динамические" клипы - те, которые добавлены автоматически
 I:=0;Sel:=Clips.ItemIndex; // сохранить старую позицию
 while I<Clips.Items.Count do begin
  if not (Clips.Items.Objects[I] as TClip).Static then begin // клип динамический
   Clips.Items.Delete(I); // стереть
   if Sel>=I then Dec(Sel);
  end else Inc(I); // ничего не делать
 end;
 if Sel<0 then Sel:=0; // выбрать ближайший подходящий клип
 Clips.ItemIndex:=Sel;
 if Clips.Items.Count=0 then begin Memo1.Text:='';IsStatic.Checked:=false;Clips.Text:='';end;
end;

procedure TClipEditor.N18Click(Sender: TObject);
begin // стереть все клипы
 Clips.Clear;
 Memo1.Text:='';
 IsStatic.Checked:=false;
end;

procedure TClipEditor.N15Click(Sender: TObject);
begin // сменить режим вставки
 if Sender=N15 then begin // стандартный режим - снять горячий ключ
  if PasteMode in [1,2,3] then UnregisterHotkey(Handle,2);
  PasteMode:=0;
 end;
 if Sender=N16 then begin // режим симуляции печати с клавиатуры
  RegisterDelphiHotkey(Handle,2,HotPaste);
  PasteMode:=1;
 end;
 if Sender=N19 then begin // симуляция печати с клавиатуры - ввод серийного номера
  // (замена дефисов на символы табуляции)
  RegisterDelphiHotkey(Handle,2,HotPaste);
  PasteMode:=2;
 end;
 if Sender=N21 then begin // симуляция печати с клавиатуры - ввод серийного номера
  // (с удалением дефисов)
  RegisterDelphiHotkey(Handle,2,HotPaste);
  PasteMode:=3;
 end;
 (Sender as TMenuItem).Checked:=true; // поставить галочку
end;

procedure TClipEditor.pureclip1Click(Sender: TObject);
begin // включение режима 
 PureClip1.Checked:=not PureClip1.Checked; // нельзя одновременно поставить две галочки
 PureClip2.Checked:=false;
 PasteOnPureclip:=PureClip1.Checked; // переустановить глобальные переменные
 AutoPureclip:=PureClip2.Checked;
end;

procedure TClipEditor.N6Click(Sender: TObject);
begin // список окон-исключений с нестандартными горячими клавишами
 Application.CreateForm(TWinList, WinList);
 WinList.ShowModal;
 WinList.Free;
end;

procedure TClipEditor.pureclip2Click(Sender: TObject);
begin // включение
 PureClip1.Checked:=false;
 PureClip2.Checked:=not PureClip2.Checked;
 PasteOnPureclip:=PureClip1.Checked;
 AutoPureclip:=PureClip2.Checked;
end;

procedure TClipEditor.N10Click(Sender: TObject);
var X,Y:PChar;
begin
 GetMem(X,128);GetMem(Y,32);
 Application.MessageBox(StrPCopy(X,Ini.ReadString('Language','Info',
  'Clipboard extender')+' by Python'),StrPCopy(Y,Ini.ReadString('Language',
  'About','About')),MB_ICONINFORMATION);
 FreeMem(X,128);FreeMem(Y,32);
end;

procedure TClipEditor.N8Click(Sender: TObject);
var P:PChar;
begin
 GetMem(P,512);
 GetModuleFileName(hInstance,P,512);
 ExecuteFile(ChangeFileExt(StrPas(P),'.htm'),'',ExtractFileDir(StrPas(P)),SW_SHOW);
 FreeMem(P,512);
end;

end.
