object MyPatch: TMyPatch
  Left = 208
  Top = 158
  BorderStyle = bsToolWindow
  Caption = 'Hex file patcher'
  ClientHeight = 137
  ClientWidth = 308
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Info1: TLabel
    Left = 8
    Top = 10
    Width = 65
    Height = 13
    AutoSize = False
    Caption = 'File name:'
  end
  object Info2: TLabel
    Left = 8
    Top = 34
    Width = 137
    Height = 17
    AutoSize = False
    Caption = 'Offset (Hex):'
    Color = clSilver
    ParentColor = False
    Transparent = True
  end
  object Info3: TLabel
    Left = 8
    Top = 58
    Width = 85
    Height = 13
    AutoSize = False
    Caption = 'New data:'
  end
  object FName: TEdit
    Left = 80
    Top = 8
    Width = 185
    Height = 19
    AutoSize = False
    CharCase = ecUpperCase
    ReadOnly = True
    TabOrder = 0
  end
  object Offs: TEdit
    Left = 152
    Top = 32
    Width = 145
    Height = 19
    CharCase = ecUpperCase
    TabOrder = 1
    Text = '0'
    OnKeyPress = FNameKeyPress
  end
  object NewHex: TEdit
    Left = 96
    Top = 56
    Width = 201
    Height = 19
    TabOrder = 2
    Text = '000000'
    OnKeyPress = FNameKeyPress
  end
  object Backup: TCheckBox
    Left = 8
    Top = 76
    Width = 289
    Height = 17
    Caption = 'Create backup file (.BAK)'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object Br: TButton
    Left = 272
    Top = 8
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 4
    OnClick = BrClick
  end
  object Go: TButton
    Left = 56
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Go'
    Default = True
    TabOrder = 5
    OnClick = GoClick
  end
  object Ex: TButton
    Left = 176
    Top = 104
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Ex'
    ModalResult = 2
    TabOrder = 6
  end
  object Open: TOpenDialog
    Title = #1048#1084#1103' '#1092#1072#1081#1083#1072' '#1076#1083#1103' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103
    Left = 216
    Top = 8
  end
end
