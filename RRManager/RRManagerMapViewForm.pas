unit RRManagerMapViewForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RRManagerBaseGUI, RRManagerMapViewFrame, RRManagerBaseObjects,
  RRManagerObjects, BaseObjects;

type
  TfrmViewFundMap = class(TSingleFramedForm, IConcreteVisitor)
  private
    FShowLayers: boolean;
    //FMap: TMgMap;
    FShowToolBar: boolean;
    procedure SetShowLayers(const Value: boolean);
    //function getMap: TMgMap;
    procedure SetShowToolBar(const Value: boolean);
    { Private declarations }
  protected
    procedure   SetEditingObject(const Value: TBaseObject); override;
    function    GetActiveObject: TIDObject;
    procedure   SetActiveObject(const Value: TIDObject);

  public
    { Public declarations }
    procedure VisitVersion(AVersion: TOldVersion);
    procedure VisitStructure(AStructure: TOldStructure);

    procedure VisitDiscoveredStructure(ADiscoveredStructure: TOldDiscoveredStructure);
    procedure VisitPreparedStructure(APreparedStructure: TOldPreparedStructure);
    procedure VisitDrilledStructure(ADrilledStructure: TOldDrilledStructure);
    procedure VisitField(AField: TOldField);

    procedure VisitHorizon(AHorizon: TOldHorizon);

    procedure VisitSubstructure(ASubstructure: TOldSubstructure);

    procedure VisitLayer(ALayer: TOldLayer);

    procedure VisitBed(ABed: TOldBed);
    procedure VisitOldLicenseZone(ALicenseZone: TOldLicenseZone);
    

    procedure VisitAccountVersion(AAccountVersion: TOldAccountVersion);
    procedure VisitStructureHistoryElement(AHistoryElement: TOldStructureHistoryElement);

    procedure VisitWell(AWell: TIDObject);
    procedure VisitTestInterval(ATestInterval: TIDObject);
    procedure VisitLicenseZone(ALicenseZone: TIDObject);
    procedure VisitSlotting(ASlotting: TIDObject);

    procedure VisitCollectionWell(AWell: TIDObject);
    procedure VisitCollectionSample(ACollectionSample: TIDObject);
    procedure VisitDenudation(ADenudation: TIDObject);
    procedure VisitWellCandidate(AWellCandidate: TIDObject);



    //property    Map: TMgMap read getMap;
    constructor Create(AOwner: TComponent); override;
    property    ShowLayers: boolean read FShowLayers write SetShowLayers;
    property    ShowToolBar: boolean read FShowToolBar write SetShowToolBar;
  end;

var
  frmViewFundMap: TfrmViewFundMap;

implementation

{$R *.dfm}

{ TfrmViewFundMap }

constructor TfrmViewFundMap.Create(AOwner: TComponent);
begin
  inherited;
  //FMap := nil;
  FrameClass := TfrmMapView;
  FormStyle := fsStayOnTop;
  ShowButtons := false;
  FShowLayers := true;
  FShowToolBar := true;
end;

function TfrmViewFundMap.GetActiveObject: TIDObject;
begin
  Result := EditingObject;
end;

{function TfrmViewFundMap.getMap: TMGMap;
begin
  if not Assigned(FMap) then FMap := (Frame as  TfrmMapView).mgmFundMap;
  Result := FMap;
end;}

procedure TfrmViewFundMap.SetActiveObject(const Value: TIDObject);
begin

end;

procedure TfrmViewFundMap.SetEditingObject(const Value: TBaseObject);
begin
  inherited;
  
end;

procedure TfrmViewFundMap.SetShowLayers(const Value: boolean);
begin
  if FShowLayers <> Value then
  begin
    FShowLayers := Value;
//    Map.LayersViewWidth := ord(FShowLayers)*150;
//    FM
  end;
end;

procedure TfrmViewFundMap.SetShowToolBar(const Value: boolean);
begin
  if FShowToolBar <> Value then
  begin
    FShowToolBar := Value;
    (Frame as TfrmMapView).tlbrMapEdit.Visible := FShowLayers;
  end;
end;

procedure TfrmViewFundMap.VisitAccountVersion(
  AAccountVersion: TOldAccountVersion);
begin
  EditingObject := AAccountVersion.Structure
end;

procedure TfrmViewFundMap.VisitBed(ABed: TOldBed);
begin
  EditingObject := ABed.Structure;
end;

procedure TfrmViewFundMap.VisitCollectionSample(
  ACollectionSample: TIDObject);
begin

end;

procedure TfrmViewFundMap.VisitCollectionWell(AWell: TIDObject);
begin

end;

procedure TfrmViewFundMap.VisitDenudation(ADenudation: TIDObject);
begin

end;

procedure TfrmViewFundMap.VisitDiscoveredStructure(
  ADiscoveredStructure: TOldDiscoveredStructure);
begin
  EditingObject := ADiscoveredStructure;
end;

procedure TfrmViewFundMap.VisitDrilledStructure(
  ADrilledStructure: TOldDrilledStructure);
begin
  EditingObject := ADrilledStructure;
end;

procedure TfrmViewFundMap.VisitField(AField: TOldField);
begin
  EditingObject := AField;
end;

procedure TfrmViewFundMap.VisitHorizon(AHorizon: TOldHorizon);
begin
  EditingObject := AHorizon.Structure;
end;

procedure TfrmViewFundMap.VisitLayer(ALayer: TOldLayer);
begin
  if Assigned(ALayer.Substructure) then
    EditingObject := ALayer.Substructure.Horizon.Structure
  else
  if Assigned(ALayer.Bed) then
    EditingObject := ALayer.Bed.Structure;
end;

procedure TfrmViewFundMap.VisitLicenseZone(ALicenseZone: TIDObject);
begin

end;

procedure TfrmViewFundMap.VisitOldLicenseZone(ALicenseZone: TOldLicenseZone);
begin

end;

procedure TfrmViewFundMap.VisitPreparedStructure(
  APreparedStructure: TOldPreparedStructure);
begin
  EditingObject := APreparedStructure;
end;

procedure TfrmViewFundMap.VisitSlotting(ASlotting: TIDObject);
begin

end;

procedure TfrmViewFundMap.VisitStructure(AStructure: TOldStructure);
begin
  EditingObject := AStructure;
end;

procedure TfrmViewFundMap.VisitStructureHistoryElement(
  AHistoryElement: TOldStructureHistoryElement);
begin

end;

procedure TfrmViewFundMap.VisitSubstructure(ASubstructure: TOldSubstructure);
begin
  EditingObject := ASubstructure.Horizon.Structure;
end;

procedure TfrmViewFundMap.VisitTestInterval(ATestInterval: TIDObject);
begin

end;

procedure TfrmViewFundMap.VisitVersion(AVersion: TOldVersion);
begin
{ TODO : что-то будет, может быть. возможно подключение соответствующегшо старого слоя }  
end;

procedure TfrmViewFundMap.VisitWell(AWell: TIDObject);
begin

end;

procedure TfrmViewFundMap.VisitWellCandidate(AWellCandidate: TIDObject);
begin

end;

end.
