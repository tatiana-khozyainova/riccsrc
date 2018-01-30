inherited frmCoreIntervalEdit: TfrmCoreIntervalEdit
  Width = 1360
  Height = 703
  inherited StatusBar: TStatusBar
    Top = 684
    Width = 1360
  end
  object gbxIntervalProperties: TGroupBox
    Left = 0
    Top = 0
    Width = 1360
    Height = 684
    Align = alClient
    Caption = #1056#1077#1076#1072#1082#1094#1080#1103' '#1080#1085#1090#1077#1088#1074#1072#1083#1072
    TabOrder = 1
    DesignSize = (
      1360
      684)
    object Bevel1: TBevel
      Left = 6
      Top = 135
      Width = 1347
      Height = 10
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
      Style = bsRaised
    end
    object Bevel2: TBevel
      Left = 7
      Top = 207
      Width = 1347
      Height = 10
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
      Style = bsRaised
    end
    object Bevel3: TBevel
      Left = 6
      Top = 289
      Width = 1347
      Height = 4
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
      Style = bsRaised
    end
    object Label1: TLabel
      Left = 9
      Top = 298
      Width = 129
      Height = 13
      Caption = #1052#1077#1093#1072#1085#1080#1095#1077#1089#1082#1086#1077' '#1089#1086#1089#1090#1086#1103#1085#1080#1077
    end
    object Label2: TLabel
      Left = 144
      Top = 32
      Width = 64
      Height = 13
      Caption = #1044#1072#1090#1072' '#1086#1090#1073#1086#1088#1072
    end
    object Label3: TLabel
      Left = 327
      Top = 297
      Width = 70
      Height = 13
      Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
    end
    object edtIntervalNumber: TLabeledEdit
      Left = 10
      Top = 48
      Width = 121
      Height = 21
      EditLabel.Width = 90
      EditLabel.Height = 13
      EditLabel.Caption = #1053#1086#1084#1077#1088' '#1080#1085#1090#1077#1088#1074#1072#1083#1072
      TabOrder = 0
    end
    object edtTopDepth: TLabeledEdit
      Left = 12
      Top = 103
      Width = 121
      Height = 21
      EditLabel.Width = 72
      EditLabel.Height = 13
      EditLabel.Caption = #1043#1083#1091#1073#1080#1085#1072' '#1086#1090' ('#1084')'
      TabOrder = 2
    end
    object edtBottomDepth: TLabeledEdit
      Left = 142
      Top = 103
      Width = 121
      Height = 21
      EditLabel.Width = 73
      EditLabel.Height = 13
      EditLabel.Caption = #1043#1083#1091#1073#1080#1085#1072' '#1076#1086' ('#1084')'
      TabOrder = 3
    end
    object edtCoreYield: TLabeledEdit
      Left = 15
      Top = 178
      Width = 121
      Height = 21
      EditLabel.Width = 82
      EditLabel.Height = 13
      EditLabel.Caption = #1042#1099#1093#1086#1076' '#1082#1077#1088#1085#1072' ('#1084')'
      TabOrder = 4
    end
    object edtFinalCoreYield: TLabeledEdit
      Left = 141
      Top = 178
      Width = 121
      Height = 21
      EditLabel.Width = 106
      EditLabel.Height = 26
      EditLabel.Caption = #1060#1072#1082#1090#1080#1095#1077#1089#1082#1080#1081' '#1074#1099#1093#1086#1076' '#1082#1077#1088#1085#1072' ('#1084')'
      EditLabel.WordWrap = True
      LabelSpacing = 4
      TabOrder = 5
    end
    object edtDiameter: TLabeledEdit
      Left = 267
      Top = 177
      Width = 121
      Height = 21
      EditLabel.Width = 71
      EditLabel.Height = 13
      EditLabel.Caption = #1044#1080#1072#1084#1077#1090#1088' ('#1084#1084')'
      TabOrder = 6
    end
    object chlbxMechState: TCheckListBox
      Left = 8
      Top = 316
      Width = 305
      Height = 205
      ItemHeight = 13
      TabOrder = 7
    end
    object dtmTakeDate: TDateTimePicker
      Left = 144
      Top = 48
      Width = 251
      Height = 21
      Date = 39827.600056782410000000
      Time = 39827.600056782410000000
      TabOrder = 1
    end
    inline frmStratigraphyName: TfrmIDObjectSelect
      Left = 8
      Top = 224
      Width = 1346
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 8
      inherited edtObject: TEdit
        Width = 1300
      end
      inherited btnObject: TButton
        Left = 1309
      end
    end
    object mmComment: TMemo
      Left = 327
      Top = 315
      Width = 1027
      Height = 206
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 9
    end
  end
end
