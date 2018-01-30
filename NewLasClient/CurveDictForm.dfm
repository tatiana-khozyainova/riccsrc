object frmCurveDict: TfrmCurveDict
  Left = 296
  Top = 120
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1082#1088#1080#1074#1099#1093
  ClientHeight = 400
  ClientWidth = 588
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    588
    400)
  PixelsPerInch = 96
  TextHeight = 13
  object lblInput: TLabel
    Left = 80
    Top = 16
    Width = 135
    Height = 13
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1082#1088#1080#1074#1086#1081':'
  end
  object edtInput: TEdit
    Left = 224
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'edtInput'
    OnChange = edtInputChange
  end
  object strngrdCurves: TStringGrid
    Left = 8
    Top = 40
    Width = 569
    Height = 353
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 3
    FixedCols = 0
    TabOrder = 1
  end
  object MainMenu: TMainMenu
    Left = 16
    Top = 360
    object file1: TMenuItem
      Caption = #1060#1072#1081#1083
    end
  end
  object actlst: TActionList
    Left = 8
    object actLoadCurves: TAction
      Caption = 'actLoadCurves'
      OnExecute = FormShow
    end
    object actFind: TAction
      Caption = 'actFind'
      OnExecute = edtInputChange
    end
  end
end
