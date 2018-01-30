unit BaseTable;


interface

uses Contnrs;

type

  TBaseTableCell = class
  private
    FObject: TObject;
    FValue: variant;
  public
    property Value: variant read FValue write FValue;
    property Data: TObject read FObject write FObject;

    function IsEmpty: boolean;
    function AsString: string;
    function AsFloat: double;
    function AsDateTime: TDateTime;
  end;

  TBaseTableCells = class(TObjectList)
  private
    FEmpty: boolean;
    function GetItems(const Index: integer): TBaseTableCell;
  public
    function  Add: TBaseTableCell; overload;
    procedure AddToIndex(AIndex: integer);
    procedure Add(ACell: TBaseTableCell); overload;
    property  Items[const Index: integer]: TBaseTableCell read GetItems; default;
    property  Empty: boolean read FEmpty write FEmpty;

    constructor Create;
  end;

  TBaseTableCellsGroup = class(TObjectList)
  private
    function GetItems(const Index: integer): TBaseTableCells;
  public
    function AddToIndex(AIndex: Integer; const OwnsObjects: Boolean = true): TBaseTableCells;

    function Add(const OwnsObjects: Boolean = true): TBaseTableCells;
    property Items[const Index: integer]: TBaseTableCells read GetItems; default;
    constructor Create;
  end;


  TBaseTable = class
  private
    FColumns: TBaseTableCellsGroup;
    FRows: TBaseTableCellsGroup;

    function GetColumns: TBaseTableCellsGroup;
    function GetFirstColumn: TBaseTableCells;
    function GetFooter: TBaseTableCells;
    function GetHeader: TBaseTableCells;
    function GetRows: TBaseTableCellsGroup;
    function GetColumnCount: integer;
    function GetRowCount: integer;
  protected

    function  CheckPreconditions: boolean; virtual;
    procedure OpenFile(AFileName: string); virtual;
    procedure LoadRows; virtual;
    function  CheckCellsEmpty(ACells: TBaseTableCells): boolean; virtual;
  public
    property  Rows: TBaseTableCellsGroup read GetRows;
    property  Columns: TBaseTableCellsGroup read GetColumns;

    property  RowCount: integer read GetRowCount;
    property  ColumnCount: integer read GetColumnCount;

    property  Header: TBaseTableCells read GetHeader;
    property  Footer: TBaseTableCells read GetFooter;
    property  FirstColumn: TBaseTableCells read GetFirstColumn;


    procedure LoadFromFile(AFileName: string);

    constructor Create;
    destructor  Destroy; override;
  end;

implementation

uses SysUtils, Dialogs, Variants;

{ TBaseTableRow }

function TBaseTableCells.Add: TBaseTableCell;
begin
  Result := TBaseTableCell.Create;
  inherited Add(Result);
end;

procedure TBaseTableCells.Add(ACell: TBaseTableCell);
begin
  inherited Add(ACell);
end;

procedure TBaseTableCells.AddToIndex(AIndex: integer);
begin
  While AIndex > Count - 1 do
    Add;
end;

constructor TBaseTableCells.Create;
begin
  inherited Create(true);
  FEmpty := false;
end;

function TBaseTableCells.GetItems(const Index: integer): TBaseTableCell;
begin
  Result := inherited Items[Index] as TBaseTableCell;
end;

{ TBaseTableCell }

function TBaseTableCell.AsDateTime: TDateTime;
begin
  try
    Result := VarAsType(Value, varDate)
  except
    Result := NULL;
  end;
end;

function TBaseTableCell.AsFloat: double;
begin
  try
    result := VarAsType(Value, varDouble)
  except
    Result := -2;
  end;
end;

function TBaseTableCell.AsString: string;
begin
  Result := trim(VarAsType(Value, varOleStr));
end;

function TBaseTableCell.IsEmpty: boolean;
begin
  Result := VarIsEmpty(Value) or VarIsNull(Value) or VarIsClear(Value) or (AsString = '');
end;

{ TBaseTableCellsGroup }

function TBaseTableCellsGroup.Add(const OwnsObjects: Boolean = true): TBaseTableCells;
begin                                   
  Result := TBaseTableCells.Create;
  Result.OwnsObjects := OwnsObjects;
  inherited Add(Result);
end;

function TBaseTableCellsGroup.AddToIndex(AIndex: Integer;
  const OwnsObjects: Boolean): TBaseTableCells;
begin
  Result := nil;
  While AIndex > Count - 1 do
    Result := Add(OwnsObjects);

end;

constructor TBaseTableCellsGroup.Create;
begin
  inherited Create(true);
end;

function TBaseTableCellsGroup.GetItems(
  const Index: integer): TBaseTableCells;
begin
  Result := inherited Items[Index] as TBaseTableCells;
end;

{ TBaseTable }

function TBaseTable.CheckCellsEmpty(ACells: TBaseTableCells): boolean;
begin
  ACells.Empty := false;
  Result := ACells.Empty;
end;

function TBaseTable.CheckPreconditions: boolean;
begin
  Result := false;
  if not Result then
    MessageDlg('Не заданы параметны загрузки файла', mtError, [mbOK], 0);
end;

constructor TBaseTable.Create;
begin
  inherited;  
end;

destructor TBaseTable.Destroy;
begin
  FreeAndNil(FColumns);
  FreeAndNil(FRows);
  inherited;
end;

function TBaseTable.GetColumnCount: integer;
begin
  Result := Columns.Count;
end;

function TBaseTable.GetColumns: TBaseTableCellsGroup;
begin
  if not Assigned(FColumns) then
  begin
    FColumns := TBaseTableCellsGroup.Create;
    FColumns.OwnsObjects := false;
  end;

  Result := FColumns;
end;

function TBaseTable.GetFirstColumn: TBaseTableCells;
begin
  Result := Columns[0];
end;

function TBaseTable.GetFooter: TBaseTableCells;
begin
  Result := Rows[RowCount - 1];
end;

function TBaseTable.GetHeader: TBaseTableCells;
begin
  Result := Rows[0];
end;

function TBaseTable.GetRowCount: integer;
begin
  Result := Rows.Count;
end;

function TBaseTable.GetRows: TBaseTableCellsGroup;
begin
  if not Assigned(FRows) then
    FRows := TBaseTableCellsGroup.Create;

  Result := FRows;
end;

procedure TBaseTable.LoadFromFile(AFileName: string);
begin
  if CheckPreconditions then
  begin
    OpenFile(AFileName);
    LoadRows;
  end;
end;

procedure TBaseTable.LoadRows;
var i: integer;
begin

  for i := 0 to Rows.Count - 1 do
    CheckCellsEmpty(Rows[i]);

  for i := 0 to Columns.Count - 1 do
    CheckCellsEmpty(Columns[i]);

end;

procedure TBaseTable.OpenFile(AFileName: string);
begin

end;

end.
