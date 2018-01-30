inherited frmGenSectionEdit: TfrmGenSectionEdit
  Width = 586
  Height = 413
  inherited StatusBar: TStatusBar
    Top = 394
    Width = 586
  end
  object gbxGenSection: TGroupBox
    Left = 0
    Top = 0
    Width = 586
    Height = 394
    Align = alClient
    Caption = #1056#1077#1076#1072#1082#1094#1080#1103' '#1089#1074#1086#1076#1085#1086#1075#1086' '#1088#1072#1079#1088#1077#1079#1072
    TabOrder = 1
    DesignSize = (
      586
      394)
    object lblGenSectionName: TLabel
      Left = 8
      Top = 24
      Width = 121
      Height = 13
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1088#1072#1079#1088#1077#1079#1072
    end
    object edtGenSectionName: TEdit
      Left = 8
      Top = 48
      Width = 566
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    inline frmBaseStratigraphyName: TfrmIDObjectSelect
      Left = 5
      Top = 104
      Width = 287
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      inherited edtObject: TEdit
        Width = 241
      end
      inherited btnObject: TButton
        Left = 250
      end
    end
    inline frmTopStratigraphyName: TfrmIDObjectSelect
      Left = 299
      Top = 104
      Width = 270
      Height = 46
      Anchors = [akTop, akRight]
      TabOrder = 2
      inherited edtObject: TEdit
        Width = 224
      end
      inherited btnObject: TButton
        Left = 233
      end
    end
  end
end
