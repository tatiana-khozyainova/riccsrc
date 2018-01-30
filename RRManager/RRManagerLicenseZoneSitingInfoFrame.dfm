object frmLicenseZoneSitingInfo: TfrmLicenseZoneSitingInfo
  Left = 0
  Top = 0
  Width = 454
  Height = 397
  TabOrder = 0
  object gbxSiting: TGroupBox
    Left = 0
    Top = 0
    Width = 454
    Height = 397
    Align = alClient
    Caption = #1051#1080#1094#1077#1085#1079#1080#1086#1085#1085#1099#1081' '#1091#1095#1072#1089#1090#1086#1082' - '#1087#1088#1080#1074#1103#1079#1082#1072
    TabOrder = 0
    DesignSize = (
      454
      397)
    inline cmplxPetrolRegion: TfrmComplexCombo
      Left = 3
      Top = 248
      Width = 446
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      inherited cmbxName: TComboBox
        Width = 413
      end
      inherited btnShowAdditional: TButton
        Left = 419
      end
    end
    inline cmplxTectStruct: TfrmComplexCombo
      Left = 3
      Top = 297
      Width = 446
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      inherited cmbxName: TComboBox
        Width = 413
      end
      inherited btnShowAdditional: TButton
        Left = 419
      end
    end
    inline cmplxDistrict: TfrmComplexCombo
      Left = 5
      Top = 25
      Width = 446
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      inherited cmbxName: TComboBox
        Width = 413
      end
      inherited btnShowAdditional: TButton
        Left = 419
      end
    end
    inline frmCoordsEdit: TfrmCoordsEdit
      Left = 8
      Top = 80
      Width = 439
      Height = 168
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
    end
  end
end
