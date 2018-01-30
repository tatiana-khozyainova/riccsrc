object frmDrilledStructureInfo: TfrmDrilledStructureInfo
  Left = 0
  Top = 0
  Width = 681
  Height = 477
  TabOrder = 0
  object gbxAll: TGroupBox
    Left = 0
    Top = 0
    Width = 681
    Height = 477
    Align = alClient
    Caption = 'Структура в бурении'
    TabOrder = 0
    inline cmplxOrganization: TfrmComplexCombo
      Left = 3
      Top = 23
      Width = 675
      Anchors = [akLeft, akTop, akRight]
      inherited cmbxName: TComboBox
        Width = 641
      end
      inherited btnShowAdditional: TButton
        Left = 649
      end
    end
    object pnl: TPanel
      Left = 2
      Top = 86
      Width = 677
      Height = 389
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvNone
      TabOrder = 1
      object Label1: TLabel
        Left = 4
        Top = 21
        Width = 194
        Height = 13
        Caption = 'Скважины, пробуренные на структуре'
      end
      object lwWells: TListView
        Left = 4
        Top = 40
        Width = 312
        Height = 319
        Anchors = [akLeft, akTop, akBottom]
        Columns = <>
        MultiSelect = True
        TabOrder = 0
        ViewStyle = vsList
        OnChange = lwWellsChange
      end
      object btnAdd: TButton
        Left = 4
        Top = 361
        Width = 186
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Связать скважину со структурой'
        TabOrder = 1
      end
      object btnDelete: TButton
        Left = 210
        Top = 361
        Width = 106
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Удалить связь'
        TabOrder = 2
      end
      object rgrpSelectParam: TRadioGroup
        Left = 320
        Top = 35
        Width = 354
        Height = 71
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Параметр'
        ItemIndex = 0
        Items.Strings = (
          'подтверждаемость ГИС'
          'подтверждаемость структурных моделей'
          'причины отрицательного результата')
        TabOrder = 3
        OnClick = rgrpSelectParamClick
      end
      object mmParameter: TMemo
        Left = 320
        Top = 109
        Width = 354
        Height = 277
        Anchors = [akLeft, akTop, akRight, akBottom]
        Lines.Strings = (
          '')
        TabOrder = 4
        OnChange = mmParameterChange
      end
    end
  end
  object actnLstWells: TActionList
    Left = 557
    Top = 106
    object actnAddWell: TAction
      Caption = 'Связать скважину со структурой'
      OnExecute = actnAddWellExecute
    end
    object actnDeleteWell: TAction
      Caption = 'Удалить связь'
      OnExecute = actnDeleteWellExecute
      OnUpdate = actnDeleteWellUpdate
    end
  end
end
