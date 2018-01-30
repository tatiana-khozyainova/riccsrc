inherited frmCollectionEditFrame: TfrmCollectionEditFrame
  Width = 591
  Height = 391
  inherited StatusBar: TStatusBar
    Top = 372
    Width = 591
  end
  inherited gbxObjectInfo: TGroupBox
    Width = 591
    Height = 372
    Caption = #1057#1074#1086#1081#1089#1090#1074#1072' '#1082#1086#1083#1083#1077#1082#1094#1080#1080
    inherited edtName: TLabeledEdit
      Width = 573
      EditLabel.Width = 133
      EditLabel.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1082#1086#1083#1083#1077#1082#1094#1080#1080
    end
    inherited edtShortName: TLabeledEdit
      Width = 576
      TabOrder = 5
    end
    object cmbxCollectionType: TComboBox
      Left = 8
      Top = 89
      Width = 301
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnCloseUp = cmbxCollectionTypeCloseUp
    end
    object cmbxFossilType: TComboBox
      Left = 316
      Top = 89
      Width = 265
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      ItemHeight = 13
      TabOrder = 2
    end
    object cmbxCollectionAuthor: TComboBox
      Left = 7
      Top = 206
      Width = 305
      Height = 21
      ItemHeight = 13
      TabOrder = 6
    end
    object cmbxCollectionOwner: TComboBox
      Left = 316
      Top = 206
      Width = 265
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 7
    end
    object cmbxTopStrat: TComboBox
      Left = 8
      Top = 147
      Width = 302
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
    end
    object cmbxBottomStrat: TComboBox
      Left = 316
      Top = 147
      Width = 266
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 4
    end
    object txtCollectionType: TStaticText
      Left = 8
      Top = 72
      Width = 80
      Height = 17
      Caption = #1058#1080#1087' '#1082#1086#1083#1083#1077#1082#1094#1080#1080
      TabOrder = 8
    end
    object txtFossilType: TStaticText
      Left = 315
      Top = 72
      Width = 144
      Height = 17
      Caption = #1058#1080#1087' '#1086#1088#1075#1072#1085#1080#1095#1077#1089#1082#1080#1093' '#1086#1089#1090#1072#1090#1082#1086#1074
      Enabled = False
      TabOrder = 9
    end
    object txtStratigraphy: TStaticText
      Left = 8
      Top = 128
      Width = 197
      Height = 17
      Caption = #1057#1090#1088#1072#1090#1080#1075#1088#1072#1092#1080#1095#1077#1089#1082#1072#1103' '#1087#1088#1080#1074#1103#1079#1082#1072' ('#1086#1090' - '#1076#1086')'
      TabOrder = 10
    end
    object txtAuthorName: TStaticText
      Left = 8
      Top = 188
      Width = 91
      Height = 17
      Caption = #1040#1074#1090#1086#1088' '#1082#1086#1083#1083#1077#1082#1094#1080#1080
      TabOrder = 11
    end
    object txtCollectionOwner: TStaticText
      Left = 316
      Top = 189
      Width = 110
      Height = 17
      Caption = #1042#1083#1072#1076#1077#1083#1077#1094' '#1082#1086#1083#1083#1077#1082#1094#1080#1080
      TabOrder = 12
    end
  end
end
