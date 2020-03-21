unit Static;

interface

uses Windows, SysUtils, Classes, Tlhelp32, Dialogs, Plugins, ShellApi, Forms, mmSystem;

function GetMyPath: string; // Возвращает папку, где находится программа со слешем в конце
function GetProgPath(Str: string): string; // Вырезает папку из полного пути (C:\Tmp\yo.exe -> C:\Tmp\)
function GetProgDrive(Str: string): string; // Вырезает диск из полного пути (C:\Tmp\yo.exe -> C:\)
function GetProgName(Str: string): string; // Вырезает имя из полного пути (C:\Tmp\yo.exe qwe rty -> C:\Tmp\yo.exe)
function GetProgParam(Str: string): string; // Вырезает параметры из полного пути (alias qwe rty -> qwe rty)
function GetLastDelimiter(Str: string): integer; // Возвращает позицию последнего слеша или 0, если их в строке нет
function IsWWW(Str: string): boolean; // Возвращает true, если переданный параметр - урл интернета
function IsEmail(Str: string): boolean; // Возвращает true, если переданный параметр - адрес почты
function CorrectEMail(Str: string): string; // Вставляет вместо пробелов - %20
function BindHotKey(keyAlt, keyCtrl, keyShift, keyWin: boolean; keyCode: cardinal; id: integer; frmHadle: HWND): boolean; // Забивает в системе хоткей
procedure UnBindHotKey(id: integer; frmHadle: HWND); // Сносит его
function ParseConsole(strCon: string): boolean; // Парсит всю строку, запущенную с консоли
function ParseAlias(Str: string): boolean; // Парсит алиасы
function ParseSysAlias(Str: string): boolean; // Парсит системные алиасы
function ParseInternal(Str: string): boolean; // Парсит внутренние команды
function ParseWWW(Str: string): boolean; // Парсит адреса интернета
function ParseEMail(Str: string): boolean; // Парсит адреса почты
function ParseFolder(Str: string): boolean; // Парсит папки (пути)
function ParseFile(Str: string): boolean; // Парсит файлы (пути)
function ParsePlugin(Str: string; FromAlias: boolean): boolean; // Парсит плагины
function ParseDOS(Str: string): boolean; // Парсит DOS
function IsNumber(Str: string): boolean; // Является ли строка целым числом
function KillZero(Str: string): string; // Удаляет первичные нули в строке
function GetWinVersion: String; // Возвращает версию windows
function KillTask(ExeFileName: string): integer; // Снимает процесс по имени файла
function SetProcessPriority(Priority: integer): integer; // Изменяет приоритет своего процесса
function GetProcessPriority: integer; // Возвращает приоритет своего процесса
function GetTypePath(Str: string; SelStart: integer): integer; // Возвращает номер символа, где начинается набираться путь
function GetDOSEnvVar(const VarName: string): string; // Возвращает значение системной переменной
function GetPathFolder(Str: string): string; // Возвращает полный путь к файлу, если он есть в одном месте из переменной PATH
function GetNumWord(Str, Separator: string; Num: integer): string; // Возвращает нужное по счету слово в данной строке и с данным разделителем
procedure SetKeyboardLayout(Str: string); // Устанавливает нужную раскладку
function DriveState(DrvLetter: string): integer; // Возвращает состояние диска
function RunShell(action: string; param: string = ''; path: string = ''; state: integer = SW_ShowNormal; method: string = 'open'; handle: HWND = 0): HWND; // Запускает через ShellExecute и смотрит, получилось ли
procedure PlayFile(FileName: string); // Проигрывает указанный файл

const
	// Встроенные команды WinConsole
	InSide: array[1..14] of string=('/about',
																 '/checkconfig',
                                 '/config',
																 '/exit',
																 '/help',
																 '/hide',
																 '/homedir',
																 '/inidir',
																 '/inifiles',
																 '/load',
																 '/reread',
																 '/settings',
                                 '/show',
																 '/unload'{,
																 '/test'});
	Program_Name='TypeAndRun'; // Название программы
	Program_Version='4.7b11'; // Версия программы
	HotKeyId=666; // Id главного хоткея

var
	Program_Config: string; // Название инишки конфига
	Program_History: string; // Название инишки истории
  Program_Config_Old: string; // Конфиг с мертвыми алиасами
  Program_Plugin: string; // Название инишки плагинов

implementation

uses Configs, ForAll, frmConsoleUnit, StrUtils, Settings;

// Возвращает папку, где находится программа со слешем в конце
// Использует функцию GetProgPath для вырезания пути
function GetMyPath: string;
begin
	Result:=GetProgPath(ParamStr(0));
end;

// Вырезает папку из полного пути (C:\Tmp\yo.exe -> C:\Tmp\)
// Использует функцию GetLastDelimiter для получения позиции последнего слеша
// Str - полный путь
function GetProgPath(Str: string): string;
begin
	if Copy(Str, 0, 1)='"' then
	  Result:=Copy(Str, 2, GetLastDelimiter(Str)-1)
  else
	  Result:=Copy(Str, 1, GetLastDelimiter(Str));
end;

// Вырезает диск из полного пути (C:\Tmp\yo.exe -> C:\)
// Str - полный путь
function GetProgDrive(Str: string): string;
begin
  Result:=Copy(Str, 1, 3);
end;

// Вырезает имя из полного пути (C:\Tmp\yo.exe qwe rty -> C:\Tmp\yo.exe)
// Str - полный путь
function GetProgName(Str: string): string;
var
	tmpStr, tmpProg, tmpParam: string;
begin
	tmpStr:=Trim(Str);
	tmpParam:='';
	if Copy(tmpStr, 0, 1)='"' then begin
		Delete(tmpStr, 1, 1);
		tmpProg:=Copy(tmpStr, 0, Pos('"', tmpStr)-1);
		Delete(tmpStr, 1, Length(tmpProg)+2);
		tmpParam:=tmpStr;
	end
	else if Pos(' ', tmpStr)<>0 then begin
		tmpProg:=Copy(tmpStr, 0, Pos(' ', tmpStr)-1);
		Delete(tmpStr, 1, Pos(' ', tmpStr));
		tmpParam:=tmpStr;
	end
	else
		tmpProg:=tmpStr;
	Result:=tmpProg;
	{if Pos(' ', Str)<> 0 then
		Result:=Copy(Str, 0, Pos(' ', str)-1)
	else
		Result:=Str;}
end;

// Вырезает параметры из полного пути (alias qwe rty -> qwe rty)
// Str - полный путь
function GetProgParam(Str: string): string;
var
	tmpStr, tmpProg, tmpParam: string;
begin
	tmpStr:=Trim(Str);
	tmpParam:='';
	if Copy(tmpStr, 0, 1)='"' then begin
		Delete(tmpStr, 1, 1);
		tmpProg:=Copy(tmpStr, 0, Pos('"', tmpStr)-1);
		Delete(tmpStr, 1, Length(tmpProg)+2);
		tmpParam:=tmpStr;
	end
	else if Pos(' ', tmpStr)<>0 then begin
		tmpProg:=Copy(tmpStr, 0, Pos(' ', tmpStr)-1);
		Delete(tmpStr, 1, Pos(' ', tmpStr));
		tmpParam:=tmpStr;
	end
	else
		tmpProg:=tmpStr;
	Result:=tmpParam;
	{if Pos(' ', Str)<> 0 then
		Result:=Copy(Str, Pos(' ', str)+1, Length(Str)-Pos(' ', str)+1)
	else
		Result:='';}
end;

// Возвращает позицию последнего слеша или 0, если их в строке нет
// Эта функция используется, где надо вырезать часть пути
// Str - путь
function GetLastDelimiter(Str: string): integer;
var
	i: integer;
begin
	for i:=length(Str) downto 0 do begin
		if Copy(Str, i, 1)='\' then Break;
	end;
	Result:=i;
end;

// Возвращает true, если переданный параметр - урл интернета
// Определяет по начальным 'www.' или 'http://' в строке
// Str - урл
function IsWWW(Str: string): boolean;
begin
  Result:=(AnsiLowerCase(Copy(Str, 1, 4))=AnsiLowerCase('www.')) or (AnsiLowerCase(Copy(Str, 1, 7))=AnsiLowerCase('http://'));
end;

// Возвращает true, если переданный параметр - адрес почты
// В строке должна быть сначала '@', а потом '.' - значит это мыло
// Str - адрес почты
function IsEMail(Str: string): boolean;
begin
  if (Pos('@', Str)<>0) and (Copy(Str, 0, 1)<>'@') then begin
    Delete(Str, 1, Pos('@', Str));
   	Result:=(Pos('.', Str)<>0) and (Copy(Str, 0, 1)<>'.');
  end
  else
  	Result:=False;
end;

// Вставляет вместо пробелов - %20
// Требуется для запуска почты через 'mailto:'
// Str - адрес почты для проверки 
function CorrectEMail(Str: string): string;
begin
	while Pos(' ', Str)<>0 do begin
		Insert('%20', Str, Pos(' ', Str));
		Delete(Str, Pos(' ', Str), 1);
  end;
	Result:=Str;
end;

// Забивает в системе хоткей
// Передаваемые параметры: Alt, Ctrl, Shift, Win, сама клавиша, Id хоткея и Handle формы
// Функция возвращает True, если хоткей удачно забит, иначе - False
function BindHotKey(keyAlt, keyCtrl, keyShift, keyWin: boolean; keyCode: cardinal; id: integer; frmHadle: HWND): boolean;
var
	ModKey: cardinal;
begin
	ModKey:=0;
	if keyAlt then ModKey:=ModKey+1;
	if keyCtrl then ModKey:=ModKey+2;
  if keyShift then ModKey:=ModKey+4;
	if keyWin then ModKey:=ModKey+8;
	Result:=RegisterHotkey(frmHadle, id, ModKey, keyCode);
end;

// Сносит забитый хоткей
// Передаваемые параметры: Handle формы и Id хоткея
procedure UnBindHotKey(id: integer; frmHadle: HWND);
begin
	UnRegisterHotkey(frmHadle, id);
end;

// Парсит всю строку, запущенную с консоли, на предмет запускаемости по разным категориям
// Возвращает TRUE, если что-то удалось запустить
// strCon - текст в консоли на момент запуска
function ParseConsole(strCon: string): boolean;
var
	IfExec: boolean;
//  tmpCon: string;
begin
	IfExec:=False;

{  while Pos(' & ', strCon)<>0 do begin
		tmpCon:=Copy(strCon, 0, Pos(' & ', strCon)-1);
    ShowMessage('|'+tmpCon+'|');
    Exit;
  end;}

	if (not IfExec) and Options.Exec.Internal then
		if ParseInternal(strCon) then IfExec:=True;
	if (not IfExec) and Options.Exec.Alias then
		if ParseAlias(strCon) then IfExec:=True;
	if (not IfExec) and Options.Exec.SysAlias then
		if ParseSysAlias(strCon) then IfExec:=True;
	if (not IfExec) and Options.Exec.WWW then
		if ParseWWW(strCon) then IfExec:=True;
	if (not IfExec) and Options.Exec.EMail then
		if ParseEMail(strCon) then IfExec:=True;
	if (not IfExec) and Options.Exec.Folders then
		if ParseFolder(strCon) then ifExec:=True;
	if (not IfExec) and Options.Exec.Files then
		if ParseFile(strCon) then IfExec:=True;
	if (not IfExec) and Options.Exec.Plugins then
		if ParsePlugin(strCon, False) then IfExec:=True;
	if (not IfExec) and Options.Exec.Shell then
		if ParseDOS(strCon) then IfExec:=True;
	IsShift:=False;
  IsParseCL:=False;
  IsParseMessage:=False;
 	Result:=IfExec;
end;

// Парсит внутренние команды
// Возвращает TRUE, если удалось запустить внутренную команду
// Str - внутренняя команда
function ParseInternal(Str: string): boolean;
var
	i: integer;
	IfExec: boolean;
begin
	IfExec:=False;
	for i:=1 to High(InSide) do begin
		if (GetProgName(Str)=Copy(InSide[i], 0, Length(Str))) or (not Options.EasyType.CaseSensitivity and (AnsiLowerCase(Str)=AnsiLowerCase(InSide[i]))) then begin
			IfExec:=True;
      HideCon;
			ExecInternal(i, GetProgParam(Str));
      SaveHistoryInternal(i, GetProgParam(Str));
			Break;
		end;
	end;
	Result:=IfExec;
end;

// Парсит алиасы
// Возвращает TRUE, если удалось запустить хоть один из них
// Str - алиас
function ParseAlias(Str: string): boolean;
var
	i: integer;
	IfExec: boolean;
  tmpStr: string;
begin
  IfExec:=False;
	for i:=0 to ConfigStr.Count-1 do begin
		if (GetProgName(Str)=GetName('alias', ConfigStr.Strings[i])) or (not Options.EasyType.CaseSensitivity and (AnsiLowerCase(GetProgName(Str))=AnsiLowerCase(GetName('alias', ConfigStr.Strings[i])))) then begin
    	HideCon;
			if not IsShift then begin
      	tmpStr:=GetName('action', ConfigStr.Strings[i]);
        if IsWWW(tmpStr) then begin
					InsertS(tmpStr, GetProgParam(Str));
					ExecWWW(tmpStr);
        end
        else begin
					ExecAlias(i, GetProgParam(Str));
        end;
			end
			else begin
      	tmpStr:=GetName('action', ConfigStr.Strings[i]);
        if IsWWW(tmpStr) then begin
          ExecAlias(i, GetProgParam(Str));
        end
        else
  				KillTask(ExtractFileName(tmpStr));
      end;
      SaveHistoryAlias(i, GetProgParam(Str));
      MoveTopConfig(i);
			IfExec:=True;
		end;
	end;
	Result:=IfExec;
end;

// Парсит системные алиасы
// Возвращает TRUE, если удалось запустить хоть один из них
// Str - алиас
function ParseSysAlias(Str: string): boolean;
var
	i: integer;
	IfExec: boolean;
begin
	IfExec:=False;
	for i:=0 to Options.SystemAliases.Name.Count-1 do begin
		if (GetProgName(Str)=Options.SystemAliases.Name.Strings[i]) or (not Options.EasyType.CaseSensitivity and (AnsiLowerCase(GetProgName(Str))=AnsiLowerCase(Options.SystemAliases.Name.Strings[i]))) then begin
    	HideCon;
			if not IsShift then begin
				ExecSysAlias(i, GetProgParam(Str));
				SaveSysHistoryAlias(i, GetProgParam(Str));
			end
			else
				KillTask(ExtractFileName(Options.SystemAliases.Action.Strings[i]));
			IfExec:=True;
		end;
	end;
	Result:=IfExec;
end;

// Парсит адреса интернета
// Возвращает TRUE, если удалось запустить адрес интернета
// Str - урл
function ParseWWW(Str: string): boolean;
begin
	if IsWWW(Str) then begin
  	HideCon;
		ExecWWW(Str);
		SaveHistoryWWW(Str);
		Result:=True;
	end
	else
		Result:=False;
end;

// Парсит адреса почты
// Возвращает TRUE, если удалось запустить адрес почты
// Str - адрес почты
function ParseEMail(Str: string): boolean;
begin
	if IsEmail(Str) then begin
  	HideCon;
		ExecEMail(Str);
		SaveHistoryEMail(Str);
		Result:=True;
	end
	else
		Result:=False;
end;

// Парсит папки (пути)
// Возвращает TRUE, если удалось открыть папку
// Str - путь к папке
function ParseFolder(Str: string): boolean;
begin
	if DirectoryExists(Str) then begin
  	HideCon;
		ExecFolder(Str);
		SaveHistoryFolder(Str);
		Result:=True;
	end
	else
		Result:=False;
end;

// Парсит файлы (пути)
// Str - путь к файлу
function ParseFile(Str: string): boolean;
var
	tmpStr: string;
begin
	tmpStr:=Str;
 	while Pos('"', tmpStr)<>0 do begin
   	Delete(tmpStr, Pos('"', tmpStr), 1);
  end;
	if FileExists(tmpStr) then begin
  	HideCon;
		ExecFile(tmpStr, '', GetProgPath(Str));
		SaveHistoryDOS(Str);
		Result:=True;
	end
  else if FileExists(GetProgName(tmpStr)) then begin
  	HideCon;
		ExecFile(GetProgName(tmpStr), GetProgParam(Str), GetProgPath(tmpStr));
		SaveHistoryDOS(Str);
		Result:=True;
	end
  else if GetPathFolder(GetProgName(tmpStr))<>'' then begin
  	HideCon;
		ExecFile(GetPathFolder(GetProgName(tmpStr)), GetProgParam(Str), GetProgPath(tmpStr));
		SaveHistoryDOS(Str);
		Result:=True;
  end
	else
		Result:=False;
end;

// Парсит плагины
// Str - путь к файлу
// FromAlias - если запуск плагина делается из алиаса
function ParsePlugin(Str: string; FromAlias: boolean): boolean;
var
  i: integer;
  tmpParse: TExec;
begin
  Result:=False;
  for i:=0 to High(PluginDll) do begin
		tmpParse.con_text:='';
		tmpParse:=ExecPlugin(i, Str);
    if tmpParse.run<>0 then begin
      if tmpParse.run=2 then begin
        frmTARConsole.txtConsole.Text:=tmpParse.con_text;
        frmTARConsole.txtConsole.SelStart:=tmpParse.con_sel_start;
        frmTARConsole.txtConsole.SelLength:=tmpParse.con_sel_length;
      end
      else
      	HideCon;
      if (not FromAlias) and PluginDll[i].SaveHistory then SaveHistoryPlugin(Str);
      Result:=True;
      Break;
    end;
  end;
end;

// Парсит DOS
// Вовращает TRUE, если удалось запустить
// Str - строка на запуск через shell
function ParseDOS(Str: string): boolean;
begin
	if Options.Path.Shell<>'' then begin
	  HideCon;
		ExecDOS(Str);
		SaveHistoryDOS(Str);
		Result:=True
	end
	else
		Result:=False;
end;

// Является ли строка целым числом
// Str - строка для проверки
function IsNumber(Str: string): boolean;
var
	i: integer;
	flag: boolean;

  // Является ли символ целым числом
  // Str - символ для проверки
	function IsNum(Str: string): boolean;
	begin
    IsNum:=((Str='0') or (Str='1') or (Str='2') or (Str='3') or (Str='4') or (Str='5') or (Str='6') or (Str='7') or (Str='8') or (Str='9'));
	end;

begin
	flag:=False;
	for i:=0 to Length(Str) do begin
		if (not IsNum(Copy(Str, i, 1))) then flag:=True;
	end;
  Result:=not flag;
end;

// Удаляет первичные нули в строке
// Str - данная строка
function KillZero(Str: string): string;
begin
	while (Copy(Str, 0, 1)='0') and (Length(Str)<>1) do
		Delete(Str, 1, 1);
	Result:=Str;
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
			Result:=OSName+'|'+IntToStr(dwMajorVersion)+'|'+IntToStr(dwMinorVersion)+'|'+IntToStr(dwBuildNumber)+'|'+szCSDVersion;
		end;
	end
	else
		Result:='';
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

// Изменяет приоритет своего процесса
// Priority - приоритет:
// -1 - idle
// 0 - normal
// 1 - high
// 2 - realtime
function SetProcessPriority(Priority: integer): integer;
var
	H: THandle;
begin
	Result:=0;
	H:=GetCurrentProcess();
	if(Priority=-1) then
		SetPriorityClass(H, IDLE_PRIORITY_CLASS)
	else if (Priority=0) then
		SetPriorityClass(H, NORMAL_PRIORITY_CLASS)
	else if (Priority=1) then
		SetPriorityClass(H, HIGH_PRIORITY_CLASS)
	else if (Priority=2) then
		SetPriorityClass(H, REALTIME_PRIORITY_CLASS);
	case GetPriorityClass(H) Of
		IDLE_PRIORITY_CLASS: Result:=-1;
		NORMAL_PRIORITY_CLASS: Result:=0;
		HIGH_PRIORITY_CLASS: Result:=1;
		REALTIME_PRIORITY_CLASS: Result:=2;
	end;
end;

// Возвращает приоритет своего процесса
function GetProcessPriority: integer;
var
	H: THandle;
begin
	Result:=0;
	H:=GetCurrentProcess();
	case GetPriorityClass(H) Of
		IDLE_PRIORITY_CLASS: Result:=-1;
		NORMAL_PRIORITY_CLASS: Result:=0;
		HIGH_PRIORITY_CLASS: Result:=1;
		REALTIME_PRIORITY_CLASS: Result:=2;
	end;
end;

// Возвращает номер символа, где начинается набираться путь
function GetTypePath(Str: string; SelStart: integer): integer;
var
	Posit: integer;
begin
  Str:=Copy(Str, 0, SelStart);
  Posit:=0;
  while pos(':\', Str)<>0 do begin
    Posit:=Pos(':\', Str);
    Str[Posit]:='¦';
    Str[Posit+1]:='¦';
  end;
	Result:=Posit;
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
  i: integer;
const
  extArr: array[1..10] of string=('.com', '.exe', '.bat', '.cmd', '.vbs', '.vbe', '.js', '.jse', '.wsf', '.wsh');
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
    // Если нет - пробуем подставлять разные стандартные расширения
    for i:=1 to High(ExtArr) do begin
      if FileExists(tmpPath + '\' + Str + extArr[i]) then begin
        Result:=tmpPath + '\' + Str;
        Exit;
      end;
    end;
    Delete(strPATH, 1, tmpPos);
  end;
  Result:='';
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
    Insert('¦', tmpStr, Pos(Separator, tmpStr));
    Delete(tmpStr, Pos(Separator, tmpStr), 1);
  end;
  if Num>i+1 then begin
    Result:='';
  end
  else begin
    i:=0;
    Str:=Str+Separator;
    while i+1<=Num do begin
      tmpStr:=Copy(Str, 1, Pos(Separator, Str)-1);
      Delete(Str, 1, Pos(Separator, Str)+Length(Separator)-1);
      Inc(i);
    end;
    Result:=tmpStr;
  end;
end;

// Устанавливает нужную раскладку
// Str - Код нужной раскладки
procedure SetKeyboardLayout(Str: string);
var
  Layout: array [0..KL_NAMELENGTH] of char;
begin
  LoadKeyboardLayout(StrCopy(Layout, PChar(Str)), KLF_ACTIVATE);
end;

// Возвращает состояние диска
// DrvLetter - буква диска+':'
function DriveState(DrvLetter: string): integer;
var
  SearchRec: TSearchRec;
  oldMode: Cardinal;
  ReturnCode: Integer;
begin
  oldMode:=SetErrorMode(SEM_FAILCRITICALERRORS);
  {$I-}
  ReturnCode:=FindFirst(DrvLetter+'\*.*', faAnyfile, SearchRec);
  FindClose(SearchRec);
  {$I+}
  Result:=ReturnCode;
  SetErrorMode(oldMode);
end;

// Запускает через ShellExecute и смотрит, получилось ли
function RunShell(action: string; param: string = ''; path: string = ''; state: integer = SW_ShowNormal; method: string = 'open'; handle: HWND = 0): HWND;
begin
	if handle=0 then
		handle:=Application.Handle;
	if (method='') and not Options.Exec.DefaultAction then
		method:='open';
	Result:=ShellExecute(handle, PAnsiChar(method), PAnsiChar(action), PAnsiChar(param), PAnsiChar(path), state);
end;

// Проигрывает указанный файл
procedure PlayFile(FileName: string);
var
	tmpFile: PChar;
begin
	if Options.Sounds.EnableSounds then begin
		tmpFile:='';
		if FileExists(FileName) then
			tmpFile:=PChar(FileName)
		else if FileExists(GetMyPath + FileName) then
			tmpFile:=PChar(GetMyPath + FileName);
		if tmpFile<>'' then
			PlaySound(tmpFile, 0, SND_ASYNC or SND_FILENAME);
	end;
end;

end.
