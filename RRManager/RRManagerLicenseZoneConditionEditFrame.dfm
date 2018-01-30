object frmLicenseZoneConditionEditFrame: TfrmLicenseZoneConditionEditFrame
  Left = 0
  Top = 0
  Width = 498
  Height = 486
  TabOrder = 0
  object gbxCondition: TGroupBox
    Left = 0
    Top = 0
    Width = 498
    Height = 486
    Align = alClient
    Caption = #1059#1089#1083#1086#1074#1080#1077' ('#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077')'
    TabOrder = 0
    object Bevel1: TBevel
      Left = 2
      Top = 144
      Width = 494
      Height = 14
      Align = alTop
      Shape = bsTopLine
    end
    inline frmLicensePeriod1: TfrmLicensePeriod
      Left = 2
      Top = 89
      Width = 494
      Height = 55
      Align = alTop
      TabOrder = 0
      inherited lblPeriod: TLabel
        Width = 128
        Caption = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1087#1086' '#1074#1088#1077#1084#1077#1085#1080
      end
      inherited ToolBar1: TToolBar
        Top = 27
        Width = 494
        Height = 28
        inherited dtpStartDate: TDateEdit
          BorderStyle = bsNone
          OnButtonClick = frmLicensePeriod1dtpStartDateButtonClick
          OnKeyPress = frmLicensePeriod1dtpStartDateKeyPress
        end
        inherited dtpFinDate: TDateEdit
          BorderStyle = bsNone
          OnButtonClick = frmLicensePeriod1dtpFinDateButtonClick
          OnKeyPress = frmLicensePeriod1dtpFinDateKeyPress
        end
      end
    end
    object stConditionType: TStaticText
      Left = 2
      Top = 15
      Width = 494
      Height = 74
      Align = alTop
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object pnlVolume: TPanel
      Left = 2
      Top = 158
      Width = 494
      Height = 115
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object edtMinVolume: TLabeledEdit
        Left = 8
        Top = 24
        Width = 233
        Height = 21
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        EditLabel.Width = 156
        EditLabel.Height = 13
        EditLabel.Caption = #1054#1073#1098#1077#1084' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' ('#1085#1077' '#1084#1077#1085#1077#1077')'
        TabOrder = 0
        OnKeyPress = edtMinVolumeKeyPress
      end
      object edtMaxVolume: TLabeledEdit
        Left = 8
        Top = 72
        Width = 233
        Height = 21
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        EditLabel.Width = 154
        EditLabel.Height = 13
        EditLabel.Caption = #1054#1073#1098#1077#1084' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' ('#1085#1077' '#1073#1086#1083#1077#1077')'
        TabOrder = 1
        OnKeyPress = edtMaxVolumeKeyPress
      end
      object stMeasureUnit: TStaticText
        Left = 247
        Top = 24
        Width = 170
        Height = 21
        AutoSize = False
        BevelInner = bvNone
        BevelKind = bkFlat
        TabOrder = 2
      end
    end
    object pnlRelativeDate: TPanel
      Left = 2
      Top = 273
      Width = 494
      Height = 72
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
      object stDateMeasureUnit: TStaticText
        Left = 247
        Top = 24
        Width = 170
        Height = 21
        AutoSize = False
        BevelInner = bvNone
        BevelKind = bkFlat
        TabOrder = 0
      end
      object edtRelativeDate: TLabeledEdit
        Left = 8
        Top = 24
        Width = 233
        Height = 21
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        EditLabel.Width = 228
        EditLabel.Height = 13
        EditLabel.Caption = #1054#1090#1085#1086#1089#1080#1090#1077#1083#1100#1085#1099#1081' '#1089#1088#1086#1082' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' ('#1085#1077' '#1084#1077#1085#1077#1077')'
        TabOrder = 1
        OnKeyPress = edtRelativeDateKeyPress
      end
    end
  end
end
