object xJournal: TxJournal
  Left = 215
  Top = 113
  BorderStyle = bsToolWindow
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1075#1086#1088#1103#1095#1080#1093' '#1082#1083#1072#1074#1080#1096
  ClientHeight = 328
  ClientWidth = 422
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
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 144
    Top = 4
    Width = 273
    Height = 317
  end
  object Label1: TLabel
    Left = 152
    Top = 12
    Width = 50
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object List: TListBox
    Left = 0
    Top = 0
    Width = 137
    Height = 328
    Align = alLeft
    ItemHeight = 13
    TabOrder = 0
    OnClick = ListClick
    OnKeyDown = ListKeyDown
  end
  object GroupBox2: TGroupBox
    Left = 152
    Top = 56
    Width = 249
    Height = 117
    Hint = 
      #1053#1072#1078#1084#1080#1090#1077' '#1083#1102#1073#1091#1102' '#1082#1083#1072#1074#1080#1096#1091' '#1074' '#1087#1086#1083#1077' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103' '#1076#1083#1103' '#1091#1089#1090#1072#1085#1086#1074#1082#1080'. '#1053#1072#1078#1084#1080 +
      #1090#1077' '#1087#1086#1074#1090#1086#1088#1085#1086' '#1076#1083#1103' '#1091#1076#1072#1083#1077#1085#1080#1103'.'
    Caption = #1043#1086#1088#1103#1095#1080#1077' '#1082#1083#1072#1074#1080#1096#1080
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    object Control: TCheckBox
      Left = 8
      Top = 16
      Width = 73
      Height = 17
      Caption = 'Control'
      TabOrder = 0
      OnClick = IdChange
    end
    object Alt: TCheckBox
      Left = 8
      Top = 40
      Width = 57
      Height = 17
      Caption = 'Alt'
      TabOrder = 1
      OnClick = IdChange
    end
    object Shift: TCheckBox
      Left = 8
      Top = 64
      Width = 49
      Height = 17
      Caption = 'Shift'
      TabOrder = 2
      OnClick = IdChange
    end
    object Win: TCheckBox
      Left = 8
      Top = 88
      Width = 57
      Height = 17
      Caption = 'Win'
      TabOrder = 3
      OnClick = IdChange
    end
    object Cap1: TEdit
      Left = 88
      Top = 16
      Width = 153
      Height = 21
      ReadOnly = True
      TabOrder = 4
      Text = '$0'
    end
    object Cap2: TEdit
      Left = 88
      Top = 40
      Width = 153
      Height = 21
      ReadOnly = True
      TabOrder = 5
      Text = '$0'
    end
    object Cap3: TEdit
      Left = 88
      Top = 64
      Width = 153
      Height = 21
      ReadOnly = True
      TabOrder = 6
      Text = '$0'
    end
    object Cap4: TEdit
      Left = 88
      Top = 88
      Width = 153
      Height = 21
      ReadOnly = True
      TabOrder = 7
      Text = '$0'
    end
  end
  object GroupBox3: TGroupBox
    Left = 152
    Top = 176
    Width = 249
    Height = 69
    Caption = #1047#1072#1076#1072#1085#1080#1077
    TabOrder = 3
    object Label2: TLabel
      Left = 8
      Top = 20
      Width = 19
      Height = 13
      Caption = #1058#1080#1087
    end
    object Label3: TLabel
      Left = 8
      Top = 44
      Width = 36
      Height = 13
      Caption = #1057#1090#1088#1086#1082#1072
    end
    object Kind: TComboBox
      Left = 40
      Top = 16
      Width = 193
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnClick = IdChange
      Items.Strings = (
        #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1087#1088#1086#1075#1088#1072#1084#1084#1091
        #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1072#1083#1080#1072#1089' TaR')
    end
    object Line: TEdit
      Left = 48
      Top = 40
      Width = 161
      Height = 21
      TabOrder = 1
      OnChange = IdChange
    end
    object Br: TButton
      Left = 216
      Top = 40
      Width = 21
      Height = 21
      Caption = '...'
      TabOrder = 2
      OnClick = BrClick
    end
  end
  object Id: TEdit
    Left = 152
    Top = 28
    Width = 249
    Height = 21
    TabOrder = 1
    OnChange = IdChange
  end
  object DelHotkey: TButton
    Left = 288
    Top = 252
    Width = 113
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1093#1086#1090#1082#1077#1081' (&D)'
    TabOrder = 5
    OnClick = DelHotkeyClick
  end
  object AddHotkey: TButton
    Left = 152
    Top = 252
    Width = 113
    Height = 25
    Caption = #1053#1086#1074#1099#1081' '#1093#1086#1090#1082#1077#1081' (&N)'
    TabOrder = 4
    OnClick = AddHotkeyClick
  end
  object BitBtn1: TButton
    Left = 152
    Top = 288
    Width = 113
    Height = 25
    Caption = 'Ok'
    Default = True
    TabOrder = 6
    OnClick = BitBtn1Click
  end
  object BitBtn2: TButton
    Left = 288
    Top = 288
    Width = 113
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 7
    OnClick = BitBtn2Click
  end
  object Open: TOpenDialog
    Left = 8
    Top = 8
  end
end
