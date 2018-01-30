unit ExcelTable;

interface

uses BaseTable;

type

  TExcelTable = class(TBaseTable)
  private
    FFirstRow: integer;
    FFirstCol: integer;
    FExcel, FXLWorkbook, FXLWorkSheet: OleVariant;
    FData: OleVariant;
    FDataRowCount: integer;
    FDataColCount: integer;
  protected
    function  CheckPreconditions: boolean; override;
    procedure OpenFile(AFileName: string); override;
    procedure LoadRows; override;
  public
    property FirstCol: integer read FFirstCol write FFirstCol;
    property FirstRow: integer read FFirstRow write FFirstRow;

    property  DataRowCount: integer read FDataRowCount;
    property  DataColCount: integer read FDataColCount;
    property  Data: OleVariant read FData;

    destructor Destroy; override;
  end;

implementation

uses Dialogs, ComObj, Variants;

{ TExcelTable }

function TExcelTable.CheckPreconditions: boolean;
begin
  Result := (FirstCol >= 1);
  if not Result then MessageDlg('Не задан начальный столбец диапазона данных', mtError, [mbOK], 0);

  Result := (FirstRow >= 1);
  if not Result then MessageDlg('Не задана начальная строка диапазона данных', mtError, [mbOK], 0);
end;

destructor TExcelTable.Destroy;
begin
  if (not varIsEmpty(FExcel)) and (not VarIsNull(FExcel)) then FExcel.Quit;
  FXLWorkbook := null;
  FXLWorksheet := null;
  inherited;
end;

procedure TExcelTable.LoadRows;
var i, j, iColIndex: integer;
    row, column: TBaseTableCells;
    cell: TBaseTableCell;
begin
  for i := VarArrayLowBound(FData, 1) to VarArrayHighBound(FData, 1) do
  begin
    row := Rows.Add;
    iColIndex := 0;
    for j := VarArrayLowBound(FData, 2) to VarArrayHighBound(FData, 2) do
    begin
      cell := row.Add;
      cell.Value := FData[i, j];

      if (i = VarArrayLowBound(FData, 1)) then
        column := Columns.Add(false)
      else
        column := Columns[iColIndex];


      column.Add(cell);

      inc(iColIndex);
    end;
  end;

  inherited;
end;

procedure TExcelTable.OpenFile(AFileName: string);
var Cell1, vRange: OleVariant;
begin
  inherited;

  FExcel := CreateOleObject('Excel.Application');
  FExcel.Visible := true;
  FExcel.Visible := false;
  FXLWorkBook := FExcel.Workbooks.add(AFileName);
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;


  Cell1 := FXLWorksheet.Cells.Item[FirstRow, FirstCol];
  vRange := Cell1.CurrentRegion;

  FData := vRange.Value;
  FDataRowCount := VarArrayHighBound(FData, 1) - VarArrayLowBound(FData, 1) + 1;
  FDataColCount := VarArrayHighBound(FData, 2) - VarArrayLowBound(FData, 2) + 1;

  FXLWorkbook.Close();
  FExcel.Quit;
end;

end.
