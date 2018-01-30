object frmResources: TfrmResources
  Left = 0
  Top = 0
  Width = 659
  Height = 493
  TabOrder = 0
  object Splitter1: TSplitter
    Left = 201
    Top = 0
    Height = 493
  end
  object gbxProperties: TGroupBox
    Left = 204
    Top = 0
    Width = 455
    Height = 493
    Align = alClient
    Caption = #1056#1077#1076#1072#1082#1090#1086#1088
    TabOrder = 0
    object Label5: TLabel
      Left = 2
      Top = 252
      Width = 95
      Height = 13
      Caption = #1044#1072#1090#1072' '#1091#1090#1074#1077#1088#1078#1076#1077#1085#1080#1103
    end
    object tlbrEdit: TToolBar
      Left = 2
      Top = 462
      Width = 451
      Height = 29
      Align = alBottom
      Caption = 'tlbrEdit'
      Flat = True
      TabOrder = 0
      object tlbtnAdd: TToolButton
        Left = 0
        Top = 0
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        Down = True
        ImageIndex = 0
      end
      object tlbtnBack: TToolButton
        Left = 23
        Top = 0
        Caption = #1042#1077#1088#1085#1091#1090#1100' '#1087#1088#1077#1078#1085#1077#1077
        ImageIndex = 1
      end
      object ToolButton4: TToolButton
        Left = 46
        Top = 0
        Width = 8
        Caption = 'ToolButton4'
        ImageIndex = 2
        Style = tbsSeparator
      end
      object tlbtnClear: TToolButton
        Left = 54
        Top = 0
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100
        ImageIndex = 4
      end
    end
    object pgctl: TPageControl
      Left = 2
      Top = 15
      Width = 451
      Height = 447
      ActivePage = tshResourceEditor
      Align = alClient
      Style = tsFlatButtons
      TabOrder = 1
      object tshResourceEditor: TTabSheet
        Caption = #1056#1077#1089#1091#1088#1089#1099
        object Label4: TLabel
          Left = 4
          Top = 192
          Width = 48
          Height = 13
          Caption = #1047#1085#1072#1095#1077#1085#1080#1077
        end
        object Bevel1: TBevel
          Left = 0
          Top = 176
          Width = 374
          Height = 73
        end
        inline cmplxFluidType: TfrmComplexCombo
          Left = 3
          Top = 12
          Width = 367
          Height = 46
          TabOrder = 0
          inherited btnShowAdditional: TButton
            Left = 339
          end
          inherited cmbxName: TComboBox
            Width = 333
            OnChange = cmplxFluidTypecmbxNameChange
          end
        end
        inline cmplxResourceType: TfrmComplexCombo
          Left = 3
          Top = 122
          Width = 367
          Height = 46
          TabOrder = 1
          inherited btnShowAdditional: TButton
            Left = 339
          end
          inherited cmbxName: TComboBox
            Width = 333
            OnChange = cmplxResourceTypecmbxNameChange
          end
        end
        inline cmplxResourceCategory: TfrmComplexCombo
          Left = 3
          Top = 66
          Width = 367
          Height = 46
          TabOrder = 2
          inherited btnShowAdditional: TButton
            Left = 339
          end
          inherited cmbxName: TComboBox
            Width = 333
            OnChange = cmplxResourceCategorycmbxNameChange
          end
        end
        object edtValue: TEdit
          Left = 4
          Top = 210
          Width = 361
          Height = 21
          TabOrder = 3
          OnChange = edtValueChange
        end
      end
    end
  end
  inline frmVersions: TfrmVersions
    Left = 0
    Top = 0
    Width = 201
    Height = 493
    Align = alLeft
    TabOrder = 1
    inherited gbxLeft: TGroupBox
      Width = 201
      Height = 493
      Caption = #1056#1077#1089#1091#1088#1089#1099
      inherited tlbr: TToolBar
        Top = 436
        Width = 197
      end
      inherited trw: TTreeView
        Width = 197
        Height = 421
        OnChange = trwResourcesChange
        OnChanging = trwResourcesChanging
      end
    end
  end
end
