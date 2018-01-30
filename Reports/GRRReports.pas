unit GRRReports;

interface

uses SDReport, Classes;

type

   TGRRReport = class(TSDSQLCollectionReport)
   protected
     procedure InternalOpenTemplate; override;
     procedure PreProcessQueryBlock(AQueryBlock: OleVariant); override;
   public
     procedure PrepareReport; override;
     constructor Create(AOwner: TComponent); override;
   end;

implementation

uses SysUtils;

{ TGRRReport }

constructor TGRRReport.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TGRRReport.InternalOpenTemplate;
begin
  inherited;
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(ParamStr(0))+'\GRRPresentation.xltx');
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;

end;

procedure TGRRReport.PrepareReport;
begin
  inherited;

end;

procedure TGRRReport.PreProcessQueryBlock(AQueryBlock: OleVariant);
begin
  inherited;

end;

end.
