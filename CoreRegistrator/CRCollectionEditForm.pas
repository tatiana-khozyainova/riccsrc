unit CRCollectionEditForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonIDObjectEditForm;

type
  TfrmCollectionEditForm = class(TfrmIDObjectEdit)
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmCollectionEditForm: TfrmCollectionEditForm;

implementation

uses CRCollectionEditFrame, FramesWizard;

{$R *.dfm}

{ TfrmIDObjectEdit1 }

constructor TfrmCollectionEditForm.Create(AOwner: TComponent);
begin
  inherited;
  dlg.Clear;
  dlg.AddFrame(TfrmCollectionEditFrame);

  dlg.ActiveFrameIndex := 0;
  dlg.Buttons := [btFinish, btCancel];
end;

end.
 