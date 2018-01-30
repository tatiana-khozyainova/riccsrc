object frmTectBlock: TfrmTectBlock
  Left = 188
  Top = 143
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  ClientHeight = 91
  ClientWidth = 297
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object gbxTectBlock: TGroupBox
    Left = 0
    Top = 0
    Width = 297
    Height = 49
    Align = alClient
    Caption = #1058#1077#1082#1090#1086#1085#1080#1095#1077#1089#1082#1080#1081' '#1073#1083#1086#1082
    TabOrder = 0
    object cmbxTectBlock: TComboBox
      Left = 6
      Top = 19
      Width = 284
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = cmbxTectBlockChange
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 49
    Width = 297
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnOK: TButton
      Left = 140
      Top = 10
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 220
      Top = 10
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
end
