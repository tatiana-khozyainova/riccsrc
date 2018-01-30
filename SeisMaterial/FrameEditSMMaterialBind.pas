unit FrameEditSMMaterialBind;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls;

type
  TFrame4 = class(TFrame)
    lstMaterialBind: TListBox;
    lstObjectBindAll: TListBox;
    edtMaterialBind: TEdit;
    lstObjectBindCurrent: TListBox;
    txtSelectMaterial: TStaticText;
    cbbSelectMaterial: TComboBox;
    txtObjectBindCurrent: TStaticText;
    txtObjectBindAll: TStaticText;
    grp1: TGroupBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
