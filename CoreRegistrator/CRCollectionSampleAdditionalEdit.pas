unit CRCollectionSampleAdditionalEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, ComCtrls, CRBoxPictureFrame, StdCtrls;

type
  TfrmAdditionalSampleEdit = class(TfrmCommonFrame)
    gbxAdditionals: TGroupBox;
    mmBindingComment: TMemo;
    txtBindingComment: TStaticText;
    txtCommend: TStaticText;
    mmComment: TMemo;
    txtPhoto: TStaticText;
    frmPic: TfrmBoxPicture;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAdditionalSampleEdit: TfrmAdditionalSampleEdit;

implementation

{$R *.dfm}

end.
