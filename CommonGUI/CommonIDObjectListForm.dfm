object frmIDObjectList: TfrmIDObjectList
  Left = 106
  Top = 166
  Width = 638
  Height = 448
  Caption = #1056#1077#1076#1072#1082#1094#1080#1103' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1086#1074
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 368
    Width = 622
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object btnClose: TButton
      Left = 768
      Top = 8
      Width = 75
      Height = 25
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ModalResult = 2
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 768
      Top = 8
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
      Visible = False
    end
    object btnOk: TButton
      Left = 688
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 2
      Visible = False
    end
  end
  inline frmIDObjectListFrame: TfrmIDObjectListFrame
    Left = 0
    Top = 0
    Width = 622
    Height = 368
    Align = alClient
    TabOrder = 1
    inherited frmButtons1: TfrmButtons
      Height = 368
      inherited tlbr: TToolBar
        Height = 368
      end
    end
    inherited lwObjects: TListView
      Width = 586
      Height = 368
      OnDblClick = frmIDObjectListFramelwObjectsDblClick
      OnMouseDown = frmIDObjectListFramelwObjectsMouseDown
    end
  end
end
