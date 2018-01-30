object frmLicenseZoneConditions: TfrmLicenseZoneConditions
  Left = 0
  Top = 0
  Width = 836
  Height = 437
  TabOrder = 0
  object splt: TSplitter
    Left = 315
    Top = 0
    Height = 437
  end
  inline frmLicenseConditionTree: TfrmLicenseConditionTree
    Left = 0
    Top = 0
    Width = 315
    Height = 437
    Align = alLeft
    TabOrder = 0
    inherited gbxSearch: TGroupBox
      Width = 315
      DesignSize = (
        315
        49)
      inherited edtSearch: TEdit
        Width = 217
      end
      inherited btnNext: TButton
        Left = 232
      end
    end
    inherited trwConditions: TTreeView
      Width = 315
      Height = 388
      HideSelection = False
      OnChange = frmLicenseConditionTreetrwConditionsChange
    end
  end
  inline frmLicenseZoneConditionEditFrame1: TfrmLicenseZoneConditionEditFrame
    Left = 318
    Top = 0
    Width = 518
    Height = 437
    Align = alClient
    TabOrder = 1
    inherited gbxCondition: TGroupBox
      Width = 518
      Height = 437
      inherited Bevel1: TBevel
        Width = 514
      end
      inherited frmLicensePeriod1: TfrmLicensePeriod
        Width = 514
        inherited ToolBar1: TToolBar
          Width = 514
        end
      end
      inherited stConditionType: TStaticText
        Width = 514
      end
      inherited pnlVolume: TPanel
        Width = 514
      end
      inherited pnlRelativeDate: TPanel
        Width = 514
      end
    end
  end
end
