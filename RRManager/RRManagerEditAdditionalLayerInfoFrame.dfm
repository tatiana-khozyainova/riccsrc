object frmAdditionalLayerInfo: TfrmAdditionalLayerInfo
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object gbxAll: TGroupBox
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    Align = alClient
    Caption = 'Дополнительная информация о продуктивном горизонте'
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Top = 89
      Width = 84
      Height = 13
      Caption = 'Высота ловушки'
    end
    object Label2: TLabel
      Left = 166
      Top = 90
      Width = 93
      Height = 13
      Caption = 'Площадь ловушки'
    end
    object Bevel1: TBevel
      Left = 5
      Top = 135
      Width = 311
      Height = 21
      Shape = bsTopLine
    end
    object Label3: TLabel
      Left = 10
      Top = 149
      Width = 83
      Height = 13
      Caption = 'Высота залежи*'
    end
    object Label4: TLabel
      Left = 166
      Top = 150
      Width = 92
      Height = 13
      Caption = 'Площадь залежи*'
    end
    object Label5: TLabel
      Left = 10
      Top = 221
      Width = 145
      Height = 13
      Caption = '* - залежь - предполагаемая'
    end
    inline cmplxTrapType: TfrmComplexCombo
      Left = 5
      Top = 25
      Width = 311
      inherited cmbxName: TComboBox
        Width = 277
      end
      inherited btnShowAdditional: TButton
        Left = 283
      end
    end
    object edtTrapHeight: TEdit
      Left = 9
      Top = 105
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object edtTrapArea: TEdit
      Left = 165
      Top = 105
      Width = 121
      Height = 21
      TabOrder = 2
    end
    object edtBedHeight: TEdit
      Left = 9
      Top = 165
      Width = 121
      Height = 21
      TabOrder = 3
    end
    object edtBedArea: TEdit
      Left = 165
      Top = 165
      Width = 121
      Height = 21
      TabOrder = 4
    end
  end
end
