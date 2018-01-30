object Frame1: TFrame1
  Left = 0
  Top = 0
  Width = 141
  Height = 41
  TabOrder = 0
  object btn1: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Action = actn2
    TabOrder = 0
  end
  object actn1: TActionList
    Left = 88
    object actn2: TAction
      Caption = 'actn2'
      OnExecute = actn2Execute
    end
  end
end
