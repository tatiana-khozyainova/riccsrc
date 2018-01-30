inherited frmRockSampleSizeTypeEditFrame: TfrmRockSampleSizeTypeEditFrame
  Width = 518
  Height = 373
  inherited StatusBar: TStatusBar
    Top = 354
    Width = 518
  end
  inherited gbxObjectInfo: TGroupBox
    Width = 518
    Height = 354
    inherited edtName: TLabeledEdit
      Width = 489
    end
    inherited edtShortName: TLabeledEdit
      Width = 489
    end
    object edtDiameter: TLabeledEdit
      Left = 8
      Top = 160
      Width = 121
      Height = 21
      EditLabel.Width = 68
      EditLabel.Height = 13
      EditLabel.Caption = #1044#1080#1072#1084#1077#1090#1088', '#1084#1084
      TabOrder = 2
    end
    inline frmSampleType: TfrmIDObjectSelect
      Left = 136
      Top = 140
      Width = 375
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
      inherited edtObject: TEdit
        Width = 329
      end
      inherited btnObject: TButton
        Left = 338
      end
    end
    object edtX: TLabeledEdit
      Left = 8
      Top = 224
      Width = 121
      Height = 21
      EditLabel.Width = 74
      EditLabel.Height = 13
      EditLabel.Caption = #1056#1072#1079#1084#1077#1088', X('#1084#1084')'
      TabOrder = 4
    end
    object edtY: TLabeledEdit
      Left = 142
      Top = 224
      Width = 121
      Height = 21
      EditLabel.Width = 74
      EditLabel.Height = 13
      EditLabel.Caption = #1056#1072#1079#1084#1077#1088' Y ('#1084#1084')'
      TabOrder = 5
    end
    object edtZ: TLabeledEdit
      Left = 280
      Top = 224
      Width = 121
      Height = 21
      EditLabel.Width = 74
      EditLabel.Height = 13
      EditLabel.Caption = #1056#1072#1079#1084#1077#1088' Z ('#1084#1084')'
      TabOrder = 6
    end
  end
end
