object frmSlottingReportSettings: TfrmSlottingReportSettings
  Left = 535
  Top = 300
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1086#1090#1095#1077#1090
  ClientHeight = 213
  ClientWidth = 351
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
    Top = 172
    Width = 351
    Height = 41
    Align = alBottom
    TabOrder = 0
    object btnOK: TButton
      Left = 192
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 272
      Top = 8
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object gbxElements: TGroupBox
    Left = 0
    Top = 0
    Width = 351
    Height = 172
    Align = alClient
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1086#1090#1095#1077#1090#1072
    TabOrder = 1
    object chbxUseStrat: TCheckBox
      Left = 8
      Top = 24
      Width = 329
      Height = 17
      Caption = #1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1089#1090#1088#1072#1090#1080#1075#1088#1072#1092#1080#1102' '#1087#1086' '#1076#1072#1085#1085#1099#1084' '#1082#1077#1088#1085#1086#1093#1088#1072#1085#1080#1083#1080#1097#1072
      TabOrder = 0
    end
    object chbxShowMetersDrilled: TCheckBox
      Left = 8
      Top = 48
      Width = 313
      Height = 17
      Caption = #1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1087#1088#1086#1093#1086#1076#1082#1091
      TabOrder = 1
    end
    object chbxSaveFiles: TCheckBox
      Left = 8
      Top = 112
      Width = 225
      Height = 17
      Caption = #1089#1086#1093#1088#1072#1085#1103#1090#1100' '#1086#1090#1095#1077#1090#1099
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = chbxSaveFilesClick
    end
    object edtReportPath: TDirectoryEdit
      Left = 8
      Top = 136
      Width = 337
      Height = 21
      DirectInput = False
      NumGlyphs = 1
      TabOrder = 3
      Text = 'D:\Temp'
    end
    object chbxUseGenSection: TCheckBox
      Left = 8
      Top = 72
      Width = 313
      Height = 17
      Caption = #1074#1082#1083#1102#1095#1072#1090#1100' '#1080#1085#1090#1077#1088#1074#1072#1083#1099' '#1074' '#1089#1074#1086#1076#1085#1099#1093' '#1088#1072#1079#1088#1077#1079#1072#1093
      TabOrder = 4
    end
  end
end
