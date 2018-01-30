object frmLicenseZoneOrganizationInfo: TfrmLicenseZoneOrganizationInfo
  Left = 334
  Top = 205
  Width = 680
  Height = 571
  TabOrder = 0
  object gbxOrganization: TGroupBox
    Left = 0
    Top = 0
    Width = 672
    Height = 536
    Align = alClient
    Caption = 'Лицензирование'
    TabOrder = 0
    DesignSize = (
      672
      536)
    inline cmplxOwner: TfrmComplexCombo
      Left = 6
      Top = 102
      Width = 668
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      inherited btnShowAdditional: TButton
        Left = 641
      end
      inherited cmbxName: TComboBox
        Width = 635
      end
    end
    inline cmplxDeveloper: TfrmComplexCombo
      Left = 4
      Top = 150
      Width = 670
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      inherited btnShowAdditional: TButton
        Left = 643
      end
      inherited cmbxName: TComboBox
        Width = 637
      end
    end
    object gbxHolder: TGroupBox
      Left = 5
      Top = 207
      Width = 671
      Height = 113
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Постановление о праве пользования земельным участком'
      TabOrder = 2
      DesignSize = (
        671
        113)
      object Label1: TLabel
        Left = 553
        Top = 18
        Width = 106
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Дата постановления'
      end
      object Label2: TLabel
        Left = 5
        Top = 61
        Width = 51
        Height = 13
        Caption = 'Документ'
      end
      inline cmplxSiteHolder: TfrmComplexCombo
        Left = 4
        Top = 13
        Width = 545
        Height = 46
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        inherited btnShowAdditional: TButton
          Left = 518
        end
        inherited cmbxName: TComboBox
          Width = 512
        end
      end
      object edtDoc: TEdit
        Left = 5
        Top = 76
        Width = 657
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
      end
      object dtedtDocDate: TDateEdit
        Left = 552
        Top = 35
        Width = 113
        Height = 21
        Anchors = [akTop, akRight]
        NumGlyphs = 2
        TabOrder = 2
      end
    end
    object gbxIssuer: TGroupBox
      Left = 5
      Top = 331
      Width = 670
      Height = 76
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Выдача лицензии'
      TabOrder = 3
      DesignSize = (
        670
        76)
      object Label3: TLabel
        Left = 467
        Top = 20
        Width = 192
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'По государственной власти субъекта'
      end
      inline cmplxIssuer: TfrmComplexCombo
        Left = 5
        Top = 19
        Width = 454
        Height = 46
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        inherited btnShowAdditional: TButton
          Left = 427
        end
        inherited cmbxName: TComboBox
          Width = 421
        end
      end
      object cmbxSubject: TComboBox
        Left = 466
        Top = 40
        Width = 193
        Height = 21
        Style = csDropDownList
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 1
      end
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 16
      Width = 666
      Height = 73
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Сроки действия лицензии'
      TabOrder = 4
      object Label5: TLabel
        Left = 9
        Top = 24
        Width = 183
        Height = 13
        Caption = 'Дата государственной регистрации'
      end
      object Label6: TLabel
        Left = 210
        Top = 25
        Width = 132
        Height = 13
        Caption = 'Срок окончания лицензии'
      end
      object dtedtLicStart: TDateEdit
        Left = 8
        Top = 40
        Width = 193
        Height = 21
        NumGlyphs = 2
        TabOrder = 0
      end
      object dtedtLicFin: TDateEdit
        Left = 209
        Top = 40
        Width = 195
        Height = 21
        NumGlyphs = 2
        TabOrder = 1
      end
    end
  end
end
