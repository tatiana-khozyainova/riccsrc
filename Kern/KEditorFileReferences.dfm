object frmEditorReferences: TfrmEditorReferences
  Left = 530
  Top = 255
  Width = 691
  Height = 506
  Caption = 'frmEditorReferences'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inline frmLstFiles: TfrmLstFiles
    Left = 0
    Top = 0
    Width = 683
    Height = 472
    Align = alClient
    TabOrder = 0
    inherited pnl1: TPanel
      Top = 421
      Width = 683
      inherited btnSave: TBitBtn
        Left = 501
      end
      inherited btnCancel: TBitBtn
        Left = 589
      end
    end
    inherited grp2: TGroupBox
      Top = 369
      Width = 683
      inherited btnSetPath: TSpeedButton
        Left = 625
      end
      inherited btnClear: TSpeedButton
        Left = 652
      end
      inherited edtPath: TEdit
        Width = 613
      end
    end
    inherited pnl2: TPanel
      Width = 683
      Height = 341
      inherited spl1: TSplitter
        Height = 341
      end
      inherited spl2: TSplitter
        Height = 341
      end
      inherited grp1: TGroupBox
        Height = 341
        inherited lstFiles: TListBox
          Height = 324
        end
      end
      inherited grp3: TGroupBox
        Width = 327
        Height = 341
        inherited lstAllFilesByWell: TListBox
          Width = 323
          Height = 324
        end
      end
      inherited pnlButtons: TPanel
        Height = 341
      end
    end
    inherited tlb1: TToolBar
      Top = 341
      Width = 683
    end
  end
end
