inherited frmOrganizationSelect: TfrmOrganizationSelect
  Left = 479
  Top = 227
  Height = 527
  Caption = 'frmOrganizationSelect'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlButtons: TPanel
    Top = 448
  end
  inherited frmIDObjectListFrame: TfrmIDObjectListFrame
    Top = 65
    Height = 383
    inherited frmButtons1: TfrmButtons
      Height = 383
      inherited tlbr: TToolBar
        Height = 383
      end
    end
    inherited lwObjects: TListView
      Height = 383
    end
  end
  object gbxSearch: TGroupBox
    Left = 0
    Top = 0
    Width = 622
    Height = 65
    Align = alTop
    Caption = #1055#1086#1080#1089#1082
    TabOrder = 2
    object edtSearch: TEdit
      Left = 8
      Top = 24
      Width = 601
      Height = 21
      TabOrder = 0
      OnChange = edtSearchChange
    end
  end
end
