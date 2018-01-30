object frmAddWord: TfrmAddWord
  Left = 971
  Top = 282
  BorderStyle = bsDialog
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1083#1086#1074#1086
  ClientHeight = 275
  ClientWidth = 366
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
  object Panel1: TPanel
    Left = 0
    Top = 220
    Width = 366
    Height = 55
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      366
      55)
    object BitBtn1: TBitBtn
      Left = 125
      Top = 16
      Width = 135
      Height = 25
      Action = actnSave
      Anchors = [akTop, akRight]
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080' '#1074#1099#1081#1090#1080
      TabOrder = 0
      Kind = bkOK
    end
    object BitBtn2: TBitBtn
      Left = 266
      Top = 16
      Width = 91
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      Kind = bkCancel
    end
    object BitBtn3: TBitBtn
      Left = 21
      Top = 16
      Width = 98
      Height = 25
      Action = actnSaveAndNew
      Anchors = [akTop, akRight]
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 2
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
  end
  object pnl: TPanel
    Left = 0
    Top = 0
    Width = 366
    Height = 220
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      366
      220)
    object SpeedButton1: TSpeedButton
      Left = 337
      Top = 19
      Width = 23
      Height = 22
      Action = actnAddDict
      Anchors = [akTop, akRight]
    end
    object GroupBox1: TGroupBox
      Left = 0
      Top = 149
      Width = 366
      Height = 71
      Align = alClient
      Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
      TabOrder = 0
      object mmComment: TMemo
        Left = 2
        Top = 15
        Width = 362
        Height = 54
        Align = alClient
        TabOrder = 0
      end
    end
    object GroupBox4: TGroupBox
      Left = 0
      Top = 50
      Width = 366
      Height = 50
      Align = alTop
      Caption = #1050#1086#1088#1077#1085#1100' '#1089#1083#1086#1074#1072
      TabOrder = 1
      DesignSize = (
        366
        50)
      object cbxAllRoots: TComboBox
        Left = 8
        Top = 20
        Width = 353
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        Sorted = True
        TabOrder = 0
        OnChange = cbxAllRootsChange
      end
    end
    object GroupBox3: TGroupBox
      Left = 0
      Top = 100
      Width = 366
      Height = 49
      Align = alTop
      Caption = #1047#1085#1072#1095#1077#1085#1080#1077
      TabOrder = 2
      object edtName: TEdit
        Left = 8
        Top = 16
        Width = 353
        Height = 21
        TabOrder = 0
        Text = '<'#1042#1074#1077#1076#1080#1090#1077' '#1079#1085#1072#1095#1077#1085#1080#1077'>'
      end
    end
    object GroupBox2: TGroupBox
      Left = 0
      Top = 0
      Width = 366
      Height = 50
      Align = alTop
      Caption = #1057#1083#1086#1074#1072#1088#1100
      TabOrder = 3
      DesignSize = (
        366
        50)
      object SpeedButton2: TSpeedButton
        Left = 335
        Top = 19
        Width = 25
        Height = 22
        Action = actnAddDict
        Anchors = [akTop, akRight]
      end
      object cbxDicts: TComboBox
        Left = 8
        Top = 20
        Width = 321
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        Sorted = True
        TabOrder = 0
        OnChange = cbxDictsChange
      end
    end
  end
  object actnLst: TActionList
    Left = 8
    Top = 193
    object actnSave: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080' '#1074#1099#1081#1090#1080
      OnExecute = actnSaveExecute
    end
    object actnAddDict: TAction
      Caption = '...'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1086#1074#1099#1081' '#1089#1083#1086#1074#1072#1088#1100
      OnExecute = actnAddDictExecute
    end
    object actnSaveAndNew: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      OnExecute = actnSaveAndNewExecute
    end
  end
end
