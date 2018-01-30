object frmSelectVersion: TfrmSelectVersion
  Left = 405
  Top = 185
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1042#1099#1073#1086#1088' '#1074#1077#1088#1089#1080#1080
  ClientHeight = 124
  ClientWidth = 562
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
    Width = 562
    Height = 83
    Align = alClient
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1074#1077#1088#1089#1080#1102
    TabOrder = 0
    object cmbxVersion: TComboBox
      Left = 16
      Top = 32
      Width = 529
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 83
    Width = 562
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnSelect: TButton
      Left = 400
      Top = 8
      Width = 75
      Height = 25
      Caption = #1042#1099#1073#1088#1072#1090#1100
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnClose: TButton
      Left = 480
      Top = 8
      Width = 75
      Height = 25
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ModalResult = 2
      TabOrder = 1
    end
  end
end
