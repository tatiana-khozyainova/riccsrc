unit GRRParameter;

interface

uses Registrator, BaseObjects, Classes, MeasureUnits, Well, BaseConsts,
     ExceptionExt, ClientCommon, BaseWellInterval, Straton, Table,
     Organization, Version;

type
  EUnknownParameterType = class(EApplicationException)


  end;

  TGRRParamGroupType = class;
  TGRRParamGroupTypes = class;
  TGRRParamGroup = class;
  TGRRParamGroups = class;
  TGRRParameter = class;
  TGRRParameters = class;
  TLoadingGRRParameters = class;
  TGRRParameterValue = class;
  TGRRParameterValues = class;
  TGRRWellIntervalType = class;
  TGRRWellIntervalTypes = class;
  TGRRWellInterval = class;
  TGRRWellIntervals = class;
  TGRRParamPredefinedValue = class;
  TGRRParamPredefinedValues = class;
  TGRRParameterType = class;
  TGRRParameterTypes = class;
  TGRRParameterName = class;
  TGRRParameterNames = class;
  TGRRDocumentType = class;
  TGRRSeismicReport = class;
  TGRRDocumentStructure = class;
  TGRRDocumentStructures = class;
  TGRRDocument = class;
  TGRRDocumentField = class;
  TGRRDocumentFields = class;
  TGRRDocumentBed = class;
  TGRRDocumentBeds = class;
  TGRRStateChange = class;
  TGRRStateChanges = class;

  TGRRWellIntervalType = class(TRegisteredIDObject)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TGRRWellIntervalTypes = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TGRRWellIntervalType;
  public
    property Items[Index: integer]: TGRRWellIntervalType read GetItems;
    constructor Create; override;
  end;


  TGRRParamGroupType = class(TRegisteredIDObject)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TGRRParamGroupTypes = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TGRRParamGroupType;
  public
    property Items[Index: integer]: TGRRParamGroupType read GetItems;
    constructor Create; override;
  end;

  TGRRParamGroup = class(TRegisteredIDObject)
  private
    FGRRParamGroupType: TGRRParamGroupType;
    FOrder: integer;
  protected
    FGRRParameters: TGRRParameters;
    procedure AssignTo(Dest: TPersistent); override;
    function GetGRRParameters: TGRRParameters; virtual;
  public
    property  Order: integer read FOrder write FOrder;
    procedure MakePlainList(AList: TLoadingGRRParameters; Recourse: boolean); 
    property  Parameters: TGRRParameters read GetGRRParameters;
    property  ParamGroupType: TGRRParamGroupType read FGRRParamGroupType write FGRRParamGroupType;
    constructor Create(ACollection: TIDObjects); override;
    destructor Destroy; override;
  end;


  TGRRParamGroups = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TGRRParamGroup;
  public
    procedure MakePlainList(AList: TLoadingGRRParameters; Recourse: boolean); 
    property Items[Index: integer]: TGRRParamGroup read GetItems;
    constructor Create; override;
  end;

  TGRRParameterName = class(TRegisteredIDObject)
  private
    FMeasureUnit: TMeasureUnit;
    FDefaultParameterType: TGRRParameterType;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    function    List(AListOption: TListOption = loBrief): string; override;
    property DefaultMeasureUnit: TMeasureUnit read FMeasureUnit write FMeasureUnit;
    property DefaultParameterType: TGRRParameterType read FDefaultParameterType write FDefaultParameterType;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TGRRParameterNames = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TGRRParameterName;
  public
    property Items[Index: integer]: TGRRParameterName read GetItems;
    constructor Create; override;
  end;

  TGRRParameterType = class(TRegisteredIDObject)
  private
    FIsString: boolean;
    FIsDate: boolean;
    FIsDictValue: boolean;
    FIsNumeric: boolean;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property IsString: boolean read FIsString write FIsString;
    property IsDate: boolean read FIsDate write FIsDate;
    property IsNumeric: boolean read FIsNumeric write FIsNumeric;
    property IsDictValue: boolean read FIsDictValue write FIsDictValue;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TGRRParameterTypes = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TGRRParameterType;
  public
    property Items[Index: integer]: TGRRParameterType read GetItems;
    constructor Create; override;
  end;

  TGRRParameter = class(TRegisteredIDObject)
  private
    FParameterName: TGRRParameterName;
    FParameterType: TGRRParameterType;
    FMeasureUnit: TMeasureUnit;
    FGRRParameters: TGRRParameters;
    FIsMultiple: boolean;
    FPredefinedValues: TGRRParamPredefinedValues;
    FRiccTable: TRiccTable;
    FOwnsParameterName: boolean;
    FIsReadOnly: boolean;
    FOrder: integer;

    function  GetChildParameters: TGRRParameters;
    function  GetParentParameter: TGRRParameter;
    function  GetGroup: TGRRParamGroup;
    function  GetMeasureUnit: TMeasureUnit;
    function  GetPredefinedValues: TGRRParamPredefinedValues;
    procedure SetParentParameter(const Value: TGRRParameter);
    procedure SetGroup(const Value: TGRRParamGroup);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property ParameterName: TGRRParameterName read FParameterName write FParameterName;
    property MeasureUnit: TMeasureUnit read GetMeasureUnit write FMeasureUnit;

    property ParameterGroup: TGRRParamGroup read GetGroup write SetGroup;

    property ParameterType: TGRRParameterType read FParameterType write FParameterType;
    property Table: TRiccTable read FRiccTable write FRiccTable;
    property IsMultiple: boolean read FIsMultiple write FIsMultiple;
    property IsReadOnly: boolean read FIsReadOnly write FIsReadOnly;
    property Order: integer read FOrder write FOrder;

    function List(AListOption: TListOption = loBrief): string; override;

    function CheckValue(Value: string): boolean;
    property ParentParameter: TGRRParameter read GetParentParameter write SetParentParameter;
    property ChildParameters: TGRRParameters read GetChildParameters;

    // для параметров которые не из базы имя параметра создается динамически и не участвует в коллекции имен параметров
    property OwnsParameterName: boolean read FOwnsParameterName;
    property PredefinedValues: TGRRParamPredefinedValues read GetPredefinedValues;

    constructor Create(ACollection: TIDObjects); override;
    destructor Destroy; override;
  end;

  TGRRParameters = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TGRRParameter;
  public
    function  AddParameter(const AParameterName: string; AParameterType: TGRRParameterType; AMeasureUnit: TMeasureUnit; ATable: TRiccTable; const AReadOnly: boolean = false; const AMakeFakeChildren: boolean = false): TGRRParameter;
    procedure MakePlainList(AList: TLoadingGRRParameters; Recourse: boolean);
    property  Items[Index: integer]: TGRRParameter read GetItems;
    constructor Create; override;
  end;

  TLoadingGRRParameters = class(TGRRParameters)
  public
    constructor Create; override;
  end;


  TGRRParameterValue = class(TRegisteredIDObject)
  private
    FParameter: TGRRParameter;
    FTableKeyValue: integer;
    FNumValue: single;
    FStringValue: string;
    FDateTimeValue: TDateTime;
    FChildParameterValues: TGRRParameterValues;
    function  GetCommonValue: string;
    procedure SetCommonValue(const Value: string);
    function  GetChildParameterValues: TGRRParameterValues;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property Parameter: TGRRParameter read FParameter write FParameter;
    property NumValue: single read FNumValue write FNumValue;
    property StringValue: string read FStringValue write FStringValue;
    property DateTimeValue: TDateTime read FDateTimeValue write FDateTimeValue;
    property TableKeyValue: integer read FTableKeyValue write FTableKeyValue;

    property ChildParameterValues: TGRRParameterValues read GetChildParameterValues;



    property CommonValue: string read GetCommonValue write SetCommonValue; 
    constructor Create(ACollection: TIDObjects); override;
  end;

  TGRRParameterValues = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TGRRParameterValue;
    function GetHasUpperZeroParam: boolean;
  public
    function AddValueByParameter(AParameter: TGRRParameter): TGRRParameterValue;
    function GetValueByParameter(AParameter: TGRRParameter; const AddIfNotExist: boolean = false): TGRRParameterValue;

    // получаем набор параметров по группе
    procedure GetParamValuesForGroup(AParamGroup: TGRRParamGroup; AParamValues: TGRRParameterValues; MakeCopy: boolean);
    // удаляем набор параметров для группы
    procedure DeleteParamValuesForGroup(AParamGroup: TGRRParamGroup);
    // заменяем старый набор параметров на новый
    procedure ReplaceParameterValuesForGroup(AParamGroup: TGRRParamGroup; ANewValues: TGRRParameterValues);

    property  HasUpperZeroParam: boolean read GetHasUpperZeroParam;


    property Items[Index: integer]: TGRRParameterValue read GetItems;
    constructor Create; override;
  end;

  TOrganizationGRRParameterValue = class(TGRRParameterValue)
  private
    FElectricProspectingCost: Double;
    FSoftwareCost: Double;
    FSeism3DVol: Double;
    FDrillingExpl: Double;
    FGeochemicalMethodCost: Double;
    FElectricProspectingVol: Double;
    FSeism2DVol: Double;
    FSeism2DCost: Double;
    FSeism3DCost: Double;
    FMksSlboCost: Double;
    FOtherCost: Double;
    FVSPCost: Double;
    FDrillingStr: Double;
    FLicZone: TIDObject;
    FWell: TSimpleWell;
    FWellFullName: string;
    FLicZoneFullName: string;
    FNiokrCost: Double;
  public
    property LicZone: TIDObject read FLicZone write FLicZone;
    property LicZoneFullName: string read FLicZoneFullName write FLicZoneFullName;

    property Well: TSimpleWell read FWell write FWell;
    property WellFullName: string read FWellFullName write FWellFullName;

    property DrillingStr: Double read FDrillingStr write FDrillingStr;
    property DrillingExpl: Double read FDrillingExpl write FDrillingExpl;

    property Seism2DVol: Double read FSeism2DVol write FSeism2DVol;
    property Seism2DCost: Double read FSeism2DCost write FSeism2DCost;
    property Seism3DVol: Double read FSeism3DVol write FSeism3DVol;
    property Seism3DCost: Double read FSeism3DCost write FSeism3DCost;

    property VSPCost: Double read FVSPCost write FVSPCost;
    property MksSlboCost: Double read FMksSlboCost write FMksSlboCost;
    property ElectricProspectingVol: Double read FElectricProspectingVol write FElectricProspectingVol;
    property ElectricProspectingCost: Double read FElectricProspectingCost write FElectricProspectingCost;
    property GeochemicalMethodCost: Double read FGeochemicalMethodCost write FGeochemicalMethodCost;
    property NiokrCost: Double read FNiokrCost write FNiokrCost;
    property SoftwareCost: Double read FSoftwareCost write FSoftwareCost;
    property OtherCost: Double read FOtherCost write FOtherCost;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TOrganizationGRRParameterValues = class(TGRRParameterValues)
  private
    function GetItems(Index: integer): TOrganizationGRRParameterValue;
  public
    property  Items[Index: integer]: TOrganizationGRRParameterValue read GetItems;
    constructor Create; override;
  end;

  TSumByOrgGRRParameterValue = class(TOrganizationGRRParameterValue)
  private
    FOrganization: TOrganization;
  public
    property Organization: TOrganization read FOrganization write FOrganization;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TSumByOrgGRRParameterValues = class(TOrganizationGRRParameterValues)
  private
    function GetItems(Index: integer): TSumByOrgGRRParameterValue;
    function GetItemsByOrganizationID(
      Index: integer): TSumByOrgGRRParameterValue;
  public
    property  Items[Index: integer]: TSumByOrgGRRParameterValue read GetItems;
    property  ItemsByOrganizationID[Index: integer]: TSumByOrgGRRParameterValue read GetItemsByOrganizationID;

    constructor Create; override;
  end;

  TWellGRRParameterValue = class(TGRRParameterValue)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TIntervalGRRParameterValue = class(TGRRParameterValue)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TDocumentGrrParameterValue = class(TGRRParameterValue)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TBedGRRParameterValue = class(TGRRParameterValue)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;




  // специальная коллекция, которая используется только для
  // редактирования, умеет не храниться в БД, принадлежит группе
  TGRRGroupParameterValues = class(TGRRParameterValues)
  private
    FParameterGroup: TGRRParamGroup;
  public
    property    ParameterGroup: TGRRParamGroup read FParameterGroup write FParameterGroup;
    constructor Create; override;
  end;

  TWellGRRParameterValues = class(TGRRParameterValues)
  private
    function GetWell: TSimpleWell;
  public
    property Well: TSimpleWell read GetWell;
    constructor Create; override;
  end;

  TIntervalGRRParameterValues = class(TGRRParameterValues)
  private
    function GetInterval: TGRRWellInterval;
  public
    property Interval: TGRRWellInterval read GetInterval;
    constructor Create; override;
  end;

  TDocumentGRRParameterValues = class(TGRRParameterValues)
  private
    function GetDocument: TGRRDocument;
  public
    property GRRDocument: TGRRDocument read GetDocument;
    constructor Create; override;
  end;

  TBedGRRParameterValues = class(TGRRParameterValues)
  private
    function GetBed: TGRRDocumentBed;
  public
    property Bed: TGRRDocumentBed read GetBed; 
    constructor Create; override;
  end;

  TGRRWellInterval = class(TSimpleWellInterval)
  private
    FWellIntervalType: TGRRWellIntervalType;
    FStraton: TSimpleStraton;
    FGRRParameterValues: TGRRParameterValues;
    FComment: string;
    FFileName: string;
    function GetGRRParameterValues: TGRRParameterValues;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    // параметры для интервала
    function  List(AListOption: TListOption = loBrief): string; override;
    property  GRRParameterValues: TGRRParameterValues read GetGRRParameterValues;
    property  IntervalType: TGRRWellIntervalType read FWellIntervalType write FWellIntervalType;
    property  Straton: TSimpleStraton read FStraton write FStraton;
    property  Comment: string read FComment write FComment;
    property  FileName: string read FFileName write FFileName;

    function    Update(ACollection: TIDObjects = nil): integer; override;
    constructor Create(ACollection: TIDObjects); override;

  end;

  TGRRWellIntervals = class(TBaseWellIntervals)
  private
    function GetItems(Index: integer): TGRRWellInterval;
  public
    property Items[Index: integer]: TGRRWellInterval read GetItems;
    constructor Create; override;
  end;

  TGRRDocumentType = class(TRegisteredIDObject)
  public
    function  List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TGRRDocumentTypes = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TGRRDocumentType;
  public
    property Items[Index: integer]: TGRRDocumentType read GetItems;
    constructor Create; override;
  end;




  TGRRDocument = class(TRegisteredIDObject)
  private
    FYear: integer;
    FAuthors: string;
    FDocumentType: TGRRDocumentType;
    FParameterValues: TGRRParameterValues;
    FParameterGroup: TGRRParamGroup;
    FGRRStateChanges: TGRRStateChanges;
    function GetReportName: string;
    function GetParameterValues: TGRRParameterValues;
    procedure SetDocumentType(const Value: TGRRDocumentType);
    function GetGRRStateChanges: TGRRStateChanges;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property Year: integer read FYear write FYear;
    property Authors: string read FAuthors write FAuthors;
    property ReportName: string read GetReportName;
    property DocumentType: TGRRDocumentType read FDocumentType write SetDocumentType;
    property ParameterValues: TGRRParameterValues read GetParameterValues;
    property ParameterGroup: TGRRParamGroup read FParameterGroup write FParameterGroup;

    property GRRStateChanges: TGRRStateChanges read GetGRRStateChanges;

    function  Update(ACollection: TIDObjects = nil): integer; override;

    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;

  end;

  TGRRDocuments = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TGRRDocument;
  public
    function GetDocumentByType(ADocumentType: TGRRDocumentType): TGRRDocument;
    property Items[Index: integer]: TGRRDocument read GetItems;
    constructor Create; override;
    procedure Reload; override;
  end;

  TGRRSeismicReport = class(TGRRDocument)
  private
    FSeismicGroupNumber: string;
    FStructures: TGRRDocumentStructures;
    function GetStructures: TGRRDocumentStructures;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property SeismicGroupNumber: string read FSeismicGroupNumber write FSeismicGroupNumber;
    property Structures: TGRRDocumentStructures read GetStructures;
    function  List(AListOption: TListOption = loBrief): string; override;
    function  Update(ACollection: TIDObjects = nil): integer; override;
    procedure Accept(Visitor: IVisitor); override;

    constructor Create(ACollection: TIDObjects); override;
    destructor Destroy; override;
  end;

  TGRRSeisimicReports = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TGRRSeismicReport;
  public
    property Items[Index: integer]: TGRRSeismicReport read GetItems;
    constructor Create; override;
    procedure Reload; override;
  end;

  TGRRReservesRecountDocument = class(TGRRDocument)
  private
    FFields: TGRRDocumentFields;
    function GetFields: TGRRDocumentFields;
  public
    property   Fields: TGRRDocumentFields read GetFields;
    constructor Create(ACollection: TIDObjects); override;
    destructor Destroy; override;
  end;

  TGRRReservesRecountDocuments = class(TGRRDocuments)
  private
    function GetItems(Index: integer): TGRRReservesRecountDocument;
  public
    property Items[Index: integer]: TGRRReservesRecountDocument read GetItems;
    constructor Create; override;
    procedure Reload; override;
  end;

  TWellIntervalsByType = class(TIdObject)
  private
    FWellIntervals: TGRRWellIntervals;
    FWellIntervalType: TGRRWellIntervalType;
    function GetWellIntervals: TGRRWellIntervals;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property WellIntervalType: TGRRWellIntervalType read FWellIntervalType write FWellIntervalType;
    property WellIntervals: TGRRWellIntervals read GetWellIntervals;

    constructor Create(ACollection: TIDObjects); override;
    destructor Destroy; override;
  end;

  TWellIntervalsByTypeList = class(TIDObjects)
  private
    function GetItems(Index: integer): TWellIntervalsByType;
  public
    property Items[Index: integer]: TWellIntervalsByType read GetItems;
    function AddWellIntervalsByType(AWellIntervalType: TGRRWellIntervalType): TWellIntervalsByType;
    function GetIntervalsByType(AWellIntervalType: TGRRWellIntervalType): TGRRWellIntervals; overload;
    function GetWellIntervalByType(AWellIntervalType: TGRRWellIntervalType): TWellIntervalsByType; overload;


    constructor Create; override;
    procedure Reload; override;
  end;

  TLicenseZoneWellGRRParameterValueSet = class(TRegisteredIDObject)
  private
    FWell: TSimpleWell;
    FWellLicenseZoneParameterValues: TWellGRRParameterValues;
    FWellIntervalByTypeList: TWellIntervalsByTypeList;
    function GetWellGRRParameterValues: TWellGRRParameterValues;
    function GetWellIntervslByType(
      WellIntervalType: TGRRWellIntervalType): TGRRWellIntervals;
  public
    property  Well: TSimpleWell read FWell write FWell;
    property  GRRParameterValues: TWellGRRParameterValues read GetWellGRRParameterValues;
    property  WellIntervalsByType[WellIntervalType: TGRRWellIntervalType]: TGRRWellIntervals read GetWellIntervslByType;

    function  GetLastIntervalOfType(AIntervalType: TGRRWellIntervalType): TGRRWellInterval;




    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TLicenseZoneWellGRRParameterValueSets = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TLicenseZoneWellGRRParameterValueSet;
  public
    procedure Reload; override;
    function  GetValueSetByWell(AWell: TSimpleWell): TLicenseZoneWellGRRParameterValueSet;
    property  Items[Index: integer]: TLicenseZoneWellGRRParameterValueSet read GetItems;
    constructor Create; override;
  end;


  TGRRParamPredefinedValue = class(TRegisteredIDObject)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TGRRParamPredefinedValues = class(TRegisteredIDObjects)
  private
    function GetParameter: TGRRParameter;
  public
    property Parameter: TGRRParameter read GetParameter;
    constructor Create; override;
  end;

  TGRRDocumentStructure = class(TRegisteredIDObject)
  private
    FStructure: TIDObject;
    FFundType: TIDObject;
    function GetReport: TGRRSeismicReport;
    procedure SetStructure(const Value: TIDObject);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property Structure: TIDObject read FStructure write SetStructure;
    property FundType: TIDObject read FFundType write FFundType;
    property Report: TGRRSeismicReport read GetReport;

    constructor Create(ACollection: TIDObjects); override;
  end;


  TGRRDocumentStructures = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TGRRDocumentStructure;
  public
    function  Check(out Index: Integer): Boolean;
    property  Items[Index: integer]: TGRRDocumentStructure read GetItems;
    constructor Create; override;
  end;


  TGRRDocumentBed  = class(TRegisteredIDObject)
  private
    FBed: TIDObject;
    FBedType: TIDObject;
    FGRRParameterValues: TGRRParameterValues;
    function GetField: TGRRDocumentField;
    function GetGRRParameterValues: TGRRParameterValues;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property Bed: TIDObject read FBed write FBed;
    property Field: TGRRDocumentField read GetField;
    property BedType: TIDObject read FBedType write FBedType;
    property  GRRParameterValues: TGRRParameterValues read GetGRRParameterValues;    

    constructor Create(ACollection: TIDObjects); override;
  end;

  TGRRDocumentBeds = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TGRRDocumentBed;
  public
    function  GetBedBySimpleBedID(ABedID: integer): TGRRDocumentBed;
    property  Items[Index: integer]: TGRRDocumentBed read GetItems;
    constructor Create; override;
  end;


  TGRRDocumentField = class(TGRRDocumentStructure)
  private
    FBeds: TGRRDocumentBeds;
    function GetBeds: TGRRDocumentBeds;
  public
    procedure   LoadBeds;
    property    Beds: TGRRDocumentBeds read GetBeds;
    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TGRRDocumentFields = class(TGRRDocumentStructures)
  private
    function GetItems(Index: integer): TGRRDocumentField;
  public
    property Items[Index: Integer]: TGRRDocumentField read GetItems;
    constructor Create; override;
  end;

  TOilShowingType = class(TRegisteredIDObject)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TOilShowingTypes = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TOilShowingType;
  public
    property Items[Index: integer]: TOilShowingType read GetItems;
    constructor Create; override;
  end;

  TGRRStateChangeType = class(TRegisteredIDObject)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TGRRStateChangeTypes = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TGRRStateChangeType;
  public
    property Items[Index: integer]: TGRRStateChangeType read GetItems;
    constructor Create; override;
  end;

  TGRRStateChange = class(TIDObject)
  private
    FStateChangeType: TGRRStateChangeType;
    FParamGroup: TGRRParamGroup;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property StateChangeType: TGRRStateChangeType read FStateChangeType write FStateChangeType;
    property ParamGroup: TGRRParamGroup read FParamGroup write FParamGroup;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TGRRStateChanges = class(TIDObjects)
  private
    function GetItems(Index: integer): TGRRStateChange;
  public
    property Items[Index: integer]: TGRRStateChange read GetItems;
    constructor Create; override;
  end;


implementation

uses Facade, GRRParameterPoster, SysUtils, LicenseZone, Contnrs, Structure,
     SDFacade;

{ TGRRParamGroupType }

constructor TGRRParamGroupType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип группы параметров по ГРР';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGRRParamGroupTypeDataPoster];
end;

{ TGRRParamGroupTypes }

constructor TGRRParamGroupTypes.Create;
begin
  inherited;
  FObjectClass := TGRRParamGroupType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TGRRParamGroupTypeDataPoster];
end;

function TGRRParamGroupTypes.GetItems(Index: integer): TGRRParamGroupType;
begin
  Result := inherited Items[Index] as TGRRParamGroupType;
end;

{ TGRRParamGroup }

procedure TGRRParamGroup.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TGRRParamGroup).ParamGroupType := ParamGroupType;
  (Dest as TGRRParamGroup).Order := Order;
end;

constructor TGRRParamGroup.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Группа параметров по ГРР';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGRRParamGroupDataPoster];
end;

destructor TGRRParamGroup.Destroy;
begin
  FreeAndNil(FGRRParameters);
  inherited;
end;

function TGRRParamGroup.GetGRRParameters: TGRRParameters;
begin
  if not Assigned(FGRRParameters) then
  begin
    FGRRParameters := TGRRParameters.Create;
    FGRRParameters.Owner := Self;
    FGRRParameters.Reload('(GRRPARAM_GROUP_ID = ' + IntToStr(ID) + ') AND (PARENT_PARAM_ID IS NULL)', true);
  end;

  Result := FGRRParameters;
end;

procedure TGRRParamGroup.MakePlainList(AList: TLoadingGRRParameters; Recourse: boolean);
begin
  Parameters.MakePlainList(AList, Recourse);
end;

{ TGRRParamGroups }

constructor TGRRParamGroups.Create;
begin
  inherited;
  FObjectClass := TGRRParamGroup;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TGRRParamGroupDataPoster];
end;

function TGRRParamGroups.GetItems(Index: integer): TGRRParamGroup;
begin
  Result := inherited Items[Index] as TGRRParamGroup;
end;

procedure TGRRParamGroups.MakePlainList(AList: TLoadingGRRParameters;
  Recourse: boolean);
var i: integer;
begin
  for i := 0 to Count - 1 do
    Items[i].MakePlainList(AList, Recourse);
end;

{ TGRRParameter }

procedure TGRRParameter.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TGRRParameter).ParameterName := ParameterName;
  (Dest as TGRRParameter).MeasureUnit := MeasureUnit;
  (Dest as TGRRParameter).ParameterType := ParameterType;
  (Dest as TGRRParameter).IsMultiple := IsMultiple;
  (Dest as TGRRParameter).IsReadOnly := IsReadOnly;
  (Dest as TGRRParameter).Order := Order;
end;

function TGRRParameter.CheckValue(Value: string): boolean;
begin
  Result := true;

  if Assigned(ParameterType) then
  begin
    case ParameterType.ID of
    GRR_NUMERIC_PARAM_TYPE_ID:
    try
      StrToFloatEx(Value);
    except
      Result := false;
    end;
    GRR_DATE_PARAM_TYPE_ID:
    try
      StrToDateTime(Value)
    except
      Result := false;
    end;
    GRR_DOMAIN_PARAM_TYPE_ID: Result := false;
    else
      Result := false;
    end;
  end
  else Result := false;
end;

constructor TGRRParameter.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Параметр ГРР';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGRRParameterDataPoster];
  FOwnsParameterName := false;
  FIsReadOnly := False;
end;

destructor TGRRParameter.Destroy;
begin
  FreeAndNil(FGRRParameters);
  FreeAndNil(FPredefinedValues);
  if FOwnsParameterName then
    FreeAndNil(FParameterName);
  inherited;
end;

function TGRRParameter.GetChildParameters: TGRRParameters;
begin
  if not Assigned(FGRRParameters) then
  begin
    FGRRParameters := TGRRParameters.Create;
    FGRRParameters.Owner := Self;

    FGRRParameters.Reload('PARENT_PARAM_ID = ' + IntToStr(ID));
  end;

  Result := FGRRParameters;
end;

function TGRRParameter.GetGroup: TGRRParamGroup;
begin
  Result := nil;
  if Assigned(ParentParameter) then
    Result := ParentParameter.ParameterGroup;

  if (not Assigned(Result)) and (Owner is TGRRParamGroup) then
    Result := (Owner as TGRRParamGroup);
end;

function TGRRParameter.GetMeasureUnit: TMeasureUnit;
begin
  if Assigned(FMeasureUnit) then
    Result := FMeasureUnit
  else
    Result := ParameterName.DefaultMeasureUnit;
end;

function TGRRParameter.GetParentParameter: TGRRParameter;
begin
  Result := nil;
  if Collection.Owner is TGRRParameter then
    Result := Collection.Owner as TGRRParameter;
end;

function TGRRParameter.GetPredefinedValues: TGRRParamPredefinedValues;
begin
  if not Assigned(FPredefinedValues) then
  begin
    FPredefinedValues := TGRRParamPredefinedValues.Create;
    FPredefinedValues.Owner := Self;
    FPredefinedValues.Reload('Param_ID = ' + IntToStr(ID));
  end;

  Result := FPredefinedValues;
end;

function TGRRParameter.List(AListOption: TListOption): string;
begin
  if Assigned(ParameterName) then
    Result := ParameterName.List(AListOption);
end;


procedure TGRRParameter.SetGroup(const Value: TGRRParamGroup);
begin
  if Value <> ParameterGroup then
  begin
    Self.Update(Value.Parameters);
    Value.Parameters.Refresh;
    ParameterGroup.Parameters.Refresh;
  end;
end;

procedure TGRRParameter.SetParentParameter(const Value: TGRRParameter);
begin
  if Value <> ParentParameter then
  begin
    Self.Update(Value.ChildParameters);
    Value.ChildParameters.Refresh;
    ParentParameter.ChildParameters.Refresh;
  end;
end;

{ TGRRParameters }

function TGRRParameters.AddParameter(const AParameterName: string;
  AParameterType: TGRRParameterType; AMeasureUnit: TMeasureUnit;
  ATable: TRiccTable; const AReadOnly: boolean = false; const AMakeFakeChildren: boolean = false): TGRRParameter;
var pn: TGRRParameterName;
begin
  Result := inherited Add as TGRRParameter;

  pn := TGRRParameterName.Create(nil);
  pn.Name := AParameterName;
  pn.DefaultMeasureUnit := AMeasureUnit;
  pn.DefaultParameterType := AParameterType;

  Result.FOwnsParameterName := true;

  Result.ParameterName := pn;
  Result.MeasureUnit := AMeasureUnit;
  Result.Table := ATable;
  Result.ParameterType := AParameterType;
  Result.IsReadOnly := AReadOnly;

  if AMakeFakeChildren then
  begin
    Result.FGRRParameters := TGRRParameters.Create;
    Result.FGRRParameters.Owner := Result;
  end;
end;

constructor TGRRParameters.Create;
begin
  inherited;
  FObjectClass := TGRRParameter;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TGRRParameterDataPoster];
end;

function TGRRParameters.GetItems(Index: integer): TGRRParameter;
begin
  Result := inherited Items[Index] as TGRRParameter;
end;

procedure TGRRParameters.MakePlainList(AList: TLoadingGRRParameters; Recourse: boolean);
var i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if Recourse then
    begin
      AList.Add(Items[i], false, false);
      Items[i].ChildParameters.MakePlainList(AList, Recourse);
    end
    // если не делаем рекурсивный список, то грузим только простые параметры
    else if  Items[i].ChildParameters.Count = 0 then AList.Add(Items[i], false, false);
  end;
end;

{ TGRRParameterName }

procedure TGRRParameterName.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TGRRParameterName).DefaultMeasureUnit := DefaultMeasureUnit;
  (Dest as TGRRParameterName).DefaultParameterType := DefaultParameterType;
end;

constructor TGRRParameterName.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Наименование параметра по ГРР';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGRRParamNameDataPoster];  
end;

function TGRRParameterName.List(AListOption: TListOption): string;
begin
  Result := Name;
  if Assigned(DefaultMeasureUnit) then
  if DefaultMeasureUnit.ID <> DEFAULT_MEASURE_UNIT_ID then 
    Result := Result + ', ' + DefaultMeasureUnit.List(loBrief);
end;

{ TGRRParameterNames }

constructor TGRRParameterNames.Create;
begin
  inherited;
  FObjectClass := TGRRParameterName;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TGRRParamNameDataPoster];
  OwnsObjects := true;
end;

function TGRRParameterNames.GetItems(Index: integer): TGRRParameterName;
begin
  Result := inherited Items[Index] as TGRRParameterName;
end;

{ TGRRParameterType }

procedure TGRRParameterType.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TGRRParameterType).IsString := IsString;
  (Dest as TGRRParameterType).IsDate := IsDate;
  (Dest as TGRRParameterType).IsNumeric := IsNumeric;
  (Dest as TGRRParameterType).IsDictValue := IsDictValue;
end;

constructor TGRRParameterType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип данных параметра по ГРР';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGRRParamTypeDataPoster];
end;

{ TGRRParameterTypes }

constructor TGRRParameterTypes.Create;
begin
  inherited;
  FObjectClass := TGRRParameterType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TGRRParamTypeDataPoster];
end;

function TGRRParameterTypes.GetItems(Index: integer): TGRRParameterType;
begin
  Result := inherited Items[Index] as TGRRParameterType;
end;

{ TGRRParameterValue }

procedure TGRRParameterValue.AssignTo(Dest: TPersistent);
var i: Integer;
begin
  inherited;
  (Dest as TGRRParameterValue).Parameter := Parameter;
  (Dest as TGRRParameterValue).NumValue := NumValue;
  (Dest as TGRRParameterValue).StringValue := StringValue;
  (Dest as TGRRParameterValue).DateTimeValue := DateTimeValue;
  (Dest as TGRRParameterValue).TableKeyValue := TableKeyValue;

  (Dest as TGRRParameterValue).ChildParameterValues.Clear;
  for i := 0 to ChildParameterValues.Count - 1 do
    (Dest as TGRRParameterValue).ChildParameterValues.Add.Assign(ChildParameterValues.Items[i]);
end;


constructor TGRRParameterValue.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Значение параметра ГРР';
end;

function TGRRParameterValue.GetChildParameterValues: TGRRParameterValues;
begin
  if not Assigned(FChildParameterValues) then
  begin
    FChildParameterValues := TGRRParameterValues.Create;
    FChildParameterValues.Owner := Self;
    FChildParameterValues.Reload('Parent_Param_Value_ID = ' + IntToStr(ID));
  end;
  Result := FChildParameterValues;
end;

function TGRRParameterValue.GetCommonValue: string;
var o: TIDObject;
begin
  if Assigned(Parameter) and Assigned(Parameter.ParameterType) then
  begin
    case Parameter.ParameterType.ID of
    GRR_NUMERIC_PARAM_TYPE_ID: Result := Format('%.4f', [NumValue]);
    GRR_STRING_PARAM_TYPE_ID: Result := StringValue;
    GRR_DATE_PARAM_TYPE_ID:
    begin
      if DateTimeValue <> 0 then
        Result := DateTimeToStr(DateTimeValue)
      else
        Result := '';
    end;
    GRR_DOMAIN_PARAM_TYPE_ID:
    begin
      Assert(Assigned(Parameter.Table), 'не задан справочник значений, для ввода значений параметра ' + Parameter.ParameterName.Name);
      Assert(Assigned(Parameter.Table.Collection), 'не задана коллекция для подгрузки справочника');

      o := Parameter.Table.Collection.ItemsByID[FTableKeyValue];
      if Assigned(o) then Result := o.Name
      else Result := '';
    end
    else
      raise EUnknownParameterType.Create('Неизвестный тип параметра');
    end;
  end
  else
    raise EUnknownParameterType.Create('Неизвестный тип параметра');
end;


procedure TGRRParameterValue.SetCommonValue(const Value: string);
var o: TIDObject;
begin
  if Assigned(Parameter) and Assigned(Parameter.ParameterType) then
  begin
    case Parameter.ParameterType.ID of
    GRR_NUMERIC_PARAM_TYPE_ID: NumValue := ExtractFloat(Value);
    GRR_STRING_PARAM_TYPE_ID: StringValue := Value;
    GRR_DATE_PARAM_TYPE_ID: if trim(Value) <> '' then DateTimeValue := StrToDateTime(Value);
    GRR_DOMAIN_PARAM_TYPE_ID:
    begin
      Assert(Assigned(Parameter.Table), 'не задан справочник значений, для ввода значений параметра ' + Parameter.ParameterName.Name);
      Assert(Assigned(Parameter.Table.Collection), 'не задана коллекция для подгрузки справочника');

      o := Parameter.Table.Collection.GetItemByName(Value);
      if Assigned(o) then TableKeyValue := o.ID;
    end
    else
      raise EUnknownParameterType.Create('Неизвестный тип параметра');
    end;
  end
  else
    raise EUnknownParameterType.Create('Неизвестный тип параметра');
end;

{ TGRRParameterValues }

function TGRRParameterValues.AddValueByParameter(
  AParameter: TGRRParameter): TGRRParameterValue;
begin
  Result := inherited Add as TGRRParameterValue;
  Result.Parameter := AParameter;
end;

constructor TGRRParameterValues.Create;
begin
  inherited;
  FObjectClass := TGRRParameterValue;
end;

procedure TGRRParameterValues.DeleteParamValuesForGroup(
  AParamGroup: TGRRParamGroup);
var i: integer;
begin
  for i := Count - 1 downto 0 do
  if Items[i].Parameter.ParameterGroup = AParamGroup then
    Delete(i);
end;

function TGRRParameterValues.GetHasUpperZeroParam: boolean;
var i: integer;
begin
  Result := false;
  for i := 0 to Count - 1 do
  if Items[i].NumValue > 0 then
  begin
    Result := true;
    break;
  end;
end;

function TGRRParameterValues.GetItems(Index: integer): TGRRParameterValue;
begin
  Result := inherited Items[Index] as TGRRParameterValue;
end;

procedure TGRRParameterValues.GetParamValuesForGroup(
  AParamGroup: TGRRParamGroup; AParamValues: TGRRParameterValues; MakeCopy: boolean);
var i: integer;
begin
  for i := 0 to Count - 1 do
  if Items[i].Parameter.ParameterGroup = AParamGroup then
    AParamValues.Add(Items[i], MakeCopy, false);
end;

function TGRRParameterValues.GetValueByParameter(
  AParameter: TGRRParameter; const AddIfNotExist: boolean = false): TGRRParameterValue;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].Parameter = AParameter then
  begin
    Result := Items[i];
    break;
  end;

  if (not Assigned(Result)) and AddIfNotExist then
    Result := AddValueByParameter(AParameter)
end;

procedure TGRRParameterValues.ReplaceParameterValuesForGroup(
  AParamGroup: TGRRParamGroup; ANewValues: TGRRParameterValues);
var i: Integer;
begin
  DeleteParamValuesForGroup(AParamGroup);

  for i := 0 to ANewValues.Count - 1 do
  if ANewValues.Items[i].Parameter.ParameterGroup = AParamGroup then
    (Add as TGRRParameterValue).Assign(ANewValues.Items[i]);
end;

{ TWellGRRParameterValue }


constructor TWellGRRParameterValue.Create(ACollection: TIDObjects);
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TWellGRRParameterValueDataPoster];
end;

{ TWellGRRParameterValues }

constructor TWellGRRParameterValues.Create;
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TWellGRRParameterValueDataPoster];
  FObjectClass := TWellGRRParameterValue; 
end;

{ TLicenseZoneWellGRRParameterValues }

constructor TLicenseZoneWellGRRParameterValueSets.Create;
begin
  inherited;
  FObjectClass := TLicenseZoneWellGRRParameterValueSet;
  FDataPoster := nil;
end;

function TLicenseZoneWellGRRParameterValueSets.GetItems(
  Index: integer): TLicenseZoneWellGRRParameterValueSet;
begin
  Result := inherited Items[Index] as TLicenseZoneWellGRRParameterValueSet;
end;

function TLicenseZoneWellGRRParameterValueSets.GetValueSetByWell(
  AWell: TSimpleWell): TLicenseZoneWellGRRParameterValueSet;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].Well = AWell then
  begin
    Result := Items[i];
    break;
  end;
end;

procedure TLicenseZoneWellGRRParameterValueSets.Reload;
var i: integer;
begin
  if Count = 0 then
  begin
    for i := 0 to (Owner as TSimpleLicenseZone).Wells.Count - 1 do
      (Add as TLicenseZoneWellGRRParameterValueSet).Well := (Owner as TSimpleLicenseZone).Wells.Items[i];
  end;
end;

{ TLicenseZoneWellGRRParameterValue }

constructor TLicenseZoneWellGRRParameterValueSet.Create(
  ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Значение параметра ГРР для скважины по лицензионному участку';
  FWellIntervalByTypeList := TWellIntervalsByTypeList.Create;
  FWellIntervalByTypeList.Owner := Self;
end;

destructor TLicenseZoneWellGRRParameterValueSet.Destroy;
begin
  FreeAndNil(FWellLicenseZoneParameterValues);
  FreeAndNil(FWellIntervalByTypeList);
  inherited;
end;



function TLicenseZoneWellGRRParameterValueSet.GetLastIntervalOfType(
  AIntervalType: TGRRWellIntervalType): TGRRWellInterval;
var intrs: TGRRWellIntervals;
begin
  intrs := FWellIntervalByTypeList.GetIntervalsByType(AIntervalType);
  if intrs.Count > 0 then
    Result := intrs.Items[intrs.Count - 1]
  else
    Result := nil;
end;

function TLicenseZoneWellGRRParameterValueSet.GetWellGRRParameterValues: TWellGRRParameterValues;
begin
  if not Assigned(FWellLicenseZoneParameterValues) then
  begin
    FWellLicenseZoneParameterValues := TWellGRRParameterValues.Create;
    FWellLicenseZoneParameterValues.OwnsObjects := true;
    FWellLicenseZoneParameterValues.Owner := Well;
    FWellLicenseZoneParameterValues.Reload('Well_UIN = ' + IntToStr(Well.ID) + ' AND VERSION_ID = ' + IntToStr(TMainFacade.GetInstance.ActiveVersion.ID));
  end;

  Result := FWellLicenseZoneParameterValues;
end;

function TWellGRRParameterValues.GetWell: TSimpleWell;
begin
  Result := Owner as TSimpleWell; 
end;

{ TLoadingGRRParameters }

constructor TLoadingGRRParameters.Create;
begin
  inherited;
  OwnsObjects := false;
end;

{ TGRRGroupParameterValues }

constructor TGRRGroupParameterValues.Create;
begin
  inherited;
  FDataPoster := nil;
end;

{ TGRRWellIntervalType }

constructor TGRRWellIntervalType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип интервала по ГРР';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGRRWellIntervalTypeDataPoster];
end;

{ TGRRWellIntervalTypes }

constructor TGRRWellIntervalTypes.Create;
begin
  inherited;
  FObjectClass := TGRRWellIntervalType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TGRRWellIntervalTypeDataPoster];
end;

function TGRRWellIntervalTypes.GetItems(
  Index: integer): TGRRWellIntervalType;
begin
  Result := inherited Items[Index] as TGRRWellIntervalType;
end;

{ TGRRWellInterval }

procedure TGRRWellInterval.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TGRRWellInterval).IntervalType := IntervalType;
  (Dest as TGRRWellInterval).Straton := Straton;
  (Dest as TGRRWellInterval).Comment := Comment;
  (Dest as TGRRWellInterval).FileName := FileName;
end;

constructor TGRRWellInterval.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Интервал по ГРР';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGRRWellIntervalDataPoster];
end;

function TGRRWellInterval.GetGRRParameterValues: TGRRParameterValues;
begin
  if not Assigned(FGRRParameterValues) then
  begin
    FGRRParameterValues := TIntervalGRRParameterValues.Create;
    FGRRParameterValues.Owner := Self;
    FGRRParameterValues.Reload('GRR_WELL_INTERVAL_ID = ' + IntToStr(ID), False);
  end;

  Result := FGRRParameterValues;
end;

function TGRRWellInterval.List(AListOption: TListOption): string;
begin
  Result := ''; 
  if Number <> '' then
    Result := Number + ':';

  Result := Result + Format('%.2f', [Top]) + ' - ' + Format('%.2f', [Bottom]);

  if Assigned(Straton) and (Straton.List <> '') then
    Result := Result + '[' + Straton.List + ']';
end;

function TGRRWellInterval.Update(ACollection: TIDObjects): integer;
begin
  Result := inherited Update(ACollection);
  GRRParameterValues.Update(nil);
end;

{ TGRRWellIntervals }

constructor TGRRWellIntervals.Create;
begin
  inherited;
  FObjectClass := TGRRWellInterval;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TGRRWellIntervalDataPoster];
end;

function TGRRWellIntervals.GetItems(Index: integer): TGRRWellInterval;
begin
  Result := inherited Items[index] as TGRRWellInterval;
end;



{ TIntervalGRRParameterValue }


constructor TIntervalGRRParameterValue.Create(ACollection: TIDObjects);
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TTestIntervalGRRParameterDataPoster];
end;

{ TIntervalGRRParameterValues }

constructor TIntervalGRRParameterValues.Create;
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TTestIntervalGRRParameterDataPoster];
  FObjectClass :=  TIntervalGRRParameterValue;
end;

function TIntervalGRRParameterValues.GetInterval: TGRRWellInterval;
begin
  Result := Owner as TGRRWellInterval;
end;

{ TGRRParamPredefinedValue }

constructor TGRRParamPredefinedValue.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Предопределенное значение параметра ГРР';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGRRParamPredefinedValueDataPoster];
end;

{ TGRRParamPredefinedValues }

constructor TGRRParamPredefinedValues.Create;
begin
  inherited;
  FObjectClass := TGRRParamPredefinedValue;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGRRParamPredefinedValueDataPoster];
end;

function TGRRParamPredefinedValues.GetParameter: TGRRParameter;
begin
  Result := Owner as TGRRParameter;
end;

{ TGRRSeismicReport }

procedure TGRRSeismicReport.Accept(Visitor: IVisitor);
begin
  inherited;

end;

procedure TGRRSeismicReport.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TGRRSeismicReport).SeismicGroupNumber := SeismicGroupNumber;
  (Dest as TGRRSeismicReport).ParameterValues.Assign(ParameterValues);
  (Dest as TGRRSeismicReport).Structures.Assign(Structures);
end;

constructor TGRRSeismicReport.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Отчет по сейсморазведочным работам';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGRRWellIntervalDataPoster];
end;

destructor TGRRSeismicReport.Destroy;
begin
  FreeAndNil(FStructures);
  FreeAndNil(FParameterValues);
  inherited;
end;


function TGRRSeismicReport.GetStructures: TGRRDocumentStructures;
begin
  if not Assigned(FStructures) then
  begin
    FStructures := TGRRDocumentStructures.Create;
    FStructures.Owner := Self;
    FStructures.Reload('GRRSEISMIC_REPORT_ID = ' + IntToStr(ID), false);
  end;

  Result := FStructures;
end;

function TGRRSeismicReport.List(AListOption: TListOption): string;
begin
  Result := Name;
end;

function TGRRSeismicReport.Update(ACollection: TIDObjects): integer;
begin
  Result := inherited Update(ACollection);
  Structures.Update(nil);
end;

{ TGRRSesimicReports }

constructor TGRRSeisimicReports.Create;
begin
  inherited;
  FObjectClass := TGRRSeismicReport;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGRRSeismicReportDataPoster];
end;

function TGRRSeisimicReports.GetItems(Index: integer): TGRRSeismicReport;
begin
  Result := inherited Items[index] as TGRRSeismicReport;
end;

{ TGRRDocumentType }

constructor TGRRDocumentType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип отчета по сейсморазведочным работам';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGRRDocumentTypeDataPoster];
end;

function TGRRDocumentType.List(AListOption: TListOption): string;
begin
  Result := Name;
end;

{ TGRRDocumentTypes }

constructor TGRRDocumentTypes.Create;
begin
  inherited;
  FObjectClass := TGRRDocumentType;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGRRDocumentTypeDataPoster];
end;

function TGRRDocumentTypes.GetItems(Index: integer): TGRRDocumentType;
begin
  Result := inherited Items[index] as TGRRDocumentType;
end;

procedure TGRRSeisimicReports.Reload;
var sSeismicreportsID: string;
begin
  Assert(TMainFacade.GetInstance.ActiveVersion <> nil, 'Не задана текущая версия данных');
  sSeismicreportsID := IntToStr(SEISMIC_REPORT_TYPE_REWORK) + ',' + IntToStr(SEISMIC_REPORT_TYPE_2D) + ',' + IntToStr(SEISMIC_REPORT_TYPE_3D);
  Reload('(License_Zone_ID = ' + IntToStr(Owner.ID) + ') and (Version_Id = ' + IntToStr(TMainFacade.GetInstance.ActiveVersion.ID) + ') and (Seismic_Report_Type_Id in ('+sSeismicreportsID+'))');
end;

{ TSeismicReportGrrParameterValue }

constructor TDocumentGrrParameterValue.Create(
  ACollection: TIDObjects);
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TDocumentGRRParameterDataPoster];
end;

{ TDocumentGRRParameterValues }

constructor TDocumentGRRParameterValues.Create;
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TDocumentGRRParameterDataPoster];
  FObjectClass :=  TDocumentGrrParameterValue;
end;

function TDocumentGRRParameterValues.GetDocument: TGRRDocument;
begin
  Result := Owner as TGRRDocument;
end;

{ TGRRDocumentStructure }

procedure TGRRDocumentStructure.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TGRRDocumentStructure).Structure := Structure;
  (Dest as TGRRDocumentStructure).FundType := FundType;
end;

constructor TGRRDocumentStructure.Create(ACollection: TIDObjects);
begin
  inherited;
  FClassIDString := 'Структура';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGRRDocumentStructureDataPoster];
  Name := '';
end;

function TGRRDocumentStructure.GetReport: TGRRSeismicReport;
begin
  Result := Collection.Owner as TGRRSeismicReport;
end;

procedure TGRRDocumentStructure.SetStructure(const Value: TIDObject);
begin
  if FStructure <> Value then
  begin
    FStructure := Value;
    if Assigned(Structure) then
    begin
      FFundType := (FStructure as TStructure).StructureFundType;
      Name := FStructure.Name;
    end;
  end;
end;

{ TGRRDocumentStructures }

function TGRRDocumentStructures.Check(out Index: Integer): Boolean;
var i: integer;
begin
  Result := true;
  Index := -1;
  for i := 0 to Count - 1 do
  begin
    if not ((Assigned(Items[i].Structure) or (trim(Items[i].Name) <> '')) and Assigned(Items[i].FundType)) then
    begin
      Result := false;
      Index := i;
      break;
    end;
  end;
end;

constructor TGRRDocumentStructures.Create;
begin
  inherited;
  FObjectClass := TGRRDocumentStructure;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGRRDocumentStructureDataPoster];
end;

function TGRRDocumentStructures.GetItems(
  Index: integer): TGRRDocumentStructure;
begin
  Result := inherited Items[Index] as TGRRDocumentStructure;
end;


{ TGRRDocument }

procedure TGRRDocument.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TGRRSeismicReport).Year := Year;
  (Dest as TGRRSeismicReport).Authors := Authors;
  (Dest as TGRRSeismicReport).DocumentType := DocumentType;
  (Dest as TGRRSeismicReport).ParameterValues.Assign(ParameterValues);
  (Dest as TGRRSeismicReport).ParameterGroup := ParameterGroup;
end;

constructor TGRRDocument.Create(ACollection: TIDObjects);
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGRRDocumentDataPoster];
end;

destructor TGRRDocument.Destroy;
begin
  FreeAndNil(FGRRStateChanges);
  FreeAndNil(FParameterValues);
  inherited;
end;

function TGRRDocument.GetGRRStateChanges: TGRRStateChanges;
begin
  if not Assigned(FGRRStateChanges) then
  begin
    FGRRStateChanges := TGRRStateChanges.Create;
    FGRRStateChanges.Owner := Self;
    FGRRStateChanges.Reload('GRR_DOCUMENT_ID = ' + IntToStr(ID) + ' AND VERSION_ID = ' + IntToStr(TMainFacade.GetInstance.ActiveVersion.ID));
  end;

  Result := FGRRStateChanges;
end;

function TGRRDocument.GetParameterValues: TGRRParameterValues;
begin
  if not Assigned(FParameterValues) then
  begin
    FParameterValues := TDocumentGRRParameterValues.Create;
    FParameterValues.Owner := Self;
    FParameterValues.Reload('GRR_SEISMIC_REPORT_ID = ' + IntToStr(ID));
  end;

  result := FParameterValues;
end;

function TGRRDocument.GetReportName: string;
begin
  Result := Name;
end;

procedure TGRRDocument.SetDocumentType(const Value: TGRRDocumentType);
begin
  if FDocumentType <> Value then
  begin
    FDocumentType := Value;
    TMainFacade.GetInstance.Registrator.Update(Self, nil, ukUpdate);
  end;

end;

function TGRRDocument.Update(ACollection: TIDObjects): integer;
begin
  Result := inherited Update(ACollection);
  ParameterValues.Update(nil);
end;

{ TGRRDocuments }

constructor TGRRDocuments.Create;
begin
  inherited;
  FObjectClass := TGRRDocument;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGRRDocumentDataPoster];
end;

function TGRRDocuments.GetDocumentByType(
  ADocumentType: TGRRDocumentType): TGRRDocument;
var i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Assigned(Items[i].DocumentType) and (Items[i].DocumentType.ID = ADocumentType.ID) then
  begin
    Result := Items[i];
    Break;
  end;
end;

function TGRRDocuments.GetItems(Index: integer): TGRRDocument;
begin
  Result := inherited Items[Index] as TGRRDocument;
end;

procedure TGRRDocuments.Reload;
begin
  Assert(TMainFacade.GetInstance.ActiveVersion <> nil, 'Не задана текущая версия данных');
  //sSeismicreportsID := IntToStr(SEISMIC_REPORT_TYPE_REWORK) + ',' + IntToStr(SEISMIC_REPORT_TYPE_2D) + ',' + IntToStr(SEISMIC_REPORT_TYPE_3D);
  Reload('(License_Zone_ID = ' + IntToStr(Owner.ID) + ') and (Version_Id = '+ IntToStr(TMainFacade.GetInstance.ActiveVersion.ID) + ')');// and (not (Seismic_Report_Type_Id in ('+sSeismicreportsID+')))');
end;

{ TGRRDocumentField }

constructor TGRRDocumentField.Create(ACollection: TIDObjects);
begin
  inherited;
  FFundType := TMainFacade.GetInstance.AllStructureFundTypes.ItemsByID[FIELD_FUND_TYPE_ID] as TStructureFundType;
end;

destructor TGRRDocumentField.Destroy;
begin
  FreeAndNil(FBeds);
  inherited;
end;

function TGRRDocumentField.GetBeds: TGRRDocumentBeds;
begin
  if not Assigned(FBeds) then
  begin
    FBeds := TGRRDocumentBeds.Create;
    FBeds.Owner := Self;
    FBeds.Reload('Structure_ID = ' + IntToStr(ID));
  end;
  Result := FBeds;
end;

procedure TGRRDocumentField.LoadBeds;
var f: TField;
    b: TGRRDocumentBed;
    i: integer;
begin
  if Assigned(Structure) then
  begin
    f := Structure as TField;

    for i := 0 to f.Beds.Count - 1 do
    if  (Beds.GetBedBySimpleBedID(f.Beds.Items[i].ID) = nil) then
    begin
      b := Beds.Add as TGRRDocumentBed;
      b.Bed := f.Beds.Items[i];
      b.BedType := f.Beds.Items[i].FieldType;
      b.Name := f.Beds.Items[i].Name;
    end;
  end;
end;

{ TGRRDocumentFields }

constructor TGRRDocumentFields.Create;
begin
  inherited;
  FObjectClass := TGRRDocumentField;
end;

function TGRRDocumentFields.GetItems(Index: integer): TGRRDocumentField;
begin
  Result := Inherited Items[Index] as TGRRDocumentField;
end;

{ TGRRReservesRecountDocument }

constructor TGRRReservesRecountDocument.Create(ACollection: TIDObjects);
begin
  inherited;
  FFields := nil;
end;

destructor TGRRReservesRecountDocument.Destroy;
begin
  FreeAndNil(FFields);
  inherited;
end;

function TGRRReservesRecountDocument.GetFields: TGRRDocumentFields;
begin
  if not Assigned(FFields) then
  begin
    FFields := TGRRDocumentFields.Create;
    FFields.OwnsObjects := true;
    FFields.Owner := Self;
    FFields.Reload('GRRSEISMIC_REPORT_ID = ' + IntToStr(ID), false);
  end;
  Result := FFields;
end;

{ TGRRReservesRecountDocuments }

constructor TGRRReservesRecountDocuments.Create;
begin
  inherited;
  FObjectClass := TGRRReservesRecountDocument;
end;

function TGRRReservesRecountDocuments.GetItems(
  Index: integer): TGRRReservesRecountDocument;
begin
  Result := inherited Items[index] as TGRRReservesRecountDocument;
end;

procedure TGRRReservesRecountDocuments.Reload;
var sSeismicReportsID: string;
begin
  Assert(TMainFacade.GetInstance.ActiveVersion <> nil, 'Не задана текущая версия данных');
  inherited;
  sSeismicreportsID := IntToStr(SEISMIC_REPORT_TYPE_REWORK) + ',' + IntToStr(SEISMIC_REPORT_TYPE_2D) + ',' + IntToStr(SEISMIC_REPORT_TYPE_3D);
  Reload('(License_Zone_ID = ' + IntToStr(Owner.ID) + ') and (Version_Id = '+ IntToStr(TMainFacade.GetInstance.ActiveVersion.ID) + ') and (Seismic_Report_Type_Id in ('+sSeismicreportsID+'))');
end;

{ TGRRDocumentBed }

procedure TGRRDocumentBed.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TGRRDocumentBed).Bed := Bed;
  (Dest as TGRRDocumentBed).BedType := BedType;
end;

constructor TGRRDocumentBed.Create(ACollection: TIDObjects);
begin
  inherited;
  FClassIDString := 'Залежь';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGRRDocumentBedDataPoster];
  Name := '';
end;

function TGRRDocumentBed.GetField: TGRRDocumentField;
begin
  Result := (Collection.Owner as TGRRDocumentField);
end;

function TGRRDocumentBed.GetGRRParameterValues: TGRRParameterValues;
begin
  if not Assigned(FGRRParameterValues) then
  begin
    FGRRParameterValues := TBedGRRParameterValues.Create;
    FGRRParameterValues.Owner := Self;
    FGRRParameterValues.Reload('GRR_WELL_INTERVAL_ID = ' + IntToStr(ID), False);
  end;

  Result := FGRRParameterValues;
end;

{ TGRRDocumentBeds }

constructor TGRRDocumentBeds.Create;
begin
  inherited;
  FObjectClass := TGRRDocumentBed;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGRRDocumentBedDataPoster];
end;

function TGRRDocumentBeds.GetBedBySimpleBedID(
  ABedID: integer): TGRRDocumentBed;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Assigned(Items[i].Bed) and (Items[i].Bed.ID = ABedID) then
  begin
    Result := Items[i];
    break;
  end;
end;

function TGRRDocumentBeds.GetItems(Index: integer): TGRRDocumentBed;
begin
  Result := inherited Items[Index] as TGRRDocumentBed;
end;

{ TBedGRRParameterValues }

constructor TBedGRRParameterValues.Create;
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TBedGRRParameterDataPoster];
  FObjectClass :=  TBedGRRParameterValue;
end;

function TBedGRRParameterValues.GetBed: TGRRDocumentBed;
begin
  Result := Owner as TGRRDocumentBed;
end;

{ TBedGRRParameterValue }

constructor TBedGRRParameterValue.Create(ACollection: TIDObjects);
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TBedGRRParameterDataPoster];
end;

{ TOilShowingType }

constructor TOilShowingType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'тип нефтегазопроявления';
  FDataPoster := (TMainFacade.GetInstance as TMainFacade).DataPosterByClassType[TOilShowingDataPoster];
end;

{ TOilShowingTypes }

constructor TOilShowingTypes.Create;
begin
  inherited;
  FObjectClass := TOilShowingType;
  FDataPoster := (TMainFacade.GetInstance as TMainFacade).DataPosterByClassType[TOilShowingDataPoster];
end;

function TOilShowingTypes.GetItems(Index: integer): TOilShowingType;
begin
  Result := inherited Items[Index] as TOilShowingType;
end;

{ TWellIntervalsByType }

procedure TWellIntervalsByType.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TWellIntervalsByType).WellIntervalType := WellIntervalType;
  (Dest as TWellIntervalsByType).FWellIntervals := FWellIntervals;
end;

constructor TWellIntervalsByType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Выборка интервалов по типу';
end;

destructor TWellIntervalsByType.Destroy;
begin
  FreeAndNil(FWellIntervals);
  inherited;
end;

function TWellIntervalsByType.GetWellIntervals: TGRRWellIntervals;
begin
  if not Assigned(FWellIntervals) then
  begin
    FWellIntervals := TGRRWellIntervals.Create;
    FWellIntervals.Owner := (Self.Collection.Owner as TLicenseZoneWellGRRParameterValueSet).Well;
    FWellIntervals.OwnsObjects := True;
    FWellIntervals.Reload('Well_UIN = ' + IntToStr(FWellIntervals.Owner.ID) + ' and GRRInterval_Type_ID = ' + IntToStr(WellIntervalType.ID));
  end;
  Result := FWellIntervals;
end;

{ TWellIntervalsByTypeList }

function TWellIntervalsByTypeList.AddWellIntervalsByType(
  AWellIntervalType: TGRRWellIntervalType): TWellIntervalsByType;
begin
  Result := GetWellIntervalByType(AWellIntervalType);

  if not Assigned(Result) then
  begin
    Result := TWellIntervalsByType.Create(Self);
    Add(Result, false, false);
    Result.WellIntervalType := AWellIntervalType;
  end;
end;

constructor TWellIntervalsByTypeList.Create;
begin
  inherited;
  FObjectClass := TWellIntervalsByType;
  FDataPoster := nil;
end;

function TWellIntervalsByTypeList.GetItems(
  Index: integer): TWellIntervalsByType;
begin
  Result := inherited Items[Index] as TWellIntervalsByType;
end;

function TWellIntervalsByTypeList.GetIntervalsByType(
  AWellIntervalType: TGRRWellIntervalType): TGRRWellIntervals;
var o: TWellIntervalsByType;
begin
  Result := nil;
  o := GetWellIntervalByType(AWellIntervalType);
  if Assigned(o) then Result := o.WellIntervals; 
end;

function TWellIntervalsByTypeList.GetWellIntervalByType(
  AWellIntervalType: TGRRWellIntervalType): TWellIntervalsByType;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].WellIntervalType = AWellIntervalType then
  begin
    Result := Items[i];
    break;
  end;
end;

procedure TWellIntervalsByTypeList.Reload;
begin
  inherited;

end;

function TLicenseZoneWellGRRParameterValueSet.GetWellIntervslByType(
  WellIntervalType: TGRRWellIntervalType): TGRRWellIntervals;
var o: TWellIntervalsByType;
begin
  o := FWellIntervalByTypeList.AddWellIntervalsByType(WellIntervalType);
  if Assigned(o) then
    Result := o.WellIntervals
  else Result := nil;
end;

{ TOrganizationGRRParameterValues }

constructor TOrganizationGRRParameterValues.Create;
begin
  inherited;
  FObjectClass := TOrganizationGRRParameterValue;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TOrganizationGRRParameterValueDataPoster];
end;

function TOrganizationGRRParameterValues.GetItems(
  Index: integer): TOrganizationGRRParameterValue;
begin
  Result := inherited Items[index] as TOrganizationGRRParameterValue
end;

{ TOrganizationGRRParameterValue }

constructor TOrganizationGRRParameterValue.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Параметры ГРР по организации';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TOrganizationGRRParameterValueDataPoster];
end;

{ TSumByOrgGRRParameterValue }

constructor TSumByOrgGRRParameterValue.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Суммарные показатели параметров ГРР по организации';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSumByOrgGRRParameterValueDataPoster];
end;

{ TSumByOrgGRRParameterValues }

constructor TSumByOrgGRRParameterValues.Create;
begin
  inherited;
  FObjectClass := TSumByOrgGRRParameterValue;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSumByOrgGRRParameterValueDataPoster];
end;

function TSumByOrgGRRParameterValues.GetItems(
  Index: integer): TSumByOrgGRRParameterValue;
begin
  Result := inherited Items [Index] as TSumByOrgGRRParameterValue;
end;

function TSumByOrgGRRParameterValues.GetItemsByOrganizationID(
  Index: integer): TSumByOrgGRRParameterValue;
var i: Integer;
begin
  Result := nil;

  for i := 0 to Count - 1 do
  if Items[i].Organization.ID = Index then
  begin
    Result := Items[i];
    Break;
  end;
end;

{ TGRRStateChangeType }

constructor TGRRStateChangeType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'изменение состояния объекта ГРР';
  FDataPoster := (TMainFacade.GetInstance as TMainFacade).DataPosterByClassType[TGRRStateChangeTypeDataPoster];
end;

{ TGRRStateChangeTypes }

constructor TGRRStateChangeTypes.Create;
begin
  inherited;
  FObjectClass := TGRRStateChangeType;
  FDataPoster := (TMainFacade.GetInstance as TMainFacade).DataPosterByClassType[TGRRStateChangeTypeDataPoster];
end;

function TGRRStateChangeTypes.GetItems(
  Index: integer): TGRRStateChangeType;
begin
  Result := inherited Items[index] as TGRRStateChangeType;
end;

{ TGRRStateChange }

procedure TGRRStateChange.AssignTo(Dest: TPersistent);
var s: TGRRStateChange;
begin
  inherited;
  s := Dest as TGRRStateChange;
  s.StateChangeType := StateChangeType;
  s.ParamGroup := ParamGroup;
end;

constructor TGRRStateChange.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'изменение состояния объекта ГРР';
  FDataPoster := (TMainFacade.GetInstance as TMainFacade).DataPosterByClassType[TGRRStateChangeDataPoster];
end;

{ TGRRStateChanges }

constructor TGRRStateChanges.Create;
begin
  inherited;
  FObjectClass := TGRRStateChange;
  FDataPoster := (TMainFacade.GetInstance as TMainFacade).DataPosterByClassType[TGRRStateChangeDataPoster];
end;

function TGRRStateChanges.GetItems(Index: integer): TGRRStateChange;
begin
  Result := inherited Items[Index] as TGRRStateChange;
end;

end.
