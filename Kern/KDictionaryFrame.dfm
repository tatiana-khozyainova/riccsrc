object frmDictionary: TfrmDictionary
  Left = 0
  Top = 0
  Width = 443
  Height = 269
  Align = alClient
  TabOrder = 0
  object lstAllWords: TListBox
    Left = 0
    Top = 0
    Width = 443
    Height = 237
    Style = lbOwnerDrawFixed
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    Sorted = True
    TabOrder = 0
    OnDblClick = lstAllWordsDblClick
    OnDrawItem = lstAllWordsDrawItem
    OnKeyDown = lstAllWordsKeyDown
    OnKeyUp = lstAllWordsKeyUp
    OnMouseDown = lstAllWordsMouseDown
  end
  inline frmButtons: TfrmButtons
    Left = 0
    Top = 237
    Width = 443
    Height = 32
    Align = alBottom
    TabOrder = 1
    Visible = False
    inherited tlbr: TToolBar
      Height = 32
    end
  end
end
