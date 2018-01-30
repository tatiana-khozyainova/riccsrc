unit TestIntervalPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, Straton, TestInterval, Fluid;

type

  TTestingAttitudeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TTestingIntervalFluidCharacteristicDataPoster = class(TImplementedDataPoster)
  private
    FFluidTypes: TFluidTypes;
    procedure SetFluidTypes(const Value: TFluidTypes);
  public
    property AllFluidTypes: TFluidTypes read FFluidTypes write SetFluidTypes;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  // для долблений
  TTestIntervalDataPoster = class(TImplementedDataPoster)
  private
    FStratons: TSimpleStratons;
    FAllTestAttitudes: TTestingAttitudes;
    procedure SetAllTestAltitudes(const Value: TTestingAttitudes);
    procedure SetStratons(const Value: TSimpleStratons);
  public
    property AllStratons: TSimpleStratons read FStratons write SetStratons;
    property AllTestAttitudes: TTestingAttitudes read FAllTestAttitudes write SetAllTestAltitudes;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TTestIntervalAdditionalDepthPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses Facade, SysUtils, BaseWellInterval, Variants, BaseFacades;

{ TSlottingDataPoster }

constructor TTestIntervalDataPoster.Create;
begin
  inherited;

  Options := [soKeyInsert, soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_TESTING_INTERVAL';

  KeyFieldNames := 'TESTING_INTERVAL_UIN';
  FieldNames := 'TESTING_INTERVAL_UIN, TESTING_ATTITUDE_ID, STRATON_ID, ' +
                'VCH_OBJECT_NUM, VCH_RESULTS_DESCRIPTION, WELL_UIN, VERSION_ID';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_OBJECT_NUM';
end;

function TTestIntervalDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TTestIntervalDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TSimpleTestInterval;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TSimpleTestInterval;

      o.ID := ds.FieldByName('TESTING_INTERVAL_UIN').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_OBJECT_NUM').AsString);
      o.Description := ds.FieldByName('VCH_RESULTS_DESCRIPTION').AsString;

      if Assigned(AllStratons) then o.Straton := AllStratons.ItemsByID[ds.FieldByName('STRATON_ID').AsInteger] as TSimpleStraton;
      if Assigned(AllTestAttitudes) then o.Attitude := AllTestAttitudes.ItemsByID[ds.FieldByName('TESTING_ATTITUDE_ID').AsInteger] as TTestingAttitude;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TTestIntervalDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TTestInterval;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TTestInterval;

  ds.FieldByName('TESTING_INTERVAL_UIN').Value := o.ID;
  ds.FieldByName('TESTING_ATTITUDE_ID').Value := o.Attitude.ID;
  ds.FieldByName('STRATON_ID').Value := o.Straton.ID;

  ds.FieldByName('VCH_OBJECT_NUM').Value := o.Name;

  ds.FieldByName('VCH_RESULTS_DESCRIPTION').Value := o.Description;
  ds.FieldByName('WELL_UIN').Value := (o.Collection as TTestIntervals).Owner.ID;
  ds.FieldByName('VERSION_ID').Value := TMainFacade.GetInstance.ActiveVersion.ID;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('TESTING_INTERVAL_UIN').Value;
end;

{ TTestingAttitudeDataPoster }

constructor TTestingAttitudeDataPoster.Create;
begin
  inherited;

  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_TESTING_ATTITUDE';
  DataDeletionString := '';
  DataPostString := '';

  KeyFieldNames := 'TESTING_ATTITUDE_ID';
  FieldNames := 'TESTING_ATTITUDE_ID, VCH_TESTING_ATTITUDE';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_TESTING_ATTITUDE';
end;

function TTestingAttitudeDataPoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TTestingAttitudeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TTestingAttitude;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TTestingAttitude;

      o.ID := ds.FieldByName('TESTING_ATTITUDE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_TESTING_ATTITUDE').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TTestingAttitudeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TTestingAttitude;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TTestingAttitude;

  ds.FieldByName('TESTING_ATTITUDE_ID').Value := o.ID;
  ds.FieldByName('VCH_ATTITUDE_NAME').Value := o.Name;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('TESTING_ATTITUDE_ID').Value;
end;

procedure TTestIntervalDataPoster.SetAllTestAltitudes(
  const Value: TTestingAttitudes);
begin
  if FAllTestAttitudes <> Value then
    FAllTestAttitudes := Value;
end;

procedure TTestIntervalDataPoster.SetStratons(const Value: TSimpleStratons);
begin
  FStratons := Value;
end;

{ TTestIntervalAdditionalDepthPoster }

constructor TTestIntervalAdditionalDepthPoster.Create;
begin
  inherited;

  Options := [soSingleDataSource];
  DataSourceString := 'TBL_TESTING_INTERVAL_DEPTH';

  KeyFieldNames := 'TESTING_INTERVAL_UIN';
  FieldNames := 'TESTING_INTERVAL_UIN, NUM_ABS_TOP_DEPTH, NUM_ABS_BOTTOM_DEPTH';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'TESTING_INTERVAL_UIN, NUM_ABS_TOP_DEPTH, NUM_ABS_BOTTOM_DEPTH';
end;

function TTestIntervalAdditionalDepthPoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TTestIntervalAdditionalDepthPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TDepth;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TDepth;

      o.AbsoluteTop := ds.FieldByName('NUM_ABS_TOP_DEPTH').AsFloat;
      o.AbsoluteBottom := ds.FieldByName('NUM_ABS_BOTTOM_DEPTH').AsFloat;
      o.ID := ds.FieldByName('TESTING_INTERVAL_UIN').AsInteger;
      
      o.ArrangeAbsoluteDepths;
      ds.Next;
    end;

    ds.First;
  end;
end;

function TTestIntervalAdditionalDepthPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TDepth;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TDepth;

  ds.FieldByName('TESTING_INTERVAL_UIN').Value := AObject.Collection.Owner.ID;
  ds.FieldByName('NUM_ABS_TOP_DEPTH').Value := o.AbsoluteTop;
  ds.FieldByName('NUM_ABS_BOTTOM_DEPTH').Value := o.AbsoluteBottom;

  ds.Post;
end;

{ TTestingIntervalFluidCharacteristicDataPoster }

constructor TTestingIntervalFluidCharacteristicDataPoster.Create;
begin
  inherited;

  Options := [soSingleDataSource];
  DataSourceString := 'TBL_TESTING_INTERVAL_FLUID_TYPE';

  KeyFieldNames := 'TESTING_INTERVAL_FLUID_TYPE_ID';
  FieldNames := 'TESTING_INTERVAL_FLUID_TYPE_ID, TESTING_INTERVAL_UIN, FLUID_TYPE_CHARACTERISTICS_ID, FLUID_TYPE_ID';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'TESTING_INTERVAL_UIN, FLUID_TYPE_CHARACTERISTICS_ID, FLUID_TYPE_ID';
end;

function TTestingIntervalFluidCharacteristicDataPoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TTestingIntervalFluidCharacteristicDataPoster.GetFromDB(
  AFilter: string; AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TTestIntervalFluidCharacteristic;
    iLastFluidTypeID: integer;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;
    iLastFluidTypeID := -1;
    o := nil;

    while not ds.Eof do
    begin
      if iLastFluidTypeID <> ds.FieldByName('FLUID_TYPE_ID').AsInteger then
      begin
        o := AObjects.Add as TTestIntervalFluidCharacteristic;
        o.ID := ds.FieldByName('TESTING_INTERVAL_FLUID_TYPE_ID').AsInteger;
        if Assigned(AllFluidTypes) then
          o.FluidType := AllFluidTypes.ItemsByID[ds.FieldByName('FLUID_TYPE_ID').AsInteger] as TFluidType;
        iLastFluidTypeID := ds.FieldByName('FLUID_TYPE_ID').AsInteger;
      end;

      if Assigned(o) then
      begin
        //if not ds.FieldByName('Fluid_Type_Characteristics_ID').IsNull then
          // !!! o.FluidCharacteristics.Add(TMainFacade.GetInstance.AllFluidTypeCharacteristics.ItemsByID[ds.FieldByName('Fluid_Type_Characteristics_ID').AsInteger], false, true);
      end;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TTestingIntervalFluidCharacteristicDataPoster.PostToDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TTestIntervalFluidCharacteristic;
    i: integer;
begin
  Result := 0;
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TTestIntervalFluidCharacteristic;

  if o.FluidCharacteristics.Count > 0 then
  begin
    for i := 0 to o.FluidCharacteristics.Count - 1 do
    begin
      Result := inherited PostToDB(AObject, ACollection);

      ds.FieldByName('TESTING_INTERVAL_UIN').Value := o.Collection.Owner.ID;
      ds.FieldByName('FLUID_TYPE_ID').Value := o.FluidType.ID;
      ds.FieldByName('FLUID_TYPE_CHARACTERISTICS_ID').Value := o.FluidCharacteristics.Items[i].ID;
      ds.Post;
    end;
  end
  else
  begin
    Result := inherited PostToDB(AObject, ACollection);

    ds.FieldByName('TESTING_INTERVAL_UIN').Value := AObject.Collection.Owner.ID;
    ds.FieldByName('FLUID_TYPE_ID').Value := o.FluidType.ID;
    ds.FieldByName('FLUID_TYPE_CHARACTERISTICS_ID').Value := null;
    ds.Post;
  end;
end;

procedure TTestingIntervalFluidCharacteristicDataPoster.SetFluidTypes(
  const Value: TFluidTypes);
begin
  if FFluidTypes <> Value then
    FFluidTypes := Value;
end;

end.
