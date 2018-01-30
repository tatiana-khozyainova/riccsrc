object frmComplexCombo: TfrmComplexCombo
  Left = 0
  Top = 0
  Width = 406
  Height = 46
  TabOrder = 0
  DesignSize = (
    406
    46)
  object lblName: TLabel
    Left = 5
    Top = 5
    Width = 3
    Height = 13
  end
  object cmbxName: TComboBox
    Left = 2
    Top = 21
    Width = 373
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 0
    OnChange = cmbxNameChange
    OnKeyDown = cmbxNameKeyDown
  end
  object btnShowAdditional: TButton
    Left = 379
    Top = 20
    Width = 25
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = '...'
    TabOrder = 1
    OnClick = btnShowAdditionalClick
  end
end
