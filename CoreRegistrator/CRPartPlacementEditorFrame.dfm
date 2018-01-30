inherited frmPartPlacement: TfrmPartPlacement
  Width = 381
  Height = 383
  inherited StatusBar: TStatusBar
    Top = 364
    Width = 381
  end
  object gbxProperties: TGroupBox
    Left = 0
    Top = 0
    Width = 381
    Height = 364
    Align = alClient
    Caption = #1057#1074#1086#1081#1089#1090#1074#1072
    TabOrder = 1
    DesignSize = (
      381
      364)
    object lblType: TLabel
      Left = 8
      Top = 72
      Width = 103
      Height = 13
      Caption = #1058#1080#1087' '#1084#1077#1089#1090#1072' '#1093#1088#1072#1085#1077#1085#1080#1103
    end
    object lblPlacement: TLabel
      Left = 8
      Top = 118
      Width = 128
      Height = 13
      Caption = #1057#1090#1072#1088#1096#1077#1077' '#1084#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103
    end
    object edtName: TLabeledEdit
      Left = 6
      Top = 40
      Width = 369
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 160
      EditLabel.Height = 13
      EditLabel.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1084#1077#1089#1090#1072' '#1093#1088#1072#1085#1077#1085#1080#1103
      TabOrder = 0
    end
    object cmbxType: TComboBox
      Left = 7
      Top = 88
      Width = 369
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 1
    end
    object cmbxPlacementType: TComboBox
      Left = 8
      Top = 136
      Width = 366
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 2
    end
  end
end
