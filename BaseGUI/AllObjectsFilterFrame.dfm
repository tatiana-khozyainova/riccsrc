object frmAllObjs: TfrmAllObjs
  Left = 0
  Top = 0
  Width = 398
  Height = 491
  TabOrder = 0
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 398
    Height = 57
    Align = alTop
    Caption = #1060#1080#1083#1100#1090#1088' '#1087#1086#1080#1089#1082#1072
    TabOrder = 0
    DesignSize = (
      398
      57)
    object edtSearch: TEdit
      Left = 8
      Top = 24
      Width = 383
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Text = '<'#1074#1074#1077#1076#1080#1090#1077' '#1092#1080#1083#1100#1090#1088' '#1087#1086#1080#1089#1082#1072'>'
      OnChange = edtSearchChange
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 57
    Width = 398
    Height = 434
    Align = alClient
    Caption = #1057#1087#1080#1089#1086#1082' '#1086#1073#1098#1077#1082#1090#1086#1074
    TabOrder = 1
    object lstObjects: TListBox
      Left = 2
      Top = 15
      Width = 394
      Height = 417
      Align = alClient
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnMouseMove = lstObjectsMouseMove
    end
  end
end
