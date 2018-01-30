unit SlottingPlacement;

interface

uses Registrator, BaseObjects, Classes, ParentedObjects,
     Graphics, PictureObject, SysUtils, ComCtrls, Organization;

type
  TPartPlacementType = class;
  TPartPlacementTypes = class;
  TPartPlacement = class;
  TPartPlacements = class;
  TBox = class;
  TBoxes = class;
  TCoreLibrary = class;
  TRack = class;
  TRacks = class;

  TRack = class(TRegisteredIDObject)
  private
    FBoxes: TBoxes;
    function GetPartPlacement: TPartPlacement;
  protected
    function GetBoxes: TBoxes; virtual;
  public
    property Boxes: TBoxes read GetBoxes;
    property PartPlacement: TPartPlacement read GetPartPlacement;
    constructor Create(ACollection: TIDObjects); override;
    destructor Destroy; override;
  end;

  TNullRack = class(TRack)
  protected
    function GetBoxes: TBoxes; override;  
  public
    class function GetInstance: TNullRack; reintroduce;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TRacks = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TRack;
  public
    property Items[Index: integer]: TRack read GetItems;
    constructor Create; override;
  end;

  TPartPlacementType = class(TRegisteredIDObject)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TPartPlacementTypes = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TPartPlacementType;
  public
    property Items[Index: integer]: TPartPlacementType read GetItems;
    constructor Create; override;
  end;

  TPartPlacement = class(TRegisteredIDObject, IParentChild)
  private
    FBoxes: TBoxes;
    FPartPlacementType: TPartPlacementType;
    FPartPlacements: TPartPlacements;
    FMainPlacementID: integer;
    FRacks: TRacks;
    function GetMainPlacement: TPartPlacement;
    function GetBoxes: TBoxes;
    function GetCoreLibrary: TCoreLibrary;
    function GetRacks: TRacks;
  protected
    function    GetChildren: TIDObjects;
    function    GetParent: TIDObject;
    function    GetMe: TIDObject;
    function    GetChildAsParent(const Index: integer): IParentChild;
    function    GetPartPlacements: TPartPlacements; virtual;
    procedure   AssignTo(Dest: TPersistent); override;
    function    _AddRef: integer; stdcall;
    function    _Release: Integer; stdcall;
  public

    property PartPlacements: TPartPlacements read GetPartPlacements;
    property PartPlacementType: TPartPlacementType read FPartPlacementType write FPartPlacementType;
    property MainPlacementID: integer read FMainPlacementID write FMainPlacementID;
    property MainPlacement: TPartPlacement read GetMainPlacement;

    property Racks: TRacks read GetRacks;
    property CoreLibrary: TCoreLibrary read GetCoreLibrary;

    property    Boxes: TBoxes read GetBoxes;
    procedure   ClearBoxes; 

    function    Update(ACollection: TIDObjects = nil): integer; override;
    function    List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TPartPlacements = class(TRegisteredIDObjects)
  private
    FCoreLibrary: TCoreLibrary;
    function GetItems(Index: integer): TPartPlacement;
  public
    property CoreLibrary: TCoreLibrary read FCoreLibrary;
    property Items[Index: integer]: TPartPlacement read GetItems;
    constructor Create; override;
  end;

  TCoreLibrary = class(TPartPlacement)
  private
    FPartPlacementPlainList, FOldPlacementPlainList, FNewPlacementPlainList, FOldMainPlacementPlainList: TPartPlacements;

    procedure LoadPlainPartPlacements(APartPlacements: TPartPlacements);
    function  GetPartPlacementsPlainList: TPartPlacements;
    function  GetMainGarage: TPartPlacement;
    function  GetNewPlacementPlainList: TPartPlacements;
    function  GetOldPlacementPlainList: TPartPlacements;
    function  GetOldMainPlacementPlainList: TPartPlacements;
  protected
    function  GetPartPlacements: TPartPlacements; override;
  public
    property    PartPlacementPlainList: TPartPlacements read GetPartPlacementsPlainList;
    property    OldPlacementPlainList: TPartPlacements read GetOldPlacementPlainList;
    property    OldMainPlacementPlainList: TPartPlacements read GetOldMainPlacementPlainList;
    property    NewPlacementPlainList: TPartPlacements read GetNewPlacementPlainList;
    property    MainGarage: TPartPlacement read GetMainGarage;
    constructor Create; reintroduce;
    destructor  Destroy; override;
  end;


  TSlottingPlacement = class(TRegisteredIDObject)
  private
    FBoxCount: integer;
    FFinalBoxCount: integer;
    FOwnerPartPlacement: string;
    FStatePartPlacement: TPartPlacement;
    FBoxes: TBoxes;
    FSampleBoxNumbers: string;
    FOrganization: TOrganization;
    FRackList: string;
    FRackListWithGenSection: string;
    FCoreFinalYield: Single;
    FCoreYield: Single;
    FCoreYieldGenSection: Single;
    FCoreFinalYieldGenSection: Single;
    FFinalBoxCountWithGenSection: integer;
    FTransferHistory: string;
    FLastCoreTransferTask: TIDObject;
    FLastCoreTransfer: TIDObject;
    function GetBoxUINs: string;
    function GetBoxes: TBoxes;
    function GetCoreFinalYield: Single;
    function GetCoreFinalYieldGenSection: Single;
    function GetCoreYield: Single;
    function GetCoreYieldGenSection: Single;
    function GetFinalBoxCount: integer;
    function GetFinalBoxCountWithGenSection: integer;
    function GetRackList: string;
    function GetRackListWithGenSection: string;
    function GetBoxesLoaded: boolean;
    function QueryRackList(UseGenSection: Boolean): string;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property StatePartPlacement: TPartPlacement read FStatePartPlacement write FStatePartPlacement;
    property OwnerPartPlacement: string read FOwnerPartPlacement write FOwnerPartPlacement;
    property BoxCount: integer read FBoxCount write FBoxCount;

    property FinalBoxCount: integer read GetFinalBoxCount write FFinalBoxCount;
    property FinalBoxCountWithGenSection: integer read GetFinalBoxCountWithGenSection write FFinalBoxCountWithGenSection;

    property CoreFinalYield: Single read GetCoreFinalYield write FCoreFinalYield;
    property CoreYield: Single read GetCoreYield write FCoreYield;
    property CoreFinalYieldWithGenSection: Single read GetCoreFinalYieldGenSection write FCoreFinalYieldGenSection;
    property CoreYieldWithGenSection: Single read GetCoreYieldGenSection write FCoreYieldGenSection;
    property TransferHistory: string read FTransferHistory write FTransferHistory;
    property LastCoreTransferTask: TIDObject read FLastCoreTransferTask write FLastCoreTransferTask;
    property LastCoreTransfer: TIDObject read FLastCoreTransfer write FLastCoreTransfer;


    property SampleBoxNumbers: string read FSampleBoxNumbers write FSampleBoxNumbers;
    property Organization: TOrganization read FOrganization write FOrganization;

    property RackList: string read GetRackList write FRackList;
    property RackListWithGenSection: string read GetRackListWithGenSection write FRackListWithGenSection;

    property Boxes: TBoxes read GetBoxes;
    property BoxesLoaded: boolean read GetBoxesLoaded;

    function    Update(ACollection: TIDObjects = nil): integer; override;
    function    List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;



  TSlottingPlacements = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TSlottingPlacement;
  public
    property Items[Index: integer]: TSlottingPlacement read GetItems;
    constructor Create; override;
  end;


  EBoxPhotoNotAvailable = class(Exception)
  public
    constructor Create;
  end;

  TPictureFileType = (pftJPG, pftCDR, pftUnk);
  TCorePhotoType = (cptNormal, cptUv);

  TBoxPicture = class(TRegisteredIDObject)
  private
    FRemotePath: string;
    FLocalPath: string;
    FRemoteName: string;
    function  GetPictureFileType: TPictureFileType;
    procedure SetLocalPath(const Value: string);
    function  GetCorePhotoType: TCorePhotoType;
    function  GetLocalName: string;
    procedure SetLocalName(const Value: string);
    function GetRemoteFullName: string;
    function GetLocalFullName: string;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property    RemotePath: string read FRemotePath;
    property    RemoteName: string read FRemoteName write FRemoteName;
    property    RemoteFullName: string read GetRemoteFullName;

    property    LocalPath: string read FLocalPath write SetLocalPath;
    property    LocalName: string read GetLocalName write SetLocalName;
    property    LocalFullName: string read GetLocalFullName;

    property    PictureFileType: TPictureFileType read GetPictureFileType;
    property    CorePhotoType: TCorePhotoType read GetCorePhotoType;

    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TBoxPictures = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TBoxPicture;
  public
    property    Items[Index: integer]: TBoxPicture read GetItems;
    constructor Create; override;
  end;

  TBox = class(TRegisteredIDObject)
  private
    FSlottings: TIDObjects;
    FBoxPictures: TBoxPictures;
    function  GetBoxNumber: string;
    procedure SetBoxNumber(const Value: string);
    function  GetSlottings: TIDObjects;
    function  GetBoxPictures: TBoxPictures;
    function  GetBoxPicture: TBoxPicture;
    function GetHasPicture: boolean;
  protected
    procedure AssignTo(Dest: TPersistent); override;
    function  GetRack: TRack; virtual;
    procedure SetRack(const Value: TRack); virtual;
  public
    property BoxNumber: string read GetBoxNumber write SetBoxNumber;
    property Rack: TRack read GetRack write SetRack;



    property    DefaultBoxPicture: TBoxPicture read GetBoxPicture;
    property    BoxPictures: TBoxPictures read GetBoxPictures write FBoxPictures;
    procedure   ClearBoxPictures;
    property    HasPicture: boolean read GetHasPicture;

    property    Slottings: TIDObjects read GetSlottings;

    function    Update(ACollection: TIDObjects = nil): integer; override;
    function    List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TBoxes = class(TRegisteredIDObjects)
  private
    FRacks: TRacks;
    function GetItems(Index: integer): TBox;
    function GetRacks: TRacks;
  public
    property    Racks: TRacks read GetRacks;
    procedure   SortByNumbers;
    procedure   MakeList(AListItems: TListItems; NeedsRegistering: boolean = true; NeedsClearing: boolean = false); override;
    property    Items[Index: integer]: TBox read GetItems;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TWellBox = class(TBox)
  private
    FRack: TRack;
  protected
    function  GetRack: TRack; override;
    procedure SetRack(const Value: TRack); override;
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TWellBoxes = class(TBoxes)
  private
    function GetItems(Index: integer): TWellBox;
  public
    property    Items[Index: integer]: TWellBox read GetItems;
    constructor Create; override;
  end;

  TSlottingBox = class(TWellBox)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TSlottingBoxes = class(TBoxes)
  private
    function GetItems(Index: integer): TSlottingBox;
  public
    property    Items[Index: integer]: TSlottingBox read GetItems;
    constructor Create; override;
  end;

  TPlacementQuality = class(TIDObject)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TPlacementQualities = class(TIDObjects)
  private
    function GetItems(Index: integer): TPlacementQuality;
  public
    property    Items[Index: integer]: TPlacementQuality read GetItems;
    constructor Create; override;
  end;




implementation

uses SlottingPlacementDataPoster, Facade, Slotting, VarFileUtils, Math, BaseConsts, Variants, SlottingWell;

{ TPartPlacementType }

function SortByWellNumbers(Item1, Item2: Pointer): integer;
var iNumber1, iNumber2: integer;
begin
  try
    iNumber1 := StrToInt(TBox(Item1).BoxNumber);
    iNumber2 := StrToInt(TBox(Item2).BoxNumber);
    Result := CompareValue(iNumber1, iNumber2);
  except
    Result := CompareStr(TBox(Item1).BoxNumber, TBox(Item2).BoxNumber);
  end;
end;



constructor TPartPlacementType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип местоположения керна';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TPartPlacementTypeDataPoster];
end;

{ TPartPlacement }


procedure TPartPlacement.AssignTo(Dest: TPersistent);
var pp: TPartPlacement;
begin
  inherited;
  pp := Dest as TPartPlacement;
  pp.PartPlacementType := PartPlacementType;
  pp.MainPlacementID := MainPlacementID;
end;

procedure TPartPlacement.ClearBoxes;
begin
  FreeAndNil(FBoxes);
end;

constructor TPartPlacement.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Местоположение керна';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TPartPlacementTypeDataPoster];
end;

destructor TPartPlacement.Destroy;
begin
  if Assigned(FBoxes) then FBoxes.Free;
  if Assigned(FPartPlacements) then FPartPlacements.Free;
  if Assigned(FRacks) then FRacks.Free;
  inherited;
end;

function TPartPlacement.GetBoxes: TBoxes;
begin
  if not Assigned(FBoxes) then
  begin
    FBoxes := TBoxes.Create;
    FBoxes.OwnsObjects := true;
    FBoxes.Reload('Part_Placement_ID = ' + IntToStr(ID));
  end;

  Result := FBoxes;
end;

function TPartPlacement.GetChildAsParent(const Index: integer): IParentChild;
begin
  Result := PartPlacements.Items[Index];
end;

function TPartPlacement.GetChildren: TIDObjects;
begin
  Result := PartPlacements;
end;


function TPartPlacement.GetCoreLibrary: TCoreLibrary;
begin
  Result := (Collection as TPartPlacements).CoreLibrary;
end;

function TPartPlacement.GetMainPlacement: TPartPlacement;
begin
  Result := nil;
  if Assigned(Collection) and (Collection.Owner is TPartPlacement) then
    Result := Collection.Owner as TPartPlacement;
end;

function TPartPlacement.GetMe: TIDObject;
begin
  Result := Self;
end;

function TPartPlacement.GetParent: TIDObject;
begin
  Result := MainPlacement;
end;

function TPartPlacement.GetPartPlacements: TPartPlacements;
var i: integer;
begin
  if not Assigned(FPartPlacements) then
  begin
    FPartPlacements := TPartPlacements.Create;
    FPartPlacements.Owner := Self;
    FPartPlacements.OwnsObjects := true;
    FPartPlacements.FCoreLibrary := CoreLibrary; 

    for i := 0 to CoreLibrary.PartPlacementPlainList.Count - 1 do
    if CoreLibrary.PartPlacementPlainList.Items[i].MainPlacementID = ID then
      FPartPlacements.Add(CoreLibrary.PartPlacementPlainList.Items[i], false, true);
  end;

  Result := FPartPlacements;
end;

function TPartPlacement.GetRacks: TRacks;
begin
  if not Assigned(FRacks) then
  begin
    FRacks := TRacks.Create;
    FRacks.OwnsObjects := true;

    FRacks.Reload('PART_PLACEMENT_ID = ' + IntToStr(ID));
  end;

  result := FRacks;
end;

function TPartPlacement.List(AListOption: TListOption): string;
begin
  if Assigned(MainPlacement) then
  begin
    if MainPlacement.ID <> CoreLibrary.ID then
      Result := MainPlacement.List(AListOption) + '\' + inherited List(AListOption)
    else
      Result := inherited List(AListOption);
  end
  else
    Result := inherited List(AListOption);
end;

function TPartPlacement.Update(ACollection: TIDObjects = nil): integer;
begin
  Result := inherited Update;
  PartPlacements.Update(nil);
end;

function TPartPlacement._AddRef: integer;
begin
  Result := -1;
end;

function TPartPlacement._Release: Integer;
begin
  Result := -1;
end;

{ TPartPlacementTypes }

constructor TPartPlacementTypes.Create;
begin
  inherited;

  FObjectClass := TPartPlacementType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TPartPlacementTypeDataPoster];
end;

function TPartPlacementTypes.GetItems(Index: integer): TPartPlacementType;
begin
  Result := inherited Items[Index] as TPartPlacementType;
end;

{ TPartPlacements }

constructor TPartPlacements.Create;
begin
  inherited;

  FObjectClass := TPartPlacement;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TPartPlacementDataPoster];
end;

function TPartPlacements.GetItems(Index: integer): TPartPlacement;
begin
  Result := inherited Items[Index] as TPartPlacement;
end;

{ TCoreLibrary }

constructor TCoreLibrary.Create;
begin
  inherited Create(nil);
  Name := 'Кернохранилище';
end;

destructor TCoreLibrary.Destroy;
begin
  if Assigned(FPartPlacementPlainList) then FPartPlacementPlainList.Free;
  FreeAndNil(FNewPlacementPlainList);
  FreeAndNil(FOldPlacementPlainList);
  inherited;
end;

function TCoreLibrary.GetMainGarage: TPartPlacement;
begin
  Result := PartPlacements.ItemsByID[CORE_MAIN_GARAGE_ID] as TPartPlacement;
end;

function TCoreLibrary.GetNewPlacementPlainList: TPartPlacements;
var i: Integer;
begin
  if not Assigned(FNewPlacementPlainList) then
  begin
    FNewPlacementPlainList := TPartPlacements.Create;
    FNewPlacementPlainList.OwnsObjects := False;
    FNewPlacementPlainList.FCoreLibrary := Self;

    for i := 0 to PartPlacementPlainList.Count - 1 do
    if (((PartPlacementPlainList.Items[i].ID = GARAGE_PART_PLACEMENT_ID) or (PartPlacementPlainList.Items[i].ID = BASEMENT_PART_PLACEMENT_ID))
    or (((PartPlacementPlainList.Items[i].MainPlacementID = GARAGE_PART_PLACEMENT_ID) or (PartPlacementPlainList.Items[i].MainPlacementID = BASEMENT_PART_PLACEMENT_ID)))) then
      FNewPlacementPlainList.Add(PartPlacementPlainList.Items[i], false, False)
  end;

  Result := FNewPlacementPlainList;
end;

function TCoreLibrary.GetOldMainPlacementPlainList: TPartPlacements;
var i: integer;
begin
  if not Assigned(FOldMainPlacementPlainList) then
  begin
    FOldMainPlacementPlainList := TPartPlacements.Create;
    FOldMainPlacementPlainList.OwnsObjects := False;
    FOldMainPlacementPlainList.FCoreLibrary := Self;

    for i := 0 to OldPlacementPlainList.Count - 1 do
    if (OldPlacementPlainList.Items[i].MainPlacementID = 0) then
      FOldMainPlacementPlainList.Add(OldPlacementPlainList.Items[i], false, False)

  end;

  Result := FOldMainPlacementPlainList;
end;

function TCoreLibrary.GetOldPlacementPlainList: TPartPlacements;
var i: Integer;
begin
  if not Assigned(FOldPlacementPlainList) then
  begin
    FOldPlacementPlainList := TPartPlacements.Create;
    FOldPlacementPlainList.OwnsObjects := False;
    FOldPlacementPlainList.FCoreLibrary := Self;

    for i := 0 to PartPlacementPlainList.Count - 1 do
    if not(((PartPlacementPlainList.Items[i].ID = GARAGE_PART_PLACEMENT_ID) or (PartPlacementPlainList.Items[i].ID = BASEMENT_PART_PLACEMENT_ID))
    or (((PartPlacementPlainList.Items[i].MainPlacementID = GARAGE_PART_PLACEMENT_ID) or (PartPlacementPlainList.Items[i].MainPlacementID = BASEMENT_PART_PLACEMENT_ID)))) then
      FOldPlacementPlainList.Add(PartPlacementPlainList.Items[i], false, False)

  end;

  Result := FOldPlacementPlainList;
end;

function TCoreLibrary.GetPartPlacements: TPartPlacements;
var i: integer;
begin
  if not Assigned(FPartPlacements) then
  begin
    FPartPlacements := TPartPlacements.Create;
    FPartPlacements.Owner := Self;
    FPartPlacements.OwnsObjects := true;
    FPartPlacements.FCoreLibrary := Self;

    for i := 0 to PartPlacementPlainList.Count - 1 do
    if PartPlacementPlainList.Items[i].MainPlacementID = ID then
    begin
      PartPlacementPlainList.Items[i].ReassignCollection(FPartPlacements);
      FPartPlacements.Add(PartPlacementPlainList.Items[i], false, true);
    end;
  end;

  Result := FPartPlacements;
end;

function TCoreLibrary.GetPartPlacementsPlainList: TPartPlacements;
begin
  if not Assigned(FPartPlacementPlainList) then
  begin
    FPartPlacementPlainList := TPartPlacements.Create;
    FPartPlacementPlainList.OwnsObjects := false;
    FPartPlacementPlainList.Reload('PART_PLACEMENT_ID > 0', true);
    FPartPlacementPlainList.FCoreLibrary := Self;

    if (Self is TCoreLibrary) then
    if Assigned(OnInitCollectionDataLoading) then
      OnInitCollectionDataLoading(FPartPlacementPlainList);
  end;

  Result := FPartPlacementPlainList;
end;

procedure TCoreLibrary.LoadPlainPartPlacements(APartPlacements: TPartPlacements);
var i: integer;
begin

  for i := 0 to APartPlacements.Count - 1 do
  begin
    FPartPlacementPlainList.Add(APartPlacements.Items[i]);
    LoadPlainPartPlacements(APartPlacements.Items[i].PartPlacements);
    if (Self is TCoreLibrary) then
    begin
      if Assigned(OnInitCollectionDataLoading) then
        OnLoadCollectionDataItem(APartPlacements)
    end;
  end;
end;

{ TSlottingPlacement }

procedure TSlottingPlacement.AssignTo(Dest: TPersistent);
var sp: TSlottingPlacement;
begin
  inherited;

  sp := Dest as TSlottingPlacement;
  sp.BoxCount := BoxCount;
  sp.FinalBoxCount := FinalBoxCount;
  sp.OwnerPartPlacement := OwnerPartPlacement;
  sp.StatePartPlacement := StatePartPlacement;
  sp.Organization := Organization;
  sp.RackList := RackList;
  sp.RackListWithGenSection := RackListWithGenSection;
  sp.CoreFinalYield := CoreFinalYield;
  sp.CoreYield := CoreYield;
  sp.CoreYieldWithGenSection := CoreYieldWithGenSection;
  sp.CoreFinalYieldWithGenSection := CoreFinalYieldWithGenSection;
  sp.FinalBoxCountWithGenSection := FinalBoxCountWithGenSection;
  sp.TransferHistory := TransferHistory;
  sp.LastCoreTransferTask := LastCoreTransferTask;
  sp.LastCoreTransfer := LastCoreTransfer;
end;

constructor TSlottingPlacement.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Местоположение долбления';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSlottingPlacementDataPoster];
  FBoxes := nil;
end;

destructor TSlottingPlacement.Destroy;
begin
  if Assigned(FBoxes) then FBoxes.Free;
  inherited;
end;

function TSlottingPlacement.GetBoxes: TBoxes;
var sBoxUINs: string;
begin
  if not Assigned(FBoxes) then
  begin
    FBoxes := TWellBoxes.Create;
    FBoxes.OwnsObjects := true;
    FBoxes.Owner := Self;
    sBoxUINs := GetBoxUINs;
    if Trim(sBoxUINs) <> '' then 
      FBoxes.Reload('BOX_UIN in (' + sBoxUINs + ')')
    else
      FBoxes.Reload('BOX_UIN in (0)');
    FBoxes.SortByNumbers;
  end;

  Result := FBoxes;  
end;

function TSlottingPlacement.GetBoxesLoaded: boolean;
begin
  Result := Assigned(FBoxes);
end;

function TSlottingPlacement.GetBoxUINs: string;
var iResult, i: integer;
     vResult: OleVariant;
begin
  iResult := TMainFacade.GetInstance.ExecuteQuery('select Box_UIN from tbl_Slotting_Box sb, tbl_Slotting s where s.slotting_uin = sb.slotting_uin ' +
                                                  'and s.well_uin  = ' + IntToStr(Owner.ID), vResult);

  Result := '';
  for i := 0 to iResult - 1 do
    Result := Result + ',' + varAsType(vResult[0, i], varOleStr);


  if trim(Result) <> '' then
    Result :=Copy(Result, 2, Length(Result)); 


end;

function TSlottingPlacement.GetCoreFinalYield: Single;
begin
  if not (Owner as TSlottingWell).SlottingsLoaded then
    Result := FCoreFinalYield
  else
    Result := (Owner as TSlottingWell).Slottings.GetFinalCore(false);
end;

function TSlottingPlacement.GetCoreFinalYieldGenSection: Single;
begin
  if not (Owner as TSlottingWell).SlottingsLoaded then
    Result := FCoreFinalYieldGenSection
  else
    Result := (Owner as TSlottingWell).Slottings.GetFinalCore(true);
end;

function TSlottingPlacement.GetCoreYield: Single;
begin
  if not (Owner as TSlottingWell).SlottingsLoaded then
    Result := FCoreYield
  else
    Result := (Owner as TSlottingWell).Slottings.GetInCore(false);
end;

function TSlottingPlacement.GetCoreYieldGenSection: Single;
begin
  if not (Owner as TSlottingWell).SlottingsLoaded then
    Result := FCoreYieldGenSection
  else
    Result := (Owner as TSlottingWell).Slottings.GetInCore(true);
end;

function TSlottingPlacement.GetFinalBoxCount: integer;
begin
  if not BoxesLoaded then
    Result := FFinalBoxCount
  else
    Result := (Owner as TSlottingWell).Slottings.GetBoxCount(false);
end;

function TSlottingPlacement.GetFinalBoxCountWithGenSection: integer;
begin
  if not BoxesLoaded then
    Result := FFinalBoxCountWithGenSection
  else
    Result := (Owner as TSlottingWell).Slottings.GetBoxCount(true);
end;

function TSlottingPlacement.GetRackList: string;
begin
  if not BoxesLoaded then
    Result := FRackList
  else
    Result := QueryRackList(false);
end;

function TSlottingPlacement.GetRackListWithGenSection: string;
begin
  if not BoxesLoaded then
    Result := FRackListWithGenSection
  else
    Result := QueryRackList(true);
end;

function TSlottingPlacement.List(AListOption: TListOption): string;
begin
  if Assigned(StatePartPlacement) then
    Result := 'Местонахождение государственной части керна: ' + StatePartPlacement.List(loBrief) + ';';

  Result := Result + 'Местонахождение части керна-владельца: ' + OwnerPartPlacement;
end;

function TSlottingPlacement.QueryRackList(UseGenSection: Boolean): string;
var iResult: integer;
    vResult: OleVariant;
    sQuery: string;
begin
  Result := '';

  sQuery := 'select vch_Rack_List from spd_Get_Rack_List(' + IntToStr(Owner.ID) + ' ,' + IntToStr(Ord(UseGenSection)) + ')';



  iResult := TMainFacade.GetInstance.DBGates.ExecuteQuery(sQuery, vResult);
  if iResult > 0 then
    Result := vResult[0, 0];

end;

function TSlottingPlacement.Update(ACollection: TIDObjects = nil): integer;
begin
  Result := inherited Update;
  if Assigned(LastCoreTransferTask) then LastCoreTransferTask.Update();
end;

{ TSlottingPlacements }

constructor TSlottingPlacements.Create;
begin
  inherited;

  FObjectClass := TSlottingPlacement;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSlottingPlacementDataPoster];
end;

function TSlottingPlacements.GetItems(Index: integer): TSlottingPlacement;
begin
  Result := inherited Items[Index] as TSlottingPlacement;
end;

{ TBox }

procedure TBox.AssignTo(Dest: TPersistent);
var b: TBox;
begin
  inherited;

  b := Dest as TBox;
  b.Rack := Rack;
end;

procedure TBox.ClearBoxPictures;
begin
  FreeAndNil(FBoxPictures);
end;

constructor TBox.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'ящик';
end;

destructor TBox.Destroy;
begin
  FreeAndNil(FSlottings);
  inherited;
end;

function TBox.GetBoxNumber: string;
begin
  Result := Name;
end;

function TBox.GetBoxPicture: TBoxPicture;
var i: integer;
begin
  Result := nil;
  for i := 0 to BoxPictures.Count - 1 do
  if BoxPictures.Items[i].PictureFileType = pftJPG then
  begin
    Result := BoxPictures.Items[i];
    break;
  end;
end;

function TBox.GetBoxPictures: TBoxPictures;
begin
  if not Assigned (FBoxPictures) then
  begin
    FBoxPictures := TBoxPictures.Create;
    FBoxPictures.Owner := Self;
    FBoxPictures.OwnsObjects := true;
    FBoxPictures.Reload('BOX_UIN = ' + IntToStr(ID));
  end;

  Result := FBoxPictures;
end;



function TBox.GetHasPicture: boolean;
begin
  Result := BoxPictures.Count > 0;
end;

function TBox.GetRack: TRack;
begin
  Result := Owner as TRack;
end;

function TBox.GetSlottings: TIDObjects;
begin
  if not Assigned(FSlottings) then
  begin
    FSlottings := TSlottings.Create;
    FSlottings.Owner := Self;
    FSlottings.Reload('Slotting_UIN in (select Slotting_UIN from tbl_Slotting_Box where Box_UIN = ' +  IntToStr(ID) + ')');
  end;
  Result := FSlottings;
end;

function TBox.List(AListOption: TListOption): string;
begin
  Result := inherited List(AListOption);

end;

procedure TBox.SetBoxNumber(const Value: string);
begin
  Name := Value;
end;


procedure TBox.SetRack(const Value: TRack);
begin

end;

function TBox.Update(ACollection: TIDObjects = nil): integer;
begin
  Result := inherited Update;
end;

{ TBoxPhotoNotAvailable }

constructor EBoxPhotoNotAvailable.Create;
begin
  inherited Create('Фотография ящика не доступна');
end;

{ TBoxes }

constructor TBoxes.Create;
begin
  inherited;

  FObjectClass := TBox;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TBoxDataPoster];
end;

destructor TBoxes.Destroy;
begin
  if Assigned(FRacks) then FRacks.Free;
  inherited;
end;

function TBoxes.GetItems(Index: integer): TBox;
begin
  Result := inherited Items[Index] as TBox;
end;

function TBoxes.GetRacks: TRacks;
var i: integer;
begin
  if not Assigned(FRacks) then
  begin
    FRacks := TRacks.Create;
    FRacks.OwnsObjects := false;
  end
  else FRacks.Clear;

  for i := 0 to Count - 1 do
  if not (Items[i].Rack is TNullRack) then 
    FRacks.Add(Items[i].Rack, false, True);


  Result := FRacks;
end;


procedure TBoxes.MakeList(AListItems: TListItems; NeedsRegistering,
  NeedsClearing: boolean);
var li: TListItem;
    i: integer;
begin
  if NeedsClearing then AListItems.Clear;

  for i := 0 to Count - 1 do
  begin
    li := AListItems.Add;

    with li do
    begin
      Data := Items[i];

      Caption := IntToStr(Items[i].ID);
      li.SubItems.Clear;
      li.SubItems.Add(Items[i].List);
      li.SubItems.Add(Items[i].ShortName);
    end;
  end;


  if Assigned(Registrator) and NeedsRegistering then
    Registrator.Add(TListViewRegisteredObject, AListItems, Self);
end;

constructor TWellBox.Create(ACollection: TIDObjects);
begin
  inherited;
  FClassIDString := 'Ящик керна';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TWellBoxDataPoster];
end;

procedure TBoxes.SortByNumbers;
begin
  Sort(SortByWellNumbers);
end;

{ TWellBoxes }

constructor TWellBoxes.Create;
begin
  inherited;
  FObjectClass := TWellBox;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TWellBoxDataPoster];
end;

function TWellBoxes.GetItems(Index: integer): TWellBox;
begin
  Result := inherited Items[Index] as TWellBox;
end;


{ TBoxPictures }

constructor TBoxPictures.Create;
begin
  inherited;
  FObjectClass := TBoxPicture;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TBoxPictureDataPoster];
end;

function TBoxPictures.GetItems(Index: integer): TBoxPicture;
begin
  Result := inherited Items[Index] as TBoxPicture;
end;

{ TBoxPicture }

procedure TBoxPicture.AssignTo(Dest: TPersistent);
var p: TBoxPicture;
begin
  inherited;

  p := Dest as TBoxPicture;
  p.RemoteName := RemoteName;
  p.LocalPath := LocalPath;
end;

constructor TBoxPicture.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Фото керна';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TBoxPictureDataPoster];
  // генерим остальные имена
  FRemotePath := RemoteCoreFilesPath;
end;

destructor TBoxPicture.Destroy;
begin

  inherited;
end;



function TBoxPicture.GetCorePhotoType: TCorePhotoType;
begin
  if Pos('_уф', Name) > 0 then
    Result := cptUv
  else
    Result := cptNormal;
end;

function TBoxPicture.GetLocalFullName: string;
begin
  Result := LocalPath + LocalName;
end;

function TBoxPicture.GetLocalName: string;
begin
  Result := Name;
end;


function TBoxPicture.GetPictureFileType: TPictureFileType;
var sPath, sExt: string;
begin
  Result := pftUnk;
  sPath := '';

  if Trim(RemotePath) <> '' then
    sPath := RemotePath
  else if Trim(LocalPath) <> '' then
    sPath := LocalPath;

  if sPath <> '' then
  begin
    sExt := AnsiUpperCase(ExtractFileExt(sPath));
    if sExt = 'JPG' then Result := pftJPG
    else if sExt = 'CDR' then Result := pftCDR
  end
end;

function TBoxPicture.GetRemoteFullName: string;
begin
  Result := RemotePath + RemoteName;
end;

procedure TBoxPicture.SetLocalName(const Value: string);
begin
  Name := Value;
end;

procedure TBoxPicture.SetLocalPath(const Value: string);
var i: integer;
begin
  if FLocalPath <> Value then
  begin
    FLocalPath := Value;
    // генерим остальные имена
    FRemotePath := RemoteCoreFilesPath;
    FRemoteName := IntToStr(Collection.Owner.ID);
    for i := 8 downto Length(FRemoteName) do
      FRemoteName := FRemoteName + '_';
    FRemoteName := FRemoteName + Name;
  end;
end;

{ TPlacementQuality }

constructor TPlacementQuality.Create(ACollection: TIDObjects);
begin
  inherited;
  FClassIDString := 'Качество местоположения керна';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TPlacementQualityDataPoster];
end;

{ TPlacementQualities }

constructor TPlacementQualities.Create;
begin
  inherited;
  FObjectClass := TPlacementQuality;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TPlacementQualityDataPoster];
end;

function TPlacementQualities.GetItems(Index: integer): TPlacementQuality;
begin
  Result := inherited Items[Index] as TPlacementQuality;
end;

{ TRack }

constructor TRack.Create(ACollection: TIDObjects); 
begin
  ClassIDString := 'Стеллаж';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TRackDataPoster];
end;

destructor TRack.Destroy;
begin
  if Assigned(FBoxes) then FBoxes.Free;
  inherited;
end;

function TRack.GetBoxes: TBoxes;
begin
  if not Assigned(FBoxes) then
  begin
    FBoxes := TBoxes.Create;
    FBoxes.OwnsObjects := True;
    FBoxes.Reload('RACK_ID = ' + IntToStr(ID));
  end;

  Result := FBoxes;
end;

function TRack.GetPartPlacement: TPartPlacement;
begin
  Result := Owner as TPartPlacement;
end;

{ TRacks }

constructor TRacks.Create;
begin
  inherited;
  FObjectClass := TRack;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TRackDataPoster];
end;

function TRacks.GetItems(Index: integer): TRack;
begin
  Result := inherited Items[index] as TRack;
end;

function TWellBox.GetRack: TRack;
begin
  Result := FRack;  
end;

procedure TWellBox.SetRack(const Value: TRack);
begin
  FRack := Value;
end;

{ TNullRack }

constructor TNullRack.Create(ACollection: TIDObjects);
begin
  inherited;
  ID := -1;
end;

function TNullRack.GetBoxes: TBoxes;
begin
  Result := nil;
end;

class function TNullRack.GetInstance: TNullRack;
const FInstance: TNullRack = nil;
begin
  if not Assigned(FInstance) then
    FInstance := TNullRack.Create(nil);

  Result := FInstance;
end;

constructor TSlottingBox.Create(ACollection: TIDObjects);
begin
  inherited;
  FClassIDString := 'Ящик керна';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSlottingBoxDataPoster];
end;

{ TSlottingBoxes }

constructor TSlottingBoxes.Create;
begin
  inherited;
  FObjectClass := TSlottingBox;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSlottingBoxDataPoster];
end;

function TSlottingBoxes.GetItems(Index: integer): TSlottingBox;
begin
  Result := inherited Items[Index] as TSlottingBox;
end;


end.
