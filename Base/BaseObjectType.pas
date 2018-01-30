unit BaseObjectType;

interface

uses BaseObjects, Registrator, Contnrs, BaseConsts;

type

  TObjectType = class (TRegisteredIDObject)
  public

    constructor Create (ACollection: TIDObjects); override;
  end;

  TObjectTypes = class (TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TObjectType;
  public
    property Items[Index: integer]: TObjectType read GetItems;
    constructor Create; override;
  end;

  TObjectTypeMapperItem = class(TObject)
  private
    FObjectTypeID: integer;
    FFilterColumnName: string;
  public
    property FilterColumnName: string read FFilterColumnName;
    property ObjectTypeID: integer read FObjectTypeID;
  end;


  TObjectTypeMapper = class(TObjectList)
  private
    function GetItems(Index: integer): TObjectTypeMapperItem;
  public
    property Items[Index: integer]: TObjectTypeMapperItem read GetItems;
    function AddMapperItem(AId: integer; AColName: string): TObjectTypeMapperItem;
    function GetItemByID(AID: integer): TObjectTypeMapperItem;

    constructor Create; virtual;
  end;


  TDefaultObjectTypeMapper = class(TObjectTypeMapper)
  public
    constructor Create; override;

  end;


implementation

uses Facade, BaseFacades, ObjectTypePoster;

{ TObjectTypes }

constructor TObjectTypes.Create;
begin
  inherited;

  FObjectClass := TObjectType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TObjectTypeDataPoster];
end;

function TObjectTypes.GetItems(Index: integer): TObjectType;
begin
  Result := inherited Items[Index] as TObjectType;
end;

{ TObjectType }

constructor TObjectType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип объекта';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TObjectTypeDataPoster];
end;

{ TObjectTypeMapper }

function TObjectTypeMapper.AddMapperItem(AId: integer;
  AColName: string): TObjectTypeMapperItem;
begin
  Result := GetItemByID(AID);
  if not Assigned(Result) then
  begin
    Result := TObjectTypeMapperItem.Create;
    Result.FObjectTypeID := AId;
    Result.FFilterColumnName := AColName;

    inherited Add(Result);
  end;
end;

constructor TObjectTypeMapper.Create;
begin
  inherited Create(true);
end;

function TObjectTypeMapper.GetItemByID(
  AID: integer): TObjectTypeMapperItem;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].ObjectTypeID = AID then
  begin
    Result := Items[i];
    break;
  end;
end;

function TObjectTypeMapper.GetItems(Index: integer): TObjectTypeMapperItem;
begin
  Result := TObjectTypeMapperItem(inherited Items[Index]);
end;

{ TDefaultObjectTypeMapper }

constructor TDefaultObjectTypeMapper.Create;
begin
  inherited;
  AddMapperItem(PETROL_REGION_OBJECT_TYPE_ID, 'Petrol_Region_ID');
  AddMapperItem(ORGANIZATION_OBJECT_TYPE_ID, 'Organization_ID');
  AddMapperItem(DISTRICT_OBJECT_TYPE_ID, 'District_ID');
end;

end.
