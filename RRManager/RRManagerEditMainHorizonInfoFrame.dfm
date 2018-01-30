object frmMainHorizonInfo: TfrmMainHorizonInfo
  Left = 0
  Top = 0
  Width = 463
  Height = 398
  TabOrder = 0
  object gbxAll: TGroupBox
    Left = 0
    Top = 0
    Width = 463
    Height = 398
    Align = alClient
    Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1075#1086#1088#1080#1079#1086#1085#1090#1077
    TabOrder = 0
    DesignSize = (
      463
      398)
    inline cmplxOrganization: TfrmComplexCombo
      Left = 4
      Top = 137
      Width = 452
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Visible = False
      inherited cmbxName: TComboBox
        Width = 418
      end
      inherited btnShowAdditional: TButton
        Left = 426
      end
    end
    inline cmplxFirstStratum: TfrmComplexCombo
      Left = 4
      Top = 25
      Width = 453
      Height = 46
      TabOrder = 1
      inherited cmbxName: TComboBox
        Width = 419
      end
      inherited btnShowAdditional: TButton
        Left = 427
      end
    end
    object chbxOutOfFund: TCheckBox
      Left = 7
      Top = 325
      Width = 97
      Height = 17
      Caption = #1074#1085#1077' '#1092#1086#1085#1076#1072
      TabOrder = 2
      Visible = False
    end
  end
end
