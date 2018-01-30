unit Report;

interface

uses Registrator, BaseObjects;

type
  // Объемы ГРР и затраты за период по недропользователям и видам работ
  TGRRReportByOrganization = class (TRegisteredIDObject)
  public
    constructor Create (ACollection: TIDObjects); override;
  end;

  TGRRReportByOrganizations = class (TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TGRRReportByOrganization;
  public
    property    Items[Index: Integer]: TGRRReportByOrganization read GetItems;
    Constructor Create; override;
  end;

implementation

uses ReportPoster, facade;

{ TGRRReportByOrganizations }

constructor TGRRReportByOrganizations.Create;
begin
  inherited;
  FObjectClass := TGRRReportByOrganization;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TGRRReportByOrganizationDataPoster];
end;

function TGRRReportByOrganizations.GetItems(
  Index: Integer): TGRRReportByOrganization;
begin
  Result := inherited Items[Index] as TGRRReportByOrganization;
end;

{ TGRRReportByOrganization }

constructor TGRRReportByOrganization.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Объемы ГРР и затраты за период по недропользователям и видам работ';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGRRReportByOrganizationDataPoster];
end;

end.
