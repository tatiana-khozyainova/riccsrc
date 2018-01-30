inherited frmFileDownload: TfrmFileDownload
  Left = 561
  Top = 166
  Width = 611
  Height = 451
  BorderIcons = [biSystemMenu]
  Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1092#1072#1081#1083#1099
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlStep: TPanel
    Top = 73
    Width = 595
    Height = 56
    inherited prg: TProgressBar
      Top = 31
      Width = 585
    end
    inherited tlbr: TToolBar
      Width = 591
    end
    inherited prgSub: TProgressBar
      Width = 584
    end
  end
  inherited frmCalculationLogger: TfrmCalculationLogger
    Top = 129
    Width = 595
    Height = 284
    inherited gbxLog: TGroupBox
      Width = 595
      Height = 284
      Caption = #1061#1086#1076' '#1101#1082#1089#1087#1086#1088#1090#1072
      inherited lwLog: TListView
        Width = 591
        Height = 267
      end
    end
  end
  object gbxFile: TJvGroupBox [2]
    Left = 0
    Top = 0
    Width = 595
    Height = 73
    Align = alTop
    Caption = #1050#1072#1090#1072#1083#1086#1075' '#1089' '#1092#1072#1081#1083#1072#1084#1080
    TabOrder = 2
    DesignSize = (
      595
      73)
    object edtDirectory: TJvDirectoryEdit
      Left = 8
      Top = 24
      Width = 486
      Height = 21
      DialogKind = dkWin32
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Text = 'edtDirectory'
    end
    object btnGo: TJvImgBtn
      Left = 507
      Top = 21
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100'!'
      TabOrder = 1
      OnClick = btnGoClick
      HotTrackFont.Charset = DEFAULT_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'MS Sans Serif'
      HotTrackFont.Style = []
    end
    object chkDeleteDirIfExists: TCheckBox
      Left = 8
      Top = 48
      Width = 257
      Height = 17
      Caption = #1091#1076#1072#1083#1103#1090#1100' '#1076#1080#1088#1077#1082#1090#1086#1088#1080#1102', '#1077#1089#1083#1080' '#1089#1091#1097#1077#1089#1090#1074#1091#1077#1090
      TabOrder = 2
    end
  end
end
