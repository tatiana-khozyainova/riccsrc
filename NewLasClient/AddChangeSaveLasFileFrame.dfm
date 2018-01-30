object frmAddChangeSaveLasFiles: TfrmAddChangeSaveLasFiles
  Left = 0
  Top = 0
  Width = 558
  Height = 534
  TabOrder = 0
  object pgcMain: TPageControl
    Left = 0
    Top = 0
    Width = 558
    Height = 534
    ActivePage = tsLink
    Align = alClient
    Enabled = False
    TabOrder = 0
    object tsLink: TTabSheet
      Caption = #1055#1088#1080#1074#1103#1079#1072#1090#1100' '#1082' '#1089#1082#1074#1072#1078#1080#1085#1077
      Enabled = False
      DesignSize = (
        550
        506)
      object lstBxArea: TListBox
        Left = 8
        Top = 42
        Width = 277
        Height = 453
        AutoComplete = False
        Anchors = [akLeft, akTop, akBottom]
        ItemHeight = 13
        TabOrder = 1
        OnClick = lstBxAreaClick
      end
      object lstBxWells: TListBox
        Left = 294
        Top = 40
        Width = 250
        Height = 457
        Anchors = [akTop, akRight, akBottom]
        ItemHeight = 13
        TabOrder = 2
      end
      object btnAddToWell: TButton
        Left = 253
        Top = 7
        Width = 77
        Height = 25
        Action = actBtnAddToWell
        Anchors = [akTop]
        TabOrder = 0
      end
    end
    object tsChange: TTabSheet
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
      Enabled = False
      ImageIndex = 1
      object lst1: TListBox
        Left = 0
        Top = 48
        Width = 449
        Height = 457
        ItemHeight = 13
        TabOrder = 0
      end
      object btnViewLasFile: TButton
        Left = 16
        Top = 8
        Width = 91
        Height = 25
        Action = actViewLasFile
        TabOrder = 1
      end
      object btn1: TButton
        Left = 120
        Top = 8
        Width = 75
        Height = 25
        Caption = 'btn1'
        TabOrder = 2
        OnClick = btn1Click
      end
      object btn2: TButton
        Left = 240
        Top = 16
        Width = 75
        Height = 25
        Caption = #1079#1072#1084#1077#1085#1072
        TabOrder = 3
        OnClick = btn2Click
      end
    end
    object tsSave: TTabSheet
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1041#1044
      Enabled = False
      ImageIndex = 2
    end
  end
  object actlstPgcMain: TActionList
    Top = 448
    object actLstBxAreaClick: TAction
      Caption = 'actLstBxAreaClick'
      OnExecute = lstBxAreaClick
    end
    object actBtnAddToWell: TAction
      Caption = #1055#1088#1080#1074#1103#1079#1072#1090#1100
      OnUpdate = actBtnAddToWellUpdate
    end
    object actViewLasFile: TAction
      Caption = 'actViewLasFile'
      OnExecute = actViewLasFileExecute
    end
  end
end
