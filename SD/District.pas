unit District;

interface

uses BaseObjects, Classes, Registrator, ParentedObjects;

type

  TDistrictType = (dtState, dtRegion, dtSubRegion);
  TDistricts = class;
  TDistrict = class;

  // организация
  TDistrict = class (TRegisteredIDObject, IParentChild)
  private
    FMainDistrictID: integer;
    FSubDistricts: TDistricts;
    FDistrictType: TDistrictType;
    function GetSubDistricts: TDistricts;
    function GetMainDistrict: TDistrict;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
    function    _AddRef: integer; stdcall;
    function    _Release: Integer; stdcall;

    function    GetChildren: TIDObjects;
    function    GetParent: TIDObject;
    function    GetMe: TIDObject;
    function    GetChildAsParent(const Index: integer): IParentChild;
  public
    property    MainDistrictID: integer read FMainDistrictID write FMainDistrictID;
    property    DistrictType: TDistrictType read FDistrictType write FDistrictType;
    property    SubDistricts: TDistricts read GetSubDistricts;
    property    MainDistrict: TDistrict read GetMainDistrict;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TDistricts = class(TRegisteredIDObjects)
  private
    FPlainList: TDistricts;
    function GetItems(Index: Integer): TDistrict;
    function GetPlaintList: TDistricts;
  public
    procedure Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property Items[Index: Integer]: TDistrict read GetItems;
    property PlainList: TDistricts read GetPlaintList;

    procedure MakeDistrictTypedList(ALst: TStrings; ADistrictType: TDistrictType; NeedsRegistering: boolean = true; NeedsClearing: boolean = true);


    constructor Create; override;
  end;


implementation

uses DistrictPoster, Facade, BaseFacades, SDFacade;

{ TDistricts }

procedure TDistricts.Assign(Sourse: TIDObjects; NeedClearing: boolean);
begin
  inherited;

end;

constructor TDistricts.Create;
begin
  inherited;
  FObjectClass := TDistrict;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TDistrictDataPoster];
end;

function TDistricts.GetItems(Index: Integer): TDistrict;
begin
  Result := inherited Items[Index] as TDistrict;
end;

function TDistricts.GetPlaintList: TDistricts;
var i: integer;
begin
  if not Assigned(FPlainList) then
  begin
    FPlainList := TDistricts.Create;
    FPlainList.OwnsObjects := false;
    FPlainList.AddObjects(Self, false, False);

    for i := 0 to Count - 1 do
      FPlainList.AddObjects(Items[i].SubDistricts.PlainList, false, false);
  end;

  Result := FPlainList;
end;

procedure TDistricts.MakeDistrictTypedList(ALst: TStrings;
  ADistrictType: TDistrictType; NeedsRegistering, NeedsClearing: boolean);
var i: integer;
begin
  if NeedsClearing then Clear;

  for i := 0 to Count - 1 do
  if Items[i].DistrictType = ADistrictType then
    ALst.AddObject(Items[i].List, Items[i])
end;

{ TDistrict }

procedure TDistrict.AssignTo(Dest: TPersistent);
var o: TDistrict;
begin
  inherited;
  o := Dest as TDistrict;

  o.MainDistrictID := MainDistrictID;
  o.DistrictType := DistrictType;
end;

constructor TDistrict.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Административный район';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TDistrictDataPoster];
end;

function TDistrict._AddRef: integer;
begin
  Result := -1;
end;

function TDistrict._Release: Integer;
begin
  Result := -1;
end;

function TDistrict.GetChildAsParent(const Index: integer): IParentChild;
begin
  Result := SubDistricts.Items[Index];
end;

function TDistrict.GetChildren: TIDObjects;
begin
  Result := SubDistricts;
end;

function TDistrict.GetMe: TIDObject;
begin
  Result := Self;
end;

function TDistrict.GetParent: TIDObject;
begin
  result := MainDistrict;
end;

function TDistrict.GetSubDistricts: TDistricts;
var i: integer;
begin
  if not Assigned(FSubDistricts) then
  begin
    FSubDistricts := TDistricts.Create;
    FSubDistricts.OwnsObjects := true;
    FSubDistricts.Owner := Self;
    TMainFacade.GetInstance.AllDistricts.OwnsObjects := false;

    for i := 0 to TMainFacade.GetInstance.AllDistricts.Count - 1 do
    if TMainFacade.GetInstance.AllDistricts.Items[i].MainDistrictID = ID then
    begin
      FSubDistricts.Add(TMainFacade.GetInstance.AllDistricts.Items[i], false, false);
      TMainFacade.GetInstance.AllDistricts.Items[i].ReassignCollection(FSubDistricts);
    end;
  end;

  Result := FSubDistricts;
end;

function TDistrict.GetMainDistrict: TDistrict;
begin
  Result := TMainFacade.GetInstance.AllDistricts.ItemsByID[MainDistrictID] as TDistrict;
end;

end.
