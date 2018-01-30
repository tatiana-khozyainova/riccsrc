object frmAddObject: TfrmAddObject
  Left = 0
  Top = 0
  Width = 443
  Height = 277
  Align = alClient
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 228
    Width = 443
    Height = 49
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      443
      49)
    object BitBtn1: TBitBtn
      Left = 377
      Top = 12
      Width = 80
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 0
      NumGlyphs = 2
    end
    object BitBtn2: TBitBtn
      Left = 289
      Top = 12
      Width = 80
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 443
    Height = 228
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object gbx: TGroupBox
      Left = 0
      Top = 0
      Width = 280
      Height = 228
      Align = alClient
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1086#1073#1098#1077#1082#1090#1072
      TabOrder = 0
      DesignSize = (
        280
        228)
      object edtName: TEdit
        Left = 8
        Top = 22
        Width = 266
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        TabOrder = 0
      end
    end
    inline frmFilterDicts: TfrmFilter
      Left = 280
      Top = 0
      Width = 163
      Height = 228
      Align = alRight
      TabOrder = 1
      inherited gbx: TGroupBox
        Width = 163
        Height = 228
        inherited cbxActiveObject: TComboEdit
          Width = 148
        end
      end
    end
  end
  object actnLst: TActionList
    Left = 128
    Top = 8
    object actnSave: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    end
  end
end
