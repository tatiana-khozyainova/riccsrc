object frmRackSelectForm: TfrmRackSelectForm
  Left = 484
  Top = 317
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1089#1090#1077#1083#1083#1072#1078
  ClientHeight = 200
  ClientWidth = 358
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object gbxRackSelect: TGroupBox
    Left = 0
    Top = 0
    Width = 358
    Height = 159
    Align = alClient
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1089#1090#1077#1083#1083#1072#1078
    TabOrder = 0
    object lblRack: TLabel
      Left = 8
      Top = 24
      Width = 44
      Height = 13
      Caption = #1057#1090#1077#1083#1083#1072#1078
    end
    object cmbxRack: TComboBox
      Left = 8
      Top = 48
      Width = 337
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object chbxBlank: TCheckBox
      Left = 8
      Top = 72
      Width = 233
      Height = 17
      Caption = #1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1073#1083#1072#1085#1082
      TabOrder = 1
    end
    object chbxSaveFiles: TCheckBox
      Left = 8
      Top = 97
      Width = 225
      Height = 17
      Caption = #1089#1086#1093#1088#1072#1085#1103#1090#1100' '#1086#1090#1095#1077#1090#1099
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = chbxSaveFilesClick
    end
    object edtReportPath: TDirectoryEdit
      Left = 8
      Top = 121
      Width = 337
      Height = 21
      DirectInput = False
      NumGlyphs = 1
      TabOrder = 3
      Text = 'D:\Temp'
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 159
    Width = 358
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnOK: TButton
      Left = 192
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 272
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
end
