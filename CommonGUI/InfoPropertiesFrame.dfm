object frmInfoProperties: TfrmInfoProperties
  Left = 0
  Top = 0
  Width = 304
  Height = 380
  TabOrder = 0
  object lstInfoPropertiesWell: TListView
    Left = 0
    Top = 0
    Width = 304
    Height = 380
    Align = alClient
    Columns = <
      item
        Caption = #1057#1074#1086#1081#1089#1090#1074#1072
        Width = 300
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    FlatScrollBars = True
    HotTrackStyles = [htUnderlineHot]
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    ViewStyle = vsReport
    OnCustomDrawItem = lstInfoPropertiesWellCustomDrawItem
  end
end
