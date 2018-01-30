unit CRSlottingPlacementEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DialogForm, ToolWin, ComCtrls, FramesWizard, CRSlottingPlacementEditor,
  ImgList, ActnList;

type
  TfrmSlottingPlacementEditForm = class(TCommonDialogForm)
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmSlottingPlacementEditForm: TfrmSlottingPlacementEditForm;

implementation

{$R *.dfm}

{ TfrmSlottingPlacementEditForm }

constructor TfrmSlottingPlacementEditForm.Create(AOwner: TComponent);
begin
  inherited;
  dlg.AddFrame(TfrmSlottingPlacementEdit);

  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := 0;
  Caption := 'Местоположение керна скважины';

  Height := 842;
  Width := 1090;
end;

end.
