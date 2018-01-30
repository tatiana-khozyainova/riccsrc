unit WellPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, LicenseZone, Well, Area, PetrolRegion,
     Organization, District, Structure, State, Topolist, Profile, Fluid, ReasonChange, Employee,
     Straton;

type
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
  TDinamicWellOrganizationStatusDataPoster = class(TWellOrganizationStatusDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

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

  // для скважин
  TWellDataPoster = class(TImplementedDataPoster)
  private
    FAllWellStates: TStates;
    FAllWellCategories: TWellCategories;
    FAllAreas: TSimpleAreas;
    FAllOrganizations: TOrganizations;
    FAllSimpleStratons: TSimpleStratons;
    FAllAbandonReasons: TAbandonReasons;
    FAllFluidTypesByBalance: TFluidTypes;
    FAllFluidTypes: TFluidTypes;
    FAllProfiles: TProfiles;

    procedure SetAllWellStates(const Value: TStates);
    procedure SetAllWellCategories(const Value: TWellCategories);
    procedure SetAllAreas(const Value: TSimpleAreas);
    procedure SetAllOrganizations(const Value: TOrganizations);
    procedure SetAllSimpleStratons(const Value: TSimpleStratons);
    procedure SetAllAbandonReasons(const Value: TAbandonReasons);
    procedure SetAllFluidTypes(const Value: TFluidTypes);
    procedure SetAllFluidTypesByBalance(const Value: TFluidTypes);
    procedure SetAllProfiles(const Value: TProfiles);
  protected
    procedure LocalSort(AObjects: TIDObjects); override;
    procedure InternalInitWell(AWell: TWell); virtual;

    procedure CommonInternalInitRow(AWell: TWell; ds: TDataSet); virtual;
    procedure InternalInitRow(AWell: TWell; ds: TDataSet); virtual;
  public
    property AllWellStates: TStates read FAllWellStates write SetAllWellStates;
    property AllWellCategories: TWellCategories read FAllWellCategories write SetAllWellCategories;
    property AllAreas: TSimpleAreas read FAllAreas write SetAllAreas;
    property AllOrganizations: TOrganizations read FAllOrganizations write SetAllOrganizations;
    property AllSimpleStratons: TSimpleStratons read FAllSimpleStratons write SetAllSimpleStratons;
    property AllProfiles: TProfiles read FAllProfiles write SetAllProfiles;
    property AllFluidTypes: TFluidTypes read FAllFluidTypes write SetAllFluidTypes;
    property AllFluidTypesByBalance: TFluidTypes read FAllFluidTypesByBalance write SetAllFluidTypesByBalance;
    property AllAbandonReasons: TAbandonReasons read FAllAbandonReasons write SetAllAbandonReasons;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  // для динамики по скважинам
  TDinamicWellDataPoster = class(TWellDataPoster)
  protected
    function  CommonPrePostToDB (AObject: TIDObject; ACollection: TIDObjects) : TDataSet; virtual;
    function  PrePostToDB (AObject: TIDObject; ACollection: TIDObjects) : TDataSet; virtual;
    function  AfterPost(AObject: TIDObject; ACollection: TIDObjects) : TDataSet; virtual;
  public
    procedure InternalInitWells(AObjects: TIDObjects); virtual;

    procedure CommonInternalInitRow(AWell: TWell; ds: TDataSet); override;
    procedure InternalInitRow(AWell: TWell; ds: TDataSet); override;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  // для принадлежности скважин
  TWellPositionDataPoster = class(TImplementedDataPoster)
  private
    FAllLicZones: TSimpleLicenseZones;
    FAllPetrolRegions: TPetrolRegions;
    FAllDistricts: TDistricts;
    FAllStructures: TStructures;
    FAllFields: TFields;
    FAllTopolists: TTopographicalLists;
    procedure SetAllLicZones(const Value: TSimpleLicenseZones);
    procedure SetAllPetrolRegions(const Value: TPetrolRegions);
    procedure SetAllDistricts(const Value: TDistricts);
    procedure SetAllStructures(const Value: TStructures);
    procedure SetAllFields(const Value: TFields);
    procedure SetAllTopolists(const Value: TTopographicalLists);
  public
    property AllLicZones: TSimpleLicenseZones read FAllLicZones write SetAllLicZones;
    property AllPetrolRegions: TPetrolRegions read FAllPetrolRegions write SetAllPetrolRegions;
    property AllDistricts: TDistricts read FAllDistricts write SetAllDistricts;
    property AllStructures: TStructures read FAllStructures write SetAllStructures;
    property AllFields: TFields read FAllFields write SetAllFields;
    property AllTopolists: TTopographicalLists read FAllTopolists write SetAllTopolists;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TDinamicWellPositionDataPoster = class(TImplementedDataPoster)
  private
    FAllDistricts: TDistricts;
    FAllFields: TFields;
    FAllPetrolRegions: TPetrolRegions;
    FAllLicZones: TSimpleLicenseZones;
    FAllStructures: TStructures;
    FAllTopolists: TTopographicalLists;
    procedure SetAllDistricts(const Value: TDistricts);
    procedure SetAllFields(const Value: TFields);
    procedure SetAllLicZones(const Value: TSimpleLicenseZones);
    procedure SetAllPetrolRegions(const Value: TPetrolRegions);
    procedure SetAllStructures(const Value: TStructures);
  public
    property AllLicZones: TSimpleLicenseZones read FAllLicZones write SetAllLicZones;
    property AllPetrolRegions: TPetrolRegions read FAllPetrolRegions write SetAllPetrolRegions;
    property AllDistricts: TDistricts read FAllDistricts write SetAllDistricts;
    property AllStructures: TStructures read FAllStructures write SetAllStructures;
    property AllFields: TFields read FAllFields write SetAllFields;
    property AllTopolists: TTopographicalLists read FAllTopolists write FAllTopolists;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses Facade, SysUtils, ClientCommon, Variants, Math;

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
  ds.FieldByName('VCH_PASSPORT_NUM').AsString := AWell.PassportNumberWell;

  ds.FieldByName('REASON_CHANGE_ID').AsInteger := AWell.ReasonChangeID;

  ds.FieldByName('VCH_WELL_PRODUCTIVITY').AsString := '';

  if Assigned (AWell.Category) then ds.FieldByName('WELL_CATEGORY_ID').AsInteger := AWell.Category.ID;
  if Assigned (AWell.State) then ds.FieldByName('WELL_STATE_ID').AsInteger := AWell.State.ID;
  //if Assigned(AWell.Age) then ds.FieldByName('TRUE_AGE_ID').AsInteger := AWell.Age.ID;
end;

constructor TWellDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'VW_WELL_COORD';
  DataDeletionString := '';
  DataPostString := 'SPD_ADD_WELL';

  KeyFieldNames := 'WELL_UIN';

  AccessoryFieldNames := 'WELL_UIN, VCH_WELL_NUM, VCH_PASSPORT_NUM, AREA_ID, WELL_CATEGORY_ID, ' +
                         'WELL_STATE_ID, PROFILE_ID, TARGET_AGE_ID, TRUE_AGE_ID, NUM_TARGET_DEPTH, ' +
                         'NUM_TRUE_DEPTH, NUM_ROTOR_ALTITUDE, NUM_TARGET_COST, NUM_TRUE_COST, DTM_CONSTRUCTION_STARTED, ' +
                         'DTM_CONSTRUCTION_FINISHED, DTM_DRILLING_START, DTM_DRILLING_FINISH date,
    VCH_WELL_PRODUCTIVITY varchar(15),
    DTM_ENTERING_DATE date,
    TARGET_FLUID_TYPE_ID smallint,
    TRUE_FLUID_TYPE_ID smallint,
    VCH_WELL_NAME varchar(150),
    REASON_CHANGE_ID integer

  FieldNames := 'WELL_UIN, VCH_WELL_NUM, VCH_PASSPORT_NUM, AREA_ID, WELL_CATEGORY_ID, WELL_STATE_ID, ' +
                'PROFILE_ID, TARGET_AGE_ID, TRUE_AGE_ID, NUM_TARGET_DEPTH, NUM_TRUE_DEPTH, ' +
                'NUM_ROTOR_ALTITUDE, NUM_TARGET_COST, NUM_TRUE_COST, DTM_CONSTRUCTION_STARTED, DTM_CONSTRUCTION_FINISHED, ' +
                'DTM_DRILLING_START, DTM_DRILLING_FINISH, VCH_WELL_PRODUCTIVITY, DTM_ENTERING_DATE, TARGET_FLUID_TYPE_ID, ' +
                'TRUE_FLUID_TYPE_ID, VCH_WELL_NAME, COLLECTION_SAMPLE_COUNT, REASON_CHANGE_ID';

  AutoFillDates := false;
  Sort := 'VCH_AREA_NAME, VCH_WELL_NUM';
end;

function TWellDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;

{
  var Medium: string;
    d: TDocument;
begin
  d := AObject as TDocument;
  Medium := trim(d.Medium.Name);

  if (d.LocationPath <> '') and
     (Medium = 'Электронный') and
     (not Assigned((AObject as TDocument).DocType.Parent)) then // последнее условие исправить
     if MessageBox(0, PChar('Удалить файлы этого документа из банка данных?'), PChar('Вопрос'),
        MB_YESNO + MB_ICONWARNING + MB_DEFBUTTON2 + MB_SYSTEMMODAL) = ID_YES then
    begin
      if ExtractFileExt(d.LocationPath) = '.shp' then
      begin
        d.Files.LoadFiles(ExtractFilePath(d.LocationPath) + inttostr(d.ID) + '_*.*');
        d.Files.ChangeNameFiles;
      end
      else
        DeleteFile(PChar(d.LocationPath));
    end;

  Result := inherited DeleteFromDB(AObject);

  }
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

    while not ds.Eof do
    begin
      if AObjects.ObjectClass = TDinamicWell then
        o := AObjects.Add as TDinamicWell
      else o := AObjects.Add as TWell;

      InternalInitWell(o);
      ds.Next;
    end;

    LocalSort(AObjects);
    ds.First;
  end;
end;

procedure TWellDataPoster.InternalInitRow(AWell: TWell; ds: TDataSet);
begin

end;

procedure TWellDataPoster.InternalInitWell(AWell: TWell);
var ds: TDataSet;
begin
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  AWell.ID := ds.FieldByName('WELL_UIN').AsInteger;

  if Assigned(FAllAreas) then
    AWell.Area := FAllAreas.ItemsByID[ds.FieldByName('AREA_ID').AsInteger] as TSimpleArea;

  AWell.PassportNumberWell := trim(ds.FieldByName('VCH_PASSPORT_NUM').AsString);
  
  AWell.Name := trim(ds.FieldByName('VCH_WELL_NAME').AsString);
  AWell.NumberWell := trim(ds.FieldByName('VCH_WELL_NUM').AsString);
  AWell.Altitude := ds.FieldByName('NUM_ROTOR_ALTITUDE').AsFloat;
  AWell.DtDrillingStart := ds.FieldByName('DTM_DRILLING_START').AsDateTime;
  AWell.DtDrillingFinish := ds.FieldByName('DTM_DRILLING_FINISH').AsDateTime;
  AWell.TrueDepth := ds.FieldByName('NUM_TRUE_DEPTH').AsFloat;
  AWell.TargetDepth := ds.FieldByName('NUM_TARGET_DEPTH').AsFloat;
  

  if Assigned(FAllWellCategories) then
    AWell.Category := FAllWellCategories.ItemsByID[ds.FieldByName('WELL_CATEGORY_ID').AsInteger] as TWellCategory;

  if Assigned(FAllWellStates) then
    AWell.State := FAllWellStates.ItemsByID[ds.FieldByName('WELL_STATE_ID').AsInteger] as TState;

  if Assigned(FAllProfiles) then
    AWell.Profile := FAllProfiles.ItemsByID[ds.FieldByName('PROFILE_ID').AsInteger] as TProfile;

  if Assigned(FAllSimpleStratons) then
  begin
    AWell.TargetStraton := FAllSimpleStratons.ItemsByID[ds.FieldByName('TARGET_AGE_ID').AsInteger] as TSimpleStraton;
    AWell.TrueStraton := FAllSimpleStratons.ItemsByID[ds.FieldByName('TRUE_AGE_ID').AsInteger] as TSimpleStraton;
  end;
end;

procedure TWellDataPoster.LocalSort(AObjects: TIDObjects);
begin
  inherited;
  AObjects.Sort(SortWells);
end;

function TWellDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TWell;
begin
  Result := inherited PostToDB(AObject, ACollection);

  ds := TMainFacade.GetInstance.DBGates.Add(Self);
  o := AObject as TWell;

  ds.FieldByName('WELL_UIN').Value := o.ID;
  ds.FieldByName('VCH_WELL_NUM').Value := o.NumberWell;
  ds.FieldByName('AREA_ID').Value := o.Area.ID;
  ds.FieldByName('VCH_WELL_NAME').Value := o.Name;
  ds.FieldByName('VCH_PASSPORT_NUM').Value := o.PassportNumberWell;
  ds.FieldByName('VCH_WELL_PRODUCTIVITY').Value := '';

  if Assigned (o.Category) then
    ds.FieldByName('WELL_CATEGORY_ID').Value := o.Category.ID
  else
    ds.FieldByName('WELL_CATEGORY_ID').Value := null;

  if Assigned (o.State) then
    ds.FieldByName('WELL_STATE_ID').Value := o.State.ID
  else
    ds.FieldByName('WELL_STATE_ID').Value := null;


  ds.FieldByName('REASON_CHANGE_ID').Value := o.ReasonChangeID;

  if Assigned (o.Profile) then
    ds.FieldByName('PROFILE_ID').Value := o.Profile.ID
  else
    ds.FieldByName('PROFILE_ID').Value := null;



  if Assigned (o.FluidType) then
    ds.FieldByName('TRUE_FLUID_TYPE_ID').Value := o.FluidType.ID;

  if Assigned (o.FluidTypeByBalance) then
    ds.FieldByName('TARGET_FLUID_TYPE_ID').Value := o.FluidTypeByBalance.ID;

  ds.FieldByName('NUM_TARGET_COST').Value := o.TargetCost;
  ds.FieldByName('NUM_TRUE_COST').Value := o.FactCost;

  ds.FieldByName('DTM_DRILLING_START').Value := DateToStr(o.DtDrillingStart);
  ds.FieldByName('DTM_DRILLING_FINISH').Value := DateToStr(o.DtDrillingFinish);

  ds.FieldByName('NUM_TRUE_DEPTH').Value := o.TrueDepth;
  ds.FieldByName('NUM_TARGET_DEPTH').AsFloat := o.TargetDepth;

  if Assigned(o.TargetStraton) then
    ds.FieldByName('TARGET_AGE_ID').Value := o.TargetStraton.ID
  else
    ds.FieldByName('TARGET_AGE_ID').Value := null;

  if Assigned(o.TrueStraton) then
    ds.FieldByName('TRUE_AGE_ID').Value := o.TrueStraton.ID
  else
    ds.FieldByName('TRUE_AGE_ID').Value := null;


  {
  NUM_ROTOR_ALTITUDE,
  NUM_TARGET_COST,
  NUM_TRUE_COST,
  DTM_CONSTRUCTION_STARTED,
  DTM_CONSTRUCTION_FINISHED,
  DTM_ENTERING_DATE,
  COLLECTION_SAMPLE_COUNT,
  }

  ds.Post;

  if o.ID = 0 then o.ID := ds.FieldByName('WELL_UIN').Value;

//  if AObject.ID = 0 then AObject.ID := ds.FieldByName('WELL_UIN').AsInteger;
end;


{ TWellPositionDataPoster }

constructor TWellPositionDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue, soSingleDataSource];
  DataSourceString := 'TBL_WELL_POSITION';
  //DataPostString := 'SPD_SET_WELL_POSITION';

  KeyFieldNames := 'WELL_UIN';
  FieldNames := 'WELL_UIN, TOPOGRAPHICAL_LIST_ID, LICENSE_ZONE_ID, STRUCT_ID, DISTRICT_ID, PETROL_REGION_ID, STRUCTURE_ID, FIELD_ID';

  AccessoryFieldNames := 'WELL_UIN, TOPOGRAPHICAL_LIST_ID, LICENSE_ZONE_ID, STRUCT_ID, DISTRICT_ID, PETROL_REGION_ID, STRUCTURE_ID, FIELD_ID';
  AutoFillDates := false;

  Sort := 'WELL_UIN';
end;
                       
function TWellPositionDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
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
      if Assigned(AllLicZones) then
        o.LicZone := FAllLicZones.ItemsByID[ds.FieldByName('LICENSE_ZONE_ID').AsInteger] as TSimpleLicenseZone;
      if Assigned (AllDistricts) then
        o.District := FAllDistricts.ItemsByID[ds.FieldByName('DISTRICT_ID').AsInteger] as TDistrict;
      if Assigned (AllPetrolRegions) then
        o.NGR := FAllPetrolRegions.PlainList.ItemsByID[ds.FieldByName('PETROL_REGION_ID').AsInteger] as TPetrolRegion;
      if Assigned (AllStructures) then
        o.Structure := FAllStructures.ItemsByID[ds.FieldByName('STRUCTURE_ID').AsInteger] as TStructure;
      if Assigned (AllFields) then
        o.Field := FAllFields.ItemsByID[ds.FieldByName('FIELD_ID').AsInteger] as TField;
        
      //o.BED_ID := ds.FieldByName('BED_ID').AsInteger;

      o.STRUCT_ID := ds.FieldByName('STRUCT_ID').AsInteger;

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
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TWellPosition;

  ds.FieldByName('WELL_UIN').AsInteger := o.ID;

  if Assigned(o.Topolist) then ds.FieldByName('TOPOGRAPHICAL_LIST_ID').AsInteger := o.Topolist.ID;

  if Assigned (o.LicZone) then
    ds.FieldByName('LICENSE_ZONE_ID').AsInteger := o.LicZone.ID
  else
    ds.FieldByName('LICENSE_ZONE_ID').Value := Null;

  ds.FieldByName('STRUCT_ID').AsInteger := o.STRUCT_ID;

  if Assigned (o.Structure) then
    ds.FieldByName('STRUCTURE_ID').AsInteger := o.Structure.ID
  else
    ds.FieldByName('STRUCTURE_ID').Value := Null;

  if Assigned (o.District) then
    ds.FieldByName('DISTRICT_ID').AsInteger := o.District.ID
  else
    ds.FieldByName('DISTRICT_ID').Value := Null;

  if Assigned (o.NGR) then
    ds.FieldByName('PETROL_REGION_ID').AsInteger := o.NGR.ID
  else
    ds.FieldByName('PETROL_REGION_ID').Value := Null;

  ds.Post;

  o.ID := ds.FieldByName('WELL_UIN').AsInteger;
end;

procedure TWellPositionDataPoster.SetAllDistricts(const Value: TDistricts);
begin
  if FAllDistricts <> Value then 
    FAllDistricts := Value;
end;

procedure TWellPositionDataPoster.SetAllLicZones(
  const Value: TSimpleLicenseZones);
begin
  if FAllLicZones <> Value then
    FAllLicZones := Value;
end;

procedure TWellPositionDataPoster.SetAllStructures(
  const Value: TStructures);
begin
  if FAllStructures <> Value then
    FAllStructures := Value;
end;

procedure TWellPositionDataPoster.SetAllFields(const Value: TFields);
begin
  if FAllFields <> Value then
    FAllFields := Value;
end;

procedure TWellPositionDataPoster.SetAllTopolists(
  const Value: TTopographicalLists);
begin
  if FAllTopolists <> Value then
    FAllTopolists := Value;
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

procedure TWellDataPoster.SetAllAbandonReasons(
  const Value: TAbandonReasons);
begin
  if FAllAbandonReasons <> Value then
    FAllAbandonReasons := Value;
end;

procedure TWellDataPoster.SetAllAreas(const Value: TSimpleAreas);
begin
  if FAllAreas <> Value then
    FAllAreas := Value;
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

{ TDinamicWellDataPoster }

function TDinamicWellDataPoster.AfterPost(AObject: TIDObject;
  ACollection: TIDObjects): TDataSet;
begin
  Result := nil;
end;

procedure TDinamicWellDataPoster.CommonInternalInitRow(AWell: TWell;
  ds: TDataSet);
begin
  inherited;

end;

function TDinamicWellDataPoster.CommonPrePostToDB(AObject: TIDObject;
  ACollection: TIDObjects): TDataSet;
begin
  Result := nil;
end;

constructor TDinamicWellDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'tbl_well_dinamics';
  DataDeletionString := '';
  DataPostString := '';

  KeyFieldNames := 'WELL_UIN';

  FieldNames := 'WELL_UIN, REASON_CHANGE_ID, AREA_ID, VCH_WELL_NUM, WELL_CATEGORY_ID, WELL_STATE_ID, NUM_ROTOR_ALTITUDE, ' +
                'NUM_EARTH_ALTITUDE, NUM_FLOOR_ALTITUDE, PROFILE_ID, DTM_CONSTRUCTION_STARTED, DTM_CONSTRUCTION_FINISHED, ' +
                'DTM_DRILLING_START, DTM_DRILLING_FINISH, NUM_TARGET_DEPTH, NUM_TRUE_DEPTH, TARGET_FLUID_TYPE_ID, TRUE_FLUID_TYPE_ID, ' +
                'VCH_WELL_PRODUCTIVITY, NUM_TARGET_COST, NUM_TRUE_COST, VCH_PASSPORT_NUM, DTM_ENTERING_DATE, ' +
                'DTM_LAST_MODIFY_DATE, VCH_WELL_NAME, TARGET_STRATON_ID, TRUE_STRATON_ID, TRUE_AGE_ID';

  AccessoryFieldNames := 'WELL_UIN, REASON_CHANGE_ID, VCH_WELL_NUM, VCH_PASSPORT_NUM, AREA_ID, WELL_CATEGORY_ID, WELL_STATE_ID, ' +
                'PROFILE_ID, TARGET_AGE_ID, TRUE_AGE_ID, NUM_TARGET_DEPTH, NUM_TRUE_DEPTH, ' +
                'NUM_ROTOR_ALTITUDE, NUM_TARGET_COST, NUM_TRUE_COST, DTM_CONSTRUCTION_STARTED, DTM_CONSTRUCTION_FINISHED, ' +
                'DTM_DRILLING_START, DTM_DRILLING_FINISH, VCH_WELL_PRODUCTIVITY, DTM_ENTERING_DATE, TARGET_FLUID_TYPE_ID, ' +
                'TRUE_FLUID_TYPE_ID, VCH_WELL_NAME, COLLECTION_SAMPLE_COUNT, ABANDON_REASON_ID, DTM_ABANDON_DATE, DTM_LAST_MODIFY_DATE';

  AutoFillDates := false;
  Sort := 'DTM_LAST_MODIFY_DATE, VCH_AREA_NAME, VCH_WELL_NUM';
end;

function TDinamicWellDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TDinamicWellDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TDinamicWell;
begin
  Result := inherited GetFromDB(AFilter, AObjects);

  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.ItemsByID[ds.FieldByName('WELL_UIN').AsInteger] as TDinamicWell;

      o.ReasonChangeID := ds.FieldByName('REASON_CHANGE_ID').AsInteger;
      o.PassportNumberWell := trim(ds.FieldByName('VCH_PASSPORT_NUM').AsString);

      if Assigned(FAllProfiles) then
        o.Profile := FAllProfiles.ItemsByID[ds.FieldByName('PROFILE_ID').AsInteger] as TProfile;

      if Assigned(FAllFluidTypes) then
        o.FluidType := FAllFluidTypes.ItemsByID[ds.FieldByName('TRUE_FLUID_TYPE_ID').AsInteger] as TFluidType;

      if Assigned(FAllFluidTypesByBalance) then
        o.FluidTypeByBalance := FAllFluidTypesByBalance.ItemsByID[ds.FieldByName('TARGET_FLUID_TYPE_ID').AsInteger] as TFluidType;

      //if Assigned(FAllAbandonReasons) then
      //  o.AbandonReason := FAllAbandonReasons.ItemsByID[ds.FieldByName('ABANDON_REASON_ID').AsInteger] as TAbandonReason;

      //o.DtLiquidation := ds.FieldByName('DTM_ABANDON_DATE').AsDateTime;
      o.TargetCost := ds.FieldByName('NUM_TARGET_COST').AsFloat;
      o.FactCost := ds.FieldByName('NUM_TRUE_COST').AsFloat;

      o.EnteringDate := ds.FieldByName('DTM_ENTERING_DATE').AsDateTime;
      o.LastModifyDate := ds.FieldByName('DTM_LAST_MODIFY_DATE').AsDateTime;

      {
      TARGET_AGE_ID,
      TRUE_AGE_ID,
      NUM_TARGET_DEPTH,
      DTM_CONSTRUCTION_STARTED,
      DTM_CONSTRUCTION_FINISHED,
      VCH_WELL_PRODUCTIVITY,
      COLLECTION_SAMPLE_COUNT
      }

      ds.Next;
    end;

    ds.First;
  end;
end;

procedure TDinamicWellDataPoster.InternalInitRow(AWell: TWell;
  ds: TDataSet);
begin
  //if Assigned ((AWell as TDinamicWell).ReasonChange) then
  //  ds.FieldByName('REASON_CHANGE_ID').AsInteger := (AWell as TDinamicWell).ReasonChange.ID
  //else
  ds.FieldByName('REASON_CHANGE_ID').AsInteger := 1;

  if Assigned ((AWell as TDinamicWell).Profile) then
    ds.FieldByName('PROFILE_ID').AsInteger := (AWell as TDinamicWell).Profile.ID;

  if Assigned ((AWell as TDinamicWell).FluidType) then
    ds.FieldByName('TRUE_FLUID_TYPE_ID').AsInteger := (AWell as TDinamicWell).FluidType.ID;

  if Assigned ((AWell as TDinamicWell).FluidTypeByBalance) then
    ds.FieldByName('TARGET_FLUID_TYPE_ID').AsInteger := (AWell as TDinamicWell).FluidTypeByBalance.ID;

  if Assigned ((AWell as TDinamicWell).AbandonReason) then
    ds.FieldByName('ABANDON_REASON_ID').AsInteger := (AWell as TDinamicWell).AbandonReason.ID;

  ds.FieldByName('DTM_ABANDON_DATE').AsDateTime := (AWell as TDinamicWell).DtLiquidation;
  ds.FieldByName('NUM_TARGET_COST').AsFloat := (AWell as TDinamicWell).TargetCost;
  ds.FieldByName('NUM_TRUE_COST').AsFloat := (AWell as TDinamicWell).FactCost;

  ds.FieldByName('DTM_ENTERING_DATE').AsDateTime := (AWell as TDinamicWell).EnteringDate;
  ds.FieldByName('DTM_LAST_MODIFY_DATE').AsDateTime := (AWell as TDinamicWell).LastModifyDate;

  ds.FieldByName('DTM_DRILLING_START').AsDateTime := (AWell as TDinamicWell).DtDrillingStart;
  ds.FieldByName('DTM_DRILLING_FINISH').AsDateTime := (AWell as TDinamicWell).DtDrillingFinish;

  ds.FieldByName('NUM_TRUE_DEPTH').AsFloat := (AWell as TDinamicWell).TrueDepth;
  ds.FieldByName('NUM_TARGET_DEPTH').AsFloat := (AWell as TDinamicWell).TargetDepth;
end;

procedure TDinamicWellDataPoster.InternalInitWells(AObjects: TIDObjects);
begin

end;

function TDinamicWellDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TDinamicWell;
begin
  Result := inherited PostToDB(AObject, ACollection);

  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TDinamicWell;

  while not varIsNull (ds.FieldByName('WELL_UIN').Value) do ds.Append;

  ds.FieldByName('WELL_UIN').Value := o.ID;
  ds.FieldByName('VCH_WELL_NUM').Value := o.NumberWell;
  ds.FieldByName('AREA_ID').Value := o.Area.ID;
  ds.FieldByName('VCH_WELL_NAME').Value := o.Name;
  ds.FieldByName('VCH_PASSPORT_NUM').Value := o.PassportNumberWell;

  ds.FieldByName('VCH_WELL_PRODUCTIVITY').Value := '';

  if Assigned (o.Category) then ds.FieldByName('WELL_CATEGORY_ID').Value := o.Category.ID;
  if Assigned (o.State) then ds.FieldByName('WELL_STATE_ID').Value := o.State.ID;

  if Assigned (o.ReasonChange) then
    ds.FieldByName('REASON_CHANGE_ID').Value := o.ReasonChange.ID;

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
  ds.FieldByName('NUM_TRUE_COST').Value := o.FactCost;

  ds.FieldByName('DTM_ENTERING_DATE').Value := DateToStr(o.EnteringDate);
  ds.FieldByName('DTM_LAST_MODIFY_DATE').Value := null;//DateToStr(o.LastModifyDate);

  ds.FieldByName('DTM_DRILLING_START').Value := DateToStr(o.DtDrillingStart);
  ds.FieldByName('DTM_DRILLING_FINISH').Value := DateToStr(o.DtDrillingFinish);

  ds.FieldByName('NUM_TRUE_DEPTH').Value := o.TrueDepth;
  ds.FieldByName('NUM_TARGET_DEPTH').AsFloat := o.TargetDepth;

  ds.Post;

  if o.ID = 0 then o.ID := ds.FieldByName('WELL_UIN').Value;
  if not Assigned (o.ReasonChange) then
    o.ReasonChangeID := ds.FieldByName('REASON_CHANGE_ID').Value;

  {
  ds := fc.DBGates.Add(Self);

  o := AObject as TDinamicWell;

  ds.FieldByName('WELL_UIN').AsInteger := o.ID;
  ds.FieldByName('REASON_CHANGE_ID').AsInteger := o.ReasonChange.ID;
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
}
  //ds.Post;

  //if o.ID = 0 then o.ID := ds.FieldByName('WELL_UIN').Value;
end;

function TDinamicWellDataPoster.PrePostToDB(AObject: TIDObject;
  ACollection: TIDObjects): TDataSet;
begin
  Result := nil;
end;

{ TDinamicWellPositionDataPoster }

constructor TDinamicWellPositionDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'vw_dinamic_well_position';
  DataPostString := 'TBL_WELL_POSITION_DINAMICS';
  DataDeletionString := 'TBL_WELL_POSITION_DINAMICS';

  KeyFieldNames := 'WELL_UIN';
  //FieldNames := 'WELL_UIN, TOPOGRAPHICAL_LIST_ID, LICENSE_ZONE_ID, STRUCT_ID, DISTRICT_ID, PETROL_REGION_ID, STRUCTURE_ID, FIELD_ID';

  FieldNames := 'WELL_UIN, REASON_CHANGE_ID, DTM_LAST_MODIFY_DATE, TOPOGRAPHICAL_LIST_ID, LICENSE_ZONE_ID, STRUCT_ID, DISTRICT_ID, PETROL_REGION_ID, STRUCTURE_ID, FIELD_ID';

  AccessoryFieldNames := 'WELL_UIN, REASON_CHANGE_ID, DTM_LAST_MODIFY_DATE, TOPOGRAPHICAL_LIST_ID, LICENSE_ZONE_ID, STRUCT_ID, DISTRICT_ID, PETROL_REGION_ID, STRUCTURE_ID, FIELD_ID';
  AutoFillDates := false;

  Sort := 'WELL_UIN';
end;

function TDinamicWellPositionDataPoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TDinamicWellPositionDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o:  TDinamicWellPosition;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TDinamicWellPosition;

      o.ID := ds.FieldByName('WELL_UIN').AsInteger;
      o.Topolist := FAllTopolists.ItemsByID[ds.FieldByName('TOPOGRAPHICAL_LIST_ID').AsInteger] as TTopographicalList;
      o.LicZone := FAllLicZones.ItemsByID[ds.FieldByName('LICENSE_ZONE_ID').AsInteger] as TSimpleLicenseZone;
      o.District := FAllDistricts.ItemsByID[ds.FieldByName('DISTRICT_ID').AsInteger] as TDistrict;
      o.NGR := FAllPetrolRegions.PlainList.ItemsByID[ds.FieldByName('PETROL_REGION_ID').AsInteger] as TPetrolRegion;
      o.Structure := FAllStructures.ItemsByID[ds.FieldByName('STRUCTURE_ID').AsInteger] as TStructure;
      o.STRUCT_ID := ds.FieldByName('STRUCT_ID').AsInteger;

      o.dtmLastModifyDate := ds.FieldByName('DTM_LAST_MODIFY_DATE').AsDateTime;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TDinamicWellPositionDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TDinamicWellPosition;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TDinamicWellPosition;

  while not varIsNull (ds.FieldByName('WELL_UIN').Value) do ds.Append;

  ds.FieldByName('WELL_UIN').AsInteger := o.ID;

  if Assigned ((o.Collection.Owner as TDinamicWell).ReasonChange) then
    ds.FieldByName('REASON_CHANGE_ID').AsInteger := (o.Collection.Owner as TDinamicWell).ReasonChange.ID;
  if Assigned(o.Topolist) then
    ds.FieldByName('TOPOGRAPHICAL_LIST_ID').AsInteger := o.Topolist.ID;
  if Assigned(o.LicZone) then
    ds.FieldByName('LICENSE_ZONE_ID').AsInteger := o.LicZone.ID;
  if Assigned(o.Structure) then
    ds.FieldByName('STRUCTURE_ID').AsInteger := o.Structure.ID;
  if Assigned(o.District) then
    ds.FieldByName('DISTRICT_ID').AsInteger := o.District.ID;
  if Assigned(o.NGR) then
    ds.FieldByName('PETROL_REGION_ID').AsInteger := o.NGR.ID;
  if Assigned(o.Field) then
    ds.FieldByName('FIELD_ID').AsInteger := o.Field.ID;

  ds.FieldByName('STRUCT_ID').AsInteger := o.STRUCT_ID;

  ds.Post;

  if o.Id = 0 then o.ID := ds.FieldByName('WELL_UIN').AsInteger;
end;

{ TDinamicOrganizationStatusDataPoster }

constructor TDinamicWellOrganizationStatusDataPoster.Create;
begin
  inherited;

end;

function TDinamicWellOrganizationStatusDataPoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TDinamicWellOrganizationStatusDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
begin
  Result := 0;
end;

function TDinamicWellOrganizationStatusDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

{ TOrganizationStatusDataPoster }

constructor TWellOrganizationStatusDataPoster.Create;
begin
  inherited;
  Options := [];
  DataSourceString := 'TBL_ORG_STATUS';
  DataDeletionString := '';
  DataPostString := '';

  KeyFieldNames := 'ORG_STATUS_ID; WELL_UIN; ORGANIZATION_ID';
  FieldNames := 'ORG_STATUS_ID, WELL_UIN, ORGANIZATION_ID';

  AccessoryFieldNames := '';
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

      if Assigned(AllStatusOrganization) then
      begin
        o.StatusOrganization := AllStatusOrganization.ItemsByID[ds.FieldByName('ORG_STATUS_ID').AsInteger] as TOrganizationStatus;

        if Assigned(o.StatusOrganization) then o.ID := o.StatusOrganization.ID;
      end;
      if Assigned(AllOrganization) then
        o.Organization := AllOrganization.ItemsByID[ds.FieldByName('ORGANIZATION_ID').AsInteger] as TOrganization;




      ds.Next;
    end;

    ds.First;
  end;
end;

function TWellOrganizationStatusDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
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

procedure TDinamicWellPositionDataPoster.SetAllDistricts(
  const Value: TDistricts);
begin
  if FAllDistricts <> Value then
    FAllDistricts := Value;
end;

procedure TDinamicWellPositionDataPoster.SetAllFields(
  const Value: TFields);
begin
  if FAllFields <> Value then
    FAllFields := Value;
end;

procedure TDinamicWellPositionDataPoster.SetAllLicZones(
  const Value: TSimpleLicenseZones);
begin
  if FAllLicZones <> Value then
    FAllLicZones := Value;
end;

procedure TDinamicWellPositionDataPoster.SetAllPetrolRegions(
  const Value: TPetrolRegions);
begin
  if FAllPetrolRegions <> Value then
    FAllPetrolRegions := Value;
end;

procedure TDinamicWellPositionDataPoster.SetAllStructures(
  const Value: TStructures);
begin
  if fAllStructures <> Value then
    FAllStructures := Value;
end;

end.
