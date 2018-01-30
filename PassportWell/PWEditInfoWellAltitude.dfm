object frmEditWellAltitude: TfrmEditWellAltitude
  Left = 620
  Top = 353
  BorderStyle = bsDialog
  Caption = #1040#1083#1100#1090#1080#1090#1091#1076#1099' '#1087#1086' '#1089#1082#1074#1072#1078#1080#1085#1077
  ClientHeight = 191
  ClientWidth = 438
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
  inline frmAltitudesWell: TfrmAltitudesWell
    Left = 0
    Top = 0
    Width = 438
    Height = 191
    Align = alClient
    TabOrder = 0
    inherited Panel1: TPanel
      Top = 145
      Width = 438
      inherited BitBtn1: TBitBtn
        Left = 11
      end
      inherited BitBtn2: TBitBtn
        Left = 95
      end
      inherited BitBtn3: TBitBtn
        Left = 271
      end
      inherited BitBtn4: TBitBtn
        Left = 355
      end
    end
    inherited grdAltitudes: TGridView
      Width = 438
      Height = 145
    end
  end
end
