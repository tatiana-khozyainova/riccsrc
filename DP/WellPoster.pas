unit WellPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, LicenseZone, Well, Area, PetrolRegion,
     Organization, District, Structure, State, Topolist, Profile, Fluid, ReasonChange, Employee,
     Straton, TectonicStructure, Version;

type
  TWellDynamicParametersDataPoster = class(TImplementedDataPoster)
  private
    FWellCategories: TWellCategories;
    FWellStates: TStates;
    FWellProfiles: TProfiles;
    FFluidTypes: TFluidTypes;
    FStratons: TSimpleStratons;
    FVersions: TVersions;
  public
    property AllCategories: TWellCategories read FWellCategories write FWellCategories;
    property AllStates: TStates read FWellStates write FWellStates;
    property AllProfiles: TProfiles read FWellProfiles write FWellProfiles;
    property AllFluidTypes: TFluidTypes read FFluidTypes write FFluidTypes;
    property AllStratons: TSimpleStratons read FStratons write FStratons;
    property AllVersions: TVersions read FVersions write FVersions;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  // для категорий скважин
  TWellCategoryDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  // для отношения организации к скважине
  TWellOrganizationStatusDataPoster = class(TImplementedDataPoster)
  private
    FAllStatusOrganization: TOrganizationStatuses;
    FAllOrganization: TOrganizations;
    procedure SetAllStatusOrganization(const Value: TOrganizationStatuses);
    procedure SetAllOrganization(const Value: TOrganizations);
  public
    property AllStatusOrganization: TOrganizationStatuses read FAllStatusOrganization write SetAllStatusOrganization;
    property AllOrganization: TOrganizations read FAllOrganization write SetAllOrganization;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  // для динамики отношения организации к скважине


  // для привязки скважин
  TWellBindingDataPoster = class(TImplementedDataPoster)
  private
    FAllWells: TWells;
    FAllAreas: TAreas;
    procedure SetAllWells(const Value: TWells);
    procedure SetAllAreas(const Value: TAreas);
  public
    property AllWells: TWells read FAllWells write SetAllWells;
    property AllAreas: TAreas read FAllAreas write SetAllAreas;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;

    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function PostToDB(ACollection: TIDObjects; AOwner: TIDObject): integer; overload; override;

    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  // для скважин (загружается только номер, площадь и категория)
  TSimpleWellDataPoster = class(TImplementedDataPoster)
  private
    FAllWellStates: TStates;
    FAllWellCategories: TWellCategories;
    FAllAreas: TSimpleAreas;

    procedure SetAllWellStates(const Value: TStates);
    procedure SetAllWellCategories(const Value: TWellCategories);
    procedure SetAllAreas(const Value: TSimpleAreas);
  public
    property AllWellStates: TStates read FAllWellStates write SetAllWellStates;
    property AllWellCategories: TWellCategories read FAllWellCategories write SetAllWellCategories;
    property AllAreas: TSimpleAreas read FAllAreas write SetAllAreas;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  // для скважин
  TWellDataPoster = class(TImplementedDataPoster)
  private
    FAllWellStates: TStates;
    FAllWellCategories: TWellCategories;
    FAllAreas: TSimpleAreas;
    FAllOrganizations: TOrganizations;
    FAllSimpleStratons: TSimpleStratons;
    FAllFluidTypesByBalance: TFluidTypes;
    FAllFluidTypes: TFluidTypes;
    FAllProfiles: TProfiles;
    FAllEmployee: TEmployees;

    procedure SetAllWellStates(const Value: TStates);
    procedure SetAllWellCategories(const Value: TWellCategories);
    procedure SetAllAreas(const Value: TSimpleAreas);
    procedure SetAllOrganizations(const Value: TOrganizations);
    procedure SetAllSimpleStratons(const Value: TSimpleStratons);
    procedure SetAllFluidTypes(const Value: TFluidTypes);
    procedure SetAllFluidTypesByBalance(const Value: TFluidTypes);
    procedure SetAllProfiles(const Value: TProfiles);
    procedure SetAllEmployee(const Value: TEmployees);
  protected
    procedure LocalSort(AObjects: TIDObjects); override;
    procedure InternalInitWell(AWell: TWell); virtual;

    procedure CommonInternalInitRow(AWell: TWell; ds: TDataSet); virtual;
  public
    property AllWellStates: TStates read FAllWellStates write SetAllWellStates;
    property AllWellCategories: TWellCategories read FAllWellCategories write SetAllWellCategories;
    property AllAreas: TSimpleAreas read FAllAreas write SetAllAreas;
    property AllOrganizations: TOrganizations read FAllOrganizations write SetAllOrganizations;
    property AllSimpleStratons: TSimpleStratons read FAllSimpleStratons write SetAllSimpleStratons;
    property AllProfiles: TProfiles read FAllProfiles write SetAllProfiles;
    property AllFluidTypes: TFluidTypes read FAllFluidTypes write SetAllFluidTypes;
    property AllFluidTypesByBalance: TFluidTypes read FAllFluidTypesByBalance write SetAllFluidTypesByBalance;
    property AllEmployee: TEmployees read FAllEmployee write SetAllEmployee;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;


  // для принадлежности скважин
  TWellPositionDataPoster = class(TImplementedDataPoster)
  private
    FAllPetrolRegions: TPetrolRegions;
    FAllDistricts: TDistricts;
    FAllTopolists: TTopographicalLists;
    FAllTectonicStructures: TTectonicStructures;
    FAllNewPetrolRegions: TNewPetrolRegions;
    FAllNewTectonicStructures: TNewTectonicStructures;
    procedure SetAllPetrolRegions(const Value: TPetrolRegions);
    procedure SetAllDistricts(const Value: TDistricts);
    procedure SetAllTopolists(const Value: TTopographicalLists);
    procedure SetAllTectonicStructures(const Value: TTectonicStructures);
    procedure SetNewAllPetrolRegions(const Value: TNewPetrolRegions);
    procedure SetNewAllTectonicStructures(
      const Value: TNewTectonicStructures);
  public
    property AllPetrolRegions: TPetrolRegions read FAllPetrolRegions write SetAllPetrolRegions;
    property AllDistricts: TDistricts read FAllDistricts write SetAllDistricts;
    property AllTopolists: TTopographicalLists read FAllTopolists write SetAllTopolists;
    property AllTectonicStructures: TTectonicStructures read FAllTectonicStructures write SetAllTectonicStructures;

    property AllNewTectonicStructures: TNewTectonicStructures read FAllNewTectonicStructures write SetNewAllTectonicStructures;
    property AllNewPetrolRegions: TNewPetrolRegions read FAllNewPetrolRegions write SetNewAllPetrolRegions;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TWellLicenseZoneDataPoster = class(TImplementedDataPoster)
  private
    FLicenseZoneVersionObjectSets: TVersionObjectSets;
    FAllVersions: TVersions;
  public
    property AllVersions: TVersions read FAllVersions write FAllVersions;
    property LicenseZoneVersionObjectSets: TVersionObjectSets read FLicenseZoneVersionObjectSets write FLicenseZoneVersionObjectSets;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;


  TWellStructureDataPoster = class(TImplementedDataPoster)
  private
    FStructureVersionObjectSets: TVersionObjectSets;
    FAllVersions: TVersions;
  public
    property AllVersions: TVersions read FAllVersions write FAllVersions;
    property StructureVersionObjectSets: TVersionObjectSets read FStructureVersionObjectSets write FStructureVersionObjectSets;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TWellFieldDataPoster  = class(TImplementedDataPoster)
  private
    FFieldVersionObjectSets: TVersionObjectSets;
    FAllVersions: TVersions;
  public
    property AllVersions: TVersions read FAllVersions write FAllVersions;
    property FieldVersionObjectSets: TVersionObjectSets read FFieldVersionObjectSets write FFieldVersionObjectSets;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;

  end;

  TWellBedDataPoster = class(TImplementedDataPoster)
  private
    FBedVersionObjectSets: TVersionObjectSets;
    FAllVersions: TVersions;
  public
    property AllVersions: TVersions read FAllVersions write FAllVersions;
    property BedVersionObjectSets: TVersionObjectSets read FBedVersionObjectSets write FBedVersionObjectSets;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;


implementation

uses Facade, SysUtils, ClientCommon, Variants, Math, DateUtils, Field, Bed;

function SortWells(Item1, Item2: Pointer): Integer;
var w1, w2: TSimpleWell;
    iNum1, iNum2: integer;
begin
  Result := 0;
  w1 := TSimpleWell(Item1);
  w2 := TSimpleWell(Item2);

  if w1.Name > w2.Name then Result := 1
  else if w1.Name < w2.Name then Result := -1
  else
  begin
    iNum1 := ExtractInt(w1.NumberWell);
    iNum2 := ExtractInt(w2.NumberWell);

    if iNum1 > iNum2 then Result := 1
    else if iNum1 < iNum2 then Result := -1
    else if iNum1 = iNum2 then
    begin
      if w1.NumberWell > w2.NumberWell then Result := 1
      else if w1.NumberWell < w2.NumberWell then Result := -1
      else Result := 0;
    end;
  end;
end;

{ TWelldDataPoster }

procedure TWellDataPoster.CommonInternalInitRow(AWell: TWell;
  ds: TDataSet);
begin
  ds.FieldByName('WELL_UIN').AsInteger := AWell.ID;
  ds.FieldByName('VCH_WELL_NUM').AsString := AWell.NumberWell;
  ds.FieldByName('AREA_ID').AsInteger := AWell.Area.ID;
  ds.FieldByName('VCH_WELL_NAME').AsString := AWell.Name;
  ds.FieldByName('VCH_PASSPORT_NUM').AsString := Trim(AWell.PassportNumberWell);



  if Assigned (AWell.Category) then ds.FieldByName('WELL_CATEGORY_ID').AsInteger := AWell.Category.ID;
  if Assigned (AWell.State) then ds.FieldByName('WELL_STATE_ID').AsInteger := AWell.State.ID;
  //if Assigned(AWell.Age) then ds.FieldByName('TRUE_AGE_ID').AsInteger := AWell.Age.ID;
end;

constructor TWellDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'VW_WELL_COORD';
  DataDeletionString := 'TBL_WELL';
  DataPostString := 'TBL_WELL';

  KeyFieldNames := 'WELL_UIN';


  FieldNames := 'WELL_UIN, VCH_WELL_NUM, VCH_PASSPORT_NUM, AREA_ID, WELL_CATEGORY_ID, WELL_STATE_ID, ' +
                'PROFILE_ID, TARGET_STRATON_ID, TRUE_STRATON_ID, NUM_TARGET_DEPTH, NUM_TRUE_DEPTH, ' +
                'NUM_GENERAL_ALTITUDE, NUM_TARGET_COST, NUM_TRUE_COST, DTM_CONSTRUCTION_STARTED, DTM_CONSTRUCTION_FINISHED, ' +
                'DTM_DRILLING_START, DTM_DRILLING_FINISH, DTM_ENTERING_DATE, TARGET_FLUID_TYPE_ID, ' +
                'TRUE_FLUID_TYPE_ID, VCH_WELL_NAME, DTM_LAST_MODIFY_DATE, NUM_IS_PROJECT, TARGET_CATEGORY_ID, EMPLOYEE_ID, MODIFIER_ID, NUM_IS_DYNAMICS_EDITED';


  AccessoryFieldNames := 'WELL_UIN, VCH_WELL_NUM, VCH_PASSPORT_NUM, AREA_ID, WELL_CATEGORY_ID, WELL_STATE_ID, ' +
                         'PROFILE_ID, TARGET_STRATON_ID, TRUE_STRATON_ID, NUM_TARGET_DEPTH, NUM_TRUE_DEPTH, ' +
                         'NUM_GENERAL_ALTITUDE, NUM_TARGET_COST, NUM_TRUE_COST, DTM_CONSTRUCTION_STARTED, DTM_CONSTRUCTION_FINISHED, ' +
                         'DTM_DRILLING_START, DTM_DRILLING_FINISH, DTM_ENTERING_DATE, TARGET_FLUID_TYPE_ID, ' +
                         'TRUE_FLUID_TYPE_ID, VCH_WELL_NAME, DTM_LAST_MODIFY_DATE, NUM_IS_PROJECT, TARGET_CATEGORY_ID, EMPLOYEE_ID, MODIFIER_ID, NUM_IS_DYNAMICS_EDITED';


  AutoFillDates := false;
  Sort := 'VCH_AREA_NAME, VCH_WELL_NUM';
end;

function TWellDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
var ds: TCommonServerDataSet;
begin
  Assert(DataDeletionString <> '', 'Не задан приемник данных ' + ClassName);
  Result := 0;
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  try
    // находим строку соответствующую ключу
    ds.First;
    if ds.Locate('WELL_UIN', AObject.ID, []) then
    begin
      ds.Delete;
    end
  except
    Result := -1;
  end;
end;

function TWellDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TWell;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;
    if Assigned(AObjects) then
    begin
      while not ds.Eof do
      begin
        o := AObjects.Add as TWell;
        InternalInitWell(o);
        ds.Next;
      end;

      LocalSort(AObjects);
    end;
    ds.First;
  end;
end;

procedure TWellDataPoster.InternalInitWell(AWell: TWell);
var ds: TDataSet;
begin
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  //WELL_UIN
  AWell.ID := ds.FieldByName('WELL_UIN').AsInteger;

  //VCH_WELL_NUM, VCH_PASSPORT_NUM, AREA_ID, VCH_WELL_NAME
  if Assigned(FAllAreas) then
    AWell.Area := FAllAreas.ItemsByID[ds.FieldByName('AREA_ID').AsInteger] as TSimpleArea;

  AWell.Name := trim(ds.FieldByName('VCH_WELL_NAME').AsString);
  AWell.PassportNumberWell := trim(ds.FieldByName('VCH_PASSPORT_NUM').AsString);
  AWell.NumberWell := trim(ds.FieldByName('VCH_WELL_NUM').AsString);


  //DTM_DRILLING_START, DTM_DRILLING_FINISH
  AWell.DtDrillingStart := ds.FieldByName('DTM_DRILLING_START').AsDateTime;
  AWell.DtDrillingFinish := ds.FieldByName('DTM_DRILLING_FINISH').AsDateTime;

  // NUM_TARGET_DEPTH, NUM_TRUE_DEPTH
  AWell.TrueDepth := ds.FieldByName('NUM_TRUE_DEPTH').AsFloat;
  AWell.TargetDepth := ds.FieldByName('NUM_TARGET_DEPTH').AsFloat;

  // NUM_TARGET_COST, NUM_TRUE_COST
  AWell.TargetCost := ds.FieldByName('NUM_TARGET_COST').AsFloat;
  AWell.TrueCost := ds.FieldByName('NUM_TRUE_COST').AsFloat;

  // DTM_LAST_MODIFY_DATE
  AWell.LastModifyDate := ds.FieldByName('DTM_LAST_MODIFY_DATE').AsDateTime;

   AWell.IsProject := ds.FieldByName('NUM_IS_PROJECT').AsInteger > 0;

  // WELL_CATEGORY_ID, WELL_STATE_ID
  if Assigned(FAllWellCategories) then
  begin
    AWell.Category := FAllWellCategories.ItemsByID[ds.FieldByName('WELL_CATEGORY_ID').AsInteger] as TWellCategory;
    AWell.TargetCategory := FAllWellCategories.ItemsByID[ds.FieldByName('TARGET_CATEGORY_ID').AsInteger] as TWellCategory;
  end;

  if Assigned(FAllWellStates) then
    AWell.State := FAllWellStates.ItemsByID[ds.FieldByName('WELL_STATE_ID').AsInteger] as TState;

  //TARGET_FLUID_TYPE_ID, TRUE_FLUID_TYPE_ID
  if Assigned (FAllFluidTypes) then
  begin
    AWell.FluidType := FAllFluidTypes.ItemsByID[ds.FieldByName('TRUE_FLUID_TYPE_ID').AsInteger] as TFluidType;
    AWell.FluidTypeByBalance := FAllFluidTypes.ItemsByID[ds.FieldByName('TARGET_FLUID_TYPE_ID').AsInteger] as TFluidType;
  end;

  //PROFILE_ID, TARGET_AGE_ID, TRUE_AGE_ID,
  if Assigned (FAllProfiles) then
    AWell.Profile := FAllProfiles.ItemsByID[ds.FieldByName('PROFILE_ID').AsInteger] as TProfile;

  if Assigned(FAllSimpleStratons) then
  begin
    AWell.TargetStraton := FAllSimpleStratons.ItemsByID[ds.FieldByName('TARGET_STRATON_ID').AsInteger] as TSimpleStraton;
    AWell.TrueStraton := FAllSimpleStratons.ItemsByID[ds.FieldByName('TRUE_STRATON_ID').AsInteger] as TSimpleStraton;
  end;

  // DTM_CONSTRUCTION_STARTED, DTM_CONSTRUCTION_FINISHED
  AWell.DtConstructionStart := ds.FieldByName('DTM_CONSTRUCTION_STARTED').AsDateTime;
  AWell.DtConstructionFinish := ds.FieldByName('DTM_CONSTRUCTION_FINISHED').AsDateTime;

  // EMPLOYEE_ID
  if Assigned(FAllEmployee) then
    AWell.Employee := FAllEmployee.ItemsByID[ds.FieldByName('EMPLOYEE_ID').AsInteger] as TEmployee;

  // AWell.Altitudes;
end;

procedure TWellDataPoster.LocalSort(AObjects: TIDObjects);
begin
  inherited;
  //AObjects.Sort(SortWells);
end;

function TWellDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var o: TWell;
    ds: TCommonServerDataSet;
    bEdit: boolean;
begin
  Assert(DataPostString <> '', 'Не задан приемник данных ' + ClassName);

  Result := 0;

  o := AObject as TWell;

  Assert(Assigned(o.Area), 'Не задана площадь');
  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);

    if not ds.Active then
      ds.Open;
    //ds.First;
    bEdit := false;
    if ds.Locate('WELL_UIN', AObject.ID, []) then
    begin
      ds.Edit;
      bEdit := true;
    end
    else ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;

  ds.FieldByName('WELL_UIN').Value := o.ID;
  ds.FieldByName('VCH_WELL_NUM').Value := trim(o.NumberWell);
  ds.FieldByName('AREA_ID').Value := o.Area.ID;
  ds.FieldByName('VCH_WELL_NAME').Value := Trim(o.Name);
  ds.FieldByName('VCH_PASSPORT_NUM').Value := trim(o.PassportNumberWell);
  ds.FieldByName('DTM_LAST_MODIFY_DATE').Value := DateOf(o.LastModifyDate);
  ds.FieldByName('NUM_IS_PROJECT').Value := ord(o.IsProject);


  if Assigned (o.Category) then
    ds.FieldByName('WELL_CATEGORY_ID').Value := o.Category.ID
  else
    ds.FieldByName('WELL_CATEGORY_ID').Value := null;


  if Assigned(o.TargetCategory) then
    ds.FieldByName('TARGET_CATEGORY_ID').Value := o.TargetCategory.ID
  else
    ds.FieldByName('TARGET_CATEGORY_ID').Value := null;

  if Assigned (o.State) then
    ds.FieldByName('WELL_STATE_ID').Value := o.State.ID
  else
    ds.FieldByName('WELL_STATE_ID').Value := null;


  if Assigned (o.Profile) then
    ds.FieldByName('PROFILE_ID').Value := o.Profile.ID
  else
    ds.FieldByName('PROFILE_ID').Value := null;

  if Assigned (o.FluidType) then
     ds.FieldByName('TRUE_FLUID_TYPE_ID').Value := o.FluidType.ID
  else
    ds.FieldByName('TRUE_FLUID_TYPE_ID').Value := null;

  if Assigned (o.FluidTypeByBalance) then
    ds.FieldByName('TARGET_FLUID_TYPE_ID').Value := o.FluidTypeByBalance.ID
  else
    ds.FieldByName('TARGET_FLUID_TYPE_ID').Value := null;

  ds.FieldByName('NUM_TARGET_COST').AsFloat := o.TargetCost;
  ds.FieldByName('NUM_TRUE_COST').AsFloat := o.TrueCost;

  ds.FieldByName('DTM_DRILLING_START').Value := DateToStr(o.DtDrillingStart);
  ds.FieldByName('DTM_DRILLING_FINISH').Value := DateToStr(o.DtDrillingFinish);

  ds.FieldByName('NUM_TRUE_DEPTH').AsFloat := o.TrueDepth;
  ds.FieldByName('NUM_TARGET_DEPTH').AsFloat := o.TargetDepth;

  if Assigned(o.TargetStraton) then
    ds.FieldByName('TARGET_STRATON_ID').Value := o.TargetStraton.ID
  else
    ds.FieldByName('TARGET_STRATON_ID').Value := null;

  if Assigned(o.TrueStraton) then
    ds.FieldByName('TRUE_STRATON_ID').Value := o.TrueStraton.ID
  else
    ds.FieldByName('TRUE_STRATON_ID').Value := null;

  ds.FieldByName('DTM_CONSTRUCTION_STARTED').Value := DateToStr(o.DtConstructionStart);
  ds.FieldByName('DTM_CONSTRUCTION_FINISHED').Value := DateToStr(o.DtConstructionFinish);

  ds.FieldByName('NUM_IS_PROJECT').AsInteger := ord(o.IsProject);

  if not bEdit then
    ds.FieldByName('EMPLOYEE_ID').AsInteger := TMainFacade.GetInstance.DBGates.EmployeeID;

  ds.FieldByName('MODIFIER_ID').AsInteger := TMainFacade.GetInstance.DBGates.EmployeeID;
  ds.FieldByName('num_Is_Dynamics_Edited').AsInteger := 0;
  ds.Post;

  if o.ID = 0 then
  begin
    o.ID := ds.FieldByName('WELL_UIN').Value;
    o.UpdateFilters;
  end;

  {
  Result := inherited PostToDB(AObject, ACollection);

  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TDinamicWell;

  ds.FieldByName('WELL_UIN').Value := o.ID;
  ds.FieldByName('VCH_WELL_NUM').Value := o.NumberWell;
  ds.FieldByName('AREA_ID').Value := o.Area.ID;
  ds.FieldByName('VCH_WELL_NAME').Value := o.Name;
  ds.FieldByName('VCH_PASSPORT_NUM').Value := o.PassportNumberWell;


  if Assigned (o.Category) then ds.FieldByName('WELL_CATEGORY_ID').Value := o.Category.ID;
  if Assigned (o.State) then ds.FieldByName('WELL_STATE_ID').Value := o.State.ID;


  if Assigned (o.Profile) then
    ds.FieldByName('PROFILE_ID').Value := o.Profile.ID;

  if Assigned (o.FluidType) then
    ds.FieldByName('TRUE_FLUID_TYPE_ID').Value := o.FluidType.ID;

  if Assigned (o.FluidTypeByBalance) then
    ds.FieldByName('TARGET_FLUID_TYPE_ID').Value := o.FluidTypeByBalance.ID;

//  if Assigned (o.AbandonReason) then
//    ds.FieldByName('ABANDON_REASON_ID').Value := o.AbandonReason.ID;

//  ds.FieldByName('DTM_ABANDON_DATE').Value := DateToStr(o.DtLiquidation);

  ds.FieldByName('NUM_TARGET_COST').Value := o.TargetCost;
  ds.FieldByName('NUM_TRUE_COST').Value := o.TrueCost;

  ds.FieldByName('DTM_ENTERING_DATE').Value := DateToStr(o.EnteringDate);
  ds.FieldByName('DTM_LAST_MODIFY_DATE').Value := null;//DateToStr(o.LastModifyDate);

  ds.FieldByName('DTM_DRILLING_START').Value := DateToStr(o.DtDrillingStart);
  ds.FieldByName('DTM_DRILLING_FINISH').Value := DateToStr(o.DtDrillingFinish);

  ds.FieldByName('NUM_TRUE_DEPTH').Value := o.TrueDepth;
  ds.FieldByName('NUM_TARGET_DEPTH').AsFloat := o.TargetDepth;

  ds.FieldByName('EMPLOYEE_ID').Value := TMainFacade.GetInstance.DBGates.EmployeeID;

  ds.Post;

  if o.ID = 0 then o.ID := ds.FieldByName('WELL_UIN').Value;


  {
  ds := fc.DBGates.Add(Self);

  o := AObject as TDinamicWell;

  ds.FieldByName('WELL_UIN').AsInteger := o.ID;
  ds.FieldByName('VCH_WELL_NUM').AsString := o.NumberWell;
  ds.FieldByName('VCH_PASSPORT_NUM').AsString := o.PassportNumberWell;
  ds.FieldByName('AREA_ID').AsInteger := o.Area.ID;

  if Assigned (o.Category) then
    ds.FieldByName('WELL_CATEGORY_ID').AsInteger := o.Category.ID;

  if Assigned (o.State) then
    ds.FieldByName('WELL_STATE_ID').AsInteger := o.State.ID;

  if Assigned (o.Profile) then
    ds.FieldByName('PROFILE_ID').AsInteger := o.Profile.ID;

  ds.FieldByName('VCH_WELL_NAME').AsString := o.Name;

  {
  NUM_ROTOR_ALTITUDE, ' +
  NUM_EARTH_ALTITUDE,
  NUM_FLOOR_ALTITUDE,
  DTM_CONSTRUCTION_STARTED,
  DTM_CONSTRUCTION_FINISHED, ' +
  NUM_TARGET_DEPTH,
  TARGET_FLUID_TYPE_ID,
  VCH_WELL_PRODUCTIVITY,
  MODIFIER_ID,
  MODIFIER_CLIENT_APP_TYPE_ID, ' +
  WELL_OWNER_ID,
  TARGET_STRATON_ID,
  TRUE_STRATON_ID

      // альтитуда
    property  Altitude: double read FAltitude write FAltitude;
      // возраст на забое
    property  Age: string read FAge write FAge;
      // принадлежность к организации по лиц. участку
    property  LicenseZone: TIDObject read FLicenseZone write SetLicenseZone;
      // организация
    property  OwnerOrganization: TOrganization read FOwnerOrganization write FOwnerOrganization;
      // организация - берется по лицензии если таковая есть, если нет по организации из базы данных
    property  RealOwner: TOrganization read GetRealOwner;
     // результат бурения
    property    FluidType: TFluidType read FFluidType write FFluidType;
     // целевое назначение
    property    FluidTypeByBalance: TFluidType read FFluidTypeByBalance write FFluidTypeByBalance;
     // источник
    property    IstFinance: TIDObject read GetIstFinance;
    property    IstFinances: TIDObjects read FIstFinances write FIstFinances;

  //ds.Post;

  //if o.ID = 0 then o.ID := ds.FieldByName('WELL_UIN').Value;
  }
end;

{ TWellPositionDataPoster }

constructor TWellPositionDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue, soSingleDataSource];
  DataSourceString := 'TBL_WELL_POSITION';

  KeyFieldNames := 'WELL_UIN';

  FieldNames := 'WELL_UIN, TOPOGRAPHICAL_LIST_ID, STRUCT_ID, DISTRICT_ID, PETROL_REGION_ID, NEW_PETROL_REGION_ID, NEW_TSTRUCT_ID';
  AccessoryFieldNames := 'WELL_UIN, TOPOGRAPHICAL_LIST_ID, STRUCT_ID, DISTRICT_ID, PETROL_REGION_ID, NEW_PETROL_REGION_ID, NEW_TSTRUCT_ID';

  AutoFillDates := false;

  Sort := 'WELL_UIN';
end;

function TWellPositionDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TWellPositionDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TWellPosition;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TWellPosition;

      o.ID := ds.FieldByName('WELL_UIN').AsInteger;

      if Assigned (AllTopolists) then
        o.Topolist := FAllTopolists.ItemsByID[ds.FieldByName('TOPOGRAPHICAL_LIST_ID').AsInteger] as TTopographicalList;
      if Assigned (AllDistricts) then
        o.District := FAllDistricts.ItemsByID[ds.FieldByName('DISTRICT_ID').AsInteger] as TDistrict;
      if Assigned (AllPetrolRegions) then
        o.NGR := FAllPetrolRegions.PlainList.ItemsByID[ds.FieldByName('PETROL_REGION_ID').AsInteger] as TPetrolRegion;
      
      if Assigned (AllNewPetrolRegions) then
        o.NewNGR := FAllNewPetrolRegions.PlainList.ItemsByID[ds.FieldByName('NEW_PETROL_REGION_ID').AsInteger] as TNewPetrolRegion;
      if Assigned (AllNewTectonicStructures) then
        o.NewTectonicStructure := FAllNewTectonicStructures.ItemsByID[ds.FieldByName('NEW_TSTRUCT_ID').AsInteger] as TNewTectonicStructure;

      if Assigned (AllTectonicStructures) then
        o.TectonicStructure := FAllTectonicStructures.ItemsByID[ds.FieldByName('STRUCT_ID').AsInteger] as TTectonicStructure;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TWellPositionDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TWellPosition;
begin
  Assert(DataPostString <> '', 'Не задан приемник данных ' + ClassName);
  Result := 0;
  o := AObject as TWellPosition;



  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);

    if not ds.Active then
      ds.Open;

    if ds.Locate('WELL_UIN', AObject.ID, []) then
      ds.Edit
    else ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;


  ds.FieldByName('WELL_UIN').AsInteger := o.Collection.Owner.ID;

  if Assigned(o.Topolist) then
    ds.FieldByName('TOPOGRAPHICAL_LIST_ID').AsInteger := o.Topolist.ID
  else
    ds.FieldByName('TOPOGRAPHICAL_LIST_ID').Value := null;

  

  

  if Assigned(o.District) then
    ds.FieldByName('DISTRICT_ID').AsInteger := o.District.ID
  else
    ds.FieldByName('DISTRICT_ID').Value := null;

  if Assigned(o.NGR) then
    ds.FieldByName('PETROL_REGION_ID').AsInteger := o.NGR.ID
  else
    ds.FieldByName('PETROL_REGION_ID').Value := null;


  if Assigned(o.TectonicStructure) then
    ds.FieldByName('STRUCT_ID').AsInteger := o.TectonicStructure.ID
  else
    ds.FieldByName('STRUCT_ID').Value := null;

  if Assigned(o.NewTectonicStructure) then
    ds.FieldByName('NEW_TSTRUCT_ID').AsInteger := o.NewTectonicStructure.ID
  else
    ds.FieldByName('NEW_TSTRUCT_ID').Value := null;

  if Assigned(o.NewNGR) then
    ds.FieldByName('NEW_PETROL_REGION_ID').AsInteger := o.NewNGR.ID
  else
    ds.FieldByName('NEW_PETROL_REGION_ID').Value := null;

  ds.Post;
end;

procedure TWellPositionDataPoster.SetAllDistricts(const Value: TDistricts);
begin
  if FAllDistricts <> Value then
    FAllDistricts := Value;
end;



procedure TWellPositionDataPoster.SetAllTopolists(
  const Value: TTopographicalLists);
begin
  if FAllTopolists <> Value then
    FAllTopolists := Value;
end;

procedure TWellPositionDataPoster.SetAllTectonicStructures(
  const Value: TTectonicStructures);
begin
  if FAllTectonicStructures <> Value then
    FAllTectonicStructures := Value;
end;

procedure TWellPositionDataPoster.SetNewAllPetrolRegions(
  const Value: TNewPetrolRegions);
begin
  if FAllNewPetrolRegions <> Value then
    FAllNewPetrolRegions := Value;
end;

procedure TWellPositionDataPoster.SetNewAllTectonicStructures(
  const Value: TNewTectonicStructures);
begin
  if FAllNewTectonicStructures <> Value then
    FAllNewTectonicStructures := Value;
end;

{ TWellCategoryDataPoster }

constructor TWellCategoryDataPoster.Create;
begin
  inherited;
  Options := [];
  DataSourceString := 'TBL_WELL_CATEGORY_DICT';
  DataDeletionString := '';
  DataPostString := '';

  KeyFieldNames := 'WELL_CATEGORY_ID';
  FieldNames := 'WELL_CATEGORY_ID, VCH_CATEGORY_NAME';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_CATEGORY_NAME';
end;

function TWellCategoryDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TWellCategoryDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TWellCategory;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TWellCategory;

      o.ID := ds.FieldByName('WELL_CATEGORY_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_CATEGORY_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TWellCategoryDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

procedure TWellDataPoster.SetAllAreas(const Value: TSimpleAreas);
begin
  if FAllAreas <> Value then
    FAllAreas := Value;
end;

procedure TWellDataPoster.SetAllEmployee(const Value: TEmployees);
begin
  if FAllEmployee <> Value then 
    FAllEmployee := Value;
end;

procedure TWellDataPoster.SetAllFluidTypes(const Value: TFluidTypes);
begin
  if FAllFluidTypes <> Value then
    FAllFluidTypes := Value;
end;

procedure TWellDataPoster.SetAllFluidTypesByBalance(
  const Value: TFluidTypes);
begin
  if FAllFluidTypesByBalance <> Value then
    FAllFluidTypesByBalance := Value;
end;

procedure TWellDataPoster.SetAllOrganizations(const Value: TOrganizations);
begin
  if FAllOrganizations <> Value then
    FAllOrganizations := Value;
end;

procedure TWellDataPoster.SetAllProfiles(const Value: TProfiles);
begin
  if FAllProfiles <> Value then
    FAllProfiles := Value;
end;

procedure TWellDataPoster.SetAllSimpleStratons(
  const Value: TSimpleStratons);
begin
  if FAllSimpleStratons <> Value then
    FAllSimpleStratons := Value;
end;

procedure TWellDataPoster.SetAllWellCategories(
  const Value: TWellCategories);
begin
  if FAllWellCategories <> Value then
    FAllWellCategories := Value;
end;

procedure TWellDataPoster.SetAllWellStates(const Value: TStates);
begin
  if FAllWellStates <> Value then
    FAllWellStates := Value;
end;

procedure TWellPositionDataPoster.SetAllPetrolRegions(
  const Value: TPetrolRegions);
begin
  if FAllPetrolRegions <> Value then
    FAllPetrolRegions := Value;
end;


{ TWellBindingDataPoster }

constructor TWellBindingDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_WELL_BINDING';

  KeyFieldNames := 'WELL_UIN; AREA_ID; VCH_WELL_NUM';
  FieldNames := 'WELL_UIN, AREA_ID, VCH_WELL_NUM';

  AccessoryFieldNames := 'WELL_UIN, AREA_ID, VCH_WELL_NUM';
  AutoFillDates := false;

  Sort := 'WELL_UIN';
end;

function TWellBindingDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TWellBindingDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o:  TWellBinding;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TWellBinding;

      o.Area := AllAreas.ItemsByID[ds.FieldByName('AREA_ID').AsInteger] as TArea;
      o.NumberWell := ds.FieldByName('VCH_WELL_NUM').AsString;

      AObjects.Add(o, false, false);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TWellBindingDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TWellBindingDataPoster.PostToDB(ACollection: TIDObjects;
  AOwner: TIDObject): integer;
var ds: TDataSet;
    o: TWell;
    os: TWellBindings;
    i: integer;
begin
  Result := 0;

  ds := TMainFacade.GetInstance.DBGates.Add(Self);
  if not ds.Active then ds.Open;

  o := AOwner as TWell;
  os := ACollection as TWellBindings;

  try
    while ds.Locate('WELL_UIN', o.ID, []) do
    begin
      ds.Delete;
      ds.First;
    end;
  except
    on E: Exception do
    begin
      //
    end;
  end;

  for i := 0 to os.Count - 1 do
  begin
    ds.Append;

    while not varIsNull(ds.FieldByName('WELL_UIN').Value) do
      ds.Append;

    ds.FieldByName('WELL_UIN').Value := o.ID;
    ds.FieldByName('AREA_ID').Value := os.Items[i].Area.ID;
    ds.FieldByName('VCH_WELL_NUM').Value := os.Items[i].NumberWell;

    ds.Post;
  end;
end;

procedure TWellBindingDataPoster.SetAllAreas(const Value: TAreas);
begin
  if FAllAreas <> Value then
    FAllAreas := Value;
end;

procedure TWellBindingDataPoster.SetAllWells(const Value: TWells);
begin
  if FAllWells <> Value then
    FAllWells := Value;
end;









{ TOrganizationStatusDataPoster }

constructor TWellOrganizationStatusDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_ORG_STATUS';

  KeyFieldNames := 'ORG_STATUS_ID; WELL_UIN';
  FieldNames := 'ORG_STATUS_ID, WELL_UIN, ORGANIZATION_ID';

  AccessoryFieldNames := 'ORG_STATUS_ID, WELL_UIN, ORGANIZATION_ID';
  
  AutoFillDates := false;
end;

function TWellOrganizationStatusDataPoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TWellOrganizationStatusDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TWellOrganizationStatus;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TWellOrganizationStatus;

      o.StatusOrganization := AllStatusOrganization.ItemsByID[ds.FieldByName('ORG_STATUS_ID').AsInteger] as TOrganizationStatus;
      o.Organization := AllOrganization.ItemsByID[ds.FieldByName('ORGANIZATION_ID').AsInteger] as TOrganization;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TWellOrganizationStatusDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TWellOrganizationStatus;
begin
  Assert(DataPostString <> '', 'Не задан приемник данных ' + ClassName);
  Result := 0;

  o := AObject as TWellOrganizationStatus;

  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);

    if not ds.Active then
      ds.Open;

    if ds.Locate('ORG_STATUS_ID; WELL_UIN', varArrayOf([o.StatusOrganization.ID, (o.Collection.Owner as TWell).ID]), []) then
      ds.Edit
    else ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;

  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  ds.FieldByName('WELL_UIN').AsInteger := (o.Collection.Owner as TWell).ID;

  if Assigned (o.StatusOrganization) then
    ds.FieldByName('ORG_STATUS_ID').AsInteger := o.StatusOrganization.ID;

  if Assigned (o.Organization) then
    ds.FieldByName('ORGANIZATION_ID').AsInteger := o.Organization.ID;

  ds.Post;
end;

procedure TWellOrganizationStatusDataPoster.SetAllOrganization(
  const Value: TOrganizations);
begin
  if FAllOrganization <> Value then
    FAllOrganization := Value;
end;

procedure TWellOrganizationStatusDataPoster.SetAllStatusOrganization(
  const Value: TOrganizationStatuses);
begin
  if FAllStatusOrganization <> Value then
    FAllStatusOrganization := Value;
end;


{ TSimpleWellDataPoster }

constructor TSimpleWellDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'VW_WELL_COORD';

  KeyFieldNames := 'WELL_UIN';
  AccessoryFieldNames := 'WELL_UIN, VCH_WELL_NUM, VCH_PASSPORT_NUM, AREA_ID, VCH_WELL_NAME, DTM_LAST_MODIFY_DATE, WELL_CATEGORY_ID, WELL_STATE_ID, NUM_IS_PROJECT, TARGET_CATEGORY_ID, NUM_TARGET_DEPTH, NUM_TRUE_DEPTH, DTM_DRILLING_START, DTM_DRILLING_FINISH';

  FieldNames := 'WELL_UIN, VCH_WELL_NUM, VCH_PASSPORT_NUM, AREA_ID, VCH_WELL_NAME, DTM_LAST_MODIFY_DATE, WELL_CATEGORY_ID, WELL_STATE_ID, NUM_IS_PROJECT, TARGET_CATEGORY_ID, NUM_TARGET_DEPTH, NUM_TRUE_DEPTH, DTM_DRILLING_START, DTM_DRILLING_FINISH';

  AutoFillDates := false;
  Sort := 'VCH_AREA_NAME, VCH_WELL_NUM';
end;

function TSimpleWellDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TSimpleWellDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TSimpleWell;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      if AObjects.ObjectClass = TSimpleWell then
        o := AObjects.Add as TSimpleWell
      else o := AObjects.Add as TWell;

      //WELL_UIN
      o.ID := ds.FieldByName('WELL_UIN').AsInteger;

      //VCH_WELL_NUM, VCH_PASSPORT_NUM, AREA_ID, VCH_WELL_NAME
      if Assigned(FAllAreas) then
        o.Area := FAllAreas.ItemsByID[ds.FieldByName('AREA_ID').AsInteger] as TSimpleArea;

      o.Name := trim(ds.FieldByName('VCH_WELL_NAME').AsString);
      o.PassportNumberWell := ds.FieldByName('VCH_PASSPORT_NUM').AsString;
      o.NumberWell := trim(ds.FieldByName('VCH_WELL_NUM').AsString);

      // DTM_LAST_MODIFY_DATE
      o.LastModifyDate := ds.FieldByName('DTM_LAST_MODIFY_DATE').AsDateTime;


      O.IsProject := ds.FieldByName('NUM_IS_PROJECT').AsInteger > 0;

      // WELL_CATEGORY_ID, WELL_STATE_ID
      if Assigned(FAllWellCategories) then
      begin
        o.Category := FAllWellCategories.ItemsByID[ds.FieldByName('WELL_CATEGORY_ID').AsInteger] as TWellCategory;
        o.TargetCategory := FAllWellCategories.ItemsByID[ds.FieldByName('TARGET_CATEGORY_ID').AsInteger] as TWellCategory;
      end;
      if Assigned(FAllWellStates) then
        o.State := FAllWellStates.ItemsByID[ds.FieldByName('WELL_STATE_ID').AsInteger] as TState;

      o.TrueDepth := ds.FieldByName('NUM_TRUE_DEPTH').AsFloat;
      o.TargetDepth := ds.FieldByName('NUM_TARGET_DEPTH').AsFloat;
      o.DtDrillingStart := ds.FieldByName('DTM_DRILLING_START').AsDateTime;
      o.DtDrillingFinish := ds.FieldByName('DTM_DRILLING_FINISH').AsDateTime;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TSimpleWellDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

procedure TSimpleWellDataPoster.SetAllAreas(const Value: TSimpleAreas);
begin
  if FAllAreas <> Value then
    FAllAreas := Value;
end;

procedure TSimpleWellDataPoster.SetAllWellCategories(
  const Value: TWellCategories);
begin
  if FAllWellCategories <> Value then
    FAllWellCategories := Value;
end;

procedure TSimpleWellDataPoster.SetAllWellStates(const Value: TStates);
begin
  if FAllWellStates <> Value then
    FAllWellStates := Value;
end;

{ TWellDynamicParametersDataPoster }

constructor TWellDynamicParametersDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_WELL_DINAMICS';

  KeyFieldNames := 'WELL_UIN; VERSION_ID';

  FieldNames := 'WELL_UIN, WELL_CATEGORY_ID, WELL_STATE_ID, ' +
                'PROFILE_ID, TRUE_STRATON_ID, NUM_TRUE_DEPTH, NUM_TRUE_COST, ' +
                'TRUE_FLUID_TYPE_ID, VERSION_ID, EMPLOYEE_ID, DTM_LAST_MODIFY_DATE, NUM_IS_PROJECT, MODIFIER_ID, DTM_ENTERING_DATE, NUM_IS_WELL_EDITED';


  AccessoryFieldNames := FieldNames;
  AutoFillDates := false;
  Sort := 'WELL_UIN, VERSION_ID';
end;

function TWellDynamicParametersDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var o: TWellDynamicParameters;
    ds: TCommonServerDataSet;
begin
  o := AObject as TWellDynamicParameters;

  Assert(DataDeletionString <> '', 'Не задан приемник данных ' + ClassName);
  Assert(Assigned(o), 'Не задан сохраняемый объект');
  Assert(Assigned(o.Version), 'Не задана версия сохраняемого объекта');
  Result := 0;



  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);

    if not ds.Active then
      ds.Open;
    ds.First;

    if ds.Locate('WELL_UIN; VERSION_ID', varArrayOf([AObject.ID, o.Version.ID]), []) then
      ds.Delete;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;
end;

function TWellDynamicParametersDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TWellDynamicParameters;
begin
  Assert(Assigned(AllCategories));
  Assert(Assigned(AllProfiles));
  Assert(Assigned(AllStates));
  Assert(Assigned(AllFluidTypes));
  Assert(Assigned(AllStratons));
  Assert(Assigned(AllVersions));

  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TWellDynamicParameters;



      o.WellCategory := AllCategories.ItemsByID[ds.FieldByName('WELL_CATEGORY_ID').AsInteger] as TWellCategory;
      o.WellState := AllStates.ItemsById[ds.FieldByName('WELL_STATE_ID').AsInteger] as TState;
      o.WellProfile := AllProfiles.ItemsById[ds.FieldByName('PROFILE_ID').AsInteger] as TProfile;
      o.TrueDepth := ds.FieldByName('NUM_TRUE_DEPTH').AsFloat;
      o.TrueFluidType := AllFluidTypes.ItemsById[ds.FieldByName('TRUE_FLUID_TYPE_ID').AsInteger] as TFluidType;
      o.TrueCost := ds.FieldByName('NUM_TRUE_COST').AsFloat;
      o.TrueStraton := AllStratons.ItemsById[ds.FieldByName('TRUE_STRATON_ID').AsInteger] as TSimpleStraton;
      o.Version := AllVersions.ItemsByID[ds.FieldByName('VERSION_ID').AsInteger] as TVersion;



      ds.Next;
    end;

    ds.First;
  end;
end;

function TWellDynamicParametersDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var o: TWellDynamicParameters;
    ds: TCommonServerDataSet;
begin
  o := AObject as TWellDynamicParameters;

  Assert(DataPostString <> '', 'Не задан приемник данных ' + ClassName);
  Assert(Assigned(o), 'Не задан сохраняемый объект');
  Assert(Assigned(o.Version), 'Не задана версия сохраняемого объекта');
  Result := 0;



  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    ds.Close;
    ds.Open;

    if ds.Locate('WELL_UIN; VERSION_ID', varArrayOf([AObject.Owner.ID, o.Version.ID]), []) then
      ds.Edit
    else
    begin
      ds.Append;
      ds.FieldByName('EMPLOYEE_ID').Value := TMainFacade.GetInstance.DBGates.EmployeeID;
      ds.FieldByName('DTM_ENTERING_DATE').Value := Date;
    end;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;

  ds.FieldByName('WELL_UIN').Value := o.Owner.ID;
  ds.FieldByName('VERSION_ID').Value := o.Version.ID;

  if Assigned(o.WellCategory) then
    ds.FieldByName('WELL_CATEGORY_ID').Value := o.WellCategory.ID
  else
    ds.FieldByName('WELL_CATEGORY_ID').Value := null;

  if Assigned(o.WellState) then
    ds.FieldByName('WELL_STATE_ID').Value := o.WellState.ID
  else
    ds.FieldByName('WELL_STATE_ID').Value := null;

  if Assigned(o.WellProfile) then
    ds.FieldByName('PROFILE_ID').Value := o.WellProfile.ID
  else
    ds.FieldByName('PROFILE_ID').Value := null;

  if Assigned(o.TrueStraton) then
    ds.FieldByName('TRUE_STRATON_ID').Value := o.TrueStraton.ID
  else
    ds.FieldByName('TRUE_STRATON_ID').Value := null;

  if Assigned(o.TrueFluidType) then
    ds.FieldByName('TRUE_FLUID_TYPE_ID').Value := o.TrueFluidType.ID
  else
    ds.FieldByName('TRUE_FLUID_TYPE_ID').Value := null;

  ds.FieldByName('NUM_TRUE_DEPTH').Value := o.TrueDepth;
  ds.FieldByName('NUM_TRUE_COST').Value := o.TrueCost;
  ds.FieldByName('MODIFIER_ID').Value := TMainFacade.GetInstance.DBGates.EmployeeID;
  ds.FieldByName('DTM_LAST_MODIFY_DATE').Value := Date;

  ds.FieldByName('NUM_IS_PROJECT').Value := ord(o.IsProject);
  ds.FieldByName('NUM_IS_WELL_EDITED').Value := 0;

  ds.Post;
end;

{ TWellLicenseZoneDataPoster }

constructor TWellLicenseZoneDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_WELL_LICENSE_ZONE';

  KeyFieldNames := 'WELL_UIN; VERSION_ID; LICENSE_ZONE_ID';

  FieldNames := 'WELL_UIN, VERSION_ID, LICENSE_ZONE_ID';
  AccessoryFieldNames := 'WELL_UIN, VERSION_ID, LICENSE_ZONE_ID';

  AutoFillDates := false;

  Sort := 'WELL_UIN, VERSION_ID, LICENSE_ZONE_ID';
end;

function TWellLicenseZoneDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TCommonServerDataSet;
    o: TWellLicenseZone;
begin
  Assert(DataDeletionString <> '', 'Не задан приемник данных ' + ClassName);

  Result := 0;

  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TWellLicenseZone;
  Assert(Assigned(o.Version), 'Не задана версия объекта');
  Assert(Assigned(o.LicenseZone), 'На задан лицензионный участок');

  try
    // находим строку соответствующую ключу
    ds.First;
    if ds.Locate(KeyFieldNames, varArrayOf([AObject.ID, o.Version.ID, o.LicenseZone.ID]), []) then
      ds.Delete;
  except
    Result := -1;
  end;
end;

function TWellLicenseZoneDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TWellLicenseZone;
begin
  Assert(Assigned(AllVersions), 'Не заданы версии объектов');
  Assert(Assigned(LicenseZoneVersionObjectSets), 'Не задан источник лицензионных участков');

  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TWellLicenseZone;

      o.ID := ds.FieldByName('WELL_UIN').AsInteger;

      o.Version := AllVersions.ItemsByID[ds.FieldByName('VERSION_ID').AsInteger] as TVersion;
      o.LicenseZone := LicenseZoneVersionObjectSets.GetObjectSetByVersion(o.Version).Objects.ItemsByID[ds.FieldByName('LICENSE_ZONE_ID').AsInteger] as TSimpleLicenseZone;

      ds.Next;
    end;

    ds.First;
  end;

end;

function TWellLicenseZoneDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TWellLicenseZone;
begin
  Assert(DataPostString <> '', 'Не задан приемник данных ' + ClassName);
  Assert(Assigned(AllVersions), 'Не заданы версии объектов');
  Assert(Assigned(LicenseZoneVersionObjectSets), 'Не задан источник лицензионных участков');

  Result := 0;
  o := AObject as TWellLicenseZone;
  Assert(Assigned(o.Version), 'Не задана версия объекта');
  Assert(Assigned(o.LicenseZone), 'На задан лицензионный участок');


  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);

    if not ds.Active then
      ds.Open;

    if ds.Locate(KeyFieldNames, varArrayOf([AObject.ID, o.Version.ID, o.LicenseZone.ID]), []) then
      ds.Edit
    else ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;


  ds.FieldByName('VERSION_ID').AsInteger := o.Version.ID;
  ds.FieldByName('LICENSE_ZONE_ID').AsInteger := o.LicenseZone.ID;
  ds.Post;
end;

{ TWellStructureDataPoster }

constructor TWellStructureDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_WELL_STRUCTURE';

  KeyFieldNames := 'WELL_UIN; VERSION_ID; STRUCTURE_ID';

  FieldNames := 'WELL_UIN, VERSION_ID, STRUCTURE_ID';
  AccessoryFieldNames := 'WELL_UIN, VERSION_ID, STRUCTURE_ID';

  AutoFillDates := false;

  Sort := 'WELL_UIN, VERSION_ID, STRUCTURE_ID';

end;

function TWellStructureDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TCommonServerDataSet;
    o: TWellStructure;
begin
  Assert(DataDeletionString <> '', 'Не задан приемник данных ' + ClassName);

  Result := 0;

  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TWellStructure;
  Assert(Assigned(o.Version), 'Не задана версия объекта');
  Assert(Assigned(o.Structure), 'На задана структура');

  try
    // находим строку соответствующую ключу
    ds.First;
    if ds.Locate(KeyFieldNames, varArrayOf([AObject.ID, o.Version.ID, o.Structure.ID]), []) then
      ds.Delete;
  except
    Result := -1;
  end;
end;

function TWellStructureDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TWellStructure;
begin
  Assert(Assigned(AllVersions), 'Не заданы версии объектов');
  Assert(Assigned(StructureVersionObjectSets), 'Не задан источник структур');

  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TWellStructure;

      o.ID := ds.FieldByName('WELL_UIN').AsInteger;

      o.Version := AllVersions.ItemsByID[ds.FieldByName('VERSION_ID').AsInteger] as TVersion;
      o.Structure := StructureVersionObjectSets.GetObjectSetByVersion(o.Version).Objects.ItemsByID[ds.FieldByName('STRUCTURE_ID').AsInteger] as TSimpleStructure;

      ds.Next;
    end;

    ds.First;
  end;

end;

function TWellStructureDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TWellStructure;
begin
  Assert(DataPostString <> '', 'Не задан приемник данных ' + ClassName);
  Assert(Assigned(AllVersions), 'Не заданы версии объектов');
  Assert(Assigned(StructureVersionObjectSets), 'Не задан источник структур');

  Result := 0;
  o := AObject as TWellStructure;
  Assert(Assigned(o.Version), 'Не задана версия объекта');
  Assert(Assigned(o.Structure), 'На задана структура');


  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);

    if not ds.Active then
      ds.Open;

    if ds.Locate(KeyFieldNames, varArrayOf([AObject.ID, o.Version.ID, o.Structure.ID]), []) then
      ds.Edit
    else ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;


  ds.FieldByName('VERSION_ID').AsInteger := o.Version.ID;
  ds.FieldByName('STRUCTURE_ID').AsInteger := o.Structure.ID;
  ds.Post;
end;

{ TWellFieldDataPoster }

constructor TWellFieldDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_WELL_FIELD';

  KeyFieldNames := 'WELL_UIN; VERSION_ID; FIELD_ID';

  FieldNames := 'WELL_UIN, VERSION_ID, FIELD_ID';
  AccessoryFieldNames := 'WELL_UIN, VERSION_ID, FIELD_ID';

  AutoFillDates := false;

  Sort := 'WELL_UIN, VERSION_ID, FIELD_ID';

end;

function TWellFieldDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TCommonServerDataSet;
    o: TWellField;
begin
  Assert(DataDeletionString <> '', 'Не задан приемник данных ' + ClassName);

  Result := 0;

  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TWellField;
  Assert(Assigned(o.Version), 'Не задана версия объекта');
  Assert(Assigned(o.Field), 'На задано месторождение');

  try
    // находим строку соответствующую ключу
    ds.First;
    if ds.Locate(KeyFieldNames, varArrayOf([AObject.ID, o.Version.ID, o.Field.ID]), []) then
      ds.Delete;
  except
    Result := -1;
  end;
end;

function TWellFieldDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TWellField;
begin
  Assert(Assigned(AllVersions), 'Не заданы версии объектов');
  Assert(Assigned(FieldVersionObjectSets), 'Не задан источник месторождений');

  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TWellField;

      o.ID := ds.FieldByName('WELL_UIN').AsInteger;

      o.Version := AllVersions.ItemsByID[ds.FieldByName('VERSION_ID').AsInteger] as TVersion;
      o.Field := FieldVersionObjectSets.GetObjectSetByVersion(o.Version).Objects.ItemsByID[ds.FieldByName('FIELD_ID').AsInteger] as TSimpleField;

      ds.Next;
    end;

    ds.First;
  end;


end;

function TWellFieldDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TWellField;
begin
  Assert(DataPostString <> '', 'Не задан приемник данных ' + ClassName);
  Assert(Assigned(AllVersions), 'Не заданы версии объектов');
  Assert(Assigned(FieldVersionObjectSets), 'Не задан источник месторождений');

  Result := 0;
  o := AObject as TWellField;
  Assert(Assigned(o.Version), 'Не задана версия объекта');
  Assert(Assigned(o.Field), 'На задано месторождение');


  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);

    if not ds.Active then
      ds.Open;

    if ds.Locate(KeyFieldNames, varArrayOf([AObject.ID, o.Version.ID, o.Field.ID]), []) then
      ds.Edit
    else ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;


  ds.FieldByName('VERSION_ID').AsInteger := o.Version.ID;
  ds.FieldByName('FIELD_ID').AsInteger := o.Field.ID;
  ds.Post;

end;

{ TWellBedDataPoster }

constructor TWellBedDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_WELL_BED';

  KeyFieldNames := 'WELL_UIN; VERSION_ID; BED_ID';

  FieldNames := 'WELL_UIN, VERSION_ID, BED_ID';
  AccessoryFieldNames := 'WELL_UIN, VERSION_ID, BED_ID';

  AutoFillDates := false;

  Sort := 'WELL_UIN, VERSION_ID, BED_ID';

end;

function TWellBedDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TCommonServerDataSet;
    o: TWellBed;
begin
  Assert(DataDeletionString <> '', 'Не задан приемник данных ' + ClassName);

  Result := 0;

  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TWellBed;
  Assert(Assigned(o.Version), 'Не задана версия объекта');
  Assert(Assigned(o.Bed), 'На задана залежь');

  try
    // находим строку соответствующую ключу
    ds.First;
    if ds.Locate(KeyFieldNames, varArrayOf([AObject.ID, o.Version.ID, o.Bed.ID]), []) then
      ds.Delete;
  except
    Result := -1;
  end;
end;

function TWellBedDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TWellBed;
begin
  Assert(Assigned(AllVersions), 'Не заданы версии объектов');
  Assert(Assigned(BedVersionObjectSets), 'Не задан источник залежей');

  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TWellBed;

      o.ID := ds.FieldByName('WELL_UIN').AsInteger;

      o.Version := AllVersions.ItemsByID[ds.FieldByName('VERSION_ID').AsInteger] as TVersion;
      o.Bed := BedVersionObjectSets.GetObjectSetByVersion(o.Version).Objects.ItemsByID[ds.FieldByName('BED_ID').AsInteger] as TSimpleBed;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TWellBedDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TWellBed;
begin
  Assert(DataPostString <> '', 'Не задан приемник данных ' + ClassName);
  Assert(Assigned(AllVersions), 'Не заданы версии объектов');
  Assert(Assigned(BedVersionObjectSets), 'Не задан источник залежей');

  Result := 0;
  o := AObject as TWellBed;
  Assert(Assigned(o.Version), 'Не задана версия объекта');
  Assert(Assigned(o.Bed), 'На задана залежь');


  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);

    if not ds.Active then
      ds.Open;

    if ds.Locate(KeyFieldNames, varArrayOf([AObject.ID, o.Version.ID, o.Bed.ID]), []) then
      ds.Edit
    else ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;


  ds.FieldByName('VERSION_ID').AsInteger := o.Version.ID;
  ds.FieldByName('BED_ID').AsInteger := o.Bed.ID;
  ds.Post;

end;

end.
