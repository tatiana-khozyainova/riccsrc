unit AllGisReport;

interface

uses SDReport,    BaseObjects, Classes, Contnrs;

type

  TGisReport = class (TSDSQLCollectionReport)
 protected
  procedure InternalMoveData; override;
 end;

implementation

uses SysUtils, Forms, CommonReport, Material, Facade, ComObj;

{ TGisReport }

procedure TGisReport.InternalMoveData;
var i: integer;
    vQueryResult: OleVariant;
begin
  inherited;
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(Application.ExeName)+'\SeisReport.xlt');
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;



end;

end.
