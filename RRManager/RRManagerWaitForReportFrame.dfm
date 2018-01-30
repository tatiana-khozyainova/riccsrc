object frmWaitForReport: TfrmWaitForReport
  Left = 0
  Top = 0
  Width = 407
  Height = 294
  TabOrder = 0
  object gbxWaitForReport: TGroupBox
    Left = 0
    Top = 0
    Width = 407
    Height = 294
    Align = alClient
    Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1086#1090#1095#1077#1090#1072
    TabOrder = 0
    DesignSize = (
      407
      294)
    object lblHeader: TLabel
      Left = 10
      Top = 59
      Width = 33
      Height = 13
      Caption = #1064#1072#1087#1082#1072
      Visible = False
    end
    object lblData: TLabel
      Left = 10
      Top = 139
      Width = 41
      Height = 13
      Caption = #1044#1072#1085#1085#1099#1077
      Visible = False
    end
    object prgHeaders: TProgressBar
      Left = 10
      Top = 84
      Width = 390
      Height = 16
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Visible = False
    end
    object prgData: TProgressBar
      Left = 10
      Top = 159
      Width = 390
      Height = 16
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      Visible = False
    end
  end
end
