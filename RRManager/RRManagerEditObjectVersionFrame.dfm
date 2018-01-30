object frmEditObjectVersion: TfrmEditObjectVersion
  Left = 0
  Top = 0
  Width = 359
  Height = 378
  TabOrder = 0
  object gbxVersionInfo: TGroupBox
    Left = 0
    Top = 0
    Width = 359
    Height = 378
    Align = alClient
    Caption = #1057#1086#1079#1076#1072#1090#1100' '#1074#1077#1088#1089#1080#1102
    TabOrder = 0
    DesignSize = (
      359
      378)
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 115
      Height = 13
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1074#1077#1088#1089#1080#1080
    end
    object Label2: TLabel
      Left = 8
      Top = 118
      Width = 133
      Height = 13
      Caption = #1055#1088#1080#1095#1080#1085#1072' '#1089#1086#1079#1076#1072#1085#1080#1103' '#1074#1077#1088#1089#1080#1080
    end
    object Label3: TLabel
      Left = 9
      Top = 74
      Width = 116
      Height = 13
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103' '#1074#1077#1088#1089#1080#1080
    end
    object edtVersionName: TEdit
      Left = 7
      Top = 40
      Width = 345
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object dtedtVersionDate: TDateEdit
      Left = 7
      Top = 89
      Width = 347
      Height = 21
      DefaultToday = True
      DialogTitle = #1042#1099#1073#1077#1088#1080#1090#1077' '#1076#1072#1090#1091
      Anchors = [akLeft, akTop, akRight]
      NumGlyphs = 2
      TabOrder = 1
    end
    object mmVersionReason: TMemo
      Left = 2
      Top = 132
      Width = 355
      Height = 244
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 2
    end
  end
end
