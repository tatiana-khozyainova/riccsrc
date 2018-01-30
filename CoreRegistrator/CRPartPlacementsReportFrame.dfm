inherited frmPartPlacementsReport: TfrmPartPlacementsReport
  Height = 441
  inherited spl1: TSplitter
    Height = 317
  end
  inherited StatusBar: TStatusBar
    Top = 317
  end
  inherited trwHierarchy: TTreeView
    Height = 317
  end
  inherited frmPartPlacement1: TfrmPartPlacement
    Height = 317
    inherited StatusBar: TStatusBar
      Top = 298
    end
    inherited gbxProperties: TGroupBox
      Height = 298
    end
  end
  object gbxSettings: TGroupBox [4]
    Left = 0
    Top = 336
    Width = 762
    Height = 105
    Align = alBottom
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
    TabOrder = 3
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
    object chbxPlacementTotals: TCheckBox
      Left = 8
      Top = 35
      Width = 225
      Height = 17
      Caption = #1074#1082#1083#1102#1095#1072#1090#1100' '#1080#1090#1086#1075#1080' '#1087#1086' '#1084#1077#1089#1090#1086#1087#1086#1083#1086#1078#1077#1085#1080#1102
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object chbxOverallTotal: TCheckBox
      Left = 251
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
