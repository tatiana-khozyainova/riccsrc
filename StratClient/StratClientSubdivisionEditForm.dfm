object frmSubdivisionEditForm: TfrmSubdivisionEditForm
  Left = 498
  Top = 290
  Width = 1044
  Height = 540
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1089#1090#1088#1072#1090#1080#1075#1088#1072#1092#1080#1095#1077#1089#1082#1080#1093' '#1088#1072#1079#1073#1080#1074#1086#1082
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
  inline frmSubdivisionEditFrame1: TfrmSubdivisionEditFrame
    Left = 0
    Top = 0
    Width = 1028
    Height = 501
    Align = alClient
    TabOrder = 0
    inherited grdSubdivisionTable: TGridView
      Width = 1028
      Height = 322
    end
    inherited lwErrors: TListView
      Top = 351
      Width = 1028
    end
    inherited tlbrButtons: TToolBar
      Width = 1028
    end
  end
end
