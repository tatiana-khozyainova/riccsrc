unit Well;

interface

uses Registrator, Slotting, BaseObjects, ComCtrls, TestInterval,
     Classes, Organization, SlottingPlacement, PetrolRegion, District, Employee,
     ReasonChange, State, Fluid, Profile, TopoList, Parameter, Altitude, Coord,
     Straton, TectonicStructure, SubdivisionComponent, ResearchGroup, LasFile, Version, Area;

type
  TSimpleWell = class;
  TSimpleWells = class;
  TWellBinding = class;
  TWellBindings = class;
  TWellDynamicParameters = class;
  TWellCategory = class;
  TWellLicenseZones = class;
  TWellStructures = class;
  TWellFields = class;
  TWellBeds = class;


  TWellDynamicParameters = class(TRegisteredIDObject)
  private
    FIsProject: boolean;
    FEnteringDate: TDateTime;
    FModifyingDate: TDateTime;
    FTrueDepth: single;
    FTrueCost: single;
    FFluidType: TFluidType;
    FWellProfile: TProfile;
    FWellState: TState;
    FTrueStraton: TSimpleStraton;
    FVersion: TVersion;
    FWellCategory: TWellCategory;
    FAbandonReason: TAbandonReason;
    FAbandonDate: TDateTime;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property WellCategory: TWellCategory read FWellCategory write FWellCategory;
    property WellState: TState read FWellState write FWellState;
    property WellProfile: TProfile read FWellProfile write FWellProfile;
    property TrueDepth: single read FTrueDepth write FTrueDepth;
    property TrueFluidType: TFluidType read FFluidType write FFluidType;
    property TrueCost: single read FTrueCost write FTrueCost;
    property TrueStraton: TSimpleStraton read FTrueStraton write FTrueStraton;
    property EnteringDate: TDateTime read FEnteringDate write FEnteringDate;
    property ModifyingDate: TDateTime  read FModifyingDate write FModifyingDate;
    property IsProject: boolean read FIsProject write FIsProject;
    property Version: TVersion read FVersion write FVersion;
    property AbandonReason: TAbandonReason read FAbandonReason write FAbandonReason;
    property AbandonDate: TDateTime read FAbandonDate write FAbandonDate;

    function Compare(AWellDynamicParameters: TWellDynamicParameters): boolean;
    constructor Create (ACollection: TIDObjects); override;
  end;

  TWellDynamicParametersSet = class(TRegisteredIDObjects)
  private
    function GetItems(const Index: Integer): TWellDynamicParameters;
  public
    property    Items[const Index: Integer]: TWellDynamicParameters read GetItems;
    function    GetParametersByVersion(AVersion: TVersion): TWellDynamicParameters;
    Constructor Create; override;
  end;

  TWellProperty = class (TRegisteredIDObject)
  private
    FflShow: Boolean;
    FWidth: Integer;
  public
    // показывать или нет
    property    flShow: Boolean read FflShow write FflShow;
    // ширина стоблца
    property    Width: Integer read FWidth write FWidth;

    constructor Create (ACollection: TIDObjects); override;
  end;

  TWellProperties = class (TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TWellProperty;
  public
    property    Items[Index: Integer]: TWellProperty read GetItems;

    function    ObjectsToStr: string; reintroduce; overload;

    Constructor Create; override;
  end;

  // категория скважины
  TWellCategory = class (TRegisteredIDObject)
  public
    constructor Create (ACollection: TIDObjects); override;
  end;

  TNullWellCategory = class(TWellCategory)
  public
    constructor Create(ACollection: TIDObjects); override;
    class function GetInstance: TNullWellCategory;
  end;

  TWellCategories = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TWellCategory;
  public
    property    Items[Index: Integer]: TWellCategory read GetItems;
    Constructor Create; override;
  end;

  // отношение организации к скважине
  TWellOrganizationStatus = class (TRegisteredIDObject)
  private
    FOrganization: TOrganization;
    FStatusOrganization: TOrganizationStatus;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    // статус организации
    property  StatusOrganization: TOrganizationStatus read FStatusOrganization write FStatusOrganization;
    // организация
    property  Organization: TOrganization read FOrganization write FOrganization;

    constructor Create (ACollection: TIDObjects); override;
  end;

  TWellOrganizationStatuses = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TWellOrganizationStatus;
    function    GetItemsByIDStatus(Index: Integer): TWellOrganizationStatus;
  public
    property    Items[Index: Integer]: TWellOrganizationStatus read GetItems;
    property    ItemsByIDStatus[Index: Integer]: TWellOrganizationStatus read GetItemsByIDStatus;

    Constructor Create; override;
  end;

  // динамика отношения организации к скважине

  // принадлежность скважины
  TWellPosition = class (TRegisteredIDObject)
  private
    FNGR: TPetrolRegion;
    FDistrict: TDistrict;
    FTopolist: TTopographicalList;
    FTectonicStructure: TTectonicStructure;
    FNewNGR: TNewPetrolRegion;
    FNewTectonicStructure: TNewTectonicStructure;
    FWellLicenseZones: TWellLicenseZones;
    FWellStructures: TWellStructures;
    FWellFields: TWellFields;
    FWellBeds: TWellBeds;

    function GetNGO: TPetrolRegion;
    function GetNGP: TPetrolRegion;
    function GetNewNGO: TNewPetrolRegion;
    function GetNewNGP: TNewPetrolRegion;
    function GetWellBeds: TWellBeds;
    function GetWellFields: TWellFields;
    function GetWellLicenseZones: TWellLicenseZones;
    function GetWellStructures: TWellStructures;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property  Topolist: TTopographicalList read FTopolist write FTopolist;
      // тектонические структуры
    property  TectonicStructure: TTectonicStructure read FTectonicStructure write FTectonicStructure;
      // район
    property  District: TDistrict read FDistrict write FDistrict;
      // НГР
    property  NGR: TPetrolRegion read FNGR write FNGR;
      // НГО
    property  NGO: TPetrolRegion read GetNGO;
      // НГП
    property  NGP: TPetrolRegion read GetNGP;

      // новая тектоническая структура
    property  NewTectonicStructure: TNewTectonicStructure read FNewTectonicStructure write FNewTectonicStructure;
      // НГР
    property  NewNGR: TNewPetrolRegion read FNewNGR write FNewNGR;
      // НГО
    property  NewNGO: TNewPetrolRegion read GetNewNGO;
      // НГП
    property  NewNGP: TNewPetrolRegion read GetNewNGP;

    property  WellLicenseZones: TWellLicenseZones read GetWellLicenseZones;
    property  WellStructures: TWellStructures read GetWellStructures;
    property  WellFields: TWellFields read GetWellFields;
    property  WellBeds: TWellBeds read GetWellBeds;

    constructor Create(ACollection: TIDObjects); override;
    destructor Destroy; override;
  end;

  TWellPositions = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TWellPosition;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items[Index: Integer]: TWellPosition read GetItems;

    constructor Create; override;
  end;

  TWellLicenseZone = class (TRegisteredIDObject)
  private
    FLicenseZone: TIDObject;
    FVersion: TVersion;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property LicenseZone: TIDObject read FLicenseZone write FLicenseZone;
    property Version: TVersion read FVersion write FVersion;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TWellLicenseZones = class (TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TWellLicenseZone;
  public
    property    Items[Index: Integer]: TWellLicenseZone read GetItems;

    constructor Create; override;
  end;

  TWellField = class(TRegisteredIDObject)
  private
    FField: TIDObject;
    FVersion: TVersion;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property Field: TIDObject read FField write FField;
    property Version: TVersion read FVersion write FVersion;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TWellFields = class(TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TWellField;
  public
    property    Items[Index: Integer]: TWellField read GetItems;

    constructor Create; override;
  end;

  TWellStructure = class(TRegisteredIDObject)
  private
    FStructure: TIDObject;
    FVersion: TVersion;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property Structure: TIDObject read FStructure write FStructure;
    property Version: TVersion read FVersion write FVersion;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TWellStructures = class(TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TWellStructure;
  public
    property    Items[Index: Integer]: TWellStructure read GetItems;

    constructor Create; override;
  end;

  TWellBed = class(TRegisteredIDObject)
  private
    FBed: TIDObject;
    FVersion: TVersion;
  protected
    procedure AssignTo(Dest: TPersistent); override;

  public
    property Bed: TIDObject read FBed write FBed;
    property Version: TVersion read FVersion write FVersion;
    constructor Create(ACollection: TIDObjects); override;

  end;

  TWellBeds = class(TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TWellBed;
  public
    property    Items[Index: Integer]: TWellBed read GetItems;

    constructor Create; override;

  end;

  // просто скважины
  TSimpleWell = class (TRegisteredIDObject)
  private
    FDtDrillingStart: TDateTime;
    FDtDrillingFinish: TDateTime;
    FOwnerOrganization: TOrganization;
    FWellBindings: TWellBindings;
    FAltitudes: TAltitudes;
    FLastModifyDate: TDateTime;
    FTargetDepth: double;
    FAge: TSimpleStraton;
    FWellPositions: TWellPositions;
    FInfoGroups: TInfoGroups;
    FWellDynamicParameters: TWellDynamicParametersSet;
    FNumberWell: string;
    FPassportNumberWell: string;
    FArea: TSimpleArea;
    FTargetCategory: TWellCategory;

    function GetRealOwner: TOrganization;
    function GetWellBindings: TWellBindings;
    function GetAltitudes: TAltitudes;
    function GetWellPositions: TWellPositions;
    function GetInfoGroups: TInfoGroups;
    function GetWellDynamicParameters: TWellDynamicParametersSet;
    function GetCurrentWellDynamicParameters: TWellDynamicParameters;
    function  GetTrueDepth: double;
    procedure SetTrueDepth(const Value: double);
    function  GetCategory: TWellCategory;
    procedure SetCategory(const Value: TWellCategory);
    function  GetState: TState;
    procedure SetState(const Value: TState);
    function GetIsProject: boolean;
    procedure SetIsProject(const Value: boolean);
    function GetAltitude: single;
    procedure SetTargetCategory(const Value: TWellCategory);
  protected
    procedure AssignTo(Dest: TPersistent); override;
    function  GetWellPosition: TWellPosition; virtual;
  public
      // номер скважины
    property  NumberWell: string read FNumberWell write FNumberWell;
      // паспортный номер скважины
    property  PassportNumberWell: string read FPassportNumberWell write FPassportNumberWell;


    property  WellDynamicParametersSet: TWellDynamicParametersSet read GetWellDynamicParameters;
    property  CurrentWellDynamicParameters: TWellDynamicParameters read GetCurrentWellDynamicParameters;

    property  Altitude: single read GetAltitude;
    property  Altitudes: TAltitudes read GetAltitudes;

      // начало бурения
    property  DtDrillingStart: TDateTime read FDtDrillingStart write FDtDrillingStart;
      // окончание бурения
    property  DtDrillingFinish: TDateTime read FDtDrillingFinish write FDtDrillingFinish;

      // проектый забой
    property  TargetDepth: double read FTargetDepth write FTargetDepth;
      // фактический забой
    property  TrueDepth: double read GetTrueDepth write SetTrueDepth;

      // категория
    property  Category: TWellCategory read GetCategory write SetCategory;
      // категория назначения
    property  TargetCategory: TWellCategory read FTargetCategory write SetTargetCategory;
      // состояние
    property  State: TState read GetState write SetState;

     // проектная или фактическая
    property  IsProject: boolean read GetIsProject write SetIsProject;

      // привязка к скважине
    property  WellBinding: TWellBindings read GetWellBindings;

     // принадлежность скважины
    property    WellPosition: TWellPosition read GetWellPosition;
    property    WellPositions: TWellPositions read GetWellPositions;

    // организация
    property  OwnerOrganization: TOrganization read FOwnerOrganization write FOwnerOrganization;
    // площадь
    property  Area: TSimpleArea read FArea write FArea;
      // организация - берется по лицензии если таковая есть, если нет по организации из базы данных
    property  RealOwner: TOrganization read GetRealOwner;

    // дата последнего изменения
    property    LastModifyDate: TDateTime read FLastModifyDate write FLastModifyDate;

      // синонимы
    //property  SynonymWells: TSimpleWells read FSynonymWells write FSynonymWells;

      // самоописание
    function  List(AListOption: TListOption = loBrief): string; override;

    procedure   UpdateFilters; override;


      // принимаем посетителей
    procedure   Accept(Visitor: IVisitor); override;

    // какие исследования имеются
    property   InfoGroups: TInfoGroups read GetInfoGroups;

    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TSimpleWells = class (TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TSimpleWell;
    function GetFilter: string;
  public
    procedure Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items[Index: Integer]: TSimpleWell read GetItems;
    // фильтр для коллекции скважин
    property    Filter: string read GetFilter;

    procedure   Sort;
    procedure   SortByWellNumAndArea;
    procedure   MakeList(ACaption: WideString; NeedsRegistering: boolean = true; NeedsClearing: boolean = true); reintroduce; overload;
    function    ObjectsToStr: string; reintroduce; overload;

    constructor Create; override;
  end;

  // скважины со всевозможной инфой
  TWell = class(TSimpleWell)
  private
    FSlottingPlacements: TSlottingPlacements;
    FFluidTypeByBalance: TFluidType;
    FAbandonReason: TAbandonReasonWell;
    FTargetCost: double;
    FIstFinances: TIDObjects;
    FCoords: TWellCoords;
    FWellOrgStatuses: TWellOrganizationStatuses;
    FTargetStraton: TSimpleStraton;
    FEnteringDate: TDateTime;
    FDtConstructionFinish: TDateTime;
    FDtConstructionStart: TDateTime;
    FEmployee: TEmployee;
    FAbandonReasons: TAbandonReasonWells;
    FSubdivisions: TSubdivisions;
    FLasFiles: TLasFiles;


    function    GetSlottingPlacement: TSlottingPlacement;
    function    GetIstFinance: TIDObject;

    function    GetWellOrgStatuses: TWellOrganizationStatuses;
    function    GetCoord: TWellCoord;


    function    GetAbandonReason: TAbandonReasonWell;
    function    GetLasFiles: TLasFiles;
    function    GetSlottingsLoaded: Boolean;
    function    GetTrueStraton: TSimpleStraton;
    procedure   SetTrueStraton(const Value: TSimpleStraton);
    function    GetTrueCost: double;
    procedure   SetTrueCost(const Value: double);
    function    GetProfile: TProfile;
    procedure   SetProfile(const Value: TProfile);
    function    GetTrueFluidType: TFluidType;
    procedure   SetTrueFluidType(const Value: TFluidType);
    function    GetSubdivisions: TSubdivisions;
    function GetWellName: string;
  protected
    FSlottings: TSlottings;
    FTestIntervals: TTestIntervals;

    function    GetSlottings: TSlottings; virtual;
    function    GetTestIntervals: TTestIntervals; virtual;

    procedure   AssignTo(Dest: TPersistent); override;
    function    GetPropertyValue(APropertyID: integer): OleVariant; override;
  public
    // разбивки
    property    Subdivisions: TSubdivisions read GetSubdivisions;

    // коллекция долблений
    property    Slottings: TSlottings read GetSlottings;
    property    SlottingsLoaded: Boolean read GetSlottingsLoaded;
    procedure    RefreshIntervals;
    // коллекция Лас-файлов
    property    LasFiles: TLasFiles read GetLasFiles;

    // местоположение керна
    property    SlottingPlacement: TSlottingPlacement read GetSlottingPlacement;
    // когда нету - добавляем новое местоположение
    function    AddSlottingPlacement: TSlottingPlacement;

    // коллекция интервалов опробования
    property    TestIntervals: TTestIntervals read GetTestIntervals;

    // дата ввода данных
    property    EnteringDate: TDateTime read FEnteringDate write FEnteringDate;


    // результат бурения
    property    FluidType: TFluidType read GetTrueFluidType write SetTrueFluidType;
    // целевое назначение
    property    FluidTypeByBalance: TFluidType read FFluidTypeByBalance write FFluidTypeByBalance;

    // причина ликвидации
    property    AbandonReason: TAbandonReasonWell read GetAbandonReason write FAbandonReason;
    property    AbandonReasons: TAbandonReasonWells read FAbandonReasons write FAbandonReasons;

    // дата начала строительства
    property    DtConstructionStart: TDateTime read FDtConstructionStart write FDtConstructionStart;
    // дата окончания строительства
    property    DtConstructionFinish: TDateTime read FDtConstructionFinish write FDtConstructionFinish;

    // профиль
    property    Profile: TProfile read GetProfile write SetProfile;
    // сметная стоимость
    property    TargetCost: double read FTargetCost write FTargetCost;
    // фактическая стоимость
    property    TrueCost: double read GetTrueCost write SetTrueCost;

    // источник
    property    IstFinance: TIDObject read GetIstFinance;
    property    IstFinances: TIDObjects read FIstFinances write FIstFinances;

    // координаты скважины
    property    Coord:  TWellCoord  read GetCoord;
    property    Coords: TWellCoords read FCoords write FCoords;


    property    Employee : TEmployee read FEmployee write FEmployee;

    // проектный возраст пород на забое
    property    TargetStraton: TSimpleStraton read FTargetStraton write FTargetStraton;
    // фактический возраст пород на забое
    property    TrueStraton: TSimpleStraton read GetTrueStraton write SetTrueStraton;

    procedure   MakeList(AListItems: TListItems; NeedsClearing: boolean = false); override;
    procedure   MakeList(AListView: TListView; NeedsClearing: boolean = false); override;

    // отношение организации к скважине
    property    WellOrgStatuses: TWellOrganizationStatuses read GetWellOrgStatuses;

    // наименование скважины
    property    WellName: string read GetWellName;

    procedure   UpdateFilters; override;

    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy;override;
  end;

  TWells = class (TSimpleWells)
  private
    function GetItems(Index: Integer): TWell;
  public
    procedure Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    procedure RefreshIntervals;
    property Items[Index: integer]: TWell read GetItems;
    function    ObjectsToStr: string; overload;
    constructor Create; override;
  end;

    // скважины в динамике
  

  // привязка скважины
  TWellBinding = class (TSimpleWell)
  public
    constructor Create (ACollection: TIDObjects); override;
  end;

  TWellBindings = class (TSimpleWells)
  private
    function GetItems(Index: Integer): TWellBinding;
  public
    property Items[Index: Integer]: TWellBinding read GetItems;

    constructor Create; override;
  end;

implementation

uses Facade, WellPoster, SysUtils, Math, Variants, LicenseZone, Structure, FinanceSource,
     Contnrs, DateUtils, Comparers;

{ TWells }



procedure TWells.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TWells.Create;
begin
  inherited;
  FObjectClass := TWell;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TWellDataPoster];

  OwnsObjects := true;
end;

function TWells.GetItems(Index: Integer): TWell;
begin
  Result := inherited Items[Index] as TWell;
end;

function TWells.ObjectsToStr: string;
var i: integer;
begin
  Result := '';

  for i := 0 to Count - 1 do
    if (i <> Count - 1) and (Count <> 1) then Result := Result + Items[i].NumberWell + ', '
    else Result := Result + Items[i].NumberWell;

  if Count > 0 then Result := Result + ' - ' + Items[0].Area.List(loBrief);
end;

procedure TWells.RefreshIntervals;
var i: Integer;
begin
  for i := 0 to Count - 1 do
     Items[i].RefreshIntervals;
end;

{ TWell }

procedure   TSimpleWell.Accept(Visitor: IVisitor);
begin
  inherited;
  Visitor.VisitWell(Self);
end;

procedure TSimpleWell.AssignTo(Dest: TPersistent);
var o: TSimpleWell;
begin
  inherited;
  o := Dest as TSimpleWell;

  o.TrueDepth := TrueDepth;
  o.TargetDepth := TargetDepth;
  o.NumberWell := NumberWell;
  o.PassportNumberWell := PassportNumberWell;
  o.Category := Category;
  o.State := State;
  o.Area := Area;
  o.DtDrillingStart := DtDrillingStart;
  o.DtDrillingFinish := DtDrillingFinish;
  o.LastModifyDate := LastModifyDate;
  o.TargetCategory := TargetCategory;

  if Assigned (OwnerOrganization) then
    o.OwnerOrganization := OwnerOrganization;
end;

constructor TSimpleWell.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Скважина';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSimpleWellDataPoster];

  CountFields := 25;
end;

function TWell.AddSlottingPlacement(): TSlottingPlacement;
begin
  if not Assigned(SlottingPlacement) then
    Result := FSlottingPlacements.Add as TSlottingPlacement
  else
    Result := SlottingPlacement;
end;

procedure TWell.AssignTo(Dest: TPersistent);
var o: TWell;
begin
  inherited;
  if (Dest is TWell) then
  begin
    o := Dest as TWell;

    //o.Slottings.Assign(Slottings);
    //o.TestIntervals.Assign(TestIntervals);

    o.FluidTypeByBalance := FluidTypeByBalance;
    o.FluidType := FluidType;
    o.Profile := Profile;
    o.AbandonReason := AbandonReason;
    o.TargetCost := TargetCost;
    o.TrueCost := TrueCost;

    o.FEnteringDate := EnteringDate;
    o.TargetStraton := TargetStraton;
    o.TrueStraton := TrueStraton;
    o.Employee := Employee;
  end;
end;

constructor TWell.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Скважина';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TWellDataPoster];
  FSlottingPlacements := nil;
  Name := '';
end;

function TWell.GetCoord: TWellCoord;
begin
  Result := nil;

  if not Assigned (FCoords) then
  begin
    FCoords := TWellCoords.Create;
    FCoords.Owner := Self;
    FCoords.OwnsObjects := true;
    FCoords.Reload ('NUM_OBJECT_TYPE = 1 and OBJECT_UIN = ' + IntToStr(ID));
  end;

  if FCoords.Count > 0 then
    Result := FCoords.Items[0] as TWellCoord;
end;


function TWell.GetIstFinance: TIDObject;
begin
  Result := nil;

  if not Assigned (FIstFinances) then
  begin
    FIstFinances := TFinanceSourcesWell.Create;
    FIstFinances.Owner := Self;
    FIstFinances.Reload ('Well_UIN = ' + IntToStr(ID));
  end;

  if FIstFinances.Count > 0 then
    Result := FIstFinances.Items[0];
end;

function TWell.GetPropertyValue(APropertyID: integer): OleVariant;
begin
  Result := null;

  case APropertyID of
    1:  Result := NumberWell;
    2:  Result := Name;
    3:  Result := TrueDepth;
    4:  Result := Altitude;
    5:  Result := List;
  end;
end;

function TWell.GetSlottingPlacement: TSlottingPlacement;
begin
  if not Assigned(FSlottingPlacements) then
  begin
    FSlottingPlacements := TSlottingPlacements.Create;
    FSlottingPlacements.Owner := Self;
    FSlottingPlacements.OwnsObjects := true;
    FSlottingPlacements.Reload('Well_UIN = ' + IntToStr(ID));
  end;

  if FSlottingPlacements.Count = 0 then
    FSlottingPlacements.Add;

  Result := FSlottingPlacements.Items[0];
end;

function TWell.GetSlottings: TSlottings;
begin
  if not Assigned(FSlottings) then
  begin
    try
      FSlottings := TSlottings.Create;
      FSlottings.Owner := Self;
      FSlottings.Reload(' well_uin = ' + IntToStr(id) + ' and dtm_kern_take_date is not null ');
    except
      FSlottings := nil;
    end;
  end;

  Result := FSlottings;
end;

function TWell.GetTestIntervals: TTestIntervals;
begin
  if not Assigned(FTestIntervals) then
  begin
    FTestIntervals := TTestIntervals.Create;
    FTestIntervals.Owner := Self;
    FTestIntervals.OwnsObjects := true;
    FTestIntervals.Reload('Well_UIN = ' + IntToStr(ID));
  end;

  Result := FTestIntervals;
end;


function TSimpleWell.GetWellPosition: TWellPosition;
begin
  Result := nil;

  if not Assigned (FWellPositions) then
  begin
    FWellPositions := TWellPositions.Create;
    FWellPositions.Owner := Self;
    FWellPositions.Reload('well_uin = ' + IntToStr(ID));
  end;

  if FWellPositions.Count > 0 then
    Result := FWellPositions.Items[0];
end;

procedure TWell.MakeList(AListItems: TListItems; NeedsClearing: boolean = false);
var i, j : Integer;
begin
  CountFields := 25;

  inherited;
  AListItems.Item[0].Caption := 'Скважина';
  AListItems.Item[0].Data := nil;
  AListItems.Item[0].Data := TObject;

  i := 1;
  AListItems.Item[i].Caption := 'UIN: ';
  AListItems.Item[i].Data := nil;
  AListItems.Item[i + 1].Caption := '     ' + IntToStr(ID);

  i := i + 2;
  AListItems.Item[i].Caption := 'Название площади :';
  AListItems.Item[i].Data := nil;
  if Assigned(Area) then AListItems.Item[i + 1].Caption := '     ' + Area.Name
  else AListItems.Item[i + 1].Caption := '     <информация отсутствует>';

  i := i + 2;
  AListItems.Item[i].Caption := 'Номер скважины :';
  AListItems.Item[i].Data := nil;
  if Trim(NumberWell) <> '' then  AListItems.Item[i + 1].Caption := '     ' + NumberWell
  else AListItems.Item[i + 1].Caption := '     <информация отсутствует>';

  i := i + 2;
  AListItems.Item[i].Caption := 'Забой :';
  AListItems.Item[i].Data := nil;
  AListItems.Item[i + 1].Caption := '     ' + FloatToStr(TrueDepth);

  i := i + 2;
  AListItems.Item[i].Caption := 'Альтитуда :';
  AListItems.Item[i].Data := nil;
  AListItems.Item[i + 1].Caption := '     ' + FloatToStr(Altitude);

  if Assigned (WellPosition) then
  begin
    i := i + 2;
    AListItems.Item[i].Caption := 'НГР, НГО :';
    AListItems.Item[i].Data := nil;
    //if trim(WellPosition.NGR) <> '' then AListItems.Item[i + 1].Caption := '     ' + WellPosition.NGR
    //else AListItems.Item[i + 1].Caption := '     <информация отсутствует>';
  end;

  i := i + 2;
  AListItems.Item[i].Caption := 'Состояние :';
  AListItems.Item[i].Data := nil;
  if Assigned(State) then AListItems.Item[i + 1].Caption := '     ' + State.Name
  else AListItems.Item[i + 1].Caption := '     <информация отсутствует>';

  i := i + 2;
  AListItems.Item[i].Caption := 'Категория :';
  AListItems.Item[i].Data := nil;
  if Assigned(Category) then AListItems.Item[i + 1].Caption := '     ' + Category.Name
  else AListItems.Item[i + 1].Caption := '     <информация отсутствует>';

  i := i + 2;
  AListItems.Item[i].Caption := 'Возраст на забое :';
  AListItems.Item[i].Data := nil;
  if Assigned (FAge) then
  begin
    if trim(FAge.List) <> '' then AListItems.Item[i + 1].Caption := '     ' + FAge.List
    else AListItems.Item[i + 1].Caption := '     <информация отсутствует>';
  end
  else AListItems.Item[i + 1].Caption := '     <информация отсутствует>';

  i := i + 2;
  AListItems.Item[i].Caption := 'Начало бурения :';
  AListItems.Item[i].Data := nil;
  if (FDtDrillingStart > 0) then
    AListItems.Item[i + 1].Caption := '     ' + DateToStr(FDtDrillingStart)
  else
    AListItems.Item[i + 1].Caption := '     <информация отсутствует>';

  i := i + 2;
  AListItems.Item[i].Caption := 'Конец бурения :';
  AListItems.Item[i].Data := nil;

  if (FDtDrillingFinish > 0) then
    AListItems.Item[i + 1].Caption := '     ' + DateToStr(FDtDrillingFinish)
  else
    AListItems.Item[i + 1].Caption := '     <информация отсутствует>';

  i := i + 2;
  AListItems.Item[i].Caption := 'Дата последних изменений :';
  AListItems.Item[i].Data := nil;
  if YearOf(FLastModifyDate) <> 1899 then
    AListItems.Item[i + 1].Caption := '     ' + DateToStr(FLastModifyDate)
  else AListItems.Item[i + 1].Caption := '     <информация отсутствует>';

  // удаляем лишние поля (если есть)
  if CountFields > i + 2 then
  for j := CountFields - 1 downto i + 2 do
    AListItems.Delete (j);
  CountFields := i + 2;
end;

function TSimpleWell.GetWellPositions: TWellPositions;
begin
  if not Assigned (FWellPositions) then
  begin
    FWellPositions := TWellPositions.Create;
    FWellPositions.Owner := Self;
    FWellPositions.Reload('well_uin = ' + IntToStr(ID));
  end;

  Result := FWellPositions;
end;

function TWell.GetAbandonReason: TAbandonReasonWell;
begin
  Result := nil;

  if not Assigned (FAbandonReasons) then
  begin
    FAbandonReasons := TAbandonReasonWells.Create();
    FAbandonReasons.Owner := Self;
    FAbandonReasons.Reload('well_uin = ' + IntToStr(ID));
  end;

  if FAbandonReasons.Count > 0 then
    Result := FAbandonReasons.Items[0];
end;

procedure TWell.MakeList(AListView: TListView; NeedsClearing: boolean);
var i, j: Integer;
begin
  inherited;
    {
    // лицензионный участок
    property    LicZone: TIDObject read GetLicZone;
    // результат бурения
    property    FluidType: TFluidType read FFluidType write FFluidType;
    // целевое назначение
    property    FluidTypeByBalance: TFluidType read FFluidTypeByBalance write FFluidTypeByBalance;

    // сметная стоимость
    property    TargetCost: double read FTargetCost write FTargetCost;

    // источник
    property    IstFinance: TIDObject read GetIstFinance;
    property    IstFinances: TIDObjects read FIstFinances write FIstFinances;

    // координаты скважины
    property    Coord:  TWellCoord  read GetCoord;
    property    Coords: TWellCoords read FCoords write FCoords;

    property    Employee : TEmployee read FEmployee write FEmployee;

    // проектный возраст пород на забое
    property    TargetStraton: TSimpleStraton read FTargetStraton write FTargetStraton;
    // фактический возраст пород на забое
    property    TrueStraton: TSimpleStraton read FTrueStraton write FTrueStraton;

    // отношение организации к скважине
    property    WellOrgStatuses: TWellOrganizationStatuses read GetWellOrgStatuses;
  }

  // --------- Общая информация ------------------------------------------------

  AListView.Items.Item[0].Caption := 'Общая информация по скважине';
  AListView.Items.Item[0].Data := nil;
  AListView.Items.Item[0].Data := TObject;

  i := 1;
  AListView.Items.Item[i].Caption := 'UIN: ';
  AListView.Items.Item[i].Data := nil;
  AListView.Items.Item[i + 1].Caption := '     ' + IntToStr(ID);

  i := i + 2;
  AListView.Items.Item[i].Caption := 'Название площади :';
  AListView.Items.Item[i].Data := nil;
  if Assigned(Area) then AListView.Items.Item[i + 1].Caption := '     ' + Area.Name
  else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

  i := i + 2;
  AListView.Items.Item[i].Caption := 'Номер скважины :';
  AListView.Items.Item[i].Data := nil;
  if Trim(NumberWell) <> '' then  AListView.Items.Item[i + 1].Caption := '     ' + NumberWell
  else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

  i := i + 2;
  AListView.Items.Item[i].Caption := 'Паспортный номер скважины :';
  AListView.Items.Item[i].Data := nil;
  if Trim(PassportNumberWell) <> '' then  AListView.Items.Item[i + 1].Caption := '     ' + PassportNumberWell
  else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

  i := i + 2;
  AListView.Items.Item[i].Caption := 'Синоним названия скважины :';
  AListView.Items.Item[i].Data := nil;
  if Trim(FName) <> '' then  AListView.Items.Item[i + 1].Caption := '     ' + FName
  else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

  i := i + 2;
  AListView.Items.Item[i].Caption := '';

  // ---------------------------------------------------------------------------

  i := i + 1;
  AListView.Items.Item[i].Caption := 'Категория скважины :';
  AListView.Items.Item[i].Data := nil;
  if Assigned(Category) then AListView.Items.Item[i + 1].Caption := '     ' + Category.Name
  else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

  i := i + 2;
  AListView.Items.Item[i].Caption := 'Состояние скважины :';
  AListView.Items.Item[i].Data := nil;
  if Assigned(State) then AListView.Items.Item[i + 1].Caption := '     ' + State.Name
  else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

  if Assigned (FAbandonReason) then
  begin
    i := i + 2;
    AListView.Items.Item[i].Caption := 'Дата ликвидации :';
    AListView.Items.Item[i].Data := FAbandonReason;
    AListView.Items.Item[i + 1].Caption := '     ' + DateToStr(FAbandonReason.DtLiquidation);

    i := i + 2;
    AListView.Items.Item[i].Caption := 'Причина ликвидации (спец. код) :';
    AListView.Items.Item[i].Data := FAbandonReason;
    AListView.Items.Item[i + 1].Caption := '     ' + FAbandonReason.Name;
  end;

  i := i + 2;
  AListView.Items.Item[i].Caption := 'Дата начала бурения :';
  AListView.Items.Item[i].Data := nil;
  if FDtDrillingStart > 0 then
    AListView.Items.Item[i + 1].Caption := '     ' + DateToStr(FDtDrillingStart)
  else
    AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

  i := i + 2;
  AListView.Items.Item[i].Caption := 'Дата окончания бурения :';
  AListView.Items.Item[i].Data := nil;
  if FDtDrillingFinish > 0 then
    AListView.Items.Item[i + 1].Caption := '     ' + DateToStr(FDtDrillingFinish)
  else
    AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

  // Альтитуда ротора
  // Альтитуда земли
  // Альтитуда пола
  // Альтитуда трубы
  // Альтитуда устья
  i := i + 2;
  AListView.Items.Item[i].Caption := 'Альтитуда :';
  AListView.Items.Item[i].Data := nil;
  if Assigned (Altitudes) then
    if Altitudes.count > 0 then
      AListView.Items.Item[i + 1].Caption := '     ' + Altitudes.List()
    else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>'
  else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

  i := i + 2;
  AListView.Items.Item[i].Caption := '';

  // ------------ Положение скважины -------------------------------------------

  i := i + 1;
  AListView.Items.Item[i].Caption := 'Привязка скважины';
  AListView.Items.Item[i].Data := nil;
  AListView.Items.Item[i].Data := TObject;

  if Assigned (WellPosition) then
  begin
    i := i + 1;
    AListView.Items.Item[i].Caption := 'Название НГР :';
    AListView.Items.Item[i].Data := nil;
    if Assigned(WellPosition.NGR) then
    begin
      AListView.Items.Item[i + 1].Caption := '     ' + WellPosition.NGR.List()
    end
    else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

    i := i + 2;
    AListView.Items.Item[i].Caption := 'Название НГО :';
    AListView.Items.Item[i].Data := nil;
    if Assigned(WellPosition.NGR) then
      if Assigned(WellPosition.NGR.MainPetrolRegion) then AListView.Items.Item[i + 1].Caption := '     ' + WellPosition.NGR.MainPetrolRegion.List()
      else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>'
    else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

    // НГП
    i := i + 2;
    AListView.Items.Item[i].Caption := 'Название НГП :';
    AListView.Items.Item[i].Data := nil;
    if Assigned(WellPosition.NGR) then
      if Assigned(WellPosition.NGR.MainPetrolRegion) then
         if Assigned(WellPosition.NGR.MainPetrolRegion.MainPetrolRegion) then WellPosition.NGR.MainPetrolRegion.MainPetrolRegion.List()
         else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>'
      else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>'
    else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

    i := i + 2;
    AListView.Items.Item[i].Caption := 'Название географического региона :';
    AListView.Items.Item[i].Data := nil;
    if Assigned(WellPosition.District) then AListView.Items.Item[i + 1].Caption := '     ' + WellPosition.District.List()
    else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

    i := i + 2;
    AListView.Items.Item[i].Caption := 'Полное название тектонической структуры :';
    AListView.Items.Item[i].Data := nil;
    if Assigned(WellPosition.TectonicStructure) then AListView.Items.Item[i + 1].Caption := '     ' + WellPosition.TectonicStructure.List()
    else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

    (*
    i := i + 2;
    AListView.Items.Item[i].Caption := 'Название лицензионного участка :';
    AListView.Items.Item[i].Data := nil;
    if Assigned(WellPosition.LicZone) then AListView.Items.Item[i + 1].Caption := '     ' + WellPosition.LicZone.List()
    else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

    i := i + 2;
    AListView.Items.Item[i].Caption := 'Название нефтегазоперспективной структуры :';
    AListView.Items.Item[i].Data := nil;
    if Assigned(WellPosition.Structure) then AListView.Items.Item[i + 1].Caption := '     ' + WellPosition.Structure.List()
    else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

    i := i + 2;
    AListView.Items.Item[i].Caption := 'Название месторождения :';
    AListView.Items.Item[i].Data := nil;
    if Assigned(WellPosition.Field) then AListView.Items.Item[i + 1].Caption := '     ' + WellPosition.Field.List()
    else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';  *)
  end
  else
  begin
    i := i + 1;      
    AListView.Items.Item[i].Caption := 'Название НГР :';
    AListView.Items.Item[i].Data := nil;
    AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

    i := i + 2;
    AListView.Items.Item[i].Caption := 'Название географического региона :';
    AListView.Items.Item[i].Data := nil;
    AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

    i := i + 2;
    AListView.Items.Item[i].Caption := 'Полное название тектонической структуры :';
    AListView.Items.Item[i].Data := nil;
    AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

    i := i + 2;
    AListView.Items.Item[i].Caption := 'Название лицензионного участка :';
    AListView.Items.Item[i].Data := nil;
    AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

    i := i + 2;
    AListView.Items.Item[i].Caption := 'Название нефтегазоперспективной структуры :';
    AListView.Items.Item[i].Data := nil;
    AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

    i := i + 2;
    AListView.Items.Item[i].Caption := 'Название месторождения :';
    AListView.Items.Item[i].Data := nil;
    AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';
  end;

  i := i + 2;
  AListView.Items.Item[i].Caption := '';

  // ------------ Фактические показатели ---------------------------------------

  i := i + 1;
  AListView.Items.Item[i].Caption := 'Фактические показатели по скважине';
  AListView.Items.Item[i].Data := nil;
  AListView.Items.Item[i].Data := TObject;

  i := i + 1;
  AListView.Items.Item[i].Caption := 'Фактическая глубина :';
  AListView.Items.Item[i].Data := nil;
  AListView.Items.Item[i + 1].Caption := '     ' + FloatToStr(TrueDepth);

  i := i + 2;
  AListView.Items.Item[i].Caption := 'Возраст вскрытых отложений на забое (стратиграфический индекс) :';
  AListView.Items.Item[i].Data := nil;
  if Assigned (TrueStraton) then
  begin
    if trim(TrueStraton.List) <> '' then AListView.Items.Item[i + 1].Caption := '     ' + TrueStraton.List
    else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';
  end
  else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

  i := i + 2;
  AListView.Items.Item[i].Caption := 'Возраст вскрытых отложений на забое (название) :';
  AListView.Items.Item[i].Data := nil;
  if Assigned (TrueStraton) then
  begin
    if trim(TrueStraton.Taxonomy.List) <> '' then AListView.Items.Item[i + 1].Caption := '     ' + TrueStraton.Taxonomy.List
    else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';
  end
  else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

  // Продуктивность

  i := i + 2;
  AListView.Items.Item[i].Caption := 'Фактическая стоимость (руб.) :';
  AListView.Items.Item[i].Data := nil;
  AListView.Items.Item[i + 1].Caption := '     ' + FloatToStr(RoundTo(TrueCost, -2));

  i := i + 2;
  AListView.Items.Item[i].Caption := 'Результат бурения :';
  AListView.Items.Item[i].Data := nil;
  if Assigned(FluidType) then AListView.Items.Item[i + 1].Caption := '     ' + FluidType.List()
  else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

  i := i + 2;
  AListView.Items.Item[i].Caption := '';

  // --------------- Проектные показатели --------------------------------------

  i := i + 1;
  AListView.Items.Item[i].Caption := 'Проектные показатели по скважине';
  AListView.Items.Item[i].Data := nil;
  AListView.Items.Item[i].Data := TObject;

  i := i + 1;
  AListView.Items.Item[i].Caption := 'Проектная стоимость (руб.) :';
  AListView.Items.Item[i].Data := nil;
  AListView.Items.Item[i + 1].Caption := '     ' + FloatToStr(RoundTo(FTargetCost, -2));

  i := i + 2;
  AListView.Items.Item[i].Caption := 'Проектная глубина :';
  AListView.Items.Item[i].Data := nil;
  AListView.Items.Item[i + 1].Caption := '     ' + FloatToStr(FTargetDepth);

  i := i + 2;
  AListView.Items.Item[i].Caption := 'Проектный горизонт (стратиграфический индекс) :';
  AListView.Items.Item[i].Data := nil;
  if Assigned (FTargetStraton) then
  begin
    if trim(FTargetStraton.List) <> '' then AListView.Items.Item[i + 1].Caption := '     ' + FTargetStraton.List
    else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';
  end
  else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

  i := i + 2;
  AListView.Items.Item[i].Caption := 'Проектный горизонт (название) :';
  AListView.Items.Item[i].Data := nil;
  if Assigned (FTargetStraton) then
  begin
    if trim(FTargetStraton.Taxonomy.List) <> '' then AListView.Items.Item[i + 1].Caption := '     ' + FTargetStraton.Taxonomy.List
    else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';
  end
  else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

  i := i + 2;
  AListView.Items.Item[i].Caption := 'Целевое назначение :';
  AListView.Items.Item[i].Data := nil;
  if Assigned(FluidTypeByBalance) then AListView.Items.Item[i + 1].Caption := '     ' + FluidTypeByBalance.List()
  else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

  i := i + 2;
  AListView.Items.Item[i].Caption := '';

  //----------------------------------------------------------------------------

  i := i + 1;
  AListView.Items.Item[i].Caption := 'Дата начала строительства :';
  AListView.Items.Item[i].Data := nil;
  if YearOf(FDtConstructionStart) <> 1899 then
    AListView.Items.Item[i + 1].Caption := '     ' + DateToStr(FDtConstructionStart)
  else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

  i := i + 2;
  AListView.Items.Item[i].Caption := 'Дата окончания строительства :';
  AListView.Items.Item[i].Data := nil;
  if YearOf(FDtConstructionFinish) <> 1899 then
    AListView.Items.Item[i + 1].Caption := '     ' + DateToStr(FDtConstructionFinish)
  else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

  i := i + 2;
  AListView.Items.Item[i].Caption := '';

  //----------------------------------------------------------------------------

  i := i + 1;
  AListView.Items.Item[i].Caption := 'Профиль :';
  AListView.Items.Item[i].Data := nil;
  if Assigned(Profile) then AListView.Items.Item[i + 1].Caption := '     ' + Profile.Name
  else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

  // Название тополиста



  //----------------------------------------------------------------------------

  if WellOrgStatuses.Count > 0 then
  begin
    i := i + 2;
    AListView.Items.Item[i].Caption := '';

    i := i + 1;
    AListView.Items.Item[i].Caption := 'Полное название разведывающего министерства :';
    AListView.Items.Item[i].Data := nil;
    if Assigned(WellOrgStatuses.ItemsByIDStatus[3]) then AListView.Items.Item[i + 1].Caption := '     ' + WellOrgStatuses.ItemsByIDStatus[3].Organization.List
    else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

    i := i + 2;
    AListView.Items.Item[i].Caption := 'Полное название разведывающего треста :';
    AListView.Items.Item[i].Data := nil;
    if Assigned(WellOrgStatuses.ItemsByIDStatus[5]) then AListView.Items.Item[i + 1].Caption := '     ' + WellOrgStatuses.ItemsByIDStatus[5].Organization.List
    else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

    i := i + 2;
    AListView.Items.Item[i].Caption := 'Полное название разведывающего объединения :';
    AListView.Items.Item[i].Data := nil;
    if Assigned(WellOrgStatuses.ItemsByIDStatus[7]) then AListView.Items.Item[i + 1].Caption := '     ' + WellOrgStatuses.ItemsByIDStatus[7].Organization.List
    else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

    i := i + 2;
    AListView.Items.Item[i].Caption := 'Полное название эксплуатирующего министерства :';
    AListView.Items.Item[i].Data := nil;
    if Assigned(WellOrgStatuses.ItemsByIDStatus[4]) then AListView.Items.Item[i + 1].Caption := '     ' + WellOrgStatuses.ItemsByIDStatus[4].Organization.List
    else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

    i := i + 2;
    AListView.Items.Item[i].Caption := 'Полное название эксплуатирующего треста :';
    AListView.Items.Item[i].Data := nil;
    if Assigned(WellOrgStatuses.ItemsByIDStatus[6]) then AListView.Items.Item[i + 1].Caption := '     ' + WellOrgStatuses.ItemsByIDStatus[6].Organization.List
    else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

    i := i + 2;
    AListView.Items.Item[i].Caption := 'Полное название эксплуатирующего объединения :';
    AListView.Items.Item[i].Data := nil;
    if Assigned(WellOrgStatuses.ItemsByIDStatus[8]) then AListView.Items.Item[i + 1].Caption := '     ' + WellOrgStatuses.ItemsByIDStatus[8].Organization.List
    else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';
  end;

  i := i + 2;
  AListView.Items.Item[i].Caption := '';

  //----------------------------------------------------------------------------

  i := i + 1;
  AListView.Items.Item[i].Caption := 'Дата ввода данных :';
  AListView.Items.Item[i].Data := nil;
  if YearOf(FEnteringDate) <> 1899 then
    AListView.Items.Item[i + 1].Caption := '     ' + DateToStr(FEnteringDate)
  else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';

  i := i + 2;
  AListView.Items.Item[i].Caption := 'Дата последних изменений :';
  AListView.Items.Item[i].Data := nil;
  if YearOf(FLastModifyDate) <> 1899 then
    AListView.Items.Item[i + 1].Caption := '     ' + DateToStr(FLastModifyDate)
  else AListView.Items.Item[i + 1].Caption := '     <информация отсутствует>';



  // удаляем лишние поля (если есть)
  if CountFields > i + 2 then
  for j := CountFields - 1 downto i + 2 do
  begin
    AListView.Items.Item[j].Selected := True;
    AListView.DeleteSelected;
  end;

  CountFields := i;
end;



function TWell.GetLasFiles: TLasFiles;
begin
  if not Assigned(FLasFiles) then
  begin
    FLasFiles := TLasFiles.Create;
    FLasFiles.Owner := Self;
    FLasFiles.OwnsObjects := true;
    FLasFiles.Reload(Format('Well_UIN = %s', [IntToStr(ID)]), false);
  end;

  Result := FLasFiles;
end;

destructor TWell.Destroy;
begin
  FreeAndNil(FLasFiles);
  FreeAndNil(FSubdivisions);
  inherited;
end;

procedure TWell.RefreshIntervals;
begin
  FreeAndNil(FSlottings);
end;

function TWell.GetSlottingsLoaded: Boolean;
begin
  Result := Assigned(FSlottings);
end;

function TWell.GetTrueStraton: TSimpleStraton;
begin
  Result := CurrentWellDynamicParameters.TrueStraton;
end;

procedure TWell.SetTrueStraton(const Value: TSimpleStraton);
begin
  CurrentWellDynamicParameters.TrueStraton := Value;
end;

function TWell.GetTrueCost: double;
begin
  Result := CurrentWellDynamicParameters.TrueCost;
end;

procedure TWell.SetTrueCost(const Value: double);
begin
  CurrentWellDynamicParameters.TrueCost := Value;
end;

function TWell.GetProfile: TProfile;
begin
  result := CurrentWellDynamicParameters.WellProfile;
end;

procedure TWell.SetProfile(const Value: TProfile);
begin
  CurrentWellDynamicParameters.WellProfile := Value;
end;

function TWell.GetTrueFluidType: TFluidType;
begin
  Result := CurrentWellDynamicParameters.TrueFluidType;
end;

procedure TWell.SetTrueFluidType(const Value: TFluidType);
begin
  CurrentWellDynamicParameters.TrueFluidType := Value;
end;

procedure TWell.UpdateFilters;
var sFilter: string;
begin
  inherited;

  sFilter := 'WELL_UIN = ' + IntToStr(ID);

  if Assigned(FWellOrgStatuses) then
  begin
    FWellOrgStatuses.PosterState.Filter := sFilter;
    FWellOrgStatuses.Poster.Filter := sFilter;
  end;

  if Assigned(FSubdivisions) then
  begin
    FSubdivisions.PosterState.Filter := sFilter;
    FSubdivisions.Poster.Filter := sFilter;
  end;

  if Assigned(FSlottings) then
  begin
    FSlottings.PosterState.Filter := sFilter;
    FSlottings.Poster.Filter := sFilter;
  end;

  if Assigned(FLasFiles) then
  begin
    FLasFiles.PosterState.Filter := sFilter;
    FLasFiles.Poster.Filter := sFilter;
  end;

  if Assigned(FSlottingPlacements) then
  begin
    FSlottingPlacements.PosterState.Filter := sFilter;
    FSlottingPlacements.Poster.Filter := sFilter;
  end;

  if Assigned(FTestIntervals) then
  begin
    FTestIntervals.PosterState.Filter := sFilter;
    FTestIntervals.Poster.Filter := sFilter;
  end;

  if Assigned(FAbandonReasons) then
  begin
    FAbandonReasons.PosterState.Filter := sFilter;
    FAbandonReasons.Poster.Filter := sFilter;
  end;

  if Assigned(FWellBindings) then
  begin
    FWellBindings.PosterState.Filter := sFilter;
    FWellBindings.Poster.Filter := sFilter;
  end;

  if Assigned(FCoords) then
  begin
    FCoords.PosterState.Filter := sFilter;
    FCoords.Poster.Filter := sFilter;
  end;

end;

function TWell.GetSubdivisions: TSubdivisions;
begin
  if not Assigned(FSubdivisions) then
  begin
    FSubdivisions := TSubdivisions.Create;
    FSubdivisions.Owner := Self;
    FSubdivisions.Reload('WELL_UIN = ' + IntToStr(ID));
  end;

  Result := FSubdivisions;
end;

function TWell.GetWellName: string;
begin
  Result := Name;
end;

{ TSimpleWells }

procedure TSimpleWells.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TSimpleWells.Create;
begin
  inherited;
  FObjectClass := TSimpleWell;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSimpleWellDataPoster];
end;

function TSimpleWells.GetFilter: string;
var i : integer;
begin
  Result := '';

  if Count > 0 then
  begin
    if Count > 1 then
      for i := 0 to Count - 2 do Result := IntToStr(Items[i].ID) + ', ' + Result;

    Result := Result + IntToStr(Items[Count - 1].ID);
  end;
end;

function TSimpleWells.GetItems(Index: Integer): TSimpleWell;
begin
  Result := inherited Items[Index] as TSimpleWell;
end;

procedure TSimpleWells.MakeList(ACaption: WideString; NeedsRegistering,
  NeedsClearing: boolean);
var i: integer;
begin
  inherited;

  // пока для случая, когда название скважин (площади) одинаково
  for i := 0 to Count - 1 do
  begin
    if (i <> Count - 1) and (Count <> 1) then
      ACaption := ACaption + Items[i].NumberWell + ', '
    else ACaption := ACaption + Items[i].NumberWell;

    ACaption := ACaption + ' - ' + Items[i].Name;
  end;
end;

function TSimpleWells.ObjectsToStr: string;
var i: integer;
begin
  Result := '';

  // пока для случая, когда название скважин (площади) одинаково
  for i := 0 to Count - 1 do
  begin
    if (i <> Count - 1) and (Count <> 1) then
      Result := Result + Items[i].NumberWell + ', '
    else Result := Result + Items[i].NumberWell;

    Result := Result + ' - ' + Items[i].Area.List(loBrief);
  end;
end;

procedure TSimpleWells.Sort;
//var i, j, MaxValue, index, TempValue: integer;
//    w: TSimpleWell;
begin
  {w := TSimpleWell.Create(nil);

  for i := 0 to Count - 1 do
  if TryStrToInt (Items[i].FNumberWell, MaxValue) then
  begin
    index := i;
    for j := (i + 1) to Count - 1 do
    if TryStrToInt(Items[j].FNumberWell, TempValue) then
    if TempValue > MaxValue then
    begin
      w.Assign(Items[index]);
      Items[index].Assign(Items[j]);
      Items[j].Assign(w);

      MaxValue := TempValue;
      index := j;
    end;
  end;}
  SortByWellNumAndArea;
end;


function TSimpleWell.GetRealOwner: TOrganization;
begin
  Result := nil;
  (* if Assigned(WellPosition) and Assigned(WellPosition.LicZone) then
    Result := (WellPosition.LicZone as TSimpleLicenseZone).OwnerOrganization
  else
    Result := OwnerOrganization; *)
end;

function TSimpleWell.GetAltitudes: TAltitudes;
begin
  if not Assigned (FAltitudes) then
  begin
    FAltitudes := TAltitudes.Create;
    FAltitudes.Owner := Self;
    FAltitudes.OwnsObjects := true;
    FAltitudes.Reload('WELL_UIN = ' + IntToStr(ID));
  end;

  Result := FAltitudes;
end;

function TSimpleWell.GetWellBindings: TWellBindings;
begin
  if not Assigned (FWellBindings) then
  begin
    FWellBindings := TWellBindings.Create;
    FWellBindings.Owner := Self;
    FWellBindings.Reload('Well_UIN = ' + IntToStr(ID));
  end;

  Result := FWellBindings;
end;

function TSimpleWell.List(AListOption: TListOption = loBrief): string;
begin
  if Assigned (Area) then
    Result := NumberWell + ' - ' + Area.List(AListOption)
  else Result := NumberWell;
end;

procedure TSimpleWells.SortByWellNumAndArea;
begin
  inherited Sort(WellNumAndAreaCompare);
end;

{ TWellPositions }

procedure TWellPositions.Assign(Sourse: TIDObjects; NeedClearing: boolean);
begin
  inherited;

end;

constructor TWellPositions.Create;
begin
  inherited;
  FObjectClass := TWellPosition;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TWellPositionDataPoster];
end;

function TWellPositions.GetItems(Index: Integer): TWellPosition;
begin
  Result := inherited Items[Index] as TWellPosition;
end;

{ TWellPosition }

procedure TWellPosition.AssignTo(Dest: TPersistent);
var o: TWellPosition;
begin
  inherited;
  o := Dest as TWellPosition;

  o.TectonicStructure := TectonicStructure;
  o.Topolist := Topolist;
  o.NGR := NGR;
  o.District := District;
  o.NewNGR := NewNGR;
  o.NewTectonicStructure := NewTectonicStructure;
end;

constructor TWellPosition.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Принадлежность скважины';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TWellPositionDataPoster];
end;

{ TCategories }

constructor TWellCategories.Create;
begin
  inherited;
  FObjectClass := TWellCategory;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TWellCategoryDataPoster];
end;

function TWellCategories.GetItems(Index: Integer): TWellCategory;
begin
  Result := inherited Items[Index] as TWellCategory;
end;

{ TCategory }

constructor TWellCategory.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Категория скважины';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TWellCategoryDataPoster];
end;

destructor TWellPosition.Destroy;
begin
  FreeAndNil(FWellLicenseZones);
  FreeAndNil(FWellStructures);
  FreeAndNil(FWellFields);
  FreeAndNil(FWellBeds);
  inherited;
end;

function TWellPosition.GetNewNGO: TNewPetrolRegion;
begin
  Result := NewNGR.MainPetrolRegion as TNewPetrolRegion;
end;

function TWellPosition.GetNewNGP: TNewPetrolRegion;
begin
  Result := NewNGO.MainPetrolRegion as TNewPetrolRegion;
end;

function TWellPosition.GetNGO: TPetrolRegion;
begin
  if Assigned(NGR) then
     Result := NGR.MainPetrolRegion
  else
     Result := nil;
end;

function TWellPosition.GetNGP: TPetrolRegion;
begin
  Result := NGO.MainPetrolRegion;
end;

function TWellPosition.GetWellBeds: TWellBeds;
begin
  if not Assigned(FWellBeds) then
  begin
    FWellBeds := TWellBeds.Create();
    FWellBeds.Owner := Self;
    FWellBeds.Reload('WELL_UIN = '  + IntToStr(Owner.ID));
  end;

  Result := FWellBeds;
end;

function TWellPosition.GetWellFields: TWellFields;
begin
  if not Assigned(FWellFields) then
  begin
    FWellFields := TWellFields.Create;
    FWellFields.Owner := Self;
    FWellFields.Reload('WELL_UIN = ' + IntToStr(Owner.ID));
  end;

  Result := FWellFields;
end;

function TWellPosition.GetWellLicenseZones: TWellLicenseZones;
begin
  if not Assigned(FWellLicenseZones) then
  begin
    FWellLicenseZones := TWellLicenseZones.Create;
    FWellLicenseZones.Owner := Self;
    FWellLicenseZones.Reload('Well_UIN = ' + IntToStr(Owner.ID));
  end;
  Result := FWellLicenseZones;
end;

function TWellPosition.GetWellStructures: TWellStructures;
begin
  if not Assigned(FWellStructures) then
  begin
    FWellStructures := TWellStructures.Create;
    FWellStructures.Owner := Self;
    FWellStructures.Reload('WELL_UIN = ' + IntToStr(Owner.ID));
  end;

  Result := FWellStructures;

end;

{ TWellBindings }

constructor TWellBindings.Create;
begin
  inherited;
  FObjectClass := TWellBinding;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TWellBindingDataPoster];
end;

function TWellBindings.GetItems(Index: Integer): TWellBinding;
begin
  Result := inherited Items[Index] as TWellBinding; 
end;

{ TWellBinding }

constructor TWellBinding.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Привязка скважины';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TWellBindingDataPoster];
end;





function TWell.GetWellOrgStatuses: TWellOrganizationStatuses;
begin
  if not Assigned (FWellOrgStatuses) then
  begin
    FWellOrgStatuses := TWellOrganizationStatuses.Create;
    FWellOrgStatuses.Owner := Self;
    FWellOrgStatuses.Reload('WELL_UIN = ' + IntToStr(ID));
  end;

  Result := FWellOrgStatuses;
end;


{ TOrganizationStatuses }

constructor TWellOrganizationStatuses.Create;
begin
  inherited;
  FObjectClass := TWellOrganizationStatus;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TWellOrganizationStatusDataPoster];
end;

function TWellOrganizationStatuses.GetItems(
  Index: Integer): TWellOrganizationStatus;
begin
  Result := inherited Items[Index] as TWellOrganizationStatus;
end;

{ TOrganizationStatus }

procedure TWellOrganizationStatus.AssignTo(Dest: TPersistent);
var o: TWellOrganizationStatus;
begin
  inherited;
  o := Dest as TWellOrganizationStatus;

  o.Organization := Organization;
  o.StatusOrganization := StatusOrganization;
end;

constructor TWellOrganizationStatus.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Отношение организации к скважине';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TWellOrganizationStatusDataPoster];
end;


{ TWellCols }

constructor TWellProperties.Create;
begin
  inherited;
  FObjectClass := TWellProperty;
end;

function TWellProperties.GetItems(Index: Integer): TWellProperty;
begin
  Result := inherited Items[index] as TWellProperty;
end;

{ TWellCol }

constructor TWellProperty.Create(ACollection: TIDObjects);
begin
  inherited;
  FClassIDString := 'Свойство скважины';
  FflShow := True;
end;

function TWellProperties.ObjectsToStr: string;
var i: integer;
begin
  Result := '';
  if Count <> 0 then
  for i := 0 to Count - 1 do
  if Items[i].flShow then
  begin
    if i < Count - 1 then Result := Result + Items[i].Name + ', '
    else Result := Result + Items[i].Name;
  end;

  if Result = '' then Result := '<нет данных>'
  else
  begin
     if (Result [Length(Result) - 1] + Result [Length(Result)]) = ', ' then
       System.Delete(Result, Length(Result) - 1, 2);
  end;
end;

function TWellOrganizationStatuses.GetItemsByIDStatus(
  Index: Integer): TWellOrganizationStatus;
var i: Integer;
begin
  Result := nil;

  for i := 0 to Count - 1 do
  if Items[i].FStatusOrganization.ID = Index then
  begin
    Result := Items[i];
    Break;
  end;
end;


function TSimpleWell.GetInfoGroups: TInfoGroups;
begin
  if not Assigned(FInfoGroups) then
  begin
    FInfoGroups := TInfoGroups.Create;
    FInfoGroups.OwnsObjects := False;
  end;

  Result := FInfoGroups;
end;

destructor TSimpleWell.Destroy;
begin
  FreeAndNil(FInfoGroups);
  FreeAndNil(FWellDynamicParameters);
  inherited;
end;

{ TNullWellCategory }

constructor TNullWellCategory.Create(ACollection: TIDObjects);
begin
  inherited;
  Name := '<не указана>';
end;

class function TNullWellCategory.GetInstance: TNullWellCategory;
const cat: TNullWellCategory = nil;
begin
  if not Assigned(cat) then cat := TNullWellCategory.Create(nil);

  Result := cat;
end;

{ TWellDynamicParameters }

procedure TWellDynamicParameters.AssignTo(Dest: TPersistent);
var wdp: TWellDynamicParameters;
begin
  inherited;
  wdp := Dest as TWellDynamicParameters;
  wdp.WellCategory := WellCategory;
  wdp.WellState := WellState;
  wdp.WellProfile := WellProfile;
  wdp.TrueDepth := TrueDepth;
  wdp.TrueFluidType := TrueFluidType;
  wdp.TrueCost := TrueCost;
  wdp.TrueStraton := TrueStraton;
  wdp.EnteringDate := EnteringDate;
  wdp.ModifyingDate := ModifyingDate;
  wdp.IsProject := IsProject;
  wdp.AbandonReason := AbandonReason;
  wdp.AbandonDate := AbandonDate;
  wdp.Version := Version;
end;

function TWellDynamicParameters.Compare(
  AWellDynamicParameters: TWellDynamicParameters): boolean;
begin

  Result := WellCategory = AWellDynamicParameters.WellCategory;
  if not Result then exit;

  Result := WellState = AWellDynamicParameters.WellState;
  if not Result then exit;

  Result := WellProfile = AWellDynamicParameters.WellProfile;
  if not Result then exit;

  Result := TrueDepth = AWellDynamicParameters.TrueDepth;
  if not Result then exit;

  Result := TrueFluidType = AWellDynamicParameters.TrueFluidType;
  if not Result then exit;

  Result := TrueCost = AWellDynamicParameters.TrueCost;
  if not Result then exit;

  Result := TrueStraton = AWellDynamicParameters.TrueStraton;
  if not Result then exit;

  Result := IsProject = AWellDynamicParameters.IsProject;
  if not Result then exit;
end;

constructor TWellDynamicParameters.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Динамические параметры скважины';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TWellDynamicParametersDataPoster];

end;

{ TWellDynamicParametersSet }

constructor TWellDynamicParametersSet.Create;
begin
  inherited;
  FObjectClass := TWellDynamicParameters;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TWellDynamicParametersDataPoster];
end;

function TWellDynamicParametersSet.GetItems(
  const Index: Integer): TWellDynamicParameters;
begin
  Result := inherited Items[Index] as TWellDynamicParameters;
end;

function TSimpleWell.GetWellDynamicParameters: TWellDynamicParametersSet;
var p: TWellDynamicParameters;
begin
  if not Assigned(FWellDynamicParameters) then
  begin
    FWellDynamicParameters := TWellDynamicParametersSet.Create();
    FWellDynamicParameters.Owner := Self;
    FWellDynamicParameters.Reload('Well_UIN = ' + IntToStr(ID));
    p := FWellDynamicParameters.GetParametersByVersion(TMainFacade.GetInstance.AllVersions.ItemsByID[0] as TVersion);
    if not Assigned(p) then
    begin
      p := FWellDynamicParameters.Add as TWellDynamicParameters; // это те, которые актуальны и подлежат изменению
      p.Version := TMainFacade.GetInstance.AllVersions.ItemsByID[0] as TVersion;
    end;
  end;

  Result := FWellDynamicParameters;
end;

function TSimpleWell.GetCurrentWellDynamicParameters: TWellDynamicParameters;
begin
  Result := WellDynamicParametersSet.Items[WellDynamicParametersSet.Count - 1];
end;



function TSimpleWell.GetTrueDepth: double;
begin
  Result := CurrentWellDynamicParameters.TrueDepth;
end;

procedure TSimpleWell.SetTrueDepth(const Value: double);
begin
  CurrentWellDynamicParameters.TrueDepth := Value;
end;

function TSimpleWell.GetCategory: TWellCategory;
begin
  if not Assigned(CurrentWellDynamicParameters.WellCategory) then
    CurrentWellDynamicParameters.WellCategory := TargetCategory;

  Result := CurrentWellDynamicParameters.WellCategory
end;

procedure TSimpleWell.SetCategory(const Value: TWellCategory);
begin
  CurrentWellDynamicParameters.WellCategory := Value;
end;

function TSimpleWell.GetState: TState;
begin
  result := CurrentWellDynamicParameters.WellState;
end;

procedure TSimpleWell.SetState(const Value: TState);
begin
  CurrentWellDynamicParameters.WellState := Value;
end;

function TSimpleWell.GetIsProject: boolean;
begin
  Result := CurrentWellDynamicParameters.IsProject;
end;

procedure TSimpleWell.SetIsProject(const Value: boolean);
begin
  CurrentWellDynamicParameters.IsProject := Value;
end;



function TSimpleWell.GetAltitude: single;
begin
  if Altitudes.Count > 0 then
    Result := Altitudes.Items[0].Value
  else
    Result := 0;
end;


function TWellDynamicParametersSet.GetParametersByVersion(
  AVersion: TVersion): TWellDynamicParameters;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].Version = AVersion then
  begin
    result := Items[i];
    break;
  end;
end;

{ TWellLicenseZone }

procedure TWellLicenseZone.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TWellLicenseZone).LicenseZone := LicenseZone;
  (Dest as TWellLicenseZone).Version := Version;
end;

constructor TWellLicenseZone.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Принадлежность скважины к лицензионному участку';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TWellLicenseZoneDataPoster];
end;

{ TWellLicenseZones }

constructor TWellLicenseZones.Create;
begin
  inherited;
  FObjectClass := TWellLicenseZone;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TWellLicenseZoneDataPoster];
end;

function TWellLicenseZones.GetItems(Index: Integer): TWellLicenseZone;
begin
  Result := inherited Items[index] as TWellLicenseZone;
end;

{ TWellField }

procedure TWellField.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TWellField).Field := Field;
  (Dest as TWellField).Version := Version;
end;

constructor TWellField.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Принадлежность скважины к месторождению';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TWellFieldDataPoster];
end;

{ TWellFields }

constructor TWellFields.Create;
begin
  inherited;
  FObjectClass := TWellField;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TWellFieldDataPoster];
end;

function TWellFields.GetItems(Index: Integer): TWellField;
begin
  Result := inherited Items[Index] as TWellField;
end;

{ TWellStructure }

procedure TWellStructure.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TWellStructure).Structure := Structure;
  (Dest as TWellStructure).Version := Version;
end;

constructor TWellStructure.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Принадлежность скважины к структуре';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TWellStructureDataPoster];
end;

{ TWellStructures }

constructor TWellStructures.Create;
begin
  inherited;
  FObjectClass := TWellStructure;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TWellStructureDataPoster];
end;

function TWellStructures.GetItems(Index: Integer): TWellStructure;
begin
  Result := inherited Items[Index] as TWellStructure;
end;

{ TWellBed }

procedure TWellBed.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TWellBed).Bed := Bed;
  (Dest as TWellBed).Version := Version;
end;

constructor TWellBed.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Принадлежность скважины к залежи';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TWellBedDataPoster];
end;

{ TWellBeds }

constructor TWellBeds.Create;
begin
  inherited;
  FObjectClass := TWellBed;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TWellBedDataPoster];
end;

function TWellBeds.GetItems(Index: Integer): TWellBed;
begin
  Result := inherited Items[Index] as TWellBed;
end;

procedure TSimpleWell.SetTargetCategory(const Value: TWellCategory);
begin
  FTargetCategory := Value;
  if not Assigned(Category) then Category := FTargetCategory;
end;

procedure TSimpleWell.UpdateFilters;
var sFilter: string;
begin
  sFilter := 'WELL_UIN = ' + IntToStr(ID);

  if Assigned(FWellDynamicParameters) then
  begin
    FWellDynamicParameters.PosterState.Filter := sFilter;
    FWellDynamicParameters.Poster.Filter  := sFilter;
  end;

  if Assigned(FWellPositions) then
  begin
    FWellPositions.PosterState.Filter := sFilter;
    FWellPositions.Poster.Filter := sFilter;
  end;

  if Assigned(FInfoGroups) then
  begin
    FInfoGroups.PosterState.Filter := sFilter;
    FInfoGroups.Poster.Filter := sFilter;
  end;

  if Assigned(FAltitudes) then
  begin
    FAltitudes.PosterState.Filter := sFilter;
    FAltitudes.Poster.Filter := sFilter;
  end;
end;

end.
