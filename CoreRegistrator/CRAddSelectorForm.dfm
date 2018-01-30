object frmAddSelector: TfrmAddSelector
  Left = 420
  Top = 253
  Width = 578
  Height = 170
  BorderIcons = [biSystemMenu]
  Caption = #1063#1090#1086' '#1076#1086#1073#1072#1074#1080#1090#1100
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object rgrpSelector: TRadioGroup
    Left = 0
    Top = 0
    Width = 570
    Height = 94
    Align = alClient
    Caption = #1063#1090#1086' '#1076#1086#1073#1072#1074#1080#1090#1100
    ItemIndex = 0
    Items.Strings = (
      #1082#1086#1083#1083#1077#1082#1094#1080#1102
      #1101#1082#1089#1087#1086#1085#1072#1090
      #1085#1080#1095#1077#1075#1086' '#1085#1077' '#1076#1086#1073#1072#1074#1083#1103#1090#1100)
    TabOrder = 0
    OnClick = rgrpSelectorClick
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 94
    Width = 570
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      570
      41)
    object btnClose: TButton
      Left = 426
      Top = 8
      Width = 131
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1080' '#1079#1072#1082#1088#1099#1090#1100
      ModalResult = 1
      TabOrder = 0
    end
    object chbxSaveSelection: TCheckBox
      Left = 8
      Top = 16
      Width = 145
      Height = 17
      Caption = #1079#1072#1087#1086#1084#1085#1080#1090#1100' '#1074#1099#1073#1086#1088
      TabOrder = 1
      OnClick = chbxSaveSelectionClick
    end
  end
end
