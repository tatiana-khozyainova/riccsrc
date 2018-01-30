unit TestIntervalParameterDataPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, TestIntervalParameter, Fluid, MeasureUnits;

type
  TTestIntervalParameterDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;


implementation

uses Facade, SysUtils, SDFacade, Parameter, BaseFacades;

{ TTestIntervalParameterDataPoster }

constructor TTestIntervalParameterDataPoster.Create;
begin
  inherited;

  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_TESTING_PARAMETER_DICT';
  //DataDeletionString := '';
  //DataPostString := '';

  KeyFieldNames := 'TESTING_PARAMETER_ID';
  FieldNames := 'TESTING_PARAMETER_ID, VCH_TESTING_PARAM_NAME, VCH_TESTING_PARAM_SHORT_NAME, FLUID_TYPE_ID, MEASURE_UNIT_ID';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_TESTING_PARAM_NAME';
end;

function TTestIntervalParameterDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TTestIntervalParameterDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TTestIntervalParameter;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TTestIntervalParameter;

      o.ID := ds.FieldByName('Testing_Parameter_ID').AsInteger;
      o.Name := trim(ds.FieldByName('vch_Testing_Param_Name').AsString);
      o.ShortName := trim(ds.FieldByName('vch_Testing_Param_Short_Name').AsString);
      o.MeasureUnit := TMainFacade.GetInstance.AllMeasureUnits.ItemsByID[ds.FieldByName('Measure_Unit_ID').AsInteger] as TMeasureUnit;
      o.FluidType := TMainFacade.GetInstance.AllFluidTypes.ItemsByID[ds.FieldByName('Fluid_Type_ID').AsInteger] as TFluidType;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TTestIntervalParameterDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TTestIntervalParameter;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TTestIntervalParameter;

  ds.FieldByName('Testing_Parameter_ID').Value := o.ID;
  ds.FieldByName('vch_Testing_Param_Name').Value := o.Name;
  ds.FieldByName('vch_Testing_Param_Short_Name').Value := o.ShortName;
  ds.FieldByName('Fluid_Type_ID').Value := o.FluidType.ID;
  ds.FieldByName('Measure_Unit_ID').Value := o.MeasureUnit.ID;

  ds.Post;

  if o.ID = 0 then
    ds.FieldByName('Testing_Parameter_ID').Value := (ds as TCommonServerDataSet).CurrentRecordFilterValues[0, 0]; 
end;

end.
