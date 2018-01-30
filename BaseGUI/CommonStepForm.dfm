object frmStep: TfrmStep
  Left = 289
  Top = 214
  Width = 635
  Height = 453
  BorderIcons = [biMaximize]
  Caption = #1048#1085#1076#1080#1082#1072#1090#1086#1088' '#1093#1086#1076#1072' '#1101#1082#1089#1087#1086#1088#1090#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  inline frmCalculationLogger: TfrmCalculationLogger
    Left = 0
    Top = 121
    Width = 619
    Height = 293
    Align = alClient
    TabOrder = 0
    inherited gbxLog: TGroupBox
      Width = 619
      Height = 293
      inherited lwLog: TListView
        Width = 615
        Height = 276
      end
    end
  end
  object pnlStep: TPanel
    Left = 0
    Top = 0
    Width = 619
    Height = 121
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object tlbr: TToolBar
      Left = 2
      Top = 2
      Width = 615
      Height = 29
      ButtonHeight = 21
      ButtonWidth = 45
      Caption = 'tlbr'
      Flat = True
      ShowCaptions = True
      TabOrder = 0
      Visible = False
      object sbtnHide: TToolButton
        Left = 0
        Top = 0
        Action = actnHide
      end
    end
    object prg: TProgressBar
      Left = 5
      Top = 32
      Width = 608
      Height = 17
      TabOrder = 1
    end
    object prgSub: TProgressBar
      Left = 6
      Top = 88
      Width = 608
      Height = 17
      TabOrder = 2
    end
    object lblStep: TStaticText
      Left = 7
      Top = 59
      Width = 4
      Height = 4
      TabOrder = 3
    end
  end
  object actnStepForm: TActionList
    Left = 386
    Top = 18
    object actnHide: TAction
      Caption = #1057#1082#1088#1099#1090#1100
      OnExecute = actnHideExecute
      OnUpdate = actnHideUpdate
    end
  end
end
