inherited frmAdditionalSampleEdit: TfrmAdditionalSampleEdit
  Width = 660
  Height = 718
  inherited StatusBar: TStatusBar
    Top = 693
    Width = 660
    Height = 25
  end
  object gbxAdditionals: TGroupBox
    Left = 0
    Top = 0
    Width = 660
    Height = 693
    Align = alClient
    Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
    TabOrder = 1
    DesignSize = (
      660
      693)
    object mmBindingComment: TMemo
      Left = 8
      Top = 40
      Width = 644
      Height = 89
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object txtBindingComment: TStaticText
      Left = 8
      Top = 19
      Width = 289
      Height = 17
      AutoSize = False
      Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081' '#1082' '#1087#1088#1080#1074#1103#1079#1082#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object txtCommend: TStaticText
      Left = 8
      Top = 133
      Width = 241
      Height = 17
      AutoSize = False
      Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
    object mmComment: TMemo
      Left = 8
      Top = 152
      Width = 644
      Height = 132
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
    end
    object txtPhoto: TStaticText
      Left = 8
      Top = 302
      Width = 115
      Height = 17
      Caption = #1060#1086#1090#1086#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
    end
    inline frmPic: TfrmBoxPicture
      Left = 2
      Top = 320
      Width = 656
      Height = 371
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 5
      inherited ToolBar1: TToolBar
        Width = 656
      end
      inherited grbx: TGroupBox
        Width = 656
        Height = 284
        inherited Image1: TImage
          Left = 16
          Top = 24
        end
      end
      inherited GroupBox2: TGroupBox
        Width = 656
        inherited edtPath: TEdit
          Width = 639
        end
      end
    end
  end
end
