object Frame6: TFrame6
  Left = 0
  Top = 0
  Width = 600
  Height = 550
  Constraints.MinHeight = 550
  Constraints.MinWidth = 600
  Color = clMoneyGreen
  ParentColor = False
  TabOrder = 0
  DesignSize = (
    600
    550)
  object grp3: TGroupBox
    Left = 16
    Top = 296
    Width = 577
    Height = 209
    Caption = #1057#1086#1089#1090#1072#1074#1085#1099#1077' '#1101#1083#1077#1084#1077#1085#1090#1099' '#1101#1082#1079#1077#1084#1087#1083#1103#1088#1072
    TabOrder = 30
  end
  object grp2: TGroupBox
    Left = 16
    Top = 72
    Width = 577
    Height = 185
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1101#1082#1079#1077#1084#1087#1083#1103#1088#1086#1074' '#1086#1090#1095#1077#1090#1072
    TabOrder = 29
  end
  object grp1: TGroupBox
    Left = 16
    Top = 8
    Width = 577
    Height = 60
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 28
  end
  object txtSelectMaterial: TStaticText
    Left = 24
    Top = 16
    Width = 323
    Height = 17
    Caption = #1042#1099#1073#1080#1088#1080#1090#1077' '#1089#1091#1097#1077#1089#1090#1074#1091#1102#1097#1080#1081' '#1086#1090#1095#1077#1090' '#1086' '#1089#1077#1081#1089#1084#1086#1088#1072#1079#1074#1077#1076#1086#1095#1085#1099#1093' '#1088#1072#1073#1086#1090#1072#1093
    TabOrder = 0
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
    TabOrder = 1
  end
  object lstExempleCurrent: TListBox
    Left = 24
    Top = 88
    Width = 305
    Height = 121
    ItemHeight = 13
    TabOrder = 2
  end
  object cbbTypeExemple: TComboBox
    Left = 336
    Top = 104
    Width = 249
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
  end
  object cbbLocExemple: TComboBox
    Left = 336
    Top = 144
    Width = 249
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
  end
  object edtCountExemple: TEdit
    Left = 336
    Top = 184
    Width = 249
    Height = 21
    TabOrder = 5
  end
  object edtCommentExemple: TEdit
    Left = 24
    Top = 232
    Width = 561
    Height = 21
    TabOrder = 6
  end
  object txtTypeExemple: TStaticText
    Left = 336
    Top = 88
    Width = 88
    Height = 17
    Caption = #1058#1080#1087' '#1101#1082#1079#1077#1084#1087#1083#1103#1088#1072
    TabOrder = 7
  end
  object txtLocExemple: TStaticText
    Left = 336
    Top = 128
    Width = 97
    Height = 17
    Caption = #1052#1077#1089#1090#1086#1085#1072#1093#1086#1078#1076#1077#1085#1080#1077
    TabOrder = 8
  end
  object txtCountExemple: TStaticText
    Left = 336
    Top = 168
    Width = 133
    Height = 17
    Caption = #1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1101#1082#1079#1077#1084#1087#1083#1103#1088#1086#1074
    TabOrder = 9
  end
  object txtCommentExemple: TStaticText
    Left = 24
    Top = 216
    Width = 74
    Height = 17
    Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
    TabOrder = 10
  end
  object lstElement: TListBox
    Left = 24
    Top = 312
    Width = 305
    Height = 113
    ItemHeight = 13
    TabOrder = 11
  end
  object cbbTypeElement: TComboBox
    Left = 336
    Top = 328
    Width = 249
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 12
  end
  object edtNumberElement: TEdit
    Left = 336
    Top = 368
    Width = 249
    Height = 21
    TabOrder = 13
  end
  object edtCommentElement: TEdit
    Left = 24
    Top = 480
    Width = 561
    Height = 21
    TabOrder = 14
  end
  object txtTypeElement: TStaticText
    Left = 336
    Top = 312
    Width = 75
    Height = 17
    Caption = #1058#1080#1087' '#1101#1083#1077#1084#1077#1085#1090#1072
    TabOrder = 15
  end
  object txtNumberElement: TStaticText
    Left = 336
    Top = 352
    Width = 90
    Height = 17
    Caption = #1053#1086#1084#1077#1088' '#1101#1083#1077#1084#1077#1085#1090#1072
    TabOrder = 16
  end
  object txtCommentElement: TStaticText
    Left = 24
    Top = 464
    Width = 74
    Height = 17
    Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
    TabOrder = 17
  end
  object btnAddExemple: TButton
    Left = 24
    Top = 264
    Width = 129
    Height = 25
    Caption = 'btnAddExemple'
    TabOrder = 18
  end
  object btnUpExemple: TButton
    Left = 160
    Top = 264
    Width = 129
    Height = 25
    Caption = 'btnUpExemple'
    TabOrder = 19
  end
  object btnDelExemple: TButton
    Left = 296
    Top = 264
    Width = 129
    Height = 25
    Caption = 'btnDelExemple'
    TabOrder = 20
  end
  object btnAddElement: TButton
    Left = 24
    Top = 512
    Width = 129
    Height = 25
    Caption = 'btnAddExemple'
    TabOrder = 21
  end
  object btnUpElement: TButton
    Left = 160
    Top = 512
    Width = 129
    Height = 25
    Caption = 'btnUpExemple'
    TabOrder = 22
  end
  object btnDelElement: TButton
    Left = 296
    Top = 512
    Width = 129
    Height = 25
    Caption = 'btnDelExemple'
    TabOrder = 23
  end
  object edtNameElement: TEdit
    Left = 24
    Top = 440
    Width = 561
    Height = 21
    TabOrder = 24
  end
  object edtLocationElement: TEdit
    Left = 336
    Top = 408
    Width = 249
    Height = 21
    TabOrder = 25
  end
  object txtNameElement: TStaticText
    Left = 24
    Top = 424
    Width = 54
    Height = 17
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077
    TabOrder = 26
  end
  object txtLocationElement: TStaticText
    Left = 336
    Top = 392
    Width = 97
    Height = 17
    Caption = #1052#1077#1089#1090#1086#1085#1072#1093#1086#1078#1076#1077#1085#1080#1077
    TabOrder = 27
  end
end
