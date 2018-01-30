object frmSubstructureParameters: TfrmSubstructureParameters
  Left = 0
  Top = 0
  Width = 462
  Height = 347
  TabOrder = 0
  object gbxAll: TGroupBox
    Left = 0
    Top = 0
    Width = 462
    Height = 347
    Align = alClient
    Caption = 'Параметры структуры'
    TabOrder = 0
    object pgctlStructureParams: TPageControl
      Left = 2
      Top = 15
      Width = 247
      Height = 330
      ActivePage = tshEnteredParams
      Align = alLeft
      Style = tsFlatButtons
      TabOrder = 0
      object tshEnteredParams: TTabSheet
        Caption = 'Введенные параметры'
        ImageIndex = 1
        object trwSelectedParams: TTreeView
          Left = 0
          Top = 0
          Width = 239
          Height = 299
          Align = alClient
          Indent = 19
          TabOrder = 0
        end
      end
      object tshAllParams: TTabSheet
        Caption = 'Все параметры'
        object trwAllParams: TTreeView
          Left = 0
          Top = 0
          Width = 239
          Height = 299
          Align = alClient
          Indent = 19
          TabOrder = 0
        end
      end
    end
    object pnlParams: TPanel
      Left = 249
      Top = 15
      Width = 211
      Height = 330
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Label1: TLabel
        Left = 4
        Top = 84
        Width = 48
        Height = 13
        Caption = 'Значение'
      end
      inline cmplxFluidType: TfrmComplexCombo
        Top = 25
        Width = 206
        Anchors = [akLeft, akTop, akRight]
        inherited cmbxName: TComboBox
          Width = 172
        end
        inherited btnShowAdditional: TButton
          Left = 180
        end
      end
      object edtValue: TEdit
        Left = 4
        Top = 102
        Width = 201
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
      end
      inline cmplxMeasureUnit: TfrmComplexCombo
        Left = 1
        Top = 137
        Width = 206
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 2
        inherited cmbxName: TComboBox
          Width = 172
        end
        inherited btnShowAdditional: TButton
          Left = 180
        end
      end
    end
  end
end
