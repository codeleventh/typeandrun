// tar_system 1.81
// Copyright © Evgeniy Galantsev 2003-2005

library mydll;

uses
	Windows,
  SysUtils,
  ShellApi,
	Messages,
	Tlhelp32,
	Classes,
  cdeject in 'cdeject.pas';

type
	TInfo=record
  	size: integer; // Размер структуры
  	plugin: PChar; // Обязательно строка 'Hello! I am the TypeAndRun plugin.' - это распознание плагина
		name: PChar; // Название плагина
		version: PChar; // Его версия
    description: PChar; // Краткое описание функциональности
    author: PChar; // Автор плагина
    copyright: PChar; // Права на плагин
    homepage: PChar; // Домашняя страница плагина
  end;
  TExec=record
  	size: integer; // Размер структуры
    run: integer; // Возвращает, запустилась ли строка
    con_text: PChar; // Если надо отобразить текст в консоли
    con_sel_start: integer; // Начало выделения текста в консоли
    con_sel_length: integer; // Длина выделения
  end;

var
	tmpList: array of string; // Массив алиасов
	tmpET: TStringList;
  ConsoleHWND: HWND;

// Очистка корзины
procedure DelBin;
const
  SHERB_NOCONFIRMATION = $00000001;
  SHERB_NOPROGRESSUI = $00000002;
  SHERB_NOSOUND = $00000004;
type
  TSHEmptyRecycleBin = function (Wnd: HWND; LPCTSTR: PChar; DWORD: Word): integer; stdcall;
var
  SHEmptyRecycleBin: TSHEmptyRecycleBin;
  LibHandle: THandle;
begin
  LibHandle:=LoadLibrary(PChar('Shell32.dll'));
  if LibHandle<>0 then
  	@SHEmptyRecycleBin:=GetProcAddress(LibHandle, 'SHEmptyRecycleBinA')
  else
  	exit;
  if @SHEmptyRecycleBin<>nil then
  SHEmptyRecycleBin(0, nil, SHERB_NOCONFIRMATION);
  FreeLibrary(LibHandle);
  @SHEmptyRecycleBin := nil;
end;

// Снимает процесс по имени файла
// ExeFileName - имя файла
function KillTask(ExeFileName: string): integer;
const
	PROCESS_TERMINATE=$0001;
var
	ContinueLoop: boolean;
	FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  result:= 0;
  FSnapshotHandle:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize:=Sizeof(FProcessEntry32);
  ContinueLoop:=Process32First(FSnapshotHandle, FProcessEntry32);
  while integer(ContinueLoop)<>0 do begin
		if((UpperCase(ExtractFileName(FProcessEntry32.szExeFile))=UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile)=UpperCase(ExeFileName))) then
			Result:=Integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0), FProcessEntry32.th32ProcessID), 0));
		ContinueLoop:=Process32Next(FSnapshotHandle, FProcessEntry32);
	end;
	CloseHandle(FSnapshotHandle);
end;

// Возвращает значение системной переменной
// VarName - имя переменной, например PATH
function GetDOSEnvVar(const VarName: string): string;
var
	i: integer;
begin
	Result:='';
	try
		i:=GetEnvironmentVariable(PChar(VarName), nil, 0);
		if i>0 then begin
			SetLength(Result, i-1);
			GetEnvironmentVariable(Pchar(VarName), PChar(Result), i);
		end
    else begin
    	Result:='';
    end;
	except
	  Result:='';
  end;
end;

// Возвращает полный путь к файлу, если он есть в одном месте из переменной PATH
// Str - имя файла
function GetPathFolder(Str: string): string;
var
	strPATH, tmpPath: string;
  tmpPos: integer;
begin
	strPATH:=GetDOSEnvVar('PATH');
	while Pos(';', strPATH)<>0 do begin
		tmpPos:=Pos(';', strPATH);
		tmpPath:=Copy(strPATH, 0, tmpPos-1);
		// Если такой файл есть в путях запуска
		if FileExists(tmpPath + '\' + Str) then begin
			Result:=tmpPath + '\' + Str;
			Exit;
		end;
		Delete(strPATH, 1, tmpPos);
  end;
  Result:='';
end;

// Пополняет список процессов
procedure LoadBuf;
var
	pe: TProcessEntry32;
	b: boolean;
	H: THandle;
begin
	tmpET.Clear;
	H:=CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);
	try
		pe.dwSize:=sizeof(pe);
		b:=Process32First(H, pe);
		while b do begin
			tmpET.Add(tmpList[4] + ' ' + pe.szExeFile);
			b:=Process32Next(H, pe);
		end;
	finally
		CloseHandle(H);
	end;
end;

// Пополняет список контролов
procedure LoadControls;
var
	strPATH, tmpPath, tmpName: string;
	tmpPos: integer;
	fi: TSearchRec;
begin
	tmpET.Clear;
	strPATH:=GetDOSEnvVar('PATH');
	while Pos(';', strPATH)<>0 do begin
		tmpPos:=Pos(';', strPATH);
		tmpPath:=Copy(strPATH, 0, tmpPos-1);
		if FindFirst(tmpPath+'\*.cpl', faAnyFile, fi)=0 then begin
			repeat
				if(fi.Name[1]='.') then continue;
				tmpName:=fi.Name;
				tmpName:=Copy(tmpName, 0, Length(tmpName)-4);
				tmpET.Add(tmpList[1] + ' ' + tmpName);
			until (FindNext(fi)<>0);
		end;
		FindClose(fi);
		Delete(strPATH, 1, tmpPos);
	end;
end;

// Возвращает нужное по счету слово в данной строке и с данным разделителем
// Str - изначальная строка
// Separator - разделитель слов
// Num - нужное по счету слово слева
function GetNumWord(Str, Separator: string; Num: integer): string;
var
  i: integer;
  tmpStr: string;
begin
  i:=0;
  tmpStr:=Str;
  while Pos(Separator, tmpStr)<>0 do begin
    Inc(i);
    Insert('!', tmpStr, Pos(Separator, tmpStr));
    Delete(tmpStr, Pos(Separator, tmpStr), 1);
  end;
  if Num>i+1 then begin
    Result:='';
  end
  else begin
    i:=0;
    Str:=Str+Separator;
    while i+1<=Num do begin
      tmpStr:=Copy(Str, 0, Pos(Separator, Str)-1);
      Delete(Str, 1, Pos(Separator, Str));
      Inc(i);
    end;
    Result:=tmpStr;
  end;
end;

// Возвращает версию windows
function GetWinVersion: String;
var
	VersionInfo: TOSVersionInfo;
	OSName: string;
begin
	VersionInfo.dwOSVersionInfoSize:= SizeOf(TOSVersionInfo);
	if Windows.GetVersionEx(VersionInfo) then begin
		with VersionInfo do begin
			case dwPlatformId of
				VER_PLATFORM_WIN32s: OSName:='Win32s';
				VER_PLATFORM_WIN32_WINDOWS: OSName:='Windows 95';
				VER_PLATFORM_WIN32_NT: OSName:='Windows NT';
			end;
			Result:=OSName+' Version '+IntToStr(dwMajorVersion)+'.'+IntToStr(dwMinorVersion)+#13#10' (Build '+IntToStr(dwBuildNumber)+': '+szCSDVersion+')';
		end;
	end
	else
		Result:='';
end;

// Меняет разрешение экрана и возвращает, удалось ли это сделать
// W - ширина
// H - высота
// B - глубина цвета
// F - кадровая развертка
function SetResolution(W, H, B, F: string): Boolean;
var
	DeviceMode : TDevMode;
begin
	with DeviceMode do begin
		dmSize:=SizeOf(DeviceMode);
		dmPelsWidth:=StrToInt(W);
		dmPelsHeight:=StrToInt(H);
		if B<>'' then dmBitsPerPel:=StrToInt(B);
    if F<>'' then dmDisplayFrequency:=StrToInt(F);
		dmFields:=DM_PELSWIDTH or DM_PELSHEIGHT;
    if B<>'' then dmFields:=dmFields or DM_BITSPERPEL;
    if F<>'' then dmFields:=dmFields or DM_DISPLAYFREQUENCY;
		Result:=False;
		if ChangeDisplaySettings(DeviceMode, CDS_UPDATEREGISTRY)<>DISP_CHANGE_SUCCESSFUL
			then Exit;
		Result:=ChangeDisplaySettings(DeviceMode, CDS_FULLSCREEN)=DISP_CHANGE_SUCCESSFUL;
	end;
end;

// Дает привелегии в NT
procedure GetPriv;
var
	hToken: THandle;
	tkp: TTokenPrivileges;
	tkpo: TTokenPrivileges;
	zero: DWORD;
begin
  zero:=0;
  if not OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken) then begin
    MessageBox(0, PChar('Error'), 'OpenProcessToken() Failed', MB_OK );
    Exit;
  end;
  if not LookupPrivilegeValue(nil, 'SeShutdownPrivilege', tkp.Privileges[0].Luid) then begin
    MessageBox(0, PChar('Error'), 'LookupPrivilegeValue() Failed', MB_OK );
    Exit;
  end;
  tkp.PrivilegeCount:=1;
  tkp.Privileges[0].Attributes:=SE_PRIVILEGE_ENABLED;
  AdjustTokenPrivileges(hToken, False, tkp, SizeOf(TTokenPrivileges), tkpo, zero);
end;

// Выходит из windows
// what - типа выхода:
// 0 - shutdown
// 1 - reboot
// 2 - logoff
// 3 - poweroff
// 4 - hibernate
// force - форсировать ли действие
procedure ExitWin(What: integer; force: boolean);
const
	SE_SHUTDOWN_NAME='SeShutdownPrivilege';
var
  actionExit: cardinal;
begin
  if What=0 then
    actionExit:=EWX_SHUTDOWN
  else if What=1 then
    actionExit:=EWX_REBOOT
  else if What=2 then
    actionExit:=EWX_LOGOFF
  else if What=3 then
    actionExit:=EWX_SHUTDOWN or EWX_POWEROFF
  else
    actionExit:=EWX_LOGOFF;
  if force then actionExit:=actionExit or EWX_FORCE;
	if Pos('NT', GetWinVersion)<>0 then begin
    GetPriv;
		if Boolean(GetLastError) then begin
			MessageBox(0, PChar('Error'), 'AdjustTokenPrivileges() Failed', MB_OK );
			Exit;
		end
		else begin
    	if What=4 then
      	SetSystemPowerState(False, force)
      else
				ExitWindowsEx(actionExit, 0);
  	end;
  end
	else if What<>4 then
		ExitWindowsEx(actionExit, 0);
end;

// Работа с приводами cdrom
procedure EjectCD(str: string);
var
  i: integer;
  c: char;
  o: Tact;
  s: string;
begin
	firstCD:=#0;
  InitDrivesStat;
  if Length(GetNumWord(str, ' ', 2))=0 then begin
    OpenCloseCD(FirstCD, aInvert);
  end
  else begin
  	i:=1;
    while(GetNumWord(str, ' ', i)<>'') do begin
      s:=GetNumWord(str, ' ', i);
      c:=UPcase(s[1]);
      o:=aOpen;
      if (c in ['/', '-']) then
        o:=aClose;
      if c in ['*', 'A'..'Z'] then
        o:=aInvert;
      if not (c in ['A'..'Z']) then
        if length(s)>1 then
          c:=s[2]
        else
          c:=FirstCD;
      OpenCloseCD(c,o);
      Inc(i);
    end;
  end;
  SetDrvState;
end;

function OpenControl(str: string): boolean;
var
	tmpParam: string;
	flag: boolean;
begin
	flag:=false;
	if Pos(' ', str)<>0 then begin
		tmpParam:=Copy(str, Pos(' ', str)+1, Length(str)-Pos(' ', str));
		tmpParam:=GetPathFolder(tmpParam+'.cpl');
		if tmpParam<>'' then begin
			ShellExecute(0, 'open', Pchar('rundll32.exe'), Pchar('shell32.dll,Control_RunDLL '+tmpParam), nil, SW_ShowNormal);
			flag:=true;
		end;
	end;
  Result:=flag;
end;

// Запускает алиас
// num - его номер
// str - запускаемая строка
function ExecAlias(num: integer; str: string): boolean;
var
	tmpStr: string;
	intNum: integer;
	flag: boolean;
begin
	intNum:=0;
	flag:=False;

  // cdeject
  if num=intNum then begin
		EjectCD(str);
    flag:=True;
  end;
	Inc(intNum);

  // control
	if num=intNum then begin
		flag:=OpenControl(str);
	end;
	Inc(intNum);

  // emptyrecyclebin
  if num=intNum then begin
		DelBin;
		flag:=True;
	end;
	Inc(intNum);

	// hibernate
	if num=intNum then begin
		if GetNumWord(str, ' ', 2)='force' then ExitWin(4, True) else ExitWin(4, False);
		flag:=True;
	end;
	Inc(intNum);

	// killprocess
	if num=intNum then begin
		KillTask(GetNumWord(str, ' ', 2));
		flag:=True;
	end;
	Inc(intNum);

	// lock
	if num=intNum then begin
		ShellExecute(0, 'open', Pchar('rundll32.exe'), Pchar('USER32.DLL,LockWorkStation'), nil, SW_ShowNormal);
		flag:=True;
	end;
	Inc(intNum);

	// logoff
	if num=intNum then begin
		if GetNumWord(str, ' ', 2)='force' then ExitWin(2, True) else ExitWin(2, False);
		flag:=True;
	end;
	Inc(intNum);

	// poweroff
	if num=intNum then begin
		if GetNumWord(str, ' ', 2)='force' then ExitWin(3, True) else ExitWin(3, False);
		flag:=True;
	end;
	Inc(intNum);

	// reboot
	if num=intNum then begin
		if GetNumWord(str, ' ', 2)='force' then ExitWin(1, True) else ExitWin(1, False);
		flag:=True;
	end;
	Inc(intNum);

	// resolution
	if num=intNum then begin
		tmpStr:=GetNumWord(str, ' ', 2);
		if tmpStr<>'' then begin
			if GetNumWord(tmpStr, ',', 1)<>'' then begin
				SetResolution(GetNumWord(tmpStr, ',', 1), GetNumWord(GetNumWord(str, ' ', 2), ',', 2), GetNumWord(tmpStr, ',', 3), GetNumWord(tmpStr, ',', 4));
				flag:=True;
			end;
		end;
	end;
	Inc(intNum);

	// shutdown
	if num=intNum then begin
		if GetNumWord(str, ' ', 2)='force' then ExitWin(0, True) else ExitWin(0, False);
		flag:=True;
	end;

  Result:=flag;
end;

// Посылает текст окну
// WinHandle - хендл окна
// txtText - посылаемая строка
procedure SendText(WinHandle: HWND; txtText: string);
var
	Data: TCopyDataStruct;
	s: string;
begin
	s:=txtText;
  Data.dwData := 0;
  Data.cbData := Length(s);
  Data.lpData := @s[1];
  SendMessage(WinHandle, WM_COPYDATA, 0, integer(@Data));
end;

// Выполняется при загрузке dll
// WinHWND - хендл главного окна
procedure Load(WinHWND: HWND); cdecl;
begin
	tmpET:=TStringList.Create;
  ConsoleHWND:=WinHWND;
	SetLength(tmpList, 11);
	tmpList[0]:='~cdeject';
	tmpList[1]:='~control';
	tmpList[2]:='~emptyrecyclebin';
	tmpList[3]:='~hibernate';
	tmpList[4]:='~killprocess';
	tmpList[5]:='~lock';
	tmpList[6]:='~logoff';
	tmpList[7]:='~poweroff';
	tmpList[8]:='~reboot';
	tmpList[9]:='~resolution';
	tmpList[10]:='~shutdown';
end;
exports Load;

// Выполняется при выгрузке dll
procedure Unload; cdecl;
begin
	tmpET.Free;
end;
exports Unload;

// Проверка при принадледность dll к плагинам TypeAndRun
// И возврат информации о плагине
function GetInfo: TInfo; cdecl;
var
	info: TInfo;
begin
	info.size:=SizeOf(TInfo);
	info.plugin:='Hello! I am the TypeAndRun plugin.';
	info.name:='tar_system';
	info.version:='1.81';
  info.description:='System functions';
  info.author:='Evgeniy Galantsev (-=GaLaN=-)';
	info.copyright:='Copyright © Evgeniy Galantsev 2003-2005';
	info.homepage:='http://galanc.com/';
	Result:=info;
end;
exports GetInfo;

// Возвращает количество строк в списке в dll
function GetCount: integer; cdecl;
begin
	Result:=High(tmpList)+1;
end;
exports GetCount;

// Возвращает нужную строку из списка в dll
// num - номер нужной строки
function GetString(num: integer): PChar; cdecl;
begin
	Result:=PChar(tmpList[num]);
end;
exports GetString;

// Возвращает дополнение к строке
function GetCountET(Str: PChar): integer; cdecl;
begin
	if GetNumWord(Str, ' ', 1)=tmpList[4] then begin
		LoadBuf;
		Result:=tmpET.Count;
	end
	else if GetNumWord(Str, ' ', 1)=tmpList[1] then begin
		LoadControls;
		Result:=tmpET.Count;
	end
	else
		Result:=0;
end;
exports GetCountET;

// Возвращает нужную строку из списка в dll
// num - номер нужной строки
function GetStringET(num: integer): PChar; cdecl;
begin
	Result:=PAnsiChar(tmpET.Strings[num]);
end;
exports GetStringET;

// Запуск строки с помощью плагина - возвращает, прошел ли запуск и строку, отображаемую в консоли
// str - запускаемая строка
function RunString(str: PChar): TExec; cdecl;
var
	i: integer;
	exec: TExec;
begin
	// Инициализация возвращаемой структуры
  exec.size:=SizeOf(TExec);
	exec.run:=0;
	exec.con_text:='';
	exec.con_sel_start:=0;
	exec.con_sel_length:=0;
	// Перебор алиасов
	for i:=0 to High(tmpList) do
		// Если запускаемая строка совпадает с одним из алиасов
		if tmpList[i]=Copy(str, 0, Length(tmpList[i])) then begin
			// То возвращаем TRUE
			if ExecAlias(i, str) then begin
				exec.run:=1;
				break;
			end;
		end;
	Result:=exec;
end;
exports RunString;

end.
