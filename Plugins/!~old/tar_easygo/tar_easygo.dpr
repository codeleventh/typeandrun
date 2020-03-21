// Плагин, подключающий к TaR плагины Easy-Go!
// Copyright © Evgeniy Galantsev 2003-2005

library tar_easygo;

uses
	Windows,
	SysUtils;

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

	TDll=class(TObject)
		Name: string; // Имя dll
		Loaded: boolean; // Загружена ли dll
		Functions: array of string; // Список строк-функций из плагина
		private
			LibHandle: THandle; // Содержит хэндл загружаемой библиотеки
		protected
		public
			constructor Create; // Конструктор
			destructor Destroy; override; // Деструктор
			function Load: boolean; // Загружает библиотеку
			procedure Unload; // Выгружает библиотеку
		published
	end;

var
	DllFileName: Array[0..MAX_PATH] of Char; // Путь к dll'шке - нужен для определения папки, где леэит плагин
	DllList: array of Tdll;
	NumAliases: word;

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

// Конструктор
constructor TDll.Create;
begin
	inherited Create;
end;

// Деструктор
destructor TDll.Destroy;
begin
	inherited Destroy;
end;

// Загружает библиотеку
function TDll.Load: boolean;
var
	tmpGetScriptsList: function: PChar; stdcall;
	tmp: string;
	i: word;
begin
	Result:=False;
	SetLength(Functions, 0);
	if not Loaded then begin
		LibHandle:=LoadLibrary(PChar(Name));
		if LibHandle>=32 then begin
			tmpGetScriptsList:=GetProcAddress(LibHandle, 'GetScriptsList');
			if @tmpGetScriptsList<>nil then begin
				tmp:=tmpGetScriptsList;
				Loaded:=True;
				i:=1;
				while GetNumWord(tmp, '|', i)<>'' do begin
					SetLength(Functions, Length(Functions)+1);
					Functions[Length(Functions)-1]:='~' + Copy(ExtractFileName(Name), 0, Length(ExtractFileName(Name))-4) + '#' + GetNumWord(tmp, '|', i);
					Inc(i);
				end; 
				Result:=True;
			end;
		end;
	end;
end;

// Выгружает библиотеку
procedure TDll.Unload;
begin
	if Loaded then begin
		FreeLibrary(LibHandle);
		Loaded:=False;
	end;
end;

procedure FindDir;
var
	fi: TSearchRec;
begin
	SetCurrentDir(ExtractFilePath(DllFileName));
	if FindFirst('*.dll', faAnyFile, fi)=0 then begin
		repeat
			if fi.Name <> ExtractFileName(DllFileName) then begin
				SetLength(DllList, Length(DllList)+1);
				DllList[High(DllList)]:=TDll.Create;
				DllList[High(DllList)].Name:=ExtractFilePath(DllFileName) + fi.Name;
			end;
		until (FindNext(fi)<>0);
		FindClose(fi);
	end;
end;

// Выполняется при загрузке dll
// WinHWND - хендл главного окна
procedure Load(WinHWND: HWND); cdecl;
var
	i, j: word;
begin
	GetModuleFileName(HInstance, DllFileName, MAX_PATH); // Вычисляем полный путь к tar_easygo.dll
	SetLength(DllList, 0);
	FindDir;
	NumAliases:=0;
	if High(DllList)<>-1 then
		for i:=0 to High(DllList) do
			if DllList[i].Load then
				for j:=0 to Length(DllList[i].Functions)-1 do
					Inc(NumAliases);
end;
exports Load;

// Выполняется при выгрузке dll
procedure Unload; cdecl;
var
	i: word;
begin
	if High(DllList)<>-1 then
		for i:=0 to High(DllList) do begin
			DllList[i].Unload;
			DllList[i].Destroy;
		end;
	SetLength(DllList, 0);
end;
exports Unload;

// Проверка на принадледность dll к плагинам TypeAndRun
// И возврат информации о плагине
function GetInfo: TInfo; cdecl;
var
	info: TInfo;
begin
	info.size:=SizeOf(TInfo);
	info.plugin:='Hello! I am the TypeAndRun plugin.';
	info.name:='tar_easygo';
	info.version:='1.11';
	info.description:='Easy-Go! -> TaR plugins connector';
	info.author:='Evgeniy Galantsev (-=GaLaN=-)';
	info.copyright:='Copyright © Evgeniy Galantsev 2003-2005';
	info.homepage:='http://galanc.com/';
	Result:=info;
end;
exports GetInfo;

// Возвращает количество строк в списке в dll
function GetCount: integer; cdecl;
begin
	Result:=NumAliases;
end;
exports GetCount;

// Возвращает нужную строку из списка в dll
// num - номер нужной строки
function GetString(num: integer): PChar; cdecl;
var
	i, j, tmp: word;
	tmpResult: string;
begin
	tmp:=0;
	tmpResult:='';
	if High(DllList)<>-1 then
		for i:=0 to High(DllList) do begin
			if DllList[i].Loaded then begin
				for j:=0 to Length(DllList[i].Functions)-1 do begin
					Inc(tmp);
					if tmp=(num+1) then begin
						tmpResult:=DllList[i].Functions[j];
					end;
				end;
			end;
		end;
	Result:=PChar(tmpResult);
end;
exports GetString;

// Запуск строки с помощью плагина - возвращает, прошел ли запуск и строку, отображаемую в консоли
// str - запускаемая строка 
function RunString(str: PChar): TExec; cdecl;
var
	exec: TExec;
	i, j: word;
	tmpFunc: procedure(param: PChar); stdcall;
	tmpParam: string;
begin
	// Инициализация возвращаемой структуры
	exec.size:=SizeOf(TExec);
	exec.run:=0;
	exec.con_text:='';
	exec.con_sel_start:=0;
	exec.con_sel_length:=0;

	if High(DllList)<>-1 then
		for i:=0 to High(DllList) do begin
			if DllList[i].Loaded then begin
				for j:=0 to Length(DllList[i].Functions)-1 do begin
					if DllList[i].Functions[j]=GetNumWord(str, ' ', 1) then begin
						tmpParam:=GetNumWord(GetNumWord(str, ' ', 1), '#', 2);
						tmpFunc:=GetProcAddress(DllList[i].LibHandle, PChar(tmpParam));
						if @tmpFunc<>nil then begin
							tmpParam:=GetNumWord(str, ' ', 2);
							tmpFunc(PChar(tmpParam));
							exec.run:=1;
						end;
					end;
				end;
			end;
		end;
	Result:=exec;
end;
exports RunString;

end.
