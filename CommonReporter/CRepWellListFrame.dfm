object frmWellList: TfrmWellList
  Left = 0
  Top = 0
  Width = 320
  Height = 241
  TabOrder = 0
  object gbxWells: TJvGroupBox
    Left = 0
    Top = 0
    Width = 320
    Height = 241
    Align = alClient
    Caption = #1057#1082#1074#1072#1078#1080#1085#1099
    TabOrder = 0
    object lvWells: TJvListView
      Left = 2
      Top = 15
      Width = 316
      Height = 224
      Align = alClient
      Columns = <
        item
          Caption = #1055#1083#1086#1097#1072#1076#1100
          Width = -2
          WidthType = (
            -2)
        end
        item
          Caption = #1053#1086#1084#1077#1088
          Width = -2
          WidthType = (
            -2)
        end>
      FlatScrollBars = True
      GridLines = True
      HideSelection = False
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      ShowWorkAreas = True
      TabOrder = 0
      ViewStyle = vsReport
      ColumnsOrder = '0=-2,1=-2'
      GroupView = True
      Groups = <>
      ExtendedColumns = <
        item
        end
        item
        end>
    end
  end
end
