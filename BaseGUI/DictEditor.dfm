object frmDictEditor: TfrmDictEditor
  Left = 198
  Top = 185
  Width = 696
  Height = 480
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1086#1074
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inline cmplxDicts: TfrmComplexList
    Left = 0
    Top = 59
    Width = 688
    Height = 394
    Align = alClient
    TabOrder = 0
    inherited gbxAll: TGroupBox
      Width = 688
      Height = 394
      inherited btnFirst: TSpeedButton
        Left = 658
      end
      inherited btnInsert: TSpeedButton
        Left = 658
        Top = 148
        OnClick = cmplxDictsbtnInsertClick
      end
      inherited btnEdit: TSpeedButton
        Left = 658
        Top = 185
      end
      inherited btnDelete: TSpeedButton
        Left = 658
        Top = 217
      end
      inherited btnLast: TSpeedButton
        Left = 658
        Top = 297
      end
      inherited strgrCurrentDict: TStringGrid
        Width = 648
        Height = 284
      end
      inherited btnOK: TButton
        Left = 528
        Top = 359
      end
      inherited btnCancel: TButton
        Left = 608
        Top = 359
      end
    end
  end
  object gbxSelectDict: TGroupBox
    Left = 0
    Top = 0
    Width = 688
    Height = 59
    Align = alTop
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082
    TabOrder = 1
    object cmbxDict: TComboBox
      Left = 8
      Top = 25
      Width = 673
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = cmbxDictChange
    end
  end
end
