unit BaseReportController;

interface

uses BaseReport, Classes, BaseObjects;

type
  TReportControllerFilter = (rcfUseAll, rcfUseSelected);

  TBaseReportController = class(TComponent)
  private
    FAutoFormat: boolean;
    FDataMover: TDataMover;
    FFilter: TReportControllerFilter;
    FReportingObjects: TIDObjects;
    FReportingObject: TIDObject;
    procedure SetReportingObjects(const Value: TIDObjects);
    procedure SetReportingObject(const Value: TIDObject);
  protected
    FDataMovers: TDataMovers;
    function GetDataMovers: TDataMovers; virtual;
  public
    property ReportingObjects: TIDObjects read FReportingObjects write SetReportingObjects;
    property ReportingObject: TIDObject read FReportingObject write SetReportingObject;
    

    property DataMovers: TDataMovers read GetDataMovers;
    property AutoFormat: boolean read FAutoFormat write FAutoFormat;
    property SelectedDataMover: TDataMover read FDataMover write FDataMover;
    property Filter: TReportControllerFilter read FFilter write FFilter;
    procedure MakeReport(AReport: TReport); 
  end;

implementation

{ TBaseReportController }

function TBaseReportController.GetDataMovers: TDataMovers;
begin
  Result := FDataMovers;
end;

procedure TBaseReportController.MakeReport(AReport: TReport);
begin
  AReport.Block.ReportingCollection := ReportingObjects;
  AReport.Block.ReportingObject := ReportingObject;
  AReport.MakeReport(SelectedDataMover);
end;

procedure TBaseReportController.SetReportingObject(
  const Value: TIDObject);
begin
  if FReportingObject <> Value then
    FReportingObject := Value;
end;

procedure TBaseReportController.SetReportingObjects(
  const Value: TIDObjects);
begin
  if FReportingObjects <> Value then
    FReportingObjects := Value;
end;

end.
