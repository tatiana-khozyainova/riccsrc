unit Facade;

interface

uses BaseFacades, SDFacade, Registrator, Classes, DBGate, BaseObjects, Well,
     Organization, Profile, State, Fluid, Straton, Area, Parameter, Altitude,
     ReasonChange, Coord, LicenseZone, Version;

type
  TMainFacade = class (TSDFacade)
  private
    FFilter: string;
    FActiveWell: TWell;
    FActiveArea: TArea;

    FAllWells: TWells;
    FAllAbandonReasons: TAbandonReasons;
    FAllFluidTypesByBalance: TFluidTypes;
    FAllParametersGroups: TParametersGroupsByWell;
    FAllParameters: TParametersByWell;
    FAllSourcesCoord: TSourceCoords;
    FAllLicenseZones: TSimpleLicenseZones;
    FActiveWells, FEditingWells: TWells;
    FBedVersionObjectSets: TVersionObjectSets;
    FFieldVersionObjectSets: TVersionObjectSets;
    FLicenseZoneVersionObjectSets: TVersionObjectSets;
    FStructureVersionObjectSets: TVersionObjectSets;


    function GetAllWells: TWells;
    function GetAllAbandonReasons: TAbandonReasons;
    function GetAllFluidTypesByBalance: TFluidTypes;
    function GetAllParametersGroups: TParametersGroupsByWell;
    function GetAllParameters: TParametersByWell;
    function GetAllSourcesCoord: TSourceCoords;
    function GetAllSimpleLicenseZones: TSimpleLicenseZones;
    function GetBedVersionObjectSets: TVersionObjectSets;
    function GetFieldVersionObjectSets: TVersionObjectSets;
    function GetLicenseZoneVersionObjectSets: TVersionObjectSets;
    function GetStructureVersionObjectSets: TVersionObjectSets;
    function GetEditingWells: TWells;
  protected
    function GetRegistrator: TRegistrator; override;
    function GetDataPosterByClassType(ADataPosterClass: TDataPosterClass): TDataPoster; override;

  public
    // фильтр
    property Filter: string read FFilter write FFilter;
    // список скважин
    property AllWells: TWells read GetAllWells;
    // причины ликвидации
    property AllAbandonReasons: TAbandonReasons read GetAllAbandonReasons;
    // целевое назначение
    property AllFluidTypesByBalance: TFluidTypes read GetAllFluidTypesByBalance;
    // группы параметров
    property AllParametersGroups: TParametersGroupsByWell read GetAllParametersGroups;
    // параметрs
    property AllParameters: TParametersByWell read GetAllParameters;
    // все лицензионные участки (упрощенный вариант)
    property AllLicenseZones: TSimpleLicenseZones read GetAllSimpleLicenseZones;

    // версионные объекты
    property LicenseZoneVersionObjectSets: TVersionObjectSets read GetLicenseZoneVersionObjectSets;
    property StructureVersionObjectSets: TVersionObjectSets read GetStructureVersionObjectSets;
    property FieldVersionObjectSets: TVersionObjectSets read GetFieldVersionObjectSets;
    property BedVersionObjectSets: TVersionObjectSets read GetBedVersionObjectSets;
    // все источники координат
    property AllSourcesCoord: TSourceCoords read GetAllSourcesCoord;

    property ActiveWell: TWell read FActiveWell write FActiveWell;
    property ActiveWells: TWells read FActiveWells write FActiveWells;
    property ActiveArea: TArea read FActiveArea write FActiveArea;

    property EditingWells: TWells read GetEditingWells;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TConcreteRegistrator = class(TRegistrator)
  public
    constructor Create; override;
  end;

implementation

uses WellPoster, ParameterPoster, AltitudePoster, CoordPoster, FinanceSourcePoster,
     StatePoster, SysUtils, Bed, Structure, Field;

{ TMainFacade }

constructor TMainFacade.Create(AOwner: TComponent);
begin
  inherited;
  // настройка соединения с бд
  //DBGates.ServerClassString := 'RiccServerTest.CommonServerTest';
  //DBGates.ServerClassString := 'RiccServer.CommonServer';

  //DBGates.AutorizationMethod := amInitialize;
  DBGates.AutorizationMethod := amEnum;
  DBGates.NewAutorizationMode := false;

  //DBGates.ClientAppTypeID := 20;
  //DBGates.ClientName := 'Новый паспорт скважины';
end;

destructor TMainFacade.Destroy;
begin
  FreeAndNil(FBedVersionObjectSets);
  FreeAndNil(FFieldVersionObjectSets);
  FreeAndNil(FLicenseZoneVersionObjectSets);
  FreeAndNil(FStructureVersionObjectSets);

  FreeAndNil(FAllWells);
  FreeAndNil(FAllAbandonReasons);
  FreeAndNil(FAllFluidTypesByBalance);
  FreeAndNil(FAllParametersGroups);
  FreeAndNil(FAllParameters);
  FreeAndNil(FAllSourcesCoord);
  FreeAndNil(FAllLicenseZones);
  FreeAndNil(FEditingWells);
  inherited;
end;

function TMainFacade.GetAllAbandonReasons: TAbandonReasons;
begin
  if not Assigned (FAllAbandonReasons) then
  begin
    FAllAbandonReasons := TAbandonReasons.Create;
    FAllAbandonReasons.Reload('', True);
  end;

  Result := FAllAbandonReasons;
end;

function TMainFacade.GetAllFluidTypesByBalance: TFluidTypes;
var i: integer;
    o: TFluidType;
begin
  if not Assigned (FAllFluidTypesByBalance) then
  begin
    FAllFluidTypesByBalance := TFluidTypes.Create;
    
    for i := 0 to AllFluidTypes.Count - 1 do
    if AllFluidTypes.Items[i].BalanceFluid = 1 then
    begin
      o := AllFluidTypes.Items[i];
      FAllFluidTypesByBalance.Add(o);
    end;
  end;

  Result := FAllFluidTypesByBalance;
end;

function TMainFacade.GetAllSimpleLicenseZones: TSimpleLicenseZones;
begin
  Result := LicenseZoneVersionObjectSets.GetObjectSetByVersion(AllVersions.ItemsByID[0] as TVersion).Objects as TSimpleLicenseZones;
end;

function TMainFacade.GetAllParameters: TParametersByWell;
var i: integer;
begin
  if not Assigned (FAllParameters) then
  begin
    FAllParameters := TParametersByWell.Create;
    for i := 0 to FAllParametersGroups.Count - 1 do
      FAllParameters.Assign(FAllParametersGroups.Items[i].Parameters, false);
  end;

  Result := FAllParameters;
end;

function TMainFacade.GetAllParametersGroups: TParametersGroupsByWell;
begin
  if not Assigned (FAllParametersGroups) then
  begin
    FAllParametersGroups := TParametersGroupsByWell.Create;
    FAllParametersGroups.Reload('', true);
  end;

  Result := FAllParametersGroups;
end;


function TMainFacade.GetAllSourcesCoord: TSourceCoords;
begin
  if not Assigned (FAllSourcesCoord) then
  begin
    FAllSourcesCoord := TSourceCoords.Create;
    FAllSourcesCoord.Reload('', True);
  end;

  Result := FAllSourcesCoord;
end;

function TMainFacade.GetAllWells: TWells;
begin
  if not Assigned (FAllWells) then
  begin
    FAllWells := TWells.Create;
    FAllWells.OwnsObjects := true;
    FAllWells.Reload;
  end;

  Result := FAllWells;
end;

function TMainFacade.GetBedVersionObjectSets: TVersionObjectSets;
begin
  if not Assigned(FBedVersionObjectSets) then
    FBedVersionObjectSets := TVersionObjectSets.Create(TSimpleBeds);

  Result := FBedVersionObjectSets;
end;

function TMainFacade.GetDataPosterByClassType(
  ADataPosterClass: TDataPosterClass): TDataPoster;
begin
  Result := inherited GetDataPosterByClassType(ADataPosterClass);

  if Result is TWellDataPoster then
  begin
    (Result as TWellDataPoster).AllProfiles := AllProfiles;
    (Result as TWellDataPoster).AllFluidTypes := AllFluidTypes;
    (Result as TWellDataPoster).AllFluidTypesByBalance := AllFluidTypesByBalance;
    (Result as TWellDataPoster).AllEmployee := AllEmployees;
  end
  else if Result is TWellDynamicParametersDataPoster then
  begin
    (Result as TWellDynamicParametersDataPoster).AllCategories := AllCategoriesWells;
    (Result as TWellDynamicParametersDataPoster).AllStates := AllStatesWells;
    (Result as TWellDynamicParametersDataPoster).AllProfiles := AllProfiles;
    (Result as TWellDynamicParametersDataPoster).AllFluidTypes := AllFluidTypes;
    (Result as TWellDynamicParametersDataPoster).AllStratons := AllSimpleStratons;
    (Result as TWellDynamicParametersDataPoster).AllVersions := AllVersions;
  end
  else if Result is TWellLicenseZoneDataPoster then
  begin
    (result as TWellLicenseZoneDataPoster).AllVersions := AllVersions;
    (result as TWellLicenseZoneDataPoster).LicenseZoneVersionObjectSets := LicenseZoneVersionObjectSets;
  end
  else if Result is TWellFieldDataPoster then
  begin
    (result as TWellFieldDataPoster).AllVersions := AllVersions;
    (Result as TWellFieldDataPoster).FieldVersionObjectSets := FieldVersionObjectSets;
  end
  else if Result is TWellStructureDataPoster then
  begin
    (Result as TWellStructureDataPoster).AllVersions := AllVersions;
    (Result as TWellStructureDataPoster).StructureVersionObjectSets := StructureVersionObjectSets;
  end
  else if Result is TWellBedDataPoster then
  begin
    (Result as TWellBedDataPoster).AllVersions := AllVersions;
    (Result as TWellBedDataPoster).BedVersionObjectSets := BedVersionObjectSets;
  end
  else if Result is TParameterValueByWellDataPoster then
  begin
    (Result as TParameterValueByWellDataPoster).AllParameters := AllParameters;
  end
  else if Result is TParameterByWellDataPoster then
  begin
    (Result as TParameterByWellDataPoster).AllMeasureUnits := AllMeasureUnits;
  end
  else if Result is TAltitudeDataPoster then
  begin
    (Result as TAltitudeDataPoster).AllAltitudeTypes := AllAltitudeTypes;
    (Result as TAltitudeDataPoster).AllMeasureSystemTypes := AllMeasureSystemTypes;
  end
  else if Result is TWellCoordDataPoster then
  begin
    (Result as TWellCoordDataPoster).AllSourcesCoord := AllSourcesCoord;
  end
  else if Result is TFinanceSourceWellDataPoster then
  begin
    (Result as TFinanceSourceWellDataPoster).AllFinanceSources := AllFinanceSources;
  end
  else if Result is TAbandonReasonWellDataPoster then
  begin
    (Result as TAbandonReasonWellDataPoster).AllAbandonReasons := AllAbandonReasons;
  end;
end;

function TMainFacade.GetFieldVersionObjectSets: TVersionObjectSets;
begin
  if not Assigned(FFieldVersionObjectSets) then
    FFieldVersionObjectSets := TVersionObjectSets.Create(TSimpleFields);

  Result := FFieldVersionObjectSets;
end;

function TMainFacade.GetLicenseZoneVersionObjectSets: TVersionObjectSets;
begin
  if not Assigned(FLicenseZoneVersionObjectSets) then
    FLicenseZoneVersionObjectSets := TVersionObjectSets.Create(TSimpleLicenseZones);

  Result := FLicenseZoneVersionObjectSets;
end;

function TMainFacade.GetRegistrator: TRegistrator;
begin
  if not Assigned(FRegistrator) then
    FRegistrator := TConcreteRegistrator.Create;
  Result := FRegistrator;
end;

function TMainFacade.GetStructureVersionObjectSets: TVersionObjectSets;
begin
  if not Assigned(FStructureVersionObjectSets) then
    FStructureVersionObjectSets := TVersionObjectSets.Create(TSimpleStructures);

  Result := FStructureVersionObjectSets;
end;

function TMainFacade.GetEditingWells: TWells;
begin
  if not Assigned(FEditingWells) then
    FEditingWells := TWells.Create;
  Result := FEditingWells;
end;

{ TConcreteRegistrator }

constructor TConcreteRegistrator.Create;
begin
  inherited;
  AllowedControlClasses.Add(TStringsRegisteredObject);
  AllowedControlClasses.Add(TTreeViewRegisteredObject);
end;

end.
