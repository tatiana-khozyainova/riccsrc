unit ReportPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB;

type
  // для отчета "Объемы ГРР и затраты за период по недропользователям и видам работ"
  TGRRReportByOrganizationDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

{ TGRRReportByOrganizationDataPoster }

constructor TGRRReportByOrganizationDataPoster.Create;
begin
  inherited;

end;

function TGRRReportByOrganizationDataPoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TGRRReportByOrganizationDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
begin
  Result := 0;
end;

function TGRRReportByOrganizationDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

end.
