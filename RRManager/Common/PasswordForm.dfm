object frmPassword: TfrmPassword
  Left = 343
  Top = 276
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1042#1074#1077#1076#1080#1090#1077' '#1080#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' '#1080' '#1087#1072#1088#1086#1083#1100
  ClientHeight = 140
  ClientWidth = 300
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
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
    Left = 145
    Top = 50
    Width = 150
    Height = 21
    TabOrder = 0
    OnKeyDown = edtUserNameKeyDown
  end
  object btnOk: TButton
    Left = 140
    Top = 110
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 220
    Top = 110
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object edtPassword: TEdit
    Left = 145
    Top = 80
    Width = 150
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
    OnKeyDown = edtPasswordKeyDown
  end
  object btnChangePassword: TButton
    Left = 5
    Top = 110
    Width = 100
    Height = 25
    Caption = #1057#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1086#1083#1100
    TabOrder = 4
    OnClick = btnChangePasswordClick
  end
end
