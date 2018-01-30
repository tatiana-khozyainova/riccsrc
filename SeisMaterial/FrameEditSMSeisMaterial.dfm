object Frame5: TFrame5
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
    Left = 296
    Top = 72
    Width = 297
    Height = 265
    Caption = #1057#1077#1081#1089#1084#1086#1087#1088#1086#1092#1080#1083#1080' '#1087#1086#1083#1091#1095#1077#1085#1085#1099#1077' '#1074' '#1093#1086#1076#1077' '#1088#1072#1073#1086#1090
    TabOrder = 28
  end
  object grp2: TGroupBox
    Left = 16
    Top = 72
    Width = 265
    Height = 265
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1088#1072#1073#1086#1090
    TabOrder = 27
  end
  object grp1: TGroupBox
    Left = 16
    Top = 8
    Width = 577
    Height = 60
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 26
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
    TabOrder = 0
  end
  object txtSelectMaterial: TStaticText
    Left = 24
    Top = 16
    Width = 323
    Height = 17
    Caption = #1042#1099#1073#1080#1088#1080#1090#1077' '#1089#1091#1097#1077#1089#1090#1074#1091#1102#1097#1080#1081' '#1086#1090#1095#1077#1090' '#1086' '#1089#1077#1081#1089#1084#1086#1088#1072#1079#1074#1077#1076#1086#1095#1085#1099#1093' '#1088#1072#1073#1086#1090#1072#1093
    TabOrder = 1
  end
  object dtpBeginWorks: TDateTimePicker
    Left = 24
    Top = 144
    Width = 249
    Height = 21
    Date = 0.475283321757160600
    Time = 0.475283321757160600
    TabOrder = 2
  end
  object dtpEndWorks: TDateTimePicker
    Left = 24
    Top = 184
    Width = 249
    Height = 21
    Date = 0.475422685187368200
    Time = 0.475422685187368200
    TabOrder = 3
  end
  object txtBeginWorks: TStaticText
    Left = 24
    Top = 128
    Width = 100
    Height = 17
    Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1088#1072#1073#1086#1090
    TabOrder = 4
  end
  object txtEndWorks: TStaticText
    Left = 24
    Top = 168
    Width = 118
    Height = 17
    Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1088#1072#1073#1086#1090
    TabOrder = 5
  end
  object cbbTypeWorks: TComboBox
    Left = 24
    Top = 264
    Width = 249
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
  end
  object cbbMethodWorks: TComboBox
    Left = 24
    Top = 224
    Width = 249
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 7
  end
  object txtTypeWorks: TStaticText
    Left = 24
    Top = 248
    Width = 55
    Height = 17
    Caption = #1058#1080#1087' '#1088#1072#1073#1086#1090
    TabOrder = 8
  end
  object txtMethodWorks: TStaticText
    Left = 24
    Top = 208
    Width = 68
    Height = 17
    Caption = #1052#1077#1090#1086#1076' '#1088#1072#1073#1086#1090
    TabOrder = 9
  end
  object edtScaleWorks: TEdit
    Left = 24
    Top = 304
    Width = 249
    Height = 21
    TabOrder = 10
  end
  object txtScaleWorks: TStaticText
    Left = 24
    Top = 288
    Width = 82
    Height = 17
    Caption = #1052#1072#1089#1096#1090#1072#1073' '#1088#1072#1073#1086#1090
    TabOrder = 11
  end
  object cbbSeisCrews: TComboBox
    Left = 24
    Top = 104
    Width = 249
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 12
  end
  object txtSeisCrews: TStaticText
    Left = 24
    Top = 88
    Width = 78
    Height = 17
    Caption = #1057#1077#1081#1089#1084#1086#1087#1072#1088#1090#1080#1103
    TabOrder = 13
  end
  object edtRefComp: TEdit
    Left = 24
    Top = 360
    Width = 561
    Height = 21
    TabOrder = 14
  end
  object txtRefComp: TStaticText
    Left = 24
    Top = 344
    Width = 76
    Height = 17
    Caption = #1057#1086#1089#1090#1072#1074' '#1086#1090#1095#1077#1090#1072
    TabOrder = 15
  end
  object txtStructMap: TStaticText
    Left = 24
    Top = 392
    Width = 120
    Height = 17
    Caption = #1057#1090#1088#1091#1082#1090#1091#1088#1085#1099#1077' '#1082#1072#1088#1090#1099' '#1054#1043
    TabOrder = 16
  end
  object txtCross: TStaticText
    Left = 24
    Top = 464
    Width = 49
    Height = 17
    Caption = #1056#1072#1079#1088#1077#1079#1099
    TabOrder = 17
  end
  object cbbProfile: TComboBox
    Left = 304
    Top = 104
    Width = 281
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 18
  end
  object lstProfileCurrent: TListBox
    Left = 304
    Top = 184
    Width = 281
    Height = 145
    ItemHeight = 13
    TabOrder = 19
  end
  object btnAddProfile: TButton
    Left = 304
    Top = 136
    Width = 137
    Height = 25
    Caption = #1055#1088#1080#1074#1103#1079#1072#1090#1100' '#1089#1077#1081#1089#1084#1086#1087#1088#1086#1092#1080#1083#1100'>>>>>'
    TabOrder = 20
  end
  object rgProfile: TRadioGroup
    Left = 376
    Top = 448
    Width = 145
    Height = 17
    Items.Strings = (
      #1042#1089#1077' '#1089#1077#1081#1089#1084#1086#1087#1088#1086#1092#1080#1083#1103
      #1053#1077' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1085#1099#1077)
    TabOrder = 21
    Visible = False
  end
  object txtProfile: TStaticText
    Left = 304
    Top = 168
    Width = 199
    Height = 17
    Caption = #1057#1077#1081#1089#1084#1086#1087#1088#1086#1092#1080#1083#1080' '#1089#1074#1103#1079#1072#1085#1085#1099#1077' '#1089' '#1086#1090#1095#1077#1090#1086#1084
    TabOrder = 22
  end
  object txtProfileNotConnect: TStaticText
    Left = 304
    Top = 88
    Width = 192
    Height = 17
    Caption = #1053#1077' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1085#1099#1077' '#1089#1077#1081#1089#1084#1086#1087#1088#1086#1092#1080#1083#1080
    TabOrder = 23
  end
  object mmoStructMap: TMemo
    Left = 24
    Top = 408
    Width = 561
    Height = 49
    TabOrder = 24
  end
  object mmoCross: TMemo
    Left = 24
    Top = 480
    Width = 561
    Height = 49
    Lines.Strings = (
      '')
    TabOrder = 25
  end
  object btn1: TButton
    Left = 448
    Top = 136
    Width = 137
    Height = 25
    Caption = 'btn1'
    TabOrder = 29
  end
end
