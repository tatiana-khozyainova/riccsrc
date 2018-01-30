unit CommonReport;

interface

uses Excel97, Straton;

type

TCommonReport = class
private
  FExcel: TExcelApplication;
  FStraton: TStraton;
  FReportResult: OleVariant;
  procedure SetStraton(Value: TStraton);
  procedure MakeReport;
  procedure MoveDataToExcel;
  procedure RemoveCols;
public
  TemplateName: string;
  ReportName:   string;
  Query: string;
  ReportID: integer;
  HeaderRow: variant;
  RemovingCols:  array of byte;
  property    Straton: TStraton read FStraton write SetStraton;
  constructor Create(Excel: TExcelApplication);
end;


implementation
uses StraDictCommon, ClientCommon, SysUtils;


procedure TCommonReport.RemoveCols;
var i: integer;
begin
  for i:=High(RemovingCols) downto 0 do
    FExcel.Run('DeleteColumn',RemovingCols[i]);
end;

procedure TCommonReport.MoveDataToExcel;
var sPath: string;
    i, j: integer;
    vbc: OleVariant;
    wb: _WorkBook;
begin
  // соединяемся
  FExcel.Connect;
  sPath := ExtractFilePath(ParamStr(0))+TemplateName;
  wb := FExcel.Workbooks.Add(sPath,0);

  // добавляем макросы
  vbc:=wb.VBProject.VBComponents.Add(1);
  vbc.Name := 'macros';
  vbc.Codemodule.AddFromString('Sub DeleteColumn(Index as integer)'+#13+#10+
                               'Columns(Index).Delete'+#13+#10+
                               'End Sub');


  // шапка
  FExcel.Cells.Item[11,3].Value := ReportName;
  FExcel.Cells.Item[12,1].Value := '№';
  for i := 0 to varArrayHighBound(HeaderRow, 1) do
    FExcel.Cells.Item[12,i+2].Value := varAsType(HeaderRow[i],varOleStr);

  // результаты запроса
  for j:=0 to varArrayHighBound(FReportResult,2) do
  begin
    // порядковый номер
    FExcel.Cells.Item[j+13,1].Value := j+1;

    // непосредственно данные
    for i:=0 to varArrayHighBound(FReportResult,1) do
    //if varType(FReportResult[i,j]) <> varCurrency then
      FExcel.Cells.Item[j+13,i+2].Value := FReportResult[i,j]
    {else
      FExcel.Cells.Item[j+13,i+2].Value := varAsType(FReportResult[i,j], varSingle);}    
  end;

  // автоподбор
  FExcel.Columns.AutoFit;

  // если задано - удаляем пустые столбцы
  RemoveCols;

  // отсоединяемся
  wb.VBProject.VBComponents.Remove(wb.VBProject.VBComponents.Item('macros'));
  FExcel.Visible[0] := true;
  FExcel.Disconnect;
end;


procedure TCommonReport.MakeReport;
var sFilter: string;
begin
  sFilter := '';
  if Assigned(FStraton) then
     sFilter := FStraton.MakeFilter(true, nil);

  if (sFilter<>'') then
  if pos('WHERE', UpperCase(Query)) > 0 then
     Query := Query + ' and Straton_ID in ' + sFilter
  else Query := Query + ' where Straton_ID in ' + sFilter;


  if IServer.ExecuteQuery(Query) > 0 then
  begin
    FReportResult := IServer.QueryResult;
    // соединяемся с Excel
    // выбрасываем данные в соответствующие столбцы
    // если задано - удаляем пустые столбцы
    MoveDataToExcel;
  end;
end;

procedure TCommonReport.SetStraton(Value: TStraton);
begin
  FStraton := Value;
  MakeReport;
end;

constructor TCommonReport.Create(Excel: TExcelApplication);
begin
  inherited Create;
  FStraton := nil;
  FExcel := Excel;
end;


end.
