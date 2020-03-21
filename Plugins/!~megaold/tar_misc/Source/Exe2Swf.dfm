object AntiFlash: TAntiFlash
  Left = 216
  Top = 136
  ActiveControl = InTxt
  BorderStyle = bsToolWindow
  Caption = 'Flash data extractor'
  ClientHeight = 126
  ClientWidth = 261
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PrintScale = poNone
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 24
    Height = 13
    Caption = 'Input'
  end
  object Label2: TLabel
    Left = 16
    Top = 36
    Width = 32
    Height = 13
    Caption = 'Output'
  end
  object InTxt: TEdit
    Left = 72
    Top = 4
    Width = 153
    Height = 21
    ReadOnly = True
    TabOrder = 0
  end
  object InBr: TButton
    Left = 232
    Top = 4
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 1
    OnClick = InBrClick
  end
  object OutTxt: TEdit
    Left = 72
    Top = 32
    Width = 153
    Height = 21
    ReadOnly = True
    TabOrder = 2
  end
  object OutBr: TButton
    Left = 232
    Top = 32
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 3
    OnClick = OutBrClick
  end
  object Extr: TRadioGroup
    Left = 8
    Top = 56
    Width = 129
    Height = 61
    Caption = 'Extract'
    Items.Strings = (
      'Module'
      'Data')
    TabOrder = 4
    OnClick = ExtrClick
  end
  object BitBtn1: TButton
    Left = 152
    Top = 64
    Width = 75
    Height = 25
    Caption = 'BitBtn1'
    Default = True
    TabOrder = 5
    OnClick = BitBtn1Click
  end
  object BitBtn2: TButton
    Left = 152
    Top = 96
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'BitBtn2'
    ModalResult = 2
    TabOrder = 6
  end
  object Open: TOpenDialog
    DefaultExt = '.exe'
    Filter = #1048#1089#1087#1086#1083#1085#1103#1077#1084#1099#1077' '#1092#1072#1081#1083#1099'|*.exe|'#1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
    Title = 'Input EXE file'
    Left = 72
    Top = 8
  end
  object Save: TSaveDialog
    DefaultExt = '.swf'
    Filter = 'Flash '#1092#1072#1081#1083#1099'|*.swf|'#1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
    Title = 'Output SWF file'
    Left = 72
    Top = 32
  end
end
