unit FrameEditProfile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls;

type
  TFrame8 = class(TFrame)
    cbbSelectProfile: TComboBox;
    edtNumberProfile: TEdit;
    edtBeginPiket: TEdit;
    edtEndPiket: TEdit;
    edtLengthProfile: TEdit;
    edtCommentProfile: TEdit;
    cbbTypeProfile: TComboBox;
    lstCoordProfile: TListBox;
    edtNumberCoord: TEdit;
    edtCoordX: TEdit;
    edtCoordY: TEdit;
    btnAddCoord: TButton;
    btnUpCoord: TButton;
    btnDelCoord: TButton;
    cbbSeisMaterial: TComboBox;
    btnAddProfile: TButton;
    btnUpProfile: TButton;
    btnDelProfile: TButton;
    txtNumberProfile: TStaticText;
    txtTypeProfile: TStaticText;
    txtBeginPiket: TStaticText;
    txtEndPiket: TStaticText;
    txtLenghtProfile: TStaticText;
    txtCommentProfile: TStaticText;
    txtSeisMaterial: TStaticText;
    txtNumberCoord: TStaticText;
    txtCoordX: TStaticText;
    txtCoordY: TStaticText;
    rgProfile: TRadioGroup;
    grp1: TGroupBox;
    grp2: TGroupBox;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



end.
