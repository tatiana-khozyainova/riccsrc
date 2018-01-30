object frmDictOptions: TfrmDictOptions
  Left = 0
  Top = 0
  Width = 443
  Height = 277
  Align = alClient
  TabOrder = 0
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 443
    Height = 265
    Align = alTop
    Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    TabOrder = 0
    object lstShowingDicts: TCheckListBox
      Left = 2
      Top = 15
      Width = 439
      Height = 201
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
    end
    object Panel1: TPanel
      Left = 2
      Top = 216
      Width = 439
      Height = 47
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object ckAll: TCheckBox
        Left = 24
        Top = 16
        Width = 97
        Height = 17
        Caption = #1042#1099#1073#1088#1072#1090#1100' '#1074#1089#1077
        TabOrder = 0
        OnClick = ckAllClick
      end
      object ckNonAll: TCheckBox
        Left = 152
        Top = 16
        Width = 97
        Height = 17
        Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1074#1089#1077
        TabOrder = 1
        OnClick = ckNonAllClick
      end
    end
  end
end
