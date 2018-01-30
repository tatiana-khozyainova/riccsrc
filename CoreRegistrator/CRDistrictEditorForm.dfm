object frmDistrictReportForm: TfrmDistrictReportForm
  Left = 468
  Top = 66
  Width = 877
  Height = 540
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1075#1077#1086#1075#1088#1072#1092#1080#1095#1077#1089#1082#1080#1084' '#1088#1077#1075#1080#1086#1085#1072#1084
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
    Top = 460
    Width = 861
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object btnOK: TButton
      Left = 696
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 776
      Top = 8
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  inline frmDistricts: TfrmParentChild
    Left = 0
    Top = 0
    Width = 861
    Height = 355
    Align = alClient
    TabOrder = 1
    inherited StatusBar: TStatusBar
      Top = 336
      Width = 861
    end
    inherited trwHierarchy: TTreeView
      Width = 861
      Height = 336
    end
  end
  object gbxSettings: TGroupBox
    Left = 0
    Top = 355
    Width = 861
    Height = 105
    Align = alBottom
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
    TabOrder = 2
    object chbxAreaTotals: TCheckBox
      Left = 8
      Top = 19
      Width = 313
      Height = 17
      Caption = #1074#1082#1083#1102#1095#1072#1090#1100' '#1080#1090#1086#1075#1080' '#1087#1086' '#1087#1083#1086#1097#1072#1076#1103#1084
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object chbxDistrictTotals: TCheckBox
      Left = 8
      Top = 35
      Width = 257
      Height = 17
      Caption = #1074#1082#1083#1102#1095#1072#1090#1100' '#1080#1090#1086#1075#1080' '#1087#1086' '#1075#1077#1086#1075#1088#1072#1092#1080#1095#1077#1089#1082#1080#1084' '#1088#1077#1075#1080#1086#1085#1072#1084
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object chbxOverallTotal: TCheckBox
      Left = 272
      Top = 19
      Width = 169
      Height = 17
      Caption = #1074#1082#1083#1102#1095#1072#1090#1100' '#1086#1073#1097#1080#1081' '#1080#1090#1086#1075
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object chbxSaveFiles: TCheckBox
      Left = 8
      Top = 61
      Width = 225
      Height = 17
      Caption = #1089#1086#1093#1088#1072#1085#1103#1090#1100' '#1086#1090#1095#1077#1090#1099
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = chbxSaveFilesClick
    end
    object edtReportPath: TDirectoryEdit
      Left = 8
      Top = 78
      Width = 337
      Height = 21
      DirectInput = False
      NumGlyphs = 1
      TabOrder = 4
      Text = 'D:\Temp'
    end
  end
end
