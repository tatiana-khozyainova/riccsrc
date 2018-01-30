unit FrameEditSMSeisMaterial;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TFrame5 = class(TFrame)
    cbbSelectMaterial: TComboBox;
    txtSelectMaterial: TStaticText;
    dtpBeginWorks: TDateTimePicker;
    dtpEndWorks: TDateTimePicker;
    txtBeginWorks: TStaticText;
    txtEndWorks: TStaticText;
    cbbTypeWorks: TComboBox;
    cbbMethodWorks: TComboBox;
    txtTypeWorks: TStaticText;
    txtMethodWorks: TStaticText;
    edtScaleWorks: TEdit;
    txtScaleWorks: TStaticText;
    cbbSeisCrews: TComboBox;
    txtSeisCrews: TStaticText;
    edtRefComp: TEdit;
    txtRefComp: TStaticText;
    txtStructMap: TStaticText;
    txtCross: TStaticText;
    cbbProfile: TComboBox;
    lstProfileCurrent: TListBox;
    btnAddProfile: TButton;
    rgProfile: TRadioGroup;
    txtProfile: TStaticText;
    txtProfileNotConnect: TStaticText;
    mmoStructMap: TMemo;
    mmoCross: TMemo;
    grp1: TGroupBox;
    grp2: TGroupBox;
    grp3: TGroupBox;
    btn1: TButton;
    

  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}





end.
