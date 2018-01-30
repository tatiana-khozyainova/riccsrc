unit FluidPoster;

interface


uses PersistentObjects, DBGate, BaseObjects, DB, Fluid;

type
  TFluidCharacteristicDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;


  TFluidTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses Facade, SysUtils;

{ TFluidTypeDataPoster }

constructor TFluidTypeDataPoster.Create;
begin
  inherited;

  Options := [soSingleDataSource];
  DataSourceString := 'TBL_FLUID_TYPE_DICT';

  KeyFieldNames := 'FLUID_TYPE_ID';
  FieldNames := 'FLUID_TYPE_ID, VCH_FLUID_TYPE_NAME, VCH_FLUID_SHORT_NAME, NUM_BALANCE_FLUID';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_FLUID_TYPE_NAME';
end;

function TFluidTypeDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TFluidTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TFluidType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TFluidType;
      o.ID := ds.FieldByName('FLUID_TYPE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_FLUID_TYPE_NAME').AsString);
      o.ShortName := trim(ds.FieldByName('VCH_FLUID_SHORT_NAME').AsString);
      o.BalanceFluid := ds.FieldByName('NUM_BALANCE_FLUID').AsInteger;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TFluidTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TFluidType;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TFluidType;

  ds.FieldByName('FLUID_TYPE_ID').Value := o.ID;
  ds.FieldByName('VCH_FLUID_TYPE_NAME').Value := o.Name;
  ds.FieldByName('VCH_FLUID_SHORT_NAME').Value := o.ShortName;
  if o.BalanceFluid <> 0 then
    ds.FieldByName('NUM_BALANCE_FLUID').AsInteger := o.BalanceFluid;

  ds.Post;

  o.ID := ds.FieldByName('FLUID_TYPE_ID').Value;
end;

{ TTestIntervalFluidCharacteristicDataPoster }

constructor TFluidCharacteristicDataPoster.Create;
begin
  inherited;

  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_FLUID_TYPE_CHARACTERISTICS';

  KeyFieldNames := 'FLUID_TYPE_CHARACTERISTICS_ID';
  FieldNames := 'FLUID_TYPE_CHARACTERISTICS_ID, VCH_FLUID_TYPE_CHARACT_NAME';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_FLUID_TYPE_CHARACT_NAME';
end;

function TFluidCharacteristicDataPoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject,ACollection);
end;

function TFluidCharacteristicDataPoster.GetFromDB(
  AFilter: string; AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TIDObject;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add;
      o.ID := ds.FieldByName('FLUID_TYPE_CHARACTERISTICS_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_FLUID_TYPE_CHARACT_NAME').AsString);
      ds.Next;
    end;

    ds.First;
  end;
end;

function TFluidCharacteristicDataPoster.PostToDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TIDObject;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TIDObject;

  ds.FieldByName('FLUID_TYPE_CHARACTERISTICS_ID').Value := o.ID;
  ds.FieldByName('VCH_FLUID_TYPE_CHARACT_NAME').Value := o.Name;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('FLUID_TYPE_CHARACTERISTICS_ID').Value;
end;

end.
