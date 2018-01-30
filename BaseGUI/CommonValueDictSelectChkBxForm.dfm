object frmValueDictSelectChkBx: TfrmValueDictSelectChkBx
  Left = 655
  Top = 288
  Width = 363
  Height = 281
  Caption = #1042#1099#1073#1086#1088' '#1079#1085#1072#1095#1077#1085#1080#1081' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblCaption: TLabel
    Left = 7
    Top = 5
    Width = 190
    Height = 26
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1092#1080#1083#1100#1090#1088' '#1076#1083#1103' '#1073#1086#1083#1077#1077' '#1073#1099#1089#1090#1088#1086#1075#1086' '#13#10#1087#1086#1080#1089#1082#1072' '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1086#1075#1086' '#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object btnOK: TButton
    Left = 190
    Top = 215
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 270
    Top = 215
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object edtSearch: TEdit
    Left = 200
    Top = 7
    Width = 145
    Height = 21
    Enabled = False
    TabOrder = 2
  end
  object lstObjects: TCheckListBox
    Left = 5
    Top = 35
    Width = 345
    Height = 175
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
end
