unit Settings;

interface

uses
	Forms, IniFiles, Graphics, Classes, SysUtils, Registry, Windows, Dialogs, AlignEdit, CoolTrayIcon, Static, ForAll,
	Configs;

type
	// Класс настроек - Show
	TSettingsShow = class(TObject)
		private
			FConsoleWidthPercent: boolean;
			FBalloonTips: boolean;
			FHideConsole: boolean;
			FCenterScreenX: boolean;
			FCenterScreenY: boolean;
			FPutMouseIntoConsole: boolean;
			FShowConsoleOnStart: boolean;
			FTriggerShow: boolean;
			FAutoHide: boolean;
			FTrayIcon: boolean;
			FDestroyForm: boolean;
			FPriority: integer;
			FAutoHideValue: integer;
			FConsoleX: integer;
			FConsoleHeight: integer;
			FConsoleY: integer;
			FTransparent: integer;
			FConsoleWidth: integer;
			FBorderSize: integer;
			procedure SetAutoHide(const Value: boolean);
			procedure SetAutoHideValue(const Value: integer);
			procedure SetBalloonTips(const Value: boolean);
			procedure SetBorderSize(const Value: integer);
			procedure SetCenterScreenX(const Value: boolean);
			procedure SetCenterScreenY(const Value: boolean);
			procedure SetConsoleHeight(const Value: integer);
			procedure SetConsoleWidth(const Value: integer);
			procedure SetConsoleWidthPercent(const Value: boolean);
			procedure SetConsoleX(const Value: integer);
			procedure SetConsoleY(const Value: integer);
			procedure SetDestroyForm(const Value: boolean);
			procedure SetHideConsole(const Value: boolean);
			procedure SetPriority(const Value: integer);
			procedure SetPutMouseIntoConsole(const Value: boolean);
			procedure SetShowConsoleOnStart(const Value: boolean);
			procedure SetTransparent(const Value: integer);
			procedure SetTrayIcon(const Value: boolean);
			procedure SetTriggerShow(const Value: boolean);
		published
			property ShowConsoleOnStart: boolean read FShowConsoleOnStart write SetShowConsoleOnStart; // Показывать ли консоль при запуске
			property HideConsole: boolean read FHideConsole write SetHideConsole; // Скрывать ли консоль после нажатия Enter
			property TriggerShow: boolean read FTriggerShow write SetTriggerShow; // Скрывать ли консоль после повторного нажатия горячей клавиши
			property CenterScreenX: boolean read FCenterScreenX write SetCenterScreenX; // Показывать X в центре экрана
			property CenterScreenY: boolean read FCenterScreenY write SetCenterScreenY; // Показывать Y в центре экрана
			property ConsoleX: integer read FConsoleX write SetConsoleX; // X координаты консоли (действуют, если CenterScreen=0)
			property ConsoleY: integer read FConsoleY write SetConsoleY; // Y координаты консоли (действуют, если CenterScreen=0)
			property ConsoleHeight: integer read FConsoleHeight write SetConsoleHeight; // Высота консоли
			property ConsoleWidth: integer read FConsoleWidth write SetConsoleWidth; // Ширина консоли
			property ConsoleWidthPercent: boolean read FConsoleWidthPercent write SetConsoleWidthPercent; // Ширина в процентах?
			property Transparent: integer read FTransparent write SetTransparent; // Прозрачность формы
			property DestroyForm: boolean read FDestroyForm write SetDestroyForm; // Убрать форму и оставить лишь рамку
			property BorderSize: integer read FBorderSize write SetBorderSize; // Размер рамки вокруг консоли
			property TrayIcon: boolean read FTrayIcon write SetTrayIcon; // Показывать иконку в трее
			property AutoHide: boolean read FAutoHide write SetAutoHide; // Скрывать консоль с случае потери фокуса
			property AutoHideValue: integer read FAutoHideValue write SetAutoHideValue; // Количество миллисекунд до скрытия
			property Priority: integer read FPriority write SetPriority; // Приоритет программы
			property BalloonTips: boolean read FBalloonTips write SetBalloonTips; // Показывать ли балун типсы
			property PutMouseIntoConsole: boolean read FPutMouseIntoConsole write SetPutMouseIntoConsole; // Помещать мышиный курсор в консоль при ее вызове
	end;

	// Класс настроек - Hint
	TSettingsHint = class(TObject)
		private
			FShowHint: boolean;
    FDestroyForm: boolean;
    FBorderSize: integer;
    FTransparent: integer;
			procedure SetShowHint(const Value: boolean);
    procedure SetBorderSize(const Value: integer);
    procedure SetDestroyForm(const Value: boolean);
    procedure SetTransparent(const Value: integer);
		published
			property ShowHint: boolean read FShowHint write SetShowHint; // Показывать ли подсказку при наборе алиасов
			property Transparent: integer read FTransparent write SetTransparent; // Прозрачность формы
			property DestroyForm: boolean read FDestroyForm write SetDestroyForm; // Убрать форму и оставить лишь рамку
			property BorderSize: integer read FBorderSize write SetBorderSize; // Размер рамки вокруг консоли
	end;

	// Класс настроек - DownDrop
	TSettingsDownDrop = class(TObject)
		private
			FLineNum: integer;
    FDestroyForm: boolean;
    FBorderSize: integer;
    FTransparent: integer;
			procedure SetLineNum(const Value: integer);
    procedure SetBorderSize(const Value: integer);
    procedure SetDestroyForm(const Value: boolean);
    procedure SetTransparent(const Value: integer);
		published
			property LineNum: integer read FLineNum write SetLineNum; // Число строк в выпадающем листе
			property Transparent: integer read FTransparent write SetTransparent; // Прозрачность формы
			property DestroyForm: boolean read FDestroyForm write SetDestroyForm; // Убрать форму и оставить лишь рамку
			property BorderSize: integer read FBorderSize write SetBorderSize; // Размер рамки вокруг консоли
	end;

	// Класс настроек - Color
	TSettingsColor = class(TObject)
		private
			FName: string;
			FBorder: TColor;
			FHintColor: TColor;
			FDropDownText: TColor;
			FText: TColor;
			FConsole: TColor;
			FDropDownColor: TColor;
			FHintText: TColor;
    FHintBorder: TColor;
    FDropDownBorder: TColor;
			procedure SetBorder(const Value: TColor);
			procedure SetConsole(const Value: TColor);
			procedure SetDropDownColor(const Value: TColor);
			procedure SetDropDownText(const Value: TColor);
			procedure SetHintColor(const Value: TColor);
			procedure SetHintText(const Value: TColor);
			procedure SetName(const Value: string);
			procedure SetText(const Value: TColor);
    procedure SetDropDownBorder(const Value: TColor);
    procedure SetHintBorder(const Value: TColor);
		published
			property Name: string read FName write SetName;
			property Text: TColor read FText write SetText;
			property Console: TColor read FConsole write SetConsole;
			property Border: TColor read FBorder write SetBorder;
			property HintText: TColor read FHintText write SetHintText;
			property HintColor: TColor read FHintColor write SetHintColor;
			property HintBorder: TColor read FHintBorder write SetHintBorder;
			property DropDownText: TColor read FDropDownText write SetDropDownText;
			property DropDownColor: TColor read FDropDownColor write SetDropDownColor;
			property DropDownBorder: TColor read FDropDownBorder write SetDropDownBorder;
	end;


	// Класс настроек - Hotkey
	TSettingsHotkey = class(TObject)
		private
			FCtrlKey: boolean;
			FAltKey: boolean;
			FWinKey: boolean;
			FShiftKey: boolean;
			FKey: cardinal;
			procedure SetAltKey(const Value: boolean);
			procedure SetCtrlKey(const Value: boolean);
			procedure SetKey(const Value: cardinal);
			procedure SetShiftKey(const Value: boolean);
			procedure SetWinKey(const Value: boolean);
		published
			property Key: cardinal read FKey write SetKey; // Клавиша для хоткея
			property WinKey: boolean read FWinKey write SetWinKey; // Win?
			property CtrlKey: boolean read FCtrlKey write SetCtrlKey; // Ctrl?
			property AltKey: boolean read FAltKey write SetAltKey; // Alt?
			property ShiftKey: boolean read FShiftKey write SetShiftKey; // Shift?
	end;

	// Класс настроек - Font
	TSettingsFont = class(TObject)
		private
			FBold: boolean;
			FApplyEnglish: boolean;
			FAutoSize: boolean;
			FUnderLine: boolean;
			FLockEnglish: boolean;
			FItalic: boolean;
			FStrikeOut: boolean;
			FAlign: integer;
			FSize: integer;
			FName: string;
			procedure SetAlign(const Value: integer);
			procedure SetApplyEnglish(const Value: boolean);
			procedure SetAutoSize(const Value: boolean);
			procedure SetBold(const Value: boolean);
			procedure SetItalic(const Value: boolean);
			procedure SetLockEnglish(const Value: boolean);
			procedure SetName(const Value: string);
			procedure SetSize(const Value: integer);
			procedure SetStrikeOut(const Value: boolean);
			procedure SetUnderLine(const Value: boolean);
		published
			property Name: string read FName write SetName; // Имя шрифта для консоли
			property Size: integer read FSize write SetSize; // Размер щрифта для консоли
			property AutoSize: boolean read FAutoSize write SetAutoSize; // Автоматически подгонять размер шрифта?
			property Bold: boolean read FBold write SetBold; // Жирный?
			property Italic: boolean read FItalic write SetItalic; // Курсив?
			property StrikeOut: boolean read FStrikeOut write SetStrikeOut; // Перечеркнутый?
			property UnderLine: boolean read FUnderLine write SetUnderLine; // Подчеркнутый?
			property Align: integer read FAlign write SetAlign; // Выравнивание текста в консоли
			property ApplyEnglish: boolean read FApplyEnglish write SetApplyEnglish; // Включать ли английскую раскладку при каждом вызове консоли
			property LockEnglish: boolean read FLockEnglish write SetLockEnglish; // Запрещать ли изменять английскую расладку
	end;

	// Класс настроек - Type
	TSettingsType = class(TObject)
		private
			FCaseSensitivity: boolean;
			FAdvancedBackspace: boolean;
			FHistory: boolean;
			FPlugins: boolean;
			FInternal: boolean;
			FAlias: boolean;
			FSysAlias: boolean;
			FSpace: boolean;
			FAdvancedSpace: boolean;
			FEnableET: boolean;
			FPath: boolean;
			FEasyType: integer;
    	FDeleteDuplicates: boolean;
			procedure SetAdvancedBackspace(const Value: boolean);
			procedure SetAdvancedSpace(const Value: boolean);
			procedure SetAlias(const Value: boolean);
			procedure SetCaseSensitivity(const Value: boolean);
			procedure SetEasyType(const Value: integer);
			procedure SetEnableET(const Value: boolean);
			procedure SetHistory(const Value: boolean);
			procedure SetInternal(const Value: boolean);
			procedure SetPath(const Value: boolean);
			procedure SetPlugins(const Value: boolean);
			procedure SetSpace(const Value: boolean);
			procedure SetSysAlias(const Value: boolean);
    procedure SetDeleteDuplicates(const Value: boolean);
		published
			property EasyType: integer read FEasyType write SetEasyType; // Вариант автодополнения
			property Internal: boolean read FInternal write SetInternal; // Дополнять внутренние команды
			property Alias: boolean read FAlias write SetAlias; // Дополнять названия алиасов
			property SysAlias: boolean read FSysAlias write SetSysAlias; // Дополнять названия системных алиасов
			property Path: boolean read FPath write SetPath; // Дополнять браузер путей
			property Plugins: boolean read FPlugins write SetPlugins; // Дополнять ли строки из плагинов
			property History: boolean read FHistory write SetHistory; // Дополнять историю
			property CaseSensitivity: boolean read FCaseSensitivity write SetCaseSensitivity; // Различать ли регистр набираемых символов
			property Space: boolean read FSpace write SetSpace; // Добавлять к алиасам пробел в конце.
			property EnableET: boolean read FEnableET write SetEnableET; // Включать ли автодополнение при каждом вызове консоли?
			property AdvancedBackspace: boolean read FAdvancedBackspace write SetAdvancedBackspace; // Включить продвинутое нажатие backspace
			property AdvancedSpace: boolean read FAdvancedSpace write SetAdvancedSpace; // Включить продвинутое нажатие space
			property DeleteDuplicates: boolean read FDeleteDuplicates write SetDeleteDuplicates; // Удалять дубликаты из списка дополнения
	end;

	// Класс настроек - Exec
	TSettingsExec = class(TObject)
		private
			FSysAlias: boolean;
			FFiles: boolean;
			FEMail: boolean;
			FWWW: boolean;
			FFolders: boolean;
			FDefaultAction: boolean;
			FInternal: boolean;
			FAlias: boolean;
			FShell: boolean;
			FPlugins: boolean;
			procedure SetAlias(const Value: boolean);
			procedure SetDefaultAction(const Value: boolean);
			procedure SetEMail(const Value: boolean);
			procedure SetFiles(const Value: boolean);
			procedure SetFolders(const Value: boolean);
			procedure SetInternal(const Value: boolean);
			procedure SetPlugins(const Value: boolean);
			procedure SetShell(const Value: boolean);
			procedure SetSysAlias(const Value: boolean);
			procedure SetWWW(const Value: boolean);
		published
			property Internal: boolean read FInternal write SetInternal; // Запускать ли внутренние команды
			property Alias: boolean read FAlias write SetAlias; // Запускать ли алиасы
			property SysAlias: boolean read FSysAlias write SetSysAlias; // Запускать ли системные алиасы
			property WWW: boolean read FWWW write SetWWW; // Запускать ли адреса интернета
			property EMail: boolean read FEMail write SetEMail; // Запускать ли адреса почты
			property Folders: boolean read FFolders write SetFolders; // Открывать ли папки
			property Files: boolean read FFiles write SetFiles; // Запускать ли файлы
			property Plugins: boolean read FPlugins write SetPlugins; // Запускать ли плагины
			property Shell: boolean read FShell write SetShell; // Запускать ли неопознанные команды через shell?
			property DefaultAction: boolean read FDefaultAction write SetDefaultAction; // Запускать действие по умолчанию, а не open
	end;

	// Класс настроек - History
	TSettingsHistory = class(TObject)
		private
			FInvertScroll: boolean;
			FSaveEMail: boolean;
			FSavePath: boolean;
			FSaveParamPlugins: boolean;
			FSaveHistory: boolean;
			FSaveWWW: boolean;
			FSaveParamAlias: boolean;
			FSaveSysParamAlias: boolean;
			FSaveInternal: boolean;
			FSaveAlias: boolean;
			FSaveSysAlias: boolean;
			FSavePlugins: boolean;
			FSaveParamInternal: boolean;
			FSaveUnknown: boolean;
			FSaveMessage: boolean;
			FSaveCommandLine: boolean;
			FMaxHistory: integer;
			procedure SetInvertScroll(const Value: boolean);
			procedure SetMaxHistory(const Value: integer);
			procedure SetSaveAlias(const Value: boolean);
			procedure SetSaveCommandLine(const Value: boolean);
			procedure SetSaveEMail(const Value: boolean);
			procedure SetSaveHistory(const Value: boolean);
			procedure SetSaveInternal(const Value: boolean);
			procedure SetSaveMessage(const Value: boolean);
			procedure SetSaveParamAlias(const Value: boolean);
			procedure SetSaveParamInternal(const Value: boolean);
			procedure SetSaveParamPlugins(const Value: boolean);
			procedure SetSavePath(const Value: boolean);
			procedure SetSavePlugins(const Value: boolean);
			procedure SetSaveSysAlias(const Value: boolean);
			procedure SetSaveSysParamAlias(const Value: boolean);
			procedure SetSaveUnknown(const Value: boolean);
			procedure SetSaveWWW(const Value: boolean);
		published
			property SaveHistory: boolean read FSaveHistory write SetSaveHistory; // Сохранять ли историю вообще
			property SaveInternal: boolean read FSaveInternal write SetSaveInternal; // Сохранять ли внутренние команды
			property SaveParamInternal: boolean read FSaveParamInternal write SetSaveParamInternal; // Сохранять ли внутренние команды с параметрами
			property SaveAlias: boolean read FSaveAlias write SetSaveAlias; // Сохранять ли названия алиасов
			property SaveParamAlias: boolean read FSaveParamAlias write SetSaveParamAlias; // Сохранять ли названия алиасов с параметрами
			property SaveSysAlias: boolean read FSaveSysAlias write SetSaveSysAlias; // Сохранять ли названия системных алиасов
			property SaveSysParamAlias: boolean read FSaveSysParamAlias write SetSaveSysParamAlias; // Сохранять ли названия системных алиасов с параметрами
			property SaveWWW: boolean read FSaveWWW write SetSaveWWW; // Сохранять ли адреса интернета
			property SaveEMail: boolean read FSaveEMail write SetSaveEMail; // Сохранять ли адреса почты
			property SavePath: boolean read FSavePath write SetSavePath; // Сохранять ли пути к папкам
			property SavePlugins: boolean read FSavePlugins write SetSavePlugins; // Сохранять ли плагины
			property SaveParamPlugins: boolean read FSaveParamPlugins write SetSaveParamPlugins; // Сохранять ли плагины с параметрами
			property SaveUnknown: boolean read FSaveUnknown write SetSaveUnknown; // Сохранять ли все остальное, запущенное с консоли
			property SaveCommandLine: boolean read FSaveCommandLine write SetSaveCommandLine; // Сохранять строки, переданные из коммандной строки
			property SaveMessage: boolean read FSaveMessage write SetSaveMessage; // Сохранять строки, переданные сообщением WM_CopyData окну консоли
			property MaxHistory: integer read FMaxHistory write SetMaxHistory; // Максимальное число записей в истории
			property InvertScroll: boolean read FInvertScroll write SetInvertScroll; // Инвертировать направление прокрутки истории
	end;

	// Класс настроек - Path
	TSettingsPath = class(TObject)
		private
			FShell: string;
			FShellNoClose: string;
			FBrowser: string;
			FShellClose: string;
			FFM: string;
			procedure SetBrowser(const Value: string);
			procedure SetFM(const Value: string);
			procedure SetShell(const Value: string);
			procedure SetShellClose(const Value: string);
			procedure SetShellNoClose(const Value: string);
		published
			property Browser: string read FBrowser write SetBrowser; // Путь к интернет-браузеру
			property FM: string read FFM write SetFM; // Путь к файл-менеджеру
			property Shell: string read FShell write SetShell; // Путь к shell
			property ShellClose: string read FShellClose write SetShellClose; // Параметр к шеллу - выполнить и закрыть окно
			property ShellNoClose: string read FShellNoClose write SetShellNoClose; // Параметр к шеллу - выполнить и оставить окно
	end;
	
	// Класс настроек - Resisty
	TSettingsRegistry = class(TObject)
		private
		FShellInt: boolean;
		FAutoRun: integer;
    FMultiUser: boolean;
    FMultiUserMayChange: boolean;
    FAutoRunMayChange: integer;
    FShellIntMayChange: boolean;
		procedure SetAutoRun(const Value: integer);
		procedure SetShellInt(const Value: boolean);
    procedure SetMultiUser(const Value: boolean);
    procedure SetMultiUserMayChange(const Value: boolean);
    procedure SetAutoRunMayChange(const Value: integer);
    procedure SetShellIntMayChange(const Value: boolean);
		published
			property AutoRun: integer read FAutoRun write SetAutoRun; // Запускать программу вместе с Windows
			property AutoRunMayChange: integer read FAutoRunMayChange write SetAutoRunMayChange; // Можно изменить?
			property ShellInt: boolean read FShellInt write SetShellInt; // Добавлять в контекстное меню меня
			property ShellIntMayChange: boolean read FShellIntMayChange write SetShellIntMayChange; // Можно изменить?
			property MultiUser: boolean read FMultiUser write SetMultiUser; // Использовать мультиюзерные конфиги
			property MultiUserMayChange: boolean read FMultiUserMayChange write SetMultiUserMayChange; // Можно изменить?
	end;

	// Класс настроек - Language
	TSettingsLanguage = class(TObject)
		LangStr: TStringList; // Строки из языкового ресурса
		private
    	FLanguage: string;
			procedure SetLanguage(const Value: string);
		public
			constructor Create; // Конструктор
			destructor Destroy; override; // Деструктор
			procedure ReadLanguages; // Считывает язык из файла
		published
			property Language: string read FLanguage write SetLanguage; // Язык программы
	end;

	// Класс настроек - Undo
	TSettingsUndo = class(TObject)
		private
			FUseUndo: boolean;
			procedure SetUseUndo(const Value: boolean);
		published
			property UseUndo: boolean read FUseUndo write SetUseUndo; // Использовать ли функцию отмены
	end;

	// Класс настроек - Sound
	TSettingsSound = class(TObject)
		ListSounds: TStringList;
		private
			FEnableSounds: boolean;
			FExecuteAliasSound: string;
			FExecuteSysAliasSound: string;
			FExecuteURLSound: string;
			FExecutePluginSound: string;
			FExecuteEmailSound: string;
			FExecuteFolderSound: string;
			FExecuteFileSound: string;
			FExecuteShellSound: string;
    FExecuteInternalSound: string;
			procedure SetEnableSounds(const Value: boolean);
			procedure SetExecuteAliasSound(const Value: string);
			procedure SetExecuteSysAliasSound(const Value: string);
			procedure SetExecuteURLSound(const Value: string);
			procedure SetExecuteEmailSound(const Value: string);
			procedure SetExecuteFileSound(const Value: string);
			procedure SetExecuteFolderSound(const Value: string);
			procedure SetExecutePluginSound(const Value: string);
			procedure SetExecuteShellSound(const Value: string);
    procedure SetExecuteInternalSound(const Value: string);
		public
			constructor Create; // Конструктор
			destructor Destroy; override; // Деструктор
		published
			property EnableSounds: boolean read FEnableSounds write SetEnableSounds; // Включены ли в программе звуки
			property ExecuteInternalSound: string read FExecuteInternalSound write SetExecuteInternalSound; // Звук по запуску внутренней команды
			property ExecuteAliasSound: string read FExecuteAliasSound write SetExecuteAliasSound; // Звук по запуску алиаса
			property ExecuteSysAliasSound: string read FExecuteSysAliasSound write SetExecuteSysAliasSound; // Звук по запуску системного алиаса
			property ExecuteURLSound: string read FExecuteURLSound write SetExecuteURLSound; // Звук по запуску адреса интернета
			property ExecuteEmailSound: string read FExecuteEmailSound write SetExecuteEmailSound; // Звук по запуску адреса почты
			property ExecuteFolderSound: string read FExecuteFolderSound write SetExecuteFolderSound; // Звук по запуску папки
			property ExecuteFileSound: string read FExecuteFileSound write SetExecuteFileSound; // Звук по запуску файла
			property ExecutePluginSound: string read FExecutePluginSound write SetExecutePluginSound; // Звук по запуску плагина
			property ExecuteShellSound: string read FExecuteShellSound write SetExecuteShellSound; // Звук по запуску всего остального
	end;

	// Класс настроек - Config
	TSettingsConfig = class(TObject)
		private
			FAutoSort: boolean;
			FMoveTop: boolean;
			FCDA_Startup: boolean;
			FCDA_CreateOldFile: boolean;
			FCDA_SearchFile: boolean;
			FRereadHotKey: boolean;
			FCDA_Confirmation: boolean;
			FCDA_SearchPlugins: boolean;
			FAutoReread: boolean;
			FAutoRereadValue: integer;
			procedure SetAutoReread(const Value: boolean);
			procedure SetAutoRereadValue(const Value: integer);
			procedure SetAutoSort(const Value: boolean);
			procedure SetCDA_Confirmation(const Value: boolean);
			procedure SetCDA_CreateOldFile(const Value: boolean);
			procedure SetCDA_SearchFile(const Value: boolean);
			procedure SetCDA_SearchPlugins(const Value: boolean);
			procedure SetCDA_Startup(const Value: boolean);
			procedure SetMoveTop(const Value: boolean);
			procedure SetRereadHotKey(const Value: boolean);
		published
			property MoveTop: boolean read FMoveTop write SetMoveTop; // Кидать ли запущенный алиас вверх конфига
			property AutoSort: boolean read FAutoSort write SetAutoSort; // Автоматическая сортировка конфига
			property AutoReread: boolean read FAutoReread write SetAutoReread; // Автоматически перечитывать конфиг с алиасами
			property AutoRereadValue: integer read FAutoRereadValue write SetAutoRereadValue; // Интервал перечитывания в миллисекундах
			property RereadHotKey: boolean read FRereadHotKey write SetRereadHotKey; // Перечитывать ли конфиг при каждом нажатии хоткея
			property CDA_CreateOldFile: boolean read FCDA_CreateOldFile write SetCDA_CreateOldFile; // Создавать старый файл с мертвыми алиасами
			property CDA_Confirmation: boolean read FCDA_Confirmation write SetCDA_Confirmation; // Спрашивать при убийстве каждого алиаса
			property CDA_SearchFile: boolean read FCDA_SearchFile write SetCDA_SearchFile; // Можно ли искать файл на том-же диске
			property CDA_SearchPlugins: boolean read FCDA_SearchPlugins write SetCDA_SearchPlugins; // Можно ли искать алиас в плагинах
			property CDA_Startup: boolean read FCDA_Startup write SetCDA_Startup; // Удалять мертвые алиасы при каждом запуске программы
	end;

	// Класс настроек - Coordinates
	TSettingsCoordinates = class(TObject)
		private
			FSettingsY: integer;
			FSettingsX: integer;
			procedure SetSettingsX(const Value: integer);
			procedure SetSettingsY(const Value: integer);
		published
			property SettingsX: integer read FSettingsX write SetSettingsX; // Координаты формы настроек
			property SettingsY: integer read FSettingsY write SetSettingsY; // Координаты формы настроек
	end;

	// Класс работы с системными алиасами
	TSystemAlias = class(TObject)
		private
			FAction: TStringList;
			FName: TStringList;
			FPath: TStringList;
			procedure SetAction(const Value: TStringList);
			procedure SetName(const Value: TStringList);
			procedure SetPath(const Value: TStringList);
		public
			constructor Create; // Конструктор
			destructor Destroy; override; // Деструктор
			procedure ReadSystemAliases; // Читает алиасы из реестра
		published
			property Name: TStringList read FName write SetName; // Имя системного алиаса
			property Action: TStringList read FAction write SetAction; // Действие системного алиаса
			property Path: TStringList read FPath write SetPath; // Путь к системному алиасу
	end;

	// Класс работы с настройками
	TSettings = class(TObject)
		Show: TSettingsShow;
		Hint: TSettingsHint;
		DownDrop: TSettingsDownDrop;
		Color: array[0..2] of TSettingsColor;
		Hotkey: TSettingsHotkey;
		Font: TSettingsFont;
		EasyType: TSettingsType;
		Exec: TSettingsExec;
		History: TSettingsHistory;
		Path: TSettingsPath;
    Registry: TSettingsRegistry;
		Language: TSettingsLanguage;
		Undo: TSettingsUndo;
    Sounds: TSettingsSound;
		Config: TSettingsConfig;
		Coordinates: TSettingsCoordinates;
		SystemAliases: TSystemAlias;
		private
			FFileName: string;
			procedure SetFileName(const Value: string);
		public
			constructor Create; // Конструктор
			destructor Destroy; override; // Деструктор
			procedure ReadSettings; // Считывает настройки из файла
			procedure SaveSettings; // Сохраняет настройки в файл
			procedure ReadRegSettings; // Считывает настройки из реестра
			procedure SaveRegSettings; // Сохраняет настройки в реестр
		published
			property FileName: string read FFileName write SetFileName; // Имя файла настроек
	end;

var
	Options: TSettings;

implementation

uses frmConsoleUnit, frmSettingsUnit, frmAboutUnit;

{ TSettingsColor }

procedure TSettingsColor.SetBorder(const Value: TColor);
begin
	FBorder := Value;
end;

procedure TSettingsColor.SetConsole(const Value: TColor);
begin
  FConsole := Value;
end;

procedure TSettingsColor.SetDropDownBorder(const Value: TColor);
begin
  FDropDownBorder := Value;
end;

procedure TSettingsColor.SetDropDownColor(const Value: TColor);
begin
  FDropDownColor := Value;
end;

procedure TSettingsColor.SetDropDownText(const Value: TColor);
begin
  FDropDownText := Value;
end;

procedure TSettingsColor.SetHintBorder(const Value: TColor);
begin
  FHintBorder := Value;
end;

procedure TSettingsColor.SetHintColor(const Value: TColor);
begin
  FHintColor := Value;
end;

procedure TSettingsColor.SetHintText(const Value: TColor);
begin
  FHintText := Value;
end;

procedure TSettingsColor.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TSettingsColor.SetText(const Value: TColor);
begin
  FText := Value;
end;

{ TSettingsShow }

procedure TSettingsShow.SetAutoHide(const Value: boolean);
begin
	FAutoHide := Value;
end;

procedure TSettingsShow.SetAutoHideValue(const Value: integer);
begin
  FAutoHideValue := Value;
end;

procedure TSettingsShow.SetBalloonTips(const Value: boolean);
begin
  FBalloonTips := Value;
end;

procedure TSettingsShow.SetBorderSize(const Value: integer);
begin
  FBorderSize := Value;
end;

procedure TSettingsShow.SetCenterScreenX(const Value: boolean);
begin
  FCenterScreenX := Value;
end;

procedure TSettingsShow.SetCenterScreenY(const Value: boolean);
begin
  FCenterScreenY := Value;
end;

procedure TSettingsShow.SetConsoleHeight(const Value: integer);
begin
  FConsoleHeight := Value;
end;

procedure TSettingsShow.SetConsoleWidth(const Value: integer);
begin
  FConsoleWidth := Value;
end;

procedure TSettingsShow.SetConsoleWidthPercent(const Value: boolean);
begin
  FConsoleWidthPercent := Value;
end;

procedure TSettingsShow.SetConsoleX(const Value: integer);
begin
  FConsoleX := Value;
end;

procedure TSettingsShow.SetConsoleY(const Value: integer);
begin
  FConsoleY := Value;
end;

procedure TSettingsShow.SetDestroyForm(const Value: boolean);
begin
  FDestroyForm := Value;
end;

procedure TSettingsShow.SetHideConsole(const Value: boolean);
begin
  FHideConsole := Value;
end;

procedure TSettingsShow.SetPriority(const Value: integer);
begin
  FPriority := Value;
end;

procedure TSettingsShow.SetPutMouseIntoConsole(const Value: boolean);
begin
  FPutMouseIntoConsole := Value;
end;

procedure TSettingsShow.SetShowConsoleOnStart(const Value: boolean);
begin
  FShowConsoleOnStart := Value;
end;

procedure TSettingsShow.SetTransparent(const Value: integer);
begin
  FTransparent := Value;
end;

procedure TSettingsShow.SetTrayIcon(const Value: boolean);
begin
  FTrayIcon := Value;
end;

procedure TSettingsShow.SetTriggerShow(const Value: boolean);
begin
	FTriggerShow := Value;
end;

{ TSettingsHint }

procedure TSettingsHint.SetBorderSize(const Value: integer);
begin
  FBorderSize := Value;
end;

procedure TSettingsHint.SetDestroyForm(const Value: boolean);
begin
  FDestroyForm := Value;
end;

procedure TSettingsHint.SetShowHint(const Value: boolean);
begin
  FShowHint := Value;
end;

procedure TSettingsHint.SetTransparent(const Value: integer);
begin
  FTransparent := Value;
end;

{ TSettingsDowndrop }

procedure TSettingsDownDrop.SetBorderSize(const Value: integer);
begin
  FBorderSize := Value;
end;

procedure TSettingsDownDrop.SetDestroyForm(const Value: boolean);
begin
  FDestroyForm := Value;
end;

procedure TSettingsDownDrop.SetLineNum(const Value: integer);
begin
	FLineNum := Value;
end;

procedure TSettingsDownDrop.SetTransparent(const Value: integer);
begin
  FTransparent := Value;
end;

{ TSettingsHotkey }

procedure TSettingsHotkey.SetAltKey(const Value: boolean);
begin
	FAltKey := Value;
end;

procedure TSettingsHotkey.SetCtrlKey(const Value: boolean);
begin
  FCtrlKey := Value;
end;

procedure TSettingsHotkey.SetKey(const Value: cardinal);
begin
  FKey := Value;
end;

procedure TSettingsHotkey.SetShiftKey(const Value: boolean);
begin
  FShiftKey := Value;
end;

procedure TSettingsHotkey.SetWinKey(const Value: boolean);
begin
  FWinKey := Value;
end;

{ TSettingsFont }

procedure TSettingsFont.SetAlign(const Value: integer);
begin
	FAlign := Value;
end;

procedure TSettingsFont.SetApplyEnglish(const Value: boolean);
begin
  FApplyEnglish := Value;
end;

procedure TSettingsFont.SetAutoSize(const Value: boolean);
begin
  FAutoSize := Value;
end;

procedure TSettingsFont.SetBold(const Value: boolean);
begin
  FBold := Value;
end;

procedure TSettingsFont.SetItalic(const Value: boolean);
begin
  FItalic := Value;
end;

procedure TSettingsFont.SetLockEnglish(const Value: boolean);
begin
  FLockEnglish := Value;
end;

procedure TSettingsFont.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TSettingsFont.SetSize(const Value: integer);
begin
  FSize := Value;
end;

procedure TSettingsFont.SetStrikeOut(const Value: boolean);
begin
	FStrikeOut := Value;
end;

procedure TSettingsFont.SetUnderLine(const Value: boolean);
begin
  FUnderLine := Value;
end;

{ TSettingsType }

procedure TSettingsType.SetAdvancedBackspace(const Value: boolean);
begin
	FAdvancedBackspace := Value;
end;

procedure TSettingsType.SetAdvancedSpace(const Value: boolean);
begin
  FAdvancedSpace := Value;
end;

procedure TSettingsType.SetAlias(const Value: boolean);
begin
  FAlias := Value;
end;

procedure TSettingsType.SetCaseSensitivity(const Value: boolean);
begin
  FCaseSensitivity := Value;
end;

procedure TSettingsType.SetDeleteDuplicates(const Value: boolean);
begin
	FDeleteDuplicates := Value;
end;

procedure TSettingsType.SetEasyType(const Value: integer);
begin
  FEasyType := Value;
end;

procedure TSettingsType.SetEnableET(const Value: boolean);
begin
  FEnableET := Value;
end;

procedure TSettingsType.SetHistory(const Value: boolean);
begin
  FHistory := Value;
end;

procedure TSettingsType.SetInternal(const Value: boolean);
begin
  FInternal := Value;
end;

procedure TSettingsType.SetPath(const Value: boolean);
begin
  FPath := Value;
end;

procedure TSettingsType.SetPlugins(const Value: boolean);
begin
  FPlugins := Value;
end;

procedure TSettingsType.SetSpace(const Value: boolean);
begin
  FSpace := Value;
end;

procedure TSettingsType.SetSysAlias(const Value: boolean);
begin
  FSysAlias := Value;
end;

{ TSettingsExec }

procedure TSettingsExec.SetAlias(const Value: boolean);
begin
	FAlias := Value;
end;

procedure TSettingsExec.SetDefaultAction(const Value: boolean);
begin
  FDefaultAction := Value;
end;

procedure TSettingsExec.SetEMail(const Value: boolean);
begin
  FEMail := Value;
end;

procedure TSettingsExec.SetFiles(const Value: boolean);
begin
  FFiles := Value;
end;

procedure TSettingsExec.SetFolders(const Value: boolean);
begin
  FFolders := Value;
end;

procedure TSettingsExec.SetInternal(const Value: boolean);
begin
  FInternal := Value;
end;

procedure TSettingsExec.SetPlugins(const Value: boolean);
begin
  FPlugins := Value;
end;

procedure TSettingsExec.SetShell(const Value: boolean);
begin
  FShell := Value;
end;

procedure TSettingsExec.SetSysAlias(const Value: boolean);
begin
  FSysAlias := Value;
end;

procedure TSettingsExec.SetWWW(const Value: boolean);
begin
  FWWW := Value;
end;

{ TSettingsPath }

procedure TSettingsPath.SetBrowser(const Value: string);
begin
  FBrowser := Value;
end;

procedure TSettingsPath.SetFM(const Value: string);
begin
  FFM := Value;
end;

procedure TSettingsPath.SetShell(const Value: string);
begin
  FShell := Value;
end;

procedure TSettingsPath.SetShellClose(const Value: string);
begin
  FShellClose := Value;
end;

procedure TSettingsPath.SetShellNoClose(const Value: string);
begin
  FShellNoClose := Value;
end;

{ TSettingsHistory }

procedure TSettingsHistory.SetInvertScroll(const Value: boolean);
begin
	FInvertScroll := Value;
end;

procedure TSettingsHistory.SetMaxHistory(const Value: integer);
begin
  FMaxHistory := Value;
end;

procedure TSettingsHistory.SetSaveAlias(const Value: boolean);
begin
  FSaveAlias := Value;
end;

procedure TSettingsHistory.SetSaveCommandLine(const Value: boolean);
begin
  FSaveCommandLine := Value;
end;

procedure TSettingsHistory.SetSaveEMail(const Value: boolean);
begin
  FSaveEMail := Value;
end;

procedure TSettingsHistory.SetSaveHistory(const Value: boolean);
begin
  FSaveHistory := Value;
end;

procedure TSettingsHistory.SetSaveInternal(const Value: boolean);
begin
  FSaveInternal := Value;
end;

procedure TSettingsHistory.SetSaveMessage(const Value: boolean);
begin
  FSaveMessage := Value;
end;

procedure TSettingsHistory.SetSaveParamAlias(const Value: boolean);
begin
  FSaveParamAlias := Value;
end;

procedure TSettingsHistory.SetSaveParamInternal(const Value: boolean);
begin
  FSaveParamInternal := Value;
end;

procedure TSettingsHistory.SetSaveParamPlugins(const Value: boolean);
begin
  FSaveParamPlugins := Value;
end;

procedure TSettingsHistory.SetSavePath(const Value: boolean);
begin
  FSavePath := Value;
end;

procedure TSettingsHistory.SetSavePlugins(const Value: boolean);
begin
  FSavePlugins := Value;
end;

procedure TSettingsHistory.SetSaveSysAlias(const Value: boolean);
begin
  FSaveSysAlias := Value;
end;

procedure TSettingsHistory.SetSaveSysParamAlias(const Value: boolean);
begin
  FSaveSysParamAlias := Value;
end;

procedure TSettingsHistory.SetSaveUnknown(const Value: boolean);
begin
  FSaveUnknown := Value;
end;

procedure TSettingsHistory.SetSaveWWW(const Value: boolean);
begin
  FSaveWWW := Value;
end;

{ TSettingsRegistry }

procedure TSettingsRegistry.SetAutoRun(const Value: integer);
begin
	FAutoRun := Value;
end;

procedure TSettingsRegistry.SetAutoRunMayChange(const Value: integer);
begin
  FAutoRunMayChange := Value;
end;

procedure TSettingsRegistry.SetMultiUser(const Value: boolean);
begin
	FMultiUser := Value;
end;

procedure TSettingsRegistry.SetMultiUserMayChange(const Value: boolean);
begin
  FMultiUserMayChange := Value;
end;

procedure TSettingsRegistry.SetShellInt(const Value: boolean);
begin
	FShellInt := Value;
end;

procedure TSettingsRegistry.SetShellIntMayChange(const Value: boolean);
begin
  FShellIntMayChange := Value;
end;

{ TSettingsLanguage }

constructor TSettingsLanguage.Create;
begin
	LangStr:=TStringList.Create;
	inherited;
end;

destructor TSettingsLanguage.Destroy;
begin
	LangStr.Free;
	inherited;
end;

procedure TSettingsLanguage.ReadLanguages;
begin
	if not FileExists(GetMyPath+'Lang\' + Language + '.lng') then
		if not FileExists(GetMyPath+'Lang\English.lng') then
			Exit
		else
			LangStr.LoadFromFile(GetMyPath+'Lang\English.lng')
	else
		LangStr.LoadFromFile(GetMyPath+'Lang\' + Language + '.lng');
end;

procedure TSettingsLanguage.SetLanguage(const Value: string);
begin
	FLanguage := Value;
end;

{ TSettingsUndo }

procedure TSettingsUndo.SetUseUndo(const Value: boolean);
begin
	FUseUndo := Value;
end;

{ TSettingsConfig }

procedure TSettingsConfig.SetAutoReread(const Value: boolean);
begin
  FAutoReread := Value;
end;

procedure TSettingsConfig.SetAutoRereadValue(const Value: integer);
begin
  FAutoRereadValue := Value;
end;

procedure TSettingsConfig.SetAutoSort(const Value: boolean);
begin
  FAutoSort := Value;
end;

procedure TSettingsConfig.SetCDA_Confirmation(const Value: boolean);
begin
  FCDA_Confirmation := Value;
end;

procedure TSettingsConfig.SetCDA_CreateOldFile(const Value: boolean);
begin
  FCDA_CreateOldFile := Value;
end;

procedure TSettingsConfig.SetCDA_SearchFile(const Value: boolean);
begin
  FCDA_SearchFile := Value;
end;

procedure TSettingsConfig.SetCDA_SearchPlugins(const Value: boolean);
begin
  FCDA_SearchPlugins := Value;
end;

procedure TSettingsConfig.SetCDA_Startup(const Value: boolean);
begin
  FCDA_Startup := Value;
end;

procedure TSettingsConfig.SetMoveTop(const Value: boolean);
begin
  FMoveTop := Value;
end;

procedure TSettingsConfig.SetRereadHotKey(const Value: boolean);
begin
	FRereadHotKey := Value;
end;

{ TSettingsCoordinates }

procedure TSettingsCoordinates.SetSettingsX(const Value: integer);
begin
	FSettingsX := Value;
end;

procedure TSettingsCoordinates.SetSettingsY(const Value: integer);
begin
	FSettingsY := Value;
end;

{ TSettings }

constructor TSettings.Create;
var
	i: integer;
begin
	Show:=TSettingsShow.Create;
	Hint:=TSettingsHint.Create;
	DownDrop:=TSettingsDownDrop.Create;
	for i:=0 to High(Color) do
		Color[i]:=TSettingsColor.Create;
	Hotkey:=TSettingsHotkey.Create;
	Font:=TSettingsFont.Create;
	EasyType:=TSettingsType.Create;
	Exec:=TSettingsExec.Create;
	History:=TSettingsHistory.Create;
	Path:=TSettingsPath.Create;
	Registry:=TSettingsRegistry.Create;
	Language:=TSettingsLanguage.Create;
	Undo:=TSettingsUndo.Create;
  Sounds:=TSettingsSound.Create;
	Config:=TSettingsConfig.Create;
	Coordinates:=TSettingsCoordinates.Create;
  SystemAliases:=TSystemAlias.Create;
	inherited;
end;

destructor TSettings.Destroy;
var
	i: integer;
begin
	Show.Free;
	Hint.Free;
	DownDrop.Free;
	for i:=0 to High(Color) do
		Color[i].Free;
	Hotkey.Free;
	Font.Free;
	EasyType.Free;
	Exec.Free;
	History.Free;
	Path.Free;
	Registry.Free;
	Language.Free;
	Undo.Free;
  Sounds.Free;
	Config.Free;
	Coordinates.Free;
  SystemAliases.Free;
	inherited;
end;

procedure TSettings.ReadSettings;
var
	IniFile: TMemIniFile;
procedure LoadColor(num: integer; str: string);
begin
	Color[num].Text:=IniFile.ReadInteger('Color', 'FontColor' + str, 16777088);
	Color[num].Console:=IniFile.ReadInteger('Color', 'BackColor' + str, 5832704);
	Color[num].Border:=IniFile.ReadInteger('Color', 'BorderColor' + str, 12615680);
	Color[num].HintText:=IniFile.ReadInteger('Color', 'HintTextColor' + str, 16777088);
	Color[num].HintColor:=IniFile.ReadInteger('Color', 'HintColor' + str, 5832704);
	Color[num].HintBorder:=IniFile.ReadInteger('Color', 'HintBorderColor' + str, 12615680);
	Color[num].DropDownText:=IniFile.ReadInteger('Color', 'DropDownTextColor' + str, 16777088);
	Color[num].DropDownColor:=IniFile.ReadInteger('Color', 'DropDownColor' + str, 5832704);
	Color[num].DropDownBorder:=IniFile.ReadInteger('Color', 'DropDownBorderColor' + str, 12615680);
end;
begin
	IniFile:=TMemIniFile.Create(FileName);

	Show.ShowConsoleOnStart:=IniFile.ReadBool('Show', 'ShowConsoleOnStart', True);
	Show.HideConsole:=IniFile.ReadBool('Show', 'HideConsole', True);
	Show.TriggerShow:=IniFile.ReadBool('Show', 'TriggerShow', False);
	Show.CenterScreenX:=IniFile.ReadBool('Show', 'CenterScreenX', True);
	Show.CenterScreenY:=IniFile.ReadBool('Show', 'CenterScreenY', True);
	Show.ConsoleX:=IniFile.ReadInteger('Show', 'ConsoleX', 0);
	Show.ConsoleY:=IniFile.ReadInteger('Show', 'ConsoleY', 0);
	Show.ConsoleHeight:=IniFile.ReadInteger('Show', 'ConsoleHeight', 19);
	Show.ConsoleWidth:=IniFile.ReadInteger('Show', 'ConsoleWidth', 50);
	Show.ConsoleWidthPercent:=IniFile.ReadBool('Show', 'ConsoleWidthPercent', True);
	Show.Transparent:=IniFile.ReadInteger('Show', 'Transparent', 180);
	Show.DestroyForm:=IniFile.ReadBool('Show', 'DestroyForm', False);
	Show.BorderSize:=IniFile.ReadInteger('Show', 'BorderSize', 1);
	Show.TrayIcon:=IniFile.ReadBool('Show', 'TrayIcon', True);
	Show.AutoHide:=IniFile.ReadBool('Show', 'AutoHide', False);
	Show.AutoHideValue:=IniFile.ReadInteger('Show', 'AutoHideValue', 1);
	Show.Priority:=IniFile.ReadInteger('Show', 'Priority', 1);
	Show.BalloonTips:=IniFile.ReadBool('Show', 'Balloon', True);
	Show.PutMouseIntoConsole:=IniFile.ReadBool('Show', 'PutMouseIntoConsole', False);

	Hint.ShowHint:=IniFile.ReadBool('Hint', 'ShowHint', True);
	Hint.Transparent:=IniFile.ReadInteger('Hint', 'Transparent', 255);
	Hint.DestroyForm:=IniFile.ReadBool('Hint', 'DestroyForm', False);
	Hint.BorderSize:=IniFile.ReadInteger('Hint', 'BorderSize', 1);

	DownDrop.LineNum:=IniFile.ReadInteger('DropDown', 'LineNum', 10);
	DownDrop.Transparent:=IniFile.ReadInteger('DropDown', 'Transparent', 180);
	DownDrop.DestroyForm:=IniFile.ReadBool('DropDown', 'DestroyForm', False);
	DownDrop.BorderSize:=IniFile.ReadInteger('DropDown', 'BorderSize', 1);

	Color[0].Text:=IniFile.ReadInteger('Color', 'FontColorNoET', 0);
	Color[0].Console:=IniFile.ReadInteger('Color', 'BackColorNoET', 65280);
	Color[0].Border:=IniFile.ReadInteger('Color', 'BorderColorNoET', 255);
	Color[0].HintText:=IniFile.ReadInteger('Color', 'HintTextColorNoET', 65280);
	Color[0].HintColor:=IniFile.ReadInteger('Color', 'HintColorNoET', 0);
	Color[0].HintBorder:=IniFile.ReadInteger('Color', 'HintBorderColorNoET', 255);
	Color[0].DropDownText:=IniFile.ReadInteger('Color', 'DropDownTextColorNoET', 65280);
	Color[0].DropDownColor:=IniFile.ReadInteger('Color', 'DropDownColorNoET', 0);
	Color[0].DropDownBorder:=IniFile.ReadInteger('Color', 'DropDownBorderColorNoET', 255);
	LoadColor(1, '');
	LoadColor(2, 'Linux');
	{Color[1].Text:=IniFile.ReadInteger('Color', 'FontColor', 16777088);
	Color[1].Console:=IniFile.ReadInteger('Color', 'BackColor', 5832704);
	Color[1].Border:=IniFile.ReadInteger('Color', 'BorderColor', 12615680);
	Color[1].HintText:=IniFile.ReadInteger('Color', 'HintTextColor', 16777088);
	Color[1].HintColor:=IniFile.ReadInteger('Color', 'HintColor', 5832704);
	Color[1].HintBorder:=IniFile.ReadInteger('Color', 'HintBorderColor', 12615680);
	Color[1].DropDownText:=IniFile.ReadInteger('Color', 'DropDownTextColor', 16777088);
	Color[1].DropDownColor:=IniFile.ReadInteger('Color', 'DropDownColor', 5832704);
	Color[1].DropDownBorder:=IniFile.ReadInteger('Color', 'DropDownBorderColor', 12615680);
	Color[2].Text:=IniFile.ReadInteger('Color', 'FontColorLinux', 16777088);
	Color[2].Console:=IniFile.ReadInteger('Color', 'BackColorLinux', 5832704);
	Color[2].Border:=IniFile.ReadInteger('Color', 'BorderColorLinux', 12615680);
	Color[2].HintText:=IniFile.ReadInteger('Color', 'HintTextColorLinux', 16777088);
	Color[2].HintColor:=IniFile.ReadInteger('Color', 'HintColorLinux', 5832704);
	Color[2].HintBorder:=IniFile.ReadInteger('Color', 'HintBorderColorLinux', 12615680);
	Color[2].DropDownText:=IniFile.ReadInteger('Color', 'DropDownTextColorLinux', 16777088);
	Color[2].DropDownColor:=IniFile.ReadInteger('Color', 'DropDownColorLinux', 5832704);
	Color[2].DropDownBorder:=IniFile.ReadInteger('Color', 'DropDownBorderColorLinux', 12615680);}

	Hotkey.Key:=IniFile.ReadInteger('HotKey', 'Key', 145);
	Hotkey.WinKey:=IniFile.ReadBool('HotKey', 'WinKey', False);
	Hotkey.CtrlKey:=IniFile.ReadBool('HotKey', 'CtrlKey', False);
	Hotkey.AltKey:=IniFile.ReadBool('HotKey', 'AltKey', False);
	Hotkey.ShiftKey:=IniFile.ReadBool('HotKey', 'ShiftKey', False);

	Font.Name:=IniFile.ReadString('Font', 'Name', 'Courier New');
	Font.Size:=IniFile.ReadInteger('Font', 'Size', 11);
	Font.AutoSize:=IniFile.ReadBool('Font', 'AutoSize', True);
	Font.Bold:=IniFile.ReadBool('Font', 'Bold', True);
	Font.Italic:=IniFile.ReadBool('Font', 'Italic', False);
	Font.StrikeOut:=IniFile.ReadBool('Font', 'StrikeOut', False);
	Font.UnderLine:=IniFile.ReadBool('Font', 'UnderLine', False);
	Font.Align:=IniFile.ReadInteger('Font', 'Alignment', 0);
	Font.ApplyEnglish:=IniFile.ReadBool('Font', 'ApplyEnglish', False);
	Font.LockEnglish:=IniFile.ReadBool('Font', 'LockEnglish', False);

	EasyType.EasyType:=IniFile.ReadInteger('Type', 'EasyType', 1);
	EasyType.Internal:=IniFile.ReadBool('Type', 'Internal', True);
	EasyType.Alias:=IniFile.ReadBool('Type', 'Alias', True);
	EasyType.SysAlias:=IniFile.ReadBool('Type', 'SysAlias', True);
	EasyType.Path:=IniFile.ReadBool('Type', 'Path', True);
	EasyType.Plugins:=IniFile.ReadBool('Type', 'Plugins', True);
	EasyType.History:=IniFile.ReadBool('Type', 'History', True);
  EasyType.CaseSensitivity:=IniFile.ReadBool('Type', 'Case', False);
	EasyType.Space:=IniFile.ReadBool('Type', 'Space', False);
	EasyType.EnableET:=IniFile.ReadBool('Type', 'EnableET', True);
	EasyType.AdvancedBackspace:=IniFile.ReadBool('Type', 'AdvancedBackspace', True);
	EasyType.AdvancedSpace:=IniFile.ReadBool('Type', 'AdvancedSpace', True);
	EasyType.DeleteDuplicates:=IniFile.ReadBool('Type', 'DeleteDuplicates', False);

	Exec.Internal:=IniFile.ReadBool('Exec', 'Internal', True);
	Exec.Alias:=IniFile.ReadBool('Exec', 'Alias', True);
	Exec.SysAlias:=IniFile.ReadBool('Exec', 'SysAlias', True);
	Exec.WWW:=IniFile.ReadBool('Exec', 'WWW', True);
	Exec.EMail:=IniFile.ReadBool('Exec', 'EMail', True);
	Exec.Folders:=IniFile.ReadBool('Exec', 'Folder', True);
	Exec.Files:=IniFile.ReadBool('Exec', 'File', True);
	Exec.Plugins:=IniFile.ReadBool('Exec', 'Plugins', True);
	Exec.Shell:=IniFile.ReadBool('Exec', 'Shell', True);
	Exec.DefaultAction:=IniFile.ReadBool('Exec', 'DefaultAction', False);

	Path.Browser:=IniFile.ReadString('Path', 'Browser', '"c:\Program Files\Internet Explorer\IEXPLORE.EXE"');
	Path.FM:=IniFile.ReadString('Path', 'FileManager', 'explorer.exe');
  if Pos('NT', GetWinVersion)<>0 then
		Path.Shell:=IniFile.ReadString('Path', 'Shell', 'cmd.exe')
	else
		Path.Shell:=IniFile.ReadString('Path', 'Shell', 'command.com');
	Path.ShellClose:=IniFile.ReadString('Path', 'ShellClose', '/c %s');
	Path.ShellNoClose:=IniFile.ReadString('Path', 'ShellNoClose', '/k %s');

	History.SaveHistory:=IniFile.ReadBool('History', 'SaveHistory', True);
	History.SaveInternal:=IniFile.ReadBool('History', 'SaveInternal', False);
	History.SaveParamInternal:=IniFile.ReadBool('History', 'SaveParamInternal', True);
	History.SaveAlias:=IniFile.ReadBool('History', 'SaveAlias', False);
	History.SaveParamAlias:=IniFile.ReadBool('History', 'SaveParamAlias', True);
	History.SaveSysAlias:=IniFile.ReadBool('History', 'SaveSysAlias', False);
	History.SaveSysParamAlias:=IniFile.ReadBool('History', 'SaveSysParamAlias', True);
	History.SaveWWW:=IniFile.ReadBool('History', 'SaveWWW', True);
	History.SaveEMail:=IniFile.ReadBool('History', 'SaveEMail', True);
	History.SavePath:=IniFile.ReadBool('History', 'SavePath', False);
	History.SavePlugins:=IniFile.ReadBool('History', 'SavePlugins', True);
	History.SaveParamPlugins:=IniFile.ReadBool('History', 'SaveParamPlugins', True);
	History.SaveUnknown:=IniFile.ReadBool('History', 'SaveUnknown', True);
	History.SaveCommandLine:=IniFile.ReadBool('History', 'SaveCommandLine', False);
	History.SaveMessage:=IniFile.ReadBool('History', 'SaveMessage', False);
	History.MaxHistory:=IniFile.ReadInteger('History', 'MaxHistory', 0);
	History.InvertScroll:=IniFile.ReadBool('History', 'InvertScroll', False);

	Language.Language:=IniFile.ReadString('Language', 'Language', 'English');

	Undo.UseUndo:=IniFile.ReadBool('Undo', 'UseUndo', True);

	Sounds.EnableSounds:=IniFile.ReadBool('Sounds', 'EnableSounds', False);
	Sounds.ExecuteInternalSound:=IniFile.ReadString('Sounds', 'ExecuteInternal', '');
	Sounds.ExecuteAliasSound:=IniFile.ReadString('Sounds', 'ExecuteAlias', '');
	Sounds.ExecuteSysAliasSound:=IniFile.ReadString('Sounds', 'ExecuteSysAlias', '');
	Sounds.ExecuteURLSound:=IniFile.ReadString('Sounds', 'ExecuteURL', '');
	Sounds.ExecuteEmailSound:=IniFile.ReadString('Sounds', 'ExecuteEMail', '');
	Sounds.ExecuteFolderSound:=IniFile.ReadString('Sounds', 'ExecuteFolder', '');
	Sounds.ExecuteFileSound:=IniFile.ReadString('Sounds', 'ExecuteFile', '');
	Sounds.ExecutePluginSound:=IniFile.ReadString('Sounds', 'ExecutePlugin', '');
  Sounds.ExecuteShellSound:=IniFile.ReadString('Sounds', 'ExecuteAllOther', '');

	Config.MoveTop:=IniFile.ReadBool('Config', 'MoveTop', True);
	Config.AutoSort:=IniFile.ReadBool('Config', 'AutoSort', False);
	Config.AutoReread:=IniFile.ReadBool('Config', 'AutoReread', False);
	Config.AutoRereadValue:=IniFile.ReadInteger('Config', 'AutoRereadValue', 1000);
	Config.RereadHotKey:=IniFile.ReadBool('Config', 'RereadHotKey', False);
	Config.CDA_CreateOldFile:=IniFile.ReadBool('Config', 'CDA_CreateOldFile', True);
	Config.CDA_Confirmation:=IniFile.ReadBool('Config', 'CDA_Confirmation', False);
	Config.CDA_SearchFile:=IniFile.ReadBool('Config', 'CDA_SearchFile', False);
	Config.CDA_SearchPlugins:=IniFile.ReadBool('Config', 'CDA_SearchPlugins', True);
	Config.CDA_Startup:=IniFile.ReadBool('Config', 'CDA_Startup', True);

	Coordinates.SettingsX:=IniFile.ReadInteger('Coordinates', 'SettingsX', 100);
	Coordinates.SettingsY:=IniFile.ReadInteger('Coordinates', 'SettingsY', 100);

	IniFile.Free;
end;

procedure TSettings.SaveSettings;
var
	IniFile: TMemIniFile;
procedure SaveColor(num: integer; str: string);
begin
	IniFile.WriteInteger('Color', 'BackColor' + str, Color[num].Console);
	IniFile.WriteInteger('Color', 'FontColor' + str, Color[num].Text);
	IniFile.WriteInteger('Color', 'BorderColor' + str, Color[num].Border);
	IniFile.WriteInteger('Color', 'HintTextColor' + str, Color[num].HintText);
	IniFile.WriteInteger('Color', 'HintColor' + str, Color[num].HintColor);
	IniFile.WriteInteger('Color', 'HintBorderColor' + str, Color[num].HintBorder);
	IniFile.WriteInteger('Color', 'DropDownTextColor' + str, Color[num].DropDownText);
	IniFile.WriteInteger('Color', 'DropDownColor' + str, Color[num].DropDownColor);
	IniFile.WriteInteger('Color', 'DropDownBorderColor' + str, Color[num].DropDownBorder);
end;
begin
	IniFile:=TMemIniFile.Create(FileName);

	IniFile.WriteBool('Show', 'ShowConsoleOnStart', Show.ShowConsoleOnStart);
	IniFile.WriteBool('Show', 'HideConsole', Show.HideConsole);
	IniFile.WriteBool('Show', 'TriggerShow', Show.TriggerShow);
	IniFile.WriteBool('Show', 'CenterScreenX', Show.CenterScreenX);
	IniFile.WriteBool('Show', 'CenterScreenY', Show.CenterScreenY);
	IniFile.WriteInteger('Show', 'ConsoleX', Show.ConsoleX);
	IniFile.WriteInteger('Show', 'ConsoleY', Show.ConsoleY);
	IniFile.WriteInteger('Show', 'ConsoleHeight', Show.ConsoleHeight);
	IniFile.WriteInteger('Show', 'ConsoleWidth', Show.ConsoleWidth);
	IniFile.WriteBool('Show', 'ConsoleWidthPercent', Show.ConsoleWidthPercent);
	IniFile.WriteInteger('Show', 'Transparent', Show.Transparent);
	IniFile.WriteBool('Show', 'DestroyForm', Show.DestroyForm);
	IniFile.WriteInteger('Show', 'BorderSize', Show.BorderSize);
	IniFile.WriteBool('Show', 'TrayIcon', Show.TrayIcon);
	IniFile.WriteBool('Show', 'AutoHide', Show.AutoHide);
	IniFile.WriteInteger('Show', 'AutoHideValue', Show.AutoHideValue);
	IniFile.WriteInteger('Show', 'Priority', Show.Priority);
	IniFile.WriteBool('Show', 'Balloon', Show.BalloonTips);
	IniFile.WriteBool('Show', 'PutMouseIntoConsole', Show.PutMouseIntoConsole);

	IniFile.WriteBool('Hint', 'ShowHint', Hint.ShowHint);
	IniFile.WriteInteger('Hint', 'Transparent', Hint.Transparent);
	IniFile.WriteBool('Hint', 'DestroyForm', Hint.DestroyForm);
	IniFile.WriteInteger('Hint', 'BorderSize', Hint.BorderSize);

	IniFile.WriteInteger('DropDown', 'LineNum', DownDrop.LineNum);
	IniFile.WriteInteger('DropDown', 'Transparent', DownDrop.Transparent);
	IniFile.WriteBool('DropDown', 'DestroyForm', DownDrop.DestroyForm);
	IniFile.WriteInteger('DropDown', 'BorderSize', DownDrop.BorderSize);

	SaveColor(0, 'NoET');
	SaveColor(1, '');
	SaveColor(2, 'Linux');
	{IniFile.WriteInteger('Color', 'BackColorNoET', Color[0].Console);
	IniFile.WriteInteger('Color', 'FontColorNoET', Color[0].Text);
	IniFile.WriteInteger('Color', 'BorderColorNoET', Color[0].Border);
	IniFile.WriteInteger('Color', 'HintTextColorNoET', Color[0].HintText);
	IniFile.WriteInteger('Color', 'HintColorNoET', Color[0].HintColor);
	IniFile.WriteInteger('Color', 'DropDownTextColorNoET', Color[0].DropDownText);
	IniFile.WriteInteger('Color', 'DropDownColorNoET', Color[0].DropDownColor);
	IniFile.WriteInteger('Color', 'FontColor', Color[1].Text);
	IniFile.WriteInteger('Color', 'BackColor', Color[1].Console);
	IniFile.WriteInteger('Color', 'BorderColor', Color[1].Border);
	IniFile.WriteInteger('Color', 'HintTextColor', Color[1].HintText);
	IniFile.WriteInteger('Color', 'HintColor', Color[1].HintColor);
	IniFile.WriteInteger('Color', 'DropDownTextColor', Color[1].DropDownText);
	IniFile.WriteInteger('Color', 'DropDownColor', Color[1].DropDownColor);
	IniFile.WriteInteger('Color', 'BackColorLinux', Color[2].Console);
	IniFile.WriteInteger('Color', 'FontColorLinux', Color[2].Text);
	IniFile.WriteInteger('Color', 'BorderColorLinux', Color[2].Border);
	IniFile.WriteInteger('Color', 'HintTextColorLinux', Color[2].HintText);
	IniFile.WriteInteger('Color', 'HintColorLinux', Color[2].HintColor);
	IniFile.WriteInteger('Color', 'DropDownTextColorLinux', Color[2].DropDownText);
	IniFile.WriteInteger('Color', 'DropDownColorLinux', Color[2].DropDownColor);}

	IniFile.WriteInteger('HotKey', 'Key', Hotkey.Key);
	IniFile.WriteBool('HotKey', 'WinKey', Hotkey.WinKey);
	IniFile.WriteBool('HotKey', 'CtrlKey', Hotkey.CtrlKey);
	IniFile.WriteBool('HotKey', 'AltKey', Hotkey.AltKey);
	IniFile.WriteBool('HotKey', 'ShiftKey', Hotkey.ShiftKey);

	IniFile.WriteString('Font', 'Name', Font.Name);
	IniFile.WriteInteger('Font', 'Size', Font.Size);
	IniFile.WriteBool('Font', 'AutoSize', Font.AutoSize);
	IniFile.WriteBool('Font', 'Bold', Font.Bold);
	IniFile.WriteBool('Font', 'Italic', Font.Italic);
	IniFile.WriteBool('Font', 'StrikeOut', Font.StrikeOut);
	IniFile.WriteBool('Font', 'UnderLine', Font.UnderLine);
	IniFile.WriteInteger('Font', 'Alignment', Font.Align);
	IniFile.WriteBool('Font', 'ApplyEnglish', Font.ApplyEnglish);
	IniFile.WriteBool('Font', 'LockEnglish', Font.LockEnglish);

	IniFile.WriteInteger('Type', 'EasyType', EasyType.EasyType);
	IniFile.WriteBool('Type', 'Internal', EasyType.Internal);
	IniFile.WriteBool('Type', 'Alias', EasyType.Alias);
	IniFile.WriteBool('Type', 'SysAlias', EasyType.SysAlias);
	IniFile.WriteBool('Type', 'Path', EasyType.Path);
	IniFile.WriteBool('Type', 'Plugins', EasyType.Plugins);
	IniFile.WriteBool('Type', 'History', EasyType.History);
	IniFile.WriteBool('Type', 'Case', EasyType.CaseSensitivity);
	IniFile.WriteBool('Type', 'Space', EasyType.Space);
	IniFile.WriteBool('Type', 'EnableET', EasyType.EnableET);
	IniFile.WriteBool('Type', 'AdvancedBackspace', EasyType.AdvancedBackspace);
	IniFile.WriteBool('Type', 'AdvancedSpace', EasyType.AdvancedSpace);
  IniFile.WriteBool('Type', 'DeleteDuplicates', EasyType.DeleteDuplicates);

	IniFile.WriteBool('Exec', 'Internal', Exec.Internal);
	IniFile.WriteBool('Exec', 'Alias', Exec.Alias);
	IniFile.WriteBool('Exec', 'SysAlias', Exec.SysAlias);
	IniFile.WriteBool('Exec', 'WWW', Exec.WWW);
	IniFile.WriteBool('Exec', 'EMail', Exec.EMail);
	IniFile.WriteBool('Exec', 'Folder', Exec.Folders);
	IniFile.WriteBool('Exec', 'File', Exec.Files);
	IniFile.WriteBool('Exec', 'Plugins', Exec.Plugins);
	IniFile.WriteBool('Exec', 'Shell', Exec.Shell);
	IniFile.WriteBool('Exec', 'DefaultAction', Exec.DefaultAction);

	IniFile.WriteString('Path', 'Browser', Path.Browser);
	IniFile.WriteString('Path', 'FileManager', Path.FM);
	IniFile.WriteString('Path', 'Shell', Path.Shell);
	IniFile.WriteString('Path', 'ShellClose', Path.ShellClose);
	IniFile.WriteString('Path', 'ShellNoClose', Path.ShellNoClose);

	IniFile.WriteBool('History', 'SaveHistory', History.SaveHistory);
	IniFile.WriteBool('History', 'SaveInternal', History.SaveInternal);
	IniFile.WriteBool('History', 'SaveParamInternal', History.SaveParamInternal);
	IniFile.WriteBool('History', 'SaveAlias', History.SaveAlias);
	IniFile.WriteBool('History', 'SaveParamAlias', History.SaveParamAlias);
	IniFile.WriteBool('History', 'SaveSysAlias', History.SaveSysAlias);
	IniFile.WriteBool('History', 'SaveSysParamAlias', History.SaveSysParamAlias);
	IniFile.WriteBool('History', 'SaveWWW', History.SaveWWW);
	IniFile.WriteBool('History', 'SaveEMail', History.SaveEMail);
	IniFile.WriteBool('History', 'SavePath', History.SavePath);
	IniFile.WriteBool('History', 'SavePlugins', History.SavePlugins);
	IniFile.WriteBool('History', 'SaveParamPlugins', History.SaveParamPlugins);
	IniFile.WriteBool('History', 'SaveUnknown', History.SaveUnknown);
	IniFile.WriteBool('History', 'SaveCommandLine', History.SaveCommandLine);
	IniFile.WriteBool('History', 'SaveMessage', History.SaveMessage);
	IniFile.WriteInteger('History', 'MaxHistory', History.MaxHistory);
	IniFile.WriteBool('History', 'InvertScroll', History.InvertScroll);

	IniFile.WriteString('Language', 'Language', Language.Language);

	IniFile.WriteBool('Undo', 'UseUndo', Undo.UseUndo);

	IniFile.WriteBool('Sounds', 'EnableSounds', Sounds.EnableSounds);
	IniFile.WriteString('Sounds', 'ExecuteInternal', Sounds.ExecuteInternalSound);
	IniFile.WriteString('Sounds', 'ExecuteAlias', Sounds.ExecuteAliasSound);
	IniFile.WriteString('Sounds', 'ExecuteSysAlias', Sounds.ExecuteSysAliasSound);
	IniFile.WriteString('Sounds', 'ExecuteURL', Sounds.ExecuteURLSound);
	IniFile.WriteString('Sounds', 'ExecuteEMail', Sounds.ExecuteEmailSound);
	IniFile.WriteString('Sounds', 'ExecuteFolder', Sounds.ExecuteFolderSound);
	IniFile.WriteString('Sounds', 'ExecuteFile', Sounds.ExecuteFileSound);
	IniFile.WriteString('Sounds', 'ExecutePlugin', Sounds.ExecutePluginSound);
	IniFile.WriteString('Sounds', 'ExecuteAllOther', Sounds.ExecuteShellSound);

	IniFile.WriteBool('Config', 'MoveTop', Config.MoveTop);
	IniFile.WriteBool('Config', 'AutoSort', Config.AutoSort);
	IniFile.WriteBool('Config', 'AutoReread', Config.AutoReread);
	IniFile.WriteInteger('Config', 'AutoRereadValue', Config.AutoRereadValue);
	IniFile.WriteBool('Config', 'RereadHotKey', Config.RereadHotKey);
	IniFile.WriteBool('Config', 'CDA_CreateOldFile', Config.CDA_CreateOldFile);
	IniFile.WriteBool('Config', 'CDA_Confirmation', Config.CDA_Confirmation);
	IniFile.WriteBool('Config', 'CDA_SearchFile', Config.CDA_SearchFile);
	IniFile.WriteBool('Config', 'CDA_SearchPlugins', Config.CDA_SearchPlugins);
	IniFile.WriteBool('Config', 'CDA_Startup', Config.CDA_Startup);

	IniFile.WriteInteger('Coordinates', 'SettingsX', Coordinates.SettingsX);
	IniFile.WriteInteger('Coordinates', 'SettingsY', Coordinates.SettingsY);

	IniFile.UpdateFile;
	IniFile.Free;
end;

procedure TSettings.ReadRegSettings;
var
	RegFile: TRegistry;
begin
	RegFile:=TRegistry.Create;

	Options.Registry.AutoRun:=0;
  Options.Registry.AutoRunMayChange:=0;
	RegFile.RootKey:=HKEY_LOCAL_MACHINE;
	if RegFile.OpenKeyReadOnly('\Software\Microsoft\Windows\CurrentVersion\Run') then begin
		if RegFile.ValueExists('TypeAndRun') then
			Options.Registry.AutoRun:=1;
		RegFile.CloseKey;
	end;
	if RegFile.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run\test', True) then begin
		Registry.AutoRunMayChange:=1;
		RegFile.CloseKey;
		RegFile.DeleteKey('\Software\Microsoft\Windows\CurrentVersion\Run\test');
	end;
	RegFile.RootKey:=HKEY_CURRENT_USER;
	if RegFile.OpenKeyReadOnly('\Software\Microsoft\Windows\CurrentVersion\Run') then begin
		if (Options.Registry.AutoRun<>1) and (RegFile.ValueExists('TypeAndRun')) then
			Options.Registry.AutoRun:=2;
		RegFile.CloseKey;
	end;
	if RegFile.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run\test', True) then begin
		if Registry.AutoRunMayChange<>1 then
			Registry.AutoRunMayChange:=2;
		RegFile.CloseKey;
		RegFile.DeleteKey('\Software\Microsoft\Windows\CurrentVersion\Run\test');
	end;

	Options.Registry.ShellInt:=False;
	Options.Registry.ShellIntMayChange:=False;
	RegFile.RootKey:=HKEY_CLASSES_ROOT;
	if RegFile.OpenKeyReadOnly('\*\Shell\Add to '+Program_Name+'...\command') then begin
		Options.Registry.ShellInt:=True;
		RegFile.CloseKey;
	end;
	if RegFile.OpenKey('\*\Shell\Add to '+Program_Name+'...\command\test', True) then begin
		Options.Registry.ShellIntMayChange:=True;
		RegFile.CloseKey;
		RegFile.DeleteKey('\*\Shell\Add to '+Program_Name+'...\command\test');
	end;

  Registry.MultiUser:=False;
	Registry.MultiUserMayChange:=False;
	RegFile.RootKey:=HKEY_LOCAL_MACHINE;
	if RegFile.OpenKeyReadOnly('\Software\TypeAndRun') then begin
		if RegFile.ValueExists('MultiUsers') then
			Registry.MultiUser:=RegFile.ReadBool('MultiUsers')
		else
			Registry.MultiUser:=False;
		RegFile.CloseKey;
	end;
	if Pos('NT', GetWinVersion)<>0 then begin
		if RegFile.OpenKey('\Software\TypeAndRun\test', True) then begin
			Registry.MultiUserMayChange:=True;
			RegFile.CloseKey;
			RegFile.DeleteKey('\Software\TypeAndRun\test');
		end;
	end;

	RegFile.Free;
end;

procedure TSettings.SaveRegSettings;
var
	RegFile: TRegistry;
begin
	RegFile:=TRegistry.Create;

	if Options.Registry.AutoRunMayChange=1 then begin
		RegFile.RootKey:=HKEY_LOCAL_MACHINE;
		if RegFile.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', False) then begin
			if Options.Registry.AutoRun<>1 then begin
				RegFile.DeleteValue(Program_Name);
			end
			else begin
				if not RegFile.ValueExists(Program_Name) then begin
					RegFile.WriteString(Program_Name,'"'+Application.ExeName+'"');
				end;
			end;
			RegFile.CloseKey;
		end;
	end;
	if Options.Registry.AutoRunMayChange<>0 then begin
		RegFile.RootKey:=HKEY_CURRENT_USER;
		if RegFile.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', False) then begin
			if Options.Registry.AutoRun<>2 then begin
				RegFile.DeleteValue(Program_Name);
			end
			else begin
				if not RegFile.ValueExists(Program_Name) then begin
					RegFile.WriteString(Program_Name,'"'+Application.ExeName+'"');
				end;
			end;
			RegFile.CloseKey;
		end;
	end;

	if Options.Registry.ShellIntMayChange then begin
		RegFile.RootKey:=HKEY_CLASSES_ROOT;
		if Options.Registry.ShellInt then begin
			if not RegFile.OpenKeyReadOnly('\*\Shell\Add to '+Program_Name+'...\command') then begin
				if RegFile.OpenKey('\*\Shell\Add to '+Program_Name+'...\command', true) then begin
					RegFile.WriteString('', '"'+Application.ExeName+'" "--add=%1"');
				end;
			end;
			if not RegFile.OpenKeyReadOnly('\Folder\Shell\Add to '+Program_Name+'...\command') then begin
				if RegFile.OpenKey('\Folder\Shell\Add to '+Program_Name+'...\command', true) then begin
					RegFile.WriteString('', '"'+Application.ExeName+'" "--add=%1"');
				end;
			end;
		end
		else begin
			RegFile.DeleteKey('\*\Shell\Add to '+Program_Name+'...');
			RegFile.DeleteKey('\Folder\Shell\Add to '+Program_Name+'...');
		end;
		RegFile.CloseKey;
	end;

  if Options.Registry.MultiUserMayChange then begin
		RegFile.RootKey:=HKEY_LOCAL_MACHINE;
		if(Registry.MultiUser) then begin
			if RegFile.OpenKey('\Software\TypeAndRun', True) then begin
				RegFile.WriteBool('MultiUsers', Registry.MultiUser);
				RegFile.CloseKey;
			end;
		end
		else begin
			RegFile.DeleteKey('\Software\TypeAndRun');
		end;
	end;

	RegFile.Free;
end;

procedure TSettings.SetFileName(const Value: string);
begin
	FFileName := Value;
end;

{ TSystemAlias }

constructor TSystemAlias.Create;
begin
	Name:=TStringList.Create;
	Action:=TStringList.Create;
	Path:=TStringList.Create;
	inherited;
end;

destructor TSystemAlias.Destroy;
begin
	Name.Free;
	Action.Free;
  Path.Free;
	inherited;
end;

procedure TSystemAlias.ReadSystemAliases;
var
	SysAliases: TRegistry;
	i: integer;
	tmpList: TStringList;
begin
	SysAliases:=TRegistry.Create;
	SysAliases.RootKey:=HKEY_LOCAL_MACHINE;
	if SysAliases.OpenKeyReadOnly('\Software\Microsoft\Windows\CurrentVersion\App Paths\') then begin
    tmpList:=TStringList.Create;
		SysAliases.GetKeyNames(tmpList);
		Name.Clear;
		Action.Clear;
    Path.Clear;
		for i:=0 to tmpList.Count-1 do begin
			if AnsiLowerCase(Copy(tmpList.Strings[i], Length(tmpList.Strings[i])-3, 4))='.exe' then begin
				if SysAliases.OpenKeyReadOnly('\Software\Microsoft\Windows\CurrentVersion\App Paths\'+tmpList.Strings[i]) then begin
					if SysAliases.ReadString('')<>'' then begin
						Name.Add(Copy(tmpList.Strings[i], 0, Length(tmpList.Strings[i])-4));
						Action.Add(SysAliases.ReadString(''));
            Path.Add(SysAliases.ReadString('Path'));
					end;
				end;
			end;
		end;
		SysAliases.CloseKey;
		tmpList.Free;
	end;
	SysAliases.Free;
end;

procedure TSystemAlias.SetAction(const Value: TStringList);
begin
  FAction := Value;
end;

procedure TSystemAlias.SetName(const Value: TStringList);
begin
  FName := Value;
end;

procedure TSystemAlias.SetPath(const Value: TStringList);
begin
	FPath := Value;
end;

{ TSettingsSound }

constructor TSettingsSound.Create;
begin
  ListSounds:=TStringList.Create;
	inherited;
end;

destructor TSettingsSound.Destroy;
begin
	ListSounds.Free;
	inherited;
end;

procedure TSettingsSound.SetEnableSounds(const Value: boolean);
begin
	FEnableSounds := Value;
end;

procedure TSettingsSound.SetExecuteAliasSound(const Value: string);
begin
  FExecuteAliasSound := Value;
end;

procedure TSettingsSound.SetExecuteEmailSound(const Value: string);
begin
  FExecuteEmailSound := Value;
end;

procedure TSettingsSound.SetExecuteFileSound(const Value: string);
begin
  FExecuteFileSound := Value;
end;

procedure TSettingsSound.SetExecuteFolderSound(const Value: string);
begin
  FExecuteFolderSound := Value;
end;

procedure TSettingsSound.SetExecuteInternalSound(const Value: string);
begin
  FExecuteInternalSound := Value;
end;

procedure TSettingsSound.SetExecutePluginSound(const Value: string);
begin
  FExecutePluginSound := Value;
end;

procedure TSettingsSound.SetExecuteShellSound(const Value: string);
begin
  FExecuteShellSound := Value;
end;

procedure TSettingsSound.SetExecuteSysAliasSound(const Value: string);
begin
	FExecuteSysAliasSound := Value;
end;

procedure TSettingsSound.SetExecuteURLSound(const Value: string);
begin
  FExecuteURLSound := Value;
end;

end.
