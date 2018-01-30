object frmLicenseZoneSelect: TfrmLicenseZoneSelect
  Left = 0
  Top = 0
  Width = 435
  Height = 54
  HorzScrollBar.Visible = False
  Align = alTop
  AutoScroll = False
  TabOrder = 0
  object lblCount: TLabel
    Left = 600
    Top = 72
    Width = 3
    Height = 13
  end
  object grpLZSelect: TGroupBox
    Left = 0
    Top = 0
    Width = 435
    Height = 54
    Align = alClient
    Caption = #1051#1080#1094#1077#1085#1079#1080#1086#1085#1085#1099#1081' '#1091#1095#1072#1089#1090#1086#1082
    TabOrder = 0
    DesignSize = (
      435
      54)
    object btnPrev: TSpeedButton
      Left = 8
      Top = 22
      Width = 65
      Height = 22
      Action = act1
      Flat = True
    end
    object btnNext: TSpeedButton
      Left = 812
      Top = 23
      Width = 65
      Height = 22
      Action = act2
      Anchors = [akRight, akBottom]
      Flat = True
    end
    object btnSearch: TSpeedButton
      Left = 1121
      Top = 23
      Width = 65
      Height = 22
      Action = actSeach
      Anchors = [akRight, akBottom]
      Flat = True
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
        FFFFFFF3ECECA27171AA8080E5D9D9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFB1B5C02C4A6F4A4855FFFFFFFFFFFFFFFFFFD5BEBEBB9292CBA9A99F6B6BB7
        9595F0EAEAFFFFFFFFFFFFFFFFFFB4B8C43F749A47B0ED1C3E6FFFFFFFFFFFFF
        FCFBFBB48B8BE1CBCBF2E6E6EBD5D5C59C9E9E6A6BC9ACABF6F4F4B5BFCE3C7B
        A64DB8F31A59A0AFB7C6FFFFFFFFFFFFE8DCDCB98F8FFEFBFBF6E9EBC5AEB2C0
        AAABAC8E8D905C5D8F65693863923CAEF2206CBDB4BFD2FFFFFFFFFFFFFFFFFF
        C4A3A3E0C8C8F8F9FDAB9390B09067C9BC81CAC095B3A28D734F4C5454671852
        9A97A0B9FFFFFFFFFFFFFFFFFFF4EEEEBA9191FDFDFDB29E99B99157F9DE81FE
        FEA7FEFEC9FCFCDEB7A99F7C5F5EB695998F5A5CB29495F8F4F4FFFFFFD5BCBC
        DDC4C4E2E3E8B2865FF5C266FBDD84FDFBA9FDFEC2FEFEE3F9F8E6AE978BCAA9
        A8D1AAA98D504FD6C5C5FAF7F7C39F9FFCF7F8D3C9C9CB9559FDCF72F8DA84FC
        F2A3FDFEC5FDFEC8FEFED3CEC2A0B7989BD3B3B3986565F1EBEBE7D8D8D2B5B5
        FEFEFECEBCBCC98B50FED678FDF9B7FBEEB3FCF6ACFDFEAEFEFEB1D5C998C4AA
        B0BC9090B99A9AFFFFFFCEB0B0E4D2D2EEE2E2D5C5CABE8661F2B960FEF8A8FD
        F6B3FBE791FCE78BF8EC8ECAB28FDAC2C69C6767EDE4E4FFFFFFC29B9BE3D0D0
        F6EEEEFEFEFED6C5BED19055F3BC61FCD575F9CF72F5C96DD5B277CFBDBBCFAC
        ACAD8484FFFFFFFFFFFFEADCDCD0B3B3D1B1B1E8DADAFEFEFEDDCFC8D6A174DE
        A263DEAA6DCFA881C9B2B0F1E4E7AB7979DFD0D0FFFFFFFFFFFFFFFFFFFFFFFF
        EDE1E1CFB2B2C8A4A4E8D7D8F0F1F7E8E2E0E8E0E1EDE4EBE2CECFDEC8C6AE83
        83FDFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3ECECCFB3B3C39A9AE4
        CFD1FDFBFCFEFEFEE6D5D5C29E9ED1B9B9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFF1E9E9CDAFAFC29D9DD8BFBFD8BDBDB18585F3ED
        EDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFF2EBEBD0B7B7AB7C7CC9ABABFFFFFFFFFFFFFFFFFFFFFFFF}
    end
    object cmbxLicenseZones: TComboBox
      Left = 75
      Top = 23
      Width = 734
      Height = 21
      BevelKind = bkFlat
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 0
      OnChange = cmbxLicenseZonesChange
    end
    object edtLZSeach: TEdit
      Left = 883
      Top = 23
      Width = 235
      Height = 21
      Anchors = [akTop, akRight]
      BevelKind = bkFlat
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = #1042#1074#1077#1076#1080#1090#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1083#1080#1094#1077#1085#1079#1080#1086#1085#1085#1086#1075#1086' '#1091#1095#1072#1089#1090#1082#1072
      OnEnter = edtLZSeachEnter
    end
  end
  object actlstLZSeach: TActionList
    Left = 661
    Top = 8
    object actSeach: TAction
      Caption = #1055#1086#1080#1089#1082
      OnExecute = actSeachExecute
      OnUpdate = actSeachUpdate
    end
    object act2: TAction
      Caption = '>>'
      OnExecute = act2NextExecute
      OnUpdate = act2NextUpdate
    end
    object act1: TAction
      Caption = '<<'
      OnExecute = act1PrevExecute
      OnUpdate = act1PrevUpdate
    end
  end
end
