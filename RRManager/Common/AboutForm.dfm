object frmAbout: TfrmAbout
  Left = 319
  Top = 204
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'О программе'
  ClientHeight = 201
  ClientWidth = 396
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnMouseMove = FormMouseMove
  PixelsPerInch = 96
  TextHeight = 13
  object lblName: TLabel
    Left = 65
    Top = 5
    Width = 330
    Height = 36
    Alignment = taCenter
    AutoSize = False
    Caption = 'Редактор стратиграфических разбивок'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
  end
  object Label1: TLabel
    Left = 123
    Top = 110
    Width = 271
    Height = 19
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Проект: Хозяинова Т.В.'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 64
    Top = 153
    Width = 163
    Height = 44
    Cursor = crHandPoint
    Hint = 'Отправить e-mail автору|mailto:radonly@pisem.net'
    AutoSize = False
    Caption = 
      'Программирование: Группа системного и программного обслуживания ' +
      'РИКЦ'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    WordWrap = True
    OnClick = Label2Click
  end
  object Label3: TLabel
    Left = 53
    Top = 128
    Width = 342
    Height = 26
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Консультанты: Королькова Л.А., Ларионова З.В., Мельников С.В.'
    WordWrap = True
  end
  object imgPassportIcon: TImage
    Left = 12
    Top = 2
    Width = 36
    Height = 36
    Center = True
    Stretch = True
    Transparent = True
  end
  object btnOK: TButton
    Left = 315
    Top = 166
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
    OnClick = btnOKClick
  end
  object Panel1: TPanel
    Left = 54
    Top = -3
    Width = 3
    Height = 207
    BevelInner = bvRaised
    TabOrder = 2
  end
  object Panel2: TPanel
    Left = -3
    Top = 145
    Width = 401
    Height = 3
    BevelInner = bvLowered
    BevelOuter = bvLowered
    TabOrder = 3
  end
  object StaticText1: TStaticText
    Left = -1
    Top = 41
    Width = 399
    Height = 17
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = 'Программа разработана ТП НИЦ'
    TabOrder = 1
  end
end
