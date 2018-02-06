unit SDFacade;

interface

uses BaseFacades, Employee, BaseObjectType, Well, Structure, BaseObjects, Fluid, MeasureUnits,
     LicenseZone, Area, TypeWork, PetrolRegion, District, Straton, SlottingPoster, State,
     Topolist, TectonicStructure, FinanceSource, Version, Table, Organization, Altitude,
     Profile, ReasonChange, Material, GRRObligation, SeismWorkType;

type
  TSDFacade = class;
  TSDFacadeClass = class of TSDFacade;

  TSDFacade = class (TBaseFacade)
  private
    FRICCDicts: TRICCDicts;
    FAllEmployees: TEmployees;
    FAllEmployeeOuts: TEmployeeOutsides;
    FEmployees: TEmployees;
    FAllPosts: TPosts;
    FAllWells: TWells;
    FAllStructures: TStructures;
    FAllTectonicStructures: TTectonicStructures;
    FAllNewTectonicStructures: TNewTectonicStructures;
    FAllFields: TFields;
    FAllFluidTypes: TFluidTypes;
    FAllMeasureUnits: TMeasureUnits;
    FAllFluidTypeCharacteristics: TFluidCharacteristics;
    FAllLicenseZoneTypes: TLicenseZoneTypes;
    FAllAreas: TSimpleAreas;
    FAllStatesWells: TStates;
    FAllTypeWorks: TTypeWorks;
    FAllCategoriesWells: TWellCategories;
    FPetrolRegions: TPetrolRegions;
    FAllNewPetrolRegions: TNewPetrolRegions;
    FAllDistricts: TDistricts;
    FAllNGOs: TPetrolRegions;
    FAllNGPs: TPetrolRegions;
    FAllNGRs: TPetrolRegions;
    FAllNewNGOs: TNewPetrolRegions;
    FAllNewNGPs: TNewPetrolRegions;
    FAllNewNGRs: TNewPetrolRegions;
    FSimpleStratons: TSimpleStratons;
    FAllStratTaxonomies : TStratTaxonomies;
    FAllStratTaxonomyTypes: TTaxonomyTypes;
    FAllTopolists: TTopographicalLists;
    FAllFinanceSources: TFinanceSources;
    FAllOrgStatuses: TOrganizationStatuses;
    FAllAltitudeTypes: TAltitudeTypes;
    FAllMeasureSystemTypes: TMeasureSystemTypes;
    FAllProfiles: TProfiles;
    FOilFluidTypes: TFluidTypes;
    FStructureFundTypes: TStructureFundTypes;
    FDocumentTypes: TDocumentTypes;

    
    FFilter: string;
    FVersionFilter: string;
    FLicenseZoneFilter: string;

    function GetAllPosts: TPosts;
    function GetAllEmployees: TEmployees;
    function GetAllWells: TWells;
    function GetAllStructures: TStructures;
    function GetAllLicenseZoneTypes: TLicenseZoneTypes;
    function GetAllAreas: TSimpleAreas;
    function GetAllPetrolRegions: TPetrolRegions;
    function GetAllNGOs: TPetrolRegions;
    function GetAllNGPs: TPetrolRegions;
    function GetAllNGRs: TPetrolRegions;
    function GetAllTectonicStructures: TTectonicStructures;
    function GetAllFields: TFields;
    function GetSimpleStratons: TSimpleStratons;
    function GetAllEmployeeOuts: TEmployeeOutsides;
    function GetEmployees: TEmployees;
    function GetAllStratTaxonomies: TStratTaxonomies;
    function GetAllStratTaxonomyTypes: TTaxonomyTypes;
    function GetAllTopoLists: TTopographicalLists;
    function GetAllFinanceSources: TFinanceSources;
    function GetRICCDicts: TRiccDicts;
    function GetAllOrgStatuses: TOrganizationStatuses;
    function GetAllAltitudeTypes: TAltitudeTypes;
    function GetAllMeasureSystemTypes: TMeasureSystemTypes;
    function GetAllProfiles: TProfiles;
    function GetOilFluidTypes: TFluidTypes;
    function GetAllStructureFundTypes: TStructureFundTypes;
    function GetAllTypeWorks: TTypeWorks;
    function GetAllNewTectonicStructures: TNewTectonicStructures;
    function GetAllNewPetrolRegions: TNewPetrolRegions;
    function GetAllNewNGOs: TNewPetrolRegions;
    function GetAllNewNGPs: TNewPetrolRegions;
    function GetAllNewNGRs: TNewPetrolRegions;
  //  function GetAllSeismWorkTypes: TSeismWorkTypes;
  protected
    FAllLicenseZones: TLicenseZones;
    FAllRICCDicts: TRiccTables;
    FReasonChangesByWell: TReasonChanges;
    FAllVersions: TVersions;
    
    procedure DoVersionChanged(AOldVersion, ANewVersion: TVersion); override;
    procedure InitRiccDicts; virtual;
    function GetAllLicenseZones: TLicenseZones; virtual;
    function GetDataPosterByClassType(ADataPosterClass: TDataPosterClass): TDataPoster; override;
    function GetAllFuidTypes: TFluidTypes;
    function GetAllMeasureUnits: TMeasureUnits;
    function GetAllFluidTypeCharacteristics: TFluidCharacteristics;
    function GetAllStatesWells: TStates;
    function GetAllCategoriesWells: TWellCategories;
    function GetAllDistricts: TDistricts;
    function GetReasonChangeID: integer; virtual;
    function GetReasonChangesByWell: TReasonChanges;
    function GetAllVersions: TVersions; virtual;
    procedure ReloadWells; virtual;
    procedure RefreshDicts; virtual;
    function  GetDocumentTypes: TDocumentTypes;
  public
      // должности
    property AllPosts: TPosts read GetAllPosts;
      // список своих сотрудников сотрудников
    property AllEmployees: TEmployees read GetAllEmployees;
      // список внешних сотрудников
    property AllEmployeeOuts: TEmployeeOutsides read GetAllEmployeeOuts;
      // список всех сотрудников сотрудников
    property Employees: TEmployees read GetEmployees;
      // список скважин (UIN, номер, название)

    property AllWells: TWells read GetAllWells;
    procedure SkipWells;

      // список всех структур
    property AllStructures: TStructures read GetAllStructures;
      // список всех тектонических структур
    property AllTectonicStructures: TTectonicStructures read GetAllTectonicStructures;
      // список всех новых тектонических структур
    property AllNewTectonicStructures: TNewTectonicStructures read GetAllNewTectonicStructures;
      // список всех месторождений
    property AllFields: TFields read GetAllFields;
      // список всех площадей
    property AllAreas: TSimpleAreas read GetAllAreas;
      // типы флюидов
    property AllFluidTypes: TFluidTypes read GetAllFuidTypes;
      // нефтяных флюидов
    property OilFluidTypes: TFluidTypes read GetOilFluidTypes;

      // единицы измерения
    property AllMeasureUnits: TMeasureUnits read GetAllMeasureUnits;
      // характеристики типов флюидов
    property AllFluidTypeCharacteristics: TFluidCharacteristics read GetAllFluidTypeCharacteristics;
      // все типы лицензионных участков
    property AllLicenseZoneTypes: TLicenseZoneTypes read GetAllLicenseZoneTypes;
      // все состояния скважин
    property AllStatesWells: TStates read GetAllStatesWells;
      // все категории скважин
    property AllCategoriesWells: TWellCategories read GetAllCategoriesWells;
      // стратиграфические подразделения
    property AllSimpleStratons: TSimpleStratons read GetSimpleStratons;
      // таксономические единницы
    property AllStratTaxonomies: TStratTaxonomies read GetAllStratTaxonomies;
      // тип таксономической единницы
    property AllStratTaxonomyTypes: TTaxonomyTypes read GetAllStratTaxonomyTypes;
    // статус организации
    property AllOrgStatuses: TOrganizationStatuses read GetAllOrgStatuses;
    // все профили
    property AllProfiles: TProfiles read GetAllProfiles;

    // типы работ
    property AllTypeWorks: TTypeWorks read GetAllTypeWorks;


      // все нефтегазоносные регионы
    property AllPetrolRegions: TPetrolRegions read GetAllPetrolRegions;
      // все НГП
    property AllNGPs: TPetrolRegions read GetAllNGPs;
      // все НГО
    property AllNGOs: TPetrolRegions read GetAllNGOs;
      // все НГР
    property AllNGRs: TPetrolRegions read GetAllNGRs;

      // все новые нефтегазоносные регионы
    property AllNewPetrolRegions: TNewPetrolRegions read GetAllNewPetrolRegions;
      // все новые НГП
    property AllNewNGPs: TNewPetrolRegions read GetAllNewNGPs;
      // все новые НГО
    property AllNewNGOs: TNewPetrolRegions read GetAllNewNGOs;
      // все новые НГР
    property AllNewNGRs: TNewPetrolRegions read GetAllNewNGRs;

      // все лицензионные участки
    property AllLicenseZones: TLicenseZones read GetAllLicenseZones;
      // все административные районы
    property AllDistricts: TDistricts read GetAllDistricts;
      // все топографические листы
    property AllTopolists: TTopographicalLists read GetAllTopoLists;
      // источник финансирования
    property AllFinanceSources: TFinanceSources read GetAllFinanceSources;
      // версии
    property AllVersions: TVersions read GetAllVersions;
      // все справочники
    property RiccDicts: TRiccDicts read GetRICCDicts;
      // все типы альтитуд
    property AllAltitudeTypes: TAltitudeTypes read GetAllAltitudeTypes;
      // все системы альтитуд
    property AllMeasureSystemTypes: TMeasureSystemTypes read GetAllMeasureSystemTypes;
      // типы фонда структур
    property AllStructureFundTypes: TStructureFundTypes read GetAllStructureFundTypes;


    property ReasonChangeID: integer read GetReasonChangeID;
      // причины изменения для скважины
    property ReasonChangesByWell: TReasonChanges read GetReasonChangesByWell;

      // типы документов
    property DocumentTypes: TDocumentTypes read GetDocumentTypes;

    property Filter: string read FFilter write FFilter;
    property VersionFilter: string read FVersionFilter write FVersionFilter;
    property LicenseZoneFilter: string read FLicenseZoneFilter write FLicenseZoneFilter;
    

    class function GetInstance: TSDFacade;
    destructor Destroy; override;
  end;

implementation

uses StructurePoster, LicenseZonePoster, WellPoster, SysUtils, EmployeePoster,
     StratonPoster, Forms, AltitudePoster, GRRObligationPoster;

destructor TSDFacade.Destroy;
begin
  if Assigned(FSimpleStratons) then FSimpleStratons.Free;
  if Assigned(FAllVersions) then FAllVersions.Free;
  if Assigned(FAllOrgStatuses) then FAllOrgStatuses.Free;
  if Assigned(FAllProfiles) then FAllProfiles.Free;

  inherited;
end;

function TSDFacade.GetAllAltitudeTypes: TAltitudeTypes;
begin
  if not Assigned (FAllAltitudeTypes) then
  begin
    FAllAltitudeTypes := TAltitudeTypes.Create;
    FAllAltitudeTypes.Reload('', true);
  end;

  Result := FAllAltitudeTypes;
end;

function TSDFacade.GetAllAreas: TSimpleAreas;
begin
  if not Assigned (FAllAreas) then
  begin
    FAllAreas := TSimpleAreas.Create;
    FAllAreas.Reload('', true);
  end;

  Result := FAllAreas;
end;

function TSDFacade.GetAllCategoriesWells: TWellCategories;
begin
  if not Assigned (FAllCategoriesWells) then
  begin
    FAllCategoriesWells := TWellCategories.Create;
    FAllCategoriesWells.OwnsObjects := true;
    FAllCategoriesWells.Reload('', true);
  end;

  Result := FAllCategoriesWells;
end;

function TSDFacade.GetAllDistricts: TDistricts;
begin
  if not Assigned (FAllDistricts) then
  begin
    FAllDistricts := TDistricts.Create;
    FAllDistricts.Reload('', true);
  end;

  Result := FAllDistricts;
end;

function TSDFacade.GetAllEmployeeOuts: TEmployeeOutsides;
begin
  if not Assigned (FAllEmployeeOuts) then
  begin
    FAllEmployeeOuts := TEmployeeOutsides.Create;
    FAllEmployeeOuts.Reload('', true);
  end;

  Result := FAllEmployeeOuts;
end;

function TSDFacade.GetAllEmployees: TEmployees;
begin
  if not Assigned(FAllEmployees) then
  begin
    FAllEmployees := TEmployees.Create;
    FAllEmployees.Reload ('', true);
  end;

  Result := FAllEmployees;
end;

function TSDFacade.GetAllFields: TFields;
begin
  if not Assigned (FAllFields) then
  begin
    FAllFields := TFields.Create;
    FAllFields.Reload('Version_ID =  ' + IntToStr(ActiveVersion.ID) +  '  and Structure_fund_type_id = 4');
  end;

  Result := FAllFields;
end;

function TSDFacade.GetAllFinanceSources: TFinanceSources;
begin
  if not Assigned (FAllFinanceSources) then
  begin
    FAllFinanceSources := TFinanceSources.Create;
    FAllFinanceSources.Reload('', true);
  end;

  Result := FAllFinanceSources;
end;

function TSDFacade.GetAllFluidTypeCharacteristics: TFluidCharacteristics;
begin
  if not Assigned(FAllFluidTypeCharacteristics) then
  begin
    FAllFluidTypeCharacteristics := TFluidCharacteristics.Create;
    FAllFluidTypeCharacteristics.OwnsObjects := false;
    FAllFluidTypeCharacteristics.Reload('', true);
  end;

  Result := FAllFluidTypeCharacteristics;
end;

function TSDFacade.GetAllFuidTypes: TFluidTypes;
begin
  if not Assigned(FAllFluidTypes) then
  begin
    FAllFluidTypes := TFluidTypes.Create;
    FAllFluidTypes.OwnsObjects := true;
    FAllFluidTypes.Reload;
  end;

  Result := FAllFluidTypes;
end;

function TSDFacade.GetAllLicenseZones: TLicenseZones;
var sFilter: string;
begin
  if not Assigned(FAllLicenseZones) then
  begin
    FAllLicenseZones := TLicenseZones.Create;
    FAllLicenseZones.OwnsObjects := true;
    sFilter := Trim(LicenseZoneFilter);
    if sFilter <> '' then sFilter := sFilter + ' AND ' + 'Version_ID = %s AND LICENSE_ZONE_STATE_ID = 1' else sFilter := 'Version_ID = %s AND LICENSE_ZONE_STATE_ID = 1';
    FAllLicenseZones.Reload(Format(sFilter,[IntToStr(ActiveVersion.ID)]), true);
  end;

  Result := FAllLicenseZones;
end;

function TSDFacade.GetAllLicenseZoneTypes: TLicenseZoneTypes;
begin
  if not Assigned (FAllLicenseZoneTypes) then
  begin
    FAllLicenseZoneTypes := TLicenseZoneTypes.Create;
    FAllLicenseZoneTypes.Reload('', true);
  end;

  Result := FAllLicenseZoneTypes;
end;

function TSDFacade.GetAllMeasureSystemTypes: TMeasureSystemTypes;
begin
  if not Assigned (FAllMeasureSystemTypes) then
  begin
    FAllMeasureSystemTypes := TMeasureSystemTypes.Create;
    FAllMeasureSystemTypes.Reload('', true);
  end;

  Result := FAllMeasureSystemTypes;
end;

function TSDFacade.GetAllMeasureUnits: TMeasureUnits;
begin
  if not Assigned(FAllMeasureUnits) then
  begin
    FAllMeasureUnits := TMeasureUnits.Create;
    FAllMeasureUnits.OwnsObjects := true;
    FAllMeasureUnits.Reload('', true);
  end;

  Result := FAllMeasureUnits;
end;

function TSDFacade.GetAllNewNGOs: TNewPetrolRegions;
var i : integer;
    o : TNewPetrolRegion;
begin
  if not Assigned (FAllNewNGOs) then
  begin
    FAllNewNGOs := TNewPetrolRegions.Create;

    for i := 0 to AllNewPetrolRegions.Count - 1 do
    if AllNewPetrolRegions.Items[i].RegionType = prtNGO then
    begin
      o := AllNewPetrolRegions.Items[i];
      FAllNewNGOs.Add(o);
    end;
  end;

  Result := FAllNewNGOs;
end;

function TSDFacade.GetAllNewNGPs: TNewPetrolRegions;
var i : integer;
    o : TNewPetrolRegion;
begin
  if not Assigned (FAllNewNGPs) then
  begin
    FAllNewNGPs := TNewPetrolRegions.Create;

    for i := 0 to AllNewPetrolRegions.Count - 1 do
    if AllNewPetrolRegions.Items[i].RegionType = prtNGP then
    begin
      o := AllNewPetrolRegions.Items[i];
      FAllNewNGPs.Add(o);
    end;
  end;

  Result := FAllNewNGPs;
end;

function TSDFacade.GetAllNewNGRs: TNewPetrolRegions;
var i : integer;
    o : TNewPetrolRegion;
begin
  if not Assigned (FAllNewNGRs) then
  begin
    FAllNewNGRs := TNewPetrolRegions.Create;

    for i := 0 to AllNewPetrolRegions.Count - 1 do
    if AllNewPetrolRegions.Items[i].RegionType = prtNGR then
    begin
      o := AllNewPetrolRegions.Items[i];
      FAllNewNGRs.Add(o);
    end;
  end;

  Result := FAllNewNGRs;
end;

function TSDFacade.GetAllNewPetrolRegions: TNewPetrolRegions;
begin
  if not Assigned (FAllNewPetrolRegions) then
  begin
    FAllNewPetrolRegions := TNewPetrolRegions.Create;
    FAllNewPetrolRegions.Reload('', true);
  end;

  Result := FAllNewPetrolRegions;
end;

function TSDFacade.GetAllNewTectonicStructures: TNewTectonicStructures;
begin
  if not Assigned (FAllNewTectonicStructures) then
  begin
    FAllNewTectonicStructures := TNewTectonicStructures.Create;
    FAllNewTectonicStructures.Reload('', true);
  end;

  Result := FAllNewTectonicStructures
end;

function TSDFacade.GetAllNGOs: TPetrolRegions;
var i : integer;
    o : TPetrolRegion;
begin
  if not Assigned (FAllNGOs) then
  begin
    FAllNGOs := TPetrolRegions.Create;

    for i := 0 to AllPetrolRegions.Count - 1 do
    if AllPetrolRegions.Items[i].RegionType = prtNGO then
    begin
      o := AllPetrolRegions.Items[i];
      FAllNGOs.Add(o);
    end;
  end;

  Result := FAllNGOs;
end;

function TSDFacade.GetAllNGPs: TPetrolRegions;
var i : integer;
    o : TPetrolRegion;
begin
  if not Assigned (FAllNGPs) then
  begin
    FAllNGPs := TPetrolRegions.Create;

    for i := 0 to AllPetrolRegions.Count - 1 do
    if AllPetrolRegions.Items[i].RegionType = prtNGP then
    begin
      o := AllPetrolRegions.Items[i];
      FAllNGPs.Add(o);
    end;
  end;

  Result := FAllNGPs;
end;

function TSDFacade.GetAllNGRs: TPetrolRegions;
var i : integer;
    o : TPetrolRegion;
begin
  if not Assigned (FAllNGRs) then
  begin
    FAllNGRs := TPetrolRegions.Create;

    for i := 0 to AllPetrolRegions.Count - 1 do
    if AllPetrolRegions.Items[i].RegionType = prtNGR then
    begin
      o := AllPetrolRegions.Items[i];
      FAllNGRs.Add(o);
    end;
  end;

  Result := FAllNGRs;
end;

function TSDFacade.GetAllOrgStatuses: TOrganizationStatuses;
begin
  if not Assigned (FAllOrgStatuses) then
  begin
    FAllOrgStatuses := TOrganizationStatuses.Create;
    FAllOrgStatuses.Reload('', true);
  end;

  Result := FAllOrgStatuses;
end;

function TSDFacade.GetAllPetrolRegions: TPetrolRegions;
begin
  if not Assigned(FPetrolRegions) then
  begin
    FPetrolRegions := TPetrolRegions.Create;
    // только по ТПП
    FPetrolRegions.Reload('', true);
    FPetrolRegions.OwnsObjects := true;
  end;

  Result := FPetrolRegions;
end;

function TSDFacade.GetAllPosts: TPosts;
begin
  if not Assigned(FAllPosts) then
  begin
    FAllPosts := TPosts.Create;
    FAllPosts.Reload;
  end;

  Result := FAllPosts;
end;


function TSDFacade.GetAllProfiles: TProfiles;
begin
  if not Assigned (FAllProfiles) then
  begin
    FAllProfiles := TProfiles.Create;
    FAllProfiles.Reload('', true);
  end;

  Result := FAllProfiles;
end;

function TSDFacade.GetAllStatesWells: TStates;
begin
  if not Assigned (FAllStatesWells) then
  begin
    FAllStatesWells := TStates.Create;
    FAllStatesWells.OwnsObjects := true;
    FAllStatesWells.Reload('', true);
  end;

  Result := FAllStatesWells;
end;


function TSDFacade.GetAllStratTaxonomies: TStratTaxonomies;
begin
  if not Assigned (FAllStratTaxonomies) then
  begin
    FAllStratTaxonomies := TStratTaxonomies.Create;
    FAllStratTaxonomies.Reload('', true);
  end;

  Result := FAllStratTaxonomies;
end;

function TSDFacade.GetAllStratTaxonomyTypes: TTaxonomyTypes;
begin
  if not Assigned (FAllStratTaxonomyTypes) then
  begin
    FAllStratTaxonomyTypes := TTaxonomyTypes.Create;
    FAllStratTaxonomyTypes.Reload('', true);
  end;

  Result := FAllStratTaxonomyTypes;
end;

function TSDFacade.GetAllStructureFundTypes: TStructureFundTypes;
begin
  if not Assigned(FStructureFundTypes) then
  begin
    FStructureFundTypes := TStructureFundTypes.Create;
    FStructureFundTypes.Reload('', true);
  end;

  result := FStructureFundTypes;
end;

function TSDFacade.GetAllStructures: TStructures;
begin
  if not Assigned (FAllStructures) then
  begin
    FAllStructures := TStructures.Create;
    FAllStructures.Reload('VERSION_ID = ' + IntToStr(ActiveVersion.ID) +  ' and Structure_fund_type_id <> 4');
  end;

  Result := FAllStructures;
end;

function TSDFacade.GetAllTectonicStructures: TTectonicStructures;
begin
  if not Assigned (FAllTectonicStructures) then
  begin
    FAllTectonicStructures := TTectonicStructures.Create;
    FAllTectonicStructures.Reload('', true);
  end;

  Result := FAllTectonicStructures;
end;

function TSDFacade.GetAllTopoLists: TTopographicalLists;
begin
  if not Assigned (FAllTopolists) then
  begin
    FAllTopolists := TTopographicalLists.Create;
    FAllTopolists.Reload('', true);
  end;

  Result := FAllTopolists;
end;

function TSDFacade.GetAllTypeWorks: TTypeWorks;
begin
  if not Assigned (FAllTypeWorks) then
  begin
    FAllTypeWorks := TTypeWorks.Create;
    FAllTypeWorks.Reload('ID_PARENT_WORK_TYPE is null ');
  end;

  Result := FAllTypeWorks;
end;

function TSDFacade.GetAllVersions: TVersions;
begin
  if not Assigned(FAllVersions) then
  begin
    FAllVersions := TVersions.Create;
    FAllVersions.Reload(VersionFilter, True);
  end;
  Result := FAllVersions;
end;

function TSDFacade.GetAllWells: TWells;
begin
  if not Assigned (FAllWells) then
  begin
    FAllWells := TWells.Create;
    FAllWells.Reload(Filter, false);
  end;

  Result := FAllWells;
end;

function TSDFacade.GetDataPosterByClassType(
  ADataPosterClass: TDataPosterClass): TDataPoster;
begin
  Result := inherited GetDataPosterByClassType(ADataPosterClass);

  if Result is TStructureDataPoster then
    (Result as TStructureDataPoster).AllOrganizations := AllOrganizations
  else if Result is TWellDataPoster then
  begin
    (Result as TWellDataPoster).AllWellStates := AllStatesWells;
    (Result as TWellDataPoster).AllWellCategories := AllCategoriesWells;
    (Result as TWellDataPoster).AllAreas := AllAreas;
    (Result as TWellDataPoster).AllOrganizations := AllOrganizations;
    (Result as TWellDataPoster).AllSimpleStratons := AllSimpleStratons;
    (Result as TWellDataPoster).AllProfiles := AllProfiles;
    (Result as TWellDataPoster).AllEmployee := AllEmployees;
  end
  else if Result is TWellPositionDataPoster then
  begin
    (Result as TWellPositionDataPoster).AllPetrolRegions := AllPetrolRegions;
    (Result as TWellPositionDataPoster).AllDistricts := AllDistricts;
    (Result as TWellPositionDataPoster).AllTopolists := AllTopolists;
    (Result as TWellPositionDataPoster).AllTectonicStructures := AllTectonicStructures;
    (Result as TWellPositionDataPoster).AllNewTectonicStructures := AllNewTectonicStructures;
    (Result as TWellPositionDataPoster).AllNewPetrolRegions := AllNewPetrolRegions;
  end
  else if Result is TSlottingDataPoster then
    (Result as TSlottingDataPoster).AllStratons := AllSimpleStratons
  else if Result is TSimpleLicenseZonePoster then
  begin
    (Result as TSimpleLicenseZonePoster).AllOrganizations := AllOrganizations;
    (Result as TSimpleLicenseZonePoster).AllLicZoneTypes := AllLicenseZoneTypes;
  end
  else if Result is TEmployeeDataPoster then
    (Result as TEmployeeDataPoster).AllPosts := AllPosts
  else if Result is TSimpleStratonDataPoster then
    (Result as TSimpleStratonDataPoster).AllStratTaxonomies := AllStratTaxonomies
  else if Result is TWellOrganizationStatusDataPoster then
  begin
    (Result as TWellOrganizationStatusDataPoster).AllStatusOrganization := AllOrgStatuses;
    (Result as TWellOrganizationStatusDataPoster).AllOrganization := AllOrganizations;
  end
  else if Result is TAltitudeDataPoster then
  begin
    (Result as TAltitudeDataPoster).AllAltitudeTypes := AllAltitudeTypes;
    (Result as TAltitudeDataPoster).AllMeasureSystemTypes := AllMeasureSystemTypes;
  end
  else if Result is TStructureDataPoster then
  begin
    (Result as TStructureDataPoster).AllFundTypes := AllStructureFundTypes;
    (Result as TStructureDataPoster).AllOrganizations := AllOrganizations;
  end
  else if Result is TLicenseZonePoster then
  begin
    (Result as TLicenseZonePoster).AllOrganizations := AllOrganizations;
    (Result as TLicenseZonePoster).AllLicZoneTypes := AllLicenseZoneTypes;
  end



end;

function TSDFacade.GetEmployees: TEmployees;
begin
  if not Assigned (FEmployees) then
  begin
    FEmployees := TEmployees.Create;
    FEmployees.Assign(AllEmployees);
    FEmployees.Assign(AllEmployeeOuts, false);
  end;

  Result := FEmployees;
end;

class function TSDFacade.GetInstance: TSDFacade;
const FInstance: TSDFacade = nil;
begin
  if FInstance = nil then
  begin
    FInstance :=  Create(Application.MainForm);
    FInstance.ComponentIndex := 0;
  end;

  Result := FInstance;
end;

function TSDFacade.GetOilFluidTypes: TFluidTypes;
var i: integer;
begin
  if not Assigned(FOilFluidTypes) then
  begin
    FOilFluidTypes := TFluidTypes.Create;
    FOilFluidTypes.OwnsObjects := true;


    for i := 0 to AllFluidTypes.Count - 1 do
    if not (AllFluidTypes.Items[i].ID  in [29, 30, 31]) then // не бокситы не глина и не газовая шапка - убрать потом
      FOilFluidTypes.Add(AllFluidTypes.Items[i], True, false);
  end;
  Result := FOilFluidTypes;
end;

function TSDFacade.GetReasonChangeID: integer;
begin
  Result := 0;
end;

function TSDFacade.GetReasonChangesByWell: TReasonChanges;
begin
  if not Assigned (FReasonChangesByWell) then
  begin
    FReasonChangesByWell := TReasonChanges.Create;
    FReasonChangesByWell.Reload('REASON_CHANGE_ID in (1, 2, 3, 4, 5, 6, 8)');
  end;

  Result := FReasonChangesByWell;
end;

function TSDFacade.GetRICCDicts: TRiccDicts;
begin
  if not Assigned(FRICCDicts) then
  begin
    FRICCDicts := TRICCDicts.Create;
    FRICCDicts.Reload;
    InitRiccDicts; 
  end;

  Result := FRICCDicts;
end;

function TSDFacade.GetSimpleStratons: TSimpleStratons;
begin
  if not Assigned(FSimpleStratons) then
    FSimpleStratons := TSimpleStratons.Create;

  if FSimpleStratons.Count = 0 then
    FSimpleStratons.Reload;

  Result := FSimpleStratons;
end;

procedure TSDFacade.InitRiccDicts;
begin
  RiccDicts.BindToCollection('TBL_ORGANIZATION_DICT', AllOrganizations, nil);
  RiccDicts.BindToCollection('TBL_WELL_STATUS_DICT', AllStatesWells, nil);
  RiccDicts.BindToCollection('TBL_AREA_DICT', AllAreas, nil);
  RiccDicts.BindToCollection('TBL_WELL_CATEGORY_DICT', AllCategoriesWells, nil);
  RiccDicts.BindToCollection('VW_STRATIGRAPHY_DICT', AllSimpleStratons, nil);
  RiccDicts.BindToCollection('TBL_FLUID_TYPE_DICT', OilFluidTypes, nil);
end;

procedure TSDFacade.RefreshDicts;
begin

end;

procedure TSDFacade.ReloadWells;
begin

end;

procedure TSDFacade.SkipWells;
begin
  FreeAndNil(FAllWells);

end;


function TSDFacade.GetDocumentTypes: TDocumentTypes;
begin
  if not Assigned(FDocumentTypes) then
  begin
    FDocumentTypes := TDocumentTypes.Create;
    FDocumentTypes.Reload('', true);
  end;

  Result := FDocumentTypes;
end;

procedure TSDFacade.DoVersionChanged(AOldVersion, ANewVersion: TVersion);
begin
  FreeAndNil(FAllLicenseZones);
end;


{function TSDFacade.GetAllSeismWorkTypes: TSeismWorkTypes;
begin
 if not Assigned (FAllSeismWorkTypes) then
  begin
    FAllSeismWorkTypes := TSeismWorkTypes.Create;
    FAllSeismWorkTypes.Reload('', true);
  end;

  Result := FAllSeismWorkTypes;
end; }

end.
