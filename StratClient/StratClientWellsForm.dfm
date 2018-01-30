object frmWells: TfrmWells
  Left = 0
  Top = 0
  Width = 594
  Height = 443
  TabOrder = 0
  object pnlThemes: TPanel
    Left = 0
    Top = 0
    Width = 594
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
  end
  object gbxWells: TGroupBox
    Left = 0
    Top = 41
    Width = 594
    Height = 402
    Align = alClient
    Caption = #1057#1082#1074#1072#1078#1080#1085#1099
    TabOrder = 1
    object lwWells: TListView
      Left = 2
      Top = 15
      Width = 590
      Height = 385
      Align = alClient
      Columns = <
        item
          Caption = 'UIN'
          Width = -2
          WidthType = (
            -2)
        end
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
        end
        item
          Caption = #1047#1072#1073#1086#1081
          Width = -2
          WidthType = (
            -2)
        end
        item
          Caption = #1040#1083#1100#1090#1080#1090#1091#1076#1072
          Width = -2
          WidthType = (
            -2)
        end>
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
end
