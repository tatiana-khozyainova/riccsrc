inherited frmBoxProperties: TfrmBoxProperties
  Width = 304
  Height = 576
  inherited StatusBar: TStatusBar
    Top = 557
    Width = 304
  end
  object gbxBoxProperties: TGroupBox
    Left = 0
    Top = 0
    Width = 304
    Height = 557
    Align = alClient
    Caption = #1071#1097#1080#1082
    TabOrder = 1
    object Panel1: TPanel
      Left = 2
      Top = 15
      Width = 300
      Height = 202
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        300
        202)
      object lblRack: TLabel
        Left = 8
        Top = 72
        Width = 127
        Height = 13
        Caption = #1056#1072#1079#1084#1077#1097#1077#1085#1080#1077' '#1074' '#1089#1090#1077#1083#1083#1072#1078#1077
      end
      object lblAll: TLabel
        Left = 8
        Top = 120
        Width = 274
        Height = 65
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          '*'#1056#1072#1079#1084#1077#1097#1077#1085#1080#1077' '#1074' '#1089#1090#1077#1083#1083#1072#1078#1072#1093' '#1076#1086#1089#1090#1091#1087#1085#1086' '#1090#1086#1083#1100#1082#1086' '#1076#1083#1103' '#1084#1077#1089#1090#1072' '#1093#1088#1072#1085#1077#1085#1080#1103' "'#1040#1085#1075#1072 +
          #1088'".'
        WordWrap = True
      end
      object edtBoxNumber: TLabeledEdit
        Left = 8
        Top = 40
        Width = 281
        Height = 21
        EditLabel.Width = 70
        EditLabel.Height = 13
        EditLabel.Caption = #1053#1086#1084#1077#1088' '#1103#1097#1080#1082#1072
        TabOrder = 0
        OnExit = edtBoxNumberExit
      end
      object cmbxRack: TComboBox
        Left = 8
        Top = 91
        Width = 281
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
        OnChange = cmbxRackChange
      end
    end
  end
end
