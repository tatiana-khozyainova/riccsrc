object frmCoreTransferFullReport: TfrmCoreTransferFullReport
  Left = 419
  Top = 353
  Width = 589
  Height = 205
  Caption = #1058#1077#1082#1091#1097#1072#1103' '#1090#1072#1073#1083#1080#1094#1072' '#1087#1077#1088#1077#1074#1086#1079#1082#1080
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
    Top = 125
    Width = 573
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object btnOK: TButton
      Left = 408
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 488
      Top = 8
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object gbxParameters: TGroupBox
    Left = 0
    Top = 0
    Width = 573
    Height = 125
    Align = alClient
    Caption = #1058#1077#1082#1091#1097#1072#1103' '#1090#1072#1073#1083#1080#1094#1072' '#1087#1077#1088#1077#1074#1086#1079#1082#1080' - '#1087#1072#1088#1072#1084#1077#1090#1088#1099
    TabOrder = 1
    object chbxUseCurrentWells: TCheckBox
      Left = 8
      Top = 32
      Width = 465
      Height = 17
      Caption = #1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1089#1082#1074#1072#1078#1080#1085#1099' '#1092#1080#1083#1100#1090#1088#1072
      TabOrder = 0
    end
    object chbxSaveFiles: TCheckBox
      Left = 8
      Top = 61
      Width = 225
      Height = 17
      Caption = #1089#1086#1093#1088#1072#1085#1103#1090#1100' '#1086#1090#1095#1077#1090#1099
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object edtReportPath: TDirectoryEdit
      Left = 8
      Top = 78
      Width = 337
      Height = 21
      DirectInput = False
      NumGlyphs = 1
      TabOrder = 2
      Text = 'D:\Temp'
    end
  end
end
