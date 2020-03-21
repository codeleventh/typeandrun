unit Common;

interface

Uses IniFiles;

Const MainGroup='Clipboard';

Type TBinMode=(ModeNo,ModeRead,ModeWrite);
Type TBiniFile=class(TIniFile) // объект, умеющий хранить двоичные данные в "теневом"
      // двоичном файле
      private
       BinFile:integer; // хэндл двоичного файла
       BinMode:TBinMode;
      public
       Constructor Create(FileName:string;aMode:TBinMode=ModeRead);
       Procedure ResetBinary(NewMode:TBinMode=ModeWrite);
       Function ReadBlob(Section,Key:string):integer;virtual;
       Procedure WriteBlob(Section,Key:string;Blob:integer);virtual;
       Function ReadPChar(Section,Key:string):PChar;virtual;
       Procedure WritePChar(Section,Key:string;P:PChar);virtual;
       Function ReadBoolean(const Section,Ident:string;Default:Boolean):boolean;virtual;
       Procedure WriteBoolean(const Section,Ident:string;Value:Boolean);
       Procedure Free;
     end;
     TClip=class
       FData:PChar;
      private
       Function GetData:string;
       Procedure SetData(Value:string);
      public
       Static:boolean;
       property Data:string read GetData write SetData;
       Constructor Create;overload;
       Constructor Create(Clip:TClip);overload;
       Constructor Create(Handle:integer);overload;
       Procedure Free;
     end;

var DisappearDelay:cardinal;
    Ini:TBiniFile;
    DescrLen,MaxDynamic:word;
    PasteOnPureClip,AutoPureclip:boolean;
    HotCopy,HotPaste,DelayCopy,DelayPaste:word;
    PasteMode:byte;
    DelayPrint:word;
    SRus,SLat:string;
    ClipEditorPresent,OptionPresent,WinPresent:boolean;

Function ExtractDescr(P:PChar):string;
Function RegisterDelphiHotkey(Handle,Id:integer;Hotkey:word):boolean;
Procedure SendKey(Key:char);
function GetActiveKbdLayout:cardinal;
function GetActiveKbdLayoutWnd:cardinal;
procedure SetKbdLayout(kbLayout:cardinal);
procedure SetKbdLayoutWnd(kbLayout:cardinal);
procedure PureClip;
Procedure Convert(Line:string);
Procedure Translit(Line:string);
Procedure SendHotkey(Hotkey:word);
function GetNext(var X:string):string;
Procedure Wait(msec:cardinal;Handle:integer);
Function Replace(const S:string;const Src,Dst:string):string;
 // заменяет все вхождения строки Src в S на Dst
function ExecuteFile(const FileName,Params,DefaultDir:string;ShowCmd:Integer):THandle;
procedure DrawOSD(S:string);

implementation

Uses Classes,SysUtils,ShellAPI,Windows,Messages;

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

function ExecuteFile(const FileName,Params,DefaultDir:string;ShowCmd:Integer):THandle;
var zFileName,zParams,zDir:array[0..79] of Char;
begin
 Result:=ShellExecute(0,nil,StrPCopy(zFileName,FileName),
  StrPCopy(zParams,Params),StrPCopy(zDir,DefaultDir),ShowCmd);
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

Function RegisterDelphiHotkey(Handle,Id:integer;Hotkey:word):boolean;
var Flag:word;
begin
 Flag:=0;
 if Hotkey and $2000<>0 then Flag:=Flag or MOD_SHIFT;
 if Hotkey and $4000<>0 then Flag:=Flag or MOD_CONTROL;
 if Hotkey and $8000<>0 then Flag:=Flag or MOD_ALT;
 Result:=RegisterHotkey(Handle,Id,Flag,Hotkey and $FF);
end;

Function ExtractDescr(P:PChar):string;
var I:integer;
begin
 I:=0;Result:='';
 while(Length(Result)<DescrLen)and(P[I]<>#0)do begin
  if P[I] in ['A'..'Z','a'..'z','0'..'9','А'..'Я','а'..'я',' ',':',',','.',' '] then Result:=Result+P[I];
  Inc(I);
 end;
end;

Constructor TClip.Create;
begin inherited Create;Static:=true;FData:=nil;end;

Constructor TClip.Create(Clip:TClip);
begin inherited Create;Static:=Clip.Static;Data:=Clip.Data;end;

Constructor TClip.Create(Handle:integer);
var Data:cardinal;
    P:PChar;
    Sz:integer;
begin
 if OpenClipboard(Handle) then begin
  Data:=GetClipboardData(CF_TEXT);
  if Data=0 then begin
   CloseClipboard;
   raise Exception.Create('Clipboard empty');
  end;
  P:=GlobalLock(Data);
  Sz:=GlobalSize(Data);
  if Sz>65519 then Sz:=65519;
  GetMem(FData,Sz+1);
  MoveMemory(FData,P,Sz);
  FData[Sz]:=#0;
  GlobalUnlock(Data);
  CloseClipboard;
 end;
 Static:=false;
end;

Procedure TClip.Free;
begin
 if FData<>nil then FreeMem(FData,lstrlen(FData)+1);
end;

Constructor TBiniFile.Create(FileName:string;aMode:TBinMode=ModeRead);
begin
 inherited Create(FileName);
 BinMode:=ModeNo;
 ResetBinary(aMode);
end;

Function TClip.GetData:string;
begin Result:=StrPas(FData);end;

Procedure TClip.SetData(Value:string);
begin
 Free;
 GetMem(FData,Length(Value)+1);
 StrPCopy(FData,Value);
end;

Procedure TBiniFile.ResetBinary(NewMode:TBinMode=ModeWrite);
begin
 if BinMode<>ModeNo then CloseHandle(BinFile);
 if(NewMode=ModeWrite)and(NewMode<>BinMode)then begin
  BinFile:=CreateFile(PChar(ChangeFileExt(FileName,'.dat')),GENERIC_WRITE,0,nil,
   CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE or FILE_ATTRIBUTE_HIDDEN or FILE_FLAG_SEQUENTIAL_SCAN,0);
  if BinFile<>-1 then BinMode:=ModeWrite else BinMode:=ModeNo;
 end else
 if(NewMode=ModeRead)and(NewMode<>BinMode)then begin
  BinFile:=CreateFile(PChar(ChangeFileExt(FileName,'.dat')),GENERIC_READ,0,nil,
   OPEN_EXISTING,FILE_ATTRIBUTE_ARCHIVE or FILE_ATTRIBUTE_HIDDEN or FILE_FLAG_SEQUENTIAL_SCAN,0);
  if BinFile<>-1 then BinMode:=ModeRead else BinMode:=ModeNo;
 end;
end;

Function TBIniFile.ReadBlob(Section,Key:string):integer;
var S:string;
    B:string[10];
    I1,I2,I,Mode:cardinal;
    P:pointer;
begin
 Result:=0;
 if BinMode=ModeRead then begin
  I1:=0;I2:=0;Mode:=0;B:='';
  S:=ReadString(Section,Key,'BLOB(0,0)');
  For I:=1 to Length(S) do case Mode of
   0:case Upcase(S[I])of
     'A'..'Z':B:=B+Upcase(S[I]);
     '(':if B='BLOB' then Mode:=1 else exit;
     else exit;
    end;
   1:case S[I] of
     '0'..'9':I1:=I1*10+ord(S[I])-ord('0');
     ',':Mode:=2;
     else exit;
    end;
   2:case S[I] of
    '0'..'9':I2:=I2*10+ord(S[I])-ord('0');
    ')':Mode:=3;
    else exit;
   end;
  end;
  if I2=0 then exit; // неча читать
  Result:=GlobalAlloc(GHND,I2);
  SetFilePointer(BinFile,I1,nil,FILE_BEGIN);
  P:=GlobalLock(Result);
  ReadFile(BinFile,P^,I2,I1,nil);
  GlobalUnlock(Result);
 end;
end;

Function TBIniFile.ReadPChar(Section,Key:string):PChar;
var S:string;
    B:string[10];
    I1,I2,I,Mode:cardinal;
begin
 Result:=nil;
 if BinMode=ModeRead then begin
  I1:=0;I2:=0;Mode:=0;B:='';
  S:=ReadString(Section,Key,'PCHAR(0,0)');
  For I:=1 to Length(S) do case Mode of
   0:case Upcase(S[I])of
     'A'..'Z':B:=B+Upcase(S[I]);
     '(':if B='PCHAR' then Mode:=1 else exit;
     else exit;
    end;
   1:case S[I] of
     '0'..'9':I1:=I1*10+ord(S[I])-ord('0');
     ',':Mode:=2;
     else exit;
    end;
   2:case S[I] of
    '0'..'9':I2:=I2*10+ord(S[I])-ord('0');
    ')':Mode:=3;
    else exit;
   end;
  end;
  if I2=0 then exit; // неча читать
  GetMem(Result,I2+1);
  SetFilePointer(BinFile,I1,nil,FILE_BEGIN);
  ReadFile(BinFile,Result^,I2,I,nil);
  Result[I2]:=#0; // finalyzing zero
 end;
end;

Procedure TBiniFile.WriteBlob(Section,Key:string;Blob:integer);
var P:pointer;
    I:cardinal;
    Size:integer;
begin
 if BinMode=ModeWrite then begin
  Size:=GetFileSize(BinFile,nil);
  WriteString(Section,Key,Format('BLOB(%d,%d)',[Size,GlobalSize(Blob)]));
  P:=GlobalLock(Blob);
  WriteFile(BinFile,P^,GlobalSize(Blob),I,nil);
  GlobalUnlock(Blob);
 end;
end;

Procedure TBIniFile.WritePChar(Section,Key:string;P:PChar);
var I:cardinal;
    Size:integer;
begin
 if BinMode=ModeWrite then begin
  Size:=GetFileSize(BinFile,nil);
  WriteString(Section,Key,Format('PCHAR(%d,%d)',[Size,lstrlen(P)]));
  WriteFile(BinFile,P^,lstrlen(P),I,nil);
 end;
end;

Function TBiniFile.ReadBoolean(const Section,Ident:string;Default:Boolean):boolean;
var S:string[10];
begin
 if Default then S:='True' else S:='False';
 S:=ReadString(Section,Ident,S);
 Result:=AnsiUpperCase(S)=AnsiUpperCase('TRUE');
end;

Procedure TBiniFile.WriteBoolean(const Section,Ident:string;Value:Boolean);
begin
 if Value then WriteString(Section,Ident,'True')
 else WriteString(Section,Ident,'False');
end;

Procedure TBiniFile.Free;
begin
 if BinMode<>ModeNo then CloseHandle(BinFile)
 else DeleteFile(PChar(ChangeFileExt(FileName,'.dat')));
 inherited;
end;

Function UpLet(Down:char):char;
Const
 RusFirstLit:set of byte=[160..175];
 RusSecLit:set of byte=[224..239];
var I:byte;
begin
 I:=Ord(Down);
 if (I in RusFirstLit)then UpLet:=Chr(I-32)
  else if (I in RusSecLit)then UpLet:=Chr(I-80)
   else UpLet:=UpCase(Down);
end;

Procedure SendKey(Key:char);
var Sk:word;
    I:word;
    Tr:boolean;
begin
 Tr:=Key in ['А'..'Я','а'..'я'];
 if Tr then
  For I:=1 to Length(SRus) do if Key=SRus[I] then begin Key:=SLat[I];break;end;
 if Tr then SetKbdLayoutWnd($04190419) else SetKbdLayoutWnd($04090409);
 Sk:=VkKeyScan(Key);
 if Sk and $FF=$FF then exit;
 if Sk and $100<>0 then begin keybd_event(VK_SHIFT,0,0,0);Sleep(1);end else keybd_event(VK_SHIFT,0,KEYEVENTF_KEYUP,0);
 if Sk and $200<>0 then begin keybd_event(VK_CONTROL,0,0,0);Sleep(1);end else keybd_event(VK_CONTROL,0,KEYEVENTF_KEYUP,0);
 if Sk and $400<>0 then begin keybd_event(VK_MENU,0,0,0);Sleep(1);end else keybd_event(VK_MENU,0,KEYEVENTF_KEYUP,0);
 if Sk and $FF<>$FF then begin keybd_event(Sk and $FF,0,0,0);Sleep(1);end;
 if Sk and $FF<>$FF then begin keybd_event(Sk and $FF,0,KEYEVENTF_KEYUP,0);Sleep(1);end;
 if Sk and $100<>0 then begin keybd_event(VK_SHIFT,0,KEYEVENTF_KEYUP,0);Sleep(1);end;
 if Sk and $200<>0 then begin keybd_event(VK_CONTROL,0,KEYEVENTF_KEYUP,0);Sleep(1);end;
 if Sk and $400<>0 then begin keybd_event(VK_MENU,0,KEYEVENTF_KEYUP,0);Sleep(1);end;
end;

function GetActiveKbdLayout:cardinal;
begin Result:=GetKeyboardLayout(0) shr 16;end;

function GetActiveKbdLayoutWnd:cardinal;
begin
 Result:=GetKeyboardLayout(GetWindowThreadProcessId(GetForegroundWindow,nil)) shr 16;
end;

procedure SetKbdLayout(kbLayout:cardinal);
begin
 ActivateKeyboardLayout(kbLayout,KLF_ACTIVATE);
end;

procedure SetKbdLayoutWnd(kbLayout:cardinal);
begin
 SendMessage(GetForegroundWindow,WM_INPUTLANGCHANGEREQUEST,1,kbLayout);
// SendMessage(GetForegroundWindow,WM_INPUTLANGCHANGE,0,kbLayout and $FFFF);
end;

Procedure Wait(msec:cardinal;Handle:integer);
var OldTicks:cardinal;
    Msg:tagMSG;
begin
 OldTicks:=GetTickCount;
 while OldTicks+msec>GetTickCount do begin
  if(Handle<>-1)and(PeekMessage(Msg,Handle,0,0,PM_REMOVE))then begin
   TranslateMessage(Msg);
   DispatchMessage(Msg);
  end;
  Sleep(0);
 end;
end;

procedure PureClip;
var Data,NewSize,NewData,CodePage:integer;
    DataPtr,NewPtr:pchar;
begin
 CodePage:=$419;
 if OpenClipboard(GetForegroundWindow) then begin // монопольно пользовать буфер
  Data:=GetClipboardData(CF_TEXT); // сохранить прежние текстовые данные
  if Data=0 then begin CloseClipboard;exit;end;
  NewSize:=GlobalSize(Data);
  DataPtr:=GlobalLock(Data);
  NewData:=GlobalAlloc(GMEM_MOVEABLE+GMEM_DDESHARE,NewSize);
  NewPtr:=GlobalLock(NewData);
  MoveMemory(NewPtr,DataPtr,NewSize);
  EmptyClipboard; // убить буфер
  Data:=GlobalAlloc(GMEM_MOVEABLE+GMEM_DDESHARE,4);  // Назначить кодовую страницу для буфера обмена
  DataPtr:=GlobalLock(Data);
  MoveMemory(DataPtr,@CodePage,4);
  GlobalUnlock(Data);
  SetClipboardData(CF_LOCALE,Data);
  GlobalUnlock(NewData);
  SetClipboardData(CF_TEXT,NewData); // вернуть новые данные для буфера обмена
  CloseClipboard; // закрыть буфер
  if PasteOnPureclip then begin // вставить, если необходимо
   Wait(DelayCopy,GetForegroundWindow);
   SendHotkey(HotPaste);
   Wait(1,GetForegroundWindow);
  end;
 end;
end;

Procedure Convert(Line:string);
var S,S1,S2:string;
    Mode1,Mode2:string[5];
    P,Ptr:PChar;
    Versa,Auto:boolean;
    Data,Data2,I,J,K,CodePage:integer;
begin
 Versa:=true;Auto:=true;Mode1:='';Mode2:='';
 while(Line<>'')do begin
  S:=GetNext(Line);
  if(CompareText(S,'/norev')=0)then Versa:=false
  else if(CompareText(S,'/noauto')=0)then Auto:=false
  else if Mode1='' then Mode1:=AnsiUppercase(S)
  else if Mode2='' then Mode2:=AnsiUpperCase(S);
 end;
 if Auto then begin
  if OpenClipboard(GetForegroundWindow) then begin
   EmptyClipboard; // убить буфер
   CloseClipboard;
  end else raise Exception.Create('Clipboard open error');
  Wait(DelayCopy,GetForegroundWindow);
  SendHotkey(HotCopy);
  Wait(1,GetForegroundWindow);
 end;
 CodePage:=$419;
 if(Mode1='')or(Mode2='') then begin // automatic conversion
  GetMem(P,16);
  GetKeyboardLayoutName(P);
  if lstrcmp(P,'00000419')=0 then begin // здесь есть какой-то баг, не позволяющий правильно работать, но какой, я еще не понял, но исправить надо!!!
   Mode1:='RUS';Mode2:='LAT';
   SetKbdLayoutWnd($4090409);
  end else begin
   Mode1:='LAT';Mode2:='RUS';
   SetKbdLayoutWnd($4190419);
  end;
  FreeMem(P,16);
 end;
 S1:=Ini.ReadString('Convert',Mode1,'');
 S2:=Ini.ReadString('Convert',Mode2,'');
 if(S1='')or(S2='')or(Length(S1)<>Length(S2))then raise Exception.Create('Wrong mode');
 if OpenClipboard(GetForegroundWindow) then begin
  Data:=GetClipboardData(CF_TEXT); // сохранить прежние текстовые данные
  if Data=0 then begin CloseClipboard;raise Exception.Create('Nothing to do');end;
  Ptr:=GlobalLock(Data);
  Data2:=GlobalAlloc(GHND or GMEM_DDESHARE,GlobalSize(Data));
  P:=GlobalLock(Data2);
  MoveMemory(P,Ptr,GlobalSize(Data));
  // собственно алгоритм преобразования
  For I:=0 to GlobalSize(Data)-1 do begin
   K:=0;
   For J:=1 to Length(S1) do if S1[J]=Ptr[I] then K:=J;
   if K<>0 then P[I]:=S2[K]
   else if Versa then begin
    For J:=1 to Length(S2) do if S2[J]=Ptr[I] then K:=J;
    if K<>0 then P[I]:=S1[K] else P[I]:=Ptr[I];
   end else P[I]:=Ptr[I]
  end;
  // конец алгоритма преобразования
  GlobalUnlock(Data);
  GlobalUnlock(Data2);
  EmptyClipboard; // убить буфер
  SetClipboardData(CF_TEXT,Data2);
  Data2:=GlobalAlloc(GMEM_MOVEABLE+GMEM_DDESHARE,4);
  P:=GlobalLock(Data2);
  MoveMemory(P,@CodePage,4);
  GlobalUnlock(Data2);
  SetClipboardData(CF_LOCALE,Data2);
  CloseClipboard;
  if Auto then begin // вставить, если необходимо
   Wait(DelayCopy,GetForegroundWindow);
   SendHotkey(HotPaste);
   Wait(1,GetForegroundWindow);
  end;
 end else raise Exception.Create('Clipboard unavailable');
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

Procedure SendHotkey(Hotkey:word);
var Flag:integer;
begin
 if Hotkey and $2000<>0 then keybd_event(VK_SHIFT,0,0,0) else keybd_event(VK_SHIFT,0,KEYEVENTF_KEYUP,0);Sleep(1);
 if Hotkey and $4000<>0 then keybd_event(VK_CONTROL,0,0,0) else keybd_event(VK_CONTROL,0,KEYEVENTF_KEYUP,0);Sleep(1);
 if Hotkey and $8000<>0 then keybd_event(VK_MENU,0,0,0) else keybd_event(VK_MENU,0,KEYEVENTF_KEYUP,0);Sleep(1);
 if Hotkey and $FF in [$21..$28,$2D] then Flag:=KEYEVENTF_EXTENDEDKEY else Flag:=0;
 keybd_event(Hotkey and $FF,0,Flag,0);Sleep(1);
 keybd_event(Hotkey and $FF,0,KEYEVENTF_KEYUP or Flag,0);Sleep(1);
 if Hotkey and $2000<>0 then keybd_event(VK_SHIFT,0,KEYEVENTF_KEYUP,0);Sleep(1);
 if Hotkey and $4000<>0 then keybd_event(VK_CONTROL,0,KEYEVENTF_KEYUP,0);Sleep(1);
 if Hotkey and $8000<>0 then keybd_event(VK_MENU,0,KEYEVENTF_KEYUP,0);Sleep(1);
end;

Procedure Translit(Line:string);
Function MyCompare(Line:PChar;Ind,Sz:cardinal;Line2:string):boolean;
var I1,I2:byte;
begin
 I1:=Ind;I2:=1;Result:=false;
 while(I1<=Sz)and(I2<=Length(Line2))do begin
  if Line[I1]<>Line2[I2] then exit; // символы не совпадают
  Inc(I1);Inc(I2);
 end;
 Result:=I2>=Length(Line2);
end;
procedure AppendString(P:PChar;var Ind:integer;S:string);
var J:integer;
begin
 For J:=1 to Length(S) do P[Ind+J-1]:=S[J];Inc(Ind,Length(S));
end;
var Data,Data2:cardinal;
    P,P2:PChar;
    Strs:TStringList;
    I,GlSz,Sz2:integer;
    J,Srcs:word;
    Src,Dst:array[0..199]of string[10];
    X:string[20];
    ConvMode:byte;
    Versa,Auto:boolean;
begin
 Versa:=false;Auto:=true;
 while(Line<>'')do begin
  X:=GetNext(Line);
  if(CompareText(X,'/rev')=0)then Versa:=true
  else if(CompareText(X,'/noauto')=0)then Auto:=false;
 end;
 if Auto then begin
  if OpenClipboard(GetForegroundWindow) then begin
   EmptyClipboard; // убить буфер
   CloseClipboard;
  end else raise Exception.Create('Clipboard open error');
  Wait(DelayCopy,GetForegroundWindow);
  SendHotkey(HotCopy);
  Wait(1,GetForegroundWindow);
 end;
 Strs:=TStringList.Create;
 Ini.ReadSectionValues('Translit',Strs);
 FillChar(Src,sizeof(Src),0);
 FillChar(Dst,sizeof(Dst),0);
 Srcs:=0;
 For I:=0 to Strs.Count-1 do begin
  X:=Strs.Strings[I];
  J:=Pos('=',X);if J=0 then continue;
  Delete(X,1,J);J:=Pos(' ',X);
  Src[Srcs]:=Copy(X,1,J-1);Dst[Srcs]:=Copy(X,J+1,5);
  inc(Srcs);
 end;
 Strs.Free;
 if Srcs=0 then exit;dec(Srcs);
 if OpenClipboard(GetForegroundWindow) then begin
  Data:=GetClipboardData(CF_TEXT);
  P:=GlobalLock(Data);
  GlSz:=GlobalSize(Data)-1;Sz2:=0;ConvMode:=0;
  I:=0;While I<GlSz do begin
   case ConvMode of
    0:begin // пока еще направление неизвестно
     For J:=0 to Srcs do if MyCompare(P,I,GlSz,Src[J]) then break;
     if J>Srcs then begin
      For J:=0 to Srcs do if MyCompare(P,I,GlSz,Dst[J]) then break;
      if J<=Srcs then begin if not Versa then ConvMode:=2;Inc(I,Length(Dst[J]));Inc(Sz2,Length(Src[J]));end
      else begin Inc(I);Inc(Sz2);end; // символ представляет сам себя
     end else begin if not Versa then ConvMode:=1;Inc(I,Length(Src[J]));Inc(Sz2,Length(Dst[J]));end;
    end;
    1:begin // преобразование от Src к Dst
     For J:=0 to Srcs do if MyCompare(P,I,GlSz,Src[J]) then break;
     if J<=Srcs then begin Inc(I,Length(Src[J]));Inc(Sz2,Length(Dst[J]));end
     else begin Inc(I);Inc(Sz2);end;
    end;
    2:begin // преобразование от Dst к Src
     For J:=0 to Srcs do if MyCompare(P,I,GlSz,Dst[J]) then break;
     if J<Srcs then begin Inc(I,Length(Dst[J]));Inc(Sz2,Length(Src[J]));end
     else begin Inc(I);Inc(Sz2);end;
    end;
    else Inc(I); // другое преобразование не проводится
   end;
  end;
  Data2:=GlobalAlloc(GHND or GMEM_SHARE,Sz2+1);
  P2:=GlobalLock(Data2);
  I:=0;Sz2:=0;while I<GlSz do case ConvMode of
   0:begin // значит, либо вообще нечего преобразовывать (но зачем тогда запускать команду?), либо стоит Versa
    For J:=0 to Srcs do if MyCompare(P,I,GlSz,Src[J]) then break;
    if J<Srcs then begin Inc(I,Length(Src[J]));AppendString(P2,Sz2,Dst[J]);end
    else begin // обратное преобразование
     For J:=0 to Srcs do if MyCompare(P,I,GlSz,Dst[J]) then break;
     if J<Srcs then begin Inc(I,Length(Dst[J]));AppendString(P2,Sz2,Src[J]);end
     else begin P2[Sz2]:=P[I];Inc(Sz2);Inc(I);end;
    end;
   end;
   1:begin
    For J:=0 to Srcs do if MyCompare(P,I,GlSz,Src[J]) then break;
    if J<Srcs then begin Inc(I,Length(Src[J]));AppendString(P2,Sz2,Dst[J]);end
    else begin P2[Sz2]:=P[I];Inc(Sz2);Inc(I);end;
   end;
   2:begin
    For J:=0 to Srcs do if MyCompare(P,I,GlSz,Dst[J]) then break;
    if J<Srcs then begin Inc(I,Length(Dst[J]));AppendString(P2,Sz2,Src[J]);end
    else begin P2[Sz2]:=P[I];Inc(Sz2);Inc(I);end;
   end;
   else Inc(I);
  end;
  GlobalUnlock(Data2);
  GlobalUnlock(Data);
  EmptyClipboard;
  SetClipboardData(CF_TEXT,Data2); // вернуть новые данные для буфера обмена
  Data:=GlobalAlloc(GMEM_MOVEABLE+GMEM_DDESHARE,4);  // Назначить кодовую страницу для буфера обмена
  P:=GlobalLock(Data);
  I:=$419;
  MoveMemory(P,@I,4);
  GlobalUnlock(Data);
  SetClipboardData(CF_LOCALE,Data);
  CloseClipboard;
  if Auto then begin // вставить, если необходимо
   Wait(DelayCopy,GetForegroundWindow);
   SendHotkey(HotPaste);
   Wait(1,GetForegroundWindow);
  end;
 end;
end;

var P:PChar;
initialization
 GetMem(P,512);
 GetModuleFileName(hInstance,P,512);
 Ini:=TBiniFile.Create(ChangeFileExt(StrPas(P),'.ini'));
 FreeMem(P,512);
 DescrLen:=Ini.ReadInteger(MainGroup,'DescrLen',15);
 MaxDynamic:=Ini.ReadInteger(MainGroup,'MaxDynamic',10);
 PasteMode:=Ini.ReadInteger(MainGroup,'PasteMode',0);
 PasteOnPureClip:=Ini.ReadBoolean(MainGroup,'PasteOnPureclip',false);
 DisappearDelay:=Ini.ReadInteger(MainGroup,'DisappearDelay',2500);
 HotCopy:=Ini.ReadInteger(MainGroup,'HotCopy',VK_INSERT or $4000);
 HotPaste:=Ini.ReadInteger(MainGroup,'HotPaste',VK_INSERT or $2000);
 DelayCopy:=Ini.ReadInteger(MainGroup,'DelayCopy',150);
 DelayPaste:=Ini.ReadInteger(MainGroup,'DelayPaste',150);
 DelayPrint:=Ini.ReadInteger(MainGroup,'DelayPrint',10);
 AutoPureClip:=Ini.ReadBoolean(MainGroup,'AutoPureclip',false);
 SRus:=Ini.ReadString('Convert','RUS','');
 SLat:=Ini.ReadString('Convert','LAT','');
 ClipEditorPresent:=false;OptionPresent:=false;WinPresent:=false;
finalization
 Ini.WriteInteger(MainGroup,'DescrLen',DescrLen);
 Ini.WriteInteger(MainGroup,'MaxDynamic',MaxDynamic);
 Ini.WriteInteger(MainGroup,'PasteMode',PasteMode);
 Ini.WriteBoolean(MainGroup,'PasteOnPureclip',PasteOnPureClip);
 Ini.WriteInteger(MainGroup,'DisappearDelay',DisappearDelay);
 Ini.WriteInteger(MainGroup,'HotCopy',HotCopy);
 Ini.WriteInteger(MainGroup,'HotPaste',HotPaste);
 Ini.WriteInteger(MainGroup,'DelayCopy',DelayCopy);
 Ini.WriteInteger(MainGroup,'DelayPaste',DelayPaste);
 Ini.WriteInteger(MainGroup,'DelayPrint',DelayPrint);
 Ini.WriteBoolean(MainGroup,'AutoPureclip',AutoPureClip);
 Ini.Free;
end.
