unit LicenseZoneSelectForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonIDObjectListForm, CommonIDObjectListFrame, StdCtrls,
  ExtCtrls;

type
  TfrmLicenseZoneSelectForm = class(TfrmIDObjectList)
    procedure frmIDObjectListFramelwObjectsDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmLicenseZoneSelectForm: TfrmLicenseZoneSelectForm;

implementation

uses Facade;

{$R *.dfm}

constructor TfrmLicenseZoneSelectForm.Create(AOwner: TComponent);
begin
  inherited;
  IDObjects := fc.AllLicenseZones;
  Caption := 'Лицензионный участок';
end;

procedure TfrmLicenseZoneSelectForm.frmIDObjectListFramelwObjectsDblClick(
  Sender: TObject);
begin
  ModalResult := mrOK;
end;

end.
