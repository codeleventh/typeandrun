library tar_hotkey;
uses
  Windows,
  Messages,
  SysUtils,
  Forms,Dialogs,IniFiles,
  Hotkey in 'Hotkey.pas',
  Unit1 in 'Unit1.pas' {xJournal};

Const Commands:array[0..4]of string=('~SetHotkey','~KillHotkey','~GetHotkey','~StoreHotkey','~keydebug');

Type TInfo=record
      size: integer; // Structure size, bytes
      plugin: PChar; // plugin detection string, should be 'Hello! I am the TypeAndRun plugin.'
      name: PChar; // Plugin name
      version: PChar; // Plugin version
      description: PChar; // Plugin short description
      author: PChar; // Plugin author
      copyright: PChar; // Copyrights
      homepage: PChar; // Plugin or author homepage
     end;
     TExec=record
      size: integer; // Structure size, bytes
      run: integer; // If string was processed then set non-zero value (0: not process, 1: process, 2: process and TaR console must be stay show)
      con_text: PChar; // New text in console (working with run=2!)
      con_sel_start: integer; // First symbol to select (working with run=2!)
      con_sel_length: integer; // Length of selection (working with run=2!)
     end;

var KeyWin:TKeyWin;
    TimerId:integer;
    S:string;
    Loaded:boolean;

{$R *.res}

procedure Load(WinHWND:integer);
var X:PChar;
begin
 TarHandle:=WinHWND;
 HotCount:=0;
 GetMem(X,512);
 GetModuleFileName(hInstance,X,512);
 Ini:=TIniFile.Create(ChangeFileExt(StrPas(X),'.INI'));
// AssignFile(Log,'log.log');
// Rewrite(Log);
 DllHandle:=LoadLibrary(PChar(ExtractFilePath(StrPas(X))+'KHook.dll'));
 if DllHandle<>0 then @SetHook:=GetProcAddress(DllHandle,'InstallHook');
 Keyboard:=TKeyboard.Create;
 KeyWin:=TKeyWin.Create;
 Loaded:=(DllHandle<>0)and(KeyWin<>nil)and(@SetHook<>nil)and(SetHook(1,KeyWin.Hnd)<>0);
 if not Loaded then begin
  if KeyWin<>nil then KeyWin.Free;KeyWin:=nil;
  if DllHandle<>0 then FreeLibrary(DllHandle);DllHandle:=0;
  if Keyboard<>nil then Keyboard.Free;Keyboard:=nil;
  MessageBox(TarHandle,StrPCopy(X,Ini.ReadString(Language,'ErrorHookSet','Hook not installed! Plugin won''t work!')),'Error',0);
  if Ini<>nil then Ini.Free;Ini:=nil;
 end;
 FreeMem(X,512);
end;
exports Load;

procedure Unload;cdecl;
var X:PChar;
begin
 GetMem(X,128);
 if Loaded then begin
  if SetHook(0,0)=0 then MessageBox(TarHandle,StrPCopy(X,Ini.ReadString(Language,'ErrorHookRemove','Hook not removed! System may crash!')),'Warning',0);
  if KeyWin<>nil then KeyWin.Free;KeyWin:=nil;
  if Ini<>nil then Ini.Free;Ini:=nil;
  if DllHandle<>0 then FreeLibrary(DllHandle);DllHandle:=0;
  if Keyboard<>nil then Keyboard.Free;
  Keyboard:=nil;
  Loaded:=false;
 end;
 FreeMem(X,128);
// CloseFile(Log);
end;
exports Unload;

function GetInfo:TInfo;cdecl; // информация о плагине
var X1,X2:PChar;
begin
 GetMem(X1,128);GetMem(X2,256);
 Result.size:=SizeOf(TInfo);
 Result.plugin:='Hello! I am the TypeAndRun plugin.';
 if Ini=nil then Result.name:='Hotkey manager'
 else Result.name:=PChar(StrPCopy(X1,Ini.ReadString(Language,'PluginName','Hotkey manager')));
 Result.version:='1.0 final';
 if Ini=nil then Result.description:='Manager of hotkeys'#13'And so on'
 else Result.description:=PChar(StrPCopy(X2,Replace(Ini.ReadString(Language,'PluginDescription','Manager of hotkeys\nAnd so on'),'\n',#13)));
 Result.author:='Python';
 Result.copyright:='SmiSoft (SA)';
 Result.homepage:='smisoft@rambler.ru';
end;
exports GetInfo;

function GetCount:integer;cdecl;
begin Result:=succ(High(Commands));end;
exports GetCount;

function GetString(num:integer):PChar;cdecl;
begin Result:=PChar(Commands[Num]);end;
exports GetString;

Procedure TimerProc(hWnd,uMsg,idEvent,dwTime:integer);stdcall;
var I,J:word;
    X:PChar;
begin
 KillTimer(0,TimerId);
 I:=pos(' ',S);
 GetMem(X,128);
 if I=0 then I:=Length(S)+1; // ошибка задания параметров
 if CompareText(copy(S,1,I-1),Commands[0])=0 then begin
  Delete(S,1,I);I:=pos(' ',S);if I=0 then exit;
  For J:=1 to HotCount do if CompareText(Hotkeys[J].Name,copy(S,1,I-1))=0 then break;
  if(HotCount>=Max)and(J>HotCount)then MessageBox(TarHandle,StrPCopy(X,Ini.ReadString(Language,'MaxHotkeysError','Too many hotkeys!')),'Warning',0)
  else if(J>HotCount)then begin
   Hotkeys[HotCount+1]:=TMyHotkey.Create(copy(S,I+1,Length(S)));
   if Hotkeys[HotCount+1]<>nil then begin
    Hotkeys[HotCount+1].Name:=copy(S,1,I-1);
    Inc(HotCount);
   end;
  end else Hotkeys[J].Create(copy(S,I+1,Length(S)));
 end else if CompareText(copy(S,1,I-1),Commands[1])=0 then begin
  S:=trim(copy(S,I+1,Length(S)));
  if Length(S)=0 then begin
   if MessageDlg(Ini.ReadString(Language,'EraseAll','Erase all hotkeys. Are you sure?'),mtConfirmation,mbOkCancel,0)=idOk then begin
    For I:=1 to HotCount do Hotkeys[I].Free;
    HotCount:=0;
   end;
  end else begin
   For J:=1 to HotCount do if CompareText(Hotkeys[J].Name,copy(S,1,I-1))=0 then break; // найти такое имя
   if J<=HotCount then begin
    for I:=J to HotCount-1 do Hotkeys[I].Copy(Hotkeys[I+1]);
    Hotkeys[HotCount].Free;
    Dec(HotCount);
   end else MessageDlg(Ini.ReadString(Language,'NotFound','This hotkey not found.'),mtWarning,[mbOk],0);
  end;
 end else if CompareText(copy(S,1,I-1),Commands[2])=0 then begin
  S:=trim(copy(S,I+1,Length(S)));
  if Length(S)=0 then begin
   Application.CreateForm(TxJournal,xJournal);
   if SetHook(1,xJournal.Handle)=0 then  // переключить хук на новое окно
    MessageDlg(Ini.ReadString(Language,'ErrorHookSet','Hook not installed! Plugin won''t work!'),mtError,[mbOk],0);
   xJournal.ShowModal;
   xJournal.Free;
   Keyboard.Create;
   if SetHook(1,KeyWin.Hnd)=0 then  // вернуть хук на старое окно
    MessageDlg(Ini.ReadString(Language,'ErrorHookRemove','Hook not removed! System may crash!'),mtWarning,[mbOk],0);
  end else begin
   For J:=1 to HotCount do if CompareText(Hotkeys[J].Name,copy(S,1,I-1))=0 then break; // найти такое имя
   if J<=HotCount then MessageDlg(Hotkeys[J].Name+#13+Hotkeys[J].Get,mtInformation,[mbOk],0)
   else MessageDlg(Ini.ReadString(Language,'NotFound','This hotkey not found.'),mtWarning,[mbOk],0);
  end;
 end else if CompareText(copy(S,1,I-1),Commands[3])=0 then begin
  KeyWin.WriteHotkeys;
 end else if CompareText(copy(S,1,I-1),commands[4])=0 then begin
  S:='Keys: '+inttostr(Keyboard.Count)+#13;
  For I:=1 to $1FF do if Keyboard.Status[I] then begin
   For J:=Low(SpecKeys) to High(SpecKeys) do if SpecScan[J]=I then break;
   if J>High(SpecKeys) then S:=S+Format(',%x',[I])
   else S:=S+','+SpecName[J];
  end;
  ShowMessage(S);
 end;
 FreeMem(X,128);
end;

function RunString(Str:PChar):TExec;cdecl; // выполнение переданной команды
var I,J:integer;
    Has:boolean;
begin
 Result.size:=SizeOf(TExec);
 Result.run:=0;
 Result.con_text:='';
 Result.con_sel_start:=0;
 Result.con_sel_length:=0;
 if Loaded then begin
  S:=StrPas(Str);
  I:=pos(' ',S);
  if I=0 then I:=Length(S)+1; // ошибка задания параметров
  Has:=false;
  For J:=Low(Commands) to High(Commands) do if CompareText(copy(S,1,I-1),Commands[J])=0 then Has:=true;
  if Has then begin
   Result.run:=1;
   TimerId:=SetTimer(0,0,100,@TimerProc);
   // проблема вот в чем: видимо, сперва отрабатывает процедура, а лишь потом - скрывается консоль.
   // чтобы сперва убрать консоль, приходится использовать вот такую фигню.
  end;
 end;
end;
exports RunString;

begin
 Ini:=nil;KeyWin:=nil;Keyboard:=nil;Loaded:=false;
end.
