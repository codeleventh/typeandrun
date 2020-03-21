object Renum: TRenum
  Left = 200
  Top = 108
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsToolWindow
  Caption = 'Numeral corrector'
  ClientHeight = 158
  ClientWidth = 301
  Color = clBtnFace
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
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 29
    Height = 13
    Caption = 'Folder'
  end
  object Label2: TLabel
    Left = 8
    Top = 36
    Width = 47
    Height = 13
    Caption = 'Old mask:'
  end
  object Label3: TLabel
    Left = 8
    Top = 60
    Width = 53
    Height = 13
    Caption = 'New mask:'
  end
  object Label4: TLabel
    Left = 8
    Top = 84
    Width = 23
    Height = 13
    Caption = 'From'
  end
  object Label5: TLabel
    Left = 176
    Top = 84
    Width = 13
    Height = 13
    Caption = 'To'
  end
  object Pr: TProgressBar
    Left = 0
    Top = 145
    Width = 301
    Height = 13
    Align = alBottom
    Min = 0
    Max = 100
    TabOrder = 6
  end
  object Path: TEdit
    Left = 48
    Top = 8
    Width = 217
    Height = 21
    ReadOnly = True
    TabOrder = 0
  end
  object Br: TButton
    Left = 272
    Top = 8
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 1
    OnClick = BrClick
  end
  object OldM: TEdit
    Left = 88
    Top = 32
    Width = 177
    Height = 21
    TabOrder = 2
  end
  object NewM: TEdit
    Left = 88
    Top = 56
    Width = 177
    Height = 21
    TabOrder = 3
  end
  object Bnd1: TSpinEdit
    Left = 48
    Top = 80
    Width = 73
    Height = 22
    MaxValue = 32000
    MinValue = 0
    TabOrder = 4
    Value = 0
  end
  object Bnd2: TSpinEdit
    Left = 208
    Top = 80
    Width = 89
    Height = 22
    MaxValue = 32000
    MinValue = 0
    TabOrder = 5
    Value = 32000
  end
  object BitBtn1: TButton
    Left = 61
    Top = 112
    Width = 75
    Height = 25
    Caption = 'BitBtn1'
    Default = True
    TabOrder = 7
    OnClick = BitBtn1Click
  end
  object BitBtn2: TButton
    Left = 165
    Top = 112
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'BitBtn2'
    ModalResult = 2
    TabOrder = 8
  end
end
