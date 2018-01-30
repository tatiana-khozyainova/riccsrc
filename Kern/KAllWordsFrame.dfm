object frmAllWords: TfrmAllWords
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    Align = alClient
    Caption = #1047#1085#1072#1095#1077#1085#1080#1103' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
    TabOrder = 0
    inline frmButtons: TfrmButtons
      Left = 2
      Top = 206
      Width = 316
      Height = 32
      Align = alBottom
      TabOrder = 0
      inherited tlbr: TToolBar
        Width = 316
        Height = 32
      end
      inherited actnLst: TActionList
        inherited actnAdd: TAction
          OnExecute = frmButtonsactnAddExecute
        end
      end
    end
    object lstAllWords: TListBox
      Left = 2
      Top = 15
      Width = 316
      Height = 191
      Align = alClient
      ItemHeight = 13
      TabOrder = 1
      OnDrawItem = lstAllWordsDrawItem
    end
  end
end
