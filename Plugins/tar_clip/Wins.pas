unit Wins;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TWinList = class(TForm)
    List: TListBox;
    SelectType: TRadioGroup;
    Template: TEdit;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Label3: TLabel;
    HotKey1: THotKey;
    HotKey2: THotKey;
    NewWin: TButton;
    DelWin: TButton;
    Ok: TButton;
    Cancel: TButton;
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
  end;

var
  WinList: TWinList;
  SelectedWindow:integer;

implementation

{$R *.dfm}

Uses Common;

Const SpecGroup='Lang_Windows';

procedure TWinList.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if Image1.Tag=0 then begin
  Image1.Tag:=1;
  Screen.Cursor:=crHandPoint;
  SetCapture(Handle);
 end;
end;

procedure TWinList.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState;X,Y:Integer);
var H1:integer;
    Point:TPoint;
    S,S1:pchar;
begin
 if Image1.Tag=1 then begin
  GetMem(S,256);GetMem(S1,256);
  ReleaseCapture;
  GetCursorPos(Point);
  SelectedWindow:=WindowFromPoint(Point);H1:=0;
  Repeat
   GetWindowText(SelectedWindow,S,256);
   GetClassName(SelectedWindow,S1,256);
   if(lstrlen(S)=0)then begin
    H1:=GetParent(SelectedWindow);
    if H1<>0 then SelectedWindow:=H1;
   end;
  until(H1=0)or(lstrlen(S)<>0);
  Template.Text:=Format('%s [%s] (%x)',[StrPas(S),StrPas(S1),SelectedWindow]);
  FreeMem(S1,256);FreeMem(S,256);
  Image1.Tag:=0;
  Screen.Cursor:=crDefault;
 end;
end;

procedure TWinList.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 WinPresent:=false;
end;

procedure TWinList.FormCreate(Sender: TObject);
begin
 Caption:=Ini.ReadString(SpecGroup,'Caption','Exclusion windows editor');
 SelectType.Caption:=Ini.ReadString(SpecGroup,'SelectType','Select by:');
 SelectType.Items.Strings[0]:=Ini.ReadString(SpecGroup,'SelectType1','Complete header');
 SelectType.Items.Strings[1]:=Ini.ReadString(SpecGroup,'SelectType2','Header''s template');
 SelectType.Items.Strings[2]:=Ini.ReadString(SpecGroup,'SelectType3','Class name');
 SelectType.Items.Strings[3]:=Ini.ReadString(SpecGroup,'SelectType4','File name');
 Label1.Caption:=Ini.ReadString(SpecGroup,'WindowCapture','Window capture');
 Label2.Caption:=Ini.ReadString(SpecGroup,'HotCopy','Copy hotkey:');
 Label3.Caption:=Ini.ReadString(SpecGroup,'HotPaste','Paste hotkey:');
 NewWin.Caption:=Ini.ReadString(SpecGroup,'NewWin','New');
 DelWin.Caption:=Ini.ReadString(SpecGroup,'DelWin','Delete');
 Ok.Caption:=Ini.ReadString('Language','Ok','Ok');
 Cancel.Caption:=Ini.ReadString('Language','Cancel','Cancel');
 WinPresent:=true;
end;

end.
