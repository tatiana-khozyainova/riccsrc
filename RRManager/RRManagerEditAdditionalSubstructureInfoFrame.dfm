object frmAdditionalSubstructureInfo: TfrmAdditionalSubstructureInfo
  Left = 0
  Top = 0
  Width = 316
  Height = 527
  TabOrder = 0
  object gbxAll: TGroupBox
    Left = 0
    Top = 0
    Width = 316
    Height = 527
    Align = alClient
    Caption = 'Параметры подструктуры'
    TabOrder = 0
    object Label3: TLabel
      Left = 6
      Top = 87
      Width = 140
      Height = 13
      Caption = 'Высота ожидаемой залежи'
    end
    object Label4: TLabel
      Left = 7
      Top = 137
      Width = 149
      Height = 13
      Caption = 'Площадь ожидаемой залежи'
    end
    object edtBedHeight: TEdit
      Left = 6
      Top = 105
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object edtArea: TEdit
      Left = 7
      Top = 155
      Width = 121
      Height = 21
      TabOrder = 1
    end
    inline cmplxNGK: TfrmComplexCombo
      Left = 3
      Top = 30
      Width = 308
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      inherited cmbxName: TComboBox
        Width = 274
      end
      inherited btnShowAdditional: TButton
        Left = 280
      end
    end
    inline cmplxTrapType: TfrmComplexCombo
      Left = 4
      Top = 193
      Width = 309
      TabOrder = 3
      inherited cmbxName: TComboBox
        Width = 275
      end
      inherited btnShowAdditional: TButton
        Left = 281
      end
    end
    inline cmplxLayer: TfrmComplexCombo
      Left = 4
      Top = 260
      Width = 310
      TabOrder = 4
      inherited cmbxName: TComboBox
        Width = 276
      end
      inherited btnShowAdditional: TButton
        Left = 282
      end
    end
  end
end
