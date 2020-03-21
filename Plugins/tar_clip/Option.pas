unit Option;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ComCtrls;

type
  TOptionForm = class(TForm)
    Ok: TButton;
    Cancel: TButton;
    Label1: TLabel;
    DisappearDelaySpin: TSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    DescrLenSpin: TSpinEdit;
    Label4: TLabel;
    MaxDynamicsSpin: TSpinEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    HotCopyKey: THotKey;
    HotPasteKey: THotKey;
    Label8: TLabel;
    Label9: TLabel;
    DelayCopySpin: TSpinEdit;
    Label10: TLabel;
    Label11: TLabel;
    DelayPasteSpin: TSpinEdit;
    Label12: TLabel;
    Label13: TLabel;
    DelayPrintSpin: TSpinEdit;
    Label14: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure OkClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OptionForm: TOptionForm;

implementation

{$R *.dfm}

Uses Common;

Const SpecGroup='Lang_option';

procedure TOptionForm.FormCreate(Sender: TObject);
begin
 Caption:=Ini.ReadString(SpecGroup,'Caption','Options');
 Label1.Caption:=Ini.ReadString(SpecGroup,'DisappearDelay','Disappear delay:');
 Label2.Caption:=Ini.ReadString(SpecGroup,'msec','milliseconds');
 Label3.Caption:=Ini.ReadString(SpecGroup,'DescrLen','Description length:');
 Label4.Caption:=Ini.ReadString(SpecGroup,'ClipNo','Maximal clips:');
 Label5.Caption:=Ini.ReadString(SpecGroup,'sym','symbols');
 Label6.Caption:=Ini.ReadString(SpecGroup,'clips','clips');
 Label7.Caption:=Ini.ReadString(SpecGroup,'HotCopy','Copy hotkey:');
 Label8.Caption:=Ini.ReadString(SpecGroup,'DelayCopy','Copy delay:');
 Label9.Caption:=Ini.ReadString(SpecGroup,'msec','milliseconds');
 Label10.Caption:=Ini.ReadString(SpecGroup,'HotPaste','Paste hotkey:');
 Label11.Caption:=Ini.ReadString(SpecGroup,'DelayPaste','Paste delay:');
 Label12.Caption:=Ini.ReadString(SpecGroup,'msec','milliseconds');
 Label13.Caption:=Ini.ReadString(SpecGroup,'PrintDelay','Print delay:');
 Label14.Caption:=Ini.ReadString(SpecGroup,'msec','milliseconds');
 Ok.Caption:=Ini.ReadString('Language','Ok','Ok');
 Cancel.Caption:=Ini.ReadString('Language','Cancel','Cancel');
 DisappearDelaySpin.Value:=DisappearDelay;
 DescrLenSpin.Value:=DescrLen;
 MaxDynamicsSpin.Value:=MaxDynamic;
 HotCopyKey.HotKey:=HotCopy;
 DelayCopySpin.Value:=DelayCopy;
 HotPasteKey.HotKey:=HotPaste;
 DelayPasteSpin.Value:=DelayPaste;
 DelayPrintSpin.Value:=DelayPrint;
 OptionPresent:=true;
end;

procedure TOptionForm.OkClick(Sender: TObject);
begin
 DisappearDelay:=DisappearDelaySpin.Value;
 DescrLen:=DescrLenSpin.Value;
 MaxDynamic:=MaxDynamicsSpin.Value;
 HotCopy:=HotCopyKey.HotKey;
 DelayCopy:=DelayCopySpin.Value;
 HotPaste:=HotPasteKey.HotKey;
 DelayPaste:=DelayPasteSpin.Value;
 DelayPrint:=DelayPrintSpin.Value;
end;

procedure TOptionForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 OptionPresent:=false;
end;

end.
