object frmAddChangeSaveLasFiles: TfrmAddChangeSaveLasFiles
  Left = 0
  Top = 0
  Width = 657
  Height = 475
  TabOrder = 0
  object pgcMain: TPageControl
    Left = 0
    Top = 0
    Width = 657
    Height = 475
    ActivePage = tsLink
    Align = alClient
    TabOrder = 0
    object tsLink: TTabSheet
      Caption = 'tsLink'
      DesignSize = (
        649
        447)
      object lstBxArea: TListBox
        Left = 0
        Top = 8
        Width = 313
        Height = 401
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 13
        TabOrder = 1
        OnClick = lstBxAreaClick
      end
      object lstBxWells: TListBox
        Left = 328
        Top = 8
        Width = 313
        Height = 401
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 13
        TabOrder = 2
      end
      object btnAddToWell: TButton
        Left = 288
        Top = 420
        Width = 75
        Height = 25
        Anchors = [akLeft, akRight, akBottom]
        Caption = #1055#1088#1080#1074#1103#1079#1072#1090#1100
        TabOrder = 0
      end
    end
    object tsChange: TTabSheet
      Caption = 'tsChange'
      ImageIndex = 1
    end
    object tsSave: TTabSheet
      Caption = 'tsSave'
      ImageIndex = 2
    end
  end
  object actlstPgcMain: TActionList
    Top = 448
    object actLstBxAreaClick: TAction
      Caption = 'actLstBxAreaClick'
      OnExecute = lstBxAreaClick
    end
  end
end
