object frmAllObjectsFilter: TfrmAllObjectsFilter
  Left = 0
  Top = 0
  Width = 503
  Height = 57
  Align = alClient
  TabOrder = 0
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 503
    Height = 57
    Align = alClient
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
    TabOrder = 0
    DesignSize = (
      503
      57)
    object edtFilter: TEdit
      Left = 8
      Top = 24
      Width = 153
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Text = '<'#1092#1080#1083#1100#1090#1088' '#1087#1086#1080#1089#1082#1072'>'
      OnChange = edtFilterChange
    end
    object cbxAllObjects: TComboBox
      Left = 168
      Top = 24
      Width = 297
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      TabOrder = 1
    end
    object btnEditor: TBitBtn
      Left = 471
      Top = 20
      Width = 24
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '...'
      Enabled = False
      TabOrder = 2
    end
  end
end
