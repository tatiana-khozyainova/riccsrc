unit DBGate;

interface

uses SysUtils, Classes, PersistentObjects, BaseObjects, Variants, ComObj,
     ActnList;


type
  EUserUnknownException = class(Exception)
  public
    constructor Create;
  end;

  TImplementedDataPoster = class(TDataPoster)
  protected
    procedure SetFilter(const Value: string); override;
  public

    procedure RestoreState(AState: TDataPosterState); override;
    procedure SaveState(AState: TDataPosterState); override;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TImplementedCommonServerDataSet = class(TCommonServerDataSet)
  private
    FPoster: TImplementedDataPoster;
    procedure SetPoster(const Value: TImplementedDataPoster);
  public
    property Poster: TImplementedDataPoster read FPoster write SetPoster;
  end;

  TAuthorizationMethod = (amInitialize, amEnum);
  

  TDBGates = class(TCommonServerDataSets)
  private
    FAutorized: boolean;
    FEmployeeID: integer;
    FEmployeePriority: integer;
    FEmployeeTabNumber: string;
    FNewAutorizationMode: boolean;
    FServerClassString: string;
    FAuthorizationMethod: TAuthorizationMethod;
    FClientAppTypeID: integer;
    FGroupID: integer;
    FClientName: string;
    function GetItemByPoster(
     ADataPoster: TImplementedDataPoster): TCommonServerDataSet;
    function GetEmployeeName: string;
  public
    property    Autorized: boolean read FAutorized;

    property    EmployeeName: string read GetEmployeeName;
    property    EmployeeID: integer read FEmployeeID write FEmployeeID;
    property    EmployeePriority: integer read FEmployeePriority write FEmployeePriority;
    property    EmployeeTabNumber: string read FEmployeeTabNumber write FEmployeeTabNumber;

    property    ItemByPoster[ADataPoster: TImplementedDataPoster]: TCommonServerDataSet read GetItemByPoster;
    function    Add(ADataPoster: TImplementedDataPoster): TCommonServerDataSet;

    property    ServerClassString: string read FServerClassString write FServerClassString;
    property    NewAutorizationMode: boolean read FNewAutorizationMode write FNewAutorizationMode;
    property    AutorizationMethod: TAuthorizationMethod read FAuthorizationMethod write FAuthorizationMethod;
    property    ClientAppTypeID: integer read FClientAppTypeID write FClientApptypeID;
    property    GroupID: integer read FGroupID write FGroupID;
    property    ClientName: string read FClientName write FClientName;


    procedure   InitializeServer(AUserName, APwd: string);
    procedure   UninitializeServer;

   
    function    ExecuteQuery(const ASQL: string; var AResult: OleVariant; Invert: boolean = false): integer; overload;
    function    ExecuteQuery(const ASQL: string): integer; overload;

    procedure   DeleteFile(const ARemoteFileName: string);
    procedure   DeleteFiles(ARemoteFileNames: TStrings);

    procedure   FetchPriorities(AActnList: TActionList);

    constructor Create(Owner: TComponent); override;
    destructor  Destroy; override;
  end;




implementation

uses Facade, DB;

{ TDBGate }

function TDBGates.Add(ADataPoster: TImplementedDataPoster): TCommonServerDataSet;
var ds: TImplementedCommonServerDataSet;
begin
  try
    ds := ItemByPoster[ADataPoster] as TImplementedCommonServerDataSet;

    if not Assigned(ds) then
    begin
      ds := TImplementedCommonServerDataSet.Create(nil);
      ds.Poster := ADataPoster;
      inherited Add(ds);
    end;
    Result := ds;
  except
    Result := nil;
  end;
end;


constructor TDBGates.Create(Owner: TComponent);
begin
  inherited;

  FAutorized := false;
  FClientName := 'Разработки ТП НИЦ';
end;

procedure TDBGates.DeleteFile(const ARemoteFileName: string);
begin
  Server.DeleteFile(ARemoteFileName);
end;

procedure TDBGates.DeleteFiles(ARemoteFileNames: TStrings);
var i: integer;
begin
  for  i := 0 to ARemoteFileNames.Count - 1 do
    DeleteFile(ARemoteFileNames[i]); 
end;

destructor TDBGates.Destroy;
begin

  inherited;
end;

function TDBGates.ExecuteQuery(const ASQL: string; var AResult: OleVariant; Invert: boolean = false): integer;
begin
  FServer.NeedADORecordset := true;
  Result := FServer.ExecuteQuery(ASQL);
  if Result >= 0 then
    if not Invert then
      AResult := FServer.QueryResult
    else
      AResult := FServer.QueryResultAsADORecordset
end;

function TDBGates.ExecuteQuery(const ASQL: string): integer;
begin
  FServer.NeedADORecordset := true;
  Result := FServer.ExecuteQuery(ASQL);
end;

procedure TDBGates.FetchPriorities(AActnList: TActionList);
var iRemnant: integer;  // остаток
    iPart: integer;     // целая часть
    iPriority: integer; // приоритет текущей операции
    i, j: integer;
begin
  iPart := FEmployeePriority;
  i := 0;

  repeat
    iRemnant := iPart mod 2;
    iPart := iPart div 2;

      // это чтоб math не подключать
    iPriority := iRemnant * round(exp(i * ln(2)));

    if (iPriority > 0) then
    for j := 0 to AActnList.ActionCount-1 do
    begin
      if (AActnList.Actions[j].Tag = iPriority) then
      begin
        (AActnList.Actions[j] as TAction).Visible := true;
        (AActnList.Actions[j] as TAction).Enabled := true;
      end;
    end;
    
    inc(i);
  until (iPart = 0);
end;

function TDBGates.GetEmployeeName: string;
begin
  if not (varIsEmpty(Server) or varIsNull(Server)) then
    Result := Server.EmployeeName;
end;

function TDBGates.GetItemByPoster(
  ADataPoster: TImplementedDataPoster): TCommonServerDataSet;
var i: integer;
    icsd: TImplementedCommonServerDataSet;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  begin
    icsd := Items[i] as TImplementedCommonServerDataSet;

    if icsd.Poster = ADataPoster then
    begin
      Result := Items[i];
      break;
    end;
  end;
end;

procedure TDBGates.InitializeServer(AUserName, APwd: string);
var temp: WordBool;
begin
  if varIsEmpty(FServer) then
    FServer := CreateOleObject(ServerClassString);
  FServer.NewAutorizationMode := NewAutorizationMode;

  if (AutorizationMethod = amInitialize) then
    GroupID := (FServer.InitializeServer(AUserName, APwd, ClientAppTypeID, '', '', '', FEmployeePriority, EmployeeName, FEmployeeID, temp))
  else if (AutorizationMethod = amEnum) then
  begin
    GroupID := FServer.EnumClientTypes(AUserName, APwd);
    FEmployeeID := FServer.ClientEmployeeID;
  end;

  if GroupID >= 0 then
  begin
    FAutorized := true;
    EmployeePriority := FServer.ClientPriority;
  end
  else
  begin
    FAutorized := false;
    varClear(FServer);
    raise EUserUnknownException.Create;
  end;
end;

procedure TDBGates.UninitializeServer;
begin
  FServer := null;
  VarClear(FServer);
  FAutorized := false;
end;

{ TImplementedDataPoster }

constructor TImplementedDataPoster.Create;
begin
  inherited;

end;

function TImplementedDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; 
var ds: TCommonServerDataSet;
begin
  Assert(DataDeletionString <> '', 'Не задан приемник данных ' + ClassName);
  Result := 0;
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  try
    // находим строку соответствующую ключу
    //ds.Refresh;
    ds.First;
    if ds.Locate(ds.KeyFieldNames, AObject.ID, []) then
      ds.Delete
  except
    Result := -1;
  end;
end;

function TImplementedDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TCommonServerDataSet;
begin
  Assert(Trim(DataSourceString) <> '', 'Не задан источник данных для постера ' + ClassName);
  Assert(Trim(FieldNames) <> '', 'Не задан список выбираемых атрибутов ' + ClassName);
  Assert(Trim(KeyFieldNames) <> '', 'Не задан ключевой атрибут ' + ClassName);

  Result := 0;
  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    ds.Filter := AFilter;

    if Assigned (ds) then
    begin
      if ds.Active then ds.Close;
      ds.Open;
      if Assigned(AObjects) then AObjects.NeedsReloading := false;
    end;
    Result := ds.RecordCount;
  except
  on E: Exception do
    begin
      //
    end;
  end;
end;

function TImplementedDataPoster.PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer;
var ds: TCommonServerDataSet;
begin
  Assert(DataPostString <> '', 'Не задан приемник данных ' + ClassName);
  Result := 0;
  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    if not ds.Active then
      ds.Open;

    if ds.Locate(KeyFieldNames, AObject.ID, []) then
      ds.Edit
    else ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;
end;

procedure TImplementedDataPoster.RestoreState(AState: TDataPosterState);
var bChanged: boolean;
    ds: TCommonServerDataSet;
begin
  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    bChanged := false;

    if ds.Filter <> AState.Filter then
    begin
      bChanged := true;

      try
        ds.Filter := AState.Filter;
      except
        ds.Close;
        ds.Open;
        ds.Filter := AState.Filter;
      end;

      try
        ds.Filtered := true;
      except
        ds.Close;
        ds.Open;
        ds.Filtered := true;
      end;
    end;

    if ds.Sort <> AState.Sort then
    begin
      bChanged := true;
      ds.Sort := AState.Sort;
    end;

    if bChanged then
    if ds.Active then ds.Refresh else ds.Open;
  except
    raise;

  end;
end;

procedure TImplementedDataPoster.SaveState(AState: TDataPosterState);
var  ds: TCommonServerDataSet;
begin
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  AState.Filter := ds.Filter;
  AState.Sort := ds.Sort;
end;


procedure TImplementedDataPoster.SetFilter(const Value: string);
var ds: TDataSet;
begin
  if FFilter <> Value then
  begin
    FFilter := Value;

    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    ds.Filter := FFilter;
    ds.Close;
    ds.Open;
  end;
end;

{ TImplementedCommonServerDataSet }

procedure TImplementedCommonServerDataSet.SetPoster(
  const Value: TImplementedDataPoster);
begin
  FPoster := Value;

  DataSourceString := FPoster.DataSourceString;
  DataDeletionString := FPoster.DataDeletionString;
  DataPostString := FPoster.DataPostString;

  Options := FPoster.Options;

  FieldNames := FPoster.FieldNames;
  AccessoryFields := FPoster.AccessoryFieldNames;
  KeyFieldNames := FPoster.KeyFieldNames;

  AutoFillDates := FPoster.AutoFillDates;

  Sort := FPoster.Sort;

  PageSize := FPoster.PageSize;

  DatasetIdent := DataSourceString;
end;

{ EUserUnknownException }

constructor EUserUnknownException.Create;
begin
  Message := 'Имя пользователя и пароль не опознаны системой. Пожалуйста, попробуйте авторизоваться ещё раз.';
end;

end.

