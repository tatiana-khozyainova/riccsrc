object frmContentsViewForm: TfrmContentsViewForm
  Left = -6
  Top = 92
  Width = 1036
  Height = 540
  Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1082#1077#1088#1085#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inline frmCoreTransferNavigator1: TfrmCoreTransferNavigator
    Left = 0
    Top = 0
    Width = 1020
    Height = 45
    Align = alTop
    TabOrder = 0
    inherited gbxTransfers: TGroupBox
      Width = 1020
      inherited tlbrNavigator: TToolBar
        Width = 1016
      end
    end
  end
  inline frmCoreTransferContentsView1: TfrmCoreTransferContentsView
    Left = 0
    Top = 45
    Width = 1020
    Height = 457
    Align = alClient
    TabOrder = 1
    inherited StatusBar: TStatusBar
      Top = 438
      Width = 1020
    end
    inherited tlbr: TToolBar
      Width = 1020
    end
    inherited gbxTransferTasks: TGroupBox
      Width = 1020
      Height = 409
      inherited grdCoreTransfers: TGridView
        Width = 1016
        Height = 392
      end
    end
  end
end
