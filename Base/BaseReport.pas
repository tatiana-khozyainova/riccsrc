unit BaseReport;

interface

uses BaseObjects, Variants, DB, Contnrs, Classes;

type
  TReport = class;

  TReportBlockColumn = class(TPersistent)
  private
    FColumnID: byte;
    FColumnName: string;
    FColumnDataType: TFieldType;
    FVisible: boolean;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property ColumnID: byte read FColumnID write FColumnID;
    property ColumnName: string read FColumnName write FColumnName;
    property ColumnDataType: TFieldType read FColumnDataType write FColumnDataType;
    property Visible: boolean read FVisible write FVisible;
  end;

  TColumnIdsSet = set of byte;

  TReportBlockColumns = class(TObjectList)
  private
    function GetItems(Index: integer): TReportBlockColumn;
    function GetVisibleColumnCount: integer;
  public
    function Add: TReportBlockColumn; overload;
    function Add(AColumnID: integer; AColumnName: string; AColumnDataType: TFieldType; AVisible: boolean): TReportBlockColumn; overload; 
    function GetReportHeader: OleVariant;
    function GetVisibleColumnIDs: TColumnIdsSet;

    property VisibleColumnCount: integer read GetVisibleColumnCount;
    property Items[Index: integer]: TReportBlockColumn read GetItems;

    constructor Create; virtual;
  end;



  TReportBlock = class(TIDObject)
  private
    FTop: integer;
    FLeft: integer;
  protected
    FReportingObject: TIDObject;
    FReportingCollection: TIDObjects;
    FBlockHeader: OleVariant;
    FBlockData: OleVariant;
    FReportBlockColumns: TReportBlockColumns;
    procedure SetReportingObject(const Value: TIDObject); virtual;
    procedure SetReportingCollection(const Value: TIDObjects); virtual;
    function  GetBlockHeader: OleVariant; virtual;
    function  GetBlockData: OleVariant; virtual;
    function  GetHeight: integer; virtual;
    function  GetWidth: integer; virtual;
    function  GetReportBlockColumns: TReportBlockColumns; virtual;
  public
    property  Left: integer read FLeft write FLeft;
    property  Top:  integer read FTop write FTop;
    property  Width: integer read GetWidth;
    property  Height: integer read GetHeight;

    property  ReportingObject: TIDObject read FReportingObject write SetReportingObject;
    property  ReportingCollection: TIDObjects read FReportingCollection write SetReportingCollection;
    property  ReportBlockColumns: TReportBlockColumns read GetReportBlockColumns;


    property  BlockData: OleVariant read GetBlockData;
    property  BlockHeader: OleVariant read GetBlockHeader;
    procedure Clear; virtual;

    constructor Create; reintroduce; virtual;
  end;

  TReportBlocks = class(TIDObjects)
  private
    function GetItems(Index: integer): TReportBlock;
  public
    property Items[Index: integer]: TReportBlock read GetItems; default;
    constructor Create; override;
  end;

  TComplexReportBlock = class(TReportBlock)
  private
    FReportBlocks: TReportBlocks;
    function   GetReportBlocks: TReportBlocks;
  protected
    procedure  SetReportingObject(const Value: TIDObject); override;
    procedure  SetReportingCollection(const Value: TIDObjects); override;
    function   GetReportBlockColumns: TReportBlockColumns; override;
    function   GetHeight: integer; override;
    function   GetWidth: integer; override;
    function   GetBlockData: OleVariant; override;
  public
    procedure  Clear; override;  
    property   ReportingCollection: TIDObjects read FReportingCollection write SetReportingCollection;
    property   Blocks: TReportBlocks read GetReportBlocks;
    destructor Destroy; override;
  end;


  IReportVisitor = interface
    procedure MakeSingleObjectReport(AObject: TIDObject; Report: TReport);
    procedure MakeCollectionReport(ACollection: TIDObjects; Report: TReport);
    procedure MakeDatasetReport(ADataSet: TDataSet; Report: TReport);
  end;

  TDataMover = class(TInterfacedObject, IReportVisitor)
  private
    FName: string;
  public
    procedure Prepare; virtual; abstract;
    procedure MakeSingleObjectReport(AObject: TIDObject; Report: TReport); virtual;
    procedure MakeCollectionReport(ACollection: TIDObjects; Report: TReport); virtual;
    procedure MakeDatasetReport(ADataSet: TDataSet; Report: TReport); virtual;

    property  Name: string read FName write FName;

    constructor Create; virtual;
  end;

  TDataMoverClass = class of TDataMover;

  TDataMovers = class(TObjectList)
  private
    function GetItems(Index: integer): TDataMover;
    function GetItemByClassType(
      ADataMoverClass: TDataMoverClass): TDataMover;
  public
    property Items[Index: integer]: TDataMover read GetItems;
    property ItemByClassType[ADataMoverClass: TDataMoverClass]: TDataMover read GetItemByClassType;
    procedure MakeList(AList: TStrings);
    constructor Create; virtual;
  end;

  TTableReport = class(TIDObjectTable)
  private
    FReportTitle: string;
    function    GetItems(ACol, ARow: integer): TReportBlock;
    procedure   SetItems(ACol, ARow: integer; const Value: TReportBlock);
  public
    procedure   MakeReport(ADataMover: TDataMover); virtual;
    property    ReportTitle: string read FReportTitle write FReportTitle;
    property    Items[ACol, ARow: integer]: TReportBlock read GetItems write SetItems;
    constructor Create; override;
  end;


  TReport = class(TIDObject)
  private
    FReportTitle: string;
    FReportBlock: TReportBlock;
    procedure SetReportBlock(const Value: TReportBlock);
    function  GetReportBlockColumns: TReportBlockColumns;
  public
    procedure   MakeReport(ADataMover: TDataMover); virtual;
    property    ReportTitle: string read FReportTitle write FReportTitle;
    property    Block: TReportBlock read FReportBlock write SetReportBlock;
    property    ReportColumns: TReportBlockColumns read GetReportBlockColumns;
    constructor Create; reintroduce; virtual;
  end;


  TSingleObjectReport = class(TReport)
  protected
    procedure   SetReportObject(const Value: TIDObject); virtual;
    function    GetReportObject: TIDObject; virtual;
  public
    procedure   MakeReport(ADataMover: TDataMover); override;
    property    ReportObject: TIDObject read GetReportObject write SetReportObject;
  end;

  TCollectionReport = class(TReport)
  protected
    procedure   SetReportObjects(const Value: TIDObjects); virtual;
    function    GetReportObjects: TIDObjects; virtual;
  public
    procedure   MakeReport(ADataMover: TDataMover); override;
    property    ReportObjects: TIDObjects read GetReportObjects write SetReportObjects;
  end;

  TDataSetReport = class(TReport)
  protected
    FDataSet: TDataSet;
    procedure SetDataSet(const Value: TDataSet); virtual;
  public
    procedure   MakeReport(ADataMover: TDataMover); override;
    property    DataSet: TDataSet read FDataSet write SetDataSet;
  end;

implementation

{ TReportBlock }

procedure TReportBlock.Clear;
begin
  FBlockHeader := null;
  FBlockData := null;
end;

constructor TReportBlock.Create;
begin
  inherited Create(nil);
end;

function TReportBlock.GetBlockData: OleVariant;
begin
  Result := FBlockData;
end;

function TReportBlock.GetBlockHeader: OleVariant;
begin
  if varIsNull(FBlockHeader) then
    FBlockHeader := ReportBlockColumns.GetReportHeader;
    
  Result := FBlockHeader;
end;

function TReportBlock.GetHeight: integer;
begin
  try
    Result := varArrayHighBound(BlockData, 1);
  except
    Result := 0;
  end;
end;

function TReportBlock.getReportBlockColumns: TReportBlockColumns;
begin
  if not Assigned(FReportBlockColumns) then
    FReportBlockColumns := TReportBlockColumns.Create;

  Result := FReportBlockColumns;
end;

function TReportBlock.GetWidth: integer;
begin
  try
    Result := varArrayHighBound(BlockData, 2);
  except
    Result := 0;
  end;
end;

procedure TReportBlock.SetReportingCollection(const Value: TIDObjects);
begin
  if FReportingCollection <> Value then
    FReportingCollection := Value;
end;

procedure TReportBlock.SetReportingObject(const Value: TIDObject);
begin
  if FReportingObject <> Value then
    FReportingObject := Value;
end;

{ TReportBlocks }

constructor TReportBlocks.Create;
begin
  inherited;
  FObjectClass := TReportBlock;
end;

function TReportBlocks.GetItems(Index: integer): TReportBlock;
begin
  Result := inherited Items[Index] as TReportBlock;
end;

{ TTableReport }

constructor TTableReport.Create;
begin
  inherited Create;
end;

function TTableReport.GetItems(ACol, ARow: integer): TReportBlock;
begin
  Result := inherited Items[ACol, ARow] as TReportBlock;
end;

procedure TTableReport.MakeReport(ADataMover: TDataMover);
begin

end;

procedure TTableReport.SetItems(ACol, ARow: integer; const Value: TReportBlock);
begin
  inherited Items[ACol, ARow] := Value;
end;

function TSingleObjectReport.GetReportObject: TIDObject;
begin
  Result := FReportBlock.ReportingObject;    
end;

procedure TSingleObjectReport.MakeReport(ADataMover: TDataMover);
begin
  inherited;
  Block.Clear;
  ADataMover.MakeSingleObjectReport(ReportObject, Self);
end;

procedure TSingleObjectReport.SetReportObject(const Value: TIDObject);
begin
  FReportBlock.ReportingObject := Value;
end;

function TCollectionReport.GetReportObjects: TIDObjects;
begin
  Result := Block.ReportingCollection;  
end;

procedure TCollectionReport.MakeReport(ADataMover: TDataMover);
begin
  inherited;
  Block.Clear;
  ADataMover.MakeCollectionReport(ReportObjects, Self);
end;

procedure TCollectionReport.SetReportObjects(const Value: TIDObjects);
begin
  Block.ReportingCollection := Value;
end;

{ TComplexReportBlock }

procedure TComplexReportBlock.Clear;
var i: integer;
begin
  inherited;
  for i := 0 to Blocks.Count - 1 do
    Blocks.Items[i].Clear;
end;

destructor TComplexReportBlock.Destroy;
begin
  if Assigned(FReportBlocks) then FReportBlocks.Free;
  inherited;
end;

function TComplexReportBlock.GetBlockData: OleVariant;
var i, j, k: integer;
    iWidth, iHeight, iCurrentColumn: integer;
begin
  iWidth := 0;
  iHeight := Blocks.Items[0].Height;

  for i := 0 to Blocks.Count  - 1 do
  begin
    iWidth := iWidth + Blocks.Items[i].Width;

    if iHeight > Blocks.Items[i].Height then iHeight := Blocks.Items[i].Height;
  end;

  Result := VarArrayCreate([0, iHeight, 0, iWidth + 1], varVariant);
  iCurrentColumn := 0;
  for i := 0 to Blocks.Count - 1 do
  begin
    for j := 0 to iHeight do
    for k := 0 to Blocks.Items[i].Width do
      Result[j, iCurrentColumn + k] := Blocks.Items[i].BlockData[j, k];

    iCurrentColumn := iCurrentColumn + Blocks.Items[i].Width + ord(iCurrentColumn = 0);
  end;
end;

function TComplexReportBlock.GetHeight: integer;
var i: integer;
begin
  Result := 100000000;
  for i := 0 to Blocks.Count  - 1 do
  if Result > Blocks.Items[i].Height then Result := Blocks.Items[i].Height;
end;

function TComplexReportBlock.GetReportBlockColumns: TReportBlockColumns;
var i, j: integer;
begin
  if not Assigned(FReportBlockColumns) then
  begin
    Result := inherited GetReportBlockColumns;
    FReportBlockColumns.OwnsObjects := false;

    for i := 0 to Blocks.Count - 1 do
    for j := 0 to Blocks.Items[i].ReportBlockColumns.Count - 1 do
      Result.Add(Blocks.Items[i].ReportBlockColumns.Items[j]);
  end
  else Result := FReportBlockColumns;
end;

function TComplexReportBlock.GetReportBlocks: TReportBlocks;
begin
  if not Assigned(FReportBlocks) then
    FReportBlocks := TReportBlocks.Create;

  Result := FReportBlocks;
end;

function TComplexReportBlock.GetWidth: integer;
var i: integer;
begin
  Result := 0;
  for i := 0 to Blocks.Count  - 1 do
    Result := Result + Blocks.Items[i].Width;

end;

procedure TComplexReportBlock.SetReportingCollection(
  const Value: TIDObjects);
var i: integer;
begin
  FReportingCollection := Value;
  for i := 0 to Blocks.Count - 1 do
    Blocks.Items[i].ReportingCollection := FReportingCollection; 
end;

procedure TComplexReportBlock.SetReportingObject(const Value: TIDObject);
var i: integer;
begin
  inherited;

  for i := 0 to Blocks.Count - 1 do
    Blocks[i].ReportingObject := ReportingObject;
end;

{ TDataSetReport }

procedure TDataSetReport.MakeReport(ADataMover: TDataMover);
begin
  inherited;
  Block.Clear;
  ADataMover.MakeDatasetReport(DataSet, Self);
end;

procedure TDataSetReport.SetDataSet(const Value: TDataSet);
begin
  FDataSet := Value;
end;



{ TReport }

constructor TReport.Create;
begin

end;

function TReport.GetReportBlockColumns: TReportBlockColumns;
begin
  Result := Block.ReportBlockColumns;  
end;

procedure TReport.MakeReport(ADataMover: TDataMover);
begin

end;

procedure TReport.SetReportBlock(const Value: TReportBlock);
begin
  FReportBlock := Value;
end;

{ TReportBlockColumns }

function TReportBlockColumns.Add: TReportBlockColumn;
begin
  Result := TReportBlockColumn.Create;
  inherited Add(Result);
end;

function TReportBlockColumns.Add(AColumnID: integer; AColumnName: string;
  AColumnDataType: TFieldType; AVisible: boolean): TReportBlockColumn;
begin
  Result := Add;
  with Result do
  begin
    ColumnID := AColumnID;
    ColumnName := AColumnName;
    ColumnDataType := AColumnDataType;
    Visible := AVisible;
  end;
end;

constructor TReportBlockColumns.Create;
begin
  inherited Create(true);
end;

function TReportBlockColumns.GetItems(Index: integer): TReportBlockColumn;
begin
  Result := inherited Items[Index] as TReportBlockColumn;
end;

function TReportBlockColumns.GetReportHeader: OleVariant;
var i, k: integer;
begin
  Result := varArrayCreate([0, VisibleColumnCount - 1], varOleStr);
  k := 0;
  for i := 0 to Count - 1 do
  if Items[i].Visible then
  begin
    Result[k] := Items[i].ColumnName;
    inc(k);
  end;
end;

function TReportBlockColumns.GetVisibleColumnCount: integer;
var i: integer;
begin
  Result := 0;

  for i := 0 to Count - 1 do
    Result := Result + ord(Items[i].Visible);
end;

function TReportBlockColumns.GetVisibleColumnIDs: TColumnIdsSet;
var i: integer;
begin
  Result := [];

  for i := 0 to Count - 1 do
  if Items[i].Visible then
    Result := Result + [Items[i].ColumnID];
end;

{ TReportBlockColumn }

procedure TReportBlockColumn.AssignTo(Dest: TPersistent);
var rbc: TReportBlockColumn;
begin
  rbc := Dest as TReportBlockColumn;

  rbc.ColumnID := ColumnID;
  rbc.ColumnName := ColumnName;
  rbc.ColumnDataType := ColumnDataType;
  rbc.Visible := Visible;



end;

{ TDataMovers }

constructor TDataMovers.Create;
begin
  inherited Create(true);
end;

function TDataMovers.GetItemByClassType(
  ADataMoverClass: TDataMoverClass): TDataMover;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i] is ADataMoverClass then
  begin
    Result := Items[i];
    break;
  end;
end;

function TDataMovers.GetItems(Index: integer): TDataMover;
begin
  Result := inherited Items[Index] as TDataMover;
end;

procedure TDataMovers.MakeList(AList: TStrings);
var i: integer;
begin
  AList.Clear;
  for i := 0 to Count - 1 do
    AList.AddObject(Items[i].Name, Items[i]);
end;

{ TDataMover }

constructor TDataMover.Create;
begin
  inherited;
end;

procedure TDataMover.MakeCollectionReport(ACollection: TIDObjects;
  Report: TReport);
begin
  Prepare;
end;

procedure TDataMover.MakeDatasetReport(ADataSet: TDataSet;
  Report: TReport);
begin
  Prepare;
end;

procedure TDataMover.MakeSingleObjectReport(AObject: TIDObject;
  Report: TReport);
begin
  Prepare;
end;

end.
