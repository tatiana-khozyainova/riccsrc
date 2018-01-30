unit CRSampleEditForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DialogForm, ImgList, ActnList, FramesWizard, ComCtrls, ToolWin,
  CRCollectionSampleEdit, CRCollectionSampleAdditionalEdit;

type
  TfrmSampleEditForm = class(TCommonDialogForm)
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmSampleEditForm: TfrmSampleEditForm;

implementation

{$R *.dfm}

{ TfrmSampleEditForm }

constructor TfrmSampleEditForm.Create(AOwner: TComponent);
begin
  inherited;
  dlg.Clear;
  dlg.AddFrame(TfrmCollectionSampleEdit);
  dlg.AddFrame(TfrmAdditionalSampleEdit);
  dlg.ActiveFrameIndex := 0;

  Width := 570;
  Height := 720;
end;

end.
