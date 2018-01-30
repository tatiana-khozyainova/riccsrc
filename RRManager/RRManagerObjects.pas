unit RRManagerObjects;

interface

uses Classes, RRmanagerBaseObjects, SysUtils, ClientCommon, BaseObjects, LicenseZone, District,
     PetrolRegion, TectonicStructure, BaseConsts, Contnrs;

type
  TOldVersion = class;
  TOldVersions = class;

  TOldStructure = class;
  TOldStructures = class;

  TOldPreparedStructure = class;
  TOldPreparedStructures = class;

  TOldDiscoveredStructure = class;
  TOldDiscoveredStructures = class;

  TOldDrilledStructure = class;
  TOldDrilledStructures = class;

  TOldOutOfFundStructure = class;
  TOldOutOfFundStructures = class;

  TOldField = class;
  TOldFields = class;


  TOldStructureHistoryElement = class;
  TOldStructureHistory = class;

  TOldHorizon = class;
  TOldHorizons = class;

  TOldSubstructure = class;
  TOldSubstructures = class;

  TOldLayer = class;
  TOldLayers = class;

  TOldResource = class;
  TOldResources = class;

  TOldParam = class;
  TOldParams = class;
  TOldLayerParams = class;

  TOldBed = class;
  TOldBeds = class;

  TOldAccountVersion = class;
  TOldAccountVersions = class;

  TOldReserve = class;
  TOldReserves = class;

  TOldDocument = class;
  TOldDocuments = class;

  TOldLicenseZone = class;
  TOldLicenseZones = class;

  TOldLicense = class;
  TOldLicenseZoneClass = class of TOldLicenseZone;

  TIntegerList = class(TObjectList)
  private
    function GetItems(Index: Integer): Integer;
  public
    property Items[Index: Integer]: Integer read GetItems;
    constructor Create; 
  end;

  IConcreteVisitor = interface(IVisitor)
    procedure VisitVersion(AVersion: TOldVersion);
    procedure VisitStructure(AStructure: TOldStructure);
    procedure VisitDiscoveredStructure(ADiscoveredStructure: TOldDiscoveredStructure);
    procedure VisitPreparedStructure(APreparedStructure: TOldPreparedStructure);
    procedure VisitDrilledStructure(ADrilledStructure: TOldDrilledStructure);
    procedure VisitField(AField: TOldField);

    procedure VisitHorizon(AHorizon: TOldHorizon);

    procedure VisitSubstructure(ASubstructure: TOldSubstructure);

    procedure VisitLayer(ALayer: TOldLayer);

    procedure VisitBed(ABed: TOldBed);

    procedure VisitAccountVersion(AAccountVersion: TOldAccountVersion);
    procedure VisitStructureHistoryElement(AHistoryElement: TOldStructureHistoryElement);
    procedure VisitOldLicenseZone(ALicenseZone: TOldLicenseZone);
  end;

  TOldVersion = class(TBaseObject)
  private
    FVersionReason: string;
    FVersionDate: TDateTime;
    FVersionName: string;
  protected
    // присвоить
    procedure AssignTo(Dest: TPersistent); override;
    function  GetObjectType: integer; override;
    function  GetMaterialBindType: integer; override;
  public
    property VersionName: string read FVersionName write FVersionName;
    property VersionReason: string read FVersionReason write FVersionReason;
    property VersionDate: TDateTime read FVersionDate write FVersionDate;

    // в конструкторе создаем пустое хранилище под горизонты, загружаем историю в специальный класс
    constructor Create(Collection: TIDObjects); override;
    destructor  Destroy; override;
    // описываем
    function    List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string; override;
    procedure   Accept(Visitor: IVisitor); override;
  end;

  TOldVersions = class(TBaseCollection)
  private
    function GetItems(const Index: integer): TOldVersion;
  public
    function Add: TOldVersion;
    property Items[const Index: integer]: TOldVersion read GetItems;
    constructor Create(AOwner: TBaseObject); override;
  end;

  TOldCoordObject = class(TBaseObject)

  end;

  TOldCoordObjects = class(TBaseCollection)
  public

  end;




  TOldLicense = class(TBaseObject)
  private
    FLicenseZoneNum: string;
    FRegistrationStartDate: TDateTime;
    FLicenseZoneTOldypeID: integer;
    FLicenseZoneTOldype: string;
    FLicenseType: string;
    FLicenseTypeID: integer;
    FRegistrationFinishDate: TDateTime;
    FSeria: string;
    FLicenseTitle: string;
    FDeveloperOrganizationID: integer;
    FOwnerOrganizationID: integer;
    FOwnerOrganizationName: string;
    FDeveloperOrganizationName: string;
    FSiteHolderID: integer;
    FSiteHolder: string;
    FDocHolderDate: TDateTime;
    FDocHolder: string;
    FIssuerID: integer;
    FIssuerName: string;
    FIssuerSubject: string;
    FLicenseTypeShortName: string;
  protected
    // присвоить
    procedure AssignTo(Dest: TPersistent); override;
    function  GetObjectType: integer; override;
    function  GetMaterialBindType: integer; override;
    function  GetSubObjectsCount: integer; override;
  public
    property  LicenseZoneNum: string read FLicenseZoneNum write FLicenseZoneNum;

    property  OwnerOrganizationID: integer read FOwnerOrganizationID write FOwnerOrganizationID;
    property  OwnerOrganizationName: string read FOwnerOrganizationName write FOwnerOrganizationName;

    property  DeveloperOrganizationID: integer read FDeveloperOrganizationID write FDeveloperOrganizationID;
    property  DeveloperOrganizationName: string read FDeveloperOrganizationName write FDeveloperOrganizationName;

    property  SiteHolderID: integer read FSiteHolderID write FSiteHolderID;
    property  SiteHolder: string read FSiteHolder write FSiteHolder;
    property  DocHolderDate: TDateTime read FDocHolderDate write FDocHolderDate;
    property  DocHolder: string read FDocHolder write FDocHolder;

    property  IssuerID: integer read FIssuerID write FIssuerID;
    property  IssuerName: string read FIssuerName write FIssuerName;
    property  IssuerSubject: string read FIssuerSubject write FIssuerSubject;


    property  LicenzeZoneTypeID: integer read FLicenseZoneTOldypeID write FLicenseZoneTOldypeID;
    property  LicenzeZoneType: string read FLicenseZoneTOldype write FLicenseZoneTOldype;

    property  LicenseTypeID: integer read FLicenseTypeID write FLicenseTypeID;
    property  LicenseType: string read FLicenseType write FLicenseType;
    property  LicenseTypeShortName: string read FLicenseTypeShortName write FLicenseTypeShortName;

    property  LicenseTitle: string read FLicenseTitle write FLicenseTitle;

    property  RegistrationStartDate: TDateTime read FRegistrationStartDate write FRegistrationStartDate;
    property  RegistrationFinishDate: TDateTime read FRegistrationFinishDate write FRegistrationFinishDate;

    property  Seria: string read FSeria write FSeria;

    function  List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string; override;
  end;

  TOldLicenseZone = class(TBaseObject)
  private
    FDistrictID: integer;
    FLicenseZoneStateID: integer;
    FDepthFrom: single;
    FDepthTo: single;
    FArea: single;
    FLicenseZoneState: string;
    FDistrict: string;
    FLicenseZoneName: string;
    FLicense: TOldLicense;
    FVersions: TOldAccountVersions;
    FPetrolRegionID: integer;
    FPetrolRegion: string;
    FTectonicStructID: integer;
    FTectonicStruct: string;
    FCoordObjects: TOldCoordObjects;
    FCompetitionID: integer;
    FCompetitionDate: TDateTime;
    FCompetitionName: string;
    FLicenseConditionValues: TLicenseConditionValues;
    FNGDRID: Integer;
    FNGDRName: string;
    function GetLicenseZoneNum: string;
    function GetVersions: TOldAccountVersions;
    function GetLicense: TOldLicense;
    function GetRegistrationFinishDate: TDateTime;
    function GetRegistrationStartDate: TDateTime;
    function GetCoordObjects: TOldCoordObjects;
    function GetLicenseConditionValues: TLicenseConditionValues;
  protected
    // присвоить
    procedure AssignTo(Dest: TPersistent); override;
    function  GetObjectType: integer; override;
    function  GetMaterialBindType: integer; override;
    function  GetSubObjectsCount: integer; override;
  public
    property  Coords: TOldCoordObjects read GetCoordObjects;
    property  LicenseZoneStateID: integer read FLicenseZoneStateID write FLicenseZoneStateID;
    property  LicenseZoneState: string read FLicenseZoneState write FLicenseZoneState;

    property  DistrictID: integer read FDistrictID write FDistrictID;
    property  District: string read FDistrict write FDistrict;

    property  PetrolRegionID: integer read FPetrolRegionID write FPetrolRegionID;
    property  PetrolRegion: string read FPetrolRegion write FPetrolRegion;

    property  TectonicStructID: integer read FTectonicStructID write FTectonicStructID;
    property  TectonicStruct: string read FTectonicStruct write FTectonicStruct;


    property  RegistrationStartDate: TDateTime read GetRegistrationStartDate;
    property  RegistrationFinishDate: TDateTime read GetRegistrationFinishDate;

    property  LicenseZoneNum: string read GetLicenseZoneNum;
    property  LicenseZoneName: string read FLicenseZoneName write FLicenseZoneName;

    property  Area: single read FArea write FArea;
    property  DepthFrom: single read FDepthFrom write FDepthFrom;
    property  DepthTo: single read FDepthTo write FDepthTo;

    property  CompetitionID: integer read FCompetitionID write FCompetitionID;
    property  CompetitionName: string read FCompetitionName write FCompetitionName;
    property  CompetitionDate: TDateTime read FCompetitionDate write FCompetitionDate;

    property  NGDRID: Integer read FNGDRID write FNGDRID;
    property  NGDRName: string read FNGDRName write FNGDRName;

    property  License: TOldLicense read GetLicense;
    property  LicenseConditionValues: TLicenseConditionValues read GetLicenseConditionValues;


    property  Versions: TOldAccountVersions read GetVersions;

    constructor Create(Collection: TIDObjects); override;
    destructor  Destroy; override;

    function    List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string; override;
    function    List(ListOption: TListOption): string; overload; override;
    procedure   Accept(Visitor: IVisitor); override;
  end;

  TOldLicenseZones = class(TBaseCollection)
  private
    function GetItems(const Index: integer): TOldLicenseZone;
  public
    property Items[const Index: integer]: TOldLicenseZone read GetItems;

    function  Add: TOldLicenseZone; overload;

    { TOldODO : Правила сортировки }
    procedure SortByName;
    procedure SortByLicenseNumber;
    procedure SortByDistrict;
    procedure SortByPetrolRegion;
    procedure SortByNGO;
    procedure SortByOrganization;
    procedure SortByTOldectStruct;
    procedure SortByLicenseType;
    procedure SortByLicenseZoneTOldype;

    constructor Create(AOwner: TBaseObject); override;
  end;


  TOldStructure = class(TBaseObject)
  private
    FOutOfFund: boolean;
    FAreaID: integer;
    FStructureTypeID: integer;
    FArea: string;
    FStructureType: string;
    FActual: boolean;
    FOrganizationID: integer;
    FOrganization: string;
    FOwnerOrganization: string;
    FOwnerOrganizationID: integer;
    FHistory: TOldStructureHistory;
    FHorizons: TOldHorizons;
    FVersions: TOldAccountVersions;
    FLastHistoryElement: TOldStructureHistoryElement;
    FCartoHorizonID: integer;
    FDistricts: TDistricts;
    FLicenseZones: TSimpleLicenseZones;
    FPetrolRegions: TPetrolRegions;
    FTectonicStructs: TTectonicStructures;

    function GetHistory: TOldStructureHistory;
    function GetHorizons: TOldHorizons;
    function GetAccountVersions: TOldAccountVersions;
    function GetCartoHorizon: TOldHorizon;
    function GetDistricts: TDistricts;
    function GetLicenseZones: TSimpleLicenseZones;
    function GetPetrolRegions: TPetrolRegions;
    function GetTectonicStructs: TTectonicStructures;
  protected
    // присвоить
    procedure AssignTo(Dest: TPersistent); override;
    function  GetObjectType: integer; override;
    function  GetMaterialBindType: integer; override;
    function  GetSubObjectsCount: integer; override;
  public
    procedure AssignCollections(Source: TPersistent); override;
    // копирование привязочных параметров структуры
    procedure StructureMainParamsAssign(Source: TOldStructure);
    // идентификаторы для привязки
    // вид фонда
    property StructureTypeID: integer read FStructureTypeID write FStructureTypeID;
    // площадь
    property AreaID: integer read FAreaID write FAreaID;
    // организация
    property OrganizationID: integer read FOrganizationID write FOrganizationID;
    // организация-недропользователль
    property OwnerOrganizationID: integer read FOwnerOrganizationID write FOwnerOrganizationID;
  public
    // вид фонда
    property StructureType: string read FStructureType write FStructureType;
    // площадь
    property Area: string read FArea write FArea;
    // выведена из фонда
    property OutOfFund: boolean read FOutOfFund write FOutOfFund;
    // ---- инициализируются в потомке ----
    // организация проводящая работы на структуре
    property Organization: string read FOrganization write FOrganization;
    // организация-недропользователь
    property OwnerOrganization: string read FOwnerOrganization write FOwnerOrganization;
    // актуальна в текущем качестве -
    // истинна только для последнего шага истории
    // возможно, потом уберем
    property Actual: boolean read FActual write FActual;

    // горизонты - грузятся по первому обращению
    property Horizons: TOldHorizons read GetHorizons;
    // история структуры - грузится по первому обращению
    property History: TOldStructureHistory read GetHistory;
    // ссылка на вновь добавленный (отредактированный) элемент истории
    property LastHistoryElement: TOldStructureHistoryElement read FLastHistoryElement write FLastHistoryElement;

    // горизонт, по которому структура нанесена на карту
    property CartoHorizonID: integer read FCartoHorizonID write FCartoHorizonID;
    property CartoHorizon: TOldHorizon read GetCartoHorizon;

    // в конструкторе создаем пустое хранилище под горизонты, загружаем историю в специальный класс
    constructor Create(Collection: TIDObjects); override;
    destructor  Destroy; override;

    // географические регионы
    property Districts: TDistricts read GetDistricts;
    // нефтегазоносные регионы
    property PetrolRegions: TPetrolRegions read GetPetrolRegions;
    // тектонические структуры
    property TectonicStructs: TTectonicStructures read GetTectonicStructs;
    // лицензионные участки
    property LicenseZones: TSimpleLicenseZones read GetLicenseZones;

    // описываем
    function    List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string; override;
    // версии документов, описывающих всякие подсчеты и параметры
    property Versions: TOldAccountVersions read GetAccountVersions;
    procedure Accept(Visitor: IVisitor); override;
  end;

  TOldStructureClass = class of TOldStructure;

  TOldStructures = class(TBaseCollection)
  private
    function GetItems(const Index: integer): TOldStructure;
  public
    property  Items[const Index: integer]: TOldStructure read GetItems;
    function  Add: TOldStructure; overload;
    function  Add(AStructureClass: TOldStructureClass): TOldStructure; overload;
    function Add(const AID: integer): TOldStructure; reintroduce; overload;
    constructor Create(AOwner: TBaseObject); override;
  end;

  // подготовленная структура
  TOldPreparedStructure = class(TOldStructure)
  private
    FMethodID: integer;
    FMethod: string;
    FYear: string;
    FReportAuthor: string;
    FSeismoGroupName: string;
    function GetMethod: string;
    function GetMethodID: integer;
    function GetReportAuthor: string;
    function GetSeismoGroupName: string;
    function GetYear: string;
  protected
    // присвоить
    procedure AssignTo(Dest: TPersistent); override;
  public
    // идентификатор метода
    property MethodID: integer read GetMethodID write FMethodID;
    // метод подготовки
    property Method: string read GetMethod write FMethod;
    // год подготовки
    property Year: string read GetYear write FYear;
    // автор отчета
    property ReportAuthor: string read GetReportAuthor write FReportAuthor;
    // номер сейсмопартии
    property SeismoGroupName: string read GetSeismoGroupName write FSeismogroupName;

    procedure Accept(Visitor: IVisitor); override;    
    constructor Create(Collection: TIDObjects); override;
    destructor  Destroy; override;

  end;

  TOldPreparedStructures = class(TOldStructures)
  private
    function GetItems(const Index: integer): TOldPreparedStructure;
  public
    property Items[const Index: integer]: TOldPreparedStructure read GetItems;
  end;

  // выявленная структура
  TOldDiscoveredStructure = class(TOldStructure)
  private
    FMethodID: integer;
    FMethod: string;
    FYear: string;
    FReportAuthor: string;
    FSeismoGroupName: string;
    function GetMethod: string;
    function GetMethodID: integer;
    function GetReportAuthor: string;
    function GetSeismoGroupName: string;
    function GetYear: string;
  protected
    // присвоить
    procedure AssignTo(Dest: TPersistent); override;
  public
    // идентификатор метода
    property MethodID: integer read GetMethodID write FMethodID;
    // метод выявления
    property Method: string read GetMethod write FMethod;
    // год выявления
    property Year: string read GetYear write FYear;
    // автор отчета
    property ReportAuthor: string read GetReportAuthor write FReportAuthor;
    // номер сейсмопартии
    property SeismoGroupName: string read GetSeismoGroupName write FSeismogroupName;
    constructor Create(Collection: TIDObjects); override;
    destructor  Destroy; override;

    procedure Accept(Visitor: IVisitor); override;    
  end;

  TOldDiscoveredStructures = class(TOldStructures)
  private
    function GetItems(const Index: integer): TOldDiscoveredStructure;
  public
    property Items[const Index: integer]: TOldDiscoveredStructure read GetItems;
  end;

  TOldStructureWell = class(TBaseObject)
  protected
    FAreaID:                   integer;
    FWellUIN:                  integer;
    FDepth, FAltitude:         single;
    FAreaName, FWellNum,
    FOldAreaName, FOldWellNum: string;
    procedure   AssignTo(Dest: TPersistent); override; //
  public
    property    AreaName: string read FAreaName write FAreaName;
    property    WellNum:  string read FWellNum  write FWellNum;
    property    Altitude: single read FAltitude write FAltitude;
    property    Depth:    single read FDepth    write FDepth;
    function    List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string; override;
    constructor Create(Collection: TIDObjects); override; //
    destructor  Destroy; override;                         //
  end;

  TOldStructureWells = class(TBaseCollection)
  private
    FStructure: TOldStructure;
    function GetItems(const Index: integer): TOldStructureWell;
  public
    function Add(AUIN: integer): TOldStructureWell; reintroduce; overload;
    property Structure: TOldStructure read FStructure write FStructure;
    property Items[const Index: integer]: TOldStructureWell read GetItems;
    constructor Create(AOwner: TBaseObject); override;
  end;

  TOldDrilledStructureWell = class(TOldStructureWell)
  private
    FNegativeResultReason: string;
    FGisConfirmation: string;
    FStructModelConfirmation: string;
  protected
    procedure   AssignTo(Dest: TPersistent); override; //
  public
    property GISConfirmation: string read FGisConfirmation write FGISConfirmation;
    property StructModelConfirmation: string read FStructModelConfirmation write FStructModelConfirmation;
    property NegativeResultReason: string read FNegativeResultReason write FNegativeResultReason;
  end;

  TOldDrilledStructureWells = class(TOldStructureWells)
  private
    function GetItems(const Index: integer): TOldDrilledStructureWell;
  public
    property Items[const Index: integer]: TOldDrilledStructureWell read GetItems;
    function Add: TOldDrilledStructureWell; overload;
    constructor Create(AOwner: TBaseObject); override;
  end;

  // структура в бурении
  TOldDrilledStructure = class(TOldStructure)
  private
    FWells: TOldDrilledStructureWells;
    function GetWells: TOldDrilledStructureWells;
  protected
    // присвоить
    procedure AssignTo(Dest: TPersistent); override;
  public
    procedure AssignCollections(Source: TPersistent); override;
    // скважины
    property    Wells: TOldDrilledStructureWells read GetWells;
    procedure Accept(Visitor: IVisitor); override;
    constructor Create(Collection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TOldDrilledStructures = class(TOldStructures)
  private
    function GetItems(const Index: integer): TOldDrilledStructure;
  public
    property Items[const Index: integer]: TOldDrilledStructure read GetItems;
  end;

  // выведенная из фонда
  TOldOutOfFundStructure = class(TOldStructure)
  protected
    // присвоить
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(Collection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TOldOutOfFundStructures = class(TOldStructures)
  private
    function GetItems(const Index: integer): TOldOutOfFundStructure;
  public
    property Items[const Index: integer]: TOldOutOfFundStructure read GetItems;
  end;

  // месторождение
  TOldField = class(TOldStructure)
  private
    FFieldType: string;
    FFieldTypeID: integer;
    FDevelopingDegree: string;
    FFirstWell: TOldStructureWell;
    FDevelopingDegreeID: integer;
    FBeds: TOldBeds;
    FExploitationFinishYear: integer;
    FDiscoveringYear: integer;
    FExploitationStartYear: integer;
    FVersions: TOldAccountVersions;
    function GetBeds: TOldBeds;
    function GetVersions: TOldAccountVersions;
  protected
    procedure   AssignTo(Dest: TPersistent); override; //
    function    GetSubObjectsCount: integer; override;
  public
    procedure   AssignCollections(Source: TPersistent); override;

    // идентификатор типа меторождения
    property FieldTypeID: integer read FFieldTypeID write FFieldTypeID;
    // тип меторождения (нефтяное, газовое)
    property FieldType: string read FFieldType write FFieldType;

    // скважина-первооткрывательница
    property FirstWell: TOldStructureWell read FFirstWell write FFirstWell;

    // степень освоения
    property DevelopingDegreeID: integer read FDevelopingDegreeID write FDevelopingDegreeID;
    property DevelopingDegree: string read FDevelopingDegree write FDevelopingDegree;
    // залежи
    property Beds: TOldBeds read GetBeds;

    // год начала разработки
    property DiscoveringYear: integer read FDiscoveringYear write FDiscoveringYear;
    // год ввода в разработку
    property ExploitationStartYear: integer read FExploitationStartYear write FExploitationStartYear;
    // год вывода из эксплуатации
    property ExploitationFinishYear: integer read FExploitationFinishYear write FExploitationFinishYear;

    // версии документов (баланс, сводный баланс)
    property Versions: TOldAccountVersions read GetVersions;   

    procedure Accept(Visitor: IVisitor); override;

    constructor Create(Collection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TOldFields = class(TOldStructures)
  private
    function GetItems(const Index: integer): TOldField;
  public
    property Items[const Index: integer]: TOldField read GetItems;
  end;

  // элемент любой истории - на будущее
  TOldHistoryElement = class(TBaseObject)
  private
    FActionReasonID: integer;
    FActionTypeID: integer;
    FActionName: string;
    FComment: string;
    FActionReason: string;
    FActionType: string;
    FActionDate: TDateTime;
    FEmployeeID: integer;
    FEmployee: string;
    FRealDate: TDateTime;
    function GetHistoryOwner: TBaseObject;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    // владелец - для удобства обращения
    property HistoryOwner: TBaseObject read GetHistoryOwner;
    // тип действия
    property ActionTypeID: integer read FActionTypeID write FActionTypeID;
    property ActionType: string read FActionType write FActionType;
    // причина действия
    property ActionReasonID: integer read FActionReasonID write FActionReasonID;
    property ActionReason: string read FActionReason write FActionReason;
    // дата действия
    property ActionDate: TDateTime read FActionDate write FActionDate;
    // подробный коммент
    property Comment: string read FComment write FComment;
    // кто менял
    property EmployeeID: integer read FEmployeeID write FEmployeeID;
    property Employee: string read FEmployee write FEmployee;
    // когда реально меняли
    property RealDate: TDateTime read FRealDate write FRealDate;
    // собственное имя экшена
    // вроде "добавили/изменили параметр x"
    // инициализируется в потомках
    // по стратегии
    property ActionName: string read FActionName write FActionName;
    function    List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string; override;
    constructor Create(Collection: TIDObjects); override;
    destructor  Destroy; override;
    procedure Accept(Visitor: IVisitor); override;
  end;

  TOldHistory = class(TBaseCollection)
  private
    function GetItems(const Index: integer): TOldHistoryElement;
  public
    property Items[const Index: integer]: TOldHistoryElement read GetItems;
    function Add: TOldHistoryElement;
    constructor Create(AOwner: TBaseObject); override;
  end;



  TOldStructureHistoryElement = class(TOldHistoryElement)
  private
    FLastFundType: string;
    FFundType: string;
    FLastFundTypeID: integer;
    FFundTypeID: integer;
    FHistoryStructure: TOldStructure;
    function  GetStructure: TOldStructure;
    procedure SetLastFundTypeID(const Value: integer);
    function  GetHistoryStructure: TOldStructure;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    procedure AssignCollections(Source: TPersistent); override;
    // структура, над которой производилось действие
    property Structure: TOldStructure read GetStructure;
    // структура в том состоянии, которое было на момент данного элемента истории
    // создается по требованию в момент редакции
    property HistoryStructure: TOldStructure read GetHistoryStructure;
    // откуда и куда переходит
    property LastFundTypeID: integer read FLastFundTypeID write SetLastFundTypeID;
    property LastFundType: string read FLastFundType write FLastFundType;

    property FundTypeID: integer read FFundTypeID write FFundTypeID;
    property FundType: string read FFundType write FFundType;
    // когда перешла
    function List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string; override;
    procedure Accept(Visitor: IVisitor); override;
    constructor Create(Collection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TOldStructureHistory = class(TOldHistory)
  private
    function GetItems(const Index: integer): TOldStructureHistoryElement;
  public
    property Items[const Index: integer]: TOldStructureHistoryElement read GetItems;
    function GetElementByFundType(AFundTypeID: integer): TOldStructureHistoryElement;
    function GetElementByLastFundType(ALastFundTypeID: integer): TOldStructureHistoryElement;    
    function Add: TOldStructureHistoryElement;
    constructor Create(AOwner: TBaseObject); override;
  end;


  TOldFundType = class(TBaseObject)
  private
    FFundTypeName: string;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property FundTypeName: string read FFundTypeName write FFundTypeName;
    function List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string; override;
  end;

  TOldFundTypes = class(TBaseCollection)
  private
    function GetItems(const Index: integer): TOldFundType;
  public
    property Items[const Index: integer]: TOldFundType read GetItems;
    function Add: TOldFundType;
    constructor Create(AOwner: TBaseObject); override;
  end;



  // соответствует структуре на горизонте
  TOldHorizon = class(TBaseObject)
  private
    FOutOfFund: boolean;
    FFirstStratum: string;
    FSecondStratum: string;
    FSubstructures: TOldSubstructures;
    FOrganizationID: integer;
    FOrganization: string;
    FFirstStratumID: integer;
    FSecondStratumID: integer;
    FFirstStratumPostfix: string;
    FSecondStratumPostfix: string;
    FActive: boolean;
    FComplexID: integer;
    FComplex: string;
    FVersions: TOldAccountVersions;
    FComment: string;
    FInvestigationYear: string;
    FFundTypes: TOldFundTypes;
    function GetSubstructures: TOldSubstructures;
    function GetStructure: TOldStructure;
    function GetVersions: TOldAccountVersions;
    function GetFundTypes: TOldFundTypes;
  protected
    procedure AssignTo(Dest: TPersistent); override;
    function  GetObjectType: integer; override;
    function  GetMaterialBindType: integer; override;
    function  GetSubObjectsCount: integer; override;
  public
    procedure   AssignCollections(Source: TPersistent); override;
    // первый и второй горизонты там от - до
    property FirstStratumID: integer read FFirstStratumID write FFirstStratumID;
    property FirstStratum: string read FFirstStratum write FFirstStratum;
    property FirstStratumPostfix: string read FFirstStratumPostfix write FFirstStratumPostfix;

    property SecondStratumID: integer read FSecondStratumID write FSecondStratumID;
    property SecondStratum: string read FSecondStratum write FSecondStratum;
    property SecondStratumPostfix: string read FSecondStratumPostfix write FSecondStratumPostfix;

    // структура
    property Structure: TOldStructure read GetStructure;
    // вне фонда
    property OutOfFund: boolean read FOutOfFund write FOutOfFund;
    // подструктуры
    property Substructures: TOldSubstructures read GetSubstructures;

    // организация - бывает так, что один горизонт от стурутуры прингадлежит какой-то организации
    property OrganizationID: integer read FOrganizationID write FOrganizationID;
    property Organization: string read FOrganization write FOrganization;

{ DONE :
Разобраться с пластом: добавить в предстваление, в материализацию/дематериализацию,
в интерфейс. Отдельный объект в итоге стал.}
    // активный или пассивный фонд
    property Active: boolean read FActive write FActive;

    // идентификатор комплекса
    property ComplexID: integer read FComplexID write FComplexID;
    // НГК
    property Complex: string read FComplex write FComplex;
    // год
    property InvestigationYear: string read FInvestigationYear write FInvestigationYear;
    // комментарий
    property Comment: string read FComment write FComment;
    // соответствие фонду
    property FundTypes: TOldFundTypes read GetFundTypes;

    // вывод
    function List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string; override;

    // создаем пустые коллекции подструктур, которые будут грузиться по требованию
    constructor Create(AStructure: TOldStructure); reintroduce;
    // уничтожаем
    destructor Destroy; override;

    procedure Accept(Visitor: IVisitor); override;

    property Versions: TOldAccountVersions read GetVersions;    
  end;

  TOldOutOfFundHorizon = class(TOldHorizon)
  private
    FReason: string;
  public
    // причина исключения из фонда
    property Reason: string read FReason write FReason;
  end;


  TOldHorizons = class(TBaseCollection)
  private
    function GetItems(const Index: integer): TOldHorizon;
  public
    property Items[const Index: integer]: TOldHorizon read GetItems;
    function Add: TOldHorizon;
    constructor Create(AOwner: TBaseObject); override;
  end;


  TOldSubstructure = class(TBaseObject)
  private
    FRockID: integer;
    FRockName: string;
    FCollectorTypeID: integer;
    FCollectorType: string;
    FBedType: string;
    FBedTypeID: integer;
    FStructureElementID: integer;
    FStructureElement: string;
    FOrder: integer;
    FActualUntil: TDateTime;
    FStructureElementType: string;
    FRealName: string;
    FStructureElementTypeID: integer;
    FParameters: TOldParams;
    FReliability: single;
    FProbability: single;
    FQualityRange: string;
    FSubcomplexID: integer;
    FSubComplex: string;
    FControlDensity: single;
    FClosingIsogypse: single;
    FPerspectiveArea: single;
    FMapError: single;
    FAmplitude: single;
    FLayers: TOldLayers;
    FVersions: TOldAccountVersions;
    function GetHorizon: TOldHorizon;
    function GetParameters: TOldParams;
    function GetLayers: TOldLayers;
    function GetVersions: TOldAccountVersions;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
    function    GetObjectType: integer; override;
    function    GetMaterialBindType: integer; override;
    function    GetSubObjectsCount: integer; override;        
  public
    procedure   AssignCollections(Source: TPersistent); override;
    // литология
    property RockID: integer read FRockID write FRockID;
    // тип коллектора
    property CollectorTypeID: integer read FCollectorTypeID write FCollectorTypeID;
    // тип залежи
    property BedTypeID: integer read FBedTypeID write FBedTypeID;
    // блок, купол
    property StructureElementTypeID: integer read FStructureElementTypeID write FStructureElementTypeID;
    // подструктура из предопределденных
    property StructureElementID: integer read FStructureElementID write FStructureElementID;
    // идентификатор подкомплекса
    property SubComplexID: integer read FSubcomplexID write FSubcomplexID;
  public
    // литология
    property RockName: string read FRockName write FRockName;
    // тип коллектора
    property CollectorType: string read FCollectorType write FCollectorType;
    // тип залежи
    property BedType: string read FBedType write FBedType;
    // блок, купол и проч.
    property StructureElementType: string read FStructureElementType write FStructureElementType;
    // горизонт
    property Horizon: TOldHorizon read GetHorizon;
    // порядок
    property Order: integer read FOrder write FOrder;
    // наименование
    property StructureElement: string read FStructureElement write FStructureElement;
    property RealName: string read FRealName write FRealName;
    // неактуальна начианая с даты
    property ActualUntil: TDateTime read FActualUntil write FActualUntil;
    // НГК
    property SubComplex: string read FSubComplex write FSubComplex;
    // вывод
    function List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string; override;
    // параметры подструктуры
    property Parameters: TOldParams read GetParameters;
    // вероятность существования
    property Probability: single read FProbability write FProbability;
    // надежность
    property Reliability: single read FReliability write FReliability;
    // оценка качества
    property QualityRange: string read FQualityRange write FQualityRange;
    // замыкющая изогипса
    property ClosingIsogypse: single read FClosingIsogypse write FClosingIsogypse;
    // перспективная площадь
    property PerspectiveArea: single read FPerspectiveArea write FPerspectiveArea;
    //амплитуда
    property Amplitude: single read FAmplitude write FAmplitude;
    // контрольная плотность
    property ControlDensity: single read FControlDensity write FControlDensity;
    // стандартная ошибка карты
    property MapError: single read FMapError write FMapError;

    // продуктивные пласты
    property Layers: TOldLayers read GetLayers;
    property Versions: TOldAccountVersions read GetVersions;

    procedure Accept(Visitor: IVisitor); override;     
  end;

  TOldSubstructures = class(TBaseCollection)
  private
    function GetItems(const Index: integer): TOldSubstructure;
  public
    function Add: TOldSubstructure;
    property Items[const Index: integer]: TOldSubstructure read GetItems;
    constructor Create(AOwner: TBaseObject); override;
  end;

  // продуктивный пласт
  TOldLayer = class(TBaseObject)
  private
    FLayerID: integer;
    FCollectorTypeID: integer;
    FRockID: integer;
    FFillingCoef: single;
    FTrapHeight: single;
    FTrapArea: single;
    FBedArea: single;
    FBedHeight: single;
    FPower: single;
    FEffectivePower: single;
    FCollectorType: string;
    FRockName: string;
    FLayerIndex: string;
    FTrapTypeID: integer;
    FTrapType: string;
    FResourceVersions: TOldAccountVersions;
    FSubstructureUIN: integer;
    FBedID: integer;
    FBedTypeId: integer;
    FBedType: string;
    function GetBed: TOldBed;
    function GetSubstructure: TOldSubstructure;
    function GetResourceVersions: TOldAccountVersions;
  protected
    function GetObjectType: integer; override;
    procedure AssignTo(Dest: TPersistent); override;
    function GetMaterialBindType: integer; override;    
  public
    // литология
    property RockID: integer read FRockID write FRockID;
    property RockName: string read FRockName write FRockName;

    // пласт
    property LayerID: integer read FLayerID write FLayerID;
    property LayerIndex: string read FLayerIndex write FLayerIndex;

    // тип коллеектора
    property CollectorTypeID: integer read FCollectorTypeID write FCollectorTypeID;
    property CollectorType: string read FCollectorType write FCollectorType;

    // тип ловушки
    property  TrapTypeID: integer read FTrapTypeID write FTrapTypeID;
    property  TrapType: string read FTrapType write FTrapType;

    // тип залежи
    property  BedTypeID: integer read FBedTypeId write FBedTypeID;
    property  BedType: string read FBedType write FBedType; 

    // мощность
    property Power: single read FPower write FPower;
    // эффективная мощность
    property EffectivePower: single read FEffectivePower write FEffectivePower;
    // коэффициент заполнения
    property FillingCoef: single read FFillingCoef write FFillingCoef;
    // высота ловушки
    property TrapHeight: single read FTrapHeight write FTrapHeight;
    // площадь ловушки
    property TrapArea: single read FTrapArea write FTrapArea;
    // высота залежи
    property BedHeight: single read FBedHeight write FBedHeight;
    // площадь залежи
    property BedArea: single read FBedArea write FBedArea;
    // подструктура для продуктивного пласта, который сввязан с залежью в интерфейсном дереве
    property SubstructureUIN: integer read FSubstructureUIN write FSubstructureUIN;
    // подструктура
    property Substructure: TOldSubstructure read GetSubstructure;

    // залежь, к которой принадлежит продуктивный пласт
    property BedID: integer read FBedID write FBedID;

    // залежь
    property Bed: TOldBed read GetBed;

    // вывод
    function List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string; override;
    // версии ресурсов, запасов и параметров
    property Versions: TOldAccountVersions read GetResourceVersions;

    procedure Accept(Visitor: IVisitor); override;
  end;

  TOldLayers = class(TBaseCollection)
  private
    function GetItems(const Index: integer): TOldLayer;
  public
    function Add: TOldLayer;
    property Items[const Index: integer]: TOldLayer read GetItems;
    constructor Create(AOwner: TBaseObject); override;
  end;


  // залежь
  TOldBed = class(TBaseObject)
  private
    FCollectorTypeID: integer;
    FAgeID: integer;
    FComplexID: integer;
    FBedTypeID: integer;
    FDepth: single;
    FBedHeight: single;
    FBedArea: single;
    FBedIndex: string;
    FComplexName: string;
    FBedType: string;
    FCollectorType: string;
    FAge: string;
    FRockID: integer;
    FRock: string;
    FHorizons: TOldHorizons;
    FSubstructures: TOldSubstructures;
    FFluidTypeID: integer;
    FFluidType: string;
    FLayers: TOldLayers;
    FVersions: TOldAccountVersions;
    FStructureElementID: integer;
    FStructureElementTypeID: integer;
    FStructureElementType: string;
    FStructureElement: string;
    FIsBalanced: boolean;
    function GetHorizons: TOldHorizons;
    function GetStructure: TOldStructure;
    function GetSubstructure: TOldSubstructure;
    function GetSubstructures: TOldSubstructures;
    function GetField: TOldField;
    function GetLayers: TOldLayers;
    function GetVerions: TOldAccountVersions;
  protected
    function   GetObjectType: integer; override;
    procedure  AssignTo(Dest: TPersistent); override;
    function   GetSubObjectsCount: integer; override;
  public
    procedure  AssignCollections(Source: TPersistent); override;
    // идентификатор типа залежи
    property BedTypeID: integer read FBedTypeID write FBedTypeID;
    // тип залежи
    property BedType: string read FBedType write FBedType;

    // идентификатор типа флюида залежи
    property FluidTypeID: integer read FFluidTypeID write FFluidTypeID;
    // тип флюида залежи
    property FluidType: string read FFluidType write FFluidType;

    // идентификатор типа коллектора
    property CollectorTypeID: integer read FCollectorTypeID write FCollectorTypeID;
    // тип коллектора
    property CollectorType: string read FCollectorType write FCollectorType;

    // идентификатор литологии
    property RockID: integer read FRockID write FRockID;
    // литология коллектора
    property RockName: string read FRock write FRock;

    // возраст залежи
    property AgeID: integer read FAgeID write FAgeID;
    property Age: string read FAge write FAge;

    // блок, купол
    property StructureElementTypeID: integer read FStructureElementTypeID write FStructureElementTypeID;
    property StructureElementType: string read FStructureElementType write FStructureElementType;
    // подструктура из предопределденных
    property StructureElementID: integer read FStructureElementID write FStructureElementID;
    property StructureElement: string read FStructureElement write FStructureElement;
    // подструктуры, из которых состоит залежь
    property Substructures: TOldSubstructures read GetSubstructures;
    // подструктура, в которую входит залежь
    property Substructure: TOldSubstructure read GetSubstructure;


    // в балансе или нет
    property IsBalanced: boolean read FIsBalanced write FIsBalanced; 

    // горизонты, из которых состоит залежь
    property Horizons: TOldHorizons read GetHorizons;
    // структура
    property Structure: TOldStructure read GetStructure;
    // месторождения
    property Field: TOldField read GetField;

    // индекс залежи
    property BedIndex: string read FBedIndex write FBedIndex;
    // нефтегазоносный комплекс
    property ComplexID: integer read FComplexID write FComplexID;
    property ComplexName: string read FComplexName write FComplexName;

    // глубина кровли
    property Depth: single read FDepth write FDepth;
    // высота залежи
    property BedHeight: single read FBedHeight write FBedHeight;
    // площадь залежи (площадь нефтеносности)
    property BedArea: single read FBedArea write FBedArea;
    constructor Create(ACollection: TIDObjects); override;
    // вывод
    function List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string; override;

    // продуктивные пласты
    property Layers: TOldLayers read GetLayers;
    // версии всяких параметров
    property Versions: TOldAccountVersions read GetVerions;

    procedure Accept(Visitor: IVisitor); override;
  end;

  TOldBeds = class(TBaseCollection)
  private
    function GetItems(const Index: integer): TOldBed;
  public
    function Add: TOldBed;
    property Items[const Index: integer]: TOldBed read GetItems;
    constructor Create(AOwner: TBaseObject); override;
  end;

  TOldAccountVersion = class(TBaseObject)
  private
    FVersionID: integer;
    FDocTypeID: integer;
    FAuthors: string;
    FDocName: string;
    FVersion: string;
    FDocType: string;
    FResources: TOldResources;
    FCreatorOrganizationID: integer;
    FAffirmatorOrganizationID: integer;
    FCreatorOrganization: string;
    FAffirmatorOrganization: string;
    FCreationDate: TDateTime;
    FAffirmationDate: TDateTime;
    FAffirmed: boolean;
    FReserves: TOldReserves;
    FParams: TOldLayerParams;
    FDocuments: TOldDocuments;
    FContainsResources: boolean;
    FContainsParams: boolean;
    FContainsReserves: boolean;
    FContainsDocuments: boolean;
    function GetResources: TOldResources;
    function GetLayer: TOldLayer;
    function GetReserves: TOldReserves;
    function GetParams: TOldLayerParams;
    function GetBed: TOldBed;
    function GetHorizon: TOldHorizon;
    function GetStructure: TOldStructure;
    function GetSubstructure: TOldSubstructure;
    function GetDocuments: TOldDocuments;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    // версия
    property VersionID: integer read FVersionID write FVersionID;
    property Version: string read FVersion write FVersion;

    // тип документа
    property DocTypeID: integer read FDocTypeID write FDocTypeID;
    property DocType: string read FDocType write FDocType;

    // наименование документа
    property DocName: string read FDocName write FDocName;

    // организация, подготовившая подсчет
    property CreatorOrganizationID: integer read FCreatorOrganizationID write FCreatorOrganizationID;
    property CreatorOrganization: string read FCreatorOrganization write FCreatorOrganization;

    // автор
    property Authors: string read FAuthors write FAuthors;

    // дата создания
    property CreationDate: TDateTime read FCreationDate write FCreationDate;

    // организация, утвержившая документ подсчета
    property AffirmatorOrganizationID: integer read FAffirmatorOrganizationID write FAffirmatorOrganizationID;
    property AffirmatorOrganization: string read FAffirmatorOrganization write FAffirmatorOrganization;

    // дата утверждения
    property AffirmationDate: TDateTime read FAffirmationDate write FAffirmationDate;

    // утвержден
    property Affirmed: boolean read FAffirmed write FAffirmed;

    function List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string; override;

    // ресурсы
    property Resources: TOldResources read GetResources;
    // запасы
    property Reserves: TOldReserves read GetReserves;
    // параметры
    property Parameters: TOldLayerParams read GetParams;
    // документы
    property Documents: TOldDocuments read GetDocuments;

    // версия может принадлежать чему угодно
    property Layer: TOldLayer read GetLayer;
    property Bed: TOldBed read GetBed;
    property Substructure: TOldSubstructure read GetSubstructure;
    property Horizon: TOldHorizon read GetHorizon;
    property Structure: TOldStructure read GetStructure;

    // включает запасы
    property ContainsReserves: boolean read FContainsReserves write FContainsReserves;
    // включает ресурсы
    property ContainsResources: boolean read FContainsResources write FContainsResources;
    // включает параметры
    property ContainsParams: boolean read FContainsParams write FContainsParams;
    // вклбчает документы
    property ContainsDocuments: boolean read FContainsDocuments write FContainsDocuments;

    constructor Create(ACollection: TIDObjects); override;
    procedure Accept(Visitor: IVisitor); override;
  end;

  TOldAccountVersions = class(TBaseCollection)
  private
    function GetItems(const Index: integer): TOldAccountVersion;
    function GetBed: TOldBed;
    function GetHorizon: TOldHorizon;
    function GetLayer: TOldLayer;
    function GetStructure: TOldStructure;
    function GetSubstructure: TOldSubstructure;
    function GetContainsReserves: boolean;
  public
    property Layer: TOldLayer read GetLayer;
    property Bed: TOldBed read GetBed;
    property Substructure: TOldSubstructure read GetSubstructure;
    property Horizon: TOldHorizon read GetHorizon;
    property Structure: TOldStructure read GetStructure;

    procedure ParametersClear;
    procedure ResourcesClear;
    procedure ReservesClear;

    property  ContainsReserves: boolean read GetContainsReserves;

    function Add: TOldAccountVersion;
    property Items[const Index: integer]: TOldAccountVersion read GetItems;
    constructor Create(AOwner: TBaseObject); override;
  end;

  TOldReserve = class(TBaseObject)
  private
    FFluidTypeID: integer;
    FCategoryID: integer;
    FReserveKindID: integer;
    FValue: single;
    FReserveKind: string;
    FFluidType: string;
    FCategory: string;
    FReserveTypeID: integer;
    FReserveType: string;
    FReserveValueTypeID: integer;
    FReserveValueTypeName: string;
    FLicenseZone: TSimpleLicenseZone;
    function GetLayer: TOldLayer;
    function GetVersion: TOldAccountVersion;
  protected
    procedure  AssignTo(Dest: TPersistent); override;
  public
    // категория запасов
    property ReserveCategoryID: integer read FCategoryID write FCategoryID;
    property ReserveCategory: string read FCategory write FCategory;
    // тип флюида
    property FluidTypeID: integer read FFluidTypeID write FFluidTypeId;
    property FluidType: string read FFluidType write FFluidType;
    // вид запасов
    property ReserveKindID: integer read FReserveKindID write FReserveKindID;
    property ReserveKind: string read FReserveKind write FReserveKind;
    // тип ресурсов - геологические или извлекаемые
    property ReserveTypeID: integer read FReserveTypeID write FReserveTypeID;
    property ReserveType: string read FReserveType write FReserveType;
    // тип запасов
    property ReserveValueTypeID: integer read FReserveValueTypeID write FReserveValueTypeID;
    property ReserveValueTypeName: string read FReserveValueTypeName write FReserveValueTypeName;
    // к какому лицензионному участку относится значение запасов
    property LicenseZone: TSimpleLicenseZone read FLicenseZone write FLicenseZone;
    // значение
    property Value: single read FValue write FValue;
    // описать
    function List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string; override;

    function Check: boolean; override;

    property Version: TOldAccountVersion read GetVersion;
    property Layer: TOldLayer read GetLayer;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TOldReserves = class(TBaseCollection)
  private
    FReserves: TOldReserves;
    FFluidTypes: TIntegerList;
    function GetItems(const Index: integer): TOldReserve;
    function GetCalculatedReserves: TOldReserves;
    function GetUniqueFluidTypes: TIntegerList;
  public
    property  UniqueFluidTypes: TIntegerList read GetUniqueFluidTypes;
    property  CalculatedReserves: TOldReserves read GetCalculatedReserves;
    procedure CalculateReserves;

    function Add: TOldReserve;

    function AddReserve(ACategoryID: Integer; AKindID: integer; ATypeID: Integer; AValueTypeID: integer; AFluidTypeID: integer; AValue: Single): TOldReserve; 
    property Items[const Index: integer]: TOldReserve read GetItems;
    constructor Create(AOwner: TBaseObject); override;
    destructor Destroy; override;
  end;

  TOldResource = class(TBaseObject)
  private
    FresourceCategoryID: integer;
    FResourceTypeID: integer;
    FFluidTypeID: integer;
    FFluidType: string;
    FResourceCategory: string;
    FResourceType: string;
    FValue: single;
    function GetVersion: TOldAccountVersion;
    function GetLayer: TOldLayer;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    // тип флюида
    property FluidTypeID: integer read FFluidTypeID write FFluidTypeId;
    property FluidType: string read FFluidType write FFluidType;
    // тип ресурсов - геологические или извлекаемые
    property ResourceTypeID: integer read FResourceTypeID write FResourceTypeID;
    property ResourceType: string read FResourceType write FResourceType;
    // категория ресурсов
    property ResourceCategoryID: integer read FresourceCategoryID write FResourceCategoryID;
    property ResourceCategory: string read FResourceCategory write FResourceCategory;
    // значение
    property Value: single read FValue write FValue;
    // версия, к которой принадлежит элемент данных
    property Version: TOldAccountVersion read GetVersion;
    // продуктивный пласт
    property Layer: TOldLayer read GetLayer;
    // вывод
    function List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string; override;
  end;

  TOldResources = class(TBaseCollection)
  private
    function GetItems(const Index: integer): TOldResource;
  public
    function Add: TOldResource;
    property Items[const Index: integer]: TOldResource read GetItems;
    constructor Create(AOwner: TBaseObject); override;
  end;


  TOldParam = class(TBaseObject)
  private
    FOrder: integer;
    FFluidTypeID: integer;
    FValue: single;
    FParamSign: string;
    FParamName: string;
    FFluidType: string;
    FParamID: integer;
    FMeasureUnitID: integer;
    FMeasureUnitName: string;
    FParamTypeID: integer;
    FParamType: string;
    FResourceCategoryID: integer;
    FResourceCategory: string;
    FRelationshipID: integer;
    FRelationshipName: string;
    FLicenseZone: TSimpleLicenseZone;
    FnextValue: single;
    FIsRange: boolean;
    function GetSubstructure: TOldSubstructure;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    property ParamID:   integer read FParamID write FParamID;
    property ParamName: string read FParamName write FParamName;
    property ParamSign: string read FParamSign write FParamSign;

    // тип параметра
    property ParamTypeID: integer read FParamTypeID write FParamTypeID;
    property ParamType: string read FParamType write FParamType;

    // тип флюида
    property FluidTypeID: integer read FFluidTypeID write FFluidTypeId;
    property FluidType: string read FFluidType write FFluidType;

    // категория запасов (ресурсов)
    property ResourceCategoryID: integer read FResourceCategoryID write FResourceCategoryID;
    property ResourceCategory: string read FResourceCategory write FResourceCategory;

    // тип отношения
    property RelationshipID: integer read FRelationshipID write FRelationshipID;
    property RelationshipName: string read FRelationshipName write FRelationshipName;

    // значение-диапазон
    property IsRange: boolean read FIsRange write FIsRange;

    // принадлежность к лицензионному участку
    property LicenseZone: TSimpleLicenseZone read FLicenseZone write FLicenseZone;

    // порядок
    property Order: integer read FOrder write FOrder;
    // значение
    property Value: single read FValue write FValue;
    // второе значение (при диапазоне)
    property NextValue: single read FnextValue write FNextValue;

    // единица измерения
    property MeasureUnitID: integer read FMeasureUnitID write FMeasureUnitID;
    property MeasureUnitName: string read FMeasureUnitName write FMeasureUnitName;

    // проверка целостности
    function Check: boolean; override;
    // вывод
    function List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string; override;
    // подструктура
    property Substructure: TOldSubstructure read GetSubstructure;
  end;

  TOldParams = class(TBaseCollection)
  private
    function GetItems(const Index: integer): TOldParam;
  public
    function Add: TOldParam;
    property Items[const Index: integer]: TOldParam read GetItems;
    function GetParam(const AFluidTypeID, AParamID: integer): TOldParam;
    constructor Create(AOwner: TBaseObject); override;
  end;

  TOldLayerParams = class(TOldParams)


  end;

  TOldPerfectStructureHistoryElement = class(TOldStructureHistoryElement)
  private
    FRealStructureHistoryElement: TOldStructureHistoryElement;
  public
    function List(ListOption: TListOption; IncludeKey: boolean; Recourse: boolean): string; override;
    property RealStructureHistoryElement: TOldStructureHistoryElement read FRealStructureHistoryElement write FRealStructureHistoryElement;
    constructor Create(Collection: TIDObjects); override;
  end;

  TOldPerfectStructureHistory = class(TOldStructureHistory)
  private
    function GetItems(const Index: integer): TOldPerfectStructureHistoryElement;
  public
    procedure   RestoreState;
    property    Items[const Index: integer]: TOldPerfectStructureHistoryElement read GetItems;
    constructor Create(AOwner: TBaseObject); override;
  end;


  TOldDocument = class(TBaseObject)
  private
    FOrganizationID: integer;
    FThemeID: integer;
    FDocName: string;
    FAuthors: string;
    FThemeName: string;
    FComment: string;
    FCreationDate: TDateTime;
    FOrganizationName: string;
    FMediumID: integer;
    FUserBindAttributes: string;
    FMediumName: string;
    FMaterialTypeID: integer;
    FMaterialType: string;
    FPreLocation: string;
    FPreLocationChanged: boolean;
    function  GetBindAttributes: string;
    function  GetVersion: TOldAccountVersion;
    function  GetLocation: string;
    procedure SetPreLocation(const Value: string);
    function  GetFileName: string;
  protected
    procedure  AssignTo(Dest: TPersistent); override;
  public
    property DocName: string read FDocName write FDocName;
    property Authors: string read FAuthors write FAuthors;
    property CreationDate: TDateTime read FCreationDate write FCreationDate;
    property Location: string read GetLocation;
    property PreLocation: string read FPreLocation write SetPreLocation;
    property PreLocationChanged: boolean read FPreLocationChanged;
    property FileName: string read GetFileName;
    property Comment: string read FComment write FComment;

    property ThemeID: integer read FThemeID write FThemeID;
    property ThemeName: string read FThemeName write FThemeName;

    property OrganizationID: integer read FOrganizationID write FOrganizationID;
    property OrganizationName: string read FOrganizationName write FOrganizationName;

    property MediumID: integer read FMediumID write FMediumID;
    property MediumName: string read FMediumName write FMediumName;

    property MaterialTypeID: integer read FMaterialTypeID write FMaterialTypeID;
    property MaterialType: string read FMaterialType write FMaterialType;       

    property BindAttributes: string read GetBindAttributes;
    property UserBindAttrbutes: string read FUserBindAttributes write FUserBindAttributes;

    function List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string; override;

    property Version: TOldAccountVersion read GetVersion;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TOldDocuments = class(TBaseCollection)
  private
    function GetItems(const Index: integer): TOldDocument;
  public
    function Add: TOldDocument;
    property Items[const Index: integer]: TOldDocument read GetItems;
    constructor Create(AOwner: TBaseObject); override;
  end;



implementation

uses Facade, Structure;

{ TOldStructure }

procedure TOldStructure.Accept(Visitor: IVisitor);
var v: IConcreteVisitor;
begin
  inherited;
  v := IConcreteVisitor(Visitor);
  v.VisitStructure(Self);
end;

procedure TOldStructure.AssignCollections(Source: TPersistent);
var s: TOldStructure;
    i: integer;
begin
  s := Source as TOldStructure;

  Horizons.Assign(s.Horizons);
  for i := 0 to Horizons.Count - 1 do
    Horizons.Items[i].AssignCollections(s.Horizons.Items[i]);
end;

procedure TOldStructure.AssignTo(Dest: TPersistent);
var s: TOldStructure;
begin
  s := Dest as TOldStructure;
  s.ID := ID;

  s.StructureTypeID := StructureTypeID;
  s.StructureType := StructureType;
  // нефтегазоносный регион
  s.PetrolRegions.Clear;
  s.PetrolRegions.AddObjects(PetrolRegions, false, false);
  // тектоническая структура
  s.TectonicStructs.Clear;
  s.TectonicStructs.AddObjects(TectonicStructs, false, false);
  // географический регион
  s.Districts.Clear;
  s.Districts.AddObjects(Districts, false, false);
  // площадь
  s.AreaID := AreaID;
  s.Area := Area;
  // организация
  s.OrganizationID := OrganizationID;
  s.Organization := Organization;
  // организация-недропользователль
  s.OwnerOrganizationID := OwnerOrganizationID;
  s.OwnerOrganization := OwnerOrganization;
  // наименование структуры
  s.Name := Name;
  // выведена из фонда
  s.OutOfFund := OutOfFund;
  s.Actual := Actual;
  // копируем параметры
  s.Versions.Assign(Versions);
end;

constructor TOldStructure.Create(Collection: TIDObjects);
begin
  inherited;
end;

destructor TOldStructure.Destroy;
begin
  if Assigned(FHorizons) then
    FHorizons.Free;
  inherited;
end;

function TOldStructure.GetAccountVersions: TOldAccountVersions;
begin
  if not Assigned(FVersions) then FVersions := TOldAccountVersions.Create(Self);
  Result := FVersions;
end;

function TOldStructure.GetCartoHorizon: TOldHorizon;
begin
  Result := Horizons.ItemsByUIN[CartoHorizonID] as TOldHorizon;
end;

function TOldStructure.GetDistricts: TDistricts;
begin
  if not Assigned(FDistricts) then
  begin
    FDistricts := TStructureOwnedDistricts.Create;
    FDistricts.Owner := Self;
    FDistricts.Reload('VERSION_ID = ' + IntToStr(TMainFacade.GetInstance.ActiveVersion.ID)+ '  AND OBJECT_TYPE_ID = ' + IntToStr(DISTRICT_OBJECT_TYPE_ID)  + ' AND STRUCTURE_ID = ' + IntToStr(ID));
  end;

  Result := FDistricts;
end;

function TOldStructure.GetHistory: TOldStructureHistory;
begin
  if not Assigned(FHistory) then FHistory := TOldStructureHistory.Create(Self);
  Result := FHistory;
end;

function TOldStructure.GetHorizons: TOldHorizons;
begin
  if not Assigned(FHorizons) then FHorizons := TOldHorizons.Create(Self);
  Result := FHorizons;
end;

function TOldStructure.GetLicenseZones: TSimpleLicenseZones;
begin
  if not Assigned(FLicenseZones) then
  begin
    FLicenseZones := TStrucureOwnedLicenseZones.Create;
    FLicenseZones.Owner := Self;
    FLicenseZones.Reload('VERSION_ID = ' + IntToStr(TMainFacade.GetInstance.ActiveVersion.ID)+ ' AND OBJECT_TYPE_ID = ' + IntToStr(LICENSE_ZONE_OBJECT_TYPE_ID)  + ' AND STRUCTURE_ID = ' + IntToStr(ID));
  end;

  Result := FLicenseZones;
end;

function TOldStructure.GetMaterialBindType: integer;
begin
  Result := 6;
end;

function TOldStructure.GetObjectType: integer;
begin
  Result := 0;
end;

function TOldStructure.GetPetrolRegions: TPetrolRegions;
begin
  if not Assigned(FPetrolRegions) then
  begin
    FPetrolRegions := TStructureOwnedPetrolRegions.Create;
    FPetrolRegions.Owner := Self;
    FPetrolRegions.Reload('VERSION_ID = ' + IntToStr(TMainFacade.GetInstance.ActiveVersion.ID)+ ' AND OBJECT_TYPE_ID = ' + IntToStr(PETROL_REGION_OBJECT_TYPE_ID)  + ' AND STRUCTURE_ID = ' + IntToStr(ID));
  end;

  Result := FPetrolRegions;
end;

function TOldStructure.GetSubObjectsCount: integer;
var i: integer;
begin
  Result := Horizons.Count;

  for i := 0 to Horizons.Count - 1 do
    Result := Result + Horizons.Items[i].SubObjectsCount;
end;

function TOldStructure.GetTectonicStructs: TTectonicStructures;
begin
  if not Assigned(FTectonicStructs) then
  begin
    FTectonicStructs := TStructureOwnedTectonicStructs.Create;
    FTectonicStructs.Owner := Self;
    FTectonicStructs.Reload('VERSION_ID = ' + IntToStr(TMainFacade.GetInstance.ActiveVersion.ID)+ ' AND OBJECT_TYPE_ID = ' + IntToStr(TECTONIC_STRUCT_OBJECT_TYPE_ID)  + ' AND STRUCTURE_ID = ' + IntToStr(ID));
  end;

  Result := FTectonicStructs;
end;

function TOldStructure.List(ListOption: TListOption;
  IncludeKey: boolean; Recource: boolean): string;
begin
  Result := inherited List(ListOption, IncludeKey, Recource);

  if ListOption in [loBrief, loHierarchicalName] then
    Result := Result + Name
  else
  begin
    if ListOption <> loBindAttributes then
    begin
      Result := Result + Name + ' - ' + StructureType;
      if ListOption = loMedium then
        Result := Result + '(' + PetrolRegions.List + ')'
      else if ListOption = loFull then
        Result := Result +  '; '+ Area + '; ' + TectonicStructs.List + '; ' + Districts.List;
    end
    else if ListOption <> loMapAttributes then
      Result := Result + Name + ', ' + Organization
    else
      Result := Result + Name;
  end;
end;

procedure TOldStructure.StructureMainParamsAssign(Source: TOldStructure);
begin
  ID := Source.ID;

  // нефтегазоносный регион
  PetrolRegions.Clear;
  PetrolRegions.AddObjects(Source.PetrolRegions, false, false);
  // тектоническая структура
  TectonicStructs.Clear;
  TectonicStructs.AddObjects(Source.TectonicStructs, false, false);
  // географический регион
  Districts.Clear;
  Districts.AddObjects(Source.Districts, false, false);
  // площадь
  AreaID := Source.AreaID;
  Area := Source.Area;
{  // организация
  OrganizationID := Source.OrganizationID;
  Organization := Source.Organization;}
  // организация-недропользователль
  OwnerOrganizationID := Source.OwnerOrganizationID;
  OwnerOrganization := Source.OwnerOrganization;
  // наименование структуры
  Name := Source.Name;
  // выведена из фонда
  OutOfFund := Source.OutOfFund;
  Actual := Source.Actual;
end;

{ TOldField }

procedure TOldField.Accept(Visitor: IVisitor);
var v: IConcreteVisitor;
begin
  v := IConcreteVisitor(Visitor);
  v.VisitField(Self);
end;

procedure TOldField.AssignCollections(Source: TPersistent);
var i: integer;
    f: TOldField;
begin
  inherited;

  f := Source as TOldField;
  Beds.Assign(f.Beds);
  for i := 0 to Beds.Count - 1 do
    Beds.Items[i].AssignCollections(f.Beds.Items[i]);
end;

procedure TOldField.AssignTo(Dest: TPersistent);
var f: TOldField;
begin
  inherited;

  if Dest is TOldField then
  begin
    f := Dest as TOldField;
    // идентификатор лицензионного участка

    f.LicenseZones.Clear;
    f.LicenseZones.AddObjects(LicenseZones, false, false);

    // идентификатор типа меторождения
    f.FieldTypeID := FieldTypeID;
    f.FieldType := FieldType;

    // скважина-первооткрывательница
    f.FirstWell.Assign(FirstWell);

    // степень освоения
    f.DevelopingDegreeID := DevelopingDegreeID;
    f.DevelopingDegree := DevelopingDegree;
  end;
end;

constructor TOldField.Create(Collection: TIDObjects);
begin
  inherited;
  // инициализируем как месторождение
  StructureTypeID := 4;
  StructureType := GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_STRUCTURE_FUND_TYPE_DICT'].Dict, StructureTypeID);

  FirstWell := TOldStructureWell.Create(nil);
end;

destructor TOldField.Destroy;
begin
  FirstWell.Free;
  inherited;
end;

function TOldField.GetBeds: TOldBeds;
begin
  if not Assigned(FBeds) then FBeds := TOldBeds.Create(Self);
  Result := FBeds;
end;

function TOldField.GetSubObjectsCount: integer;
var i: integer;
begin
  Result := inherited GetSubObjectsCount;

  Result := Result + Beds.Count;

  for i := 0 to Beds.Count - 1 do
    Result := Result + Beds.Items[i].SubObjectsCount;
end;

function TOldField.GetVersions: TOldAccountVersions;
begin
  if not Assigned(FVersions) then FVersions := TOldAccountVersions.Create(Self);
  Result := FVersions;
end;

{ TOldPreparedStructure }

procedure TOldPreparedStructure.Accept(Visitor: IVisitor);
var v: IConcreteVisitor;
begin
  inherited;
  v := IConcreteVisitor(Visitor);
  v.VisitPreparedStructure(Self);
end;

procedure TOldPreparedStructure.AssignTo(Dest: TPersistent);
var s: TOldPreparedStructure;
begin
  inherited;
  if Dest is TOldPreparedStructure then
  begin
    s := Dest as TOldPreparedStructure;
    // идентификатор метода
    s.MethodID := MethodID;
    s.Method := Method;
    // год подготовки
    s.Year := Year;
    // автор отчета
    s.ReportAuthor := ReportAuthor;
    // номер сейсмопартии
    s.SeismoGroupName := SeismogroupName;
  end;
end;

constructor TOldPreparedStructure.Create(Collection: TIDObjects);
begin
  inherited;
  // инициализируем как подготовленную
  StructureTypeID := 2;
  StructureType := GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_STRUCTURE_FUND_TYPE_DICT'].Dict, StructureTypeID);
end;

destructor TOldPreparedStructure.Destroy;
begin
  inherited;

end;

function TOldPreparedStructure.GetMethod: string;
begin
  Result := FMethod;
end;

function TOldPreparedStructure.GetMethodID: integer;
begin
  Result := FMethodID;
end;

function TOldPreparedStructure.GetReportAuthor: string;
begin
  Result := FReportAuthor;
end;

function TOldPreparedStructure.GetSeismoGroupName: string;
begin
  Result := FSeismogroupName;
end;

function TOldPreparedStructure.GetYear: string;
begin
  Result := FYear;
end;

{ TOldDiscoveredStructure }

procedure TOldDiscoveredStructure.Accept(Visitor: IVisitor);
var v: IConcreteVisitor;
begin
  inherited;
  v := IConcreteVisitor(Visitor);
  v.VisitDiscoveredStructure(Self);
end;

procedure TOldDiscoveredStructure.AssignTo(Dest: TPersistent);
var s: TOldDiscoveredStructure;
begin
  inherited;
  if Dest is TOldDiscoveredStructure then
  begin
    s := Dest as TOldDiscoveredStructure;
    // идентификатор метода
    s.MethodID := MethodID;
    s.Method := Method;
    // год подготовки
    s.Year := Year;
    // автор отчета
    s.ReportAuthor := ReportAuthor;
    // номер сейсмопартии
    s.SeismoGroupName := SeismogroupName;
  end;
end;

constructor TOldDiscoveredStructure.Create(Collection: TIDObjects);
begin
  inherited;
  // инициализруем как выявленную
  StructureTypeID := 1;
  StructureType := GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_STRUCTURE_FUND_TYPE_DICT'].Dict, StructureTypeID);
end;

destructor TOldDiscoveredStructure.Destroy;
begin
  inherited;

end;

function TOldDiscoveredStructure.GetMethod: string;
begin
  Result := FMethod;
end;

function TOldDiscoveredStructure.GetMethodID: integer;
begin
  Result := FMethodID;
end;

function TOldDiscoveredStructure.GetReportAuthor: string;
begin
  Result := FReportAuthor;
end;

function TOldDiscoveredStructure.GetSeismoGroupName: string;
begin
  Result := FSeismogroupName;
end;

function TOldDiscoveredStructure.GetYear: string;
begin
  Result := FYear;
end;

{ TOldDrilledStructure }

procedure TOldDrilledStructure.Accept(Visitor: IVisitor);
var v: IConcreteVisitor;
begin
  inherited;
  v := IConcreteVisitor(Visitor);
  v.VisitDrilledStructure(Self);
end;

procedure TOldDrilledStructure.AssignCollections(Source: TPersistent);
var  ds: TOldDrilledStructure;
begin
  inherited;

  ds := Source as TOldDrilledStructure;

  Wells.Assign(ds.Wells);
end;

procedure TOldDrilledStructure.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TOldDrilledStructure.Create(Collection: TIDObjects);
begin
  inherited;
  // инициализируем как структуру в бурении
  StructureTypeID := 3;
  StructureType := GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_STRUCTURE_FUND_TYPE_DICT'].Dict, StructureTypeID);
end;

destructor TOldDrilledStructure.Destroy;
begin
  FWells.Free;
  FWells := nil;
  inherited;
end;

function TOldDrilledStructure.GetWells: TOldDrilledStructureWells;
begin
  if not Assigned(FWells) then FWells := TOldDrilledStructureWells.Create(Self);
  Result := FWells;
end;

{ TOldOutOfFundStructure }

procedure TOldOutOfFundStructure.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TOldOutOfFundStructure.Create(Collection: TIDObjects);
begin
  inherited;
  // вне фонда
  StructureTypeID := 0;
  StructureType := GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_STRUCTURE_FUND_TYPE_DICT'].Dict, StructureTypeID);
end;

destructor TOldOutOfFundStructure.Destroy;
begin
  inherited;

end;

{ TOldStructures }

function TOldStructures.Add: TOldStructure;
begin
  Result := inherited Add as TOldStructure;
end;

function TOldStructures.Add(AStructureClass: TOldStructureClass): TOldStructure;
begin
  Result := AStructureClass.Create(Self);
  inherited Add(Result, false, false);
end;

function TOldStructures.Add(const AID: integer): TOldStructure;
var cls: TOldStructureClass;
begin
  cls := TOldStructure;
  case AID of
  // Выявленные
  1: cls := TOldDiscoveredStructure;
  // подгтовленные
  2: cls := TOldPreparedStructure;
  // в бурении
  3: cls := TOldDrilledStructure;
  // месторождения
  4: cls := TOldField;
  end;

  Result := Add(cls);
  if cls <> TOldStructure then Result.NeedsUpdate := true;
end;


constructor TOldStructures.Create(AOwner: TBaseObject);
begin
  FOwner := AOwner;
  inherited Create(TOldStructure);
end;



function TOldStructures.GetItems(const Index: integer): TOldStructure;
begin
  Result := inherited Items[Index] as TOldStructure;
end;





{ TOldPreparedStructures }

function TOldPreparedStructures.GetItems(
  const Index: integer): TOldPreparedStructure;
begin
  Result := inherited Items[Index] as TOldPreparedStructure;
end;

{ TOldDiscoveredStructures }

function TOldDiscoveredStructures.GetItems(
  const Index: integer): TOldDiscoveredStructure;
begin
  Result := inherited Items[Index] as TOldDiscoveredStructure;
end;

{ TOldDrilledStructures }

function TOldDrilledStructures.GetItems(
  const Index: integer): TOldDrilledStructure;
begin
  Result := inherited Items[Index] as TOldDrilledStructure;
end;

{ TOldOutOfFundStructures }

function TOldOutOfFundStructures.GetItems(
  const Index: integer): TOldOutOfFundStructure;
begin
  Result := inherited Items[Index] as TOldOutOfFundStructure;
end;

{ TOldFields }

function TOldFields.GetItems(const Index: integer): TOldField;
begin
  Result := inherited Items[Index] as TOldField;
end;

{ TOldStructureHistory }

function TOldStructureHistory.Add: TOldStructureHistoryElement;
begin
  Result := inherited Add as TOldStructureHistoryElement;
end;

constructor TOldStructureHistory.Create(AOwner: TBaseObject);
begin
  FOwner := AOwner;
  inherited Create(TOldStructureHistoryElement);
end;

function TOldStructureHistory.GetElementByFundType(
  AFundTypeID: integer): TOldStructureHistoryElement;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].FundTypeID = AFundTypeID then
  begin
    Result := Items[i];
    break;
  end;
end;

function TOldStructureHistory.GetElementByLastFundType(
  ALastFundTypeID: integer): TOldStructureHistoryElement;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].LastFundTypeID = ALastFundTypeID then
  begin
    Result := Items[i];
    break;
  end;
end;

function TOldStructureHistory.GetItems(
  const Index: integer): TOldStructureHistoryElement;
begin
  Result := inherited Items[Index] as TOldStructureHistoryElement;
end;


{ TOldHorizon }

procedure TOldHorizon.Accept(Visitor: IVisitor);
var v: IConcreteVisitor; 
begin
  inherited;
  v := IConcreteVisitor(Visitor);
  v.VisitHorizon(Self);
end;

procedure TOldHorizon.AssignCollections(Source: TPersistent);
var h: TOldHorizon;
    i: integer;
begin
  inherited;

  h := Source as TOldHorizon;
  Substructures.Assign(h.Substructures);

  for i := 0 to Substructures.Count - 1 do
    Substructures.Items[i].AssignCollections(h.Substructures.Items[i]);
end;

procedure TOldHorizon.AssignTo(Dest: TPersistent);
var H: TOldHorizon;
begin
  h := Dest as TOldHorizon;
  h.ID := ID;
  h.OutOfFund := OutOfFund;

  h.FirstStratum := FirstStratum;
  h.FirstStratumID := FirstStratumID;
  h.FirstStratumPostfix := FirstStratumPostfix;

  h.SecondStratum := SecondStratum;
  h.SecondStratumID := SecondStratumID;
  h.SecondStratumPostfix := SecondStratumPostfix;

  h.OrganizationID := OrganizationID;
  h.Organization := Organization;

  h.Active := Active;

  h.ComplexID := ComplexID;
  h.Complex := Complex;

  h.Comment := Comment;
  h.InvestigationYear := InvestigationYear;

  h.FundTypes.Assign(FundTypes);
  h.Versions.Assign(Versions);  
end;

constructor TOldHorizon.Create(AStructure: TOldStructure);
begin

end;

destructor TOldHorizon.Destroy;
begin
  inherited;

end;

function TOldHorizon.GetFundTypes: TOldFundTypes;
begin
  if not Assigned(FFundTypes) then FFundTypes := TOldFundTypes.Create(Self);
  Result := FFundTypes;
end;

function TOldHorizon.GetMaterialBindType: integer;
begin
  Result := 12; 
end;

function TOldHorizon.GetObjectType: integer;
begin
  Result := 1;
end;

function TOldHorizon.GetStructure: TOldStructure;
begin
  Result := (Collection as TBaseCOllection).Owner as TOldStructure;
end;

function TOldHorizon.GetSubObjectsCount: integer;
var i: integer;
begin
  Result := Substructures.Count;

  for i := 0 to Substructures.Count - 1 do
    Result := Result + Substructures.Items[i].SubObjectsCount;
end;

function TOldHorizon.GetSubstructures: TOldSubstructures;
begin
  if not Assigned(FSubstructures) then FSubstructures := TOldSubstructures.Create(Self);
  Result := FSubstructures;
end;

function TOldHorizon.GetVersions: TOldAccountVersions;
begin
  if not Assigned(FVersions) then FVersions := TOldAccountVersions.Create(Self);

  Result := FVersions;
end;

function TOldHorizon.List(ListOption: TListOption;
  IncludeKey: boolean; Recource: boolean): string;
begin
  Result := Inherited List(ListOption, IncludeKey, Recource);
  if ListOption in [loHierarchicalName] then
    Result := Result + FirstStratum + '(' + Structure.Name + ')'
  else
  begin
    if ListOption <> loBindAttributes then
    begin
      if ListOption in [loBrief] then
        Result := Result + FirstStratum;

      if ListOption in [loMedium, loFull] then
        Result := Result + FirstStratum + '(' + FirstStratumPostfix + ')';


      if ListOption = loFull then
        Result := Result + ';' + Organization;

      if Recource and Assigned(Structure) then
        Result := Result + ' ::: ' + Structure.List(loBrief, false, Recource);
    end
    else Result := Result + FirstStratum;
  end;
end;

{ TOldHorizons }

function TOldHorizons.Add: TOldHorizon;
begin
  Result := inherited Add as TOldHorizon;
end;

constructor TOldHorizons.Create(AOwner: TBaseObject);
begin
  inherited Create(TOldHorizon);
  FOwner := AOwner;
end;

function TOldHorizons.GetItems(const Index: integer): TOldHorizon;
begin
  Result := inherited Items[Index] as TOldHorizon;
end;


{ TOldDrilledStructureWells }

function TOldDrilledStructureWells.Add: TOldDrilledStructureWell;
begin
  Result := inherited Add as TOldDrilledStructureWell;
end;


constructor TOldDrilledStructureWells.Create(AOwner: TBaseObject);
begin
  inherited Create(TOldDrilledStructureWell);
  FStructure := AOwner as TOldStructure;
end;

function TOldDrilledStructureWells.GetItems(
  const Index: integer): TOldDrilledStructureWell;
begin
  Result := inherited Items[Index] as TOldDrilledStructureWell;
end;


{ TOldSubstructures }

function TOldSubstructures.Add: TOldSubstructure;
begin
  Result := inherited Add as TOldSubstructure; 
end;

constructor TOldSubstructures.Create(AOwner: TBaseObject);
begin
  inherited Create(TOldSubstructure);
  FOwner := AOwner;
end;

function TOldSubstructures.GetItems(const Index: integer): TOldSubstructure;
begin
  Result := inherited Items[Index] as TOldSubstructure;
end;




{ TOldStructureWell }

procedure TOldStructureWell.AssignTo(Dest: TPersistent);
var w: TOldStructureWell;
begin
  w := Dest as TOldStructureWell;
  w.ID := ID;
  w.AreaName := AreaName;
  w.WellNum  := WellNum;
  w.Depth    := Depth;
  w.Altitude := Altitude;
end;

constructor TOldStructureWell.Create(Collection: TIDObjects);
begin
  inherited;

end;

destructor TOldStructureWell.Destroy;
begin
  inherited;

end;

function TOldStructureWell.List(ListOption: TListOption;
  IncludeKey: boolean; Recource: boolean): string;
begin
  Result := inherited List(ListOption, IncludeKey, Recource);
  Result := Result +  WellNum + ' - ' + AreaName;

  if ListOption in [loMedium, loFull] then
    Result := Result + '(Альтитуда: ' + Format('%6.2f', [Altitude]) + '; Забой: ' + Format('%6.2f', [Depth]) + ')';

end;

{ TOldStructureWells }

function TOldStructureWells.Add(AUIN: integer): TOldStructureWell;
begin
  Result := ItemsByUIN[AUIN] as TOldStructureWell;
  if not Assigned(Result) then
    Result := Add as TOldStructureWell;
end;

constructor TOldStructureWells.Create(AOwner: TBaseObject);
begin
  inherited Create(TOldStructureWell);
  FStructure := AOwner as TOldStructure;
end;

function TOldStructureWells.GetItems(const Index: integer): TOldStructureWell;
begin
  Result := inherited Items[Index] as TOldStructureWell;
end;


{ TOldSubstructure }


procedure TOldSubstructure.AssignTo(Dest: TPersistent);
var S: TOldSubstructure;
begin
  s := Dest as TOldSubstructure;
  S.ID := ID;

  s.RockID := RockID;
  s.RockName := RockName;

  s.CollectorTypeID := CollectorTypeID;
  s.CollectorType := CollectorType;

  s.BedTypeID := BedTypeID;
  s.BedType := BedType;

  s.StructureElementID := StructureElementID;
  s.StructureElement := StructureElement;

  s.Order := Order;
  s.RealName := RealName;


  s.Reliability := Reliability;
  s.Probability := Probability;
  s.QualityRange := QualityRange;


  s.ActualUntil := ActualUntil;

  s.StructureElementTypeID := StructureElementTypeID;
  s.StructureElementType := StructureElementType;

  s.SubComplexID := SubComplexID;
  s.SubComplex   := SubComplex;

  s.ClosingIsogypse := ClosingIsogypse;
  s.PerspectiveArea := PerspectiveArea;
  s.Amplitude := Amplitude;
  s.ControlDensity := ControlDensity;
  s.MapError := MapError;

end;

function TOldSubstructure.GetHorizon: TOldHorizon;
begin
  Result := (Collection as TBaseCOllection).Owner as TOldHorizon;
end;

function TOldSubstructure.GetVersions: TOldAccountVersions;
begin
  if not Assigned(FVersions) then FVersions := TOldAccountVersions.Create(Self);
  Result := FVersions;
end;

function TOldSubstructure.GetLayers: TOldLayers;
begin
  if not Assigned(FLayers) then FLayers := TOldLayers.Create(Self);
  Result := FLayers;
end;

function TOldSubstructure.GetParameters: TOldParams;
begin
  if not Assigned(FParameters) then FParameters := TOldParams.Create(Self);
  Result := FParameters;
end;

function TOldSubstructure.List(ListOption: TListOption;
  IncludeKey: boolean; Recource: boolean): string;
begin
  Result := inherited List(ListOption, IncludeKey, Recource);
  if ListOption in [loHierarchicalName] then
    Result := Result + RealName + '(' + Horizon.FirstStratum + ' ::: ' + Horizon.Structure.Name + ')'
  else
  begin
    if ListOption <> loBindAttributes then
    begin
      if ListOption in [loBrief, loMedium, loFull] then
      if RealName <> '' then
        Result := Result + RealName
      else
        Result := Result + StructureElement;


      if ListOption in [loMedium, loFull] then
        Result := Result + '(' + StructureElementType + ')';


      if ListOption in [loFull] then
        Result := Result + '; ' + RockName + '; ' + CollectorType;

      if Recource and Assigned(Horizon) then
        Result := Result + ' ::: ' + Horizon.List(loBrief, false, Recource);
    end
    else Result := Result + RealName + ';' + SubComplex;
  end;
end;

function TOldSubstructure.GetObjectType: integer;
begin
  Result := 2;
end;

procedure TOldSubstructure.Accept(Visitor: IVisitor);
var v: IConcreteVisitor;
begin
  inherited;
  v := IConcreteVisitor(Visitor);
  v.VisitSubstructure(Self);
end;

procedure TOldSubstructure.AssignCollections(Source: TPersistent);
var s: TOldSubstructure;
    i: integer;
begin
  inherited;

  s := Source as TOldSubstructure;

  Layers.Assign(s.Layers);

  for i := 0 to Layers.Count - 1 do
    Layers.Items[i].AssignCollections(s.Layers.Items[i]);
end;

function TOldSubstructure.GetMaterialBindType: integer;
begin
  Result := 13;
end;

function TOldSubstructure.GetSubObjectsCount: integer;
begin
  Result := Layers.Count;
end;

{ TOldResources }

function TOldResources.Add: TOldResource;
begin
  Result := inherited Add as TOldResource;
end;

constructor TOldResources.Create(AOwner: TBaseObject);
begin
  inherited Create(TOldResource);
  FOwner := AOwner;
end;

function TOldResources.GetItems(const Index: integer): TOldResource;
begin
  Result := inherited items[Index] as TOldResource;
end;


{ TOldResource }

procedure TOldResource.AssignTo(Dest: TPersistent);
var R: TOldResource;
begin
  R := Dest as TOldResource;

  R.ResourceCategoryID := ResourceCategoryID;
  R.ResourceCategory := ResourceCategory;
  
  R.ResourceTypeID := ResourceTypeID;
  R.ResourceType := ResourceType;

  R.FluidTypeID := FluidTypeID;
  R.FluidType   := FluidType;

  R.Value  := Value;

end;

function TOldResource.GetLayer: TOldLayer;
begin
  if Assigned(Version) then
    Result := (Version.Collection as TBaseCollection).Owner as TOldLayer
  else Result := nil;
end;


function TOldResource.GetVersion: TOldAccountVersion;
begin
  Result := (Collection as TBaseCollection).Owner as TOldAccountVersion;
end;

function TOldResource.List(ListOption: TListOption;
  IncludeKey: boolean; Recource: boolean): string;
begin
  Result := inherited List(ListOption, IncludeKey, Recource);
  Result := Result + ResourceCategory + '(' + ResourceType + '); ' + FluidType + ';'
                                                          + trim(Format('%8.3f', [Value]));
end;

{ TOldParam }

procedure TOldParam.AssignTo(Dest: TPersistent);
var p: TOldParam;
begin
  p := Dest as TOldParam;
  p.ParamID := ParamID;
  p.ID := ID;
  p.ParamName := ParamName;
  p.ParamSign := ParamSign;
  // тип флюида
  p.FluidTypeID := FluidTypeID;
  p.FluidType := FluidType;
  // порядок
  p.Order := Order;
  // значение
  p.Value := Value;
  // единица измерения
  p.MeasureUnitID := MeasureUnitID;
  p.MeasureUnitName := MeasureUnitName;

  p.ResourceCategoryID := ResourceCategoryID;
  p.ResourceCategory := ResourceCategory;

  p.RelationshipID := RelationshipID;
  p.RelationshipName := RelationshipName;


  p.IsRange := IsRange;
  
  p.LicenseZone := LicenseZone;
  p.NextValue := NextValue;
end;

function TOldParam.Check: boolean;
begin
  Result := inherited Check;
  Result := Result and (FluidTypeID > 0) and (ParamID > 0) and (ResourceCategoryID > 0);
end;

function TOldParam.GetSubstructure: TOldSubstructure;
begin
  Result := (Collection as TBaseCollection).Owner as TOldSubstructure;
end;

function TOldParam.List(ListOption: TListOption;
  IncludeKey: boolean; Recource: boolean): string;
var sParamName, sFluidType, sCategory: string;
begin
  Result := inherited List(ListOption, IncludeKey, Recource);

  sParamName := ParamName;
  sFluidType := FluidType;
  if trim(sFluidType) = '' then sFluidType := 'флюид не указан';
  sCategory := ResourceCategory;
  if trim(sCategory) = '' then sCategory := 'Категория не указана';

  Result := sParamName + '[' + sFluidType + ';' + sCategory + ']' + RelationshipName + Trim(Format('%8.3f', [Value]));

  if Assigned(LicenseZone) then
    Result := Result + '[' + LicenseZone.List + ']';
end;

{ TOldParams }

function TOldParams.Add: TOldParam;
begin
  Result := inherited Add as TOldParam;
  if Assigned(FOwner) and (FOwner is TOldAccountVersion) then
    (Owner as TOldAccountVersion).ContainsParams := true;
end;

constructor TOldParams.Create(AOwner: TBaseObject);
begin
  inherited Create(TOldParam);
  FOwner := AOwner;
end;

function TOldParams.GetItems(
  const Index: integer): TOldParam;
begin
  Result := inherited Items[Index] as TOldParam;
end;


function TOldParams.GetParam(const AFluidTypeID,
  AParamID: integer): TOldParam;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if  (Items[i].FluidTypeID = AFluidTypeID)
  and (Items[i].ParamID = AParamID) then
  begin
    Result := Items[i];
    break;
  end;
end;

{ TOldBed }

procedure TOldBed.Accept(Visitor: IVisitor);
var v: IConcreteVisitor;
begin
  inherited;
  v := IConcreteVisitor(Visitor);
  v.VisitBed(Self);
end;

procedure TOldBed.AssignCollections(Source: TPersistent);
var b: TOldBed;
    i: integer;
begin
  inherited;

  b := Source as TOldBed;

  Layers.Assign(b.Layers);

  for i := 0 to Layers.Count - 1 do
    Layers.Items[i].AssignCollections(b.Layers.Items[i]);
end;

procedure TOldBed.AssignTo(Dest: TPersistent);
var b: TOldBed;
begin

  b := Dest as TOldBed;

  b.ID := ID;
  // идентификатор типа залежи
  b.BedTypeID := BedTypeID;
  b.BedType := BedType;

  // идентификатор типа флюида залежи
  b.FluidTypeID := FluidTypeID;
  b.FluidType := FluidType;

  // идентификатор типа коллектора
  b.CollectorTypeID := CollectorTypeID;
  b.CollectorType := CollectorType;

  // идентификатор литологии
  b.RockID := RockID;
  b.RockName := RockName;

  // возраст залежи
  b.AgeID := AgeID;
  b.Age := Age;

  // индекс залежи
  b.BedIndex := BedIndex;

  // нефтегазоносный комплекс
  b.ComplexID := ComplexID;
  b.ComplexName := ComplexName;

  // глубина кровли
  b.Depth := Depth;
  // высота залежи
  b.BedHeight := BedHeight;
  // площадь залежи (площадь нефтеносности)
  b.BedArea := BedArea;

  b.IsBalanced := IsBalanced;
end;

constructor TOldBed.Create(ACollection: TIDObjects);
begin
  inherited;
  // параметры залежи первоначально берутся из параметров подструктур
  if Substructures.Count > 0 then
  begin

    FBedTypeID  := Substructures.Items[0].BedTypeID;
    FBedType    := Substructures.Items[0].BedType;

    FCollectorTypeID := Substructures.Items[0].CollectorTypeID;
    FCollectorType := Substructures.Items[0].CollectorType;

    FRockID := Substructures.Items[0].RockID;
    FRock := Substructures.Items[0].RockName;

    FComplexID := Substructures.Items[0].SubComplexID;
    FComplexName := Substructures.Items[0].SubComplex;

{
    // возраст залежи
    property AgeID: integer read FAgeID write FAgeID;
    property Age: string read FAge write FAge;
}
  end
  else
  if Horizons.Count > 0 then
  begin
    FComplexID := Horizons.Items[0].ComplexID;
    FComplexName := Horizons.Items[0].Complex;
  end;

  IsBalanced := true;

//  DebugFileSave('Creator: ' + IntToStr(Field.UIN) + ';' + Field.Name);
end;



function TOldBed.GetField: TOldField;
begin
  if Structure is TOldField then
    Result := Structure as TOldField
  else Result := nil;
end;

function TOldBed.GetHorizons: TOldHorizons;
begin
  if not Assigned(FHorizons) then FHorizons := TOldHorizons.Create(Self);
  Result := FHorizons;
end;


function TOldBed.GetLayers: TOldLayers;
begin
  if not Assigned(FLayers) then FLayers := TOldLayers.Create(Self);
  Result := FLayers;
end;

function TOldBed.GetObjectType: integer;
begin
  Result := 3;
end;



function TOldBed.GetStructure: TOldStructure;
var c: TBaseCollection;
begin
  Result := nil;
  c := (Collection as TBaseCollection);
  if c.Owner is TOldStructure then
    Result := c.Owner as TOldStructure
  else if c.Owner is TOldSubstructure then
    Result := (((((c.Owner as TOldSubstructure).Collection as TBaseCollection).Owner as TOldHorizon).Collection as TBaseCollection).Owner as TOldStructure);
end;

function TOldBed.GetSubObjectsCount: integer;
begin
  Result := Layers.Count;
end;

function TOldBed.GetSubstructure: TOldSubstructure;
var c: TBaseCollection;
begin
  c := (Collection as TBaseCollection);
  if c.Owner is TOldSubstructure then
    Result := c.Owner as TOldSubstructure
  else
    Result := nil;  
end;

function TOldBed.GetSubstructures: TOldSubstructures;
begin
  if not Assigned(FSubstructures) then FSubstructures := TOldSubstructures.Create(Self);
  Result := FSubstructures;
end;

function TOldBed.GetVerions: TOldAccountVersions;
begin
  if not Assigned(FVersions) then FVersions := TOldAccountVersions.Create(Self);
  Result := FVersions;
end;

function TOldBed.List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string;
begin
  Result := inherited List(ListOption, IncludeKey, Recource);

  if ListOption in [loHierarchicalName] then
    Result := Result + BedIndex + '[' + Field.Name + ' месторождение]'
  else
  begin
    if ListOption in [loBrief, loMedium, loFull, loMapAttributes] then
    begin
      Result := Result + BedIndex;

      if (trim(StructureElement) <> '') then
        Result := Result + ' [Блок, купол: ' + StructureElement + ']';

    end;

    if (ListOption in [loMapAttributes]) and Assigned(Structure) then
      Result := Result + '(' + IntToStr(Structure.ID) + ')';

    if listOption in [loFull] then
      Result := Result + '(' + BedType + ';' + CollectorType + ';' + RockName + Format('%6.2f', [Depth]) + ')';

    if Recource and Assigned(Structure) then
      Result := Result + ' ::: ' + Structure.List(loBrief, false, Recource);
  end;
end;

{ TOldBeds }

function TOldBeds.Add: TOldBed;
begin
  Result := inherited Add as TOldBed;
end;

constructor TOldBeds.Create(AOwner: TBaseObject);
begin
  inherited Create(TOldBed);
  FOwner := AOwner;
end;

function TOldBeds.GetItems(const Index: integer): TOldBed;
begin
  Result := inherited Items[Index] as  TOldBed;
end;


{ TOldLayer }

procedure TOldLayer.Accept(Visitor: IVisitor);
var v: IConcreteVisitor; 
begin
  inherited;
  v := IConcreteVisitor(Visitor);
  v.VisitLayer(Self);
end;

procedure TOldLayer.AssignTo(Dest: TPersistent);
var lr: TOldLayer;
begin
  lr := Dest as TOldLayer;

  lr.ID := ID;

  // литология
  lr.RockID := RockID;
  lr.RockName := RockName;

  // пласт
  lr.LayerID := LayerID;
  lr.LayerIndex := LayerIndex;

  // тип коллеектора
  lr.CollectorTypeID := CollectorTypeID;
  lr.CollectorType := CollectorType;

  // тип ловушки
  lr.TrapTypeID := TrapTypeID;
  lr.TrapType := TrapType;

  // мощность
  lr.Power := Power;
  // эффективная мощность
  lr.EffectivePower := EffectivePower;
  // коэффициент заполнения
  lr.FillingCoef := FillingCoef;
  // высота ловушки
  lr.TrapHeight := TrapHeight;
  // площадь ловушки
  lr.TrapArea := TrapArea;
  // высота залежи
  lr.BedHeight := BedHeight;
  // площадь залежи
  lr.BedArea := BedArea;
  lr.SubstructureUIN := SubstructureUIN;
end;

function TOldLayer.GetBed: TOldBed;
var c: TBaseCollection;
begin
  c := (Collection as TBaseCollection);
  if c.Owner is TOldBed then
    Result := c.Owner as TOldBed
  else
    Result := nil;
end;

function TOldLayer.GetMaterialBindType: integer;
begin
  Result := 14;
end;

function TOldLayer.GetObjectType: integer;
begin
  Result := 4;
end;

function TOldLayer.GetResourceVersions: TOldAccountVersions;
begin
  if not Assigned(FResourceVersions) then FResourceVersions := TOldAccountVersions.Create(Self);
  Result := FResourceVersions;
end;

function TOldLayer.GetSubstructure: TOldSubstructure;
var c: TBaseCollection;
begin
  c := (Collection as TBaseCollection);
  if c.Owner is TOldSubstructure then
    Result := c.Owner as TOldSubstructure
  else
    Result := nil;
end;

function TOldLayer.List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string;
begin
  Result :=  inherited List(ListOption, IncludeKey, Recource);
  Result  := Result + LayerIndex;
  if ListOption <> loBindAttributes then
  begin
    if Recource and Assigned(Substructure) then
      Result := Result + ' ::: ' + SubStructure.List(loBrief, false, Recource)
    else
    if Recource and Assigned(Bed) then
      Result := Result + ' ::: ' + Bed.List(loBrief, false, Recource);
  end;
end;

{ TOldLayers }

function TOldLayers.Add: TOldLayer;
begin
  Result := inherited Add as TOldLayer;
end;

constructor TOldLayers.Create(AOwner: TBaseObject);
begin
  inherited Create(TOldLayer);
  FOwner := AOwner;
end;

function TOldLayers.GetItems(const Index: integer): TOldLayer;
begin
  Result := inherited Items[Index] as TOldLayer;
end;


{ TOldAccountVersion }

procedure TOldAccountVersion.Accept(Visitor: IVisitor);
var v: IConcreteVisitor;
begin
  inherited;
  v := IConcreteVisitor(Visitor);
  v.VisitAccountVersion(Self);
end;

procedure TOldAccountVersion.AssignTo(Dest: TPersistent);
var v: TOldAccountVersion;
begin
  v := Dest as TOldAccountVersion;

  v.ID := ID;

  v.CreatorOrganizationID := CreatorOrganizationID;
  v.CreatorOrganization := CreatorOrganization;

  v.AffirmatorOrganizationID := AffirmatorOrganizationID;
  v.AffirmatorOrganization := AffirmatorOrganization;

  v.VersionID := VersionID;
  v.Version := Version;

  v.DocTypeID := DocTypeId;
  v.DocType := DocType;

  v.Authors := Authors;

  v.DocName := DocName;

  v.CreationDate := CreationDate;
  v.AffirmationDate := AffirmationDate;

  v.ContainsReserves := ContainsReserves;
  v.ContainsResources := ContainsResources;
  v.ContainsParams := ContainsParams;
  v.Parameters.CopyCollection := Parameters.CopyCollection;
  v.Parameters.Assign(Parameters);

  v.Resources.CopyCollection := Resources.CopyCollection;
  v.Resources.Assign(Resources);

  v.Reserves.CopyCollection := Reserves.CopyCollection;
  v.Reserves.Assign(Reserves);

  v.Documents.CopyCollection := Documents.CopyCollection;
  v.Documents.Assign(Documents);
end;

constructor TOldAccountVersion.Create(ACollection: TIDObjects);
begin
  inherited Create(ACollection);
end;

function TOldAccountVersion.GetBed: TOldBed;
begin
  Result := (Collection as TOldAccountVersions).Bed;
end;

function TOldAccountVersion.GetDocuments: TOldDocuments;
begin
  if not Assigned(FDocuments) then FDocuments := TOldDocuments.Create(Self);
  Result := FDocuments;
end;

function TOldAccountVersion.GetHorizon: TOldHorizon;
begin
  Result := (Collection as TOldAccountVersions).Horizon;
end;

function TOldAccountVersion.GetLayer: TOldLayer;
begin
  Result := (Collection as TOldAccountVersions).Layer;
end;

function TOldAccountVersion.GetParams: TOldLayerParams;
begin
  if not Assigned(FParams) then FParams := TOldLayerParams.Create(Self);
  Result := FParams;
end;

function TOldAccountVersion.GetReserves: TOldReserves;
begin
  if not Assigned(FReserves) then FReserves := TOldReserves.Create(Self);
  Result := FReserves;
end;

function TOldAccountVersion.GetResources: TOldResources;
begin
  if not Assigned(FResources) then FResources := TOldResources.Create(Self);
  Result := FResources;
end;

function TOldAccountVersion.GetStructure: TOldStructure;
begin
  Result := (Collection as TOldAccountVersions).Structure;
end;

function TOldAccountVersion.GetSubstructure: TOldSubstructure;
begin
  Result := (Collection as TOldAccountVersions).Substructure;
end;

function TOldAccountVersion.List(ListOption: TListOption;
  IncludeKey: boolean; Recource: boolean): string;
begin
   Result := inherited List(ListOption, IncludeKey, Recource);

   Result := '['  + DocName + ']';
end;

{ TOldAccountVersions }

function TOldAccountVersions.Add: TOldAccountVersion;
begin
  Result := inherited Add as TOldAccountVersion;
end;


constructor TOldAccountVersions.Create(AOwner: TBaseObject);
begin
  inherited Create(TOldAccountVersion);
  FOwner := AOwner;
end;

function TOldAccountVersions.GetBed: TOldBed;
begin
  if Owner is TOldBed then
    Result := Owner as TOldBed
  else if Assigned(Layer) then result := Layer.Bed
  else Result := nil;
end;

function TOldAccountVersions.GetContainsReserves: boolean;
var i: integer;
begin
  Result := false;

  for i := 0 to Count - 1 do
  begin
    Result := Items[i].Reserves.Count >  0;
    if Result then break;
  end;
end;

function TOldAccountVersions.GetHorizon: TOldHorizon;
begin
  if Owner is TOldHorizon then
    Result := Owner as TOldHorizon
  else if Assigned(Substructure) then
    Result := Substructure.Horizon
  else Result := nil;
end;

function TOldAccountVersions.GetItems(const Index: integer): TOldAccountVersion;
begin
  Result := inherited Items[Index] as TOldAccountVersion;
end;


function TOldAccountVersions.GetLayer: TOldLayer;
begin
  if Owner is TOldLayer then
    Result := Owner as TOldLayer
  else Result := nil;
end;

function TOldAccountVersions.GetStructure: TOldStructure;
begin
  if Owner is TOldStructure then
    Result := Owner as TOldStructure
  else if Assigned(Horizon) then
    Result := Horizon.Structure
  else if Assigned(Bed) then
    Result := Bed.Structure
  else Result := nil;
end;

function TOldAccountVersions.GetSubstructure: TOldSubstructure;
begin
  if Owner is TOldSubstructure then
    Result := Owner as TOldSubstructure
  else if Assigned(Layer) then
    Result := Layer.Substructure
  else Result := nil;
end;

procedure TOldAccountVersions.ParametersClear;
var i: integer;
begin
  for i := 0 to Count - 1 do
    Items[i].Parameters.Clear;
end;

procedure TOldAccountVersions.ReservesClear;
var i: integer;
begin
  for i := 0 to Count - 1 do
    Items[i].Reserves.Clear;
end;

procedure TOldAccountVersions.ResourcesClear;
var i: integer;
begin
  for i := 0 to Count - 1 do
    Items[i].Resources.Clear;
end;

{ TOldReserve }

procedure TOldReserve.AssignTo(Dest: TPersistent);
var r: TOldReserve;
begin
  r := Dest as TOldReserve;

  r.FluidTypeID := FluidTypeID;
  r.FluidType := FluidType;

  r.ReserveCategoryID := ReserveCategoryID;
  r.ReserveCategory := ReserveCategory;

  r.ReserveKindID := ReserveKindID;
  r.ReserveKind := ReserveKind;

  r.ReserveTypeID := ReserveTypeID;
  r.ReserveType := ReserveType;

  r.Value := Value;

  r.ReserveValueTypeID := ReserveValueTypeID;
  r.ReserveValueTypeName := ReserveValueTypeName;

  r.LicenseZone := LicenseZone;
end;

function TOldReserve.Check: boolean;
begin
  Result := inherited Check;
  Result := Result and (FluidTypeID > 0) and (ReserveCategoryID > 0) and (ReserveKindID >= 0) and (ReserveTypeID >= 0);
end;

constructor TOldReserve.Create(ACollection: TIDObjects);
begin
  inherited;
  ReserveValueTypeID := RESERVES_RESERVE_VALUE_TYPE_ID;
  ReserveValueTypeName := GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_RESERVES_VALUE_TYPE'].Dict, ReserveValueTypeID);
end;

function TOldReserve.GetLayer: TOldLayer;
begin
  if Assigned(Version) then
    Result := (Version.Collection as TBaseCollection).Owner as TOldLayer
  else Result := nil;
end;

function TOldReserve.GetVersion: TOldAccountVersion;
begin
  Result := (Collection as TBaseCollection).Owner as TOldAccountVersion;
end;

function TOldReserve.List(ListOption: TListOption;
  IncludeKey: boolean; Recource: boolean): string;
begin
  Result := inherited List(ListOption, IncludeKey, Recource);
  Result := Result + ReserveCategory + '(' + ReserveType + ';' +
            ReserveKind + '); ' + FluidType + ';' +
            trim(Format('%8.3f', [Value]));

  if Assigned(LicenseZone) then
    Result := Result + '[' + LicenseZone.List + ']';
end;

{ TOldReserves }

function TOldReserves.Add: TOldReserve;
begin
  Result := inherited Add as TOldReserve; 
end;

function TOldReserves.AddReserve(ACategoryID, AKindID, ATypeID,
  AValueTypeID: integer; AFluidTypeID: integer; AValue: Single): TOldReserve;
begin
  Result := Add;
  with Result do
  begin
    ReserveCategoryID := ACategoryID;
    ReserveCategory := GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_RESOURCES_CATEGORY_DICT'].Dict, ReserveCategoryID);

    ReserveKindID := AKindID;
    ReserveKind := GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_RESERVES_KIND_DICT'].Dict, ReserveKindID);

    ReserveTypeID := ATypeID;
    ReserveType := GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_RESOURSE_TYPE_DICT'].Dict, ReserveTypeID);

    ReserveValueTypeID := AValueTypeID;
    ReserveValueTypeName := GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_RESERVES_VALUE_TYPE'].Dict, ReserveValueTypeID);

    FluidTypeID := AFluidTypeID;
    FluidType := GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_FLUID_TYPE_DICT'].Dict, FluidTypeID);
    
    Value := AValue;
  end;
end;

procedure TOldReserves.CalculateReserves;
var i, j: integer;
    fVal: single;
begin
  CalculatedReserves.Clear;
  // считаем остаточные запасы по категориям A+B и A+B+C1
  for j := 0 to UniqueFluidTypes.Count - 1 do
  begin
    // A+B - геологические
    fVal := 0;
    for i := 0 to Count - 1 do
    if  (Items[i].ReserveCategoryID in [RESOURCE_CATEGORY_A, RESOURCE_CATEGORY_B])
    and (Items[i].ReserveTypeID = RESOURCE_TYPE_GEO)
    and (Items[i].ReserveKindID = RESERVE_KIND_REM)
    and (Items[i].ReserveValueTypeID = RESERVES_RESERVE_VALUE_TYPE_ID)
    and (Items[i].FluidTypeID = UniqueFluidTypes.Items[j]) then
      fVal := fVal + Items[i].Value;

    CalculatedReserves.AddReserve(RESOURCE_CATEGORY_AB, RESERVE_KIND_REM,
                                  RESOURCE_TYPE_GEO, RESERVES_RESERVE_VALUE_TYPE_ID,
                                  UniqueFluidTypes.Items[j], fVal);

    // A+B - извлекаемые
    fVal := 0;
    for i := 0 to Count - 1 do
    if  (Items[i].ReserveCategoryID in [RESOURCE_CATEGORY_A, RESOURCE_CATEGORY_B])
    and (Items[i].ReserveTypeID = RESOURCE_TYPE_RECOVERABLE)
    and (Items[i].ReserveKindID = RESERVE_KIND_REM)
    and (Items[i].ReserveValueTypeID = RESERVES_RESERVE_VALUE_TYPE_ID)
    and (Items[i].FluidTypeID = UniqueFluidTypes.Items[j]) then
      fVal := fVal + Items[i].Value;

    CalculatedReserves.AddReserve(RESOURCE_CATEGORY_AB, RESERVE_KIND_REM,
                                  RESOURCE_TYPE_RECOVERABLE, RESERVES_RESERVE_VALUE_TYPE_ID,
                                  UniqueFluidTypes.Items[j], fVal);

    // A+B + С1 - геологические
    fVal := 0;
    for i := 0 to Count - 1 do
    if  (Items[i].ReserveCategoryID in [RESOURCE_CATEGORY_A, RESOURCE_CATEGORY_B, RESOURCE_CATEGORY_C1])
    and (Items[i].ReserveTypeID = RESOURCE_TYPE_GEO)
    and (Items[i].ReserveKindID = RESERVE_KIND_REM)
    and (Items[i].ReserveValueTypeID = RESERVES_RESERVE_VALUE_TYPE_ID)
    and (Items[i].FluidTypeID = UniqueFluidTypes.Items[j]) then
      fVal := fVal + Items[i].Value;

    CalculatedReserves.AddReserve(RESOURCE_CATEGORY_ABC1, RESERVE_KIND_REM,
                                  RESOURCE_TYPE_GEO, RESERVES_RESERVE_VALUE_TYPE_ID,
                                  UniqueFluidTypes.Items[j], fVal);

    // A+B + С1 - извлекаемые
    fVal := 0;
    for i := 0 to Count - 1 do
    if  (Items[i].ReserveCategoryID in [RESOURCE_CATEGORY_A, RESOURCE_CATEGORY_B, RESOURCE_CATEGORY_C1])
    and (Items[i].ReserveTypeID = RESOURCE_TYPE_RECOVERABLE)
    and (Items[i].ReserveKindID = RESERVE_KIND_REM)
    and (Items[i].ReserveValueTypeID = RESERVES_RESERVE_VALUE_TYPE_ID)
    and (Items[i].FluidTypeID = UniqueFluidTypes.Items[j]) then
      fVal := fVal + Items[i].Value;

    CalculatedReserves.AddReserve(RESOURCE_CATEGORY_ABC1, RESERVE_KIND_REM,
                                  RESOURCE_TYPE_RECOVERABLE, RESERVES_RESERVE_VALUE_TYPE_ID,
                                  UniqueFluidTypes.Items[j], fVal);
  end;
end;

constructor TOldReserves.Create(AOwner: TBaseObject);
begin
  inherited Create(TOldReserve);
  FOwner := AOwner;
end;

destructor TOldReserves.Destroy;
begin
  FreeAndNil(FReserves);
  inherited;
end;

function TOldReserves.GetCalculatedReserves: TOldReserves;
begin
  if not Assigned(FReserves) then FReserves := TOldReserves.Create(Owner);
  Result := FReserves;
end;

function TOldReserves.GetItems(const Index: integer): TOldReserve;
begin
  Result := inherited Items[Index] as TOldReserve;
end;


function TOldReserves.GetUniqueFluidTypes: TIntegerList;
var i: integer;
begin
  if not Assigned(FFluidTypes) then FFluidTypes := TIntegerList.Create;
  FFluidTypes.Clear;

  for i := 0 to Count - 1 do
  if FFluidTypes.IndexOf(TObject(Items[i].FluidTypeID)) = -1 then
    FFluidTypes.Add(TObject(Items[i].FluidTypeID));

  Result := FFluidTypes;
end;

{ TOldHistoryElement }

procedure TOldHistoryElement.Accept(Visitor: IVisitor);
begin
  inherited;

end;

procedure TOldHistoryElement.AssignTo(Dest: TPersistent);
var h: TOldHistoryElement;
begin
  h := Dest as TOldHistoryElement;

  h.ID := ID;

  h.ActionTypeID := ActionTypeID;
  h.ActionType := ActionType;

  h.ActionReasonID := ActionReasonID;
  h.ActionReason := ActionReason;

  h.ActionDate := ActionDate;
  h.ActionName := ActionName;
  h.Comment := Comment;

  h.EmployeeID := EmployeeID;
  h.Employee := Employee;

  h.RealDate := RealDate;
end;

constructor TOldHistoryElement.Create(Collection: TIDObjects);
begin
  inherited ;

end;

destructor TOldHistoryElement.Destroy;
begin
  inherited;

end;

function TOldHistoryElement.GetHistoryOwner: TBaseObject;
begin
  Result := (Collection as TBaseCollection).Owner;
end;


function TOldHistoryElement.List(ListOption: TListOption;
  IncludeKey: boolean; Recource: boolean): string;
begin
  Result := inherited List(ListOption, IncludeKey, Recource);
  if ActionType <> '' then
    Result := Result + ActionType;
  if ActionDate <> 0 then
    Result := Result + '; ' + DateTimeToStr(ActionDate);
  if  (ListOption = loFull) and (ActionReason <> '') then
      Result := Result + '; ' + ActionReason;
end;

{ TOldStructureHistoryElement }

procedure TOldStructureHistoryElement.Accept(Visitor: IVisitor);
var v: IConcreteVisitor;
begin
  inherited;
  v := IConcreteVisitor(Visitor);
  v.VisitStructureHistoryElement(Self);
end;

procedure TOldStructureHistoryElement.AssignCollections(Source: TPersistent);
begin
  inherited;

end;

procedure TOldStructureHistoryElement.AssignTo(Dest: TPersistent);
var h: TOldStructureHistoryElement;
begin
  inherited AssignTo(Dest);

  h := Dest as TOldStructureHistoryElement;

  h.LastFundTypeID := LastFundTypeID;
  h.LastFundType := LastFundType;

  h.FundTypeID := FundTypeID;
  h.FundType := FundType;
  if (Assigned(h.HistoryStructure) or Assigned(HistoryStructure)) then h.HistoryStructure.Assign(HistoryStructure);
end;

constructor TOldStructureHistoryElement.Create(Collection: TIDObjects);
begin
  inherited;
  ActionName := 'перевели структуру из фонда "%s" в фонд "%s"';
end;

destructor TOldStructureHistoryElement.Destroy;
begin
  inherited;

end;

function TOldStructureHistoryElement.GetHistoryStructure: TOldStructure;
begin
  if not Assigned(FHistoryStructure) or (FHistoryStructure.StructureTypeID <> FundTypeID) then
  begin
    FHistoryStructure.Free;
    FHistoryStructure := nil;

    case FundTypeID of
    1: FHistoryStructure := TOldDiscoveredStructure.Create(nil);
    2: FHistoryStructure := TOldPreparedStructure.Create(nil);
    3: FHistoryStructure := TOldDrilledStructure.Create(nil);
    4: FHistoryStructure := TOldField.Create(nil);
    end;

    if Assigned(FHistoryStructure) and Assigned(Structure) then FHistoryStructure.Assign(Structure);
  end;

  Result := FHistoryStructure;
end;

function TOldStructureHistoryElement.GetStructure: TOldStructure;
begin
  Result := HistoryOwner as TOldStructure;
end;

function TOldStructureHistoryElement.List(ListOption: TListOption;
  IncludeKey: boolean; Recource: boolean): string;
begin
  if ListOption = loBrief then
    Result := inherited List(ListOption, IncludeKey, Recource)
  else
  begin
    if LastFundTypeID <> 0 then
      Result := Format(ActionName, [LastFundType, FundType]) + '(' + inherited List(ListOption, IncludeKey, Recource) + ')'
    else
      Result := Format(ActionName, [FundType]) +  '(' + inherited List(ListOption, IncludeKey, Recource) + ')';
  end
end;

procedure TOldStructureHistoryElement.SetLastFundTypeID(const Value: integer);
begin
  FLastFundTypeID := Value;
  if FLastFundTypeID = 0 then
    ActionName := 'добавили структуру/месторождение в фонд "%s"'
  else
    ActionName := 'перевели структуру из фонда "%s" в фонд "%s"';
end;

{ TOldHistory }

function TOldHistory.Add: TOldHistoryElement;
begin
  Result := inherited Add as TOldHistoryElement;
end;

constructor TOldHistory.Create(AOwner: TBaseObject);
begin
  inherited Create(TOldHistoryElement);
  FOwner := AOwner;
end;

function TOldHistory.GetItems(const Index: integer): TOldHistoryElement;
begin
  Result := inherited Items[Index] as TOldHistoryElement;
end;


{ TOldDrilledStructureWell }

procedure TOldDrilledStructureWell.AssignTo(Dest: TPersistent);
var w: TOldDrilledStructureWell;
begin
  inherited;

  w := Dest as TOldDrilledStructureWell;

  w.NegativeResultReason := NegativeResultReason;
  w.GisConfirmation := GISConfirmation;
  w.StructModelConfirmation := StructModelConfirmation;
end;


{ TOldPerfectStructureHistory }

constructor TOldPerfectStructureHistory.Create(AOwner: TBaseObject);
begin
  inherited;
  RestoreState;
end;

function TOldPerfectStructureHistory.GetItems(
  const Index: integer): TOldPerfectStructureHistoryElement;
begin
  Result := inherited Items[Index] as TOldPerfectStructureHistoryElement;
end;

procedure TOldPerfectStructureHistory.RestoreState;
var h: TOldStructureHistoryElement;
begin
  Clear;
  // регистрация безотносительно фонда
  h := TOldPerfectStructureHistoryElement.Create(Self);
  h.LastFundTypeID := 0;
  h.LastFundType := 'Вновь зарегистрированные';
  h.FundTypeID := 6;
  h.FundType := 'Нет данных';
  h.ActionTypeID := 1;
  h.ActionType := 'Изменение фонда';


  // регистрация
  h := TOldPerfectStructureHistoryElement.Create(Self);
  h.LastFundTypeID := 0;
  h.LastFundType := 'Вновь зарегистрированные';
  h.FundTypeID := 1;
  h.FundType := 'Выявленные';
  h.ActionTypeID := 1;
  h.ActionType := 'Изменение фонда';

  // переход из выявленных в подготовленные
  h := TOldPerfectStructureHistoryElement.Create(Self);
  h.LastFundTypeID := 1;
  h.LastFundType := 'Выявленные';
  h.FundTypeID := 2;
  h.FundType := 'Подготовленные';
  h.ActionTypeID := 1;
  h.ActionType := 'Изменение фонда';


  // переход из подготовленных в структуры в бурении
  h := TOldPerfectStructureHistoryElement.Create(Self);
  h.LastFundTypeID := 2;
  h.LastFundType := 'Подготовленные';
  h.FundTypeID := 3;
  h.FundType := 'В бурении';
  h.ActionTypeID := 1;
  h.ActionType := 'Изменение фонда';

  // переход из структур в бурении в месторождения
  h := TOldPerfectStructureHistoryElement.Create(Self);
  h.LastFundTypeID := 3;
  h.LastFundType := 'В бурении';
  h.FundTypeID := 4;
  h.FundType := 'Месторождения';
  h.ActionTypeID := 1;
  h.ActionType := 'Изменение фонда';

  // вывод из фонда с отрицательным результатом
  h := TOldPerfectStructureHistoryElement.Create(Self);
  h.LastFundTypeID := 3;
  h.LastFundType := 'В бурении';
  h.FundTypeID := 7;
  h.FundType := 'Выведена с отрицательным результатом';
  h.ActionTypeID := 1;
  h.ActionType := 'Изменение фонда';

  // вывод из фонда
  h := TOldPerfectStructureHistoryElement.Create(Self);
  h.LastFundTypeID := 4;
  h.LastFundType := 'Месторождения';
  h.FundTypeID := 5;
  h.FundType := 'Вне фонда';
  h.ActionTypeID := 1;
  h.ActionType := 'Изменение фонда';



end;

{ TOldPerfectStructureHistoryElement }

constructor TOldPerfectStructureHistoryElement.Create(
  Collection: TIDObjects);
begin
  inherited Create(Collection);
  RealStructureHistoryElement := nil;
end;

function TOldPerfectStructureHistoryElement.List(ListOption: TListOption;
  IncludeKey, Recourse: boolean): string;
begin
  if not Assigned(RealStructureHistoryElement) or (ListOption = loBrief) then
    Result := inherited List(ListOption, IncludeKey, Recourse)
  else
  begin
    if RealStructureHistoryElement.LastFundTypeID <> 0 then
      Result := Format(ActionName, [RealStructureHistoryElement.LastFundType, FundType]) + '(' + inherited List(ListOption, IncludeKey, Recourse) + ')'
    else
      Result := Format(ActionName, [FundType]) +  '(' + inherited List(ListOption, IncludeKey, Recourse) + ')';
  end
end;


{ TOldFundType }

procedure TOldFundType.AssignTo(Dest: TPersistent);
var ft: TOldFundType;
begin
  ft := Dest as TOldFundType;
  ft.ID := ID;
  ft.FundTypeName := FundTypeName;
end;

function TOldFundType.List(ListOption: TListOption; IncludeKey,
  Recource: boolean): string;
begin
  Result := inherited List(ListOption, IncludeKey, Recource);
  Result := FundTypeName + Result; 
end;

{ TOldFundTypes }

function TOldFundTypes.Add: TOldFundType;
begin
  Result := inherited Add as TOldFundType;
end;

constructor TOldFundTypes.Create(AOwner: TBaseObject);
begin
  inherited Create(TOldFundType);
  FOwner := AOwner;
end;

function TOldFundTypes.GetItems(const Index: integer): TOldFundType;
begin
  Result := inherited Items[Index] as TOldFundType;
end;

{ TOldDocument }

procedure TOldDocument.AssignTo(Dest: TPersistent);
var d: TOldDocument;
begin
  d := Dest as TOldDocument;
  d.ID := ID;

  d.OrganizationID := OrganizationID;
  d.OrganizationName := OrganizationName;

  d.ThemeID := ThemeID;
  d.ThemeName := ThemeName;

  d.DocName := DocName;
  d.Authors := Authors;
  d.FPreLocation := PreLocation;
  d.Comment := Comment;
  d.CreationDate := CreationDate;

  d.MediumID := MediumID;
  d.MediumName := MediumName;

  d.UserBindAttrbutes := UserBindAttrbutes;

  d.MaterialTypeID := MaterialTypeID;
  d.MaterialType := MaterialType;
end;

constructor TOldDocument.Create(ACollection: TIDObjects);
begin
  inherited;
  FPreLocationChanged := false;
end;

function TOldDocument.GetBindAttributes: string;
begin
  Result := ((Version.Collection as TBaseCollection).Owner as TBaseObject).List(loBindAttributes, false, false)
end;

function TOldDocument.GetFileName: string;
var sFile: string;
begin
  sFile := ExtractFileName(PreLocation);
  if pos('___', sFile) > 0 then
    Result := trim(copy(sFile, pos('___', sFile) + Length('___'), Length(sFile)))
  else
    Result := sFile;
end;

function TOldDocument.GetLocation: string;
begin
  Result := sDocPath + IntToStr(ID) + '___' + FileName;
end;

function TOldDocument.GetVersion: TOldAccountVersion;
begin
  Result := (Collection as TBaseCollection).Owner as TOldAccountVersion;
end;

function TOldDocument.List(ListOption: TListOption; IncludeKey,
  Recource: boolean): string;
var sUIN: string;
begin
  sUIN := inherited List(ListOption, IncludeKey, Recource);

  Result := '';
  if ListOption >=loBrief then
  begin
    Result := Result + Authors + ' - ' + DocName;
    if ListOption = loMedium then
      Result := Result + '(' + ThemeName + ')'
    else
    if ListOption = loFull then
      Result := Result + ' - ' + OrganizationName;
  end;
  Result := Result + sUIN;
end;

procedure TOldDocument.SetPreLocation(const Value: string);
begin
  if FPreLocation <> Value then
  begin
    FPreLocation := Value;
    FPreLocationChanged := true;
  end;
end;

{ TOldDocuments }

function TOldDocuments.Add: TOldDocument;
begin
  Result := inherited Add as TOldDocument;
end;

constructor TOldDocuments.Create(AOwner: TBaseObject);
begin
  FOwner := AOwner;
  inherited Create(TOldDocument);
end;

function TOldDocuments.GetItems(const Index: integer): TOldDocument;
begin
  Result := inherited Items[Index] as TOldDocument;
end;



{ TOldVersion }

procedure TOldVersion.Accept(Visitor: IVisitor);
var v: IConcreteVisitor;
begin
  inherited;
  v := IConcreteVisitor(Visitor);
  v.VisitVersion(Self);
end;

procedure TOldVersion.AssignTo(Dest: TPersistent);
var v: TOldVersion;
begin
  v := Dest as TOldVersion;
  v.ID := ID;

  v.VersionReason := VersionReason;
  v.VersionDate := VersionDate;
end;

constructor TOldVersion.Create(Collection: TIDObjects);
begin
  inherited;

end;

destructor TOldVersion.Destroy;
begin
  inherited;
end;


function TOldVersion.GetMaterialBindType: integer;
begin
  Result := -1;
end;

function TOldVersion.GetObjectType: integer;
begin
  Result := -1;
end;


function TOldVersion.List(ListOption: TListOption; IncludeKey,
  Recource: boolean): string;
begin
  Result := inherited List(ListOption, IncludeKey, Recource);

  Result := Result + VersionName + '[' + DateTimeToStr(VersionDate) + ']';
end;

{ TOldVersions }

function TOldVersions.Add: TOldVersion;
begin
  Result := inherited Add as TOldVersion;
end;

constructor TOldVersions.Create(AOwner: TBaseObject);
begin
  inherited Create(TOldVersion);
  FOwner := AOwner;
end;

function TOldVersions.GetItems(const Index: integer): TOldVersion;
begin
  Result := inherited Items[Index] as TOldVersion;
end;

{ TOldLicense }

procedure TOldLicense.AssignTo(Dest: TPersistent);
var l: TOldLicense;
begin
  inherited;

  l := Dest as TOldLicense;

  l.OwnerOrganizationID := OwnerOrganizationID;
  l.OwnerOrganizationName := OwnerOrganizationName;
  l.DeveloperOrganizationID := DeveloperOrganizationID;
  l.DeveloperOrganizationName := DeveloperOrganizationName;

  l.SiteHolderID := SiteHolderID;
  l.SiteHolder := SiteHolder;
  l.DocHolderDate := DocHolderDate;

  l.LicenseZoneNum := LicenseZoneNum;
  l.LicenseTitle := LicenseTitle;
  l.Seria := Seria;

  l.LicenzeZoneTypeID := LicenzeZoneTypeID;
  l.LicenzeZoneType := LicenzeZoneType;

  l.RegistrationStartDate := RegistrationStartDate;
  l.RegistrationFinishDate := RegistrationFinishDate;

  l.LicenseTypeID := LicenseTypeID;
  l.LicenseType := LicenseType;
  l.LicenseTypeShortName := LicenseTypeShortName; 
end;

function TOldLicense.GetMaterialBindType: integer;
begin
  Result := 0;
end;

function TOldLicense.GetObjectType: integer;
begin
  Result := 0;
end;

function TOldLicense.GetSubObjectsCount: integer;
begin
  Result := 0;
end;


function TOldLicense.List(ListOption: TListOption; IncludeKey,
  Recource: boolean): string;
begin
  Result := LicenseZoneNum;
end;

{ TOldLicenseZones }

function TOldLicenseZones.Add: TOldLicenseZone;
begin
  Result := Inherited Add As TOldLicenseZone;
end;


constructor TOldLicenseZones.Create(AOwner: TBaseObject);
begin
  FOwner := AOwner;
  inherited Create(TOldLicenseZone);
end;

function TOldLicenseZones.GetItems(const Index: integer): TOldLicenseZone;
begin
  Result := inherited Items[Index] as TOldLicenseZone;
end;

procedure TOldLicenseZones.SortByDistrict;
begin

end;

procedure TOldLicenseZones.SortByLicenseNumber;
begin

end;

procedure TOldLicenseZones.SortByLicenseType;
begin

end;

procedure TOldLicenseZones.SortByLicenseZoneTOldype;
begin

end;

procedure TOldLicenseZones.SortByName;
begin
  
end;

procedure TOldLicenseZones.SortByNGO;
begin

end;

procedure TOldLicenseZones.SortByOrganization;
begin

end;

procedure TOldLicenseZones.SortByPetrolRegion;
begin

end;

procedure TOldLicenseZones.SortByTOldectStruct;
begin

end;

{ TOldLicenseZone }

procedure TOldLicenseZone.Accept(Visitor: IVisitor);
var v: IConcreteVisitor;
begin
  inherited;
  v := IConcreteVisitor(Visitor);
  v.VisitLicenseZone(Self);
end;

procedure TOldLicenseZone.AssignTo(Dest: TPersistent);
var lz: TOldLicenseZone;
begin

  lz := Dest as TOldLicenseZone;

  lz.LicenseZoneStateID := LicenseZoneStateID;
  lz.LicenseZoneState := LicenseZoneState;

  lz.DepthFrom := DepthFrom;
  lz.DepthTo := DepthTo;
  lz.Area := Area;

  lz.DistrictID := DistrictID;
  lz.District := District;

  lz.LicenseZoneName := LicenseZoneName;
  lz.CompetitionID := CompetitionID;
  lz.CompetitionDate := CompetitionDate;
  lz.NGDRID := NGDRID;
  lz.NGDRName := NGDRName;
  lz.License.Assign(License);
end;

constructor TOldLicenseZone.Create(Collection: TIDObjects);
begin
  inherited;
  FLicenseConditionValues := nil;
end;

destructor TOldLicenseZone.Destroy;
begin
  if Assigned(FVersions) then FVersions.Free;
  if Assigned(FLicense) then FLicense.Free;
  if Assigned(FLicenseConditionValues) then FLicenseConditionValues.Free;
  inherited;
end;

function TOldLicenseZone.GetCoordObjects: TOldCoordObjects;
begin
  if not Assigned(FCoordObjects) then
    FCoordObjects := TOldCoordObjects.Create(Self);

  Result := FCoordObjects;
end;

function TOldLicenseZone.GetLicense: TOldLicense;
begin
  if not Assigned(FLicense) then FLicense := TOldLicense.Create(nil);
  Result := FLicense;
end;


function TOldLicenseZone.GetLicenseConditionValues: TLicenseConditionValues;
begin
  if not Assigned(FLicenseConditionValues) then
  begin
    FLicenseConditionValues := TLicenseConditionValues.Create;
    FLicenseConditionValues.Owner := Self;
    FLicenseConditionValues.Reload;
  end;

  Result := FLicenseConditionValues;
end;

function TOldLicenseZone.GetLicenseZoneNum: string;
begin
  Result := License.LicenseZoneNum;
end;

function TOldLicenseZone.GetMaterialBindType: integer;
begin
  Result := 15;
end;

function TOldLicenseZone.GetObjectType: integer;
begin
  Result := 0;
end;


function TOldLicenseZone.GetRegistrationFinishDate: TDateTime;
begin
  Result := License.RegistrationFinishDate;
end;

function TOldLicenseZone.GetRegistrationStartDate: TDateTime;
begin
  Result := License.RegistrationStartDate;
end;

function TOldLicenseZone.GetSubObjectsCount: integer;
begin
  Result := 0;
end;

function TOldLicenseZone.GetVersions: TOldAccountVersions;
begin
  if not Assigned(FVersions) then FVersions := TOldAccountVersions.Create(Self);
  Result := FVersions;
end;

function TOldLicenseZone.List(ListOption: TListOption; IncludeKey,
  Recource: boolean): string;
begin
  Result := LicenseZoneName +'(Номер лицензии: '  + License.List(ListOption, IncludeKey, Recource) + ')';
end;


{

procedure TOldStructures.Assign(Source: TPersistent);
var i: integer;
    strs: TOldStructures;
    s : TOldStructure;
begin
  strs := Source as TOldStructures;

  for i := 0 to Strs.Count - 1 do
  begin
    S := Add(TOldStructureClass(Strs.Items[i].ClassType));
    S.Assign(Strs.Items[i]);
  end;
end;

function TOldStructures.Insert(Index: integer): TOldStructure;
begin
  Result := inherited Insert(Index) as TOldStructure;
end;


function TOldStructures.Insert(Index: integer;
  AStructureClass: TOldStructureClass): TOldStructure;
begin
  Result := AStructureClass.Create(Self);
  Result.Index := Index;
end;

procedure TOldAccountVersions.AssignTo(Dest: TPersistent);
var b: TBaseCollection;
begin
  b := Dest as TBaseCollection;
  b.Owner := Owner;
  inherited;
end;


procedure TOldLicenseZones.Assign(Source: TPersistent);
var i: integer;
    zones: TOldLicenseZones;
    s : TOldLicenseZone;
begin
  zones := Source as TOldLicenseZones;

  for i := 0 to zones.Count - 1 do
  begin
    S := Add as TOldLicenseZone;
    S.Assign(Zones.Items[i]);
  end;
end;


    function Insert(Index: integer): TOldStructure; overload;
    function Insert(Index: integer; AID: integer): TOldStructure; overload;
    function Insert(Index: integer; AStructureClass: TOldStructureClass): TOldStructure; overload;

function TOldStructures.Insert(Index, AID: integer): TOldStructure;
var cls: TOldStructureClass;
begin
  cls := TOldStructure;
  case AID of
  // Выявленные
  1: cls := TOldDiscoveredStructure;
  // подгтовленные
  2: cls := TOldPreparedStructure;
  // в бурении
  3: cls := TOldDrilledStructure;
  // месторождения
  4: cls := TOldField;
  end;

  Result := Insert(Index, cls);
  if cls <> TOldStructure then Result.NeedsUpdate := true;
end;


}
function TOldLicenseZone.List(ListOption: TListOption): string;
begin
  Result := LicenseZoneName +'_'  + LicenseZoneNum;
end;

{ TIntegerList }

constructor TIntegerList.Create;
begin
  inherited Create(False);
end;

function TIntegerList.GetItems(Index: Integer): Integer;
begin
  Result := Integer(inherited Items[Index]);
end;

end.

