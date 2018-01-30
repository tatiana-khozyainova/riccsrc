unit LicenseZonePoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, LicenseZone, SysUtils,
     Organization, MeasureUnits, NGDR;

type
  TLicenseConditionValuePoster = class(TImplementedDataPoster)
  private
    FAllLicenseConditions: TLicenseConditions;
  public
    property AllLicenseConditions: TLicenseConditions read FAllLicenseConditions write FAllLicenseConditions;
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    constructor Create; override;
  end;

  TLicenseConditionKindPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    
    constructor Create; override;
  end;

  TLicenseConditionTypePoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    
    constructor Create; override;
  end;

  TLicenseConditionPoster = class(TImplementedDataPoster)
  private
    FLicenseConditionTypes: TLicenseConditionTypes;
    FLicenseConditionKinds: TLicenseConditionKinds;
  public
    property AllLicenseConditionKinds: TLicenseConditionKinds read FLicenseConditionKinds write FLicenseConditionKinds;
    property AllLicenseConditionTypes: TLicenseConditionTypes read FLicenseConditionTypes write FLicenseConditionTypes;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    constructor Create; override;
  end;


  TLicenseZoneTypePoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;

    constructor Create; override;
  end;

  TSimpleLicenseZonePoster = class(TImplementedDataPoster)
  private
    FAllOrganizations: TOrganizations;
    FAllLicZoneTypes: TLicenseZoneTypes;
    FAllNGDRs: TNGDRs;
    procedure SetAllOrganizations(const Value: TOrganizations);
    procedure SetAllLicZoneTypes(const Value: TLicenseZoneTypes);
    procedure SetAllNGDRs(const Value: TNGDRs);
  public
    property AllOrganizations: TOrganizations read FAllOrganizations write SetAllOrganizations;
    property AllLicZoneTypes: TLicenseZoneTypes read FAllLicZoneTypes write SetAllLicZoneTypes;
    property AllNGDRs: TNGDRs read FAllNGDRs write SetAllNGDRs;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TLicenseZonePoster = class(TImplementedDataPoster)
  private
    FAllLicZoneTypes: TLicenseZoneTypes;
    FAllOrganizations: TOrganizations;
    FAllNGDRs: TNGDRs;
    procedure SetAllLicZoneTypes(const Value: TLicenseZoneTypes);
    procedure SetAllOrganizations(const Value: TOrganizations);
    procedure SetAllNGDRs(const Value: TNGDRs);
  public
    property AllOrganizations: TOrganizations read FAllOrganizations write SetAllOrganizations;
    property AllLicZoneTypes: TLicenseZoneTypes read FAllLicZoneTypes write SetAllLicZoneTypes;
    property AllNGDRs: TNGDRs read FAllNGDRs write SetAllNGDRs;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses Facade, Variants;


{ TLicenseZonePoster }

constructor TLicenseZonePoster.Create;
begin
  inherited;

  Options := [soKeyInsert];
  DataSourceString := 'VW_LICENSE_ZONES';
  DataDeletionString := 'spd_Delete_License_Zone';
  DataPostString := 'spd_Add_License_Zone_All';



  KeyFieldNames := 'LICENSE_ZONE_ID';
  FieldNames := 'LICENSE_ZONE_ID, VCH_LICENSE_NUM, VCH_LICENSE_ZONE_NAME, ' +
                'LICENSE_ZONE_TYPE_ID, VCH_LICENSE_ZONE_TYPE_NAME, VCH_LICENSE_ZONE_TP_SHORT_NAME, ' +
                'NUM_AREA, NUM_DEPTH_FROM, NUM_DEPTH_TO, DISTRICT_ID, VCH_DISTRICT_NAME, ' +
                'LICENSE_ZONE_STATE_ID, VCH_LICENSE_ZONE_STATE_NAME, ORGANIZATION_ID, ' +
                'VCH_ORG_FULL_NAME, VCH_ORG_SHORT_NAME, LICENSE_TYPE_ID, VCH_LICENSE_TYPE_NAME, ' +
                'VCH_LIC_TYPE_SHORT_NAME, DTM_REGISTRATION_DATE, DTM_REGISTRATION_DATE_FINISH, ' +
                'VCH_LICENSE_NAME, VERSION_ID,   competition_type_id,   vch_competition_type_name,   dtm_competition_date, vch_Seria, ' +
                'issuer_organization_id, vch_issuer_org_full_name, vch_issuer_org_short_name, vch_issuer_subject, ' +
                'site_holder_organization_id, dtm_site_holding_date, vch_site_holder_document, vch_site_holder_org_full_name, vch_site_holder_org_short_name, ' +
                'DEVELOPER_ORGANIZATION_ID, VCH_DEVELOPER_ORG_FULL_NAME, VCH_DEVELOPER_ORG_SHORT_NAME, NGDR_ID, LICENSE_ID, VCH_SERIA';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_LICENSE_ZONE_NAME';
end;

function TLicenseZonePoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TLicenseZone;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TLicenseZone;

      o.ID := ds.FieldByName('LICENSE_ZONE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_LICENSE_ZONE_NAME').AsString);
      o.OwnerOrganization := FAllOrganizations.ItemsByID[ds.FieldByName('ORGANIZATION_ID').AsInteger] as TOrganization;
      o.LicenzeZoneType := FAllLicZoneTypes.ItemsByID[ds.FieldByName('LICENSE_ZONE_TYPE_ID').AsInteger] as TLicenseZoneType;
      o.LicenseZoneNum := trim(ds.FieldByName('VCH_LICENSE_NUM').AsString);
      o.DistrictID := ds.FieldByName('DISTRICT_ID').AsInteger;
      o.LicenseId := ds.FieldByName('LICENSE_ID').AsInteger;
      o.LicenseName := ds.FieldByName('VCH_LICENSE_NAME').AsString;
      o.License.RegistrationStartDate := ds.FieldByName('DTM_REGISTRATION_DATE').AsDateTime;
      o.License.RegistrationFinishDate := ds.FieldByName('DTM_REGISTRATION_DATE_FINISH').AsDateTime;
      //


      if Assigned(FAllNGDRs) then
        o.NGDR := FAllNGDRs.ItemsByID[ds.FieldByName('NGDR_ID').AsInteger] as TNGDR;

      ds.Next;
    end;

    ds.First;
  end;
end;

procedure TLicenseZonePoster.SetAllLicZoneTypes(
  const Value: TLicenseZoneTypes);
begin
  if FAllLicZoneTypes <> Value then
    FAllLicZoneTypes := Value;
end;

procedure TLicenseZonePoster.SetAllNGDRs(const Value: TNGDRs);
begin
  if FAllNGDRs <> Value then
    FAllNGDRs := Value;
end;

procedure TLicenseZonePoster.SetAllOrganizations(
  const Value: TOrganizations);
begin
  if FAllOrganizations <> Value then
    FAllOrganizations := Value;
end;

{ TSimpleLicenseZonePoster }

constructor TSimpleLicenseZonePoster.Create;
begin
  inherited;
  Options := [];
  DataSourceString := 'VW_LICENSE_ZONES';
  DataDeletionString := '';
  DataPostString := 'TBL_LICENSE_ZONE_DICT';

  KeyFieldNames := 'LICENSE_ZONE_ID; VERSION_ID';
  FieldNames := 'LICENSE_ZONE_ID, VCH_LICENSE_NUM, VCH_LICENSE_ZONE_NAME, VERSION_ID, ORGANIZATION_ID, LICENSE_ZONE_TYPE_ID, NGDR_ID, LICENSE_TYPE_ID';

  AccessoryFieldNames := 'LICENSE_ZONE_ID, VERSION_ID, NGDR_ID';
  AutoFillDates := false;

  Sort := 'VCH_LICENSE_NUM, DTM_REGISTRATION_DATE, VCH_LICENSE_ZONE_TP_SHORT_NAME, VCH_LICENSE_ZONE_NAME';
end;

function TSimpleLicenseZonePoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TSimpleLicenseZone;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TSimpleLicenseZone;

      o.ID := ds.FieldByName('LICENSE_ZONE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_LICENSE_ZONE_NAME').AsString);
      o.OwnerOrganization := FAllOrganizations.ItemsByID[ds.FieldByName('ORGANIZATION_ID').AsInteger] as TOrganization;
      o.LicenzeZoneType := FAllLicZoneTypes.ItemsByID[ds.FieldByName('LICENSE_TYPE_ID').AsInteger] as TLicenseZoneType;
      o.LicenseZoneNum := trim(ds.FieldByName('VCH_LICENSE_NUM').AsString);
      if Assigned(FAllNGDRs) then
        o.NGDR := FAllNGDRs.ItemsByID[ds.FieldByName('NGDR_ID').AsInteger] as TNGDR;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TSimpleLicenseZonePoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TSimpleLicenseZone;
begin
  Assert(DataPostString <> '', 'Ќе задан приемник данных ' + ClassName);
  Result := 0;

  o := AObject as TSimpleLicenseZone;

  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);

    if not ds.Active then
      ds.Open;

    if ds.Locate('LICENSE_ZONE_ID; VERSION_ID', varArrayOf([o.ID, TMainFacade.GetInstance.ActiveVersion.ID]), []) then
      ds.Edit
    else exit; // пока не добавл€ем, только редактировать можем
  except
  on E: Exception do
    begin
      raise;
    end;
  end;

  if Assigned(o.NGDR) then
    ds.FieldByName('NGDR_ID').AsInteger := o.NGDR.ID;

  ds.Post;
end;

procedure TSimpleLicenseZonePoster.SetAllLicZoneTypes(
  const Value: TLicenseZoneTypes);
begin
  if FAllLicZoneTypes <> Value then
    FAllLicZoneTypes := Value;
end;

procedure TSimpleLicenseZonePoster.SetAllNGDRs(const Value: TNGDRs);
begin
  if FAllNGDRs <> Value then
    FAllNGDRs := Value;
end;

procedure TSimpleLicenseZonePoster.SetAllOrganizations(
  const Value: TOrganizations);
begin
  if FAllOrganizations <> Value then
    FAllOrganizations := Value;
end;

{ TLicenseZoneTypePoster }

constructor TLicenseZoneTypePoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_LICENSE_TYPE_DICT';

  KeyFieldNames := 'LICENSE_TYPE_ID';
  FieldNames := 'LICENSE_TYPE_ID, VCH_LICENSE_TYPE_NAME, VCH_LIC_TYPE_SHORT_NAME';

  AccessoryFieldNames := 'LICENSE_TYPE_ID, VCH_LICENSE_TYPE_NAME, VCH_LIC_TYPE_SHORT_NAME';
  AutoFillDates := false;

  Sort := '';
end;

function TLicenseZoneTypePoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TLicenseZoneType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TLicenseZoneType;

      o.ID := ds.FieldByName('LICENSE_TYPE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_LICENSE_TYPE_NAME').AsString);
      o.ShortName := trim(ds.FieldByName('VCH_LIC_TYPE_SHORT_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

{ TLicenseConditionValuePoster }

constructor TLicenseConditionValuePoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];

  DataSourceString := 'TBL_LICENSE_CONDITION_VALUE';

  KeyFieldNames := 'LICENSE_ZONE_ID; VERSION_ID; LICENSE_CONDITION_ID; DTM_START_DATE; DTM_FINISH_DATE';
  FieldNames := 'LICENSE_ZONE_ID, VERSION_ID, LICENSE_CONDITION_ID, DTM_START_DATE, DTM_FINISH_DATE, NUM_RELATIVE_DATE, NUM_START_VOLUME, NUM_FINAL_VOLUME';
  AccessoryFieldNames := 'LICENSE_ZONE_ID, VERSION_ID, LICENSE_CONDITION_ID, DTM_START_DATE, DTM_FINISH_DATE, NUM_RELATIVE_DATE, NUM_START_VOLUME, NUM_FINAL_VOLUME';
  AutoFillDates := false;

  Sort := '';
end;

function TLicenseConditionValuePoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
var ds: TCommonServerDataSet;
    lv: TLicenseConditionValue;
begin
  Result := 0;
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  try
    // находим строку соответствующую ключу
    //ds.Refresh;
    lv := AObject as TLicenseConditionValue;
    ds.First;
    if ds.Locate(ds.KeyFieldNames, varArrayOf([lv.OwnerObject.ID,
                                               (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID,
                                               lv.LicenseCondition.ID,
                                               lv.StartDate,
                                               lv.FinishDate]), []) then
      ds.Delete
  except
    Result := -1;
  end;
end;

function TLicenseConditionValuePoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TLicenseConditionValue;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TLicenseConditionValue;

      o.ID := ds.FieldByName('LICENSE_CONDITION_ID').AsInteger;

      o.LicenseCondition := AllLicenseConditions.ItemsByID[ds.FieldByName('LICENSE_CONDITION_ID').AsInteger] as TLicenseCondition;
      o.StartDate := ds.FieldByName('DTM_START_DATE').AsDateTime;
      o.FinishDate := ds.FieldByName('DTM_FINISH_DATE').AsDateTime;
      o.DaysAfterRegistration := ds.FieldByName('NUM_RELATIVE_DATE').AsInteger;
      o.StartVolume := ds.FieldByName('NUM_START_VOLUME').AsFloat;
      o.FinishVolume := ds.FieldByName('NUM_FINAL_VOLUME').AsFloat;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TLicenseConditionValuePoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TCommonServerDataSet;
    o: TLicenseConditionValue;
begin
  Result := 0;
  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    if not ds.Active then
      ds.Open;

    o := AObject as TLicenseConditionValue;
    if ds.Locate(ds.KeyFieldNames, varArrayOf([o.OwnerObject.ID,
                                               (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID,
                                               o.LicenseCondition.ID,
                                               o.StartDate,
                                               o.FinishDate]), []) then
      ds.Edit
    else ds.Append;



    ds.FieldByName('LICENSE_CONDITION_ID').AsInteger := o.LicenseCondition.ID;

    if o.StartDate = 0 then o.StartDate := (o.OwnerObject as TLicenseZone).License.RegistrationStartDate;
    if o.FinishDate = 0 then o.FinishDate := (o.OwnerObject as TLicenseZone).License.RegistrationFinishDate;

    ds.FieldByName('DTM_START_DATE').AsDateTime := o.StartDate;
    ds.FieldByName('DTM_FINISH_DATE').AsDateTime := o.FinishDate;
    ds.FieldByName('NUM_RELATIVE_DATE').AsInteger := o.DaysAfterRegistration;
    ds.FieldByName('NUM_START_VOLUME').AsFloat := o.StartVolume;
    ds.FieldByName('NUM_FINAL_VOLUME').AsFloat := o.FinishVolume;
    ds.FieldByName('LICENSE_ZONE_ID').AsInteger := o.OwnerObject.ID;
    ds.FieldByName('VERSION_ID').AsInteger := (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID;

    ds.Post;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;
end;

{ TLicenseConditionKindPoster }

constructor TLicenseConditionKindPoster.Create;
begin
  inherited;

  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_LICENSE_CONDITION_KIND';

  KeyFieldNames := 'LICENSE_CONDITION_KIND_ID';
  FieldNames := 'LICENSE_CONDITION_KIND_ID, VCH_LICENSE_CONDITION_KIND_NAME';

  AccessoryFieldNames := 'LICENSE_CONDITION_KIND_ID, VCH_LICENSE_CONDITION_KIND_NAME';
  AutoFillDates := false;

  Sort := '';
end;

function TLicenseConditionKindPoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TLicenseConditionKindPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TLicenseConditionKind;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TLicenseConditionKind;

      o.ID := ds.FieldByName('LICENSE_CONDITION_KIND_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_LICENSE_CONDITION_KIND_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TLicenseConditionKindPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TLicenseConditionKind;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TLicenseConditionKind;

  ds.FieldByName('LICENSE_CONDITION_KIND_ID').AsInteger := o.ID;
  ds.FieldByName('VCH_LICENSE_CONDITION_KIND_NAME').AsString := o.Name;
  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('LICENSE_CONDITION_KIND_ID').Value;
end;

{ TLicenseConditionTypePoster }

constructor TLicenseConditionTypePoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_LICENSE_CONDITION_TYPE';

  KeyFieldNames := 'LICENSE_CONDITION_TYPE_ID';
  FieldNames := 'LICENSE_CONDITION_TYPE_ID, VCH_LICENS_CONDITION_TYPE_NAME, NUM_HAS_RELATIVE_DATE, NUM_BOUNDING_DATES';

  AccessoryFieldNames := 'LICENSE_CONDITION_TYPE_ID, VCH_LICENS_CONDITION_TYPE_NAME, NUM_HAS_RELATIVE_DATE, NUM_BOUNDING_DATES';
  AutoFillDates := false;

  Sort := '';
end;

function TLicenseConditionTypePoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TLicenseConditionTypePoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TLicenseConditionType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TLicenseConditionType;

      o.ID := ds.FieldByName('LICENSE_CONDITION_TYPE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_LICENS_CONDITION_TYPE_NAME').AsString);
      o.HasRelativeDate := ds.FieldByName('NUM_HAS_RELATIVE_DATE').AsInteger > 0;
      o.BoundingDates := ds.FieldByName('NUM_BOUNDING_DATES').AsInteger > 0;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TLicenseConditionTypePoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TLicenseConditionType;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TLicenseConditionType;

  ds.FieldByName('LICENSE_CONDITION_TYPE_ID').AsInteger := o.ID;
  ds.FieldByName('VCH_LICENS_CONDITION_TYPE_NAME').AsString := o.Name;
  ds.FieldByName('NUM_HAS_RELATIVE_DATE').AsInteger := ord(o.HasRelativeDate);
  ds.FieldByName('NUM_BOUNDING_DATES').AsInteger := ord(o.BoundingDates);  
  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('LICENSE_CONDITION_TYPE_ID').Value;
end;

{ TLicenseConditionPoster }

constructor TLicenseConditionPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];

  DataSourceString := 'TBL_LICENSE_CONDITION';

  KeyFieldNames := 'LICENSE_CONDITION_ID';
  FieldNames := 'LICENSE_CONDITION_ID, VOLUME_MEASURE_UNIT_ID, DATE_MEASURE_UNIT_ID, LICENSE_CONDITION_KIND_ID, ' +
                'LICENSE_CONDITION_TYPE_ID, VCH_LICENSE_CONDITION_NAME, NUM_RELATIVE_DATE_CONDITION, NUM_USE_BY_DEFAULT, NUM_IS_NON_PERIODIC, NUM_HAS_VOLUME, NUM_HAS_RELATIVE_DATE';

  AccessoryFieldNames := 'LICENSE_CONDITION_ID, VOLUME_MEASURE_UNIT_ID, DATE_MEASURE_UNIT_ID, LICENSE_CONDITION_KIND_ID, LICENSE_CONDITION_TYPE_ID, VCH_LICENSE_CONDITION_NAME, NUM_RELATIVE_DATE_CONDITION, NUM_USE_BY_DEFAULT, NUM_HAS_VOLUME, NUM_HAS_RELATIVE_DATE';
  AutoFillDates := false;

  Sort := '';
end;

function TLicenseConditionPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TLicenseConditionPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TLicenseCondition;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TLicenseCondition;

      o.ID := ds.FieldByName('LICENSE_CONDITION_ID').AsInteger;
      o.VolumeMeasureUnit := TMainFacade.GetInstance.AllMeasureUnits.ItemsByID[ds.FieldByName('VOLUME_MEASURE_UNIT_ID').AsInteger] as TMeasureUnit;
      o.DateMeasureUnit := TMainFacade.GetInstance.AllMeasureUnits.ItemsByID[ds.FieldByName('DATE_MEASURE_UNIT_ID').AsInteger] as TMeasureUnit;      
      o.LicenseConditionKind := AllLicenseConditionKinds.ItemsByID[ds.FieldByName('LICENSE_CONDITION_KIND_ID').AsInteger] as TLicenseConditionKind;
      o.LicenseConditionType := AllLicenseConditionTypes.ItemsByID[ds.FieldByName('LICENSE_CONDITION_TYPE_ID').AsInteger] as TLicenseConditionType;
      o.DaysAfterRegistration := ds.FieldByName('num_Relative_Date_Condition').AsInteger;
      o.IsDefault := (ds.FieldByName('num_Use_By_Default').AsInteger > 0);
      o.Name := trim(ds.FieldByName('vch_License_Condition_Name').AsString);
      o.NonPeriodic := (ds.FieldByName('num_Is_Non_Periodic').AsInteger > 0);
      o.HasVolume := (ds.FieldByName('num_Has_Volume').AsInteger > 0);
      o.HasRelativeDate := (ds.FieldByName('num_Has_Relative_Date').AsInteger > 0);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TLicenseConditionPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TLicenseCondition;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TLicenseCondition;

  ds.FieldByName('LICENSE_CONDITION_ID').AsInteger := o.ID;
  ds.FieldByName('VOLUME_MEASURE_UNIT_ID').AsInteger := o.VolumeMeasureUnit.ID;
  ds.FieldByName('DATE_MEASURE_UNIT_ID').AsInteger := o.DateMeasureUnit.ID;

  ds.FieldByName('LICENSE_CONDITION_KIND_ID').AsInteger := o.LicenseConditionKind.ID;
  ds.FieldByName('LICENSE_CONDITION_TYPE_ID').AsInteger := o.LicenseConditionType.ID;
  ds.FieldByName('num_Relative_Date_Condition').AsInteger := o.DaysAfterRegistration;
  ds.FieldByName('num_Use_By_Default').AsInteger := ord(o.IsDefault);
  ds.FieldByName('vch_License_Condition_Name').AsString := o.Name;
  ds.FieldByName('num_Is_Non_Periodic').AsInteger := ord(o.NonPeriodic);
  ds.FieldByName('num_Has_Volume').AsInteger := ord(o.HasVolume);
  ds.FieldByName('num_Has_Relative_Date').AsInteger := ord(o.HasRelativeDate);


  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('LICENSE_CONDITION_ID').Value;
end;

end.
