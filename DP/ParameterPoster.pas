unit ParameterPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, Parameter, TestInterval, MeasureUnits;

type
  TParameterDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TParameterValueDataPoster = class(TImplementedDataPoster)
  private
    FParameters: TParameters;
  public
    property AllParameters: TParameters read FParameters write FParameters;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TParameterByWellDataPoster = class(TImplementedDataPoster)
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

  TParametersGroupByWellDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;


    constructor Create; override;
  end;

  TParameterValueByWellDataPoster = class(TImplementedDataPoster)
  private
    FAllParameters: TParametersByWell;
    procedure SetAllParameters(const Value: TParametersByWell);
  public
    property AllParameters: TParametersByWell read FAllParameters write SetAllParameters;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;


    constructor Create; override;
  end;

implementation

uses Facade, SysUtils, Well;

{ TParameterDataPoster }

constructor TParameterDataPoster.Create;
begin
  inherited;

  Options := [soSingleDataSource];
  DataSourceString := 'TBL_TESTING_PARAMETER_DICT';

  KeyFieldNames := 'TESTING_PARAMETER_ID';
  FieldNames := 'TESTING_PARAMETER_ID, VCH_TESTING_PARAM_NAME, VCH_TESTING_PARAM_SHORT_NAME';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_TESTING_PARAM_NAME';
end;

function TParameterDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TParameterDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TParameter;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TParameter;

      o.ID := ds.FieldByName('Testing_Parameter_ID').AsInteger;
      o.Name := trim(ds.FieldByName('vch_Testing_Param_Name').AsString);
      o.ShortName := trim(ds.FieldByName('vch_Testing_Param_Short_Name').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TParameterDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TParameter;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TParameter;

  ds.FieldByName('Testing_Parameter_ID').Value := o.ID;
  ds.FieldByName('vch_Testing_Param_Name').Value := o.Name;
  ds.FieldByName('vch_Testing_Param_Short_Name').Value := o.ShortName;

  ds.Post;

  o.ID := ds.FieldByName('Testing_Parameter_ID').Value;
end;

{ TParameterValueDataPoster }

constructor TParameterValueDataPoster.Create;
begin
  inherited;

  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'tbl_Testing_Parameter_Value';

  KeyFieldNames := 'TESTING_PARAMETER_VALUE_ID';
  FieldNames := 'TESTING_PARAMETER_VALUE_ID, TESTING_INTERVAL_UIN, TESTING_PARAMETER_ID, num_Testing_Parameter_Value, vch_Testing_Parameter_Value';
  AccessoryFieldNames := '';
  AutoFillDates := false;
end;

function TParameterValueDataPoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TParameterValueDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    p: TParameterValue;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      p := AObjects.Add as TParameterValue;

      p.ID := ds.FieldByName('TESTING_PARAMETER_VALUE_ID').AsInteger;
      p.Parameter := AllParameters.ItemsByID[ds.FieldByName('TESTING_PARAMETER_ID').AsInteger] as TParameter;
      p.Value := ds.FieldByName('VCH_TESTING_PARAMETER_VALUE').AsString;
      p.NumValue := ds.FieldByName('NUM_TESTING_PARAMETER_VALUE').AsFloat;


      ds.Next;
    end;

    ds.First;
  end;
end;

function TParameterValueDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    p: TParameterValue;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  p := AObject as TParameterValue;

  ds.FieldByName('TESTING_PARAMETER_VALUE_ID').Value := p.ID;
  ds.FieldByName('TESTING_PARAMETER_ID').Value := p.Parameter.ID;
  ds.FieldByName('VCH_TESTING_PARAMETER_VALUE').Value := p.Value;
  ds.FieldByName('NUM_TESTING_PARAMETER_VALUE').Value := p.NumValue;
  ds.FieldByName('TESTING_INTERVAL_UIN').Value := p.Collection.Owner.ID;

  ds.Post;

  if p.ID <= 0 then p.ID := (ds as TCommonServerDataSet).CurrentRecordFilterValues[0];
end;

{ TParameterValueByWellDataPoster }

constructor TParameterValueByWellDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_PARAMETR_VALUES';

  KeyFieldNames := 'PARAMETR_VALUE_ID';
  FieldNames := 'PARAMETR_VALUE_ID, WELL_UIN, REASON_CHANGE_ID, INT_VALUE, VCH_VALUE, DTM_VALUE, DICT_VALUE_ID, TABLE_ID, PARAMETR_ID';

  AccessoryFieldNames := 'PARAMETR_VALUE_ID, WELL_UIN, REASON_CHANGE_ID, INT_VALUE, VCH_VALUE, DTM_VALUE, DICT_VALUE_ID, TABLE_ID, PARAMETR_ID';
  AutoFillDates := false;

  Sort := 'PARAMETR_VALUE_ID';
end;

function TParameterValueByWellDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;

begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TParameterValueByWellDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TParameterValueByWell;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TParameterValueByWell;

      o.ID := ds.FieldByName('PARAMETR_VALUE_ID').AsInteger;
      o.INTValue := ds.FieldByName('INT_VALUE').AsInteger;
      o.VCHValue := ds.FieldByName('VCH_VALUE').AsString;
      o.DTMValue := ds.FieldByName('DTM_VALUE').AsDateTime;

      //if Assigned ((o.Collection.Owner as TDinamicWell).ReasonChange) then
      //  ds.FieldByName('REASON_CHANGE_ID').AsInteger := (o.Collection.Owner as TDinamicWell).ReasonChange.ID;

      o.ParametrWell := AllParameters.ItemsByID[ds.FieldByName('PARAMETR_ID').AsInteger] as TParameterByWell;

      // WELL_UIN,
      // REASON_CHANGE_ID,
      // DICT_VALUE_ID,
      // TABLE_ID

      ds.Next;
    end;

    ds.First;
  end;
end;

function TParameterValueByWellDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TParameterValueByWell;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TParameterValueByWell;

  ds.FieldByName('PARAMETR_VALUE_ID').AsInteger := o.ID;
  ds.FieldByName('WELL_UIN').AsInteger := o.Collection.Owner.ID;

  //if Assigned ((o.Collection.Owner as TDinamicWell).ReasonChange) then
  //  ds.FieldByName('REASON_CHANGE_ID').AsInteger := (o.Collection.Owner as TDinamicWell).ReasonChange.ID;


  ds.FieldByName('INT_VALUE').AsInteger := o.INTValue;
  ds.FieldByName('VCH_VALUE').AsString := trim (o.VCHValue);
  ds.FieldByName('DTM_VALUE').AsDateTime := o.DTMValue;

  ds.FieldByName('PARAMETR_ID').AsInteger := o.ParametrWell.ID;

  //DICT_VALUE_ID,
  //TABLE_ID,

  ds.Post;

  if o.ID = 0 then o.ID := ds.FieldByName('PARAMETR_VALUE_ID').Value;
end;

procedure TParameterValueByWellDataPoster.SetAllParameters(
  const Value: TParametersByWell);
begin
  if FAllParameters <> Value then
    FAllParameters := Value;
end;

{ TParameterByWellDataPoster }

constructor TParameterByWellDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_PARAMETRS_DICT';

  KeyFieldNames := 'PARAMETR_ID';
  FieldNames := 'PARAMETR_ID, PARAMETR_NAME, PARAMETR_GROUPS_ID, MEASURE_UNIT_ID';

  AccessoryFieldNames := 'PARAMETR_ID, PARAMETR_NAME, PARAMETR_GROUPS_ID, MEASURE_UNIT_ID';
  AutoFillDates := false;

  Sort := 'PARAMETR_ID';
end;

function TParameterByWellDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TParameterByWellDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TParameterByWell;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TParameterByWell;

      o.ID := ds.FieldByName('PARAMETR_ID').AsInteger;
      o.Name := trim(ds.FieldByName('PARAMETR_NAME').AsString);

      if ds.FieldByName('MEASURE_UNIT_ID').AsInteger > 0 then
        o.MeasureUnit := FAllMeasureUnits.ItemsByID[ds.FieldByName('MEASURE_UNIT_ID').AsInteger] as TMeasureUnit;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TParameterByWellDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TParameterByWell;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TParameterByWell;

  ds.FieldByName('PARAMETR_ID').AsInteger := o.ID;
  ds.FieldByName('PARAMETR_NAME').AsString := trim (o.Name);
  ds.FieldByName('PARAMETR_GROUPS_ID').AsInteger := o.Owner.ID;

  if Assigned (o.MeasureUnit) then
    ds.FieldByName('MEASURE_UNIT_ID').AsInteger := o.MeasureUnit.ID;

  ds.Post;

  if o.ID = 0 then o.ID := ds.FieldByName('PARAMETR_ID').Value;
end;

{ TParameterGroupByWellDataPoster }

constructor TParametersGroupByWellDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_PARAMETR_GROUPS_DICT';

  KeyFieldNames := 'PARAMETR_GROUPS_ID';
  FieldNames := 'PARAMETR_GROUPS_ID, PARAMETR_GROUPS_NAME';

  AccessoryFieldNames := 'PARAMETR_GROUPS_ID, PARAMETR_GROUPS_NAME';
  AutoFillDates := false;

  Sort := 'PARAMETR_GROUPS_ID';
end;

function TParametersGroupByWellDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; 
begin
  Result := 0;
end;

function TParametersGroupByWellDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TParametersGroupByWell;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TParametersGroupByWell;

      o.ID := ds.FieldByName('PARAMETR_GROUPS_ID').AsInteger;
      o.Name := trim(ds.FieldByName('PARAMETR_GROUPS_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TParametersGroupByWellDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TParametersGroupByWell;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TParametersGroupByWell;

  ds.FieldByName('PARAMETR_GROUPS_ID').AsInteger := o.ID;
  ds.FieldByName('PARAMETR_GROUPS_NAME').AsString := trim (o.Name);

  ds.Post;

  if o.ID = 0 then o.ID := ds.FieldByName('PARAMETR_GROUPS_ID').Value;
end;

procedure TParameterByWellDataPoster.SetAllMeasureUnits(
  const Value: TMeasureUnits);
begin
  if FAllMeasureUnits <> Value then
    FAllMeasureUnits := Value;
end;

end.
