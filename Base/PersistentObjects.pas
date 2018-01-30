unit PersistentObjects;

interface

uses DB, Classes, ADODB, SysUtils,
     Variants, ADOInt, ActiveX,
     Windows, Contnrs, Dialogs,
     Controls;

type

  TCommonServerDataSet = class;
  TDistinctDataSet = class;
  TCommonServerDataSets = class;
  TCSServerDataSets = class;

  TCommonDataSetFacade = class;
  TCommonServerDataSetClass = class of TCommonServerDataSet;
  TListParamAdditions = class;

//  TExtensibleDataSet = class;

  TFilter = class;
  TFilters = class;

  TCSDataSetOption = (soSingleDataSource, soKeyInsert, soPartialFilling, soNoInsert, soNoUpdate, soNoDelete, soGetKeyValue);
  TCSDataSetOptions = set of TCSDataSetOption;
  TMassUpdateKind = (mukValue, mukField);

  TSourceType = (stTable, stProc, stView, stNone);

  PRecInfo = ^TRecInfo;
  TRecInfo = packed record
    Bookmark: OleVariant;
    BookmarkFlag: TBookmarkFlag;
    RecordStatus: Integer;
    RecordNumber: Integer;
  end;

  TCompareOperationType = (cotFilterValue, cotFilter);
  TCompareOperationTypes = set of TCompareOperationType;

  TCompareOperation = class
  private
    FOperationName: string;
    FOperation: string;
    FCompareOperationType: TCompareOperationType;
  public
    property Operation: string read FOperation;
    property OperationName: string read FOperationName;
    property OperationType: TCompareOperationType read FCompareOperationType;
    constructor Create; virtual;
  end;



  TFilter = class
  private
    FOperation: TCompareOperation;
    FFilterValue: variant;
    FFilters: TFilters;
    function GetStringValue: string;
    procedure SetFilterValue(const Value: variant);
  public
    property FilterValue: variant read FFilterValue write SetFilterValue;
    property StringValue: string read GetStringValue;
    property Operation: TCompareOperation read FOperation write FOperation;
    property Owner: TFilters read FFilters;
  end;

  TFilters = class(TObjectList)
  private
    FCommonOperation: TCompareOperation;
    FField: TField;
    function GetItems(const Index: integer): TFilter;
  public
    property Items[const Index: integer]: TFilter read GetItems;
    property CommonOperation: TCompareOperation read FCommonOperation write FCommonOperation;
    function Add: TFilter;
    property Field: TField read FField;

    constructor Create(AField: TField);
    destructor  Destroy; override;
  end;

  TFilterField = class
  private
    FField: TField;
    FFilters: TFilters;
    FAppendingOperation: TCompareOperation;
    function GetAppliedFilter: string;
  public
    property Field: TField read FField;
    property Filters: TFilters read FFilters;

    property AppliedFilter: string read GetAppliedFilter;
    // операция с которой объединяются поля
    property AppendingOperation: TCompareOperation read FAppendingOperation write FAppendingOperation;
    constructor Create(AField: TField);
    destructor  Destroy; override;
  end;

  TFilterFields = class(TObjectList)
  private
    FAppendingOperation: TCompareOperation;
    function GetItems(Index: integer): TFilterField;
    function GetAppliedFilter: string;
    function GetFilterFieldsByFieldName(
      const AFieldName: string): TFilterField;
  public
    property Items[Index: integer]: TFilterField read GetItems;
    property FilterFieldsByFieldName[const AFieldName: string]: TFilterField read GetFilterFieldsByFieldName;

    function Add(AField: TField): TFilterField;

    property AppendingOperation: TCompareOperation read FAppendingOperation write FAppendingOperation;
    property AppliedFilter: string read GetAppliedFilter;
    procedure ClearFilters;

    constructor Create(ADataSet: TCommonServerDataSet);
    destructor Destroy; override;
  end;

  TSortOrder = (srtNone, srtAsc, srtDesc);

  TSortField = class
  private
    FSortOrder: TSortOrder;
    FFieldName: string;
    FName: string;
    procedure SetSortOrder(const Value: TSortOrder);
    function  GetSortString(Full: boolean): string;
  public
    property FieldName: string read FFieldName;
    property Name: string read FName;
    property SortOrder: TSortOrder read FSortOrder write SetSortOrder;
    property SortString[Full: boolean]: string read GetSortString;
    constructor Create(AField: TField);
  end;

  TSortFields = class(TObjectList)
  private
    FOwner: TDataSet;
    function GetFieldByName(AFieldName: string): TSortField;
    function GetItems(Index: integer): TSortField;
    function GetSort(Full: boolean): string;
  public
    property Items[Index: integer]: TSortField read GetItems;
    property FieldByName[AFieldName: string]: TSortField read GetFieldByName;
    property SortString[Full: boolean]: string read GetSort;
    property Owner: TDataSet read FOwner;
    procedure Reload;
    constructor Create(AOwner: TDataSet);
  end;

  TCommonServerFieldList = class(TObjectList)
  private
    FDataSet: TDataSet;
    function GetItems(Index: integer): TField;
  public
    property DataSet: TDataSet read FDataSet;
    property Items[Index: integer]: TField read GetItems;
    function Add(AFieldName: string): TField;
    function FieldByName(AFieldName: string): TField; 
    constructor Create(ADataSet: TDataSet);
  end;

  TBookmarks = class(TList)
  private
    FDataSet: TDataSet;
    function GetItems(Index: integer): TBookmark;
  public
    property DataSet: TDataSet read FDataSet;
    property Items[Index: integer]: TBookmark read GetItems;
    function Add(ABookmark: TBookmark): integer;
    function MakeFilter: string;
    procedure Clear; override;
    constructor Create(ADataset: TDataSet);
    destructor  Destroy; override;
  end;

  TCommonServerDataSet = class(TDataSet)
  private
    FCacheSize: integer;
    FRusName: string;
    FDataSourceName: string;
    FOptions: TCSDataSetOptions;
    FServer: OleVariant;
    FLastErrorCode: integer;
    FStoreDefs: Boolean;
    FMasterDataLink: TMasterDataLink;
    FRecordSet: OleVariant;
    FRecBufSize: Integer;
    FLockCursor,FFindCursor, FLookupCursor: OleVariant;
    FFilterBuffer: PChar;
    FModifiedFields: TList;
    FFilterGroup: TFilterGroup;
    FMaxRecords: integer;
    FKeyFieldNames: string;
    FDataDeletionString, FDataPostString: string;
    FFieldNames: string;
    FDataSetRusName: string;
    FDataSetIdent: string;
    FFilterFields: TFilterFields;
    FbaseFilter: string;
    FAccessoryFields: string;
    FGeneralRecordCount: integer;
    FPartSize: integer;
    FRecordsLoaded: integer;
    FFilterChanged: boolean;
    FSort: string;
    FTableID: integer;
    FFieldIDs: TList;
    FDistinctDataSets: TCSServerDataSets;
    FSortFields: TSortFields;
    FUpdatableFieldNames: string;
    FFetchedByQuery: TBookmarks;
    FAutoFillDates: boolean;
    FAutoRefresh: boolean;
    FRefreshKeys: string;
    FRefreshValues: variant;
    FLastResult: integer;
    function  GetCacheSize: Integer;
    procedure SetCacheSize(const Value: Integer);
    function  GetFilterGroup: TFilterGroup;
    function  GetRecordsetState: TObjectStates;
    function  GetRecordStatus: TRecordStatusSet;
    function  GetSort: WideString;
    procedure SetFilterGroup(const Value: TFilterGroup);
    procedure SetRecordset(const Value: OleVariant);
    procedure SetSort(const Value: WideString);
    function  GetMaxRecords: Integer;
    procedure SetMaxRecords(const Value: Integer);
    function  GetCurrentRecordFilter: string;
    function  GetCurrentRecordFilterValues: variant;
    function  GetCurrentRecordFilterNames: variant;
    function  GetCurrentRecordNames: variant;
    function  GetCurrentRecordValues: variant;
    procedure SetCurrentRecordRecordFilterValues(const Value: variant);
    procedure SetCommonSource(ASourceName: string);
    procedure SetDataDeletionString(const Value: string);
    procedure SetDataPostString(const Value: string);
    procedure SetDataSourceName(const Value: string);
    function  getTestBOF: integer;
    function  getTestEOF: integer;
    function  MakeHeader: integer; virtual;
    procedure SetBaseFilter(const Value: string);
    function  GetCurrentPage: integer;
    function  GetPageCount: integer;
    procedure GetGeneralRecordCount;
    function  GetTableID: integer;
    function  GetFieldIDs(const Index: integer): integer;
    function  GetDistinctDataSets(AFieldName: string): TDistinctDataSet;
    procedure SetServer(const Value: OleVariant);
    function  GetSortFields(AFieldName: string): TSortField;
    function  GetSortFieldsSortString(Full: boolean): string;
    function  GetCurrentRecordUpdatableValues: variant;
    procedure SetCurrentRecordUpdatableValues(Value: variant);
    function  GetCurrentRecordUpdatebleNames: variant;
    function  GetCurrentRecordUserFilter(Columns: string): string;
    function  GetCurrentRecordUserFilterValues(Columns: string): variant;
    function  GetDataSetClass: TCommonServerDataSetClass;
  protected
    function  GetSelectQuery(const AFilter: string = ''): string; virtual;
    procedure DoGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure DataEvent(Event: TDataEvent; Info: Longint); override;
    function  GetCurrentRecordModifiedNames: OleVariant; virtual;
    function  GetCurrentRecordModifiedValues: OleVariant; virtual;
    function  GetLeadingSelectQuery: string; virtual;
  protected
    procedure CreateFields; override;
    function  DoBeforeAutoRefresh: boolean; virtual;
    procedure DoAutoRefresh; virtual;

    procedure CloseCursor; override;
    procedure DoBeforeScroll; override;
    procedure DoAfterScroll; override;
    procedure DoAfterOpen; override;
    procedure DoOnNewRecord; override;
    procedure ActivateTextFilter(const FilterText: string);
    function  AllocRecordBuffer: PChar; override;
    procedure CheckFieldCompatibility(Field: TField; FieldDef: TFieldDef); override;
    procedure CheckInactive; override;
    procedure ClearCalcFields(Buffer: PChar); override;
    procedure DeactivateFilters;
    procedure DestroyLookupCursor; virtual;
    function  FindRecord(Restart, GoForward: Boolean): Boolean; override;
    procedure FreeRecordBuffer(var Buffer: PChar); override;
    function GetActiveRecBuf(var RecBuf: PChar): Boolean;
    procedure GetBookmarkData(Buffer: PChar; Data: Pointer); override;
    function GetBookmarkFlag(Buffer: PChar): TBookmarkFlag; override;
    function GetCanModify: Boolean; override;
    function GetDataSource: TDataSource; override;
    function GetRecNo: Integer; override;
    function GetRecord(Buffer: PChar; GetMode: TGetMode; DoCheck: Boolean): TGetResult; override;
    function GetRecordCount: Integer; override;
    function GetRecordSize: Word; override;
    function GetStateFieldValue(State: TDataSetState; Field: TField): Variant; override;
    procedure InternalAddRecord(Buffer: Pointer; Append: Boolean); override;
    procedure InternalCancel; override;
    procedure InternalClose; override;
    procedure InternalDelete; override;
    procedure InternalEdit; override;
    procedure InternalFirst; override;
    function  InternalGetRecord(Buffer: PChar; GetMode: TGetMode; DoCheck: Boolean): TGetResult;
    procedure InternalGotoBookmark(Bookmark: Pointer); override;
    procedure InternalHandleException; override;
    procedure InternalInitFieldDefs; override;
    procedure InternalInitRecord(Buffer: PChar); override;
    procedure InternalInsert; override;
    procedure InternalLast; override;
    procedure InternalOpen; override;
    procedure InternalPost; override;
    procedure InternalRefresh; override;
    procedure InternalRequery(Options: TExecuteOptions = []); virtual;
    procedure InternalSetSort(Value: WideString);
    procedure InternalSetToRecord(Buffer: PChar); override;
    function  IsCursorOpen: Boolean; override;
    procedure Loaded; override;
    function  LocateRecord(const KeyFields: string; const KeyValues: OleVariant;
      Options: TLocateOptions; SyncCursor: Boolean): Boolean;
    procedure OpenCursor(InfoQuery: Boolean); override;
    procedure ReleaseLock;
    procedure SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag); override;
    procedure SetBookmarkData(Buffer: PChar; Data: Pointer); override;
    procedure SetFieldData(Field: TField; Buffer: Pointer); override;
    procedure SetFieldData(Field: TField; Buffer: Pointer; NativeFormat: Boolean); override;
    procedure SetFiltered(Value: Boolean); override;
    procedure SetFilterOptions(Value: TFilterOptions); override;
    procedure SetFilterText(const Value: string); override;
    procedure SetRecNo(Value: Integer); override;
    procedure UpdateRecordSetPosition(Buffer: PChar);
    property  MasterDataLink: TMasterDataLink read FMasterDataLink;
    property  FieldDefs stored FStoreDefs;
    property  StoreDefs: Boolean read FStoreDefs write FStoreDefs default False;
  public
    property    LastErrorCode: integer read FLastErrorCode write FLastErrorCode;
    procedure   FetchNext;
    procedure   FetchByQuery(AFilter: string);
    property    LastResult: integer read FLastResult write FLastResult;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    function    GetFieldName: string;
    function    AddNewField(AFieldClass: TFieldClass): TField;
    function    BookmarkValid(Bookmark: TBookmark): Boolean; override;
    procedure   CancelBatch(AffectRecords: TAffectRecords = arAll);
    procedure   CancelUpdates;
    function    CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer; override;
    procedure   DeleteRecords(AffectRecords: TAffectRecords = arAll);
    procedure   FilterOnBookmarks(Bookmarks: array of const);
    function    GetFieldData(Field: TField; Buffer: Pointer): Boolean; override;
    function    GetFieldData(Field: TField; Buffer: Pointer; NativeFormat: Boolean): Boolean; override;
    function    GetFieldData(FieldNo: Integer; Buffer: Pointer): Boolean; overload; override;
    function    IsSequenced: Boolean; override;
    function    Locate(const KeyFields: string; const KeyValues: Variant;
      Options: TLocateOptions): Boolean; override;
    function    Lookup(const KeyFields: string; const KeyValues: Variant;
      const ResultFields: string): Variant; override;
    procedure   Requery(Options: TExecuteOptions = []);
    function    Seek(const KeyValues: Variant; SeekOption: TSeekOption = soFirstEQ): Boolean;
    function    Supports(CursorOptions: TCursorOptions): Boolean;
    procedure   UpdateBatch(AffectRecords: TAffectRecords = arAll);
    function    UpdateStatus: TUpdateStatus; override;
    procedure   ExecProc;
    property    FilterGroup: TFilterGroup read GetFilterGroup write SetFilterGroup;
    property    Recordset: OleVariant read FRecordset write SetRecordset;
    property    RecordsetState: TObjectStates read GetRecordsetState;
    property    RecordStatus: TRecordStatusSet read GetRecordStatus;
    property    Sort: WideString read GetSort write SetSort;

    procedure   Insert;
    procedure   Delete;
    procedure   Post; override;

    procedure   ApplyFilter; virtual;
    // идентификаторы атрибутов
    property    FieldIDs[const Index: integer]: integer read GetFieldIDs;

    property    CurrentRecordUserFilter[Columns: string]: string read GetCurrentRecordUserFilter;
    property    CurrentRecordUserFilterValues[Columns: string]: variant read GetCurrentRecordUserFilterValues;

    // вспомогательные датасеты - такие типа справочники на лету
    property    DistinctDataSets[AFieldName: string]: TDistinctDataSet read GetDistinctDataSets;
    // поля с скортировкой
    property    SortFields[AFieldName: string]: TSortField read GetSortFields;
    property    SortFieldsSortString[Full: boolean]: string read GetSortFieldsSortString;
    // SQL-запрос формирующийся в соответствии с содержимым загруженного датасета
    // для отчётов, поскольку проходить по датасету от начала до конца и выгружать записи сильно напряжно
    property    LeadingSelectQuery: string read GetLeadingSelectQuery;
    function    GetLeadingSelectResult(NeedInversion: boolean): OleVariant;
    // обновить поля
    procedure   UpdateFields(UpdatableFields: string; AColumns: string; AFilterValues: variant);
    // запрос
    property    SelectQuery[const AFilter: string = '']: string read getSelectQuery;
    // класс датасета
    property    DataSetClass: TCommonServerDataSetClass read GetDataSetClass;
    function    Clone: TCommonServerDataSet;
    function    TestQuery: integer;
  published
    // название источника данных - запрос или таблица
    property    DataSourceString: string read FDataSourceName write SetDataSourceName;
    // название процедуры/таблицы откуда будут удаляться данные
    property    DataDeletionString: string read FDataDeletionString write SetDataDeletionString;
    // название таблицы/процедуры посредством которой будут вставляться/удаляться данные
    property    DataPostString: string read FDataPostString write SetDataPostString;
    // идентификатор таблицы в tbl_Table
    property    TableID: integer read GetTableID;
    // фильтр
    property    BaseFilter: string read FbaseFilter write SetBaseFilter;
    // флаг смены фильтра
    property    FilterChanged: boolean read FFilterChanged;

    // наименование датасета - русское
    property    DatasetRusName: string read FDataSetRusName write FDataSetRusName;
    // идентификатор датасета
    property    DatasetIdent: string read FDataSetIdent write FDataSetIdent;

    // вспомогательные поля, которые не учитываются при редактировании
    property    AccessoryFields: string read FAccessoryFields write FAccessoryFields;

    // автозаполнение дат
    property    AutoFillDates: boolean read FAutoFillDates write FAutoFillDates;
    // автообновление по фильтру
    property    AutoRefresh: boolean read FAutoRefresh write FAutoRefresh;
    property    RefreshKeys: string read FRefreshKeys write FRefreshKeys;
    property    RefreshValues: variant read FRefreshValues write FRefreshValues;

    // свойство-коллекция, определяющая поведение столбцов
    property FilterFields: TFilterFields read FFilterFields;
    property TestEOF: integer read getTestEOF;
    property TestBOF: integer read getTestBOF;


    function    GetSourceType(const ASourceName: string): TSourceType;
    // названия ключевых полей
    property    KeyFieldNames: string read FKeyFieldNames write FkeyFieldNames;
    // названия полей подлежащих обновлению после постинга
    property    UpdatableFieldNames: string read FUpdatableFieldNames write FUpdatableFieldNames;
    // названия запрашиваемых полей
    property    FieldNames: string read FFieldNames write FFieldNames;
    // фильтр текущей записи
    property    CurrentRecordFilter: string read GetCurrentRecordFilter;
    property    CurrentRecordFilterValues: variant read GetCurrentRecordFilterValues write SetCurrentRecordRecordFilterValues;
    property    CurrentRecordFilterNames: variant read GetCurrentRecordFilterNames;

    property    CurrentRecordUpdatableValues: variant read GetCurrentRecordUpdatableValues write SetCurrentRecordUpdatableValues;
    property    CurrentRecordUpdatebleNames: variant read GetCurrentRecordUpdatebleNames;

    property    CurrentRecordValues: variant read GetCurrentRecordValues;
    property    CurrentRecordNames: variant read GetCurrentRecordNames;
    property    CurrentRecordModifiedValues: OleVariant read GetCurrentRecordModifiedValues;
    property    CurrentRecordModifiedNames: OleVariant read GetCurrentRecordModifiedNames;

    // русское название схемы
    property    RusName: string read FRusName write FRusName;
    // свойства - всякие флаги
    property    Options: TCSDataSetOptions read FOptions write FOptions;
    // непосредственно сервер, который будет выполнять операции
    property    Server: OleVariant read FServer write SetServer;

    // метод копирования некоторых полей одного датасета - в другой
    function    CopyRecord(Dest: TCommonServerDataSet; CopyFields: string): integer;
    // копирование нескольких сразу - для этого передаём лист букмарков
    function    CopyRecords(Dest: TCommonServerDataSet; Bookmarks: TObject; CopyFields: string; MasterFields: string; MasterFieldValues: Variant; SourceUpdatableFields, DestUpdatableFields: string): integer;
    // скидываем набор данных в простой список
    procedure   MakeList(ALst: TStringList; AKeyFieldName, AListFieldName: string);
    // массовое обновление
    function  MassUpdate(AFieldName: string; AValue: string; UpdateKind: TMassUpdateKind): integer; virtual;



    // при частичной загрузке нужно знать
    // общее количество строк, которое можно загрузить
    // размер страницы и на какой странице находимся
    // при пересортировке - нужно бы восстанавливать положение в той строке
    // на которой находимся, но это сложновато пока, поэтому
    // скорее всего получится восстанавливать страницу

    // размер страницы - задаётся пользователем
    // учитывается только при выставленной опции soPartialFilling
    property PageSize: integer read FPartSize write FPartSize;
    // общее количество строк, которое есть в таблице (по данному запросу)
    property GeneralRecordCount: integer read FGeneralRecordCount write FGeneralRecordCount;
    // загруженное количество строк. просто RecordCount воспользоваться не получится, поскольку
    // при смене фильтра - это число должно сбрасываться, а RecordCount - оставаться прежним
    property RecordsLoaded: integer read FRecordsLoaded write FRecordsLoaded;


    // текущая страница - высчитывается, исходя из строки на которой находимся и количества загруженных строк
    property CurrentPage: integer read GetCurrentPage;
    // общее количество страниц - высчитывается, исходя из общего количества строк и размера страницы в строках
    property PageCount: integer read GetPageCount;

    // сохраняем записи в текстовый файл с разделителями
    procedure SaveToFile(AFileName: string; ADelimiter: string; AFields: string); virtual;
    // загружаем записи из текстового файла с разделителями
    procedure LoadFromFile(AFileName: string; ADelimiter: string; AFields: string); virtual;
  published
    property Active default true;
    property AutoCalcFields;
    property CacheSize: Integer read GetCacheSize write SetCacheSize default 1;
    property Filter;
    property Filtered;
    property MaxRecords: Integer read GetMaxRecords write SetMaxRecords default 0;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property BeforeRefresh;
    property AfterRefresh;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnFilterRecord;
    property OnNewRecord;
    property OnPostError;
  end;



  TDistinctDataSet = class(TCommonServerDataSet)
  protected
    function GetCanModify: Boolean; override;
    function GetSelectQuery(const AFilter: string = ''): string; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  // датасет с частичной загрузкой - надо будет доделать
  TPartialLoadingDataSet = class(TCommonServerDataSet)
  private
    FRecordsToLoad: integer;
    FRecordsLoaded: integer;
  protected
    function  GetSelectQuery(const AFilter: string = ''): string; override;
    procedure OpenCursor(InfoQuery: Boolean); override;
  public
    // по скольку грузить
    property    RecordsToLoad: integer read FrecordsToLoad write FRecordsToLoad;
    // сколько загружено
    property    RecordsLoaded: integer read FRecordsLoaded write FRecordsLoaded;
  end;



  TExtensionParam = class(TParam)
  private
    FDisplayName: string;
  protected
    function GetDisplayName: string; override;
    procedure SetDisplayName(const Value: string); override;
  end;

  TExtensionParams = class(TParams)
  public
    constructor Create;
  end;



  TListParamAddition = class
  private
    FListFilter: string;
    FListtableName: string;
    FListColumns: string;
    FListOrder: string;
    FParamName: string;
    FStrings: TStringList;
    FOwner: TListParamAdditions;
    FCommonServerDataSet: TCommonServerDataSet;
  public
    property ParamName: string read FParamName;
    property ListTableName: string read FListtableName;
    property ListColumns: string read FListColumns;
    property ListFilter: string read FListFilter;
    property ListOrder: string read FListOrder;

    property DataSet: TCommonServerDataSet read FCommonServerDataSet;


    property Owner: TListParamAdditions read FOwner;

    destructor  Destroy; override;
    constructor Create(AOwner: TListParamAdditions;
                       ADataSet: TCommonServerDataSet;
                       AParamName, AListColumns, AListFilter, AListOrder: string);
  end;


  TListParamAdditions = class(TObjectList)
  private
    function GetItems(const Index: integer): TListParamAddition;
    function GetParamByName(const ParamName: string): TListParamAddition;
  public
    property Items[const Index: integer]: TListParamAddition read GetItems;
    property ItemsByParamName[const ParamName: string]: TListParamAddition read GetParamByName;

    function Add(ADataSet: TCommonServerDataSet; AParamName, AListColumns, AListFilter, AListOrder: string): TListParamAddition;

    constructor Create;
    destructor Destroy; override;



  end;

  TCommonServerDatasets = class(TObjectList)
  private
    FOwner: TComponent;
    function GetDatasetByRusName(
      const ARusName: string): TCommonServerDataSet;
    function GetDatasetBySourceName(
      const ASourceName: string): TCommonServerDataSet;
    function GetItems(const Index: integer): TCommonServerDataSet;
    function GetDatasetByIdent(const AIdent: string): TCommonServerDataSet;
    function GetDatasetByClassType(
      const AClassType: TCommonServerDataSetClass): TCommonServerDataSet;
    function GetServer: Variant;
  protected
    FServer: Variant;  
    function InternalGetServer: variant; virtual;
  public
    property Items[const Index: integer]: TCommonServerDataSet read GetItems;
    property DatasetBySourceName[const ASourceName: string]: TCommonServerDataSet read GetDatasetBySourceName;
    property DataSetByRusName[const ARusName: string]: TCommonServerDataSet read GetDatasetByRusName;
    property DataSetByIdent[const AIdent: string]: TCommonServerDataSet read GetDatasetByIdent;
    property DataSetByClassType[const AClassType: TCommonServerDataSetClass]: TCommonServerDataSet read GetDatasetByClassType;

    function Add(ADataSet: TCommonServerDataSet): TCommonServerDataSet; overload;
    function Add(ADataSetClass: TCommonServerDataSetClass): TCommonServerDataSet; overload;

    property Owner: TComponent read FOwner;

    // откуда выспрашивать
    property Server: Variant read GetServer;
    // всевозможные расширения датасетов
    constructor Create(AOwner: TComponent); virtual;
    destructor  Destroy; override;
  end;

  TCommonDataSetFacade = class(TCommonServerDataSets)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TCSServerDataSets = class(TCommonServerDataSets)
  protected
    FServer: variant;
    function InternalGetServer: variant; override;
  end;


const
  sExtensionPrefix = 'ex';
  sFormulaPrefix = 'fld';

implementation

uses Forms, DBGrids, ClientCommon, StringUtils;

type TStringArray = array of string;

const   bfNA = TBookmarkFlag(Ord(High(TBookmarkFlag)) + 1);

var

  ExecuteOptionValues: array[TExecuteOption] of TOleEnum = (adAsyncExecute,
    adAsyncFetch, adAsyncFetchNonBlocking, adExecuteNoRecords);

  FilterGroupValues: array[TFilterGroup] of TOleEnum = ($FFFFFFFF {Unassigned},
    adFilterNone, adFilterPendingRecords, adFilterAffectedRecords,
    adFilterFetchedRecords, adFilterPredicate, adFilterConflictingRecords);

  AffectRecordsValues: array[TAffectRecords] of TOleEnum =
    (adAffectCurrent, adAffectGroup, adAffectAll, adAffectAllChapters);

  SeekOptionValues: array[TSeekOption] of TOleEnum = (adSeekFirstEQ,
    adSeekLastEQ, adSeekAfterEQ, adSeekAfter, adSeekBeforeEQ, adSeekBefore);

  CursorOptionValues: array[TCursorOption] of TOleEnum = (adHoldRecords,
    adMovePrevious, adAddNew, adDelete, adUpdate, adBookmark, adApproxPosition,
    adUpdateBatch, adResync, adNotify, adFind, adSeek, adIndex);

  RecordStatusValues: array[TRecordStatus] of TOleEnum = (adRecOK, adRecNew,
    adRecModified, adRecDeleted, adRecUnmodified, adRecInvalid,
    adRecMultipleChanges, adRecPendingChanges, adRecCanceled, adRecCantRelease,
    adRecConcurrencyViolation, adRecIntegrityViolation,adRecMaxChangesExceeded,
    adRecObjectOpen, adRecOutOfMemory, adRecPermissionDenied,
    adRecSchemaViolation, adRecDBDeleted);

  ObjectStateValues: array[TObjectState] of TOleEnum = (adStateClosed,
    adStateOpen, adStateConnecting, adStateExecuting, adStateFetching);



function MakeFilter(FieldNames: string; FieldValues: variant): string;
var vFieldNames, vFieldValues: variant;
    i, iHB: integer;
begin
  vFieldNames := Split(FieldNames, ';');
  if not varIsArray(FieldValues) then vFieldValues := varArrayOf([FieldValues])
  else vFieldValues := FieldValues;

  iHB := varArrayHighBound(vFieldNames, 1);
  if varArrayHighBound(vFieldValues, 1) < iHB  then   iHB := varArrayHighBound(vFieldValues, 1);


  for i := 0 to iHB do
  begin
    Result := Result + ' and ' + '(' + varAsType(vFieldNames[i], varOleStr)  + '=';
    if (not varType(vFieldValues[i]) in [varOleStr, varDate]) then
      Result := Result + varAsType(vFieldValues[i], varOleStr)
    else
      Result := Result + '''' + varAsType(vFieldValues[i], varOleStr) + '''';

    Result := Result + ')';
  end;

  Result := '(' + trim(copy(Result, 5, Length(Result))) + ')';
end;

function CreateControl(AOwner: TControl;
  AClassType: TControlClass; const ALeft, ATop, AWidth, AHeight: integer;
  const AAnchors: TAnchors; const AAlign: TAlign): TControl;
begin
  Result := AClassType.Create(AOwner);
  with Result do
  begin
    Parent := AOwner as TWinControl;
    Top := ATop;
    Left := ALeft;
    Width := AWidth;
    Height := AHeight;
    Anchors := AAnchors;
    Align := AAlign;
    Visible := true;
  end;
end;


function FetchParameters(S: string; APrefix: string; out AParams: TStringArray): integer;
const DividerChars: set of char = [' ', ';', ',', '.', ':', ')', '(', '[', ']', '+', '-', '=', '/', '\', #10, #13];
var i, iPos, iHBound: integer;
    sTemp: string;
    arrTemp: TStringArray;
begin
  sTemp := S;

  SetLength(arrTemp, 0);

  iPos := pos(APrefix, sTemp);
  while iPos > 0 do
  begin
    for i := iPos + 1 to Length(sTemp) do
    if (sTemp[i] in DividerChars)  then
    begin
      iHBound := Length(arrTemp);
      SetLength(arrTemp, iHBound + 1);
      arrTemp[iHBound] := copy(sTemp, iPos + 1, i - iPos - 1);

      // режем найденный параметр из строки
      sTemp := StringReplace(sTemp, ':' + arrTemp[iHBound], '', [rfReplaceAll, rfIgnoreCase]);
      break;
    end
    else
    if (i = Length(sTemp)) then
    begin
      iHBound := Length(arrTemp);
      SetLength(arrTemp, iHBound + 1);
      arrTemp[iHBound] := copy(sTemp, iPos + 1, i - iPos);

      // режем найденный параметр из строки
      sTemp := StringReplace(sTemp, ':' + arrTemp[iHBound], '', [rfReplaceAll, rfIgnoreCase]);
      break;
    end;
    iPos := pos(APrefix, sTemp);
  end;

  AParams := arrTemp;
  Result := Length(AParams);
end;

function GetStates(State: Integer): TObjectStates;
var
  Os: TObjectState;
begin
  Result := [];
  for Os := stOpen to High(TObjectState) do
    if (ObjectStateValues[Os] and State) <> 0 then
      Include(Result, Os);
  if Result = [] then Result := [stClosed];
end;

function OleEnumToOrd(OleEnumArray: array of TOleEnum; Value: TOleEnum): Integer;
var i: integer;
begin
  Result := 0;
  for i := Low(OleEnumArray) to High(OleEnumArray) do
  begin
    if Value = OleEnumArray[Result] then Exit;
    Result := i;
  end;

  raise Exception.Create('Неверное преобразование');
end;


function FieldListCheckSum(DataSet: TDataset): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to DataSet.Fields.Count - 1 do
    Result := Result + (Integer(Dataset.Fields[I]) shr (I mod 16));
end;


procedure DoRecordsetDelete(DataSet: TCommonServerDataSet; AffectRecords: TAffectRecords);
begin
  with DataSet do
  try
    FRecordset.Delete(AffectRecordsValues[AffectRecords]);
    { When CacheSize > 1, Recordset allows fetching of deleted records.
      Calling MovePrevious seems to work around it }
    if (CacheSize > 1) and (PRecInfo(ActiveBuffer).RecordNumber <> 1) then
    begin
      FRecordset.MovePrevious;
      FRecordset.MoveNext;
    end;
    FRecordset.MoveNext;
  except
    on E: Exception do
    begin
      FRecordset.CancelUpdate;
      DatabaseError(E.Message);
    end;
  end;
end;


function GetFilterStr(Field: TField; Value: Variant; Partial: Boolean = False): string;
var
  Operator,
  FieldName,
  QuoteCh: string;
begin
  QuoteCh := '';
  Operator := '=';
  FieldName := Field.FieldName;
  if Pos(' ', FieldName) > 0 then
    FieldName := Format('[%s]', [FieldName]);
  if VarIsNull(Value) or VarIsClear(Value) then
    Value := 'Null'
  else
    case Field.DataType of
      ftDate, ftTime, ftDateTime:
        QuoteCh := '#';
      ftString, ftFixedChar, ftWideString:
        begin
          if Partial and (Value <> '') then
          begin
            Value := Value + '*';
            Operator := ' like ';     { Do not localize }
          end;
          if Pos('''', Value) > 0 then
            QuoteCh := '#' else
            QuoteCh := '''';
        end;
    end;
  Result := Format('(%s%s%s%s%2:s)', [FieldName, Operator, QuoteCh, VarToStr(Value)]);
end;


function ExecuteOptionsToOrd(ExecuteOptions: TExecuteOptions): Integer;
var
  Eo: TExecuteOption;
begin
  Result := 0;
  if ExecuteOptions <> [] then
    for Eo := Low(TExecuteOption) to High(TExecuteOption) do
      if Eo in ExecuteOptions then
        Inc(Result, ExecuteOptionValues[Eo]);
end;

function ADOTypeToFieldType(const ADOType: DataTypeEnum; EnableBCD: Boolean = True): TFieldType;
begin
  case ADOType of
    adEmpty: Result := ftUnknown;
    adTinyInt, adSmallInt: Result := ftSmallint;
    adError, adInteger, adUnsignedInt: Result := ftInteger;
    adBigInt, adUnsignedBigInt: Result := ftLargeInt;
    adUnsignedTinyInt, adUnsignedSmallInt: Result := ftWord;
    adSingle, adDouble: Result := ftFloat;
    adCurrency: Result := ftBCD;
    adBoolean: Result := ftBoolean;
    adDBDate: Result := ftDate;
    adDBTime: Result := ftTime;
    adDate, adDBTimeStamp, adFileTime, adDBFileTime: Result := ftDateTime;
    adChar: Result := ftFixedChar;
    adVarChar: Result := ftString;
    adBSTR, adWChar, adVarWChar: Result := ftWideString;
    adLongVarChar, adLongVarWChar: Result := ftMemo;
    adLongVarBinary: Result := ftBlob;
    adBinary: Result := ftBytes;
    adVarBinary: Result := ftVarBytes;
    adChapter: Result := ftDataSet;
    adPropVariant, adVariant: Result := ftVariant;
    adIUnknown: Result := ftInterface;
    adIDispatch: Result := ftIDispatch;
    adGUID: Result := ftGUID;
    adDecimal, adNumeric, adVarNumeric:
      if EnableBCD then Result := ftBCD
      else Result := ftFloat;
  else
    Result := ftUnknown;
  end;
end;


{ TScheme }

procedure TCommonServerDataSet.ActivateTextFilter(const FilterText: string);
begin
  try
    if not VarIsEmpty(FRecordSet) then
      FRecordSet.Filter := FilterText;
  except
    CursorPosChanged;
    //raise;
  end;
end;

function TCommonServerDataSet.AllocRecordBuffer: PChar;
begin
  Result := AllocMem(FRecBufSize);
  if Assigned(Result) then
  begin
    Initialize(PRecInfo(Result)^);
    Initialize(PVariantList(Result+SizeOf(TRecInfo))^, Fields.Count);
  end;
end;



procedure TCommonServerDataSet.ApplyFilter;
var sFilter: string;
begin
  sFilter := FilterFields.AppliedFilter;


  //if Filter <> sFilter then
  begin
{    if trim(sFilter) = '' then
    sFilter := Filter;}
    Close;
    Filter := sFilter;
    Open;
  end;
end;

function TCommonServerDataSet.BookmarkValid(Bookmark: TBookmark): Boolean;
begin
  Result := False;
  if Assigned(Bookmark) and not VarIsNull(POleVariant(Bookmark)^) then
  try
    FRecordset.Bookmark := POleVariant(Bookmark)^;
    CursorPosChanged;
    Result := True;
  except
  end;
end;

procedure TCommonServerDataSet.CancelBatch(AffectRecords: TAffectRecords);
begin
  Cancel;
  UpdateCursorPos;
  Recordset.CancelBatch(AffectRecordsValues[AffectRecords]);
  { If all records were previously deleted, ADO does not reset EOF flag }
  if RecordSet.EOF  and RecordSet.BOF and (Recordset.RecordCount > 0) then
    Recordset.MoveFirst else
    UpdateCursorPos;
  Resync([]);
end;

procedure TCommonServerDataSet.CancelUpdates;
begin
  CancelBatch;
end;

procedure TCommonServerDataSet.CheckFieldCompatibility(Field: TField;
  FieldDef: TFieldDef);
var
  Compatible: Boolean;
begin
  case Field.DataType of
    ftVariant:          { TVariantField should work for any field type }
      Compatible := True;
    ftFloat, ftCurrency, ftBCD: { Numeric and Doubles are interchangeable }
      Compatible := FieldDef.DataType in [ftFloat, ftCurrency, ftBCD];
    ftString, ftWideString: { As are string and widestring }
      Compatible := FieldDef.DataType in [ftString, ftWideString];
  else
    Compatible := False;
  end;
  if not Compatible then inherited;
end;

procedure TCommonServerDataSet.CheckInactive;
begin
//  Result := false;
end;

procedure TCommonServerDataSet.ClearCalcFields(Buffer: PChar);
var
  I: Integer;
begin
  if CalcFieldsSize > 0 then
    for I := 0 to Fields.Count - 1 do
      with Fields[I] do
        if FieldKind in [fkCalculated, fkLookup] then
          PVariantList(Buffer+SizeOf(TRecInfo))[Index] := Null;
end;


procedure TCommonServerDataSet.CloseCursor;
begin
  inherited;
  //FRecordsLoaded := 0;
end;

function TCommonServerDataSet.CompareBookmarks(Bookmark1,
  Bookmark2: TBookmark): Integer;
var
  B1, B2: Integer;
const
  RetCodes: array[Boolean, Boolean] of ShortInt = ((2, -1),(1, 0));
begin
  Result := RetCodes[Bookmark1 = nil, Bookmark2 = nil];
  if Result = 2 then
  try
    Result := RecordSet.CompareBookmarks(POleVariant(Bookmark1)^,
      POleVariant(Bookmark2)^) - 1;
    if Result > 1 then
    begin
      B1 := POleVariant(Bookmark1)^;
      B2 := POleVariant(Bookmark2)^;
      if B1 > B2 then
        Result := 1 else
        Result := -1;
    end;
  except
    Result := 0;
  end;
end;

function TCommonServerDataSet.CopyRecord(
  Dest: TCommonServerDataSet; CopyFields: string): integer;
var i: integer;
    f: TField;
begin
  Result := 0;
  try
    // открываем датасет назначения
    if not Dest.Active then Dest.Open;
    if not Active then Open;

    // добаввляем в датасет назначения пустую строку
    if Dest.CanModify then
    begin
      Dest.Append;
      // проходим по датасету источника и копируем все поля, которые входят в CopyFields в датасет назначения
      for i := 0 to FieldCount - 1 do
      if Pos(AnsiUpperCase(Fields[i].FieldName), AnsiUpperCase(CopyFields)) > 0  then
      begin
        f := Dest.FindField(Fields[i].FieldName);

        if  Assigned(f) and not f.ReadOnly
        and (f.DataType = Fields[i].DataType) then
          f.Value := Fields[i].Value;
      end;
      // постим
      Dest.Post;
    end;
  except
    // что-нибудь не так
    Result := -1;
  end;
end;

function TCommonServerDataSet.CopyRecords(Dest: TCommonServerDataSet;
  Bookmarks: TObject; CopyFields: string; MasterFields: string; MasterFieldValues: Variant;
  SourceUpdatableFields, DestUpdatableFields: string): integer;
var i, j, iMasterFieldFound: integer;
    f: TField;
    bms: TBookmarkList;
begin
  Result := 0;
  try
    // открываем датасет назначения
    if not Dest.Active then Dest.Open;

    if Dest.CanModify then
    begin
      bms := Bookmarks as TBookmarkList;
      for i := 0 to bms.Count - 1 do
      begin
        GotoBookmark(Pointer(bms.Items[i]));
        Dest.Append;
        iMasterFieldFound := 0;
        // проходим по датасету источника и копируем все поля, которые входят в CopyFields в датасет назначения
        for j := 0 to FieldCount - 1 do
        begin
          if Pos(AnsiUpperCase(Fields[j].FieldName), AnsiUpperCase(CopyFields)) > 0  then
          begin
            f := Dest.FindField(Fields[j].FieldName);
            if  Assigned(f) and not f.ReadOnly
            and (f.DataType = Fields[j].DataType) then
              f.Value := Fields[j].Value;
          end;
        end;

        if trim(MasterFields) <> '' then
        for j := 0 to Dest.FieldCount - 1 do
        if Pos(AnsiUpperCase(Dest.Fields[j].FieldName), AnsiUpperCase(MasterFields)) > 0  then
        begin
          f := Dest.Fields[j];

          if varIsType(MasterFieldValues, varArray) then
          begin
            f.Value := MasterFieldValues[iMasterFieldFound];
            inc(iMasterFieldFound);
          end
          else f.Value := MasterFieldValues;
        end;

        // постим
        Dest.Post;
      end;
      // переспрашиваем
      Dest.Refresh;
    end;
  except
    // что-нибудь не так
    Result := -1;
  end;
end;

constructor TCommonServerDataSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FModifiedFields := TList.Create;
  FSortFields := TSortFields.Create(Self);
  FDistinctDataSets := TCSServerDataSets.Create(Self);

  FFieldNames := '*';
  FFilterChanged := true;
  FFieldIDs := TList.Create;
  FAutoFillDates := false;
  FAutoRefresh := false;

  NestedDataSetClass := TCommonServerDataSet;
  FMasterDataLink := TMasterDataLink.Create(Self);

  FFetchedByQuery := TBookmarks.Create(Self);
end;


procedure TCommonServerDataSet.DataEvent(Event: TDataEvent; Info: Integer);
begin
  try
    if Event = deFieldChange then
    //if TField(Info).FieldKind = fkLookup then
       SetModified(True);
  except

  end;
  inherited;
end;

procedure TCommonServerDataSet.DeactivateFilters;
begin
  FRecordset.Filter := '';
end;

procedure TCommonServerDataSet.Delete;
begin
  if not(soNoDelete in Options) then inherited
  else Cancel; 
end;

procedure TCommonServerDataSet.DeleteRecords(AffectRecords: TAffectRecords);
begin
  CheckActive;
  UpdateCursorPos;
  CursorPosChanged;
  DoRecordsetDelete(Self, AffectRecords);
  Resync([]);
end;

destructor TCommonServerDataSet.Destroy;
begin
  Destroying;
  Close;
  FreeAndNil(FFetchedByQuery);
  FreeAndNil(FModifiedFields);
  FreeAndNil(FMasterDataLink);
  FreeAndNil(FFilterFields);
  FreeAndNil(FFieldIds);
  FreeAndNil(FDistinctDataSets);
  FreeAndNil(FSortFields);
  inherited;
end;

procedure TCommonServerDataSet.DestroyLookupCursor;
begin
  varClear(FFindCursor);
end;

procedure TCommonServerDataSet.DoAfterOpen;
begin
  inherited;
  FSortFields.Reload;
end;

procedure TCommonServerDataSet.DoAfterScroll;
begin
  // для прокрутки
  //if RecNo >= (RecordsLoaded - (PageSize div 5)) then FetchNext;
  inherited;
end;

procedure TCommonServerDataSet.DoOnNewRecord;
var i: integer;
begin
  inherited;
  for i := 0 to FieldCount - 1 do
  if Fields[i].DataType in [ftTimeStamp, ftDateTime] then
    Fields[i].Value := null
  else if Fields[i].DataType in [ftDate] then
    Fields[i].Value := null;
end;

procedure TCommonServerDataSet.DoBeforeScroll;
begin
  inherited DoBeforeScroll;
end;

procedure TCommonServerDataSet.DoGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  try
    if Sender.Lookup and not VarIsNull(Sender.Value) then
      Text := Sender.LookupDataSet.Lookup(Sender.LookupKeyFields, Sender.Value, Sender.LookupResultField)
  except
    
  end
end;


procedure TCommonServerDataSet.ExecProc;
begin
  // если новая запись - вставляем
  if UpdateStatus = usInserted then
  begin


  end
  else if UpdateStatus = usModified then
  begin

  end
  else if UpdateStatus = usDeleted then
  begin

  end;

end;

procedure TCommonServerDataSet.FetchByQuery(AFilter: string);
var iResult: integer;
    dsTemp: OleVariant;
    fv, ff: OleVariant;
    i, j: integer;
    b: POleVariant;
begin
{ TODO : Тут при постраничной загрузке
  в датасет грузится лишняя строка,
  один раз по фильтру, а д
  другой - постранично.
 }
  if RecordsLoaded < GeneralRecordCount then
  begin

    Server.NeedADORecordSet := true;
    iResult := Server.ExecuteQuery(SelectQuery[AFilter]);

    //if iResult >= 0 then
    if iResult > 0 then
    begin
      dsTemp := Server.QueryResultAsADORecordSet;
      if iResult <> 0 then dsTemp.MoveFirst;

      fv := varArrayCreate([0, dsTemp.Fields.Count - 1], varVariant);
      ff := varArrayCreate([0, dsTemp.Fields.Count - 1], varVariant);
      for i := 0 to dsTemp.RecordCount - 1 do
      begin
        for j := 0 to dsTemp.Fields.Count - 1 do
        begin
          fv[j] := dsTemp.Fields[j].Value;
          ff[j] := dsTemp.Fields[j].Name;
        end;

        FRecordSet.AddNew(ff, fv);

        New(b);
        b^ := FRecordSet.Bookmark;
        FFetchedByQuery.Add(b);
        
        dsTemp.MoveNext;
      end;
      //FRecordsLoaded := FRecordsLoaded + iResult;

      if trim(FSort) <> '' then FRecordSet.Sort := FSort;
    end;
  end;
end;

procedure TCommonServerDataSet.FetchNext;
var iResult: integer;
    dsTemp: OleVariant;
    fv, ff: OleVariant;
    i, j: integer;
begin
  if RecordsLoaded < GeneralRecordCount then
  begin
    Server.NeedADORecordSet := true;
    iResult := Server.ExecuteQuery(SelectQuery['']);

    if iResult >= 0 then
    begin
      dsTemp := Server.QueryResultAsADORecordSet;
      if iResult <> 0 then dsTemp.MoveFirst;

      fv := varArrayCreate([0, dsTemp.Fields.Count - 1], varVariant);
      ff := varArrayCreate([0, dsTemp.Fields.Count - 1], varVariant);
      for i := 0 to dsTemp.RecordCount - 1 do
      begin
        for j := 0 to dsTemp.Fields.Count - 1 do
        begin
          fv[j] := dsTemp.Fields[j].Value;
          ff[j] := dsTemp.Fields[j].Name;
        end;
        FRecordSet.AddNew(ff, fv);
        dsTemp.MoveNext;
      end;
      FRecordsLoaded := FRecordsLoaded + iResult;

      // !!! ошибка - поле не редактируемое
      //if trim(FSort) <> '' then FRecordSet.Sort := FSort;
    end;
  end;
end;

procedure TCommonServerDataSet.FilterOnBookmarks(Bookmarks: array of const);
var
  I: Integer;
  BookmarkData: OleVariant;
begin
  CheckBrowseMode;
  BookmarkData := VarArrayCreate([Low(Bookmarks), High(Bookmarks)], varVariant);
  for I := Low(Bookmarks) to High(Bookmarks) do
     BookmarkData[I] := POleVariant(TVarRec(Bookmarks[I]).VPointer)^;
  inherited SetFilterText('');
  FFilterGroup := fgUnassigned;
  DestroyLookupCursor;
  try
    Recordset.Filter := BookmarkData;
    First;
    inherited SetFiltered(True);
  except
    inherited SetFiltered(False);
    raise;
  end;
end;

function TCommonServerDataSet.FindRecord(Restart, GoForward: Boolean): Boolean;
var
  Cursor: OleVariant;
begin
  CheckBrowseMode;
  SetFound(False);
  UpdateCursorPos;
  CursorPosChanged;
  DoBeforeScroll;
  if not Filtered then
  begin
    if Restart then FFindCursor := null;
    if varIsEmpty(FFindCursor) then
    begin
      FFindCursor := FRecordset.Clone(adLockReadOnly);
      FFindCursor.Filter := Filter;
    end else
      if not Restart then FFindCursor.Bookmark := FRecordset.Bookmark;
    Cursor := FFindCursor;
  end else
    Cursor := FRecordset;
  try
    if GoForward then
    begin
      if Restart then
        Cursor.MoveFirst else
        Cursor.MoveNext;
    end else
    begin
      if Restart then
        Cursor.MoveLast else
        Cursor.MovePrevious;
    end;
    if Cursor <> FRecordset then
      FRecordset.Bookmark := FFindCursor.Bookmark;
    Resync([rmExact, rmCenter]);
    SetFound(True);
  except
    { Exception = not found }
  end;
  Result := Found;
  if Result then DoAfterScroll;
end;

procedure TCommonServerDataSet.FreeRecordBuffer(var Buffer: PChar);
begin
  Finalize(PRecInfo(Buffer)^);
  if Fields.Count > 0 then
    Finalize(PVariantList(Buffer+SizeOf(TRecInfo))^, Fields.Count);
  FreeMem(Buffer);
end;


function TCommonServerDataSet.GetActiveRecBuf(var RecBuf: PChar): Boolean;
begin
  case State of
    dsBlockRead,
    dsBrowse:
      if IsEmpty or ((BookmarkSize = 0) and RecordSet.EOF) then
        RecBuf := nil else
        RecBuf := ActiveBuffer;
    dsEdit, dsInsert, dsNewValue: RecBuf := ActiveBuffer;
    dsCalcFields,
    dsInternalCalc: RecBuf := CalcBuffer;
    dsFilter: RecBuf := FFilterBuffer;
  else
    RecBuf := nil;
  end;
  Result := RecBuf <> nil;
end;


procedure TCommonServerDataSet.GetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  Initialize(POleVariant(Data)^);
  POleVariant(Data)^ := PRecInfo(Buffer).Bookmark;
end;

function TCommonServerDataSet.GetBookmarkFlag(Buffer: PChar): TBookmarkFlag;
begin
  Result := PRecInfo(Buffer)^.BookmarkFlag;
end;

function TCommonServerDataSet.GetCacheSize: Integer;
begin
  if not varIsEmpty(Recordset) then
    FCacheSize := FRecordset.CacheSize;
  Result := FCacheSize;
end;

function TCommonServerDataSet.GetCanModify: Boolean;
begin
  Result := FRecordset.Supports(adUpdate);
end;


function TCommonServerDataSet.GetCurrentPage: integer;
begin
  Result := 1;
  if (soPartialFilling in Options) and (PageCount <> 0) then
  begin
    //Result := Round(RecNo / PageCount);
    Result := Round(RecordsLoaded / PageSize);
    if Result = 0 then Result := 1;
  end;
end;

function TCommonServerDataSet.GetCurrentRecordFilter: string;
var i: integer;
    fl: TList;
    v: OleVariant;
begin
  fl := TObjectList.Create(false);
  GetFieldList(fl, KeyFieldNames);


  for i := 0 to fl.Count - 1 do
  begin
    v := TField(fl[i]).AsVariant;
    case VarType(v) of
    varDate, varOleStr:
      Result := Result + 'and (' +  TField(fl[i]).FieldName + ' = ' + '''' +  TField(fl[i]).AsString  + '''' + ')';
    else
      Result := Result + 'and (' +  TField(fl[i]).FieldName + ' = ' + TField(fl[i]).AsString  + ')';
    end;
  end;

  Result := trim(copy(Result, 5, Length(Result)));

  fl.Free;
end;

function TCommonServerDataSet.GetCurrentRecordFilterNames: variant;
var fl: TObjectList;
    i, j: integer;
begin
  fl := TObjectList.Create(false);
  GetFieldList(fl, KeyFieldNames);

  Result := varArrayCreate([0, fl.Count - 1], varOleStr);
  j := 0;
  for i := 0 to fl.Count - 1 do
  begin
    if pos(UpperCase(TField(fl.Items[i]).FieldName), UpperCase(AccessoryFields)) > 0 then
    begin
      Result[j] := TField(fl.Items[i]).FieldName;
      j := j + 1;
    end;
  end;

  if j < fl.Count then varArrayRedim(Result, j - 1);

  fl.Free
end;

function TCommonServerDataSet.GetCurrentRecordFilterValues: variant;
var fl: TObjectList;
    i, j: integer;
begin
  fl := TObjectList.Create(false);
  GetFieldList(fl, KeyFieldNames);
  Result := varArrayCreate([0, fl.Count - 1], varVariant);

  j := 0;

  for i := 0 to fl.Count - 1 do
  begin
    if pos(UpperCase(TField(fl.Items[i]).FieldName), UpperCase(AccessoryFields)) > 0 then
    begin
      Result[j] := TField(fl.Items[i]).Value;
      j := j + 1;
    end;
  end;

  if j < fl.Count then varArrayRedim(Result, j - 1);
  fl.Free
end;

function TCommonServerDataSet.GetCurrentRecordModifiedNames: OleVariant;
var i, j: integer;
begin
  Result := varArrayCreate([0, FModifiedFields.Count - 1], varOleStr);
  j := 0;
  for i := 0 to FModifiedFields.Count - 1 do
  if pos(UpperCase(TField(FModifiedFields.Items[i]).FieldName), UpperCase(AccessoryFields)) > 0 then
  begin
    Result[j] := TField(FModifiedFields.Items[i]).FieldName;
    j := j + 1;
  end;

  if j < FModifiedFields.Count then varArrayRedim(Result, j - 1);
end;

function TCommonServerDataSet.GetCurrentRecordModifiedValues: OleVariant;
var i, j: integer;
begin
  Result := varArrayCreate([0, FModifiedFields.Count - 1], varVariant);
  j := 0;
  for i := 0 to FModifiedFields.Count - 1 do
  if pos(UpperCase(TField(FModifiedFields.Items[i]).FieldName), UpperCase(AccessoryFields)) > 0 then
  begin
    Result[j] := TField(FModifiedFields.Items[i]).Value;
    j := j + 1;
  end;

  if j < FModifiedFields.Count then varArrayRedim(Result, j - 1);
end;

function TCommonServerDataSet.GetCurrentRecordNames: variant;
var i, j: integer;
begin
  Result := varArrayCreate([0, Fields.Count - 1], varOleStr);
  j := 0;
  for i := 0 to Fields.Count - 1 do
  begin
    if pos(UpperCase(Fields[i].FieldName), UpperCase(AccessoryFields)) > 0 then
    begin
      Result[j] := Fields[i].FieldName;
      j := j + 1;
    end;
  end;

  if j < Fields.Count then varArrayRedim(Result, j - 1);
end;

function TCommonServerDataSet.GetCurrentRecordUpdatableValues: variant;
var fl: TObjectList;
    i, j: integer;
begin
  fl := TObjectList.Create(false);
  GetFieldList(fl, UpdatableFieldNames);
  Result := varArrayCreate([0, fl.Count - 1], varInteger);

  j := 0;

  for i := 0 to fl.Count - 1 do
  begin
    if pos(UpperCase(TField(fl.Items[i]).FieldName), UpperCase(AccessoryFields)) > 0 then
    begin
      Result[j] := TField(fl.Items[i]).Value;
      j := j + 1;
    end;
  end;

  if j < fl.Count then varArrayRedim(Result, j - 1);
  fl.Free

end;

function TCommonServerDataSet.GetCurrentRecordUpdatebleNames: variant;
var fl: TObjectList;
    i, j: integer;
begin
  fl := TObjectList.Create(false);
  GetFieldList(fl, UpdatableFieldNames);

  Result := varArrayCreate([0, fl.Count - 1], varOleStr);
  j := 0;
  for i := 0 to fl.Count - 1 do
  begin
    if pos(UpperCase(TField(fl.Items[i]).FieldName), UpperCase(AccessoryFields)) > 0 then
    begin
      Result[j] := TField(fl.Items[i]).FieldName;
      j := j + 1;
    end;
  end;

  if j < fl.Count then varArrayRedim(Result, j - 1);

  fl.Free
end;

function TCommonServerDataSet.GetCurrentRecordUserFilter(
  Columns: string): string;
var vFields: variant;
    i: integer;
    f: TField;
begin
  vFields := Split(Columns, ';');

  Result := '';
  for i := 0 to varArrayHighBound(vFields, 1) do
  begin
    f := FindField(vFields[i]);

    if Assigned(f) then
    begin
      if f.DataType in [ftString, ftDate, ftTime, ftWideString, ftTimeStamp] then
        Result := Result + ' and ' + '(' + f.FieldName + ' = ' + '''' + f.AsString + '''' + ')'
      else
        Result := Result + ' and ' + '(' + f.FieldName + ' = ' + f.AsString + ')';
    end;
  end;

  Result := trim(copy(Result, 5, Length(Result)));
end;



function TCommonServerDataSet.GetCurrentRecordUserFilterValues(
  Columns: string): variant;
var vFields: variant;
    i, j: integer;
    f: TField;
begin
  vFields := Split(Columns, ';');

  Result := varArrayCreate([0, -1], varVariant);
  j := 0;

  for i := 0 to varArrayHighBound(vFields, 1) do
  begin
    f := FindField(vFields[i]);

    if Assigned(f) then
    begin
      varArrayRedim(Result, j);
      Result[j] := f.Value;
      j := j + 1;
    end;
  end;

  if j = 1 then Result := Result[0];
end;

function TCommonServerDataSet.GetCurrentRecordValues: variant;
var i, j : integer;
begin
  Result := varArrayCreate([0, Fields.Count - 1], varVariant);
  j := 0;
  for i := 0 to Fields.Count - 1 do
  if pos(UpperCase(Fields[i].FieldName), UpperCase(AccessoryFields)) > 0 then
  begin
    Result[j] := Fields[i].Value;
    j := j + 1;
  end;

  if j < Fields.Count then varArrayRedim(Result, j - 1);
end;

function TCommonServerDataSet.GetDataSource: TDataSource;
begin
  Result := MasterDataLink.DataSource;
end;


function TCommonServerDataSet.GetDistinctDataSets(
  AFieldName: string): TDistinctDataSet;
var i: integer;
begin
  Result := nil;
  for i := 0 to FDistinctDataSets.Count - 1 do 
  if AnsiUpperCase(FDistinctDataSets.Items[i].FieldNames) = AnsiUpperCase(AFieldName) then
  begin
    Result := FDistinctDataSets.Items[i] as TDistinctDataSet;
    break;
  end;

  if not Assigned(Result) then
  begin
    Result := TDistinctDataSet.Create(nil);
    Result.Options := [soSingleDataSource];
    Result.OPtions := Result.Options +  Options;
    Result.PageSize := PageSize;
    Result.DataSourceString := DataSourceString;
    Result.DatasetIdent := DataSourceString;

    Result.KeyFieldNames := AFieldName;
    Result.FieldNames := AFieldName;
    Result.Sort := AFieldName;
    FDistinctDataSets.Add(Result);
  end;

  try
    if not Result.Active then Result.Open;
  except
    FDistinctDataSets.Remove(Result);
    Result := nil;
  end;
end;

function TCommonServerDataSet.GetFieldData(FieldNo: Integer; Buffer: Pointer): Boolean;
begin
  Result := GetFieldData(FieldByNumber(FieldNo), Buffer);
end;

function TCommonServerDataSet.GetFieldData(Field: TField; Buffer: Pointer): Boolean;
begin
  Result := GetFieldData(Field, Buffer, True);
end;

function TCommonServerDataSet.GetFieldData(Field: TField; Buffer: Pointer;
  NativeFormat: Boolean): Boolean;
var
  RecBuf: PChar;
  Data: OleVariant;

  procedure CurrToBuffer(const C: Currency);
  begin
    if NativeFormat then
      DataConvert(Field, @C, Buffer, True) else
      Currency(Buffer^) := C;
  end;

  procedure VarToBuffer;
  begin
    with tagVariant(Data) do
      case Field.DataType of
        ftGuid, ftFixedChar, ftString:
          begin
            PChar(Buffer)[Field.Size] := #0;
            WideCharToMultiByte(0, 0, bStrVal, SysStringLen(bStrVal)+1,
              Buffer, Field.Size, nil, nil);
          end;
        ftWideString:
          WideString(Buffer^) := bStrVal;
        ftSmallint:
          if vt = VT_UI1 then
            SmallInt(Buffer^) := Byte(cVal) else
            SmallInt(Buffer^) := iVal;
        ftWord:
          if vt = VT_UI1 then
            Word(Buffer^) := bVal else
            Word(Buffer^) := uiVal;
        ftAutoInc, ftInteger:
          Integer(Buffer^) := Data;
        ftFloat, ftCurrency:
          if vt = VT_R8 then
            Double(Buffer^) := dblVal else
            Double(Buffer^) := Data;
        ftBCD:
          if vt = VT_CY then
            CurrToBuffer(cyVal) else
            CurrToBuffer(Data);
        ftBoolean:
          WordBool(Buffer^) := vbool;
        ftDate, ftTime, ftDateTime:
          if NativeFormat then
            DataConvert(Field, @date, Buffer, True) else
            TOleDate(Buffer^) := date;
        ftBytes, ftVarBytes:
          if NativeFormat then
            DataConvert(Field, @Data, Buffer, True) else
            OleVariant(Buffer^) := Data;
        ftInterface: IUnknown(Buffer^) := Data;
        ftIDispatch: IDispatch(Buffer^) := Data;
        ftLargeInt: LargeInt(Buffer^) := Data;
        ftBlob..ftTypedBinary, ftVariant: OleVariant(Buffer^) := Data;
      else
        DatabaseErrorFmt('Тип поля не поддерживается', [FieldTypeNames[Field.DataType],
          Field.DisplayName]);
      end;
  end;

  procedure RefreshBuffers;
  begin
    Reserved := Pointer(FieldListCheckSum(Self));
    UpdateCursorPos;
    Resync([]);
  end;

begin
  if not Assigned(Reserved) then RefreshBuffers;
  Result := GetActiveRecBuf(RecBuf);
  if not Result then Exit;
  Data := PVariantList(RecBuf+SizeOf(TRecInfo))[Field.Index];
  if VarIsClear(Data) and (Field.FieldNo > 0) then
  begin
    { Don't try to read data from a deleted record }
    if (PRecInfo(RecBuf)^.RecordStatus and adRecDeleted) = 0 then
    begin
      UpdateRecordSetPosition(RecBuf);
      Data := Recordset.Fields[Field.FieldNo-1].Value;
    end;
    if VarIsClear(Data) then Data := Null;
    PVariantList(RecBuf+SizeOf(TRecInfo))[Field.Index] := Data;
  end;
  Result := not VarIsNull(Data);
  if Result and (Buffer <> nil) then
    VarToBuffer;
end;

function TCommonServerDataSet.GetFieldIDs(const Index: integer): integer;
var i, iResult: integer;
    vResult: variant;
begin
  for i := FFieldIDs.Count to Index do
    FFieldIDs.Add(nil);

  Result := Integer(FFieldIDs.Items[Index]);
  if Result = 0 then
  begin
    iResult := Server.ExecuteQuery('select Attribute_ID from tbl_Attribute where vch_Attribute_Name = ' + '''' + AnsiUpperCase(Fields[Index].FieldName) + '''');

    if iResult > 0 then
    begin
      vResult := Server.QueryResult;

      Result := vResult[0, 0];
      FFieldIDs.Items[Index] := Pointer(Result);
    end;
  end;
end;

function TCommonServerDataSet.GetFilterGroup: TFilterGroup;
var
  FilterVar: OleVariant;
begin
  if Active and Filtered then
  begin
    FilterVar := Recordset.Filter;
    if (VarType(FilterVar) = varInteger) and
      (FilterVar >= adFilterNone) and (FilterVar <= adFilterConflictingRecords) then
      FFilterGroup := TFilterGroup(DWORD(OleEnumToOrd(FilterGroupValues, FilterVar)))
    else
      FFilterGroup := fgUnassigned;
  end;
  Result := FFilterGroup;
end;




procedure TCommonServerDataSet.GetGeneralRecordCount;
var iResult: integer;
    vResult: variant;
    sQuery: string;
begin
  if ((soPartialFilling in Options) and (FilterChanged)) then
     //((soPartialFilling in Options) and (FRecordsLoaded = 0)) then
  begin
    FRecordsLoaded := 0;
    FFilterChanged := false;
    Server.NeedADORecordset := false;
    sQuery := 'select count(*) from ' + DataSourceString;

    if Filter <> '' then
      sQuery := sQuery + ' where ' + Filter;

    iResult := Server.ExecuteQuery(sQuery);
    if iResult >= 0 then
    begin
      vResult := Server.QueryResult;
      GeneralRecordCount := vResult[0, 0];
    end;
  end;
end;

function TCommonServerDataSet.GetLeadingSelectQuery: string;
var i, iAliasCount: integer;
    s, sJoin, sDsName: string;
    strlstAliases: TStringList;
begin
  s := ''; sJoin := '';
  strlstAliases := TStringList.Create;
  iAliasCount := 0;

  for i := 0 to FieldCount - 1 do
  if Fields[i].Visible then
  begin
    if (not Fields[i].Lookup)
    or (pos(Fields[i].LookupResultField, Fields[i].LookupKeyFields) > 0) then
    begin
      sDSName := 't' + IntToStr(iAliasCount);
      strlstAliases.Add(DataSourceString + '=' + sDSName);

      iAliasCount := iAliasCount + 1;

      s := s + ',' + sDsName + '.' + Fields[i].FieldName
    end
    else
    begin
      sDsName := (Fields[i].LookupDataSet as TCommonServerDataSet).DataSourceString;
      if sDSName = DataSourceString then
      begin
        sDSName := 't' + IntToStr(iAliasCount);
        iAliasCount := iAliasCount + 1;

        s := s + ',' + sDsName + '.' + Fields[i].LookupResultField;
        sJoin := sJoin + ' left join ' + ' ' + DataSourceString + ' ' + sDsName;
        sJoin := sJoin + ' on (' + strlstAliases.Values[DataSourceString] + '.' + Fields[i].FieldName + '=' + sDsName + '.' + KeyFieldNames + ') ';
      end
      else
      begin
        sJoin := sJoin + ' left join ' + sDsName;

        sDSName := 't' + IntToStr(iAliasCount);
        iAliasCount := iAliasCount + 1;

        sJoin := sJoin + ' ' + sDsName;

        s := s + ',' + sDsName + '.' + Fields[i].LookupResultField;
        sJoin := sJoin + ' on (' + strlstAliases.Values[DataSourceString] + '.' + Fields[i].FieldName + '=' + sDsName + '.' + Fields[i].FieldName + ') ';
      end;
    end;
  end;

  s := copy(s, 2, Length(s));

  s := 'select ' + s + ' from ' + DataSourceString + ' ' + strlstAliases.Values[DataSourceString];
  s := s + ' ' + sJoin;

  if trim(Filter) <> '' then
    s := s + ' where ' + StringReplace(Filter, DataSourceString, strlstAliases.Values[DataSourceString], [rfReplaceAll]);

  if trim(FSort) <> '' then
    s := s + ' order by ' + StringReplace(FSort, DataSourceString, strlstAliases.Values[DataSourceString], [rfReplaceAll]);

  Result := s;
  strlstAliases.Free;
end;


function TCommonServerDataSet.GetLeadingSelectResult(
  NeedInversion: boolean): OleVariant;
var iResult: integer;
begin
  Server.NeedInvertedArray := NeedInversion;
  iResult := Server.ExecuteQuery(LeadingSelectQuery);

  if iResult > 0 then
  begin
    if not NeedInversion then
      Result := Server.QueryResult
    else
      Result := Server.InvertedQueryResult;
  end;

  Server.NeedInvertedArray := false;
end;

function TCommonServerDataSet.GetMaxRecords: Integer;
begin
  if not varIsEmpty(FRecordset) then
    FMaxRecords := FRecordset.MaxRecords;
  Result := FMaxRecords;
end;



function TCommonServerDataSet.GetPageCount: integer;
begin
  Result := 1;
  if (soPartialFilling in Options) and (PageSize > 0) then
  begin
    Result := GeneralRecordCount div PageSize;
    if GeneralRecordCount mod PageSize > 0 then Result := Result + 1;
  end;
end;


function TCommonServerDataSet.GetRecNo: Integer;
var
  BufPtr: PChar;
begin
  CheckActive;

  if IsEmpty or (State = dsInsert) then
    Result := -1
  else
  begin
    if State = dsCalcFields then
      BufPtr := CalcBuffer else
      BufPtr := ActiveBuffer;
    Result := PRecInfo(BufPtr).RecordNumber;
    { If record was read with controls disabled, then the RecordNumber is
      initialized to -2 as a flag to re-read the value from the recordset }
    if Result = -2 then
    begin
      { Position to recordset to the appropriate record }
      InternalSetToRecord(BufPtr);
      CursorPosChanged;
      Result := FRecordset.AbsolutePosition;
    end;
  end;
end;

function TCommonServerDataSet.GetRecord(Buffer: PChar; GetMode: TGetMode;
  DoCheck: Boolean): TGetResult;
var
  Accept: Boolean;
  SaveState: TDataSetState;
begin
  if (BookmarkSize = 0) and (BufferCount > 1) then
    DatabaseError('Закладки не поддерживаются');
  if Filtered and Assigned(OnFilterRecord) then
  begin
    FFilterBuffer := Buffer;
    SaveState := SetTempState(dsFilter);
    try
      Accept := True;
      repeat
        Result := InternalGetRecord(Buffer, GetMode, DoCheck);
        if Result = grOK then
        begin
          OnFilterRecord(Self, Accept);
          if not Accept and (GetMode = gmCurrent) then
            Result := grError;
        end;
      until Accept or (Result <> grOK);
    except
      ApplicationHandleException(Self);
      Result := grError;
    end;
    RestoreState(SaveState);
  end else
    Result := InternalGetRecord(Buffer, GetMode, DoCheck)
end;

function TCommonServerDataSet.GetRecordCount: Integer;
begin
  CheckActive;
  if not varIsEmpty (FRecordset) then
    Result := FRecordset.RecordCount
  else
    Result := 0;
end;

function TCommonServerDataSet.GetRecordsetState: TObjectStates;
begin
  if not varIsEmpty (FRecordset) then
    Result := GetStates(Recordset.State) else
    Result := [];
end;

function TCommonServerDataSet.GetRecordSize: Word;
begin
  Result := FRecBufSize;
end;

function TCommonServerDataSet.GetRecordStatus: TRecordStatusSet;
var
  Status: Integer;
  RecStatus: TRecordStatus;
begin
  CheckActive;
  Result := [];
  if State = dsCalcFields then
    Status := PRecInfo(CalcBuffer).RecordStatus else
    Status := PRecInfo(ActiveBuffer).RecordStatus;
  for RecStatus := Low(TRecordStatus) to High(TRecordStatus) do
    if (RecordStatusValues[RecStatus] and Status) <> 0 then
      Include(Result, RecStatus);
end;

function TCommonServerDataSet.GetSelectQuery(const AFilter: string = ''): string;
begin
  Result := 'select ';

  // сколько выбрать и сколько пропустить
  // выбираем только новые строки

  if (soPartialFilling in Options) and  (trim(AFilter) = '') then
  begin
    Result := Result + ' first ' + IntToStr(PageSize);

    //if Active then
    // !!!
    if (RecordsLoaded > 0) then //and (TMainFacade.GetInstance.AllDocuments.Count > 0) then
      Result := Result + ' skip ' + IntToStr(RecordsLoaded) + ' '
    else
      Result := Result + ' skip 0 ';
  end;

  Result := Result + ' distinct ';

  Result := Result + FieldNames + ' from ' + DataSourceString;

  if trim(AFilter) <> '' then
    Result := Result + ' where ' + AFilter
  else if trim(Filter) <> '' then
    Result := Result + ' where ' + Filter;

 { if FFetchedByQuery.Count > 0 then
    Result := Result + ' ( and not (' +  FFetchedByQuery.MakeFilter + '))';}

  if trim(FSort) <> '' then
    Result := Result + ' order by ' + FSort;
end;

function TCommonServerDataSet.GetSort: WideString;
begin
  if not varIsEmpty(FRecordset) then
    Result := FRecordset.Sort else
    Result := '';
end;

function TCommonServerDataSet.GetSortFields(
  AFieldName: string): TSortField;
begin
  FSortFields.Reload;
  Result := FSortFields.FieldByName[AFieldName];
end;

function TCommonServerDataSet.GetSortFieldsSortString(Full: boolean): string;
begin
  Result := FSortFields.SortString[Full];
end;

function TCommonServerDataSet.GetSourceType(
  const ASourceName: string): TSourceType;
begin
  if pos('TBL_', UpperCase(ASourceName)) > 0 then
    Result := stTable
  else if pos('VW_', UpperCase(ASourceName)) > 0 then
    Result := stView
  else if pos('SPD_', UpperCase(ASourceName)) > 0 then
    Result := stProc
  else
    Result := stNone;
end;

function TCommonServerDataSet.GetStateFieldValue(State: TDataSetState;
  Field: TField): Variant;
begin
  if IsEmpty or not (Self.State in [dsBrowse, dsEdit]) then
    Result := Null
  else
  begin
    UpdateCursorPos;
    case State of
      dsOldValue:
        Result := FRecordset.Fields[Field.FieldNo-1].OriginalValue;
      dsCurValue:
        Result := FRecordset.Fields[Field.FieldNo-1].UnderlyingValue;
    else
      Result := inherited GetStateFieldValue(State, Field);
    end;
  end;
end;

function TCommonServerDataSet.GetTableID: integer;
var iResult: integer;
    vResult: OleVariant;
begin
  if FTableID = 0 then
  begin
    iResult := Server.ExecuteQuery('select distinct Table_ID from tbl_Table where vch_Table_Name = ' + '''' + AnsiUpperCase(FDataSourceName) + '''');
    if iResult > 0 then
    begin
      vResult := Server.QueryResult;

      FTableID := vResult[0, 0];
    end;
  end;

  Result := FTableID;
end;

function TCommonServerDataSet.getTestBOF: integer;
begin
  Result := FRecordSet.bOf;

  if Result < 0 then
  begin
    FRecordset.MoveFirst;
    Result := FRecordset.Bof;
  end;
end;

function TCommonServerDataSet.getTestEOF: integer;
begin
  Result := FRecordSet.Eof;
  if Result < 0 then
  begin
    FRecordset.MoveLast;
    Result := FRecordset.Eof;
  end;

end;

procedure TCommonServerDataSet.Insert;
begin
  if (soNoInsert in Options) then Inherited
  else Cancel;
end;

procedure TCommonServerDataSet.InternalAddRecord(Buffer: Pointer; Append: Boolean);
begin
  if Append then SetBookmarkFlag(Buffer, bfEOF);
  InternalPost;
end;

procedure TCommonServerDataSet.InternalCancel;
begin
  ReleaseLock;
end;

procedure TCommonServerDataSet.InternalClose;
begin
  BindFields(False);
  if DefaultFields then DestroyFields;
  DestroyLookupCursor;
end;

procedure TCommonServerDataSet.InternalDelete;
var iResult: integer;
begin
  // выполнить удаление на сервере
  if not(soNoDelete in Options) then
  begin
    iResult := -1;
    if GetSourceType(DataDeletionString) = stTable then
      iResult := Server.DeleteRow(DataDeletionString, CurrentRecordFilter)
    else
    if GetSourceType(DataDeletionString) = stProc then
      iResult := Server.InsertRow(DataDeletionString, null, CurrentRecordFilterValues)
    else if GetSourceType(DataDeletionString) = stNone then
      iResult := 0;

    if iResult >= 0 then
    begin
      try
        FRecordset.Delete(adAffectCurrent);

        if soPartialFilling in Options then
        begin
          FRecordsLoaded := FRecordsLoaded - 1;
          GeneralRecordCount := GeneralRecordCount - 1;
        end;
        { When CacheSize > 1, Recordset allows fetching of deleted records.
          Calling MovePrevious seems to work around it }
        if (CacheSize > 1) and (PRecInfo(ActiveBuffer).RecordNumber <> 1) then
        begin
          FRecordset.MovePrevious;
          FRecordset.MoveNext;
        end;
        FRecordset.MoveNext;
      except
        on E: Exception do
        begin
          FRecordset.CancelUpdate;
          DatabaseError(E.Message);
        end;
      end;
    end
    else raise EDatabaseError.Create('Ошибка удаления данных');
  end;
end;

procedure TCommonServerDataSet.InternalEdit;
var
  I: Integer;
begin
  FModifiedFields.Clear;
  if FRecordset.LockType = adLockPessimistic then
  begin
    UpdateCursorPos;
    FLockCursor := FRecordset.Clone(adLockUnspecified);
    FLockCursor.Bookmark := FRecordset.Bookmark;
    { Find an updatable field, and then assign the existing value to lock }
    for I := 0 to FLockCursor.Fields.Count - 1 do
    if ((adFldUpdatable+adFldUnknownUpdatable) and
        FRecordset.Fields[I].Attributes) <> 0 then
    begin
      FLockCursor.Fields[I].Value := FLockCursor.Fields[I].Value;
      break;
    end;
  end;
end;

procedure TCommonServerDataSet.InternalFirst;
begin
  if not FRecordSet.BOF then
  begin
    FRecordset.MoveFirst;
    if FRecordset.Supports(adMovePrevious) and not FRecordSet.BOF then
      FRecordset.MovePrevious;
  end;
end;

function TCommonServerDataSet.InternalGetRecord(Buffer: PChar; GetMode: TGetMode;
  DoCheck: Boolean): TGetResult;
begin
  try
    Result := grOK;
    case GetMode of
      gmNext:
        begin
          { Don't call MoveNext during open if no bookmark support }
          if (State <> dsInactive) or (BookmarkSize > 0) then
            if not RecordSet.Eof then FRecordset.MoveNext;
          if RecordSet.Eof then
            Result := grEOF;
          { This code blanks out the field values for active
            buffer on forward only recordsets. }
          if BookmarkSize = 0 then
            Finalize(PVariantList(ActiveBuffer+SizeOf(TRecInfo))^, Fields.Count);
        end;
      gmPrior:
        begin
          if not Recordset.BOF then FRecordset.MovePrevious;
          if Recordset.BOF then Result := grBOF;
        end;
      gmCurrent:
        begin
          if Recordset.BOF then Result := grBOF;
          if RecordSet.Eof then Result := grEOF;
        end;
    end;
    if Result = grOK then
    begin
      with PRecInfo(Buffer)^ do
      begin
        RecordStatus := FRecordset.Status;
        if (BookmarkSize > 0) and ((adRecDeleted and RecordStatus) = 0) then
        begin
          BookmarkFlag := bfCurrent;
          Bookmark := FRecordset.Bookmark;
          if ControlsDisabled then
            RecordNumber := -2 else
            RecordNumber := FRecordset.AbsolutePosition;
        end 
      end;
      Finalize(PVariantList(Buffer+SizeOf(TRecInfo))^, Fields.Count);
      GetCalcFields(Buffer);
    end;
  except
    if DoCheck then raise;
    Result := grError;
  end;
end;

procedure TCommonServerDataSet.InternalGotoBookmark(Bookmark: Pointer);
begin
  FRecordset.Bookmark := POleVariant(Bookmark)^;
end;

procedure TCommonServerDataSet.InternalHandleException;
begin
  ApplicationHandleException(Self);
end;

procedure TCommonServerDataSet.InternalInitFieldDefs;
const
  SIsAutoInc: WideString = 'ISAUTOINCREMENT'; { do not localize }
var
  HasAutoIncProp: Boolean;

  { Determine if the field's property list contains an ISAUTOINCREMENT entry }
  procedure AddFieldDef(F: OleVariant; FieldDefs: TFieldDefs);
  var
    FieldType: TFieldType;
    FieldDef: TFieldDef;
    I: Integer;
    FName: string;
    FSize: Integer;
    FPrecision: Integer;
  begin
    FieldType := ADOTypeToFieldType(F.Type, false);
    if FieldType <> ftUnknown then
    begin
      FSize := 0;
      FPrecision := 0;
      FieldDef := FieldDefs.AddFieldDef;
      with FieldDef do
      begin
        FieldNo := FieldDefs.Count;
        I := 0;
        FName := F.Name;
        while (FName = '') or (FieldDefs.IndexOf(FName) >= 0) do
        begin
          Inc(I);
          if F.Name = '' then
            FName := Format('COLUMN%d', [I]) else { Do not localize }
            FName := Format('%s_%d', [F.Name, I]);
        end;
        Name := FName;
        if (F.Type = adNumeric) and (F.NumericScale = 0) and
           (F.Precision < 10) then
          FieldType := ftInteger;
        case FieldType of
          ftString, ftWideString, ftBytes, ftVarBytes, ftFixedChar:
            FSize := F.DefinedSize;
          ftBCD:
            begin
              FPrecision := F.Precision;
              FSize := ShortInt(F.NumericScale);
              if FSize < 0 then FSize := 4;
            end;
          ftInteger:
            if HasAutoIncProp and (F.Properties[SIsAutoInc].Value = True) then
              FieldType := ftAutoInc;
          ftGuid:
            FSize := 38;
        end;

        if ((adFldRowID and F.Attributes) <> 0) then
           Attributes := Attributes + [faHiddenCol];
        if ((adFldFixed and F.Attributes) <> 0) then
           Attributes := Attributes + [faFixed];
        if (((adFldUpdatable+adFldUnknownUpdatable) and F.Attributes) = 0) or
           (FieldType = ftAutoInc) then
          Attributes := Attributes + [DB.faReadonly];
        DataType := FieldType;
        Size := FSize;
        Precision := FPrecision;
        if (DataType = ftDataSet) and (Fields.Count = 0) then
          ObjectView := True;
      end;
    end;
  end;

var
  Count, I: Integer;
begin
  FieldDefs.Clear;
  Count := FRecordset.Fields.Count;
  for I := 0 to Count - 1 do
    AddFieldDef(FRecordset.Fields[I], FieldDefs);
end;

procedure TCommonServerDataSet.InternalInitRecord(Buffer: PChar);
var
  I: Integer;
begin
  for I := 0 to Fields.Count - 1 do
    PVariantList(Buffer+SizeOf(TRecInfo))[I] := Null;
end;

procedure TCommonServerDataSet.InternalInsert;
begin
  FModifiedFields.Clear;
end;

procedure TCommonServerDataSet.InternalLast;
begin
  if not RecordSet.Eof then
  begin
    FRecordset.MoveLast;
    if not RecordSet.Eof then
      FRecordset.MoveNext;
  end;
end;

procedure TCommonServerDataSet.InternalOpen;
begin
  if not varIsEmpty(FRecordset) then
  begin
    SetUniDirectional(false);
    if FRecordset.Supports(adBookmark) then
      BookmarkSize := SizeOf(OleVariant) else
    BookmarkSize := 0;
    FieldDefs.Updated := False;
    FieldDefs.Update;
    CreateFields;
    BindFields(True);
    FRecBufSize := SizeOf(TRecInfo) + (Fields.Count * SizeOf(OleVariant));
  end;
end;

procedure TCommonServerDataSet.InternalPost;
var iResult: integer;
    st: TSourceType;
    vFields: variant;
    vTranFields, vTranValues: OleVariant;

  procedure UpdateData;
  var
    I: Integer;
    FieldData: PVariantList;
    Data: OleVariant;
  begin
    try
      FieldData := PVariantList(ActiveBuffer + SizeOf(TRecInfo));
      for I := 0 to FModifiedFields.Count - 1 do
        with TField(FModifiedFields[I]) do
        begin
          Data := FieldData[Index];
          if not VarIsClear(Data) and
             (((adFldUpdatable+adFldUnknownUpdatable) and
             FRecordset.Fields[FieldNo-1].Attributes) <> 0) then
            FRecordset.Fields[FieldNo-1].Value := Data;
        end;
      if (FRecordset.EditMode * (adEditInProgress + adEditAdd)) <> 0 then
        FRecordset.Update(EmptyParam, EmptyParam);
      ReleaseLock;
    except
      CursorPosChanged;
      FRecordset.CancelUpdate;
      raise;
    end;
  end;

  procedure CheckForFlyAway;
  begin
    if BookmarkSize > 0 then
    try
      { Check for fly away }
      FRecordset.Bookmark := FRecordset.Bookmark;
      if RecordSet.Eof  or Recordset.BOF  then
      begin
        { If recordset is empty, then this prevents an error calling InternalFirst }
        if not Recordset.BOF  and FRecordset.Supports(adMovePrevious) then
          FRecordset.MovePrevious;
        { Reposition to last record we were on }
        CursorPosChanged;
        UpdateCursorPos;
      end;
    except
      CursorPosChanged;
    end;
  end;

begin
  inherited;
  UpdateCursorPos;
  try
    iResult := -1;
    st := GetSourceType(DataPostString);
    // если это было редактирование - пытаемся редактировать
    if State = dsEdit then
    begin
      // обновляем записи по фильтру
      //if AutoRefresh then DoBeforeAutoRefresh;

      if st = stTable then
        iResult := Server.UpdateRow(DataPostString, CurrentRecordModifiedNames, CurrentRecordModifiedValues, CurrentRecordFilter)
      else if st = stProc then
      begin
        if (soKeyInsert in Options) or (soPartialFilling in Options) then
        begin
          iResult := Server.SelectRows(DataPostString, varArrayOf(['*']), '', CurrentRecordValues);
          if iResult >= 0 then
          begin
            if UpdatableFieldNames = '' then
              CurrentRecordFilterValues := Server.QueryResult
            else
              CurrentRecordUpdatableValues := Server.QueryResult
          end;
        end
        else iResult := Server.InsertRow(DataPostString, CurrentRecordNames, CurrentRecordValues);
      end
      else if st = stNone then
        iResult := 0;

      if iResult >= 0 then UpdateData;

      // обновляем записи по фильтру
      if AutoRefresh then DoAutoRefresh;
    end
    else
    begin
      if st = stTable then
      begin
        if soKeyInsert in Options then
        begin
          iResult := Server.InsertKeyRow(DataPostString, CurrentRecordModifiedNames, CurrentRecordModifiedValues);
          if iResult >= 0 then
            CurrentRecordFilterValues := varArrayOf([Server.QueryResult]);
        end
        else
        begin
          vTranFields := CurrentRecordModifiedNames;
          vTranValues := CurrentRecordModifiedValues;
          iResult := Server.InsertRow(DataPostString, vTranFields, vTranValues);


          if (soGetKeyValue in Options) and (iResult >= 0) then
          begin
            if pos(';', KeyFieldNames) = 0 then
              iResult := Server.ExecuteQuery('select max(' + KeyFieldNames + ') from ' + DataPostString)
            else
              iResult := Server.ExecuteQuery('select max(' + copy(KeyFieldNames, 1, Pos(';', KeyFieldNames) - 1) + ') from ' + DataPostString);
            CurrentRecordFilterValues := Server.QueryResult;
          end;
        end;
      end
      else if st = stProc then
      begin
        if (soKeyInsert in Options) or (soPartialFilling in Options) then
        begin
          iResult := Server.SelectRows(DataPostString, varArrayOf(['*']), '', CurrentRecordValues);
          //iResult := Server.InsertRow(DataPostString, varArrayOf(['*']), '', CurrentRecordValues);
          if iResult >= 0 then
          begin
            if UpdatableFieldNames = '' then
              CurrentRecordFilterValues := Server.QueryResult
            else
              CurrentRecordUpdatableValues := Server.QueryResult
          end;
        end
        else iResult := Server.InsertRow(DataPostString, CurrentRecordNames, CurrentRecordValues);
      end
      else if st = stNone then
        iResult := 0;


      if (iResult >= 0) then
      begin
        FRecordset.AddNew(EmptyParam, EmptyParam);

        if soPartialFilling in Options then
        begin
          FRecordsLoaded := FRecordsLoaded + 1;
          GeneralRecordCount := GeneralRecordCount + 1;
        end;

        try
          UpdateData;
        except
          { When appending recordset may be left in an invalid state, reset it }
          if RecordSet.Eof and Recordset.BOF and (FRecordset.RecordCount > 0) and EOF then
            FRecordset.MoveLast;
          raise;
        end;
      end
      else
        DatabaseError('Ошибка добавления(редакции) данных. Код ошибки '+ IntToStr(iResult));
    end;
  except
    on E: Exception do
      DatabaseError(E.Message);
  end;
  CheckForFlyAway;
  LastResult := iResult;
end;

procedure TCommonServerDataSet.InternalRefresh;
begin
  InternalRequery;
end;

procedure TCommonServerDataSet.InternalRequery(Options: TExecuteOptions);
var RL: integer;
begin
  RL := 0;
  try
    if soPartialFilling in Self.Options then
    begin
      RL := FRecordsLoaded;
      FRecordsLoaded := 0;
    end;

    FModifiedFields.Clear;

    Close;
    //if TMainFacade.GetInstance.AllDocuments.count <> 0 then
    FRecordsLoaded := RL; // - PageSize;
    Open;

  except
    if FRecordset.State = adStateClosed then Close;
    raise;
  end;
  DestroyLookupCursor;
end;

procedure TCommonServerDataSet.InternalSetSort(Value: WideString);
begin
  FRecordset.Sort := Value;
end;

procedure TCommonServerDataSet.InternalSetToRecord(Buffer: PChar);
begin
  if PRecInfo(Buffer)^.BookmarkFlag in [bfCurrent, bfInserted] then
    InternalGotoBookmark(@PRecInfo(Buffer)^.Bookmark);
end;

function TCommonServerDataSet.IsCursorOpen: Boolean;
begin
  Result := not varIsEmpty(FRecordSet);
end;

function TCommonServerDataSet.IsSequenced: Boolean;
begin
  Result := not varIsEmpty(FRecordSet) and FRecordset.Supports(adApproxPosition) and not Filtered;
end;

procedure TCommonServerDataSet.Loaded;
begin
  try
    inherited Loaded;
  except

  end;
end;


procedure TCommonServerDataSet.LoadFromFile(AFileName, ADelimiter, AFields: string);
var i, j: integer;
    lst: TStringList;
    vFields, vRow: variant;
    iFieldCount: integer;
    f: TField;
begin
  // грузим из файла только выбранные поля
  // и постим их в соответствующий датасет
  First;
  vFields := Split(AFields, ',');
  iFieldCount := varArrayHighBound(vFields, 1);


  lst := TStringList.Create;
  lst.LoadFromFile(AFileName);

  for i := 0 to lst.Count - 1 do
  begin
    vRow := Split(lst[i], ADelimiter[1]);
    // добавляем запись соответствующую строке
    Append;

    for  j := 0 to iFieldCount do
    begin
      f := FieldByName(vFields[j]);
      if not ((f.DataType <> ftString) and (trim(varAsType(vRow[j], varOleStr)) = '')) then
        f.Value := trim(vRow[j])
      else
        f.Value := null;
    end;
    // сохраняем запись
    Post;
  end;

  lst.Free;
end;

function TCommonServerDataSet.Locate(const KeyFields: string; const KeyValues: Variant;
  Options: TLocateOptions): Boolean;
var sFilter: string;
begin
  Result := false;
  try
    DoBeforeScroll;
    Result := LocateRecord(KeyFields, KeyValues, Options, True);
    if Result then
    begin
      Resync([rmExact, rmCenter]);
      DoAfterScroll;
    end
    else
    if (soPartialFilling in Self.Options) then
    begin
      sFilter := MakeFilter(KeyFields, KeyValues);
      FetchByQuery(sFilter);
      FetchNext;
      Result := LocateRecord(KeyFields, KeyValues, Options, True);
      if Result then
      begin
        Resync([rmExact, rmCenter]);
        DoAfterScroll;
      end
    end;
  except
    on E: Exception do
    begin
      //
    end;
  end;  
end;

function TCommonServerDataSet.LocateRecord(const KeyFields: string;
  const KeyValues: OleVariant; Options: TLocateOptions;
  SyncCursor: Boolean): Boolean;
var
  Fields: TList;
  Buffer: PChar;
  I, FieldCount: Integer;
  Partial: Boolean;
  SortList, FieldExpr, LocateFilter: string;
begin
  CheckBrowseMode;
  UpdateCursorPos;
  CursorPosChanged;
  Buffer := TempBuffer;
  Partial := loPartialKey in Options;
  Fields := TList.Create;
  DoBeforeScroll;
  try
    try
      GetFieldList(Fields, KeyFields);

      FLookupCursor := null;
      FLookupCursor := FRecordset.Clone(adLockReadOnly);

      //FLookupCursor := FRecordSet;

      for I := 0 to Fields.Count - 1 do
      with TField(Fields[I]) do
      if Pos(' ', FieldName) > 0 then
        SortList := Format('%s[%s],', [SortList, FieldName]) else

      SortList := Format('%s%s,', [SortList, FieldName]);
      SetLength(SortList, Length(SortList)-1);
      if FLookupCursor.Sort <> SortList then
        FLookupCursor.Sort := SortList;
      FLookupCursor.Filter := '';
      FFilterBuffer := Buffer;
      SetTempState(dsFilter);
      try
        InitRecord(Buffer);
        FieldCount := Fields.Count;
        if FieldCount = 1 then
        begin
          FLookupCursor.Filter := GetFilterStr(FieldByName(KeyFields), KeyValues, Partial);//LocateFilter;
          //FLookupCursor.Find(GetFilterStr(FieldByName(KeyFields), KeyValues, Partial), 0,
          // adSearchForward, EmptyParam)
        end
        else
        begin
          for I := 0 to FieldCount - 1 do
          begin                         
            FieldExpr := GetFilterStr(Fields[I], KeyValues[I], (Partial and (I = FieldCount-1)));
            if LocateFilter <> '' then
              LocateFilter := LocateFilter + ' AND ' + FieldExpr else    { Do not localize }
              LocateFilter := FieldExpr;
          end;
          FLookupCursor.Filter := LocateFilter;
        end;
      finally
        RestoreState(dsBrowse);
      end;
    finally
      Fields.Free;
    end;
    Result := not FLookupCursor.EOF;
    if Result then
    if SyncCursor then
    begin
      FRecordset.Bookmark := FLookupCursor.Bookmark;
      if RecordSet.Eof or Recordset.BOF then
      begin
        Result := False;
        CursorPosChanged;
      end
    end
    else
      { For lookups, read all field values into the temp buffer }
      for I := 0 to Self.Fields.Count - 1 do
      with Self.Fields[I] do
      if FieldKind = fkData then
        PVariantList(Buffer+SizeOf(TRecInfo))[Index] := FLookupCursor.Fields[FieldNo-1].Value;
  except
    Result := False;
  end;
end;


function TCommonServerDataSet.Lookup(const KeyFields: string; const KeyValues: Variant;
  const ResultFields: string): Variant;
var sFilter: string;
begin
  Result := Null;
  if LocateRecord(KeyFields, KeyValues, [], False) then
  begin
    SetTempState(dsCalcFields);
    try
      CalculateFields(TempBuffer);
      Result := FieldValues[ResultFields];
    finally
      RestoreState(dsBrowse);
    end;
  end
  else
  if (soPartialFilling in Self.Options) then
  begin
    sFilter := MakeFilter(KeyFields, KeyValues);
    FetchByQuery(sFilter);
    FetchNext;
    if LocateRecord(KeyFields, KeyValues, [], True) then
    begin
      SetTempState(dsCalcFields);
      try
        CalculateFields(TempBuffer);
        Result := FieldValues[ResultFields];
      finally
        RestoreState(dsBrowse);
      end;
    end
  end;
end;


function TCommonServerDataSet.MakeHeader: integer;
var i, iResult: integer;
    vResult: OleVariant;
begin
  // выбираем названия полей из таблицы атрибутов
  // заодно назначаем насильственно точность для полей с плавающей точкой
  Result := 0;
  try
    for i := 0 to Fields.Count - 1 do
    begin
      iResult := Server.ExecuteQuery('select distinct vch_Rus_Attribute_Name from tbl_Attribute where vch_Attribute_Name = ' + '''' + Fields[i].FieldName + '''');

      if iResult > 0 then
      begin
        vResult := Server.QueryResult;
        if trim(varAsType(vResult[0, 0], varOleStr)) <> '' then
          Fields[i].DisplayLabel := vResult[0, 0];

        if Fields[i] is TFloatField then
          (Fields[i] as TFloatField).DisplayFormat := '#.###';
      end;
    end
  except
    Result := -1;
  end;
end;

procedure TCommonServerDataSet.MakeList(ALst: TStringList; AKeyFieldName,
  AListFieldName: string);
var i, iResult, iID: integer;
    vResult: variant;
begin
  ALst.Clear;
  iResult := Server.ExecuteQuery('select distinct ' + AkeyFieldName + ', ' + AListFieldName + ' from ' + DataSourceString);

  if iResult > 0 then
  begin
    vResult := Server.QueryResult;

    for i := 0 to iResult - 1 do
    begin
      iID := vResult[0, i];
      ALst.AddObject(vResult[1, i], TObject(iID));
    end;
  end;
end;

procedure TCommonServerDataSet.OpenCursor(InfoQuery: Boolean);
var iResult: integer;
begin
  GetGeneralRecordCount;
  Server.NeedADORecordset := true;
  iResult := Server.ExecuteQuery(SelectQuery['']);
  if iResult >= 0 then
  //if iResult > 0 then
  begin
    FRecordSet := Server.QueryResultAsADORecordSet;

    if iResult <> 0 then FRecordSet.MoveFirst;

    {if trim(FSort) <> '' then
      FRecordSet.Sort := FSort;}

    FRecordsLoaded := FRecordsLoaded + iResult;
  end;

{  if varIsEmpty(FRecordSet) or (RecordsToLoad > 0) then
  begin
    Server.NeedADORecordset := true;
    iResult := Server.ExecuteQuery(SelectQuery);
    if iResult > 0 then
    begin
      if RecordsToLoad = 0 then
      begin
        FRecordSet := Server.QueryResultAsADORecordSet;
        FRecordsLoaded := iResult
      end
      else
      begin
        if varIsEmpty(FRecordSet) then
          FRecordSet := Server.QueryResultAsADORecordSet
        else
        begin
          rs := Server.QueryResultAsADORecordSet;
          rs.MoveFirst;
          fv := varArrayCreate([0, rs.Fields.Count - 1], varVariant);
          ff := varArrayCreate([0, rs.Fields.Count - 1], varVariant);
          for i := 0 to rs.RecordCount - 1 do
          begin
            for j := 0 to rs.Fields.Count - 1 do
            begin
              fv[j] := rs.Fields[j].Value;
              ff[j] := rs.Fields[j].Name;
            end;
            FRecordSet.AddNew(ff, fv);
            rs.MoveNext;
          end;
          FRecordsLoaded := FRecordsLoaded + iResult;
        end;
      end;
    end;
  end;                        }

  inherited OpenCursor(False);
  MakeHeader;


  if Assigned(FFilterFields) then FFilterFields.Free;
  FFilterFields := TFilterFields.Create(Self);
  LastResult := iResult;
end;


procedure TCommonServerDataSet.Post;
begin
  if not (((State = dsInsert) and (soNoInsert in Options)) or
          ((State = dsEdit) and (soNoUpdate in Options))) then
    inherited
  else Cancel;
end;

procedure TCommonServerDataSet.ReleaseLock;
begin
  if not varIsEmpty(FLockCursor) then
  begin
    FLockCursor.CancelUpdate;
    varClear(FLockCursor);
  end;
end;


procedure TCommonServerDataSet.Requery(Options: TExecuteOptions);
begin
  CheckBrowseMode;
  InternalRequery(Options);
  First;
end;


procedure TCommonServerDataSet.SaveToFile(AFileName, ADelimiter: string; AFields: string);
var i: integer;
    s: string;
    lst: TStringList;
    vFields: variant;
    iFieldCount: integer;
begin
  if RecordCount > 0 then
  begin
    First;
    lst := TStringList.Create;
    vFields := Split(AFields, ',');
    iFieldCount := varArrayHighBound(vFields, 1);

    while not Eof do
    begin
      s := '';
      for i := 0 to iFieldCount do
        s := s + FieldByName(trim(varAsType(vFields[i], varOleStr))).AsString + ADelimiter + ' ';

      lst.Add(s);
      Next;
    end;

    lst.SaveToFile(AFileName);
    lst.Free;
  end;
end;

function TCommonServerDataSet.Seek(const KeyValues: Variant;
  SeekOption: TSeekOption): Boolean;
begin
  DoBeforeScroll;
  CheckBrowseMode;
  try
    FRecordset.Seek(KeyValues, SeekOptionValues[SeekOption]);
    Result := not RecordSet.Eof;
  except
    Result := False;
  end;
  if Result then
  begin
    Resync([rmExact, rmCenter]);
    DoAfterScroll;
  end else
    CursorPosChanged;
end;

procedure TCommonServerDataSet.SetBaseFilter(const Value: string);
begin
  if FBaseFilter <> Value then
  begin
    FBaseFilter := Value;
    FFilterChanged := true;
  end;
  Filter := FBaseFilter;
end;

procedure TCommonServerDataSet.SetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  if Assigned(Data) then
    PRecInfo(Buffer).Bookmark := POleVariant(Data)^ else
    PRecInfo(Buffer).BookmarkFlag := bfNA;
end;

procedure TCommonServerDataSet.SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag);
begin
  PRecInfo(Buffer).BookmarkFlag := Value;
end;

procedure TCommonServerDataSet.SetCacheSize(const Value: Integer);
begin
  FCacheSize := Value;
  if not varIsEmpty(Recordset) then
    FRecordset.CacheSize := FCacheSize;
end;

procedure TCommonServerDataSet.SetCommonSource(ASourceName: string);
begin
  FDataSourceName := ASourceName;
  FDataDeletionString := ASourceName;
  FDataPostString := ASourceName;
end;

procedure TCommonServerDataSet.SetCurrentRecordRecordFilterValues(
  const Value: variant);
var i: integer;
    fl: TObjectList;
begin
  fl := TObjectList.Create(true);
  GetFieldList(fl, KeyFieldNames);

  case varArrayDimCount(Value) of
  1:
    begin
      for i := 0 to varArrayHighBound(Value, 1) do
        FieldByName(TField(fl.Items[i]).FieldName).Value := Value[i];
    end;
  2:
    begin
      for i := 0 to varArrayHighBound(Value, 1) do
        FieldByName(TField(fl.Items[i]).FieldName).Value := Value[i, 0];
    end;
  end;


//  fl.Free;
end;

procedure TCommonServerDataSet.SetCurrentRecordUpdatableValues(
  Value: variant);
var i: integer;
    fl: TObjectList;
begin
  fl := TObjectList.Create(true);
  GetFieldList(fl, UpdatableFieldNames);

  case varArrayDimCount(Value) of
  1:
    begin
      for i := 0 to varArrayHighBound(Value, 1) do
        FieldByName(TField(fl.Items[i]).FieldName).Value := Value[i];
    end;
  2:
    begin
      for i := 0 to varArrayHighBound(Value, 1) do
        FieldByName(TField(fl.Items[i]).FieldName).Value := Value[i, 0];
    end;
  end;


//  fl.Free;
end;


procedure TCommonServerDataSet.SetDataDeletionString(const Value: string);
begin
  if FDataDeletionString <> Value then
  begin
    FDataDeletionString := Value;
    if soSingleDataSource in Options then
      SetCommonSource(Value);
  end;
end;

procedure TCommonServerDataSet.SetDataPostString(const Value: string);
begin
  if FDataPostString <> Value then
  begin
    FDataPostString := Value;
    if soSingleDataSource in Options then
      SetCommonSource(Value);
  end;
end;

procedure TCommonServerDataSet.SetDataSourceName(const Value: string);
begin
  if FDataSourceName <> Value then
  begin
    FDataSourceName := Value;
    if soSingleDataSource in Options then
      SetCommonSource(Value);
  end;
end;

procedure TCommonServerDataSet.SetFieldData(Field: TField; Buffer: Pointer;
  NativeFormat: Boolean);

  procedure BufferToVar(var Data: OleVariant);
  begin
    case Field.DataType of
      ftString, ftFixedChar, ftGuid:
        Data := WideString(PChar(Buffer));
      ftWideString:
        Data := WideString(Buffer^);
      ftAutoInc, ftInteger:
        Data := LongInt(Buffer^);
      ftSmallInt:
        Data := SmallInt(Buffer^);
      ftWord:
        Data := Word(Buffer^);
      ftBoolean:
        Data := WordBool(Buffer^);
      ftFloat, ftCurrency:
        Data := Double(Buffer^);
      ftBlob, ftMemo, ftGraphic, ftVariant:
        Data := Variant(Buffer^);
      ftInterface:
        Data := IUnknown(Buffer^);
      ftIDispatch:
        Data := IDispatch(Buffer^);
      ftDate, ftTime, ftDateTime:
        if NativeFormat then
          DataConvert(Field, Buffer, @TVarData(Data).VDate, False) else
          Data := TDateTime(Buffer^);
      ftBCD:
        if NativeFormat then
          DataConvert(Field, Buffer, @TVarData(Data).VCurrency, False) else
          Data := Currency(Buffer^);
      ftBytes, ftVarBytes:
        if NativeFormat then
          DataConvert(Field, Buffer, @Data, False) else
          Data := OleVariant(Buffer^);
      ftLargeInt:
        Data := LargeInt(Buffer^);
      else
        DatabaseErrorFmt('Тип поля не поддерживается', [FieldTypeNames[Field.DataType],
          Field.DisplayName]);
    end;
  end;

var
  Data: OleVariant;
  RecBuf: PChar;
begin
  with Field do
  begin
    if not (State in dsWriteModes) then DatabaseError('Поле не редактируемое', Self);
    GetActiveRecBuf(RecBuf);

    if FieldNo > 0 then
    begin
      if ReadOnly and not (State in [dsSetKey, dsFilter]) then
        DatabaseErrorFmt('Поле только для чтения', [DisplayName]);
      Validate(Buffer);
      if FModifiedFields.IndexOf(Field) = -1 then
        FModifiedFields.Add(Field);
    end;
    if Buffer = nil then
      Data := Null else
      BufferToVar(Data);

    if RecBuf = nil then RecBuf := ActiveBuffer; 
    PVariantList(RecBuf+SizeOf(TRecInfo))[Field.Index] := Data;
    if not (State in [dsCalcFields, dsInternalCalc, dsFilter, dsNewValue]) then
      DataEvent(deFieldChange, Longint(Field));
  end;
end;

procedure TCommonServerDataSet.SetFieldData(Field: TField; Buffer: Pointer);
begin
  SetFieldData(Field, Buffer, True);
end;

procedure TCommonServerDataSet.SetFiltered(Value: Boolean);
begin
  if Filtered <> Value then
  begin
    if Active then
    begin
      CheckBrowseMode;
      DestroyLookupCursor;
      if Value then
      begin
        if FFilterGroup <> fgUnassigned then
          FRecordset.Filter := Integer(FilterGroupValues[FFilterGroup]) else
          ActivateTextFilter(Filter)
      end
      else
        DeactivateFilters;
      inherited SetFiltered(Value);
      First;
    end else
      inherited SetFiltered(Value);
  end;
end;

procedure TCommonServerDataSet.SetFilterGroup(const Value: TFilterGroup);
begin
  CheckBrowseMode;
  inherited SetFilterText('');
  FFilterGroup := Value;
  if (FFilterGroup <> fgUnassigned) and Filtered then
  begin
    FRecordset.Filter := Integer(FilterGroupValues[FFilterGroup]);
    First;
  end;
end;

procedure TCommonServerDataSet.SetFilterOptions(Value: TFilterOptions);
begin
  if Value <> [] then
    DatabaseError('Не установлены опции фильтрации');
end;

procedure TCommonServerDataSet.SetFilterText(const Value: string);
begin
  if (Filter <> Value) then
  begin
    if Active and Filtered then
    begin
      CheckBrowseMode;
      if Value <> '' then
        ActivateTextFilter(Value) else
        DeactivateFilters;
      DestroyLookupCursor;
      First;
    end;

    FFilterChanged := true;
    if (Value <> BaseFilter) and (trim(BaseFilter) <> '') then
    begin
      if trim(Value) <> '' then
        inherited SetFilterText(BaseFilter + ' and ' + '(' + Value + ')')
      else
        inherited SetFilterText(BaseFilter);      
    end
    else
      inherited SetFilterText(Value);
    FFilterGroup := fgUnassigned;
  end;
end;




procedure TCommonServerDataSet.SetMaxRecords(const Value: Integer);
begin
  if MaxRecords <> Value then
  begin
    CheckInactive;
    FMaxRecords := Value;
  end;
end;





procedure TCommonServerDataSet.SetRecNo(Value: Integer);
begin
  if RecNo <> Value then
  begin
    DoBeforeScroll;
    FRecordset.AbsolutePosition := Value;
    Resync([rmCenter]);
    DoAfterScroll;
  end;
end;



procedure TCommonServerDataSet.SetRecordset(const Value: OleVariant);
begin
  Close;
  if Not VarIsEmpty(Value) then
  try
    if (Value.State and adStateOpen) = 0 then
      DatabaseError('Набор данных не открыт', Self);
    FRecordset := Value;
    Open;
  except
    Close;
    raise;
  end;
end;

procedure TCommonServerDataSet.SetServer(const Value: OleVariant);
begin
  FServer := Value;
  FDistinctDataSets.FServer := FServer;
end;

procedure TCommonServerDataSet.SetSort(const Value: WideString);
begin
  if FSort <> Value then
  begin
    FSort := Value;

    if Active then
    begin
      UpdateCursorPos;
      if not (soPartialFilling in Options) then
        InternalSetSort(Value)
      else
      begin
        Requery;
        InternalSetSort(StringReplace(Value, DataSourceString + '.', '', [rfReplaceAll, rfIgnoreCase]));
      end;

      Resync([]);
    end;
  end;
end;

function TCommonServerDataSet.Supports(CursorOptions: TCursorOptions): Boolean;
var
  Opt: TCursorOption;
  Options: TOleEnum;
begin
  CheckActive;
  begin
    Options := 0;
    for Opt := Low(TCursorOption) to High(TCursorOption) do
      if Opt in CursorOptions then
        Options := Options + CursorOptionValues[Opt];
    Result := Recordset.Supports(Options);
  end;
end;

procedure TCommonServerDataSet.UpdateBatch(AffectRecords: TAffectRecords);
begin
  CheckBrowseMode;
  FRecordset.UpdateBatch(AffectRecordsValues[AffectRecords]);
  UpdateCursorPos;
  Resync([]);
end;

procedure TCommonServerDataSet.UpdateFields(UpdatableFields: string; AColumns: string; AFilterValues: variant);
var vResult: variant;
    vFields, vKeys: variant;
    i: integer;
    f: TField;
    sColumns, sFilter, sKeys: string;
begin
  sColumns := copy(UpdatableFields, 1, Length(UpdatableFields) - 1);
  sFilter := MakeFilter(AColumns, AFilterValues);

  i := FServer.ExecuteQuery('select ' + StringReplace(sColumns, ';', ',', [rfReplaceAll]) + ' from ' + DataSourceString + ' where ' + sFilter);

  if i >= 0 then
  begin
    vResult := FServer.QueryResult;

    vKeys := Split(AColumns, ';');
    sKeys := '';
    for i := 0 to varArrayHighBound(vKeys, 1) do
    begin
      f := FindField(vKeys[i]);
      if Assigned(f) then sKeys := sKeys + ';' + varAsType(vKeys[i], varOleStr);
    end;

    sKeys := copy(sKeys, 2, Length(sKeys));

    if AutoRefresh then
    begin
      RefreshKeys := sKeys;
      RefreshValues := AFilterValues;
      
      DoBeforeAutoRefresh;
    end;
    Locate(sKeys, AFilterValues, []);

    vFields := Split(UpdatableFields, ';');
    Edit;
    for i := 0 to varArrayHighBound(vFields, 1) do
    begin
      f := FindField(vFields[i]);
      if Assigned(f) then f.Value := vResult[i, 0];
    end;
    Post;
  end;
end;

procedure TCommonServerDataSet.UpdateRecordSetPosition(Buffer: PChar);
begin
  if (State <> dsCalcFields) and (BookmarkSize > 0)
  and ((TestBOF > 0) or (TestEOF > 0)
   or  ((TestBOF = 0) or (TestEOF = 0) and (RecordSet.Bookmark <> PRecInfo(Buffer)^.Bookmark))) then
  begin
    InternalSetToRecord(Buffer);
    CursorPosChanged;
  end;
end;

function TCommonServerDataSet.UpdateStatus: TUpdateStatus;
var
  RecordStatus: TRecordStatusSet;
begin
  RecordStatus := GetRecordStatus;
  if rsDeleted in RecordStatus then
    Result := usDeleted
  else if rsNew in RecordStatus then
    Result := usInserted
  else if rsModified in RecordStatus then
    Result := usModified
  else
    Result := usUnmodified;
end;

{ TPartialLoadingDataSet }

function TPartialLoadingDataSet.GetSelectQuery(const AFilter: string = ''): string;
begin
  if RecordsToLoad = 0 then
    Result := inherited GetSelectQuery
  else
    Result := 'select ' +
              ' first ' + IntToStr(RecordsToLoad) + ' skip ' + IntToStr(RecordsLoaded) + ' '  +
              FieldNames + ' from ' + DataSourceString
end;

procedure TPartialLoadingDataSet.OpenCursor(InfoQuery: Boolean);
var iResult: integer;
    rs, fv, ff: OleVariant;
    i, j: integer;
begin
  if varIsEmpty(FRecordSet) or (RecordsToLoad > 0) then
  begin
    if RecordsToLoad = 0 then inherited
    else
    begin
      Server.NeedADORecordset := true;
      iResult := Server.ExecuteQuery(SelectQuery['']);

      if iResult > 0 then
      begin
        if varIsEmpty(FRecordSet) then
          FRecordSet := Server.QueryResultAsADORecordSet
        else
        begin
          rs := Server.QueryResultAsADORecordSet;
          rs.MoveFirst;
          fv := varArrayCreate([0, rs.Fields.Count - 1], varVariant);
          ff := varArrayCreate([0, rs.Fields.Count - 1], varVariant);
          for i := 0 to rs.RecordCount - 1 do
          begin
            for j := 0 to rs.Fields.Count - 1 do
            begin
              fv[j] := rs.Fields[j].Value;
              ff[j] := rs.Fields[j].Name;
            end;
            FRecordSet.AddNew(ff, fv);
            rs.MoveNext;
          end;
          FRecordsLoaded := FRecordsLoaded + iResult;
        end;
      end;
      inherited OpenCursor(False);
    end;
  end;
end;


{ TCommonServerDataSets }

function TCommonServerDataSets.Add(
  ADataSet: TCommonServerDataSet): TCommonServerDataSet;
begin
  inherited Add(ADataSet);
  Result := ADataSet;
  Result.Server := Server;
end;

function TCommonServerDataSets.Add(
  ADataSetClass: TCommonServerDataSetClass): TCommonServerDataSet;
begin
  Result := ADataSetClass.Create(FOwner);
  Add(Result)
end;

constructor TCommonServerDataSets.Create(AOwner: TComponent);
begin
  inherited Create(true);
  FOwner := AOwner;

end;

destructor TCommonServerDataSets.Destroy;
begin
  inherited;
end;

function TCommonServerDataSets.GetDatasetByClassType(
  const AClassType: TCommonServerDataSetClass): TCommonServerDataSet;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].ClassType = AClassType then
  begin
    Result := Items[i];
    break;
  end;

  if not Assigned(Result) then
    Result := Add(AClassType);
end;

function TCommonServerDataSets.GetDatasetByIdent(
  const AIdent: string): TCommonServerDataSet;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if trim(UpperCase(Items[i].DatasetIdent)) <> trim(AnsiUpperCase(AIdent)) then
  begin
    Result := Items[i];
    break;
  end;
end;

function TCommonServerDataSets.GetDatasetByRusName(
  const ARusName: string): TCommonServerDataSet;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if trim(AnsiUpperCase(Items[i].RusName)) <> trim(AnsiUpperCase(ARusName)) then
  begin
    Result := Items[i];
    break;
  end;    
end;

function TCommonServerDataSets.GetDatasetBySourceName(
  const ASourceName: string): TCommonServerDataSet;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if trim(UpperCase(Items[i].DataSourceString)) = trim(AnsiUpperCase(ASourceName)) then
  begin
    Result := Items[i];
    break;
  end;
end;

function TCommonServerDataSets.GetItems(
  const Index: integer): TCommonServerDataSet;
begin
  Result := inherited Items[Index] as TCommonServerDataSet;
end;

function TCommonServerDataSets.GetServer: Variant;
begin
  if varIsEmpty(FServer) then
    FServer := InternalGetServer;

  Result := FServer
end;

function TCommonServerDataSets.InternalGetServer: variant;
begin
  Result := FServer;  
end;



{ TFilters }

function TFilters.Add: TFilter;
begin
  Result := TFilter.Create;
  inherited Add(Result);
  Result.FFilters := Self;
end;

constructor TFilters.Create(AField: TField);
begin
  inherited Create(true);
  FField := AField;
end;

destructor TFilters.Destroy;
begin

  inherited;
end;


function TFilters.GetItems(const Index: integer): TFilter;
begin
  Result := inherited Items[Index] as TFilter;
end;

{ TFilterField }

constructor TFilterField.Create(AField: TField);
begin
  inherited Create;

  FField := AField;
  FFilters := TFilters.Create(AField); 
end;

destructor TFilterField.Destroy;
begin
  FFilters.Free;
  inherited;
end;

function TFilterField.GetAppliedFilter: string;
var i: integer;
begin
  Result := '';
  for i := 0 to Filters.Count - 1 do
  if Filters.Items[i].StringValue <> '' then
  begin
    if i > 0 then
      Result := Result + AppendingOperation.Operation;


    Result := Result + '(' +
              (Field.DataSet as TCommonServerDataSet).DataSourceString +
              '.' + Field.FieldName +
              Filters.Items[i].Operation.Operation
              + Filters.Items[i].StringValue + ') '



  end
end;

{ TFilterFields }

function TFilterFields.Add(AField: TField): TFilterField;
begin
  Result := TFilterField.Create(AField);
  inherited Add(Result); 
end;

procedure TFilterFields.ClearFilters;
var i: integer;
begin
  for i := 0 to Count - 1 do
    Items[i].Filters.Clear; 
end;

constructor TFilterFields.Create(ADataSet: TCommonServerDataSet);
var i: integer;
begin
  inherited Create;


  for i := 0 to ADataSet.Fields.Count - 1 do
    Add(ADataSet.Fields[i]);
end;

destructor TFilterFields.Destroy;
begin

  inherited;
end;

function TFilterFields.GetAppliedFilter: string;
var i, j: integer;
    sFilter: string;
begin
  Result := '';
  j := 0;
  for i := 0 to Count - 1 do
  begin
    sFilter := Items[i].AppliedFilter;
    if sFilter <> '' then
    begin
      if j > 0 then
      begin
        if Assigned(AppendingOperation) then
          Result := Result + AppendingOperation.Operation
        else
          Result := Result + ' or ';
      end;
        
      Result := Result + '(' + sFilter + ') ';
      j := j + 1;
    end
  end;
end;

function TFilterFields.GetFilterFieldsByFieldName(
  const AFieldName: string): TFilterField;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if AnsiUpperCase(Items[i].Field.FieldName) = AnsiUpperCase(AFieldName) then 
  begin
    Result := Items[i];
    break;
  end;
end;

function TFilterFields.GetItems(Index: integer): TFilterField;
begin
  Result := inherited Items[Index] as TFilterField;
end;

{ TCompareOperation }

constructor TCompareOperation.Create;
begin
  inherited;
end;

{ TConcreteCompareOperations }



{ TFilter }

function TFilter.GetStringValue: string;
begin
  if not(varIsEmpty(FilterValue) or varIsNull(FilterValue)) then
  begin
    if trim(varAsType(FilterValue, varOleStr)) <> '' then
    begin
      if not Owner.Field.Lookup then
        if not(Owner.Field.DataType in [ftString, ftDate, ftTimeStamp, ftWideString]) then
          Result := varAsType(FilterValue, varOleStr)
        else
          Result := '''' + varAsType(FilterValue, varOleStr) + ''''
      else
        Result := varAsType(FilterValue, varOleStr);
    end
    else Result := '''' + '' + '''';
  end
  else Result := '';
end;


procedure TFilter.SetFilterValue(const Value: variant);
var v: Variant;
begin
  if FFilterValue <> Value then
  begin
    FFilterValue := Value;
    if Owner.Field.Lookup then
    begin
      v := Owner.Field.LookupDataSet.Lookup(Owner.Field.LookupResultField, FFilterValue, Owner.Field.LookupKeyFields);
      FFilterValue := v
    end;
  end;
end;

{ TExtensionGroup }


{ TListParamAddition }

constructor TListParamAddition.Create(AOwner: TListParamAdditions;
                                      ADataSet: TCommonServerDataSet;
                                      AParamName, AListColumns,
                                      AListFilter, AListOrder: string);
begin
  inherited Create;
  FOwner := AOwner;
  FParamName := trim(AParamName);
  FCommonServerDataSet := ADataSet;
  FListColumns := trim(AListColumns);
  FListFilter := trim(AListFilter);
  FListOrder := trim(AListOrder);
end;


destructor TListParamAddition.Destroy;
begin
  FStrings.Free;
  inherited;
end;



{ TListParamAdditions }

function TListParamAdditions.Add(ADataSet: TCommonServerDataSet; AParamName, AListColumns,
  AListFilter, AListOrder: string): TListParamAddition;
begin
  Result := TListParamAddition.Create(Self, ADataSet, AParamName, AListColumns, AListFilter, AListOrder);
  inherited Add(Result);
end;

constructor TListParamAdditions.Create;
begin
  inherited Create(true);
end;

destructor TListParamAdditions.Destroy;
begin

  inherited;
end;

function TListParamAdditions.GetItems(
  const Index: integer): TListParamAddition;
begin
  Result := inherited Items[Index] as TListParamAddition;
end;

function TListParamAdditions.GetParamByName(
  const ParamName: string): TListParamAddition;
var i: integer;
begin
  Result := nil;
  for  i := 0 to Count - 1 do
  if UpperCase(Items[i].ParamName) = UpperCase(ParamName) then
  begin
    Result := Items[i];
    break;
  end;
end;

{ TExtensionParam }

function TExtensionParam.GetDisplayName: string;
begin
  if trim(FDisplayName) <> '' then
    Result := FDisplayName
  else
    Result := inherited GetDisplayName;
end;

procedure TExtensionParam.SetDisplayName(const Value: string);
begin
  FDisplayName := Value;
  inherited;
end;

{ TExtensionParams }

constructor TExtensionParams.Create;
begin
  inherited Create(TExtensionParam);
end;

{ TDistinctDataSet }

constructor TDistinctDataSet.Create(AOwner: TComponent);
begin
  inherited;
end;

function TDistinctDataSet.GetCanModify: Boolean;
begin
  Result := false;
end;

function TDistinctDataSet.GetSelectQuery(const AFilter: string = ''): string;
begin
  Result := 'select ';

  if soPartialFilling in Options then
  begin
    Result := Result + ' first ' + IntToStr(PageSize);

    if Active then
      Result := Result + ' skip ' + IntToStr(RecordsLoaded) + ' '
    else
      Result := Result + ' skip 0 ';
  end;
  
  Result := Result + ' distinct ' + FieldNames + ' from ' + DataSourceString;

  if trim(FSort) <> '' then
    Result := Result + ' order by ' + FSort;
end;

{ TCommonDataSetFacade }

constructor TCommonDataSetFacade.Create(AOwner: TComponent);
begin
  inherited;

end;

{ TCSServerDataSets }

function TCSServerDataSets.InternalGetServer: variant;
begin
  Result := FServer;
end;

{ TSortField }

constructor TSortField.Create(AField: TField);
begin
  inherited Create;
  FFieldName := (AField.DataSet as TCommonServerDataSet).DataSourceString + '.' + AField.FieldName;
  FName := AField.FieldName;
end;

function TSortField.GetSortString(Full: boolean): string;
begin
  Result := '';
  if Full then
  begin
    case SortOrder of
      srtNone: Result := '';
      srtAsc: Result := FieldName + ' asc';
      srtDesc: Result := FieldName + ' desc';
    end;
  end
  else
  begin
    case SortOrder of
      srtNone: Result := '';
      srtAsc: Result := Name + ' asc';
      srtDesc: Result := Name + ' desc';
    end;
  end;
end;

procedure TSortField.SetSortOrder(const Value: TSortOrder);
begin
  if FSortOrder <> Value then
  begin
    FSortOrder := Value;
  end;
end;

{ TSortFields }

constructor TSortFields.Create(AOwner: TDataSet);
begin
  inherited Create(true);
  FOwner := AOwner;
  Reload;
end;

function TSortFields.GetFieldByName(AFieldName: string): TSortField;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if trim(AnsiUpperCase(AFieldName)) = trim(AnsiUpperCase(Items[i].Name)) then
  begin
    Result := Items[i];
    break;
  end;
end;

function TSortFields.GetItems(Index: integer): TSortField;
begin
  Result := inherited Items[Index] as TSortField;
end;

function TSortFields.GetSort(Full: boolean): string;
var i: integer;
begin
  Result := '';
  for i := 0 to Count - 1 do
  if Items[i].SortOrder <> srtNone then
    Result := Result + ', ' + Items[i].SortString[Full];

  if trim(Result) <> '' then
    Result := trim(copy(Result, 2, Length(Result)));
end;

procedure TSortFields.Reload;
var i: integer;
    sf: TSortField;
begin
  for i := 0 to Owner.FieldCount-1 do
  begin
    sf := FieldByName[Owner.Fields[i].FieldName];
    if not Assigned(sf) then
    begin
      sf := TSortField.Create(Owner.Fields[i]);
      sf.SortOrder := srtNone;
      Add(sf);
    end;
  end;
end;

{ TCommonServerFieldList }

function TCommonServerFieldList.Add(AFieldName: string): TField;
begin
  Result := FDataSet.FieldByName(AFieldName);
  inherited Add(Result);
end;

constructor TCommonServerFieldList.Create(ADataSet: TDataSet);
begin
  inherited Create(false);
  FDataSet := ADataSet;
end;

function TCommonServerFieldList.FieldByName(AFieldName: string): TField;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if UpperCase(Items[i].FieldName) = UpperCase(AFieldName) then
  begin
    Result := Items[i];
    break;
  end;
end;

function TCommonServerFieldList.GetItems(Index: integer): TField;
begin
  Result := inherited Items[Index] as TField;
end;


{ TBookmarks }

function TBookmarks.Add(ABookmark: TBookmark): integer;
begin
  Result := inherited Add(ABookmark);
end;

procedure TBookmarks.Clear;
var i: integer;
begin
  for i := Count - 1 downto 0 do
    Dispose(Items[i]);
end;

constructor TBookmarks.Create(ADataset: TDataSet);
begin
  inherited Create;
  FDataSet := ADataset;
end;

destructor TBookmarks.Destroy;
begin
  Clear;
  inherited;
end;

function TBookmarks.GetItems(Index: integer): TBookmark;
begin
  Result := TBookmark(inherited Items[Index]);
end;

function TBookmarks.MakeFilter: string;
var i: integer;
    f: TField;
    vKeyField: variant;
begin
  Result := '(';
  for i := 0 to Count - 1 do
  begin
    vKeyField := Split((FDataSet as TCommonServerDataSet).KeyFieldNames, ';');
    if varIsArray(vKeyField) then
      f := FDataSet.FieldByName(vKeyField[0])
    else
      f := FDataSet.FieldByName(vKeyField);

    if Assigned(f) then
    begin
      Result := (FDataSet as TCommonServerDataSet).DataSourceString + '.' + f.FieldName + ' in ' + '('; 

      if FDataSet.BookmarkValid(Items[i]) then
      begin
        FDataSet.BookMark := POleVariant(Items[i])^;
        Result := Result + f.AsString + ',';
      end;
    end;
  end;

  Result := copy(Result, 1, Length(Result) - 1);
  Result := Result + ')';
end;

procedure TCommonServerDataSet.DoAutoRefresh;
begin

end;

function  TCommonServerDataSet.DoBeforeAutoRefresh: boolean;
begin
  Result := true;
end;

function TCommonServerDataSet.AddNewField(
  AFieldClass: TFieldClass): TField;
begin
  Result := AFieldClass.Create(Self);
  Result.FieldName :=  GetFieldName;
  Result.DisplayLabel := Result.FieldName;
  Result.DataSet := Self;
end;

function TCommonServerDataSet.GetFieldName: string;
function MakeName(AFrom: integer): string;
begin
  Result := 'fld' + IntToStr(AFrom);

  if Assigned(FindField(Result)) then
    Result := MakeName(AFrom + 1);
end;
begin
  Result := MakeName(1);
end;

procedure TCommonServerDataSet.CreateFields;
begin
  inherited;

end;

function TCommonServerDataSet.GetDataSetClass: TCommonServerDataSetClass;
begin
  Result := TCommonServerDataSetClass(ClassType);
end;

function TCommonServerDataSet.Clone: TCommonServerDataSet;
begin
  Result:= DataSetClass.Create(Self);
  Result.Server := Server;
  if Active then Result.Open;
end;


function TCommonServerDataSet.TestQuery: integer;
begin
  Result := Server.ExecuteQuery(SelectQuery['']);
end;

function TCommonServerDataSet.MassUpdate(AFieldName, AValue: string;
  UpdateKind: TMassUpdateKind): integer;
begin
  Result := 0;
  if GetSourceType(DataPostString) = stTable then
  begin
    Result := Server.UpdateRow(DataPostString, varArrayOf([AFieldName]), varArrayOf([AValue]), Filter);
  end;
end;


end.

