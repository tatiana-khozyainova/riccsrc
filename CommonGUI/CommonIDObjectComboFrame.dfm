object frmIDObjectCombo: TfrmIDObjectCombo
  Left = 0
  Top = 0
  Width = 431
  Height = 59
  TabOrder = 0
  DesignSize = (
    431
    59)
  object cmbxName: TComboBox
    Left = 6
    Top = 29
    Width = 387
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 0
    OnChange = cmbxNameChange
  end
  object btnShowAdditional: TButton
    Left = 398
    Top = 28
    Width = 25
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = '...'
    TabOrder = 1
    OnClick = btnShowAdditionalClick
  end
  object lblName: TStaticText
    Left = 7
    Top = 8
    Width = 4
    Height = 4
    TabOrder = 2
  end
end
