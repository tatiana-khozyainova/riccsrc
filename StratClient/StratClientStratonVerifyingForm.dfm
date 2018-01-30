object frmVerifyStratons: TfrmVerifyStratons
  Left = 343
  Top = 226
  Width = 735
  Height = 506
  BorderIcons = [biSystemMenu]
  Caption = #1053#1072#1081#1076#1077#1085#1085#1099#1077' '#1089#1090#1088#1072#1090#1086#1085#1099
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 422
    Width = 719
    Height = 46
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      719
      46)
    object sbtnSynonyms: TSpeedButton
      Left = 374
      Top = 24
      Width = 110
      Height = 21
      AllowAllUp = True
      GroupIndex = 2
      Caption = #1057#1080#1085#1086#1085#1080#1084#1099
      Flat = True
    end
    object sbtnReload: TSpeedButton
      Left = 374
      Top = 2
      Width = 110
      Height = 21
      AllowAllUp = True
      GroupIndex = 1
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1089#1090#1088#1072#1090#1086#1085#1099
      Flat = True
      OnClick = sbtnReloadClick
    end
    object btnOK: TButton
      Left = 526
      Top = 19
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
    object rgrpSearch: TRadioGroup
      Left = 2
      Top = 1
      Width = 371
      Height = 43
      Anchors = [akLeft, akTop, akRight]
      Caption = #1048#1089#1082#1072#1090#1100' '#1087#1086
      Columns = 3
      ItemIndex = 0
      Items.Strings = (
        #1080#1085#1076#1077#1082#1089#1091
        #1085#1072#1079#1074#1072#1085#1080#1102
        #1089#1080#1085#1086#1085#1080#1084#1091)
      TabOrder = 1
      OnClick = rgrpSearchClick
    end
    object gbxSearch: TGroupBox
      Left = 240
      Top = 1
      Width = 126
      Height = 43
      Caption = #1057#1090#1088#1086#1082#1072' '#1087#1086#1080#1089#1082#1072
      TabOrder = 2
      DesignSize = (
        126
        43)
      object edtSearch: TEdit
        Left = 3
        Top = 14
        Width = 118
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnKeyPress = chlbxAllStratonsKeyPress
      end
    end
  end
  object pnlCommon: TPanel
    Left = 0
    Top = 0
    Width = 719
    Height = 422
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pnlAll: TPanel
      Left = 0
      Top = 0
      Width = 719
      Height = 422
      Align = alClient
      BevelInner = bvSpace
      BevelOuter = bvLowered
      TabOrder = 0
      object pnlStratons: TPanel
        Left = 2
        Top = 2
        Width = 715
        Height = 84
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          715
          84)
        object Label1: TLabel
          Left = 3
          Top = 5
          Width = 220
          Height = 13
          Caption = #1057#1087#1080#1089#1086#1082' '#1089#1090#1088#1072#1090#1080#1075#1088#1072#1092#1080#1095#1077#1089#1082#1080#1093' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081
        end
        object edtStratons: TEdit
          Left = 0
          Top = 22
          Width = 720
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          ReadOnly = True
          TabOrder = 0
        end
        object rgrpSplit: TRadioGroup
          Left = 0
          Top = 49
          Width = 715
          Height = 35
          Align = alBottom
          Caption = #1056#1072#1079#1076#1077#1083#1080#1090#1077#1083#1100
          Columns = 2
          ItemIndex = 0
          Items.Strings = (
            '+'
            '--')
          TabOrder = 1
          OnClick = rgrpSplitClick
        end
      end
      object chlbxAllStratons: TCheckListBox
        Left = 2
        Top = 86
        Width = 715
        Height = 334
        OnClickCheck = chlbxAllStratonsClickCheck
        Align = alClient
        ItemHeight = 13
        TabOrder = 1
      end
    end
  end
end
