unit ExcelReport;

interface

uses BaseReport, BaseObjects, DB;

type
  TExcelDataMover = class(TDataMover)
  private
    FExcel: OleVariant;
  public
    property  ExcelApp: OleVariant read FExcel write FExcel;
    procedure Prepare; override;
    procedure MakeSingleObjectReport(AObject: TIDObject; Report: TReport); override;
    procedure MakeCollectionReport(ACollection: TIDObjects; Report: TReport); override;
    procedure MakeDatasetReport(ADataSet: TDataSet; Report: TReport); override;

    constructor Create; override;
  end;






implementation



{ TExcelDataMover }

constructor TExcelDataMover.Create;
begin
  inherited;
  Name := 'Экпорт в Excel';
end;

procedure TExcelDataMover.MakeCollectionReport(ACollection: TIDObjects;
  Report: TReport);
var v1, v2: OleVariant;
begin
  inherited;
  (Report as TCollectionReport).ReportObjects := ACollection;

  v1 := ExcelApp.Cells[Report.Block.Top - 1, Report.Block.Left];
  v2 := ExcelApp.Cells[Report.Block.Top - 1, Report.Block.Left + Report.Block.Width];
  ExcelApp.Range[v1,v2].Value := Report.Block.BlockHeader;

  v1 := ExcelApp.Cells[Report.Block.Top, Report.Block.Left];
  v2 := ExcelApp.Cells[Report.Block.Top + Report.Block.Height, Report.Block.Left + Report.Block.Width];
  ExcelApp.Range[v1, v2].Value := Report.Block.BlockData;
end;

procedure TExcelDataMover.MakeDatasetReport(ADataSet: TDataSet;
  Report: TReport);
var v1, v2: OleVariant;
begin
  inherited;
  (Report as TDataSetReport).DataSet := ADataSet;

  v1 := ExcelApp.Cells[Report.Block.Top - 1, Report.Block.Left];
  v2 := ExcelApp.Cells[Report.Block.Top - 1, Report.Block.Left + Report.Block.Width];
  ExcelApp.Range[v1,v2].Value := Report.Block.BlockHeader;

  v1 := ExcelApp.Cells[Report.Block.Top, Report.Block.Left];
  v2 := ExcelApp.Cells[Report.Block.Top + Report.Block.Height, Report.Block.Left + Report.Block.Width];
  ExcelApp.Range[v1, v2].Value := Report.Block.BlockData;
end;

procedure TExcelDataMover.MakeSingleObjectReport(AObject: TIDObject;
  Report: TReport);
var v1, v2: OleVariant;  
begin
  inherited;  
  (Report as TSingleObjectReport).ReportObject := AObject;

  v1 := ExcelApp.Cells[Report.Block.Top - 1, Report.Block.Left];
  v2 := ExcelApp.Cells[Report.Block.Top - 1, Report.Block.Left + Report.Block.Width];
  ExcelApp.Range[v1,v2].Value := Report.Block.BlockHeader;

  v1 := ExcelApp.Cells[Report.Block.Top, Report.Block.Left];
  v2 := ExcelApp.Cells[Report.Block.Top + Report.Block.Height, Report.Block.Left + Report.Block.Width];
  ExcelApp.Range[v1, v2].Value := Report.Block.BlockData;
end;

procedure TExcelDataMover.Prepare;
begin
  ExcelApp.Workbooks.Add;
  ExcelApp.Visible := true;  

end;

end.
