unit RRManagerComplexQuickViewFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RRManagerObjects, RRManagerBaseGUI, RRManagerQuickMapViewFrame, BaseObjects;

type
  TfrmComplexMapQuickView = class(TFrame, IConcreteVisitor)
    frmQuickViewStructureMap: TfrmQuickViewMap;
    frmQuickViewFieldMap: TfrmQuickViewMap;
    frmQuickViewBedMap: TfrmQuickViewMap;
    frmQuickViewLicZoneMap: TfrmQuickViewMap;
  private
    { Private declarations }
  protected
    function  GetActiveObject: TIDObject;
    procedure SetActiveObject(const Value: TIDObject);
  public
    { Public declarations }
    procedure VisitVersion(AVersion: TOldVersion);
    procedure VisitStructure(AStructure: TOldStructure);

    procedure VisitDiscoveredStructure(ADiscoveredStructure: TOldDiscoveredStructure);
    procedure VisitPreparedStructure(APreparedStructure: TOldPreparedStructure);
    procedure VisitDrilledStructure(ADrilledStructure: TOldDrilledStructure);
    procedure VisitField(AField: RRManagerObjects.TOldField);

    procedure VisitHorizon(AHorizon: TOldHorizon);

    procedure VisitSubstructure(ASubstructure: TOldSubstructure);

    procedure VisitLayer(ALayer: TOldLayer);

    procedure VisitBed(ABed: TOldBed);
    procedure VisitAccountVersion(AAccountVersion: TOldAccountVersion);
    procedure VisitStructureHistoryElement(AHistoryElement: TOldStructureHistoryElement);
    procedure VisitOldLicenseZone(ALicenseZone: TOldLicenseZone);
    
    procedure Clear;

    procedure VisitWell(AWell: TIDObject);
    procedure VisitTestInterval(ATestInterval: TIDObject);
    procedure VisitLicenseZone(ALicenseZone: TIDObject);
    procedure VisitSlotting(ASlotting: TIDObject);

    procedure VisitCollectionWell(AWell: TIDObject);
    procedure VisitCollectionSample(ACollectionSample: TIDObject);
    procedure VisitDenudation(ADenudation: TIDObject);
    procedure VisitWellCandidate(AWellCandidate: TIDObject);

    

    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

{ TfrmComplexMapQuickView }

procedure TfrmComplexMapQuickView.Clear;
begin

  frmQuickViewLicZoneMap.Visible := true;
  frmQuickViewLicZoneMap.QuickViewObject := nil;

  frmQuickViewStructureMap.Visible := false;
//  frmQuickViewStructureMap.QuickViewObject := nil;

  frmQuickViewFieldMap.Visible := false;
//  frmQuickViewFieldMap.QuickViewObject := nil;

  frmQuickViewBedMap.Visible := false;
//  frmQuickViewBedMap.QuickViewObject := nil;
end;

constructor TfrmComplexMapQuickView.Create(AOwner: TComponent);
begin
  inherited;

  Height := 240;

  with frmQuickViewFieldMap do
  begin
    Visible := true;

    MapPath := 'http://srv2.tprc/map/mwfFiles/fond_mest_mini.mwf';
    LayerName := 'Mest';
    UpdateByName := 'update mest set UIN_Mest = %s, Mest = ' +  '''' + '%s' + '''' +
                    '''' + ' where Mest = '+ '''' + '%s' + '''';
    UpdateByObjectID := 'update mest set UIN_Mest = %s, Mest = ' +  '''' + '%s' + '''' +
                        '''' + ' where ID = '+ '''' + '%s' + '''';

    SelectQry := 'select * from mest where Mest like ' + '''' + '%s' + '''';
    SelectUINed := 'select * from mest where UIN_Mest = %s';
    UpdateUINed := 'update mest set %s = ' + '''' + '%s' + '''' + ' where UIN_Mest = %s';
    ZoomGoToUINed := 'Mest_UIN';
    ZoomGotoNamed := 'Месторождения';
  end;



  with frmQuickViewStructureMap do
  begin
    Visible := true;
    MapPath := 'http://srv2.tprc/map/mwfFiles/fond_mini.mwf';
    LayerName := 'struct';
    UpdateByName := 'update struct set UIN = %s, name = ' +  '''' + '%s' + '''' +
                    ', name_uin = ' + '''' + '%s' + '''' + ' where Name = '+ '''' + '%s' + '''';
    UpdateByObjectID := 'update struct set UIN = %s, name = ' +  '''' + '%s' + '''' +
                        ', name_uin = ' + '''' + '%s' + '''' + ' where ID = '+ '''' + '%s' + '''';

    SelectQry := 'select * from Struct where name like ' + '''' + '%s' + '''';
    SelectUINed := 'select * from Struct where uin = %s';
    UpdateUINed := 'update struct set %s = ' + '''' + '%s' + '''' + ' where uin = %s';
    ZoomGoToUINed := 'Struct_UIN';
    ZoomGotoNamed := 'Структуры';
  end;



  with frmQuickViewBedMap do
  begin
    Visible := true;
    MapPath := 'http://srv2.tprc/map/mwfFiles/bed_mini.mwf';

    LayerName := 'Zalez';
    UpdateByName := 'update zalez set BEDUIN = %s, BalansAge = ' +  '''' + '%s' + '''' +
                    ', name_uin = ' + '''' + '%s' + '''' + ' where Name_UIN like '+ '''' + '%s' + '''';
    SelectQry := 'select * from zalez where Name_UIN like ' + '''' + '%s' + '''';
    SelectUINed := 'select * from zalez where BedUIN = %s';
    UpdateUINed := 'update zalez set %s = ' + '''' + '%s' + '''' + ' where BedUIN = %s';

    ZoomGoToUINed := 'Zalez_UIN';
    ZoomGotoNamed := 'Залежи';
  end;

  with frmQuickViewLicZoneMap do
  begin
    Visible := true;
    MapPath := 'http://srv2.tprc/map/mwfFiles/lic_mini.mwf';
    LayerName := 'LICEN_UCH';
    UpdateByName := 'update LICEN_UCH set UIN_depos = %s, name_Site = ' +  '''' + '%s' + '''' + ' where name_Site = '+ '''' + '%s' + '''';
    UpdateByObjectID := 'update LICEN_UCH set UIN_depos = %s, name_Site = ' +  '''' + '%s' + '''' + ' where UIN_depos = '+ '''' + '%s' + '''';

    SelectQry := 'select * from LICEN_UCH where name_Site like ' + '''' + '%s' + '''';
    SelectUINed := 'select * from LICEN_UCH where UIN_depos = %s';
    UpdateUINed := 'update LICEN_UCH set %s = ' + '''' + '%s' + '''' + ' where UIN_depos = %s';
    ZoomGoToUINed := 'LicZoneUIN';
    ZoomGotoNamed := 'LicZoneName';
  end;
end;

function TfrmComplexMapQuickView.GetActiveObject: TIDObject;
begin
  Result := nil;
end;

procedure TfrmComplexMapQuickView.SetActiveObject(const Value: TIDObject);
begin

end;

procedure TfrmComplexMapQuickView.VisitAccountVersion(
  AAccountVersion: TOldAccountVersion);
begin

end;

procedure TfrmComplexMapQuickView.VisitBed(ABed: TOldBed);
begin
  frmQuickViewStructureMap.Visible := false;
  frmQuickViewFieldMap.Visible := false;
  frmQuickViewBedMap.Visible := true;
  frmQuickViewLicZoneMap.Visible := false;


  Height := frmQuickViewBedMap.Height;
  frmQuickViewBedMap.VisitBed(ABed);
end;

procedure TfrmComplexMapQuickView.VisitCollectionSample(
  ACollectionSample: TIDObject);
begin

end;

procedure TfrmComplexMapQuickView.VisitCollectionWell(AWell: TIDObject);
begin

end;

procedure TfrmComplexMapQuickView.VisitDenudation(ADenudation: TIDObject);
begin

end;

procedure TfrmComplexMapQuickView.VisitDiscoveredStructure(
  ADiscoveredStructure: TOldDiscoveredStructure);
begin
  frmQuickViewStructureMap.Visible := true;
  frmQuickViewFieldMap.Visible := false;
  frmQuickViewBedMap.Visible := false;
  frmQuickViewLicZoneMap.Visible := false;
  
  Height := frmQuickViewStructureMap.Height;

  frmQuickViewStructureMap.VisitDiscoveredStructure(ADiscoveredStructure);
end;

procedure TfrmComplexMapQuickView.VisitDrilledStructure(
  ADrilledStructure: TOldDrilledStructure);
begin
  frmQuickViewStructureMap.Visible := true;
  frmQuickViewFieldMap.Visible := false;
  frmQuickViewBedMap.Visible := false;
  frmQuickViewLicZoneMap.Visible := false;


  Height := frmQuickViewStructureMap.Height;
  frmQuickViewStructureMap.VisitDrilledStructure(ADrilledStructure);
end;

procedure TfrmComplexMapQuickView.VisitField(AField: TOldField);
begin
  frmQuickViewStructureMap.Visible := false;
  frmQuickViewFieldMap.Visible := true;
  frmQuickViewBedMap.Visible := false;
  frmQuickViewLicZoneMap.Visible := false;


  Height := frmQuickViewFieldMap.Height;
  frmQuickViewFieldMap.VisitField(AField);
end;

procedure TfrmComplexMapQuickView.VisitHorizon(AHorizon: TOldHorizon);
begin
  frmQuickViewStructureMap.Visible := true;
  frmQuickViewFieldMap.Visible := false;
  frmQuickViewBedMap.Visible := false;
  frmQuickViewLicZoneMap.Visible := false;


  Height := frmQuickViewStructureMap.Height;

  frmQuickViewStructureMap.VisitHorizon(AHorizon);
end;

procedure TfrmComplexMapQuickView.VisitLayer(ALayer: TOldLayer);
begin
  frmQuickViewStructureMap.Visible := true;
  frmQuickViewFieldMap.Visible := false;
  frmQuickViewBedMap.Visible := false;
  frmQuickViewLicZoneMap.Visible := false;
  
  Height := frmQuickViewStructureMap.Height;
  frmQuickViewStructureMap.VisitLayer(ALayer);
end;

procedure TfrmComplexMapQuickView.VisitLicenseZone(
  ALicenseZone: TIDObject);
begin

end;

procedure TfrmComplexMapQuickView.VisitOldLicenseZone(
  ALicenseZone: TOldLicenseZone);
begin
  frmQuickViewStructureMap.Visible := false;
  frmQuickViewFieldMap.Visible := false;
  frmQuickViewBedMap.Visible := false;
  frmQuickViewLicZoneMap.Visible := true;

  Height := frmQuickViewLicZoneMap.Height;
  frmQuickViewLicZoneMap.VisitLicenseZone(ALicenseZone);
end;

procedure TfrmComplexMapQuickView.VisitPreparedStructure(
  APreparedStructure: TOldPreparedStructure);
begin
  frmQuickViewStructureMap.Visible := true;
  frmQuickViewFieldMap.Visible := false;
  frmQuickViewBedMap.Visible := false;
  frmQuickViewLicZoneMap.Visible := false;

  Height := frmQuickViewStructureMap.Height;
  frmQuickViewStructureMap.VisitPreparedStructure(APreparedStructure);
end;

procedure TfrmComplexMapQuickView.VisitSlotting(ASlotting: TIDObject);
begin

end;

procedure TfrmComplexMapQuickView.VisitStructure(AStructure: TOldStructure);
begin
  if not (AStructure is TOldField) then
  begin
    frmQuickViewStructureMap.Visible := true;
    frmQuickViewFieldMap.Visible := false;
    frmQuickViewBedMap.Visible := false;
    frmQuickViewLicZoneMap.Visible := false;

    Height := frmQuickViewStructureMap.Height;

    frmQuickViewStructureMap.VisitStructure(AStructure);
  end
  else
  begin
    frmQuickViewStructureMap.Visible := false;
    frmQuickViewFieldMap.Visible := true;
    frmQuickViewBedMap.Visible := false;
    frmQuickViewLicZoneMap.Visible := false;

    Height := frmQuickViewFieldMap.Height;

    frmQuickViewFieldMap.VisitField(AStructure as TOldField);
  end;
end;

procedure TfrmComplexMapQuickView.VisitStructureHistoryElement(
  AHistoryElement: TOldStructureHistoryElement);
begin

end;

procedure TfrmComplexMapQuickView.VisitSubstructure(
  ASubstructure: TOldSubstructure);
begin
  frmQuickViewStructureMap.Visible := true;
  frmQuickViewFieldMap.Visible := false;
  frmQuickViewBedMap.Visible := false;
  frmQuickViewLicZoneMap.Visible := false;

  Height := frmQuickViewStructureMap.Height;
  frmQuickViewStructureMap.VisitSubstructure(ASubstructure);
end;

procedure TfrmComplexMapQuickView.VisitTestInterval(
  ATestInterval: TIDObject);
begin

end;

procedure TfrmComplexMapQuickView.VisitVersion(AVersion: TOldVersion);
begin

end;

procedure TfrmComplexMapQuickView.VisitWell(AWell: TIDObject);
begin

end;

procedure TfrmComplexMapQuickView.VisitWellCandidate(
  AWellCandidate: TIDObject);
begin

end;

end.
