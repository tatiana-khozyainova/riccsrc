object frmComplexList: TfrmComplexList
  Left = 0
  Top = 0
  Width = 557
  Height = 419
  TabOrder = 0
  object gbxAll: TGroupBox
    Left = 0
    Top = 0
    Width = 557
    Height = 419
    Align = alClient
    Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    TabOrder = 0
    DesignSize = (
      557
      419)
    object lblSearch: TLabel
      Left = 118
      Top = 8
      Width = 79
      Height = 13
      Caption = #1041#1099#1089#1090#1088#1099#1081' '#1087#1086#1080#1089#1082
    end
    object btnRefresh: TSpeedButton
      Left = 447
      Top = 24
      Width = 100
      Height = 25
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      Flat = True
      OnClick = btnRefreshClick
    end
    object btnFirst: TSpeedButton
      Left = 527
      Top = 60
      Width = 25
      Height = 50
      Hint = #1053#1072' '#1087#1077#1088#1074#1091#1102' '#1089#1090#1088#1086#1082#1091
      Anchors = [akTop, akRight]
      Flat = True
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000C40E0000C40E00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777777777777777777777777777777700077777000777777060070060
        7777777706606607777777777066607777777777770607777777770007707700
        0777777060070060777777770660660777777777706660777777777777060777
        7777777777707777777777777777777777777777777777777777}
      Layout = blGlyphTop
      OnClick = btnFirstClick
    end
    object btnInsert: TSpeedButton
      Left = 527
      Top = 156
      Width = 25
      Height = 25
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1090#1088#1086#1082#1091
      Anchors = [akRight]
      Caption = '+'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btnInsertClick
    end
    object btnEdit: TSpeedButton
      Left = 527
      Top = 195
      Width = 25
      Height = 25
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1090#1088#1086#1082#1091
      Anchors = [akRight]
      Caption = '<>'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btnEditClick
    end
    object btnDelete: TSpeedButton
      Left = 527
      Top = 229
      Width = 25
      Height = 25
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1090#1088#1086#1082#1091
      Anchors = [akRight]
      Caption = '-'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btnDeleteClick
    end
    object btnLast: TSpeedButton
      Left = 527
      Top = 320
      Width = 25
      Height = 49
      Hint = #1053#1072' '#1087#1086#1089#1083#1077#1076#1085#1102#1102' '#1089#1090#1088#1086#1082#1091
      Anchors = [akRight, akBottom]
      Flat = True
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000C40E0000C40E00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777777777777777777770777777777777770607777777777770666077
        7777777706606607777777706007006077777700077077000777777777060777
        7777777770666077777777770660660777777770600700607777770007777700
        0777777777777777777777777777777777777777777777777777}
      Layout = blGlyphTop
      OnClick = btnLastClick
    end
    object Bevel1: TBevel
      Left = 3
      Top = 55
      Width = 549
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object Bevel2: TBevel
      Left = 3
      Top = 378
      Width = 548
      Height = 19
      Anchors = [akLeft, akRight, akBottom]
      Shape = bsTopLine
    end
    object btnNext: TSpeedButton
      Left = 339
      Top = 25
      Width = 102
      Height = 24
      Caption = #1044#1072#1083#1077#1077
      Flat = True
      OnClick = btnNextClick
    end
    object chbxShowIDs: TCheckBox
      Left = 8
      Top = 30
      Width = 97
      Height = 17
      Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' ID '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      TabOrder = 0
      OnClick = chbxShowIDsClick
    end
    object edtSearch: TEdit
      Left = 117
      Top = 27
      Width = 220
      Height = 21
      Hint = #1042#1074#1077#1076#1080#1090#1077' '#1090#1077#1082#1089#1090' '#1076#1083#1103' '#1073#1099#1089#1090#1088#1086#1075#1086' '#1087#1086#1080#1089#1082#1072
      TabOrder = 1
      OnChange = edtSearchChange
    end
    object btnOK: TButton
      Left = 397
      Top = 385
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1054#1050
      Default = True
      ModalResult = 1
      TabOrder = 2
    end
    object btnCancel: TButton
      Left = 477
      Top = 385
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 3
    end
    object lwCurrentDict: TListView
      Left = 3
      Top = 61
      Width = 513
      Height = 311
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = <>
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 4
      ViewStyle = vsReport
      OnDblClick = strgrCurrentDictDblClick
      OnKeyUp = strgrCurrentDictKeyUp
      OnMouseDown = lwCurrentDictMouseDown
    end
  end
end