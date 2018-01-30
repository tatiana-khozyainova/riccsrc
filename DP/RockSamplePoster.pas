unit RockSamplePoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, RockSample, Windows, Lithology;

type
  TRockSampleTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TRockSampleSizeTypePoster = class(TImplementedDataPoster)
  private
    FAllSampleTypes: TRockSampleTypes;
  public
    property AllSampleTypes: TRockSampleTypes read FAllSampleTypes write FAllSampleTypes;
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;override;

    constructor Create; override;
  end;

  TRockSampleSizeTypePresencePoster = class(TImplementedDataPoster)
  private
    FAllSampleSizeTypes: TRockSampleSizeTypes;
  public
    property AllSampleSizeTypes: TRockSampleSizeTypes read FAllSampleSizeTypes write FAllSampleSizeTypes;
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;override;

    constructor Create; override;
  end;

  TRockSampleDataPoster = class(TImplementedDataPoster)
  private
    FAllLithologies: TLithologies;
    procedure SetAllLithologies(const Value: TLithologies);
  public
    property AllLithologies: TLithologies read FAllLithologies write SetAllLithologies;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;override;

    constructor Create; override;
  end;

implementation

uses Facade, BaseFacades, SysUtils, Variants;

{ TRockSimpleDataPoster }

constructor TRockSampleDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'tbl_rock_sample';//'SPD_GET_ROCK_SAMPLES_BY_LAYER';
  //DataPostString := 'SPD_ADD_ROCK_SAMPLE';
  //DataDeletionString := '';

  KeyFieldNames := 'ROCK_SAMPLE_UIN';
  FieldNames := 'SLOTTING_UIN, ROCK_SAMPLE_UIN, VCH_GENERAL_NUMBER, NUM_FROM_SLOTTING_TOP,' +
                'ROCK_ID, NUM_SAMPLE_CHECKED, MODIFIER_ID, MODIFIER_CLIENT_APP_TYPE_ID';

  AccessoryFieldNames := 'SLOTTING_UIN, ROCK_SAMPLE_UIN, VCH_GENERAL_NUMBER, NUM_FROM_SLOTTING_TOP,' +
                         'ROCK_ID, NUM_SAMPLE_CHECKED, MODIFIER_ID, MODIFIER_CLIENT_APP_TYPE_ID';
  AutoFillDates := false;

  Sort := '';
end;

function TRockSampleDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TRockSampleDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o : TRockSample;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TRockSample;

      o.ID := ds.FieldByName('ROCK_SAMPLE_UIN').AsInteger;     
      o.Name := trim(ds.FieldByName('VCH_GENERAL_NUMBER').AsString);
      o.FromBegining := ds.FieldByName('NUM_FROM_SLOTTING_TOP').AsFloat;
      if Assigned(AllLithologies) then
        o.Lithology := AllLithologies.ItemsByID[ds.FieldByName('ROCK_ID').AsInteger] as TLithology;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TRockSampleDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TRockSample;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TRockSample;

  ds.FieldByName('SLOTTING_UIN').AsInteger := o.Owner.Collection.Owner.ID;
  ds.FieldByName('ROCK_SAMPLE_UIN').AsInteger := o.ID;
  ds.FieldByName('VCH_GENERAL_NUMBER').AsString := trim (o.Name);
  ds.FieldByName('NUM_FROM_SLOTTING_TOP').AsFloat := o.FromBegining;
  if Assigned (o.Lithology) then ds.FieldByName('ROCK_ID').AsInteger := o.Lithology.ID
  else ds.FieldByName('ROCK_ID').AsInteger := 0;
  ds.FieldByName('NUM_SAMPLE_CHECKED').AsInteger := 0;
  ds.FieldByName('MODIFIER_ID').AsInteger := TMainFacade.GetInstance.DBGates.EmployeeID;
  ds.FieldByName('MODIFIER_CLIENT_APP_TYPE_ID').AsInteger := TMainFacade.GetInstance.DBGates.ClientAppTypeID;

  ds.Post;

  o.ID := ds.FieldByName('ROCK_SAMPLE_UIN').Value;
end;

procedure TRockSampleDataPoster.SetAllLithologies(
  const Value: TLithologies);
begin
  if FAllLithologies <> Value then
    FAllLithologies := Value;
end;

{ TRockSampleSizeTypePoster }

constructor TRockSampleSizeTypePoster.Create;
begin
  inherited;

  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_SAMPLE_TYPE';

  KeyFieldNames := 'Sample_Type_ID';
  FieldNames := 'Sample_Type_ID, DNR_Sample_Type_Id, vch_Sample_Type_Name, num_Diameter, num_X_Size, num_Y_Size, num_Z_Size, vch_Sample_Type_Short_Name, num_Order';
  AccessoryFieldNames := 'Sample_Type_ID, DNR_Sample_Type_Id, vch_Sample_Type_Name, num_Diameter, num_X_Size, num_Y_Size, num_Z_Size, vch_Sample_Type_Short_Name, num_Order';
  AutoFillDates := false;

  Sort := 'num_Order';
end;

function TRockSampleSizeTypePoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TRockSampleSizeTypePoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    rst: TRockSampleSizeType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      rst := AObjects.Add as TRockSampleSizeType;

      rst.ID := ds.FieldByName('Sample_Type_ID').AsInteger;
      rst.RockSampleType := AllSampleTypes.ItemsById[ds.FieldByName('DNR_Sample_Type_Id').AsInteger] as TRockSampleType;
      rst.Name := trim(ds.FieldByName('vch_Sample_Type_Name').AsString);
      rst.ShortName := trim(ds.FieldByName('vch_Sample_Type_Short_Name').AsString);
      rst.Diameter := ds.FieldByName('num_Diameter').AsFloat;
      rst.XSize := ds.FieldByName('num_X_Size').AsFloat;
      rst.YSize := ds.FieldByName('num_Y_Size').AsFloat;
      rst.ZSize := ds.FieldByName('num_Z_Size').AsFloat;
      rst.Order := ds.FieldByName('num_Order').AsInteger;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TRockSampleSizeTypePoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    rst: TRockSampleSizeType;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  rst := AObject as TRockSampleSizeType;

  ds.FieldByName('Sample_Type_ID').AsInteger := rst.ID;
  ds.FieldByName('DNR_Sample_Type_Id').AsInteger := rst.RockSampleType.ID;
  ds.FieldByName('vch_Sample_Type_Name').AsString := rst.Name;
  ds.FieldByName('vch_Sample_Type_Short_Name').AsString := rst.ShortName;
  ds.FieldByName('num_Diameter').AsFloat := rst.Diameter;
  ds.FieldByName('num_X_Size').AsFloat := rst.XSize;
  ds.FieldByName('num_Y_Size').AsFloat := rst.YSize;
  ds.FieldByName('num_Z_Size').AsFloat := rst.ZSize;
  ds.FieldByName('num_Order').AsInteger := rst.Order;

  ds.Post;

  if rst.ID = 0 then
    rst.ID := ds.FieldByName('Sample_Type_ID').AsInteger;
end;

{ TRockSampleTypeDataPoster }

constructor TRockSampleTypeDataPoster.Create;
begin
  inherited;

  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'tbl_DNR_Sample_Type_dict';

  KeyFieldNames := 'DNR_Sample_Type_Id';
  FieldNames := 'DNR_Sample_Type_Id, vch_DNR_Sample_Type';
  AccessoryFieldNames := 'DNR_Sample_Type_Id, vch_DNR_Sample_Type';
  AutoFillDates := false;

  Sort := 'vch_DNR_Sample_Type';
end;

function TRockSampleTypeDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TRockSampleTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    rst: TRockSampleType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      rst := AObjects.Add as TRockSampleType;

      rst.ID := ds.FieldByName('DNR_Sample_Type_Id').AsInteger;
      rst.Name := trim(ds.FieldByName('vch_DNR_Sample_Type').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TRockSampleTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    rst: TRockSampleType;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  rst := AObject as TRockSampleType;

  rst.ID := ds.FieldByName('DNR_Sample_Type_Id').AsInteger;
  rst.Name := trim(ds.FieldByName('vch_DNR_Sample_Type').AsString);

  ds.Post;

  if rst.ID = 0 then
    rst.ID := ds.FieldByName('DNR_Sample_Type_Id').AsInteger;
end;

{ TRockSampleSizeTypePresencePoster }

constructor TRockSampleSizeTypePresencePoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_SLOTTING_SAMPLE_TYPE';

  KeyFieldNames := 'SAMPLE_TYPE_ID; SLOTTING_UIN';
  FieldNames := 'SAMPLE_TYPE_ID, SLOTTING_UIN, NUM_COUNT';

  AccessoryFieldNames := 'SAMPLE_TYPE_ID, SLOTTING_UIN, NUM_COUNT';
  AutoFillDates := false;

  Sort := '';
end;

function TRockSampleSizeTypePresencePoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
var ds: TCommonServerDataSet;
begin
  Result := 0;
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  try
    // находим строку соответствующую ключу
    ds.First;
    if ds.Locate(ds.KeyFieldNames, varArrayOf([AObject.ID, AObject.Collection.Owner.ID]), []) then
      ds.Delete
  except
    Result := -1;
  end;
end;

function TRockSampleSizeTypePresencePoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var rstp: TRockSampleSizeTypePresence;
    ds: TDataSet;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      rstp := AObjects.Add as TRockSampleSizeTypePresence;
      rstp.RockSampleSizeType := AllSampleSizeTypes.ItemsById[ds.FieldByName('Sample_Type_ID').AsInteger] as TRockSampleSizeType;
      rstp.ID := rstp.RockSampleSizeType.ID;
      rstp.Count := ds.FieldByName('num_Count').AsInteger;
      ds.Next;
    end;

    ds.First;
  end;
end;

function TRockSampleSizeTypePresencePoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    rstp: TRockSampleSizeTypePresence;
begin
  Result := 0;
  rstp := AObject as TRockSampleSizeTypePresence;
  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    if not ds.Active then
      ds.Open;
    if ds.Locate(KeyFieldNames, varArrayOf([AObject.ID, rstp.Collection.Owner.ID]), []) then
      ds.Edit
    else ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;

  ds.FieldByName('Sample_Type_ID').AsInteger := rstp.RockSampleSizeType.ID;
  ds.FieldByName('Slotting_UIN').AsInteger := (rstp.Collection as TRockSampleSizeTypePresences).Owner.ID;
  ds.FieldByName('num_Count').AsInteger := rstp.Count;

  ds.Post;
end;

end.
