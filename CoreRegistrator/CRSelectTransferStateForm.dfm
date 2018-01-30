object frmSelectTransferStateDialog: TfrmSelectTransferStateDialog
  Left = 279
  Top = 232
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1042#1099#1073#1086#1088' '#1089#1086#1089#1090#1086#1103#1085#1080#1103' '#1089#1082#1074#1072#1078#1080#1085#1099
  ClientHeight = 127
  ClientWidth = 350
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object gbxAll: TGroupBox
    Left = 0
    Top = 0
    Width = 350
    Height = 84
    Align = alClient
    Caption = #1042#1099#1073#1086#1088' '#1089#1086#1089#1090#1086#1103#1085#1080#1103' '#1089#1082#1074#1072#1078#1080#1085#1099
    TabOrder = 0
    object lblState: TLabel
      Left = 8
      Top = 32
      Width = 128
      Height = 13
      Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
    end
    object cmbxState: TComboBox
      Left = 8
      Top = 48
      Width = 329
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 84
    Width = 350
    Height = 43
    Align = alBottom
    TabOrder = 1
    object btnSelect: TButton
      Left = 184
      Top = 8
      Width = 75
      Height = 25
      Caption = #1042#1099#1073#1088#1072#1090#1100
      ModalResult = 1
      TabOrder = 0
    end
    object btnClose: TButton
      Left = 264
      Top = 8
      Width = 75
      Height = 25
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ModalResult = 2
      TabOrder = 1
    end
  end
end
