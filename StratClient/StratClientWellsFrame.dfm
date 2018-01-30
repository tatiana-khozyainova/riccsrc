object frmWells: TfrmWells
  Left = 0
  Top = 0
  Width = 582
  Height = 569
  TabOrder = 0
  object spl1: TSplitter
    Left = 0
    Top = 316
    Width = 582
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  object pnlThemes: TPanel
    Left = 0
    Top = 0
    Width = 582
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      582
      41)
    object lblThemesSelected: TLabel
      Left = 8
      Top = 16
      Width = 143
      Height = 13
      Caption = #1042#1099#1073#1088#1072#1085#1085#1099#1077' '#1090#1077#1084#1099': '#1074#1089#1077' '#1090#1077#1084#1099
    end
    object btnThemeSelec: TButton
      Left = 460
      Top = 8
      Width = 115
      Height = 25
      Action = actnThemeSelect
      Anchors = [akRight, akBottom]
      TabOrder = 0
    end
  end
  object gbxWells: TGroupBox
    Left = 0
    Top = 41
    Width = 582
    Height = 275
    Align = alClient
    Caption = #1057#1082#1074#1072#1078#1080#1085#1099
    TabOrder = 1
    object lwWells: TListView
      Left = 2
      Top = 15
      Width = 578
      Height = 258
      Align = alClient
      Checkboxes = True
      Columns = <
        item
          Caption = #1055#1083#1086#1097#1072#1076#1100
          Width = -2
          WidthType = (
            -2)
        end
        item
          Caption = #1053#1086#1084#1077#1088
          Width = -2
          WidthType = (
            -2)
        end
        item
          Caption = #1047#1072#1073#1086#1081
          Width = -2
          WidthType = (
            -2)
        end
        item
          Caption = #1040#1083#1100#1090#1080#1090#1091#1076#1072
          Width = -2
          WidthType = (
            -2)
        end>
      ReadOnly = True
      RowSelect = True
      PopupMenu = pmTools
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
  inline frmSubdivisionEditFrame1: TfrmSubdivisionEditFrame
    Left = 0
    Top = 319
    Width = 582
    Height = 250
    Align = alBottom
    TabOrder = 2
    inherited grdSubdivisionTable: TGridView
      Width = 582
      Height = 71
    end
    inherited lwErrors: TListView
      Top = 100
      Width = 582
    end
    inherited tlbrButtons: TToolBar
      Width = 582
    end
  end
  object pmTools: TPopupMenu
    Left = 264
    Top = 72
    object N1: TMenuItem
      Action = actnSelectAll
    end
    object N2: TMenuItem
      Action = actnDeselectAll
    end
    object actnSwitchSelection1: TMenuItem
      Action = actnSwitchSelection
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object actnViewSubs1: TMenuItem
      Action = actnViewSubs
    end
    object actnEditSubs1: TMenuItem
      Action = actnEditSubs
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object actnExcelExport1: TMenuItem
      Action = actnExcelExport
    end
  end
  object actnlstWells: TActionList
    Left = 312
    Top = 40
    object actnSelectAll: TAction
      Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077
      OnExecute = actnSelectAllExecute
      OnUpdate = actnSelectAllUpdate
    end
    object actnDeselectAll: TAction
      Caption = #1057#1085#1103#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1080#1077
      OnExecute = actnDeselectAllExecute
      OnUpdate = actnDeselectAllUpdate
    end
    object actnViewSubs: TAction
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088#1077#1090#1100' '#1088#1072#1079#1073#1080#1074#1082#1080
      OnExecute = actnViewSubsExecute
      OnUpdate = actnViewSubsUpdate
    end
    object actnSwitchSelection: TAction
      Caption = #1055#1077#1088#1077#1082#1083#1102#1095#1080#1090#1100' '#1074#1099#1073#1086#1088#1082#1091
      OnExecute = actnSwitchSelectionExecute
      OnUpdate = actnSwitchSelectionUpdate
    end
    object actnThemeSelect: TAction
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1090#1077#1084#1099' '#1053#1048#1056
      OnExecute = actnThemeSelectExecute
    end
    object actnExcelExport: TAction
      Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074' MS Excel'
      OnExecute = actnExcelExportExecute
      OnUpdate = actnExcelExportUpdate
    end
    object actnEditSubs: TAction
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1079#1073#1080#1074#1082#1080
      OnExecute = actnEditSubsExecute
      OnUpdate = actnEditSubsUpdate
    end
    object actnImportSubs: TAction
      Caption = #1048#1084#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1079#1073#1080#1074#1082#1080
      OnExecute = actnImportSubsExecute
    end
  end
  object dlgOpen: TOpenDialog
    DefaultExt = 'xlsx'
    Filter = #1060#1072#1081#1083#1099' MS Excel 2007|*.xlsx|'#1060#1072#1081#1083#1099' MS Excel 2003|*.xls'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 280
    Top = 272
  end
end
