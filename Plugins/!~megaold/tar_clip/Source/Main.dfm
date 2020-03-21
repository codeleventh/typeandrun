object ClipEditor: TClipEditor
  Left = 198
  Top = 137
  ActiveControl = Clips
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1082#1083#1080#1087#1086#1074
  ClientHeight = 169
  ClientWidth = 246
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000000
    0BB333333333333333333330000000000B000000000000000000003000000000
    0B8FF6FFFFFFFFFFFFFFF030000000000B8FF6FFFFFFFFFFFFFFF03000000000
    0B8666666666666666666030000000000B8FF6FFFFFFFFFFFFFFF03000000000
    0B8FF6FFFFFFFFFFFFFFF030000000000B866666666666666666603000000000
    0B8FF6FFFFFFFFFFFFFFF030000000000B8FF6FFFFFFFFFFFFFFF03000000000
    0B8666666666666666666030000000000B8FF6FFFFFFFFFFFFFFF03000000000
    0B8FF6FFFFFFFFFFFFFFF030000000000B866666666666666666603000000000
    0B8FF6FFFFFFFFFFFFFFF030000000000B8FF6FFFFFFFFFFFFFFF03000000000
    0B8666666666666666666030000000000B8FF6FFFFFFFFFFFFFFF03000000000
    0B8FF6FFFFFFFFFFFFFFF030000000000B866666666666666666603000000000
    0B8FF6FFFFFFFFFFFFFFF030000000000B8FF6FFFFFFFFFFFFFFF03000000000
    0B8FF6FF88888888888FF030000000000B8FF6F000000000008FF03000000000
    0B888880FF888888808880B0000000000BBBBBBB0FF888880BBBBBB000000000
    0000000000FF88800000000000000000000000000FF888880000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFF800001FF000000FF000000FF000000FF000000FF000000FF000000FF000
    000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000
    000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000
    000FF000000FF000000FF000000FF800001FFFF007FFFFF007FFFFFFFFFF}
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDefault
  PrintScale = poPrintToFit
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 28
    Width = 233
    Height = 117
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Clips: TComboBox
    Tag = -1
    Left = 8
    Top = 4
    Width = 233
    Height = 21
    AutoComplete = False
    ItemHeight = 13
    MaxLength = 30
    PopupMenu = Dummy
    TabOrder = 1
    OnChange = ClipsChange
    OnKeyDown = ClipsKeyDown
    OnSelect = ClipsSelect
  end
  object IsStatic: TCheckBox
    Left = 8
    Top = 148
    Width = 233
    Height = 17
    Caption = #1057#1090#1072#1090#1080#1095#1077#1089#1082#1080#1081' '#1082#1083#1080#1087
    TabOrder = 2
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 32
    object N2: TMenuItem
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
      object Disappear: TMenuItem
        Caption = #1057#1082#1088#1099#1074#1072#1090#1100' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
        OnClick = DisappearClick
      end
      object AlwaysOnTop: TMenuItem
        Caption = #1042#1089#1077#1075#1076#1072' '#1085#1072#1074#1077#1088#1093#1091
        OnClick = AlwaysOnTopClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object N5: TMenuItem
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1073#1091#1092#1077#1088#1072
        OnClick = N5Click
      end
      object N6: TMenuItem
        Caption = #1048#1089#1082#1083#1102#1095#1077#1085#1080#1103
        Enabled = False
        OnClick = N6Click
      end
      object N20: TMenuItem
        Caption = '-'
      end
      object pureclip1: TMenuItem
        Caption = #1042#1089#1090#1072#1074#1083#1103#1090#1100' '#1087#1086' ~pureclip'
        OnClick = pureclip1Click
      end
      object pureclip2: TMenuItem
        Caption = #1040#1074#1090#1086' ~pureclip'
        OnClick = pureclip2Click
      end
    end
    object N11: TMenuItem
      Caption = #1050#1083#1080#1087#1099
      object N12: TMenuItem
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100
        ShortCut = 45
        OnClick = N12Click
      end
      object N13: TMenuItem
        Caption = #1059#1076#1072#1083#1080#1090#1100
        ShortCut = 8238
        OnClick = N13Click
      end
      object N17: TMenuItem
        Caption = #1057#1090#1077#1088#1077#1090#1100' '#1076#1080#1085#1072#1084#1080#1095#1077#1089#1082#1080#1077
        ShortCut = 16430
        OnClick = N17Click
      end
      object N18: TMenuItem
        Caption = #1057#1090#1077#1088#1077#1090#1100' '#1074#1089#1077
        OnClick = N18Click
      end
      object N14: TMenuItem
        Caption = '-'
      end
      object N15: TMenuItem
        Caption = #1054#1073#1099#1095#1085#1072#1103' '#1074#1089#1090#1072#1074#1082#1072
        RadioItem = True
        OnClick = N15Click
      end
      object N16: TMenuItem
        Caption = #1057#1080#1084#1091#1083#1103#1094#1080#1103' '#1082#1083#1072#1074#1080#1072#1090#1091#1088#1099
        RadioItem = True
        OnClick = N15Click
      end
      object N19: TMenuItem
        Caption = #1057#1077#1088#1080#1081#1085#1099#1081' '#1085#1086#1084#1077#1088' 1'
        RadioItem = True
        OnClick = N15Click
      end
      object N21: TMenuItem
        Caption = #1057#1077#1088#1080#1081#1085#1099#1081' '#1085#1086#1084#1077#1088' 2'
        RadioItem = True
        OnClick = N15Click
      end
    end
    object N7: TMenuItem
      Caption = #1057#1087#1088#1072#1074#1082#1072
      object N8: TMenuItem
        Caption = #1057#1087#1088#1072#1074#1082#1072
        ShortCut = 112
        OnClick = N8Click
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object N10: TMenuItem
        Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
        OnClick = N10Click
      end
    end
  end
  object Dummy: TPopupMenu
    Left = 40
    Top = 32
  end
end
