object frmSetPerformer: TfrmSetPerformer
  Left = 738
  Top = 340
  Width = 295
  Height = 472
  Caption = #1042#1099#1073#1086#1088' '#1086#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1086#1075#1086' '#1080#1089#1087#1086#1083#1085#1080#1090#1077#1083#1103
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel8: TPanel
    Left = 0
    Top = 396
    Width = 287
    Height = 41
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      287
      41)
    object btnOk: TBitBtn
      Left = 83
      Top = 8
      Width = 92
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1043#1086#1090#1086#1074#1086
      Default = True
      ModalResult = 1
      TabOrder = 0
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
    object BitBtn17: TBitBtn
      Left = 187
      Top = 8
      Width = 92
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      Kind = bkCancel
    end
  end
  inline frmAllUsers: TfrmAllUsers
    Left = 0
    Top = 0
    Width = 287
    Height = 396
    Align = alClient
    TabOrder = 1
    inherited grp1: TGroupBox
      Width = 287
      Height = 370
      inherited grp2: TGroupBox
        Top = 291
        Width = 283
      end
      inherited grp3: TGroupBox
        Width = 283
        Height = 276
        inherited lstAllEmployees: TListBox
          Width = 279
          Height = 231
        end
        inherited pnl1: TPanel
          Top = 246
          Width = 279
        end
      end
    end
    inherited frmButtons: TfrmButtons
      Top = 370
      Width = 287
      inherited tlbr: TToolBar
        Width = 287
        inherited btnAdd: TToolButton
          Wrap = True
        end
        inherited ToolButton11: TToolButton
          Left = 0
          Top = 23
        end
        inherited ToolButton10: TToolButton
          Left = 26
          Top = 23
        end
        inherited ToolButton6: TToolButton
          Left = 52
          Top = 23
        end
        inherited ToolButton8: TToolButton
          Left = 78
          Top = 23
        end
        inherited ToolButton9: TToolButton
          Left = 117
          Top = 23
        end
        inherited btnCancel: TToolButton
          Left = 143
          Top = 23
        end
      end
    end
  end
end
