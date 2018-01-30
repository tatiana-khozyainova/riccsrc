object frmAltitudesWell: TfrmAltitudesWell
  Left = 0
  Top = 0
  Width = 435
  Height = 266
  Align = alClient
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 220
    Width = 435
    Height = 46
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      435
      46)
    object BitBtn1: TBitBtn
      Left = 15
      Top = 12
      Width = 75
      Height = 25
      Action = actnAddAltitude
      Anchors = [akTop, akRight]
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 99
      Top = 12
      Width = 75
      Height = 25
      Action = actnDelAltitude
      Anchors = [akTop, akRight]
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 1
    end
    object BitBtn3: TBitBtn
      Left = 275
      Top = 12
      Width = 75
      Height = 25
      Action = actnOk
      Anchors = [akTop, akRight]
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ModalResult = 1
      TabOrder = 2
      NumGlyphs = 2
    end
    object BitBtn4: TBitBtn
      Left = 359
      Top = 12
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      Default = True
      ModalResult = 2
      TabOrder = 3
      NumGlyphs = 2
    end
  end
  object grdAltitudes: TGridView
    Left = 0
    Top = 0
    Width = 435
    Height = 220
    Align = alClient
    AllowEdit = True
    Columns = <
      item
        Caption = #1058#1080#1087' '#1072#1083#1100#1090#1080#1090#1091#1076#1099
        EditStyle = gePickList
        MaxLength = 145
        PickList.Strings = (
          '2'
          '3'
          '43')
        DefWidth = 145
      end
      item
        Caption = #1057#1080#1089#1090#1077#1084#1072' '#1072#1083#1100#1090#1080#1090#1091#1076
        EditStyle = gePickList
        MaxLength = 145
        DefWidth = 145
      end
      item
        Caption = #1054#1090#1084#1077#1090#1082#1072
        MaxLength = 140
        DefWidth = 140
      end>
    FocusOnScroll = True
    Header.Sections = <
      item
        Alignment = taCenter
        Caption = #1058#1080#1087' '#1072#1083#1100#1090#1080#1090#1091#1076#1099
        Width = 145
      end
      item
        Alignment = taCenter
        Caption = #1057#1080#1089#1090#1077#1084#1072' '#1072#1083#1100#1090#1080#1090#1091#1076
        Width = 145
      end
      item
        Alignment = taCenter
        Caption = #1054#1090#1084#1077#1090#1082#1072
        Width = 140
      end>
    Header.Synchronized = True
    ImageHighlight = False
    ParentShowHint = False
    Rows.Count = 1
    ShowCellTips = True
    ShowFocusRect = False
    ShowHint = True
    TabOrder = 1
    OnCellClick = grdAltitudesCellClick
    OnChanging = grdAltitudesChanging
    OnDrawCell = grdAltitudesDrawCell
    OnGetEditText = grdAltitudesGetEditText
    OnSetEditText = grdAltitudesSetEditText
  end
  object actnLst: TActionList
    Left = 16
    Top = 24
    object actnAddAltitude: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1072#1083#1100#1090#1080#1090#1091#1076#1091
      OnExecute = actnAddAltitudeExecute
    end
    object actnDelAltitude: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1072#1083#1100#1090#1080#1090#1091#1076#1091
      OnExecute = actnDelAltitudeExecute
    end
    object actnOk: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
      OnExecute = actnOkExecute
    end
  end
end
