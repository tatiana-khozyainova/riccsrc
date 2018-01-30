object frmThemes: TfrmThemes
  Left = 192
  Top = 125
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1042#1099#1073#1088#1072#1090#1100' '#1090#1077#1084#1099
  ClientHeight = 412
  ClientWidth = 667
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
    Top = 352
    Width = 667
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object btnOk: TButton
      Left = 504
      Top = 16
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 584
      Top = 16
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
    end
    object btnReloadThemes: TButton
      Left = 8
      Top = 16
      Width = 161
      Height = 25
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1090#1077#1084
      TabOrder = 2
      OnClick = btnReloadThemesClick
    end
  end
  object gbxTheme: TGroupBox
    Left = 0
    Top = 0
    Width = 667
    Height = 352
    Align = alClient
    Caption = #1058#1077#1084#1099' '#1053#1048#1056
    TabOrder = 1
    object lwTheme: TListView
      Left = 2
      Top = 44
      Width = 663
      Height = 306
      Align = alClient
      Checkboxes = True
      Columns = <
        item
          Caption = #1053#1086#1084#1077#1088
          Width = -2
          WidthType = (
            -2)
        end
        item
          Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Width = -2
          WidthType = (
            -2)
        end>
      HideSelection = False
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
    end
    object tlbrTools: TToolBar
      Left = 2
      Top = 15
      Width = 663
      Height = 29
      ButtonHeight = 21
      ButtonWidth = 116
      Caption = 'tlbrTools'
      Flat = True
      ShowCaptions = True
      TabOrder = 1
      object btnSelectAll: TToolButton
        Left = 0
        Top = 0
        AllowAllUp = True
        Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1105
        Grouped = True
        ImageIndex = 0
        Style = tbsCheck
        OnClick = btnSelectAllClick
      end
      object btn1: TToolButton
        Left = 116
        Top = 0
        Width = 19
        Caption = 'btn1'
        ImageIndex = 2
        Style = tbsSeparator
      end
      object edtSearch: TEdit
        Left = 135
        Top = 0
        Width = 243
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Text = #1074#1074#1077#1076#1080#1090#1077' '#1085#1086#1084#1077#1088' '#1080#1083#1080' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1090#1077#1084#1099
        OnChange = edtSearchChange
        OnEnter = edtSearchEnter
        OnExit = edtSearchExit
      end
      object btnCheckSelected: TToolButton
        Left = 378
        Top = 0
        Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1085#1072#1081#1076#1077#1085#1085#1099#1077
        ImageIndex = 1
        OnClick = btnCheckSelectedClick
      end
    end
  end
end
