object frmWellConfirm: TfrmWellConfirm
  Left = 178
  Top = 160
  Width = 439
  Height = 263
  BorderIcons = []
  Caption = #1057#1082#1074#1072#1078#1080#1085#1072' '#1085#1077' '#1085#1072#1081#1076#1077#1085#1072' ...'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 184
    Width = 423
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object btnOk: TButton
      Left = 260
      Top = 10
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
    object btnIgnore: TButton
      Left = 340
      Top = 10
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 5
      TabOrder = 1
    end
  end
  object gbxWell: TGroupBox
    Left = 0
    Top = 0
    Width = 423
    Height = 184
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 17
      Width = 47
      Height = 13
      Caption = #1055#1083#1086#1097#1072#1076#1100
    end
    object Label2: TLabel
      Left = 8
      Top = 82
      Width = 89
      Height = 13
      Caption = #1053#1086#1084#1077#1088' '#1089#1082#1074#1072#1078#1080#1085#1099
    end
    object lblReport: TLabel
      Left = 9
      Top = 125
      Width = 407
      Height = 48
      AutoSize = False
      WordWrap = True
    end
    object cmbxArea: TComboBox
      Left = 6
      Top = 37
      Width = 409
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      OnChange = cmbxAreaChange
    end
    object cmbxWellNum: TComboBox
      Left = 7
      Top = 102
      Width = 408
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      OnChange = cmbxWellNumChange
    end
  end
end
