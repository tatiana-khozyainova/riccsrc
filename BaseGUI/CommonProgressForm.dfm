object frmProgress: TfrmProgress
  Left = 276
  Top = 125
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsNone
  ClientHeight = 51
  ClientWidth = 286
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    286
    51)
  PixelsPerInch = 96
  TextHeight = 13
  object prg: TProgressBar
    Left = 8
    Top = 16
    Width = 267
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Step = 1
    TabOrder = 0
  end
end
