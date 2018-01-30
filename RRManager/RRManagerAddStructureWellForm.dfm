object frmAddWell: TfrmAddWell
  Left = 192
  Top = 104
  Width = 514
  Height = 483
  Caption = #1057#1074#1103#1079#1072#1090#1100' '#1089#1082#1074#1072#1078#1080#1085#1091' '#1089#1086' '#1089#1090#1088#1091#1082#1090#1091#1088#1086#1081
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
  object gbxArea: TGroupBox
    Left = 0
    Top = 0
    Width = 506
    Height = 105
    Align = alTop
    Caption = #1055#1083#1086#1097#1072#1076#1100
    TabOrder = 0
    DesignSize = (
      506
      105)
    object Label1: TLabel
      Left = 13
      Top = 35
      Width = 47
      Height = 13
      Caption = #1055#1083#1086#1097#1072#1076#1100
    end
    object cmbxAreas: TComboBox
      Left = 10
      Top = 60
      Width = 490
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 0
      OnChange = cmbxAreasChange
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 415
    Width = 506
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      506
      41)
    object btnOK: TButton
      Left = 350
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 430
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object gbxWells: TGroupBox
    Left = 0
    Top = 105
    Width = 506
    Height = 310
    Align = alClient
    Caption = #1057#1082#1074#1072#1078#1080#1085#1099
    TabOrder = 2
    object lwWells: TListView
      Left = 2
      Top = 15
      Width = 502
      Height = 293
      Align = alClient
      Columns = <>
      HideSelection = False
      MultiSelect = True
      ReadOnly = True
      TabOrder = 0
      ViewStyle = vsList
      OnSelectItem = lwWellsSelectItem
    end
  end
end
