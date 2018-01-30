unit GRRObligationPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, GRRObligation, MeasureUnits, Table,
     Well, Organization, SeismWorkType, Structure, Area, State;//, LicenseZone;

type

  TBaseObligationDataPoster = class(TImplementedDataPoster)
  private
    FNirStates : TNIRStates;
    FNirTypes: TNIRTypes;
  public
    property AllNirStates : TNIRStates read FNirStates write FNirStates;
    property AllNirTypes : TNIRTypes read FNirTypes write FNirTypes;

    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;


    constructor Create; override;
  end;

  TNIRDataPoster = class(TBaseObligationDataPoster)
  private
    FMainNirObligations: TNIRObligations;
    FMeasureUnits: TMeasureUnits;
   // FVersion:
  public
    property AllMainNirObligations: TNIRObligations read  FMainNirObligations write FMainNirObligations;
    property AllMeasureUnits: TMeasureUnits read FMeasureUnits write FMeasureUnits;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    constructor Create; override;
  end;

  TNIRStateDataPoster = class (TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    constructor Create; override;
  end;

  TNIRTypeDataPoster = class (TImplementedDataPoster)
  private
    FNIRTypes:  TNIRTypes;
  public
    property AllNIRTypes: TNIRTypes read FNIRTypes write FNIRTypes;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    constructor Create; override;
  end;

  TSeismicObligationDataPoster = class(TBaseObligationDataPoster)
  private
    FSeismWorkTypes: TSeismWorkTypes;
  public
    property AllSeismWorkTypes: TSeismWorkTypes read FSeismWorkTypes write FSeismWorkTypes;
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TDrillingObligationDataPoster = class(TBaseObligationDataPoster)
  private
    FWellStates: TStates;
    FWellCategories: TWellCategories;
  public
    property AllWellStates: TStates read FWellStates write FWellStates;
    property AllWellCategories: TWellCategories read FWellCategories write FWellCategories;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TNirObligationPlaceDataPoster = class(TImplementedDataPoster)
  private
    FStructures: TStructures;
  public
    property AllStructures: TStructures read FStructures write FStructures;
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TSeismicObligationPlaceDataPoster = class (TImplementedDataPoster)
  private
    FStructures: TStructures;
    FAllAreas: TSimpleAreas;
  public
    property AllStructures: TStructures read FStructures write FStructures;
    property AllAreas: TSimpleAreas read FAllAreas write FAllAreas;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TDrillingObligationWellDataPoster = class (TImplementedDataPoster)
  private
    FStructures: TStructures;
    FWells : TWells;
    FNirStates : TNIRStates;
  public
    property AllStructures: TStructures read FStructures write FStructures;
    property AllWells: TWells read FWells write FWells;
    property AllNirStates : TNIRStates read FNirStates write FNirStates;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;


implementation

uses Facade, SysUtils, Math, DateUtils, Variants;

{ TNIRDataPoster }

constructor TNIRDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_NIR_OBLIGATION_TMP';
  DataDeletionString := 'TBL_NIR_OBLIGATION_TMP';
  DataPostString := 'TBL_NIR_OBLIGATION_TMP';



  FieldNames := 'OBLIGATION_ID, LICENSE_ID, VERSION_ID, ' +
                'DTM_FINISH_DATE, NIR_TYPE_ID, VCH_COMMENT, VCH_DATE_CONDITION,' +
                'NUM_NIR_FACT_COST, NUM_VOLUME, VOLUME_MEASURE_UNIT_ID,MAIN_OBLIGATION_ID,' +
                'NUM_FOR_FIELD_ONLY, NIR_FACT_STATE_ID, DTM_START_DATE, VCH_OBLIGATION_NAME';

  AccessoryFieldNames := 'OBLIGATION_ID, LICENSE_ID, VERSION_ID, ' +
                'DTM_FINISH_DATE, NIR_TYPE_ID, VCH_COMMENT, VCH_DATE_CONDITION,' +
                'NUM_NIR_FACT_COST, NUM_VOLUME, VOLUME_MEASURE_UNIT_ID,MAIN_OBLIGATION_ID,' +
                'NUM_FOR_FIELD_ONLY, NIR_FACT_STATE_ID, DTM_START_DATE, VCH_OBLIGATION_NAME';
  AutoFillDates := false;

  Sort := '';
end;

function TNIRDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TNIRDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TNIRObligation;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;
    if Assigned(AObjects) then
    begin
    while not ds.Eof do
    begin
      o := AObjects.Add as TNIRObligation;

      o.ID := ds.FieldByName('OBLIGATION_ID').AsInteger;
      o.StartDate := ds.FieldByName('DTM_START_DATE').AsDateTime;
      o.FinishDate := ds.FieldByName('DTM_FINISH_DATE').AsDateTime;
      o.Comment := trim(ds.FieldByName('VCH_COMMENT').AsString);
      o.Name := trim(ds.FieldByName('VCH_OBLIGATION_NAME').AsString);

      if Assigned(AllNirStates) then
        o.NIRState := AllNirStates.ItemsById[ds.FieldByName('NIR_FACT_STATE_ID').AsInteger] as TNIRState
      else
        o.NIRState := nil;

      if Assigned(AllNirTypes) then
        o.NirType := AllNirTypes.ItemsById[ds.FieldByName('NIR_TYPE_ID').AsInteger] as TNIRType
      else
        o.NirType := nil;

      if Assigned(AllMeasureUnits) then
        o.MeasureUnit := AllMeasureUnits.ItemsById[ds.FieldByName('VOLUME_MEASURE_UNIT_ID').AsInteger] as TMeasureUnit
      else
        o.MeasureUnit := nil;

      if Assigned(AllMainNirObligations) then
        o.MainObligation := AllMainNirObligations.ItemsById[ds.FieldByName('MAIN_OBLIGATION_ID').AsInteger] as TNIRObligation
      else
        o.MainObligation := nil;

      o.DateCondition :=  ds.FieldByName('VCH_DATE_CONDITION').AsString;
      o.FactCost := ds.FieldByName('NUM_NIR_FACT_COST').AsFloat;
      o.Volume := ds.FieldByName('NUM_VOLUME').AsFloat;
      o.ForFieldOnly := ds.FieldByName('NUM_FOR_FIELD_ONLY').AsInteger;

      ds.Next;
    end;
    end;
    ds.First;
  end;
end;

function TNIRDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TNIRObligation;
begin


  Assert(DataPostString <> '', 'Не задан приемник данных ' + ClassName);
  Result := 0;
  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    if not ds.Active then
      ds.Open;

    if ds.Locate(KeyFieldNames, varArrayOf([AObject.ID, TMainFacade.GetInstance.ActiveVersion.Id]), []) then
      ds.Edit
    else ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;

  o := AObject as TNIRObligation;

  ds.FieldByName('OBLIGATION_ID').Value := o.ID;
  ds.FieldByName('DTM_START_DATE').Value := o.StartDate;
  ds.FieldByName('DTM_FINISH_DATE').Value := o.FinishDate;
  ds.FieldByName('VCH_OBLIGATION_NAME').Value := Trim(o.Name); 
  ds.FieldByName('VCH_COMMENT').Value := o.Comment ;
  ds.FieldByName('VERSION_ID').Value :=  TMainFacade.GetInstance.ActiveVersion.Id;
  ds.FieldByName('LICENSE_ID').Value :=  o.Owner.ID;

  if Assigned(o.NirType) then
    ds.FieldByName('NIR_TYPE_ID').Value := o.NirType.ID
  else
    ds.FieldByName('NIR_TYPE_ID').Value := null;

  if Assigned(o.NIRState) then
    ds.FieldByName('NIR_FACT_STATE_ID').Value := o.NIRState.ID
  else
    ds.FieldByName('NIR_FACT_STATE_ID').Value := null;

  ds.FieldByName('VCH_DATE_CONDITION').Value := o.DateCondition;
  ds.FieldByName('NUM_NIR_FACT_COST').Value := o.FactCost;
  ds.FieldByName('NUM_VOLUME').Value  := o.Volume;
  ds.FieldByName('NUM_FOR_FIELD_ONLY').Value := o.ForFieldOnly;

   if Assigned(o.MainObligation) then
    ds.FieldByName('MAIN_OBLIGATION_ID').Value := o.MainObligation.Id
  else
    ds.FieldByName('MAIN_OBLIGATION_ID').Value := null;

   if Assigned(o.MeasureUnit)  then
    ds.FieldByName('VOLUME_MEASURE_UNIT_ID').Value := o.MeasureUnit.ID
  else
    ds.FieldByName('VOLUME_MEASURE_UNIT_ID').Value := null;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('OBLIGATION_ID').Value;

end;

{TNIRStateDataPoster}
constructor TNIRStateDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_NIR_STATE';
  DataDeletionString := 'TBL_NIR_STATE';
  DataPostString := 'TBL_NIR_STATE';

  KeyFieldNames := 'NIR_STATE_ID';
  FieldNames := 'NIR_STATE_ID, VCH_NOR_STATE_NAME';

  AccessoryFieldNames := 'NIR_STATE_ID, VCH_NOR_STATE_NAME';
  AutoFillDates := false;

  Sort := '';
end;

function TNIRStateDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TNIRStateDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TNIRState;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;
    if Assigned(AObjects) then
    begin
      while not ds.Eof do
      begin
        o := AObjects.Add as TNIRState;
        o.ID := ds.FieldByName('NIR_STATE_ID').AsInteger;
        o.Name := ds.FieldByName('VCH_NOR_STATE_NAME').AsString;
        ds.Next;
      end;
    end;

    ds.First;
  end;
end;

function TNIRStateDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TNIRState;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TNIRState;

  ds.FieldByName('NIR_STATE_ID').Value := o.ID;
  ds.FieldByName('VCH_NOR_STATE_NAME').Value := o.Name;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('NIR_STATE_ID').Value;

end;

{TNIRTypeDataPoster}
constructor TNIRTypeDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_NIR_TYPE_DICT';
  DataDeletionString := 'TBL_NIR_TYPE_DICT';
  DataPostString := 'TBL_NIR_TYPE_DICT';

  KeyFieldNames := 'NIR_TYPE_ID';
  FieldNames := 'NIR_TYPE_ID, VCH_NIR_TYPE, MAIN_NIR_TYPE_ID';

  AccessoryFieldNames := 'NIR_TYPE_ID, VCH_NIR_TYPE, MAIN_NIR_TYPE_ID';
  AutoFillDates := false;

  Sort := '';
end;

function TNIRTypeDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TNIRTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TNIRType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;
    if Assigned(AObjects) then
    begin
      while not ds.Eof do
      begin
        o := AObjects.Add as TNIRType;
        o.ID := ds.FieldByName('NIR_TYPE_ID').AsInteger;
        o.Name := ds.FieldByName('VCH_NIR_TYPE').AsString;
        if Assigned(FNIRTypes) then
          o.Main :=  FNIRTypes.ItemsByID[ds.FieldByName('MAIN_NIR_TYPE_ID').AsInteger] as TNIRType;
        ds.Next;
      end;
    end;
    ds.First;
  end;
end;

function TNIRTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TNIRType;
begin

  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TNIRType;

  ds.FieldByName('NIR_TYPE_ID').Value := o.ID;
  ds.FieldByName('VCH_NIR_TYPE').Value := o.Name;
  if Assigned(o.Main) then
    ds.FieldByName('MAIN_NIR_TYPE_ID').Value := o.Main.Id
  else
    ds.FieldByName('MAIN_NIR_TYPE_ID').Value := null;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('NIR_TYPE_ID').Value;

end;

{ TDrillDataPoster }

constructor TDrillingObligationDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_DRILLING_OBLIGATION_TMP';
  DataDeletionString := 'TBL_DRILLING_OBLIGATION_TMP';
  DataPostString := 'TBL_DRILLING_OBLIGATION_TMP';

  KeyFieldNames := 'OBLIGATION_ID; VERSION_ID';
  FieldNames := 'OBLIGATION_ID, LICENSE_ID, VERSION_ID,' +
                'DTM_DRILLING_START_DATE, DTM_DRILLING_FINISH_DATE,'+
                'WELL_STATE_ID, WELL_CATEGORY_ID, NUM_WELL_COUNT,' +
                'NUM_WELL_COUNT_IS_UNDEFINED, NUM_FACT_COST, VCH_COMMENT, NIR_STATE_ID';

  AccessoryFieldNames := 'OBLIGATION_ID, LICENSE_ID, VERSION_ID,' +
                'DTM_DRILLING_START_DATE, DTM_DRILLING_FINISH_DATE,'+
                'WELL_STATE_ID, WELL_CATEGORY_ID, NUM_WELL_COUNT,' +
                'NUM_WELL_COUNT_IS_UNDEFINED, NUM_FACT_COST, VCH_COMMENT, NIR_STATE_ID';
  AutoFillDates := false;

  Sort := 'DTM_DRILLING_FINISH_DATE';
end;

function TDrillingObligationDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
    Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TDrillingObligationDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TDrillObligation;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;
    if Assigned(AObjects) then
    begin

    while not ds.Eof do
    begin
      o := AObjects.Add as TDrillObligation;
      o.ID := ds.FieldByName('OBLIGATION_ID').AsInteger;
      o.StartDate := ds.FieldByName('DTM_DRILLING_START_DATE').AsDateTime;
      o.FinishDate := ds.FieldByName('DTM_DRILLING_FINISH_DATE').AsDateTime;
      o.Comment := ds.FieldByName('VCH_COMMENT').AsString;

      if Assigned(AllNirStates) then
        o.NIRState := AllNirStates.ItemsById[ds.FieldByName('NIR_STATE_ID').AsInteger] as TNIRState
      else
        o.NIRState := nil;

      if Assigned(AllWellStates) then
        o.WellState := AllWellStates.ItemsById[ds.FieldByName('WELL_STATE_ID').AsInteger] as TState
      else
        o.WellState := nil;

      if Assigned(AllWellCategories) then
         o.WellCategory := AllWellCategories.ItemsById[ds.FieldByName('WELL_CATEGORY_ID').AsInteger] as TWellCategory
      else
         o.WellCategory := nil;

      o.WellCount := ds.FieldByName('NUM_WELL_COUNT').AsInteger;
      o.WellCountIsUndefined := ds.FieldByName('NUM_WELL_COUNT_IS_UNDEFINED').AsInteger;
      o.FactCost := ds.FieldByName('NUM_FACT_COST').AsFloat;

      ds.Next;
    end;
     end;
    ds.First;
  end;

end;

function TDrillingObligationDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TDrillObligation;
begin

  Assert(DataPostString <> '', 'Не задан приемник данных ' + ClassName);
  Result := 0;
  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    if not ds.Active then
      ds.Open;

    if ds.Locate(KeyFieldNames, varArrayOf([AObject.ID, TMainFacade.GetInstance.ActiveVersion.Id]), []) then
      ds.Edit
    else ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;



  o := AObject as TDrillObligation;

  ds.FieldByName('OBLIGATION_ID').Value := o.ID;
  ds.FieldByName('DTM_DRILLING_START_DATE').Value := o.StartDate;
  ds.FieldByName('DTM_DRILLING_FINISH_DATE').Value := o.FinishDate;
  ds.FieldByName('VCH_COMMENT').Value := o.Comment;
  ds.FieldByName('VERSION_ID').Value := TMainFacade.GetInstance.ActiveVersion.Id;
  ds.FieldByName('LICENSE_ID').Value := o.Owner.ID;

   if Assigned(o.NIRState) then
     ds.FieldByName('NIR_STATE_ID').Value := o.NIRState.ID
   else
   ds.FieldByName('NIR_STATE_ID').Value := null;

  if Assigned(o.WellCategory) then
    ds.FieldByName('WELL_CATEGORY_ID').Value := o.WellCategory.Id
  else
    ds.FieldByName('WELL_CATEGORY_ID').Value := null;

  if Assigned(o.WellState) then
    ds.FieldByName('WELL_STATE_ID').Value := o.WellState.ID
  else
    ds.FieldByName('WELL_STATE_ID').Value := null;

  ds.FieldByName('NUM_WELL_COUNT').Value := o.WellCount;
  ds.FieldByName('NUM_WELL_COUNT_IS_UNDEFINED').Value := o.WellCountIsUndefined;
  ds.FieldByName('NUM_FACT_COST').Value := o.FactCost;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('OBLIGATION_ID').Value;


end;

{ TSeismicDataPoster }

constructor TSeismicObligationDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_SEISMIC_OBLIGATION_TMP';
  DataDeletionString := 'TBL_SEISMIC_OBLIGATION_TMP';
  DataPostString := 'TBL_SEISMIC_OBLIGATION_TMP';

  KeyFieldNames := 'OBLIGATION_ID; VERSION_ID';

  FieldNames := 'OBLIGATION_ID, LICENSE_ID, VERSION_ID,' +
                'DTM_START_DATE, DTM_FINISH_DATE, SEISWORK_TYPE_ID,' +
                'NUM_VOLUME, NUM_FACT_VOLUME, NUM_COST, VCH_COMMENT,' +
                'NUM_VOLUME_IN_GRR_PROGRAM, NIR_STATE_ID';

  AccessoryFieldNames := 'OBLIGATION_ID, LICENSE_ID, VERSION_ID,' +
                'DTM_START_DATE, DTM_FINISH_DATE, SEISWORK_TYPE_ID,' +
                'NUM_VOLUME, NUM_FACT_VOLUME, NUM_COST, VCH_COMMENT,' +
                'NUM_VOLUME_IN_GRR_PROGRAM, NIR_STATE_ID';

  AutoFillDates := false;

  Sort := 'DTM_FINISH_DATE, DTM_START_DATE';
end;

function TSeismicObligationDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TSeismicObligationDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TSeismicObligation;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;
    if Assigned(AObjects) then
    begin
    while not ds.Eof do
    begin
      o := AObjects.Add as TSeismicObligation;
      o.ID := ds.FieldByName('OBLIGATION_ID').AsInteger;
      o.StartDate := ds.FieldByName('DTM_START_DATE').AsDateTime;
      o.FinishDate := ds.FieldByName('DTM_FINISH_DATE').AsDateTime;
      o.Comment := ds.FieldByName('VCH_COMMENT').AsString;

      
      if Assigned(AllNirStates) then
        o.NIRState := AllNirStates.ItemsById[ds.FieldByName('NIR_STATE_ID').AsInteger] as TNIRState
      else
        o.NIRState := nil;

      if Assigned(AllSeismWorkTypes) then
        o.SeisWorkType := AllSeismWorkTypes.ItemsById[ds.FieldByName('SEISWORK_TYPE_ID').AsInteger] as TSeismWorkType
      else
        o.SeisWorkType := nil;

      o.Volume := ds.FieldByName('NUM_VOLUME').AsFloat;
      o.VolumeInGRRProgram := ds.FieldByName('NUM_VOLUME_IN_GRR_PROGRAM').AsFloat > 0;
      o.FactVolume := ds.FieldByName('NUM_FACT_VOLUME').AsFloat;
      o.Cost := ds.FieldByName('NUM_COST').AsFloat;

      ds.Next;
    end;
    end;
    ds.First;
  end;
end;

function TSeismicObligationDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TSeismicObligation;
begin

  Assert(DataPostString <> '', 'Не задан приемник данных ' + ClassName);
  Result := 0;
  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    if not ds.Active then
      ds.Open;

    if ds.Locate(KeyFieldNames, varArrayOf([AObject.ID, TMainFacade.GetInstance.ActiveVersion.Id]), []) then
      ds.Edit
    else ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;


  o := AObject as TSeismicObligation;


  ds.FieldByName('OBLIGATION_ID').Value := o.ID;
  ds.FieldByName('DTM_START_DATE').Value := o.StartDate;
  ds.FieldByName('DTM_FINISH_DATE').Value := o.FinishDate;
  ds.FieldByName('VCH_COMMENT').Value := o.Comment;
  ds.FieldByName('VERSION_ID').Value := TMainFacade.GetInstance.ActiveVersion.Id;
  ds.FieldByName('LICENSE_ID').Value := o.Owner.ID;

  if Assigned(o.NIRState) then
     ds.FieldByName('NIR_STATE_ID').Value := o.NIRState.ID
   else
   ds.FieldByName('NIR_STATE_ID').Value := null;

  if Assigned(o.SeisWorkType) then
    ds.FieldByName('SEISWORK_TYPE_ID').Value := o.SeisWorkType.ID
  else
    ds.FieldByName('SEISWORK_TYPE_ID').Value := null;

  ds.FieldByName('NUM_VOLUME').Value := o.Volume;
  ds.FieldByName('NUM_VOLUME_IN_GRR_PROGRAM').Value := Ord(o.VolumeInGRRProgram);
  ds.FieldByName('NUM_FACT_VOLUME').Value := o.FactVolume;
  ds.FieldByName('NUM_COST').Value := o.Cost;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('OBLIGATION_ID').Value;

end;


{ TNirObligationPlaceDataPoster }

constructor TNirObligationPlaceDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_NIR_OBLIGATION_PLACE';
  DataDeletionString := 'TBL_NIR_OBLIGATION_PLACE';
  DataPostString := 'TBL_NIR_OBLIGATION_PLACE';

  KeyFieldNames := 'NIR_OBLIGATION_PLACE_ID';
  FieldNames := 'NIR_OBLIGATION_PLACE_ID, OBLIGATION_ID, VERSION_ID, ' +
                'STRUCTURE_ID' ;


  AccessoryFieldNames := 'NIR_OBLIGATION_PLACE_ID, OBLIGATION_ID,' +
                        'VERSION_ID, STRUCTURE_ID' ;

  AutoFillDates := false;

  Sort := '';
end;

function TNirObligationPlaceDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
    Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TNirObligationPlaceDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TNirObligationPlace;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;
    if Assigned(AObjects) then
    begin
    while not ds.Eof do
    begin
      o := AObjects.Add as TNirObligationPlace;
      o.ID := ds.FieldByName('NIR_OBLIGATION_PLACE_ID').AsInteger;

       if Assigned(AllStructures) then
        o.Structure := AllStructures.ItemsById[ds.FieldByName('STRUCTURE_ID').AsInteger] as TStructure
      else
        o.Structure := nil;

      ds.Next;
    end;
    end;
    ds.First;
  end;
end;

function TNirObligationPlaceDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TNirObligationPlace;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TNirObligationPlace;

  ds.FieldByName('NIR_OBLIGATION_PLACE_ID').Value := o.ID;
  ds.FieldByName('OBLIGATION_ID').Value := o.Owner.ID;
  ds.FieldByName('VERSION_ID').Value := TMainFacade.GetInstance.ActiveVersion.Id;
  ds.FieldByName('STRUCTURE_ID').Value := o.Structure.ID;

  ds.Post;

  if o.ID = 0 then
     o.ID := ds.FieldByName('NIR_OBLIGATION_PLACE_ID').Value;
end;

{ TSeismicObligationPlaceDataPoster }

constructor TSeismicObligationPlaceDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_SEISMIC_OBLIGATION_PLACE';
  DataDeletionString := 'TBL_SEISMIC_OBLIGATION_PLACE';
  DataPostString := 'TBL_SEISMIC_OBLIGATION_PLACE';

  KeyFieldNames := 'SEISMIC_OBLIGATION_PLACE_ID';
  FieldNames := 'SEISMIC_OBLIGATION_PLACE_ID, OBLIGATION_ID,' +
               'VERSION_ID, AREA_ID, STRUCTURE_ID';

  AccessoryFieldNames := 'SEISMIC_OBLIGATION_PLACE_ID, OBLIGATION_ID,' +
                        'VERSION_ID, AREA_ID, STRUCTURE_ID';

  AutoFillDates := false;

  Sort := '';
end;

function TSeismicObligationPlaceDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TSeismicObligationPlaceDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TSeismicObligationPlace;
begin
  
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;
    if Assigned(AObjects) then
    begin
    while not ds.Eof do
    begin
      o := AObjects.Add as TSeismicObligationPlace;
      o.ID := ds.FieldByName('SEISMIC_OBLIGATION_PLACE_ID').AsInteger;


      if Assigned(AllStructures) then
        o.Structure := AllStructures.ItemsById[ds.FieldByName('STRUCTURE_ID').AsInteger] as TStructure
      else
        o.Structure := nil;

      if Assigned(AllAreas) then
        o.Area  := AllAreas.ItemsById[ds.FieldByName('AREA_ID').AsInteger] as TSimpleArea
      else
        o.Area := nil;

      ds.Next;
    end;
    end;
    ds.First;
  end;
end;

function TSeismicObligationPlaceDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TSeismicObligationPlace;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TSeismicObligationPlace;

  ds.FieldByName('SEISMIC_OBLIGATION_PLACE_ID').Value := o.ID;
  ds.FieldByName('OBLIGATION_ID').Value := o.Owner.ID;
  ds.FieldByName('VERSION_ID').Value := TMainFacade.GetInstance.ActiveVersion.Id;
  ds.FieldByName('STRUCTURE_ID').Value := o.Structure.ID;
  ds.FieldByName('AREA_ID').Value := o.Area.ID;

  ds.Post;

  if o.ID = 0 then
     o.ID := ds.FieldByName('SEISMIC_OBLIGATION_PLACE_ID').Value;
end;

{ TDrillingObligationWellDataPoster }

constructor TDrillingObligationWellDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_DRILL_OBLIGATION_WELL_TMP';
  DataDeletionString := 'TBL_DRILL_OBLIGATION_WELL_TMP';
  DataPostString := 'TBL_DRILL_OBLIGATION_WELL_TMP';

  KeyFieldNames := 'OBLIGATION_WELL_ID';
  FieldNames := 'OBLIGATION_WELL_ID, OBLIGATION_ID, WELL_UIN,' +
               'VERSION_ID, NIR_STATE_ID, STRUCTURE_ID,' +
               'NUM_DRILLING_RATE, NUM_FACT_COST, VCH_DRILLING_COMMENT';

  AccessoryFieldNames := 'OBLIGATION_WELL_ID, OBLIGATION_ID, WELL_UIN,' +
                         'VERSION_ID, NIR_STATE_ID, STRUCTURE_ID,' +
                         'NUM_DRILLING_RATE, NUM_FACT_COST, VCH_DRILLING_COMMENT';

  AutoFillDates := false;

  Sort := '';
end;

function TDrillingObligationWellDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TDrillingObligationWellDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TDrillingObligationWell;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;
    if Assigned(AObjects) then
    begin
    while not ds.Eof do
    begin
      o := AObjects.Add as TDrillingObligationWell;
      o.ID := ds.FieldByName('OBLIGATION_WELL_ID').AsInteger;

       if Assigned(AllStructures) then
        o.Structure := AllStructures.ItemsById[ds.FieldByName('STRUCTURE_ID').AsInteger] as TStructure
      else
        o.Structure := nil;

      if Assigned(AllWells) then
        o.Well := AllWells.ItemsById[ds.FieldByName('WELL_UIN').AsInteger] as TWell
       else
        o.Well := nil;
        
      if Assigned(AllNirStates) then
        o.NirState := AllNirStates.ItemsById[ds.FieldByName('NIR_STATE_ID').AsInteger] as TNIRState
      else
        o.NirState :=  nil;

      o.DrillingRate := ds.FieldByName('NUM_DRILLING_RATE').AsFloat;
      o.FactCost := ds.FieldByName('NUM_FACT_COST').AsFloat;
      o.DrillingComment := ds.FieldByName('VCH_DRILLING_COMMENT').AsString;
      ds.Next;
    end;
    end;
    ds.First;
  end;
end;
function TDrillingObligationWellDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TDrillingObligationWell;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TDrillingObligationWell;

  ds.FieldByName('OBLIGATION_WELL_ID').Value := o.ID;
  ds.FieldByName('OBLIGATION_ID').Value := o.Owner.ID;
  ds.FieldByName('VERSION_ID').Value := TMainFacade.GetInstance.ActiveVersion.Id;
  ds.FieldByName('STRUCTURE_ID').Value := o.Structure.ID;
  ds.FieldByName('WELL_UIN').Value := o.Well.ID;
  ds.FieldByName('NIR_STATE_ID').Value := o.NirState.ID;
  ds.FieldByName('NUM_DRILLING_RATE').Value := o.DrillingRate;
  ds.FieldByName('NUM_FACT_COST').Value := o.FactCost;
  ds.FieldByName('VCH_DRILLING_COMMENT').Value := o.DrillingComment;

  ds.Post;

  if o.ID = 0 then
     o.ID := ds.FieldByName('OBLIGATION_WELL_ID').Value;
end;

{ TBaseObligationDataPoster }

constructor TBaseObligationDataPoster.Create;
begin
  inherited;
  KeyFieldNames := 'OBLIGATION_ID; VERSION_ID';
end;

function TBaseObligationDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TCommonServerDataSet;
begin
  Assert(DataDeletionString <> '', 'Не задан приемник данных ' + ClassName);
  Result := 0;
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  try
    // находим строку соответствующую ключу
    //ds.Refresh;
    ds.First;
    if ds.Locate(ds.KeyFieldNames, VarArrayOf([AObject.ID, TMainFacade.GetInstance.ActiveVersion.ID ]), []) then
      ds.Delete
  except
    Result := -1;
  end;
end;

end.
