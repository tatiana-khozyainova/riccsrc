object frmHistory: TfrmHistory
  Left = 0
  Top = 0
  Width = 576
  Height = 501
  TabOrder = 0
  object gbxAll: TGroupBox
    Left = 0
    Top = 0
    Width = 576
    Height = 501
    Align = alClient
    Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1080#1089#1090#1086#1088#1080#1080
    TabOrder = 0
    DesignSize = (
      576
      501)
    object lblDisclaimer: TLabel
      Left = 10
      Top = 35
      Width = 556
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 
        #1042#1099' '#1087#1077#1088#1077#1074#1077#1083#1080' '#1089#1090#1088#1091#1082#1090#1091#1088#1091' '#1080#1079' '#1092#1086#1085#1076#1072' %s '#1074' '#1092#1086#1085#1076' %s. '#1069#1090#1086' '#1089#1077#1088#1100#1077#1079#1085#1086#1077' '#1080#1079#1084#1077#1085 +
        #1077#1085#1080#1077', '#1082#1086#1090#1086#1088#1086#1077' '#1090#1088#1077#1073#1091#1077#1090' '#1086#1090#1076#1077#1083#1100#1085#1086#1081' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080'. '#1047#1072#1087#1086#1083#1085#1080#1090#1077', '#1087#1086#1078#1072#1083#1091#1081#1089 +
        #1090#1072', '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1086#1085#1085#1091#1102' '#1092#1086#1088#1084#1091'.'
      WordWrap = True
    end
    object lblDescription: TLabel
      Left = 8
      Top = 190
      Width = 131
      Height = 13
      Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081' '#1082' '#1076#1077#1081#1089#1090#1074#1080#1102
    end
    object sbtnShowHistory: TSpeedButton
      Left = 442
      Top = 344
      Width = 127
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1102' '#1080#1089#1090#1086#1088#1080#1102
      Flat = True
      OnClick = sbtnShowHistoryClick
    end
    object Label1: TLabel
      Left = 321
      Top = 82
      Width = 141
      Height = 13
      Anchors = [akTop, akRight]
      Caption = #1044#1072#1090#1072' '#1089#1086#1074#1077#1088#1096#1077#1085#1080#1103' '#1076#1077#1081#1089#1090#1074#1080#1103
    end
    inline cmplxActionType: TfrmComplexCombo
      Left = 2
      Top = 80
      Width = 318
      Height = 43
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      TabOrder = 0
      inherited cmbxName: TComboBox
        Top = 18
        Width = 283
      end
      inherited btnShowAdditional: TButton
        Left = 290
        Top = 17
      end
    end
    inline cmplxActionReason: TfrmComplexCombo
      Left = 2
      Top = 136
      Width = 572
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      inherited cmbxName: TComboBox
        Width = 537
      end
      inherited btnShowAdditional: TButton
        Left = 544
      end
    end
    object mmReason: TMemo
      Left = 7
      Top = 205
      Width = 564
      Height = 133
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 2
    end
    object lwHistory: TListView
      Left = 2
      Top = 370
      Width = 572
      Height = 129
      Align = alBottom
      Columns = <>
      TabOrder = 3
      OnChange = lwHistoryChange
    end
    object dtedtActionDate: TDateEdit
      Left = 321
      Top = 99
      Width = 246
      Height = 21
      DefaultToday = True
      Anchors = [akTop, akRight]
      NumGlyphs = 2
      TabOrder = 4
    end
    object edtWhoWhen: TEdit
      Left = 8
      Top = 344
      Width = 431
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 5
    end
  end
end
