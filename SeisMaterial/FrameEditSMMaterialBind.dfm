object Frame4: TFrame4
  Left = 0
  Top = 0
  Width = 600
  Height = 550
  Constraints.MinHeight = 550
  Constraints.MinWidth = 600
  Color = clBtnFace
  ParentColor = False
  TabOrder = 0
  DesignSize = (
    600
    550)
  object grp1: TGroupBox
    Left = 16
    Top = 8
    Width = 577
    Height = 57
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 8
  end
  object lstMaterialBind: TListBox
    Left = 24
    Top = 72
    Width = 193
    Height = 457
    ItemHeight = 13
    TabOrder = 0
  end
  object lstObjectBindAll: TListBox
    Left = 232
    Top = 88
    Width = 353
    Height = 193
    ItemHeight = 13
    TabOrder = 1
  end
  object edtMaterialBind: TEdit
    Left = 232
    Top = 288
    Width = 353
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object lstObjectBindCurrent: TListBox
    Left = 232
    Top = 336
    Width = 353
    Height = 193
    ItemHeight = 13
    TabOrder = 3
  end
  object txtSelectMaterial: TStaticText
    Left = 24
    Top = 16
    Width = 323
    Height = 17
    Caption = #1042#1099#1073#1080#1088#1080#1090#1077' '#1089#1091#1097#1077#1089#1090#1074#1091#1102#1097#1080#1081' '#1086#1090#1095#1077#1090' '#1086' '#1089#1077#1081#1089#1084#1086#1088#1072#1079#1074#1077#1076#1086#1095#1085#1099#1093' '#1088#1072#1073#1086#1090#1072#1093
    TabOrder = 4
  end
  object cbbSelectMaterial: TComboBox
    Left = 24
    Top = 32
    Width = 561
    Height = 24
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 5
  end
  object txtObjectBindCurrent: TStaticText
    Left = 232
    Top = 320
    Width = 147
    Height = 17
    Caption = #1058#1077#1082#1091#1097#1080#1077' '#1086#1073#1098#1077#1082#1090#1099' '#1087#1088#1080#1074#1103#1079#1082#1080
    TabOrder = 6
  end
  object txtObjectBindAll: TStaticText
    Left = 232
    Top = 72
    Width = 163
    Height = 17
    Caption = #1042#1086#1079#1084#1086#1078#1085#1099#1077' '#1086#1073#1098#1077#1082#1090#1099' '#1087#1088#1080#1074#1103#1079#1082#1080
    TabOrder = 7
  end
end
