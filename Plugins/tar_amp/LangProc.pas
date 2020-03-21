(* Объект для ускоренного перевода приложений на другие языки. 		    *
 * Автор: Python (SmiSoft(SA)) <smisoft@rambler.ru>                         *
 * Объект изначально был создан для личного пользования, поэтому автор      *
 * не несет ответственности за возможные ошибки или недочеты в работе       *
 * объекта.                                                                 *
 * Вы имеете право изменять этот файл, но обязаны оставить неизменным       *
 * этот комментарий, а также добавить краткий комментарий о сути сделанных  *
 * изменений и имя автора, выполнившего данные изменения.			    *)

{  Использовать компонент несложно. Для его инициализации нужно дать
  стандартную команду:
  Lang:=TLangIni.Create(ChangeFileExt(Application.ExeName,'.ini'));
  Тем самым я создам нужный объект. Лучше, чтобы это был единственный
  объект на всю программу. Обычно я создаю его в FormCreate главной
  формы. В конце работы, объект требуется уничтожить командой
  Lang.Free;
  Обычно это происходит по событию FormClose, или FormDestroy главной
  формы. Для перевода формы на язык, содержащийся в INI файле требуется
  дать команду:
  Lang.Translate(Self);
  Здесь подразумевается, что переводится вызывающая форма. Если это не
  так, то параметром следует указать ту форму, которая должна быть
  переведена. Содержимое INI файла должно иметь такую форму:
  [имя_формы]
  имя_компонента_1=значение_1
  имя_компонента_2=значение_2
  ...
  При этом компонент с указанным именем получит заголовок значение_?.
  Заголовок для метки (TLabel) это Caption, для кнопки (TButton) - тоже
  Caption, для других компонентов - посмотри в исходнике. Особое
  положение занимают TComboBox и TRadioButtonGroup. У них формат такой:
  имя_компонента=текст_по_умолчанию
  имя_компонента#1=значение_первого_элемента
  имя_компонента#2=значение_второго_элемента
  ...
  При этом имя_компонента для TComboBox - это свойство Text, а для
  TRadioButtonGroup - свойство Caption.
  Все компоненты, не предусмотренные в коде, не переводятся. Если нужно
  - допиши в исходный код.
  Наконец, объект способен сохранять значения многих элементов
  (галочек, выбранный элемент комбобокса, списка, значение TEdit и
  некоторые другие). Для загрузки сохраненных значений используйте
  команду:
  Lang.LoadOptions(используемая_группа,форма_для_загрузки);
  Для того, чтобы загрузка произошла, INI файл должен содержать данные,
  иначе команда не изменит значения параметров. Обычно эту команду я
  даю сразу после конструктора, но возможны варианты (потому я и не
  сделал "жесткого" вызова в конструкторе). Сохранение производится по
  команде:
  Lang.StoreOptions(MainGroup,Self);
  Обычно эту команду я даю перед деструктором. Опять, возможны
  варианты.}

unit LangProc;

interface

Uses Windows,Messages,Classes,IniFiles,Forms,SysUtils;

Type TFile1Proc=procedure(const S:string);
Type TFile2Proc=Procedure(const Name1,Name2:string);

Type TInvalidSyntaxMode=(InvalidChar,InvalidFormat,InvalidFlag);
Type EInvalidSyntax=class(Exception)
      Constructor Create(const Invalid,Valid:string;I:integer;Mode:TInvalidSyntaxMode=InvalidChar);
     end;

Type TLangIni=class(TIniFile)
      Procedure Translate(aParent:TCustomForm);
      Procedure LoadOptions(const Group:string;aParent:TCustomForm);
      Procedure StoreOptions(const Group:string;aParent:TCustomForm);
      Function ReadTBool(const Section,Ident:string;Default:Boolean):boolean;
      Procedure WriteTBool(const Section,Ident:string;Value:Boolean);
     end;

function EnableDebugPrivilege(const Value:Boolean):Boolean;
 // дает возможность уничтожать процессы
Function Replace(const S:string;const Src,Dst:string):string;
 // заменяет все вхождения строки Src в S на Dst
Function Replace2(const Data:string;const Src:string;const Dst:string):string;
 // заменяет все вхождения вида {Src} на Dst, {Src num1} на вырезку из Dst
 // с num1 символа до конца, {Src num1 num2} на вырезку из Dst с num1 символа
 // до num2 символа
Function GetTimeCount:integer;
Function ExtractName(const Name:string):string; // извлекает ТОЛЬКО имя файла
procedure DrawClock(Temp:integer); // рисует часы в правом верхнем углу экрана
procedure DrawOSD(S:string); // рисует OnScreenDisplay сообщение по центру экрана. Задерживает выполнение программы на 2 сек.
procedure DrawOSD2(S:string); // рисует OnScreenDisplay сообщение в правом верхнем углу экрана.
function Mask(const S:string):string; // преобразует спецсимволы в спецпоследовательности
function Unmask(const Line:string):string; // преобразует спецпоследовательности в спецсимволы
function Str2Time(const S:string):integer; // выделяет время из строки
function Time2Str(Time:integer):string; // перевести в часы:минуты:секунды
function Time2Str2(Time:integer):string; // перевести в NN ч. NN м. NN с.
function GetNext(var X:string):string; // вытаскивает следующую лексему из строки. Лексема удаляется
 // рисует на фиксированном месте указанное сообщение. Задерживает выполнение программы на 1 сек.
Procedure Process1File(const aName:string;aLevel:byte;File1Proc:TFile1Proc);
Procedure Process2Files(const aName1,aName2:string;Level:byte;File2Proc:TFile2Proc;Reality:boolean);
function ExecuteFile(const FileName,Params,DefaultDir:string;ShowCmd:Integer):integer;
 // дубликат из модуля FmxUtils - вещь полезная
procedure SendText(WinHandle:cardinal;txtText:string); // посылает строку приложению через стандартный интерфейс
Function DetectSize(S:string):integer;
procedure PartCopy(const S1,S2:string;Index,Size:integer);
function BlockInput(fBlockIt:bool):bool;stdcall;external 'user32.dll';
 // выключает и включает реакцию на ввод пользователя
Function ExtractCommandName(Line:string):string;
Function ExtractCommandLine(Line:string):string;
Function XMessageBox(Handle:cardinal;Text,Caption:string;Flags:cardinal=MB_OK):cardinal;
procedure SetWallpaper(sWallpaperBMPPath:String;bTile:boolean=false);

Type PLastInputInfo=^TLastInputInfo;
     TLastInputInfo=packed record
      cbSize:cardinal;
      dwTime:cardinal;
     end;
function GetLastInputInfo(plii:PLastInputInfo):bool;stdcall;external 'user32.dll';

var TempDir,WinDir:shortstring;
    Stat:(None,Running,Stopping);
    OldLen:word;
    Ini:TLangIni;

implementation

uses ShellAPI,StdCtrls,ExtCtrls,Menus,ComCtrls,Dialogs,Spin,Registry;

{ EInvalidSyntax }

constructor EInvalidSyntax.Create(const Invalid,Valid: string; I: integer;Mode:TInvalidSyntaxMode=InvalidChar);
var S:string;
begin
 if(Mode=InvalidChar)and(I>Length(S)) then Mode:=InvalidFormat;
 case Mode of
  InvalidChar:begin
   S:=Ini.ReadString('Error','InvalidChar','Found invalid char %2 in position %3\nin line "%1".');
   S:=Unmask(S);
   S:=Replace(S,'%1',Invalid);
   S:=Replace(S,'%2',Invalid[I]);
   S:=Replace(S,'%3',inttostr(I));
   inherited Create(S);
  end;
  InvalidFormat:begin
   S:=Ini.ReadString('Error','InvalidFormat','%1 is not in format %2.');
   S:=Unmask(S);
   S:=Replace(S,'%1',Invalid);
   S:=Replace(S,'%2',Valid);
   inherited Create(S);
  end;
  InvalidFlag:begin
   S:=Ini.ReadString('Error','InvalidFlag','%1 is not a valid flag!');
   S:=Unmask(S);
   S:=Replace(S,'%1',Invalid);
   inherited Create(S);
  end;
 end;
end;

{ TLangIni }

Procedure TLangIni.Translate(aParent:TCustomForm);
var I,J:integer;
    C:TComponent;
begin
 if aParent<>nil then begin
  aParent.Caption:=ReadString(aParent.Name,'Caption',aParent.Caption);
  For I:=0 to aParent.ComponentCount-1 do begin
   C:=aParent.Components[I];
   if C is TCustomLabel then with C as TCustomLabel do Caption:=ReadString(aParent.Name,Name,Caption)
   else if C is TButton then with C as TButton do Caption:=ReadString(aParent.Name,Name,Caption)
   else if C is TMenuItem then with C as TMenuItem do Caption:=ReadString(aParent.Name,Name,Caption)
   else if C is TCheckBox then with C as TCheckBox do Caption:=ReadString(aParent.Name,Name,Caption)
   else if C is TRadioButton then with C as TRadioButton do Caption:=ReadString(aParent.Name,Name,Caption)
   else if C is TStaticText then with C as TStaticText do Caption:=ReadString(aParent.Name,Name,Caption)
   else if C is TCustomLabeledEdit then with C as TCustomLabeledEdit do EditLabel.Caption:=ReadString(aParent.Name,Name,EditLabel.Caption)
   else if C is TTabSheet then with C as TTabSheet do Caption:=ReadString(aParent.Name,Name,Caption)
   else if C is TComboBox then with C as TComboBox do begin
    Text:=ReadString(aParent.Name,Name,Text);
    if ReadBool(aParent.Name,Name+'#',false) then // переводимый
     For J:=0 to Items.Count-1 do Items[J]:=ReadString(aParent.Name,Name+'#'+inttostr(J),Items[J]);
   end else if C is TGroupBox then with C as TGroupBox do Caption:=ReadString(aParent.Name,Name,Caption)
   else if C is TRadioGroup then with C as TRadioGroup do begin
    Caption:=ReadString(aParent.Name,Name,Caption);
    if ReadBool(aParent.Name,Name+'#',false) then // переводимая группа
     For J:=0 to Items.Count-1 do Items[J]:=ReadString(aParent.Name,Name+'#'+inttostr(J),Items[J]);
   end
  end;
 end;
end;

Procedure TLangIni.LoadOptions(const Group:string;aParent:TCustomForm);
var I:word;
    C:TComponent;
begin
 if aParent<>nil then begin
  aParent.Left:=ReadInteger(Group,'Left',aParent.Left);
  aParent.Top:=ReadInteger(Group,'Top',aParent.Top);
  For I:=0 to aParent.ComponentCount-1 do begin
   C:=aParent.Components[I];
   if C.Tag>=0 then
    if C is TCustomEdit then with C as TCustomEdit do Text:=ReadString(Group,Name,Text)
    else if C is TRadioButton then with C as TRadioButton do Checked:=ReadBool(Group,Name,Checked)
    else if C is TCheckBox then with C as TCheckBox do Checked:=ReadBool(Group,Name,Checked)
    else if C is TListBox then with C as TListBox do ItemIndex:=ReadInteger(Group,Name,ItemIndex)
    else if C is TTrackBar then with C as TTrackBar do Position:=ReadInteger(Group,Name,Position)
    else if C is TScrollBar then with C as TScrollBar do Position:=ReadInteger(Group,Name,Position)
    else if C is TSpinEdit then with C as TSpinEdit do Value:=ReadInteger(Group,Name,Value)
    else if C is TPageControl then with C as TPageControl do ActivePageIndex:=ReadInteger(Group,Name,ActivePageIndex)
    else if C is TComboBox then with C as TComboBox do ItemIndex:=ReadInteger(Group,Name,ItemIndex)
    else if C is TRadioGroup then with C as TRadioGroup do ItemIndex:=ReadInteger(Group,Name,ItemIndex)
    else if C is TMenuItem then with C as TMenuItem do Checked:=ReadBool(Group,Name,Checked)
    else if C is TTimer then with C as TTimer do Interval:=ReadInteger(Group,Name,Interval)
  end;
 end;
end;

procedure TLangIni.StoreOptions(const Group:string;aParent:TCustomForm);
var I:word;
    C:TComponent;
begin
 if aParent<>nil then begin
  WriteInteger(Group,'Left',aParent.Left);
  WriteInteger(Group,'Top',aParent.Top);
  For I:=0 to aParent.ComponentCount-1 do begin
   C:=aParent.Components[I];
   if C.Tag>=0 then
    if C is TCustomEdit then with C as TCustomEdit do WriteString(Group,Name,Text)
    else if C is TRadioButton then with C as TRadioButton do WriteBool(Group,Name,Checked)
    else if C is TCheckBox then with C as TCheckBox do WriteBool(Group,Name,Checked)
    else if C is TListBox then with C as TListBox do WriteInteger(Group,Name,ItemIndex)
    else if C is TTrackBar then with C as TTrackBar do WriteInteger(Group,Name,Position)
    else if C is TScrollBar then with C as TScrollBar do WriteInteger(Group,Name,Position)
    else if C is TPageControl then with C as TPageControl do WriteInteger(Group,Name,ActivePageIndex)
    else if C is TComboBox then with C as TComboBox do WriteInteger(Group,Name,ItemIndex)
    else if C is TRadioGroup then with C as TRadioGroup do WriteInteger(Group,Name,ItemIndex)
    else if C is TMenuItem then with C as TMenuItem do begin
     if Checked then WriteBool(Group,Name,Checked)
     else DeleteKey(Group,Name);
    end else if C is TTimer then with C as TTimer do WriteInteger(Group,Name,Interval)
  end;
 end;
end;

Function TLangIni.ReadTBool(const Section,Ident:string;Default:Boolean):boolean;
var S:string[10];
begin
 if Default then S:='True' else S:='False';
 S:=ReadString(Section,Ident,S);
 Result:=CompareText(S,'TRUE')=0;
end;

Procedure TLangIni.WriteTBool(const Section,Ident:string;Value:Boolean);
begin
 if Value then WriteString(Section,Ident,'True')
 else WriteString(Section,Ident,'False');
end;

function EnableDebugPrivilege(const Value: Boolean): Boolean;
const SE_DEBUG_NAME = 'SeDebugPrivilege';
var hToken:THandle;
    tp:TOKEN_PRIVILEGES;
    d:DWORD;
begin
  Result:=False;
  if OpenProcessToken(GetCurrentProcess,TOKEN_ADJUST_PRIVILEGES,hToken) then begin
    tp.PrivilegeCount:=1;
    LookupPrivilegeValue(nil,SE_DEBUG_NAME,tp.Privileges[0].Luid);
    if Value then tp.Privileges[0].Attributes := $00000002
    else tp.Privileges[0].Attributes := $80000000;
    AdjustTokenPrivileges(hToken,False,tp,SizeOf(TOKEN_PRIVILEGES),nil,d);
    if GetLastError = ERROR_SUCCESS then Result:=True;
    CloseHandle(hToken);
  end;
end;

Function ExtractCommandName(Line:string):string;
 // выдергивает из полной командной строки только имя исполняемого файла.
 // Понимает исполняемые файлы, в имени которых встречается пробел (если все имя заключено в кавычки "")
var Mode:byte;
    I,I1,I2:integer;
begin
 Mode:=0;I1:=1;I2:=Length(Line);
 For I:=1 to Length(Line) do case Line[I] of
  '"':case Mode of
   0:begin I1:=I+1;Mode:=1;end;
   1:begin I2:=I-1;break;end;
  end;
  ' ':case Mode of
   2:begin I2:=I-1;break;end;
  end;
  else case Mode of
   0:begin I1:=I;Mode:=2;end;
  end;
 end;
 Result:=copy(Line,I1,I2-I1+1);
end;

Function ExtractCommandLine(Line:string):string;
 // выдергивает из полной командной строки только параметры командной строки
 // Понимает исполняемые файлы, в имени которых встречается пробел (если все имя заключено в кавычки "")
var Mode:byte;
    I,I3:integer;
begin
 Mode:=0;I3:=Length(Line)+1;
 For I:=1 to Length(Line) do case Line[I] of
  '"':case Mode of
   0:begin Mode:=1;end;
   1:begin I3:=I+2;break;end;
  end;
  ' ':case Mode of
   2:begin I3:=I+1;break;end;
  end;
  else case Mode of
   0:begin Mode:=2;end;
  end;
 end;
 Result:=Copy(Line,I3,Length(Line)-I3+1);
end;

Function Replace(const S:string;const Src,Dst:string):string;
var I:word;
begin
 Result:='';I:=1;
 if Src<>'' then begin
  While(I<=Length(S)-Length(Src)+1)do
   if Copy(S,I,Length(Src))=Src then begin Result:=Result+Dst;Inc(I,Length(Src));end
   else begin Result:=Result+S[I];Inc(I);end;
  While(I<=Length(S))do begin Result:=Result+S[I];Inc(I);end;
 end;
end;

Function Replace2(const Data:string;const Src:string;const Dst:string):string;
var Flag:string;
    Mode:(None,ReadFlag,Read1,Read2,Notsup);
    Data1,Data2,Start,I:word;
begin
 Result:='';Mode:=None;Data1:=0;Data2:=0;Start:=1;
 For I:=1 to Length(Data) do
  case Data[I] of
   '{':case Mode of
     None:begin Flag:='';Data1:=0;Data2:=0;Start:=I;Mode:=ReadFlag;end;
     ReadFlag:if Flag='' then begin Result:=Result+'{';Mode:=None;end;
    end;
   ' ':case Mode of
     None:Result:=Result+' ';
     ReadFlag:Mode:=Read1;
     Read1:Mode:=Read2;
     Read2:Mode:=Notsup;
    end;
   '0'..'9':case Mode of
     None:Result:=Result+Data[I];
     ReadFlag:Flag:=Flag+Data[I];
     Read1:Data1:=10*Data1+ord(Data[I])-ord('0');
     Read2:Data2:=10*Data2+ord(Data[I])-ord('0');
    end;
   '}':begin case Mode of
     None:Result:=Result+Data[I];
     ReadFlag:if CompareText(Flag,Src)=0 then Result:=Result+Dst
      else Result:=Result+copy(Data,Start,I-Start+1);
     Read1:if CompareText(Flag,Src)=0 then Result:=Result+copy(Dst,Data1,Length(Dst)-Data1+1)
      else Result:=Result+copy(Data,Start,I-Start+1);
     Read2,Notsup:if CompareText(Flag,Src)=0 then Result:=Result+copy(Dst,Data1,Data2-Data1+1)
      else Result:=Result+copy(Data,Start,I-Start+1);
    end;Mode:=None;end;
   else case Mode of
    None:Result:=Result+Data[I];
    ReadFlag:Flag:=Flag+Data[I];
   end;
  end;
end;

Function GetTimeCount:integer;
var H,M,S,Temp:word;
begin
 DecodeTime(Time,H,M,S,Temp);
 Result:=(H mod 12)*3600+M*60+S;
end;

procedure DrawClock(Temp:integer);
Const Size=50;
var DC,MemDC,CDC,Pen1,Pen2,Pen3:integer;
    I:byte;
    Angle:double;
    Point:TPoint;
begin
 DC:=GetDC(0);
 MemDC:=CreateCompatibleDC(DC);
 CDC:=CreateCompatibleBitmap(DC,Size,Size);
 SelectObject(MemDC,CDC);
 BitBlt(MemDC,0,0,Size,Size,DC,GetSystemMetrics(SM_CXSCREEN)-Size,0,SRCCOPY);
 Pen1:=CreatePen(PS_SOLID,1,0);
 Pen2:=CreatePen(PS_SOLID,2,0);
 Pen3:=CreatePen(PS_SOLID,3,0);
 Ellipse(MemDC,0,0,Size,Size);
 For I:=0 to 11 do begin
  if I mod 3=0 then SelectObject(MemDC,Pen2) else SelectObject(MemDC,Pen1);
  Angle:=I*pi/6;
  MoveToEx(MemDC,trunc(0.75*Size/2*cos(Angle)+size/2),trunc(0.75*Size/2*sin(Angle)+size/2),@Point);
  LineTo(MemDC,trunc(Size/2*cos(Angle)+size/2),trunc(Size/2*sin(Angle)+size/2));
 end;
 SelectObject(MemDC,Pen3);
 Angle:=Temp/3600*2*pi/12-pi/2;
 MoveToEx(MemDC,Size div 2,Size div 2,@Point);
 LineTo(MemDC,trunc(0.6*Size/2*cos(Angle)+Size/2),trunc(0.6*Size/2*sin(Angle)+Size/2));
 SelectObject(MemDC,Pen2);
 Temp:=Temp mod 3600;
 Angle:=Temp/60*2*pi/60-pi/2;
 MoveToEx(MemDC,Size div 2,Size div 2,@Point);
 LineTo(MemDC,trunc(0.8*Size/2*cos(Angle)+size/2),trunc(0.8*Size/2*sin(Angle)+size/2));
 SelectObject(MemDC,Pen1);
 Temp:=Temp mod 60;
 Angle:=Temp*2*pi/60-pi/2;
 MoveToEx(MemDC,Size div 2,Size div 2,@Point);
 LineTo(MemDC,trunc(Size/2*cos(Angle)+size/2),trunc(Size/2*sin(Angle)+size/2));
 DeleteObject(Pen1);DeleteObject(Pen2);DeleteObject(Pen3);
 BitBlt(DC,GetSystemMetrics(SM_CXSCREEN)-Size,0,Size,Size,MemDC,0,0,SRCCOPY);
 DeleteObject(CDC);
 DeleteDC(MemDC);
 ReleaseDC(0,DC);
end;

procedure DrawOSD(S:string);
var DC,Font,MemDC,CDC,I:integer;
    LogFont:TLogFont;
    Size:TSize;
    Rect:TRect;
begin
 DC:=GetDC(0);
 LogFont.lfHeight:=40;
 LogFont.lfWidth:=0;
 LogFont.lfEscapement:=0;
 LogFont.lfOrientation:=0;
 LogFont.lfWeight:=FW_BOLD;
 LogFont.lfItalic:=0;
 LogFont.lfUnderline:=0;
 LogFont.lfStrikeOut:=0;
 LogFont.lfCharSet:=RUSSIAN_CHARSET;
 LogFont.lfOutPrecision:=OUT_DEFAULT_PRECIS;
 LogFont.lfClipPrecision:=CLIP_DEFAULT_PRECIS;
 LogFont.lfQuality:=DEFAULT_QUALITY;
 LogFont.lfPitchAndFamily:=VARIABLE_PITCH;
 LogFont.lfFaceName:='Arial';
 Font:=CreateFontIndirect(LogFont);
 SelectObject(DC,Font);
 GetTextExtentPoint32(DC,@S[1],Length(S),Size);
 MemDc:=CreateCompatibleDc(DC);
 CDC:=CreateCompatibleBitmap(DC,Size.cx,Size.cy);
 SelectObject(MemDC,CDC);
 SelectObject(MemDC,Font);
 SetTextColor(MemDC,$55CC99);
 SetBkMode(MemDC,OPAQUE);
 SetBkColor(MemDC,$550055);
 TextOut(MemDC,0,0,@S[1],Length(S));
 Rect.Left:=(GetSystemMetrics(SM_CXSCREEN)-Size.cx)shr 1;
 Rect.Right:=(GetSystemMetrics(SM_CXSCREEN)+Size.cx)shr 1;
 Rect.Top:=3*GetSystemMetrics(SM_CYSCREEN) shr 2-Size.cy shr 1;
 Rect.Bottom:=3*GetSystemMetrics(SM_CYSCREEN) shr 2+Size.cy shr 1;
 For I:=1 to 200 do begin
  BitBlt(DC,Rect.Left,Rect.Top,Size.cx,Size.cy,MemDC,0,0,SRCCOPY);
  Sleep(10);
 end;
 DeleteObject(Font);
 DeleteObject(CDC);
 DeleteDC(MemDC);
 ReleaseDC(0,DC);
 InvalidateRect(0,@Rect,true);
end;

procedure DrawOSD2(S:string);
var DC,Font,MemDC,CDC:integer;
    LogFont:TLogFont;
    Size:TSize;
    Rect:TRect;
begin
 DC:=GetDC(0);
 LogFont.lfHeight:=40;
 LogFont.lfWidth:=0;
 LogFont.lfEscapement:=0;
 LogFont.lfOrientation:=0;
 LogFont.lfWeight:=FW_BOLD;
 LogFont.lfItalic:=0;
 LogFont.lfUnderline:=0;
 LogFont.lfStrikeOut:=0;
 LogFont.lfCharSet:=RUSSIAN_CHARSET;
 LogFont.lfOutPrecision:=OUT_DEFAULT_PRECIS;
 LogFont.lfClipPrecision:=CLIP_DEFAULT_PRECIS;
 LogFont.lfQuality:=DEFAULT_QUALITY;
 LogFont.lfPitchAndFamily:=VARIABLE_PITCH;
 LogFont.lfFaceName:='Arial';
 Font:=CreateFontIndirect(LogFont);
 SelectObject(DC,Font);
 GetTextExtentPoint32(DC,@S[1],Length(S),Size);
 MemDc:=CreateCompatibleDc(DC);
 CDC:=CreateCompatibleBitmap(DC,Size.cx,Size.cy);
 SelectObject(MemDC,CDC);
 SelectObject(MemDC,Font);
 SetTextColor(MemDC,$55CC99);
 SetBkMode(MemDC,OPAQUE);
 SetBkColor(MemDC,$550055);
 TextOut(MemDC,0,0,@S[1],Length(S));
 Rect.Left:=GetSystemMetrics(SM_CXSCREEN)-Size.cx;
 Rect.Right:=GetSystemMetrics(SM_CXSCREEN);
 Rect.Top:=0;
 Rect.Bottom:=Size.cy;
 if OldLen>Length(S) then InvalidateRect(0,@Rect,false);
 OldLen:=Length(S);
 BitBlt(DC,Rect.Left,Rect.Top,Size.cx,Size.cy,MemDC,0,0,SRCCOPY);
 DeleteObject(Font);
 DeleteObject(CDC);
 DeleteDC(MemDC);
 ReleaseDC(0,DC);
end;

function Mask(const S:string):string;
var I:integer;
begin
 Result:='';
 For I:=1 to Length(S) do
  case S[I] of
   '\':Result:=Result+'\\';
   #10:;
   #13:Result:=Result+'\n';
   #9:Result:=Result+'\t';
   else Result:=Result+S[I];
  end; 
end;

function Unmask(const Line:string):string;
var Mask:boolean;
    I:integer;
begin
 Mask:=false;Result:='';
 For I:=1 to Length(Line) do
  if Mask then begin
   case Line[I] of
    'n':Result:=Result+#13#10;
    't':Result:=Result+#9;
    else Result:=Result+Line[I];
   end;
   Mask:=false;
  end else case Line[I] of
   '\':Mask:=true;
   else Result:=Result+Line[I];
  end; 
end;

function Str2Time(const S:string):integer; // выделяет время из строки
Const TimeFormat='[[hh:]mm:]ss';
function ReadNumber(const S:string;var I:integer):integer;
begin
 Result:=0;
 if(I>Length(S))then raise EInvalidSyntax.Create(S,'',Length(S));
 if(S[I]<'0')or(S[I]>'9')then raise EInvalidSyntax.Create(S,'',I);
 while(I<=Length(S))and(S[I]>='0')and(S[I]<='9')do begin
  Result:=10*Result+ord(S[I])-ord('0');
  Inc(I);
 end;
end;
var I,J:integer;
    Mode:(Sec,Min,Hr);
begin
 if Length(S)=0 then raise EInvalidSyntax.Create(S,TimeFormat,0,InvalidFormat);
 Mode:=Sec;For I:=1 to Length(S) do case S[I] of // фильтрация
  '0'..'9':;
  ':':if Mode<Hr then Inc(Mode) else raise EInvalidSyntax.Create(S,'',I);
  else raise EInvalidSyntax.Create(S,'',I);
 end;
 I:=1;Result:=0;
 if Mode=Hr then begin
  J:=ReadNumber(S,I);
  if(S[I]<>':')or(J>24)or(I>Length(S))then raise EInvalidSyntax.Create(S,TimeFormat,0,InvalidFormat);
  Inc(Result,3600*J);Inc(I);
 end;
 if Mode>=Min then begin
  J:=ReadNumber(S,I);
  if(S[I]<>':')or((J>=60)and(Mode>Min))or(I>Length(S))then raise EInvalidSyntax.Create(S,TimeFormat,0,InvalidFormat);
  Inc(Result,60*J);Inc(I);
 end;
 if Mode>=Sec then begin
  J:=ReadNumber(S,I);
  if((J>=60)and(Mode>Sec))or(I<=Length(S))then raise EInvalidSyntax.Create(S,TimeFormat,0,InvalidFormat);
  Inc(Result,J);
 end;
end;

function Time2Str(Time:integer):string; // перевести в часы:минуты:секунды
var Use:boolean;
    S:string[5];
begin
 Result:='';Use:=false;
 if Time>3600 then begin
  Str(Time div 3600,S);
  if Length(S)<2 then S:='0'+S;
  Result:=S+':';
  Use:=true;
 end;
 Time:=Time mod 3600;
 if(Time>60)or Use then begin
  Str(Time div 60,S);
  if Length(S)<2 then S:='0'+S;
  Result:=Result+S+':';
  Use:=true;
 end;
 Time:=Time mod 60;
 Str(Time,S);
 if Use and(Length(S)<2)then S:='0'+S;
 Result:=Result+S;
end;

function Time2Str2(Time:integer):string; // перевести в NN ч. NN м. NN с.
begin
 Result:='';
 if Time>=3600 then Result:=Result+inttostr(Time div 3600)+Ini.ReadString('Language','Hr','h.');
 Time:=Time mod 3600;
 if Time>=60 then Result:=Result+inttostr(Time div 60)+Ini.ReadString('Language','Min','m.');
 Time:=Time mod 60;
 if(Time>0)or(Result='')then Result:=Result+inttostr(Time)+Ini.ReadString('Language','Sec','s.');
end;

function GetNext(var X:string):string;
var I:integer;
begin
 if X='' then Result:='' else repeat
  I:=pos(' ',X);
  if I=0 then I:=succ(Length(X));
  Result:=trim(system.copy(X,1,I-1));
  Delete(X,1,I);X:=trim(X);
 until(Result<>'')or(X='');
end;

Function ExtractName(const Name:string):string;
var I:word;
begin
 I:=Length(ExtractFilePath(Name))+1;
 Result:=copy(Name,I,Length(Name)-I+1-Length(ExtractFileExt(Name)));
end;

Procedure Process1File(const aName:string;aLevel:byte;File1Proc:TFile1Proc);
Procedure Recursive(Layer:byte);
var SR:TSearchRec;
    Found:integer;
begin
 Found:=FindFirst(ExtractFileName(aName),faAnyFile,Sr);
 while(Found=0)and(Stat=Running)do begin
  if FileExists(Sr.Name)then File1Proc(ExpandFileName(Sr.Name));
  Found:=FindNext(Sr);
 end;
 FindClose(Sr);
 if Layer>0 then begin
  Found:=FindFirst('*.*',faAnyFile,Sr);
  while(Found=0)and(Stat=Running)do begin // folder processing
   if Sr.Name[1]<>'.' then begin
    {$I-}ChDir(SR.Name);{$I+}
    if IOResult=0 then begin
     Recursive(Layer-1);
     ChDir('..');
    end;
   end;
   Found:=FindNext(SR);
  end;
  FindClose(SR);
 end;
end;
var OldFolder:string;
begin
 {$I-}
 GetDir(0,OldFolder);
 Stat:=Running;
 ChDir(ExtractFileDir(aName));
 if IOResult=0 then begin
  Recursive(aLevel);
  ChDir(OldFolder);IOResult;
 end;
 Stat:=None;
 {$I+}
end;

Procedure Process2Files(const aName1,aName2:string;Level:byte;File2Proc:TFile2Proc;Reality:boolean);
var Target,RelDir,FilePart,ExtPart:string;
    SrcLen:word;
Procedure Process(Level:byte);
var SR:TSearchRec;
    Found:integer;
begin
 if Level>0 then begin
  Found:=FindFirst('*.*',faAnyFile,SR);
  while(Found=0)and(Stat=Running)do begin
   with Sr do if(not FileExists(Name))and(Name[1]<>'.')and(Name[Length(Name)]<>'.')then begin
    {$I-}ChDir(Name);{$I-}
    if IOResult=0 then begin Process(Level-1);ChDir('..');end;
   end;
   Found:=FindNext(Sr);
  end;
  FindClose(SR);
 end;
 Found:=FindFirst(ExtractFileName(aName1),faAnyFile,SR);
 while(Found=0)and(Stat=Running)do begin
  if FileExists(Sr.Name) then begin
   Target:=Replace2(aName2,'FileName',Sr.Name);
   Target:=Replace2(Target,'Name',ExtractName(Sr.Name));
   Target:=Replace2(Target,'Ext',ExtractFileExt(Sr.Name));
   if ExtractFileName(Target)='*' then begin
    FilePart:=Sr.Name;
    ExtPart:='';
   end else begin
    FilePart:=ExtractName(Target);
    if FilePart='*' then FilePart:=ExtractName(Sr.Name);
    ExtPart:=ExtractFileExt(Target);
    if ExtPart='.*' then ExtPart:=ExtractFileExt(Sr.Name);
   end;
   Target:=ExtractFilePath(ExpandFileName(Target));
   RelDir:=ExtractFilePath(ExpandFileName(Sr.Name));
   Delete(RelDir,1,SrcLen);
   {$I-}if(Reality)and(RelDir<>'')then MkDir(Target+RelDir);IOResult;{$I+}
   File2Proc(ExpandFileName(Sr.Name),Target+RelDir+FilePart+ExtPart);
  end;
  Found:=FindNext(SR);
 end;
 FindClose(SR);
end;
var OldDir:string;
begin
 {$I-}
 Stat:=Running;
 GetDir(0,OldDir);
 ChDir(ExtractFileDir(aName1));
 if IOResult=0 then begin
  SrcLen:=Length(ExtractFilePath(ExpandFileName(aName1)));
  Process(Level);
  ChDir(OldDir);
 end;
 Stat:=None;
 {$I+}
end;

function ExecuteFile(const FileName,Params,DefaultDir:string;ShowCmd:Integer):integer;
var zFileName,zParams,zDir:array[0..79]of Char;
begin
 Result:=ShellExecute(0,nil,StrPCopy(zFileName,FileName),StrPCopy(zParams,Params),
  StrPCopy(zDir,DefaultDir),ShowCmd);
end;

// Посылает текст окну
// WinHandle - хендл окна
// txtText - посылаемая строка
procedure SendText(WinHandle:cardinal;txtText: string);
var Data:TCopyDataStruct;
    s:string;
begin
 if WinHandle<>0 then begin
  s:=txtText;
  Data.dwData:=0;
  Data.cbData:=Length(s);
  Data.lpData:=@s[1];
  SendMessage(WinHandle,WM_COPYDATA,0,integer(@Data));
 end;
end;

Function DetectSize(S:string):integer;
var I,Temp:integer;
begin
 Temp:=0;Result:=0;
 For I:=1 to Length(S) do case upcase(S[I]) of
  '0'..'9':Temp:=10*Temp+ord(S[I])-ord('0');
  'G':begin Inc(Result,Temp*1024*1024*1024);Temp:=0;end;
  'M':begin Inc(Result,Temp*1024*1024);Temp:=0;end;
  'K':begin Inc(Result,Temp*1024);Temp:=0;end;
 end;
 Inc(Result,Temp);
end;

procedure PartCopy(const S1,S2:string;Index,Size:integer);
Const Max=512;
Type TBuffer=array[1..Max]of char;
var Buf:TBuffer;
    F1,F2:file;
    Need,Has,Wrote:integer;
begin
 {$I-}
 AssignFile(F1,S1);Reset(F1,1);
 if IOResult<>0 then begin CloseFile(F1);exit;end;
 ForceDirectories(ExtractFileDir(S2));
 AssignFile(f2,S2);{$I-}Rewrite(F2,1);{$I+}
 if IOResult<>0 then begin CloseFile(F1);CloseFile(F2);exit;end;
 Seek(F1,Index);Need:=Size;
 repeat
  if Need<Max then BlockRead(F1,Buf,Need,Has) else BlockRead(F1,Buf,Max,Has);
  if Has<>0 then BlockWrite(F2,Buf,Has,Wrote);Dec(Need,Has);
 until(Need=0)or(Has=0)or(Wrote<>Has);
 CloseFile(F1);CloseFile(F2);
 {$I+}
end;

Function XMessageBox(Handle:cardinal;Text,Caption:string;Flags:cardinal=MB_OK):cardinal;
var X,Y:PChar;
begin
 GetMem(X,1024);GetMem(Y,128);
 Result:=MessageBox(Handle,StrPLCopy(X,Text,1024),StrPLCopy(Y,Caption,128),Flags);
 FreeMem(X,1024);FreeMem(Y,128);
end;

procedure SetWallpaper(sWallpaperBMPPath:String;bTile:boolean=false);
var reg:TRegIniFile;
begin
// Изменяем ключи реестра
// HKEY_CURRENT_USER\Control Panel\Desktop
// TileWallpaper (REG_SZ)
// Wallpaper (REG_SZ)
 reg:=TRegIniFile.Create('Control Panel\Desktop' );
 with reg do begin
  WriteString('','Wallpaper',sWallpaperBMPPath);
  if(bTile)then WriteString('','TileWallpaper','1')
  else WriteString('','TileWallpaper','0');
 end;
 reg.Free;
 // Оповещаем всех о том, что мы изменили системные настройки
 SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, Nil, SPIF_SENDWININICHANGE);
end;

var Z:PChar;
begin
 GetMem(Z,180);
 GetTempPath(180,Z);
 TempDir:=StrPas(Z);
 GetWindowsDirectory(Z,180);
 WinDir:=StrPas(Z)+'\';
 FreeMem(Z,180);
end.
