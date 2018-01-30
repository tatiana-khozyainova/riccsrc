object frmBasketFrame: TfrmBasketFrame
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object lwBasket: TListView
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    Align = alClient
    Columns = <
      item
        Caption = #1054#1073#1098#1077#1082#1090#1099' '#1082#1086#1088#1079#1080#1085#1099
        Width = -2
        WidthType = (
          -2)
      end>
    DragKind = dkDock
    DragMode = dmAutomatic
    FullDrag = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDragOver = lwBasketDragOver
  end
end
