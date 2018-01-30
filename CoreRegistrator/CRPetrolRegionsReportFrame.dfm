inherited frmPetrolRegionsReport: TfrmPetrolRegionsReport
  Left = 453
  Top = 200
  Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1086#1090#1095#1077#1090' '#1087#1086' '#1053#1043#1056
  PixelsPerInch = 96
  TextHeight = 13
  inherited frmPetrolRegions: TfrmParentChild
    Height = 400
    inherited StatusBar: TStatusBar
      Top = 381
      Visible = False
    end
    inherited trwHierarchy: TTreeView
      Height = 381
    end
  end
  object gbxSettings: TGroupBox
    Left = 0
    Top = 400
    Width = 854
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
    object chbxNGRTotals: TCheckBox
      Left = 8
      Top = 35
      Width = 185
      Height = 17
      Caption = #1074#1082#1083#1102#1095#1072#1090#1100' '#1080#1090#1086#1075#1080' '#1087#1086' '#1053#1043#1056
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object chbxNGOTotals: TCheckBox
      Left = 192
      Top = 19
      Width = 177
      Height = 17
      Caption = #1074#1082#1083#1102#1095#1072#1090#1100' '#1080#1090#1086#1075#1080' '#1087#1086' '#1053#1043#1054
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object chbxOverallTotal: TCheckBox
      Left = 192
      Top = 35
      Width = 169
      Height = 17
      Caption = #1074#1082#1083#1102#1095#1072#1090#1100' '#1086#1073#1097#1080#1081' '#1080#1090#1086#1075
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object chbxSaveFiles: TCheckBox
      Left = 8
      Top = 61
      Width = 225
      Height = 17
      Caption = #1089#1086#1093#1088#1072#1085#1103#1090#1100' '#1086#1090#1095#1077#1090#1099
      Checked = True
      State = cbChecked
      TabOrder = 4
      OnClick = chbxSaveFilesClick
    end
    object edtReportPath: TDirectoryEdit
      Left = 8
      Top = 78
      Width = 337
      Height = 21
      DirectInput = False
      NumGlyphs = 1
      TabOrder = 5
      Text = 'D:\Temp'
    end
  end
end
