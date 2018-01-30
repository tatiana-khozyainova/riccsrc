inherited frmCoreTransferEdit: TfrmCoreTransferEdit
  object gbxCoreTransfer: TGroupBox
    Left = 0
    Top = 0
    Width = 477
    Height = 234
    Align = alClient
    Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1082#1077#1088#1085#1072
    TabOrder = 1
    object dtpTransferStart: TDateTimePicker
      Left = 8
      Top = 52
      Width = 186
      Height = 21
      Date = 42280.246366793980000000
      Time = 42280.246366793980000000
      TabOrder = 0
    end
    object chbxTransferFinish: TCheckBox
      Left = 8
      Top = 88
      Width = 233
      Height = 17
      Caption = #1091#1082#1072#1079#1072#1090#1100' '#1076#1072#1090#1091' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
      TabOrder = 1
      OnClick = chbxTransferFinishClick
    end
    object lblTransferStart: TStaticText
      Left = 8
      Top = 32
      Width = 142
      Height = 17
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
      TabOrder = 2
    end
    object lblTransferFinish: TStaticText
      Left = 8
      Top = 112
      Width = 160
      Height = 17
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
      Enabled = False
      TabOrder = 3
    end
  end
  object dtpTransferFinish: TDateTimePicker
    Left = 8
    Top = 132
    Width = 186
    Height = 21
    Date = 42280.246366793980000000
    Time = 42280.246366793980000000
    Enabled = False
    TabOrder = 2
  end
end
