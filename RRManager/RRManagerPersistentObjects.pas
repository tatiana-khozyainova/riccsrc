unit RRManagerPersistentObjects;

interface

uses Contnrs, SysUtils, Classes, ComCtrls, RRManagerBaseObjects, ClientCommon
  {$IFDEF VER150}
  , Variants
  {$ENDIF}
  ;


type
  TDataPoster = class;
  TDataPosterCache = class;
  TDataState = class;
  TDataPosterClass = class of TDataPoster;
  // ��� ����������������� - ������ � ����������, ������ ��� ������, ��� ������
  // � ������ ��� ��������� ��� ������ ������
  TMaterializationKind = (mkFull, mkSingle, mkCollectionProxy, mkProxy, mkFullProxy);
  TDataStateClass = class of TDataState;
  TBaseCollectionClass = class of TBaseCollection;

  TChangeType = (ctDeleted, ctUpdated, ctAdded, ctRestored);


  // ������ ������� � ����
  EDataAccessError = class(Exception)
  public
    constructor Create(ErrorCode: integer; const Table, Key, Columns: string);
  end;

  // ������ ��������������
  EMaterializationError = class(Exception)
  public
    constructor Create;
  end;

  TPoster = class(TInterfacedObject)
  private
    FClearFirst: boolean;
  protected
    FLastGotObject: TBaseObject;
    FLastGotCollection: TBaseCollection;
    FLastPostedObject: TBaseObject;
    FLastDeletedObject: TBaseObject;
    // ������ ������ ������� � ������ ���������
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; overload; virtual; abstract;
    // ������ ������ ��������� � ������ ���������
    function GetPostingData(ABaseCollection: TBaseCollection): OleVariant; overload; virtual;
    // ������ ������ ��� �������� � ������ ���������
    function GetDeletingData(ABaseObject: TBaseObject): OleVariant; overload; virtual;
    // ������ ������ ��� �������� ���� (������ ���� �������� �����)
    function GetDeletingData(ABaseCollection: TBaseCollection): OleVariant; overload; virtual;
    // �������������� ������
    function GetObject(AData: variant): TBaseCollection; virtual; abstract;
    // ������������� ����� ������� � ���������� ��������
    procedure Prepare; virtual; abstract;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function  ExtendedPost(ABaseObject: TBaseObject): integer; overload; virtual;
    function  ExtendedPost(ABaseCollection: TBaseCollection): integer; overload; virtual;
  public
    // ��������� ��������� �������� ��������� ������
    property LastGotCollection: TBaseCollection read FLastGotCollection write FLastGotCollection;
    property LastGotObject: TBaseObject read FLastGotObject write FLastGotObject;

    // ��������� ����������� ������
    property LastPostedObject: TBaseObject read FLastPostedObject;
    // ��������� ��������� ������
    property LastDeletedObject: TBaseObject read FLastDeletedObject;
    // ������� �� ��������� ��� ������ ���������
    property ClearFirst: boolean read FClearFirst write FClearFirst;
    constructor Create; virtual;
  end;


  // ������-������
  // ����� �� ������ �� ����� �������� ���������� �������
  // ���������� ����������� � ����
  // � �������� �� ��� ����� ��������� ��� ������ �������
  // �� ���� ������������� ������ � �������� ����������
  // ������ � ����������� ���� ��� (�� ����� ���� �� ���, � ������ �� ����������)
  // ���������� �������
  TDataPoster = class(TPoster)
  protected
    FForceGet: boolean;
    FInsertReturnsData: boolean;
    FPostingColumns: string;
    FGettingColumns: string;
    FPostingTable: string;
    FGettingTable: string;
    FQuery: string;
    FCache: TDataPosterCache;
    FKeyColumn: string;
    FDeletingTable: string;
    FOrder: string;
    FObjectClass: TBaseClass;
    FCollectionClass: TBaseCollectionClass;
 public
    // ���
    property Cache: TDataPosterCache read FCache;
    // �������, �� ������� ����� ������
    property GettingTable: string read FGettingTable;
    // �������, ������� �����
    property GettingColumns: string read FGettingColumns;
    // �������-����
    property KeyColumn: string read FKeyColumn;

    function GetFilter(ACollection: TBaseCollection): string; overload;
    function GetFilter(AObject: TBaseObject): string; overload;

    property ObjectClass: TBaseClass read FObjectClass;
    property CollectionClass: TBaseCollectionClass read FCollectionClass;


    // ������� (���������), � ������� ��������� ������
    property PostingTable: string read FPostingTable;

    // �������, ������� ������� �������� ��� �������
    property PostingColumns: string read FPostingColumns;

    // �������, �� ������� ��������� ������
    property DeletingTable: string read FDeletingTable;

    // ������ ��� ������� ��� ��������� ������
    property Query: string read FQuery;
    // ������� �� �������� ���������
    property Order: string read FOrder write FOrder;
    // ������������ �� �����-�� ������ ��� �������
    property InsertReturnsData: boolean read FInsertReturnsData;
    // ������� GetObject � GetFromDB
    // �������� �� ��, ��� �������� ������ �� ������
    // ��� �������� �����-�� ������
    property ForceGet: boolean read FForceGet write FForceGet;
    // ��������� ������
    function PostToDB(ABaseObject: TBaseObject): integer; overload;
    // ��������� ���������
    function PostToDB(ABaseCollection: TBaseCollection; DeleteFirst: boolean = true): integer; overload;
    // ������� ������
    function DeleteFromDB(ABaseObject: TBaseObject; ClearCollection: boolean = true): integer; overload;
    // ������� ���������
    function DeleteFromDB(ABaseCollection: TBaseCollection; ClearCollection: boolean = false): integer; overload;

    // �������� ������
    function GetFromDB(const AUIN: integer): TBaseCollection; overload;
    // �������� ������ �� �������
    function GetFromDB(AFilter: string): TBaseCollection; overload;

    // ������� ������ � UIN�� - ������ �������� ������ - ���� ����� ��������� ��
    // ���� ������� - ������� �����������. ������ ����������� ������ Data � ����������
    // ����������� �� GetObject.
    function GetProxy(const AUIN: integer): TBaseCollection; virtual; abstract;

    constructor Create; override;
    destructor Destroy; override;
  end;

  TStringPoster = class(TPoster)
  public
    function GetFromString(ASource: string): TBaseCollection; 
    function PostToString(ABaseCollection: TBaseCollection): string; overload;
    function PostToString(ABaseObject: TBaseObject): string; overload;
    constructor Create; override;
  end;


  // ��� ����� ���� �������� � �������� ����������� ��� ���������
  TRegisteredEvent = class
  private
    FCurrentObject: TBaseCollection;
    FLastObject: TBaseCollection;
    FDateTime: TDateTime;
  public
    property   CurrentObject: TBaseCollection read FCurrentObject write FCurrentObject;
    property   LastObject: TBaseCollection read FLastObject write FLastObject;
    property   DateTime: TDateTime read FDateTime;
    procedure  Restore;
    constructor Create;
    destructor Destroy; override;
  end;

  // ��� �������, � ������� ���������� ������������ �������
  // ���� ���������
  // ������� ����� ���������, ������ �� ����� �� �� ���������� ����������� (���������)
  TDataPosterCache = class(TObjectList)
  private
    FMaxDepth: integer;
    FOutTime: TDateTime;
    function GetItems(const AUIN: integer): TRegisteredEvent;
    procedure SetMaxDepth(const Value: integer);
    procedure SetOutTime(const Value: TDateTime);
  public
    property Items[const UIN: integer]: TRegisteredEvent read GetItems;
    // �������� �� ����
    procedure DeleteByUIN(const UIN: integer);

    // ������������ ������� ����
    property MaxDepth: integer read FMaxDepth write SetMaxDepth;
    // ����� ��������������, ������� � �������� ������� ��������� �����������
    property OutTime: TDateTime read FOutTime write SetOutTime;

    function Add(AEvent: TRegisteredEvent): integer; overload;
    function Add(ACurrentObject: TBaseCollection): integer; overload;
  end;

  // ������ ��������� ������� (���������, �����, ����������, ����������)
  TDataState = class
  private
    FName: string;
  public
    // ����� ���������� �������� �� ����������� ������� � ��
    // � ������ ����������-�������� ��� ������ ��������
    procedure SetState(ABaseCollection: TBaseCollection); virtual;
    property  Name: string read FName write FName;
  end;


  // ������ ����������� ������ ���� ��������
  TDataPosters = class(TObjectList)
  private
    function GetPosters(const ClassType: TDataPosterClass): TDataPoster;
    function GetItems(const Index: integer): TDataPoster;
    function GetPostersByObjectClass(
      const ClassType: TBaseClass): TDataPoster;
    function GetPostersByCollectionClass(
      const ClassType: TBaseCollectionClass): TDataPoster;
    function GetPostersByCollection(
      const ACollection: TBaseCollection): TDataPoster;
    function GetPostersByObject(const AObject: TBaseObject): TDataPoster;
  public
    property    Items[const Index: integer]: TDataPoster read GetItems;
    property    Posters[const ClassType: TDataPosterClass]: TDataPoster read GetPosters;
    property    PosterByObjectClass[const ClassType: TBaseClass]: TDataPoster read GetPostersByObjectClass;
    property    PosterByCollectionClass[const ClassType: TBaseCollectionClass]: TDataPoster read GetPostersByCollectionClass;
    property    PosterByObject[const AObject: TBaseObject]: TDataPoster read GetPostersByObject;
    property    PosterByCollection[const ACollection: TBaseCollection]: TDataPoster read GetPostersByCollection;

    constructor Create; virtual;
  end;


{ DONE : ��� ���� ���-�� ��������� }

implementation

uses Facade;


{ TDataPoster }

constructor TDataPoster.Create;
begin
  inherited;
  FCache := TDataPosterCache.Create;
  FInsertReturnsData := true;
  FForceGet := false;
  Prepare;
end;

function TDataPoster.DeleteFromDB(
  ABaseObject: TBaseObject;
  ClearCollection: boolean = true): integer;
var v: OleVariant;
begin
  Result := 0;
  if Assigned(ABaseObject) and (trim(DeletingTable) <> '') then
  begin
    if pos('spd_', DeletingTable) = 0 then
    begin
      Result := TMainFacade.GetInstance.DBGates.Server.DeleteRow(DeletingTable, KeyColumn + ' = ' + IntToStr(ABaseObject.ID));
      if ClearCollection and (Result >= 0) then
      begin
        ABaseObject.Collection.Remove(ABaseObject);
        ABaseObject := nil;
      end;
    end
    else
    begin
      v := GetDeletingData(ABaseObject);
      if not (varIsNull(v) or varIsEmpty(v)) then
      begin
        Result := TMainFacade.GetInstance.DBGates.Server.InsertRow(DeletingTable, null, v);
        if ClearCollection and (Result >= 0) then
        begin
          ABaseObject.Collection.Remove(ABaseObject);
          ABaseObject := nil;
        end;
     end;


     if Result < 0 then raise EDataAccessError.Create(Result, DeletingTable, KeyColumn + ' = ' + IntToStr(ABaseObject.ID), '');
      { DONE : ������� �� ���������, �� �� ������� �� ���� ��������� - ����� ���� �����������
        ��������������.}

      // ��������� � ���
      //Cache.Add(ABaseCollection);
    end;
  end;  
end;

function TDataPoster.GetFromDB(const AUIN: integer): TBaseCollection;
var vResult: variant;
    iResult: integer;
    sQuery: string;
begin
  Result := nil;
  varClear(vResult);
  // ������������� ���
  //Result := Cache.Items[AUIN].CurrentObject;
  //if not Assigned(Result) then
  begin
    iResult := -1;
    if trim(Query) <> '' then
    begin
      if pos('where', Query) = 0 then
        sQuery := Query + ' where '
      else
        sQuery := Query + ' and ';

      iResult := TMainFacade.GetInstance.DBGates.Server.ExecuteQuery(sQuery + '(' +  KeyColumn + ' = ' + IntToStr(AUIN) + ')' +
                                              ' order by ' + Order)
    end
    else
    if trim(GettingTable) <> '' then
    begin
      if pos('SPD_', UpperCase(GettingTable)) > 0 then
        iResult := TMainFacade.GetInstance.DBGates.Server.SelectRows(GettingTable, varArrayOf([GettingColumns]),
                                      '', varArrayOf([AUIN]))
      else
        iResult := TMainFacade.GetInstance.DBGates.Server.ExecuteQuery('select ' + GettingColumns + ' ' +
                                        'from ' + GettingTable + ' ' +
                                        'where ' + KeyColumn + ' = ' + IntToStr(AUIN) + ' ' +
                                        'order by ' + Order);
    end;


    if iResult >= 0 then
    begin
      vResult := TMainFacade.GetInstance.DBGates.Server.QueryResult;
      Result  := GetObject(vResult);
      FLastGotCollection := Result;
    end
    else if iResult < 0 then
    if ForceGet then
    begin
      Result := GetObject(null);
      FLastGotCollection := Result;
    end
    else raise EDataAccessError.Create(iResult, GettingTable, KeyColumn + ' = ' + IntToStr(AUIN), GettingColumns);
  end;
end;



function TDataPoster.GetFromDB(AFilter: string): TBaseCollection;
var vResult: variant;
    iResult: integer;
begin
  Result := nil;
  iResult := -1;
  if AFilter <> '' then
  begin
    // ������������� ���
    if pos('where', Query) = 0 then
    begin
      if pos('where', trim(AFilter)) <> 1 then
        AFilter := 'where ' + AFilter
    end
    else AFilter := ' and ' + '(' + AFilter + ')';

    if Order = '' then FOrder := KeyColumn;

    if trim(Query) <> '' then
      iResult := TMainFacade.GetInstance.DBGates.Server.ExecuteQuery(Query + ' ' + AFilter + ' order by ' + Order)
    else
    if trim(GettingTable) <> '' then
    begin
      iResult := TMainFacade.GetInstance.DBGates.Server.ExecuteQuery('select distinct ' + GettingColumns + ' ' +
                                      'from ' + GettingTable + ' ' +
                                       AFilter + ' ' +
                                       ' order by ' + Order)
    end;

    if iResult >= 0 then
    begin
      if iResult > 0 then
        vResult := TMainFacade.GetInstance.DBGates.Server.QueryResult;

      if not Assigned(Result) then
      begin
        Result  := GetObject(vResult);
        FLastGotCollection := Result;
      end;
    end
    else if iResult < 0 then
    if ForceGet then
    begin
      Result := GetObject(null);
      FLastGotCollection := Result;
    end
    else raise EDataAccessError.Create(iResult, GettingTable, AFilter, GettingColumns);
  end
  else
  if ForceGet then
  begin
    Result := GetObject(null);
    FLastGotCollection := Result;
  end;
end;




function TDataPoster.PostToDB(ABaseObject: TBaseObject): integer;
var vResult: variant;
    vPostingColumns: OleVariant;
begin
  Result := 0;
  if Assigned(ABaseObject) and ABaseObject.Check then
  begin
    vPostingColumns := GetPostingData(ABaseObject);
    if not(varIsEmpty(vPostingColumns) or varIsNull(vPostingColumns)) then
    begin
      if pos('spd_', PostingTable) = 0 then
      begin
        if not InsertReturnsData then
          Result := TMainFacade.GetInstance.DBGates.Server.InsertRow(PostingTable, varArrayOf([PostingColumns]),
                                      vPostingColumns)
        else
          Result := TMainFacade.GetInstance.DBGates.Server.InsertKeyRow(PostingTable, varArrayOf([PostingColumns]),
                                         vPostingColumns)
      end
      else
      begin
        if InsertReturnsData then
          Result := TMainFacade.GetInstance.DBGates.Server.SelectRows(PostingTable, ' ' + PostingColumns + ' ', '', vPostingColumns)
        else
          Result := TMainFacade.GetInstance.DBGates.Server.InsertRow(PostingTable, Null, vPostingColumns)
      end;

      if Result < 0 then raise EDataAccessError.Create(Result, PostingTable, '', PostingColumns)
      else
      if (Result > 0) and InsertReturnsData then
      begin
        vResult := TMainFacade.GetInstance.DBGates.Server.QueryResult;
        ABaseObject.ID := vResult[0, 0];
      end;

      { TODO : �������� ��� ��������� ����� ����� ����������� � ���������  -
        ����� �� ���������. ��������� ���������� �������� ��� ����������
        ���������, � �� ��� �����������, �� �������� ������� � ���, ��� ����������
        ��� ���������, ��� ����� ������ ���� ��������� �� ���� ����������, ��� �� ���������.}
        // ��������� � ���
        //Cache.Add(ABaseCollection);
    end;
    FLastPostedObject := ABaseObject;
    ExtendedPost(ABaseObject);
  end;
end;




destructor TDataPoster.Destroy;
begin
  FCache.Free;
  inherited;
end;


function TDataPoster.PostToDB(ABaseCollection: TBaseCollection; DeleteFirst: boolean = true): integer;
var i: integer;
begin
  Result := 0;
  if DeleteFirst then DeleteFromDB(ABaseCollection);
  for i := ABaseCollection.Count - 1 downto 0 do
    Result := PostToDB(ABaseCollection.ITems[i]);

  ExtendedPost(ABaseCollection);    
end;

constructor TPoster.Create;
begin
  inherited;
  FClearFirst := true
end;


function TPoster.ExtendedPost(ABaseObject: TBaseObject): integer;
begin
  Result := 0;
end;

function TPoster.ExtendedPost(ABaseCollection: TBaseCollection): integer;
begin
  Result := 0;
end;

function TPoster.GetDeletingData(
  ABaseCollection: TBaseCollection): OleVariant;
begin
  Result := null;
end;

function TPoster.GetDeletingData(ABaseObject: TBaseObject): OleVariant;
begin
  Result := null;
end;

function TDataPoster.DeleteFromDB(ABaseCollection: TBaseCollection;
  ClearCollection: boolean = false): integer;
var v: variant;
    i: integer;
begin
  v := null;
  Result := 0;
  if trim(DeletingTable) <> '' then
  begin
    if Assigned(ABaseCollection) then
      v := GetDeletingData(ABaseCollection);

    if not (varIsNull(v) or varIsEmpty(v)) then
    begin
      if (not (pos('spd_', DeletingTable) = 0)) then
      begin
        Result := TMainFacade.GetInstance.DBGates.Server.InsertRow(DeletingTable, null, v);

        if Result < 0 then raise EDataAccessError.Create(Result, DeletingTable, '', '');
        if ClearCollection then ABaseCollection.Clear;
      end
      else
      begin
        Result := TMainFacade.GetInstance.DBGates.Server.DeleteRow(DeletingTable, KeyColumn + ' = ' + IntToStr(v[0]));
        if Result < 0 then raise EDataAccessError.Create(Result, DeletingTable, '', '');
        if ClearCollection and (Result >= 0) then ABaseCollection.Clear;
      end;
    end
    else
    begin
      for i := 0 to ABaseCollection.Count - 1 do
       Result := DeleteFromDB(ABaseCollection.Items[i], ClearCollection);
    end;
  end;
end;


function TDataPoster.GetFilter(ACollection: TBaseCollection): string;
var i: integer;
begin
  result := '';
  for i := 0 to ACollection.Count - 1 do
    Result := ', ' + IntToStr(ACollection.Items[i].ID);
  Result := copy(Result, 2, Length(Result));

  Result := KeyColumn + ' in (' + Result + ')'; 
end;

function TDataPoster.GetFilter(AObject: TBaseObject): string;
begin
  Result := KeyColumn + ' = ' + IntToStr(AObject.ID);
end;

{ TDataPosterCache }

function TDataPosterCache.Add(AEvent: TRegisteredEvent): integer;
begin
  Result := inherited Add(AEvent);
end;

function TDataPosterCache.Add(ACurrentObject: TBaseCollection): integer;
var evnt: TRegisteredEvent;
begin
  evnt := Items[ACurrentObject.UIN];
  if Assigned(evnt) then
  begin
    evnt.LastObject.Assign(evnt.CurrentObject);
    Result := IndexOf(evnt);
  end
  else
  begin
    evnt := TRegisteredEvent.Create;
    evnt.CurrentObject := ACurrentObject;
    evnt.LastObject := TBaseCollectionClass(ACurrentObject.ClassType).Create(nil);
    Result := Add(evnt);
  end;
end;

procedure TDataPosterCache.DeleteByUIN(const UIN: integer);
var re: TRegisteredEvent;
begin
  re := Items[UIN];
  if Assigned(re) then
    Remove(re);
end;

function TDataPosterCache.GetItems(const AUIN: integer): TRegisteredEvent;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if TRegisteredEvent(inherited Items[i]).CurrentObject.UIN = AUIN then
  begin
    Result := TRegisteredEvent(inherited Items[i]);
    break;
  end;
end;

procedure TDataPosterCache.SetMaxDepth(const Value: integer);
var i: integer;
begin
  if FMaxDepth <> Value then
  begin
    if  (FMaxDepth < Value)
    and (FMaxDepth < Count) then
    for i := Count - 1 downto FMaxDepth - 1 do
      Delete(i);


    FMaxDepth := Value;
  end;
end;

procedure TDataPosterCache.SetOutTime(const Value: TDateTime);
begin
  FOutTime := Value;
end;

{ TDataState }

procedure TDataState.SetState(ABaseCollection: TBaseCollection);
begin

end;

{ TDataPosters }

constructor TDataPosters.Create;
begin
  OwnsObjects := true;
end;



function TDataPosters.GetItems(const Index: integer): TDataPoster;
begin
  Result := TDataPoster(inherited Items[Index]);
end;

function TDataPosters.GetPosters(
  const ClassType: TDataPosterClass): TDataPoster;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].ClassType = ClassType then
  begin
    Result := Items[i];
    break;
  end;

  if not Assigned(Result) then
  begin
    Result := ClassType.Create;
    Add(Result);
  end;
end;


{ TDataAccessError }

constructor EDataAccessError.Create(ErrorCode: integer; const Table,
  Key, Columns: string);
begin
  inherited CreateFmt('������ ������� � ������ ��� ��������� � ������� %s � ����������� (��������: %s; ����: %s).'
                       +#10#13+'��� ������ %s. ���������� � ������������.', [Table, Columns, Key, intToStr(ErrorCode)]);
end;

function TDataPosters.GetPostersByCollection(
  const ACollection: TBaseCollection): TDataPoster;
var i: integer;
begin
  Result := nil;
  if not Assigned(ACollection) then
    Result := PosterByObjectClass[TBaseClass(ACollection.ClassType)]
  else
  begin
    for i := 0 to Count - 1 do
    if ACollection is Items[i].CollectionClass then
    begin
      Result := Items[i];
      break;
    end;
  end;
end;

function TDataPosters.GetPostersByCollectionClass(
  const ClassType: TBaseCollectionClass): TDataPoster;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].CollectionClass = ClassType then
  begin
    Result := Items[i];
    break;
  end;
end;

function TDataPosters.GetPostersByObject(
  const AObject: TBaseObject): TDataPoster;
var i: integer;
begin
  Result := nil;
  if not Assigned(AObject) then
    Result := PosterByObjectClass[TBaseClass(AObject.ClassType)]
  else
  begin
    for i := 0 to Count - 1 do
    if AObject is Items[i].ObjectClass then 
    begin
      Result := Items[i];
      break;
    end;
  end;
end;

function TDataPosters.GetPostersByObjectClass(
  const ClassType: TBaseClass): TDataPoster;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].ObjectClass = ClassType then
  begin
    Result := Items[i];
    break;
  end;
end;

{ EMaterializationError }

constructor EMaterializationError.Create;
begin
  inherited Create('�� �������� �������������� � ������ �����������');
end;

{ TRegisteredEvent }

constructor TRegisteredEvent.Create;
begin
  FDateTime := now;
end;

destructor TRegisteredEvent.Destroy;
begin
  CurrentObject.Free;
  LastObject.Free;
  inherited Destroy;
end;

procedure TRegisteredEvent.Restore;
var io: TBaseCollection;
begin
  io := TBaseCollectionClass(CurrentObject.ClassType).Create(nil);
  io.Assign(CurrentObject);
  CurrentObject.Free;
  CurrentObject.Assign(LastObject);
  LastObject.Assign(io);
end;



{ TOutput }


function TPoster.GetPostingData(
  ABaseCollection: TBaseCollection): OleVariant;
begin
  Result := null;
end;

function TPoster._AddRef: Integer;
begin
  Result := 0;
end;

function TPoster._Release: Integer;
begin
  Result := 0;
end;

{ TStringPoster }

constructor TStringPoster.Create;
begin
  inherited;
  Prepare;
end;

function TStringPoster.GetFromString(ASource: string): TBaseCollection;
begin
  Result := GetObject(ASource);
end;

function TStringPoster.PostToString(
  ABaseCollection: TBaseCollection): string;
begin
  Result := varAsType(GetPostingData(ABaseCollection), varOleStr);
end;

function TStringPoster.PostToString(ABaseObject: TBaseObject): string;
begin
  Result := varAsType(GetPostingData(ABaseObject), varOleStr);
end;

end.

