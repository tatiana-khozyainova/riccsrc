unit RRManagerChangeLicenseZoneFundFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RRManagerBaseGUI, CommonComplexCombo, StdCtrls, RRManagerObjects,
  RRManagerBaseObjects, BaseObjects;

type
  TfrmChangeLicenseZoneFrame = class(TBaseFrame)
  //TfrmChangeLicenseZoneFrame = class(TFrame)
    gbxStatusChange: TGroupBox;
    cmplxLicenseZoneState: TfrmComplexCombo;
    lblLicenseZone: TStaticText;
  private
    { Private declarations }
    function GetLicenseZone: TOldLicenseZone;
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure ClearControls; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    property    LicenseZone: TOldLicenseZone read GetLicenseZone;
    procedure   Save; override;

  end;

implementation

{$R *.dfm}

{ TfrmChangeLicenseZoneFrame }

procedure TfrmChangeLicenseZoneFrame.ClearControls;
begin
  inherited;

end;

constructor TfrmChangeLicenseZoneFrame.Create(AOwner: TComponent);
begin
  inherited;
  EditingClass := TOldLicenseZone;

  cmplxLicenseZoneState.Caption := 'Статус участка';
  cmplxLicenseZoneState.FullLoad := true;
  cmplxLicenseZoneState.DictName := 'TBL_LICENSE_ZONE_STATE_DICT';
end;

procedure TfrmChangeLicenseZoneFrame.FillControls(
  ABaseObject: TBaseObject);
begin
  inherited;
  lblLicenseZone.Caption := Format('Вид фонда для лицензионного участка %s, находящегося в фонде %s, будет изменен на ', [(ABaseObject as TOldLicenseZone).List(loFull, false, false), (ABaseObject as TOldLicenseZone).LicenseZoneState]);
  cmplxLicenseZoneState.AddItem((ABaseObject as TOldLicenseZone).LicenseZoneStateID, (ABaseObject as TOldLicenseZone).LicenseZoneState);
end;

function TfrmChangeLicenseZoneFrame.GetLicenseZone: TOldLicenseZone;
begin
  Result := nil;
  if EditingObject is TOldLicenseZone then
    Result := EditingObject as TOldLicenseZone;
end;

procedure TfrmChangeLicenseZoneFrame.Save;
begin
  inherited;

  LicenseZone.LicenseZoneStateID := cmplxLicenseZoneState.SelectedElementID;
  LicenseZone.LicenseZoneState := cmplxLicenseZoneState.SelectedElementName;
end;

end.
