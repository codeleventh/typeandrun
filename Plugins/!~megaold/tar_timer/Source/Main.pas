unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, CheckLst, Menus,IniFiles;

type
  TBase = class(TForm)
    Sheds: TListBox;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Hours: TCheckListBox;
    Label3: TLabel;
    Mins: TCheckListBox;
    MinPop: TPopupMenu;
    MinSet: TMenuItem;
    MinNo: TMenuItem;
    MinInvert: TMenuItem;
    Dows: TCheckListBox;
    Label5: TLabel;
    DowsPop: TPopupMenu;
    DowSet: TMenuItem;
    DowNo: TMenuItem;
    DowInvert: TMenuItem;
    Label6: TLabel;
    Days: TCheckListBox;
    Mons: TCheckListBox;
    Years: TCheckListBox;
    DaysPop: TPopupMenu;
    DaysSet: TMenuItem;
    DaysNo: TMenuItem;
    DaysInvert: TMenuItem;
    MonPop: TPopupMenu;
    Label7: TLabel;
    Label8: TLabel;
    MonSet: TMenuItem;
    MonNo: TMenuItem;
    MonInvert: TMenuItem;
    YearPop: TPopupMenu;
    YearSet: TMenuItem;
    YearNo: TMenuItem;
    YearInvert: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    GroupBox2: TGroupBox;
    TaskList: TComboBox;
    Label9: TLabel;
    Label4: TLabel;
    Input: TEdit;
    Cron1: TButton;
    Cron2: TButton;
    GroupBox3: TGroupBox;
    HoursPop: TPopupMenu;
    HoursSet: TMenuItem;
    HoursNo: TMenuItem;
    HoursInvert: TMenuItem;
    CallID: TEdit;
    Label10: TLabel;
    Path: TEdit;
    PathBr: TButton;
    Open: TOpenDialog;
    LateProc: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    CronAdd: TButton;
    CronRem: TButton;
    procedure FormCreate(Sender: TObject);
    procedure HoursSetClick(Sender: TObject);
    procedure HoursNoClick(Sender: TObject);
    procedure HoursInvertClick(Sender: TObject);
    procedure MinSetClick(Sender: TObject);
    procedure MinNoClick(Sender: TObject);
    procedure MinInvertClick(Sender: TObject);
    procedure DowSetClick(Sender: TObject);
    procedure DowNoClick(Sender: TObject);
    procedure DowInvertClick(Sender: TObject);
    procedure DaysSetClick(Sender: TObject);
    procedure DaysNoClick(Sender: TObject);
    procedure DaysInvertClick(Sender: TObject);
    procedure YearSetClick(Sender: TObject);
    procedure YearNoClick(Sender: TObject);
    procedure YearInvertClick(Sender: TObject);
    procedure MonSetClick(Sender: TObject);
    procedure MonNoClick(Sender: TObject);
    procedure MonInvertClick(Sender: TObject);
    procedure Cron1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure Cron2Click(Sender: TObject);
    procedure InputChange(Sender: TObject);
    procedure TaskListChange(Sender: TObject);
    procedure PathBrClick(Sender: TObject);
    procedure HoursClickCheck(Sender: TObject);
    procedure CronAddClick(Sender: TObject);
    procedure CronRemClick(Sender: TObject);
    procedure CronModClick(Sender: TObject);
    procedure ShedsClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ShedsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  public
   procedure SetCrons;
   procedure GetCrons;
   procedure ListBoxMode(Sender:TCheckListBox;Mode:byte);
  end;

var
  Base: TBase;

implementation

{$R *.dfm}

Uses WinCron,Common;

Const MainGroup='Language';

procedure TBase.ListBoxMode(Sender:TCheckListBox;Mode:byte);
var I:integer;
begin
 for I:=0 to Sender.Count-1 do case Mode of
  0:Sender.Checked[I]:=true;
  1:Sender.Checked[I]:=false;
  2:Sender.Checked[I]:=not Sender.Checked[I];
 end;
 Cron2.Tag:=GetTickCount;
end;

procedure TBase.FormCreate(Sender: TObject);
Const DowsDef:array[0..6]of string=('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday');
Const MonDef:array[1..12]of string=('January','February','March','April','May',
 'June','July','August','September','October','November','December');
Const TaskDef:array[0..3]of string=('Popup message','On screen display','Execute program','Pass to TaR');
var I:byte;
begin
 Caption:=Ini.ReadString(MainGroup,'Caption','Hotkey editor');
 GroupBox3.Caption:=Ini.ReadString(MainGroup,'CommonCap','Common parameters');
 GroupBox1.Caption:=Ini.ReadString(MainGroup,'AlarmCap','Alarm time');
 Label4.Caption:=Ini.ReadString(MainGroup,'CronCap','CRON format');
 Cron1.Hint:=Ini.ReadString(MainGroup,'V2C','Convert visual appearance to CRON');
 Cron2.Hint:=Ini.ReadString(MainGroup,'C2V','Convert CRON to visual appearance');
 Label2.Caption:=Ini.ReadString(MainGroup,'HoursCap','hours');
 Label3.Caption:=Ini.ReadString(MainGroup,'MinCap','minutes');
 Label5.Caption:=Ini.ReadString(MainGroup,'DowsCap','day of week');
 Label6.Caption:=Ini.ReadString(Maingroup,'DayCap','days');
 Label7.Caption:=Ini.ReadString(MainGroup,'MonCap','months');
 Label8.Caption:=Ini.ReadString(MainGroup,'YearCap','years');
 LateProc.Caption:=Ini.ReadString(MainGroup,'LateCap','Late processing');
 GroupBox2.Caption:=Ini.ReadString(MainGroup,'TaskTypeCap','Task type');
 Label9.Caption:=Ini.ReadString(MainGroup,'WhatCap','To do:');
 Label10.Caption:=Ini.ReadString(MainGroup,'PathCap','Program:');
 Button1.Caption:=Ini.ReadString(MainGroup,'Ok','Accept');
 Button2.Caption:=Ini.ReadString(MainGroup,'Cancel','Decline');
 For I:=0 to 6 do Dows.Items.Strings[I]:=Ini.ReadString(MainGroup,'DowsCap'+inttostr(I),DowsDef[I]);
 For I:=0 to 11 do Mons.Items.Strings[I]:=Ini.ReadString(MainGroup,'MonCap'+inttostr(I+1),MonDef[I+1]);
 For I:=0 to 3 do TaskList.Items.Strings[I]:=Ini.ReadString(MainGroup,'TaskCap'+inttostr(I),TaskDef[I]);
 For I:=0 to 23 do Hours.Items.Add(inttostr(I));
 For I:=0 to 59 do Mins.Items.Add(inttostr(I));
 For I:=1 to 31 do Days.Items.Add(inttostr(I));
 For I:=10 to 30 do Years.Items.Add(inttostr(I+1980));
 Cron1.Tag:=0;
 Cron2.Tag:=0;
 ListBoxMode(Hours,0);
 ListBoxMode(Mins,0);
 ListBoxMode(Dows,0);
 ListBoxMode(Days,0);
 ListBoxMode(Mons,0);
 ListBoxMode(Years,0);
 TaskList.ItemIndex:=0;
 TaskListChange(Sender);
 Sheds.ItemIndex:=0;
 SetCrons;
end;

procedure TBase.HoursSetClick(Sender: TObject);
begin
 ListBoxMode(Hours,0);
end;

procedure TBase.HoursNoClick(Sender: TObject);
begin
 ListBoxMode(Hours,1);
end;

procedure TBase.HoursInvertClick(Sender: TObject);
begin
 ListBoxMode(Hours,2);
end;

procedure TBase.MinSetClick(Sender: TObject);
begin
 ListBoxMode(Mins,0);
end;

procedure TBase.MinNoClick(Sender: TObject);
begin
 ListBoxMode(Mins,1);
end;

procedure TBase.MinInvertClick(Sender: TObject);
begin
 ListBoxMode(Mins,2);
end;

procedure TBase.DowSetClick(Sender: TObject);
begin
 ListBoxMode(Dows,0);
end;

procedure TBase.DowNoClick(Sender: TObject);
begin
 ListBoxMode(Dows,1);
end;

procedure TBase.DowInvertClick(Sender: TObject);
begin
 ListBoxMode(Dows,2);
end;

procedure TBase.DaysSetClick(Sender: TObject);
begin
 ListBoxMode(Days,0);
end;

procedure TBase.DaysNoClick(Sender: TObject);
begin
 ListBoxMode(Days,1);
end;

procedure TBase.DaysInvertClick(Sender: TObject);
begin
 ListBoxMode(Days,2);
end;

procedure TBase.YearSetClick(Sender: TObject);
begin
 ListBoxMode(Years,0);
end;

procedure TBase.YearNoClick(Sender: TObject);
begin
 ListBoxMode(Years,1);
end;

procedure TBase.YearInvertClick(Sender: TObject);
begin
 ListBoxMode(Years,2);
end;

procedure TBase.MonSetClick(Sender: TObject);
begin
 ListBoxMode(Mons,0);
end;

procedure TBase.MonNoClick(Sender: TObject);
begin
 ListBoxMode(Mons,1);
end;

procedure TBase.MonInvertClick(Sender: TObject);
begin
 ListBoxMode(Mons,2);
end;

procedure TBase.Cron1Click(Sender: TObject);
var Cron:TCron;
    I:byte;
begin
 Cron:=TCron.Create('* /msg Test');
 if Cron<>nil then begin
 FillChar(Cron.When,sizeof(TWhen),0);
 For I:=0 to 23 do if Hours.Checked[I] then Include(Cron.When[1],I);
 For I:=0 to 59 do if Mins.Checked[I] then Include(Cron.When[0],I);
 For I:=0 to 6 do if Dows.Checked[I] then Include(Cron.When[4],I);
 For I:=0 to 30 do if Days.Checked[I] then Include(Cron.When[2],I+1);
 For I:=0 to 11 do if Mons.Checked[I] then Include(Cron.When[3],I+1);
 For I:=0 to Years.Count-1 do if Years.Checked[I] then Include(Cron.When[5],I+10);
 Cron.Kind:=TaskList.ItemIndex;
 Cron.Late:=LateProc.Checked;
 Cron.Line:=Path.Text;
 Input.Text:=Cron.Get;
 Cron.Free;
 Cron1.Tag:=GetTickCount;
 end;
end;

procedure TBase.N1Click(Sender: TObject);
begin
 ListBoxMode(Dows,1);
 Dows.Checked[0]:=true;
 Dows.Checked[6]:=true;
end;

procedure TBase.N2Click(Sender: TObject);
begin
 ListBoxMode(Dows,0);
 Dows.Checked[0]:=false;
 Dows.Checked[6]:=false;
end;

procedure TBase.Cron2Click(Sender: TObject);
var Cron:TCron;
    I:byte;
begin
 Cron:=TCron.Create(Input.Text);
 if Cron<>nil then begin
  For I:=0 to 23 do Hours.Checked[I]:=I in Cron.When[1];
  For I:=0 to 59 do Mins.Checked[I]:=I in Cron.When[0];
  For I:=0 to 6 do Dows.Checked[I]:=I in Cron.When[4];
  For I:=1 to 31 do Days.Checked[I-1]:=I in Cron.When[2];
  For I:=1 to 12 do Mons.Checked[I-1]:=I in Cron.When[3];
  For I:=10 to 30 do Years.Checked[I-10]:=I in Cron.When[5];
  TaskList.ItemIndex:=Cron.Kind;
  Path.Text:=Cron.Line;
  LateProc.Checked:=Cron.Late;
  TaskListChange(Sender);
  Cron.Free;
  Cron2.Tag:=GetTickCount;
 end;
end;

procedure TBase.InputChange(Sender: TObject);
begin
 Cron1.Tag:=GetTickCount;
end;

procedure TBase.TaskListChange(Sender: TObject);
begin
 PathBr.Enabled:=TaskList.ItemIndex=2;
 Cron2.Tag:=GetTickCount;
end;

procedure TBase.PathBrClick(Sender: TObject);
var S:string;
    I:integer;
begin
 Open.FileName:='';
 Open.Title:=Ini.ReadString(MainGroup,'InputFileCap','Select file to insert');
 if Open.Execute then begin
  S:=Path.Text;
  I:=Path.SelStart;
  Insert(Open.FileName+' ',S,Path.SelStart+1);
  Path.Text:=S;
  Path.SelStart:=I+Length(Open.FileName)+1;
 end;
end;

procedure TBase.HoursClickCheck(Sender: TObject);
begin
 Cron2.Tag:=GetTickCount;
end;

procedure TBase.CronAddClick(Sender: TObject);
var Cron:TCron;
begin
 if Sheds.Count>=Max then MessageDlg(Ini.ReadString(MainGroup,'MaxSheds','Too many shedules defined!'),mtError,[mbOk],0)
 else if CallID.Text<>'' then begin
  if Cron1.Tag<Cron2.Tag then Cron1Click(Sender);
  Cron:=TCron.Create(Input.Text);
  if Cron<>nil then begin
   Sheds.AddItem(CallID.Text,Cron);
   Sheds.ItemIndex:=Sheds.Count-1;
   Cron2Click(Sender);
  end;
 end;
end;

procedure TBase.CronRemClick(Sender: TObject);
begin
 Sheds.DeleteSelected;
 CallID.Text:='';
 Input.Text:='* /msg Test';
 Cron1Click(Sender);
 TaskList.ItemIndex:=0;
 TaskListChange(Sender);
end;

procedure TBase.CronModClick(Sender: TObject);
begin
 if(CallID.Text<>'')and(Sheds.Tag<>-1)then begin
  Sheds.Items.Strings[Sheds.Tag]:=CallID.Text;
  if Cron1.Tag<Cron2.Tag then Cron1Click(Sender);
  (Sheds.Items.Objects[Sheds.Tag] as TCron).Create(Input.Text);
  Cron2Click(Sender);
 end;
end;

procedure TBase.ShedsClick(Sender: TObject);
var Cron:TCron;
begin
 CronModClick(Sender);
 if Sheds.ItemIndex<>-1 then begin
  Sheds.Tag:=Sheds.ItemIndex;
  Cron:=Sheds.Items.Objects[Sheds.ItemIndex] as TCron;
  CallID.Text:=Sheds.Items.Strings[Sheds.ItemIndex];
  Input.Text:=Cron.Get;
  Cron2Click(Sender);
  TaskList.ItemIndex:=Cron.Kind;
  Path.Text:=Cron.Line;
  TaskListChange(Sender);
 end;
end;

procedure TBase.SetCrons;
var I:integer;
    Cron:TCron;
begin
 CronRemClick(nil);
 Sheds.Clear;
 For I:=1 to Sheduler.CronNum do begin
  Cron:=TCron.Create(Sheduler.Crons[I]);
  Sheds.AddItem(Sheduler.Crons[I].Name,Cron);
 end;
end;

procedure TBase.GetCrons;
var I:integer;
begin
 For I:=1 to Sheduler.CronNum do Sheduler.Crons[I].Free;
 Sheduler.CronNum:=Sheds.Count;
 For I:=1 to Sheduler.CronNum do begin
  Sheduler.Crons[I]:=TCron.Create(Sheds.Items.Objects[I-1] as TCron);
  Sheduler.Crons[I].Name:=Sheds.Items.Strings[I-1];
 end;
end;

procedure TBase.BitBtn1Click(Sender: TObject);
begin
 CronModClick(Sender);
 GetCrons;
end;

procedure TBase.ShedsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var I:integer;
begin
 with Sheds do if(Key=vk_Up)and(ssCtrl in Shift)then begin
  For I:=0 to Count-1 do if Selected[I] then break;
  if(I<Count)and(I>0)then begin
   Items.Exchange(I,I-1);
   ClearSelection;
   Selected[I]:=true;
  end;
 end else if(Key=vk_Down)and(ssCtrl in Shift)then begin
  For I:=0 to Count-1 do if Selected[I] then break;
  if(I<Count-1)then begin
   Items.Exchange(I,I+1);
   ClearSelection;
   Selected[I]:=true;
  end;
 end else if(Key=vk_Prior)and(ssCtrl in Shift)then begin
  For I:=0 to Count-1 do if Selected[I] then break;
  while(I<Count)and(I>0)do begin
   Items.Exchange(I,I-1);
   Dec(I);
  end;
  ClearSelection;
  Selected[0]:=true;
 end else if(Key=vk_Next)and(ssCtrl in Shift)then begin
  For I:=0 to Count-1 do if Selected[I] then break;
  while(I<Count-1)do begin
   Items.Exchange(I,I+1);
   Inc(I);
  end;
  ClearSelection;
  Selected[Count-1]:=true;
 end else if Key=vk_Delete then CronRemClick(Sender);
end;

end.
