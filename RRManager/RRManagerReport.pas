unit RRManagerReport;

interface

uses Excel97, RRManagerBaseOBjects, Contnrs, RRManagerObjects, Classes,
     RRManagerPersistentObjects, ADOInt, RRManagerBaseGUI,
     OleServer, VBScript_RegExp_55_TLB, BaseDicts, BaseObjects
     {$IFDEF VER150}
     , Variants
     {$ENDIF}
     ;


type
  TReportTable = class;
  TReportTables = class;
  TReportColumn = class;
  TReportColumns = class;
  TJoins = class;
  TReportGroup = class;
  TReportGroups = class;


  TReportOption = (roFullReport, roRemoveEmpties);

  TCommonReport = class(TBaseObject)
  private
    FExcel: TExcelApplication;
    FReportResult: OleVariant;
    FQuery: string;
    FReportName: string;
    FTemplateName: string;
    FOption: TReportOption;
    FOneSample: boolean;
    FMainReportID: integer;
    FLevel: integer;
    FData: TBaseCollection;
    FReportTables: TReportTables;
    FArrangedColumns: TReportColumns;
    FGroups: TReportGroups;
    function  Connect: _WorkBook;
    procedure Disconnect(wb: _WorkBook);
    function  PrepareData(const UseReportFilterTable: boolean): string;
    function  PrepareDataForStructures(const UseReportFilterTable: boolean): string;
    function  PrepareDataForHorizons(const UseReportFilterTable: boolean): string;
    function  PrepareDataForBeds(const UseReportFilterTable: boolean): string;
    function  PrepareDataForSubstructures(const UseReportFilterTable: boolean): string;
    function  PrepareDataForLayers(const UseReportFilterTable: boolean): string;

    procedure MoveDataToExcel;
    procedure MoveDataToExcelEx;
    procedure MoveGroupedDataToExcel;
    procedure RemoveEmptyCols;
    procedure MakeGeneralReport; overload;
    procedure MakeGeneralReport(AFilter: TBaseCollection); overload;
    procedure MakePrivateReports;
    function  MakeHeader: integer;
  protected
    property  MainReportID: integer read FMainReportID write FMainReportID;
    procedure AssignTo(Dest: TPersistent); override;
  public
    // ������������� �������
    property  ArrangedColumns: TReportColumns read FArrangedColumns;
    // ������ (���� ������������ �����������)
    property  Groups: TReportGroups read FGroups;
    property  ReportTables: TReportTables read FReportTables;
    property  Option: TReportOption read FOption write FOption;
    property  TemplateName: string read FTemplateName write FTemplateName;
    property  ReportName:   string read FReportName write FReportName;
    property  Query: string read FQuery write FQuery;
    property  OneSample: boolean read FOneSample write FOneSample;
    // ������ ������ �����
    property  Level: integer read FLevel write FLevel;
    property  Data: TBaseCollection read FData write FData;
    procedure MakeReport(AFilter: TBaseCollection);
    function  List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string; override;
    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TReports = class (TBaseCollection)
  private
    FData: TBaseCollection;
    FExcel: TExcelApplication;
    function GetItem(const Index: integer): TCommonReport;
  public
    MovePrg: procedure(const AMin, AMax, AStep: integer) of object;
    MoveHeaderPrg: procedure(const AMin, AMax, AStep: integer) of object;
    property Items[const Index: integer]: TCommonReport read GetItem;
    property Excel: TExcelApplication read FExcel write FExcel;
    constructor Create(AOwner: TBaseObject); override;
    function Add: TCommonReport;
  end;

  // ����������� ����� ������
  //  ������� ������ � ���������� ���,
  // ��� ������ ��������� ��� ������
  // � ����� ����� ����� ������������
  TReportFilter = class(TBaseObject)
  private
    FStructures: TOldStructures;
    FReport: TCommonReport;
  public
    // ����������� ���������
    property Structures: TOldStructures read FStructures;
    // �����, ��������� �������������
    property Report: TCommonReport read FReport write FReport;
    constructor Create(ACollection: TIDObjects); override;
    destructor Destroy; override;
  end;

  TReportFilters = class(TBaseCollection)
  private
    function GetItems(const Index: integer): TReportFilter;
  public
    property    Items[const Index: integer]: TReportFilter read GetITems;
    function    GetFilterByReportID(AID: integer): TReportFilter;
    function    Add: TReportFilter;
    constructor Create(AOwner: TBaseObject); override;
  end;

  TReportColumn = class(TPersistent)
  private
    FRusColName: string;
    FColName: string;
    FOrder: smallint;
    FKey: boolean;
    FColumns: TReportColumns;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    // �������� �������
    property ColName: string read FColName write FColName;
    // ������� �������� �������
    property RusColName: string read FRusColName write FRusColName;
    // ������ ������� � �������
    property Order: smallint read FOrder write FOrder;
    // ������� �������
    function List: string;
    // ����
    property Key: boolean read FKey write FKey;
    // ���������
    property Columns: TReportColumns read FColumns;
  end;

  TReportColumns = class(TObjectList)
  private
    FReportTable: TReportTable;
    FReportGroup: TReportGroup;
    function GetItems(const Index: integer): TreportColumn;
  public
    procedure Assign(Source: TReportColumns);

    property Items[const Index: integer]: TreportColumn read GetItems;
    function  Add(const AColName: string): TReportColumn; overload;
    procedure Add(AColumn: TReportColumn); overload;
    function  IndexByName(AColName: string): integer;
    function  ColByName(AColName: string): TReportColumn;
    // ������������� �� �������
    procedure SortByOrder;
    // ������������� �� �������� �����
    procedure SortByRusName;
    // ������������� �� �������� ����������� TDict.Columns
    // ��� ���� ������� ������ ��������� ��������
    // �� ��� ��� ������� � �� ���������� �������������
    // � ����� ��� �������� ������� ����� ������
    // �������� � ������� ��������
    procedure Import(ADict: TDict);
    // �������-��������
    property Owner: TReportTable read FReportTable;
    property GroupOwner: TReportGroup read FReportGroup; 
    constructor Create(AOwner: TReportTable); overload;
    constructor Create(AOwner: TReportGroup); overload;
    constructor Create; overload;
  end;

  TReportTable = class(TBaseObject)
  private
    FTableName: string;
    FRusTableName: string;
    FJoins: TJoins;
    FColumns: TReportColumns;
    FKey: TReportColumn;
    FQueryAlias: string;
    function GetColumns(AColName: string): TReportColumn;
    function GetItems(AIndex: integer): TreportColumn;
    function GetColumnCount: integer;
    procedure SetTableName(const Value: string);
    function GetKey: TReportColumn;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    // ������������ �������
    property  TableName: string read FTableName write SetTableName;
    // ������� �������� �������
    property  RusTableName: string read FRusTableName write FRusTableName;
    // ��������� ������� � �������
    property  QueryAlias: string read FQueryAlias write FQueryAlias;
    // ������ �� ��������
    function IndexOfName(AColName: string): integer;
    // ����� �� �������� �������
    property  Columns[AColName: string]: TReportColumn read GetColumns;
    // ���������� ��������
    property  ColumnCount: integer read GetColumnCount;
    // ��������� �������
    procedure ColumnsClear;
    property  Items[AIndex: integer]: TreportColumn read GetItems;
    // ���������� �������
    // ���-�� ������� ����������
    function  Add(AColumn: TReportColumn): TReportColumn; overload;
    // �� �����: ������� �����������, � ���� �� ������� - ���������
    // ��� ��� ��� ����� ������ - ������ ��� ���� �� :)
    function  Add(AColumnName: string): TReportColumn; overload;
    // ������� �������
    procedure Delete(const Index: integer);
    // ������������� �� �������
    procedure SortColumnsByOrder;
    // ������������� �� �������� �����
    procedure SortColumnsByRusName;
    // ���������� �������
    procedure CopyColumns(ASource: TReportTable);
    // ��������� ���������� ��� ������ �������
    property Joins: TJoins read FJoins;
    // ��������
    function    List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string; override;
    // ����
    property Key: TReportColumn read GetKey;
    constructor Create(ACollection: TIDObjects); override;
    destructor Destroy; override;
  end;

  // ������ ������ ��� ������
  TReportTables = class(TBaseCollection)
  private
    function GetReportTable(const Index: integer): TReportTable;
  public
    property Items[const Index: integer]: TReportTable read GetReportTable;
    // ������� �� ����� ������� � ��
    function GetTableByName(AName: string): TReportTable;
    // ������� �� �������� ����� (��� ��� �����) � ��
    function GetTableByRusName(AName: string; Part: boolean = true): TReportTable;
    // ������� �� ��������
    function GetTableByID(const AID: integer): TReportTable;
    // ���������� �������
    function Add(const AName, ARusName: string): TReportTable; overload;


    constructor Create(AOwner: TBaseObject); override;
  end;

  // ������, � ������� ��������� ������� ��� ������
  // ���� ���������� �� ������� ������� �������� � ������
  TConcreteReportTables = class(TReportTables)
  public
    constructor Create(AOwner: TBaseObject); override;
  end;


  TJoin = class(TBaseObject)
  private
    FMain: boolean;
    FRightColumn: TReportColumn;
    FLeftColumn: TReportColumn;
    FLeftTable: TReportTable;
    FRightTable: TReportTable;
  public
    // �������, ������� ���� ������ � ������ �����������
    property LeftTable: TReportTable read FLeftTable write FLeftTable;
    // �������, ������� ���� �����
    property RightTable: TReportTable read FRightTable write FRightTable;
    // ����� �����������. Main = true: � where, Main = false: � left.
    // ������ ���� ������� ���������
    // ����� ����, � ����� ����� ������ "�����" ����������� ��������������
    property Main: boolean read FMain write FMain;
    // �������, �� ������� ����������
    // (����������� TRightTable � TLeftTable � ������������ � ����)
    // �� ����� �������
    property LeftColumn: TReportColumn read FLeftColumn write FLeftColumn;
    // �� ������ �������
    property RightColumn: TReportColumn read FRightColumn write FRightColumn;
    constructor Create(ACollection: TIDObjects); override;
  end;

  // SQL-������������ �������
  TReportSQL = class(TObjectList)
  private
    FSQL: string;
  public
    // ������ ���������� ��� �������� � ����� �� �����������
    // �� ��������� ������� (������� � ������������������)
    // � �� �������
    property SQL: string read FSQL;
    constructor Create(ASQL: string);
  end;


  TJoins = class(TBaseCollection)
  private
    function GetItems(const Index: integer): TJoin;
  public
    property Items[const Index: integer]: TJoin read GetItems;
    function Add: TJoin;
    constructor Create(AOwner: TBaseObject); override;
  end;


  TReportGroup = class(TBaseObject)
  private
    FGroupingColumn: TReportColumn;
    FAggregateColumns: TReportColumns;
    FFieldNum: integer;
    FFieldValue: variant;
    FVisible: boolean;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property GroupingColumn: TReportColumn read FGroupingColumn;
    property AggregateColumns: TReportColumns read FAggregateColumns;
    property FieldNum: integer read FFieldNum write FFieldNum;
    property FieldValue: variant read FFieldValue write FFieldValue;
    property Visible: boolean read FVisible write FVisible;
    function    List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string; override;
    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TReportGroups = class (TBaseCollection)
  private
    function GetItems(const Index: integer): TReportGroup;
  public
    function IndexOfColName(const AColName: string): integer;
    function IsColumnUsed(const AColName: string): boolean;
    property Items[const Index: integer]: TReportGroup read GetItems;
    function Add: TReportGroup;
    constructor Create(AOwner: TBaseObject); override;
    function OrderString: string;
  end;


  TReportsDataPoster = class(RRManagerPersistentObjects.TDataPoster)
  protected
    procedure Prepare; override;
    // ������ ������ ������� � ������ ���������
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // ������ ������ ��� �������� � ������ ���������
    function GetDeletingData(ABaseObject: TBaseObject): OleVariant; override;
    // �������������� ������
    function GetObject(AData: variant): TBaseCollection; override;
  public
    function GetProxy(const AUIN: integer): TBaseCollection; override;
  end;

  TReportGroupDataPoster = class(RRManagerPersistentObjects.TDataPoster)
  private
    FLastPostedAttribute: integer;
  protected
    procedure Prepare; override;
    // ������ ������ ������� � ������ ���������
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // ������ ������ ��� �������� � ������ ���������
    function GetDeletingData(ABaseCollection: TBaseCollection): OleVariant; overload; override;
    // �������������� ������
    function GetObject(AData: variant): TBaseCollection; override;
  public
    function    GetProxy(const AUIN: integer): TBaseCollection; override;
    constructor Create; override;
  end;

  TReportTablesDataPoster = class(RRManagerPersistentObjects.TDataPoster)
  protected
    procedure Prepare; override;
    // ������ ������ ������� � ������ ���������
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // ������ ������ ��������� � ������ ���������
    function GetPostingData(ABaseCollection: TBaseCollection): OleVariant; override;
    // ������ ������ ��� �������� � ������ ���������
    function GetDeletingData(ABaseObject: TBaseObject): OleVariant; override;
    // �������������� ������
    function GetObject(AData: variant): TBaseCollection; override;
  public
    function GetProxy(const AUIN: integer): TBaseCollection; override;
  end;

  TQueryTablesDataPoster = class(TStringPoster)
  private
    procedure AddJoins(const ALeftTable, ARightTable, ALeftColumn, ARightColumn, ALeftAlias, ARightAlias: string);
    procedure GetFromWhereClause(ASQL: string);
    procedure GetFromJoins(ASQL: string);
    procedure ParseFrom(ASQL: string);
    function  LocateTable(AFromClause: string; var ATable: string): string;
  protected
    procedure Prepare; override;
    function  GetObject(AData: variant): TBaseCollection; override;
    // ������ ������ ��������� � ������ ���������
    function  GetPostingData(ABaseCollection: TBaseCollection): OleVariant; override;
    // ������ ������ ��������� � ������ ���������
    function  GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
  end;


  TReportBaseLoadAction = class(TBaseAction)
  public
    function Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TReportTablesBaseLoadAction = class(TBaseAction)
  public
    function    Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

  TReportBaseEditAction = class(TBaseAction)
  public
    function  Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

  TReportBaseAddAction = class(TReportBaseEditAction)
  public
    function Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;


  TReportActionList = class(TbaseActionList)
  public
    constructor Create(AOwner: TComponent); override;
  end;


var
  AllReports: TReports = nil;
  AllConcreteTables: TConcreteReportTables = nil;

implementation

uses ClientCommon, SysUtils, RRManagerCreateReportForm, Controls, ComObj, RRManagerCommon, Facade,
  BaseFacades, DBGate;


procedure TCommonReport.RemoveEmptyCols;
var i,j: integer;
    bFound : boolean;
    sh: OleVariant;
begin
  sh := FExcel.ActiveWorkbook.ActiveSheet;
  for i:=varArrayHighBound(FReportResult,1) + 1 downto 1 do
  begin
    bFound := false;

    for j:=0 to varArrayHighBound(FReportResult,2) do
    if not(varIsEmpty(FReportResult[i-1,j])
       or varIsNull(FReportResult[i-1,j])
       or (varAsType(FReportResult[i-1,j], varOleStr) = '')) then
       //or (trim(varAsType(FReportResult[i-1,j], varOleStr))=''))then
    begin
      bFound := true;
      break;
    end;

    if not bFound then
    begin
      sh.Columns.Item[i + 1].Hidden := true;
//      sh.Cells.Item[14, i + 1].Value := 1;
    end
//    else sh.Cells.Item[14, i + 1].Value := 2;
  end;
end;

procedure TCommonReport.MoveDataToExcel;
var {sPath, }sWell: string;
    i, j, iHB: integer;
    Wells: array of string;
    {vbc, }vTemp: OleVariant;
    wb: _WorkBook;
    sh: OleVariant;
    rpts: TReports;
begin
  // �����������
  rpts := Collection as TReports;
  iHb := 0;
  wb := Connect;

  // ��������� �������
  {vbc:=wb.VBProject.VBComponents.Add(1);
  vbc.Name := 'macros';
  vbc.Codemodule.AddFromString('Sub DeleteColumn(Index as integer)'+#13+#10+
                               'Columns(Index).Delete'+#13+#10+
                               'End Sub');

  //vbc.Codemodule.AddFromFile(ExtractFilePath(ParamStr(0))+'macro.txt');}

  if Assigned(rpts.MovePrg) then rpts.MovePrg(1, 100, 1);
  // ����������� ������
  // �������� ������ �������� - ������ ����� ��� ����� ����
  SetLength(Wells,1);
  Wells[0] := FReportResult[0,0];

  // ���������� ������������
  for j:=0 to varArrayHighBound(FReportResult,2) do
  begin

    // �������� �������� �������
    if FReportResult[0,j]<>Wells[High(Wells)] then
    begin
      SetLength(Wells,Length(Wells)+1);
      Wells[High(Wells)] := FReportResult[0,j];
    end;

    // ���������� �����
    FExcel.Cells.Item[j+13,1].Value := j+1;

    // ��������������� ������
    // varAsType(FReportResult[i,j],varOleStr);
    //FReportResult[i,j];
    iHB := varArrayHighBound(FReportResult,1);
    vTemp := varArrayCreate([0, iHB], varVariant);
    for i:=0 to iHB do
    if not (varIsEmpty(FReportResult[i,j])) then
         FExcel.Cells.Item[j+13,i+2].Value := FReportResult[i,j];
      //vTemp[i] := FReportResult[i,j];
      //FExcel.Cells.Item[j+13,i+2].Value := varAsType(FReportResult[i,j],varOleStr);

    //FExcel.Run('Outer', j + 13, vTemp);
    if Assigned(rpts.MovePrg) then rpts.MovePrg(1, 100, 1);
  end;

  // �������� ��������(�������)
  for i:=0 to High(Wells) do
  begin
    if i>0 then sWell := sWell + ', ' else sWell := '���. ';
    sWell := sWell+Wells[i];
  end;
  FExcel.Cells.Item[7,1].Value := sWell;

  sh := wb.ActiveSheet;
  // ���� ������ - ������� ������ �������
  if Option = roRemoveEmpties then RemoveEmptyCols;
  // ���� ����� �� ����� ������� - ������� ������ �������
  if Length(Wells)=1 then sh.Columns.Item[2].Hidden := true
  else sh.Columns.Item[2].AutoFit;

  {if Length(Wells)=1 then FExcel.Run('DeleteColumn', 2)
  else FExcel.Run('AutoFitter', 2);}

  //FExcel.Run('SetSheetName', copy(sWell, 1, 31));
  Sh.Name := copy(sWell, 1, 31);


  //FExcel.Run('AutoFitter', 8);
  //sh.Columns.Item[8].AutoFit;
  if iHB > 0 then sh.Columns.Item[iHB + 2].AutoFit;
  Disconnect(wb);
  if Assigned(rpts.MovePrg) then rpts.MovePrg(1, 100, 1);
end;

procedure TCommonReport.MakeReport(AFilter: TBaseCollection);
{var  //i: integer;
     rpts: TReports;}
begin
  // ������ �������� �������, ��������  �������������, �����
  // � ������� ��� ������� ��������� �����
  // ������ ������ �� ���� ��������
  // AROCK_SAMPLE_UIN, ASLOTTING_UIN, AWELL_UIN

  // GetRockSampleFilter(FReportRockSamples, sFilter);
  // �������� �� ������������� ����������
  // � �������� ��������

  if not Assigned(AFilter) then
  begin
    if not OneSample then MakeGeneralReport
    else MakePrivateReports;
  end
  else MakeGeneralReport(AFilter);


  // ��������� ������, ������� ����� �������������� ������ ���������

  // ������� ������
  //i := iServer.DeleteRow('tbl_Report_Filter', 'Employee_ID = '+inttostr(iEmployeeID));
end;




function TReports.Add: TCommonReport;
begin
  Result := inherited Add as TCommonReport;
end;

constructor TReports.Create(AOwner: TBaseObject);
begin
  inherited Create(TCommonReport);
  FOwner := AOwner; 
end;

function TReports.GetItem(const Index: integer): TCommonReport;
begin
  Result := TCommonReport(inherited Items[Index]);
end;


function TCommonReport.List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): String;
begin
  case ListOption of
  loBrief, loMedium: Result := ReportName;
  loFull: Result := ReportName + '(' + TemplateName + ')';
  end;

  if IncludeKey then Result := Result + '[r'+IntToStr(ID)+']';
end;


{ TReportsDataPoster }

function TReportsDataPoster.GetDeletingData(
  ABaseObject: TBaseObject): OleVariant;
begin
  Result := varArrayOf([(AbaseObject as TCommonReport).ID]);
end;

function TReportsDataPoster.GetObject(AData: variant): TBaseCollection;
var r: TCommonReport;
    i: integer;    
begin
  if not Assigned(FLastGotCollection) then
    FLastGotCollection := TReports.Create(nil)
  else FLastGotCollection.Clear;

  Result := FLastGotCollection;
  if not varIsEmpty(AData) then
  for i := 0 to varArrayHighBound(AData, 2) do
  begin
    r := (Result as TReports).Add;

    r.ID := AData[0, i];
    r.ReportName := AData[1, i];
    r.TemplateName := AData[2, i];
    r.Query := AData[3, i];
    r.OneSample := AData[4, i];

    r.MainReportID := r.ID;
    if not varIsEmpty(AData[5, i]) then
      r.MainReportID := AData[5, i];

    r.Level := AData[6, i];
  end;
end;

function TReportsDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
var r: TCommonReport;
begin
  // ���� �� �������� - ��������� ���� ������ ������
  {
    REPORT_ID          INTEGER,
    VCH_REPORT_NAME    VARCHAR(100),
    VCH_TEMPLATE_NAME  VARCHAR(50),
    VCH_REPORT_QUERY   VARCHAR(8000),
    NUM_ONE_SAMPLE     SMALLINT,
    MAIN_REPORT_ID     INTEGER,
    LEVEL smallint,
    CLIENT_APP_TYPE_ID  INTEGER,

  }
  r := ABaseObject as TCommonReport;
  Result := varArrayOf([r.ID,
                        r.ReportName,
                        r.TemplateName,
                        r.Query,
                        0,
                        null,
                        r.Level,
                        TMainFacade.GetInstance.ClientAppTypeID
                        ]);
end;

function TReportsDataPoster.GetProxy(const AUIN: integer): TBaseCollection;
begin
  Result := nil;
end;


procedure TCommonReport.MakeGeneralReport;
var iResult: integer;
    rpts: TReports;
begin
  PrepareData(true);

  iResult := TMainFacade.GetInstance.DBGates.Server.ExecuteQuery(Query+'('+ inttostr(TMainFacade.GetInstance.DBGates.EmployeeID) +')');
  if (Data.Count > 0) and (iResult > 0) then
  begin
    FReportResult := TMainFacade.GetInstance.DBGates.Server.QueryResult;
    // ����������� � Excel
    // ����������� ������ � ��������������� �������
    // ���� ������ - ������� ������ �������
    MoveDataToExcelEx;
  end;
end;

procedure TCommonReport.MakePrivateReports;
var vTitle, vData: variant;
    i, j: integer;
    wb: _WorkBook;
begin
  PrepareData(true);

  if (TMainFacade.GetInstance.DBGates.Server.ExecuteQuery(Query+'('+ inttostr(TMainFacade.GetInstance.DBGates.EmployeeID) +')') > 0) then
  begin

    FReportResult := TMainFacade.GetInstance.DBGates.Server.QueryResult;
    // ����������� � Excel
    // ����������� ������ � ��������������� �������
    // ���� ������ - ������� ������ �������
    vTitle := varArrayCreate([0, 14], varVariant);
    vData  := varArrayCreate([0, varArrayHighBound(FReportResult, 1) - 15], varVariant);
    for i := 0 to varArrayHighBound(FReportResult, 2) do
    begin
      wb := Connect;

      for j := 0 to 14 do
        vTitle[j] := FReportResult[j, i];

      for j := 0 to varArrayHighBound(vData, 1) do
        vData[j] := FReportResult[15 + j, i];

      //varClear(FReportResult);

      FExcel.Run('FillTitle', vTitle);
      FExcel.Run('FillAll', vData);
      Disconnect(wb);
    end;
  end;
end;

function TCommonReport.Connect: _WorkBook;
var sPath: string;
begin
  FExcel.Connect;
  FExcel.Visible[0] := false;
  sPath := ExtractFilePath(ParamStr(0))+ExtractFileName(TemplateName);
  Result := FExcel.Workbooks.Add(sPath,0);
  Result.Activate(0);
end;

procedure TCommonReport.Disconnect(wb: _WorkBook);
begin
  // �������������
  if OneSample then
    wb.VBProject.VBComponents.Remove(wb.VBProject.VBComponents.Item('macros'));
  FExcel.Visible[0] := true;
  FExcel.Disconnect;
end;

procedure TReportsDataPoster.Prepare;
begin
  FGettingTable := 'SPD_GET_REPORT';
  FGettingColumns := 'Report_ID, vch_Report_Name, vch_Template_Name, vch_Report_Query, num_One_Sample, Main_Report_ID, num_Level';

  FOrder := 'vch_Report_Name';

  FPostingColumns := '*';
  FPostingTable := 'spd_Add_Report';
  FQuery := '';
  FKeyColumn := 'Report_ID';
  FDeletingTable := 'spd_Delete_Report';
end;



{ TReportFilter }

constructor TReportFilter.Create(ACollection: TIDObjects);
begin
  inherited;
  FStructures := TOldStructures.Create(Self);
end;

destructor TReportFilter.Destroy;
begin
  FStructures.Free;
  inherited;
end;

{ TReportBaseLoadAction }

constructor TReportBaseLoadAction.Create(AOwner: TComponent);
begin
  inherited;

end;

function TReportBaseLoadAction.Execute: boolean;
var dp: RRManagerPersistentObjects.TDataPoster;
    i: integer;
    sColName: string;
    r: TCommonReport;
begin
  Result := false;
  LastCollection := AllReports;
  if LastCollection.NeedsUpdate then
  begin
    LastCollection.NeedsUpdate := false;

    Result := inherited Execute;
    // ����� ������
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TReportsDataPoster];
    // �������������� ���������
    dp.LastGotCollection := LastCollection;
    sColName := dp.KeyColumn;


    LastCollection := dp.GetFromDB(TMainFacade.GetInstance.ClientAppTypeID);

    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TReportGroupDataPoster];
    // �������� �� ��������� � ��������� ����������
    for i := 0 to LastCollection.Count - 1 do
    begin
      r := LastCollection.Items[i] as TCommonReport;
      dp.LastGotCollection := r.Groups;
      dp.GetFromDB(sColName + '=' + IntToStr(LastCollection.Items[i].ID));
    end;
  end;
end;


{ TReportTable }

function TReportTable.Add(AColumnName: string): TReportColumn;
begin
  Result := FColumns.Add(AColumnName);
end;

function TReportTable.Add(AColumn: TReportColumn): TReportColumn;
begin
  // �� ��������� �� �� �����,
  // � ��������, ������ ��� ��������� ������������ ��������
  Result := TReportColumn.Create;

  Result.Assign(AColumn);
  FColumns.Add(Result);
end;

procedure TReportTable.AssignTo(Dest: TPersistent);
var rt: TReportTable;
begin

  rt := Dest as TReportTable;
  rt.ID := ID;
  rt.FTableName := TableName;
  rt.FRusTableName := RusTableName;
  // ������� � ���������� �� ��������
  // ��� �������� ��� � ���������� ����� �������
  // �������� ������ ����
  rt.Key.Assign(Key);

end;

procedure TReportTable.CopyColumns(ASource: TReportTable);
begin
  FColumns.Assign(ASource.FColumns);
end;

constructor TReportTable.Create(ACollection: TIDObjects);
begin
  inherited Create(ACollection);
  FKey := nil;
  FJoins := TJoins.Create(Self);
  FColumns := TReportColumns.Create(Self);
end;

procedure TReportTable.Delete(const Index: integer);
begin
  FColumns.Delete(Index);
end;

destructor TReportTable.Destroy;
begin
  FJoins.Free;
  FColumns.Free;
  inherited;
end;

function TReportTable.GetColumnCount: integer;
begin
  Result := FColumns.Count;
end;

function TReportTable.GetColumns(AColName: string): TReportColumn;
begin
  Result := FColumns.ColByName(AColName);
end;

function TReportTable.GetItems(AIndex: integer): TreportColumn;
begin
  Result := FColumns.Items[AIndex]; 
end;

function TReportTable.GetKey: TReportColumn;
var i: integer;
begin
  if not Assigned(FKey) then 
  for i := 0 to ColumnCount - 1 do
  if Items[i].Key then
  begin
    FKey := Items[i];
    break;
  end;

  if not Assigned(FKey) then FKey := FColumns.Add('');
  Result := FKey;
end;

function TReportTable.IndexOfName(AColName: string): integer;
begin
  Result := FColumns.IndexByName(AColName)
end;

function TReportTable.List(ListOption: TListOption;
  IncludeKey: boolean; Recource: boolean): string;
begin
  Result := RusTableName;
end;

procedure TReportTable.SetTableName(const Value: string);
begin
  if FTableName <> Value then
  begin
    FTableName := Value;
    FColumns.Import((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName[FTableName]);
  end;
end;

procedure TReportTable.SortColumnsByRusName;
begin
  FColumns.SortByRusName;
end;

procedure TReportTable.SortColumnsByOrder;
begin
  FColumns.SortByOrder;
end;

procedure TReportTable.ColumnsClear;
begin
  FColumns.Clear;
end;

{ TReportSQL }

constructor TReportSQL.Create(ASQL: string);
begin

end;

{ TReportTables }


function TReportTables.Add(const AName, ARusName: string): TReportTable;
begin
  Result := Add as TReportTable;
  Result.TableName := AName;
  Result.RusTableName := ARusName; 
end;


constructor TReportTables.Create(AOwner: TBaseObject);
begin
  inherited Create(TReportTable);
  FOwner := AOwner; 
end;


function TReportTables.GetReportTable(const Index: integer): TReportTable;
begin
  Result := inherited Items[Index] as TReportTable;
end;

function TReportTables.GetTableByID(const AID: integer): TReportTable;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].ID = AID then
  begin
    Result := Items[i];
    break;
  end;
end;

function TReportTables.GetTableByName(AName: string): TReportTable;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if AnsiUpperCase(Items[i].TableName) = AnsiUpperCase(AName) then
  begin
    Result := Items[i];
    break;
  end;
end;

function TReportTables.GetTableByRusName(AName: string;
  Part: boolean): TReportTable;
var i: integer;
begin
  Result := nil;
  if Part then
  begin
    for i := 0 to Count - 1 do
    if pos(AnsiUpperCase(AName), AnsiUpperCase(Items[i].RusTableName)) > 0 then
    begin
      Result := Items[i];
      break;
    end;
  end
  else
  begin
    for i := 0 to Count - 1 do
    if AnsiUpperCase(AName) = AnsiUpperCase(Items[i].RusTableName) then
    begin
      Result := Items[i];
      break;
    end; 
  end;
end;

{ TConcreteReportTables }

constructor TConcreteReportTables.Create(AOwner: TBaseObject);
begin
  inherited Create(AOwner);
end;


{ TJoins }

function TJoins.Add: TJoin;
begin
  Result := inherited Add as TJoin;
end;

constructor TJoins.Create(AOwner: TBaseObject);
begin
  inherited Create(TJoin);
  FOwner := AOwner;
end;

function TJoins.GetItems(const Index: integer): TJoin;
begin
  Result := inherited Items[Index] as TJoin
end;




{ TJoin }

constructor TJoin.Create(ACollection: TIDObjects);
begin
  inherited Create(ACollection);
end;


{ TConcreteJoinsDataPoster }

function TReportTablesDataPoster.GetDeletingData(
  ABaseObject: TBaseObject): OleVariant;
begin
  Result := Null;
end;

function TReportTablesDataPoster.GetObject(
  AData: variant): TBaseCollection;
var i: integer;
    jn: TJoin;
    lc, rc: TReportColumn;
    lt, rt: TReportTable;

// ������� ���������� ������ � ���������� �������������
// �������� �����-������ ��������� �� ��������� ��������� �������
// � ���� ���������� �� tbl_joins �� �������
function InitJoinsArray: variant;
begin
  Result := varArrayCreate([0, 8, 0, 7], varVariant);

  Result[0, 0] := 1;
  Result[1, 0] := 'vw_Structure';
  Result[2, 0] := 'vw_Horizon';
  Result[3, 0] := 'Structure_ID';
  Result[4, 0] := 'Structure_ID';
  Result[5, 0] := '��������� ��� �������������';
  Result[6, 0] := '��������';

  Result[0, 1] := 2;
  Result[1, 1] := 'vw_Horizon';
  Result[2, 1] := 'vw_Substructure';
  Result[3, 1] := 'Structure_Stratum_ID';
  Result[4, 1] := 'Structure_Stratum_ID';
  Result[5, 1] := '��������';
  Result[6, 1] := '������������';

  Result[0, 2] := 3;
  Result[1, 2] := 'vw_Substructure';
  Result[2, 2] := 'vw_Concrete_Layer';
  Result[3, 2] := 'Substructure_ID';
  Result[4, 2] := 'Substructure_ID';
  Result[5, 2] := '������������';
  Result[6, 2] := '������������ �����';


  Result[0, 3] := 4;
  Result[1, 3] := 'vw_Structure';
  Result[2, 3] := 'vw_Bed';
  Result[3, 3] := 'Structure_ID';
  Result[4, 3] := 'Structure_ID';
  Result[5, 3] := '��������� ��� �������������';
  Result[6, 3] := '������';

  Result[0, 4] := 5;
  Result[1, 4] := 'vw_Bed';
  Result[2, 4] := 'vw_Concrete_Layer';
  Result[3, 4] := 'Bed_ID';
  Result[4, 4] := 'Bed_ID';
  Result[5, 4] := '������';
  Result[6, 4] := '������������ �����';

  Result[0, 5] := 6;
  Result[1, 5] := 'vw_Concrete_Layer';
  Result[2, 5] := '';
  Result[3, 5] := '';
  Result[4, 5] := '';
  Result[5, 5] := '������������ �����';
  Result[6, 5] := '';

  Result[0, 6] := 7;
  Result[1, 6] := 'vw_horizon';
  Result[2, 6] := 'vw_horizon_resources';
  Result[3, 6] := 'Structure_Stratum_ID';
  Result[4, 6] := 'Structure_Stratum_ID';
  Result[5, 6] := '��������';
  Result[6, 6] := '������� �� ���������';

  Result[0, 7] := 8;
  Result[1, 7] := 'vw_Structure';
  Result[2, 7] := 'vw_Structure_Resources';
  Result[3, 7] := 'Structure_ID';
  Result[4, 7] := 'Structure_ID';
  Result[5, 7] := '��������� ��� �������������';
  Result[6, 7] := '������� �� ���������';


end;

begin
  {
    ������,  ��� ��������� �������� ������
    �� ������ ��-�� ����� ������ ��-��-����,
    � ��� � ��-�� ����, ��� ��������� ��������� ������ ���������:
    ��������� ConcreteJoins (��������, ����� ���� ����� ������� ������, �� ������ ��� ��� �����
    � �����),
    ��������� ConcreteTables, ������� ������ �� ����������� � �������� �� BaseObject-BaseCollection,
    � �������������, ��� ���������� ����� ������� �� ConcreteTables, ����������� ��������� � ��������
  }

  if not Assigned(FLastGotCollection) then
  if Assigned(AllConcreteTables) then
    FLastGotCollection := AllConcreteTables
  else
  begin
    FLastGotCollection := TConcreteReportTables.Create(nil);
    AllConcreteTables := FLastGotCollection as TConcreteReportTables;    
  end
  else FLastGotCollection.Clear;

  Result := FLastGotCollection;


  // ��� �������� � ������������� ������ �� tbl_joins
  // ���� �� ����������������
  AData := InitJoinsArray;

  if not varIsEmpty(AData) then
  for i := 0 to varArrayHighBound(AData, 2) do
  begin
    // 1 - �������� ����� �������
    // 2 - �������� ������ �������
    // 3 - �������� ������ �������
    // 4 - �������� ������� �������
    // 5 - ������� �������� ����� �������
    // 6 - ������� �������� ������ �������
    // 7 - ������� �������� ������� ����� �������
    // 8 - ������� �������� ������� ������ �������
    lt := AllConcreteTables.GetTableByName(AData[1, i]);
    if not Assigned(lt) then
    begin
      lt := AllConcreteTables.Add as TReportTable;
      // ��� ������� ����� ������� �������������� ������� �� tbl_Attribute
      lt.TableName := AData[1, i];
      lt.RusTableName := AData[5, i];
    end;

    if AData[3, i] <> '' then
    begin
      lc := lt.Columns[AData[3, i]];
      if Assigned(lc) then lc.Key := true;
    end
    else lc := nil;

    if (AData[2, i] <> '') then
    begin
      rt := AllConcreteTables.GetTableByName(AData[2, i]);
      if not Assigned(rt) then
      begin
        rt := AllConcreteTables.Add as TReportTable;
        // ��� ������� ����� ������� �������������� ������� �� tbl_Attribute
        rt.TableName := AData[2, i];
        rt.RusTableName := AData[6, i];
      end;

      rc := rt.Columns[AData[4, i]];
      if Assigned(rc) then  rc.Key := true;
    end
    else
    begin
      rt := nil;
      rc := nil;
    end;

    jn := lt.Joins.Add;
    jn.LeftTable := lt;
    jn.RightTable := rt;
    jn.LeftColumn := lc;
    jn.RightColumn := rc;
    {
      � ����� ����������� �����-�� ������� ������
      ������� 1
      |__ ������� 2
      ������� 2
      |__ ������� 3

      ������� �� ���� ����� ����������� ������ �������,
      ����� ������� ���.

      ������� 1
      |__ ������� 2
         |__������� 3
      ������� 2
      |__ ������� 3
     }
  end;
end;

function TReportTablesDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
begin
  Result := Null;
end;

function TReportTablesDataPoster.GetPostingData(
  ABaseCollection: TBaseCollection): OleVariant;
begin
  Result := null;
end;

function TReportTablesDataPoster.GetProxy(
  const AUIN: integer): TBaseCollection;
begin
  Result := nil;
end;

procedure TReportTablesDataPoster.Prepare;
begin
  FObjectClass := TCommonReport;
  FCollectionClass := TReports;

  // �� �����������, �� ������������
  // ��� ����� ����� �������� ������ ��
  // ������� ����������
  // � ���� - �� ������ �������
  ForceGet := true;

end;

{ TReportColumns }

function TReportColumns.Add(const AColName: string): TReportColumn;
begin
  Result := TReportColumn.Create();
  Result.ColName := AColName;
  Add(Result);
end;

procedure TReportColumns.Add(AColumn: TReportColumn);
begin
  inherited Add(AColumn);
  AColumn.FColumns := Self;  
end;


procedure TReportColumns.Assign(Source: TReportColumns);
var i: integer;
    cl: TReportColumn;
begin
  for i := 0 to Source.Count - 1 do
  begin
    cl := TReportColumn.Create;
    cl.Assign(Source.Items[i]);
    Add(cl);
  end;
end;

function TReportColumns.ColByName(AColName: string): TReportColumn;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if AnsiUpperCase(Items[i].ColName) = AnsiUpperCase(AColName) then
  begin
    Result := Items[i];
    break;
  end;
end;

constructor TReportColumns.Create(AOwner: TReportTable);
begin
  inherited;
  FReportTable := AOwner;
  OwnsObjects := true;
end;

constructor TReportColumns.Create(AOwner: TReportGroup);
begin
  inherited;
  FReportGroup := AOwner;
  OwnsObjects := true;
end;

constructor TReportColumns.Create;
begin
  inherited;
  FReportGroup := nil;
  FReportTable := nil;
end;

function TReportColumns.GetItems(const Index: integer): TreportColumn;
begin
  result := inherited Items[Index] as TreportColumn;
end;


function OrderSort(Item1, Item2: Pointer): Integer;
var c1, c2: TReportColumn;
begin
  c1 := TReportColumn(Item1);
  c2 := TreportColumn(Item2);
  if c1.Order < c2.Order then Result := -1
  else if c1.Order > c2.Order then Result := 1
  else Result := 0;
end;

function RusNameSort(Item1, Item2: Pointer): Integer;
var c1, c2: TReportColumn;
begin
  c1 := TReportColumn(Item1);
  c2 := TreportColumn(Item2);
  if c1.RusColName < c2.RusColName then Result := -1
  else if c1.RusColName > c2.RusColName then Result := 1
  else Result := 0;
end;



procedure TReportColumns.Import(ADict: TDict);
var i: integer;
    rc: TReportColumn;
begin
  if Assigned(ADict) then
  begin
    for i := 0 to ADict.Columns.Count - 1 do
    begin
      rc := Add(ADict.Columns[i].ColName);
      rc.RusColName := ADict.Columns[i].RusColName;
    end;
  end;
end;

function TReportColumns.IndexByName(AColName: string): integer;
var i: integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
  if AnsiUpperCase(Items[i].ColName) = AnsiUpperCase(AColName) then
  begin
    Result := i;
    break;
  end;
end;

procedure TReportColumns.SortByOrder;
begin
  Sort(OrderSort);
end;

procedure TReportColumns.SortByRusName;
begin
  Sort(RusNameSort);
end;

{ TReportTablesBaseLoadAction }

constructor TReportTablesBaseLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  if not Assigned(AllConcreteTables) then AllConcreteTables := TConcreteReportTables.Create(nil);  
end;

destructor TReportTablesBaseLoadAction.Destroy;
begin
  inherited;
end;

function TReportTablesBaseLoadAction.Execute: boolean;
var dp: RRManagerPersistentObjects.TDataPoster;
begin
  Result := false;


  LastCollection := AllConcreteTables;

  if LastCollection.NeedsUpdate then
  begin
    LastCollection.NeedsUpdate := false;

    Result := inherited Execute;
    // ����� ������
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TReportTablesDataPoster];
    // �������������� ���������
    dp.LastGotCollection := LastCollection;


    LastCollection := dp.GetFromDB(1);
  end;
end;

{ TQueryTablesDataPoster }

procedure TQueryTablesDataPoster.AddJoins(const ALeftTable, ARightTable,
  ALeftColumn, ARightColumn, ALeftAlias, ARightAlias: string);
var jn: TJoin;
    rts: TReportTables;
    lt, rt: TReportTable;
    lc, rc: TReportColumn;
begin
  // ���������� ���������� �������� ������
  if (trim(ALeftTable) <> '') and (trim(ARightTable) <> '') then
  begin
    rts := FLastGotCollection as TReportTables;

    lt := rts.GetTableByName(ALeftTable);
    if not Assigned(lt) then
    begin
      lt := rts.Add as TReportTable;
      // ��� ������� ����� ������� �������������� ������� �� tbl_Attribute
      lt.TableName := ALeftTable;
      lt.QueryAlias := ALeftAlias;
    end;
    lc := lt.Columns[ALeftColumn];

    rt := rts.GetTableByName(ARightTable);
    if not Assigned(rt) then
    begin
      rt := rts.Add as TReportTable;
      // ��� ������� ����� ������� �������������� ������� �� tbl_Attribute
      rt.TableName := ARightTable;
      rt.QueryAlias := ARightAlias;
    end;
    rc := rt.Columns[ARightColumn];

    jn := lt.Joins.Add;
    jn.LeftTable := lt;
    jn.LeftColumn := lc;
    jn.RightTable := rt;
    jn.RightColumn := rc;
  end;
end;

procedure TQueryTablesDataPoster.GetFromJoins(
  ASQL: string);
var sFromClause, sJoin, sRightTable,
    sRightTableAlias, sRightColumn,
    sLeftColumn, sLeftTable, sLeftTableAlias,
    sLeft, sRight: string;
    iPos, iNextPos: integer;
begin

  // ����� ������ ������ �� ������� ��������
  sFromClause := trim(copy(ASQL, pos(' FROM ', ASQL), Length(ASQL)));
  // ������� ����� FROM �� ������ ������
  sFromClause := StringReplace(sFromClause, 'FROM ', '', []);

  iPos := pos('LEFT JOIN', sFromClause);
  if iPos > 0 then
    sFromClause := trim(copy(sFromClause, 1, iPos - 1));

  iPos := pos('LEFT JOIN', ASQL);

  while iPos > 0 do
  begin
    // ������ ��������� join
    iNextPos := PosAfter('LEFT JOIN', ASQL, iPos);
    if iNextPos = 0 then iNextPos := Length(ASQL);
    // ����� ������ ����������
    sJoin := copy(ASQL, iPos, iNextPos - iPos);
    // �������� �� �������
    // ������� �� ��� ���� left join
    sJoin := StringReplace(sJoin, 'LEFT JOIN', '', []);
    // ��������� ������� �� ��������� ����� on
    SplitInto2Parts(' ON ', sJoin, sRightTable, sJoin);
    // ������� ������
    sJoin := StringReplace(sJoin, '(', '', [rfReplaceAll]);
    sJoin := StringReplace(sJoin, ')', '', [rfReplaceAll]);
        
    sRightTable := trim(sRightTable);
    if pos(' AS ', sRightTable) > 0 then
      SplitInto2Parts('AS', sRightTable, sRightTable, sRightTableAlias)
    else SplitInto2Parts(' ', sRightTable, sRightTable, sRightTableAlias);

    if sRightTableAlias = '' then sRightTableAlias := sRightTable;

    sJoin := trim(sJoin);

    SplitInto2Parts('=', sJoin, sLeft, sRight);
    if pos(sRightTableAlias, sLeft) > 0 then
    begin
      SplitInto2Parts('.', sLeft, sRightTableAlias, sRightColumn);
      SplitInto2Parts('.', sRight, sLeftTableAlias, sLeftColumn);
    end
    else
    if pos(sRightTableAlias, sRight) > 0 then    
    begin
      SplitInto2Parts('.', sRight, sRightTableAlias, sRightColumn);
      SplitInto2Parts('.', sLeft, sLeftTableAlias, sLeftColumn);
    end;

    // �������� �� ���������� ����� ������� �� from
    sLeftTable := sLeftTableAlias;
    LocateTable(sFromClause, sLeftTable);

    // ���������� ���������� �������� ������
    AddJoins(sLeftTable, sRightTable, sLeftColumn, sRightColumn, StringReplace(sLeftTableAlias, '.', '', []), StringReplace(sRightTableAlias, '.', '', []));
    // ������� �������������� ������
    ASQL := StringReplace(ASQL, sJoin, '', []);
    iPos := PosAfter('LEFT JOIN', ASQL, iPos);    
  end;
end;

procedure TQueryTablesDataPoster.GetFromWhereClause(
  ASQL: string);
var sFromClause, sWhereClause, sTable, sTableAlias, sJoinString, sLeftTable, sRightTable,
    sRightColumn, sLeftColumn, sLeftTableAlias, sRightTableAlias: string;
    iPos, iNextPos, iPrevPos, iFirstPos: integer;
begin
  // ����� ������ ������ �� ������� ��������
  sFromClause := trim(copy(ASQL, pos(' FROM ', ASQL), Length(ASQL)));
  // ����� ������ �����������
  sWhereClause := trim(copy(ASQL, pos(' WHERE ', ASQL), Length(ASQL)));

  // ������� ����� FROM �� ������ ������
  sFromClause := StringReplace(sFromClause, sWhereClause, '', []);
  sFromClause := StringReplace(sFromClause, 'FROM ', '', []);
  // ������� ����� WHERE �� ������ �����������
  sWhereClause := StringReplace(sWhereClause, 'WHERE', '', []);
  
  // ���� ������ �������
  // ����������� ��� �������
  iPos := pos(',', sFromClause);
  iFirstPos := 0;
  // ���� ����� ������� ���,
  // �� ������ ��� �� ����������
  // ������� �� � ��� �� ������������ � Where
  while (iPos > 0) and (trim(sWhereClause) <> '') do
  begin
    // ����� ������ �������
    sTable := trim(copy(sFromClause, iFirstPos + 1, iPos-iFirstPos-1));
    iFirstPos := iPos;

    // ������� �� �� ��������� ������ from
    // ���������, ��� ��� ��������� � ����� �����������
    // sFromClause := StringReplace(sFromClause, sTable + ',', '', []);
    // ���� � ������� ���� ���������
    // �� ������ ���
    iPos := pos(' ', sTable);

    if iPos > 0 then
    begin
      // ������� ��������
      // ��������� ��������
      SplitInto2Parts(' ', sTable, sTable, sTableAlias);
      // ������ �� ���������� ��� ����� �������� as (���� ������������)
      sTableAlias := StringReplace(sTableAlias, 'as ', '', []);  
    end
    else
    begin
      // ���� ��� ����������, �� ���������, ��� �� ��������� ����� �������
      sTable := copy(sTable, 1, length(sTable));
      sTableAlias := sTable;
    end;

    // ���� ���������� ������� � ������ where
    iPos := pos(sTableAlias, sWhereClause);
    if iPos > 0 then
    begin
      // �������� ������ ����������
      // �������, ��� ��� ���������� �������� ��������
      iPrevPos := PosBefore('(', sWhereClause, iPos);
      iNextPos := PosAfter(')', sWhereClause, iPos);
      sJoinString := copy(sWhereClause, iPrevPos + 1, iNextPos - iPrevPos - 1);

      // ������� �� where - ������ �� �����������
      sWhereClause := StringReplace(sWhereClause, '(' + sJoinString + ')', '', []);

      // ������������ ������ - ����� �� �� ��� ����� �� '='
      SplitInto2Parts('=', sJoinString, sLeftTable, sRightTable);
      SplitInto2Parts('.', sLeftTable, sLeftTable, sLeftColumn);
      SplitInto2Parts('.', sRightTable, sRightTable, sRightColumn);

      // ��������, ����� �� ������ �� ���� ������ ������� �� From
      if sLeftTable = sTableAlias then
      begin
        sLeftTableAlias := sTableAlias;
        sRightTableAlias := sRightTable;
        sLeftTable := sTable;
        sTable := sRightTable;
        iPrevPos := 2;
      end
      else
      if sRightTable = sTableAlias then
      begin
        sRightTableAlias := sTableAlias;
        sLeftTableAlias := sLeftTable;
        sRightTable := sTable;
        sTable := sLeftTable;
        iPrevPos := 1;
      end;

      LocateTable(sFromClause, sTable);

      if iPrevPos = 1 then
        sLeftTable := sTable
      else sRightTable := sTable;

      // �������� ������������ ������ ��������
      AddJoins(sLeftTable, sRightTable, sLeftColumn, sRightColumn, StringReplace(sLeftTableAlias, '.', '', []), StringReplace(sRightTableAlias, '.', '', []));

    end;

    if iFirstPos = Length(sFromClause) then break;

    iPos := PosAfter(',', sFromClause, iFirstPos);
    if iPos = 0 then iPos := Length(sFromClause);
  end;
end;

function TQueryTablesDataPoster.GetObject(AData: variant): TBaseCollection;
var S: string;
    i, j, iPos: integer;
    rts: TReportTables;
begin
  S := AData;
  S := AnsiUpperCase(S);

  S := StringReplace(S, #13#10, ' ', [rfReplaceAll]);
  S := StringReplace(S, #32, ' ', [rfReplaceAll]);
  
  if not Assigned(FLastGotCollection) then
    FLastGotCollection := TConcreteReportTables.Create(nil)
  else FLastGotCollection.Clear;

  Result := FLastGotCollection;
  
  // ������� ���� ��� �������
  // � ��� ������� �����������
  // ������ ������ TConcreteTables
  if pos ('LEFT JOIN', S) > 0 then
    GetFromJoins(S);
  if pos (' WHERE ', S) > 0 then
    GetFromWhereClause(S);
  ParseFrom(S);

  // � ����� ��� ��������� ������
  // ��������� ������ select
  rts := FLastGotCollection as TReportTables;
  for i := 0 to rts.Count - 1 do
  begin
    for j := rts.Items[i].ColumnCount - 1 downto 0 do
    begin
      iPos := pos(AnsiUpperCase(rts.Items[i].QueryAlias + '.'+ rts.Items[i].Items[j].ColName), S);
      if iPos = 0 then
        rts.Items[i].Delete(j)
      else rts.Items[i].Items[j].Order := iPos;
    end;
    rts.Items[i].SortColumnsByOrder;
  end;
end;

function TQueryTablesDataPoster.GetPostingData(
  ABaseCollection: TBaseCollection): OleVariant;
var tbls: TReportTables;
    iAlias: integer;
    sSelect, sFrom, sQuery, sJoin, sAlias, sNextAlias: string;

function NextAlias: string;
begin
 Result := 't' + IntToStr(iAlias);
 inc(iAlias);
end;

procedure RecourceTables(ATable: TReportTable; AAlias: string; IncludeKeys: boolean);
var j: integer;
begin
  { TODO :
      ���� ������� �������� � select �������� ��� ������ �������
      ���� ����� ����� �����������
  }

  for j := 0 to ATable.ColumnCount - 1 do
  if IncludeKeys or (not IncludeKeys and not ATable.Items[j].Key) then 
    sSelect := sSelect + ', ' + AAlias + '.' + ATable.Items[j].ColName;

  for j := 0 to ATable.Joins.Count - 1 do
  begin
    sNextAlias := NextAlias;
    sJoin := sJoin + #13#10 + ' LEFT JOIN ' +
               ATable.Joins.Items[j].RightTable.TableName + ' ' + sNextAlias + ' ' +
               'ON (' + AAlias + '.' + ATable.Joins.Items[j].LeftColumn.ColName + ' = ' +
                        sNextAlias + '.' + ATable.Joins.Items[j].RightColumn.ColName + ') and ' +
               '(' + AAlias + '.Version_ID = ' + sNextAlias + '.Version_ID)';
    RecourceTables(ATable.Joins.Items[j].RightTable, sNextAlias, false);
  end;
end;


begin
  tbls := ABaseCollection as TReportTables;
  sSelect := ''; sFrom := ''; sJoin := '';
  iAlias := 1;
  // ������-�� ������� ������ ���� ����
  sAlias := NextAlias;
  if tbls.Count > 0 then
  begin
    sFrom := sFrom + ', ' + tbls.Items[0].TableName + ' ' + sAlias;
    RecourceTables(tbls.Items[0], sAlias, true);
    sSelect := trim(copy(sSelect, 2, Length(sSelect)));
    sFrom := trim(copy(sFrom, 2, Length(sFrom)));

    sQuery := 'select ' + sSelect + ' ' +
              'from ' + sFrom + ' ' +
              sJoin;
    Result := sQuery;
  end
  else Result := '';
end;

function TQueryTablesDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
var i, j: integer;
    r: TCommonReport;
    tbls: TReportTables;
    sQuery, sSelect, sRealSelect, sCopySelect: string;
    rExp: TRegExp;
    matches: MatchCollection;
    mch: Match;
  {
    ����� ABaseObject - CommonReport
    � ������ AbaseCollection - TReportTables
    ��� ��������� ��������� ������
    ������ ������ ��������� ����������� ���������
  }

begin
  r := ABaseObject as TCommonReport;
  tbls := r.ReportTables;

  sQuery := GetPostingData(tbls);

  if r.ArrangedColumns.Count > 0 then
  begin
    sSelect := trim(copy(sQuery, 1, pos('FROM', UpperCase(sQuery)) - 1));

    sQuery := trim(copy(sQuery, pos('FROM', UpperCase(sQuery)), Length(sQuery)));
    rExp := TRegExp.Create(nil);
    rExp.IgnoreCase := true;
    rExp.Global := true;

    sCopySelect := sSelect;
    sRealSelect := '';
    for i := 0 to r.ArrangedColumns.Count - 1 do
    begin
      rExp.Pattern := '(t\d\.){1}' + r.ArrangedColumns.Items[i].ColName;
      matches := rExp.Execute(sSelect) as MatchCollection;
      for j := 0 to matches.Count - 1 do
      begin
        mch := matches[j] as Match;
        sRealSelect := sRealSelect + ', ' + mch.Value;
        sCopySelect := StringReplace(sCopySelect, mch.Value, '', []);
      end;
      sSelect := sCopySelect;
    end;

    sQuery := 'select ' + trim(copy(sRealSelect, 2, Length(sRealSelect))) + ' ' + sQuery;
  end;
  Result := sQuery; 
end;

function TQueryTablesDataPoster.LocateTable(AFromClause: string; var ATable: string): string;
var iPos, iNextPos, iNext2Pos: integer;
    sTableAlias: string;
begin
  // ��� ������� ���� �� from
  // ����� ���� � ���������
  iPos := pos(' ' + ATable+', ', ' ' + AFromClause);
  if iPos = 0 then
    iPos := pos(' ' + ATable + ' ', AFromClause + ' ');
  if iPos = 0 then
    iPos := Pos(ATable, AFromClause);

  // ���� ��� ������ ������ ��� ���������� - �������
  // �� ��� ���������
  if not((iPos = 1) or (AFromClause[iPos - 1] = ',')) then
  begin
    // �������  ������ ������� ��
    iPos := PosBefore(',', AFromClause, iPos);
    //if iPos = 0 then iPos := 1;
    sTableAlias := trim(ATable);
    iNextPos := posAfter(' ', AFromClause, iPos + 1);
    iNext2Pos := posAfter(',', AFromClause, iPos + 1);
    if (iNext2Pos < iNextPos) and (iNext2Pos <> 0) then
      iNextPos := posAfter(',', AFromClause, iPos + 1);    

    ATable := trim(copy(AFromClause, iPos + 1, iNextPos - iPos - 1));

    AFromClause := StringReplace(AFromClause, ATable + ' as ' + sTableAlias + ', ', '', []);
    AFromClause := StringReplace(AFromClause, ATable + ' as ' + sTableAlias, '', []);
    AFromClause := StringReplace(AFromClause, ATable + ' ' + sTableAlias + ', ', '', []);
    AFromClause := StringReplace(AFromClause, ATable + ' ' + sTableAlias, '', []);
  end
  else
  begin
    AFromClause := StringReplace(AFromClause, ATable + ', ', '', []);
    AFromClause := StringReplace(AFromClause, ATable, '', []);
  end;

  Result := AFromClause;
end;

procedure TQueryTablesDataPoster.ParseFrom(ASQL: string);
var sFromClause, sTable, sTableAlias: string;
    iPos: integer;
    rts: TReportTables;
    lt: TReportTable;
begin
  // ����� ������ ������ �� ������� ��������
  // ��� ���� ������� - � ��� ���� �������
  sFromClause := trim(copy(ASQL, pos(' FROM ', ASQL), Length(ASQL)));
  // ������� ����� FROM �� ������ ������
  sFromClause := StringReplace(sFromClause, 'FROM ', '', []);
  // ���� ����� ��� ���� �������
  // �� ������
  // ������-�� ��� ��������� ������������
  // ���� ��� �� ������ �����������
  // ��� ��� ���� ����� � ����� ������
  // �� From ������ ����� �������
  // ��, ���, ����������, ������
  iPos := pos(',', sFromClause);
  if iPos = 0 then
  begin


    SplitInto2Parts(' ', sFromClause, sTable, sTableAlias);
    // �������� ������������ ���������� ��������
    if trim(sTable) <> '' then
    begin
      rts := FLastGotCollection as TReportTables;

      lt := rts.GetTableByName(sTable);
      if not Assigned(lt) then
      begin
        lt := rts.Add as TReportTable;
        // ��� ������� ����� ������� �������������� ������� �� tbl_Attribute
        lt.TableName := sTable;
      end;
    end;
  end;
end;

procedure TQueryTablesDataPoster.Prepare;
begin
end;

constructor TCommonReport.Create(ACollection: TIDObjects);
begin
  inherited;
  FExcel := TExcelApplication.Create(nil);
  FReportTables := TReportTables.Create(nil);
  FArrangedColumns := TReportColumns.Create;
  FGroups := TReportGroups.Create(Self);
end;

destructor TCommonReport.Destroy;
begin
  FExcel.Free;
  FReportTables.Free;
  FArrangedColumns.Free;
  FGroups.Free;
  inherited;
end;





{ TReportColumn }

procedure TReportColumn.AssignTo(Dest: TPersistent);
var rc: TReportColumn;
begin
  rc := Dest as TReportColumn;

  rc.ColName  := ColName;
  rc.RusColName := RusColName;
  rc.Order := Order;
  rc.Key := Key;
end;

function TReportColumn.List: string;
begin
  Result := RusColName;
  if Trim(result) = '' then
    Result := ColName;
end;

procedure TCommonReport.MakeGeneralReport(AFilter: TBaseCollection);
var sFilter: string;
    iResult: integer;
begin
  Data := AFilter;

  if (AFilter.Count > 0) then
  begin
    sFilter := PrepareData(false);

    TMainFacade.GetInstance.DBGates.Server.NeedAdoRecordset := true;
    if pos('where', Query) > 0 then
      iResult := TMainFacade.GetInstance.DBGates.Server.ExecuteQuery(Query + ' and (' + sFilter + ')')
    else
      iResult := TMainFacade.GetInstance.DBGates.Server.ExecuteQuery(Query + ' where ' + sFilter);

    TMainFacade.GetInstance.DBGates.Server.NeedAdoRecordset := false;      
    if (iResult > 0) then
    begin
      FReportResult := TMainFacade.GetInstance.DBGates.Server.QueryResultAsADORecordSet;
      TMainFacade.GetInstance.DBGates.Server.NeedAdoRecordset := false;
      // ����������� � Excel
      // ����������� ������ � ��������������� �������
      // ���� ������ - ������� ������ �������
      if Groups.Count = 0 then
        MoveDataToExcelEx
      else MoveGroupedDataToExcel;
    end;
  end;
end;

procedure TCommonReport.MoveDataToExcelEx;
var i, j, iHeader: integer;
    wb: _WorkBook;
    sh: OleVariant;
    rpts: TReports;
begin
  // �����������
  rpts := Collection as TReports;
  wb := Connect;


  // ���������� ������������
  FReportResult.MoveFirst;
  i := MakeHeader;
  iHeader := i;

  while not FReportResult.Eof do
  begin
    // ���������� �����
    FExcel.Cells.Item[i, 1].Value := i - iHeader + 1;

    for j := 0 to FReportResult.Fields.Count - 1 do
    if VarType(FReportResult.Fields[j].Value) <> varOleStr then
      FExcel.Cells.Item[i, j + 2] := FReportResult.Fields[j].Value
    else
      FExcel.Cells.Item[i, j + 2] := Trim(VarAsType(FReportResult.Fields[j].Value,  varOleStr));



    if Assigned(rpts.MovePrg) then rpts.MovePrg(0, FReportResult.RecordCount - 1, 1);
    FReportResult.MoveNext;
    inc(i);
  end;

  sh := wb.ActiveSheet;

  // ��������� ������
  for i := 1 to FReportResult.Fields.Count do
   sh.Columns.Item[i].AutoFit;

  // ���� ������ - ������� ������ �������
  if Option = roRemoveEmpties then RemoveEmptyCols;
  Disconnect(wb);
end;

procedure TCommonReport.AssignTo(Dest: TPersistent);
var r: TCommonReport;
begin
  r := Dest as TCommonReport;

  r.Query := Query;
  r.ReportName := ReportName;
  r.TemplateName := TemplateName;
  r.Option := Option;
  r.OneSample := OneSample;
  r.Level := Level;
  r.ArrangedColumns.Assign(ArrangedColumns);
  r.Groups.Assign(Groups);
end;

{ TReportActionList }

constructor TReportActionList.Create(AOwner: TComponent);
begin
  inherited;

end;

{ TReportBaseEditAction }

constructor TReportBaseEditAction.Create(AOwner: TComponent);
begin
  inherited;

  Caption := '������������� �����';
  CanUndo := false;
  Visible := true;
end;

destructor TReportBaseEditAction.Destroy;
begin
  inherited;
end;

function TReportBaseEditAction.Execute(ABaseObject: TBaseObject): boolean;
var dp: RRManagerPersistentObjects.TDataPoster;
begin
  Result := true;
  if not Assigned(frmEditReport) then frmEditReport := TfrmEditReport.Create(Self);
  frmEditReport.EditingObject := ABaseObject;
  frmEditReport.dlg.ActiveFrameIndex := 0;

  if frmEditReport.ShowModal = mrOK then
  begin
    frmEditReport.Save;
    ABaseObject := (frmEditReport.Dlg.Frames[0] as TbaseFrame).EditingObject;
    // ����� ������
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TReportsDataPoster];
    // �������������� ���������
    dp.PostToDB(ABaseObject);

    // ����� ������ �������
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TReportGroupDataPoster];
    dp.LastGotCollection := (ABaseObject as TCommonReport).Groups;
    dp.PostToDB((ABaseObject as TCommonReport).Groups, true);

    // ��������� �������������
    AllReports.NeedsUpdate := true;
  end;
end;

{ TReportBaseAddAction }

constructor TReportBaseAddAction.Create(AOwner: TComponent);
begin
  inherited;

  Caption := '������� �����';
  CanUndo := false;
  Visible := true;
end;

destructor TReportBaseAddAction.Destroy;
begin
  inherited;
end;

function TReportBaseAddAction.Execute: boolean;
begin
  Result := inherited Execute(nil);
end;

{ TReportFilters }

function TReportFilters.Add: TReportFilter;
begin
  Result := inherited Add as TReportFilter;
end;

constructor TReportFilters.Create(AOwner: TBaseObject);
begin
  inherited Create(TReportFilter);
  FOwner := AOwner;
end;

function TReportFilters.GetFilterByReportID(AID: integer): TReportFilter;
var  i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Assigned(Items[i].Report) and (Items[i].Report.ID = AID) then
  begin
    Result := Items[i];
    break;
  end;
end;

function TReportFilters.GetITems(const Index: integer): TReportFilter;
begin
  Result := inherited Items[Index] as TReportFilter;
end;

function TCommonReport.PrepareData(const UseReportFilterTable: boolean): string;
var rpts: TReports;
    i: integer;
begin

  if UseReportFilterTable then
  begin
    i := TMainFacade.GetInstance.DBGates.Server.DeleteRow('tbl_Report_Filter', 'Employee_ID = '+inttostr(TMainFacade.GetInstance.DBGates.EmployeeID));
    if i < 0 then raise EDataAccessError.Create(i, 'tbl_Report_Filter', '', '');
  end;

  case Level of
  0: Result := PrepareDataForStructures(UseReportFilterTable);
  1: Result := PrepareDataForHorizons(UseReportFilterTable);
  2: Result := PrepareDataForBeds(UseReportFilterTable);
  3: Result := PrepareDataForSubstructures(UseReportFilterTable);
  4: Result := PrepareDataForLayers(UseReportFilterTable);
  end;


  if Assigned((TMainFacade.GetInstance as TMainFacade).ActiveVersion) then
  if trim(Result) <> '' then
    Result := Result + ' and (t1.Version_ID = ' + IntToStr((TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID) + ')'
  else
    Result := '(t1.Version_ID = ' + IntToStr((TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID) + ')';

  Result := Result + ' ' + Groups.OrderString;
end;

function TCommonReport.PrepareDataForBeds(const UseReportFilterTable: boolean): string;
var s, b: integer;
    vFilterSamples: variant;
    rpts: TReports;
    dp: RRManagerPersistentObjects.TDataPoster;
begin
  Result := '';

  if UseReportFilterTable then
  begin
    vFilterSamples := varArrayCreate([0, 3, 0, 0], varInteger);
    for s := 0 to Data.Count - 1 do
    begin
      for b := 0 to (Data.Items[s] as TOldField).Beds.Count - 1 do
      begin
        vFilterSamples[0, 0] := (Data.Items[s] as TOldField).Beds.Items[b].ID;
        vFilterSamples[1, 0] := 2;
        vFilterSamples[2, 0] := TMainFacade.GetInstance.DBGates.EmployeeID;
        vFilterSamples[3, 0] := MainReportID;
        TMainFacade.GetInstance.DBGates.Server.InsertRow('spd_Set_Report_Filter', null, vFilterSamples);
        Result := Result + ', ' + IntToStr((Data.Items[s] as TOldField).Beds.Items[b].ID);
      end;
    end;
  end
  else
  begin
    for s := 0 to Data.Count - 1 do
    for b := 0 to (Data.Items[s] as TOldField).Beds.Count - 1 do
      Result := Result + ', ' + IntToStr((Data.Items[s] as TOldField).Beds.Items[b].ID);
  end;

  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.PosterByObjectClass[TOldBed];
  Result := 't1.' + dp.KeyColumn + ' in (' + trim(Copy(Result, 2, Length(Result))) + ')';
end;

function TCommonReport.PrepareDataForHorizons(const UseReportFilterTable: boolean): string;
var s, h: integer;
    dp: RRManagerPersistentObjects.TDataPoster;
    rpts: TReports;
    vFilterSamples: variant;
begin
  rpts := Collection as TReports;
  Result := '';
  if UseReportFilterTable then
  begin
    vFilterSamples := varArrayCreate([0, 3, 0, 0], varInteger);


    for s := 0 to Data.Count - 1 do
    begin
      for h := 0 to (Data.Items[s] as TOldStructure).Horizons.Count - 1 do
      begin
        vFilterSamples[0, 0] := (Data.Items[s] as TOldStructure).Horizons.Items[h].ID;
        vFilterSamples[1, 0] := 1;
        vFilterSamples[2, 0] := TMainFacade.GetInstance.DBGates.EmployeeID;
        vFilterSamples[3, 0] := MainReportID;
        TMainFacade.GetInstance.DBGates.Server.InsertRow('spd_Set_Report_Filter', null, vFilterSamples);
        Result := Result + ', ' + IntToStr((Data.Items[s] as TOldStructure).Horizons.Items[h].ID);
      end;
    end;
  end
  else
  begin
    for s := 0 to Data.Count - 1 do
    for h := 0 to (Data.Items[s] as TOldStructure).Horizons.Count - 1 do
      Result := Result + ', ' + IntToStr((Data.Items[s] as TOldStructure).Horizons.Items[h].ID);
  end;

  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.PosterByObjectClass[TOldHorizon];
  Result := 't1.' + dp.KeyColumn + ' in (' + trim(Copy(Result, 2, Length(Result))) + ')';
end;

function TCommonReport.PrepareDataForLayers(const UseReportFilterTable: boolean): string;
var s, h, subs, l: integer;
    rpts: TReports;
    vFilterSamples: variant;
    dp: RRManagerPersistentObjects.TDataPoster;
begin
  rpts := Collection as TReports;
  Result := '';
  if UseReportFilterTable then
  begin
    vFilterSamples := varArrayCreate([0, 3, 0, 0], varInteger);

    for s := 0 to Data.Count - 1 do
    begin
      for h := 0 to (Data.Items[s] as TOldStructure).Horizons.Count - 1 do
      begin
        for subs := 0 to (Data.Items[s] as TOldStructure).Horizons.Items[h].Substructures.Count - 1 do
        begin
          for l := 0 to (Data.Items[s] as TOldStructure).Horizons.Items[h].Substructures.Items[subs].Layers.Count - 1 do
          begin
            vFilterSamples[0, 0] := (Data.Items[s] as TOldStructure).Horizons.Items[h].Substructures.Items[subs].Layers.Items[l].ID;
            vFilterSamples[1, 0] := 4;
            vFilterSamples[2, 0] := TMainFacade.GetInstance.DBGates.EmployeeID;
            vFilterSamples[3, 0] := MainReportID;
            TMainFacade.GetInstance.DBGates.Server.InsertRow('spd_Set_Report_Filter', null, vFilterSamples);
            Result := Result + ', ' + IntToStr((Data.Items[s] as TOldStructure).Horizons.Items[h].Substructures.Items[subs].Layers.Items[l].ID);

          end;
        end;
      end;
    end;
  end
  else
  begin
    for s := 0 to Data.Count - 1 do
    for h := 0 to (Data.Items[s] as TOldStructure).Horizons.Count - 1 do
    for subs := 0 to (Data.Items[s] as TOldStructure).Horizons.Items[h].Substructures.Count - 1 do
    for l := 0 to (Data.Items[s] as TOldStructure).Horizons.Items[h].Substructures.Items[subs].Layers.Count - 1 do
       Result := Result + ', ' + IntToStr((Data.Items[s] as TOldStructure).Horizons.Items[h].Substructures.Items[subs].Layers.Items[l].ID);
  end;

  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.PosterByObjectClass[TOldLayer];
  Result := 't1.' + dp.KeyColumn + ' in (' + trim(Copy(Result, 2, Length(Result))) + ')';
end;

function TCommonReport.PrepareDataForStructures(const UseReportFilterTable: boolean): string;
var i: integer;
    rpts: TReports;
    vFilterSamples: variant;
    dp: RRManagerPersistentObjects.TDataPoster;

begin
  rpts := Collection as TReports;

  Result := '';

  if UseReportFilterTable then
  begin
    vFilterSamples := varArrayCreate([0, 3, 0, 0], varInteger);

    for i := 0 to Data.Count - 1 do
    begin
      vFilterSamples[0, 0] := Data.Items[i].ID;
      vFilterSamples[1, 0] := 0;
      vFilterSamples[2, 0] := TMainFacade.GetInstance.DBGates.EmployeeID;
      vFilterSamples[3, 0] := MainReportID;
      TMainFacade.GetInstance.DBGates.Server.InsertRow('spd_Set_Report_Filter', null, vFilterSamples);

      Result := Result + ', ' + IntToStr(Data.Items[i].ID);
    end;
  end
  else
  for i := 0 to Data.Count - 1 do
    Result := Result + ', ' + IntToStr(Data.Items[i].ID);

  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.PosterByObjectClass[TOldStructure];
  Result := 't1.' + dp.KeyColumn + ' in (' + Copy(Result, 2, Length(Result)) + ')';
end;

function TCommonReport.PrepareDataForSubstructures(const UseReportFilterTable: boolean): string;
var s, h, subs: integer;
    rpts: TReports;
    vFilterSamples: variant;
    dp: RRManagerPersistentObjects.TDataPoster;
begin
  rpts := Collection as TReports;
  Result := '';
  if UseReportFilterTable then
  begin
    vFilterSamples := varArrayCreate([0, 3, 0, 0], varInteger);
    for s := 0 to Data.Count - 1 do
    begin
      for h := 0 to (Data.Items[s] as TOldStructure).Horizons.Count - 1 do
      begin
        for subs := 0 to (Data.Items[s] as TOldStructure).Horizons.Items[h].Substructures.Count - 1 do
        begin
          vFilterSamples[0, 0] := (Data.Items[s] as TOldStructure).Horizons.Items[h].Substructures.Items[subs].ID;
          vFilterSamples[1, 0] := 3;
          vFilterSamples[2, 0] := TMainFacade.GetInstance.DBGates.EmployeeID;
          vFilterSamples[3, 0] := MainReportID;
          TMainFacade.GetInstance.DBGates.Server.InsertRow('spd_Set_Report_Filter', null, vFilterSamples);
          Result := Result + ', ' + IntToStr((Data.Items[s] as TOldStructure).Horizons.Items[h].Substructures.Items[subs].ID);
        end;
      end;
    end;
  end
  else
  begin
    for s := 0 to Data.Count - 1 do
    for h := 0 to (Data.Items[s] as TOldStructure).Horizons.Count - 1 do
    for subs := 0 to (Data.Items[s] as TOldStructure).Horizons.Items[h].Substructures.Count - 1 do
       Result := Result + ', ' + IntToStr((Data.Items[s] as TOldStructure).Horizons.Items[h].Substructures.Items[subs].ID);
  end;

  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.PosterByObjectClass[TOldSubstructure];
  Result := 't1.' + dp.KeyColumn + ' in (' + trim(Copy(Result, 2, Length(Result))) + ')';
end;

{ TReportGroup }

procedure TReportGroup.AssignTo(Dest: TPersistent);
var rg: TReportGroup;
begin
  rg := Dest as TReportGroup;
  rg.Visible := Visible;
  rg.GroupingColumn.Assign(GroupingColumn);
  rg.AggregateColumns.Assign(AggregateColumns);

end;

constructor TReportGroup.Create(ACollection: TIDObjects);
begin
  inherited;
  Visible := true;
  FGroupingColumn := TReportColumn.Create;
  FAggregateColumns := TReportColumns.Create(Self);
end;

destructor TReportGroup.Destroy;
begin
  FGroupingColumn.Free;
  FAggregateColumns.Free;
  inherited;
end;

function TReportGroup.List(ListOption: TListOption; IncludeKey,
  Recource: boolean): string;
begin
  Result := GroupingColumn.RusColName;
end;

{ TReportGroups }

function TReportGroups.Add: TReportGroup;
begin
  Result := inherited Add as TReportGroup;
end;

constructor TReportGroups.Create(AOwner: TBaseObject);
begin
  inherited Create(TReportGroup);
  FOwner := AOwner;
end;

function TReportGroups.GetItems(const Index: integer): TReportGroup;
begin
  Result := inherited Items[Index] as TReportGroup;
end;

function TReportGroups.IndexOfColName(const AColName: string): integer;
var i: integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
  if Items[i].GroupingColumn.ColName = AColName then
  begin
    Result := i;
    break;
  end;
end;

procedure TCommonReport.MoveGroupedDataToExcel;
var i, j, iFirstRow, iColIndex: integer;
    wb: _WorkBook;
    sh: OleVariant;
    rpts: TReports;
    sFieldName: string;
    c: TReportColumn;
    rg: TReportGroup;

function CloseGroup(ARowIndex: integer; AGroup: TReportGroup): integer;
var i: integer;
begin
  Result := ARowIndex;
  for i := 0 to AGroup.AggregateColumns.Count - 1 do
  begin
    FExcel.Cells.Item[Result, 1] := AGroup.AggregateColumns.Items[i].RusColName;
    FExcel.Cells.Item[Result, 1] := FReportResult.Fields[AGroup.FFieldNum].Value;
    Result := ARowIndex + 1;
  end;
  // ���������� ������ �� �����
end;

function OpenGroup(ARowIndex: integer; AGroup: TReportGroup): integer;
begin
  Result := ARowIndex + 1;
  FExcel.Cells.Item[ARowIndex, 1] := FReportResult.Fields[AGroup.FFieldNum].Value;
end;

begin
  // �����������
  rpts := Collection as TReports;
  wb := Connect;


  // ���������� ������������
  FReportResult.MoveFirst;


  // �������� �� ������� � ��� �� ��������
  // ����� ������ ����� ������ ����� �������� �� �������

  // ���� � ������� ���������� ������ �������, �� ������� �������� �����������
  for j := 0 to FReportResult.Fields.Count - 1 do
  begin
    i := Groups.IndexOfColName(FReportResult.Fields[j].Name);
    if i > -1 then
    begin
      Groups.Items[i].FieldNum := j;
      Groups.Items[i].FieldValue := '';
    end;
  end;

  i := MakeHeader;
  iFirstRow := i;

  while not FReportResult.Eof do
  begin
    // �������� �� �������
    // ���� ��� ��������� ������
    for j := 0 to Groups.Count - 1 do
    if (varAsType(FReportResult.Fields[Groups.Items[j].FieldNum].Value, varOleStr) <> varAsType(Groups.Items[j].FieldValue, varOleStr)) then
    begin
      // ��������� ������ ������
      if i <> iFirstRow then i := CloseGroup(i, Groups.Items[j]);
      // ������� �����
      if Groups.Items[j].Visible then i := OpenGroup(i, Groups.Items[j]);
      Groups.Items[j].FieldValue := FReportResult.Fields[Groups.Items[j].FieldNum].Value;
    end;

    // ���������� �����
    FExcel.Cells.Item[i, 1].Value := i - 1;

    for j := 0 to FReportResult.Fields.Count - 1 do
    if (FGroups.IndexOfColName(FReportResult.Fields[j].Name) = -1)
    and not (FGroups.IsColumnUsed(FReportResult.Fields[j].Name)) then
      FExcel.Cells.Item[i, j + 2] := FReportResult.Fields[j].Value;

    if Assigned(rpts.MovePrg) then rpts.MovePrg(0, FReportResult.RecordCount - 1, 1);
    FReportResult.MoveNext;
    inc(i);
  end;


  sh := wb.ActiveSheet;
  // ���� ������ - ������� ������ �������
  if Option = roRemoveEmpties then RemoveEmptyCols;
  Disconnect(wb);
end;

function TReportGroups.IsColumnUsed(const AColName: string): boolean;
var i: integer;
begin
  Result := false;
  for i := 0 to Count - 1 do
  if Items[i].AggregateColumns.IndexByName(AColName) > -1 then
  begin
    Result := true;
    break;
  end;
end;

function TReportGroups.OrderString: string;
var i: integer;
begin
  Result := '';
  for i := 0 to Count - 1 do
    Result := Result + ', ' + Items[i].GroupingColumn.ColName;

  if (trim(Result) <> '') then
    Result := ' order by ' + copy(trim(Result), 2, Length(Result));
end;

function TCommonReport.MakeHeader: integer;
var i, j: integer;
    sFieldName: string;
    c: TReportColumn;
    rpts: TReports;
begin
  // � ����� ������ ���������� ���������� ������
  Result := 3;
  rpts := Collection as TReports;

  FReportResult.MoveFirst;

  FExcel.Cells.Item[1, 1].Value := '�';
  FExcel.Cells.Item[2, 1].Value := 1;  
  for j := 0 to FReportResult.Fields.Count - 1 do
  begin
    sFieldName := FReportResult.Fields[j].Name;
    for i := 0 to AllConcreteTables.Count - 1 do
    begin
      c := AllConcreteTables.Items[i].Columns[sFieldName];
      if Assigned(c) then
      begin
        sFieldName := c.RusColName;
        break;
      end;
    end;

    FExcel.Cells.Item[1, j + 2].Value := sFieldName;
    FExcel.Cells.Item[2, j + 2].Value := j + 2;
    if Assigned(rpts.MoveHeaderPrg) then rpts.MoveHeaderPrg(0, FReportResult.Fields.Count - 1, 1);
  end;
end;

{ TReportGroupDataPoster }

constructor TReportGroupDataPoster.Create;
begin
  inherited;
  FLastPostedAttribute := -1;
end;

{function TReportGroupDataPoster.GetDeletingData(
  ABaseObject: TBaseObject): OleVariant;
begin
  Result := varArrayOf([(ABaseObject as TReportGroup).ID]);
end;}

function TReportGroupDataPoster.GetDeletingData(
  ABaseCollection: TBaseCollection): OleVariant;
var rgs: TReportGroups; 
begin
  rgs := ABaseCollection as TReportGroups;
  Result := varArrayOf([(rgs.FOwner as TCommonReport).ID]);
end;

function TReportGroupDataPoster.GetObject(AData: variant): TBaseCollection;
var i: integer;
    rc: TReportColumn;
    r: TReportGroup;
    iLastGroupID: integer;
begin
{
  0 rg.group_id,
  1 ma.attribute_id,
  2 ma.vch_attribute_name,
  3 ma.vch_rus_attribute_name,
  4 sa.attribute_id,
  5 sa.vch_attribute_name,
  6 sa.vch_rus_attribute_name
}
  if not Assigned(FLastGotCollection) then
    FLastGotCollection := TReportGroups.Create(nil)
  else FLastGotCollection.Clear;

  iLastGroupID := -1;
  Result := FLastGotCollection;

  if not varIsEmpty(AData) then
  for i := 0 to varArrayHighBound(AData, 2) do
  begin
    if iLastGroupID <> AData[0, i] then
    begin
      r := (FLastGotCollection as TReportGroups).Add;
      r.ID := AData[0, i];
      r.GroupingColumn.ColName := trim(varAsType(AData[2, i], varOleStr));
      r.GroupingColumn.RusColName := trim(varAsType(AData[3, i], varOleStr));
    end;

    if Assigned(r) and (not ((varType(AData[4, i])= varEmpty) or (varType(AData[4, i]) = varNull))) then
    begin
      rc := r.AggregateColumns.Add(trim(varAsType(AData[5, i], varOleStr)));
      rc.RusColName := trim(varAsType(AData[6, i], varOleStr));
    end;
  end;
end;

function TReportGroupDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
var R: TReportGroup;
    vSubAttributeID: variant;
begin
  {
    GROUP_ID
    REPORT_ID
    MAIN_ATTRIBUTE_ID
    SUB_ATTRIBUTE_ID
  }
  R := ABaseObject as TReportGroup;
  FLastPostedAttribute := FLastPostedAttribute + 1;

  if (FLastPostedAttribute >= 0) and (FLastPostedAttribute <  r.AggregateColumns.Count) then
    vSubAttributeID := R.AggregateColumns.Items[FLastPostedAttribute].ColName
  else
  begin
    if (FLastPostedAttribute >=  r.AggregateColumns.Count) then FLastPostedAttribute := -1;
    vSubAttributeID := null;
  end;
  Result := varArrayOf([r.ID, ((r.Collection as TReportGroups).Owner as TCommonReport).ID, R.GroupingColumn.ColName, vSubAttributeID]);
end;

function TReportGroupDataPoster.GetProxy(
  const AUIN: integer): TBaseCollection;
begin
  Result := nil;
end;

procedure TReportGroupDataPoster.Prepare;
begin
  FGettingTable := '';
  FGettingColumns := '';

  FOrder := '';

  FPostingColumns := '*';
  FPostingTable := 'spd_Add_Report_Group';
  FQuery := 'select rg.group_id, ma.attribute_id, ma.vch_attribute_name, ' +
            'ma.vch_rus_attribute_name, sa.attribute_id, sa.vch_attribute_name, ' +
            'sa.vch_rus_attribute_name ' +
            'from tbl_report_group rg  ' +
            'left join tbl_report_group_attribute rga on (rga.group_id = rg.group_id) ' +
            'left join tbl_Attribute ma on (rg.attribute_id = ma.attribute_id) ' +
            'left join tbl_attribute sa on (rga.attribute_id = sa.attribute_id)';
  FKeyColumn := 'rg.Group_ID';
  FDeletingTable := 'spd_Delete_Report_Groups';
end;

end.
