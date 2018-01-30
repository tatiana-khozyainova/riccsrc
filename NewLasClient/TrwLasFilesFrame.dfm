object frmTrwLasFiles: TfrmTrwLasFiles
  Left = 0
  Top = 0
  Width = 250
  Height = 463
  TabOrder = 0
  object gbx1: TGroupBox
    Left = 0
    Top = 0
    Width = 250
    Height = 463
    Align = alClient
    Caption = 'LAS-'#1092#1072#1081#1083#1099
    TabOrder = 0
    object trwLasFiles: TTreeView
      Left = 2
      Top = 15
      Width = 246
      Height = 446
      Align = alClient
      HideSelection = False
      Indent = 19
      MultiSelect = True
      TabOrder = 0
      OnChange = trwLasFilesChange
    end
  end
end
