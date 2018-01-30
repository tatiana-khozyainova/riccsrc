object Frame2: TFrame2
  Left = 0
  Top = 0
  Width = 821
  Height = 657
  TabOrder = 0
  object tvSeisMaterial: TTreeView
    Left = 0
    Top = 0
    Width = 400
    Height = 640
    Align = alLeft
    Anchors = [akLeft, akTop, akRight, akBottom]
    Constraints.MaxWidth = 750
    Constraints.MinHeight = 640
    Constraints.MinWidth = 350
    Indent = 19
    ReadOnly = True
    TabOrder = 0
  end
  object lvSeisMaterialProperty: TListView
    Left = 400
    Top = 0
    Width = 421
    Height = 640
    Align = alClient
    Columns = <
      item
        AutoSize = True
      end
      item
        Width = 0
      end>
    Constraints.MinHeight = 640
    Constraints.MinWidth = 420
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = []
    GridLines = True
    MultiSelect = True
    ParentFont = False
    TabOrder = 1
    ViewStyle = vsReport
    OnCustomDrawItem = lvSeisMaterialPropertyCustomDrawItem
  end
  object pbLoadDict: TProgressBar
    Left = 0
    Top = 640
    Width = 821
    Height = 17
    Align = alBottom
    TabOrder = 2
  end
  object actlstSeisMaterialList: TActionList
    Left = 176
    Top = 104
    object actOpen: TAction
      Caption = 'actOpen'
    end
    object actSelectProperty: TAction
      Caption = 'actSelectProperty'
    end
    object actDrawItemList: TAction
      Caption = 'actDrawItemList'
    end
  end
end
