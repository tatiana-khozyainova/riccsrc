object frmVerifyStratons: TfrmVerifyStratons
  Left = 343
  Top = 226
  Width = 603
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
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 238
    Width = 587
    Height = 46
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      587
      46)
    object sbtnSynonyms: TSpeedButton
      Left = 366
      Top = 24
      Width = 110
      Height = 21
      AllowAllUp = True
      GroupIndex = 2
      Caption = #1057#1080#1085#1086#1085#1080#1084#1099
      Flat = True
      OnClick = sbtnSynonymsClick
    end
    object sbtnReload: TSpeedButton
      Left = 366
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
      Left = 514
      Top = 19
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object rgrpSearch: TRadioGroup
      Left = 2
      Top = 1
      Width = 239
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
  object gbxSynonyms: TGroupBox
    Left = 0
    Top = 284
    Width = 587
    Height = 183
    Align = alBottom
    Caption = #1057#1080#1085#1086#1085#1080#1084#1099
    TabOrder = 1
    Visible = False
    object lbxSynonyms: TListBox
      Left = 2
      Top = 15
      Width = 383
      Height = 166
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnDblClick = lbxSynonymsClick
    end
    object gbxService: TGroupBox
      Left = 385
      Top = 15
      Width = 200
      Height = 166
      Align = alRight
      Caption = #1056#1077#1075#1080#1086#1085#1099
      TabOrder = 1
      object chlbxRegions: TCheckListBox
        Left = 2
        Top = 15
        Width = 196
        Height = 52
        OnClickCheck = chlbxRegionsClickCheck
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
      end
      object pnlPetrol: TPanel
        Left = 2
        Top = 67
        Width = 196
        Height = 97
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          196
          97)
        object Label2: TLabel
          Left = 3
          Top = 56
          Width = 61
          Height = 13
          Caption = #1053#1043#1056', '#1053#1043#1054' ...'
        end
        object spdbtnDeselectAll: TSpeedButton
          Left = 1
          Top = 4
          Width = 196
          Height = 22
          Anchors = [akLeft, akTop, akRight]
          Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1074#1099#1073#1086#1088
          Glyph.Data = {
            C2010000424DC20100000000000036000000280000000B0000000B0000000100
            1800000000008C010000C40E0000C40E00000000000000000000808080808080
            8080808080808080808080808080808080808080808080808080800000008080
            80FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80808000
            0000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            808080000000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF808080000000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFF808080000000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF808080000000808080FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF808080000000808080FFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF808080000000808080FFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080800000008080
            80FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80808000
            0000808080808080808080808080808080808080808080808080808080808080
            808080000000}
          Margin = 3
          Spacing = 7
          OnClick = spdbtnDeselectAllClick
        end
        object sbtnSelectAll: TSpeedButton
          Left = 1
          Top = 25
          Width = 196
          Height = 22
          Anchors = [akLeft, akTop, akRight]
          Caption = #1042#1099#1073#1088#1072#1090#1100' '#1074#1089#1077
          Glyph.Data = {
            C2010000424DC20100000000000036000000280000000B0000000B0000000100
            1800000000008C010000C40E0000C40E00000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000
            0000000000FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            000000000000000000FFFFFFFFFFFF000000000000000000FFFFFFFFFFFFFFFF
            FFFFFFFF000000000000000000FFFFFF000000000000000000000000000000FF
            FFFFFFFFFFFFFFFF000000000000000000FFFFFF000000000000FFFFFF000000
            000000000000FFFFFFFFFFFF000000000000000000FFFFFF000000FFFFFFFFFF
            FFFFFFFF000000000000000000FFFFFF000000000000000000FFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFF000000000000000000FFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFF0000000000000000
            00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000}
          Margin = 3
          Spacing = 7
          OnClick = spdbtnDeselectAllClick
        end
        object cmbxPetrolRegion: TComboBox
          Left = 1
          Top = 72
          Width = 194
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 0
          OnChange = cmbxPetrolRegionChange
          OnKeyUp = cmbxPetrolRegionKeyUp
        end
      end
    end
  end
  object pnlCommon: TPanel
    Left = 0
    Top = 0
    Width = 587
    Height = 238
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object pnlAll: TPanel
      Left = 0
      Top = 0
      Width = 587
      Height = 238
      Align = alClient
      BevelInner = bvSpace
      BevelOuter = bvLowered
      TabOrder = 0
      object pnlStratons: TPanel
        Left = 2
        Top = 2
        Width = 583
        Height = 84
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          583
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
          Width = 588
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          ReadOnly = True
          TabOrder = 0
        end
        object rgrpSplit: TRadioGroup
          Left = 0
          Top = 49
          Width = 583
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
        Width = 583
        Height = 150
        OnClickCheck = chlbxAllStratonsClickCheck
        Align = alClient
        ItemHeight = 13
        TabOrder = 1
      end
    end
  end
end
