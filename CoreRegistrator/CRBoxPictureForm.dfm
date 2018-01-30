object frmBoxPictureForm: TfrmBoxPictureForm
  Left = 462
  Top = 12
  Width = 421
  Height = 720
  BorderIcons = [biSystemMenu]
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1092#1086#1090#1086' '#1082#1077#1088#1085#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 640
    Width = 405
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      405
      41)
    object lblBox: TLabel
      Left = 8
      Top = 4
      Width = 3
      Height = 13
    end
    object btnOK: TButton
      Left = 233
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 313
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  inline frmBoxPicture1: TfrmBoxPicture
    Left = 0
    Top = 0
    Width = 405
    Height = 640
    Align = alClient
    TabOrder = 1
    inherited grbx: TGroupBox
      Width = 405
      Height = 525
      inherited lblCurrentFile: TLabel
        Left = 385
        Top = 497
      end
      inherited lblCdr: TLabel
        Top = 497
      end
      inherited btnForward: TBitBtn
        Left = 322
      end
      inherited pnl: TPanel
        Height = 457
        inherited wbImage: TWebBrowser
          Height = 457
          ControlData = {
            4C0000009E2800003B2F00000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
      end
    end
    inherited gbxFIle: TGroupBox
      Width = 405
      inherited edtPath: TDirectoryEdit
        Width = 320
      end
      inherited edtCorelPath: TDirectoryEdit
        Width = 320
      end
      inherited btnReload: TBitBtn
        Left = 332
      end
    end
    inherited prg: TProgressBar
      Width = 405
    end
  end
end
