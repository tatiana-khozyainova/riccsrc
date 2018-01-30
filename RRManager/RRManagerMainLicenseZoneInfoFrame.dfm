object frmLicenseZoneMainInfo: TfrmLicenseZoneMainInfo
  Left = 0
  Top = 0
  Width = 661
  Height = 457
  TabOrder = 0
  object gbxAll: TGroupBox
    Left = 0
    Top = 0
    Width = 661
    Height = 457
    Align = alClient
    Caption = #1051#1080#1094#1077#1085#1079#1080#1086#1085#1085#1099#1081' '#1091#1095#1072#1089#1090#1086#1082' - '#1086#1089#1085#1086#1074#1085#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103
    TabOrder = 0
    DesignSize = (
      661
      457)
    object Label1: TLabel
      Left = 6
      Top = 147
      Width = 168
      Height = 13
      Caption = #1062#1077#1083#1077#1074#1086#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077' '#1080' '#1074#1080#1076' '#1088#1072#1073#1086#1090
    end
    object Label4: TLabel
      Left = 8
      Top = 104
      Width = 92
      Height = 13
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1091#1095#1072#1089#1090#1082#1072
    end
    object mmGoal: TMemo
      Left = 5
      Top = 163
      Width = 652
      Height = 89
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = mmGoalChange
    end
    object GroupBox1: TGroupBox
      Left = 4
      Top = 24
      Width = 650
      Height = 73
      Anchors = [akLeft, akTop, akRight]
      Caption = #1043#1086#1089#1091#1076#1072#1088#1089#1090#1074#1077#1085#1085#1099#1081' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1086#1085#1085#1099#1081' '#1085#1086#1084#1077#1088
      TabOrder = 1
      DesignSize = (
        650
        73)
      object Label2: TLabel
        Left = 9
        Top = 24
        Width = 34
        Height = 13
        Caption = #1053#1086#1084#1077#1088
      end
      object Label3: TLabel
        Left = 380
        Top = 24
        Width = 31
        Height = 13
        Caption = #1057#1077#1088#1080#1103
      end
      object edtNumber: TEdit
        Left = 8
        Top = 40
        Width = 121
        Height = 21
        TabOrder = 0
      end
      inline cmplxLicenseType: TfrmComplexCombo
        Left = 130
        Top = 20
        Width = 247
        Height = 46
        TabOrder = 1
        inherited cmbxName: TComboBox
          Top = 20
          Width = 214
        end
        inherited btnShowAdditional: TButton
          Left = 220
          Top = 18
        end
      end
      object cmbxSeria: TComboBox
        Left = 379
        Top = 40
        Width = 78
        Height = 21
        ItemHeight = 13
        TabOrder = 2
        Items.Strings = (
          #1057#1067#1050)
      end
      inline cmplxLicenseZoneState: TfrmComplexCombo
        Left = 460
        Top = 19
        Width = 185
        Height = 46
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 3
        inherited cmbxName: TComboBox
          Width = 152
        end
        inherited btnShowAdditional: TButton
          Left = 158
        end
      end
    end
    object edtName: TEdit
      Left = 7
      Top = 120
      Width = 413
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
    end
    inline cmplxLicenseZoneType: TfrmComplexCombo
      Left = 423
      Top = 99
      Width = 228
      Height = 46
      Anchors = [akTop, akRight]
      TabOrder = 3
      inherited cmbxName: TComboBox
        Width = 195
      end
      inherited btnShowAdditional: TButton
        Left = 201
      end
    end
    object gbxPerspective: TGroupBox
      Left = 8
      Top = 272
      Width = 649
      Height = 81
      Caption = #1055#1077#1088#1089#1087#1077#1082#1090#1080#1074#1085#1099#1081' '#1091#1095#1072#1089#1090#1086#1082
      TabOrder = 4
      object Label6: TLabel
        Left = 271
        Top = 18
        Width = 89
        Height = 13
        Caption = #1044#1072#1090#1072' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103
      end
      object dtmCompetitionDate: TDateEdit
        Left = 270
        Top = 40
        Width = 121
        Height = 21
        DefaultToday = True
        NumGlyphs = 2
        TabOrder = 0
      end
      inline cmplxConcursType: TfrmComplexCombo
        Left = 10
        Top = 20
        Width = 247
        Height = 46
        TabOrder = 1
        inherited cmbxName: TComboBox
          Width = 214
        end
        inherited btnShowAdditional: TButton
          Left = 220
        end
      end
    end
  end
end
