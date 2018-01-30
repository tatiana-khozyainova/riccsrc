object frmBasketView: TfrmBasketView
  Left = 187
  Top = 281
  Width = 787
  Height = 540
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inline frmBasket: TfrmBasket
    Left = 0
    Top = 0
    Width = 779
    Height = 513
    Align = alClient
    TabOrder = 0
    inherited gbxAll: TGroupBox
      Width = 779
      Height = 472
      inherited pnlTop: TPanel
        Width = 775
        inherited tlbr: TToolBar
          Width = 775
          inherited cmbxType: TComboBox
            Width = 298
          end
          inherited ToolButton1: TToolButton
            Left = 298
          end
        end
      end
      inherited lwBasket: TListView
        Width = 775
        Height = 413
      end
    end
    inherited pnlButtons: TPanel
      Top = 472
      Width = 779
      inherited btnClose: TButton
        Left = 700
      end
    end
  end
end
