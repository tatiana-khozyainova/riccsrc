object frmOptions: TfrmOptions
  Left = 400
  Top = 260
  BorderStyle = bsDialog
  Caption = #1053#1072#1090#1088#1086#1081#1082#1080' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
  ClientHeight = 411
  ClientWidth = 469
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
  object pgctrl: TPageControl
    Left = 0
    Top = 0
    Width = 469
    Height = 352
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      inline frmDictOptions: TfrmDictOptions
        Left = 0
        Top = 0
        Width = 461
        Height = 324
        Align = alClient
        TabOrder = 0
        inherited GroupBox1: TGroupBox
          Width = 461
          inherited lstShowingDicts: TCheckListBox
            Width = 457
          end
          inherited Panel1: TPanel
            Width = 457
          end
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 352
    Width = 469
    Height = 59
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 1
    DesignSize = (
      469
      59)
    object BitBtn1: TBitBtn
      Left = 244
      Top = 16
      Width = 100
      Height = 30
      Anchors = [akTop, akRight]
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 0
      Kind = bkOK
    end
    object BitBtn2: TBitBtn
      Left = 356
      Top = 16
      Width = 100
      Height = 30
      Anchors = [akTop, akRight]
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      Kind = bkCancel
    end
  end
end
