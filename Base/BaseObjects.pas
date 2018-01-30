unit BaseObjects;

interface

uses Classes, Contnrs, SysUtils, PersistentObjects, Forms, ComCtrls,
     Menus, StdCtrls, Variants;

type
  TIDObject = class;
  TIDObjects = class;
  TIDObjectClass = class of TIDObject;
  TIDObjectsClass = class of TIDObjects;
  TDataPoster = class;
  TDataPosterClass = class of TDataPoster;


  EObjectAddingException = class(Exception)
  public
    constructor Create(AObject: TIDObject; ALastException: Exception);
  end;

  EObjectDeletingException = class(Exception)
  public
    constructor Create(AObject: TIDObject);
  end;

  TListOption = (loBrief, loMedium, loFull, loKeyOnly, loBindAttributes, loMapAttributes, loHierarchicalName);

  IVisitor = interface
    function  GetActiveObject: TIDObject;
    procedure SetActiveObject(const Value: TIDObject);

    property  ActiveObject: TIDObject read GetActiveObject write SetActiveObject;

    procedure VisitWell(AWell: TIDObject);
    procedure VisitGenSection(AGenSection: TIDObject);
    procedure VisitCollectionWell(AWell: TIDObject);
    procedure VisitTestInterval(ATestInterval: TIDObject);
    procedure VisitLicenseZone(ALicenseZone: TIDObject);
    procedure VisitSlotting(ASlotting: TIDObject);
    procedure VisitGenSectionSlotting(ASlotting: TIDObject);
    procedure VisitCollectionSample(ACollectionSample: TIDObject);
    procedure VisitDenudation(ADenudation: TIDObject);
    procedure VisitWellCandidate(AWellCandidate: TIDObject);
  end;


  TDataPosterState = class(TPersistent)
  private
    FFilter: string;
    FSort: string;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property Filter: string read FFilter write FFilter;
    property Sort: string read FSort write FSort;
  end;  


  TDataPoster = class
  private
    FAutoFillDates: boolean;
    FDataPostString: string;
    FDataDeletionString: string;
    FDataSourceString: string;
    FKeyFieldNames: string;
    FFieldNames: string;
    FOptions: TCSDataSetOptions;
    FAccessoryFieldNames: string;
    FSort: string;
    FPageSize: integer;
    FRecordsLoaded: integer;
    FGeneralRecordCount: integer;
    FCurrentPage: integer;
    FPageCount: integer;
    FDataPosterState: TDataPosterState;
    procedure SetDataSourceString(const Value: string);
    function  GetDataPosterState: TDataPosterState;
  protected
    FFilter: string;
    // локальная сортировка
    procedure LocalSort(AObjects: TIDObjects); virtual;
    procedure SetFilter(const Value: string); virtual;
  public
    procedure RestoreState(AState: TDataPosterState); virtual;
    procedure SaveState(AState: TDataPosterState); virtual; 

    property  PosterState: TDataPosterState read GetDataPosterState write FDataPosterState;


    property DataSourceString: string read FDataSourceString write SetDataSourceString;
    property DataDeletionString: string read FDataDeletionString write FDataDeletionString;
    property DataPostString: string read FDataPostString write FDataPostString;

      // размер страницы
    property PageSize: integer read FPageSize write FPageSize;
      // общее количество строк, которое есть в таблице (по данному запросу)
    property GeneralRecordCount: integer read FGeneralRecordCount write FGeneralRecordCount;
      // загруженное количество строк. просто RecordCount воспользоваться не получится,
      // поскольку при смене фильтра - это число должно сбрасываться,
      // а RecordCount - оставаться прежним
    property RecordsLoaded: integer read FRecordsLoaded write FRecordsLoaded;
      // текущая страница - высчитывается, исходя из строки на которой находимся и количества загруженных строк
    property CurrentPage: integer read FCurrentPage write FCurrentPage;
      // общее количество страниц - высчитывается, исходя из общего количества строк и размера страницы в строках
    property PageCount: integer read FPageCount write FPageCount;

    property Options: TCSDataSetOptions read FOptions write FOptions;
    property FieldNames: string read FFieldNames write FFieldNames;
    property KeyFieldNames: string read FKeyFieldNames write FKeyFieldNames;
    property AccessoryFieldNames: string read FAccessoryFieldNames write FAccessoryFieldNames;
    property AutoFillDates: boolean read FAutoFillDates write FAutoFillDates;


    property Filter: string read FFilter write SetFilter;
    property Sort: string read FSort write FSort;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; virtual;

    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; overload; virtual;
    function PostToDB(ACollection: TIDObjects; AOwner: TIDObject): integer; overload; virtual;

    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; overload; virtual;
    function DeleteFromDB(ACollection: TIDObjects): integer; overload; virtual;


    constructor Create; virtual; 
  end;

  TDataPosters = class(TObjectList)
  private
    function GetDataPosterByClassType(
      ADataPosterClass: TDataPosterClass): TDataPoster;
    function GetItems(Index: integer): TDataPoster;
  public
    property Items[Index: integer]: TDataPoster read GetItems;
    property DataPosterByClassType[ADataPosterClass: TDataPosterClass]: TDataPoster read GetDataPosterByClassType; default;
    function Add(ADataPosterClass: TDataPosterClass): TDataPoster;
    constructor Create;
  end;




  TIdObject = class(TInterfacedPersistent)
  private
    FID: integer;
    FCollection: TIDObjects;
    FCountFields: integer;
    FEditingObject: TIDObject;
    FObjectType: TIDObject;
    FMetaphoneName: string;
    FMetaphoneShortName: string;
    FTempLink: TIDObject;
    procedure SetClassIDString(const Value: string);
    function  GetEditingObject: TIDObject;
    function  GetOwner: TIdObject; reintroduce;
    function  GetMetaphoneName: string;
    function  GetMetaphoneShortName: string;
  protected
    FName: string;
    FShortName: string;
    FComment: string;
    FDataPoster: TDataPoster;
    FClassIDString: string;
    procedure AssignTo(Dest: TPersistent); override;
    function  GetName: string; virtual;
    procedure SetName(const Value: string); virtual;
    function  GetShortName: string; virtual;
    procedure SetShortName(const Value: string); virtual;
    function  GetPropertyValue(APropertyID: integer): OleVariant; virtual;
    function  GetComment: string;
    procedure SetComment(const Value: string);
    procedure InitSubCollections; virtual;
  public
    property  Owner: TIDObject read GetOwner;
    property  Collection: TIDObjects read FCollection;
    function  Prev: TIDObject;
    function  Next: TIDObject; 
    procedure ReassignCollection(ACollection: TIDObjects);

    procedure   Accept(Visitor: IVisitor); virtual;
      // количество полей информации
    property  CountFields: integer read FCountFields write FCountFields;

    property  ID: integer read FID write FID;
    property  Name: string read GetName write SetName;
    property  ShortName: string read GetShortName write SetShortName;

    property  MetaphoneName: string read GetMetaphoneName;
    property  MetaphoneShortName: string read GetMetaphoneShortName;

    property  Comment: string read GetComment write SetComment;


    property  ClassIDString: string read FClassIDString write SetClassIDString;
    property  Poster: TDataPoster read FDataPoster;
    function  List(AListOption: TListOption = loBrief): string; virtual;

    // тип объекта
    property  ObjectType: TIDObject read FObjectType write FObjectType;
    property  TempLink: TIDObject read FTempLink write FTempLink;

    property  EditingObject: TIDObject read GetEditingObject;

    property  PropertyValue[APropertyID: integer]: OleVariant read GetPropertyValue;

    function    Update(ACollection: TIDObjects = nil): integer; virtual;
    procedure   StrToObjects(Value: string; AAllObjects, AObjects: TIDObjects);
    procedure   IntToObjects(Value: string; AAllObjects, AObjects: TIDObjects);
    function    StrToCorrect(AStr: string; NeedsLowerCase: Boolean = True; NeedsDelSpace: Boolean = True): string;

    procedure   UpdateFilters; virtual;
    constructor Create(ACollection: TIDObjects); virtual;
    destructor  Destroy; override;
  end;


  TIdObjects = class(TObjectList)
  private
    FNeedsReloading: boolean;
    FOwner: TIDObject;
    FDeletedObjects: TIDObjects;
    FDataPosterState: TDataPosterState;
    function GetItems(Index: integer): TIDObject;
    function GetItemsByID(AID: integer): TIdObject;
    function GetDeletedObjects: TIDObjects;
    function GetDataPosterState: TDataPosterState;
    function GetItemsByIDAndClassType(AClass: TIDObjectClass;
      AID: integer): TIdObject;
  protected
    FDataPoster: TDataPoster;
    FObjectClass: TIDObjectClass;
  public
    procedure Assign(Source: TIDObjects; NeedClearing: boolean = true); overload; virtual;

    property  Poster: TDataPoster read FDataPoster write FDataPoster;
    property  PosterState: TDataPosterState read GetDataPosterState write FDataPosterState;

    property  ObjectClass: TIDObjectClass read FObjectClass;

    property  Owner: TIDObject read FOwner write FOwner;

    function  Add: TIDObject; overload; virtual;
    function  Add(AObject: TObject; Copy: boolean = true; NeedsCheck: boolean = true): TIDObject; overload; virtual;
    function  Add(AID: integer): TIDObject; overload; virtual;
    function  Add(AID: integer; AName: string): TIDObject; overload; virtual;
    function  Add(AID: integer; AName, AShortName: string): TIDObject; overload; virtual;
    procedure AddObjects(ASourceObjects: TIDObjects; Copy: boolean = true; NeedsCheck: boolean = true);

    procedure Delete(Index: integer); virtual;
    function  Remove(AObject: TObject): Integer; virtual;


    procedure MarkDeleted(AObject: TObject); overload; virtual;
    procedure MarkDeleted(Index: integer); overload; virtual;
    procedure MarkAllDeleted; virtual;
    procedure DeleteMarkedObjects;


    procedure Clear; override;

    procedure Reload; overload; virtual;
    procedure Reload(AFilter: string; UseEmptyFilter: boolean = false); overload; virtual;
    procedure Refresh; virtual;

    property  Items[Index: integer]: TIdObject read GetItems;
    property  ItemsByID[AID: integer]: TIdObject read GetItemsByID;
    property  ItemsByIDAndClassType[AClass: TIDObjectClass; AID: integer]: TIdObject read GetItemsByIDAndClassType;

    function  GetItemByName (AName: string): TIDObject;
    function  GetItemByShortName (AName: string): TIDObject;
    function  GetItemByMetaphoneName(AName: string): TIDObject;
    function  GetItemByMetaphoneShortName(AName: string): TIDObject;

    procedure GetItemsByName(const AName: string; AOutItems: TIDObjects);
    procedure GetItemsByPartialName(const ANamePart: string; AOutItems: TIDObjects);


    function  Update(ACollection: TIDObjects): integer; virtual;

    property  NeedsReloading: boolean read FNeedsReloading write FNeedsReloading;

    procedure   SetIcons (AObject: TObject); virtual;

    function    ObjectsToStr: string; overload; virtual;
    function    ObjectsToStr (AAuthors: string): string; overload; virtual;

    function    IsItemsEqual (AObjects: TIDObjects): boolean;
    function    FullEnteringItems (AObjects: TIDObjects): boolean;

    property    DeletedObjects: TIDObjects read GetDeletedObjects;

    function    List(AListOption: TListOption = loBrief): string; virtual;
    function    IDList(ASeparator: char = ','): string;

    procedure   SortByID(Straight: Boolean = True);
    procedure   SortByName(Straight: Boolean = True);   

    constructor Create; virtual;
    destructor  Destroy; override;
  end;

  TIDObjectTable = class (TObject)
  private
    FObjects: array of array of TIDObject;
    FColCount: integer;
    FRowCount: integer;
    FObjectClass: TIDObjectClass;
    FInternalObjects: TIDObjects;
    function  GetItems(ACol, ARow: integer): TIDObject;
    procedure SetColCount(const Value: integer);
    procedure SetRowCount(const Value: integer);
    procedure SetItems(ACol, ARow: integer; const Value: TIDObject);
    function  GetItemsByID(AID: integer): TIDObject;
    procedure SetObjectClass(const Value: TIDObjectClass);
  public
    property Items[ACol, ARow: integer]: TIDObject read GetItems write SetItems;
    property ItemsByID[AID: integer]: TIDObject read GetItemsByID;
    procedure FindItem(AObject: TIDObject; var ACol, ARow: integer);

    property ColCount: integer read FColCount write SetColCount;
    property RowCount: integer read FRowCount write SetRowCount;

    function  Add(ACol, ARow: integer): TIDObject; overload; virtual;
    function  Add(ACol, ARow: integer; AObject: TObject; Copy: boolean = true; NeedsCheck: boolean = true): TIDObject; overload; virtual;
    function  Add(ACol, ARow: integer; AID: integer): TIDObject; overload; virtual;
    function  Add(ACol, ARow: integer; AID: integer; AName: string): TIDObject; overload; virtual;
    function  Add(ACol, ARow: integer; AID: integer; AName, AShortName: string): TIDObject; overload; virtual;

    procedure  Delete(ACol, ARow: integer);
    function   Remove(AObject: TIDObject): integer;

    property    ObjectClass: TIDObjectClass read FObjectClass write SetObjectClass;
    constructor Create; virtual;
    destructor  Destroy; override;
  end;


  TAllIdObjects = class(TIdObjects)
  public
    constructor Create; override;
  end;

  function  NameCompare(Item1, Item2: Pointer): Integer;
  function  ReverseNameCompare(Item1, Item2: Pointer): Integer;
  function  UINCompare(Item1, Item2: Pointer): Integer;
  function  ReverseUINCompare(Item1, Item2: Pointer): Integer;


implementation

uses BasePosters, BaseFacades, Math, StringUtils, DB, Facade;

{ TIdObject }

function  UINCompare(Item1, Item2: Pointer): Integer;
var o1, o2: TIDObject;
begin
  o1 := TIDObject(Item1);
  o2 := TIDObject(Item2);

  if o1.ID > o2.ID then Result := 1
  else if o1.ID < o2.ID then Result := -1
  else Result := 0;
end;

function  ReverseUINCompare(Item1, Item2: Pointer): Integer;
begin
  Result := -UINCompare(Item1, Item2);
end;


function  NameCompare(Item1, Item2: Pointer): Integer;
var o1, o2: TIDObject;
begin
  o1 := TIDObject(Item1);
  o2 := TIDObject(Item2);

  if o1.Name > o2.Name then Result := 1
  else if o1.Name < o2.Name then Result := -1
  else Result := 0;
end;

function  ReverseNameCompare(Item1, Item2: Pointer): Integer;
begin
  Result := - NameCompare(Item1, Item2);
end;

procedure TIdObject.Accept(Visitor: IVisitor);
begin

end;

procedure TIdObject.AssignTo(Dest: TPersistent);
var o: TIDObject;
begin
  o := Dest as TIdObject;

  o.ID := ID;
  o.Name := Name;
  o.ShortName := ShortName;
  o.Comment := Comment;
  o.ObjectType := ObjectType;
end;


constructor TIdObject.Create(ACollection: TIDOBjects);
begin
  inherited Create;
  ClassIDString := 'Объект с идентификатором';
  //FDataPoster := TMainFacade.GetInstance.DataPosters[TIDObjectDataPoster];
  FCollection := ACollection;
  FCountFields := 2;
end;

destructor TIdObject.Destroy;
begin
  if Assigned(FEditingObject) then FEditingObject.Free;
  inherited;
end;

function TIdObject.GetComment: string;
begin
  Result := FComment;
end;

function TIdObject.GetEditingObject: TIDObject;
begin
  // создаем объект, не причисляя его к коллекции
  if not Assigned(FEditingObject) then
  begin
    FEditingObject := Collection.ObjectClass.Create(Collection);
    FEditingObject.Assign(Self);
  end;
  Result := FEditingObject;
end;

function TIdObject.GetMetaphoneName: string;
var strlst: TStringList;
    i, iIndex: integer;
begin
  if trim(FMetaphoneName) = '' then
  begin
    strlst := TStringList.Create;
    Split(Name, [' '], strlst);

    iIndex := 0;
    for i := 0 to strlst.Count - 1 do
    if Length(strlst[i]) > Length(strlst[iIndex]) then
      iIndex := i;
      
    // преобразуем наиболее длинную составляющую
    FMetaphoneName := MetaphoneTransletter(strlst[iIndex], 1, 7);
  end;

  Result := FMetaphoneName;
end;

function TIdObject.GetMetaphoneShortName: string;
begin
  if trim(FMetaphoneShortName) = '' then FMetaphoneShortName := MetaphoneTransletter(ShortName, 1, 4);

  Result := FMetaphoneShortName;
end;

function TIdObject.GetName: string;
begin
  Result := FName;
end;

function TIdObject.GetOwner: TIdObject;
begin
  Result := Collection.Owner;
end;

function TIdObject.GetPropertyValue(APropertyID: integer): OleVariant;
begin
  Result := null;
end;

function TIdObject.GetShortName: string;
begin
  Result := FShortName;
end;


procedure TIdObject.InitSubCollections;
begin

end;

procedure TIdObject.IntToObjects(Value: string; AAllObjects,
  AObjects: TIDObjects);
  // AAllObjects - фасад
  // AObjects - внутренняя коллекция класса
var i: integer;
    str: string;
begin
  if Value <> '' then
  begin
    Value := PChar(Value);
    str := '';
    for i := 0 to Length(Value) do
    if Value[i] <> '|' then str := str + Value[i]
    else
    begin
      AObjects.Add(AAllObjects.ItemsByID[StrToInt(trim(str))] as AAllObjects.FObjectClass);
      str := '';
    end;
  end
end;

function TIdObject.List(AListOption: TListOption = loBrief): string;
begin
  Result := Name;
end;

function TIdObject.Next: TIDObject;
begin
  Result := nil;
  if Assigned(Collection) and (Collection.IndexOf(Self) < Collection.Count - 1) then
    Result := Collection.Items[Collection.IndexOf(Self) + 1];
end;

function TIdObject.Prev: TIDObject;
begin
  Result := nil;
  if Assigned(Collection) and (Collection.IndexOf(Self) > 0) then
    Result := Collection.Items[Collection.IndexOf(Self) - 1];
end;

procedure TIdObject.ReassignCollection(ACollection: TIDObjects);
begin
  FCollection := ACollection;
end;

procedure TIdObject.SetClassIDString(const Value: string);
begin
  if FClassIDString <> Value then
  begin
    FClassIDString := Value;
    FName := 'Новый '  + FClassIDString;
  end;
end;

procedure TIdObject.SetComment(const Value: string);
begin
  Fcomment := Value;
end;

procedure TIdObject.SetName(const Value: string);
begin
  if FName <> Value then
  begin
    FName := Value;
    FMetaphoneName := '';
  end;
end;

procedure TIdObject.SetShortName(const Value: string);
begin
  if FShortName <> Value then
  begin
    FShortName := Value;
    FMetaphoneShortName := '';
  end;
end;

function TIdObject.StrToCorrect(AStr: string; NeedsLowerCase,
  NeedsDelSpace: Boolean): string;
var i: Integer;
    str1, str2: string;
begin
  Result := '';

  if NeedsLowerCase then
  begin
    str1 := AStr;
    str2 := AStr;

    System.Delete(str1, 2, StrLen(PChar(str2)) - 1);
    System.Delete(str2, 1, 1);

    str1 := AnsiUpperCase(str1) + AnsiLowerCase(str2);
  end;

  if NeedsDelSpace then
  begin
    {
    for i := 1 do StrLen(str1) do
    begin


    end;
    }
  end;

  Result := str1;
end;

procedure TIdObject.StrToObjects(Value: string; AAllObjects, AObjects: TIDObjects);
  { AAllObjects - фасад
    AObjects - внутренняя коллекция класса }
var i: integer;
    str: string;
begin
  if Value <> '' then
  begin
    Value := PChar(Value);
    str := '';
    for i := 0 to Length(Value) do
      if Value[i] <> '|' then str := str + Value[i]
      else
      begin
        AObjects.Add(AAllObjects.GetItemByName(trim(str)) as AAllObjects.FObjectClass);
        str := '';
      end;
  end
end;

function TIdObject.Update(ACollection: TIDObjects = nil): integer;
var dp: TDataPoster;
begin
  Result := 0;

  if Assigned(ACollection) then
    dp := ACollection.Poster
  else
  begin
    Assert(Collection <> nil, 'Объект не принадлежит какой-либо коллекции');
    dp := Collection.Poster;
  end;

  Assert(dp <> nil, 'Не задан материализатор для записываемого в БД объекта');

  if Assigned(ACollection) then
  begin
    dp.RestoreState(ACollection.PosterState);
    Result := dp.PostToDB(Self, ACollection)
  end
  else
  begin
    dp.RestoreState(Collection.PosterState);
    Result := dp.PostToDB(Self, Collection);
  end;
  
  FreeAndNil(FEditingObject);
end;

procedure TIdObject.UpdateFilters;
begin
  
end;

{ TIdObjects }

function TIdObjects.Add: TIDObject;
begin
  Result := FObjectClass.Create(Self);
  inherited Add(Result);
end;

function TIdObjects.Add(AID: integer; AName: string): TIDObject;
begin
  Result := ItemsByID[AID];

  if not Assigned(Result) then
  begin
    Result := Add;
    Result.ID := AID;
  end;

  Result.Name := AName;
end;

function TIdObjects.Add(AID: integer): TIDObject;
begin
  Result := ItemsByID[AID];

  if not Assigned(Result) then
  begin
    Result := Add;
    Result.ID := AID;
  end;
end;

function TIdObjects.Add(AObject: TObject; Copy: boolean = true; NeedsCheck: boolean = true): TIDObject; 
var o: TIDObject;
begin
  if Copy then
  begin
    if NeedsCheck then
    begin
      if (not Assigned(ItemsByID[(AObject as TIDObject).ID])) then
      begin
        o := ObjectClass.Create(Self);
        o.Assign(AObject as TIDObject);
        inherited Add(o);
        Result := o;
      end
      else
      begin
        Result := ItemsByID[(AObject as TIDObject).ID];
        if Copy then Result.Assign(AObject as TIDObject);
      end;
    end
    else
    begin
      o := ObjectClass.Create(Self);
      o.Assign(AObject as TIDObject);
      inherited Add(o);
      Result := o;
    end;
  end
  else
  begin
    if NeedsCheck then
    begin
      if (IndexOf(AObject) = -1) then
      if ((AObject as TIDObject).ID = 0) or (((AObject as TIDObject).ID <> 0) and (not Assigned(ItemsByID[(AObject as TIDObject).ID]))) then
        inherited Add(AObject);
    end
    else
      inherited Add(AObject);

    Result := AObject as TIDObject;
  end;
end;

function TIdObjects.Add(AID: integer; AName,
  AShortName: string): TIDObject;
begin
  Result := ItemsByID[AID];

  if not Assigned(Result) then
  begin
    Result := Add;
    Result.ID := AID;
  end;
  Result.Name := AName;
  Result.ShortName := AShortName;
end;

procedure TIdObjects.Assign(Source: TIDObjects; NeedClearing: boolean = true);
var i : integer;
    o : TIDObject;
begin
  if NeedClearing then Clear;

  for i := 0 to Source.Count - 1 do
    Add(Source.Items[i], true, false);

  //if Assigned(FOwner) then FOwner := Source.FOwner;

  if Assigned(Source.FDeletedObjects) then
  begin
    for i := 0 to Source.FDeletedObjects.Count - 1 do
    begin
      o := FObjectClass.Create(Self);
      o.Assign(Source.FDeletedObjects.Items[i]);
      DeletedObjects.Add(o);
    end;
  end;
end;

procedure TIdObjects.Clear;
begin
  inherited Clear;
end;

constructor TIdObjects.Create;
begin
  inherited Create(false);
  FObjectClass := TIDObject;
  { TODO : В потомках - один единственный постер будет забираться из фасада. }
//  FDataPoster := TMainFacade.GetInstance.DataPosters[TIDObjectDataPoster];

  FNeedsReloading := true;
end;

procedure TIdObjects.Delete(Index: integer);
var iResult: integer;
begin
  iResult := 0;
  //(OwnsObjects or Items[Index].Collection.OwnsObjects) and 
  if Assigned(Poster) then
  begin
    if Assigned(FDataPosterState) then Poster.RestoreState(FDataPosterState);
    iResult := Poster.DeleteFromDB(Items[Index], Self);
  end;

  if iResult >= 0 then inherited
  else Raise EObjectDeletingException.Create(Items[Index]);
end;

destructor TIdObjects.Destroy;
begin
 { TODO : И уничтожать его тоже не нужно будет - касается как коллеций, так и одиноких объектов }
  if Assigned(FDeletedObjects) then FDeletedObjects.Free;
  inherited;
end;

function TIdObjects.IsItemsEqual(AObjects: TIDObjects): boolean;
var i: integer;
    os : TIDObjects;
begin
  Result := false;

  if AObjects.Count = Count then
  begin
    os := TIDObjects.Create;
    os.OwnsObjects := false;

    // если в AObjects есть объект из основного списка
    // добавляем его в список совпадений 
    for i := 0 to Count - 1 do
    if Assigned(AObjects.ItemsByID[Items[i].ID]) then
      os.Add(Items[i], false, true);

    if os.Count = AObjects.Count then Result := true;

    os.Free;
  end;
end;

function TIdObjects.GetDataPosterState: TDataPosterState;
begin
  if not Assigned(FDataPosterState) then FDataPosterState := TDataPosterState.Create;
  Result := FDataPosterState;
end;

function TIdObjects.GetDeletedObjects: TIDObjects;
begin
  if not Assigned(FDeletedObjects) then
  begin
    FDeletedObjects := TIDObjects.Create;
    FDeletedObjects.FDataPoster := Poster;
    FDeletedObjects.OwnsObjects := not OwnsObjects;
    FDeletedObjects.Owner := Owner;
  end;

  Result := FDeletedObjects;
end;

function TIdObjects.GetItemByName(AName: string): TIDObject;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if AnsiLowerCase(trim(Items[i].Name)) = AnsiLowerCase(trim(AName)) then
  begin
    Result := Items[i];
    break;
  end;
end;

function TIdObjects.GetItems(Index: integer): TIDObject;
begin
  Result := inherited Items[Index] as TIDObject;
end;

function TIdObjects.GetItemsByID(AID: integer): TIdObject;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if (Items[i].ID = AID) then
  begin
    Result := Items[i];
    break;
  end;
end;


procedure TIdObjects.MarkDeleted(AObject: TObject);
var bOwner: boolean; 
begin
  DeletedObjects.Add(AObject, false, false);

  bOwner := OwnsObjects;
  if bOwner then OwnsObjects := false;
  inherited Remove(AObject);
  OwnsObjects := bOwner;
end;

function TIdObjects.GetItemsByIDAndClassType(AClass: TIDObjectClass;
  AID: integer): TIdObject;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if (Items[i] is AClass) and (Items[i].ID = AID) then
  begin
    Result := Items[i];
    break;
  end;
end;

procedure TIdObjects.MarkDeleted(Index: integer);
begin
  MarkDeleted(Items[Index]);
end;


function TIdObjects.ObjectsToStr: string;
var i: integer;
begin
  Result := '';
  if Count <> 0 then
  for i := 0 to Count - 1 do
    if i < Count - 1 then Result := Result + Items[i].List + ', '
    else Result := Result + Items[i].List
  else Result := '<нет данных>';
end;

procedure TIdObjects.Reload;
begin
  {TODO : Фильтр, возможно, тоже придётся передавать как-то в метод.
          Или сделать метод перегружаемым, чтобы потомки сами формировал фильтр.
          Или включить шаблонный метод, создающий фильтр, и переопределять не Reload, а уже его.}
  //if Assigned(FDataPoster) then FDataPoster.GetFromDB('', Self);
  Application.ProcessMessages;
end;

function TIdObjects.ObjectsToStr(AAuthors: string): string;
begin
  Result := '';
end;

procedure TIdObjects.Reload(AFilter: string; UseEmptyFilter: boolean = false);
begin
  if Assigned(FDataPoster) then
  if (((trim(AFilter) = '') and UseEmptyFilter) or (trim(AFilter) <> '')) then
  begin
    Clear;
    FDataPoster.GetFromDB(AFilter, Self);
    FDataPoster.SaveState(PosterState);
  end;
end;

function TIdObjects.Remove(AObject: TObject): Integer;
begin
  Result := 0;

  if Assigned(Poster) then
  begin
    if Assigned(FDataPosterState)
    then Poster.RestoreState(FDataPosterState);
    Result := Poster.DeleteFromDB(AObject as TIDObject, Self);
  end;

  if Result >= 0 then inherited Remove(AObject)
  else Raise EObjectDeletingException.Create(AObject as TIDObject);
end;

procedure TIdObjects.SetIcons (AObject: TObject);
begin

end;

function TIdObjects.Update(ACollection: TIDObjects): integer;
var i: integer;
begin
  Result := 0;
  DeleteMarkedObjects;
  for i := 0 to Count - 1 do
    Items[i].Update(ACollection);
end;

function TIdObjects.FullEnteringItems(AObjects: TIDObjects): boolean;
var i, CountEnteringItems: integer;
begin
  Result := false;

  CountEnteringItems := 0;

  for i := 0 to Count - 1 do
  if Assigned (AObjects.ItemsByID[Items[i].id]) then
    inc(CountEnteringItems);

  if CountEnteringItems = Count then Result := true;
end;

function TIdObjects.List(AListOption: TListOption): string;
var i: integer;
begin
  Result := '';
  for i := 0 to Count - 1 do
    Result := Result + Items[i].List(AListOption) + ';';

  Result := Trim(copy(Result, 1, Length(Result) - 1));
end;

procedure TIdObjects.MarkAllDeleted;
var i: integer;
begin
  for i := Count - 1 downto 0 do
    MarkDeleted(i);
end;

procedure TIdObjects.AddObjects(ASourceObjects: TIDObjects; Copy: boolean = true; NeedsCheck: boolean = true);
var i: integer;
begin
  for i := 0 to ASourceObjects.Count - 1 do
    Add(ASourceObjects.Items[i], Copy, NeedsCheck)
end;

function TIdObjects.IDList(ASeparator: char = ','): string;
var i: integer;
begin
  Result := '';
  for i := 0 to Count - 1 do
    Result := Result + ASeparator +  IntToStr(Items[i].ID);

  Result := trim(copy(Result, 2, Length(Result)))
end;

procedure TIdObjects.SortByID(Straight: Boolean = True);
begin
  if Straight then
    Sort(UINCompare)
  else
    Sort(ReverseUINCompare);
end;

procedure TIdObjects.SortByName(Straight: Boolean = True);
begin
  if Straight then
    Sort(NameCompare)
  else
    Sort(ReverseNameCompare);
end;

procedure TIdObjects.Refresh;
begin
  Reload(PosterState.Filter, true);
end;

function TIdObjects.GetItemByMetaphoneName(AName: string): TIDObject;
var i: Integer;
    sName: string;
begin
  Result := nil;
  sName := MetaphoneTransletter(AName, 1, 7);
  for i := 0 to Count - 1 do
  if (Pos(Items[i].MetaphoneName, sName) > 0) or (Pos(sName, Items[i].MetaphoneName) > 0) then
  begin
    Result := Items[i];
    Break;
  end;
end;

function TIdObjects.GetItemByMetaphoneShortName(AName: string): TIDObject;
var i: Integer;
    sName: string;
begin
  Result := nil;
  sName := MetaphoneTransletter(AName, 1, 7);
  for i := 0 to Count - 1 do
  if (Pos(Items[i].MetaphoneShortName, sName) > 0) or (Pos(sName, Items[i].MetaphoneShortName) > 0) then
  begin
    Result := Items[i];
    Break;
  end;
end;

procedure TIdObjects.GetItemsByName(const AName: string;
  AOutItems: TIDObjects);
var i: integer;
    sName: string;
begin
  Assert(Assigned(AOutItems), 'Не задана переменная для сбора найденных объектов');
  AOutItems.OwnsObjects := false;

  sName := AnsiUpperCase(trim(AName));
  for i := 0 to Count - 1 do
  if sName = AnsiUpperCase(trim(Items[i].Name)) then
    AOutItems.Add(Items[i], false, false);
end;

procedure TIdObjects.GetItemsByPartialName(const ANamePart: string;
  AOutItems: TIDObjects);
var i: integer;
    sName: string;
begin
  Assert(Assigned(AOutItems), 'Не задана переменная для сбора найденных объектов');
  AOutItems.OwnsObjects := false;

  sName := AnsiUpperCase(trim(ANamePart));
  for i := 0 to Count - 1 do
  if (Pos(sName, AnsiUpperCase(trim(Items[i].Name))) > 0) then
    AOutItems.Add(Items[i], false, false);
end;

function TIdObjects.GetItemByShortName(AName: string): TIDObject;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if AnsiLowerCase(trim(Items[i].ShortName)) = AnsiLowerCase(trim(AName)) then
  begin
    Result := Items[i];
    break;
  end;
end;

procedure TIdObjects.DeleteMarkedObjects;
var i: integer;
begin
  DeletedObjects.PosterState := PosterState;
  for i := DeletedObjects.Count - 1 downto 0 do
    DeletedObjects.Delete(i);

end;

{ TAllIdObjects }

constructor TAllIdObjects.Create;
begin
  inherited Create;
  OwnsObjects := true;
end;

{ TDataPosters }

function TDataPosters.Add(ADataPosterClass: TDataPosterClass): TDataPoster;
begin
  Result := ADataPosterClass.Create;
  inherited Add(Result);
end;

constructor TDataPosters.Create;
begin
  inherited;
  OwnsObjects := true;
end;

function TDataPosters.GetDataPosterByClassType(
  ADataPosterClass: TDataPosterClass): TDataPoster;
var i: integer;
begin
  Result := nil;

  for i := 0 to Count - 1 do
  if Items[i] is ADataPosterClass then
  begin
    Result := Items[i];
    break;
  end;

  if not Assigned(Result) then
    Result := Add(ADataPosterClass);
end;

function TDataPosters.GetItems(Index: integer): TDataPoster;
begin
  Result := inherited Items[Index] as TDataPoster;
end;

{ EObjectAddingException }

constructor EObjectAddingException.Create(AObject: TIDObject; ALastException: Exception);
var sMsg: string;
begin
  if Assigned(AObject) then sMsg := AObject.List;

  sMsg := sMsg + ';' + 'Ошибка: ' + ALastException.Message;
  inherited Create('Не удалось добавить/отредактировать объект '+ AObject.List);
end;



{ TDataPoster }

constructor TDataPoster.Create;
begin
  inherited;
end;

function TDataPoster.DeleteFromDB(ACollection: TIDObjects): integer;
var i: integer;
begin
  for i := ACollection.Count - 1 downto 0 do
    DeleteFromDB(ACollection.Items[i], ACollection);
  Result := 0;
end;

function TDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; 
begin
  Result := 0;
end;

function TDataPoster.GetDataPosterState: TDataPosterState;
begin
  Result := FDataPosterState;
end;

function TDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
begin
  Assert(DataSourceString <> '' );
  Result := 0;
end;

procedure TDataPoster.LocalSort(AObjects: TIDObjects);
begin

end;

function TDataPoster.PostToDB(ACollection: TIDObjects; AOwner: TIDObject): integer;
var i: integer;
begin
  for i := ACollection.Count - 1 downto 0 do
    PostToDB(ACollection.Items[i], ACollection);
  Result := 0;
end;


function TDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

procedure TDataPoster.RestoreState(AState: TDataPosterState);
begin

end;

procedure TDataPoster.SaveState(AState: TDataPosterState);
begin

end;

procedure TDataPoster.SetDataSourceString(const Value: string);
begin
  FDataSourceString := Value;

  if soSingleDataSource in Options then
  begin
    FDataPostString := FDataSourceString;
    FDataDeletionString := FDataSourceString;
  end;
end;



procedure TDataPoster.SetFilter(const Value: string);
begin
  if FFilter <> Value then
    FFilter := Value;
end;

{ EObjectDeletingException }

constructor EObjectDeletingException.Create;
var sName: string;
begin
  sName := ' ';
  if Assigned(AObject) then
    sName := ' ' + AObject.List(loBrief);
  inherited Create('Не удалось удалить объект' + sName + '. Возможно присутствуют связанные объекты');
end;

{ TDataPosterState }

procedure TDataPosterState.AssignTo(Dest: TPersistent);
begin
  (Dest as TDataPosterState).Filter := Filter;
  (Dest as TDataPosterState).Sort := Sort;
end;

{ TIDObjectTable }

function TIDObjectTable.Add(ACol, ARow: integer; AObject: TObject; Copy,
  NeedsCheck: boolean): TIDObject;
begin
  Result := FInternalObjects.Add(AObject, Copy, NeedsCheck);
  SetItems(ACol, ARow, Result);
end;

function TIDObjectTable.Add(ACol, ARow: integer): TIDObject;
begin
  Result := FInternalObjects.Add;
  SetItems(ACol, ARow, Result);
end;

function TIDObjectTable.Add(ACol, ARow, AID: integer): TIDObject;
begin
  Result := FInternalObjects.Add(AID);
  SetItems(ACol, ARow, Result);
end;

function TIDObjectTable.Add(ACol, ARow, AID: integer; AName,
  AShortName: string): TIDObject;
begin
  Result := FInternalObjects.Add(AID, AName, AShortName);
  SetItems(ACol, ARow, Result);
end;

function TIDObjectTable.Add(ACol, ARow, AID: integer;
  AName: string): TIDObject;
begin
  Result := FInternalObjects.Add(AID, AName);
  SetItems(ACol, ARow, Result);
end;

constructor TIDObjectTable.Create;
begin
  inherited;
  FInternalObjects := TIDObjects.Create;
end;

procedure TIDObjectTable.Delete(ACol, ARow: integer);
begin
  Remove(Items[ACol, ARow]);
end;

destructor TIDObjectTable.Destroy;
begin
  FInternalObjects.Free;
  inherited;
end;

procedure TIDObjectTable.FindItem(AObject: TIDObject; var ACol,
  ARow: integer);
var i, j: integer;
begin
  ARow := -1; ACol := -1;
  for i := 0 to RowCount - 1 do
  for j := 0 to ColCount - 1 do
  if Items[i, j] = AObject then
  begin
    ARow := i;
    ACol := j;

    break;
  end;
end;

function TIDObjectTable.GetItems(ACol, ARow: integer): TIDObject;
begin
  Result := FObjects[ARow, ACol];
end;

function TIDObjectTable.GetItemsByID(AID: integer): TIDObject;
begin
  Result := FInternalObjects.ItemsByID[AID];
end;

function TIDObjectTable.Remove(AObject: TIDObject): integer;
var iCol, iRow: integer;
begin
  Result := 0;
  FindItem(AObject, iCol, iRow);

  if not ((iCol = -1) and (iRow = -1)) then
    SetItems(iCol, iRow, nil);

  FInternalObjects.Remove(AObject);
end;

procedure TIDObjectTable.SetColCount(const Value: integer);
var i: integer;
begin
  if FColCount <> Value then
  begin
    FColCount := Value;

    for i := 0 to RowCount - 1 do
      SetLength(FObjects[i], FColCount);
  end;
end;

procedure TIDObjectTable.SetItems(ACol, ARow: integer;
  const Value: TIDObject);
var iCol, iRow: integer;
begin
  FindItem(Value, iCol, iRow);
  if not ((iCol = -1) and (iRow = -1)) then
    FObjects[iRow][iCol] := nil;

  FObjects[ARow][ACol] := Value;
end;

procedure TIDObjectTable.SetObjectClass(const Value: TIDObjectClass);
begin
  if FObjectClass <> Value then
  begin
    FObjectClass := Value;
    FInternalObjects.FObjectClass := FObjectClass;
  end;
end;

procedure TIDObjectTable.SetRowCount(const Value: integer);
var i: integer;
begin
  if FRowCount <> Value then
  begin
    FRowCount := Value;
    SetLength(FObjects, FRowCount);

    for i := 0 to RowCount - 1 do
      SetLength(FObjects[i], FColCount);
  end;
end;

end.

