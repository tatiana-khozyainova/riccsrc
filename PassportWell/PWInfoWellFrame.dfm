object frmInfoWell: TfrmInfoWell
  Left = 0
  Top = 0
  Width = 648
  Height = 494
  TabOrder = 0
  DesignSize = (
    648
    494)
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 648
    Height = 57
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 0
      Top = 0
      Width = 105
      Height = 57
      Align = alLeft
      Caption = #1053#1086#1084#1077#1088' '#1089#1082#1074#1072#1078#1080#1085#1099
      TabOrder = 0
      DesignSize = (
        105
        57)
      object edtNumber: TEdit
        Left = 8
        Top = 24
        Width = 90
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
    end
    inline frmFilterArea: TfrmFilter
      Left = 105
      Top = 0
      Width = 265
      Height = 57
      Align = alLeft
      TabOrder = 1
      inherited gbx: TGroupBox
        Width = 265
        Height = 57
        Caption = #1055#1083#1086#1097#1072#1076#1100
        inherited cbxActiveObject: TComboEdit
          Width = 250
          OnButtonClick = frmFilterAreacbxActiveObjectButtonClick
        end
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 57
    Width = 648
    Height = 55
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object GroupBox5: TGroupBox
      Left = 0
      Top = 0
      Width = 648
      Height = 55
      Align = alClient
      Caption = #1057#1080#1085#1086#1085#1080#1084#1099' ('#1076#1083#1103' '#1089#1090#1072#1088#1099#1093' '#1089#1082#1074#1072#1078#1080#1085')'
      TabOrder = 0
      DesignSize = (
        648
        55)
      object edtNameSyn: TEdit
        Left = 8
        Top = 24
        Width = 632
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        Text = '<'#1089#1080#1085#1086#1085#1080#1084' '#1089#1082#1074#1072#1078#1080#1085#1099'>'
      end
    end
  end
  inline frmFilterCategory: TfrmFilter
    Left = 373
    Top = -1
    Width = 276
    Height = 57
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    inherited gbx: TGroupBox
      Width = 276
      Height = 57
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1089#1082#1074#1072#1078#1080#1085#1099
      ParentFont = False
      DesignSize = (
        276
        57)
      inherited cbxActiveObject: TComboEdit
        Width = 261
        ParentFont = False
      end
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 265
    Width = 648
    Height = 81
    Align = alTop
    Caption = #1055#1088#1086#1077#1082#1090#1085#1099#1077' '#1087#1086#1082#1072#1079#1072#1090#1077#1083#1080
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object GroupBox3: TGroupBox
      Left = 408
      Top = 18
      Width = 200
      Height = 54
      Caption = #1043#1083#1091#1073#1080#1085#1072' '#1079#1072#1073#1086#1103', '#1084
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      DesignSize = (
        200
        54)
      object edtTargetDepth: TEdit
        Left = 8
        Top = 22
        Width = 187
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
    end
    inline frmFilterTargetAge: TfrmFilter
      Left = 207
      Top = 17
      Width = 200
      Height = 55
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      inherited gbx: TGroupBox
        Width = 200
        Height = 55
        Caption = #1042#1086#1079#1088#1072#1089#1090' '#1087#1086#1088#1086#1076' '#1085#1072' '#1079#1072#1073#1086#1077
        ParentFont = False
        inherited cbxActiveObject: TComboEdit
          Width = 185
          ParentFont = False
        end
      end
    end
    inline frmFilterTargetResult: TfrmFilter
      Left = 5
      Top = 18
      Width = 200
      Height = 54
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      inherited gbx: TGroupBox
        Width = 200
        Height = 54
        Caption = #1062#1077#1083#1077#1074#1086#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
        ParentFont = False
        inherited cbxActiveObject: TComboEdit
          Width = 185
          ParentFont = False
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 346
    Width = 648
    Height = 144
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    object gbxCost: TGroupBox
      Left = 0
      Top = 0
      Width = 648
      Height = 73
      Align = alTop
      Caption = #1055#1088#1086#1077#1082#1090#1085#1072#1103' '#1089#1090#1086#1080#1084#1086#1089#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object GroupBox4: TGroupBox
        Left = 6
        Top = 16
        Width = 200
        Height = 49
        Caption = #1057#1084#1077#1090#1085#1072#1103' '#1089#1090#1086#1080#1084#1086#1089#1090#1100', '#1090'.'#1088'.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        DesignSize = (
          200
          49)
        object edtTargetCost: TEdit
          Left = 8
          Top = 22
          Width = 187
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
        end
      end
      inline frmFilterIstResourse: TfrmFilter
        Left = 208
        Top = 14
        Width = 209
        Height = 49
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        inherited gbx: TGroupBox
          Width = 209
          Height = 49
          Caption = #1048#1089#1090#1086#1095#1085#1080#1082' '#1092#1080#1085#1072#1085#1089#1080#1088#1086#1074#1072#1085#1080#1103
          ParentFont = False
          DesignSize = (
            209
            49)
          inherited cbxActiveObject: TComboEdit
            Left = 5
            Width = 196
            ParentFont = False
          end
        end
      end
    end
  end
  object gbxDates: TGroupBox
    Left = 0
    Top = 112
    Width = 648
    Height = 153
    Align = alTop
    Caption = #1044#1072#1090#1099
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    object GroupBox6: TGroupBox
      Left = 10
      Top = 16
      Width = 200
      Height = 65
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1073#1091#1088#1077#1085#1080#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      DesignSize = (
        200
        65)
      object dtmStartDrilling: TDateTimePicker
        Left = 8
        Top = 37
        Width = 184
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Date = 40190.482656250000000000
        Time = 40190.482656250000000000
        TabOrder = 0
      end
      object chbxDrillingStart: TCheckBox
        Left = 8
        Top = 16
        Width = 97
        Height = 17
        Caption = #1085#1077' '#1091#1082#1072#1079#1072#1085#1072
        TabOrder = 1
        OnClick = chbxDrillingStartClick
      end
    end
    object GroupBox7: TGroupBox
      Left = 211
      Top = 16
      Width = 200
      Height = 65
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1073#1091#1088#1077#1085#1080#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      DesignSize = (
        200
        65)
      object dtmFinishDrilling: TDateTimePicker
        Left = 8
        Top = 37
        Width = 184
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Date = 40190.482656250000000000
        Time = 40190.482656250000000000
        TabOrder = 0
      end
      object chbxDrillingFinish: TCheckBox
        Left = 8
        Top = 16
        Width = 97
        Height = 17
        Caption = #1085#1077' '#1091#1082#1072#1079#1072#1085#1072
        TabOrder = 1
        OnClick = chbxDrillingFinishClick
      end
    end
    object GroupBox8: TGroupBox
      Left = 10
      Top = 80
      Width = 200
      Height = 65
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1089#1090#1088#1086#1080#1090#1077#1083#1100#1089#1090#1074#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      DesignSize = (
        200
        65)
      object dtmConstructionStarted: TDateTimePicker
        Left = 8
        Top = 37
        Width = 184
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Date = 40190.482656250000000000
        Time = 40190.482656250000000000
        TabOrder = 0
      end
      object chbxConstructionStart: TCheckBox
        Left = 8
        Top = 16
        Width = 97
        Height = 17
        Caption = #1085#1077' '#1091#1082#1072#1079#1072#1085#1072
        TabOrder = 1
        OnClick = chbxConstructionStartClick
      end
    end
    object GroupBox9: TGroupBox
      Left = 210
      Top = 80
      Width = 200
      Height = 65
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1089#1090#1088#1086#1080#1090#1077#1083#1100#1089#1090#1074#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      DesignSize = (
        200
        65)
      object dtmConstructionFinished: TDateTimePicker
        Left = 8
        Top = 37
        Width = 184
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Date = 40190.482656250000000000
        Time = 40190.482656250000000000
        TabOrder = 0
      end
      object chbxConstructionFinish: TCheckBox
        Left = 8
        Top = 16
        Width = 97
        Height = 17
        Caption = #1085#1077' '#1091#1082#1072#1079#1072#1085#1072
        TabOrder = 1
        OnClick = chbxConstructionFinishClick
      end
    end
  end
end
