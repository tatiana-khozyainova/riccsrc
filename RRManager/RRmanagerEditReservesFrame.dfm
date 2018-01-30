object frmReserves: TfrmReserves
  Left = 0
  Top = 0
  Width = 793
  Height = 604
  TabOrder = 0
  object Splitter1: TSplitter
    Left = 201
    Top = 0
    Height = 604
  end
  object gbxProperties: TGroupBox
    Left = 204
    Top = 0
    Width = 589
    Height = 604
    Align = alClient
    Caption = #1056#1077#1076#1072#1082#1090#1086#1088
    TabOrder = 0
    object pgctl: TPageControl
      Left = 2
      Top = 15
      Width = 585
      Height = 587
      ActivePage = tshReserveEditor
      Align = alClient
      Style = tsFlatButtons
      TabOrder = 0
      object tshReserveEditor: TTabSheet
        Caption = #1047#1072#1087#1072#1089#1099
        DesignSize = (
          577
          556)
        object Bevel1: TBevel
          Left = 7
          Top = 328
          Width = 441
          Height = 57
        end
        object Label4: TLabel
          Left = 13
          Top = 336
          Width = 48
          Height = 13
          Caption = #1047#1085#1072#1095#1077#1085#1080#1077
        end
        object Label1: TLabel
          Left = 4
          Top = 472
          Width = 132
          Height = 39
          Caption = #1056#1072#1079#1084#1077#1088#1085#1086#1089#1090#1080':'#13#10#1075#1072#1079' - '#1084#1083#1085'. '#1084'. '#1082#1091#1073'.'#13#10#1082#1086#1085#1076#1077#1085#1089#1072#1090', '#1085#1077#1092#1090#1100' - '#1090#1099#1089'. '#1090'.'
        end
        object Label2: TLabel
          Left = 8
          Top = 280
          Width = 118
          Height = 13
          Caption = #1051#1080#1094#1077#1085#1079#1080#1086#1085#1085#1099#1081' '#1091#1095#1072#1089#1090#1086#1082
        end
        object TLabel
          Left = 136
          Top = 280
          Width = 3
          Height = 13
        end
        object lblOrganization: TLabel
          Left = 131
          Top = 280
          Width = 3
          Height = 13
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        inline cmplxFluidType: TfrmComplexCombo
          Left = 3
          Top = 12
          Width = 571
          Height = 46
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          inherited btnShowAdditional: TButton
            Left = 543
          end
          inherited cmbxName: TComboBox
            Width = 537
            OnChange = cmplxFluidTypecmbxNameChange
            OnSelect = cmplxFluidTypecmbxNameSelect
          end
        end
        inline cmplxReserveKind: TfrmComplexCombo
          Left = 3
          Top = 122
          Width = 571
          Height = 46
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          inherited btnShowAdditional: TButton
            Left = 543
          end
          inherited cmbxName: TComboBox
            Width = 537
            OnChange = cmplxReserveTypecmbxNameChange
            OnSelect = cmplxReserveKindcmbxNameSelect
          end
        end
        inline cmplxReserveCategory: TfrmComplexCombo
          Left = 3
          Top = 66
          Width = 571
          Height = 46
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          inherited btnShowAdditional: TButton
            Left = 543
          end
          inherited cmbxName: TComboBox
            Width = 537
            OnChange = cmplxReserveCategorycmbxNameChange
            OnSelect = cmplxReserveCategorycmbxNameSelect
          end
        end
        object edtValue: TEdit
          Left = 12
          Top = 354
          Width = 425
          Height = 21
          TabOrder = 3
          OnChange = edtValueChange
        end
        inline cmplxResourceType: TfrmComplexCombo
          Left = 2
          Top = 175
          Width = 572
          Height = 46
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 4
          inherited btnShowAdditional: TButton
            Left = 545
          end
          inherited cmbxName: TComboBox
            Width = 537
            OnChange = cmplxResourceTypecmbxNameChange
            OnSelect = cmplxResourceTypecmbxNameSelect
          end
        end
        object btnSave: TButton
          Left = 1
          Top = 416
          Width = 177
          Height = 25
          Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1079#1072#1087#1072#1089#1099
          TabOrder = 5
          OnClick = btnSaveClick
        end
        inline cmplxReservesValueType: TfrmComplexCombo
          Left = 2
          Top = 223
          Width = 599
          Height = 46
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 6
          DesignSize = (
            599
            46)
          inherited btnShowAdditional: TButton
            Left = 544
          end
          inherited cmbxName: TComboBox
            Width = 536
            OnChange = cmplxReservesValueTypecmbxNameChange
            OnSelect = cmplxReservesValueTypecmbxNameSelect
          end
        end
        object cmbxLicenseZone: TComboBox
          Left = 8
          Top = 296
          Width = 535
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 7
          OnChange = cmbxLicenseZoneChange
        end
      end
    end
  end
  inline frmVersions: TfrmVersions
    Left = 0
    Top = 0
    Width = 201
    Height = 604
    Align = alLeft
    TabOrder = 1
    inherited gbxLeft: TGroupBox
      Width = 201
      Height = 604
      Caption = #1047#1072#1087#1072#1089#1099
      inherited tlbr: TToolBar
        Top = 547
        Width = 197
      end
      inherited trw: TTreeView
        Width = 197
        Height = 532
        OnChange = trwReservesChange
        OnChanging = trwReservesChanging
      end
    end
    inherited actnLst: TActionList
      inherited AddVersion: TAction
        OnExecute = frmVersionsAddVersionExecute
      end
    end
  end
end
