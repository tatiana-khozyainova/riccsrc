inherited frmEditInfoCoordWell: TfrmEditInfoCoordWell
  Left = 580
  Top = 336
  Width = 666
  Height = 393
  Caption = 'frmEditInfoCoordWell'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited tlbr: TToolBar
    Left = 620
    Height = 354
  end
  inherited dlg: TDialogFrame
    Width = 620
    Height = 354
    inherited pnlButtons: TPanel
      Top = 313
      Width = 620
      inherited btnPrev: TButton
        Visible = False
      end
      inherited btnNext: TButton
        Visible = False
      end
    end
  end
  object btnDelCoord: TButton [2]
    Left = 13
    Top = 328
    Width = 124
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099
    TabOrder = 2
    OnClick = btnDelCoordClick
  end
end
