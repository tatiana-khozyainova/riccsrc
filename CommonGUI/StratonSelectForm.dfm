inherited frmStratonSelect: TfrmStratonSelect
  Left = 177
  Top = 195
  Width = 753
  Height = 520
  Caption = 'frmStratonSelect'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlButtons: TPanel
    Top = 441
    Width = 737
    inherited btnClose: TButton
      Caption = #1042#1099#1073#1088#1072#1090#1100
      ModalResult = 1
    end
  end
  inherited frmIDObjectListFrame: TfrmIDObjectListFrame
    Top = 65
    Width = 737
    Height = 376
    inherited frmButtons1: TfrmButtons
      Height = 376
      Visible = False
      inherited tlbr: TToolBar
        Height = 376
      end
    end
    inherited lwObjects: TListView
      Width = 701
      Height = 376
    end
  end
  object gbxSearch: TGroupBox
    Left = 0
    Top = 0
    Width = 737
    Height = 65
    Align = alTop
    Caption = #1055#1086#1080#1089#1082
    TabOrder = 2
    object edtSearch: TEdit
      Left = 8
      Top = 24
      Width = 721
      Height = 21
      TabOrder = 0
      OnChange = edtSearchChange
    end
  end
end
