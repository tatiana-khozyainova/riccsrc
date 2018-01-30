object frmLicenseConditionTree: TfrmLicenseConditionTree
  Left = 0
  Top = 0
  Width = 340
  Height = 330
  TabOrder = 0
  object gbxSearch: TGroupBox
    Left = 0
    Top = 0
    Width = 340
    Height = 49
    Align = alTop
    Caption = #1055#1086#1080#1089#1082
    TabOrder = 0
    DesignSize = (
      340
      49)
    object edtSearch: TEdit
      Left = 8
      Top = 17
      Width = 242
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = edtSearchChange
    end
    object btnNext: TButton
      Left = 257
      Top = 16
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1053#1072#1081#1090#1080
      TabOrder = 1
      OnClick = btnNextClick
    end
  end
  object trwConditions: TTreeView
    Left = 0
    Top = 49
    Width = 340
    Height = 281
    Align = alClient
    Indent = 19
    ReadOnly = True
    TabOrder = 1
  end
end
