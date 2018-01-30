object frmReportByWells: TfrmReportByWells
  Left = 516
  Top = 218
  Width = 432
  Height = 606
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1082#1074#1072#1078#1080#1085#1072#1084
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 509
    Width = 416
    Height = 58
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      416
      58)
    object btnOk: TBitBtn
      Left = 183
      Top = 18
      Width = 100
      Height = 27
      Anchors = [akTop, akRight]
      Caption = #1054#1092#1086#1088#1084#1080#1090#1100
      TabOrder = 0
      OnClick = btnOkClick
      Kind = bkOK
    end
    object btnCancel: TBitBtn
      Left = 295
      Top = 18
      Width = 100
      Height = 27
      Anchors = [akTop, akRight]
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      Kind = bkCancel
    end
    object chkSelectAll: TCheckBox
      Left = 16
      Top = 24
      Width = 153
      Height = 17
      Caption = #1074#1099#1073#1088#1072#1090#1100' '#1074#1089#1077'/'#1086#1095#1080#1089#1090#1080#1090#1100' '#1074#1089#1077
      TabOrder = 2
      OnClick = chkSelectAllClick
    end
  end
  object grp1: TGroupBox
    Left = 0
    Top = 0
    Width = 416
    Height = 509
    Align = alClient
    Caption = #1057#1087#1080#1089#1086#1082' '#1072#1090#1088#1080#1073#1091#1090#1086#1074' '#1086#1090#1095#1077#1090#1072
    TabOrder = 1
    object lstAttributes: TCheckListBox
      Left = 2
      Top = 15
      Width = 412
      Height = 492
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
    end
  end
end
