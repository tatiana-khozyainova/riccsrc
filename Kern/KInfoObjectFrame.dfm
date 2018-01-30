object frmInfoObject: TfrmInfoObject
  Left = 0
  Top = 0
  Width = 443
  Height = 270
  Align = alClient
  TabOrder = 0
  object Splitter1: TSplitter
    Left = 186
    Top = 0
    Height = 270
    Align = alRight
  end
  inline frmInfoProperties: TfrmInfoProperties
    Left = 189
    Top = 0
    Width = 254
    Height = 270
    Align = alRight
    TabOrder = 0
    inherited lstInfoPropertiesWell: TListView
      Height = 270
    end
  end
  inline frmInfoSlottings: TfrmInfoSlottings
    Left = 0
    Top = 0
    Width = 186
    Height = 270
    Align = alClient
    TabOrder = 1
    inherited tbSlloting: TToolBar
      Height = 270
    end
    inherited Panel1: TPanel
      Width = 161
      Height = 270
      inherited tvwWells: TTreeView
        Width = 161
        Height = 81
        OnClick = frmInfoSlottingstvwWellsClick
        OnGetImageIndex = frmInfoSlottingstvwWellsGetImageIndex
      end
      inherited tb: TToolBar
        Top = 81
        Width = 161
        Height = 189
        inherited ToolButton5: TToolButton
          Wrap = True
        end
        inherited ToolButton1: TToolButton
          Left = 0
          Top = 38
          Wrap = True
        end
        inherited ToolButton2: TToolButton
          Left = 0
          Top = 74
          Wrap = True
        end
        inherited ToolButton3: TToolButton
          Left = 0
          Top = 110
        end
        inherited ToolButton4: TToolButton
          Left = 0
          Top = 110
          Wrap = True
        end
        inherited ToolButton7: TToolButton
          Left = 0
          Top = 151
        end
        inherited ToolButton6: TToolButton
          Left = 152
          Top = 151
        end
      end
    end
  end
end
