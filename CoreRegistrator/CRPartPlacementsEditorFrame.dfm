inherited frmPartPlacements: TfrmPartPlacements
  Width = 762
  Height = 317
  object spl1: TSplitter [0]
    Left = 493
    Top = 0
    Height = 298
    Align = alRight
  end
  inherited StatusBar: TStatusBar
    Top = 298
    Width = 762
  end
  inherited trwHierarchy: TTreeView
    Width = 493
    Height = 298
  end
  inline frmPartPlacement1: TfrmPartPlacement [3]
    Left = 496
    Top = 0
    Width = 266
    Height = 298
    Align = alRight
    TabOrder = 2
    inherited StatusBar: TStatusBar
      Top = 279
      Width = 266
    end
    inherited gbxProperties: TGroupBox
      Width = 266
      Height = 279
      inherited edtName: TLabeledEdit
        Width = 254
      end
      inherited cmbxType: TComboBox
        Width = 254
      end
      inherited cmbxPlacementType: TComboBox
        Width = 251
      end
    end
  end
end
