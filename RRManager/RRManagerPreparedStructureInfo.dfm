object frmPreparedStructureInfo: TfrmPreparedStructureInfo
  Left = 0
  Top = 0
  Width = 426
  Height = 254
  TabOrder = 0
  object gbxAll: TGroupBox
    Left = 0
    Top = 0
    Width = 426
    Height = 254
    Align = alClient
    Caption = 'Подготовленная структура'
    TabOrder = 0
    object Label1: TLabel
      Left = 300
      Top = 15
      Width = 79
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Год подготовки'
    end
    object Label2: TLabel
      Left = 7
      Top = 121
      Width = 66
      Height = 13
      Caption = 'Автор отчета'
    end
    object Label3: TLabel
      Left = 5
      Top = 177
      Width = 246
      Height = 13
      Caption = 'Номер сейсмопартии, подготовившей структуру'
    end
    inline cmplxMethod: TfrmComplexCombo
      Left = 4
      Top = 16
      Width = 290
      Height = 44
      Anchors = [akLeft, akTop, akRight]
      inherited cmbxName: TComboBox
        Left = 1
        Top = 20
        Width = 256
      end
      inherited btnShowAdditional: TButton
        Left = 264
        Top = 18
      end
    end
    inline cmplxOrganization: TfrmComplexCombo
      Left = 3
      Top = 58
      Width = 420
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      inherited cmbxName: TComboBox
        Width = 386
      end
      inherited btnShowAdditional: TButton
        Left = 394
      end
    end
    object edtPreparationYear: TEdit
      Left = 298
      Top = 35
      Width = 121
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 2
    end
    object cmbxReportAuthor: TComboBox
      Left = 5
      Top = 140
      Width = 384
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 3
    end
    object cmbxSeismoGroupName: TComboBox
      Left = 5
      Top = 193
      Width = 256
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 4
    end
  end
end
