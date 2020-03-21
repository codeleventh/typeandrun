unit frmHintUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmHint = class(TForm)
    lblHint: TLabel;
    lblBack: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmHint: TfrmHint;

implementation

uses frmConsoleUnit;

{$R *.dfm}

end.
