object frmWaitForArchive: TfrmWaitForArchive
  Left = 0
  Top = 0
  Width = 547
  Height = 344
  TabOrder = 0
  object gbxWaitForArchive: TGroupBox
    Left = 0
    Top = 0
    Width = 547
    Height = 344
    Align = alClient
    Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1072#1088#1093#1080#1074#1072
    TabOrder = 0
    DesignSize = (
      547
      344)
    object ggStructure: TGauge
      Left = 8
      Top = 185
      Width = 150
      Height = 150
      BackColor = clMoneyGreen
      ForeColor = clGreen
      Kind = gkPie
      Progress = 0
    end
    object lblStructure: TLabel
      Left = 7
      Top = 85
      Width = 538
      Height = 33
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'C'#1090#1088#1091#1082#1090#1091#1088#1072' ...'
      WordWrap = True
    end
    object Label2: TLabel
      Left = 8
      Top = 24
      Width = 473
      Height = 52
      Caption = 
        #1040#1088#1093#1080#1074#1080#1088#1086#1074#1072#1085#1080#1077' '#1074#1089#1077#1075#1086' '#1092#1086#1085#1076#1072' '#1089#1090#1088#1091#1082#1090#1091#1088' '#1076#1086#1074#1086#1083#1100#1085#1086'-'#1090#1072#1082#1080' '#1076#1083#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1088#1086#1094 +
        #1077#1089#1089', '#13#10#1077#1089#1083#1080' '#1042#1072#1084' '#1082#1072#1078#1077#1090#1089#1103' '#1095#1090#1086' '#1074#1089#1105' '#1087#1088#1086#1080#1089#1093#1086#1076#1080#1090' '#1089#1083#1080#1096#1082#1086#1084' '#1076#1086#1083#1075#1086' - '#1089#1082#1086#1088#1077 +
        #1077' '#1074#1089#1077#1075#1086' '#1101#1090#1086' '#13#10#1089#1086#1074#1077#1088#1096#1077#1085#1085#1086' '#1085#1086#1088#1084#1072#1083#1100#1085#1086'. '#1053#1072#1073#1083#1102#1076#1072#1081#1090#1077' '#1079#1072' '#1080#1085#1076#1080#1082#1072#1090#1086#1088#1072#1084#1080' -' +
        ' '#1082#1086#1075#1076#1072' '#1074#1089#1105' '#1079#1072#1082#1086#1085#1095#1080#1090#1089#1103#13#10#1086#1085#1080' '#1101#1090#1086' '#1087#1086#1082#1072#1078#1091#1090'.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object mmStructuresState: TRichEdit
      Left = 160
      Top = 184
      Width = 377
      Height = 151
      Anchors = [akLeft, akTop, akRight, akBottom]
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object prgStructure: TProgressBar
      Left = 6
      Top = 120
      Width = 534
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
  end
end
