object frmInfoObject: TfrmInfoObject
  Left = 0
  Top = 0
  Width = 435
  Height = 266
  Align = alClient
  TabOrder = 0
  object Splitter1: TSplitter
    Left = 432
    Top = 0
    Height = 266
    Align = alRight
  end
  inline frmInfoProperties: TfrmInfoProperties
    Left = 178
    Top = 0
    Width = 254
    Height = 266
    Align = alRight
    TabOrder = 0
    inherited lstInfoPropertiesWell: TListView
      Width = 254
      Height = 266
      MultiSelect = True
    end
  end
  inline frmInfoWells: TfrmInfoWells
    Left = 0
    Top = 0
    Width = 178
    Height = 266
    Align = alClient
    TabOrder = 1
    inherited tbr: TToolBar
      Height = 266
      inherited ToolButton10: TToolButton
        Wrap = False
      end
    end
    inherited Panel1: TPanel
      Width = 153
      Height = 266
      inherited tvwWells: TTreeView
        Width = 153
        Height = 266
        MultiSelect = True
        OnClick = frmInfoWellstvwWellsClick
        OnCustomDrawItem = frmInfoWellstvwWellsCustomDrawItem
        OnExpanding = frmInfoWellstvwWellsExpanding
        OnKeyUp = frmInfoWellstvwWellsKeyUp
      end
    end
  end
end
