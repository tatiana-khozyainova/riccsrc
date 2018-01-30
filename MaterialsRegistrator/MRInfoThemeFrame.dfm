inherited frmInfoTheme: TfrmInfoTheme
  Width = 556
  Height = 332
  inherited StatusBar: TStatusBar
    Top = 313
    Width = 556
  end
  object grp1: TGroupBox
    Left = 0
    Top = 0
    Width = 556
    Height = 313
    Align = alClient
    Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1090#1077#1084#1077
    TabOrder = 1
    object grp2: TGroupBox
      Left = 2
      Top = 56
      Width = 552
      Height = 92
      Align = alTop
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077
      TabOrder = 0
      object mmName: TMemo
        Left = 2
        Top = 15
        Width = 548
        Height = 75
        Align = alClient
        TabOrder = 0
      end
    end
    object grp3: TGroupBox
      Left = 2
      Top = 197
      Width = 552
      Height = 65
      Align = alTop
      Caption = #1055#1077#1088#1080#1086#1076' '#1072#1082#1090#1091#1072#1083#1100#1085#1086#1089#1090#1080
      TabOrder = 1
      object grp4: TGroupBox
        Left = 2
        Top = 15
        Width = 191
        Height = 48
        Align = alLeft
        Caption = #1053#1072#1095#1072#1083#1086
        TabOrder = 0
        DesignSize = (
          191
          48)
        object dtmPeriodBegin: TDateTimePicker
          Left = 8
          Top = 16
          Width = 176
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          Date = 38894.645242175920000000
          Time = 38894.645242175920000000
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
        end
      end
      object grp5: TGroupBox
        Left = 193
        Top = 15
        Width = 357
        Height = 48
        Align = alClient
        Caption = #1050#1086#1085#1077#1094
        TabOrder = 1
        DesignSize = (
          357
          48)
        object dtmPeriodFinish: TDateTimePicker
          Left = 8
          Top = 16
          Width = 341
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          Date = 38894.645452314820000000
          Time = 38894.645452314820000000
          TabOrder = 0
        end
      end
    end
    object pnl1: TPanel
      Left = 2
      Top = 15
      Width = 552
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object edtNumber: TLabeledEdit
        Left = 26
        Top = 10
        Width = 81
        Height = 21
        EditLabel.Width = 14
        EditLabel.Height = 13
        EditLabel.Caption = #8470' '
        LabelPosition = lpLeft
        TabOrder = 0
      end
      object edtFolder: TLabeledEdit
        Left = 258
        Top = 10
        Width = 287
        Height = 21
        EditLabel.Width = 130
        EditLabel.Height = 13
        EditLabel.Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1072#1087#1082#1080' '#1074' '#1072#1088#1093#1080#1074#1077
        LabelPosition = lpLeft
        TabOrder = 1
      end
    end
    object grp6: TGroupBox
      Left = 2
      Top = 148
      Width = 552
      Height = 49
      Align = alTop
      Caption = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' '#1080#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
      TabOrder = 3
      DesignSize = (
        552
        49)
      object btnSetAuthors: TButton
        Left = 484
        Top = 16
        Width = 27
        Height = 25
        Anchors = [akTop, akRight, akBottom]
        Caption = '...'
        TabOrder = 0
        OnClick = btnSetAuthorsClick
      end
      object edtAuthors: TEdit
        Left = 8
        Top = 18
        Width = 473
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
        Text = '<'#1085#1077' '#1091#1082#1072#1079#1072#1085'>'
      end
      object btnClear: TBitBtn
        Left = 516
        Top = 16
        Width = 27
        Height = 25
        Hint = #1059#1076#1072#1083#1080#1090#1100' '#1086#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1086#1075#1086' '#1080#1089#1087#1086#1083#1085#1080#1090#1077#1083#1103
        Anchors = [akTop, akRight]
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = btnClearClick
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777BFBFB7777777777777777BF7777777777777770007777777777770FBF077
          777777770F8FBF0777777770F8F78BF07777770F8F78BFB8077770F8F78BFB87
          7077000F78BFB877707777700BFB87770777777770B877784077777777077704
          4407777777700070444077777777777704407777777777777007}
      end
    end
  end
end
