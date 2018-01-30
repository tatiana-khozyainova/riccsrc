unit RRManagerLicenseZoneSitingInfoFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, CommonComplexCombo, RRManagerObjects, RRManagerBaseObjects,
  RRManagerbaseGUI, RRManageCoordEditFrame, FramesWizard;

type
  //TfrmLicenseZoneSitingInfo = class(TFrame)
  TfrmLicenseZoneSitingInfo = class(TBaseFrame)
    gbxSiting: TGroupBox;
    cmplxPetrolRegion: TfrmComplexCombo;
    cmplxTectStruct: TfrmComplexCombo;
    cmplxDistrict: TfrmComplexCombo;
    frmCoordsEdit: TfrmCoordsEdit;
  private
    { Private declarations }
    function GetLicenseZone: TOldLicenseZone;
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure FillParentControls; override;
    procedure ClearControls; override;
    procedure RegisterInspector; override;
  public
    { Public declarations }
    property    LicenseZone: TOldLicenseZone read GetLicenseZone;
    constructor Create(AOwner: TComponent); override;
    procedure   Save; override;
  end;

implementation

{$R *.dfm}

{ TfrmLicenseZoneSitingInfo }

procedure TfrmLicenseZoneSitingInfo.ClearControls;
begin
  cmplxPetrolRegion.Clear;
  cmplxTectStruct.Clear;
  cmplxDistrict.Clear;
  frmCoordsEdit.Clear;
end;

constructor TfrmLicenseZoneSitingInfo.Create(AOwner: TComponent);
begin
  inherited;

  EditingClass := TOldLicenseZone;

  cmplxDistrict.Caption := 'Географический регион';
  cmplxDistrict.FullLoad := true;
  cmplxDistrict.DictName := 'TBL_DISTRICT_DICT';

  cmplxTectStruct.Caption := 'Тектоническая структура';
  cmplxTectStruct.FullLoad := true;
  cmplxTectStruct.DictName := 'TBL_TECTONIC_STRUCT_DICT';

  cmplxPetrolRegion.Caption := 'Нефтегазоносный регион';
  cmplxPetrolRegion.FullLoad := true;
  cmplxPetrolRegion.DictName := 'TBL_PETROLIFEROUS_REGION_DICT';
end;

procedure TfrmLicenseZoneSitingInfo.FillControls(ABaseObject: TBaseObject);
var l: TOldLicenseZone;
begin
  if not Assigned(ABaseObject) then l := LicenseZone
  else l := ABaseObject as TOldLicenseZone;

  cmplxPetrolRegion.AddItem(l.PetrolRegionID, l.PetrolRegion);
  cmplxTectStruct.AddItem(l.PetrolRegionID, l.PetrolRegion);
  cmplxDistrict.AddItem(l.DistrictID, l.District);


  Check;
  //frmCoordsEdit.Coords := l.Coords;
end;

procedure TfrmLicenseZoneSitingInfo.FillParentControls;
begin
  
end;

function TfrmLicenseZoneSitingInfo.GetLicenseZone: TOldLicenseZone;
begin
  Result := nil;
  if EditingObject is TOldLicenseZone then
    Result := EditingObject as TOldLicenseZone;
end;

procedure TfrmLicenseZoneSitingInfo.RegisterInspector;
begin
  inherited;

  Inspector.Add(cmplxDistrict.cmbxName, nil, ptString, 'географический регион', false);
end;

procedure TfrmLicenseZoneSitingInfo.Save;
begin
  inherited;

  if not Assigned(EditingObject) then
    FEditingObject := ((Owner as TDialogFrame).Frames[0] as TBaseFrame).EditingObject;

  LicenseZone.PetrolRegionID := cmplxPetrolRegion.SelectedElementID;
  LicenseZone.PetrolRegion := cmplxPetrolRegion.SelectedElementName;

  LicenseZone.DistrictID := cmplxDistrict.SelectedElementID;
  LicenseZone.District := cmplxDistrict.SelectedElementName;

  LicenseZone.TectonicStructID := cmplxTectStruct.SelectedElementID;
  LicenseZone.TectonicStruct := cmplxTectStruct.SelectedElementName;

  //LicenseZone.Coords.Assign(frmCoordsEdit.Coords);
end;

end.
