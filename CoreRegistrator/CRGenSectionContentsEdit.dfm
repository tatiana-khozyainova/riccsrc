inherited frmGenSectionContentsEdit: TfrmGenSectionContentsEdit
  Height = 378
  inherited StatusBar: TStatusBar
    Top = 359
  end
  object gbxGenSectionContents: TGroupBox
    Left = 0
    Top = 0
    Width = 477
    Height = 359
    Align = alClient
    Caption = #1057#1086#1089#1090#1072#1074' '#1089#1074#1086#1076#1085#1086#1075#1086' '#1088#1072#1079#1088#1077#1079#1072
    TabOrder = 1
    DesignSize = (
      477
      359)
    object lblWell: TLabel
      Left = 5
      Top = 24
      Width = 51
      Height = 13
      Caption = #1057#1082#1074#1072#1078#1080#1085#1072
    end
    object lblIntervals: TLabel
      Left = 5
      Top = 64
      Width = 158
      Height = 13
      Caption = #1048#1085#1090#1077#1088#1074#1072#1083#1099' '#1074' '#1089#1074#1086#1076#1085#1086#1084' '#1088#1072#1079#1088#1077#1079#1077
    end
    object cmbxWell: TComboBox
      Left = 4
      Top = 41
      Width = 468
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 0
      OnChange = cmbxWellChange
    end
    object lwSlottings: TListView
      Left = 2
      Top = 82
      Width = 473
      Height = 275
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      Checkboxes = True
      Columns = <
        item
          Caption = 'UIN'
          Width = 24
        end
        item
          Caption = #1048#1085#1090#1077#1088#1074#1072#1083
          Width = -2
          WidthType = (
            -2)
        end>
      TabOrder = 1
      ViewStyle = vsReport
      OnMouseUp = lwSlottingsMouseUp
    end
  end
end
