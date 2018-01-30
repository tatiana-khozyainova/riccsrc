object frmDicts: TfrmDicts
  Left = 469
  Top = 314
  Width = 731
  Height = 577
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 281
    Top = 0
    Height = 498
  end
  inline frmAllDicts: TfrmAllDicts
    Left = 0
    Top = 0
    Width = 281
    Height = 498
    Align = alLeft
    TabOrder = 0
    inherited GroupBox1: TGroupBox
      Width = 281
      Height = 498
      inherited lstAllDicts: TListBox
        Width = 277
        Height = 449
        OnClick = frmAllDictslstAllDictsClick
      end
      inherited frmButtons: TfrmButtons
        Top = 464
        Width = 277
        inherited tlbr: TToolBar
          Width = 277
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 498
    Width = 723
    Height = 52
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 1
    object btnOK: TBitBtn
      Left = 600
      Top = 16
      Width = 107
      Height = 25
      Caption = #1042#1099#1093#1086#1076
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
      NumGlyphs = 2
    end
  end
  inline frmInfoDictionary: TfrmInfoDictionary
    Left = 284
    Top = 0
    Width = 439
    Height = 498
    Align = alClient
    TabOrder = 2
    inherited GroupBox3: TGroupBox
      Width = 439
      Height = 498
      inherited frmBtns: TfrmButtons
        Top = 464
        Width = 435
        inherited tlbr: TToolBar
          Width = 435
          inherited btnAdd: TToolButton
            OnClick = nil
          end
        end
      end
      inherited GroupBox2: TGroupBox
        Width = 435
        Height = 360
        inherited lstAllValues: TListView
          Width = 431
          Height = 313
        end
        inherited lstAllWords: TListBox
          Top = 328
          Width = 431
        end
      end
      inherited ToolBar1: TToolBar
        Top = 424
        Width = 435
      end
      inherited GroupBox4: TGroupBox
        Width = 435
        inherited edtName: TEdit
          Width = 417
        end
      end
    end
    inherited pm: TPopupMenu
      inherited N2: TMenuItem
        Action = frmInfoDictionary.frmBtns.actnAdd
      end
      inherited N1: TMenuItem
        Action = frmInfoDictionary.frmBtns.actnEdit
      end
      inherited N3: TMenuItem
        Action = frmInfoDictionary.frmBtns.actnDelete
      end
    end
  end
end
