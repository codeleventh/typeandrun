// tar_math v1.6
// Copyright © Evgeniy Galantsev 2003-2005

library tar_math;

uses
	Math,
	SysUtils,
	IniFiles,
	Windows,
  FuncParser in 'FuncParser.pas';

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
  pf: TParsedFunction; // Класс математического парсера
  DllFileName: Array[0..MAX_PATH] of Char; // Путь к dll'шке - нужен для определения папки, где хранить настройки
  SelectAnswer: boolean; // Выделять ли ответ в консоли
  CopyToClipboard: boolean; // Копировать ли ответ в буфер обмена
  UseEqual: boolean; // Использовать ли символ = для распознания выражения
	UseOriginal: boolean; // Использовать ли оригинальное выражение в ответе
	Round: boolean; // Округлять ли ответ
	RoundLimit: integer; // Округлять - сколько знаков после запятой

// Кидает текст в буфер обмена
procedure SetClipboard(Buffer: PChar);
var
  Data: THandle;
  DataPtr: Pointer;
begin
  try
    OpenClipboard(0);
    try
      EmptyClipboard;
      Data:=GlobalAlloc(GMEM_MOVEABLE+GMEM_DDESHARE, StrLen(Buffer)+1);
      try
        DataPtr:=GlobalLock(Data);
        try
          Move(Buffer^, DataPtr^, StrLen(Buffer)+1);
          SetClipboardData(CF_TEXT, Data);
        finally
          GlobalUnlock(Data);
        end;
      except
        GlobalFree(Data);
        raise;
      end;
    finally
      CloseClipboard;
    end;
  finally
    CloseClipboard;
  end;
end;

// Загружает настройки из инишки
procedure LoadSettings;
var
  IniFile: TMemIniFile;
begin
  IniFile:=TMemIniFile.Create(ExtractFilePath(DllFileName)+'\tar_math.ini');
  SelectAnswer:=IniFile.ReadBool('General', 'SelectAnswer', True);
  CopyToClipboard:=IniFile.ReadBool('General', 'CopyToClipboard', True);
  UseEqual:=IniFile.ReadBool('General', 'UseEqual', True);
	UseOriginal:=IniFile.ReadBool('General', 'UseOriginal', True);
	Round:=IniFile.ReadBool('General', 'Round', True);
	RoundLimit:=IniFile.ReadInteger('General', 'RoundLimit', 13);
	if (RoundLimit<0) or (RoundLimit>13) then
		RoundLimit:=13;  
  IniFile.Destroy;
end;

// Сохраняет настройки в инишке
procedure SaveSettings;
var
  IniFile: TMemIniFile;
begin
  IniFile:=TMemIniFile.Create(ExtractFilePath(DllFileName)+'\tar_math.ini');
  IniFile.WriteBool('General', 'SelectAnswer', SelectAnswer);
  IniFile.WriteBool('General', 'CopyToClipboard', CopyToClipboard);
  IniFile.WriteBool('General', 'UseEqual', UseEqual);
	IniFile.WriteBool('General', 'UseOriginal', UseOriginal);
	IniFile.WriteBool('General', 'Round', Round);
	IniFile.WriteInteger('General', 'RoundLimit', RoundLimit);
  IniFile.UpdateFile;
  IniFile.Destroy;
end;

// Выполняется при загрузке dll
// WinHWND - хендл главного окна
procedure Load(WinHWND: HWND); cdecl;
begin
  GetModuleFileName(HInstance, DllFileName, MAX_PATH); // Вычисляем полный путь к tar_math.dll
  pf:=TParsedFunction.create;
	LoadSettings; // Загружаем настройки
end;
exports Load;

// Выполняется при выгрузке dll
procedure Unload; cdecl;
begin
  pf.Destroy;
	//SaveSettings; // Сохранение настроек
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
	info.name:='tar_math';
  info.version:='1.6';
  info.description:='Console calculator plugin';
  info.author:='Evgeniy Galantsev (-=GaLaN=-)';
	info.copyright:='Copyright © Evgeniy Galantsev 2003-2005';
  info.homepage:='http://galanc.com/';
	Result:=info;
end;
exports GetInfo;

// Запуск строки с помощью плагина - возвращает, прошел ли запуск и строку, отображаемую в консоли
// str - запускаемая строка
function RunString(str: PChar): TExec; cdecl;
var
	exec: TExec;
	tmpStr, AnswerText: string;
	ec: byte;
begin
	// Инициализация возвращаемой структуры
	exec.size:=SizeOf(TExec);
	exec.run:=0;
	exec.con_text:='';
	exec.con_sel_start:=0;
	exec.con_sel_length:=0;
	tmpStr:=str;
	// Если строка оканчивается на '=', то парсим
	if (Copy(tmpStr, Length(tmpStr), 1)='=') and UseEqual then
		tmpStr:=Copy(tmpStr, 0, Length(tmpStr)-1)
	else if UseEqual then
		exit;
	pf.ParseFunction(tmpStr, ec);
	// Если калькулятор сработал правильно
	if ec=0 then begin
		exec.run:=2;
		if Round then begin
			AnswerText:=FloatToStr(RoundTo(pf.Compute(0, 0, 0), -RoundLimit));
		end
		else begin
			AnswerText:=FloatToStr(pf.Compute(0, 0, 0));
		end;
		AnswerText:=Trim(AnswerText);
		while pos(',', AnswerText)<>0 do begin
			Insert('.', AnswerText, pos(',', AnswerText));
			Delete(AnswerText, pos(',', AnswerText), 1);
		end;
		if UseOriginal then begin
			if UseEqual then
				tmpStr:=tmpStr+'='+AnswerText
			else
				tmpStr:=tmpStr+AnswerText;
		end
		else
			tmpStr:=AnswerText;
		//exec.con_text:=PChar(tmpStr+'='+AnswerText);
		exec.con_text:=PChar(tmpStr);
		// В зависимости от настройки выделяем текст или нет
    if SelectAnswer then begin
    	if UseOriginal then begin
	      exec.con_sel_start:=Length(str);
	      exec.con_sel_length:=Length(AnswerText);
      end
      else begin
				exec.con_sel_start:=0;
	      exec.con_sel_length:=Length(AnswerText);
      end;
    end
    else begin
    	if UseOriginal then begin
	    	exec.con_sel_start:=Length(str);
	      exec.con_sel_length:=0;
			end;
    end;
    // Если разрешено, то копируем строку в буфер обмена
    if CopyToClipboard then
      SetClipboard(PChar(AnswerText));
  end;
	Result:=exec;
end;
exports RunString;

end.
