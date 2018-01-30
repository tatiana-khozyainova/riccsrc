object frmCommonList: TfrmCommonList
  Left = 0
  Top = 0
  Width = 760
  Height = 462
  TabOrder = 0
  object Splitter1: TSplitter
    Left = 185
    Top = 49
    Height = 413
    AutoSnap = False
    MinSize = 300
  end
  object tlbrEditList: TToolBar
    Left = 0
    Top = 0
    Width = 760
    Height = 29
    ButtonHeight = 21
    ButtonWidth = 60
    Caption = 'tlbrEditList'
    ShowCaptions = True
    TabOrder = 0
    object ToolButton1: TToolButton
      Left = 0
      Top = 2
      Action = actnAddObject
    end
    object ToolButton2: TToolButton
      Left = 60
      Top = 2
      Action = actnStartEdit
    end
    object ToolButton3: TToolButton
      Left = 120
      Top = 2
      Action = actnFinishEdit
    end
    object ToolButton4: TToolButton
      Left = 180
      Top = 2
      Action = actnCancelEdit
    end
    object ToolButton5: TToolButton
      Left = 240
      Top = 2
      Action = actnDeleteObject
    end
  end
  object pnlProperties: TPanel
    Left = 188
    Top = 49
    Width = 572
    Height = 413
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 1
  end
  object pnlList: TPanel
    Left = 0
    Top = 49
    Width = 185
    Height = 413
    Align = alLeft
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 2
    object lbxObjects: TListBox
      Left = 1
      Top = 1
      Width = 183
      Height = 411
      Align = alClient
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 0
      OnClick = lbxObjectsClick
    end
  end
  object sbReport: TStatusBar
    Left = 0
    Top = 29
    Width = 760
    Height = 20
    Align = alTop
    Panels = <>
    SimplePanel = True
  end
  object actnCommonList: TActionList
    Left = 416
    Top = 48
    object actnAddObject: TAction
      Category = #1044#1077#1081#1089#1090#1074#1080#1103
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnExecute = actnAddObjectExecute
      OnUpdate = actnAddObjectUpdate
    end
    object actnStartEdit: TAction
      Category = #1044#1077#1081#1089#1090#1074#1080#1103
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      OnExecute = actnStartEditExecute
      OnUpdate = actnStartEditUpdate
    end
    object actnFinishEdit: TAction
      Category = #1044#1077#1081#1089#1090#1074#1080#1103
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ShortCut = 13
      OnExecute = actnFinishEditExecute
      OnUpdate = actnFinishEditUpdate
    end
    object actnCancelEdit: TAction
      Category = #1044#1077#1081#1089#1090#1074#1080#1103
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      OnExecute = actnCancelEditExecute
      OnUpdate = actnCancelEditUpdate
    end
    object actnDeleteObject: TAction
      Category = #1044#1077#1081#1089#1090#1074#1080#1103
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnExecute = actnDeleteObjectExecute
      OnUpdate = actnDeleteObjectUpdate
    end
  end
end
