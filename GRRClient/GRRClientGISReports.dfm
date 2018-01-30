object frmGISReports: TfrmGISReports
  Left = 418
  Top = 273
  Width = 931
  Height = 467
  Caption = #1054#1090#1095#1077#1090#1099' '#1076#1083#1103' '#1082#1072#1088#1090#1099
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 388
    Width = 915
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      915
      41)
    object btnOK: TButton
      Left = 752
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnClose: TButton
      Left = 832
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 1
      OnClick = btnCloseClick
    end
    object chbxXLReports: TCheckBox
      Left = 16
      Top = 16
      Width = 345
      Height = 17
      Caption = #1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1086#1090#1095#1077#1090#1099' Excel'
      TabOrder = 2
    end
  end
  object gbxAll: TGroupBox
    Left = 0
    Top = 0
    Width = 915
    Height = 388
    Align = alClient
    Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' XML-'#1092#1072#1081#1083#1072' '#1076#1083#1103' '#1085#1072#1074#1080#1075#1072#1094#1080#1080' '#1087#1086' '#1082#1072#1088#1090#1077
    TabOrder = 1
    object pbQueryProgress: TProgressBar
      Left = 2
      Top = 369
      Width = 911
      Height = 17
      Align = alBottom
      Step = 1
      TabOrder = 0
    end
    object pnlPath: TPanel
      Left = 2
      Top = 15
      Width = 911
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        911
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
        Width = 904
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
      Width = 911
      Height = 313
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      object spl1: TSplitter
        Left = 289
        Top = 0
        Height = 313
      end
      object chklstQueries: TCheckListBox
        Left = 292
        Top = 0
        Width = 619
        Height = 313
        OnClickCheck = chklstQueriesClickCheck
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
      end
      object chklstVersions: TCheckListBox
        Left = 0
        Top = 0
        Width = 289
        Height = 313
        Align = alLeft
        ItemHeight = 13
        TabOrder = 1
      end
    end
  end
end
