object frmMainSubstructureInfo: TfrmMainSubstructureInfo
  Left = 0
  Top = 0
  Width = 506
  Height = 431
  TabOrder = 0
  object gbxAll: TGroupBox
    Left = 0
    Top = 0
    Width = 506
    Height = 431
    Align = alClient
    Caption = 'Информация о подструктуре'
    TabOrder = 0
    object Label1: TLabel
      Left = 7
      Top = 90
      Width = 149
      Height = 13
      Caption = 'Наименование подструктуры'
    end
    object Label2: TLabel
      Left = 334
      Top = 90
      Width = 107
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Номер подструктуры'
    end
    object Bevel1: TBevel
      Left = 5
      Top = 195
      Width = 496
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    inline cmplxTectonicBlock: TfrmComplexCombo
      Left = 3
      Top = 25
      Width = 495
      Anchors = [akLeft, akTop, akRight]
      inherited cmbxName: TComboBox
        Width = 461
        OnChange = cmplxTectonicBlockcmbxNameChange
      end
      inherited btnShowAdditional: TButton
        Left = 469
      end
    end
    inline cmplxLitology: TfrmComplexCombo
      Left = 10
      Top = 332
      Width = 335
      TabOrder = 1
      inherited cmbxName: TComboBox
        Width = 301
      end
      inherited btnShowAdditional: TButton
        Left = 309
      end
    end
    object edtSubstructureName: TEdit
      Left = 6
      Top = 108
      Width = 322
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
    end
    inline cmplxBedType: TfrmComplexCombo
      Left = 9
      Top = 210
      Width = 335
      TabOrder = 3
      inherited cmbxName: TComboBox
        Width = 301
      end
      inherited btnShowAdditional: TButton
        Left = 309
      end
    end
    inline cmplxCollectorType: TfrmComplexCombo
      Left = 9
      Top = 270
      Width = 335
      TabOrder = 4
      inherited cmbxName: TComboBox
        Width = 301
      end
      inherited btnShowAdditional: TButton
        Left = 309
      end
    end
    object cmbxSubstrucureNumber: TComboBox
      Left = 334
      Top = 108
      Width = 166
      Height = 21
      Anchors = [akTop, akRight]
      ItemHeight = 13
      TabOrder = 5
    end
    inline cmplxNGK: TfrmComplexCombo
      Left = 5
      Top = 140
      Width = 496
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 6
      inherited cmbxName: TComboBox
        Width = 462
      end
      inherited btnShowAdditional: TButton
        Left = 468
      end
    end
  end
end
