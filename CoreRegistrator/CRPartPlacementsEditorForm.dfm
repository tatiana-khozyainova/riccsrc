object frmPartPlacementsEditor: TfrmPartPlacementsEditor
  Left = 166
  Top = 184
  Width = 870
  Height = 640
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inline frmPartPlacements1: TfrmPartPlacements
    Left = 0
    Top = 0
    Width = 854
    Height = 560
    Align = alClient
    TabOrder = 0
    inherited spl1: TSplitter
      Left = 585
      Height = 541
    end
    inherited StatusBar: TStatusBar
      Top = 541
      Width = 854
    end
    inherited trwHierarchy: TTreeView
      Width = 585
      Height = 541
    end
    inherited frmPartPlacement1: TfrmPartPlacement
      Left = 588
      Height = 541
      inherited StatusBar: TStatusBar
        Top = 522
      end
      inherited gbxProperties: TGroupBox
        Height = 522
      end
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 560
    Width = 854
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
