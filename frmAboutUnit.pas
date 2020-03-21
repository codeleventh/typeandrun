unit frmAboutUnit;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls, ShellAPI;

type
	TfrmAbout = class(TForm)
		lblAbout: TLabel;
		btnClose: TButton;
		lblGohomepage: TLabel;
		lblGoEmail1: TLabel;
		lblGoEmail2: TLabel;
		imgBackground1: TImage;
		imgBackground2: TImage;
		imgBackground3: TImage;
		procedure FormShow(Sender: TObject);
		procedure btnCloseClick(Sender: TObject);
		procedure lblGohomepageClick(Sender: TObject);
		procedure lblGoEmail1Click(Sender: TObject);
		procedure lblGoEmail2Click(Sender: TObject);
	private

	public

	end;

var
	frmAbout: TfrmAbout;

implementation

{$R *.dfm}

uses ForAll, Static, Configs	, frmConsoleUnit, frmSettingsUnit, StrUtils, Settings;

// Отображение формы
procedure TfrmAbout.FormShow(Sender: TObject);
var
	Context: string;
begin
	ShowWindow(Application.Handle, SW_HIDE);
  Context:='program name: '+LowerCase(Program_Name)+'|version: '+LowerCase(Program_Version)+'|location: http://www.galanc.com|author: -=GaLaN=- (Evgeniy Galantsev)|email 1: -GaLaN-@mail.ru|      2: galan@fromru.com|icq: 291381';
	lblAbout.Caption:=AnsiReplaceStr(Context, '|', #13);
end;

// Закрыть форму
procedure TfrmAbout.btnCloseClick(Sender: TObject);
begin
	frmAbout.Close;
end;

// Идти на оффициальную страницу
procedure TfrmAbout.lblGohomepageClick(Sender: TObject);
begin
	RunShell(Options.Path.Browser, 'http://www.galanc.com');
end;

// Мыло 1 разработчику
procedure TfrmAbout.lblGoEmail1Click(Sender: TObject);
begin
	RunShell('mailto:-=GaLaN=-%20%3c-GalaN-@mail.ru%3e?subject=' + Program_Name + '%20' + Program_Version);
end;

// Мыло 2 разработчику
procedure TfrmAbout.lblGoEmail2Click(Sender: TObject);
begin
	RunShell('mailto:-=GaLaN=-%20%3cgalan@fromru.com%3e?subject='+Program_Name+'%20'+Program_Version);
end;


initialization
	WM_SendFileNameToOpen:=RegisterWindowMessage('WM_SendFileNameToOpen');

end.
