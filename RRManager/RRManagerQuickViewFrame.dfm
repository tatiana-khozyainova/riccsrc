object frmQuickView: TfrmQuickView
  Left = 0
  Top = 0
  Width = 225
  Height = 540
  TabOrder = 0
  object lwProperties: TListView
    Left = 0
    Top = 0
    Width = 225
    Height = 540
    Align = alClient
    Columns = <
      item
        Caption = #1057#1074#1086#1081#1089#1090#1074#1086
        Width = 220
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
    OnInfoTip = lwPropertiesInfoTip
    OnResize = lwPropertiesResize
  end
end
