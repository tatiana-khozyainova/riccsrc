object frmChangeLicenseZoneFrame: TfrmChangeLicenseZoneFrame
  Left = 0
  Top = 0
  Width = 481
  Height = 447
  TabOrder = 0
  object gbxStatusChange: TGroupBox
    Left = 0
    Top = 0
    Width = 481
    Height = 447
    Align = alClient
    Caption = #1057#1084#1077#1085#1072' '#1089#1090#1072#1090#1091#1089#1072' '#1083#1080#1094#1077#1085#1079#1080#1086#1085#1085#1086#1075#1086' '#1091#1095#1072#1089#1090#1082#1072
    TabOrder = 0
    DesignSize = (
      481
      447)
    inline cmplxLicenseZoneState: TfrmComplexCombo
      Left = 7
      Top = 88
      Width = 466
      Height = 46
      TabOrder = 0
      inherited cmbxName: TComboBox
        Width = 433
      end
      inherited btnShowAdditional: TButton
        Left = 439
      end
    end
    object lblLicenseZone: TStaticText
      Left = 8
      Top = 24
      Width = 465
      Height = 65
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      BevelKind = bkFlat
      Caption = #1042#1080#1076' '#1092#1086#1085#1076#1072' '#1076#1083#1103' '#1083#1080#1094#1077#1085#1079#1080#1086#1085#1085#1086#1075#1086' '#1091#1095#1072#1089#1090#1082#1072' %s '#1073#1091#1076#1077#1090' '#1080#1079#1084#1077#1085#1077#1085' '#1085#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
  end
end
