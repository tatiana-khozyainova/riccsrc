object formReplac: TformReplac
  Left = 376
  Top = 257
  Width = 243
  Height = 247
  Caption = #1047#1072#1084#1077#1085#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object edtIn: TEdit
    Left = 8
    Top = 16
    Width = 217
    Height = 21
    Enabled = False
    TabOrder = 0
    Text = 'edtIn'
  end
  object edtOut: TEdit
    Left = 8
    Top = 56
    Width = 217
    Height = 21
    TabOrder = 1
    Text = 'edtOut'
    OnChange = edtOutChange
  end
  object btnOk: TButton
    Left = 80
    Top = 144
    Width = 75
    Height = 25
    Caption = #1047#1072#1084#1077#1085#1080#1090#1100
    ModalResult = 1
    TabOrder = 2
  end
  object cmbxCurves: TComboBox
    Left = 8
    Top = 104
    Width = 217
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    Visible = False
    OnChange = cmbxCurvesChange
  end
end
