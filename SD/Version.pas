unit Version;

interface

uses Classes, BaseObjects, Registrator, SysUtils, ClientType, Contnrs;

type

  TVersion = class(TRegisteredIDObject)
  private
    FVersionReason: string;
    FVersionDate: TDateTime;
    FVersionName: string;
    FClientType: TClientType;
    function GetVersionFinishDate: TDateTime;
    function GetVersionStartDate: TDateTime;
    function GetVersionDate: TDateTime;
    function GetYear: Integer;
  protected
    // присвоить
    procedure AssignTo(Dest: TPersistent); override;
  public
    property VersionName: string read FVersionName write FVersionName;
    property VersionReason: string read FVersionReason write FVersionReason;
    property VersionDate: TDateTime read GetVersionDate write FVersionDate;

    property VersionStartDate: TDateTime read GetVersionStartDate;
    property VersionFinishDate: TDateTime read GetVersionFinishDate;
    property Year: Integer read GetYear;

    property ClientType: TClientType read FClientType write FClientType;

    // в конструкторе создаем пустое хранилище под горизонты, загружаем историю в специальный класс
    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
    // описываем
    function    List(AListOption: TListOption = loBrief): string; override;
  end;

  TVersions = class(TRegisteredIDObjects)
  private
    function GetItems(const Index: integer): TVersion;
  public
    function Add: TVersion; reintroduce; overload;
    property Items[const Index: integer]: TVersion read GetItems;
    constructor Create; override;
  end;

  TStubVersions = class(TVersions)
  public
    constructor Create; override;
  end;

  TVersionObjectSet = class
  private
    FVersion: TVersion;
    FObjectsClassType: TIDObjectsClass;
    procedure SetVersion(const Value: TVersion);
  protected
    FObjects: TIDObjects;
    function GetObjects: TIDObjects;
  public
    property ObjectsClassType: TIDObjectsClass read FObjectsClassType;
    property Version: TVersion read FVersion write SetVersion;
    property Objects: TIDObjects read GetObjects;

    constructor Create (AObjectsClassType: TIDObjectsClass);
    destructor Destroy; override;
  end;

  TVersionObjectSets = class(TObjectList)
  private
    FObjectsClassType: TIDObjectsClass;
    function GetItems(const Index: integer): TVersionObjectSet;
  public
    property Items[const Index: integer]: TVersionObjectSet read GetItems;
    property ObjectsClassType: TIDObjectsClass read FObjectsClassType;
    
    function GetObjectSetByVersion(AVersion: TVersion): TVersionObjectSet;
    function AddObjectSet(AVersion: TVersion): TVersionObjectSet;
    constructor Create(AObjectsClassType: TIDObjectsClass);

  end;

implementation

uses VersionPoster, Facade, DateUtils;

{ TVersion }


procedure TVersion.AssignTo(Dest: TPersistent);
var v: TVersion;
begin
  inherited;
  v := Dest as TVersion;

  v.VersionReason := VersionReason;
  v.VersionDate := VersionDate;
  v.ClientType := ClientType;
end;

constructor TVersion.Create(ACollection: TIDObjects);
begin
  inherited;
  ID := -1;
end;

destructor TVersion.Destroy;
begin
  inherited;
end;



function TVersion.GetVersionDate: TDateTime;
begin
  if ID = 0 then Result := Date
  else Result := FVersionDate;
end;

function TVersion.GetVersionFinishDate: TDateTime;
begin
  Result :=  StrToDate('31.12.' + IntToStr(Year));
end;

function TVersion.GetVersionStartDate: TDateTime;
begin
  Result :=  StrToDate('01.01.' + IntToStr(Year));
end;

function TVersion.GetYear: Integer;
begin
  Result := YearOf(VersionDate);
end;

function TVersion.List(AListOption: TListOption = loBrief): string;
begin
  Result := VersionReason;
end;

{ TVersions }

function TVersions.Add: TVersion;
begin
  Result := inherited Add as TVersion;
end;

constructor TVersions.Create;
begin
  inherited Create;
  FObjectClass := TVersion;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TVersionDataPoster];
  OwnsObjects := true;
end;

function TVersions.GetItems(const Index: integer): TVersion;
begin
  Result := inherited Items[Index] as TVersion;
end;


{ TStubVersions }

constructor TStubVersions.Create;
var v: TVersion;
begin
  inherited;
  v := Add as TVersion;
  v.ID := 0;
  v.VersionName := 'Текущая';
  v.VersionDate := Date;
end;

{ TVersionObjects }

constructor TVersionObjectSet.Create(AObjectsClassType: TIDObjectsClass);
begin
  inherited Create;
  FObjectsClassType := AObjectsClassType;
end;

destructor TVersionObjectSet.Destroy;
begin
  FreeAndNil(FObjects);
  inherited;
end;

function TVersionObjectSet.GetObjects: TIDObjects;
begin
  Assert(Assigned(Version), 'Не задана версия');
  if not Assigned(FObjects) then
  begin
    FObjects := FObjectsClassType.Create;
    FObjects.Owner := Version;
    FObjects.OwnsObjects := true;
    FObjects.Reload('Version_ID = ' + IntToStr(Version.ID));
  end;
  Result := FObjects; 
end;

procedure TVersionObjectSet.SetVersion(const Value: TVersion);
begin
  FVersion := Value;
  FObjects.Owner := FVersion;
end;

{ TVersionObjectSets }

function TVersionObjectSets.AddObjectSet(
  AVersion: TVersion): TVersionObjectSet;
begin
  Result := TVersionObjectSet.Create(FObjectsClassType);
  Result.Version := AVersion;
  inherited Add(Result);
end;

constructor TVersionObjectSets.Create(AObjectsClassType: TIDObjectsClass);
begin
  inherited Create(true);
  FObjectsClassType := AObjectsClassType;
end;

function TVersionObjectSets.GetItems(
  const Index: integer): TVersionObjectSet;
begin
  Result := inherited Items[Index] as TVersionObjectSet;
end;

function TVersionObjectSets.GetObjectSetByVersion(
  AVersion: TVersion): TVersionObjectSet;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if AVersion.ID = Items[i].Version.ID then
  begin
    Result := Items[i];
    break;
  end;

  if not Assigned(Result) then
    Result := AddObjectSet(AVersion);

end;

end.
