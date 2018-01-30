inherited frmInfoCoordWell: TfrmInfoCoordWell
  Width = 501
  Height = 192
  inherited StatusBar: TStatusBar
    Top = 173
    Width = 501
  end
  object grp1: TGroupBox
    Left = 0
    Top = 0
    Width = 501
    Height = 118
    Align = alClient
    Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1082#1086#1086#1088#1076#1080#1085#1072#1090
    TabOrder = 1
    object lbl8: TLabel
      Left = 279
      Top = 83
      Width = 10
      Height = 13
      Caption = 'Y:'
    end
    object lbl7: TLabel
      Left = 279
      Top = 51
      Width = 10
      Height = 13
      Caption = #1061':'
    end
    object lbl6: TLabel
      Left = 64
      Top = 83
      Width = 10
      Height = 13
      Caption = 'Y:'
    end
    object lbl5: TLabel
      Left = 64
      Top = 51
      Width = 10
      Height = 13
      Caption = #1061':'
    end
    object edtGradX: TMaskEdit
      Left = 80
      Top = 48
      Width = 73
      Height = 21
      EditMask = '00\'#176'00\'#39'00,00\'#39#39';1;_'
      MaxLength = 13
      TabOrder = 0
      Text = '  '#176'  '#39'  ,  '#39#39
    end
    object rbtn: TRadioButton
      Left = 32
      Top = 24
      Width = 169
      Height = 17
      Caption = #1043#1077#1086#1075#1088#1072#1092#1080#1095#1077#1089#1082#1080#1077' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object rb1: TRadioButton
      Left = 248
      Top = 24
      Width = 169
      Height = 17
      Caption = #1055#1088#1103#1084#1086#1091#1075#1086#1083#1100#1085#1099#1077' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099
      Enabled = False
      TabOrder = 2
    end
    object edtY: TEdit
      Left = 296
      Top = 80
      Width = 121
      Height = 21
      Enabled = False
      TabOrder = 3
    end
    object edtX: TEdit
      Left = 296
      Top = 48
      Width = 121
      Height = 21
      Enabled = False
      TabOrder = 4
    end
    object edtGradY: TMaskEdit
      Left = 80
      Top = 80
      Width = 69
      Height = 21
      EditMask = '00\'#176'00\'#39'00.00\'#39#39';1;_'
      MaxLength = 13
      TabOrder = 5
      Text = '  '#176'  '#39'  .  '#39#39
    end
  end
  object pnl: TPanel
    Left = 0
    Top = 118
    Width = 501
    Height = 55
    Align = alBottom
    Caption = 'pnl'
    TabOrder = 2
    inline frmFilterSource: TfrmFilter
      Left = 1
      Top = 1
      Width = 343
      Height = 53
      Align = alClient
      TabOrder = 0
      inherited gbx: TGroupBox
        Width = 343
        Height = 53
        Caption = #1048#1089#1090#1086#1095#1085#1080#1082
        inherited cbxActiveObject: TComboEdit
          Width = 327
        end
      end
    end
    object grp: TGroupBox
      Left = 344
      Top = 1
      Width = 156
      Height = 53
      Align = alRight
      Caption = #1044#1072#1090#1072' '#1087#1086#1089#1083#1077#1076#1085#1080#1093' '#1080#1079#1084#1077#1085#1077#1085#1080#1081
      TabOrder = 1
      object dtmEnteringDate: TDateTimePicker
        Left = 8
        Top = 24
        Width = 138
        Height = 21
        Date = 41514.641028449080000000
        Time = 41514.641028449080000000
        Enabled = False
        TabOrder = 0
      end
    end
  end
end
