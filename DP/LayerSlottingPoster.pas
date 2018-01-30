unit LayerSlottingPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, LayerSlotting, DB;

type

  TLayerSlottingDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TLayerRockSampleDataPoster = class(TImplementedDataPoster)
  private
    FLayers: TSimpleLayerSlottings;
    procedure SetLayers(const Value: TSimpleLayerSlottings);
  public
    property AllLayers: TSimpleLayerSlottings read FLayers write SetLayers;
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;

    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function PostToDB(ACollection: TIDObjects; AOwner: TIDObject): integer; override;

    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses Facade, BaseFacades, SysUtils, RockSample, Variants, Math;

{ TLayerSlottingDataPoster }

constructor TLayerSlottingDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_LAYER_SLOTTING';

  KeyFieldNames := 'LAYER_SLOTTING_ID';
  FieldNames := 'LAYER_SLOTTING_ID, NUM_LAYER_SLOTTING, BEGINING_LAYER, ENDING_LAYER, SLOTTING_UIN, DUMMY_LAYER';

  AccessoryFieldNames := 'LAYER_SLOTTING_ID, NUM_LAYER_SLOTTING, BEGINING_LAYER, ENDING_LAYER, SLOTTING_UIN, DUMMY_LAYER';
  AutoFillDates := false;

  Sort := 'NUM_LAYER_SLOTTING';
end;

function TLayerSlottingDataPoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TLayerSlottingDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o : TSimpleLayerSlotting;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TSimpleLayerSlotting;

      o.ID := ds.FieldByName('LAYER_SLOTTING_ID').AsInteger;
      o.Name := IntToStr(ds.FieldByName('NUM_LAYER_SLOTTING').AsInteger);
      o.BeginingLayer := ds.FieldByName('BEGINING_LAYER').AsFloat;
      o.EndingLayer := ds.FieldByName('ENDING_LAYER').AsFloat;
      o.Capacity := RoundTo(o.EndingLayer - o.BeginingLayer, -2);

      if ds.FieldByName('DUMMY_LAYER').AsInteger = 0 then
        o.DummyLayer := false
      else o.DummyLayer := true;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TLayerSlottingDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TSimpleLayerSlotting;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TSimpleLayerSlotting;

  ds.FieldByName('LAYER_SLOTTING_ID').AsInteger := o.ID;
  ds.FieldByName('NUM_LAYER_SLOTTING').AsInteger := StrToInt(trim(o.Name));
  ds.FieldByName('BEGINING_LAYER').AsFloat := o.BeginingLayer;
  ds.FieldByName('ENDING_LAYER').AsFloat := o.EndingLayer;
  ds.FieldByName('slotting_uin').Value := o.Collection.Owner.ID;

  if o.DummyLayer then ds.FieldByName('DUMMY_LAYER').AsInteger := 1 else ds.FieldByName('DUMMY_LAYER').AsInteger := 0;

  ds.Post;

  if o.ID = 0 then o.ID := ds.FieldByName('LAYER_SLOTTING_ID').Value;
end;

{ TLayerRockSampleDataPoster }

constructor TLayerRockSampleDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_ROCK_SAMPLE_LAYER';
  //DataPostString := 'SPD_ADD_ROCK_SAMPLE_LAYER';
  //DataDeletionString := 'TBL_ROCK_SAMPLE_LAYER';

  KeyFieldNames := 'ROCK_SAMPLE_UIN';
  FieldNames := 'LAYER_SLOTTING_ID, ROCK_SAMPLE_UIN';

  AccessoryFieldNames := 'LAYER_SLOTTING_ID, ROCK_SAMPLE_UIN';
  AutoFillDates := false;

  Sort := '';
end;

function TLayerRockSampleDataPoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TLayerRockSampleDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TLayerRockSample;
    oSourse: TSimpleLayerSlotting;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TLayerRockSample;
      oSourse := AllLayers.ItemsByID[ds.FieldByName('LAYER_SLOTTING_ID').AsInteger] as TSimpleLayerSlotting;
      if Assigned (oSourse) then
        o.Assign(oSourse);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TLayerRockSampleDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o : TLayerRockSample;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TLayerRockSample;

  ds.FieldByName('LAYER_SLOTTING_ID').AsInteger := o.ID;
  ds.FieldByName('ROCK_SAMPLE_UIN').AsInteger := o.RockSample.ID;

  ds.Post;

  o.ID := ds.FieldByName('LAYER_SLOTTING_ID').AsInteger;
end;

function TLayerRockSampleDataPoster.PostToDB(ACollection: TIDObjects;
  AOwner: TIDObject): integer;
begin
  Result := 0;
end;

procedure TLayerRockSampleDataPoster.SetLayers(const Value: TSimpleLayerSlottings);
begin
  if FLayers <> Value then
    FLayers := Value
end;

end.
