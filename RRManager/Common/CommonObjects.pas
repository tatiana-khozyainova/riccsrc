unit CommonObjects;


interface

uses SysUtils, Classes, ClientCommon, ComCtrls, BaseDicts, StringUtils;

// объявления по умолчанию для скважины и коллекции скважин
type
  TWell = class(TCollectionItem)
  protected
    FAreaID:                   integer;
    FWellUIN:                  integer;
    FDepth, FAltitude:         single;
    FAreaName, FWellNum,
    FOldAreaName, FOldWellNum: string;
    procedure   AssignTo(Dest: TPersistent); override; //
  public
    property    OldAreaName: string read FOldAreaName;
    property    OldWellNum: string read FOldWellNum;
    property    WellUIN:  integer read FWellUIN;
    property    AreaName: string read FAreaName;
    property    WellNum:  string read FWellNum;
    property    Altitude: single read FAltitude;
    property    Depth:    single read FDepth;
    function    ListWell: string;
    constructor Create(Collection: TCollection); override; //
    destructor  Destroy; override;                         //
  end;

  PWell = ^TWell;

  TWells = class(TCollection)
  private
    FActiveWell: TWell;
    function GetItem(const Index: integer): TWell;
  public
    property    ActiveWell: TWell read FActiveWell write FActiveWell;
    property    Items[const Index: integer]: TWell read GetItem; default;
    function    WellByName(AWellNum, AAreaName: string): TWell; overload;
    function    WellByName(const AWellNum: string; const AAreaID: integer): TWell; overload;
    function    WellByAltitudeDepth(const AAreaName: string; AAltitude, ADepth: single): TWell;
    function    WellByUIN(const AWellUIN: integer): TWell;
    function    AddWell(AWell: TWell; const Copy: boolean): TWell; overload; virtual;
    function    AddWell(AWellUIN: integer; AAreaName, AWellNum: string; const AAltitude, ADepth: single): TWell; overload; virtual; //
    function    GetFilter: string;
    constructor Create(ItemClass: TCollectionItemClass);
    destructor  Destroy; override;
  end;

  TVisibleWell = class(TWell)
  public
    Item: TObject;
    destructor Destroy; override;
  end;

  TVisibleWells = class(TWells)
  public
    ItemsHolder: TComponent;
    function  AddWell(AWellUIN: integer; AAreaName, AWellNum: string; const AAltitude, ADepth: single): TWell; override;
    constructor Create(AItemsHolder: TComponent);
  end;

implementation

uses Facade;


function    TWell.ListWell: string;
begin
  Result := 'скв. ' + WellNum + ' - ' + AreaName;
  Result := Result + ' альт.: ' + Format('%6.2f', [Altitude]);
  Result := Result + ' забой: ' + Format('%7.2f', [Depth]);
end;

procedure TWell.AssignTo(Dest: TPersistent);
begin
  with Dest as TWell do
  begin
    FAreaID := Self.FAreaID;
    FWellUIN := Self.WellUIN;
    FDepth := Self.Depth;
    FAltitude := Self.Altitude;
    FAreaName := Self.AreaName;
    FWellNum  := Self.WellNum;
    FOldAreaName := Self.OldAreaName;
    FOldWellNum := Self.OldWellNum;
    // копируем коллекцию
  end;
end;

constructor TWell.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  // создаем список коллекционируемых
end;

destructor  TWell.Destroy;
begin
  // уничтожаем список коллекционируемых
  inherited Destroy;
end;

// список скважин
function TWells.GetItem(const Index: integer): TWell;
begin
  Result := TWell(inherited Items[Index]);
end;

function  TWells.GetFilter: string;
var i: integer;
begin
  Result := '';
  for i := 0 to Count - 1 do
    Result := Result + ', ' + IntToStr(Items[i].WellUIN);
  if Result <> '' then
  Result := '(' + copy(Result, 2, Length(Result)) + ')';
end;

function TWells.WellByName(AWellNum, AAreaName: string): TWell;
var i: integer;
begin
  Result := nil;
  AAreaName := ReplaceLatSymbols(AAreaName);
  for i := 0 to Count - 1 do
  if ((Items[i].WellNum = AWellNum) and
     (AnsiUpperCase(Items[i].AreaName) = AAreaName)) or
     ((Items[i].OldWellNum = AWellNum) and
     (ReplaceLatSymbols(Items[i].OldAreaName) = AAreaName)) then
  begin
    Result := Items[i];
    break;
  end;
end;

function TWells.WellByName(const AWellNum: string; const AAreaID: integer): TWell;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if ((Items[i].WellNum = AWellNum) or
     (Items[i].OldWellNum = AWellNum)) and
     (Items[i].FAreaID = AAreaID) then
  begin
    Result := Items[i];
    break;
  end;
end;

function TWells.WellByAltitudeDepth(const AAreaName: string; AAltitude, ADepth: single): TWell;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if (pos(AAreaName, Items[i].AreaName) > 0) and
     (AAltitude = Items[i].Altitude) and
     (ADepth = Items[i].Depth) then
  begin
    Result := Items[i];
    break;
  end;
end;

function TWells.WellByUIN(const AWellUIN: integer): TWell;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].FWellUIN = AWellUIN then
  begin
    Result := Items[i];
    break;
  end;
end;

function    TWells.AddWell(AWell: TWell; const Copy: boolean): TWell;
begin
  if Copy then
  begin
    Result := WellByUIN(AWell.WellUIN);
    if not Assigned(Result) then
    begin
      Result := Add as TWell;
      Result.Assign(AWell);
    end
  end
  else Result := AddWell(AWell.WellUIN, AWell.AreaName, AWell.WellNum, AWell.Altitude, AWell.Depth);
end;

function    TWells.AddWell(AWellUIN: integer; AAreaName, AWellNum: string; const AAltitude, ADepth: single): TWell;
begin
  Result := WellByUIN(AWellUIN);

  // если не нашли
  // спрашиваем в БД и добавляем
  if not Assigned(Result) then
  begin
    Result := Add as TWell;
    with Result do
    begin
      FWellUIN  := AWellUIN;
      FAreaID   := GetObjectID((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_AREA_DICT'].Dict, AAreaName);
      FWellNum  := AWellNum;
      FAreaName := AAreaName;
      FAltitude := AAltitude;
      FDepth    := ADepth;
      FOldAreaName := AAreaName;
      FOldWellNum  := AWellNum;
    end;
  end;

  // наполняем список коллекционируемых
end;

constructor TWells.Create(ItemClass: TCollectionItemClass);
begin
  inherited Create(ItemClass);
end;

destructor  TWells.Destroy;
var i: integer;
begin
  for i := Count - 1 downto 0 do
    Items[i].Free;
  inherited Destroy;
end;

destructor TVisibleWell.Destroy;
begin
  Item.Free;
  inherited Destroy;
end;

constructor TVisibleWells.Create(AItemsHolder: TComponent);
begin
  inherited Create(TVisibleWell);
  ItemsHolder := AItemsHolder;
end;

function  TVisibleWells.AddWell(AWellUIN: integer; AAreaName, AWellNum: string; const AAltitude, ADepth: single): TWell;
var lw: TListView;
    lstItem: TListItem;
    P: PWell;
begin
  Result := inherited AddWell(AWellUIN, AAreaName, AWellNum, AAltitude, ADepth);
  if Assigned(Result) then
  with Result  as TVisibleWell do
  if ItemsHolder is TListView then
  begin
    lw := ItemsHolder as TListView;
    lstItem := lw.Items.Add;
    lstItem.Caption := WellNum;
    lstItem.SubItems.Add(AreaName);
    lstItem.SubItems.Add(Format('%5.2f', [Depth]));
    lstItem.SubItems.Add(Format('%5.2f', [Altitude]));

    lstItem.ImageIndex := 5;
    New(P);
    P^ := Result;
    lstItem.Data := P;
    lstItem.Checked := true;
    Item := TObject(lstItem);
  end;
end;


end.

