unit PetrolRegion;

interface

uses Registrator, Classes, BaseObjects, ParentedObjects;

type
  TPetrolRegionType = (prtNGP, prtNGO, prtNGR);
  TPetrolRegion = class;
  TPetrolRegions = class;


  TPetrolRegion = class(TRegisteredIDObject, IParentChild)
  private
    FRegionType: TPetrolRegionType;
    FSubRegions: TPetrolRegions;
    FMainPetrolRegionID: integer;
  protected
    procedure AssignTo(Dest: TPersistent); override;
    function    _AddRef: integer; stdcall;
    function    _Release: Integer; stdcall;

    function    GetChildren: TIDObjects;
    function    GetParent: TIDObject;
    function    GetMe: TIDObject;
    function    GetChildAsParent(const Index: integer): IParentChild;

    function GetSubRegions: TPetrolRegions; virtual;
    function GetMainPetrolRegion: TPetrolRegion; virtual;
  public
    property MainPetrolRegion: TPetrolRegion read GetMainPetrolRegion;
    property MainPetrolRegionID: integer read FMainPetrolRegionID write FMainPetrolRegionID;
    property RegionType: TPetrolRegionType read FRegionType write FRegionType;
    property SubRegions: TPetrolRegions read GetSubregions;

    function GetNextWellPassportNumber: integer;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TPetrolRegions = class(TRegisteredIDObjects)
  private
    FPlainList: TPetrolRegions;
    function GetItems(Index: integer): TPetrolRegion;
    function GetPlaintList: TPetrolRegions;
  public
    property PlainList: TPetrolRegions read GetPlaintList;

    procedure MakeRegionTypedList(ALst: TStrings; ARegionType: TPetrolRegionType; NeedsRegistering: boolean = true; NeedsClearing: boolean = true);

    property Items[Index: integer]: TPetrolRegion read GetItems;
    constructor Create; override;
  end;

  TNewPetrolRegion = class(TPetrolRegion)
  private
    FOldRegionID: Integer;
  protected
    procedure AssignTo(Dest: TPersistent); override;
    function GetSubRegions: TPetrolRegions; override;
    function GetMainPetrolRegion: TPetrolRegion; override;
  public
    property    OldRegionID: Integer read FOldRegionID write FOldRegionID;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TNewPetrolRegions = class(TPetrolRegions)
  private
    function GetItems(Index: integer): TNewPetrolRegion;
  public
    property Items[Index: integer]: TNewPetrolRegion read GetItems;
    constructor Create; override;
  end;

implementation

uses Facade, PetrolRegionDataPoster, SysUtils;

{ TPetrolRegion }

procedure TPetrolRegion.AssignTo(Dest: TPersistent);
var o : TPetrolRegion;
begin
  inherited;
  o := Dest as TPetrolRegion;

  o.RegionType := RegionType;
  o.MainPetrolRegionID := MainPetrolRegionID;
end;

constructor TPetrolRegion.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Õ√œ, Õ√Œ, Õ√–';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TPetrolRegionDataPoster];
end;

function TPetrolRegion.GetChildAsParent(
  const Index: integer): IParentChild;
begin
  Result := SubRegions.Items[Index];
end;

function TPetrolRegion.GetChildren: TIDObjects;
begin
  Result := SubRegions;
end;

function TPetrolRegion.GetMainPetrolRegion: TPetrolRegion;
begin
  Result := TMainFacade.GetInstance.AllPetrolRegions.ItemsByID[MainPetrolRegionID] as TPetrolRegion;
end;

function TPetrolRegion.GetMe: TIDObject;
begin
  Result := Self;
end;

function TPetrolRegion.GetNextWellPassportNumber: integer;
var vResult: OleVariant;
begin
  Result := 0;
  if TMainFacade.GetInstance.DBGates.Server.ExecuteQuery('select max (v.vch_passport_num) from vw_well_coord v where v.petrol_region_id = ' + IntToStr(ID) + ' and v.num_region_type = 3') > 0 then
  begin
    vResult := TMainFacade.GetInstance.DBGates.Server.QueryResult;
    try
      Result := vResult[0, 0] + 1;
    except

    end;
  end
end;

function TPetrolRegion.GetParent: TIDObject;
begin
  Result := MainPetrolRegion; 
end;

function TPetrolRegion.GetSubregions: TPetrolRegions;
var i: integer;
begin
  if not Assigned(FSubRegions) then
  begin
    FSubRegions := TPetrolRegions.Create;
    FSubRegions.OwnsObjects := true;
    FSubRegions.Owner := Self;
    TMainFacade.GetInstance.AllPetrolRegions.OwnsObjects := false;

    for i := 0 to TMainFacade.GetInstance.AllPetrolRegions.Count - 1 do
    if TMainFacade.GetInstance.AllPetrolRegions.Items[i].MainPetrolRegionID = ID then
    begin
      FSubRegions.Add(TMainFacade.GetInstance.AllPetrolRegions.Items[i], false, false);
      TMainFacade.GetInstance.AllPetrolRegions.Items[i].ReassignCollection(FSubRegions);
    end;
  end;

  Result := FSubRegions;
end;

function TPetrolRegion._AddRef: integer;
begin
  Result := -1;
end;

function TPetrolRegion._Release: Integer;
begin
  Result := -1;
end;

{ TPetrolRegions }

constructor TPetrolRegions.Create;
begin
  inherited;
  FObjectClass := TPetrolRegion;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TPetrolRegionDataPoster];
end;

function TPetrolRegions.GetItems(Index: integer): TPetrolRegion;
begin
  Result := inherited Items[Index] as TPetrolRegion;
end;

function TPetrolRegions.GetPlaintList: TPetrolRegions;
var i: integer;
begin
  if not Assigned(FPlainList) then
  begin
    FPlainList := TPetrolRegions.Create;
    FPlainList.OwnsObjects := false;
    FPlainList.AddObjects(Self, false, False);

    for i := 0 to Count - 1 do
      FPlainList.AddObjects(Items[i].SubRegions.PlainList, false, false);
  end;

  Result := FPlainList;  
end;

procedure TPetrolRegions.MakeRegionTypedList(ALst: TStrings; ARegionType: TPetrolRegionType;
  NeedsRegistering, NeedsClearing: boolean);
var i: integer;
begin
  if NeedsClearing then Clear;

  for i := 0 to Count - 1 do
  if Items[i].RegionType = ARegionType then
    ALst.AddObject(Items[i].List, Items[i])
end;

{ TNewPetrolRegion }

procedure TNewPetrolRegion.AssignTo(Dest: TPersistent);
var o : TNewPetrolRegion;
begin
  inherited;
  o := Dest as TNewPetrolRegion;

  o.OldRegionID := OldRegionID;
end;

constructor TNewPetrolRegion.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'ÕÓ‚˚È Õ√œ, Õ√Œ, Õ√–';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TNewPetrolRegionDataPoster];
end;

function TNewPetrolRegion.GetMainPetrolRegion: TPetrolRegion;
begin
  Result := TMainFacade.GetInstance.AllNewPetrolRegions.ItemsByID[MainPetrolRegionID] as TNewPetrolRegion;
end;

function TNewPetrolRegion.GetSubRegions: TPetrolRegions;
var i: integer;
begin
  if not Assigned(FSubRegions) then
  begin
    FSubRegions := TNewPetrolRegions.Create;
    FSubRegions.OwnsObjects := true;
    FSubRegions.Owner := Self;
    TMainFacade.GetInstance.AllNewPetrolRegions.OwnsObjects := false;

    for i := 0 to TMainFacade.GetInstance.AllNewPetrolRegions.Count - 1 do
    if TMainFacade.GetInstance.AllNewPetrolRegions.Items[i].MainPetrolRegionID = ID then
    begin
      FSubRegions.Add(TMainFacade.GetInstance.AllNewPetrolRegions.Items[i], false, false);
      TMainFacade.GetInstance.AllNewPetrolRegions.Items[i].ReassignCollection(FSubRegions);
    end;
  end;

  Result := FSubRegions;
end;

{ TNewPetrolRegions }

constructor TNewPetrolRegions.Create;
begin
  inherited;
  FObjectClass := TNewPetrolRegion;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TNewPetrolRegionDataPoster];
end;

function TNewPetrolRegions.GetItems(Index: integer): TNewPetrolRegion;
begin
  Result := inherited Items[index] as TNewPetrolRegion;
end;

end.
