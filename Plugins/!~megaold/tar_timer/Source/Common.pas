unit Common;

interface

Uses Windows,IniFiles;

Const Size=50;
      Max=100;
      Language='Language';
Const CronSection='Shedule';
      CronNumber='CronNumber';

procedure DrawClock(Temp:integer);
procedure DrawOSD(S:string);
Function GetTimeCount:integer;
procedure SendText(WinHandle:HWND;txtText:string);
function Str2Time(S:string):integer; // выделяет время из строки
function Time2Str(Time:integer):string; // перевести в часы:минуты:секунды
function Time2Str2(Time:integer):string; // перевести в NN ч. NN м. NN с.
Function Replace(const S:string;const Src,Dst:string):string; // заменяет все вхождения Src в S на Dst
function ExecuteFile(const FileName, Params, DefaultDir: string;ShowCmd: Integer): THandle;
Function Filter(Line:string):string;
function GetNext(var X:string):string;
Function GetStringDate(var C:string):TDateTime;
Function PutStringDate(const T:TDateTime):string;
Function Index1(Index:byte):byte;
Function Index2(Index:byte):byte;

var TarHandle:integer;
    Ini:TIniFile;
    Words:array[0..7]of word;

implementation

Uses SysUtils,Messages,ShellAPI;

Function Index1(Index:byte):byte;
begin
 case Index of
  0:Result:=0;
  1:Result:=0;
  2:Result:=1;
  3:Result:=1;
  4:Result:=0;
  5:Result:=10;
  else Result:=0;
 end;
end;

Function Index2(Index:byte):byte;
begin
 case Index of
  0:Result:=59;
  1:Result:=23;
  2:case Words[3] of
    2:if((Words[5]+1980) mod 4=0)and((Words[5]+1980) mod 100<>0)then Result:=29
     else Result:=28;
    1,3,5,7,8,10,12:Result:=31;
    4,6,9,11:Result:=30;
    else Result:=0;
   end;
  3:Result:=12;
  4:Result:=6;
  5:Result:=30;
  else Result:=0;
 end;
end;

Function GetStringDate(var C:string):TDateTime;
var X:string;
    I:byte;
    K:integer;
begin
 if C='' then Result:=0 else begin
  For I:=1 to 6 do begin X:=GetNext(C);Val(X,Words[I],K);end; // год, месяц, день
  Result:=EncodeDate(Words[1],Words[2],Words[3])+EncodeTime(Words[4],Words[5],Words[6],0);
 end;
end;

Function PutStringDate(const T:TDateTime):string;
begin
 DecodeDate(T,Words[1],Words[2],Words[3]);
 Result:=Format('%d %d %d',[Words[1],Words[2],Words[3]]);
 DecodeTime(T,Words[1],Words[2],Words[3],Words[4]);
 Result:=Result+Format(' %d %d %d',[Words[1],Words[2],Words[3]]);
end;

function GetNext(var X:string):string;
var I:integer;
begin
 if X='' then Result:='' else begin
  I:=pos(' ',X);
  if I=0 then I:=succ(Length(X));
  Result:=trim(system.copy(X,1,I-1));
  Delete(X,1,I);X:=trim(X);
 end;
end;

Function Filter(Line:string):string;
var Mask:boolean;
    I:integer;
begin Mask:=false;
 For I:=1 to Length(Line) do
  if Mask then begin
   case Line[I] of
    'n':Result:=Result+#13;
    't':Result:=Result+#9;
    else Result:=Result+Line[I];
   end;
   Mask:=false;
  end else case Line[I] of
   '\':Mask:=true;
   else Result:=Result+Line[I];
  end; 
end;

Function GetTimeCount:integer;
var H,M,S,Temp:word;
begin
 DecodeTime(Time,H,M,S,Temp);
 Result:=(H mod 12)*3600+M*60+S;
end;

procedure DrawClock(Temp:integer);
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
 ReleaseDC(0,DC);
 InvalidateRect(0,@Rect,true);
end;

// Посылает текст окну
// WinHandle - хендл окна
// txtText - посылаемая строка
procedure SendText(WinHandle:HWND;txtText: string);
var Data:TCopyDataStruct;
    s:string;
begin
 s:=txtText;
 Data.dwData:=0;
 Data.cbData:=Length(s);
 Data.lpData:=@s[1];
 SendMessage(WinHandle,WM_COPYDATA,0,integer(@Data));
end;

function Str2Time(S:string):integer; // выделяет время из строки
var I,J:integer;
    Mode:(Hr,Min,Sec);
begin Result:=0;J:=0;
 For I:=1 to Length(S) do if not(S[I]in[':','0'..'9'])then exit;
 For I:=1 to Length(S) do if S[I]=':' then Inc(J);
 if J=0 then Val(S,Result,J)else begin
  case J of
   1:Mode:=Min;
   2:Mode:=Hr;
   else exit;
  end;
  J:=0;For I:=1 to Length(S) do
   if S[I]=':' then case Mode of
    Hr:begin if J>24 then begin Result:=0;exit;end;Inc(Result,3600*J);J:=0;Mode:=Min;end;
    Min:begin if J>59 then begin Result:=0;exit;end;Inc(Result,60*J);J:=0;Mode:=Sec;end;
    Sec:begin Result:=0;exit;end;
   end else J:=10*J+ord(S[I])-ord('0');
  if Mode=Sec then Inc(Result,J);
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
 if Time=0 then Result:='0с.' else Result:='';
 if Time>3600 then Result:=Result+inttostr(Time div 3600)+'ч.';
 Time:=Time mod 3600;
 if Time>60 then Result:=Result+inttostr(Time div 60)+'м.';
 Time:=Time mod 60;
 if Time>0 then Result:=Result+inttostr(Time)+'с.';
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

function ExecuteFile(const FileName, Params, DefaultDir: string;ShowCmd: Integer): THandle;
var zFileName, zParams, zDir: array[0..79] of Char;
begin
 Result:=ShellExecute(0,nil,StrPCopy(zFileName, FileName),StrPCopy(zParams, Params),StrPCopy(zDir, DefaultDir), ShowCmd);
end;

end.
