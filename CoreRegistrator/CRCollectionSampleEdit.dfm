inherited frmCollectionSampleEdit: TfrmCollectionSampleEdit
  Width = 569
  Height = 673
  inherited StatusBar: TStatusBar
    Top = 654
    Width = 569
  end
  object gbxAllProperties: TGroupBox
    Left = 0
    Top = 0
    Width = 569
    Height = 654
    Align = alClient
    Caption = #1057#1074#1086#1081#1089#1090#1074#1072' '#1086#1073#1088#1072#1079#1094#1072
    TabOrder = 1
    object txtWell: TStaticText
      Left = 8
      Top = 16
      Width = 593
      Height = 33
      AutoSize = False
      Caption = '1 - '#1040#1076#1072#1082#1089#1082#1072#1103
      TabOrder = 0
    end
    object edtSampleNum: TLabeledEdit
      Left = 136
      Top = 121
      Width = 121
      Height = 21
      EditLabel.Width = 79
      EditLabel.Height = 13
      EditLabel.Caption = #1053#1086#1084#1077#1088' '#1086#1073#1088#1072#1079#1094#1072
      TabOrder = 1
    end
    object edtSlottingNumber: TLabeledEdit
      Left = 9
      Top = 121
      Width = 121
      Height = 21
      EditLabel.Width = 91
      EditLabel.Height = 13
      EditLabel.Caption = #1053#1086#1084#1077#1088' '#1076#1086#1083#1073#1083#1077#1085#1080#1103
      TabOrder = 2
    end
    object edtAdditionalNum: TLabeledEdit
      Left = 264
      Top = 121
      Width = 145
      Height = 21
      EditLabel.Width = 129
      EditLabel.Height = 13
      EditLabel.Caption = #1053#1086#1084#1077#1088' '#1096#1083#1080#1092#1072'/'#1087#1088#1077#1087#1072#1088#1072#1090#1072
      TabOrder = 3
    end
    object edtLabNumber: TLabeledEdit
      Left = 414
      Top = 121
      Width = 145
      Height = 21
      EditLabel.Width = 110
      EditLabel.Height = 13
      EditLabel.Caption = #1051#1072#1073#1086#1088#1072#1090#1086#1088#1085#1099#1081' '#1085#1086#1084#1077#1088
      TabOrder = 4
    end
    object edtTopDepth: TLabeledEdit
      Left = 8
      Top = 195
      Width = 172
      Height = 21
      EditLabel.Width = 130
      EditLabel.Height = 13
      EditLabel.Caption = #1048#1085#1090#1077#1088#1074#1072#1083' '#1086#1090#1073#1086#1088#1072', '#1074#1077#1088#1093', '#1084
      TabOrder = 5
    end
    object edtBottomDepth: TLabeledEdit
      Left = 194
      Top = 195
      Width = 178
      Height = 21
      EditLabel.Width = 125
      EditLabel.Height = 13
      EditLabel.Caption = #1048#1085#1090#1077#1088#1074#1072#1083' '#1086#1090#1073#1086#1088#1072', '#1085#1080#1079', '#1084
      TabOrder = 6
    end
    object edtFromTopDepth: TLabeledEdit
      Left = 9
      Top = 245
      Width = 171
      Height = 21
      EditLabel.Width = 172
      EditLabel.Height = 13
      EditLabel.Caption = #1043#1083#1091#1073#1080#1085#1072' '#1086#1090#1073#1086#1088#1072' '#1086#1090' '#1074#1077#1088#1093#1072' '#1082#1077#1088#1085#1072', '#1084
      TabOrder = 7
    end
    object edtFromBottomDepth: TLabeledEdit
      Left = 193
      Top = 245
      Width = 179
      Height = 21
      EditLabel.Width = 167
      EditLabel.Height = 13
      EditLabel.Caption = #1043#1083#1091#1073#1080#1085#1072' '#1086#1090#1073#1086#1088#1072' '#1086#1090' '#1085#1080#1079#1072' '#1082#1077#1088#1085#1072', '#1084
      TabOrder = 8
    end
    object edtAbsDepth: TLabeledEdit
      Left = 377
      Top = 245
      Width = 184
      Height = 21
      EditLabel.Width = 157
      EditLabel.Height = 13
      EditLabel.Caption = #1040#1073#1089#1086#1083#1102#1090#1085#1072#1103' '#1075#1083#1091#1073#1080#1085#1072' '#1086#1090#1073#1086#1088#1072', '#1084
      TabOrder = 9
    end
    object txtNum: TStaticText
      Left = 9
      Top = 86
      Width = 70
      Height = 17
      Caption = #1053#1091#1084#1077#1088#1072#1094#1080#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 10
    end
    object txtIntervals: TStaticText
      Left = 9
      Top = 158
      Width = 70
      Height = 17
      Caption = #1048#1085#1090#1077#1088#1074#1072#1083#1099
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 11
    end
    object txtStrat: TStaticText
      Left = 9
      Top = 278
      Width = 182
      Height = 17
      Caption = #1057#1090#1088#1072#1090#1080#1075#1088#1072#1092#1080#1095#1077#1089#1082#1072#1103' '#1087#1088#1080#1074#1103#1079#1082#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 12
    end
    object txtTopStrat: TStaticText
      Left = 9
      Top = 300
      Width = 41
      Height = 17
      Caption = #1050#1088#1086#1074#1083#1103
      TabOrder = 13
    end
    object cmbxTopStraton: TComboBox
      Left = 10
      Top = 316
      Width = 177
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 14
    end
    object txtBottom: TStaticText
      Left = 193
      Top = 300
      Width = 50
      Height = 17
      Caption = #1055#1086#1076#1086#1096#1074#1072
      TabOrder = 15
    end
    object cmbxStratBottom: TComboBox
      Left = 194
      Top = 316
      Width = 177
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 16
    end
    object chbxStratChecked: TCheckBox
      Left = 376
      Top = 318
      Width = 177
      Height = 17
      Caption = #1089#1090#1088#1072#1090#1080#1075#1088#1072#1092#1080#1103' '#1087#1088#1086#1074#1077#1088#1077#1085#1072
      TabOrder = 17
    end
    object txtDates: TStaticText
      Left = 9
      Top = 358
      Width = 36
      Height = 17
      Caption = #1044#1072#1090#1099
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 18
    end
    object dtpSamplingDate: TDateTimePicker
      Left = 8
      Top = 398
      Width = 169
      Height = 21
      Date = 40341.489755497680000000
      Time = 40341.489755497680000000
      TabOrder = 19
    end
    object txtSamplingDate: TStaticText
      Left = 9
      Top = 380
      Width = 68
      Height = 17
      Caption = #1044#1072#1090#1072' '#1086#1090#1073#1086#1088#1072
      TabOrder = 20
    end
    object txtDesc: TStaticText
      Left = 9
      Top = 430
      Width = 244
      Height = 17
      Caption = #1061#1072#1088#1072#1082#1090#1077#1088#1080#1089#1090#1080#1082#1080' '#1086#1087#1080#1089#1072#1085#1080#1081'/'#1086#1087#1088#1077#1076#1077#1083#1077#1085#1080#1081
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 21
    end
    object chbxIsDescripted: TCheckBox
      Left = 8
      Top = 452
      Width = 209
      Height = 17
      Caption = #1077#1089#1090#1100' '#1086#1087#1080#1089#1072#1085#1080#1077'/'#1086#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077
      TabOrder = 22
    end
    object chbxIsElDescripted: TCheckBox
      Left = 8
      Top = 473
      Width = 345
      Height = 17
      Caption = #1077#1089#1090#1100' '#1086#1087#1080#1089#1072#1085#1080#1077'/'#1086#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1074' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1086#1084' '#1074#1080#1076#1077
      TabOrder = 23
    end
    object txtSampleType: TStaticText
      Left = 8
      Top = 64
      Width = 79
      Height = 17
      Caption = #1058#1080#1087' '#1086#1073#1088#1072#1079#1094#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 24
    end
    object cmbxSampleType: TComboBox
      Left = 136
      Top = 63
      Width = 425
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 25
    end
    object txtPlacing: TStaticText
      Left = 9
      Top = 502
      Width = 206
      Height = 17
      Caption = #1061#1072#1088#1072#1082#1090#1077#1088#1080#1089#1090#1080#1082#1080' '#1084#1077#1089#1090#1086#1087#1086#1083#1086#1078#1077#1085#1080#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 26
    end
    object edtRoom: TLabeledEdit
      Left = 8
      Top = 536
      Width = 121
      Height = 21
      EditLabel.Width = 42
      EditLabel.Height = 13
      EditLabel.Caption = #1050#1072#1073#1080#1085#1077#1090
      TabOrder = 27
    end
    object edtBox: TLabeledEdit
      Left = 136
      Top = 536
      Width = 121
      Height = 21
      EditLabel.Width = 43
      EditLabel.Height = 13
      EditLabel.Caption = #1050#1086#1088#1086#1073#1082#1072
      TabOrder = 28
    end
  end
end
