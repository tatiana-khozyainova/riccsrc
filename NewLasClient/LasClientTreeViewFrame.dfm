object frmWellsTree: TfrmWellsTree
  Left = 0
  Top = 0
  Width = 773
  Height = 332
  TabOrder = 0
  object gbxAll: TGroupBox
    Left = 0
    Top = 140
    Width = 773
    Height = 192
    Align = alClient
    Caption = #1042#1089#1077' '#1089#1082#1074#1072#1078#1080#1085#1099
    TabOrder = 0
    object trwWell: TVirtualStringTree
      Left = 2
      Top = 15
      Width = 769
      Height = 175
      Align = alClient
      Header.AutoSizeIndex = 2
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'MS Sans Serif'
      Header.Font.Style = []
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs]
      Images = il1
      TabOrder = 0
      OnExpanded = trwWellExpanded
      OnGetText = trwWellGetText
      OnGetImageIndex = trwWellGetImageIndex
      Columns = <
        item
          MinWidth = 300
          Position = 0
          Width = 300
        end
        item
          MinWidth = 150
          Position = 1
          Width = 150
        end
        item
          Position = 2
          Width = 315
        end>
    end
  end
  object gbxFilter: TGroupBox
    Left = 0
    Top = 0
    Width = 773
    Height = 140
    Align = alTop
    Caption = #1060#1080#1083#1100#1090#1088
    TabOrder = 1
    object pnl1: TPanel
      Left = 2
      Top = 15
      Width = 769
      Height = 80
      Align = alTop
      Caption = '0'#1084' - 0'#1084
      TabOrder = 0
      object trckFrom: TTrackBar
        Left = 1
        Top = 1
        Width = 767
        Height = 30
        Align = alTop
        Max = 8000
        TabOrder = 0
        OnChange = actGetPositionsExecute
      end
      object trckTo: TTrackBar
        Left = 1
        Top = 49
        Width = 767
        Height = 30
        Align = alBottom
        Max = 8000
        TabOrder = 1
        OnChange = actGetPositionsExecute
      end
    end
    object pnl2: TPanel
      Left = 2
      Top = 95
      Width = 769
      Height = 43
      Align = alClient
      TabOrder = 1
      object lbl1: TLabel
        Left = 8
        Top = 12
        Width = 53
        Height = 13
        Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080
      end
      object btnFilter: TButton
        Left = 622
        Top = 8
        Width = 75
        Height = 25
        Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
        TabOrder = 0
        OnClick = btnFilterClick
      end
      object cmbx1: TComboBox
        Left = 72
        Top = 10
        Width = 425
        Height = 22
        Style = csOwnerDrawFixed
        ItemHeight = 16
        TabOrder = 1
        OnDrawItem = cmbx1DrawItem
        OnSelect = cmbx1Select
      end
      object rg1: TRadioGroup
        Left = 504
        Top = 3
        Width = 105
        Height = 33
        Caption = #1059#1089#1083#1086#1074#1080#1077
        TabOrder = 2
      end
      object rbAnd: TRadioButton
        Left = 512
        Top = 16
        Width = 33
        Height = 17
        Caption = #1048
        TabOrder = 3
      end
      object rbOr: TRadioButton
        Left = 552
        Top = 16
        Width = 49
        Height = 17
        Caption = #1048#1051#1048
        Checked = True
        TabOrder = 4
        TabStop = True
      end
    end
  end
  object il1: TImageList
    Left = 120
    Top = 280
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFDDDCDBFF5C5B
      5BFFAEAEADFFFEFEFEFFFDFDFDFFFCFCFCFFFDFDFDFFFEFEFDFFE0DFDFFF4B49
      49FFC3C2C2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000A2A2A2FFA2A2A2FFA2A2
      A2FFA2A2A2FFA2A2A2FFA2A2A2FFA2A2A2FFA2A2A2FFA2A2A2FFA2A2A2FFA2A2
      A2FFA2A2A2FFA2A2A2FFD9D9D9FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFF1F0F0FF3A38
      38FF020202FF6F6F6EFF6C6C6BFF6F6E6EFF6D6C6CFF757574FF242424FF0000
      00FFDADAD9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8484
      84FF848484FF848484FF848484FF848484FF848484FF848484FF848484FF8484
      84FF999999FFFFFFFFFFFFFFFFFFFFFFFFFF00000000515151FF515151FF5151
      51FF515151FF515151FF515151FF515151FF515151FF515151FF515151FF5151
      51FF515151FF515151FF7C7C7CFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFAEAC
      ABFF000000FFE9E8E7FFFEFEFEFFFDFDFDFFFDFDFDFFFCFCFCFF0C0C0CFF4948
      48FFFCFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080
      80FFB5B5B5FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4B4FFB4B4B4FFB1B1
      B1FF929292FFFFFFFFFFFFFFFFFFFFFFFFFF00000000515151FF515151FF5151
      51FF515151FF515151FF515151FF515151FF515151FF515151FF515151FF5151
      51FF515151FF515151FF7C7C7CFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFEBEA
      E9FF000000FFAAAAA9FFFDFDFDFFFBFBFBFFFCFCFCFFE7E6E6FF000000FFB1B1
      AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080
      80FF808080FF808080FF808080FF808080FF808080FF808080FF808080FF8080
      80FF959595FFFFFFFFFFFFFFFFFFFFFFFFFF00000000515151FF515151FF5151
      51FF515151FF515151FF515151FF515151FF515151FF515151FF515151FF5151
      51FF515151FF515151FF7C7C7CFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFDFD
      FDFF181717FF080808FF676665FF5F5F5EFF696968FF272727FF000000FFECEB
      EBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080
      80FF989898FF979797FF979797FF979797FF979797FF979797FF979797FF9696
      96FF949494FFFFFFFFFFFFFFFFFFFFFFFFFF00000000515151FF000000006A6A
      6AFF686868FF686868FF686868FF686868FF686868FF686868FF686868FF6868
      68FFFAFAFAFF515151FF7C7C7CFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF807F7FFF000000FFF7F6F6FFFEFEFEFFFFFFFFFF3E3D3DFF151515FFFEFE
      FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080
      80FF898989FF898989FF898989FF898989FF898989FF898989FF898989FF8989
      89FF949494FFFFFFFFFFFFFFFFFFFFFFFFFF00000000515151FF00000000ADAD
      ADFF515151FF515151FF515151FF515151FF515151FF515151FF515151FF5151
      51FF00000000515151FF7C7C7CFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFD5D5D4FF000000FFC8C8C7FFFDFDFDFFF3F2F2FF000000FF868585FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080
      80FF818181FF808080FF808080FF808080FF808080FF808080FF808080FF8181
      81FF959595FFFFFFFFFFFFFFFFFFFFFFFFFF00000000515151FF000000000000
      0000797979FF515151FF515151FF515151FF515151FF515151FF515151FFA7A7
      A7FF00000000515151FF7C7C7CFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFF8F8F8FF010101FF161614FF6C6C6BFF363535FF000000FFD8D8D7FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080
      80FFAAAAAAFFA9A9A9FFA9A9A9FFA9A9A9FFA9A9A9FFA9A9A9FFA9A9A9FFA7A7
      A7FF939393FFFFFFFFFFFFFFFFFFFFFFFFFF00000000515151FF000000000000
      0000000000000000000000000000848484FF515151FF515151FF515151FF0000
      000000000000515151FF7C7C7CFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF5B5B5BFF090909FFFEFEFEFF6F6F6FFF000000FFFCFCFCFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080
      80FF808080FF808080FF808080FF808080FF808080FFA2A2A2FFA5A5A5FFA5A5
      A5FFB2B2B2FFFFFFFFFFFFFFFFFFFFFFFFFF00000000515151FF000000000000
      000000000000000000000000000000000000515151FF515151FFD1D1D1FF0000
      000000000000515151FF7C7C7CFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFDFD
      FDFFC5C4C4FF565555FF000000FFA3A3A2FF111111FF191917FFB9B8B7FFF5F4
      F4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080
      80FFCDCDCDFFCBCBCBFFCBCBCBFFAAAAAAFFCDCDCDFF868686FF808080FF8080
      80FFEAEAEAFFFFFFFFFFFFFFFFFFFFFFFFFF00000000515151FF000000005151
      51FF515151FFA6A6A6FF0000000000000000D9D9D9FF575757FF000000000000
      000000000000515151FF7C7C7CFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFE9E9
      E8FF000000FF000000FF000000FF000000FF000000FF000000FF000000FFA2A1
      A1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080
      80FF808080FF808080FF808080FF808080FFDCDCDCFF808080FF808080FFEAEA
      EAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000515151FF000000005151
      51FF515151FF515151FF00000000000000000000000000000000000000000000
      000000000000515151FF7C7C7CFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFEFE
      FEFFE6E5E5FFE9E9E8FFD6D5D5FFC6C5C5FFDBDAD9FFEAEAE9FFEAE9E9FFFCFC
      FCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080
      80FFDDDDDDFFDBDBDBFFDBDBDBFFB5B5B5FFDCDCDCFF808080FFE9E9E9FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000515151FF000000007979
      79FF515151FFDDDDDDFF00000000000000000000000000000000000000000000
      000000000000515151FF7C7C7CFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFD2D2D2FF252525FFDCDBDAFF090909FF999897FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080
      80FF808080FF808080FF808080FF808080FFD8D8D8FFE3E3E3FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000515151FFDCDCDCFFDCDC
      DCFFDCDCDCFFDCDCDCFFDCDCDCFFDCDCDCFFDCDCDCFFDCDCDCFFDCDCDCFFDCDC
      DCFFDCDCDCFF515151FF7C7C7CFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF5F5F4FFDFDEDEFFFEFEFEFF818080FFAAA9A9FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000515151FF515151FF5151
      51FF515151FF515151FF515151FF515151FF515151FF515151FF515151FF5151
      51FF515151FF515151FF808080FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000FFFF00000000000080010000
      00000000800100000000000080010000000000008001000000000000A0010000
      00000000A009000000000000B009000000000000BE19000000000000BF190000
      00000000A339000000000000A3F9000000000000A3F900000000000080010000
      000000008001000000000000FFFF000000000000000000000000000000000000
      000000000000}
  end
  object actlst1: TActionList
    Left = 152
    Top = 280
    object actGetPositions: TAction
      Caption = 'actGetPositions'
      OnExecute = actGetPositionsExecute
    end
  end
end