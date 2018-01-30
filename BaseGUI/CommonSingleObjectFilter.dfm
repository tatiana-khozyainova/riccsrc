object frmSingleObjectFilter: TfrmSingleObjectFilter
  Left = 0
  Top = 0
  Width = 1221
  Height = 71
  TabOrder = 0
  object gbxSingleObjectFilter: TGroupBox
    Left = 0
    Top = 0
    Width = 1221
    Height = 71
    Align = alClient
    Caption = #1042#1099#1073#1086#1088' '#1086#1073#1098#1077#1082#1090#1086#1074
    TabOrder = 0
    object splt1: TSplitter
      Left = 337
      Top = 15
      Height = 54
    end
    object splt2: TSplitter
      Left = 581
      Top = 15
      Height = 54
    end
    object gbx1: TGroupBox
      Left = 2
      Top = 15
      Width = 335
      Height = 54
      Align = alLeft
      Caption = #1042#1077#1088#1089#1080#1103
      TabOrder = 0
      DesignSize = (
        335
        54)
      object cmbxVersion: TComboBox
        Left = 8
        Top = 20
        Width = 319
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        Enabled = False
        ItemHeight = 13
        TabOrder = 0
        OnChange = cmbxVersionChange
      end
    end
    object gbx2: TGroupBox
      Left = 340
      Top = 15
      Width = 241
      Height = 54
      Align = alLeft
      Caption = #1042#1080#1076' '#1086#1073#1098#1077#1082#1090#1072
      TabOrder = 1
      DesignSize = (
        241
        54)
      object cmbxObjectType: TComboBox
        Left = 11
        Top = 20
        Width = 220
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        Enabled = False
        ItemHeight = 13
        TabOrder = 0
        OnChange = cmbxObjectTypeChange
      end
    end
    object gbxObjectSelector: TGroupBox
      Left = 584
      Top = 15
      Width = 635
      Height = 54
      Align = alClient
      Caption = #1054#1073#1098#1077#1082#1090
      TabOrder = 2
      DesignSize = (
        635
        54)
      object cmbxObject: TComboBox
        Left = 9
        Top = 20
        Width = 392
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        Enabled = False
        ItemHeight = 13
        TabOrder = 0
        OnChange = cmbxObjectChange
      end
      object edtFilter: TEdit
        Left = 406
        Top = 20
        Width = 168
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 1
        Text = '<'#1092#1080#1083#1100#1090#1088' '#1087#1086#1080#1089#1082#1072'>'
      end
      object btnFilter: TButton
        Left = 581
        Top = 18
        Width = 49
        Height = 25
        Action = actnApplyFilter
        Anchors = [akTop, akRight]
        TabOrder = 2
      end
    end
  end
  object actnLst: TActionList
    Left = 152
    Top = 16
    object actnApplyFilter: TAction
      Caption = #1053#1072#1081#1090#1080
      OnExecute = actnApplyFilterExecute
    end
  end
end
