inherited frmSlottingPlacementEdit: TfrmSlottingPlacementEdit
  Width = 584
  Height = 431
  inherited StatusBar: TStatusBar
    Top = 412
    Width = 584
  end
  object gbxSlottingPlacement: TGroupBox
    Left = 0
    Top = 0
    Width = 584
    Height = 412
    Align = alClient
    Caption = #1052#1077#1089#1090#1086#1085#1072#1093#1086#1078#1076#1077#1085#1080#1077' '#1082#1077#1088#1085#1072
    TabOrder = 1
    DesignSize = (
      584
      412)
    inline frmSlottingPlacement: TfrmIDObjectSelect
      Left = 4
      Top = 21
      Width = 575
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      inherited edtObject: TEdit
        Width = 529
      end
      inherited btnObject: TButton
        Left = 538
      end
    end
    object edtOwnerPartPlacement: TLabeledEdit
      Left = 8
      Top = 248
      Width = 561
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 209
      EditLabel.Height = 13
      EditLabel.Caption = #1052#1077#1089#1090#1086#1087#1086#1083#1086#1078#1077#1085#1080#1077' '#1095#1072#1089#1090#1080' '#1082#1077#1088#1085#1072' '#1074#1083#1072#1076#1077#1083#1100#1094#1072
      TabOrder = 1
    end
    object edtBoxCount: TLabeledEdit
      Left = 8
      Top = 80
      Width = 169
      Height = 21
      EditLabel.Width = 156
      EditLabel.Height = 13
      EditLabel.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1087#1086#1089#1090#1091#1087#1080#1083#1086
      TabOrder = 2
    end
    object edtFinalBoxCount: TLabeledEdit
      Left = 184
      Top = 80
      Width = 169
      Height = 21
      EditLabel.Width = 207
      EditLabel.Height = 13
      EditLabel.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1087#1086#1089#1083#1077' '#1091#1087#1086#1088#1103#1076#1086#1095#1077#1085#1080#1103
      TabOrder = 3
    end
    inline cmplxOrganization: TfrmIDObjectSelect
      Left = 4
      Top = 176
      Width = 575
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
      inherited edtObject: TEdit
        Width = 529
      end
      inherited btnObject: TButton
        Left = 538
      end
    end
    inline frmLastCoretransfer: TfrmIDObjectSelect
      Left = 4
      Top = 111
      Width = 575
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 5
      inherited edtObject: TEdit
        Width = 529
      end
      inherited btnObject: TButton
        Left = 538
      end
    end
    object btnRefresh: TButton
      Left = 356
      Top = 79
      Width = 75
      Height = 25
      Caption = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100
      TabOrder = 6
      OnClick = btnRefreshClick
    end
  end
end
