object frmNGRExport: TfrmNGRExport
  Left = 337
  Top = 297
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  ClientHeight = 96
  ClientWidth = 446
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
    Top = 58
    Width = 446
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = True
    TabOrder = 0
    DesignSize = (
      446
      38)
    object Button1: TButton
      Left = 285
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 365
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object gbxFileExport: TGroupBox
    Left = 0
    Top = 0
    Width = 446
    Height = 58
    Align = alClient
    Caption = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1072#1088#1093#1080#1074' '#1088#1072#1079#1073#1080#1074#1086#1082
    TabOrder = 1
    DesignSize = (
      446
      58)
    object edtDirectory: TDirectoryEdit
      Left = 6
      Top = 24
      Width = 434
      Height = 21
      DialogOptions = [sdAllowCreate, sdPerformCreate, sdPrompt]
      DirectInput = False
      NumGlyphs = 1
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Text = 'C:\Temp'
    end
  end
end
