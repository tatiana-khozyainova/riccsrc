object frmEditor: TfrmEditor
  Left = 705
  Top = 334
  Width = 463
  Height = 137
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1086#1073#1098#1077#1082#1090#1072' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
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
  inline frmAddObject: TfrmAddObject
    Left = 0
    Top = 0
    Width = 455
    Height = 110
    Align = alClient
    TabOrder = 0
    inherited Panel1: TPanel
      Top = 61
      Width = 455
      inherited BitBtn1: TBitBtn
        Left = 389
      end
      inherited BitBtn2: TBitBtn
        Left = 301
      end
    end
    inherited Panel2: TPanel
      Width = 455
      Height = 61
      inherited gbx: TGroupBox
        Width = 292
        Height = 61
        inherited edtName: TEdit
          Width = 278
        end
      end
      inherited frmFilterDicts: TfrmFilter
        Left = 292
        Height = 61
        inherited gbx: TGroupBox
          Height = 61
        end
      end
    end
  end
end
