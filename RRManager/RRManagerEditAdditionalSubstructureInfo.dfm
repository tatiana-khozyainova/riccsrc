object frmAdditionalSubstructureInfo: TfrmAdditionalSubstructureInfo
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object gbxAll: TGroupBox
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    Align = alClient
    Caption = 'Параметры подструктуры'
    TabOrder = 0
    object Label1: TLabel
      Left = 6
      Top = 28
      Width = 21
      Height = 13
      Caption = 'НГК'
    end
    object Label2: TLabel
      Left = 152
      Top = 28
      Width = 22
      Height = 13
      Caption = 'ВНК'
    end
    object Label3: TLabel
      Left = 6
      Top = 77
      Width = 140
      Height = 13
      Caption = 'Высота ожидаемой залежи'
    end
    object Label4: TLabel
      Left = 152
      Top = 77
      Width = 149
      Height = 13
      Caption = 'Площадь ожидаемой залежи'
    end
    object edtNGK: TEdit
      Left = 6
      Top = 46
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object edtVNK: TEdit
      Left = 152
      Top = 46
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object edtBedHeight: TEdit
      Left = 6
      Top = 95
      Width = 121
      Height = 21
      TabOrder = 2
    end
    object edtArea: TEdit
      Left = 152
      Top = 95
      Width = 121
      Height = 21
      TabOrder = 3
    end
  end
end
