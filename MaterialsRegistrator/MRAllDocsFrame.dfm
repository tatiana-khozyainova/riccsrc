object frmAllDocs: TfrmAllDocs
  Left = 0
  Top = 0
  Width = 443
  Height = 270
  Align = alClient
  TabOrder = 0
  object spl1: TSplitter
    Left = 373
    Top = 0
    Height = 270
  end
  inline frmDocsByType: TfrmAllObjects
    Left = 23
    Top = 0
    Width = 350
    Height = 270
    Align = alLeft
    TabOrder = 0
    inherited GroupBox1: TGroupBox
      Width = 350
      inherited lstAllObjects: TListBox
        Width = 346
      end
    end
    inherited Panel1: TPanel
      Width = 350
      Visible = False
    end
    inherited frmButtons: TfrmButtons
      Width = 350
      Visible = False
      inherited tlbr: TToolBar
        Width = 350
        Visible = False
      end
    end
  end
  object tlb: TToolBar
    Left = 0
    Top = 0
    Width = 23
    Height = 270
    Align = alLeft
    AutoSize = True
    Caption = 'tlb'
    TabOrder = 1
    object btn: TToolButton
      Left = 0
      Top = 2
      Caption = 'btn'
      ImageIndex = 0
      Wrap = True
    end
  end
end
