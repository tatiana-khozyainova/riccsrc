object frmThemeSelect: TfrmThemeSelect
  Left = 192
  Top = 132
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1042#1099#1073#1088#1072#1090#1100' '#1090#1077#1084#1091
  ClientHeight = 265
  ClientWidth = 698
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
    Top = 224
    Width = 698
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      698
      41)
    object btnOK: TButton
      Left = 536
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akLeft, akRight, akBottom]
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 616
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akLeft, akRight, akBottom]
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object gbxTheme: TGroupBox
    Left = 0
    Top = 0
    Width = 698
    Height = 224
    Align = alClient
    Caption = #1057#1074#1086#1081#1089#1090#1074#1072' '#1088#1072#1079#1073#1080#1074#1082#1080
    TabOrder = 1
    object lblTheme: TLabel
      Left = 8
      Top = 32
      Width = 27
      Height = 13
      Caption = #1058#1077#1084#1072
    end
    object lblSignedDate: TLabel
      Left = 8
      Top = 88
      Width = 89
      Height = 13
      Caption = #1044#1072#1090#1072' '#1087#1086#1076#1087#1080#1089#1072#1085#1080#1103
    end
    object lblEmployee: TLabel
      Left = 192
      Top = 88
      Width = 78
      Height = 13
      Caption = #1050#1077#1084' '#1087#1086#1076#1087#1080#1089#1072#1085#1086
    end
    object lblAttention: TLabel
      Left = 8
      Top = 144
      Width = 659
      Height = 39
      Caption = 
        #1042#1085#1080#1084#1072#1085#1080#1077'! '#1055#1086#1089#1083#1077' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103' ('#1087#1086' '#1082#1085#1086#1087#1082#1077' "'#1054#1050'") '#1089#1090#1072#1088#1099#1077' '#1088#1072#1079#1073#1080#1074#1082#1080', '#1087#1088#1080 +
        #1091#1088#1086#1095#1077#1085#1085#1099#1077' '#1082' '#1076#1072#1085#1085#1086#1081' '#1090#1077#1084#1077', '#1077#1089#1083#1080' '#1086#1085#1080' '#1089#1091#1097#1077#1089#1090#1074#1086#1074#1072#1083#1080', '#1073#1091#1076#1091#1090' '#1079#1072#1084#1077#1085#1077#1085#1099'. ' +
        #1045#1089#1083#1080' '#1074#1072#1084' '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1089#1086#1093#1088#1072#1085#1080#1090#1100' '#1087#1088#1077#1078#1085#1080#1081' '#1074#1072#1088#1080#1072#1085#1090', '#1090#1086' '#1085#1077' '#1085#1072#1078#1080#1084#1072#1081#1090#1077' "' +
        #1054#1050'", '#1072' '#1074#1077#1088#1085#1080#1090#1077#1089#1100' '#1082' '#1075#1083#1072#1074#1085#1086#1084#1091' '#1086#1082#1085#1091', '#1076#1083#1103' '#1087#1086#1080#1089#1082#1072', '#1087#1088#1086#1089#1084#1086#1090#1088#1072' '#1080' '#1089#1086#1093#1088#1072#1085 +
        #1077#1085#1080#1103' '#1074' '#1074#1080#1076#1077' '#1086#1090#1095#1077#1090#1072' '#1089#1090#1072#1088#1099#1093' '#1088#1072#1079#1073#1080#1074#1086#1082' '#1087#1086' '#1076#1072#1085#1085#1086#1081' '#1090#1077#1084#1077'. '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object cmbxTheme: TComboBox
      Left = 8
      Top = 48
      Width = 681
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object dtedtSignedDate: TDateEdit
      Left = 8
      Top = 104
      Width = 161
      Height = 21
      NumGlyphs = 2
      TabOrder = 1
    end
    object cmbxEmployee: TComboBox
      Left = 192
      Top = 104
      Width = 497
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
    end
  end
end
