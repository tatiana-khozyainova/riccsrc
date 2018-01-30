object Frame3: TFrame3
  Left = 0
  Top = 0
  Width = 600
  Height = 550
  Color = clBtnFace
  ParentColor = False
  TabOrder = 0
  DesignSize = (
    600
    550)
  object grp3: TGroupBox
    Left = 16
    Top = 96
    Width = 577
    Height = 153
    Caption = #1056#1077#1075#1080#1089#1090#1088#1072#1094#1080#1086#1085#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
    TabOrder = 25
  end
  object grp2: TGroupBox
    Left = 16
    Top = 304
    Width = 521
    Height = 193
    Caption = #1040#1074#1090#1086#1088#1099' '#1086#1090#1095#1077#1090#1072
    TabOrder = 23
  end
  object grp1: TGroupBox
    Left = 16
    Top = 8
    Width = 577
    Height = 60
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 22
  end
  object cbbSelectMaterial: TComboBox
    Left = 24
    Top = 32
    Width = 561
    Height = 24
    AutoComplete = False
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 0
    OnSelect = actSelectMaterialOnSelectExecute
  end
  object txtSelectMaterial: TStaticText
    Left = 24
    Top = 16
    Width = 323
    Height = 17
    Caption = #1042#1099#1073#1080#1088#1080#1090#1077' '#1089#1091#1097#1077#1089#1090#1074#1091#1102#1097#1080#1081' '#1086#1090#1095#1077#1090' '#1086' '#1089#1077#1081#1089#1084#1086#1088#1072#1079#1074#1077#1076#1086#1095#1085#1099#1093' '#1088#1072#1073#1086#1090#1072#1093
    TabOrder = 1
  end
  object chkAddSimpleDoc: TCheckBox
    Left = 24
    Top = 72
    Width = 273
    Height = 17
    Caption = #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1099#1081' '#1086#1090#1095#1077#1090' '#1089#1077#1081#1089#1084#1086#1088#1072#1079#1074#1077#1076#1086#1095#1085#1099#1093' '#1088#1072#1073#1086#1090
    TabOrder = 2
  end
  object edtInventNumber: TEdit
    Left = 24
    Top = 136
    Width = 249
    Height = 21
    TabOrder = 3
  end
  object edtTGFNumber: TEdit
    Left = 24
    Top = 176
    Width = 249
    Height = 21
    TabOrder = 4
  end
  object dtpCreationDate: TDateTimePicker
    Left = 24
    Top = 216
    Width = 249
    Height = 21
    Date = 0.389849583327304600
    Time = 0.389849583327304600
    TabOrder = 5
  end
  object edtCommentSimpleDoc: TEdit
    Left = 16
    Top = 520
    Width = 513
    Height = 21
    TabOrder = 6
  end
  object txtInventNumber: TStaticText
    Left = 24
    Top = 120
    Width = 108
    Height = 17
    Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1085#1099#1081' '#1085#1086#1084#1077#1088
    TabOrder = 7
  end
  object txtTGFNumber: TStaticText
    Left = 24
    Top = 160
    Width = 65
    Height = 17
    Caption = #1053#1086#1084#1077#1088' '#1058#1043#1060
    TabOrder = 8
  end
  object txtNameSimpleDoc: TStaticText
    Left = 280
    Top = 120
    Width = 90
    Height = 17
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1086#1090#1095#1077#1090#1072
    TabOrder = 9
  end
  object txtCreationDate: TStaticText
    Left = 24
    Top = 200
    Width = 98
    Height = 17
    Caption = #1044#1072#1090#1072' '#1089#1086#1089#1090#1072#1074#1083#1077#1085#1080#1103
    TabOrder = 10
  end
  object txtCommentSimpleDoc: TStaticText
    Left = 16
    Top = 504
    Width = 74
    Height = 17
    Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
    TabOrder = 11
  end
  object edtLocationPath: TEdit
    Left = 552
    Top = 320
    Width = 33
    Height = 21
    TabOrder = 12
    Visible = False
  end
  object txtLocationPath: TStaticText
    Left = 552
    Top = 304
    Width = 78
    Height = 17
    Caption = 'txtLocationPath'
    TabOrder = 13
    Visible = False
  end
  object chklstAuthorOurs: TCheckListBox
    Left = 24
    Top = 352
    Width = 249
    Height = 137
    ItemHeight = 13
    TabOrder = 14
  end
  object cbbOrganization: TComboBox
    Left = 24
    Top = 272
    Width = 249
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 15
  end
  object cbbLocation: TComboBox
    Left = 280
    Top = 272
    Width = 249
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 16
  end
  object txtOrganization: TStaticText
    Left = 24
    Top = 256
    Width = 52
    Height = 17
    Caption = #1047#1072#1082#1072#1079#1095#1080#1082
    TabOrder = 17
  end
  object txtLocation: TStaticText
    Left = 280
    Top = 256
    Width = 86
    Height = 17
    Caption = #1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103
    TabOrder = 18
  end
  object chklstAuthorOutsides: TCheckListBox
    Left = 280
    Top = 352
    Width = 249
    Height = 137
    ItemHeight = 13
    TabOrder = 19
  end
  object btnAddSimpleDoc: TButton
    Left = 552
    Top = 280
    Width = 33
    Height = 25
    Caption = 'actAddSimpleDoc'
    TabOrder = 20
    Visible = False
    OnClick = actAddSimpleDocExecute
  end
  object edtSearhAuthor: TEdit
    Left = 24
    Top = 320
    Width = 505
    Height = 21
    TabOrder = 21
  end
  object edtNameSimpleDoc: TMemo
    Left = 280
    Top = 136
    Width = 305
    Height = 97
    TabOrder = 24
  end
end
