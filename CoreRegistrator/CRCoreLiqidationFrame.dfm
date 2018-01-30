inherited frmCoreLiquidaton: TfrmCoreLiquidaton
  Width = 571
  Height = 453
  inherited StatusBar: TStatusBar
    Top = 434
    Width = 571
  end
  object gbxAll: TGroupBox
    Left = 0
    Top = 0
    Width = 571
    Height = 434
    Align = alClient
    Caption = #1051#1080#1082#1074#1080#1076#1072#1094#1080#1103
    TabOrder = 1
    DesignSize = (
      571
      434)
    object lblLiquidationDate: TLabel
      Left = 8
      Top = 24
      Width = 89
      Height = 13
      Caption = #1044#1072#1090#1072' '#1083#1080#1082#1074#1080#1076#1072#1094#1080#1080
    end
    object lblSlottings: TLabel
      Left = 8
      Top = 80
      Width = 137
      Height = 13
      Caption = #1051#1080#1082#1074#1080#1076#1080#1088#1086#1074#1072#1090#1100' '#1080#1085#1090#1077#1088#1074#1072#1083#1099
    end
    object chklstSlottings: TCheckListBox
      Left = 2
      Top = 103
      Width = 567
      Height = 329
      Align = alBottom
      ItemHeight = 13
      TabOrder = 0
    end
    object dtpLiqidationFrame: TDateTimePicker
      Left = 8
      Top = 40
      Width = 551
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Date = 40718.622232453700000000
      Time = 40718.622232453700000000
      TabOrder = 1
    end
  end
end
