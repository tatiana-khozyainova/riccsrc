unit FrameEditSMExemple;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls;

type
  TFrame6 = class(TFrame)
    txtSelectMaterial: TStaticText;
    cbbSelectMaterial: TComboBox;
    lstExempleCurrent: TListBox;
    cbbTypeExemple: TComboBox;
    cbbLocExemple: TComboBox;
    edtCountExemple: TEdit;
    edtCommentExemple: TEdit;
    txtTypeExemple: TStaticText;
    txtLocExemple: TStaticText;
    txtCountExemple: TStaticText;
    txtCommentExemple: TStaticText;
    lstElement: TListBox;
    cbbTypeElement: TComboBox;
    edtNumberElement: TEdit;
    edtCommentElement: TEdit;
    txtTypeElement: TStaticText;
    txtNumberElement: TStaticText;
    txtCommentElement: TStaticText;
    btnAddExemple: TButton;
    btnUpExemple: TButton;
    btnDelExemple: TButton;
    btnAddElement: TButton;
    btnUpElement: TButton;
    btnDelElement: TButton;
    edtNameElement: TEdit;
    edtLocationElement: TEdit;
    txtNameElement: TStaticText;
    txtLocationElement: TStaticText;
    grp1: TGroupBox;
    grp2: TGroupBox;
    grp3: TGroupBox;
    
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



end.
