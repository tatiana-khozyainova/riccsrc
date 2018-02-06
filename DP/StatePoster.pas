unit StatePoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, State;

type
  // для причин ликвидации
  TAbandonReasonDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  // для причин ликвидации скважины
  TAbandonReasonWellDataPoster = class(TImplementedDataPoster)
  private
    FAllAbandonReasons: TAbandonReasons;
    procedure SetAllAbandonReasons(const Value: TAbandonReasons);

  public
    property AllAbandonReasons: TAbandonReasons read FAllAbandonReasons write SetAllAbandonReasons;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  // для состояний скважин
  TStateDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses Facade, SysUtils;

{ TStateDataPoster }

constructor TStateDataPoster.Create;
begin
  inherited;
  Options := [];
  DataSourceString := 'TBL_WELL_STATUS_DICT';
  DataDeletionString := '';
  DataPostString := '';

  KeyFieldNames := 'WELL_STATE_ID';
  FieldNames := 'WELL_STATE_ID, VCH_WELL_STATE_NAME';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_WELL_STATE_NAME';
end;

function TStateDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TStateDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TState;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TState;

      o.ID := ds.FieldByName('WELL_STATE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_WELL_STATE_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TStateDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

{ TAbandonReasonDataPoster }

constructor TAbandonReasonDataPoster.Create;
begin
  inherited;
  Options := [];
  DataSourceString := 'TBL_ABANDON_REASON_DICT';
  DataDeletionString := '';
  DataPostString := '';

  KeyFieldNames := 'ABANDON_REASON_ID';
  FieldNames := 'ABANDON_REASON_ID, VCH_ABANDON_REASON';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_ABANDON_REASON';
end;

function TAbandonReasonDataPoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TAbandonReasonDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TAbandonReason;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TAbandonReason;

      o.ID := ds.FieldByName('ABANDON_REASON_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_ABANDON_REASON').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TAbandonReasonDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

{ TAbandonReasonWellDataPoster }

constructor TAbandonReasonWellDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_ABANDONED_WELL';

  KeyFieldNames := 'WELL_UIN';
  FieldNames := 'WELL_UIN, ABANDON_REASON_ID, DTM_ABANDON_DATE';

  AccessoryFieldNames := 'WELL_UIN, ABANDON_REASON_ID, DTM_ABANDON_DATE';
  AutoFillDates := false;

  Sort := 'WELL_UIN';
end;

function TAbandonReasonWellDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TAbandonReasonWellDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TAbandonReasonWell;
    Sourse: TAbandonReasonWell;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TAbandonReasonWell;

      if Assigned (FAllAbandonReasons) then
      begin
        Sourse := TAbandonReasonWell(FAllAbandonReasons.ItemsByID[ds.FieldByName('ABANDON_REASON_ID').AsInteger]);
        if Assigned (Sourse) then o.Assign(Sourse);
      end;

      o.DtLiquidation := ds.FieldByName('DTM_ABANDON_DATE').AsDateTime;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TAbandonReasonWellDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o : TAbandonReasonWell;
    bIsEditing: Boolean;
begin
  Assert(DataPostString <> '', 'Не задан приемник данных ' + ClassName);
  Result := 0;

  o := AObject as TAbandonReasonWell;

   try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);

    if not ds.Active then
      ds.Open;

    bIsEditing := False;

    if ds.Locate('WELL_UIN', o.Collection.Owner.ID, []) then
    begin
      ds.Edit;
      bIsEditing := true;
    end;

    if not bIsEditing then ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;

  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  ds.FieldByName('WELL_UIN').AsInteger := o.Collection.Owner.ID;
  ds.FieldByName('ABANDON_REASON_ID').AsInteger := o.ID;
  ds.FieldByName('DTM_ABANDON_DATE').Value := DateToStr(o.DtLiquidation);

  ds.Post;
end;

procedure TAbandonReasonWellDataPoster.SetAllAbandonReasons(
  const Value: TAbandonReasons);
begin
  if FAllAbandonReasons <> Value then 
    FAllAbandonReasons := Value;
end;

end.
