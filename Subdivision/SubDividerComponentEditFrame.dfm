object frmSubComponentEdit: TfrmSubComponentEdit
  Left = 0
  Top = 0
  Width = 225
  Height = 532
  TabOrder = 0
  object gbxProperties: TGroupBox
    Left = 0
    Top = 0
    Width = 225
    Height = 485
    Align = alClient
    TabOrder = 0
    DesignSize = (
      225
      485)
    object Label3: TLabel
      Left = 6
      Top = 267
      Width = 41
      Height = 13
      Caption = #1043#1083#1091#1073#1080#1085#1072
    end
    object Label5: TLabel
      Left = 6
      Top = 347
      Width = 123
      Height = 13
      Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081' '#1082' '#1075#1088#1072#1085#1080#1094#1077
      Enabled = False
    end
    object Label4: TLabel
      Left = 6
      Top = 307
      Width = 70
      Height = 13
      Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
    end
    object edtDepth: TEdit
      Left = 6
      Top = 283
      Width = 212
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = edtDepthChange
      OnKeyDown = edtDepthKeyDown
    end
    object cmbxEdgeComment: TComboBox
      Left = 6
      Top = 362
      Width = 212
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      ItemHeight = 13
      TabOrder = 1
    end
    object GroupBox1: TGroupBox
      Left = 2
      Top = 408
      Width = 221
      Height = 75
      Align = alBottom
      Caption = #1057#1074#1086#1081#1089#1090#1074#1072' '#1089#1082#1074#1072#1078#1080#1085#1099' '#1080' '#1090#1077#1082#1090'. '#1073#1083#1086#1082#1072
      TabOrder = 2
      object mmProperties: TMemo
        Left = 2
        Top = 15
        Width = 217
        Height = 58
        Align = alClient
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
      end
    end
    object pgctl: TPageControl
      Left = 2
      Top = 15
      Width = 221
      Height = 206
      ActivePage = tshPlus
      Align = alTop
      Images = imgLst
      MultiLine = True
      Style = tsFlatButtons
      TabOrder = 3
      OnChange = pgctlChange
      object tshCommon: TTabSheet
        Caption = #1054#1073#1099#1095#1085#1099#1081
        DesignSize = (
          213
          174)
        object Label1: TLabel
          Left = 1
          Top = 20
          Width = 61
          Height = 13
          Caption = #1057#1090#1088#1072#1090#1086#1085' ('#1086#1090')'
        end
        object Label2: TLabel
          Left = 1
          Top = 100
          Width = 62
          Height = 13
          Caption = #1057#1090#1088#1072#1090#1086#1085' ('#1076#1086')'
        end
        object cmbxStraton: TComboBox
          Left = 1
          Top = 35
          Width = 212
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 0
          OnChange = cmbxStratonChange
        end
        object cmbxNextStraton: TComboBox
          Left = 1
          Top = 115
          Width = 212
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 1
        end
      end
      object tshPlus: TTabSheet
        Caption = #1055#1083#1102#1089#1086#1074#1080#1082
        ImageIndex = 1
        DesignSize = (
          213
          174)
        object lblFilter: TLabel
          Left = 0
          Top = 135
          Width = 40
          Height = 13
          Caption = #1060#1080#1083#1100#1090#1088
        end
        object chlbxPlus: TCheckListBox
          Left = 0
          Top = 0
          Width = 213
          Height = 131
          OnClickCheck = chlbxPlusClickCheck
          Align = alTop
          ItemHeight = 13
          TabOrder = 0
        end
        object cmbxFilter: TComboBox
          Left = 0
          Top = 150
          Width = 213
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 1
          OnChange = cmbxFilterChange
        end
      end
    end
    object chbxTemplateEdit: TCheckBox
      Left = 5
      Top = 230
      Width = 231
      Height = 17
      Caption = #1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1096#1072#1073#1083#1086#1085
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object cmbxComment: TComboBox
      Left = 6
      Top = 323
      Width = 212
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 5
      OnChange = cmbxCommentChange
    end
    object chbxChangeUndivided: TCheckBox
      Left = 5
      Top = 250
      Width = 211
      Height = 17
      Caption = #1080#1079#1084#1077#1085#1080#1090#1100' '#1085#1077#1088#1072#1089#1095#1083#1077#1085#1077#1085#1085#1099#1077
      Checked = True
      State = cbChecked
      TabOrder = 6
    end
    object chbxVerified: TCheckBox
      Left = 5
      Top = 385
      Width = 221
      Height = 17
      Caption = #1080#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1072
      Checked = True
      State = cbChecked
      TabOrder = 7
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 485
    Width = 225
    Height = 47
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      225
      47)
    object btnOK: TButton
      Left = 3
      Top = 13
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 142
      Top = 13
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object imgLst: TImageList
    Left = 107
    Top = 312
    Bitmap = {
      494C010102000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000084000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000084000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000084000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084000000840000000000000000000000FFFF
      0000FFFFFF00FFFF0000FFFFFF00000000000000000000000000000000000000
      0000000000000084000000840000008400000084000000840000008400000084
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008400000084000000840000008400000000000000FFFF
      FF00FFFF0000FFFFFF00FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000084000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000084000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000084000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF0000000003FFFFFF00000000
      03FFFFFF0000000003FFFFFF0000000003FFFE3F0000000003FFFE3F00000000
      03FFFE3F000000000340F00700000000FE40F00700000000FC00F00700000000
      FE40FE3F00000000037FFE3F0000000003FFFE3F0000000003FFFFFF00000000
      03FFFFFF00000000FFFFFFFF0000000000000000000000000000000000000000
      000000000000}
  end
end