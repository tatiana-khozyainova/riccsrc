unit RRManagerLicenseConditionTypeEditForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonIDObjectEditForm;

type
  TfrmLicenseConditionTypeEdit = class(TfrmIDObjectEdit)
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmLicenseConditionTypeEdit: TfrmLicenseConditionTypeEdit;

implementation

uses RRManagerLicenseConditionTypeEditFrame;

{$R *.dfm}

{ TfrmLicenseConditionTypeEdit }

constructor TfrmLicenseConditionTypeEdit.Create(AOwner: TComponent);
begin
  inherited;
  dlg.Clear;
  dlg.AddFrame(TfrmLicenseConditionTypeEditFrame);

  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := 0;
  Caption := 'Тип условия лицензионного соглашения';
end;

end.
