object frmTextEdit: TfrmTextEdit
  Left = 242
  Top = 225
  BorderStyle = bsSingle
  Caption = 'frmTextEdit'
  ClientHeight = 321
  ClientWidth = 492
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 280
    Width = 492
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object btnCancel: TButton
      Left = 400
      Top = 8
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 0
    end
  end
  object btnOK: TButton
    Left = 320
    Top = 288
    Width = 75
    Height = 25
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object gbxAll: TGroupBox
    Left = 0
    Top = 0
    Width = 492
    Height = 280
    Align = alClient
    Caption = #1058#1077#1082#1089#1090
    TabOrder = 2
    object mmText: TRichEdit
      Left = 2
      Top = 15
      Width = 488
      Height = 263
      Align = alClient
      TabOrder = 0
    end
  end
end
