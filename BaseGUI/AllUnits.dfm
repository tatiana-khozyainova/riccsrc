object frmAllUnits: TfrmAllUnits
  Left = 572
  Top = 315
  Width = 336
  Height = 388
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082
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
  inline frmAllObjects: TfrmAllObjects
    Left = 0
    Top = 0
    Width = 328
    Height = 354
    Align = alClient
    TabOrder = 0
    inherited GroupBox1: TGroupBox
      Width = 328
      Height = 269
      inherited lstAllObjects: TListBox
        Width = 324
        Height = 252
      end
    end
    inherited Panel1: TPanel
      Top = 305
      Width = 328
    end
    inherited frmButtons: TfrmButtons
      Top = 269
      Width = 328
      inherited tlbr: TToolBar
        Width = 328
      end
    end
  end
end
