object frmPartPlacementReportForm: TfrmPartPlacementReportForm
  Left = 209
  Top = 290
  Width = 1044
  Height = 540
  Caption = #1046#1091#1088#1085#1072#1083' '#1087#1086' '#1084#1077#1089#1090#1086#1087#1086#1083#1086#1078#1077#1085#1080#1102' '#1082#1077#1088#1085#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inline frmPartPlacementsReport1: TfrmPartPlacementsReport
    Left = 0
    Top = 0
    Width = 1028
    Height = 460
    Align = alClient
    TabOrder = 0
    inherited spl1: TSplitter
      Left = 759
      Height = 336
    end
    inherited StatusBar: TStatusBar
      Top = 336
      Width = 1028
    end
    inherited trwHierarchy: TTreeView
      Width = 759
      Height = 336
    end
    inherited frmPartPlacement1: TfrmPartPlacement
      Left = 762
      Height = 336
      inherited StatusBar: TStatusBar
        Top = 317
      end
      inherited gbxProperties: TGroupBox
        Height = 317
      end
    end
    inherited gbxSettings: TGroupBox
      Top = 355
      Width = 1028
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 460
    Width = 1028
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnOK: TButton
      Left = 696
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 776
      Top = 8
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
end
