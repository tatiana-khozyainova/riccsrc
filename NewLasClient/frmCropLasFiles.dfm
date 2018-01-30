object frmCropLasFilesForm: TfrmCropLasFilesForm
  Left = 260
  Top = 190
  Width = 723
  Height = 585
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object gbxMain: TGroupBox
    Left = 0
    Top = 0
    Width = 707
    Height = 506
    Align = alClient
    Caption = #1042#1099#1088#1077#1079#1072#1090#1100' '#1092#1072#1081#1083#1099
    TabOrder = 0
    DesignSize = (
      707
      506)
    object lblSelectFolder: TLabel
      Left = 8
      Top = 24
      Width = 82
      Height = 13
      Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1072#1087#1082#1091
    end
    object edtSelectDirectory: TJvDirectoryEdit
      Left = 8
      Top = 40
      Width = 689
      Height = 21
      DialogKind = dkWin32
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object pgctlAll: TPageControl
      Left = 2
      Top = 81
      Width = 703
      Height = 423
      ActivePage = tshByDepths
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 1
      object tshByDepths: TTabSheet
        Caption = #1055#1086' '#1075#1083#1091#1073#1080#1085#1072#1084
        object lblStart: TLabel
          Left = 8
          Top = 16
          Width = 69
          Height = 13
          Caption = #1043#1083#1091#1073#1080#1085#1072' '#1086#1090', '#1084
        end
        object lblToDepth: TLabel
          Left = 8
          Top = 72
          Width = 70
          Height = 13
          Caption = #1043#1083#1091#1073#1080#1085#1072' '#1076#1086', '#1084
        end
        object edtStart: TEdit
          Left = 8
          Top = 32
          Width = 185
          Height = 21
          TabOrder = 0
          Text = '0'
        end
        object edtFinish: TEdit
          Left = 8
          Top = 88
          Width = 185
          Height = 21
          TabOrder = 1
          Text = '5000'
        end
      end
    end
    object prg: TJvProgressBar
      Left = 8
      Top = 64
      Width = 689
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 506
    Width = 707
    Height = 41
    Align = alBottom
    BevelOuter = bvSpace
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
    TabOrder = 1
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
end
