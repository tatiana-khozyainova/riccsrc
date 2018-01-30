unit CRCoreLiquidationForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DialogForm, ImgList, ActnList, FramesWizard, ComCtrls, ToolWin;

type
  TfrmCoreLiquidationForm = class(TCommonDialogForm)
  private
    { Private declarations }
  public
    { Public declarations }
  constructor Create(AOwner: TComponent); override;
  end;

var
  frmCoreLiquidationForm: TfrmCoreLiquidationForm;

implementation

uses CRCoreLiqidationFrame, Facade, CRIntervalFrame;

{$R *.dfm}


constructor TfrmCoreLiquidationForm.Create(AOwner: TComponent);
begin
  inherited;
  dlg.Clear;
  dlg.AddFrame(TfrmCoreLiquidaton);
  dlg.ActiveFrameIndex := 0;

 // Width := 570;
  //Height := 720;

end;



end.
