object frmInfoLayerSlotting: TfrmInfoLayerSlotting
  Left = 0
  Top = 0
  Width = 443
  Height = 406
  Align = alTop
  TabOrder = 0
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 443
    Height = 60
    Align = alTop
    Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1089#1083#1086#1102
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    DesignSize = (
      443
      60)
    object Label1: TLabel
      Left = 16
      Top = 27
      Width = 81
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      Caption = #1053#1086#1084#1077#1088' '#1089#1083#1086#1103':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 554
      Top = 27
      Width = 83
      Height = 13
      Anchors = [akTop, akRight]
      Caption = #1052#1086#1097#1085#1086#1089#1090#1100' '#1089#1083#1086#1103':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 378
      Top = 27
      Width = 85
      Height = 13
      Anchors = [akTop, akRight]
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1089#1083#1086#1103':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 218
      Top = 27
      Width = 67
      Height = 13
      Anchors = [akTop, akRight]
      Caption = #1053#1072#1095#1072#1083#1086' '#1089#1083#1086#1103':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object cbxDummy: TCheckBox
      Left = 738
      Top = 27
      Width = 113
      Height = 17
      Anchors = [akTop, akRight]
      Caption = #1060#1080#1082#1090#1080#1074#1085#1099#1081' '#1089#1083#1086#1081
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = cbxDummyClick
    end
    object edtNumber: TRxSpinEdit
      Left = 126
      Top = 25
      Width = 80
      Height = 21
      MaxValue = 100.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Anchors = [akTop, akRight]
      ParentFont = False
      TabOrder = 1
    end
    object edtBegin: TRxSpinEdit
      Left = 289
      Top = 25
      Width = 80
      Height = 21
      ValueType = vtFloat
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Anchors = [akTop, akRight]
      ParentFont = False
      TabOrder = 2
    end
    object edtEnd: TRxSpinEdit
      Left = 467
      Top = 25
      Width = 80
      Height = 21
      ValueType = vtFloat
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Anchors = [akTop, akRight]
      ParentFont = False
      TabOrder = 3
    end
    object edtCapacity: TRxSpinEdit
      Left = 643
      Top = 25
      Width = 80
      Height = 21
      ValueType = vtFloat
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Anchors = [akTop, akRight]
      ParentFont = False
      TabOrder = 4
    end
  end
  inline frmRockSample: TfrmRockSample
    Left = 0
    Top = 60
    Width = 443
    Height = 346
    Align = alClient
    TabOrder = 1
    inherited GroupBox1: TGroupBox
      Height = 346
      inherited pnl: TPanel
        Height = 329
        inherited grdRockSamples: TStringGrid
          Height = 329
        end
      end
      inherited tbr: TToolBar
        Height = 329
        inherited ToolButton2: TToolButton
          Wrap = False
        end
      end
    end
  end
end
