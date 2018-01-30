object frmCoreWarehouse: TfrmCoreWarehouse
  Left = 0
  Top = 0
  Width = 974
  Height = 630
  TabOrder = 0
  inline frmObjectSelect: TfrmObjectSelect
    Left = 0
    Top = 0
    Width = 193
    Height = 630
    Align = alLeft
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    inherited pnlLeft: TPanel
      Width = 193
      Height = 630
      inherited lswSearch: TListView
        Width = 189
        Height = 386
      end
      inherited pnlButtons: TPanel
        Top = 482
        Width = 189
        inherited prg: TProgressBar
          Width = 189
        end
      end
      inherited pnlSearch: TPanel
        Width = 189
        inherited spdbtnDeselectAll: TSpeedButton
          Width = 186
        end
        inherited edtName: TEdit
          Width = 188
        end
      end
    end
  end
  inline frmCoreRegistratorFrame: TfrmCoreRegistratorFrame
    Left = 193
    Top = 0
    Width = 781
    Height = 630
    Align = alClient
    TabOrder = 1
    inherited Splitter1: TSplitter
      Left = 517
      Height = 630
    end
    inherited frmButtons: TfrmButtons
      Height = 630
      inherited tlbr: TToolBar
        Height = 630
      end
    end
    inherited trwCoreIntervals: TTreeView
      Width = 468
      Height = 630
    end
    inherited frmWellSlottingInfoQuickView1: TfrmWellSlottingInfoQuickView
      Left = 520
      Height = 630
      inherited lwProperties: TListView
        Height = 630
      end
    end
  end
end
