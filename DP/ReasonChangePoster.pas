unit ReasonChangePoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, ReasonChange, Employee;

type
  // для причины изменений
  TReasonChangeDataPoster = class(TImplementedDataPoster)
  private
    FAllEmployee: TEmployees;
    procedure SetAllEmployee(const Value: TEmployees);
  public
    property AllEmployee: TEmployees read FAllEmployee write SetAllEmployee; 

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses Facade, SysUtils;

{ TReasonChangeDataPoster }

constructor TReasonChangeDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_REASON_CHANGE';

  KeyFieldNames := 'REASON_CHANGE_ID';
  FieldNames := 'REASON_CHANGE_ID, VCH_REASON_CHANGE_NAME, EMPLOYEE_ID, DTM_CHANGE';

  AccessoryFieldNames := 'REASON_CHANGE_ID, VCH_REASON_CHANGE_NAME, EMPLOYEE_ID, DTM_CHANGE';
  AutoFillDates := false;

  Sort := 'REASON_CHANGE_ID';
end;

function TReasonChangeDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TReasonChangeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TReasonChange;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TReasonChange;

      o.ID := ds.FieldByName('REASON_CHANGE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_REASON_CHANGE_NAME').AsString);

      if (ds.FieldByName('EMPLOYEE_ID').AsInteger > 0) and (Assigned(FAllEmployee)) then
        o.Employee := FAllEmployee.ItemsByID[ds.FieldByName('EMPLOYEE_ID').AsInteger] as TEmployee;

      o.DtmChange := ds.FieldByName('DTM_CHANGE').AsDateTime;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TReasonChangeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TReasonChange;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TReasonChange;

  ds.FieldByName('REASON_CHANGE_ID').AsInteger := o.ID;
  ds.FieldByName('VCH_REASON_CHANGE_NAME').AsString := o.Name;

  if Assigned (o.Employee) then
    ds.FieldByName('EMPLOYEE_ID').AsInteger := o.Employee.ID;

  ds.FieldByName('DTM_CHANGE').AsDateTime := o.DtmChange;

  ds.Post;

  if o.ID = 0 then o.ID := ds.FieldByName('REASON_CHANGE_ID').Value;
end;

procedure TReasonChangeDataPoster.SetAllEmployee(const Value: TEmployees);
begin
  if FAllEmployee <> Value then
    FAllEmployee := Value;
end;

end.
