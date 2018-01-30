object frmIDObjectSelect: TfrmIDObjectSelect
  Left = 0
  Top = 0
  Width = 368
  Height = 46
  TabOrder = 0
  DesignSize = (
    368
    46)
  object edtObject: TEdit
    Left = 5
    Top = 21
    Width = 322
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ReadOnly = True
    TabOrder = 0
  end
  object btnObject: TButton
    Left = 331
    Top = 19
    Width = 27
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '...'
    TabOrder = 1
    OnClick = btnObjectClick
  end
  object lblObjectName: TStaticText
    Left = 6
    Top = 3
    Width = 125
    Height = 17
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1086#1073#1098#1077#1082#1090#1072
    TabOrder = 2
  end
end
