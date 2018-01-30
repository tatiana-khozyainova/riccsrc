unit CoreCollectionPoster;

interface


uses PersistentObjects, DBGate, BaseObjects, DB, CoreCollection,
     Employee, Straton, WellPoster, Well;

type
  TFossilTypePoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TCollectionTypePoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;


  TCoreCollectionPoster = class(TImplementedDataPoster)
  private
    FCollectionTypes: TCoreCollectionTypes;
    FFossilTypes: TFossilTypes;
    FEmployees: TEmployees;
    FStratons: TSimpleStratons;
  public
    // все типы органических остатков
    property AllFossilTypes: TFossilTypes read FFossilTypes write FFossilTypes;
    // все типы коллекций
    property AllCollectionTypes: TCoreCollectionTypes read FCollectionTypes write FCollectionTypes;
    // все сотрудники
    property AllEmployees: TEmployees read FEmployees write FEmployees;
    // все стратоны
    property AllStratons: TSimpleStratons read FStratons write FStratons;
    // операции взаимодействия с БД
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    // конструктор
    constructor Create; override;
  end;

  TCollectionWellPoster = class(TWellDataPoster)
  protected
    procedure InternalInitWell(AWell: TWell); override;
  end;

  TCollectionSamplePoster = class(TImplementedDataPoster)
  private
    FAllStratons: TSimpleStratons;
    FAllSampleTypes: TCollectionSampleTypes;
  public
    // все стратподразделения
    property AllStratons: TSimpleStratons read FAllStratons write FAllStratons;
    // все типы образцов
    property AllSampleTypes: TCollectionSampleTypes read FAllSampleTypes write FAllSampleTypes;
    // операции взаимодействия с БД
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;


  TCollectionSampleTypePoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TDenudationDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TWellCandidateDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses Facade, SysUtils, Variants;

{ TCoreCollectionPoster }

constructor TCoreCollectionPoster.Create;
begin
  inherited;
  // опции шлюза данных
  // soSingleDataSource - вся работа производится с помощью одной таблицы TBL_COLLECTION
  // есть возможность настроить так, чтобы, например, запись производилась через одну хранимую процедуру,
  // удаление - через другую, а чтение - с помощью представления
  // soKeyInsert - сервер приложений должен использовать стандартный метод вставки с привлечением объекта генератора
  // soGetKeyValue - после вставки данных необходимо получить ключ
  Options := [soSingleDataSource, soGetKeyValue];
  // источник-приемник данных
  DataSourceString := 'TBL_COLLECTION';
  // ключ
  KeyFieldNames := 'COLLECTION_ID';

  // поля - для заполнения свойств
  FieldNames := 'Collection_ID, Fossil_Type_ID, Author_ID, Owner_ID, ' +
                'Collection_Type_ID, vch_Collection_Name, vch_Owner_Name, ' +
                'vch_Author_Name, Base_Straton_ID, Top_Straton_ID';
  AccessoryFieldNames := FieldNames;

  AutoFillDates := false;
  // поле, определяющее порядок сортировки
  Sort := 'VCH_COLLECTION_NAME';
end;

function TCoreCollectionPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TCoreCollectionPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TCoreCollection;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TCoreCollection;

      o.ID := ds.FieldByName('COLLECTION_ID').AsInteger;
      o.Name := trim(ds.FieldByName('vch_Collection_Name').AsString);

      if Assigned(AllFossilTypes) then
        o.FossilType := AllFossilTypes.ItemsByID[ds.FieldByName('Fossil_Type_ID').AsInteger] as TFossilType;

      if Assigned(o.CoreCollectionType) then
        o.CoreCollectionType := AllCollectionTypes.ItemsByID[ds.FieldByName('Collection_Type_ID').AsInteger] as TCoreCollectionType;

      o.OwnerName := ds.FieldByName('vch_Owner_Name').AsString;
      o.AuthorName := ds.FieldByName('vch_Author_Name').AsString;

      if Assigned(o.OwnerEmp) then
        o.OwnerEmp :=  AllEmployees.ItemsByID[ds.FieldByName('Owner_ID').AsInteger] as TEmployee;

      if Assigned(o.AuthorEmp) then
        o.AuthorEmp := AllEmployees.ItemsByID[ds.FieldByName('Author_ID').AsInteger] as TEmployee;

      if Assigned(AllStratons) then
      begin
        o.TopStraton := AllStratons.ItemsByID[ds.FieldByName('Top_Straton_ID').AsInteger] as TSimpleStraton;
        o.BaseStraton := AllStratons.ItemsByID[ds.FieldByName('Base_Straton_ID').AsInteger] as TSimpleStraton;
      end;  
      ds.Next;
    end;

    ds.First;
  end;
end;

function TCoreCollectionPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TCoreCollection;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TCoreCollection;

  ds.FieldByName('COLLECTION_ID').AsInteger := o.ID;
  ds.FieldByName('vch_Collection_Name').AsString := o.Name;

  if Assigned(o.FossilType) then
    ds.FieldByName('Fossil_Type_ID').AsInteger := o.FossilType.ID;

  if Assigned(o.CoreCollectionType) then
    ds.FieldByName('Collection_Type_ID').AsInteger := o.CoreCollectionType.ID;

  ds.FieldByName('vch_Owner_Name').AsString := o.OwnerName;
  ds.FieldByName('vch_Author_Name').AsString := o.AuthorName;

  if Assigned(o.OwnerEmp) then
  begin
    ds.FieldByName('Owner_ID').AsInteger := o.OwnerEmp.ID;
    ds.FieldByName('vch_Owner_Name').AsString := o.OwnerEmp.List(loBrief);
  end;

  if Assigned(o.AuthorEmp) then
  begin
    ds.FieldByName('Author_ID').AsInteger := o.AuthorEmp.ID;
    ds.FieldByName('vch_Author_Name').AsString := o.AuthorEmp.List(loBrief);
  end;

  if Assigned(o.TopStraton)  then
    ds.FieldByName('Top_Straton_ID').AsInteger := o.TopStraton.ID;
  if Assigned(o.BaseStraton) then
    ds.FieldByName('Base_Straton_ID').AsInteger := o.BaseStraton.ID;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('COLLECTION_ID').Value;

end;

{ TFossilTypePoster }

constructor TFossilTypePoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soKeyInsert, soGetKeyValue];
  DataSourceString := 'TBL_FOSSIL_TYPE_DICT';


  KeyFieldNames := 'FOSSIL_TYPE_ID';


  FieldNames := 'Fossil_Type_ID, VCH_FOSSIL_TYPE_NAME';

  AccessoryFieldNames := FieldNames;
  AutoFillDates := false;

  Sort := 'VCH_FOSSIL_TYPE_NAME';
end;

function TFossilTypePoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TFossilTypePoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TFossilType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TFossilType;

      o.ID := ds.FieldByName('FOSSIL_TYPE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_FOSSIL_TYPE_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TFossilTypePoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TFossilType;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TFossilType;

  ds.FieldByName('FOSSIL_TYPE_ID').AsInteger := o.ID;
  ds.FieldByName('vch_Fossil_Type_Name').AsString := o.Name;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('FOSSIL_TYPE_ID').Value;
end;

{ TCollectionTypePoster }

constructor TCollectionTypePoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soKeyInsert, soGetKeyValue];
  DataSourceString := 'TBL_COLLECTION_TYPE_DICT';


  KeyFieldNames := 'COLLECTION_TYPE_ID';


  FieldNames := 'COLLECTION_TYPE_ID, VCH_COLLECTION_TYPE_NAME';

  AccessoryFieldNames := FieldNames;
  AutoFillDates := false;

  Sort := 'VCH_COLLECTION_TYPE_NAME';
end;

function TCollectionTypePoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TCollectionTypePoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TCoreCollectionType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TCoreCollectionType;

      o.ID := ds.FieldByName('COLLECTION_TYPE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_COLLECTION_TYPE_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TCollectionTypePoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TCoreCollectionType;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TCoreCollectionType;

  ds.FieldByName('COLLECTION_TYPE_ID').AsInteger := o.ID;
  ds.FieldByName('VCH_COLLECTION_TYPE_NAME').AsString := o.Name;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('COLLECTION_TYPE_ID').Value;
end;

{ TCollectionWellPoster }

procedure TCollectionWellPoster.InternalInitWell(AWell: TWell);
var ds: TDataSet;
begin
  inherited;
  ds := TMainFacade.GetInstance.DBGates.Add(Self);
  (AWell as TCollectionWell).IsSamplesPresent := ds.FieldByName('COLLECTION_SAMPLE_COUNT').AsInteger > 0;
end;

{ TCollectionSamplePoster }

constructor TCollectionSamplePoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soKeyInsert, soGetKeyValue];
  // источник-приемник данных
  DataSourceString := 'TBL_COLLECTION_SAMPLE';
  // ключ
  KeyFieldNames := 'COLLECTION_SAMPLE_ID';

  // поля - для заполнения свойств
  FieldNames := 'COLLECTION_SAMPLE_ID, WELL_UIN, WELL_CANDIDATE_UIN, DENUDATION_ID, COLLECTION_ID, ' +
                'COLLECTION_SAMPLE_TYPE_ID, NUM_INTERVAL_TOP, NUM_INTERVAL_BOTTOM, NUM_FROM_TOP, NUM_FROM_BOTTOM, ' +
                'VCH_DEPTH_COMMENT, VCH_SLOTTING_NUMBER, VCH_SAMPLE_NUMBER, VCH_LAB_NUMBER, NUM_IS_DEFINED, ' +
                'VCH_COMMENT, DTM_TAKING_DATE, STRATON_ID, ROOM_ID, VCH_BOX, VCH_PLACE_COMMENT, ' +
                'NUM_ABSOLUTE_DEPTH, VCH_ADDITIONAL_NUM, TOP_STRATON_ID,  NUM_IS_DEFINED, NUM_IS_STRATON_VERIFIED, ' + 
                'DTM_ENTERING_DATE';
  AccessoryFieldNames := FieldNames;

  AutoFillDates := false;
  // поле, определяющее порядок сортировки
  Sort := 'NUM_INTERVAL_TOP, NUM_FROM_TOP';
end;

function TCollectionSamplePoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection)
end;

function TCollectionSamplePoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TCollectionSample;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if Assigned(AObjects) then
  begin
    if not ds.Eof then
    begin
      ds.First;

      while not ds.Eof do
      begin
        o := AObjects.Add as TCollectionSample;

        o.ID := ds.FieldByName('COLLECTION_SAMPLE_ID').AsInteger;
        o.Name := trim(ds.FieldByName('VCH_SAMPLE_NUMBER').AsString);
        o.SampleNumber := trim(ds.FieldByName('VCH_SAMPLE_NUMBER').AsString);
        o.Comment := trim(ds.FieldByName('VCH_COMMENT').AsString);
        o.BindingComment := trim(ds.FieldByName('VCH_DEPTH_COMMENT').AsString);
        o.DepthFromTop := ds.FieldByName('NUM_FROM_TOP').AsFloat;
        o.DepthFromBottom := ds.FieldByName('NUM_FROM_BOTTOM').AsFloat;
        o.AbsoluteDepth := ds.FieldByName('NUM_ABSOLUTE_DEPTH').AsFloat;
        o.SlottingNumber := Trim(ds.FieldByName('VCH_SLOTTING_NUMBER').AsString);
        o.AdditionalNumber := trim(ds.FieldByName('VCH_ADDITIONAL_NUM').AsString);
        o.LabNumber := trim(ds.FieldByName('VCH_LAB_NUMBER').AsString);
        o.IsDescripted := (ds.FieldByName('NUM_IS_DEFINED').AsInteger > 0);
        o.IsElectroDescription := (ds.FieldByName('NUM_IS_EDEFINED').AsInteger > 0);
        o.EnteringDate := ds.FieldByName('DTM_ENTERING_DATE').AsDateTime;
        o.SamplingDate := ds.FieldByName('DTM_TAKING_DATE').AsDateTime;
        o.TopStraton := AllStratons.ItemsById[ds.FieldByName('TOP_STRATON_ID').AsInteger] as TSimpleStraton;
        o.BottomStraton := AllStratons.ItemsById[ds.FieldByName('STRATON_ID').AsInteger] as TSimpleStraton;
        o.IsStratChecked := (ds.FieldByName('NUM_IS_STRATON_VERIFIED').AsInteger > 0);
        o.RoomNum := ds.FieldByName('ROOM_ID').AsInteger;
        o.BoxNumber := trim(ds.FieldByName('VCH_BOX').AsString);
        o.PlacingComment := trim(ds.FieldByName('VCH_PLACE_COMMENT').AsString);
        o.Top := ds.FieldByName('NUM_INTERVAL_TOP').AsFloat;
        o.Bottom := ds.FieldByName('NUM_INTERVAL_BOTTOM').AsFloat;
        o.SampleType := AllSampleTypes.ItemsByID[ds.FieldByName('COLLECTION_SAMPLE_TYPE_ID').AsInteger] as TCollectionSampleType;

        ds.Next;
      end;

      ds.First;
    end;
  end;
end;

function TCollectionSamplePoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TCollectionSample;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TCollectionSample;

  ds.FieldByName('COLLECTION_SAMPLE_ID').AsInteger := o.ID;
  ds.FieldByName('VCH_SAMPLE_NUMBER').AsString := trim(o.SampleNumber);
  ds.FieldByName('VCH_COMMENT').AsString := trim(o.Comment);
  ds.FieldByName('VCH_DEPTH_COMMENT').AsString := trim(o.BindingComment);
  ds.FieldByName('NUM_FROM_TOP').AsFloat := o.DepthFromTop;
  ds.FieldByName('NUM_FROM_BOTTOM').AsFloat := o.DepthFromBottom;
  ds.FieldByName('NUM_ABSOLUTE_DEPTH').AsFloat := o.AbsoluteDepth;
  ds.FieldByName('VCH_SLOTTING_NUMBER').AsString := Trim(o.SlottingNumber);
  ds.FieldByName('VCH_ADDITIONAL_NUM').AsString := trim(o.AdditionalNumber);
  ds.FieldByName('VCH_LAB_NUMBER').AsString := trim(o.LabNumber);
  ds.FieldByName('NUM_IS_DEFINED').AsInteger := ord(o.IsDescripted);
  ds.FieldByName('NUM_IS_EDEFINED').AsInteger := Ord(o.IsElectroDescription);
  ds.FieldByName('DTM_TAKING_DATE').AsDateTime := o.SamplingDate;

  if Assigned(o.TopStraton) then
    ds.FieldByName('TOP_STRATON_ID').AsInteger := o.TopStraton.ID
  else
    ds.FieldByName('TOP_STRATON_ID').Value := null;

  if Assigned(o.BottomStraton) then
    ds.FieldByName('STRATON_ID').AsInteger := o.BottomStraton.ID
  else
    ds.FieldByName('STRATON_ID').Value := null;

  ds.FieldByName('NUM_IS_STRATON_VERIFIED').AsInteger := Ord(o.IsStratChecked);
  ds.FieldByName('ROOM_ID').AsInteger := o.RoomNum;
  ds.FieldByName('VCH_BOX').AsString  := trim(o.BoxNumber);
  ds.FieldByName('VCH_PLACE_COMMENT').AsString := trim(o.PlacingComment);

  ds.FieldByName('NUM_INTERVAL_TOP').AsFloat := o.Top;
  ds.FieldByName('NUM_INTERVAL_BOTTOM').AsFloat := o.Bottom;
  if Assigned(o.SampleType) then
    ds.FieldByName('COLLECTION_SAMPLE_TYPE_ID').AsInteger := o.SampleType.ID
  else
    ds.FieldByName('COLLECTION_SAMPLE_TYPE_ID').Value := null;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('COLLECTION_SAMPLE_ID').Value;
end;

{ TCollectionSampleTypePoster }

constructor TCollectionSampleTypePoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soKeyInsert, soGetKeyValue];
  DataSourceString := 'TBL_COLLECTION_SAMPLE_TYPE';


  KeyFieldNames := 'COLLECTION_SAMPLE_TYPE_ID';


  FieldNames := 'COLLECTION_SAMPLE_TYPE_ID, VCH_COLLECTION_SAMPLE_TYPE';

  AccessoryFieldNames := FieldNames;
  AutoFillDates := false;

  Sort := 'VCH_COLLECTION_SAMPLE_TYPE';
end;

function TCollectionSampleTypePoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TCollectionSampleTypePoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TCollectionSampleType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TCollectionSampleType;

      o.ID := ds.FieldByName('COLLECTION_SAMPLE_TYPE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_COLLECTION_SAMPLE_TYPE').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TCollectionSampleTypePoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TCollectionSampleType;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TCollectionSampleType;

  ds.FieldByName('COLLECTION_SAMPLE_TYPE_ID').AsInteger := o.ID;
  ds.FieldByName('VCH_COLLECTION_SAMPLE_TYPE').AsString := o.Name;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('COLLECTION_SAMPLE_TYPE_ID').Value;
end;

{ TDenudationPoster }

constructor TDenudationDataPoster.Create;
begin
  inherited;
  Options := [soKeyInsert, soGetKeyValue];
  DataSourceString := 'vw_Denudation';
  DataPostString := 'tbl_Denudation';
  DataPostString := 'tbl_Denudation';


  KeyFieldNames := 'DENUDATION_ID';


  FieldNames := 'DENUDATION_ID, VCH_DENUDATION_NAME, VCH_DENUDATION_NUMBER, num_Collection_Sample_Count';

  AccessoryFieldNames := 'DENUDATION_ID, VCH_DENUDATION_NAME, VCH_DENUDATION_NUMBER';
  AutoFillDates := false;

  Sort := 'VCH_DENUDATION_NAME, VCH_DENUDATION_NUMBER';
end;

function TDenudationDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TDenudationDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TDenudation;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TDenudation;

      o.ID := ds.FieldByName('DENUDATION_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_DENUDATION_NAME').AsString);
      o.Number := trim(ds.FieldByName('VCH_DENUDATION_NUMBER').AsString);
      o.IsSamplesPresent := TMainFacade.GetInstance.DBGates.ExecuteQuery('select * from tbl_Collection_Sample where Collection_ID = ' + IntToStr(AObjects.Owner.ID) + ' and Denudation_ID = ' + IntToStr(o.ID)) > 0;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TDenudationDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TDenudation;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TDenudation;

  ds.FieldByName('DENUDATION_ID').AsInteger := o.ID;
  ds.FieldByName('VCH_DENUDATION_NAME').AsString := o.Name;
  ds.FieldByName('VCH_DENUDATION_NUMBER').AsString := o.Number;


  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('DENUDATION_ID').Value;
end;

{ TWellCandidateDataPoster }

constructor TWellCandidateDataPoster.Create;
begin
  inherited;

  Options := [soSingleDataSource, soKeyInsert, soGetKeyValue];
  DataSourceString := 'tbl_Well_Candidate';


  KeyFieldNames := 'WELL_CANDIDATE_UIN';


  FieldNames := 'WELL_CANDIDATE_UIN, VCH_WELL_CANDIDATE_AREA_NAME, VCH_WELL_CANDIDATE_NUM, VCH_REASON, DTM_PLACING_DATE';
  AccessoryFieldNames := FieldNames;
  AutoFillDates := false;

  Sort := 'VCH_WELL_CANDIDATE_NUM, VCH_WELL_CANDIDATE_AREA_NAME';
end;

function TWellCandidateDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TWellCandidateDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TWellCandidate;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TWellCandidate;

      o.ID := ds.FieldByName('WELL_CANDIDATE_UIN').AsInteger;
      o.AreaName := Trim(ds.FieldByName('VCH_WELL_CANDIDATE_AREA_NAME').AsString);
      o.WellNum := Trim(ds.FieldByName('VCH_WELL_CANDIDATE_NUM').AsString);
      o.Reason := Trim(ds.FieldByName('VCH_REASON').AsString);
      o.PlacingDate := ds.FieldByName('DTM_PLACING_DATE').AsDateTime;
      o.IsSamplesPresent := TMainFacade.GetInstance.DBGates.ExecuteQuery('select * from tbl_Collection_Sample where Collection_ID = ' + IntToStr(AObjects.Owner.ID) + ' and Well_Candidate_UIN = ' + IntToStr(o.ID)) > 0;


      ds.Next;
    end;

    ds.First;
  end;
end;

function TWellCandidateDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TWellCandidate;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TWellCandidate;

  ds.FieldByName('WELL_CANDIDATE_UIN').AsInteger := o.ID;
  ds.FieldByName('VCH_WELL_CANDIDATE_AREA_NAME').AsString := Trim(o.AreaName);
  ds.FieldByName('VCH_WELL_CANDIDATE_NUM').AsString := Trim(o.WellNum);
  ds.FieldByName('VCH_REASON').AsString := Trim(o.Reason);
  ds.FieldByName('DTM_PLACING_DATE').AsDateTime := o.PlacingDate;


  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('WELL_CANDIDATE_UIN').Value;
end;

end.
