object frmValueDictSelect: TfrmValueDictSelect
  Left = 904
  Top = 297
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1042#1099#1073#1086#1088' '#1079#1085#1072#1095#1077#1085#1080#1103' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
  ClientHeight = 245
  ClientWidth = 416
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
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
    Left = 254
    Top = 215
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 334
    Top = 215
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object lstObjects: TListBox
    Left = 5
    Top = 35
    Width = 404
    Height = 175
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = lstObjectsClick
    OnDblClick = lstObjectsDblClick
    OnMouseMove = lstObjectsMouseMove
  end
  object edtSearch: TEdit
    Left = 200
    Top = 7
    Width = 206
    Height = 21
    TabOrder = 3
    OnChange = edtSearchChange
  end
end
