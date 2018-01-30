object frmEditAll: TfrmEditAll
  Left = 20
  Top = 496
  Width = 1032
  Height = 776
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inline frmEditSubDivision1: TfrmEditSubDivision
    Left = 0
    Top = 0
    Width = 1024
    Height = 749
    Align = alClient
    TabOrder = 0
    inherited Panel1: TPanel
      Width = 1024
      Height = 749
      inherited pnlButtons: TPanel
        Left = 796
        Height = 749
        inherited pnl: TPanel
          Top = 608
        end
        inherited frmSubComponentEdit1: TfrmSubComponentEdit
          inherited gbxProperties: TGroupBox
            inherited edtDepth: TEdit
              OnChange = nil
            end
            inherited pgctl: TPageControl
              inherited tshCommon: TTabSheet
                inherited Label2: TLabel [0]
                end
                inherited Label1: TLabel [1]
                end
                inherited cmbxNextStraton: TComboBox [2]
                end
                inherited cmbxStraton: TComboBox [3]
                  OnChange = nil
                end
              end
              inherited tshPlus: TTabSheet
                inherited cmbxFilter: TComboBox [1]
                  OnChange = nil
                end
                inherited chlbxPlus: TCheckListBox [2]
                  OnClickCheck = nil
                end
              end
            end
            inherited cmbxComment: TComboBox
              OnChange = nil
            end
          end
        end
      end
      inherited gbxSubDivision: TGroupBox
        Width = 796
        Height = 749
        inherited sgrSubDivision: TStringGrid
          Width = 792
          Height = 701
        end
        inherited pnlQuickEditButtons: TPanel
          Top = 716
          Width = 792
          inherited tlbrQuickEdit: TToolBar
            Left = 292
            Width = 499
          end
        end
      end
    end
    inherited pmnTectBlock: TPopupMenu
      inherited pmiEditTectBlock: TMenuItem
        OnClick = nil
      end
    end
  end
end
