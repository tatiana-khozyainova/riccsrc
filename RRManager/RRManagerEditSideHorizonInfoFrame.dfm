object frmSideHorizonInfo: TfrmSideHorizonInfo
  Left = 0
  Top = 0
  Width = 510
  Height = 375
  TabOrder = 0
  object gbxAll: TGroupBox
    Left = 0
    Top = 0
    Width = 510
    Height = 375
    Align = alClient
    Caption = 'Дополнительные параметры горизонта'
    TabOrder = 0
    object Label9: TLabel
      Left = 9
      Top = 74
      Width = 87
      Height = 13
      Caption = 'Оценка качества'
    end
    object lblReason: TLabel
      Left = 9
      Top = 160
      Width = 255
      Height = 13
      Caption = 'Причина исключения из фонда (для исключенных)'
    end
    object Label7: TLabel
      Left = 9
      Top = 24
      Width = 147
      Height = 13
      Caption = 'Вероятность существования'
    end
    object Label8: TLabel
      Left = 204
      Top = 24
      Width = 63
      Height = 13
      Caption = 'Надежность'
    end
    object cmbxQualityRange: TComboBox
      Left = 9
      Top = 93
      Width = 315
      Height = 21
      ItemHeight = 13
      TabOrder = 0
    end
    object chbxActiveFund: TCheckBox
      Left = 10
      Top = 130
      Width = 97
      Height = 17
      Caption = 'активный фонд'
      TabOrder = 1
    end
    object mmReason: TMemo
      Left = 2
      Top = 180
      Width = 506
      Height = 193
      Align = alBottom
      TabOrder = 2
    end
    object edtProbabilty: TEdit
      Left = 9
      Top = 43
      Width = 120
      Height = 21
      TabOrder = 3
    end
    object edtReliability: TEdit
      Left = 204
      Top = 43
      Width = 120
      Height = 21
      TabOrder = 4
    end
  end
end
