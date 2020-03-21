object frmTypeDropDown: TfrmTypeDropDown
  Left = 549
  Top = 420
  BorderStyle = bsNone
  ClientHeight = 119
  ClientWidth = 257
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lstDropDown: TListBox
    Left = 0
    Top = 0
    Width = 257
    Height = 119
    Align = alClient
    BorderStyle = bsNone
    ItemHeight = 13
    TabOrder = 0
    OnClick = lstDropDownClick
    OnKeyDown = lstDropDownKeyDown
    OnKeyPress = lstDropDownKeyPress
    OnKeyUp = lstDropDownKeyUp
  end
end
