unit Structure;

interface

uses BaseObjects, Registrator, Organization, Classes, LicenseZone, Well, District,
     TectonicStructure, PetrolRegion;

type
  TStructureOwnedDistricts = class(TDistricts)
  public
    constructor Create; override;
  end;

  TStructureOwnedTectonicStructs = class(TTectonicStructures)
  public
    constructor Create; override;
  end;

  TStructureOwnedPetrolRegions = class(TPetrolRegions)
  public
    constructor Create; override;
  end;

  TStrucureOwnedLicenseZones = class(TSimpleLicenseZones)
  public
    constructor Create; override;
  end;


  // тип структуры
  TStructureFundType = class (TRegisteredIDObject)
  public
    constructor Create (AColleation: TIDObjects); override;
  end;

  TStructureFundTypes = class (TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TStructureFundType;
  public
    property    Items[Index: integer]: TStructureFundType read GetItems;
    constructor Create; override;
  end;

  // простая структура
  TSimpleStructure = class (TRegisteredIDObject)
  private
    FOrganization: TOrganization;
  public
    // организация
    property    Organization: TOrganization read FOrganization write FOrganization;

    constructor Create (ACollection: TIDObjects); override;
  end;

  TSimpleStructures = class (TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TSimpleStructure;
  public
    property    Items[Index: Integer]: TSimpleStructure read GetItems;

    constructor Create; override;
  end;

  // структура
  TStructure = class(TSimpleStructure)
  private
    FStructureType: TStructureFundType;
    FOwnerOrganization: TOrganization;
    FOutOfFund: boolean;
    FActual: boolean;
    FVersion:Integer;

  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    // вид фонда
    property StructureFundType: TStructureFundType read FStructureType write FStructureType;
    // ---- инициализируются в потомке ----
    // организация-недропользователль
    property OwnerOrganization: TOrganization read FOwnerOrganization write FOwnerOrganization;
    // выведена из фонда
    property OutOfFund: boolean read FOutOfFund write FOutOfFund;
    // актуальна в текущем качестве -
    // истинна только для последнего шага истории
    // возможно, потом уберем
    property Actual: boolean read FActual write FActual;

    property Version: Integer read FVersion write FVersion;
    // нефтегазоносный регион
    //property PetrolRegionID: integer read FPetrolRegionID write FPetrolRegionID;
    // тектоническая структура
    //property TectonicStructID: integer read FTectonicStructID write FTectonicStructID;
    // географический регион
    //property DistrictID: integer read FDistrictID write FDistrictID;
    // площадь
    //property AreaID: integer read FAreaID write FAreaID;
    // нефтегазоносный регион
    //property PetrolRegion: string read FPetrolRegion write FPetrolRegion;
    // тектоническая структура
    //property TectonicStruct: string read FTectonicStruct write FTectonicStruct;
    // географический регион
    //property District: string read FDistrict write FDistrict;
    // площадь
    //property Area: string read FArea write FArea;
    // горизонты - грузятся по первому обращению
    //property Horizons: THorizons read GetHorizons;
    // история структуры - грузится по первому обращению
    //property History: TStructureHistory read GetHistory;
    // ссылка на вновь добавленный (отредактированный) элемент истории
    //property LastHistoryElement: TStructureHistoryElement read FLastHistoryElement write FLastHistoryElement;

    // горизонт, по которому структура нанесена на карту
    //property CartoHorizonID: integer read FCartoHorizonID write FCartoHorizonID;
    //property CartoHorizon: THorizon read GetCartoHorizon;

    // описываем
    //function    List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string; override;
    // версии документов, описывающих всякие подсчеты и параметры
    //property Versions: TAccountVersions read GetAccountVersions;
    //procedure Accept(Visitor: IVisitor); override;

    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TStructureClass = class of TStructure;

  TStructures = class(TRegisteredIDObjects)
  private
    function    GetItems(Index: integer): TStructure;
    function GetItemsByIdStruct(Index1,Index2: integer): TStructure;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items[Index: integer]: TStructure read GetItems;
    property  ItemsByIdStruct[AID,BID: integer]: TStructure read GetItemsByIdStruct;
    constructor Create; override;
  end;


  // тип месторождения
  TFieldType = class (TRegisteredIDObject)
  public
    constructor Create (ACollection: TIDObjects); override;
  end;

  TFieldTypes = class (TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TFieldType;
  public
    property    Items[Index: integer]: TFieldType read GetItems;
    constructor Create; override;
  end;

  // степень освоения
  TDevelopingDegree = class (TRegisteredIDObject)
  public
    constructor Create (ACollection: TIDObjects); override;
  end;

  TDevelopingDegrees = class (TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TDevelopingDegree;
  public
    property    Items[Index: integer]: TDevelopingDegree read GetItems;
    constructor Create; override;
  end;

  // залежи
  TBed = class (TRegisteredIDObject)
  private
    FFieldType: TFieldType;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property FieldType: TFieldType read FFieldType write FFieldType;
    constructor Create (AColleation: TIDObjects); override;
  end;

  TBeds = class (TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TBed;
  public
    property    Items[Index: integer]: TBed read GetItems;
    constructor Create; override;
  end;

  // месторождение
  TField = class(TStructure)
  private
    FDevelopingDegree: TDevelopingDegree;
    FFieldType: TFieldType;
    FLicenseZone: TLicenseZone;
    FFirstWell: TSimpleWell;
    FBeds: TBeds;
    function GetBeds: TBeds;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    // лицензионный участок
    property LicenseZone: TLicenseZone read FLicenseZone write FLicenseZone;
    // тип меторождения (нефтяное, газовое)
    property FieldType: TFieldType read FFieldType write FFieldType;
    // скважина-первооткрывательница
    property FirstWell: TSimpleWell read FFirstWell write FFirstWell;
    // степень освоения
    property DevelopingDegree: TDevelopingDegree read FDevelopingDegree write FDevelopingDegree;
    // залежи
    property Beds: TBeds read GetBeds;

    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TFields = class(TStructures)
  private
    function GetItems(Index: integer): TField;
  public
    property Items[Index: integer]: TField read GetItems;

    constructor Create; override;
  end;

implementation

uses Facade, BaseFacades, StructurePoster, Contnrs, SysUtils;

{ TStructure }

procedure TStructure.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TStructure).StructureFundType := StructureFundType;
  (Dest as TStructure).OwnerOrganization := OwnerOrganization;
  (Dest as TStructure).OutOfFund := OutOfFund;
  (Dest as TStructure).Actual := Actual;
end;

constructor TStructure.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Структура';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TStructureDataPoster];
end;

destructor TStructure.Destroy;
begin

  inherited;
end;

{ TSimpleStructure }

constructor TSimpleStructure.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Простая структура';
end;

{ TSimpleStructures }

constructor TSimpleStructures.Create;
begin
  inherited;
  FObjectClass := TSimpleStructure;
end;

function TSimpleStructures.GetItems(Index: Integer): TSimpleStructure;
begin
  Result := inherited Items[Index] as TSimpleStructure;
end;

{ TStructures }

procedure TStructures.Assign(Sourse: TIDObjects; NeedClearing: boolean);
begin
  inherited;

end;

constructor TStructures.Create;
begin
  inherited;
  FObjectClass := TStructure;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TStructureDataPoster];
end;

function TStructures.GetItems(Index: integer): TStructure;
begin
  Result := inherited Items[Index] as TStructure;
end;

function TStructures.GetItemsByIdStruct(Index1, Index2: integer): TStructure;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if ((Items[i].ID = Index1) and (Items[i].Version=Index2)) then
  begin
    Result := Items[i];
    break;
  end;
end;

{ TStructureTypes }

constructor TStructureFundTypes.Create;
begin
  inherited;
  FObjectClass := TStructureFundType;
  Poster := TMainFacade.Getinstance.DataPosterByClassType[TStructureFundTypeDataPoster];

end;

function TStructureFundTypes.GetItems(Index: integer): TStructureFundType;
begin
  Result := inherited Items[Index] as TStructureFundType;
end;



{ TStructureType }

constructor TStructureFundType.Create(AColleation: TIDObjects);
begin
  inherited;
  ClassIDString := 'Вид фонда структур';
  FDataPoster := TMainFacade.Getinstance.DataPosterByClassType[TStructureFundTypeDataPoster];
end;



{ TFieldTypes }

constructor TFieldTypes.Create;
begin
  inherited;
  FObjectClass := TFieldType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TFieldTypeDataPoster];
end;

function TFieldTypes.GetItems(Index: integer): TFieldType;
begin
  Result := inherited Items[Index] as TFieldType;
end;

{ TDevelopingDegrees }

constructor TDevelopingDegrees.Create;
begin
  inherited;
  FObjectClass := TDevelopingDegree;
end;

function TDevelopingDegrees.GetItems(Index: integer): TDevelopingDegree;
begin
  Result := inherited Items[Index] as TDevelopingDegree;
end;

{ TBeds }

constructor TBeds.Create;
begin
  inherited;
  FObjectClass := TBed;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TBedDataPoster];
end;

function TBeds.GetItems(Index: integer): TBed;
begin
  Result := inherited Items[Index] as TBed;
end;

{ TField }

procedure TField.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TField.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Месторождение';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TFieldDataPoster];
end;

destructor TField.Destroy;
begin

  inherited;
end;

function TField.GetBeds: TBeds;
begin
  if not Assigned (FBeds) then
  begin
    FBeds := TBeds.Create;
    FBeds.Owner := Self;
    FBeds.Reload ('(STRUCTURE_ID = ' + IntToStr(ID) + ') AND (VERSION_ID = ' + IntToStr(TMainFacade.GetInstance.ActiveVersion.ID) +  ')', true);
  end;

  Result := FBeds;
end;

{ TFieldType }

constructor TFieldType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип месторождения';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TFieldTypeDataPoster];
end;

{ TDevelopingDegree }

constructor TDevelopingDegree.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Степень освоения';
end;

{ TBed }

procedure TBed.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TBed).FieldType := FieldType;
end;

constructor TBed.Create(AColleation: TIDObjects);
begin
  inherited;
  ClassIDString := 'Залежь';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TBedDataPoster];
end;

{ TFields }

constructor TFields.Create;
begin
  inherited;
  FObjectClass := TField;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TFieldDataPoster];
end;

function TFields.GetItems(Index: integer): TField;
begin
  Result := inherited Items[Index] as TField;
end;


{ TStructureOwnedDistricts }

constructor TStructureOwnedDistricts.Create;
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TStructureOwnedDistrictsDataPoster];
  OwnsObjects := false;
end;

{ TStructureOwnedTectonicStructs }

constructor TStructureOwnedTectonicStructs.Create;
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TStructureOwnedTectonicStructsDataPoster];
  OwnsObjects := false;
end;

{ TStructureOwnedPetrolRegions }

constructor TStructureOwnedPetrolRegions.Create;
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TStructureOwnedPetrolRegionsDataPoster];
  OwnsObjects := false;
end;

{ TStrucureOwnedLicenseZones }

constructor TStrucureOwnedLicenseZones.Create;
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TStructureOwnedLicenseZonesDataPoster];
  OwnsObjects := false;
end;

end.
