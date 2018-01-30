object frmLoad: TfrmLoad
  Left = 640
  Top = 405
  BorderStyle = bsDialog
  Caption = #1055#1086#1078#1072#1083#1091#1081#1089#1090#1072', '#1087#1086#1076#1086#1078#1076#1080#1090#1077
  ClientHeight = 76
  ClientWidth = 399
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
    Top = 0
    Width = 399
    Height = 57
    Align = alTop
    AutoSize = False
    CommonAVI = aviFindFile
    StopFrame = 8
    Visible = False
  end
  object prgb: TProgressBar
    Left = 0
    Top = 57
    Width = 399
    Height = 19
    Align = alClient
    Max = 30
    Step = 1
    TabOrder = 1
  end
end
