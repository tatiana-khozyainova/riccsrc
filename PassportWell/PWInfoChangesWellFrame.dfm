inherited InfoChangesWell: TInfoChangesWell
  Width = 503
  Height = 287
  inherited StatusBar: TStatusBar
    Top = 268
    Width = 503
  end
  object Panel5: TPanel
    Left = 0
    Top = 105
    Width = 503
    Height = 55
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object GroupBox8: TGroupBox
      Left = 0
      Top = 0
      Width = 175
      Height = 55
      Align = alLeft
      Caption = #1044#1072#1090#1072' '#1074#1074#1086#1076#1072' '#1076#1072#1085#1085#1099#1093
      TabOrder = 0
      DesignSize = (
        175
        55)
      object dtmEnteringData: TDateTimePicker
        Left = 8
        Top = 24
        Width = 159
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Date = 40190.482656250000000000
        Time = 40190.482656250000000000
        TabOrder = 0
      end
    end
    object GroupBox9: TGroupBox
      Left = 175
      Top = 0
      Width = 175
      Height = 55
      Align = alLeft
      Caption = #1044#1072#1090#1072' '#1087#1086#1089#1083#1077#1076#1085#1077#1081' '#1084#1086#1076#1080#1092#1080#1082#1072#1094#1080#1080
      TabOrder = 1
      DesignSize = (
        175
        55)
      object dtmLastModifyData: TDateTimePicker
        Left = 8
        Top = 24
        Width = 159
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Date = 40190.482656250000000000
        Time = 40190.482656250000000000
        Enabled = False
        TabOrder = 0
      end
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 160
    Width = 503
    Height = 89
    Align = alTop
    BiDiMode = bdLeftToRight
    Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
    ParentBiDiMode = False
    TabOrder = 2
    object mmBasicChange: TMemo
      Left = 2
      Top = 15
      Width = 499
      Height = 72
      Align = alClient
      TabOrder = 0
    end
  end
  inline frmFilterEmployee: TfrmFilter
    Left = 0
    Top = 50
    Width = 503
    Height = 55
    Align = alTop
    Enabled = False
    TabOrder = 3
    inherited gbx: TGroupBox
      Width = 503
      Height = 55
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082', '#1074#1085#1086#1089#1080#1074#1096#1080#1081' '#1087#1086#1089#1083#1077#1076#1085#1080#1077' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
      inherited cbxActiveObject: TComboEdit
        Width = 488
      end
    end
  end
  inline frmFilterReasonChange: TfrmFilter
    Left = 0
    Top = 0
    Width = 503
    Height = 50
    Align = alTop
    TabOrder = 4
    inherited gbx: TGroupBox
      Width = 503
      Caption = #1055#1088#1080#1095#1080#1085#1072' '#1087#1086#1089#1083#1077#1076#1085#1080#1093' '#1080#1079#1084#1077#1085#1077#1085#1080#1081
      inherited cbxActiveObject: TComboEdit
        Width = 488
      end
    end
  end
end
