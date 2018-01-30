object frmContainer: TfrmContainer
  Left = 0
  Top = 0
  Width = 837
  Height = 455
  TabOrder = 0
  object tlbrOperations: TToolBar
    Left = 0
    Top = 0
    Width = 837
    Height = 23
    AutoSize = True
    ButtonHeight = 21
    ButtonWidth = 57
    Caption = 'tlbrOperations'
    Flat = True
    ShowCaptions = True
    TabOrder = 0
    object tlbtnAddContainer: TToolButton
      Left = 0
      Top = 0
      Action = actnAdd
    end
    object tlbtnDeleteContainer: TToolButton
      Left = 57
      Top = 0
      Action = actnDelete
    end
  end
  object pnlAll: TPanel
    Left = 0
    Top = 23
    Width = 837
    Height = 432
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
  end
  object actnlst: TActionList
    Left = 224
    Top = 64
    object actnAdd: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnExecute = actnAddExecute
    end
    object actnDelete: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnExecute = actnDeleteExecute
      OnUpdate = actnDeleteUpdate
    end
  end
end
