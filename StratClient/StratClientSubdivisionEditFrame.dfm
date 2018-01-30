object frmSubdivisionEditFrame: TfrmSubdivisionEditFrame
  Left = 0
  Top = 0
  Width = 589
  Height = 416
  TabOrder = 0
  object grdSubdivisionTable: TGridView
    Left = 0
    Top = 29
    Width = 589
    Height = 237
    Align = alClient
    AllowEdit = True
    CheckStyle = csFlat
    Columns = <>
    DefaultEditMenu = True
    DoubleBuffered = True
    FlatBorder = True
    FlatScrollBars = True
    Header.AutoSynchronize = False
    Header.FullSynchronizing = True
    Header.Sections = <>
    Header.SectionHeight = 30
    Header.Synchronized = False
    ParentShowHint = False
    PopupMenu = pmComments
    Rows.Count = 10
    ShowCellTips = True
    ShowHint = True
    TabOrder = 0
    OnCellTips = grdSubdivisionTableCellTips
    OnEditAcceptKey = grdSubdivisionTableEditAcceptKey
    OnGetCellColors = grdSubdivisionTableGetCellColors
    OnGetCellText = grdSubdivisionTableGetCellText
    OnGetHeaderColors = grdSubdivisionTableGetHeaderColors
    OnHeaderClick = grdSubdivisionTableHeaderClick
    OnMouseDown = grdSubdivisionTableMouseDown
    OnSetEditText = grdSubdivisionTableSetEditText
  end
  object lwErrors: TListView
    Left = 0
    Top = 266
    Width = 589
    Height = 150
    Align = alBottom
    Columns = <
      item
        Caption = 'C'#1090#1086#1083#1073#1077#1094
        Width = -2
        WidthType = (
          -2)
      end
      item
        Caption = #1057#1090#1088#1086#1082#1072
        Width = -2
        WidthType = (
          -2)
      end
      item
        Caption = #1054#1096#1080#1073#1082#1072
        Width = -2
        WidthType = (
          -2)
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
    OnColumnClick = lwErrorsColumnClick
    OnDblClick = lwErrorsDblClick
  end
  object tlbrButtons: TToolBar
    Left = 0
    Top = 0
    Width = 589
    Height = 29
    ButtonHeight = 21
    ButtonWidth = 88
    Caption = 'tlbrButtons'
    Flat = True
    ShowCaptions = True
    TabOrder = 2
    object btnCheck: TToolButton
      Left = 0
      Top = 0
      Action = actnCheck
    end
    object btnSave: TToolButton
      Left = 88
      Top = 0
      Action = actnSavetoDB
    end
    object btnExportToExcel: TToolButton
      Left = 176
      Top = 0
      Action = actnExcelExport
    end
  end
  object pmComments: TPopupMenu
    OnPopup = pmCommentsPopup
    Left = 232
    Top = 80
  end
  object imglst1: TImageList
    Left = 512
    Top = 56
  end
  object actnlst: TActionList
    Images = imglst1
    Left = 520
    Top = 104
    object actnSavetoDB: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1041#1044
      OnExecute = actnSavetoDBExecute
      OnUpdate = actnSavetoDBUpdate
    end
    object actnCheck: TAction
      Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100
      OnExecute = actnCheckExecute
    end
    object actnExcelExport: TAction
      Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074' Excel'
      OnExecute = actnExcelExportExecute
    end
    object actnPlaceComment: TAction
      Caption = 'actnPlaceComment'
      OnExecute = actnPlaceCommentExecute
      OnUpdate = actnPlaceCommentUpdate
    end
    object actnGoToError: TAction
      Caption = #1054#1096#1080#1073#1082#1072
      OnExecute = actnGoToErrorExecute
      OnUpdate = actnGoToErrorUpdate
    end
  end
  object dlgOpen: TOpenDialog
    DefaultExt = 'xlsx'
    Filter = '*.xlsx|'#1060#1072#1081#1083#1099' MS Excel'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 280
    Top = 272
  end
end
