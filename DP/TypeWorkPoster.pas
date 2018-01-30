unit TypeWorkPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, TypeWork, MeasureUnits;

type

  TStateWorkDataPoster = class(TImplementedDataPoster)
  private
    FAllTypeWorks: TTypeWorks;
    procedure SetAllTypeWorks(const Value: TTypeWorks);
  public
    property AllTypeWorks: TTypeWorks read FAllTypeWorks write SetAllTypeWorks;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TTypeWorkDataPoster = class (TImplementedDataPoster)
  private
    FAllMeasureUnits: TMeasureUnits;
    procedure SetAllMeasureUnits(const Value: TMeasureUnits);
  public
    property AllMeasureUnits: TMeasureUnits read FAllMeasureUnits write SetAllMeasureUnits;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses Facade, SysUtils;

{ TStateWorkDataPoster }

constructor TStateWorkDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_STATE_WORKS_DICT';

  KeyFieldNames := 'ID_STATE_WORK';
  FieldNames := 'ID_STATE_WORK, ID_TYPE_WORKS, VCH_STATE_WORK_NAME';

  AccessoryFieldNames := 'ID_STATE_WORK, ID_TYPE_WORKS, VCH_STATE_WORK_NAME';
  AutoFillDates := false;

  Sort := 'VCH_STATE_WORK_NAME';
end;

function TStateWorkDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TStateWorkDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TStateWork;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TStateWork;

      o.ID := ds.FieldByName('ID_STATE_WORK').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_STATE_WORK_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TStateWorkDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TStateWork;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := TStateWork(AObject);

  ds.FieldByName('ID_STATE_WORK').AsInteger := o.ID;
  if Assigned (o.Owner) then
    ds.FieldByName('ID_TYPE_WORKS').AsInteger := o.Owner.ID;
  ds.FieldByName('VCH_STATE_WORK_NAME').AsString := trim(o.Name);

  ds.Post;

  if o.ID <= 0 then o.ID := (ds as TCommonServerDataSet).CurrentRecordFilterValues[0];
end;

procedure TStateWorkDataPoster.SetAllTypeWorks(const Value: TTypeWorks);
begin
  if FAllTypeWorks <> Value then
    FAllTypeWorks := Value;
end;

{ TTypeWorkDataPoster }

constructor TTypeWorkDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_TYPE_WORKS_DICT';
  //DataPostString := 'SPD_ADD_TYPE_WORK_PLAN_GRR';
  //DataDeletionString := 'TBL_TYPE_WORKS_DICT';

  KeyFieldNames := 'ID_TYPE_WORKS';
  FieldNames := 'ID_TYPE_WORKS, NUMBER_COLUMN, MEASURE_UNIT_ID, VCH_WORK_TYPE_NAME, ID_PARENT_WORK_TYPE';

  AccessoryFieldNames := 'ID_TYPE_WORKS, NUMBER_COLUMN, MEASURE_UNIT_ID, VCH_WORK_TYPE_NAME, ID_PARENT_WORK_TYPE';
  AutoFillDates := false;

  Sort := 'NUMBER_COLUMN';
end;

function TTypeWorkDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  // если не будет внешнего ключа, то удал€ть сначала из таблицы с состо€ни€ми работ
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TTypeWorkDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o:  TTypeWork;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TTypeWork;

      o.ID := ds.FieldByName('ID_TYPE_WORKS').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_WORK_TYPE_NAME').AsString);
      o.MeasureUnit := FAllMeasureUnits.ItemsByID[ds.FieldByName('MEASURE_UNIT_ID').AsInteger] as TMeasureUnit;
      o.NumberPP := ds.FieldByName('NUMBER_COLUMN').AsInteger;

      if Assigned (o.Owner) then o.Level := (o.Owner as TTypeWork).Level + 1;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TTypeWorkDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TTypeWork;
begin
  Assert(DataPostString <> '', 'Ќе задан приемник данных ' + ClassName);
  Result := 0;

  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);

    if not ds.Active then
      ds.Open;

    o := AObject as TTypeWork;

    if ds.Locate('ID_TYPE_WORKS', o.Owner.ID, []) then
      ds.Edit
    else ds.Append;

    ds.FieldByName('ID_TYPE_WORKS').AsInteger := o.ID;
    ds.FieldByName('NUMBER_COLUMN').AsInteger := o.NumberPP;

    if Assigned (o.MeasureUnit) then
      ds.FieldByName('MEASURE_UNIT_ID').AsInteger := o.MeasureUnit.ID;

    ds.FieldByName('VCH_WORK_TYPE_NAME').AsString := trim (o.Name);

    if Assigned (o.Owner) then
      ds.FieldByName('ID_PARENT_WORK_TYPE').AsInteger := o.Owner.ID;

    ds.Post;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;
end;

procedure TTypeWorkDataPoster.SetAllMeasureUnits(
  const Value: TMeasureUnits);
begin
  if FAllMeasureUnits <> Value then
    FAllMeasureUnits := Value;
end;

end.
