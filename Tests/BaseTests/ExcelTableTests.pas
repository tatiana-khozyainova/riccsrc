unit ExcelTableTests;

interface

uses TestFrameWork, ExcelTable;


type

  TExcelTableTests = class(TTestCase)
  private
    FExcelTable: TExcelTable;
    FFileName: string;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestReadingFile;

  end;



implementation

uses SysUtils, Variants;

{ TExcelTableTests }

procedure TExcelTableTests.SetUp;
begin
  inherited;
  FExcelTable := TExcelTable.Create;
  FExcelTable.FirstCol := 1;
  FExcelTable.FirstRow := 1;
  FFileName := ExtractFilePath(ParamStr(0)) + '\BaseTests\MadeBagan.xls';
end;

procedure TExcelTableTests.TearDown;
begin
  inherited;
  FreeAndNil(FExcelTable);
end;

procedure TExcelTableTests.TestReadingFile;
var i, j: integer;
begin
  // ���������� ��
  FExcelTable.LoadFromFile(FFileName);
  // ���������� �������� � ����� ��������� ��
  Check(FExcelTable.Columns.Count = FExcelTable.DataColCount, '���������� ����������� �������� �� ����� ���������� �������� ������');
  Check(FExcelTable.Rows.Count = FExcelTable.DataRowCount, '���������� ����������� ����� �� ����� ���������� ����� ������');

  //��������� �� ����� �� ��������
  with FExcelTable do
  begin
    for i := VarArrayLowBound(Data, 1) to VarArrayHighBound(Data, 1) do
    for j := VarArrayLowBound(Data, 2) to VarArrayHighBound(Data, 2) do
      Check(trim(varAsType(FExcelTable.Data[i, j], varOleStr)) = FExcelTable.Rows[i-1][j-1].AsString, Format('����������� �������� (%d, %d)', [i, j]));
  end;
end;


initialization
  RegisterTest('BaseTests\BaseTable\TExcelTableTests', TExcelTableTests.Suite);


end.
