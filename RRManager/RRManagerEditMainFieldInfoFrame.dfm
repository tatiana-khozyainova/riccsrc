object frmMainFieldInfo: TfrmMainFieldInfo
  Left = 0
  Top = 0
  Width = 498
  Height = 461
  TabOrder = 0
  object gbxAll: TGroupBox
    Left = 0
    Top = 0
    Width = 498
    Height = 461
    Align = alClient
    Caption = #1052#1077#1089#1090#1086#1088#1086#1078#1076#1077#1085#1080#1077
    TabOrder = 0
    DesignSize = (
      498
      461)
    inline cmplxFieldType: TfrmComplexCombo
      Left = 4
      Top = 32
      Width = 484
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      inherited btnShowAdditional: TButton
        Left = 456
      end
      inherited cmbxName: TComboBox
        Width = 450
      end
    end
    inline cmplxDevelopingDegree: TfrmComplexCombo
      Left = 4
      Top = 90
      Width = 484
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      inherited btnShowAdditional: TButton
        Left = 456
      end
      inherited cmbxName: TComboBox
        Width = 450
      end
    end
    object edtDiscoveringYear: TLabeledEdit
      Left = 8
      Top = 240
      Width = 121
      Height = 21
      EditLabel.Width = 69
      EditLabel.Height = 13
      EditLabel.Caption = #1043#1086#1076' '#1086#1090#1082#1088#1099#1090#1080#1103
      TabOrder = 2
    end
    object edtConservationYear: TLabeledEdit
      Left = 8
      Top = 288
      Width = 121
      Height = 21
      EditLabel.Width = 87
      EditLabel.Height = 13
      EditLabel.Caption = #1043#1086#1076' '#1082#1086#1085#1089#1077#1088#1074#1072#1094#1080#1080
      TabOrder = 4
    end
    object edtDevelopingStartYear: TLabeledEdit
      Left = 144
      Top = 240
      Width = 121
      Height = 21
      EditLabel.Width = 121
      EditLabel.Height = 13
      EditLabel.Caption = #1043#1086#1076' '#1074#1074#1086#1076#1072' '#1074' '#1088#1072#1079#1088#1072#1073#1086#1090#1082#1091
      TabOrder = 3
    end
  end
end
