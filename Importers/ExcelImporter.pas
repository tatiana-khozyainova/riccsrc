unit ExcelImporter;

interface

uses SysUtils;

type

  ECellNotFound = class(Exception)
  public
    constructor Create(ACellTitle: string);
  end;

  TExcelImporter = class
  private
    FFileName: string;
    FExcel: OleVariant;
    FExcelWorkBook: OleVariant;
    FExcelWorkSheet: OleVariant;
    function GetActiveRow: integer;
    function GetActiveCol: integer;
    procedure SetFileName(const Value: string);
    procedure CreateApp; virtual;
    procedure ReleaseApp;
  protected
    class function CreateInstance: TExcelImporter; virtual;
  public
    property  ActiveRow: integer read GetActiveRow;
    property  ActiveColumn: integer read GetActiveCol;
    property  FileName: string read FFileName write SetFileName;

    property  Excel: OleVariant read FExcel;
    property  ExcelWorkbook: OleVariant read FExcelWorkBook;
    property  ExcelWorkSheet: OleVariant read FExcelWorkSheet;


    procedure Clear; virtual;
    function FindCell(ACellValue: string): boolean; virtual;
    procedure Execute; virtual;
    class function GetInstance(const AFileName: string): TExcelImporter; 
  end;


implementation

uses ComObj, Variants;

{ TExcelImporter }

procedure TExcelImporter.Clear;
begin
  ReleaseApp;
end;

procedure TExcelImporter.CreateApp;
begin
  FExcel := CreateOleObject('Excel.Application');
  FExcel.DisplayAlerts := false;
  FExcel.EnableEvents := false;
  // открываем файл
  FExcelWorkBook := FExcel.Workbooks.Open(FileName, false, true);
  // активируем первый лист
  FExcelWorkBook.Sheets.Item[1].Activate;
  FExcelWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
  Excel.Visible := true;
end;

function TExcelImporter.FindCell(ACellValue: string): boolean;
var FoundCell: OleVariant;
    i: integer;
begin
  Result := false;
  for i := 1 to FExcelWorkBook.Sheets.Count do
  begin
    FExcelWorkSheet := FExcelWorkBook.Sheets[i];
    FExcelWorkSheet.Activate;
    FExcelWorksheet.Cells[1, 1].Activate;
    FoundCell := FExcel.Cells.Find(ACellValue);
    Result := not VarIsClear(FoundCell);
    if Result then
    begin
      FoundCell.Activate;
      FoundCell.Select;
      Break;
    end;
  end;
end;

function TExcelImporter.GetActiveCol: integer;
begin
  Result := Excel.ActiveCell.Column;
end;

function TExcelImporter.GetActiveRow: integer;
begin
  Result := Excel.ActiveCell.Row;
end;

class function TExcelImporter.GetInstance(
  const AFileName: string): TExcelImporter;
const imp: TExcelImporter = nil;
begin
  if not Assigned(imp) then imp := CreateInstance;
  imp.FileName := AFileName;
  Result := imp;
end;

procedure TExcelImporter.Execute;
begin

end;

procedure TExcelImporter.ReleaseApp;
begin
  if (not((varIsNull(FExcel)) or (varIsEmpty(FExcel)))) then
    if (not FExcel.Visible) then FExcel.Quit;

  FExcelWorkSheet := Null;
  FExcelWorkBook := Null;
  FExcel := Null;
end;

procedure TExcelImporter.SetFileName(const Value: string);
begin
  if FFileName <> Value then
  begin
    FFileName := Value;
    Clear;
    CreateApp;
  end;
end;

class function TExcelImporter.CreateInstance: TExcelImporter;
begin
  Result := TExcelImporter.Create;
end;

{ TCellNotFound }

constructor ECellNotFound.Create(ACellTitle: string);
begin
  inherited CreateFmt('ячейка %s не найдена', [ACellTitle]);
end;

end.
