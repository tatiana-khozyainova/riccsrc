object frmCommonFrame: TfrmCommonFrame
  Left = 0
  Top = 0
  Width = 477
  Height = 253
  TabOrder = 0
  object StatusBar: TStatusBar
    Left = 0
    Top = 234
    Width = 477
    Height = 19
    Panels = <
      item
        Style = psOwnerDraw
        Width = 250
      end
      item
        Width = 50
      end>
    OnDrawPanel = StatusBarDrawPanel
  end
end
