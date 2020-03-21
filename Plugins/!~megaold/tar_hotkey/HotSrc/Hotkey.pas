unit Hotkey;

interface

Uses Windows,Classes,Messages,IniFiles;

Const LCtrl=0;RCtrl=1;
      LShift=2;RShift=3;
      LAlt=4;RAlt=5;
      LWin=6;RWin=7;
      Menu=8;
      MaxScan=111;

Type SpecKeys=0..MaxScan;

Const SpecScan:array[SpecKeys]of word=(
       $1D,$11D,$2A,$36,$38,$138,$15B,$15C,$15D, {menu}
       $29,$2,$3,$4,$5,$6,$7,$8,$9,$A,$B,$C,$D,$2B,
       $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,
       $1E,$1F,$20,$21,$22,$23,$24,$25,$26,$27,$28,
       $2C,$2D,$2E,$2F,$30,$31,$32,$33,$34,$35,
       $3B,$3C,$3D,$3E,$3F,$40,$41,$42,$43,$44,$1057,$1058,
       $152,$147,$149,$153,$14F,$151,
       $148,$14B,$150,$14D,
       $4F,$50,$51,$4B,$4C,$4D,$47,$48,$49,$52,
       $53,$4E,$4A,$37,$135,
       $130,$12E,$120,$110,$122,$124,$119,$16D,$121,$16B,
       $168,$167,$165,$166,$16A,$169,$132,$16C,$1);
      SpecName:array[SpecKeys]of string[10]=(
       'LCtrl','RCtrl','LShift','RShift','LAlt','RAlt','LWin','RWin','Menu',
       '`','1','2','3','4','5','6','7','8','9','0','-','=','\',
       'Q','W','E','R','T','Y','U','I','O','P','[',']',
       'A','S','D','F','G','H','J','K','L',';','''',
       'Z','X','C','V','B','N','M',',','.','/',
       'F1','F2','F3','F4','F5','F6','F7','F8','F9','F10','F11','F12',
       'Ins','Home','PgUp','Del','End','PgDn',
       'UArrow','LArrow','DArrow','RArrow',
       'Gr1','Gr2','Gr3','Gr4','Gr5','Gr6','Gr7','Gr8','Gr9','Gr0',
       'Gr.','Gr+','Gr-','Gr*','Gr/',
       'Vol+','Vol-','VolMute','Prev','Pause','Stop','Next','Media','Calc','MyComp',
       'Halt','Refresh','Search','Favourites','Back','Forward','Home','EMail','Esc');
      WM_KeyGet=WM_USER+17;
      Max=200;
      ClsName='TKeyReceiver';
      HotSection='Hotkeys';
      Language='Language';

Type TKeyboard=class(TObject)
      Status:array[1..$1FF]of boolean;
      Count:word;
      Constructor Create;  // инициирует массив
      Procedure Clear;
      Function GetKey(Code:integer):boolean;
     end;

     TMyHotkey=class(TObject) // горячий ключ
      Name:string;
      Codes:array[1..5]of word;
      Ctrl,Shift,Alt,Win:boolean;
      Kind:byte;
      Line:string;
      Count:byte;
      Count2:byte;
      Constructor Create(S:string);
      Constructor Copy(H:TMyHotkey);
      Function Check:boolean;
      Procedure Run;
      Function Get:string;
     end;

     TKeyWin = class(TThread) // обеспечивает работу с фоновым невидимым окном,
      // отлавливающим горячие клавиши. Окно создается средствами API и занимает
      // очень мало места.
       Hnd:integer;
       Constructor Create; // создать невидимое окно
       Procedure Free; // удалить невидимое окно
       Procedure ReadHotkeys; // прочитать файл конфигурации
       Procedure WriteHotkeys; // записать данные в файл конфигурации
      protected
       procedure Execute; override;// обеспечение цикла сообщений невидимого окна
     end;

function ExecuteFile(const FileName,Params,DefaultDir:string;ShowCmd:Integer):integer;
 // копия из FMXUtils - чтобы не таскать с собой лишний модуль
procedure DrawOSD(S:string);
 // рисует на фиксированном месте указанное сообщение. Задерживает выполнение программы на 1 сек.
Function Replace(const S:string;const Src,Dst:string):string;
 // заменяет все вхождения строки Src на Dst в строке S и возвращает результат

var TarHandle:integer;
    HotCount:integer;
    Hotkeys:array[1..Max]of TMyHotkey;
    Keyboard:TKeyboard;
    Ini:TIniFile;
    DllHandle:integer;
    SetHook:Function(Active:DWORD;KG:DWORD):DWORD;stdcall;
    Ability:word;
    LastTime:integer;

implementation

Uses SysUtils,ShellAPI;

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

procedure DrawOSD(S:string);
var DC,Font:integer;
    LogFont:TLogFont;
    Size:TSize;
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
 SetTextColor(DC,$55CC99);
 SetBkMode(DC,OPAQUE);
 SetBkColor(DC,$550055);
 GetTextExtentPoint32(DC,@S[1],Length(S),Size);
 TextOut(DC,(GetSystemMetrics(SM_CXSCREEN)-Size.cx)shr 1,3*GetSystemMetrics(SM_CYSCREEN) shr 2-Size.cy shr 1,@S[1],Length(S));
 DeleteObject(Font);
 ReleaseDC(0,DC);
end;

function ExecuteFile(const FileName,Params,DefaultDir:string;ShowCmd:Integer):integer;
var zFileName,zParams,zDir:array[0..79]of Char;
begin
 Result:=ShellExecute(0,nil,StrPCopy(zFileName,FileName),StrPCopy(zParams,Params),
  StrPCopy(zDir,DefaultDir),ShowCmd);
end;

function KeyWinProc(hWnd,uMsg,wParam,lParam:integer):integer;stdcall;
var I:word;
begin
 if(uMsg=WM_HOTKEY)and(wParam=1)then begin
  Keyboard.Clear;
  Result:=0;
 end else if(uMsg=WM_KeyGet)and(Keyboard.GetKey(lParam))then begin
  Result:=0;
//  DrawOSD(Inttostr(Keyboard.Count));
  if(LastTime+Ability<GetTickCount)and((lParam and $C000)=0)then begin
   LastTime:=GetTickCount;
   For I:=1 to HotCount do
    if Hotkeys[I].Check then begin
     Hotkeys[I].Run;
     Result:=1;
     break;
    end;
  end;
 end else Result:=DefWindowProc(hWnd,uMsg,wParam,lParam);
end;

procedure SendText(WinHandle:HWND;txtText: string);
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

Constructor TKeyboard.Create;
begin
 inherited Create;
 Clear;
end;

Procedure TKeyboard.Clear;
begin
 FillChar(Status,sizeof(Status),0);
 Count:=0;
end;

Function TKeyboard.GetKey(Code:integer):boolean;
begin
 Result:=Status[Code and $1FF] xor((Code and $C000)=0);
 if Result then begin
  Status[Code and $1FF]:=(Code and $C000)=0;
  if (Code and $C000)=0 then Inc(Count) else
   if Count>0 then Dec(Count);
 end;
end;

Constructor TMyHotkey.Create(S:string);
 function GetNext(var X:string):string;
 var I:integer;
 begin
  I:=pos(' ',X);
  if I=0 then I:=succ(Length(X));
  Result:=trim(system.copy(X,1,I-1));
  Delete(X,1,I);
 end;
var Temp:string[64];
    E:integer;
    SC:SpecKeys;
begin
 inherited Create;
 FillChar(Codes,sizeof(Codes),0);Count2:=0;
 Ctrl:=false;Win:=false;Alt:=false;Shift:=false;
 Kind:=1;Line:='';Count:=1;Name:='New_hotkey';
 while Length(S)>0 do begin Temp:=GetNext(S);
  if(CompareText(Temp,'Ctrl')=0)and(not Ctrl)then begin Ctrl:=true;Inc(Count2);end
  else if(CompareText(Temp,'Shift')=0)and(not Shift)then begin Shift:=true;Inc(Count2);end
  else if(CompareText(Temp,'Alt')=0)and(not Alt)then begin Alt:=true;Inc(Count2);end
  else if(CompareText(Temp,'Win')=0)and(not Win)then begin Win:=true;Inc(Count2);end
  else if CompareText(Temp,'/run')=0 then begin Kind:=0;Line:=trim(S);S:='';end
  else if CompareText(Temp,'/tar')=0 then begin Kind:=1;Line:=trim(S);S:='';end
  else if Temp[1]='$' then begin  // обнаружен код символа
   Delete(Temp,1,1);
   Codes[Count]:=0;
   For E:=1 to Length(Temp) do case Temp[E] of
    '0'..'9':Codes[Count]:=16*Codes[Count]+ord(Temp[E])-ord('0');
    'a'..'f':Codes[Count]:=16*Codes[Count]+ord(Temp[E])-ord('a')+10;
    'A'..'F':Codes[Count]:=16*Codes[Count]+ord(Temp[E])-ord('A')+10;
    else begin Codes[Count]:=0;break;end; // error during conversion
   end;
   if Codes[Count]<>0 then inc(Count);
  end else For SC:=Low(SpecKeys) to High(SpecKeys) do if CompareText(Temp,SpecName[SC])=0 then
   begin Codes[Count]:=SpecScan[SC];Inc(Count);break;end;
 end;
 Dec(Count);
end;

Constructor TMyHotkey.Copy(H:TMyHotkey);
begin
 Codes:=H.Codes;Kind:=H.Kind;Line:=H.Line;
 Ctrl:=H.Ctrl;Alt:=H.Alt;Shift:=H.Shift;Win:=H.Win;
 Name:=H.Name;Count:=H.Count;Count2:=H.Count2;
end;

Function TMyHotkey.Check:boolean;
var I:integer;
begin
 Result:=(Count<>0)and(Keyboard.Count=Count+Count2);
 if Result then For I:=1 to 5 do if(Codes[I]<>0)and(Result)and(not Keyboard.Status[Codes[I]])then Result:=false;
 if Result then if(Ctrl xor (Keyboard.Status[SpecScan[LCtrl]]or Keyboard.Status[SpecScan[RCtrl]]))then Result:=false;
 if Result then if(Alt xor (Keyboard.Status[SpecScan[LAlt]]or Keyboard.Status[SpecScan[RAlt]]))then Result:=false;
 if Result then if(Shift xor (Keyboard.Status[SpecScan[LShift]]or Keyboard.Status[SpecScan[RShift]]))then Result:=false;
 if Result then if(Win xor (Keyboard.Status[SpecScan[LWin]]or Keyboard.Status[SpecScan[RWin]]))then Result:=false;
end;

Procedure TMyHotkey.Run;
var Mode:byte;
    I,I1,I2,I3:integer;
begin
 case Kind of
  0:begin Mode:=0;I1:=1;I2:=Length(Line);I3:=Length(Line)+1;
   For I:=1 to Length(Line) do case Line[I] of
    '"':case Mode of
     0:begin I1:=I+1;Mode:=1;end;
     1:begin I2:=I-1;I3:=I+2;break;end;
    end;
    ' ':case Mode of
     2:begin I2:=I-1;I3:=I+1;break;end;
    end;
    else case Mode of
     0:begin I1:=I;Mode:=2;end;
    end;
   end;
   ExecuteFile(system.copy(Line,I1,I2-I1+1),system.copy(Line,I3,Length(Line)-I3+1),'',SW_SHOW);
  end;
  1:SendText(TarHandle,Line);
 end;
end;

function TMyHotkey.Get:string;
var Sc:SpecKeys;
    P:byte;
    Code:word;
    S:string[10];
begin
 Result:='';
 if Ctrl then Result:=Result+'Ctrl ';
 if Shift then Result:=Result+'Shift ';
 if Alt then Result:=Result+'Alt ';
 if Win then Result:=Result+'Win ';
 For P:=1 to 5 do if Codes[P]<>0 then begin
  Code:=Codes[P];
  For Sc:=Low(SpecKeys) to High(SpecKeys) do
   if SpecScan[Sc]=Code then begin
    Result:=Result+SpecName[Sc]+' ';
    Code:=0;break;
   end;
  if Code<>0 then begin S:='';
   while Code>0 do begin
    case Code mod 16 of
     0..9:S:=chr(Code mod 16+ord('0'))+S;
     10..15:S:=chr(Code mod 16+ord('A')-10)+S;
    end;
    Code:=Code div 16;
   end;
   Result:=Result+'$'+S+' ';
  end;
 end;
 if Kind=0 then Result:=Result+'/run '+Line
 else Result:=Result+'/tar '+Line;
end;

Constructor TKeyWin.Create;
var WndClass:TWndClass;
begin
 WndClass.style:=CS_CLASSDC;
 WndClass.lpfnWndProc:=@KeyWinProc;
 WndClass.cbClsExtra:=0;
 WndClass.cbWndExtra:=0;
 WndClass.hInstance:=hInstance;
 WndClass.hIcon:=LoadIcon(0,IDI_APPLICATION);
 WndClass.hCursor:=LoadCursor(0,IDC_CROSS);
 WndClass.hbrBackground:=COLOR_WINDOW;
 WndClass.lpszMenuName:=nil;
 WndClass.lpszClassName:=ClsName;
 ReadHotkeys;
 LastTime:=GetTickCount;
 if Windows.RegisterClass(WndClass)=0 then begin Free;Fail;end;
 // failed to register class
 Hnd:=CreateWindowEx(0,ClsName,ClsName,WS_POPUPWINDOW,100,100,100,100,0,0,hInstance,nil);
 if Hnd=0 then begin Free;fail;end;
 // unable to build window
 ShowWindow(Hnd,SW_HIDE);
 RegisterHotKey(Hnd,1,MOD_CONTROL or MOD_ALT or MOD_SHIFT,vk_F12);
 inherited Create(true);
end;

procedure TKeyWin.ReadHotkeys;
var I:integer;
begin
 if Ini<>nil then begin
  For I:=1 to HotCount do Hotkeys[I].Free;
  HotCount:=Ini.ReadInteger(HotSection,'Count',0);
  For I:=1 to HotCount do begin
   Hotkeys[I]:=TMyHotkey.Create(Ini.ReadString(HotSection,'String'+inttostr(I),''));
   Hotkeys[I].Name:=Ini.ReadString(HotSection,'Name'+inttostr(I),'');
  end;
  Ability:=Ini.ReadInteger(HotSection,'Delay',10);
 end;
end;

procedure TKeyWin.WriteHotkeys;
var Num,I:word;
begin
 if Ini<>nil then begin
  Num:=Ini.ReadInteger(HotSection,'Count',0);
  For I:=1 to Num do begin
   Ini.DeleteKey(HotSection,'String'+inttostr(I));
   Ini.DeleteKey(HotSection,'Name'+inttostr(I));
  end;
  Ini.WriteInteger(HotSection,'Count',HotCount);
  For I:=1 to HotCount do begin
   Ini.WriteString(HotSection,'String'+inttostr(I),Hotkeys[I].Get);
   Ini.WriteString(HotSection,'Name'+inttostr(I),Hotkeys[I].Name)
  end;
  Ini.WriteInteger(HotSection,'Delay',Ability);
 end;
end;

procedure TKeyWin.Execute;
var Msg:tagMsg;
begin
 repeat
  if GetMessage(Msg,0,0,0)=false then break;
  DispatchMessage(Msg);
 until Terminated;
end;

Procedure TKeyWin.Free;
var I:word;
begin
 WriteHotkeys;
 For I:=1 to HotCount do if Hotkeys[I]<>nil then begin Hotkeys[I].Free;Hotkeys[I]:=nil;end;
 HotCount:=0;
 UnregisterHotKey(Hnd,1);
 SendMessage(Hnd,WM_CLOSE,0,0);
 Windows.UnregisterClass(ClsName,hInstance);
 inherited Free;
end;

end.
