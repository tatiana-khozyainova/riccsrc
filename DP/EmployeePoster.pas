unit EmployeePoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, Employee;

type
    // для своих сотрудников
  TPostDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

    // для своих сотрудников
  TEmployeeDataPoster = class(TImplementedDataPoster)
  private
    FAllPosts: TPosts;
    procedure SetAllPosts(const Value: TPosts);
  public
    property AllPosts: TPosts read FAllPosts write SetAllPosts;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

    // для внешних сотрудников
  TEmployeeOutsideDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;


implementation

uses Facade, SysUtils;

{ TEmployeeDataPoster }

constructor TEmployeeDataPoster.Create;
begin
  inherited;
  Options := [];
  DataSourceString := 'VW_EMPLOYEE';
  DataDeletionString := '';
  DataPostString := '';

  KeyFieldNames := 'EMPLOYEE_ID';
  FieldNames := 'EMPLOYEE_ID, VCH_EMPLOYEE_FULL_NAME, POST_ID';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_EMPLOYEE_FULL_NAME';
end;

function TEmployeeDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TEmployeeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TEmployee;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TEmployee;
      o.ID := ds.FieldByName('EMPLOYEE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_EMPLOYEE_FULL_NAME').AsString);
      o.Post := FAllPosts.ItemsByID[ds.FieldByName('POST_ID').AsInteger] as TPost;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TEmployeeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;


{ TOutsideEmployeeDataPoster }

constructor TEmployeeOutsideDataPoster.Create;
begin
  inherited;
  Options := [soKeyInsert];
  DataSourceString := 'TBL_EMPLOYEE_OUTSIDE';
  DataDeletionString := 'TBL_EMPLOYEE_OUTSIDE';
  DataPostString := 'SPD_ADD_EMPLOYEE_OUTSIDE';

  KeyFieldNames := 'EMPLOYEE_OUTSIDE_ID';
  FieldNames := 'EMPLOYEE_OUTSIDE_ID, VCH_EMPLOYEE_OUTSIDE_FULL_NAME';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_EMPLOYEE_OUTSIDE_FULL_NAME';
end;

function TEmployeeOutsideDataPoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TEmployeeOutsideDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TEmployeeOutside;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TEmployeeOutside;
      o.ID := ds.FieldByName('EMPLOYEE_OUTSIDE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_EMPLOYEE_OUTSIDE_FULL_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TEmployeeOutsideDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    eo: TEmployeeOutside;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  eo := AObject as TEmployeeOutside;

  ds.FieldByName('EMPLOYEE_OUTSIDE_ID').Value := eo.ID;
  ds.FieldByName('VCH_EMPLOYEE_OUTSIDE_FULL_NAME').Value := trim(eo.Name);

  ds.Post;

  eo.ID := ds.FieldByName('EMPLOYEE_OUTSIDE_ID').AsInteger;
end;



procedure TEmployeeDataPoster.SetAllPosts(const Value: TPosts);
begin
  if FAllPosts <> Value then
    FAllPosts := Value;
end;

{ TPostDataPoster }

constructor TPostDataPoster.Create;
begin
  inherited;
  Options := [];
  DataSourceString := 'TBL_POST';
  DataDeletionString := '';
  DataPostString := '';

  KeyFieldNames := 'POST_ID';
  FieldNames := 'POST_ID, VCH_POST';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_POST';
end;

function TPostDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TPostDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TPost;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TPost;
      o.ID := ds.FieldByName('POST_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_POST').AsString);

      ds.Next;
    end;

    ds.First;
  end;

end;

function TPostDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

end.
