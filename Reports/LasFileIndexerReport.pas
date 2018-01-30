unit LasFileIndexerReport;

interface

uses CommonReport, SDReport, Classes, LasFile;

type

  TLasFileIndexerReport = class(TSDReport)
  private
    FLasFileContents: TLasFileContents;
    FReportData: OleVariant;
    FExcludeFromFilePath: string;
    procedure SetLasFileContents(const Value: TLasFileContents);
  protected
    procedure InternalMoveData; override;
    procedure PostFormat; override;
    procedure InternalOpenTemplate; override;
    function  GetReportFileName: string; override;    
  public
    property ExcludeFromFilePath: string read FExcludeFromFilePath write FExcludeFromFilePath;
    property LasFileContents: TLasFileContents read FLasFileContents write SetLasFileContents;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses Variants, SysUtils, Forms;

{ TLasFileIndexerReport }

constructor TLasFileIndexerReport.Create(AOwner: TComponent);
begin
  inherited;
  SilentMode := true;
  NeedsExcel := true;
  ReportingObjects.Clear;
  ReportingObjects.Add;
end;

function TLasFileIndexerReport.GetReportFileName: string;
begin
  Result := 'Список LAS-файлов';
end;

procedure TLasFileIndexerReport.InternalMoveData;
var i: Integer;
    Cell11, Cell21, Range: OleVariant;
begin
  if Assigned(FLasFileContents) then
  begin
     FReportData := varArrayCreate([0, LasFileContents.Count - 1, 0, 6], varVariant);

     for i := 0 to LasFileContents.Count - 1 do
     begin
       LasFileContents.Items[i].ReadFile();
       FReportData[i, 0] := i + 1;
       // площадь
       FReportData[i, 1] := LasFileContents.Items[i].AreaName;
       // номер
       FReportData[i, 2] := LasFileContents.Items[i].WellNum;
       // файл
       if trim(ExcludeFromFilePath) <> '' then
         FReportData[i, 3] := StringReplace(LasFileContents.Items[i].LasFileName,  ExcludeFromFilePath, '..', [])
       else
         FReportData[i, 3] := LasFileContents.Items[i].LasFileName;
       // от
       FReportData[i, 4] := LasFileContents.Items[i].FromDepth;
       // до
       FReportData[i, 5] := LasFileContents.Items[i].ToDepth;

       // методы
       FReportData[i, 6] := LasFileContents.Items[i].CurveList;

       if Assigned(OnMoveData) then OnMoveData(nil);
     end;

     Cell11 := FXLWorksheet.Cells.Item[4, 1];
     Cell21 := FXLWorksheet.Cells.Item[4  + LasFileContents.Count - 1, 7];
     Range := FXLWorksheet.Range[Cell11,Cell21];
     FExcel.Visible := True;
     Range.Value := FReportData;
  end;
end;

procedure TLasFileIndexerReport.InternalOpenTemplate;
begin
  inherited;
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(Application.ExeName)+'\LasFileIndex.xlt');
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;

procedure TLasFileIndexerReport.PostFormat;
const xlNone = -4142;
      xlContinuous = 1;
      xlThick = 4;
      xlDiagonalDown = 5;
      xlDiagonalUp = 6;
      xlEdgeLeft = 7;
      xlEdgeRight = 10;
      xlEdgeTop = 8;
      xlEdgeBottom = 9;
      xlThin = 2;
      xlAutomatic =  -4105;
      xlInsideHorizontal = 12;
      xlInsideVertical = 11;

var Cell1, Cell2, Range: OleVariant;
begin
  inherited;
  FExcel.ActiveSheet.PageSetup.CenterFooter := 'стр.&[Страница]';
  FExcel.ActiveSheet.PageSetup.RightFooter := 'Список LAS-файлов каталога';

  // рисуем границы
  Cell1 := FXLWorksheet.Cells.Item[2, 1];
  Cell2 := FXLWorksheet.Cells.Item[2 + LasFileContents.Count - 1 + 2, 7];
  Range := FXLWorksheet.Range[Cell1,Cell2];

  Range.Borders.Item[xlDiagonalDown].LineStyle := xlNone;
  Range.Borders.Item[xlDiagonalUp].LineStyle := xlNone;

  Range.Borders.Item[xlEdgeLeft].LineStyle := xlContinuous;
  Range.Borders.Item[xlEdgeLeft].Weight := xlThin;
  Range.Borders.Item[xlEdgeLeft].ColorIndex := xlAutomatic;

  Range.Borders.Item[xlEdgeTop].LineStyle := xlContinuous;
  Range.Borders.Item[xlEdgeTop].Weight := xlThin;
  Range.Borders.Item[xlEdgeTop].ColorIndex := xlAutomatic;

  Range.Borders.Item[xlEdgeBottom].LineStyle := xlContinuous;
  Range.Borders.Item[xlEdgeBottom].Weight := xlThin;
  Range.Borders.Item[xlEdgeBottom].ColorIndex := xlAutomatic;

  Range.Borders.Item[xlEdgeRight].LineStyle := xlContinuous;
  Range.Borders.Item[xlEdgeRight].Weight := xlThin;
  Range.Borders.Item[xlEdgeRight].ColorIndex := xlAutomatic;

  if Range.Rows.Count > 1 then
  begin
    Range.Borders.Item[xlInsideHorizontal].LineStyle := xlContinuous;
    Range.Borders.Item[xlInsideHorizontal].Weight := xlThin;
    Range.Borders.Item[xlInsideHorizontal].ColorIndex := xlAutomatic;
  end;

  Range.Borders.Item[xlInsideVertical].LineStyle := xlContinuous;
  Range.Borders.Item[xlInsideVertical].Weight := xlThin;
  Range.Borders.Item[xlInsideVertical].ColorIndex := xlAutomatic;

  Range.Columns.AutoFit
end;

procedure TLasFileIndexerReport.SetLasFileContents(
  const Value: TLasFileContents);
begin
  FLasFileContents := Value;
end;

end.
