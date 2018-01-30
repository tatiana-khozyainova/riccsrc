object frmDocuments: TfrmDocuments
  Left = 0
  Top = 0
  Width = 810
  Height = 505
  TabOrder = 0
  object pnlLeft: TPanel
    Left = 0
    Top = 0
    Width = 233
    Height = 505
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    inline frmVersions: TfrmVersions
      Left = 0
      Top = 0
      Width = 233
      Height = 505
      Align = alClient
      TabOrder = 0
      inherited gbxLeft: TGroupBox
        Width = 233
        Height = 505
        Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099
        inherited tlbr: TToolBar
          Top = 448
          Width = 229
        end
        inherited trw: TTreeView
          Width = 229
          Height = 433
          OnChange = frmVersionstrwChange
          OnChanging = frmVersionstrwChanging
        end
      end
    end
  end
  object gbxEditor: TGroupBox
    Left = 233
    Top = 0
    Width = 577
    Height = 505
    Align = alClient
    Caption = #1056#1077#1076#1072#1082#1090#1086#1088
    TabOrder = 1
    object pgctl: TPageControl
      Left = 2
      Top = 15
      Width = 573
      Height = 488
      ActivePage = tshDocs
      Align = alClient
      Style = tsFlatButtons
      TabOrder = 0
      object tshDocs: TTabSheet
        Caption = #1044#1086#1082#1091#1084#1077#1085#1090
        object pgctlDoc: TPageControl
          Left = 0
          Top = 0
          Width = 565
          Height = 457
          ActivePage = tshCommonDocInfo
          Align = alClient
          MultiLine = True
          TabOrder = 0
          TabPosition = tpBottom
          object tshCommonDocInfo: TTabSheet
            Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1077
            ImageIndex = 1
            object gbxMaterial: TGroupBox
              Left = 0
              Top = 0
              Width = 557
              Height = 431
              Align = alClient
              Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1080#1083#1080' '#1084#1072#1090#1077#1088#1080#1072#1083
              TabOrder = 0
              DesignSize = (
                557
                431)
              object Label1: TLabel
                Left = 9
                Top = 24
                Width = 134
                Height = 13
                Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1084#1072#1090#1077#1088#1080#1072#1083#1072
              end
              object Label2: TLabel
                Left = 10
                Top = 140
                Width = 77
                Height = 13
                Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
              end
              object edtMaterialName: TEdit
                Left = 8
                Top = 40
                Width = 542
                Height = 21
                Anchors = [akLeft, akTop, akRight]
                TabOrder = 0
                OnKeyPress = edtMaterialNameKeyPress
              end
              inline cmplxAuthors: TfrmComplexCombo
                Left = 7
                Top = 78
                Width = 544
                Height = 46
                Anchors = [akLeft, akTop, akRight]
                TabOrder = 1
                inherited btnShowAdditional: TButton
                  Left = 517
                end
                inherited cmbxName: TComboBox
                  Width = 511
                end
              end
              inline cmplxMaterialType: TfrmComplexCombo
                Left = 95
                Top = 136
                Width = 223
                Height = 46
                TabOrder = 2
                inherited btnShowAdditional: TButton
                  Left = 196
                end
                inherited cmbxName: TComboBox
                  Width = 190
                end
              end
              object dtEdtCreationDate: TDateEdit
                Left = 9
                Top = 158
                Width = 80
                Height = 21
                DefaultToday = True
                DirectInput = False
                NumGlyphs = 2
                TabOrder = 3
                Text = '17.06.2005'
                OnAcceptDate = dtEdtCreationDateAcceptDate
              end
              inline cmplxTheme: TfrmComplexCombo
                Left = 7
                Top = 194
                Width = 543
                Height = 46
                Anchors = [akLeft, akTop, akRight]
                TabOrder = 4
                inherited btnShowAdditional: TButton
                  Left = 516
                end
                inherited cmbxName: TComboBox
                  Width = 510
                end
              end
              inline cmplxOrganization: TfrmComplexCombo
                Left = 7
                Top = 246
                Width = 543
                Height = 46
                Anchors = [akLeft, akTop, akRight]
                TabOrder = 5
                inherited btnShowAdditional: TButton
                  Left = 516
                end
                inherited cmbxName: TComboBox
                  Width = 510
                end
              end
              object pnlFile: TPanel
                Left = 8
                Top = 294
                Width = 541
                Height = 57
                Anchors = [akLeft, akTop, akRight]
                BevelInner = bvLowered
                BevelOuter = bvNone
                TabOrder = 6
                DesignSize = (
                  541
                  57)
                object Label3: TLabel
                  Left = 5
                  Top = 5
                  Width = 67
                  Height = 13
                  Caption = #1055#1091#1090#1100' '#1082' '#1092#1072#1081#1083#1091
                end
                object edtFileName: TFilenameEdit
                  Left = 4
                  Top = 30
                  Width = 533
                  Height = 21
                  AcceptFiles = True
                  OnAfterDialog = edtFileNameAfterDialog
                  DialogOptions = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofNoNetworkButton]
                  DirectInput = False
                  Anchors = [akLeft, akTop, akRight]
                  NumGlyphs = 1
                  TabOrder = 0
                  OnChange = edtFileNameChange
                end
              end
              inline cmplxMedium: TfrmComplexCombo
                Left = 320
                Top = 137
                Width = 231
                Height = 46
                Anchors = [akLeft, akTop, akRight]
                TabOrder = 7
                inherited btnShowAdditional: TButton
                  Left = 204
                end
                inherited cmbxName: TComboBox
                  Width = 198
                end
              end
            end
          end
          object tshComment: TTabSheet
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            object Label4: TLabel
              Left = 8
              Top = 8
              Width = 70
              Height = 13
              Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            end
            object mmComment: TMemo
              Left = 0
              Top = 32
              Width = 557
              Height = 399
              Align = alBottom
              Anchors = [akLeft, akTop, akRight, akBottom]
              Lines.Strings = (
                '')
              TabOrder = 0
              OnKeyPress = mmCommentKeyPress
            end
          end
        end
      end
    end
  end
end
