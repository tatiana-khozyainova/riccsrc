unit GRRClientGISQueries;

interface

uses Classes, Contnrs, Version;

type
  TQueryType = (qtOrganizations, qtQueries, qtXLQuery);

  TGRRReportQuery = class
  private
    FTitle: string;
    FQueryType: TQueryType;
    FSelected: Boolean;
  public
    property Title: string read FTitle;
    property QueryType: TQueryType read FQueryType ;
    property Selected: Boolean read FSelected write FSelected; 
    procedure Execute(AFileName: string); virtual;
    constructor Create; virtual;
  end;

  TGRRReportQueryClass = class of TGRRReportQuery;

  TGRRReportQueries = class(TObjectList)
  private
    FOnExecute: TNotifyEvent;
    FVersions: TVersions;
    function GetItems(const Index: Integer): TGRRReportQuery;
    function GetSelectedCount: integer;
  public
    property Versions: TVersions read FVersions write FVersions;
    property Items[const Index: Integer]: TGRRReportQuery read GetItems;

    property  SelectedCount: integer read GetSelectedCount;

    property  OnExcecute: TNotifyEvent read FOnExecute write FOnExecute;
    procedure Execute(AFileName: string); virtual;
    procedure MakeList(ALst: TStrings);
    function  AddReport(AGRRReportQueryClass: TGRRReportQueryClass): TGRRReportQuery;
    constructor Create; virtual;
  end;

  TGRRReportXLQuery = class(TGRRReportQuery)
  public
    constructor Create; override;
  end;

  TGRRReportConcreteQueries = class(TGRRReportQueries)
  public
    constructor Create; override;
  end;

  TGRRReportGISXLQueries = class(TGRRReportQueries)
  public
    procedure Execute(AFileName: string); override;
    constructor Create; override;
  end;

  TGRRReportAllOrganizationsQuery = class(TGRRReportQuery)
  public
    constructor Create; override;
  end;

  TGRRReportVINKOrganizationsQuery = class(TGRRReportQuery)
  public
    constructor Create; override;
  end;

  TGRRReportPlannedDrillingQuery = class(TGRRReportQuery)
  public
    constructor Create; override;
  end;

  TGRRReportDrillingQuery = class(TGRRReportQuery)
  public
    constructor Create; override;
  end;

  TGRRReportDrillingWithResultQuery = class(TGRRReportQuery)
  public
    constructor Create; override;
  end;

  TGRRReportDrillingWithNoResultQuery = class(TGRRReportQuery)
  public
    constructor Create; override;
  end;

  TGRRReportNoDrillingQuery = class(TGRRReportQuery)
  public
    constructor Create; override;
  end;

  TGRRReportPlannedSeismicQuery = class(TGRRReportQuery)
  public
    constructor Create; override;
  end;

  TGRRReportPlanned2DSeismicQuery = class(TGRRReportQuery)
  public
    constructor Create; override;
  end;

  TGRRReportPlanned3DSeismicQuery = class(TGRRReportQuery)
  public
    constructor Create; override;
  end;

  TGRRReportSeismicQuery = class(TGRRReportQuery)
  public
    constructor Create; override;
  end;

  TGRRReport2DSeismicQuery = class(TGRRReportQuery)
  public
    constructor Create; override;
  end;

  TGRRReport3DSeismicQuery = class(TGRRReportQuery)
  public
    constructor Create; override;
  end;

  TGRRReportNoSeismicQuery = class(TGRRReportQuery)
  public
    constructor Create; override;
  end;

  TGRRReportPlannedNIRQuery = class(TGRRReportQuery)
  public
    constructor Create; override;
  end;


  TGRRReportNIRQuery = class(TGRRReportQuery)
  public
    constructor Create; override;
  end;

  TGRRReportNoNIRQuery = class(TGRRReportQuery)
  public
    constructor Create; override;
  end;

  TGRRReportPlannedWorkQuery = class(TGRRReportQuery)
  public
    constructor Create; override;
  end;

  TGRRReportFactWorkQuery = class(TGRRReportQuery)
  public
    constructor Create; override;
  end;

  TGRRReportNoWorkQuery = class(TGRRReportQuery)
  public
    constructor Create; override;
  end;












implementation

{ TGRRReportQuery }

constructor TGRRReportQuery.Create;
begin

end;

procedure TGRRReportQuery.Execute;
begin

end;

{ TGRRReportVINKOrganizationsQuery }

constructor TGRRReportVINKOrganizationsQuery.Create;
begin
  inherited;
  FTitle := 'По ВИНК';
  FQueryType := qtOrganizations;
end;

{ TGRRReportAllOrganizationsQuery }

constructor TGRRReportAllOrganizationsQuery.Create;
begin
  inherited;
  FTitle := 'По организациям';
  FQueryType := qtOrganizations;
end;

{ TGRRReportPlannedDrillingQuery }

constructor TGRRReportPlannedDrillingQuery.Create;
begin
  inherited;
  FTitle := 'Участки, по которым запланировано бурение на отчетный период';
  FQueryType := qtQueries;
end;

{ TGRRReportDrillingQuery }

constructor TGRRReportDrillingQuery.Create;
begin
  inherited;
  FTitle := 'Участки, по которым выполнялось бурение в отчетном периоде';
  FQueryType := qtQueries;  
end;

{ TGRRReportDrillingWithResultQuery }

constructor TGRRReportDrillingWithResultQuery.Create;
begin
  inherited;
  FTitle := 'Участки, по которым выполнялось результативное бурение в отчетном периоде';
  FQueryType := qtQueries;
end;

{ TGRRReportDrillingWithNoResultQuery }

constructor TGRRReportDrillingWithNoResultQuery.Create;
begin
  inherited;
  FTitle := 'Участки, по которым выполнялось бурение, но результат получен не был';
  FQueryType := qtQueries;
end;

{ TGRRReportNoDrillingQuery }

constructor TGRRReportNoDrillingQuery.Create;
begin
  inherited;
  FTitle := 'Участки, по которым было запланировано, но не выполнено бурение';
  FQueryType := qtQueries;
end;

{ TGRRReportPlannedSeismicQuery }

constructor TGRRReportPlannedSeismicQuery.Create;
begin
  inherited;
  FTitle := 'Участки, по которым в отчетном периоде были запланированы сейсморазведочные работы';
  FQueryType := qtQueries;
end;

{ TGRRReportPlanned2DSeismicQuery }

constructor TGRRReportPlanned2DSeismicQuery.Create;
begin
  inherited;
  FTitle := 'Участки, по которым в отчетном периоде были запланированы 2D сейсморазведочные работы';
  FQueryType := qtQueries;
end;

{ TGRRReportPlanned3DSeismicQuery }

constructor TGRRReportPlanned3DSeismicQuery.Create;
begin
  inherited;
  FTitle := 'Участки, по которым в отчетном периоде были запланированы 3D сейсморазведочные работы';
  FQueryType := qtQueries;
end;

{ TGRRReport2DSeismicQuery }

constructor TGRRReport2DSeismicQuery.Create;
begin
  inherited;
  FTitle := 'Участки, по которым в отчетном периоде были выполнены 2D сейсморазведочные работы';
  FQueryType := qtQueries;
end;

{ TGRRReport3DSeismicQuery }

constructor TGRRReport3DSeismicQuery.Create;
begin
  inherited;
  FTitle := 'Участки, по которым в отчетном периоде были выполнены 3D сейсморазведочные работы';
  FQueryType := qtQueries;
end;

{ TGRRReportNoSeismicQuery }

constructor TGRRReportNoSeismicQuery.Create;
begin
  inherited;
  FTitle := 'Участки, по которым в отчетном периоде были запланированы, но не выполнены сейсморазведочные работы';
  FQueryType := qtQueries;
end;

{ TGRRReportNIRQuery }

constructor TGRRReportNIRQuery.Create;
begin
  inherited;
  FTitle := 'Участки, по которым в отчетном периоде были выполнены НИР';
  FQueryType := qtQueries;
end;

{ TGRRReportNoNIRQuery }

constructor TGRRReportNoNIRQuery.Create;
begin
  inherited;
  FTitle := 'Участки, по которым в отчетном периоде были запланированы, но не выполнены НИР';
  FQueryType := qtQueries;
end;

{ TGRRReportSeismicQuery }

constructor TGRRReportSeismicQuery.Create;
begin
  inherited;
  FTitle := 'Участки, по которым в отчетном периоде были выполнены сейсморазведочные работы';
  FQueryType := qtQueries;
end;

{ TGRRReportPlannedNIRQuery }

constructor TGRRReportPlannedNIRQuery.Create;
begin
  inherited;
  FTitle := 'Участки, по которым в отчетном периоде были запланированы НИР';
  FQueryType := qtQueries;
end;

{ TGRRReportNoWorkQuery }

constructor TGRRReportNoWorkQuery.Create;
begin
  inherited;
  FTitle := 'Участки, по которым в отчетном периоде были запланированы, но не выполнены ГРР';
  FQueryType := qtQueries;
end;

{ TGRRReportFactWorkQuery }

constructor TGRRReportFactWorkQuery.Create;
begin
  inherited;
  FTitle := 'Участки, по которым в отчетном периоде выполнялись ГРР';
  FQueryType := qtQueries;
end;

{ TGRRReportPlannedWorkQuery }

constructor TGRRReportPlannedWorkQuery.Create;
begin
  inherited;
  FTitle := 'Участки, по которым в отчетном периоде были запланированы ГРР';
  FQueryType := qtQueries;
end;

{ TGRRReportQueries }

function TGRRReportQueries.AddReport(
  AGRRReportQueryClass: TGRRReportQueryClass): TGRRReportQuery;
begin
  Result := AGRRReportQueryClass.Create;
  inherited Add(Result);
end;

constructor TGRRReportQueries.Create;
begin
  inherited Create(True);
end;

procedure TGRRReportQueries.Execute(AFileName: string);
var i: integer;
begin
  for i := 0 to Count - 1 do
  if Items[i].Selected then
  begin
    Items[i].Execute(AFileName);
    if Assigned(FOnExecute) then FOnExecute(Self);
  end;
end;

function TGRRReportQueries.GetItems(const Index: Integer): TGRRReportQuery;
begin
  Result := inherited Items[Index] as TGRRReportQuery;
end;

function TGRRReportQueries.GetSelectedCount: integer;
var i: integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
    Result := Result + Ord(Items[i].Selected);
end;

procedure TGRRReportQueries.MakeList(ALst: TStrings);
var i: integer;
begin
  ALst.Clear;
  for i := 0 to Count - 1 do
    ALst.AddObject(Items[i].Title, Items[i]);
end;

{ TGRRReportConcreteQueries }

constructor TGRRReportConcreteQueries.Create;
begin
  inherited;
  AddReport(TGRRReportAllOrganizationsQuery);
  AddReport(TGRRReportVINKOrganizationsQuery);
  
  AddReport(TGRRReportPlannedDrillingQuery);
  AddReport(TGRRReportDrillingQuery);
  AddReport(TGRRReportDrillingWithResultQuery);
  AddReport(TGRRReportDrillingWithNoResultQuery);
  AddReport(TGRRReportNoDrillingQuery);      

  AddReport(TGRRReportPlannedSeismicQuery);
  AddReport(TGRRReportPlanned2DSeismicQuery);
  AddReport(TGRRReportPlanned3DSeismicQuery);
  AddReport(TGRRReport2DSeismicQuery);
  AddReport(TGRRReport3DSeismicQuery);

  AddReport(TGRRReportPlannedNIRQuery);
  AddReport(TGRRReportNIRQuery);
  AddReport(TGRRReportNoNIRQuery);

  AddReport(TGRRReportPlannedWorkQuery);
  AddReport(TGRRReportFactWorkQuery);
  AddReport(TGRRReportNoWorkQuery);  


end;

{ TGRRReportXLQuery }

constructor TGRRReportXLQuery.Create;
begin
  inherited;
  FTitle := 'Excel-отчет для карты';
  FQueryType := qtXLQuery;
end;

{ TGRRReportGISXLQueries }

constructor TGRRReportGISXLQueries.Create;
begin
  inherited;
  AddReport(TGRRReportXLQuery);
end;

procedure TGRRReportGISXLQueries.Execute(AFileName: string);
var i: Integer;
begin
  for i := 0 to Versions.Count - 1 do
  begin
    Items[i].Execute(AFileName);
    if Assigned(FOnExecute) then FOnExecute(Self);
  end;
end;

end.
