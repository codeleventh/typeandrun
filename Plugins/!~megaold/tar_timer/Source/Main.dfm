object Base: TBase
  Left = 241
  Top = 140
  ActiveControl = Sheds
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsToolWindow
  Caption = #1055#1088#1086#1074#1077#1088#1082#1072' OSD'
  ClientHeight = 447
  ClientWidth = 414
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
  object Sheds: TListBox
    Left = 8
    Top = 8
    Width = 129
    Height = 389
    ItemHeight = 13
    TabOrder = 0
    OnClick = ShedsClick
    OnKeyDown = ShedsKeyDown
  end
  object GroupBox1: TGroupBox
    Left = 145
    Top = 56
    Width = 265
    Height = 273
    Caption = #1042#1088#1077#1084#1103' '#1089#1088#1072#1073#1072#1090#1099#1074#1072#1085#1080#1103
    TabOrder = 2
    object Label2: TLabel
      Left = 8
      Top = 58
      Width = 28
      Height = 13
      Caption = #1063#1072#1089#1099
    end
    object Label3: TLabel
      Left = 72
      Top = 56
      Width = 39
      Height = 13
      Caption = #1052#1080#1085#1091#1090#1099
    end
    object Label5: TLabel
      Left = 136
      Top = 56
      Width = 60
      Height = 13
      Caption = #1044#1085#1080' '#1085#1077#1076#1077#1083#1080
    end
    object Label6: TLabel
      Left = 8
      Top = 152
      Width = 21
      Height = 13
      Caption = #1044#1085#1080
    end
    object Label7: TLabel
      Left = 80
      Top = 152
      Width = 41
      Height = 13
      Caption = #1052#1077#1089#1103#1094#1099
    end
    object Label8: TLabel
      Left = 176
      Top = 152
      Width = 26
      Height = 13
      Caption = #1043#1086#1076#1099
    end
    object Label4: TLabel
      Left = 8
      Top = 16
      Width = 64
      Height = 13
      Caption = 'Cron '#1092#1086#1088#1084#1072#1090
    end
    object Hours: TCheckListBox
      Left = 8
      Top = 72
      Width = 57
      Height = 81
      OnClickCheck = HoursClickCheck
      ItemHeight = 13
      PopupMenu = HoursPop
      TabOrder = 3
    end
    object Mins: TCheckListBox
      Left = 72
      Top = 72
      Width = 57
      Height = 81
      OnClickCheck = HoursClickCheck
      ItemHeight = 13
      PopupMenu = MinPop
      TabOrder = 4
    end
    object Dows: TCheckListBox
      Left = 136
      Top = 72
      Width = 121
      Height = 81
      OnClickCheck = HoursClickCheck
      ItemHeight = 13
      Items.Strings = (
        #1042#1086#1089#1082#1088#1077#1089#1077#1085#1100#1077
        #1055#1086#1085#1077#1076#1077#1083#1100#1085#1080#1082
        #1042#1090#1086#1088#1085#1080#1082
        #1057#1088#1077#1076#1072
        #1063#1077#1090#1074#1077#1088#1075
        #1055#1103#1090#1085#1080#1094#1072
        #1057#1091#1073#1073#1086#1090#1072)
      PopupMenu = DowsPop
      TabOrder = 5
    end
    object Days: TCheckListBox
      Left = 8
      Top = 168
      Width = 65
      Height = 85
      OnClickCheck = HoursClickCheck
      ItemHeight = 13
      PopupMenu = DaysPop
      TabOrder = 6
    end
    object Mons: TCheckListBox
      Left = 80
      Top = 168
      Width = 89
      Height = 85
      OnClickCheck = HoursClickCheck
      ItemHeight = 13
      Items.Strings = (
        #1071#1085#1074#1072#1088#1100
        #1060#1077#1074#1088#1072#1083#1100
        #1052#1072#1088#1090
        #1040#1087#1088#1077#1083#1100
        #1052#1072#1081
        #1048#1102#1085#1100
        #1048#1102#1083#1100
        #1040#1074#1075#1091#1089#1090
        #1057#1077#1085#1090#1103#1073#1088#1100
        #1054#1082#1090#1103#1073#1088#1100
        #1053#1086#1103#1073#1088#1100
        #1044#1077#1082#1072#1073#1088#1100)
      PopupMenu = MonPop
      TabOrder = 7
    end
    object Years: TCheckListBox
      Left = 176
      Top = 168
      Width = 81
      Height = 85
      OnClickCheck = HoursClickCheck
      ItemHeight = 13
      PopupMenu = YearPop
      TabOrder = 8
    end
    object Input: TEdit
      Left = 8
      Top = 32
      Width = 193
      Height = 21
      TabOrder = 0
      Text = '*'
      OnChange = InputChange
    end
    object Cron1: TButton
      Left = 204
      Top = 32
      Width = 21
      Height = 21
      Hint = #1055#1077#1088#1077#1074#1077#1089#1090#1080' '#1074#1080#1079#1091#1072#1083#1100#1085#1086#1077' '#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1077' '#1074' Cron'
      Caption = 'S'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = Cron1Click
    end
    object Cron2: TButton
      Left = 228
      Top = 32
      Width = 21
      Height = 21
      Hint = #1055#1077#1088#1077#1074#1077#1089#1090#1080' Cron '#1074' '#1074#1080#1079#1091#1072#1083#1100#1085#1086#1077' '#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1077
      Caption = 'C'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = Cron2Click
    end
    object LateProc: TCheckBox
      Left = 8
      Top = 252
      Width = 249
      Height = 17
      Caption = #1054#1073#1088#1072#1073#1072#1090#1099#1074#1072#1090#1100' '#1086#1087#1086#1079#1076#1072#1085#1080#1103
      TabOrder = 9
      OnClick = HoursClickCheck
    end
  end
  object GroupBox2: TGroupBox
    Left = 144
    Top = 332
    Width = 265
    Height = 69
    Caption = #1058#1080#1087' '#1079#1072#1076#1072#1085#1080#1103
    TabOrder = 3
    object Label9: TLabel
      Left = 8
      Top = 20
      Width = 89
      Height = 13
      AutoSize = False
      Caption = #1063#1090#1086' '#1076#1077#1083#1072#1090#1100
    end
    object Label10: TLabel
      Left = 8
      Top = 44
      Width = 57
      Height = 13
      AutoSize = False
      Caption = #1055#1091#1090#1100
    end
    object TaskList: TComboBox
      Left = 96
      Top = 16
      Width = 161
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = TaskListChange
      Items.Strings = (
        #1057#1086#1086#1073#1097#1077#1085#1080#1077
        'On Screen Display'
        #1047#1072#1087#1091#1089#1082' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
        #1047#1072#1087#1091#1089#1082' '#1072#1083#1080#1072#1089#1072)
    end
    object Path: TEdit
      Left = 64
      Top = 40
      Width = 161
      Height = 21
      TabOrder = 1
      OnChange = HoursClickCheck
    end
    object PathBr: TButton
      Left = 232
      Top = 40
      Width = 21
      Height = 21
      Caption = '...'
      TabOrder = 2
      OnClick = PathBrClick
    end
  end
  object GroupBox3: TGroupBox
    Left = 144
    Top = 4
    Width = 264
    Height = 49
    Caption = #1054#1073#1097#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
    TabOrder = 1
    object CallID: TEdit
      Left = 8
      Top = 20
      Width = 249
      Height = 21
      TabOrder = 0
    end
  end
  object Button1: TButton
    Left = 184
    Top = 408
    Width = 75
    Height = 25
    Caption = 'Button1'
    Default = True
    ModalResult = 1
    TabOrder = 4
    OnClick = BitBtn1Click
  end
  object Button2: TButton
    Left = 296
    Top = 408
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Button2'
    ModalResult = 2
    TabOrder = 5
  end
  object CronAdd: TButton
    Left = 40
    Top = 400
    Width = 21
    Height = 21
    Caption = '+'
    TabOrder = 6
    OnClick = CronAddClick
  end
  object CronRem: TButton
    Left = 85
    Top = 400
    Width = 21
    Height = 21
    Caption = '-'
    TabOrder = 7
    OnClick = CronRemClick
  end
  object MinPop: TPopupMenu
    Left = 16
    Top = 80
    object MinSet: TMenuItem
      Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077
      OnClick = MinSetClick
    end
    object MinNo: TMenuItem
      Caption = #1057#1085#1103#1090#1100' '#1074#1089#1077
      OnClick = MinNoClick
    end
    object MinInvert: TMenuItem
      Caption = #1048#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1090#1100
      OnClick = MinInvertClick
    end
  end
  object DowsPop: TPopupMenu
    Left = 16
    Top = 112
    object DowSet: TMenuItem
      Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077
      OnClick = DowSetClick
    end
    object DowNo: TMenuItem
      Caption = #1057#1085#1103#1090#1100' '#1074#1089#1077
      OnClick = DowNoClick
    end
    object DowInvert: TMenuItem
      Caption = #1048#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1090#1100
      OnClick = DowInvertClick
    end
    object N1: TMenuItem
      Caption = #1042#1099#1093#1086#1076#1085#1099#1077
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #1041#1091#1076#1085#1080
      OnClick = N2Click
    end
  end
  object DaysPop: TPopupMenu
    Left = 16
    Top = 144
    object DaysSet: TMenuItem
      Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077
      OnClick = DaysSetClick
    end
    object DaysNo: TMenuItem
      Caption = #1057#1085#1103#1090#1100' '#1074#1089#1077
      OnClick = DaysNoClick
    end
    object DaysInvert: TMenuItem
      Caption = #1048#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1090#1100
      OnClick = DaysInvertClick
    end
  end
  object MonPop: TPopupMenu
    Left = 16
    Top = 176
    object MonSet: TMenuItem
      Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077
      OnClick = MonSetClick
    end
    object MonNo: TMenuItem
      Caption = #1057#1085#1103#1090#1100' '#1074#1089#1077
      OnClick = MonNoClick
    end
    object MonInvert: TMenuItem
      Caption = #1048#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1090#1100
      OnClick = MonInvertClick
    end
  end
  object YearPop: TPopupMenu
    Left = 16
    Top = 208
    object YearSet: TMenuItem
      Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077
      OnClick = YearSetClick
    end
    object YearNo: TMenuItem
      Caption = #1057#1085#1103#1090#1100' '#1074#1089#1077
      OnClick = YearNoClick
    end
    object YearInvert: TMenuItem
      Caption = #1048#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1090#1100
      OnClick = YearInvertClick
    end
  end
  object HoursPop: TPopupMenu
    Left = 16
    Top = 48
    object HoursSet: TMenuItem
      Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077
      OnClick = HoursSetClick
    end
    object HoursNo: TMenuItem
      Caption = #1057#1085#1103#1090#1100' '#1074#1089#1077
      OnClick = HoursNoClick
    end
    object HoursInvert: TMenuItem
      Caption = #1048#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1090#1100
      OnClick = HoursInvertClick
    end
  end
  object Open: TOpenDialog
    Left = 16
    Top = 16
  end
end
