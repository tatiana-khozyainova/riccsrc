object frmEditExemple: TfrmEditExemple
  Left = 480
  Top = 280
  Width = 620
  Height = 630
  Caption = 'frmEditExemple'
  Color = clBtnFace
  Constraints.MinHeight = 630
  Constraints.MinWidth = 620
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object btnSMAddExemple: TButton
    Left = 328
    Top = 560
    Width = 123
    Height = 25
    Action = actSMAddExemple
    Caption = #1054#1050
    TabOrder = 0
  end
  object btnClose: TButton
    Left = 464
    Top = 560
    Width = 123
    Height = 25
    Action = actClose
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
  end
  inline frmEditSMExemple: TFrame6
    Left = 0
    Top = 0
    Width = 600
    Height = 550
    Constraints.MinHeight = 550
    Constraints.MinWidth = 600
    Color = clBtnFace
    ParentColor = False
    TabOrder = 2
    inherited cbbSelectMaterial: TComboBox
      OnSelect = actSMSelectMaterialSimpleDocExecute
    end
    inherited lstExempleCurrent: TListBox
      OnClick = actSelectExempleExecute
    end
    inherited lstElement: TListBox
      OnClick = actSelectElementExecute
    end
    inherited btnAddExemple: TButton
      Action = actAddExemple
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    end
    inherited btnUpExemple: TButton
      Action = actUpExemple
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
    end
    inherited btnDelExemple: TButton
      Action = actDelExemple
      Caption = #1059#1076#1072#1083#1080#1090#1100
    end
    inherited btnAddElement: TButton
      Action = actAddElement
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    end
    inherited btnUpElement: TButton
      Action = actUpElement
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
    end
    inherited btnDelElement: TButton
      Action = actDelElement
      Caption = #1059#1076#1072#1083#1080#1090#1100
    end
  end
  object actlst1: TActionList
    Left = 216
    Top = 560
    object actClose: TAction
      Caption = 'actClose'
      OnExecute = actCloseExecute
    end
    object actSMSelectMaterialSimpleDoc: TAction
      Caption = 'actSMSelectMaterialSimpleDoc'
      OnExecute = actSMSelectMaterialSimpleDocExecute
    end
    object actSMSelectMaterialExemple: TAction
      Caption = 'actSMSelectMaterialExemple'
      OnExecute = actSMSelectMaterialExempleExecute
    end
    object actSelectExemple: TAction
      Caption = 'actSelectExemple'
      OnExecute = actSelectExempleExecute
    end
    object actSelectElement: TAction
      Caption = 'actSelectElement'
      OnExecute = actSelectElementExecute
    end
    object actAddExemple: TAction
      Caption = 'actAddExemple'
      OnExecute = actAddExempleExecute
    end
    object actUpExemple: TAction
      Caption = 'actUpExemple'
      OnExecute = actUpExempleExecute
    end
    object actDelExemple: TAction
      Caption = 'actDelExemple'
      OnExecute = actDelExempleExecute
    end
    object actAddElement: TAction
      Caption = 'actAddElement'
      OnExecute = actAddElementExecute
    end
    object actUpElement: TAction
      Caption = 'actUpElement'
      OnExecute = actUpElementExecute
    end
    object actDelElement: TAction
      Caption = 'actDelElement'
      OnExecute = actDelElementExecute
    end
    object actSMAddExemple: TAction
      Caption = 'actSMAddExemple'
      OnExecute = actSMAddExempleExecute
    end
  end
end
