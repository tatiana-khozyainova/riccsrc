unit RRManagerEditMainHorizonInfoFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CommonComplexCombo, StdCtrls, RRmanagerBaseObjects,
  RRManagerObjects, RRManagerBaseGUI;

type
//  TfrmMainHorizonInfo = class(TFrame)
  TfrmMainHorizonInfo = class(TBaseFrame)
    gbxAll: TGroupBox;
    cmplxOrganization: TfrmComplexCombo;
    cmplxFirstStratum: TfrmComplexCombo;
    chbxOutOfFund: TCheckBox;
  private
    { Private declarations }
    function GetHorizon: TOldHorizon;
    function GetStructure: TOldStructure;
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
    procedure RegisterInspector; override;
  public
    { Public declarations }
    property    Structure: TOldStructure read GetStructure;
    property    Horizon: TOldHorizon read GetHorizon;
    constructor Create(AOwner: TComponent); override;
    procedure   Save; override;
  end;

implementation

{$R *.DFM}

{ TfrmMainHorizonInfo }

procedure TfrmMainHorizonInfo.ClearControls;
begin
  cmplxOrganization.Clear;
  cmplxFirstStratum.Clear;
  if Assigned(Structure) then
    FEditingObject := Structure.Horizons.Add;

end;

constructor TfrmMainHorizonInfo.Create(AOwner: TComponent);
begin
  inherited;
  EditingClass := TOldHorizon;
  ParentClass  := TOldStructure;

  cmplxFirstStratum.Caption := 'Горизонт (от)';
  cmplxFirstStratum.FullLoad := true;
  cmplxFirstStratum.DictName := 'TBL_CONCRETE_STRATUM';


  cmplxOrganization.Caption := 'Организация-недропользователь';
  cmplxOrganization.FullLoad := false;
  cmplxOrganization.DictName := 'TBL_ORGANIZATION_DICT';

end;

procedure TfrmMainHorizonInfo.FillControls(ABaseObject: TBaseObject);
var h: TOldHorizon;
begin
  if not Assigned(ABaseObject) then H := Horizon
  else H := ABaseObject as TOldHorizon;

  cmplxOrganization.AddItem(H.OrganizationID, H.Organization);
  cmplxFirstStratum.AddItem(H.FirstStratumID, H.FirstStratum);

//  Check;
end;

procedure TfrmMainHorizonInfo.FillParentControls;
begin
  inherited;
  ClearControls;
  cmplxOrganization.AddItem(Structure.OrganizationID, Structure.Organization);
  if Assigned(Structure) then
    FEditingObject := Structure.Horizons.Add;  
end;

function TfrmMainHorizonInfo.GetHorizon: TOldHorizon;
begin
  if EditingObject is TOldHorizon then
    Result := EditingObject as TOldHorizon
  else Result := nil;
end;

function TfrmMainHorizonInfo.GetStructure: TOldStructure;
begin
  Result := nil;
  if EditingObject is TOldStructure then
    Result := EditingObject as TOldStructure
  else if EditingObject is TOldHorizon then
    Result := (EditingObject as TOldHorizon).Structure;
end;

procedure TfrmMainHorizonInfo.RegisterInspector;
begin
  inherited;
  // регистрируем контролы, которые под инспектором
  Inspector.Add(cmplxFirstStratum.cmbxName, nil, ptString, 'горизонт (от)', false);
end;

procedure TfrmMainHorizonInfo.Save;
begin
  inherited;
  if EditingObject is TOldStructure then
    FEditingObject := Structure.Horizons.Add;

  Horizon.OrganizationID := cmplxOrganization.SelectedElementID;
  Horizon.Organization   := cmplxOrganization.SelectedElementName;

  Horizon.FirstStratumID := cmplxFirstStratum.SelectedElementID;
  Horizon.FirstStratum   := cmplxFirstStratum.SelectedElementName;

  Horizon.SecondStratumID := cmplxFirstStratum.SelectedElementID;
  Horizon.SecondStratum   := cmplxFirstStratum.SelectedElementName;

  Horizon.ComplexID := 0;
  Horizon.Complex   := '<нет>';


  Horizon.OutOfFund := chbxOutOfFund.Checked;
end;


end.
