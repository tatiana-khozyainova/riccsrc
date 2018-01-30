object frmComplexCombo: TfrmComplexCombo
  Left = 0
  Top = 0
  Width = 420
  Height = 46
  TabOrder = 0
  DesignSize = (
    420
    46)
  object lblName: TLabel
    Left = 5
    Top = 5
    Width = 3
    Height = 13
  end
  object btnShowAdditional: TButton
    Left = 391
    Top = 17
    Width = 25
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = '...'
    TabOrder = 0
    OnClick = btnShowAdditionalClick
  end
  object cmbxName: TComboBox
    Left = 5
    Top = 18
    Width = 381
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 1
    OnChange = cmbxNameChange
    OnKeyDown = cmbxNameKeyDown
    OnKeyPress = cmbxNameKeyPress
    OnSelect = cmbxNameSelect
  end
end
