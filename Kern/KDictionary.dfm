object frmListWords: TfrmListWords
  Left = 494
  Top = 200
  BorderStyle = bsNone
  Caption = 'frmListWords'
  ClientHeight = 121
  ClientWidth = 310
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inline frmDictionary: TfrmDictionary
    Left = 0
    Top = 0
    Width = 310
    Height = 121
    Align = alClient
    TabOrder = 0
    inherited lstAllWords: TListBox
      Width = 310
      Height = 89
      Font.Height = -17
      ItemHeight = 17
    end
    inherited frmButtons: TfrmButtons
      Top = 89
      Width = 310
      inherited tlbr: TToolBar
        Width = 310
      end
    end
  end
end
