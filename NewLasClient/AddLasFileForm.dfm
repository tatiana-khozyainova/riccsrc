object frmAddLasFile: TfrmAddLasFile
  Left = 217
  Top = 167
  Width = 696
  Height = 480
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' LAS-'#1092#1072#1081#1083#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu: TMainMenu
    Left = 392
    object N1: TMenuItem
      Caption = #1060#1072#1081#1083
      object OpnDlg: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100
        OnClick = OpnDlgClick
      end
    end
  end
  object ActLst: TActionList
    Left = 424
    object actOpenDialog: TAction
      Caption = 'actOpenDialog'
      OnExecute = OpnDlgClick
    end
  end
  object OpenDialog: TOpenDialog
    Left = 456
  end
end
