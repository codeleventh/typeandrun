unit Param;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls;

type
  TOpts = class(TForm)
    XUseFiles: TCheckBox;
    UseDirs: TCheckBox;
    XFileString: TEdit;
    Label1: TLabel;
    XFileMask: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    XDirString: TEdit;
    Layer: TTrackBar;
    Label4: TLabel;
    XSortFiles: TRadioGroup;
    XSortFolders: TRadioGroup;
    XCaseSens: TCheckBox;
    XInvert: TCheckBox;
    XFilesFirst: TCheckBox;
    XLocal: TCheckBox;
    Shrt: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    procedure XUseFilesClick(Sender: TObject);
    procedure UseDirsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Opts: TOpts;

implementation

{$R *.DFM}

procedure TOpts.XUseFilesClick(Sender: TObject);
begin
 XFileMask.Enabled:=XUseFiles.Checked;
 XFileString.Enabled:=XUseFiles.Checked;
 XLocal.Enabled:=XUseFiles.Checked;
end;

procedure TOpts.UseDirsClick(Sender: TObject);
begin
 XDirString.Enabled:=UseDirs.Checked;
end;

end.
