unit AltitudePoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, Altitude;

type
  TMeasureSystemTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TAltitudeTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TAltitudeDataPoster = class(TImplementedDataPoster)
  private
    FAllAltitudeTypes: TAltitudeTypes;
    FAllMeasureSystemTypes: TMeasureSystemTypes;

    procedure SetAllAltitudeTypes(const Value: TAltitudeTypes);
    procedure SetAllMeasureSystemTypes(const Value: TMeasureSystemTypes);
  public
    property AllAltitudeTypes: TAltitudeTypes read FAllAltitudeTypes write SetAllAltitudeTypes;
    property AllMeasureSystemTypes: TMeasureSystemTypes read FAllMeasureSystemTypes write SetAllMeasureSystemTypes;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;


implementation

uses Facade, SysUtils, Variants;

{ TAltitudeDataPoster }

constructor TAltitudeDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_ALTITUDE';

  KeyFieldNames := 'WELL_UIN; ALTITUDE_TYPE_ID; MEASURE_SYSTEM_TYPE_ID';
  FieldNames := 'WELL_UIN, ALTITUDE_TYPE_ID, MEASURE_SYSTEM_TYPE_ID, NUM_ALTITUDE, NUM_ORDER';

  AccessoryFieldNames := 'WELL_UIN, ALTITUDE_TYPE_ID, MEASURE_SYSTEM_TYPE_ID, NUM_ALTITUDE, NUM_ORDER';
  AutoFillDates := false;

  Sort := 'WELL_UIN, NUM_ORDER, ALTITUDE_TYPE_ID, MEASURE_SYSTEM_TYPE_ID';
end;

function TAltitudeDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
//begin
  //Result := inherited DeleteFromDB(AObject, ACollection);
var ds: TCommonServerDataSet;
    o: TAltitude;
begin
  Assert(DataDeletionString <> '', 'Не задан приемник данных ' + ClassName);
  Result := 0;

  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    if not ds.Active then
      ds.Open;

    o := AObject as TAltitude;

    if ds.Locate(ds.KeyFieldNames, varArrayOf([o.Owner.ID,
                                               o.AltitudeType.ID,
                                               o.MeasureSystemType.ID]), []) then
    ds.Delete
  except
  on E: Exception do
    begin
      raise;
    end;
  end;
end;

function TAltitudeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TAltitude;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TAltitude;

      o.ID := ds.FieldByName('ALTITUDE_TYPE_ID').AsInteger;

      if Assigned (FAllAltitudeTypes) then
        o.AltitudeType := FAllAltitudeTypes.ItemsByID[ds.FieldByName('ALTITUDE_TYPE_ID').AsInteger] as TAltitudeType;

      if Assigned (FAllMeasureSystemTypes) then
        o.MeasureSystemType := FAllMeasureSystemTypes.ItemsByID[ds.FieldByName('MEASURE_SYSTEM_TYPE_ID').AsInteger] as TMeasureSystemType;

      o.Value := ds.FieldByName('NUM_ALTITUDE').AsFloat;
      o.Order := ds.FieldByName('NUM_ORDER').AsInteger;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TAltitudeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TCommonServerDataSet;
    o: TAltitude;
begin
  Result := 0;

  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    if not ds.Active then
      ds.Open;

    o := AObject as TAltitude;

    if ds.Locate(ds.KeyFieldNames, varArrayOf([o.Owner.ID,
                                               o.AltitudeType.ID,
                                               o.MeasureSystemType.ID]), []) then
      ds.Edit
    else ds.Append;

    ds.FieldByName('WELL_UIN').Value := o.Owner.ID;
    ds.FieldByName('ALTITUDE_TYPE_ID').Value := o.AltitudeType.ID;
    ds.FieldByName('MEASURE_SYSTEM_TYPE_ID').Value := o.MeasureSystemType.ID;
    ds.FieldByName('NUM_ALTITUDE').Value := o.Value;
    ds.FieldByName('NUM_ORDER').Value := o.Order;

    ds.Post;

  except
  on E: Exception do
    begin
      raise;
    end;
  end;
end;

procedure TAltitudeDataPoster.SetAllAltitudeTypes(
  const Value: TAltitudeTypes);
begin
  if FAllAltitudeTypes <> Value then
    FAllAltitudeTypes := Value;
end;

procedure TAltitudeDataPoster.SetAllMeasureSystemTypes(
  const Value: TMeasureSystemTypes);
begin
  if FAllMeasureSystemTypes <> Value then
    FAllMeasureSystemTypes := Value;
end;

{ TMeasureSystemTypeDataPoster }

constructor TMeasureSystemTypeDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_ALT_MEASURE_SYSTEM_DICT';

  KeyFieldNames := 'MEASURE_SYSTEM_TYPE_ID';
  FieldNames := 'MEASURE_SYSTEM_TYPE_ID, VCH_MEASURE_SYSTEM_TYPE_NAME';

  AccessoryFieldNames := 'MEASURE_SYSTEM_TYPE_ID, VCH_MEASURE_SYSTEM_TYPE_NAME';
  AutoFillDates := false;

  Sort := 'VCH_MEASURE_SYSTEM_TYPE_NAME';
end;

function TMeasureSystemTypeDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TMeasureSystemTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TMeasureSystemType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TMeasureSystemType;

      o.ID := ds.FieldByName('MEASURE_SYSTEM_TYPE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_MEASURE_SYSTEM_TYPE_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TMeasureSystemTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

{ TAltitudeTypeDataPoster }

constructor TAltitudeTypeDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_ALTITUDE_TYPE_DICT';

  KeyFieldNames := 'ALTITUDE_TYPE_ID';
  FieldNames := 'ALTITUDE_TYPE_ID, VCH_ALTITUDE_TYPE';

  AccessoryFieldNames := 'ALTITUDE_TYPE_ID, VCH_ALTITUDE_TYPE';
  AutoFillDates := false;

  Sort := 'VCH_ALTITUDE_TYPE';
end;

function TAltitudeTypeDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TAltitudeTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TAltitudeType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TAltitudeType;

      o.ID := ds.FieldByName('ALTITUDE_TYPE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_ALTITUDE_TYPE').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TAltitudeTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

end.
