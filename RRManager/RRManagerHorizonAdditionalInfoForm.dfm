object frmHorizonAdditionalInfoForm: TfrmHorizonAdditionalInfoForm
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
    Caption = 'Дополнительные параметры горизонта'
    TabOrder = 0
    object Label1: TLabel
      Left = 9
      Top = 20
      Width = 120
      Height = 13
      Caption = 'Замыкающая изогипса'
    end
    object edtClosingIsogypse: TEdit
      Left = 10
      Top = 39
      Width = 120
      Height = 21
      TabOrder = 0
    end
    inline cmplxTrapType: TfrmComplexCombo
      Left = 4
      Top = 85
      Width = 181
      TabOrder = 1
      inherited cmbxName: TComboBox
        Width = 147
      end
      inherited btnShowAdditional: TButton
        Left = 155
      end
    end
  end
end
