unit Media;

interface

Uses IniFiles;

Const Language='Language';
      Commands:array[1..15] of string=('~Repeat','~Shuffle','~Volume',
       '~Pos','~List','~Pan','~Play','~Pause','~Stop','~Clear','~Version',
       '~Zoom','~prev','~next','~ampclose');

function PresentWinamp:boolean;
procedure CommandWinamp(Command:string);
function PresentBSP:boolean;
procedure CommandBSP(Command:string);
Function PresentFoo:boolean;
Procedure CommandFoo(S:string);

implementation

Uses Windows,Messages,SysUtils,LangProc;

Const WinAmpClass='Winamp v1.x';

function PresentWinamp:boolean;
begin Result:=findwindow(WinampClass,nil)<>0;end;

procedure CommandWinamp(Command:string);
const WM_WA_IPC=WM_USER;
      IPC_GETVERSION=0;
      IPC_DELETE=101;
      IPC_STARTPLAY=102;
      IPC_ISPLAYING=104;
      IPC_GETOUTPUTTIME=105;
      IPC_JUMPTOTIME=106;
      IPC_SETPLAYLISTPOS=121;
      IPC_GETLISTPOS=125;
      IPC_SETPANNING=123;
      IPC_GETLISTLENGTH=124;
      IPC_GET_SHUFFLE=250;
      IPC_GET_REPEAT=251;
      IPC_SET_SHUFFLE=252;
      IPC_SET_REPEAT=253;
      IPC_SETVOLUME=122;
var hwnd_winamp:integer;
    S:string[50];
    _Quiet:boolean;
    Mode:(ShowInfo,Enable,Disable,Increment,Decrement,Simple);
    Data,Err,Current,CurLen,OldStatus:integer;
procedure UpdateStatus;
begin
 case OldStatus of
  0:SendMessage(hwnd_winamp,WM_COMMAND,40047,0);
  1:SendMessage(hwnd_winamp,WM_COMMAND,40045,0);
  3:begin
   SendMessage(hwnd_winamp,WM_COMMAND,40047,0);
   Sleep(100);
   SendMessage(hwnd_winamp,WM_COMMAND,40045,0);
   Sleep(100);
   SendMessage(hwnd_winamp,WM_COMMAND,40046,0);
  end;
 end;
end;
begin
 hwnd_winamp:=findwindow(WinampClass,nil);
 if hwnd_winamp=0 then Exit;
 S:=GetNext(Command);
 //////// Winamp repeat
 if CompareText(S,Commands[1])=0 then begin
  Mode:=ShowInfo;_Quiet:=true;
  while Command<>'' do begin
   S:=GetNext(Command);
   if CompareText(S,'/q')=0 then _Quiet:=false
   else if S='1' then Mode:=Enable
   else if S='0' then Mode:=Disable;
  end;
  if(Mode=ShowInfo)and(_Quiet)then
   if SendMessage(hwnd_winamp,WM_WA_IPC,0,IPC_GET_REPEAT)=0 then
    MessageBox(0,PChar(Ini.ReadString(Language,'waRepeatOff','Repeat disabled')),
     PChar(Ini.ReadString(Language,'waStatus','Winamp status')),0)
   else
    MessageBox(0,PChar(Ini.ReadString(Language,'waRepeatOn','Repeat enabled')),
    PChar(Ini.ReadString(Language,'waStatus','Winamp status')),0);
  if(Mode=Enable)then begin
   SendMessage(hwnd_winamp,WM_WA_IPC,1,IPC_SET_REPEAT);
   if _Quiet then MessageBox(0,PChar(Ini.ReadString(Language,'waRepeatOn','Repeat enabled')),
    PChar(Ini.ReadString(Language,'waStatus','Winamp status')),0);
  end;
  if(Mode=Disable)then begin
   SendMessage(hwnd_winamp,WM_WA_IPC,0,IPC_SET_REPEAT);
   if _Quiet then MessageBox(0,PChar(Ini.ReadString(Language,'waRepeatOff','Repeat disabled')),
    PChar(Ini.ReadString(Language,'waStatus','Winamp status')),0);
  end;
 ///////// Winamp shuffle
 end else if CompareText(S,Commands[2])=0 then begin
  Mode:=ShowInfo;_Quiet:=true;
  while Command<>'' do begin
   S:=GetNext(Command);
   if CompareText(S,'/q')=0 then _Quiet:=false
   else if S='1' then Mode:=Enable
   else if S='0' then Mode:=Disable;
  end;
  if(Mode=ShowInfo)and(_Quiet)then
   if SendMessage(hwnd_winamp,WM_WA_IPC,0,IPC_GET_SHUFFLE)=0 then
    MessageBox(0,PChar(Ini.ReadString(Language,'waShuffleOff','Repeat disabled')),
     PChar(Ini.ReadString(Language,'waStatus','Winamp status')),0)
   else
    MessageBox(0,PChar(Ini.ReadString(Language,'waShuffleOn','Repeat enabled')),
    PChar(Ini.ReadString(Language,'waStatus','Winamp status')),0);
  if(Mode=Enable)then begin
   SendMessage(hwnd_winamp,WM_WA_IPC,1,IPC_SET_SHUFFLE);
   if _Quiet then MessageBox(0,PChar(Ini.ReadString(Language,'waShuffleOn','Repeat enabled')),
    PChar(Ini.ReadString(Language,'waStatus','Winamp status')),0);
  end;
  if(Mode=Disable)then begin
   SendMessage(hwnd_winamp,WM_WA_IPC,0,IPC_SET_SHUFFLE);
   if _Quiet then MessageBox(0,PChar(Ini.ReadString(Language,'waShuffleOff','Repeat disabled')),
    PChar(Ini.ReadString(Language,'waStatus','Winamp status')),0);
  end;
 /////// winamp volume
 end else if CompareText(S,Commands[3])=0 then begin
  S:=GetNext(Command);
  val(S,Data,Err);
  if S='+' then SendMessage(hwnd_winamp,WM_COMMAND,40058,0)
  else if S='-' then SendMessage(hwnd_winamp,WM_COMMAND,40059,0)
  else if Err=0 then SendMessage(hwnd_winamp,WM_WA_IPC,((Data*255) div 100),IPC_SETVOLUME)
 /////// song position control
 end else if CompareText(S,Commands[4])=0 then begin
  S:=GetNext(Command);val(S,Data,Err);
  Current:=SendMessage(hwnd_winamp,WM_WA_IPC,0,IPC_GETOUTPUTTIME);
  CurLen:=SendMessage(hwnd_winamp,WM_WA_IPC,1,IPC_GETOUTPUTTIME);
  if CurLen=-1 then exit;
  CurLen:=CurLen*1000;
  if(S='')then MessageBox(0,PChar(Ini.ReadString(Language,'waPosition','Current position:')+' '+
   inttostr(Current div 1000)+#13+Ini.ReadString(Language,'waLength','Song duration:')+' '+
   inttostr(CurLen div 1000)),PChar(Ini.ReadString(Language,'waStatus','Winamp status')),0)
  else if(S[1]='+')and(Err=0)then begin
   Inc(Current,Data*1000);
   if Current>CurLen then Current:=CurLen;
   SendMessage(hwnd_winamp,WM_WA_IPC,Current,IPC_JUMPTOTIME);
  end else if(S[1]='-')and(Err=0)then begin
   Inc(Current,Data*1000);
   if Current<0 then Current:=0;
   SendMessage(hwnd_winamp,WM_WA_IPC,Current,IPC_JUMPTOTIME);
  end else if(S[1]='+')and(Err<>0)then SendMessage(hwnd_winamp,WM_COMMAND,40060,0)
  else if(S[1]='-')and(Err<>0)then SendMessage(hwnd_winamp,WM_COMMAND,40061,0)
  else begin
   if Data>CurLen then Data:=CurLen;
   SendMessage(hwnd_winamp,WM_WA_IPC,Data*1000,IPC_JUMPTOTIME);
  end;
 //////// winamp playlist control
 end else if CompareText(S,Commands[5])=0 then begin
  S:=GetNext(Command);val(S,Data,Err);
  Current:=SendMessage(hwnd_winamp,WM_WA_IPC,0,IPC_GETLISTPOS);
  CurLen:=SendMessage(hwnd_winamp,WM_WA_IPC,0,IPC_GETLISTLENGTH);
  OldStatus:=SendMessage(hwnd_winamp,WM_WA_IPC,0,IPC_ISPLAYING);
  if(S='')then MessageBox(0,PChar(Ini.ReadString(Language,'waListPosition','Current position:')+' '+
   inttostr(Current+1)+#13+Ini.ReadString(Language,'waListLength','Playlist length:')+' '+
   inttostr(CurLen)),PChar(Ini.ReadString(Language,'waStatus','Winamp status')),0)
  else if(S[1]='+')and(Err=0)then begin
   Inc(Current,Data);
   if SendMessage(hwnd_winamp,WM_WA_IPC,0,IPC_GET_REPEAT)=1 then while(Current>=CurLen)do Dec(Current,CurLen)
   else if Current>=CurLen then Current:=CurLen-1;
   SendMessage(hwnd_winamp,WM_WA_IPC,Current,IPC_SETPLAYLISTPOS);
   UpdateStatus;
  end else if(S[1]='-')and(Err=0)then begin
   Inc(Current,Data);
   if SendMessage(hwnd_winamp,WM_WA_IPC,0,IPC_GET_REPEAT)=1 then while(Current<0)do Inc(Current,CurLen)
   else if Current<0 then Current:=0;
   SendMessage(hwnd_winamp,WM_WA_IPC,Current,IPC_SETPLAYLISTPOS);
   UpdateStatus;
  end else if(S[1]='+')and(Err<>0)then SendMessage(hwnd_winamp,WM_COMMAND,40048,0)
  else if(S[1]='-')and(Err<>0)then SendMessage(hwnd_winamp,WM_COMMAND,40044,0)
  else if Data=0 then SendMessage(hwnd_winamp,WM_WA_IPC,0,IPC_STARTPLAY)
  else begin
   Dec(Data);
   if SendMessage(hwnd_winamp,WM_WA_IPC,0,IPC_GET_REPEAT)=1 then begin
    while(Current>=CurLen)do Dec(Current,CurLen);
    while(Current<0)do Inc(Current,CurLen);
   end else begin
    if Data>=CurLen then Data:=CurLen-1;
    if Data<0 then Data:=0;
   end;
   SendMessage(hwnd_winamp,WM_WA_IPC,Data,IPC_SETPLAYLISTPOS);
   UpdateStatus;
  end;
 //////// panning control
 end else if CompareText(S,Commands[6])=0 then begin
  S:=GetNext(Command);val(S,Data,Err);
  if(S<>'')and(Err=0)and(Data>=0)and(Data<=255)then SendMessage(hwnd_winamp,WM_WA_IPC,Data,IPC_SETPANNING);
 end else if CompareText(S,Commands[7])=0 then SendMessage(hwnd_winamp,WM_COMMAND,40045,0)
 else if CompareText(S,Commands[8])=0 then SendMessage(hwnd_winamp,WM_COMMAND,40046,0)
 else if CompareText(S,Commands[9])=0 then SendMessage(hwnd_winamp,WM_COMMAND,40047,0)
 else if CompareText(S,Commands[10])=0 then SendMessage(hwnd_winamp,WM_WA_IPC,0,IPC_DELETE)
 else if CompareText(S,Commands[11])=0 then begin
  Data:=SendMessage(hwnd_winamp,WM_WA_IPC,0,IPC_GETVERSION);
  MessageBox(0,PChar(Format('%s: %x',[Ini.ReadString(Language,'waVersion','Version'),Data])),
   PChar(Ini.ReadString(Language,'waStatus','Winamp status')),0);
 end else if CompareText(S,Commands[13])=0 then SendMessage(hwnd_winamp,WM_COMMAND,40044,0)
 else if CompareText(S,Commands[14])=0 then SendMessage(hwnd_winamp,WM_COMMAND,40048,0)
 else if CompareText(S,Commands[15])=0 then begin
  SendMessage(hwnd_winamp,WM_CLOSE,0,0);
  SendMessage(hwnd_winamp,WM_QUIT,0,0);
 end;
end;

Const BSPlayerClass='BSPlayer';

function PresentBSP:boolean;
begin Result:=FindWindow(BSPlayerClass,nil)<>0;end;

procedure CommandBSP(Command:string);
Const WM_BSP_CMD=WM_USER+2;
      BSP_GETVERSION=$10000;
      BSP_GetMovLen=$10100;
      BSP_GetMovPos=$10101;
      BSP_SetVol=$10104;
      BSP_GetVol=$10105;
      BSP_Seek=$10103;
      BSP_Forw=15;
      BSP_Rew=14;
      BSP_VolUp=1;
      BSP_VolDown=2;
      BSP_Play=20;
      BSP_Pause=21;
      BSP_Stop=22;
      BSP_Prev=25;
      BSP_Next=28;
      BSP_Zoom50=37;
      BSP_Zoom100=38;
      BSP_Zoom200=39;
var bsp_hand,Data,Err,Current,CurLen:integer;
    S:string;
begin
 bsp_hand:=FindWindow(BSPlayerClass,nil);
 if bsp_hand=0 then Exit;
 S:=GetNext(Command);
 // version
 if CompareText(S,Commands[11])=0 then begin
  Data:=SendMessage(bsp_hand,WM_BSP_CMD,BSP_GETVERSION,0);
  MessageBox(0,PChar(Format('%s %x',[Ini.ReadString(Language,'bspVersion','BSPlayer version'),Data])),
   PChar(Ini.ReadString(Language,'bspStatus','BSPlayer status')),0);
 // movie position
 end else if CompareText(S,Commands[4])=0 then begin
  S:=GetNext(Command);val(S,Data,Err);
  Current:=SendMessage(bsp_hand,WM_BSP_CMD,BSP_GetMovPos,0);
  CurLen:=SendMessage(bsp_hand,WM_BSP_CMD,BSP_GetMovLen,0);
  if(S='')then MessageBox(0,PChar(Ini.ReadString(Language,'bspPosition','Current position:')+' '+
   inttostr(Current div 1000)+#13+Ini.ReadString(Language,'bspLength','Movie duration:')+' '+
   inttostr(CurLen div 1000)),PChar(Ini.ReadString(Language,'bspStatus','BSPlayer status')),0)
  else if(S[1]='+')and(Err=0)then begin
   Inc(Current,Data*1000);
   if Current>CurLen then Current:=CurLen;
   SendMessage(bsp_hand,WM_BSP_CMD,BSP_Seek,Current);
  end else if(S[1]='-')and(Err=0)then begin
   Inc(Current,Data*1000);
   if Current<0 then Current:=0;
   SendMessage(bsp_hand,WM_BSP_CMD,BSP_Seek,Current);
  end else if(S[1]='+')and(Err<>0)then SendMessage(bsp_hand,WM_BSP_CMD,BSP_Forw,0)
  else if(S[1]='-')and(Err<>0)then SendMessage(bsp_hand,WM_BSP_CMD,BSP_Rew,0)
  else begin
   if Data>CurLen then Data:=CurLen;
   SendMessage(bsp_hand,WM_BSP_CMD,BSP_Seek,Data*1000);
  end;
 // list position
 end else if CompareText(S,Commands[5])=0 then begin
  S:=GetNext(Command);
  if S[1]='+' then SendMessage(bsp_hand,WM_BSP_CMD,BSP_Next,0);
  if S[1]='-' then SendMessage(bsp_hand,WM_BSP_CMD,BSP_Prev,0);
 // volume
 end else if CompareText(S,Commands[3])=0 then begin
  S:=GetNext(Command);val(S,Data,Err);
  Current:=SendMessage(bsp_hand,WM_BSP_CMD,BSP_GetVol,0);
  if S='' then
   MessageBox(0,PChar(Ini.ReadString(Language,'bspVolume','Volume:')+' '+inttostr(100*Current div 23)),
    PChar(Ini.ReadString(Language,'bspStatus','BSPlayer status')),0)
  else if(S[1]='+')and(Err<>0) then SendMessage(bsp_hand,WM_BSP_CMD,BSP_VolUp,0)
  else if(S[1]='-')and(Err<>0) then SendMessage(bsp_hand,WM_BSP_CMD,BSP_VolDown,0)
  else if(Err=0)and((S[1]='+')or(S[1]='-'))then SendMessage(bsp_hand,WM_BSP_CMD,BSP_SetVol,SendMessage(bsp_hand,WM_BSP_CMD,BSP_GetVol,0)+Data)
  else SendMessage(bsp_hand,WM_BSP_CMD,BSP_SetVol,((Data*23) div 100));
 end else if CompareText(S,Commands[7])=0 then SendMessage(bsp_hand,WM_BSP_CMD,BSP_Play,0)
 else if CompareText(S,Commands[8])=0 then SendMessage(bsp_hand,WM_BSP_CMD,BSP_Pause,0)
 else if CompareText(S,Commands[9])=0 then SendMessage(bsp_hand,WM_BSP_CMD,BSP_Stop,0)
 else if CompareText(S,Commands[12])=0 then begin
  S:=GetNext(Command);
  if S='50' then SendMessage(bsp_hand,WM_BSP_CMD,BSP_Zoom50,0);
  if S='100' then SendMessage(bsp_hand,WM_BSP_CMD,BSP_Zoom100,0);
  if S='200' then SendMessage(bsp_hand,WM_BSP_CMD,BSP_Zoom200,0);
 end else if CompareText(S,Commands[13])=0 then SendMessage(bsp_hand,WM_BSP_CMD,BSP_Prev,0)
 else if CompareText(S,Commands[14])=0 then SendMessage(bsp_hand,WM_BSP_CMD,BSP_Next,0)
 else if CompareText(S,Commands[15])=0 then begin
  SendMessage(bsp_hand,WM_CLOSE,0,0);
  SendMessage(bsp_hand,WM_QUIT,0,0);
 end;
end;

var fooWnd:integer;

function IsFoobarWnd(Wnd:HWnd):Boolean;
var Buf:array[0..255] of Char;
begin
 Buf[GetClassName(Wnd,@Buf,SizeOf(Buf))]:=#0;
 Result:=(StrIComp(Buf,'{53229DFC-A273-45cd-A3A4-161FA9FC6414}')=0)or//v0.8.3
  (StrIComp(Buf,'{641C2469-355C-4d6f-9663-E714382DA462}')=0);//v0.9 beta 6
end;

function EnumProc(Wnd:HWND;var lParam:HWnd):BOOL; stdcall;
begin
 Result:=not IsFoobarWnd(Wnd);
 if not Result then lParam:=Wnd;
end;

Function PresentFoo:boolean;
begin
 Result:=(fooWnd<>0)and(IsFoobarWnd(fooWnd));
 if not Result then begin
  fooWnd:=0;
  EnumWindows(@EnumProc,Integer(@fooWnd));
  Result:=(fooWnd<>0)and(IsFoobarWnd(fooWnd));
 end;
end;

function SendCmdToFooBar(const Cmd:string):Boolean;
// эта функция любезно предоставлена DRON с Королевства Delphi (www.delphikingdom.com)
// Принцип работы: эмуляция запуска (запускать по настоящему слишком долго)
//  FooBar-а с параметром "/command:<command>".
// В разных версиях GUID-ы разные, причём окошко
//  "{53229DFC-A273-45cd-A3A4-161FA9FC6414}" присутствует и в v0.9, но
//  посылать сообщения надо другому. Так как версии меняются ОЧЕНЬ редко,
//  можно особо не заморачиваться с их определением.
var CDS:TCopyDataStruct;
    Buf:string;
begin
 Result:=PresentFoo;
 if Result then begin
  Buf:='| "/command:'+Cmd+'"';
  CDS.dwData:=$7B09B62D;//В v0.9 можно просто 0
  CDS.cbData:=Length(Buf)+1;
  CDS.lpData:=PChar(Buf);
  SendMessage(fooWnd,WM_COPYDATA,0,Integer(@CDS));
 end;
 Sleep(50);
end;

// Const FooBarClass='{DA7CD0DE-1602-45e6-89A1-C2CA151E008E}';

Procedure CommandFoo(S:string);
var X:string;
    I,E:integer;
begin
 X:=GetNext(S);
 if CompareText(X,Commands[1])=0 then begin // repeat control
  X:=GetNext(S);
  if CompareText(X,'1')=0 then SendCmdToFoobar('Playback/Order/Repeat')
  else if CompareText(X,'0')=0 then SendCmdToFoobar('Playback/Order/Default')
  else if CompareText(X,'2')=0 then SendCmdToFoobar('Playback/Order/Repeat One');
 end else if CompareText(X,Commands[2])=0 then begin // shuffle control
  X:=GetNext(S);
  if X='0' then SendCmdToFoobar('Playback/Order/Default')
  else if X='1' then SendCmdToFoobar('Playback/Order/Random');
 end else if CompareText(X,Commands[3])=0 then begin // volume
  X:=GetNext(S);val(X,I,E);
  if X='+' then SendCmdToFoobar('Playback/Volume up')
  else if X='-' then SendCmdToFoobar('Playback/Volume down')
  else if(E=0)and((X[1]='+')or(X[1]='-'))then begin
   while I>0 do begin SendCmdToFoobar('Playback/Volume up');Dec(I);end;
   while I<0 do begin SendCmdToFoobar('Playback/Volume down');Inc(I);end;
  end else if E=0 then begin
   if I>100 then I:=100;
   case I of // mapping to foobar coordinates
    0..12:I:=-21;
    13..25:I:=-18;
    26..37:I:=-15;
    38..50:I:=-12;
    51..62:I:=-9;
    63..75:I:=-6;
    76..87:I:=-3;
    88..100:I:=0;
   end;
   SendCmdToFoobar('Playback/Set volume to '+inttostr(I)+'db');
  end;
 end else if CompareText(X,Commands[4])=0 then begin // pos
  X:=GetNext(S);val(X,I,E);
  if X='+' then SendCmdToFoobar('Playback/Seek ahead by 1 second')
  else if X='-' then SendCmdToFoobar('Playback/Seek back by 1 second')
  else if(E=0)then begin
   if(X[1]<>'+')and(X[1]<>'-') then SendCmdToFoobar('Playback/Play');
   while(I>=600)do begin SendCmdToFoobar('Playback/Seek ahead by 10 minutes');Dec(I,600);end;
   while(I>=60*5)do begin SendCmdToFoobar('Playback/Seek ahead by 5 minutes');Dec(I,60*5);end;
   while(I>=60*2)do begin SendCmdToFoobar('Playback/Seek ahead by 2 minutes');Dec(I,60*2);end;
   while(I>=60)do begin SendCmdToFoobar('Playback/Seek ahead by 1 minute');Dec(I,60);end;
   while(I>=30)do begin SendCmdToFoobar('Playback/Seek ahead by 30 seconds');Dec(I,30);end;
   while(I>=10)do begin SendCmdToFoobar('Playback/Seek ahead by 10 seconds');Dec(I,10);end;
   while(I>=5)do begin SendCmdToFoobar('Playback/Seek ahead by 5 seconds');Dec(I,5);end;
   while(I>=1)do begin SendCmdToFoobar('Playback/Seek ahead by 1 second');Dec(I);end;
   while(I<=-600)do begin SendCmdToFoobar('Playback/Seek back by 10 minutes');Inc(I,600);end;
   while(I<=-60*5)do begin SendCmdToFoobar('Playback/Seek back by 5 minutes');Inc(I,60*5);end;
   while(I<=-60*2)do begin SendCmdToFoobar('Playback/Seek back by 2 minutes');Inc(I,60*2);end;
   while(I<=-60)do begin SendCmdToFoobar('Playback/Seek back by 1 minute');Inc(I,60);end;
   while(I<=-30)do begin SendCmdToFoobar('Playback/Seek back by 30 seconds');Inc(I,30);end;
   while(I<=-10)do begin SendCmdToFoobar('Playback/Seek back by 10 seconds');Inc(I,10);end;
   while(I<=-5)do begin SendCmdToFoobar('Playback/Seek back by 5 seconds');Inc(I,5);end;
   while(I<=-1)do begin SendCmdToFoobar('Playback/Seek back by 1 second');Inc(I);end;
  end;
 end else if CompareText(X,Commands[5])=0 then begin // list
  X:=GetNext(S);val(X,I,E);
  if X='+' then SendCmdToFoobar('Playback/Next')
  else if X='-' then SendCmdToFoobar('Playback/Previous')
  else if(E=0)and((X[1]='+')or(X[1]='-'))then begin
   while I>0 do begin SendCmdToFoobar('Playback/Next');Dec(I);end;
   while I<0 do begin SendCmdToFoobar('Playback/Previous');Inc(I);end;
  end;
 end else if CompareText(X,Commands[7])=0 then begin // play
  SendCmdToFoobar('Playback/Play');
 end else if CompareText(X,Commands[8])=0 then begin // pause
  SendCmdToFoobar('Playback/Pause');
 end else if CompareText(X,Commands[9])=0 then begin // stop
  SendCmdToFoobar('Playback/Stop');
 end else if CompareText(X,Commands[10])=0 then begin // clear
  SendCmdToFoobar('Playlist/Clear');
 end else if CompareText(X,Commands[11])=0 then begin // version
  SendCmdToFoobar('Foobar2000/Activate');
  SendCmdToFoobar('Foobar2000/About');
 end else if CompareText(X,Commands[13])=0 then begin // prev
  SendCmdToFoobar('Playback/Previous');
 end else if CompareText(X,Commands[14])=0 then begin // next
  SendCmdToFoobar('Playback/Next');
 end else if CompareText(X,Commands[15])=0 then begin // close
  SendCmdToFoobar('Foobar2000/Close');
 end;
end;

initialization fooWnd:=0;
end.
