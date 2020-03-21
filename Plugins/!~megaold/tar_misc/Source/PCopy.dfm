object TheCopy: TTheCopy
  Left = 198
  Top = 114
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsToolWindow
  Caption = 'Part copy'
  ClientHeight = 149
  ClientWidth = 265
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PrintScale = poNone
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 43
    Height = 13
    Caption = 'Input file:'
  end
  object Label2: TLabel
    Left = 8
    Top = 36
    Width = 51
    Height = 13
    Caption = 'Output file:'
  end
  object Label3: TLabel
    Left = 8
    Top = 60
    Width = 47
    Height = 13
    Caption = 'Copy from'
  end
  object Label4: TLabel
    Left = 8
    Top = 84
    Width = 45
    Height = 13
    Caption = 'Copy size'
  end
  object Label5: TLabel
    Left = 8
    Top = 108
    Width = 26
    Height = 13
    Caption = 'Level'
  end
  object Status: TLabel
    Left = 0
    Top = 136
    Width = 265
    Height = 13
    Align = alBottom
    Alignment = taCenter
    Caption = 'Status'
  end
  object Edit1: TEdit
    Left = 56
    Top = 8
    Width = 177
    Height = 21
    TabOrder = 0
    Text = 'E:\EXE\Common.dcu'
  end
  object Edit2: TEdit
    Left = 64
    Top = 32
    Width = 169
    Height = 21
    TabOrder = 2
    Text = 'E:\EXE\{filename}'
  end
  object Br1: TButton
    Left = 240
    Top = 8
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 1
    OnClick = Br1Click
  end
  object Br2: TButton
    Left = 240
    Top = 32
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 3
    OnClick = Br2Click
  end
  object Edit3: TEdit
    Left = 64
    Top = 56
    Width = 73
    Height = 21
    TabOrder = 4
    Text = 'Edit3'
  end
  object Edit4: TEdit
    Left = 64
    Top = 80
    Width = 73
    Height = 21
    TabOrder = 5
    Text = 'Edit4'
  end
  object MaxLevel: TTrackBar
    Left = 56
    Top = 104
    Width = 89
    Height = 25
    Max = 8
    Orientation = trHorizontal
    Frequency = 1
    Position = 3
    SelEnd = 0
    SelStart = 0
    TabOrder = 6
    TickMarks = tmBottomRight
    TickStyle = tsAuto
  end
  object BitBtn1: TButton
    Left = 168
    Top = 64
    Width = 75
    Height = 25
    Caption = 'BitBtn1'
    Default = True
    TabOrder = 7
    OnClick = BitBtn1Click
  end
  object BitBtn2: TButton
    Left = 168
    Top = 96
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'BitBtn2'
    TabOrder = 8
    OnClick = BitBtn2Click
  end
  object Open: TOpenDialog
    Options = [ofHideReadOnly, ofNoValidate, ofPathMustExist]
    Left = 8
    Top = 8
  end
end
