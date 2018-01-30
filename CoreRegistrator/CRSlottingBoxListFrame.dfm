inherited frmSlottingBoxListFrame: TfrmSlottingBoxListFrame
  Width = 788
  Height = 568
  object gbxBoxEdit: TGroupBox [0]
    Left = 0
    Top = 0
    Width = 788
    Height = 549
    Align = alClient
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1103#1097#1080#1082
    TabOrder = 0
  end
  object pnlBoxList: TPanel [1]
    Left = 0
    Top = 0
    Width = 788
    Height = 549
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 0
      Top = 0
      Width = 788
      Height = 3
      Cursor = crVSplit
      Align = alTop
    end
    object Splitter2: TSplitter
      Left = 488
      Top = 3
      Height = 546
      Align = alRight
    end
    object gbxList: TGroupBox
      Left = 0
      Top = 3
      Width = 488
      Height = 546
      Align = alClient
      Caption = #1057#1087#1080#1089#1086#1082' '#1103#1097#1080#1082#1086#1074
      TabOrder = 0
      inline frmButtons1: TfrmButtons
        Left = 2
        Top = 15
        Width = 484
        Height = 28
        Align = alTop
        TabOrder = 0
        inherited tlbr: TToolBar
          Width = 484
          Height = 28
        end
        inherited actnLst: TActionList
          inherited actnSave: TAction
            OnExecute = frmButtons1actnSaveExecute
          end
        end
      end
      object lwBoxes: TListView
        Left = 2
        Top = 43
        Width = 484
        Height = 501
        Align = alClient
        Checkboxes = True
        Columns = <
          item
            Caption = 'ID'
            Width = 20
          end
          item
            Caption = #1071#1097#1080#1082
          end>
        HideSelection = False
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 1
        ViewStyle = vsReport
        OnChange = lwBoxesChange
        OnClick = lwBoxesClick
      end
    end
    inline frmBoxEdit1: TfrmBoxProperties
      Left = 491
      Top = 3
      Width = 297
      Height = 546
      Align = alRight
      TabOrder = 1
      inherited StatusBar: TStatusBar
        Top = 527
        Width = 297
      end
      inherited gbxBoxProperties: TGroupBox
        Width = 297
        Height = 527
        inherited Panel1: TPanel
          Width = 293
        end
      end
    end
  end
  inherited StatusBar: TStatusBar
    Top = 549
    Width = 788
  end
end
