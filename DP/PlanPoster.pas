unit PlanPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, Plan, FinanceSource, FieldWork,
     Well, LicenseZone, BaseObjectType, TypeWork, Area, Organization;

type
  TParametrValueDataPoster = class(TImplementedDataPoster)
  private
    FAllParametrs: TParametrs;
    FAllStates: TStateWorks;
    FAllTypeWorks: TTypeWorks;
    procedure SetAllParametrs(const Value: TParametrs);
    procedure SetAllStates(const Value: TStateWorks);
    procedure SetAllTypeWorks(const Value: TTypeWorks);
  public
    property AllParametrs: TParametrs read FAllParametrs write SetAllParametrs;
    property AllTypeWorks: TTypeWorks read FAllTypeWorks write SetAllTypeWorks;
    property AllStates: TStateWorks read FAllStates write SetAllStates;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;

    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function PostToDB(ACollection: TIDObjects; AOwner: TIDObject): integer; overload; override;

    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TLinePlanDataPoster = class(TImplementedDataPoster)
  private
    FFinanceSources: TFinanceSources;
    FFieldWorks: TFieldWorks;
    FLicZones: TSimpleLicenseZones;
    FOrganizations: TOrganizations;
    procedure SetFinanceSources(const Value: TFinanceSources);
    procedure SetFieldWorks(const Value: TFieldWorks);
    procedure SetLicZones(const Value: TSimpleLicenseZones);
    procedure SetOrganizations(const Value: TOrganizations);
  public
    property FinanceSources: TFinanceSources read FFinanceSources write SetFinanceSources;
    property FieldWorks: TFieldWorks read FFieldWorks write SetFieldWorks;
    property LicZones: TSimpleLicenseZones read FLicZones write SetLicZones;
    property Organizations: TOrganizations read FOrganizations write SetOrganizations;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TParamReportDataPoster = class(TImplementedDataPoster)
  private
    FAllParametrs: TParametrs;
    FAllTypeWorks: TTypeWorks;
    FFinanceSources: TFinanceSources;
    procedure SetAllParametrs(const Value: TParametrs);
    procedure SetAllTypeWorks(const Value: TTypeWorks);
    procedure SetFinanceSources(const Value: TFinanceSources);
  public
    property AllParametrs: TParametrs read FAllParametrs write SetAllParametrs;
    property AllTypeWorks: TTypeWorks read FAllTypeWorks write SetAllTypeWorks;
    property FinanceSources: TFinanceSources read FFinanceSources write SetFinanceSources;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;

    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function PostToDB(ACollection: TIDObjects; AOwner: TIDObject): integer; overload; override;

    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TCountParamReportDataPoster = class(TImplementedDataPoster)
  private
    FAllTypeWorks: TTypeWorks;
    procedure SetAllTypeWorks(const Value: TTypeWorks);
  public
    property AllTypeWorks: TTypeWorks read FAllTypeWorks write SetAllTypeWorks;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;

    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function PostToDB(ACollection: TIDObjects; AOwner: TIDObject): integer; overload; override;

    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TCompositeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TCompositeObjectsDataPoster = class(TImplementedDataPoster)
  private
    FObjectTypes: TObjectTypes;
    FSimpleWells: TSimpleWells;
    FSimpleAreas: TSimpleAreas;
    procedure SetObjectTypes(const Value: TObjectTypes);
    procedure SetSimpleAreas(const Value: TSimpleAreas);
    procedure SetSimpleWells(const Value: TSimpleWells);
  public
    property ObjectTypes: TObjectTypes read FObjectTypes write SetObjectTypes;
    property SimpleWells: TSimpleWells read FSimpleWells write SetSimpleWells;
    property SimpleAreas: TSimpleAreas read FSimpleAreas write SetSimpleAreas;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TObjectPlanDataPoster = class(TImplementedDataPoster)
  private
    FTypesPlan: TTypePlans;
    procedure SetTypesPlan(const Value: TTypePlans);
  public
    property TypesPlan: TTypePlans read FTypesPlan write SetTypesPlan;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TParametrDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TTypePlanPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses Facade, SysUtils, Variants, SDFacade, Registrator, Math, DateUtils;

{ TParametrDataPoster }

constructor TParametrDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_PARAMETER_PLAN_DICT';

  KeyFieldNames := 'PARAMETER_PLAN_ID';
  FieldNames := 'PARAMETER_PLAN_ID, VCH_PARAMETER_PLAN_NAME';

  AccessoryFieldNames := 'PARAMETER_PLAN_ID, VCH_PARAMETER_PLAN_NAME';
  AutoFillDates := false;

  Sort := 'VCH_PARAMETER_PLAN_NAME';
end;

function TParametrDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TParametrDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TParametr;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TParametr;

      o.ID := ds.FieldByName('PARAMETER_PLAN_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_PARAMETER_PLAN_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TParametrDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TParametr;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := TParametr(AObject);

  ds.FieldByName('PARAMETER_PLAN_ID').AsInteger := o.ID;
  ds.FieldByName('VCH_PARAMETER_PLAN_NAME').AsString := trim (o.Name);

  ds.Post;

  if o.ID <= 0 then o.ID := (ds as TCommonServerDataSet).CurrentRecordFilterValues[0];
end;

{ TObjectPlanDataPoster }

constructor TObjectPlanDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_PLAN_GRR';
  //DataPostString := 'SPD_ADD_PLAN_GRR';
  //DataDeletionString := 'TBL_PLAN_GRR';

  KeyFieldNames := 'PLAN_ID';
  FieldNames := 'PLAN_ID, VCH_NAME_PLAN, DTM_STARTING, DTM_ENDING, COMMENT, DRAFT, TYPE_PLAN_ID';

  AccessoryFieldNames := 'PLAN_ID, VCH_NAME_PLAN, DTM_STARTING, DTM_ENDING, COMMENT, DRAFT, TYPE_PLAN_ID';
  AutoFillDates := false;

  Sort := 'VCH_NAME_PLAN';
end;

function TObjectPlanDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; 
begin
  Result := inherited DeleteFromDB(AObject, ACollection);

  
end;

function TObjectPlanDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TObjectPlanGRR;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TObjectPlanGRR;

      o.ID := ds.FieldByName('PLAN_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_NAME_PLAN').AsString);
      o.DateBegining := ds.FieldByName('DTM_STARTING').AsDateTime;
      o.DateEnding := ds.FieldByName('DTM_ENDING').AsDateTime;
      o.Comment := trim(ds.FieldByName('COMMENT').AsString);
      if ds.FieldByName('DRAFT').AsInteger = 1 then o.NotDraft := false;
      o.TypePlan := FTypesPlan.ItemsByID[ds.FieldByName('TYPE_PLAN_ID').AsInteger] as TTypePlan;

      // значения параметров будут грузиться только по необходимости (при вызове пользователя)

      ds.Next;
    end;

    ds.First;
  end;
end;

function TObjectPlanDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o:  TObjectPlanGRR;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TObjectPlanGRR;

  ds.FieldByName('PLAN_ID').AsInteger := o.ID;
  ds.FieldByName('VCH_NAME_PLAN').AsString := trim (o.Name);
  ds.FieldByName('DTM_STARTING').AsDateTime := DateOf(o.DateBegining);
  ds.FieldByName('DTM_ENDING').AsDateTime := DateOf(o.DateEnding);
  ds.FieldByName('COMMENT').AsString := trim (o.Comment);
  if Assigned (o.TypePlan) then ds.FieldByName('TYPE_PLAN_ID').AsInteger := o.TypePlan.ID;

  if not o.NotDraft then ds.FieldByName('DRAFT').AsInteger := 1
  else ds.FieldByName('DRAFT').AsInteger := 0;

  ds.Post;

  if o.ID <= 0 then o.ID := (ds as TCommonServerDataSet).CurrentRecordFilterValues[0];
end;

procedure TObjectPlanDataPoster.SetTypesPlan(const Value: TTypePlans);
begin
  if FTypesPlan <> Value then
    FTypesPlan := Value;
end;

{ TParametrValueDataPoster }

constructor TParametrValueDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_PARAM_PLAN_VALUE';

  KeyFieldNames := 'PARAM_PLAN_VALUE_ID';
  FieldNames := 'PARAM_PLAN_VALUE_ID, RECORD_PLAN_ID, ID_STATE_WORK, PARAMETER_PLAN_ID, VALUE_PARAMETR, ID_COMPOSITE, ID_TYPE_WORKS';

  AccessoryFieldNames := 'PARAM_PLAN_VALUE_ID, RECORD_PLAN_ID, ID_STATE_WORK, PARAMETER_PLAN_ID, VALUE_PARAMETR, ID_COMPOSITE, ID_TYPE_WORKS';
  AutoFillDates := false;
end;

function TParametrValueDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; 
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TParametrValueDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TParametrValue;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TParametrValue;

      o.ID := ds.FieldByName('PARAM_PLAN_VALUE_ID').AsInteger;
      o.TypeParametr := FAllParametrs.ItemsByID[ds.FieldByName('PARAMETER_PLAN_ID').AsInteger] as TParametr;
      o.State := FAllStates.ItemsByID[ds.FieldByName('ID_STATE_WORK').AsInteger] as TStateWork;
      o.TypeWork := FAllTypeWorks.ItemsByID[ds.FieldByName('ID_TYPE_WORKS').AsInteger] as TTypeWork;

      if ds.FieldByName('VALUE_PARAMETR').AsFloat <> null then
        o.ValueParam := RoundTo(ds.FieldByName('VALUE_PARAMETR').AsFloat, -3);

      // значения параметров будут грузиться только по необходимости (при вызове пользователя)

      ds.Next;
    end;

    ds.First;
  end;
end;

function TParametrValueDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    ob: TParametrValue;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  ob := AObject as TParametrValue;

  if ds.Locate('PARAM_PLAN_VALUE_ID', ob.ID, []) then
    ds.Edit
  else ds.Append;

  ds.FieldByName('PARAM_PLAN_VALUE_ID').Value := ob.ID;
  ds.FieldByName('RECORD_PLAN_ID').Value := ob.Owner.ID;
  if Assigned (ob.State) then ds.FieldByName('ID_STATE_WORK').Value := ob.State.ID;
  if Assigned(ob.TypeWork) then ds.FieldByName('ID_TYPE_WORKS').Value := ob.TypeWork.ID;
  if Assigned (ob.TypeParametr) then ds.FieldByName('PARAMETER_PLAN_ID').Value := ob.TypeParametr.ID;

  ds.FieldByName('VALUE_PARAMETR').Value := ob.ValueParam;

  ds.Post;

  ob.ID := ds.FieldByName('PARAM_PLAN_VALUE_ID').Value;
end;

function TParametrValueDataPoster.PostToDB(ACollection: TIDObjects;
  AOwner: TIDObject): integer;
var ds: TDataSet;
    ob: TLinePlan;
    ls: TParametrValues;
    i: integer;
begin
  Result := 0;
  ds := TMainFacade.GetInstance.DBGates.Add(Self);
  if not ds.Active then ds.Open;

  ob := AOwner as TLinePlan;
  ls := ACollection as TParametrValues;

  try
    while ds.Locate('RECORD_PLAN_ID', ob.ID, []) do
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

  for i := 0 to ls.Count - 1 do
  begin
    ds.Append;

    while not varIsNull(ds.FieldByName('RECORD_PLAN_ID').Value) do ds.Append;

    ds.FieldByName('RECORD_PLAN_ID').Value := ob.ID;
    ds.FieldByName('PARAM_PLAN_VALUE_ID').Value := ls.Items[i].ID;
    if Assigned(ls.Items[i].State) then ds.FieldByName('ID_STATE_WORK').Value := ls.Items[i].State.ID;
    ds.FieldByName('ID_TYPE_WORKS').Value := ls.Items[i].TypeWork.ID;
    if Assigned (ls.Items[i].TypeParametr) then ds.FieldByName('PARAMETER_PLAN_ID').Value := ls.Items[i].TypeParametr.ID;
    ds.FieldByName('VALUE_PARAMETR').Value := ls.Items[i].ValueParam;

    ds.Post;
  end;
end;

procedure TParametrValueDataPoster.SetAllParametrs(
  const Value: TParametrs);
begin
  if FAllParametrs <> Value then
    FAllParametrs := Value;
end;

procedure TParametrValueDataPoster.SetAllStates(const Value: TStateWorks);
begin
  if FAllStates <> Value then
    FAllStates := Value;
end;

procedure TParametrValueDataPoster.SetAllTypeWorks(
  const Value: TTypeWorks);
begin
  if FAllTypeWorks <>  Value then
    FAllTypeWorks := Value;
end;

{ TLinePlanDataPoster }

constructor TLinePlanDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'tbl_RECORD_PLAN';
  //DataPostString := 'SPD_ADD_RECORD_PLAN';
  //DataDeletionString := 'SPD_DELETE_RECORD_PLAN';

  KeyFieldNames := 'RECORD_PLAN_ID';
  FieldNames := 'RECORD_PLAN_ID, FINANCE_SOURCE_ID, FIELD_WORKS_ID, PLAN_ID, LICENSE_ZONE_ID, ID_COMPOSITE, TRUE_RECORD, ORGANIZATION_ID, TERRITORY_ACTIVITY';

  AccessoryFieldNames := 'RECORD_PLAN_ID, FINANCE_SOURCE_ID, FIELD_WORKS_ID, PLAN_ID, LICENSE_ZONE_ID, ID_COMPOSITE, TRUE_RECORD, ORGANIZATION_ID, TERRITORY_ACTIVITY';

  AutoFillDates := false;

  Sort := 'LICENSE_ZONE_ID, FINANCE_SOURCE_ID, FIELD_WORKS_ID';
end;

function TLinePlanDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; 
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TLinePlanDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o:  TLinePlan;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TLinePlan;

      o.ID := ds.FieldByName('RECORD_PLAN_ID').AsInteger;
      // владельца получаем при инициировании загрузки строк по плану ГРР
      o.FinanceSource := FFinanceSources.ItemsByID[ds.FieldByName('FINANCE_SOURCE_ID').AsInteger] as TFinanceSource;
      o.FieldWork := FFieldWorks.ItemsByID[ds.FieldByName('FIELD_WORKS_ID').AsInteger] as TFieldWork;
      o.LicZone := FLicZones.ItemsByID[ds.FieldByName('LICENSE_ZONE_ID').AsInteger] as TSimpleLicenseZone;
      //if Assigned (o.LicZone) then
      //  o.OrganizationGRR := o.LicZone.OwnerOrganization
      //else
      //begin
      o.OrganizationGRR := FOrganizations.ItemsByID[ds.FieldByName('ORGANIZATION_ID').AsInteger] as TOrganization;

      if ds.FieldByName('TERRITORY_ACTIVITY').AsInteger = 1 then
        o.TrueTerritoryActivity := true;
      //end;

      // 0 - все чисто, проверять не надо
      // 1 - надо проверить
      if ds.FieldByName('TRUE_RECORD').AsInteger = 0 then o.TrueRecord := false
      else o.TrueRecord := true;

      o.CompositeID := ds.FieldByName('ID_COMPOSITE').AsInteger;
      o.Composites.Reload('ID_COMPOSITE = ' + IntToStr (ds.FieldByName('ID_COMPOSITE').AsInteger));

      ds.Next;
    end;

    ds.First;
  end;
end;

function TLinePlanDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    ob: TLinePlan;
    i: Integer;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  ob := AObject as TLinePlan;

  if ds.Locate('RECORD_PLAN_ID', ob.ID, []) then
    ds.Edit
  else ds.Append;

  ds.FieldByName('RECORD_PLAN_ID').AsInteger := ob.ID;
  ds.FieldByName('PLAN_ID').AsInteger := ob.Owner.ID;

  if Assigned (ob.FinanceSource) then
    ds.FieldByName('FINANCE_SOURCE_ID').AsInteger := ob.FinanceSource.ID;

  if Assigned (ob.LicZone) then
    ds.FieldByName('LICENSE_ZONE_ID').AsInteger := ob.LicZone.ID;
  //else
  //begin
  if Assigned (ob.OrganizationGRR) then
    ds.FieldByName('ORGANIZATION_ID').AsInteger := ob.OrganizationGRR.ID;

  if ob.TrueTerritoryActivity then ds.FieldByName('TERRITORY_ACTIVITY').AsInteger := 1
  else ds.FieldByName('TERRITORY_ACTIVITY').AsInteger := 0;
  //end;

  if Assigned (ob.FieldWork) then
    ds.FieldByName('FIELD_WORKS_ID').AsInteger := ob.FieldWork.ID;

  if ob.Composite.Objects.Count > 0 then
  begin
    ob.Composite.Update;
    ds.FieldByName('ID_COMPOSITE').AsInteger := ob.Composite.ID;
  end
  else ds.FieldByName('ID_COMPOSITE').AsInteger := 1;

  // 0 - все чисто, проверять не надо
  // 1 - надо проверить
  if ob.TrueRecord then ds.FieldByName('TRUE_RECORD').AsInteger := 1
  else ds.FieldByName('TRUE_RECORD').AsInteger := 0;

  ds.Post;

  ob.ID := (ds as TCommonServerDataSet).CurrentRecordFilterValues[0];

  // поместить список объектов
  if Assigned (ob.Composite) then
  begin
    for i := 0 to ob.Composite.Objects.Count - 1 do
      (TCompositeObject(ob.Composite.Objects.Items[i])).CompositeID := ob.Composite.ID;
    ob.Composite.Objects.Update(ob.Composite.Objects);
  end;

  // сохраняем значения параметров
  ob.ParametrValues.Update(ob.ParametrValues);
end;

procedure TLinePlanDataPoster.SetFieldWorks(const Value: TFieldWorks);
begin
  if FFieldWorks <> Value then
    FFieldWorks := Value;
end;

procedure TLinePlanDataPoster.SetFinanceSources(
  const Value: TFinanceSources);
begin
  if FFinanceSources <> Value then
    FFinanceSources := Value;
end;

procedure TLinePlanDataPoster.SetLicZones(
  const Value: TSimpleLicenseZones);
begin
  if FLicZones <> Value then
    FLicZones := Value;
end;

procedure TLinePlanDataPoster.SetOrganizations(
  const Value: TOrganizations);
begin
  if FOrganizations <> Value then
    FOrganizations := Value;
end;

{ TCompositeDataPoster }

constructor TCompositeDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_COMPOSITE_OBJS_PLAN';

  KeyFieldNames := 'ID_COMPOSITE';
  FieldNames := 'ID_COMPOSITE, COMMENT';

  AccessoryFieldNames := 'ID_COMPOSITE, COMMENT';
  AutoFillDates := false;

  Sort := 'ID_COMPOSITE';
end;

function TCompositeDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; 
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TCompositeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TComposite;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TComposite;

      o.ID := ds.FieldByName('ID_COMPOSITE').AsInteger;
      o.Name := trim(ds.FieldByName('COMMENT').AsString);

      o.Objects.Reload('');

      ds.Next;
    end;

    ds.First;
  end;
end;

function TCompositeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o : TComposite;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := TComposite(AObject);

  ds.FieldByName('ID_COMPOSITE').AsInteger := o.ID;
  ds.FieldByName('COMMENT').AsString := trim (o.Name);

  ds.Post;

  if o.ID <= 0 then o.ID := (ds as TCommonServerDataSet).CurrentRecordFilterValues[0];
end;

{ TCompositeObjectsDataPoster }

constructor TCompositeObjectsDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_COMPOSITE_OBJ_PLAN';

  KeyFieldNames := 'ID_COMPOSITE; ID_OBJECT_PLAN; ID_OBJECT_TYPE';
  FieldNames := 'ID_COMPOSITE, ID_OBJECT_PLAN, ID_OBJECT_TYPE';

  AccessoryFieldNames := 'ID_COMPOSITE, ID_OBJECT_PLAN, ID_OBJECT_TYPE';
  AutoFillDates := false;
end;

function TCompositeObjectsDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; 
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TCompositeObjectsDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o:  TRegisteredIDObject;
    TypeObjID: integer;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      TypeObjID := (FObjectTypes.ItemsByID[ds.FieldByName('ID_OBJECT_TYPE').AsInteger] as TObjectType).ID;

      case TypeObjID of
        7  : begin  // скважина
               o := TSimpleWell.Create(AObjects);

               if Assigned (SimpleWells.ItemsByID[ds.FieldByName('ID_OBJECT_PLAN').AsInteger]) then
                 o := SimpleWells.ItemsByID[ds.FieldByName('ID_OBJECT_PLAN').AsInteger] as TSimpleWell
               else
               begin
                 SimpleWells.Reload('WELL_UIN = ' + IntToStr(ds.FieldByName('ID_OBJECT_PLAN').AsInteger));
                 o.Assign(SimpleWells.Items[SimpleWells.Count - 1]);
               end;

               o.ObjectType := FObjectTypes.ItemsByID[ds.FieldByName('ID_OBJECT_TYPE').AsInteger] as TObjectType;
               AObjects.Owner.Name := 'Скважина';
               AObjects.Add(o, false, false);
             end;
        29 : begin  // лицензионные участки
               o := TLicenseZone(AObjects.Add as TIDObject);
               AObjects.Owner.Name := 'Лицензионный участок';
               AObjects.Add(o, false, false);
             end;
        35 : ;  // структуры
        40 : begin  // площади
               o := TArea.Create(AObjects);

               if Assigned (SimpleAreas.ItemsByID[ds.FieldByName('ID_OBJECT_PLAN').AsInteger]) then
                 o := SimpleAreas.ItemsByID[ds.FieldByName('ID_OBJECT_PLAN').AsInteger] as TArea
               else
               begin
                 SimpleAreas.Reload('AREA_ID = ' + IntToStr(ds.FieldByName('ID_OBJECT_PLAN').AsInteger));
                 o.Assign(SimpleAreas.Items[SimpleAreas.Count - 1]);
               end;

               o.ObjectType := FObjectTypes.ItemsByID[ds.FieldByName('ID_OBJECT_TYPE').AsInteger] as TObjectType;
               AObjects.Owner.Name := 'Площадь';
               AObjects.Add(o, false, false);
             end;
      end;


      ds.Next;
    end;

    ds.First;
  end;
end;

function TCompositeObjectsDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var o: TCompositeObject;
    ds: TCommonServerDataSet;
begin
  Assert(DataPostString <> '', 'Не задан приемник данных ' + ClassName);
  Result := 0;

  o := TCompositeObject(AObject);

  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    if not ds.Active then
      ds.Open;

    if ds.Locate('ID_COMPOSITE; ID_OBJECT_PLAN', varArrayOf([o.CompositeID, o.ID]), []) then
      ds.Edit
    else ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;

  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  ds.FieldByName('ID_COMPOSITE').AsInteger := o.CompositeID;
  ds.FieldByName('ID_OBJECT_PLAN').AsInteger := o.ID;
  ds.FieldByName('ID_OBJECT_TYPE').AsInteger := o.ObjectType.ID;

  ds.Post;
end;

procedure TCompositeObjectsDataPoster.SetObjectTypes(
  const Value: TObjectTypes);
begin
  if FObjectTypes <> Value then
    FObjectTypes := Value;
end;

procedure TCompositeObjectsDataPoster.SetSimpleAreas(
  const Value: TSimpleAreas);
begin
  if FSimpleAreas <> Value then
    FSimpleAreas := Value;
end;

procedure TCompositeObjectsDataPoster.SetSimpleWells(
  const Value: TSimpleWells);
begin
  if FSimpleWells <> Value then
    FSimpleWells := Value;
end;

{ TTypePlanPoster }

constructor TTypePlanPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_TYPE_PLAN_DICT';

  KeyFieldNames := 'TYPE_PLAN_ID';
  FieldNames := 'TYPE_PLAN_ID, TYPE_PLAN_NAME';

  AccessoryFieldNames := 'TYPE_PLAN_ID, TYPE_PLAN_NAME';
  AutoFillDates := false;

  Sort := 'TYPE_PLAN_ID';
end;

function TTypePlanPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; 
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TTypePlanPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o:  TTypePlan;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TTypePlan;

      o.ID := ds.FieldByName('TYPE_PLAN_ID').AsInteger;
      o.Name := trim(ds.FieldByName('TYPE_PLAN_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TTypePlanPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o:  TTypePlan;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := TTypePlan(AObject);

  ds.FieldByName('TYPE_PLAN_ID').AsInteger := o.ID;
  ds.FieldByName('TYPE_PLAN_NAME').AsString := trim (o.Name);

  ds.Post;

  if o.ID <= 0 then o.ID := (ds as TCommonServerDataSet).CurrentRecordFilterValues[0];
end;

{ TParamReportDataPoster }

constructor TParamReportDataPoster.Create;
begin
  inherited;
  Options := [];
  DataSourceString := 'VW_PARAM_REPORT';

  KeyFieldNames := 'PLAN_ID, FINANCE_SOURCE_ID, TYPE_WORKS_ID, PARAMETER_PLAN_ID';
  FieldNames := 'PLAN_ID, PARAMETER_PLAN_ID, VCH_PARAMETER_PLAN_NAME, TYPE_WORKS_ID, VCH_WORK_TYPE_NAME, FINANCE_SOURCE_ID, VCH_FINANCE_SOURCE_NAME, VALUE_PARAMETR';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'TYPE_WORKS_ID, FINANCE_SOURCE_ID, PARAMETER_PLAN_ID';
end;

function TParamReportDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; 
begin
  Result := 0;
end;

function TParamReportDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TParamReport;
    p: TParametrValue;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    o := AObjects.Add as TParamReport;
    o.FinanceSource := FFinanceSources.ItemsByID[ds.FieldByName('FINANCE_SOURCE_ID').AsInteger] as TFinanceSource;

    while not ds.Eof do
    begin
      if o.FinanceSource.ID <> ds.FieldByName('FINANCE_SOURCE_ID').AsInteger then
      begin
        o := (AObjects as TParamsReport).ItemsByFinIstID[ds.FieldByName('FINANCE_SOURCE_ID').AsInteger] as TParamReport;

        if not Assigned (o) then
        begin
          o := AObjects.Add as TParamReport;
          o.FinanceSource := FFinanceSources.ItemsByID[ds.FieldByName('FINANCE_SOURCE_ID').AsInteger] as TFinanceSource;
        end;
      end;

      p := o.ParametrValues.Add as TParametrValue;

      p.TypeParametr := FAllParametrs.ItemsByID[ds.FieldByName('PARAMETER_PLAN_ID').AsInteger] as TParametr;
      p.TypeWork := FAllTypeWorks.ItemsByID[ds.FieldByName('TYPE_WORKS_ID').AsInteger] as TTypeWork;
      p.ValueParam := ds.FieldByName('VALUE_PARAMETR').AsFloat;

      // надо еще прицепить организацию

      ds.Next;
    end;

    ds.First;
  end;
end;

function TParamReportDataPoster.PostToDB(ACollection: TIDObjects;
  AOwner: TIDObject): integer;
begin
  Result := 0;
end;

function TParamReportDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

procedure TParamReportDataPoster.SetAllParametrs(const Value: TParametrs);
begin
  if FAllParametrs <> Value then
    FAllParametrs := Value;
end;

procedure TParamReportDataPoster.SetAllTypeWorks(const Value: TTypeWorks);
begin
  if FAllTypeWorks <> Value then
    FAllTypeWorks := Value;
end;

procedure TParamReportDataPoster.SetFinanceSources(
  const Value: TFinanceSources);
begin
  if FFinanceSources <> Value then
    FFinanceSources := Value;
end;

{ TCountParamReportDataPoster }

constructor TCountParamReportDataPoster.Create;
begin
  inherited;
  Options := [];
  DataSourceString := 'VW_COUNT_PARAM_REPORT';

  KeyFieldNames := 'PLAN_ID, TYPE_WORKS_ID';
  FieldNames := 'PLAN_ID, TYPE_WORKS_ID, VCH_WORK_TYPE_NAME, COUNT_FIN_SOURSE';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'TYPE_WORKS_ID';
end;

function TCountParamReportDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; 
begin
  Result := 0;
end;

function TCountParamReportDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TCountParamReport;
    p: TParametrValue;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    o := AObjects.Add as TCountParamReport;

    while not ds.Eof do
    begin
      p := o.ParametrValues.Add as TParametrValue;

      p.TypeWork := FAllTypeWorks.ItemsByID[ds.FieldByName('TYPE_WORKS_ID').AsInteger] as TTypeWork;
      p.ValueParam := ds.FieldByName('COUNT_FIN_SOURSE').AsFloat;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TCountParamReportDataPoster.PostToDB(ACollection: TIDObjects;
  AOwner: TIDObject): integer;
begin
  Result := 0;
end;

function TCountParamReportDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

procedure TCountParamReportDataPoster.SetAllTypeWorks(
  const Value: TTypeWorks);
begin
  if FAllTypeWorks <> Value then
    FAllTypeWorks := Value;
end;

end.
