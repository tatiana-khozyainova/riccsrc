object frmCoreTransfersEditForm: TfrmCoreTransfersEditForm
  Left = 194
  Top = 302
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1055#1077#1088#1077#1074#1086#1079#1082#1080' '#1080' '#1087#1077#1088#1077#1091#1082#1083#1072#1076#1082#1080' '#1082#1077#1088#1085#1072
  ClientHeight = 405
  ClientWidth = 734
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object gbxTransfers: TGroupBox
    Left = 0
    Top = 0
    Width = 734
    Height = 364
    Align = alClient
    Caption = #1055#1077#1088#1077#1074#1086#1079#1082#1080' '#1080' '#1087#1077#1088#1077#1091#1082#1083#1072#1076#1082#1080
    TabOrder = 0
    object spl1: TSplitter
      Left = 453
      Top = 44
      Height = 318
      Align = alRight
    end
    object lbxTransfers: TListBox
      Left = 2
      Top = 44
      Width = 451
      Height = 318
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnClick = lbxTransfersClick
    end
    object tlbrEditTransfers: TToolBar
      Left = 2
      Top = 15
      Width = 730
      Height = 29
      ButtonHeight = 21
      ButtonWidth = 64
      Caption = 'tlbrEditTransfers'
      Flat = True
      ShowCaptions = True
      TabOrder = 1
      object btnAdd: TToolButton
        Left = 0
        Top = 0
        Action = actnAddTransfer
        AllowAllUp = True
        Grouped = True
      end
      object btnEditTransfer: TToolButton
        Left = 64
        Top = 0
        Action = actnEditTransfer
        AllowAllUp = True
        Grouped = True
      end
      object btnDelete: TToolButton
        Left = 128
        Top = 0
        Action = actnDeleteTransfer
      end
      object btnApply: TToolButton
        Left = 192
        Top = 0
        Action = actnApply
        Grouped = True
      end
      object btnCancelEdit: TToolButton
        Left = 256
        Top = 0
        Action = actnCancel
        Grouped = True
      end
    end
    inline frmCoreTransferEdit1: TfrmCoreTransferEdit
      Left = 456
      Top = 44
      Width = 276
      Height = 318
      Align = alRight
      TabOrder = 2
      inherited StatusBar: TStatusBar
        Top = 299
        Width = 276
      end
      inherited gbxCoreTransfer: TGroupBox
        Width = 276
        Height = 299
      end
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 364
    Width = 734
    Height = 41
    Align = alBottom
    TabOrder = 1
    object btnOK: TButton
      Left = 439
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 519
      Top = 8
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object actnlstTransfersEdit: TActionList
    Left = 280
    Top = 96
    object actnAddTransfer: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      GroupIndex = 1
      OnExecute = actnAddTransferExecute
      OnUpdate = actnAddTransferUpdate
    end
    object actnEditTransfer: TAction
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      GroupIndex = 1
      OnExecute = actnEditTransferExecute
      OnUpdate = actnEditTransferUpdate
    end
    object actnDeleteTransfer: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnExecute = actnDeleteTransferExecute
      OnUpdate = actnDeleteTransferUpdate
    end
    object actnApply: TAction
      Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
      GroupIndex = 2
      OnExecute = actnApplyExecute
      OnUpdate = actnApplyUpdate
    end
    object actnCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      GroupIndex = 2
      OnExecute = actnCancelExecute
      OnUpdate = actnCancelUpdate
    end
  end
end
