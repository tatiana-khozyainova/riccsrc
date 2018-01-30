object ExportGis: TExportGis
  Left = 331
  Top = 167
  Width = 650
  Height = 600
  Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1043#1048#1057
  Color = clBtnFace
  Constraints.MaxHeight = 650
  Constraints.MinWidth = 650
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mm1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object spl1: TSplitter
    Left = 273
    Top = 81
    Width = 0
    Height = 473
  end
  object pnlWells: TPanel
    Left = 0
    Top = 81
    Width = 273
    Height = 473
    Align = alLeft
    Caption = 'pnlWells'
    TabOrder = 0
    object gbxWells: TGroupBox
      Left = 1
      Top = 1
      Width = 271
      Height = 471
      Align = alClient
      Caption = #1042#1099#1073#1088#1072#1085#1085#1099#1077' '#1089#1082#1074#1072#1078#1080#1085#1099
      TabOrder = 0
      object lstWells: TListBox
        Left = 2
        Top = 15
        Width = 267
        Height = 437
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
      end
      object pbExport: TProgressBar
        Left = 2
        Top = 452
        Width = 267
        Height = 17
        Align = alBottom
        TabOrder = 1
      end
    end
  end
  object pnl1: TPanel
    Left = 273
    Top = 81
    Width = 369
    Height = 473
    Align = alClient
    Caption = 'pnl1'
    TabOrder = 1
    object spl2: TSplitter
      Left = 365
      Top = 1
      Height = 471
      Align = alRight
    end
    object pnlAddedWells: TPanel
      Left = 1
      Top = 1
      Width = 184
      Height = 471
      Align = alClient
      Caption = 'pnlAddedWells'
      TabOrder = 0
      object gbxAddedWells: TGroupBox
        Left = 1
        Top = 1
        Width = 182
        Height = 469
        Align = alClient
        Caption = #1057#1082#1074#1072#1078#1080#1085#1099
        TabOrder = 0
        object lstAddedWells: TListBox
          Left = 2
          Top = 15
          Width = 178
          Height = 452
          Align = alClient
          ItemHeight = 13
          TabOrder = 0
          OnDblClick = actWellsForExportExecute
        end
      end
    end
    object pnlArea: TPanel
      Left = 185
      Top = 1
      Width = 180
      Height = 471
      Align = alRight
      Caption = 'pnlArea'
      TabOrder = 1
      object gbxAreas: TGroupBox
        Left = 1
        Top = 1
        Width = 178
        Height = 469
        Align = alClient
        Caption = #1055#1083#1086#1097#1072#1076#1080
        TabOrder = 0
        object chklstAreas: TCheckListBox
          Left = 2
          Top = 15
          Width = 174
          Height = 452
          OnClickCheck = actMakeWellsExecute
          Align = alClient
          ItemHeight = 13
          TabOrder = 0
        end
      end
    end
  end
  object pgc2: TPageControl
    Left = 0
    Top = 0
    Width = 642
    Height = 81
    ActivePage = ts2
    Align = alTop
    TabOrder = 2
    object ts1: TTabSheet
      Caption = #1043#1083#1072#1074#1085#1072#1103
      object btnDel: TSpeedButton
        Left = 0
        Top = 2
        Width = 85
        Height = 50
        Action = actDelSelectedWells
        Caption = #1059#1076#1072#1083#1080#1090#1100
        Glyph.Data = {
          36100000424D3610000000000000360000002800000020000000200000000100
          2000000000000010000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000010000000155555503555555030000
          0001000000010000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000024B3C3C114741412B594B394754483A5B54483A5B584A
          3C484741412B4B4B3C1100000002000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00025454540957473B52654E359C895D29C4A2681FE0B06E1BEAB06E1CEAA267
          21E0895D28C5654E359C5A473B52545454090000000200000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000555555064D45
          403B6B523395AB6C1CECD97F0CFCF48A04FEFE9000FFFE9000FFFE9000FFFE8F
          00FFF48A04FEDA800CFCAB6C1CEC6D5233954D49403B55555506000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000002A2A2A0647434340875E
          29B3C37714F0F88D02FFFD9001FFFF9200FFFF9200FFFF9200FFFF9200FFFF91
          00FFFF9100FFFD8F01FFF88C02FFC37514F0875E29B34B434340552A2A060000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000252493C3B885E29B2D87E
          0DFCFD8F00FFFD9201FFF59005FFFA9203FFFE9500FFFF9500FFFF9500FFFE94
          00FFFA9202FFF58F05FFFD9101FFFD8E00FFD87D0DFC875E29B352493C3B0000
          0002000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000383838096C543394C37514F0FD8F
          01FFFE9301FFE68C10FFC28E48FFC98D36FFF89503FFFE9800FFFE9800FFF895
          03FFC98C36FFC28E48FFE68B10FFFE9101FFFD8E01FFC27514F16B5233953838
          3809000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000007F7F7F02574A3B52AB6E1CECF98D02FEFD92
          00FFE68C0FFFC9A069FFDAD6D0FFCFC5B6FFCC9540FFF49708FFF49708FFCC95
          40FFCFC5B6FFDAD6D1FFC9A06AFFE68B0FFFFD9100FFF98C02FFAB6C1CEC5A4A
          3B527F7F7F020000000000000000000000000000000000000000000000000000
          00000000000000000000000000004B4B4B11654E359CDA800CFCFD9101FFF591
          05FFC18E46FFDAD6D0FFFCFCFCFFFCFCFBFFCFC5B5FFC79749FFC79749FFCFC5
          B5FFFCFCFBFFFCFCFCFFDAD6D1FFC18D46FFF59005FFFD8F01FFDA800DFC654E
          359C4B4B4B110000000000000000000000000000000000000000000000000000
          00000000000000000000000000014747412B895D28C4F48B04FFFF9300FFFB94
          02FFCB8C31FFCAC0B0FFFCFCFBFFFFFFFFFFFAF9F8FFD9D3C8FFD9D3C8FFFAF9
          F8FFFFFFFFFFFCFCFBFFCAC0B0FFCB8B31FFFB9202FFFF9100FFF48A04FF895D
          28C54747412B0000000100000000000000000000000000000000000000000000
          0000000000000000000000000001594B3947A26821E0FE9100FFFF9300FFFF96
          00FFFE9901FFCD9338FFCAC0AFFFF9F8F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFF9F8F8FFCAC0AFFFCD9238FFFE9701FFFF9400FFFF9100FFFE8F00FFA268
          21E0594B3D470000000100000000000000000000000000000000000000000000
          000000000000000000005555550354493E5AB06E1BEAFE9100FFFF9400FFFF97
          00FFFF9A00FFF99B05FFC89541FFD6CFC3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFD6CFC3FFC89441FFF99905FFFF9900FFFF9500FFFF9300FFFE8F00FFB06C
          1BEA5449385A5555550300000000000000000000000000000000000000000000
          000000000000000000005555550354493B5AB06E1BEAFE9100FFFF9400FFFF97
          00FFFE9900FFF49907FFC99948FFD9D2C6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFD9D1C6FFC99948FFF49707FFFE9800FFFF9500FFFF9300FFFE9000FFB06E
          1BEA54493B5A5555550300000000000000000000000000000000000000000000
          0000000000000000000000000001594B3D47A16921E0FE9200FFFF9400FFFE96
          00FFF89703FFCC9640FFCFC5B5FFFAF9F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFAF9F8FFCFC5B5FFCC9540FFF89603FFFE9500FFFF9200FFFE9000FFA168
          21E0594B39470000000100000000000000000000000000000000000000000000
          00000000000000000000000000014747412B895E28C4F48C04FFFF9400FFFA94
          02FFC98E36FFCEC5B6FFFCFCFBFFFFFFFFFFF9F8F8FFD5CEC0FFD5CEC0FFF9F8
          F8FFFFFFFFFFFCFCFBFFCEC5B6FFC98D36FFFA9302FFFF9200FFF48A04FF895D
          28C44747412B0000000100000000000000000000000000000000000000000000
          00000000000000000000000000004B4B4B11654E359CDB810CFCFD9201FFF592
          05FFC28F47FFDAD6D0FFFCFCFCFFFCFBFBFFCAC0AFFFCB963FFFCB963FFFCAC0
          AFFFFCFBFBFFFCFCFCFFDAD6D0FFC28E47FFF59105FFFD9001FFDA800DFC644E
          369B4B4B3C110000000000000000000000000000000000000000000000000000
          00000000000000000000000000007F7F7F02584B3B51AA6C1CECF88E02FFFD93
          00FFE68D0FFFC9A169FFDAD5D0FFCBC0B0FFCD9338FFFA9C05FFFA9C05FFCD93
          38FFCBC0B0FFDAD5D0FFC9A069FFE68C0FFFFD9200FFF88D02FEAA6C1DEC584B
          3B517F7F7F020000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000383838096C503394C27715F1FD91
          01FFFE9401FFE68D10FFC18E46FFCB8C31FFFE9901FFFF9A00FFFF9A00FFFE99
          01FFCA8C31FFC18E46FFE68C10FFFE9301FFFD8F01FFC37514F06C5033943838
          3809000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000252493C3B885F29B2D87F
          0EFCFD9100FFFD9301FFF59105FFFC9502FFFF9600FFFF9700FFFF9700FFFF96
          00FFFC9402FFF59105FFFD9201FFFD8F00FFD87E0EFC885D29B252493C3B0000
          0002000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000002A2A2A0647434340875E
          29B3C37714F0F88E02FFFD9201FFFF9300FFFF9400FFFF9400FFFF9400FFFF93
          00FFFF9300FFFD9101FFF88D02FFC37714F0885D29B2474343402A2A2A060000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000555555064D45
          3C3B6B523395AA6C1DECD9800DFCF48C04FEFE9100FFFE9100FFFE9100FFFE91
          00FFF48B04FED9800DFCAA6C1DEC6C5233944D45403B55555506000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00025454540958483B51634E359C895D28C4A16821E0AF6E1CEAAF6E1CEAA168
          21E0885D28C4644D369B58483B51545454090000000200000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000024B3C3C114842422A594B394752463B5A52463E5A594B
          39474842422A4B3C3C1100000002000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000001000000017F7F7F02555555030000
          0001000000010000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        Layout = blGlyphTop
        Spacing = 1
      end
      object btnExport: TSpeedButton
        Left = 88
        Top = 2
        Width = 85
        Height = 50
        Action = actExport
        Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100
        Glyph.Data = {
          36100000424D3610000000000000360000002800000020000000200000000100
          2000000000000010000000000000000000000000000000000000FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF005555550640404018404040184040401840404018404040184040
          4018404040184040401840404018404040184040401840404018404040184040
          4018404040184040401840404018404040184040401840404018404040184040
          4018404040184040401855555506FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF0041414127424243EB424243FF424243FF424243FF424243FF424243FF4242
          43FF424243FF424243FF424243FF424243FF424243FF424243FF424243FF4242
          43FF424243FF424243FF424243FF424243FF424243FF424243FF424243FF4242
          43FF424243FF424243FF424243EB41414127FFFFFF00FFFFFF00FFFFFF00FFFF
          FF004141436E424243FF424243FF424243FF424243FF424243FF424243FF4242
          43FF424243FF424243FF424243FF424243FF424243FF424243FF424243FF4242
          43FF424243FF424243FF424243FF424243FF424243FF424243FF424243FF4242
          43FF424243FF424243FF424243FF4141436EFFFFFF00FFFFFF00FFFFFF00FFFF
          FF0042424270424243FF424243FF424243FF424243FF424243FF424243FF4242
          43FF424243FF424243FF424243FF424243FF424243FF424243FF424243FF4242
          43FF424243F24242447C4242447842424480424243F5424243FD4343438A4242
          447842424478424243E5424243FF42424270FFFFFF00FFFFFF00FFFFFF00FFFF
          FF004242426C424243FF424243FF424243FF424243FF424243FF424243FF4242
          43FF424243FF424243FF424243FF424243FF424243FF424243FF424243FF4242
          43FF424244DB444444444444444041414447424243E0424243F1414144524444
          444044444440434343C7424243FF4242426CFFFFFF00FFFFFF00FFFFFF00FFFF
          FF0046464621424243E0424243FF424243FF424243FF424243FF424243FF4242
          43FF424243FF424243FF424243FF424243FF424243FF424243FF424243FF4242
          43FF424243FF424243FF424243FF424243FF424243FF424243FF424243FF4242
          43FF424243FF424243FF424243E046464621FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF000000000140404008404040084040400840404008404040084040
          4008404040084040400840404008404040084040400840404008404040084040
          4008404040084040400840404008404040084040400840404008404040084040
          4008404040084040400800000001FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF004545452540404628FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00808080025E4D39A58A5E2AE78B5F29E75E4D
          39A580808002FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00808080025D4D3AAFC37415F7FF8B00FFFF8B00FFC875
          14F65D4C39AF80808002FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00808080025D4D3AAFC37415F7FF8B00FFFF8B00FFFF8B00FFFF8B
          00FFC87514F65D4C39AF80808002FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00808080025D4D3AAFC37415F7FF8B00FFFF8B00FFFF8B00FFFF8B00FFFF8B
          00FFFF8B00FFC87514F65D4C39AF80808002FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
          80025D4D3AAFC37415F7FF8B00FFFF8B00FFFF8B00FFFF8B00FFFF8B00FFFF8B
          00FFFF8B00FFFF8B00FFC87514F65D4C39AF80808002FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00808080025D4D
          3AAFC37415F7FF8B00FFFF8B00FFFF8B00FFFF8B00FFFF8B00FFFF8B00FFFF8B
          00FFFF8B00FFFF8B00FFFF8B00FFC87514F65D4C39AF80808002FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF005D4D3AAFC374
          15F7FF8B00FFFF8B00FFFF8B00FFFF8B00FFFF8B00FFFF8B00FFFF8B00FFFF8B
          00FFFF8B00FFFF8B00FFFF8B00FFFF8B00FFC87514F65E4C39AEFFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0051463C4CA46820F1FF8B
          00FFFF8B00FFFF8B00FFFF8B00FFFF8B00FFFF8B00FFFF8B00FFFF8B00FFFF8B
          00FFFF8B00FFFF8B00FFFF8B00FFFF8B00FFFF8B00FFA86A1FF151473D4FFFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF005B4C3A9AE07F0BFFFF8B
          00FFFF8B00FFFF8B00FFFF8B00FFFF8B00FFFF8B00FFFF8B00FFFF8B00FFFF8B
          00FFFF8B00FFFF8B00FFFF8B00FFFF8B00FFFF8B00FFE07F0BFF5A4C3BA1FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF004040401C604E37C17153
          32D6715332D6715332D6986325EBFF8B00FFFF8B00FFFF8B00FFFF8B00FFFF8B
          00FFFF8B00FF9A6424EB715332D6715332D6715332D6604E38C44646461DFFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF005D4C3AA7E88208FFFF8B00FFFF8B00FFFF8B00FFFF8B
          00FFE88208FF5D4C39AFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00604D3998E78208FFFF8B00FFFF8B00FFFF8B00FFFF8B
          00FFE78208FF604F39A2FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00604D3998E78208FFFF8B00FFFF8B00FFFF8B00FFFF8B
          00FFE78208FF604F39A2FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00604D3998E78208FFFF8B00FFFF8B00FFFF8B00FFFF8B
          00FFE78208FF604F39A2FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00604D3998E78208FFFF8B00FFFF8B00FFFF8B00FFFF8B
          00FFE78208FF604F39A2FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00604D3998E78208FFFF8B00FFFF8B00FFFF8B00FFFF8B
          00FFE78208FF604F39A2FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00604D3998E78208FFFF8B00FFFF8B00FFFF8B00FFFF8B
          00FFE78208FF604F39A2FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00604D3998E78208FFFF8B00FFFF8B00FFFF8B00FFFF8B
          00FFE78208FF604F39A2FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00604D3998E78208FFFF8B00FFFF8B00FFFF8B00FFFF8B
          00FFE78208FF604F39A2FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF005C4B3895DC7E0CFFFF8B00FFFF8B00FFFF8B00FFFF8B
          00FFDD7E0CFF5F4D389FFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00404040185F4D38C3695135CA695135CA695135CA6951
          35CA614E38C34545451AFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
        Layout = blGlyphTop
        Spacing = 1
      end
    end
    object ts2: TTabSheet
      Caption = #1044#1072#1085#1085#1099#1077
      ImageIndex = 1
      object gbxTypes: TGroupBox
        Left = 0
        Top = 0
        Width = 321
        Height = 53
        Align = alLeft
        Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1076#1072#1085#1085#1099#1077' '#1076#1083#1103' '#1074#1099#1075#1088#1091#1079#1082#1080':'
        TabOrder = 0
        object lblLas: TLabel
          Left = 8
          Top = 8
          Width = 3
          Height = 13
        end
        object chkScans: TCheckBox
          Left = 112
          Top = 23
          Width = 201
          Height = 17
          Caption = #1057#1082#1072#1085#1080#1088#1086#1074#1072#1085#1085#1099#1077' '#1082#1086#1087#1080#1080' '#1076#1072#1085#1085#1099#1093' '#1043#1048#1057
          Enabled = False
          TabOrder = 0
        end
        object chkLAS: TCheckBox
          Left = 3
          Top = 23
          Width = 97
          Height = 17
          Caption = 'LAS-'#1092#1072#1081#1083#1099
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
      end
      object gbxPath: TGroupBox
        Left = 321
        Top = 0
        Width = 312
        Height = 53
        Align = alLeft
        Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1091#1090#1100' '#1076#1083#1103' '#1074#1099#1075#1088#1091#1079#1082#1080' '#1092#1072#1081#1083#1086#1074':'
        TabOrder = 1
        object btnBrose: TBitBtn
          Left = 232
          Top = 21
          Width = 75
          Height = 25
          Action = actBrose
          Caption = #1054#1073#1079#1086#1088' ...'
          Enabled = False
          TabOrder = 0
        end
        object edtPath: TEdit
          Left = 8
          Top = 23
          Width = 217
          Height = 21
          TabOrder = 1
          Text = 'D:'
        end
      end
    end
  end
  object mm1: TMainMenu
    Left = 8
    Top = 456
    object A1: TMenuItem
      Caption = #1060#1072#1081#1083
      object N1: TMenuItem
        Caption = #1042#1099#1093#1086#1076
      end
    end
  end
  object actlst1: TActionList
    Left = 456
    Top = 8
    object actMakeWells: TAction
      Caption = 'actMakeWells'
      OnExecute = actMakeWellsExecute
    end
    object actWellsForExport: TAction
      Caption = 'actWellsForExport'
      OnExecute = actWellsForExportExecute
    end
    object actBrose: TAction
      Caption = 'actBrose'
      OnExecute = actBroseExecute
    end
    object actExport: TAction
      Caption = 'actExport'
      OnExecute = actExportExecute
    end
    object actDelSelectedWells: TAction
      Caption = 'actDelSelectedWells'
      OnExecute = actDelSelectedWellsExecute
    end
  end
  object dlgOpen: TOpenDialog
    Left = 496
    Top = 8
  end
end
