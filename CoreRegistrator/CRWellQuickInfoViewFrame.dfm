object frmWellSlottingInfoQuickView: TfrmWellSlottingInfoQuickView
  Left = 0
  Top = 0
  Width = 334
  Height = 240
  TabOrder = 0
  object lwProperties: TListView
    Left = 0
    Top = 0
    Width = 334
    Height = 240
    Align = alClient
    Columns = <
      item
        Caption = #1057#1074#1086#1081#1089#1090#1074#1086
        Width = -2
        WidthType = (
          -2)
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    FlatScrollBars = True
    HotTrackStyles = [htUnderlineHot]
    RowSelect = True
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    ViewStyle = vsReport
    OnAdvancedCustomDrawItem = lwPropertiesAdvancedCustomDrawItem
    OnDblClick = lwPropertiesDblClick
  end
end
