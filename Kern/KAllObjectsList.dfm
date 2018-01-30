object frmAllListObjects: TfrmAllListObjects
  Left = 569
  Top = 266
  BorderStyle = bsDialog
  Caption = #1059#1082#1072#1078#1080#1090#1077' '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1099#1077' '#1086#1073#1098#1077#1082#1090#1099
  ClientHeight = 386
  ClientWidth = 440
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  inline frmAllObjects: TfrmAllObjects
    Left = 0
    Top = 0
    Width = 440
    Height = 386
    Align = alClient
    TabOrder = 0
    inherited lstObjects: TCheckListBox
      Width = 440
      Height = 212
    end
    inherited Panel1: TPanel
      Top = 330
      Width = 440
      DesignSize = (
        440
        56)
    end
    inherited gbxFilter: TGroupBox
      Top = 253
      Width = 440
    end
    inherited pnlFilter: TPanel
      Top = 212
      Width = 440
    end
  end
end
