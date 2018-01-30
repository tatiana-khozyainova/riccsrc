object frmAllObjects: TfrmAllObjects
  Left = 0
  Top = 0
  Width = 435
  Height = 266
  Align = alClient
  TabOrder = 0
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 435
    Height = 181
    Align = alClient
    Caption = #1057#1087#1080#1089#1086#1082' '#1079#1085#1072#1095#1077#1085#1080#1081
    TabOrder = 0
    object lstAllObjects: TListBox
      Left = 2
      Top = 15
      Width = 431
      Height = 164
      Align = alClient
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnDblClick = lstAllObjectsDblClick
      OnMouseMove = lstAllObjectsMouseMove
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 217
    Width = 435
    Height = 49
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnCancel: TBitBtn
      Left = 224
      Top = 12
      Width = 75
      Height = 25
      Cancel = True
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ModalResult = 2
      TabOrder = 0
      NumGlyphs = 2
    end
    object btnOk: TBitBtn
      Left = 136
      Top = 12
      Width = 75
      Height = 25
      Caption = #1042#1099#1073#1088#1072#1090#1100
      Default = True
      ModalResult = 1
      TabOrder = 1
      Visible = False
      NumGlyphs = 2
    end
  end
  inline frmButtons: TfrmButtons
    Left = 0
    Top = 181
    Width = 435
    Height = 36
    Align = alBottom
    TabOrder = 2
    inherited tlbr: TToolBar
      Height = 36
    end
    inherited actnLst: TActionList
      inherited actnAdd: TAction
        OnExecute = frmButtonsactnAddExecute
      end
      inherited actnDelete: TAction
        OnExecute = frmButtonsactnDeleteExecute
      end
      inherited actnEdit: TAction
        OnExecute = frmButtonsactnEditExecute
      end
    end
  end
end
