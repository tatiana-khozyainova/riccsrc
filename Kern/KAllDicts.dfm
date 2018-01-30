object frmAllDicts: TfrmAllDicts
  Left = 0
  Top = 0
  Width = 316
  Height = 269
  Align = alLeft
  TabOrder = 0
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 316
    Height = 269
    Align = alClient
    Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    TabOrder = 0
    object lstAllDicts: TListBox
      Left = 2
      Top = 15
      Width = 312
      Height = 220
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
    end
    inline frmButtons: TfrmButtons
      Left = 2
      Top = 235
      Width = 312
      Height = 32
      Align = alBottom
      TabOrder = 1
      inherited tlbr: TToolBar
        Width = 312
        Height = 32
      end
    end
  end
end
