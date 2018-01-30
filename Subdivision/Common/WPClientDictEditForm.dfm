object frmDictEdit: TfrmDictEdit
  Left = 240
  Top = 227
  Width = 518
  Height = 337
  ActiveControl = cmbxDictList
  Caption = 'Редактор справочников'
  Color = clBtnFace
  Constraints.MinHeight = 290
  Constraints.MinWidth = 510
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object lblDictList: TLabel
    Left = 5
    Top = 0
    Width = 111
    Height = 13
    Caption = 'Список справочников'
  end
  object btnRefresh: TSpeedButton
    Left = 360
    Top = 37
    Width = 100
    Height = 25
    Hint = 'Обновить справочник'
    Caption = 'Обновить'
    Flat = True
    OnClick = btnRefreshClick
  end
  object btnFirst: TSpeedButton
    Left = 480
    Top = 60
    Width = 25
    Height = 50
    Hint = 'На первую строку'
    Anchors = [akTop, akRight]
    Flat = True
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      04000000000080000000C40E0000C40E00001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
      7777777777777777777777777777777777777700077777000777777060070060
      7777777706606607777777777066607777777777770607777777770007707700
      0777777060070060777777770660660777777777706660777777777777060777
      7777777777707777777777777777777777777777777777777777}
    Layout = blGlyphTop
    OnClick = btnFirstClick
  end
  object btnLast: TSpeedButton
    Left = 480
    Top = 240
    Width = 25
    Height = 50
    Hint = 'На последнюю строку'
    Anchors = [akRight, akBottom]
    Flat = True
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      04000000000080000000C40E0000C40E00001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
      7777777777777777777777777770777777777777770607777777777770666077
      7777777706606607777777706007006077777700077077000777777777060777
      7777777770666077777777770660660777777770600700607777770007777700
      0777777777777777777777777777777777777777777777777777}
    Layout = blGlyphTop
    OnClick = btnLastClick
  end
  object btnInsert: TSpeedButton
    Left = 480
    Top = 128
    Width = 25
    Height = 25
    Hint = 'Добавить строку'
    Anchors = [akRight]
    Caption = '+'
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = btnInsertClick
  end
  object btnEdit: TSpeedButton
    Left = 480
    Top = 162
    Width = 25
    Height = 25
    Hint = 'Изменить строку'
    Anchors = [akRight]
    Caption = '<>'
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = btnEditClick
  end
  object btnDelete: TSpeedButton
    Left = 480
    Top = 195
    Width = 25
    Height = 25
    Hint = 'Удалить строку'
    Anchors = [akRight]
    Caption = '-'
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = btnDeleteClick
  end
  object lblSearch: TLabel
    Left = 168
    Top = 45
    Width = 79
    Height = 13
    Caption = 'Быстрый поиск'
  end
  object cmbxDictList: TComboBox
    Left = 5
    Top = 15
    Width = 350
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = cmbxDictListChange
  end
  object prgbrDictLoad: TProgressBar
    Left = 0
    Top = 294
    Width = 510
    Height = 16
    Align = alBottom
    Min = 0
    Max = 100
    ParentShowHint = False
    Smooth = True
    Step = 1
    ShowHint = False
    TabOrder = 2
  end
  object strgrCurrentDict: TStringGrid
    Left = 5
    Top = 65
    Width = 470
    Height = 225
    Hint = 
      '|Сортируйте таблицу, щелкая по заголовкам столбцов'#13#10'левой кнопко' +
      'й мыши, удерживая Shift'
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 2
    DefaultColWidth = 100
    DefaultRowHeight = 20
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goTabs]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnDblClick = strgrCurrentDictDblClick
    OnMouseUp = strgrCurrentDictMouseUp
  end
  object edtSearch: TEdit
    Left = 254
    Top = 40
    Width = 100
    Height = 21
    Hint = 'Введите текст для быстрого поиска'
    TabOrder = 3
    OnChange = edtSearchChange
  end
  object chbxShowIDs: TCheckBox
    Left = 5
    Top = 43
    Width = 97
    Height = 17
    Caption = 'Показывать ID справочника'
    TabOrder = 4
    OnClick = chbxShowIDsClick
  end
  object ppmnDictRow: TPopupMenu
    Left = 480
    Top = 20
    object mniEdit: TMenuItem
      Caption = 'Изменить'
      OnClick = btnEditClick
    end
    object mniBreak1: TMenuItem
      Caption = '-'
    end
    object mniInsert: TMenuItem
      Caption = 'Добавить'
      OnClick = btnInsertClick
    end
    object mniBreak2: TMenuItem
      Caption = '-'
    end
    object mniDelete: TMenuItem
      Caption = 'Удалить'
      OnClick = btnDeleteClick
    end
  end
end
