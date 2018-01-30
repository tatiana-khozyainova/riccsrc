object frmChangePassword: TfrmChangePassword
  Left = 189
  Top = 103
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1057#1084#1077#1085#1072' '#1080#1084#1077#1085#1080' '#1080' '#1087#1072#1088#1086#1083#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
  ClientHeight = 180
  ClientWidth = 300
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object lblOldUserName: TLabel
    Left = 5
    Top = 10
    Width = 133
    Height = 13
    Caption = #1057#1090#1072#1088#1086#1077' '#1080#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
  end
  object lblOldPassword: TLabel
    Left = 5
    Top = 40
    Width = 77
    Height = 13
    Caption = #1057#1090#1072#1088#1099#1081' '#1087#1072#1088#1086#1083#1100
  end
  object lblNewPassword: TLabel
    Left = 5
    Top = 100
    Width = 73
    Height = 13
    Caption = #1053#1086#1074#1099#1081' '#1087#1072#1088#1086#1083#1100
  end
  object lblConfrimNewPassword: TLabel
    Left = 5
    Top = 125
    Width = 81
    Height = 13
    Caption = #1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077
  end
  object lblNewUserName: TLabel
    Left = 5
    Top = 75
    Width = 129
    Height = 13
    Caption = #1053#1086#1074#1086#1077' '#1080#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
  end
  object edtOldUserName: TEdit
    Left = 145
    Top = 5
    Width = 150
    Height = 21
    TabOrder = 0
  end
  object edtOldPassword: TEdit
    Left = 145
    Top = 35
    Width = 150
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object edtNewPassword: TEdit
    Left = 145
    Top = 95
    Width = 150
    Height = 21
    PasswordChar = '*'
    TabOrder = 3
  end
  object edtConfirmNewPassword: TEdit
    Left = 145
    Top = 120
    Width = 150
    Height = 21
    PasswordChar = '*'
    TabOrder = 4
  end
  object edtNewUserName: TEdit
    Left = 145
    Top = 70
    Width = 150
    Height = 21
    TabOrder = 2
  end
  object btnOk: TButton
    Left = 140
    Top = 150
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 5
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 220
    Top = 150
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 6
  end
end
