object URLLister: TURLLister
  Left = 230
  Top = 240
  BorderStyle = bsToolWindow
  Caption = 'URL List Generator'
  ClientHeight = 336
  ClientWidth = 388
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
    Top = 8
    Width = 81
    Height = 13
    AutoSize = False
    Caption = 'Link'
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 129
    Height = 13
    AutoSize = False
    Caption = 'Primary index'
  end
  object Label3: TLabel
    Left = 8
    Top = 56
    Width = 73
    Height = 13
    AutoSize = False
    Caption = 'From'
  end
  object Label4: TLabel
    Left = 8
    Top = 80
    Width = 81
    Height = 13
    AutoSize = False
    Caption = 'To'
  end
  object Label5: TLabel
    Left = 8
    Top = 104
    Width = 81
    Height = 13
    AutoSize = False
    Caption = 'Step'
  end
  object Label6: TLabel
    Left = 8
    Top = 128
    Width = 81
    Height = 13
    AutoSize = False
    Caption = 'Numbers'
  end
  object Label7: TLabel
    Left = 8
    Top = 152
    Width = 81
    Height = 13
    AutoSize = False
    Caption = 'Subst'
  end
  object Link: TEdit
    Left = 96
    Top = 4
    Width = 281
    Height = 21
    MaxLength = 80
    TabOrder = 0
    Text = 'Link'
  end
  object I1_1: TSpinEdit
    Left = 88
    Top = 52
    Width = 73
    Height = 22
    MaxLength = 5
    MaxValue = 32000
    MinValue = 0
    TabOrder = 1
    Value = 0
  end
  object I1_2: TSpinEdit
    Left = 88
    Top = 76
    Width = 73
    Height = 22
    MaxLength = 5
    MaxValue = 32000
    MinValue = 0
    TabOrder = 2
    Value = 0
  end
  object I1_3: TSpinEdit
    Left = 88
    Top = 100
    Width = 73
    Height = 22
    MaxLength = 5
    MaxValue = 1000
    MinValue = 1
    TabOrder = 3
    Value = 1
  end
  object I1_4: TSpinEdit
    Left = 88
    Top = 124
    Width = 73
    Height = 22
    MaxLength = 5
    MaxValue = 5
    MinValue = 1
    TabOrder = 4
    Value = 2
  end
  object I2_1: TSpinEdit
    Left = 200
    Top = 52
    Width = 73
    Height = 22
    MaxLength = 5
    MaxValue = 32000
    MinValue = 0
    TabOrder = 5
    Value = 0
  end
  object I2_2: TSpinEdit
    Left = 200
    Top = 76
    Width = 73
    Height = 22
    MaxLength = 5
    MaxValue = 32000
    MinValue = 0
    TabOrder = 6
    Value = 0
  end
  object I2_3: TSpinEdit
    Left = 200
    Top = 100
    Width = 73
    Height = 22
    MaxLength = 5
    MaxValue = 1000
    MinValue = 1
    TabOrder = 7
    Value = 1
  end
  object I2_4: TSpinEdit
    Left = 200
    Top = 124
    Width = 73
    Height = 22
    MaxLength = 5
    MaxValue = 5
    MinValue = 1
    TabOrder = 8
    Value = 2
  end
  object Secondary: TCheckBox
    Left = 168
    Top = 32
    Width = 121
    Height = 17
    Caption = 'Secondary index'
    TabOrder = 9
    OnClick = SecondaryClick
  end
  object I1_5: TEdit
    Left = 88
    Top = 148
    Width = 73
    Height = 21
    MaxLength = 3
    TabOrder = 10
    Text = '@'
  end
  object I2_5: TEdit
    Left = 200
    Top = 148
    Width = 73
    Height = 21
    MaxLength = 3
    TabOrder = 11
    Text = '#'
  end
  object Data: TMemo
    Left = 8
    Top = 176
    Width = 369
    Height = 153
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 12
  end
  object Button1: TButton
    Left = 296
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Start'
    Default = True
    TabOrder = 13
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 296
    Top = 80
    Width = 75
    Height = 25
    Caption = 'To file'
    TabOrder = 14
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 296
    Top = 112
    Width = 75
    Height = 25
    Caption = 'To clip'
    TabOrder = 15
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 296
    Top = 144
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Exit'
    ModalResult = 1
    TabOrder = 16
  end
  object Save: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 8
    Top = 4
  end
end
