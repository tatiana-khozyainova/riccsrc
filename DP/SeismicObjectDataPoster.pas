unit SeismicObjectDataPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, SeismicObject, Area, Structure, Topolist, PetrolRegion, District;

type

  TSeismicObjectTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TSeismicWorkTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TSeismicCrewDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TSeismicReportDataPoster = class(TImplementedDataPoster)
  private
    FAllSeismicWorkTypes: TSeismicWorkTypes;
    FAllSeismicCrews: TSeismicCrews;
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    property AllSeismicWorkTypes: TSeismicWorkTypes read FAllSeismicWorkTypes write FAllSeismicWorkTypes;
    property AllSeismicCrews: TSeismicCrews read FAllSeismicCrews write FAllSeismicCrews;

    constructor Create; override;
  end;

  TSeismicProfileTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    constructor Create; override;
  end;

  TSeismicProfileDataPoster = class(TImplementedDataPoster)
  private
    FAllSeismicProfileTypes: TSeismicProfileTypes;
    FAllSeismicReports: TSeismicReports;
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    property AllSeismicProfileTypes: TSeismicProfileTypes read FAllSeismicProfileTypes write FAllSeismicProfileTypes;
    property AllSeismicReports: TSeismicReports read FAllSeismicReports write FAllSeismicReports;
    constructor Create; override;
  end;


implementation

uses Facade, SysUtils, Organization;

{ TSeismicObjectTypeDataPoster }

constructor TSeismicObjectTypeDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'tbl_Seismic_Object_Type_dict';

  KeyFieldNames := 'SEISMIC_OBJECT_TYPE_ID';
  FieldNames := 'SEISMIC_OBJECT_TYPE_ID, VCH_SEISMIC_OBJECT_TYPE_NAME, VCH_SHORT_SEISMIC_OBJ_TYPE_NAME';

  AccessoryFieldNames := 'SEISMIC_OBJECT_TYPE_ID, VCH_SEISMIC_OBJECT_TYPE_NAME, VCH_SHORT_SEISMIC_OBJ_TYPE_NAME';
  AutoFillDates := false;

  Sort := 'VCH_SEISMIC_OBJECT_TYPE_NAME';
end;

function TSeismicObjectTypeDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TSeismicObjectTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    s: TSeismicObjectType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if Assigned(Aobjects) and (not ds.Eof) then
  begin
    ds.First;

    while not ds.Eof do
    begin
      s := AObjects.Add as TSeismicObjectType;

      s.ID := ds.FieldByName('Seismic_Object_Type_ID').AsInteger;
      s.Name := trim(ds.FieldByName('vch_Seismic_Object_Type_Name').AsString);
      s.ShortName := trim(ds.FieldByName('VCH_SHORT_SEISMIC_OBJ_TYPE_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TSeismicObjectTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    s: TSeismicObjectType;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  s := AObject as TSeismicObjectType;

  ds.FieldByName('Seismic_Object_Type_ID').AsInteger := s.ID;
  ds.FieldByName('vch_Seismic_Object_Type_Name').AsString := s.Name;
  ds.FieldByName('VCH_SHORT_SEISMIC_OBJ_TYPE_NAME').AsString := s.ShortName;

  ds.Post;

  if s.ID = 0 then
    s.ID := ds.FieldByName('Seismic_Object_Type_ID').AsInteger;
end;

{ TSeismicWorkTypeDataPoster }

constructor TSeismicWorkTypeDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_SEISWORK_TYPE';

  KeyFieldNames := 'SEIS_WORK_TYPE_ID';
  FieldNames := 'SEIS_WORK_TYPE_ID, VCH_SEISWORK_TYPE_NAME';

  AccessoryFieldNames := 'SEIS_WORK_TYPE_ID, VCH_SEISWORK_TYPE_NAME';
  AutoFillDates := false;

  Sort := 'VCH_SEISWORK_TYPE_NAME';
end;

function TSeismicWorkTypeDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TSeismicWorkTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    w: TSeismicWorkType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if Assigned(AObjects) and (not ds.Eof) then
  begin
    ds.First;

    while not ds.Eof do
    begin
      w := AObjects.Add as TSeismicWorkType;

      w.ID := ds.FieldByName('SEIS_WORK_TYPE_ID').AsInteger;
      w.Name := trim(ds.FieldByName('VCH_SEISWORK_TYPE_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TSeismicWorkTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    w: TSeismicWorkType;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  w := AObject as TSeismicWorkType;

  ds.FieldByName('SEIS_WORK_TYPE_ID').AsInteger := w.ID;
  ds.FieldByName('VCH_SEISWORK_TYPE_NAME').AsString := w.Name;

  ds.Post;

  if w.ID = 0 then
    w.ID := ds.FieldByName('SEIS_WORK_TYPE_ID').AsInteger;
end;

{ TSeismicCrewDataPoster }

constructor TSeismicCrewDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'tbl_Seismic_Crew';

  KeyFieldNames := 'SEISMIC_CREW_ID';
  FieldNames := 'SEISMIC_CREW_ID, SEISMIC_CREW_NAME';

  AccessoryFieldNames := 'SEISMIC_CREW_ID, SEISMIC_CREW_NAME';
  AutoFillDates := false;

  Sort := 'SEISMIC_CREW_NAME';
end;

function TSeismicCrewDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TSeismicCrewDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    s: TSeismicCrew;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  //if not ds.Eof then
  if Assigned(AObjects) and (not ds.Eof) then
  begin
    ds.First;

    while not ds.Eof do
    begin
      s := AObjects.Add as TSeismicCrew;

      s.ID := ds.FieldByName('Seismic_Crew_ID').AsInteger;
      s.Name := trim(ds.FieldByName('Seismic_Crew_Name').AsString);
      //s.ShortName := trim(ds.FieldByName('VCH_SHORT_SEISMIC_OBJ_TYPE_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TSeismicCrewDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    s: TSeismicCrew;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  s := AObject as TSeismicCrew;

  ds.FieldByName('Seismic_Crew_ID').AsInteger := s.ID;
  ds.FieldByName('Seismic_Crew_Name').AsString := s.Name;
  //ds.FieldByName('VCH_SHORT_SEISMIC_OBJ_TYPE_NAME').AsString := s.ShortName;

  ds.Post;

  if s.ID = 0 then
    s.ID := ds.FieldByName('Seismic_Crew_ID').AsInteger;
end;

{ TSeismicReportDataPoster }

constructor TSeismicReportDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_SEISMIC_REPORT';

  KeyFieldNames := 'SEISMIC_REPORT_ID';
  FieldNames := 'SEISMIC_REPORT_ID, VCH_REPORT_NAME, VCH_INVENTORY_NUMBER, VCH_COMMENT, DTM_END_REPORT_DATE, DTM_SEND_DATE, VCH_REJECTION_REASON, DTM_BEGIN_WORK_DATE, DTM_END_WORK_DATE, VCH_CUSTOMER, VCH_WORKER, SEISMIC_CREW_ID, SEIS_WORK_TYPE_ID';

  AccessoryFieldNames := 'SEISMIC_REPORT_ID, VCH_REPORT_NAME, VCH_INVENTORY_NUMBER, VCH_COMMENT, DTM_END_REPORT_DATE, DTM_SEND_DATE, VCH_REJECTION_REASON, DTM_BEGIN_WORK_DATE, DTM_END_WORK_DATE, VCH_CUSTOMER, VCH_WORKER, SEISMIC_CREW_ID, SEIS_WORK_TYPE_ID';
  AutoFillDates := false;

  Sort := 'VCH_REPORT_NAME';
end;

function TSeismicReportDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TSeismicReportDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TSeismicReport;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if Assigned(AObjects) and (not ds.Eof) then
  begin
    ds.First;


    while not ds.Eof do
    begin
      o := AObjects.Add as TSeismicReport;

      o.ID := ds.FieldByName('SEISMIC_REPORT_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_REPORT_NAME').AsString);
      o.InvNumber := trim(ds.FieldByName('VCH_INVENTORY_NUMBER').AsString);
      o.Comment := trim(ds.FieldByName('VCH_COMMENT').AsString);
      o.EndReportDate := StrToDate((ds.FieldByName('DTM_END_REPORT_DATE').AsString));
      o.SendDate := StrToDate((ds.FieldByName('DTM_SEND_DATE').AsString));
      o.RejReason := trim(ds.FieldByName('VCH_REJECTION_REASON').AsString);
      o.BeginWorkDate := StrToDate((ds.FieldByName('DTM_BEGIN_WORK_DATE').AsString));
      o.EndWorkDate := StrToDate((ds.FieldByName('DTM_END_WORK_DATE').AsString));
      o.Customer := trim(ds.FieldByName('VCH_CUSTOMER').AsString);
      o.Worker := trim(ds.FieldByName('VCH_WORKER').AsString);
      if Assigned(AllSeismicCrews) then
      o.SeismicCrew := FAllSeismicCrews.ItemsByID[ds.FieldByName('SEISMIC_CREW_ID').AsInteger] as TSeismicCrew;
      if Assigned(AllSeismicWorkTypes) then
      o.SeismicWorkType := AllSeismicWorkTypes.ItemsByID[ds.FieldByName('SEIS_WORK_TYPE_ID').AsInteger] as TSeismicWorkType;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TSeismicReportDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    a: TSeismicReport;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  a := AObject as TSeismicReport;

  ds.FieldByName('SEISMIC_REPORT_ID').Value := a.ID;
  ds.FieldByName('VCH_REPORT_NAME').Value := trim(a.Name);
  ds.FieldByName('VCH_INVENTORY_NUMBER').Value := trim(a.InvNumber);
  ds.FieldByName('VCH_COMMENT').Value := trim(a.Comment);
  ds.FieldByName('DTM_END_REPORT_DATE').Value := a.EndReportDate;
  ds.FieldByName('DTM_SEND_DATE').Value := a.SendDate;
  ds.FieldByName('VCH_REJECTION_REASON').Value := Trim(a.RejReason);
  ds.FieldByName('DTM_BEGIN_WORK_DATE').Value := a.BeginWorkDate;
  ds.FieldByName('DTM_END_WORK_DATE').Value := a.EndWorkDate;
  ds.FieldByName('VCH_CUSTOMER').Value := Trim(a.Customer);
  ds.FieldByName('VCH_WORKER').Value := Trim(a.Worker);
  ds.FieldByName('SEISMIC_CREW_ID').Value := a.SeismicCrew.ID;
  ds.FieldByName('SEIS_WORK_TYPE_ID').Value := a.SeismicWorkType.ID;

  ds.Post;

  a.ID := ds.FieldByName('SEISMIC_REPORT_ID').AsInteger;
end;

{ TSeismicProfileTypeDataPoster }

constructor TSeismicProfileTypeDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_SEISMIC_PROFILE_TYPE';

  KeyFieldNames := 'SEISMIC_PROFILE_TYPE_ID';
  FieldNames := 'SEISMIC_PROFILE_TYPE_ID, VCH_SEISMIC_PROFILE_TYPE_NAME';

  AccessoryFieldNames := 'SEISMIC_PROFILE_TYPE_ID,VCH_SEISMIC_PROFILE_TYPE_NAME';
  AutoFillDates := false;

  Sort := 'VCH_SEISMIC_PROFILE_TYPE_NAME';
end;

function TSeismicProfileTypeDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TSeismicProfileTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    w: TSeismicProfileType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if Assigned(AObjects) and (not ds.Eof) then
  begin
    ds.First;

    while not ds.Eof do
    begin
      w := AObjects.Add as TSeismicProfileType;

      w.ID := ds.FieldByName('SEISMIC_PROFILE_TYPE_ID').AsInteger;
      w.Name := trim(ds.FieldByName('VCH_SEISMIC_PROFILE_TYPE_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;


function TSeismicProfileTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;

  var ds: TDataSet;
    w: TSeismicProfileType;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  w := AObject as TSeismicProfileType;

  ds.FieldByName('SEISMIC_PROFILE_TYPE_ID').AsInteger := w.ID;
  ds.FieldByName('VCH_SEISMIC_PROFILE_TYPE_NAME').AsString := w.Name;

  ds.Post;

  if w.ID = 0 then
    w.ID := ds.FieldByName('SEISMIC_PROFILE_TYPE_ID').AsInteger;
end;

{ TSeismicProfileDataPoster }

constructor TSeismicProfileDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_SEISMIC_PROFILE';

  KeyFieldNames := 'SEISMIC_PROFILE_ID';
  FieldNames := 'SEISMIC_PROFILE_ID, NUM_SEISMIC_PROFILE_NUMBER, SEISMIC_PROFILE_TYPE_ID, SEISMIC_REPORT_ID';

  AccessoryFieldNames := 'SEISMIC_PROFILE_ID, NUM_SEISMIC_PROFILE_NUMBER, SEISMIC_PROFILE_TYPE_ID, SEISMIC_REPORT_ID';
  AutoFillDates := false;

  Sort := 'NUM_SEISMIC_PROFILE_NUMBER';
end;

function TSeismicProfileDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TSeismicProfileDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TSeismicProfile;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if Assigned(AObjects) and (not ds.Eof) then
  begin
    ds.First;


    while not ds.Eof do
    begin
      o := AObjects.Add as TSeismicProfile;

      o.ID := ds.FieldByName('SEISMIC_PROFILE_ID').AsInteger;
      o.SeismicProfileNum := ds.FieldByName('NUM_SEISMIC_PROFILE_NUMBER').AsInteger;
      if Assigned(AllSeismicProfileTypes) then
      o.SeismicProfileType := FAllSeismicProfileTypes.ItemsById[ds.FieldByName('SEISMIC_PROFILE_TYPE_ID').AsInteger] as TSeismicProfileType;
      o.SeismicReport := FAllSeismicReports.ItemsById[ds.FieldByName('SEISMIC_REPORT_ID').AsInteger] as TSeismicReport;

      ds.Next;
    end;

    ds.First;
  end;
end;


function TSeismicProfileDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    a: TSeismicProfile;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  a := AObject as TSeismicProfile;

  ds.FieldByName('SEISMIC_PROFILE_ID').Value := a.ID;
  ds.FieldByName('NUM_SEISMIC_PROFILE_NUMBER').Value := a.SeismicProfileNum;
  ds.FieldByName('SEISMIC_PROFILE_TYPE_ID').Value := a.SeismicProfileType.ID;
  ds.FieldByName('SEISMIC_REPORT_ID').Value := a.SeismicReport.ID;

  ds.Post;

  a.ID := ds.FieldByName('SEISMIC_PROFILE_ID').AsInteger;
end;


end.
