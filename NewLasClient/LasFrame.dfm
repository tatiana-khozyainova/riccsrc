object Frame1: TFrame1
  Left = 0
  Top = 0
  Width = 611
  Height = 453
  TabOrder = 0
  object spl1: TSplitter
    Left = 300
    Top = 0
    Height = 453
  end
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 300
    Height = 453
    Align = alLeft
    Caption = 'pnl1'
    TabOrder = 0
    object trwLas: TTreeView
      Left = 1
      Top = 1
      Width = 298
      Height = 451
      Align = alClient
      Indent = 19
      TabOrder = 0
    end
  end
  object pnl2: TPanel
    Left = 303
    Top = 0
    Width = 308
    Height = 453
    Align = alClient
    Caption = 'pnl2'
    TabOrder = 1
    object lst1: TListBox
      Left = 1
      Top = 1
      Width = 306
      Height = 451
      Style = lbOwnerDrawFixed
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnDrawItem = lst1DrawItem
    end
  end
end
