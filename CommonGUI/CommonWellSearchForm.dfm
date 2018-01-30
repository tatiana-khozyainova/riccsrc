object frmWellSearch: TfrmWellSearch
  Left = 424
  Top = 203
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1055#1086#1080#1089#1082' '#1089#1082#1074#1072#1078#1080#1085#1099
  ClientHeight = 390
  ClientWidth = 587
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
  object pnlButtons: TPanel
    Left = 0
    Top = 349
    Width = 587
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      587
      41)
    object btnClose: TButton
      Left = 467
      Top = 8
      Width = 112
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ModalResult = 2
      TabOrder = 0
      OnClick = btnCloseClick
    end
    object btnResultsToFilter: TButton
      Left = 8
      Top = 8
      Width = 265
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1074' '#1092#1080#1083#1100#1090#1088#1077' '#1087#1083#1086#1097#1072#1076#1077#1081
      ModalResult = 1
      TabOrder = 1
      OnClick = btnResultsToFilterClick
    end
  end
  object gbxName: TGroupBox
    Left = 0
    Top = 0
    Width = 587
    Height = 105
    Align = alTop
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1082#1088#1080#1090#1077#1088#1080#1080' '#1087#1086#1080#1089#1082#1072
    TabOrder = 1
    object lblAreaName: TLabel
      Left = 8
      Top = 24
      Width = 196
      Height = 13
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1087#1083#1086#1097#1072#1076#1080' '#1080#1083#1080' '#1077#1075#1086' '#1095#1072#1089#1090#1100
    end
    object lblWellNum: TLabel
      Left = 294
      Top = 26
      Width = 161
      Height = 13
      Caption = #1053#1086#1084#1077#1088' '#1089#1082#1074#1072#1078#1080#1085#1099' '#1080#1083#1080' '#1077#1075#1086' '#1095#1072#1089#1090#1100
    end
    object edtAreaName: TEdit
      Left = 8
      Top = 48
      Width = 281
      Height = 21
      TabOrder = 0
    end
    object edtWellNum: TEdit
      Left = 294
      Top = 48
      Width = 161
      Height = 21
      TabOrder = 1
    end
    object chbxStrictAreaSearch: TCheckBox
      Left = 9
      Top = 72
      Width = 185
      Height = 17
      Caption = #1089#1090#1088#1086#1075#1086#1077' '#1089#1086#1086#1090#1074#1077#1090#1089#1090#1074#1080#1077
      TabOrder = 2
    end
    object chbxStrictWellSearch: TCheckBox
      Left = 295
      Top = 74
      Width = 160
      Height = 17
      Caption = #1089#1090#1088#1086#1075#1086#1077' '#1089#1086#1086#1090#1074#1077#1090#1089#1090#1074#1080#1077
      TabOrder = 3
    end
    object btnSearch: TButton
      Left = 463
      Top = 45
      Width = 113
      Height = 25
      Caption = #1048#1089#1082#1072#1090#1100
      TabOrder = 4
      OnClick = btnSearchClick
    end
  end
  object gbxAreaList: TGroupBox
    Left = 0
    Top = 105
    Width = 587
    Height = 244
    Align = alClient
    Caption = #1057#1087#1080#1089#1086#1082' '#1087#1083#1086#1097#1072#1076#1077#1081
    TabOrder = 2
    object chklstAreaList: TCheckListBox
      Left = 2
      Top = 15
      Width = 583
      Height = 227
      Align = alClient
      ItemHeight = 13
      PopupMenu = pmListOperations
      TabOrder = 0
    end
  end
  object pmListOperations: TPopupMenu
    Left = 160
    Top = 161
    object pmiSelectAll: TMenuItem
      Caption = #1054#1090#1084#1077#1090#1080#1090#1100' '#1074#1089#1077
      OnClick = pmiSelectAllClick
    end
    object pmiDeselectAll: TMenuItem
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1086#1090#1084#1077#1090#1082#1080
      OnClick = pmiDeselectAllClick
    end
    object N1: TMenuItem
      Caption = #1055#1077#1088#1077#1082#1083#1102#1095#1080#1090#1100' '#1074#1099#1073#1086#1088#1082#1091
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object pmiDeleteAll: TMenuItem
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1089#1087#1080#1089#1086#1082
      OnClick = pmiDeleteAllClick
    end
  end
end
