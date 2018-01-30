object frmPetrolRegionsEditor: TfrmPetrolRegionsEditor
  Left = 405
  Top = 138
  Width = 870
  Height = 585
  Caption = 'frmPetrolRegionsEditor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inline frmPetrolRegions: TfrmParentChild
    Left = 0
    Top = 0
    Width = 854
    Height = 505
    Align = alClient
    TabOrder = 0
    inherited StatusBar: TStatusBar
      Top = 486
      Width = 854
    end
    inherited trwHierarchy: TTreeView
      Width = 854
      Height = 486
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 505
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
