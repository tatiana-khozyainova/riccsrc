object frmIDObjectListFrame: TfrmIDObjectListFrame
  Left = 0
  Top = 0
  Width = 206
  Height = 350
  TabOrder = 0
  inline frmButtons1: TfrmButtons
    Left = 0
    Top = 0
    Width = 36
    Height = 350
    Align = alLeft
    TabOrder = 0
    inherited tlbr: TToolBar
      Width = 36
      Height = 350
      inherited ToolButton2: TToolButton
        Wrap = True
      end
      inherited btnSave: TToolButton
        Left = 0
        Top = 23
        Wrap = True
      end
      inherited ToolButton3: TToolButton
        Left = 0
        Top = 46
        Wrap = True
      end
      inherited ToolButton4: TToolButton
        Left = 0
        Top = 69
        Wrap = True
      end
      inherited ToolButton7: TToolButton
        Left = 0
        Top = 92
        Wrap = True
      end
      inherited btnAdd: TToolButton
        Left = 0
        Top = 115
        Wrap = True
      end
      inherited ToolButton11: TToolButton
        Left = 0
        Top = 138
        Wrap = True
      end
      inherited ToolButton10: TToolButton
        Left = 0
        Top = 161
        Wrap = True
      end
      inherited ToolButton6: TToolButton
        Left = 0
        Top = 184
        Wrap = True
      end
      inherited ToolButton8: TToolButton
        Left = 0
        Top = 207
        Wrap = True
      end
      inherited ToolButton9: TToolButton
        Left = 0
        Top = 230
        Wrap = True
      end
      inherited btnCancel: TToolButton
        Left = 0
        Top = 253
        Wrap = True
      end
    end
  end
  object lwObjects: TListView
    Left = 36
    Top = 0
    Width = 170
    Height = 350
    Align = alClient
    Columns = <
      item
        Caption = 'ID'
      end
      item
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      end>
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
    OnColumnClick = lwObjectsColumnClick
    OnCompare = lwObjectsCompare
    OnDblClick = lwObjectsDblClick
  end
end
