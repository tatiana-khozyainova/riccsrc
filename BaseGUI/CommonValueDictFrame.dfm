object frmFilter: TfrmFilter
  Left = 0
  Top = 0
  Width = 224
  Height = 50
  TabOrder = 0
  object gbx: TGroupBox
    Left = 0
    Top = 0
    Width = 224
    Height = 50
    Align = alClient
    Caption = #1057#1087#1080#1089#1086#1082' '#1086#1073#1098#1077#1082#1090#1086#1074
    TabOrder = 0
    DesignSize = (
      224
      50)
    object cbxActiveObject: TComboEdit
      Left = 8
      Top = 22
      Width = 209
      Height = 21
      DirectInput = False
      GlyphKind = gkEllipsis
      Anchors = [akLeft, akTop, akRight]
      NumGlyphs = 1
      TabOrder = 0
      OnButtonClick = cbxActiveObjectButtonClick
    end
  end
end
