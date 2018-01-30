object TreeNodeBaseFrame: TTreeNodeBaseFrame
  Left = 0
  Top = 0
  Width = 493
  Height = 232
  TabOrder = 0
  object pnlPlanName: TPanel
    Left = 0
    Top = 0
    Width = 493
    Height = 26
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object lbFrameCaption: TLabel
      Left = 28
      Top = 6
      Width = 3
      Height = 13
    end
    object FrameImage: TPaintBox
      Left = 3
      Top = 4
      Width = 18
      Height = 18
      OnPaint = FrameImagePaint
    end
  end
end
