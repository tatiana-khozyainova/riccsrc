inherited frmRockSampleSizeTypesEdit: TfrmRockSampleSizeTypesEdit
  Width = 760
  Height = 459
  inherited StatusBar: TStatusBar
    Top = 440
    Width = 760
  end
  object grdSampleSizeTypes: TGridView
    Left = 0
    Top = 0
    Width = 760
    Height = 440
    Align = alClient
    AllowEdit = True
    AlwaysEdit = True
    Columns = <
      item
        Caption = #1058#1080#1087#1086#1088#1072#1079#1084#1077#1088' '#1086#1073#1088#1072#1079#1094#1072
        ReadOnly = True
        DefWidth = 400
      end
      item
        Alignment = taRightJustify
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
      end>
    Header.FullSynchronizing = True
    Header.Synchronized = True
    ShowCellTips = False
    TabOrder = 1
    ThemeXPEnabled = False
    OnDblClick = grdSampleSizeTypesDblClick
    OnGetCellText = grdSampleSizeTypesGetCellText
    OnSetEditText = grdSampleSizeTypesSetEditText
  end
end
