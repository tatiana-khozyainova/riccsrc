object frmChangeLasFile: TfrmChangeLasFile
  Left = 0
  Top = 0
  Width = 550
  Height = 475
  TabOrder = 0
  object gbx1: TGroupBox
    Left = 0
    Top = 0
    Width = 550
    Height = 475
    Align = alClient
    Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' LAS-'#1092#1072#1081#1083#1072
    TabOrder = 0
    object pgcMain: TPageControl
      Left = 2
      Top = 15
      Width = 546
      Height = 458
      ActivePage = tsChange
      Align = alClient
      TabOrder = 0
      object tsJoin: TTabSheet
        Caption = #1055#1088#1080#1074#1103#1079#1082#1072' '#1082' '#1089#1082#1074#1072#1078#1080#1085#1077
        object lstBoxArea: TListBox
          Left = 0
          Top = 48
          Width = 257
          Height = 329
          Align = alCustom
          ItemHeight = 13
          TabOrder = 0
          OnClick = lstBoxAreaClick
        end
        object lstBoxWell: TListBox
          Left = 280
          Top = 48
          Width = 258
          Height = 329
          Align = alCustom
          ItemHeight = 13
          TabOrder = 1
        end
        object btnJoinToWell: TButton
          Left = 224
          Top = 8
          Width = 89
          Height = 25
          Action = actJoinToWell
          Caption = #1055#1088#1080#1074#1103#1079#1072#1090#1100
          TabOrder = 2
        end
      end
      object tsChange: TTabSheet
        Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
        ImageIndex = 1
        DesignSize = (
          538
          430)
        object gbxVersion: TGroupBox
          Left = 0
          Top = 0
          Width = 537
          Height = 89
          Align = alCustom
          Anchors = [akLeft, akTop, akRight]
          Caption = '~Version Information'
          TabOrder = 0
          object lstVersion: TListBox
            Left = 2
            Top = 15
            Width = 533
            Height = 72
            Align = alClient
            ItemHeight = 13
            TabOrder = 0
            OnDblClick = actLstRowDblClickExecute
          end
        end
        object gbxWell: TGroupBox
          Left = 0
          Top = 96
          Width = 537
          Height = 105
          Align = alCustom
          Anchors = [akLeft, akTop, akRight]
          Caption = '~Well Information'
          TabOrder = 1
          object lstWell: TListBox
            Left = 2
            Top = 15
            Width = 533
            Height = 88
            Align = alClient
            ItemHeight = 13
            TabOrder = 0
            OnDblClick = actLstRowDblClickExecute
          end
        end
        object gbxCurve: TGroupBox
          Left = 0
          Top = 208
          Width = 537
          Height = 105
          Anchors = [akLeft, akTop, akRight]
          Caption = '~Curve Information'
          TabOrder = 2
          object lstCurve: TListBox
            Left = 2
            Top = 15
            Width = 533
            Height = 88
            Align = alClient
            ItemHeight = 13
            TabOrder = 0
            OnDblClick = lstCurveDblClick
          end
        end
        object gbxAscii: TGroupBox
          Left = 0
          Top = 320
          Width = 537
          Height = 105
          Anchors = [akLeft, akTop, akRight]
          Caption = '~ASCII LOG DATAS'
          TabOrder = 3
          object lstAscii: TListBox
            Left = 2
            Top = 15
            Width = 533
            Height = 88
            Align = alClient
            ItemHeight = 13
            TabOrder = 0
            OnDblClick = actLstRowDblClickExecute
          end
        end
      end
    end
  end
  object actlstChangeLasFile: TActionList
    Left = 8
    Top = 384
    object actJoinToWell: TAction
      Caption = 'actJoinToWell'
      OnExecute = actJoinToWellExecute
      OnUpdate = actJoinToWellUpdate
    end
    object actChangeLasFile: TAction
      Caption = 'actChangeLasFile'
    end
    object actLstClick: TAction
      Caption = 'actLstClick'
    end
    object actLstRowDblClick: TAction
      Caption = 'actLstRowDblClick'
      OnExecute = actLstRowDblClickExecute
    end
  end
end
