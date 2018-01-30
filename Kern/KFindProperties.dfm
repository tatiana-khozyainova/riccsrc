object frmFind: TfrmFind
  Left = 720
  Top = 364
  Width = 726
  Height = 488
  Caption = #1055#1086#1080#1089#1082' '#1086#1087#1080#1089#1072#1085#1080#1103' '#1082#1077#1088#1085#1072' '#1087#1086' '#1093#1072#1088#1072#1082#1090#1077#1088#1080#1089#1090#1080#1082#1072#1084
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inline frmFindProperties: TfrmFindProperties
    Left = 0
    Top = 0
    Width = 718
    Height = 461
    Align = alClient
    TabOrder = 0
    inherited Splitter1: TSplitter
      Height = 402
    end
    inherited Panel1: TPanel
      Top = 402
      Width = 718
      inherited btnSearch: TSpeedButton
        Left = 490
      end
      inherited btnClose: TBitBtn
        Left = 602
        OnClick = frmFindProperties1btnCloseClick
      end
    end
    inherited GroupBox1: TGroupBox
      Height = 402
      inherited lstFilter: TListBox
        Height = 385
      end
    end
    inherited GroupBox2: TGroupBox
      Width = 458
      Height = 402
      inherited GroupBox5: TGroupBox
        Width = 454
        Height = 335
        inherited lstDicts: TListBox
          Width = 450
          Height = 318
        end
      end
      inherited Panel2: TPanel
        Width = 454
        inherited GroupBox3: TGroupBox
          Width = 337
          inherited edtText: TEdit
            Width = 319
          end
        end
        inherited GroupBox4: TGroupBox
          Left = 337
        end
      end
    end
  end
end
