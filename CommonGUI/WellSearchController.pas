unit WellSearchController;

interface

uses Classes, SysUtils;

type

  TWellSearchController = class
  private
    FStrictAreaSearch: boolean;
    FStrictWellSearch: boolean;
    FWellNum: string;
    FAreaName: string;
    FAreaList: TStringList;
    function GetAreaList: TStrings;
    function BuildQuery: string;
  public
    property AreaName: string read FAreaName write FAreaName;
    property WellNum: string read FWellNum write FWellNum;
    property StrictAreaSearch: boolean read FStrictAreaSearch write FStrictAreaSearch;
    property StrictWellSearch: boolean read FStrictWellSearch write FStrictWellSearch;

    property AreaList: TStrings read GetAreaList;
    procedure ExecuteQuery; 

    class function GetInstance: TWellSearchController;
    destructor Destroy; override;
  end;

implementation

uses Facade, Variants;

{ TWellSearchController }

function TWellSearchController.BuildQuery: string;
var sQuery, sFilter: string;
    sAreaName, sWellNum: string;
    sAreaWeakPart, sAreaStrictPart: string;
    sWellNumWeakPart, sWellNumStrictPart: string;

begin
  sQuery := 'select distinct Area_ID, vch_Area_Name from vw_Well';
  sAreaWeakPart := '((rf_rupper(vch_Area_Name) containing ''%s'') or (rf_rupper(vch_Well_Name) containing ''%s''))';
  sAreaStrictPart := '((rf_rupper(vch_Area_Name) = ''%s'') or (rf_rupper(vch_Well_Name) containing ''%s''))';

  sWellNumWeakPart := '((rf_rupper(vch_Well_Num) containing ''%s'') or (rf_rupper(vch_Well_Name) containing ''%s''))';
  sWellNumStrictPart := '((rf_rupper(vch_Well_Num) = ''%s'') or (rf_rupper(vch_Well_Num) containing ''%s''))';


  sAreaName := AnsiUpperCase(trim(AreaName));
  sWellNum := AnsiUpperCase(trim(WellNum));

  if trim(sAreaName) <> '' then
  begin
    sFilter := ' where ';
      
    if not StrictAreaSearch then
      sFilter := sFilter + Format(sAreaWeakPart, [sAreaName, sAreaName])
    else
      sFilter := sFilter + Format(sAreaStrictPart, [sAreaName, sAreaName]);
  end;

  if trim(sWellNum) <> '' then
  begin
    if sFilter <> '' then
      sFilter := sFilter + ' and '
    else
      sFilter := ' where ';

    if not StrictWellSearch then
      sFilter := sFilter + Format(sWellNumWeakPart, [sWellNum, sWellNum])
    else
      sFilter := sFilter + Format(sWellNumStrictPart, [sWellNum, sWellNum])
  end;

  Result := sQuery + ' ' + sFilter;
end;

destructor TWellSearchController.Destroy;
begin
  FreeAndNil(FAreaList);
  inherited;
end;

procedure TWellSearchController.ExecuteQuery;
var sQuery: string;
    vQueryResult: OleVariant;
    i: integer;
begin
  sQuery := BuildQuery;

  if TMainFacade.GetInstance.DBGates.ExecuteQuery(sQuery, vQueryResult) > 0 then
  begin
    AreaList.Clear;
    for i := 0 to VarArrayHighBound(vQueryResult, 2) do
      AreaList.AddObject(varAsType(vQueryResult[1, i], varOleStr), TObject(Integer(varAsType(vQueryResult[0, i], varInteger))));
  end;
end;

function TWellSearchController.GetAreaList: TStrings;
begin
  if not Assigned(FAreaList) then FAreaList := TStringList.Create;
  Result := FAreaList;
end;

class function TWellSearchController.GetInstance: TWellSearchController;
const wsc: TWellSearchController = nil;
begin
  if not Assigned(wsc) then
    wsc := TWellSearchController.Create;

  Result := wsc;
end;

end.
