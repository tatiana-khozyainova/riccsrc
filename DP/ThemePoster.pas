unit ThemePoster;

interface

uses DBGate, BaseObjects, PersistentObjects, DB, Employee, SysUtils;

type
  // для тем
  TThemeDataPoster = class(TImplementedDataPoster)
  private
    FAllEmployees: TEmployees;
    procedure SetAllEmployees(const Value: TEmployees);
  public
    property AllEmployees: TEmployees read FAllEmployees write SetAllEmployees;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses Theme, facade;

{ TThemeDataPoster }

constructor TThemeDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soKeyInsert];
  DataSourceString := 'TBL_THEME';

  KeyFieldNames := 'Theme_ID';

  FieldNames := 'Theme_ID, vch_Theme_Name, vch_Theme_Number, dtm_Actual_Period_Start, dtm_Actual_Period_Finish, VCH_THEME_TEXT, EMPLOYEE_ID, VCH_NAME_FOLDER';
  AccessoryFieldNames := 'Theme_ID, vch_Theme_Name, vch_Theme_Number, dtm_Actual_Period_Start, dtm_Actual_Period_Finish, VCH_THEME_TEXT, EMPLOYEE_ID, VCH_NAME_FOLDER';

  AutoFillDates := false;

  Sort := 'vch_Theme_Name';
end;

function TThemeDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin

end;

function TThemeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TTheme;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TTheme;

      o.ID := ds.FieldByName('Theme_ID').AsInteger;
      o.Name := trim(ds.FieldByName('vch_Theme_Name').AsString);
      o.Number := trim(ds.FieldByName('vch_Theme_Number').AsString);
      o.ActualPeriodStart := ds.FieldByName('dtm_Actual_Period_Start').AsDateTime;
      o.ActualPeriodFinish := ds.FieldByName('dtm_Actual_Period_Finish').AsDateTime;
      o.Folder := trim(ds.FieldByName('VCH_NAME_FOLDER').AsString);
      o.Comment := trim(ds.FieldByName('VCH_THEME_TEXT').AsString);

      if Assigned (FAllEmployees) then
        o.Performer := FAllEmployees.ItemsByID[ds.FieldByName('EMPLOYEE_ID').AsInteger] as TEmployee;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TThemeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin

end;

procedure TThemeDataPoster.SetAllEmployees(const Value: TEmployees);
begin
  if FAllEmployees <> Value then
    FAllEmployees := Value;
end;

end.
  
