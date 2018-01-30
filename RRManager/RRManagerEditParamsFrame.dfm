object frmParams: TfrmParams
  Left = 0
  Top = 0
  Width = 983
  Height = 691
  TabOrder = 0
  object Splitter1: TSplitter
    Left = 250
    Top = 0
    Height = 691
  end
  object gbxProperties: TGroupBox
    Left = 253
    Top = 0
    Width = 730
    Height = 691
    Align = alClient
    Caption = #1056#1077#1076#1072#1082#1090#1086#1088
    TabOrder = 1
    object pnlParams: TPanel
      Left = 2
      Top = 15
      Width = 726
      Height = 674
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        726
        674)
      object lblValue: TLabel
        Left = 9
        Top = 110
        Width = 48
        Height = 13
        Caption = #1047#1085#1072#1095#1077#1085#1080#1077
      end
      object Bevel1: TBevel
        Left = 8
        Top = 480
        Width = 710
        Height = 13
        Anchors = [akLeft, akTop, akRight]
      end
      object Label2: TLabel
        Left = 8
        Top = 320
        Width = 118
        Height = 13
        Caption = #1051#1080#1094#1077#1085#1079#1080#1086#1085#1085#1099#1081' '#1091#1095#1072#1089#1090#1086#1082
      end
      object TLabel
        Left = 143
        Top = 320
        Width = 3
        Height = 13
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblOrganization: TLabel
        Left = 136
        Top = 320
        Width = 3
        Height = 13
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      inline cmplxParam: TfrmComplexCombo
        Left = 3
        Top = 31
        Width = 716
        Height = 46
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        DesignSize = (
          716
          46)
        inherited btnShowAdditional: TButton
          Left = 689
        end
        inherited cmbxName: TComboBox
          Width = 679
          OnChange = cmplxParamcmbxNameChange
          OnSelect = cmplxParamcmbxNameSelect
        end
      end
      inline cmplxFluidType: TfrmComplexCombo
        Left = 4
        Top = 150
        Width = 716
        Height = 46
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 4
        DesignSize = (
          716
          46)
        inherited btnShowAdditional: TButton
          Left = 689
        end
        inherited cmbxName: TComboBox
          Width = 679
          OnChange = cmplxFluidTypecmbxNameChange
          OnSelect = cmplxFluidTypecmbxNameSelect
        end
      end
      object edtValue: TEdit
        Left = 8
        Top = 128
        Width = 249
        Height = 21
        TabOrder = 2
        OnChange = edtValueChange
        OnKeyPress = edtValueKeyPress
      end
      object btnSave: TButton
        Left = 8
        Top = 447
        Width = 181
        Height = 25
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
        TabOrder = 9
        OnClick = btnSaveClick
      end
      inline cmplxReserveCategory: TfrmComplexCombo
        Left = 4
        Top = 214
        Width = 716
        Height = 46
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 5
        DesignSize = (
          716
          46)
        inherited btnShowAdditional: TButton
          Left = 689
        end
        inherited cmbxName: TComboBox
          Width = 679
          OnChange = cmplxReserveCategorycmbxNameChange
          OnSelect = cmplxReserveCategorycmbxNameSelect
        end
      end
      inline cmplxRelationship: TfrmComplexCombo
        Left = 3
        Top = 271
        Width = 716
        Height = 46
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 6
        DesignSize = (
          716
          46)
        inherited btnShowAdditional: TButton
          Left = 689
        end
        inherited cmbxName: TComboBox
          Width = 679
          OnChange = cmplxRelationshipcmbxNameChange
        end
      end
      inline cmplxReservesValueType: TfrmComplexCombo
        Left = 3
        Top = 378
        Width = 716
        Height = 46
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 8
        Visible = False
        DesignSize = (
          716
          46)
        inherited btnShowAdditional: TButton
          Left = 689
        end
        inherited cmbxName: TComboBox
          Width = 679
          OnChange = cmplxReservesValueTypecmbxNameChange
        end
      end
      object cmbxLicenseZone: TComboBox
        Left = 8
        Top = 336
        Width = 677
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 7
        OnChange = cmbxLicenseZoneChange
      end
      object chbxUseInterval: TCheckBox
        Left = 8
        Top = 88
        Width = 257
        Height = 17
        Caption = #1076#1080#1072#1087#1072#1079#1086#1085' '#1079#1085#1072#1095#1077#1085#1080#1081
        TabOrder = 1
        OnClick = chbxUseIntervalClick
      end
      object edtNextValue: TEdit
        Left = 263
        Top = 128
        Width = 453
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Enabled = False
        TabOrder = 3
        OnChange = edtValueChange
        OnKeyPress = edtNextValueKeyPress
      end
    end
  end
  inline frmVersions1: TfrmVersions
    Left = 0
    Top = 0
    Width = 250
    Height = 691
    Align = alLeft
    TabOrder = 0
    inherited gbxLeft: TGroupBox
      Width = 250
      Height = 691
      inherited tlbr: TToolBar
        Top = 634
        Width = 246
        TabOrder = 1
      end
      inherited trw: TTreeView
        Width = 246
        Height = 619
        TabOrder = 0
        OnChange = trwParamsChange
        OnChanging = trwParamsChanging
      end
    end
    inherited actnLst: TActionList
      inherited AddSubElement: TAction
        OnExecute = frmVersions1AddSubElementExecute
      end
    end
  end
end
