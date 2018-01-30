object frmLicenseInform: TfrmLicenseInform
  Left = 0
  Top = 0
  Width = 803
  Height = 79
  TabOrder = 0
  object grpInform: TGroupBox
    Left = 0
    Top = 0
    Width = 803
    Height = 79
    Align = alClient
    Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1083#1080#1094#1077#1085#1079#1080#1080' '#1085#1077#1076#1088#1086#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
    TabOrder = 0
    DesignSize = (
      803
      79)
    object lblLicenseName: TLabel
      Left = 6
      Top = 16
      Width = 130
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1083#1080#1094#1077#1085#1079#1080#1080':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = cl3DDkShadow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOrgName: TLabel
      Left = 308
      Top = 17
      Width = 147
      Height = 13
      Anchors = [akTop, akRight]
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1080':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = cl3DDkShadow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblLicenseNum: TLabel
      Left = 476
      Top = 17
      Width = 73
      Height = 13
      Anchors = [akTop, akRight]
      Caption = #1042#1080#1076' '#1083#1080#1094#1077#1085#1079#1080#1080':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = cl3DDkShadow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblStrFin: TLabel
      Left = 641
      Top = 16
      Width = 129
      Height = 13
      Anchors = [akTop, akRight]
      Caption = #1057#1088#1086#1082' '#1076#1077#1081#1089#1090#1074#1080#1103' '#1083#1080#1094#1077#1085#1079#1080#1080':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = cl3DDkShadow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object mmLicenseName: TMemo
      Left = 4
      Top = 29
      Width = 296
      Height = 45
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Color = 16436636
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
    object mmoLicenseNum: TMemo
      Left = 475
      Top = 29
      Width = 155
      Height = 45
      Anchors = [akTop, akRight]
      BevelKind = bkFlat
      BorderStyle = bsNone
      Color = clMenuBar
      Lines.Strings = (
        'mmoLicenseNum')
      TabOrder = 1
    end
    object mmoStartFinishDate: TMemo
      Left = 640
      Top = 29
      Width = 155
      Height = 45
      Anchors = [akTop, akRight]
      BevelKind = bkFlat
      BorderStyle = bsNone
      Color = clMenuBar
      Lines.Strings = (
        'mmoStartFinishDate')
      TabOrder = 2
    end
    object mmoOrgName: TMemo
      Left = 308
      Top = 29
      Width = 155
      Height = 45
      Anchors = [akTop, akRight]
      BevelKind = bkFlat
      BorderStyle = bsNone
      Color = 10418363
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
    end
  end
end
