object frmInfoWellParametrs: TfrmInfoWellParametrs
  Left = 0
  Top = 0
  Width = 1001
  Height = 416
  TabOrder = 0
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 1001
    Height = 177
    Align = alTop
    Caption = #1060#1072#1082#1090#1080#1095#1077#1089#1082#1080#1077' '#1087#1086#1082#1072#1079#1072#1090#1077#1083#1080
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object Panel6: TPanel
      Left = 2
      Top = 72
      Width = 997
      Height = 50
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      inline frmFilterState: TfrmFilter
        Left = 0
        Top = 0
        Width = 200
        Height = 50
        Align = alLeft
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        inherited gbx: TGroupBox
          Width = 200
          Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1089#1082#1074#1072#1078#1080#1085#1099
          ParentFont = False
          DesignSize = (
            200
            50)
          inherited cbxActiveObject: TComboEdit
            Width = 185
            OnChange = frmFilterStatecbxActiveObjectChange
          end
        end
      end
      inline frmFilterAbandonReason: TfrmFilter
        Left = 200
        Top = 0
        Width = 200
        Height = 50
        Align = alLeft
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        inherited gbx: TGroupBox
          Width = 200
          Caption = #1055#1088#1080#1095#1080#1085#1072' '#1083#1080#1082#1074#1080#1076#1072#1094#1080#1080
          ParentFont = False
          inherited cbxActiveObject: TComboEdit
            Width = 185
          end
        end
      end
      object gbxDateLiq: TGroupBox
        Left = 400
        Top = 0
        Width = 401
        Height = 50
        Align = alLeft
        Caption = #1044#1072#1090#1072' '#1083#1080#1082#1074#1080#1076#1072#1094#1080#1080
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        DesignSize = (
          401
          50)
        object dtmLiquidation: TDateTimePicker
          Left = 112
          Top = 24
          Width = 281
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          Date = 40190.482656250000000000
          Time = 40190.482656250000000000
          TabOrder = 0
        end
        object chbxLicDate: TCheckBox
          Left = 8
          Top = 24
          Width = 97
          Height = 17
          Caption = #1085#1077' '#1080#1079#1074#1077#1089#1090#1085#1072
          TabOrder = 1
          OnClick = chbxLicDateClick
        end
      end
    end
    object Panel1: TPanel
      Left = 2
      Top = 122
      Width = 997
      Height = 50
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      inline frmFilterProfileName: TfrmFilter
        Left = 200
        Top = 0
        Width = 200
        Height = 50
        Align = alLeft
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        inherited gbx: TGroupBox
          Width = 200
          Caption = #1055#1088#1086#1092#1080#1083#1100
          ParentFont = False
          inherited cbxActiveObject: TComboEdit
            Width = 185
          end
        end
      end
      inline frmFilterTrueAltitude: TfrmFilter
        Left = 0
        Top = 0
        Width = 200
        Height = 50
        Align = alLeft
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        inherited gbx: TGroupBox
          Width = 200
          Caption = #1040#1083#1100#1090#1080#1090#1091#1076#1072' '#1088#1086#1090#1086#1088#1072', '#1084
          ParentFont = False
          inherited cbxActiveObject: TComboEdit
            Width = 185
            ParentFont = False
            OnButtonClick = frmFilterTrueAltitudecbxActiveObjectButtonClick
          end
        end
      end
      object GroupBox9: TGroupBox
        Left = 400
        Top = 0
        Width = 200
        Height = 50
        Align = alLeft
        Caption = #1060#1072#1082#1090#1080#1095#1077#1089#1082#1072#1103' '#1089#1090#1086#1080#1084#1086#1089#1090#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        DesignSize = (
          200
          50)
        object edtFactCost: TEdit
          Left = 8
          Top = 22
          Width = 185
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
        end
      end
    end
    object pnlCategory: TPanel
      Left = 2
      Top = 15
      Width = 997
      Height = 57
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      inline frmFilterCategory: TfrmFilter
        Left = 0
        Top = 0
        Width = 200
        Height = 57
        Align = alLeft
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        inherited gbx: TGroupBox
          Width = 200
          Height = 57
          Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1089#1082#1074#1072#1078#1080#1085#1099
          ParentFont = False
          DesignSize = (
            200
            57)
          inherited cbxActiveObject: TComboEdit
            Width = 185
            ParentFont = False
          end
        end
      end
      inline frmFilterTrueResult: TfrmFilter
        Left = 600
        Top = 0
        Width = 200
        Height = 57
        Align = alLeft
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        inherited gbx: TGroupBox
          Width = 200
          Height = 57
          Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090' '#1073#1091#1088#1077#1085#1080#1103
          ParentFont = False
          inherited cbxActiveObject: TComboEdit
            Width = 185
          end
        end
      end
      object GroupBox6: TGroupBox
        Left = 200
        Top = 0
        Width = 200
        Height = 57
        Align = alLeft
        Caption = #1043#1083#1091#1073#1080#1085#1072' '#1079#1072#1073#1086#1103', '#1084
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        DesignSize = (
          200
          57)
        object edtTrueDepth: TEdit
          Left = 8
          Top = 22
          Width = 185
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
        end
      end
      inline frmFilterTrueAge: TfrmFilter
        Left = 400
        Top = 0
        Width = 200
        Height = 57
        Align = alLeft
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        inherited gbx: TGroupBox
          Width = 200
          Height = 57
          Caption = #1042#1086#1079#1088#1072#1089#1090' '#1087#1086#1088#1086#1076' '#1085#1072' '#1079#1072#1073#1086#1077
          ParentFont = False
          inherited cbxActiveObject: TComboEdit
            Width = 185
            ParentFont = False
          end
        end
      end
    end
  end
  object gbxHistory: TGroupBox
    Left = 0
    Top = 177
    Width = 1001
    Height = 239
    Align = alClient
    Caption = #1048#1089#1090#1086#1088#1080#1103' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1080#1093' '#1087#1086#1082#1072#1079#1072#1090#1077#1083#1077#1081
    TabOrder = 1
    object lwDynamics: TListView
      Left = 2
      Top = 49
      Width = 997
      Height = 188
      Align = alClient
      Columns = <
        item
          Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
          Width = -2
          WidthType = (
            -2)
        end
        item
          Caption = #1047#1072#1073#1086#1081
          Width = -2
          WidthType = (
            -2)
        end
        item
          Caption = #1042#1086#1079#1088#1072#1089#1090
          Width = -2
          WidthType = (
            -2)
        end
        item
          Caption = #1056#1077#1079'.'#1073#1091#1088'.'
          Width = -2
          WidthType = (
            -2)
        end
        item
          Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
          Width = -2
          WidthType = (
            -2)
        end
        item
          Caption = #1042#1077#1088#1089#1080#1103
          Width = -2
          WidthType = (
            -2)
        end>
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
    end
    object pnlButtons: TPanel
      Left = 2
      Top = 15
      Width = 997
      Height = 34
      Align = alTop
      BevelOuter = bvNone
      Color = 12909538
      TabOrder = 1
      object btnEdit: TSpeedButton
        Left = 7
        Top = 2
        Width = 169
        Height = 22
        Action = actnAddHistoryItem
        Flat = True
      end
      object btnFinishEdit: TSpeedButton
        Left = 347
        Top = 2
        Width = 169
        Height = 22
        Action = actnFinishEdit
        Flat = True
      end
      object btnStartEdit: TSpeedButton
        Left = 177
        Top = 2
        Width = 169
        Height = 22
        Action = actnStartEdit
        Flat = True
      end
      object btnDelete: TSpeedButton
        Left = 518
        Top = 2
        Width = 169
        Height = 22
        Action = actnDeleteHistoryItem
        Flat = True
      end
    end
  end
  object actnlstEditHistory: TActionList
    Left = 376
    Top = 8
    object actnStartEdit: TAction
      Caption = #1053#1072#1095#1072#1090#1100' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
      OnExecute = actnStartEditExecute
      OnUpdate = actnStartEditUpdate
    end
    object actnFinishEdit: TAction
      Caption = #1047#1072#1074#1077#1088#1096#1080#1090#1100' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
      OnExecute = actnFinishEditExecute
      OnUpdate = actnFinishEditUpdate
    end
    object actnAddHistoryItem: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnExecute = actnAddHistoryItemExecute
      OnUpdate = actnAddHistoryItemUpdate
    end
    object actnDeleteHistoryItem: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnExecute = actnDeleteHistoryItemExecute
      OnUpdate = actnDeleteHistoryItemUpdate
    end
  end
end
