object formAddLasFile: TformAddLasFile
  Left = 82
  Top = 141
  Width = 854
  Height = 558
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' LAS-'#1092#1072#1081#1083#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = TopMainMenu
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object TopToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 846
    Height = 33
    ButtonWidth = 30
    Caption = 'TopToolBar'
    Flat = True
    Images = ImageList
    TabOrder = 0
    object TBSep1: TToolButton
      Left = 0
      Top = 0
      Width = 8
      Caption = 'TBSep1'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object TBOpen: TToolButton
      Left = 8
      Top = 0
      Hint = #1054#1090#1082#1088#1099#1090#1100' LAS-'#1092#1072#1081#1083' (-'#1099')'
      Action = actOpenLas
      ImageIndex = 0
      ParentShowHint = False
      ShowHint = True
    end
    object TBSep2: TToolButton
      Left = 38
      Top = 0
      Width = 8
      Caption = 'TBSep2'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object TBDel: TToolButton
      Left = 46
      Top = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' Las-'#1092#1072#1081#1083' (-'#1099')'
      Caption = 'TBDel'
      ImageIndex = 1
      ParentShowHint = False
      ShowHint = True
      OnClick = TBDelClick
    end
    object TBSep3: TToolButton
      Left = 76
      Top = 0
      Width = 8
      Caption = 'TBSep3'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object TBJoin: TToolButton
      Left = 84
      Top = 0
      Hint = #1054#1090#1086#1073#1088#1072#1079#1080#1090#1100' '#1089#1082#1074#1072#1078#1080#1085#1099
      Action = actViewAreas
      ImageIndex = 2
      ParentShowHint = False
      ShowHint = True
    end
    object TBSep4: TToolButton
      Left = 114
      Top = 0
      Width = 8
      Caption = 'TBSep4'
      ImageIndex = 3
      Style = tbsSeparator
    end
  end
  inline frmTrwLasFiles: TfrmTrwLasFiles
    Left = 0
    Top = 33
    Width = 250
    Height = 471
    Align = alLeft
    TabOrder = 1
    inherited gbx1: TGroupBox
      Height = 471
      inherited trwLasFiles: TTreeView
        Height = 454
      end
    end
  end
  inline frmChangeLasFile1: TfrmChangeLasFile
    Left = 250
    Top = 33
    Width = 596
    Height = 471
    Align = alClient
    TabOrder = 2
    inherited gbx1: TGroupBox
      Width = 596
      Height = 471
      inherited pgcMain: TPageControl
        Width = 592
        Height = 454
        inherited tsJoin: TTabSheet
          inherited lstBoxWell: TListBox
            Left = 326
          end
        end
        inherited tsChange: TTabSheet
          inherited gbxVersion: TGroupBox
            Width = 583
            inherited lstVersion: TListBox
              Width = 579
            end
          end
          inherited gbxWell: TGroupBox
            Width = 583
            inherited lstWell: TListBox
              Width = 579
            end
          end
          inherited gbxCurve: TGroupBox
            Width = 583
            inherited lstCurve: TListBox
              Width = 579
            end
          end
          inherited gbxAscii: TGroupBox
            Width = 583
            inherited lstAscii: TListBox
              Width = 579
            end
          end
        end
      end
    end
    inherited actlstChangeLasFile: TActionList
      inherited actJoinToWell: TAction
        OnExecute = frmChangeLasFile1actJoinToWellExecute
      end
    end
  end
  object TopMainMenu: TMainMenu
    Top = 472
    object mbtn1: TMenuItem
      Caption = #1060#1072#1081#1083
      object N1: TMenuItem
        Action = actOpenLas
        Caption = #1054#1090#1082#1088#1099#1090#1100
      end
      object mbtn11: TMenuItem
        Caption = #1047#1072#1082#1088#1099#1090#1100
      end
    end
    object N2: TMenuItem
      Action = actOpenCurveDict
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1082#1088#1080#1074#1099#1093
    end
  end
  object ImageList: TImageList
    Left = 32
    Top = 472
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000002020200020202000202020002020200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000808
      0A00408D9E001C404B0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000002727B9000F0F
      BC00000000000000000000000000000000000000000000000000000000001818
      7D003A3AF1000D0D4B0000000000000000000000000000000000000000000000
      0000020202000202020002020200020202000202020002020200020202000202
      0200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002751
      65003F91A0005FDDFF0033768A00000000000000000000000000000000000000
      000000000000000000000000000000000000000000002525B8000606B6000909
      BA001212BF00000000000000000000000000000000000000000017177D003232
      E8003A3AF1004242F9000D0D4B00000000000000000000000000000000000202
      0200020202000202020002020200020202000202020002020200020202000202
      0200020202000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004EAA
      D6003B83900061DDFE005DDAFE0040A0C60004080A0000000000000000000000
      0000000000000000000000000000000000002424AC000303B4000606B6000808
      B9000B0BBD001515C30000000000000000000000000017177E002929DE003030
      E5003636EC003A3AF0003838EF00000000000000000000000000000000000202
      0200020202000202020002020200020202000202020002020200020202000202
      0200020202000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000070A0C0057BF
      F200326972005DD4FE0058CEFF0054CBFF0044B8EF0013303E00000000000000
      000000000000000000000000000000000000000000004848C3000505B6000808
      B9000A0ABC000E0EC0001818C6000000000017177E002020D4002626DA002B2B
      E0002F2FE5003131E70003033500000000000000000000000000020202000202
      0200020202000202020002020200020202000202020002020200020202000202
      0200020202000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000234B5C0054BE
      EF00244850005ED4FF005BD2FF0058CFFF004FC8FE0045C1FC00225D7A000000
      00000000000000000000000000000000000000000000000000004848C2000606
      B8000A0ABB000D0DBE001010C2001A1AC8001818CB001D1DD0002121D5002626
      DA002828DD000303350000000000000000000000000000000000020202000202
      0200020202000202020002020200020202000202020002020200020202000202
      0200020202000202020000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000004000000449AC4004FB9
      EE0016262B0092E4FF005ED5FE005BD3FE0055CEFF0048C3FD0042BFFB00328F
      B900020000000000000000000000000000000000000000000000000000004949
      C3000808B9000B0BBD000E0EC0001212C4001515C8001919CC001D1DD0001F1F
      D400030336000000000000000000000000000000000000000000020202000202
      0200020202000202020002020200020202000202020002020200020202000202
      0200020202000202020000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000302020060E0FF0050BD
      F100060E1400A4E9FF00A0E7FF006CDAFF0059D3FF004CC9FF0047C2FC0041BE
      FA0040B4E9000000000000000000000000000000000000000000000000000000
      00004949C3000909BB000C0CBE000F0FC1001212C4001515C8001818CB000404
      3800000000000000000000000000000000000000000000000000000000000202
      0200020202000202020002020200020202000202020002020200020202000202
      0200020202000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001836360066FAFF0065F7
      FF00132D3000A8E2F900AFE9FF00AFEBFF00ADEBFF00A9E7FF00A4E2FE00A1E0
      FD006ECFFD001A4F640000000000000000000000000000000000000000000000
      0000161681000808B9000A0ABC000C0CBE000F0FC1001212C4001A1AC8000000
      0000000000000000000000000000000000000000000000000000000000000202
      0200020202000202020002020200020202000202020002020200020202000202
      0200020202000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000A0505003D959D005EEFFE005FF2
      FE0042A1A50034586A00B4E6FC00BEEDFF00BEEFFF00BDEEFF00B7EAFF00B4E7
      FE00B4E6FD007BADC30000000000000000000000000000000000000000001414
      81003434C4002E2EC4000808B9000A0ABB000C0CBE000E0EC0001010C2001818
      C500000000000000000000000000000000000000000000000000000000000000
      0000020202000202020002020200020202000202020002020200020202000202
      0200020202000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000100000051D7ED0055E5FD0057E8
      FD005BEFFF0041ABBC002D84AD0070D2FD00CAF1FF00CEF4FF00CAF1FF00C8EE
      FF00C7EDFF00C1E9FC0000000000000000000000000000000000141481003838
      C4003535C4003434C4003232C5002F2FC5002F2FC6002929C6002020C4001D1D
      C4002525C7000000000000000000000000000000000000000000000000000000
      0000020202000202020002020200020202000202020002020200020202000202
      0200020202000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000030202004FDCFF004EDCFD0051E0
      FE0054E6FF0053E8FF0057ECFF0041B6C900318FB60083E1FE00DCF7FF00DAF4
      FF00D9F3FF00DBF4FF00334D59000000000000000000141482003E3EC5003B3B
      C5003838C4003535C4003434C40001013A004F4FC4002F2FC5002F2FC6002E2E
      C6002E2EC7003333C90000000000000000000000000000000000000000000000
      0000000000000202020002020200020202000202020002020200020202000202
      0200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000910120049D4FF004BD4FE004CD7
      FE004EDDFE0050E3FE0052E4FF0050E5FF0052EAFF0042BBCE003193B10096E7
      FD00EAF9FF00E9F8FF009AB5C0000000000010108A004444C7004141C6003E3E
      C5003A3AC5003838C40000003A0000000000000000004F4FC4003131C5003030
      C5003030C5003030C5003535C700000000000000000000000000000000000000
      0000000000000000000002020200020202000202020002020200020202000202
      0200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000030404001F4E62003EABD40049D4
      FF004BD6FE004EE0FF004FE1FF004FE3FF0050E5FE004FE7FE0051E8FF0042BC
      D1002F89A500A9EAFD00F4FAFC0000000000000000007D7DDA004444C7004141
      C6003E3EC50000003A00000000000000000000000000000000004F4FC4003232
      C4003232C4003232C4003333B400000000000000000000000000000000000000
      0000000000000000000000000000020202000202020002020200020202000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000101B
      200027697C0041B8D5004DDDFD004EE4FF00318A980040B3C7004EE1FB0048CE
      E600000000000710130032809B00244B5A0000000000000000007D7DDA004444
      C70000003B000000000000000000000000000000000000000000000000004F4F
      C5003535C4003434B40000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000202020002020200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000001000000132A2F000000000000000000010000000100
      0000000000000000000000000000000000000000000000000000000000000101
      5300000000000000000000000000000000000000000000000000000000000000
      000012129A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000202020002020200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00F7FFEFF7FC3F0000E3FFC7E3F00F0000
      E0FF83C1E0070000C07F0180E0070000C03F8001C0070000C01FC003C0030000
      8007E007C00300008003F00FE00700008003F00FE00700000003E007F0070000
      0001C003F007000000018001F80F000000010180FC0F0000000083C1FE1F0000
      E008C7E3FF3F0000FCCFEFF7FF3F000000000000000000000000000000000000
      000000000000}
  end
  object Actionlist: TActionList
    Left = 64
    Top = 472
    object actOpenLas: TAction
      Caption = 'actOpenLas'
      OnExecute = TBOpenClick
    end
    object actViewAreas: TAction
      Caption = 'actViewAreas'
    end
    object actOpenCurveDict: TAction
      Caption = 'actOpenCurveDict'
      OnExecute = N2Click
    end
  end
  object openDialog: TOpenDialog
    Left = 96
    Top = 472
  end
end