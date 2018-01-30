object DialogFrame: TDialogFrame
  Left = 0
  Top = 0
  Width = 435
  Height = 265
  Align = alClient
  AutoSize = True
  TabOrder = 0
  object pnlButtons: TPanel
    Left = 0
    Top = 224
    Width = 435
    Height = 41
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 0
    object btnPrev: TButton
      Left = 125
      Top = 10
      Width = 75
      Height = 25
      Caption = '<< '#1053#1072#1079#1072#1076
      TabOrder = 0
      OnClick = btnPrevClick
    end
    object btnNext: TButton
      Left = 205
      Top = 10
      Width = 75
      Height = 25
      Caption = #1044#1072#1083#1077#1077' >>'
      TabOrder = 1
      OnClick = btnNextClick
    end
    object btnFinish: TButton
      Left = 285
      Top = 10
      Width = 75
      Height = 25
      Action = actnFinish
      ModalResult = 1
      TabOrder = 2
    end
    object btnCancel: TButton
      Left = 365
      Top = 10
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 3
      OnClick = btnCancelClick
    end
  end
  object actnLst: TActionList
    Left = 80
    Top = 248
    object actnFinish: TAction
      Caption = #1043#1086#1090#1086#1074#1086
      OnExecute = actnFinishExecute
      OnUpdate = actnFinishUpdate
    end
  end
end
