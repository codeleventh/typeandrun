unit Rew;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TVerify = class(TForm)
    ForAll: TCheckBox;
    Status: TLabel;
    BitBtn1: TButton;
    BitBtn2: TButton;
    BitBtn3: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Verify: TVerify;

implementation

{$R *.DFM}

end.
