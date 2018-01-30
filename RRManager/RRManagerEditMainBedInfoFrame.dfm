object frmMainBedInfo: TfrmMainBedInfo
  Left = 0
  Top = 0
  Width = 657
  Height = 470
  TabOrder = 0
  object gbxAll: TGroupBox
    Left = 0
    Top = 0
    Width = 657
    Height = 470
    Align = alClient
    Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1079#1072#1083#1077#1078#1080
    TabOrder = 0
    DesignSize = (
      657
      470)
    object Label1: TLabel
      Left = 10
      Top = 25
      Width = 79
      Height = 13
      Caption = #1048#1085#1076#1077#1082#1089' '#1079#1072#1083#1077#1078#1080
    end
    object Bevel1: TBevel
      Left = 0
      Top = 146
      Width = 671
      Height = 10
      Shape = bsBottomLine
    end
    object Label2: TLabel
      Left = 456
      Top = 24
      Width = 121
      Height = 13
      Caption = #1043#1083#1091#1073#1080#1085#1072' '#1082#1088#1086#1074#1083#1080' '#1079#1072#1083#1077#1078#1080
    end
    object Label3: TLabel
      Left = 9
      Top = 108
      Width = 63
      Height = 13
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object edtBedIndex: TEdit
      Left = 9
      Top = 40
      Width = 440
      Height = 21
      TabOrder = 0
    end
    inline cmplxNGK: TfrmComplexCombo
      Left = 5
      Top = 261
      Width = 643
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
      inherited btnShowAdditional: TButton
        Left = 615
      end
      inherited cmbxName: TComboBox
        Width = 609
      end
    end
    inline cmplxCollectorType: TfrmComplexCombo
      Left = 5
      Top = 312
      Width = 357
      Height = 46
      TabOrder = 5
      inherited btnShowAdditional: TButton
        Left = 329
      end
      inherited cmbxName: TComboBox
        Width = 323
      end
    end
    inline cmplxLithology: TfrmComplexCombo
      Left = 360
      Top = 312
      Width = 287
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 6
      inherited btnShowAdditional: TButton
        Left = 259
      end
      inherited cmbxName: TComboBox
        Width = 253
      end
    end
    inline cmplxFluidType: TfrmComplexCombo
      Left = 4
      Top = 210
      Width = 644
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
      inherited btnShowAdditional: TButton
        Left = 616
      end
      inherited cmbxName: TComboBox
        Width = 610
      end
    end
    inline cmplxBedType: TfrmComplexCombo
      Left = 4
      Top = 156
      Width = 643
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      inherited btnShowAdditional: TButton
        Left = 616
      end
      inherited cmbxName: TComboBox
        Top = 21
        Width = 606
      end
    end
    inline cmplxStructureElementType: TfrmComplexCombo
      Left = 4
      Top = 63
      Width = 645
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      inherited btnShowAdditional: TButton
        Left = 618
      end
      inherited cmbxName: TComboBox
        Width = 612
      end
    end
    object edtDepth: TEdit
      Left = 456
      Top = 40
      Width = 191
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 7
    end
    object edtComment: TEdit
      Left = 8
      Top = 124
      Width = 638
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 8
    end
    object chbxIsBalanced: TCheckBox
      Left = 8
      Top = 368
      Width = 97
      Height = 17
      Caption = #1074' '#1073#1072#1083#1072#1085#1089#1077
      TabOrder = 9
    end
  end
end
