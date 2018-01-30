object frmProgressBar: TfrmProgressBar
  Left = 340
  Top = 262
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = #1055#1086#1076#1086#1078#1076#1080#1090#1077'...'
  ClientHeight = 80
  ClientWidth = 275
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
  object Lbl: TLabel
    Left = 0
    Top = 65
    Width = 3
    Height = 13
    Alignment = taCenter
  end
  object anmWait: TAnimate
    Left = 0
    Top = 0
    Width = 272
    Height = 60
    AutoSize = False
    CommonAVI = aviCopyFile
    StopFrame = 26
  end
end
