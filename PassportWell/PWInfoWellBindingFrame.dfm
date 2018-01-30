object frmWellBinding: TfrmWellBinding
  Left = 0
  Top = 0
  Width = 657
  Height = 571
  TabOrder = 0
  object GroupBox1: TGroupBox
    Left = 0
    Top = 57
    Width = 657
    Height = 272
    Align = alTop
    Caption = #1055#1086#1083#1086#1078#1077#1085#1080#1077' '#1089#1082#1074#1072#1078#1080#1085#1099
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object Panel1: TPanel
      Left = 2
      Top = 112
      Width = 653
      Height = 50
      Align = alTop
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      inline frmFilterNGP: TfrmFilter
        Left = 353
        Top = 0
        Width = 300
        Height = 50
        Align = alRight
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        inherited gbx: TGroupBox
          Width = 300
          Caption = #1053#1043#1055' ('#1076#1086' 2010 '#1075'.)'
          ParentFont = False
          inherited cbxActiveObject: TComboEdit
            Width = 285
            ParentFont = False
          end
        end
      end
      inline frmFilterNGO: TfrmFilter
        Left = 53
        Top = 0
        Width = 300
        Height = 50
        Align = alRight
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        inherited gbx: TGroupBox
          Width = 300
          Caption = #1053#1043#1054' ('#1076#1086' 2010 '#1075'.)'
          ParentFont = False
          inherited cbxActiveObject: TComboEdit
            Width = 285
            ParentFont = False
          end
        end
      end
      inline frmFilterNGR: TfrmFilter
        Left = 0
        Top = 0
        Width = 53
        Height = 50
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        inherited gbx: TGroupBox
          Width = 53
          Caption = #1053#1043#1056' ('#1076#1086' 2010 '#1075'.)'
          ParentFont = False
          inherited cbxActiveObject: TComboEdit
            Width = 39
            OnButtonClick = frmFilterNGRcbxActiveObjectButtonClick
            OnChange = frmFilterNGRcbxActiveObjectChange
          end
        end
      end
    end
    object Panel3: TPanel
      Left = 2
      Top = 162
      Width = 653
      Height = 50
      Align = alTop
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      inline frmFilterStruct: TfrmFilter
        Left = 0
        Top = 0
        Width = 653
        Height = 50
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        inherited gbx: TGroupBox
          Width = 653
          Caption = #1058#1077#1082#1090#1086#1085#1080#1095#1077#1089#1082#1072#1103' '#1089#1090#1088#1091#1082#1090#1091#1088#1072' ('#1076#1086' 2010 '#1075'.)'
          ParentFont = False
          DesignSize = (
            653
            50)
          inherited cbxActiveObject: TComboEdit
            Width = 638
            ParentFont = False
          end
        end
      end
    end
    object Panel4: TPanel
      Left = 2
      Top = 15
      Width = 653
      Height = 97
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object pnl1: TPanel
        Left = 0
        Top = 0
        Width = 653
        Height = 49
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        inline frmFilterNewNGR: TfrmFilter
          Left = 0
          Top = 0
          Width = 53
          Height = 49
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          inherited gbx: TGroupBox
            Width = 53
            Height = 49
            Caption = #1053#1043#1056' ('#1087#1086#1089#1083#1077' 2010 '#1075'.)'
            Font.Style = [fsBold]
            ParentFont = False
            inherited cbxActiveObject: TComboEdit
              Width = 38
              Font.Style = [fsBold]
              ParentFont = False
              OnButtonClick = frmFilterNewNGRcbxActiveObjectButtonClick
              OnChange = frmFilterNewNGRcbxActiveObjectChange
            end
          end
        end
        inline frmFilterNewNGO: TfrmFilter
          Left = 53
          Top = 0
          Width = 300
          Height = 49
          Align = alRight
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          inherited gbx: TGroupBox
            Width = 300
            Height = 49
            Caption = #1053#1043#1054' ('#1087#1086#1089#1083#1077' 2010 '#1075'.)'
            Font.Style = [fsBold]
            ParentFont = False
            inherited cbxActiveObject: TComboEdit
              Width = 285
              Font.Style = [fsBold]
              ParentFont = False
            end
          end
        end
        inline frmFilterNewNGP: TfrmFilter
          Left = 353
          Top = 0
          Width = 300
          Height = 49
          Align = alRight
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          inherited gbx: TGroupBox
            Width = 300
            Height = 49
            Caption = #1053#1043#1055' ('#1087#1086#1089#1083#1077' 2010 '#1075'.)'
            Font.Style = [fsBold]
            ParentFont = False
            inherited cbxActiveObject: TComboEdit
              Width = 285
              Font.Style = [fsBold]
              ParentFont = False
            end
          end
        end
      end
      object Panel6: TPanel
        Left = 0
        Top = 49
        Width = 653
        Height = 48
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        inline frmFilterDistrict: TfrmFilter
          Left = 353
          Top = 0
          Width = 300
          Height = 48
          Align = alRight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          inherited gbx: TGroupBox
            Width = 300
            Height = 48
            Caption = #1040#1076#1084#1080#1085#1080#1089#1090#1088#1072#1090#1080#1074#1085#1099#1081' '#1088#1072#1081#1086#1085
            Font.Style = [fsBold]
            ParentFont = False
            DesignSize = (
              300
              48)
            inherited cbxActiveObject: TComboEdit
              Width = 285
              Font.Style = [fsBold]
              ParentFont = False
            end
          end
        end
        inline frmFilterNewStruct: TfrmFilter
          Left = 0
          Top = 0
          Width = 353
          Height = 48
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          inherited gbx: TGroupBox
            Width = 353
            Height = 48
            Caption = #1058#1077#1082#1090#1086#1085#1080#1095#1077#1089#1082#1072#1103' '#1089#1090#1088#1091#1082#1090#1091#1088#1072' ('#1087#1086#1089#1083#1077' 2010 '#1075'.)'
            Font.Style = [fsBold]
            ParentFont = False
            inherited cbxActiveObject: TComboEdit
              Width = 334
            end
          end
        end
      end
    end
    inline frmFilterTopolist: TfrmFilter
      Left = 2
      Top = 212
      Width = 653
      Height = 58
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      inherited gbx: TGroupBox
        Width = 653
        Height = 58
        Caption = #1058#1086#1087#1086#1075#1088#1072#1092#1080#1095#1077#1089#1082#1080#1081' '#1083#1080#1089#1090
        ParentFont = False
        DesignSize = (
          653
          58)
        inherited cbxActiveObject: TComboEdit
          Width = 638
          ParentFont = False
        end
      end
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 329
    Width = 657
    Height = 67
    Align = alTop
    Caption = #1056#1072#1079#1074#1077#1076#1099#1074#1072#1102#1097#1072#1103' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    inline frmFilterSearchingExpedition: TfrmFilter
      Left = 431
      Top = 15
      Width = 224
      Height = 50
      Align = alRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      inherited gbx: TGroupBox
        Caption = #1053#1043#1044#1059', '#1053#1043#1056#1069
        ParentFont = False
      end
    end
    inline frmFilterSearchingTrust: TfrmFilter
      Left = 207
      Top = 15
      Width = 224
      Height = 50
      Align = alRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      inherited gbx: TGroupBox
        Caption = #1058#1088#1077#1089#1090', '#1086#1073#1098#1077#1076#1080#1085#1077#1085#1080#1077
        ParentFont = False
      end
    end
    inline frmFilterSearchingMinistry: TfrmFilter
      Left = 2
      Top = 15
      Width = 205
      Height = 50
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      inherited gbx: TGroupBox
        Width = 205
        Caption = #1052#1080#1085#1080#1089#1090#1077#1088#1089#1090#1074#1086
        ParentFont = False
        inherited cbxActiveObject: TComboEdit
          Width = 190
        end
      end
    end
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 396
    Width = 657
    Height = 67
    Align = alTop
    Caption = #1069#1082#1089#1087#1083#1091#1072#1090#1080#1088#1091#1102#1097#1072#1103' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    inline frmFilterExploitingMinistry: TfrmFilter
      Left = 2
      Top = 15
      Width = 205
      Height = 50
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      inherited gbx: TGroupBox
        Width = 205
        Caption = #1052#1080#1085#1080#1089#1090#1077#1088#1089#1090#1074#1086
        ParentFont = False
        inherited cbxActiveObject: TComboEdit
          Width = 190
        end
      end
    end
    inline frmFilterExploitingTrust: TfrmFilter
      Left = 207
      Top = 15
      Width = 224
      Height = 50
      Align = alRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      inherited gbx: TGroupBox
        Caption = #1058#1088#1077#1089#1090', '#1086#1073#1098#1077#1076#1080#1085#1077#1085#1080#1077
        ParentFont = False
      end
    end
    inline frmFilterExploitingExpedition: TfrmFilter
      Left = 431
      Top = 15
      Width = 224
      Height = 50
      Align = alRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      inherited gbx: TGroupBox
        Caption = #1053#1043#1044#1059', '#1053#1043#1056#1069
        ParentFont = False
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 657
    Height = 57
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object GroupBox6: TGroupBox
      Left = 0
      Top = 0
      Width = 201
      Height = 57
      Align = alLeft
      Caption = #1055#1072#1089#1087#1086#1088#1090#1085#1099#1081' '#1085#1086#1084#1077#1088' '#1089#1082#1074#1072#1078#1080#1085#1099
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      DesignSize = (
        201
        57)
      object edtPassportNum: TEdit
        Left = 9
        Top = 24
        Width = 184
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
end
