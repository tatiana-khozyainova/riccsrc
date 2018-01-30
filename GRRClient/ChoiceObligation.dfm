object frmObligationChoice: TfrmObligationChoice
  Left = 0
  Top = 0
  Width = 823
  Height = 501
  TabOrder = 0
  object pgctlObligations: TPageControl
    Left = 0
    Top = 0
    Width = 823
    Height = 501
    ActivePage = tshNir
    Align = alClient
    MultiLine = True
    RaggedRight = True
    TabOrder = 0
    TabPosition = tpBottom
    object tshDrilling: TTabSheet
      Caption = #1041#1091#1088#1077#1085#1080#1077
      inline frmDrilling: TfrmDrillingPlan
        Left = 0
        Top = 0
        Width = 815
        Height = 475
        Align = alClient
        TabOrder = 0
        inherited grdvwDrillingPlan: TGridView
          Width = 815
          Height = 448
        end
        inherited frmObligationTools1: TfrmObligationTools
          Width = 815
          inherited tlbr1: TToolBar
            Width = 815
          end
        end
      end
    end
    object tshSeismic: TTabSheet
      Caption = #1057#1077#1081#1089#1084#1086#1088#1072#1079#1074#1077#1076#1086#1095#1085#1099#1077' '#1088#1072#1073#1086#1090#1099
      ImageIndex = 1
      inline frmSeismPlan1: TfrmSeismPlan
        Left = 0
        Top = 0
        Width = 815
        Height = 475
        Align = alClient
        TabOrder = 0
        inherited grdvwSeismPlan: TGridView
          Width = 815
          Height = 448
        end
        inherited frmObligationTools1: TfrmObligationTools
          Width = 815
          inherited tlbr1: TToolBar
            Width = 815
          end
        end
      end
    end
    object tshNir: TTabSheet
      Caption = #1053#1048#1056
      ImageIndex = 2
      inline frmNirPlan1: TfrmNirPlan
        Left = 0
        Top = 0
        Width = 815
        Height = 475
        Align = alClient
        TabOrder = 0
        inherited grdvwNirPlan: TGridView
          Width = 815
          Height = 448
        end
        inherited frmObligationTools1: TfrmObligationTools
          Width = 815
          inherited tlbr1: TToolBar
            Width = 815
          end
        end
      end
    end
  end
end
