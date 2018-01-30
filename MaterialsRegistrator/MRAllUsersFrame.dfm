object frmAllUsers: TfrmAllUsers
  Left = 0
  Top = 0
  Width = 389
  Height = 487
  TabOrder = 0
  object grp1: TGroupBox
    Left = 0
    Top = 0
    Width = 389
    Height = 461
    Align = alClient
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080
    TabOrder = 0
    object grp2: TGroupBox
      Left = 2
      Top = 382
      Width = 385
      Height = 77
      Align = alBottom
      Caption = #1060#1080#1083#1100#1090#1088
      TabOrder = 0
      object rbtnAllEmployee: TRadioButton
        Left = 8
        Top = 16
        Width = 113
        Height = 17
        Action = actnAllEmployee
        TabOrder = 0
        TabStop = True
      end
      object rbtnAllOurEmployee: TRadioButton
        Left = 8
        Top = 35
        Width = 177
        Height = 17
        Action = actnOurEmployee
        TabOrder = 1
      end
      object rbtnAllOutsideEmployee: TRadioButton
        Left = 8
        Top = 55
        Width = 177
        Height = 17
        Action = actnOutsideEmployee
        TabOrder = 2
      end
    end
    object grp3: TGroupBox
      Left = 2
      Top = 15
      Width = 385
      Height = 367
      Align = alClient
      BiDiMode = bdLeftToRight
      ParentBiDiMode = False
      TabOrder = 1
      object lstAllEmployees: TListBox
        Left = 2
        Top = 15
        Width = 381
        Height = 322
        Align = alClient
        ItemHeight = 13
        MultiSelect = True
        Sorted = True
        TabOrder = 0
      end
      object pnl1: TPanel
        Left = 2
        Top = 337
        Width = 381
        Height = 28
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object lblFilter: TLabel
          Left = 8
          Top = 7
          Width = 3
          Height = 13
        end
      end
    end
  end
  inline frmButtons: TfrmButtons
    Left = 0
    Top = 461
    Width = 389
    Height = 26
    Align = alBottom
    TabOrder = 1
    inherited tlbr: TToolBar
      Width = 389
      Height = 26
      inherited ToolButton2: TToolButton
        Down = False
      end
    end
  end
  object actnFilter: TActionList
    Left = 224
    Top = 240
    object actnAllEmployee: TAction
      Caption = #1042#1089#1077' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1080
      Checked = True
    end
    object actnOurEmployee: TAction
      Caption = #1058#1086#1083#1100#1082#1086' '#1089#1074#1086#1080' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1080
    end
    object actnOutsideEmployee: TAction
      Caption = #1058#1086#1083#1100#1082#1086' '#1074#1085#1077#1096#1085#1080#1077' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1080
    end
  end
end
