object frmGRRClientGISXLReports: TfrmGRRClientGISXLReports
  Left = 642
  Top = 293
  Width = 579
  Height = 481
  Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' XLS-'#1086#1090#1095#1077#1090#1086#1074' '#1076#1083#1103' '#1082#1072#1088#1090#1099
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object gbxAll: TGroupBox
    Left = 0
    Top = 0
    Width = 563
    Height = 402
    Align = alClient
    Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' XML-'#1092#1072#1081#1083#1072' '#1076#1083#1103' '#1085#1072#1074#1080#1075#1072#1094#1080#1080' '#1087#1086' '#1082#1072#1088#1090#1077
    TabOrder = 0
    object pbQueryProgress: TProgressBar
      Left = 2
      Top = 383
      Width = 559
      Height = 17
      Align = alBottom
      Step = 1
      TabOrder = 0
    end
    object pnlPath: TPanel
      Left = 2
      Top = 15
      Width = 559
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        559
        41)
      object lblPath: TLabel
        Left = 7
        Top = 2
        Width = 115
        Height = 13
        Caption = #1055#1091#1090#1100' '#1082' '#1082#1072#1090#1072#1083#1086#1075#1091' '#1082#1072#1088#1090#1099
      end
      object edtPath: TDirectoryEdit
        Left = 4
        Top = 16
        Width = 552
        Height = 21
        NumGlyphs = 1
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnChange = edtPathChange
      end
    end
    object pnlAll: TPanel
      Left = 2
      Top = 56
      Width = 559
      Height = 327
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      object chklstVersions: TCheckListBox
        Left = 0
        Top = 0
        Width = 559
        Height = 327
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
      end
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 402
    Width = 563
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      563
      41)
    object btnOK: TButton
      Left = 400
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100
      Enabled = False
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnClose: TButton
      Left = 480
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 1
    end
  end
end
