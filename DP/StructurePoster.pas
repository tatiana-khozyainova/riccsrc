unit StructurePoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, Organization, SysUtils;

type
  // для структур
  TStructureDataPoster = class(TImplementedDataPoster)
  private
    FAllOrganizations: TOrganizations;
    FAllFundTypes: TIDObjects;
    FAllFieldTypes: TIDObjects;
    procedure SetAllOrganizations(const Value: TOrganizations);
  public
    property AllOrganizations: TOrganizations read FAllOrganizations write SetAllOrganizations;
    property AllFundTypes: TIDObjects read FAllFundTypes write FAllFundTypes;
    property AllFieldTypes: TIDObjects read FAllFieldTypes write FAllFieldTypes;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TStructureFundTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;


  // для месторождений
  TFieldDataPoster = class(TStructureDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TBedDataPoster = class(TImplementedDataPoster)
  private
    FAllFieldTypes: TIDObjects;
  public
    property AllFieldTypes: TIDObjects read FAllFieldTypes write FAllFieldTypes;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;



  TStructureBindingDataPoster = class(TImplementedDataPoster)
  protected
    function GetObjectTypeID: integer; virtual;
    function GetSourceObjects: TIDObjects; virtual;
  public
    property ObjectTypeID: integer read GetObjectTypeID;
    property SourceObjects: TIDObjects read GetSourceObjects;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TStructureOwnedDistrictsDataPoster = class(TStructureBindingDataPoster)
  protected
    function GetObjectTypeID: integer; override;
    function GetSourceObjects: TIDObjects; override;
  public
    constructor Create; override;
  end;

  TStructureOwnedPetrolRegionsDataPoster = class(TStructureBindingDataPoster)
  protected
    function GetObjectTypeID: integer; override;
    function GetSourceObjects: TIDObjects; override;
  public
    constructor Create; override;
  end;

  TStructureOwnedTectonicStructsDataPoster = class(TStructureBindingDataPoster)
  protected
    function GetObjectTypeID: integer; override;
    function GetSourceObjects: TIDObjects; override;
  public
    constructor Create; override;
  end;

  TStructureOwnedLicenseZonesDataPoster = class(TStructureBindingDataPoster)
  protected
    function GetObjectTypeID: integer; override;
    function GetSourceObjects: TIDObjects; override;
  public
    constructor Create; override;
  end;

  TFieldTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses Structure, Facade, BaseConsts, District, Variants;

{ TStructureDataPoster }

constructor TStructureDataPoster.Create;
begin
  inherited;
  Options := [];
  DataSourceString :='TBL_STRUCTURE'; //'VW_STRUCTURE';
  DataDeletionString := 'TBL_STRUCTURE';
  DataPostString := 'TBL_STRUCTURE';

  KeyFieldNames := 'STRUCTURE_ID,VERSION_ID';
  FieldNames := 'STRUCTURE_ID, ORGANIZATION_ID, VCH_STRUCTURE_NAME, VERSION_ID, STRUCTURE_FUND_TYPE_ID'; //FIELD_TYPE_ID';

  AccessoryFieldNames := 'STRUCTURE_ID, ORGANIZATION_ID, VCH_STRUCTURE_NAME, VERSION_ID, STRUCTURE_FUND_TYPE_ID';//, FIELD_TYPE_ID';
  AutoFillDates := false;

  Sort := 'STRUCTURE_ID,VERSION_ID';
end;

function TStructureDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TStructureDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TStructure;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TStructure;

      o.ID := ds.FieldByName('STRUCTURE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_STRUCTURE_NAME').AsString);
      o.Version := ds.FieldByName('Version_ID').AsInteger;
      if Assigned(AllOrganizations) then
        o.Organization := AllOrganizations.ItemsByID[ds.FieldByName('ORGANIZATION_ID').AsInteger] as TOrganization;

      if Assigned(AllFundTypes) then
        o.StructureFundType := AllFundTypes.ItemsByID[ds.FieldByName('STRUCTURE_FUND_TYPE_ID').AsInteger] as TStructureFundType;

        


      ds.Next;
    end;

    ds.First;
  end;
end;

function TStructureDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

procedure TStructureDataPoster.SetAllOrganizations(
  const Value: TOrganizations);
begin
  if FAllOrganizations <> Value then
    FAllOrganizations := Value;
end;

{ TFieldDataPoster }

constructor TFieldDataPoster.Create;
begin
  inherited;
end;

function TFieldDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TFieldDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TField;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TField;

      o.ID := ds.FieldByName('STRUCTURE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_STRUCTURE_NAME').AsString);
      o.Organization := AllOrganizations.ItemsByID[ds.FieldByName('ORGANIZATION_ID').AsInteger] as TOrganization;

      if Assigned(AllFundTypes) then
        o.StructureFundType := AllFundTypes.ItemsByID[ds.FieldByName('STRUCTURE_FUND_TYPE_ID').AsInteger] as TStructureFundType;


      if Assigned(AllFieldTypes) then
        o.FieldType := AllFieldTypes.ItemsByID[ds.FieldByName('FIELD_TYPE_ID').AsInteger] as TFieldType;


      ds.Next;
    end;

    ds.First;
  end;
end;

function TFieldDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

{ TStructureOwnedDistrictsDataPoster }

constructor TStructureBindingDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_STRUCTURE_OBJECT_BINDING';

  FieldNames :=  'OBJECT_TYPE_ID, VERSION_ID, STRUCTURE_ID, OBJECT_ID';
  AccessoryFieldNames :=  'OBJECT_TYPE_ID, VERSION_ID, STRUCTURE_ID, OBJECT_ID';  
  KeyFieldNames := 'OBJECT_TYPE_ID; VERSION_ID; STRUCTURE_ID; OBJECT_ID';

  AutoFillDates := false;

  Sort := '';
end;

function TStructureBindingDataPoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
var ds: TCommonServerDataSet;
begin
  Result := 0;
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  try
    ds.First;

    if ds.Locate(ds.KeyFieldNames, varArrayOf([ObjectTypeID, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID, ACollection.Owner.ID, AObject.ID]), []) then
      ds.Delete
  except
    Result := -1;
  end;
end;

function TStructureBindingDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      AObjects.Add(SourceObjects.ItemsByID[ds.FieldByName('OBJECT_ID').AsInteger], false, false);
      ds.Next;
    end;

    ds.First;
  end;
end;

function TStructureBindingDataPoster.GetObjectTypeID: integer;
begin
  Result := 0;
end;

function TStructureBindingDataPoster.GetSourceObjects: TIDObjects;
begin
  Result := nil;
end;

function TStructureBindingDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
begin
  Result := 0;
  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    if not ds.Active then
      ds.Open;

    if ds.Locate(KeyFieldNames, VarArrayOf([ObjectTypeID, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID, ACollection.Owner.ID, AObject.ID]), []) then
      ds.Edit
    else ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;


  ds.FieldByName('OBJECT_TYPE_ID').AsInteger := ObjectTypeID;
  ds.FieldByName('VERSION_ID').AsInteger := 0;
  ds.FieldByName('STRUCTURE_ID').AsInteger := ACollection.Owner.ID;
  ds.FieldByName('OBJECT_ID').AsInteger := AObject.ID;

  ds.Post;
end;

{ TStructureOwnedDistrictsDataPoster }

constructor TStructureOwnedDistrictsDataPoster.Create;
begin
  inherited;
end;

function TStructureOwnedDistrictsDataPoster.GetObjectTypeID: integer;
begin
  Result := DISTRICT_OBJECT_TYPE_ID;
end;

function TStructureOwnedDistrictsDataPoster.GetSourceObjects: TIDObjects;
begin
  Result := TMainFacade.GetInstance.AllDistricts;
end;

{ TStructureOwnedPetrolRegionsDataPoster }

constructor TStructureOwnedPetrolRegionsDataPoster.Create;
begin
  inherited;
end;

function TStructureOwnedPetrolRegionsDataPoster.GetObjectTypeID: integer;
begin
  Result := PETROL_REGION_OBJECT_TYPE_ID;
end;

function TStructureOwnedPetrolRegionsDataPoster.GetSourceObjects: TIDObjects;
begin
  Result := TMainFacade.GetInstance.AllPetrolRegions;
end;

{ TStructureOwnedTectonicStructsDataPoster }

constructor TStructureOwnedTectonicStructsDataPoster.Create;
begin
  inherited;
end;

function TStructureOwnedTectonicStructsDataPoster.GetObjectTypeID: integer;
begin
  Result := TECTONIC_STRUCT_OBJECT_TYPE_ID;
end;

function TStructureOwnedTectonicStructsDataPoster.GetSourceObjects: TIDObjects;
begin
  Result := TMainFacade.GetInstance.AllTectonicStructures;
end;

{ TStructureOwnedLicenseZonesDataPoster }

constructor TStructureOwnedLicenseZonesDataPoster.Create;
begin
  inherited;
end;

function TStructureOwnedLicenseZonesDataPoster.GetObjectTypeID: integer;
begin
  Result := LICENSE_ZONE_OBJECT_TYPE_ID;
end;

function TStructureOwnedLicenseZonesDataPoster.GetSourceObjects: TIDObjects;
begin
  Result := TMainFacade.GetInstance.AllLicenseZones;
end;

{ TStructureFundTypeDataPoster }

constructor TStructureFundTypeDataPoster.Create;
begin
  inherited;
  Options := [];
  DataSourceString := 'TBL_STRUCTURE_FUND_TYPE_DICT';
  DataDeletionString := '';
  DataPostString := '';

  KeyFieldNames := 'STRUCTURE_FUND_TYPE_ID';
  FieldNames := 'STRUCTURE_FUND_TYPE_ID, VCH_STRUCTURE_FUND_TYPE_NAME';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := '';
end;

function TStructureFundTypeDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TStructureFundTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TStructureFundType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TStructureFundType;

      o.ID := ds.FieldByName('STRUCTURE_FUND_TYPE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_STRUCTURE_FUND_TYPE_NAME').AsString);
      ds.Next;
    end;

    ds.First;
  end;
end;

function TStructureFundTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

{ TFieldTypeDataPoster }

constructor TFieldTypeDataPoster.Create;
begin
  inherited;

  Options := [];
  DataSourceString := 'TBL_FIELD_TYPE_DICT';
  DataDeletionString := '';
  DataPostString := '';

  KeyFieldNames := 'FIELD_TYPE_ID';
  FieldNames := 'FIELD_TYPE_ID, VCH_FIELD_TYPE_NAME, VCH_FIELD_TYPE_SHORT_NAME';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := '';
end;

function TFieldTypeDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TFieldTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TFieldType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TFieldType;

      o.ID := ds.FieldByName('FIELD_TYPE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_FIELD_TYPE_NAME').AsString);
      ds.Next;
    end;

    ds.First;
  end;
end;

function TFieldTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

{ TBedDataPoster }

constructor TBedDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'VW_BED';
  DataDeletionString := 'TBL_BED';
  DataPostString := 'TBL_BED';


  KeyFieldNames := 'BED_ID';
  FieldNames := 'bed_id, structure_id, vch_bed_index, field_type_id';
  AccessoryFieldNames := 'bed_id, structure_id, vch_bed_index, field_type_id';
  AutoFillDates := false;

  Sort := 'VCH_BED_INDEX';

end;

function TBedDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TBedDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TBed;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TBed;
      o.ID := ds.FieldByName('bed_id').AsInteger;
      o.Name := trim(ds.FieldByName('vch_bed_index').AsString);
      if Assigned(AllFieldTypes) then
        o.FieldType := AllFieldTypes.ItemsByID[ds.FieldByName('field_type_id').AsInteger] as TFieldType;
      ds.Next;
    end;
  end;
end;

function TBedDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

end.
