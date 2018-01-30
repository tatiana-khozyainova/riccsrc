object frmEditProfile: TfrmEditProfile
  Left = 480
  Top = 280
  Width = 570
  Height = 560
  BorderIcons = [biMaximize]
  Caption = 'frmEditProfile'
  Color = clBtnFace
  Constraints.MinHeight = 560
  Constraints.MinWidth = 570
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  inline frmEditAllProfile: TFrame8
    Left = 0
    Top = -2
    Width = 545
    Height = 475
    TabOrder = 0
    inherited lstCoordProfile: TListBox
      OnClick = actSelectCoordExecute
    end
    inherited btnAddCoord: TButton
      Action = actAddCoord
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    end
    inherited btnUpCoord: TButton
      Action = actUpCoord
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
    end
    inherited btnDelCoord: TButton
      Caption = #1059#1076#1072#1083#1080#1090#1100
    end
    inherited btnAddProfile: TButton
      Action = actAddProfile
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1088#1086#1092#1080#1083#1100
    end
    inherited btnUpProfile: TButton
      Action = actUpProfile
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
    end
    inherited btnDelProfile: TButton
      Action = actDelProfile
      Caption = #1059#1076#1072#1083#1080#1090#1100
    end
    inherited rgProfile: TRadioGroup
      ItemIndex = 1
      OnClick = actCheckProfileExecute
    end
    inherited cbbSelectProfile: TComboBox
      OnClick = actSelectProfileExecute
    end
  end
  object btnSPAdd: TButton
    Left = 352
    Top = 488
    Width = 91
    Height = 25
    Action = actSPAdd
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 1
  end
  object btn1: TButton
    Left = 456
    Top = 488
    Width = 91
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 2
    OnClick = btn1Click
  end
  object actlstEditProfile: TActionList
    Left = 456
    Top = 520
    object actCheckProfile: TAction
      Caption = 'actCheckProfile'
      OnExecute = actCheckProfileExecute
    end
    object actSelectProfile: TAction
      Caption = 'actSelectProfile'
      OnExecute = actSelectProfileExecute
    end
    object actAddProfile: TAction
      Caption = 'actAddProfile'
      OnExecute = actAddProfileExecute
    end
    object actUpProfile: TAction
      Caption = 'actUpProfile'
      OnExecute = actUpProfileExecute
    end
    object actDelProfile: TAction
      Caption = 'actDelProfile'
      OnExecute = actDelProfileExecute
    end
    object actAddCoord: TAction
      Caption = 'actAddCoord'
      OnExecute = actAddCoordExecute
    end
    object actUpCoord: TAction
      Caption = 'actUpCoord'
      OnExecute = actUpCoordExecute
    end
    object actSelectCoord: TAction
      Caption = 'actSelectCoord'
      OnExecute = actSelectCoordExecute
    end
    object actDelCoord: TAction
      Caption = 'actDelCoord'
      OnExecute = actDelCoordExecute
    end
    object actSPAdd: TAction
      Caption = 'actSPAdd'
      OnExecute = actSPAddExecute
    end
  end
end
