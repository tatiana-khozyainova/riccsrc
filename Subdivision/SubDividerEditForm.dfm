object frmSubDivisionComponentEdit: TfrmSubDivisionComponentEdit
  Left = 171
  Top = 103
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Редактор свойств границы'
  ClientHeight = 545
  ClientWidth = 318
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
  inline frmSubComponentEdit1: TfrmSubComponentEdit
    Width = 318
    Height = 545
    Align = alClient
    inherited gbxProperties: TGroupBox
      Width = 318
      Height = 498
      inherited edtDepth: TEdit
        Width = 300
      end
      inherited cmbxEdgeComment: TComboBox
        Width = 300
      end
      inherited GroupBox1: TGroupBox
        Top = 421
        Width = 314
        inherited mmProperties: TMemo
          Width = 310
        end
      end
      inherited pgctl: TPageControl
        Width = 314
        inherited tshCommon: TTabSheet
          inherited cmbxStraton: TComboBox
            Width = 216
          end
          inherited cmbxNextStraton: TComboBox
            Width = 216
          end
        end
        inherited tshPlus: TTabSheet
          inherited chlbxPlus: TCheckListBox
            Width = 306
          end
          inherited cmbxFilter: TComboBox
            Width = 217
          end
        end
      end
      inherited cmbxComment: TComboBox
        Width = 300
      end
    end
    inherited pnlButtons: TPanel
      Top = 498
      Width = 318
      inherited btnCancel: TButton
        Left = 231
      end
    end
  end
end
