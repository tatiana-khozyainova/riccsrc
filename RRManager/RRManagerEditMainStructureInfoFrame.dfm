object frmMainStructureInfo: TfrmMainStructureInfo
  Left = 0
  Top = 0
  Width = 616
  Height = 425
  TabOrder = 0
  object gbxAll: TGroupBox
    Left = 0
    Top = 0
    Width = 616
    Height = 425
    Align = alClient
    Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1089#1090#1091#1088#1082#1090#1091#1088#1077
    TabOrder = 0
    DesignSize = (
      616
      425)
    object lblStrructureName: TLabel
      Left = 8
      Top = 16
      Width = 131
      Height = 13
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1089#1090#1088#1091#1082#1090#1091#1088#1099
    end
    object lblStrucureType: TLabel
      Left = 8
      Top = 64
      Width = 54
      Height = 13
      Caption = #1042#1080#1076' '#1092#1086#1085#1076#1072
    end
    object lblCartoHorizon: TLabel
      Left = 9
      Top = 352
      Width = 241
      Height = 13
      Caption = #1057#1090#1088#1091#1082#1090#1091#1088#1072' '#1085#1072' '#1082#1072#1088#1090#1077' '#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1072' '#1087#1086' '#1075#1086#1088#1080#1079#1086#1085#1090#1091
    end
    object edtStructureName: TEdit
      Left = 7
      Top = 32
      Width = 603
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = edtStructureNameChange
      OnKeyDown = edtStructureNameKeyDown
    end
    object cmbxStructureType: TComboBox
      Left = 8
      Top = 80
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnChange = cmbxStructureTypeChange
    end
    object chbxOutOfFund: TCheckBox
      Left = 9
      Top = 394
      Width = 97
      Height = 17
      Caption = #1074#1085#1077' '#1092#1086#1085#1076#1072
      TabOrder = 2
    end
    object cmbxCartoHorizon: TComboBox
      Left = 8
      Top = 368
      Width = 513
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
    end
    inline cmplxNewArea: TfrmComplexCombo
      Left = 163
      Top = 60
      Width = 438
      Height = 46
      TabOrder = 4
      inherited btnShowAdditional: TButton
        Left = 411
        Top = 15
      end
      inherited cmbxName: TComboBox
        Width = 402
      end
    end
    inline cmplxPetrolRegion: TfrmComplexCombo
      Left = 4
      Top = 112
      Width = 605
      Height = 46
      TabOrder = 5
      inherited btnShowAdditional: TButton
        Left = 577
        Width = 24
      end
      inherited cmbxName: TComboBox
        Width = 566
      end
    end
    inline cmplxTectStruct: TfrmComplexCombo
      Left = 3
      Top = 157
      Width = 606
      Height = 46
      TabOrder = 6
      inherited btnShowAdditional: TButton
        Left = 577
      end
      inherited cmbxName: TComboBox
        Width = 566
      end
    end
    inline cmplxDistrict: TfrmComplexCombo
      Left = 3
      Top = 204
      Width = 612
      Height = 46
      TabOrder = 7
      inherited btnShowAdditional: TButton
        Left = 577
        Top = 18
      end
      inherited cmbxName: TComboBox
        Width = 567
      end
    end
    inline cmplxOrganization: TfrmComplexCombo
      Left = 4
      Top = 304
      Width = 605
      Height = 46
      TabOrder = 8
      inherited btnShowAdditional: TButton
        Left = 576
      end
      inherited cmbxName: TComboBox
        Width = 565
      end
    end
    inline cmplxLicenzeZone: TfrmComplexCombo
      Left = 4
      Top = 255
      Width = 605
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 9
      inherited btnShowAdditional: TButton
        Left = 576
      end
      inherited cmbxName: TComboBox
        Width = 566
      end
    end
  end
end
