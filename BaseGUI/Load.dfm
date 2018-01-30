object frmLoad: TfrmLoad
  Left = 1057
  Top = 459
  BorderStyle = bsDialog
  Caption = #1055#1086#1078#1072#1083#1091#1081#1089#1090#1072', '#1087#1086#1076#1086#1078#1076#1080#1090#1077
  ClientHeight = 85
  ClientWidth = 421
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object anmWait: TAnimate
    Left = 0
    Top = 4
    Width = 421
    Height = 57
    Align = alTop
    AutoSize = False
    CommonAVI = aviFindFolder
    StopFrame = 29
    Visible = False
  end
  object prgb: TProgressBar
    Left = 0
    Top = 61
    Width = 421
    Height = 24
    Align = alClient
    TabOrder = 1
  end
  object stMessage: TStaticText
    Left = 0
    Top = 0
    Width = 421
    Height = 4
    Align = alTop
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
end
