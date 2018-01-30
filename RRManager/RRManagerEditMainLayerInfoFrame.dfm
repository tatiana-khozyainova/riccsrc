object frmMainLayerInfo: TfrmMainLayerInfo
  Left = 0
  Top = 0
  Width = 522
  Height = 394
  TabOrder = 0
  object gbxAll: TGroupBox
    Left = 0
    Top = 0
    Width = 522
    Height = 394
    Align = alClient
    Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1087#1088#1086#1076#1091#1082#1090#1080#1074#1085#1086#1084' '#1075#1086#1088#1080#1079#1086#1085#1090#1077
    TabOrder = 0
    DesignSize = (
      522
      394)
    object Label1: TLabel
      Left = 6
      Top = 224
      Width = 53
      Height = 13
      Caption = #1052#1086#1097#1085#1086#1089#1090#1100
    end
    object Label2: TLabel
      Left = 166
      Top = 224
      Width = 125
      Height = 13
      Caption = #1069#1092#1092#1077#1082#1090#1080#1074#1085#1072#1103' '#1084#1086#1097#1085#1086#1089#1090#1100
    end
    object Label3: TLabel
      Left = 6
      Top = 289
      Width = 133
      Height = 13
      Caption = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1103
    end
    object Bevel1: TBevel
      Left = 5
      Top = 208
      Width = 506
      Height = 8
      Shape = bsBottomLine
    end
    inline cmplxLayer: TfrmComplexCombo
      Left = 3
      Top = 25
      Width = 515
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      inherited cmbxName: TComboBox
        Width = 481
      end
      inherited btnShowAdditional: TButton
        Left = 487
      end
    end
    inline cmplxLithology: TfrmComplexCombo
      Left = 3
      Top = 102
      Width = 240
      Height = 46
      TabOrder = 1
      inherited cmbxName: TComboBox
        Width = 206
      end
      inherited btnShowAdditional: TButton
        Left = 212
      end
    end
    inline cmplxCollector: TfrmComplexCombo
      Left = 244
      Top = 103
      Width = 272
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      inherited cmbxName: TComboBox
        Width = 238
      end
      inherited btnShowAdditional: TButton
        Left = 244
      end
    end
    object edtPower: TEdit
      Left = 6
      Top = 241
      Width = 121
      Height = 21
      TabOrder = 3
    end
    object edtEffectivePower: TEdit
      Left = 166
      Top = 241
      Width = 121
      Height = 21
      TabOrder = 4
    end
    object edtFillingCoef: TEdit
      Left = 6
      Top = 306
      Width = 121
      Height = 21
      TabOrder = 5
    end
    inline cmplxBedType: TfrmComplexCombo
      Left = 4
      Top = 160
      Width = 237
      Height = 46
      TabOrder = 6
      inherited cmbxName: TComboBox
        Width = 204
      end
      inherited btnShowAdditional: TButton
        Left = 210
      end
    end
  end
end
