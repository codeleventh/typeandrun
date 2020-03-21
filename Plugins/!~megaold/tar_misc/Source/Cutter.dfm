object CutForm: TCutForm
  Left = 212
  Top = 130
  BorderStyle = bsToolWindow
  Caption = #1056#1072#1079#1088#1077#1079#1072#1090#1077#1083#1100' '#1092#1072#1081#1083#1086#1074
  ClientHeight = 238
  ClientWidth = 291
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PrintScale = poNone
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 4
    Width = 273
    Height = 13
    AutoSize = False
    Caption = #1042#1093#1086#1076#1085#1086#1081' ('#1074#1099#1093#1086#1076#1085#1086#1081') '#1092#1072#1081#1083':'
  end
  object Label2: TLabel
    Left = 8
    Top = 44
    Width = 273
    Height = 13
    AutoSize = False
    Caption = #1042#1099#1093#1086#1076#1085#1099#1077' ('#1074#1093#1086#1076#1085#1099#1077') '#1092#1072#1081#1083#1099' ('#1084#1072#1089#1082#1080'):'
  end
  object Label3: TLabel
    Left = 8
    Top = 88
    Width = 129
    Height = 13
    AutoSize = False
    Caption = #1056#1077#1078#1080#1084
  end
  object Label4: TLabel
    Left = 8
    Top = 112
    Width = 81
    Height = 13
    AutoSize = False
    Caption = #1056#1072#1079#1084#1077#1088#1099':'
  end
  object Status: TLabel
    Left = 0
    Top = 225
    Width = 291
    Height = 13
    Align = alBottom
    Alignment = taCenter
    AutoSize = False
  end
  object InName: TEdit
    Left = 8
    Top = 20
    Width = 249
    Height = 21
    MaxLength = 256
    TabOrder = 0
  end
  object InBr: TButton
    Left = 264
    Top = 20
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 1
    OnClick = InBrClick
  end
  object OutName: TEdit
    Left = 8
    Top = 60
    Width = 249
    Height = 21
    MaxLength = 256
    ReadOnly = True
    TabOrder = 2
  end
  object OutBr: TButton
    Left = 264
    Top = 60
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 3
    OnClick = OutBrClick
  end
  object Mode: TComboBox
    Tag = -1
    Left = 136
    Top = 84
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    OnChange = ModeChange
    Items.Strings = (
      #1056#1072#1079#1088#1077#1079#1072#1090#1100
      #1057#1082#1083#1077#1080#1090#1100
      #1057#1096#1080#1090#1100' '#1089#1087#1080#1089#1086#1082)
  end
  object Sizes: TEdit
    Left = 88
    Top = 108
    Width = 169
    Height = 21
    MaxLength = 256
    TabOrder = 5
  end
  object ReqMode: TCheckBox
    Left = 8
    Top = 132
    Width = 273
    Height = 17
    Caption = #1047#1072#1087#1088#1086#1089' '#1087#1086#1089#1083#1077' '#1082#1072#1078#1076#1086#1075#1086' '#1092#1072#1081#1083#1072
    TabOrder = 6
  end
  object OK: TButton
    Left = 48
    Top = 196
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 7
    OnClick = OKClick
  end
  object Cancel: TButton
    Left = 160
    Top = 196
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 8
    OnClick = CancelClick
  end
  object DelSrc: TCheckBox
    Left = 8
    Top = 152
    Width = 273
    Height = 17
    Caption = #1059#1076#1072#1083#1103#1090#1100' '#1080#1089#1093#1086#1076#1085#1099#1077' '#1092#1072#1081#1083#1099
    TabOrder = 9
  end
  object BrL: TButton
    Left = 264
    Top = 108
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 10
    OnClick = BrLClick
  end
  object MakeBat: TCheckBox
    Left = 8
    Top = 172
    Width = 281
    Height = 17
    Caption = 'MakeBat'
    TabOrder = 11
  end
  object Open: TOpenDialog
    Left = 8
    Top = 4
  end
end
