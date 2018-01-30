object frmAdditionalHorizonInfo: TfrmAdditionalHorizonInfo
  Left = 0
  Top = 0
  Width = 312
  Height = 333
  TabOrder = 0
  object Label5: TLabel
    Left = 9
    Top = 64
    Width = 55
    Height = 13
    Caption = 'Амплитуда'
  end
  object gbxAll: TGroupBox
    Left = 0
    Top = 0
    Width = 312
    Height = 333
    Align = alClient
    Caption = 'Дополнительные параметры горизонта'
    TabOrder = 0
    object Label1: TLabel
      Left = 9
      Top = 20
      Width = 120
      Height = 13
      Caption = 'Замыкающая изогипса'
    end
    object Label2: TLabel
      Left = 164
      Top = 20
      Width = 127
      Height = 13
      Caption = 'Перспективная площадь'
    end
    object Label4: TLabel
      Left = 164
      Top = 64
      Width = 121
      Height = 13
      Caption = 'Контрольная плотность'
    end
    object Label3: TLabel
      Left = 9
      Top = 64
      Width = 55
      Height = 13
      Caption = 'Амплитуда'
    end
    object Label6: TLabel
      Left = 9
      Top = 114
      Width = 128
      Height = 13
      Caption = 'Случайная ошибка карты'
    end
    object edtClosingIsogypse: TEdit
      Left = 9
      Top = 37
      Width = 120
      Height = 21
      TabOrder = 0
    end
    inline cmplxTrapType: TfrmComplexCombo
      Left = 8
      Top = 168
      Width = 278
      TabOrder = 1
      inherited cmbxName: TComboBox
        Width = 244
      end
      inherited btnShowAdditional: TButton
        Left = 252
      end
    end
    object EdtPerspectiveArea: TEdit
      Left = 164
      Top = 37
      Width = 120
      Height = 21
      TabOrder = 2
    end
    object edtAmplitude: TEdit
      Left = 9
      Top = 81
      Width = 120
      Height = 21
      TabOrder = 3
    end
    object edtControlDensity: TEdit
      Left = 164
      Top = 81
      Width = 120
      Height = 21
      TabOrder = 4
    end
    object edtMapError: TEdit
      Left = 9
      Top = 133
      Width = 120
      Height = 21
      TabOrder = 5
    end
    inline cmplxLayer: TfrmComplexCombo
      Left = 8
      Top = 235
      Width = 279
      TabOrder = 6
      inherited cmbxName: TComboBox
        Width = 245
      end
      inherited btnShowAdditional: TButton
        Left = 253
      end
    end
  end
end
