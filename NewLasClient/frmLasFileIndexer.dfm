object frmLasFileIndexerForm: TfrmLasFileIndexerForm
  Left = 446
  Top = 172
  Width = 728
  Height = 213
  Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1080#1085#1076#1077#1082#1089#1085#1099#1081' '#1092#1072#1081#1083
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object gbxMain: TGroupBox
    Left = 0
    Top = 0
    Width = 712
    Height = 175
    Align = alClient
    Caption = #1042#1099#1088#1077#1079#1072#1090#1100' '#1092#1072#1081#1083#1099
    TabOrder = 0
    DesignSize = (
      712
      175)
    object lblSelectFolder: TLabel
      Left = 8
      Top = 24
      Width = 140
      Height = 13
      Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1072#1087#1082#1091' '#1089' '#1092#1072#1081#1083#1072#1084#1080
    end
    object lblIndexerFilePath: TLabel
      Left = 8
      Top = 80
      Width = 233
      Height = 13
      Caption = #1059#1082#1072#1078#1080#1090#1077' '#1087#1091#1090#1100' '#1076#1083#1103' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103' '#1092#1072#1081#1083#1072' '#1080#1085#1076#1077#1082#1089#1072
    end
    object edtSelectDirectory: TJvDirectoryEdit
      Left = 8
      Top = 40
      Width = 694
      Height = 21
      DialogKind = dkWin32
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = edtSelectDirectoryChange
    end
    object prg: TJvProgressBar
      Left = 8
      Top = 64
      Width = 694
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object pnlButtons: TPanel
      Left = 2
      Top = 132
      Width = 708
      Height = 41
      Align = alBottom
      BevelOuter = bvSpace
      BiDiMode = bdRightToLeft
      ParentBiDiMode = False
      TabOrder = 2
      object btnStart: TButton
        Left = 544
        Top = 8
        Width = 75
        Height = 25
        Caption = #1057#1090#1072#1088#1090
        TabOrder = 0
        OnClick = btnStartClick
      end
      object btnClose: TButton
        Left = 624
        Top = 8
        Width = 75
        Height = 25
        Cancel = True
        Caption = #1047#1072#1082#1088#1099#1090#1100
        TabOrder = 1
        OnClick = btnCloseClick
      end
    end
    object edtIndexerFilePath: TJvDirectoryEdit
      Left = 8
      Top = 96
      Width = 694
      Height = 21
      DialogKind = dkWin32
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
    end
    object chbxExcludeFileName: TCheckBox
      Left = 8
      Top = 120
      Width = 350
      Height = 17
      Caption = #1080#1089#1082#1083#1102#1095#1080#1090#1100' '#1080#1079' '#1087#1091#1090#1080' '#1092#1072#1081#1083#1072' '#1095#1072#1089#1090#1100' '#1087#1091#1090#1080' '#1082' '#1082#1072#1090#1072#1083#1086#1075#1091' '#1089' '#1092#1072#1081#1083#1072#1084#1080
      TabOrder = 4
    end
  end
end
