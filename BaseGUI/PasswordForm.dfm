object frmPassword: TfrmPassword
  Left = 309
  Top = 160
  HelpContext = 3
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1042#1074#1077#1076#1080#1090#1077' '#1080#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' '#1080' '#1087#1072#1088#1086#1083#1100
  ClientHeight = 207
  ClientWidth = 303
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblUserName: TLabel
    Left = 5
    Top = 55
    Width = 96
    Height = 13
    Caption = #1048#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
  end
  object lblPassword: TLabel
    Left = 5
    Top = 85
    Width = 38
    Height = 13
    Caption = #1055#1072#1088#1086#1083#1100
  end
  object imgPassportIcon: TImage
    Left = 5
    Top = 5
    Width = 36
    Height = 36
    Center = True
    Stretch = True
    Transparent = True
  end
  object lblTitle: TLabel
    Left = 55
    Top = 15
    Width = 223
    Height = 16
    Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1087#1088#1072#1074' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edtUserName: TEdit
    Left = 113
    Top = 50
    Width = 184
    Height = 21
    TabOrder = 0
    OnKeyDown = edtUserNameKeyDown
  end
  object btnOk: TButton
    Left = 112
    Top = 110
    Width = 75
    Height = 25
    Action = actnEnter
    Caption = 'OK'
    Default = True
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 220
    Top = 110
    Width = 75
    Height = 25
    Action = actnExit
    Cancel = True
    TabOrder = 3
  end
  object edtPassword: TEdit
    Left = 113
    Top = 80
    Width = 183
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
    OnKeyDown = edtPasswordKeyDown
    OnKeyPress = edtPasswordKeyPress
  end
  object btnChangePassword: TButton
    Left = 5
    Top = 110
    Width = 100
    Height = 25
    Caption = #1057#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1086#1083#1100
    TabOrder = 4
    Visible = False
  end
  object anmWait: TAnimate
    Left = 8
    Top = 144
    Width = 289
    Height = 41
    AutoSize = False
    CommonAVI = aviFindComputer
    StopFrame = 8
    Visible = False
  end
  object sbr: TStatusBar
    Left = 0
    Top = 188
    Width = 303
    Height = 19
    AutoHint = True
    Panels = <>
    ParentShowHint = False
    ShowHint = True
    SimplePanel = True
  end
  object actnList: TActionList
    Left = 264
    Top = 8
    object actnEnter: TAction
      Caption = 'actnEnter'
      OnExecute = actnEnterExecute
      OnUpdate = actnEnterUpdate
    end
    object actnExit: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      OnExecute = actnExitExecute
      OnUpdate = actnExitUpdate
    end
  end
end
