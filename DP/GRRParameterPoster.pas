unit GRRParameterPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, GRRParameter, MeasureUnits, Table,
     Well, LicenseZone, Organization;

type
  TGRRWellIntervalTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TGRRWellIntervalDataPoster = class(TImplementedDataPoster)
  private
    FAllWellIntervalTypes: TIDObjects;
    FAllStratons: TIDObjects;
  public
    property AllGRRWellIntervalTypes: TIDObjects read FAllWellIntervalTypes write FAllWellIntervalTypes;
    property AllStratons: TIDObjects read FAllStratons write FAllStratons;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TGRRDocumentTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TGRRDocumentDataPoster = class(TImplementedDataPoster)
  private
    FAllDocumentTypes: TGRRDocumentTypes;
    FGRRParameterGroups: TGRRParamGroups;
  public
    property AllDocumentTypes: TGRRDocumentTypes read FAllDocumentTypes write FAllDocumentTypes;
    property AllParameterGroups: TGRRParamGroups read FGRRParameterGroups write FGRRParameterGroups;
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;


    constructor Create; override;
  end;


  TGRRSeismicReportDataPoster = class(TImplementedDataPoster)
  private
    FAllDocumentTypes: TGRRDocumentTypes;
    FGRRParameterGroups: TGRRParamGroups;
  public
    property AllDocumentTypes: TGRRDocumentTypes read FAllDocumentTypes write FAllDocumentTypes;
    property AllParameterGroups: TGRRParamGroups read FGRRParameterGroups write FGRRParameterGroups;
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;


    constructor Create; override;
  end;

  TGRRParamGroupTypeDataPoster =  class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TGRRParamGroupDataPoster = class(TImplementedDataPoster)
  private
    FAllParameterGroupTypes: TGRRParamGroupTypes;
  public
    property AllParameterGroupTypes: TGRRParamGroupTypes read FAllParameterGroupTypes write FAllParameterGroupTypes;
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TGRRParameterDataPoster = class(TImplementedDataPoster)
  private
    FParameterNames: TGRRParameterNames;
    FParameterGroups: TGRRParamGroups;
    FMeasureUnits: TMeasureUnits;
    FParameterTypes: TGRRParameterTypes;
  public
    property ParameterNames: TGRRParameterNames read FParameterNames write FParameterNames;
    property ParameterGroups: TGRRParamGroups read FParameterGroups write FParameterGroups;

    property ParameterTypes: TGRRParameterTypes read FParameterTypes write FParameterTypes;

    property MeasureUnits: TMeasureUnits read FMeasureUnits write FMeasureUnits;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TGRRParamNameDataPoster = class(TImplementedDataPoster)
  private
    FAllMeasureUnits: TMeasureUnits;
    FAllGRRParameterTypes: TGRRParameterTypes;
  public
    property AllMeasureUnits: TMeasureUnits read FAllMeasureUnits write FAllMeasureUnits;
    property AllGRRParameterTypes: TGRRParameterTypes read FAllGRRParameterTypes write FAllGRRParameterTypes;
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;


  TGRRParamTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TWellGRRParameterValueDataPoster = class(TImplementedDataPoster)
  private
    FAllParameters: TGRRParameters;
  public
    property AllParameters: TGRRParameters read FAllParameters write FAllParameters;
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TOrganizationGRRParameterValueDataPoster = class(TImplementedDataPoster)
  private
    FAllLicZones: TLicenseZones;
    FAllWells: TSimpleWells;
  public
    property AllWells: TSimpleWells read FAllWells write FAllWells;
    property AllLicZones: TLicenseZones read FAllLicZones write FAllLicZones;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;

    constructor Create; override;
  end;

  TSumByOrgGRRParameterValueDataPoster = class(TImplementedDataPoster)
  private
    FAllOrganizations: TOrganizations;
  public
    property AllOrganizations: TOrganizations read FAllOrganizations write FAllOrganizations;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;

    constructor Create; override;
  end;

  TTestIntervalGRRParameterDataPoster = class(TImplementedDataPoster)
  private
    FAllParameters: TGRRParameters;
  public
    property AllParameters: TGRRParameters read FAllParameters write FAllParameters;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TGRRParamPredefinedValueDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;


  TDocumentGRRParameterDataPoster = class(TImplementedDataPoster)
  private
    FAllParameters: TGRRParameters;
  public
    property AllParameters: TGRRParameters read FAllParameters write FAllParameters;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TBedGRRParameterDataPoster = class(TImplementedDataPoster)
  private
    FAllParameters: TGRRParameters;
  public
    property AllParameters: TGRRParameters read FAllParameters write FAllParameters;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;


  TGRRDocumentStructureDataPoster = class(TImplementedDataPoster)
  private
    FAllStructures: TIDObjects;
    FAllFundTypes: TIDObjects;
  public
    property AllStructures: TIDObjects read FAllStructures write FAllStructures;
    property AllFundTypes: TIDObjects read FAllFundTypes write FAllFundTypes;
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TGRRDocumentBedDataPoster = class(TImplementedDataPoster)
  private
    FAllBedTypes: TIDObjects;
  public
    property AllBedTypes: TIDObjects read FAllBedTypes write FAllBedTypes;
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TOilShowingDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;


  TGRRStateChangeTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TGRRStateChangeDataPoster = class(TImplementedDataPoster)
  private
    FAllGRRParamGroups: TGRRParamGroups;
    FAllGRRStateChangeTypes: TGRRStateChanges;
  public
    property AllGRRParamGroups: TGRRParamGroups read FAllGRRParamGroups write FAllGRRParamGroups;
    property AllGRRStateChangeTypes: TGRRStateChanges read FAllGRRStateChangeTypes write FAllGRRStateChangeTypes;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses Facade, SysUtils, Straton, Variants, BaseWellInterval, BaseConsts, Structure,
  BaseFacades;

{ TGRRParamGroupTypeDataPoster }

constructor TGRRParamGroupTypeDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue, soSingleDataSource];
  DataSourceString := 'tbl_GRRParam_Group_Type';

  KeyFieldNames := 'Group_Type_ID';
  FieldNames := 'Group_Type_ID, vch_Group_Type_Name, num_Order';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'num_Order';
end;

function TGRRParamGroupTypeDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TGRRParamGroupTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TGRRParamGroupType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TGRRParamGroupType;
      o.ID := ds.FieldByName('Group_Type_ID').AsInteger;
      o.Name := trim(ds.FieldByName('vch_Group_Type_Name').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TGRRParamGroupTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TGRRParamGroupType;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TGRRParamGroupType;

  ds.FieldByName('Group_Type_ID').AsInteger := o.ID;
  ds.FieldByName('vch_Group_Type_Name').AsString := o.Name;


  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('Group_Type_ID').Value;
end;

{ TGRRParamGroupDataPoster }

constructor TGRRParamGroupDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'tbl_GRRParam_Group';

  KeyFieldNames := 'GRRParam_Group_ID';
  FieldNames := 'GRRParam_Group_ID, vch_GRRParam_Group_Name, Group_Type_ID, num_Order';

  AccessoryFieldNames := 'GRRParam_Group_ID, vch_GRRParam_Group_Name, Group_Type_ID, num_Order';
  AutoFillDates := false;

  Sort := 'Group_Type_ID, num_Order';
end;

function TGRRParamGroupDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TGRRParamGroupDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TGRRParamGroup;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);
  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TGRRParamGroup;
      o.ID := ds.FieldByName('GRRParam_Group_ID').AsInteger;
      o.Name := trim(ds.FieldByName('vch_GRRParam_Group_Name').AsString);
      o.ParamGroupType := AllParameterGroupTypes.ItemsByID[ds.FieldByName('Group_Type_ID').AsInteger] as TGRRParamGroupType;
      o.Order := ds.FieldByName('num_Order').AsInteger;
      ds.Next;
    end;

    ds.First;
  end;
end;

function TGRRParamGroupDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TGRRParamGroup;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TGRRParamGroup;

  ds.FieldByName('GRRParam_Group_ID').AsInteger := o.ID;
  ds.FieldByName('vch_GRRParam_Group_Name').AsString := trim(o.Name);
  ds.FieldByName('Group_Type_ID').AsInteger := o.ParamGroupType.ID;
  ds.FieldByName('num_Order').AsInteger := o.Order;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('GRRParam_Group_ID').Value;
end;

{ TGRRParamNameDataPoster }

constructor TGRRParamNameDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue, soSingleDataSource];
  DataSourceString := 'tbl_GRRParam_Name_dict';

  KeyFieldNames := 'GRRParam_Name_ID';
  FieldNames := 'GRRParam_Name_ID, Default_Measure_Unit_ID, vch_GRRParam_Name, Default_Param_Type_ID';

  AccessoryFieldNames := FieldNames;
  AutoFillDates := false;

  Sort := 'vch_GRRParam_Name';
end;

function TGRRParamNameDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TGRRParamNameDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TGrrParameterName;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TGRRParameterName;
      o.ID := ds.FieldByName('GRRParam_Name_ID').AsInteger;
      o.Name := trim(ds.FieldByName('vch_GRRParam_Name').AsString);
      o.DefaultMeasureUnit := AllMeasureUnits.ItemsByID[ds.FieldByName('Default_Measure_Unit_ID').AsInteger] as TMeasureUnit;
      o.DefaultParameterType := AllGRRParameterTypes.ItemsByID[ds.FieldByName('Default_Param_Type_ID').AsInteger] as TGRRParameterType;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TGRRParamNameDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var o: TGRRParameterName;
    ds: TDataSet;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TGRRParameterName;
  ds.FieldByName('GRRParam_Name_ID').AsInteger := o.ID;
  ds.FieldByName('vch_GRRParam_Name').AsString := o.Name;
  if Assigned(o.DefaultMeasureUnit) then
    ds.FieldByName('Default_Measure_Unit_ID').AsInteger := o.DefaultMeasureUnit.ID
  else
    ds.FieldByName('Default_Measure_Unit_ID').Value := Null;

  if Assigned(o.DefaultParameterType) then
    ds.FieldByName('Default_Param_Type_ID').AsInteger := o.DefaultParameterType.ID 
  else
    ds.FieldByName('Default_Param_Type_ID').Value := Null;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('GRRParam_Name_ID').AsInteger;
end;

{ TGRRParamTypeDataPoster }

constructor TGRRParamTypeDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue, soSingleDataSource];
  DataSourceString := 'TBL_GRRPARAM_TYPE_DICT';

  KeyFieldNames := 'PARAM_TYPE_ID';
  FieldNames := 'PARAM_TYPE_ID, VCH_PARAM_TYPE_NAME, NUM_IS_STRING, NUM_IS_DATE, NUM_IS_NUMERIC, NUM_IS_DICT_VALUE';

  AccessoryFieldNames := 'PARAM_TYPE_ID, VCH_PARAM_TYPE_NAME, NUM_IS_STRING, NUM_IS_DATE, NUM_IS_NUMERIC, NUM_IS_DICT_VALUE';
  AutoFillDates := false;

  Sort := 'VCH_PARAM_TYPE_NAME';
end;

function TGRRParamTypeDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TGRRParamTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TGRRParameterType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TGRRParameterType;
      o.ID := ds.FieldByName('PARAM_TYPE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_PARAM_TYPE_NAME').AsString);
      o.IsString := ds.FieldByName('NUM_IS_STRING').AsInteger > 0;
      o.IsDate := ds.FieldByName('NUM_IS_DATE').AsInteger > 0;
      o.IsNumeric := ds.FieldByName('NUM_IS_NUMERIC').AsInteger > 0;
      o.IsDictValue := ds.FieldByName('NUM_IS_DICT_VALUE').AsInteger > 0;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TGRRParamTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

{ TGRRParameterDataPoster }

constructor TGRRParameterDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue, soSingleDataSource];
  DataSourceString := 'TBL_GRRPARAM';

  KeyFieldNames := 'PARAM_ID';
  FieldNames := 'PARAM_ID, TABLE_ID, GRRPARAM_NAME_ID, MEASURE_UNIT_ID, GRRPARAM_GROUP_ID, PARAM_TYPE_ID,  PARENT_PARAM_ID, NUM_IS_MULTIPLE, NUM_ORDER';
  AccessoryFieldNames := 'PARAM_ID, TABLE_ID, GRRPARAM_NAME_ID, MEASURE_UNIT_ID, GRRPARAM_GROUP_ID, PARAM_TYPE_ID,  PARENT_PARAM_ID, NUM_IS_MULTIPLE, NUM_ORDER';
  AutoFillDates := false;

  Sort := 'PARENT_PARAM_ID, NUM_ORDER, PARAM_ID';
end;

function TGRRParameterDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TGRRParameterDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TGRRParameter;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);
  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TGRRParameter;

      o.ID := ds.FieldByName('PARAM_ID').AsInteger;
      o.ParameterName := ParameterNames.ItemsByID[ds.FieldByName('GRRPARAM_NAME_ID').AsInteger] as TGRRParameterName;
      o.MeasureUnit := MeasureUnits.ItemsByID[ds.FieldByName('MEASURE_UNIT_ID').AsInteger] as TMeasureUnit;
      //o.ParameterGroup := ParameterGroups.ItemsByID[ds.FieldByName('GRRPARAM_GROUP_ID').AsInteger] as TGRRParamGroup;
      o.ParameterType := ParameterTypes.ItemsByID[ds.FieldByName('PARAM_TYPE_ID').AsInteger] as TGRRParameterType;
      o.Table := TMainFacade.GetInstance.RiccDicts.ItemsByID[ds.FieldByName('Table_ID').AsInteger] as TRiccTable;
      o.IsMultiple := ds.FieldByName('num_Is_Multiple').AsInteger = 1;
      o.Order := ds.FieldByName('num_Order').AsInteger;
      //o.ParentParameter := 

      ds.Next;
    end;

    ds.First;
  end;
end;

function TGRRParameterDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var o: TGRRParameter;
    ds: TDataSet;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TGRRParameter;


  ds.FieldByName('PARAM_ID').AsInteger := o.ID;
  ds.FieldByName('GRRPARAM_NAME_ID').AsInteger := o.ParameterName.ID;

  if Assigned(o.MeasureUnit) then
    ds.FieldByName('MEASURE_UNIT_ID').AsInteger := o.MeasureUnit.ID
  else
    ds.FieldByName('MEASURE_UNIT_ID').Value := Null;

  if Assigned(o.ParameterGroup) then
    ds.FieldByName('GRRPARAM_GROUP_ID').AsInteger := o.ParameterGroup.ID
  else
    ds.FieldByName('GRRPARAM_GROUP_ID').Value := Null;

  if Assigned(o.ParameterType) then
    ds.FieldByName('PARAM_TYPE_ID').AsInteger := o.ParameterType.ID
  else
    ds.FieldByName('PARAM_TYPE_ID').Value := null;

  if Assigned(o.Table) then
    ds.FieldByName('Table_ID').AsInteger := o.Table.ID
  else
    ds.FieldByName('Table_ID').Value := null;

  ds.FieldByName('num_Is_Multiple').AsInteger := ord(o.IsMultiple);
  if Assigned(o.ParentParameter) then
    ds.FieldByName('PARENT_PARAM_ID').AsInteger := ord(o.ParentParameter.ID)
  else
    ds.FieldByName('PARENT_PARAM_ID').Value := null;

  ds.FieldByName('num_Order').AsInteger := o.Order;    

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('PARAM_ID').AsInteger;
end;

{ TWellGRRParameterValueDataPoster }

constructor TWellGRRParameterValueDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue, soSingleDataSource];
  DataSourceString := 'TBL_WELL_GRRPARAM_VALUE';

  KeyFieldNames := 'PARAM_VALUE_ID';
  FieldNames := 'PARAM_VALUE_ID, PARAM_ID, WELL_UIN, REASON_CHANGE_ID, VCH_OBJECT_NUM, NUM_VALUE, VCH_VALUE, DTM_VALUE, DICT_VALUE_ID, PARENT_PARAM_VALUE_ID, VCH_COMMENT, VERSION_ID';
  AccessoryFieldNames := 'PARAM_VALUE_ID, PARAM_ID, WELL_UIN, REASON_CHANGE_ID, VCH_OBJECT_NUM, NUM_VALUE, VCH_VALUE, DTM_VALUE, DICT_VALUE_ID, PARENT_PARAM_VALUE_ID, VCH_COMMENT, VERSION_ID';
  AutoFillDates := false;

  Sort := 'PARAM_VALUE_ID';
end;

function TWellGRRParameterValueDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TWellGRRParameterValueDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TWellGRRParameterValue;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TWellGRRParameterValue;
      o.ID := ds.FieldByName('PARAM_VALUE_ID').AsInteger;

      if Assigned(AllParameters) then
        o.Parameter := AllParameters.ItemsByID[ds.FieldByName('PARAM_ID').AsInteger] as TGRRParameter;

      o.NumValue := ds.FieldByName('NUM_VALUE').AsFloat;
      o.StringValue := ds.FieldByName('VCH_VALUE').AsString;
      o.DateTimeValue := ds.FieldByName('DTM_VALUE').AsDateTime;
      o.TableKeyValue := ds.FieldByName('DICT_VALUE_ID').AsInteger;
      o.Comment := ds.FieldByName('VCH_COMMENT').AsString;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TWellGRRParameterValueDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var o: TWellGRRParameterValue;
    ds: TDataSet;
begin
  Assert(TMainFacade.GetInstance.ActiveVersion <> nil, 'Не задана текущая версия данных');

  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TWellGRRParameterValue;

  ds.FieldByName('PARAM_VALUE_ID').AsInteger := o.ID;
  ds.FieldByName('PARAM_ID').AsInteger := o.Parameter.ID;
  ds.FieldByName('NUM_VALUE').AsFloat := o.NumValue;
  ds.FieldByName('VCH_VALUE').AsString := o.StringValue;
  ds.FieldByName('DTM_VALUE').AsDateTime := o.DateTimeValue;
  ds.FieldByName('DICT_VALUE_ID').AsInteger := o.TableKeyValue;
  ds.FieldByName('REASON_CHANGE_ID').AsInteger := TMainFacade.GetInstance.ReasonChangeID;
  ds.FieldByName('WELL_UIN').AsInteger := (o.Collection as TWellGRRParameterValues).Well.ID;
  ds.FieldByName('VCH_COMMENT').AsString := o.Comment;
  ds.FieldByName('VERSION_ID').AsInteger := TMainFacade.GetInstance.ActiveVersion.ID;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('PARAM_VALUE_ID').AsInteger;
end;

{ TGRRWellIntervalTypeDataPoster }

constructor TGRRWellIntervalTypeDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue, soSingleDataSource];
  DataSourceString := 'tbl_GRRWell_Interval_Type_dict';
  DataDeletionString := '';
  DataPostString := '';

  KeyFieldNames := 'GRRInterval_Type_ID';
  FieldNames := 'GRRInterval_Type_ID, vch_Interval_Type_Name';

  AccessoryFieldNames := 'GRRInterval_Type_ID, vch_Interval_Type_Name';
  AutoFillDates := false;

  Sort := 'GRRInterval_Type_ID';
end;

function TGRRWellIntervalTypeDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TGRRWellIntervalTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TGRRWellIntervalType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TGRRWellIntervalType;
      o.ID := ds.FieldByName('GRRInterval_Type_ID').AsInteger;
      o.Name := trim(ds.FieldByName('vch_Interval_Type_Name').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TGRRWellIntervalTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TGRRWellIntervalType;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TGRRWellIntervalType;

  ds.FieldByName('GRRInterval_Type_ID').AsInteger := o.ID;
  ds.FieldByName('vch_Interval_Type_Name').AsString := o.Name;


  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('GRRInterval_Type_ID').AsInteger;
end;

{ TGRRWellIntervalDataPoster }

constructor TGRRWellIntervalDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue, soSingleDataSource];
  DataSourceString := 'tbl_GRRWell_Interval';

  KeyFieldNames := 'GRR_Well_Interval_ID';
  FieldNames := 'GRR_Well_Interval_ID, GRRInterval_Type_ID, Well_UIN, Reason_Change_ID, num_Interval_Top, num_Interval_Bottom, Straton_ID, vch_Interval_Number, vch_Interval_Comment, vch_Interval_File_Name, Version_ID';
  AccessoryFieldNames := 'GRR_Well_Interval_ID, GRRInterval_Type_ID, Well_UIN, Reason_Change_ID, num_Interval_Top, num_Interval_Bottom, Straton_ID, vch_Interval_Number, vch_Interval_Comment, vch_Interval_File_Name, Version_ID';
  AutoFillDates := false;

  Sort := 'GRR_Well_Interval_ID';
end;

function TGRRWellIntervalDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TGRRWellIntervalDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TGRRWellInterval;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TGRRWellInterval;
      o.ID := ds.FieldByName('GRR_Well_Interval_ID').AsInteger;

      if Assigned(AllGRRWellIntervalTypes) then
        o.IntervalType := AllGRRWellIntervalTypes.ItemsByID[ds.FieldByName('GRRInterval_Type_ID').AsInteger] as TGRRWellIntervalType
      else
        o.IntervalType := nil;

      o.Name := Trim(ds.FieldByName('vch_Interval_Number').AsString); 
      o.Top := ds.FieldByName('num_Interval_Top').AsFloat;
      o.Bottom := ds.FieldByName('num_Interval_Bottom').AsFloat;
      if Assigned(AllStratons) then
        o.Straton := AllStratons.ItemsByID[ds.FieldByName('Straton_ID').AsInteger] as TSimpleStraton
      else
        o.Straton := nil;

      o.Comment := Trim(ds.FieldByName('vch_Interval_Comment').AsString);
      o.FileName := Trim(ds.FieldByName('vch_Interval_File_Name').AsString);


      ds.Next;
    end;

    ds.First;
  end;
end;

function TGRRWellIntervalDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TGRRWellInterval;
begin
  Assert(TMainFacade.GetInstance.ActiveVersion <> nil, 'Не задана текущая версия данных');

  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TGRRWellInterval;


  ds.FieldByName('GRR_Well_Interval_ID').AsInteger := o.ID;

  if Assigned(o.IntervalType) then
    ds.FieldByName('GRRInterval_Type_ID').AsInteger := o.IntervalType.ID
  else
    ds.FieldByName('GRRInterval_Type_ID').Value := null;

  ds.FieldByName('vch_Interval_Number').AsString := o.Number;
  ds.FieldByName('num_Interval_Top').AsFloat := o.Top;
  ds.FieldByName('num_Interval_Bottom').AsFloat := o.Bottom;
  ds.FieldByName('Well_UIN').AsInteger := o.Owner.ID;

  if Assigned(o.Straton) then
    ds.FieldByName('Straton_ID').AsInteger := o.Straton.ID
  else
    ds.FieldByName('Straton_ID').Value := Null;


  ds.FieldByName('Reason_Change_ID').AsInteger := NO_REASON_CHANGE_ID;
  ds.FieldByName('vch_Interval_Comment').AsString := Trim(o.Comment);
  ds.FieldByName('vch_Interval_File_Name').AsString :=  Trim(o.FileName);
  ds.FieldByName('Version_ID').AsInteger := TMainFacade.GetInstance.ActiveVersion.ID;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('GRR_Well_Interval_ID').AsInteger;
end;

{ TGRRParamPredefinedValueDataPoster }

constructor TGRRParamPredefinedValueDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue, soSingleDataSource];
  DataSourceString := 'tbl_GRRParam_Value_dict';
  DataDeletionString := '';
  DataPostString := '';

  KeyFieldNames := 'GRRParam_Value_ID';
  FieldNames := 'GRRParam_Value_ID, Param_ID, vch_GRRParam_Value_Name, vch_GRRParam_Value_Short_Name';


  AccessoryFieldNames := 'GRRParam_Value_ID, Param_ID, vch_GRRParam_Value_Name, vch_GRRParam_Value_Short_Name';
  AutoFillDates := false;

  Sort := 'vch_GRRParam_Value_Name';
end;

function TGRRParamPredefinedValueDataPoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TGRRParamPredefinedValueDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TGRRParamPredefinedValue;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TGRRParamPredefinedValue;

      o.ID := ds.FieldByName('GRRParam_Value_ID').AsInteger;
      o.Name := trim(ds.FieldByName('vch_GRRParam_Value_Name').AsString);
      o.ShortName := trim(ds.FieldByName('vch_GRRParam_Value_Short_Name').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TGRRParamPredefinedValueDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TGRRParamPredefinedValue;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TGRRParamPredefinedValue;

  ds.FieldByName('GRRParam_Value_ID').AsInteger := o.ID;
  ds.FieldByName('vch_GRRParam_Value_Name').AsString := Trim(o.Name);
  ds.FieldByName('vch_GRRParam_Value_Short_Name').AsString := Trim(o.ShortName);

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('GRRParam_Value_ID').AsInteger;
end;

{ TTestIntervalGRRParameterDataPoster }

constructor TTestIntervalGRRParameterDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue, soSingleDataSource];
  DataSourceString := 'TBL_INTERVAL_GRRPARAM_VALUE';

  KeyFieldNames := 'PARAM_VALUE_ID';
  FieldNames := 'PARAM_VALUE_ID, PARAM_ID, GRR_WELL_INTERVAL_ID, REASON_CHANGE_ID, VCH_OBJECT_NUM, NUM_VALUE, VCH_VALUE, DTM_VALUE, DICT_VALUE_ID, PARENT_PARAM_VALUE_ID, VCH_COMMENT';
  AccessoryFieldNames := 'PARAM_VALUE_ID, PARAM_ID, GRR_WELL_INTERVAL_ID, REASON_CHANGE_ID, VCH_OBJECT_NUM, NUM_VALUE, VCH_VALUE, DTM_VALUE, DICT_VALUE_ID, PARENT_PARAM_VALUE_ID, VCH_COMMENT';
  AutoFillDates := false;

  Sort := 'PARAM_VALUE_ID';
end;

function TTestIntervalGRRParameterDataPoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TTestIntervalGRRParameterDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TIntervalGRRParameterValue;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TIntervalGRRParameterValue;
      o.ID := ds.FieldByName('PARAM_VALUE_ID').AsInteger;

      if Assigned(AllParameters) then
        o.Parameter := AllParameters.ItemsByID[ds.FieldByName('PARAM_ID').AsInteger] as TGRRParameter;

      o.NumValue := ds.FieldByName('NUM_VALUE').AsFloat;
      o.StringValue := ds.FieldByName('VCH_VALUE').AsString;
      o.DateTimeValue := ds.FieldByName('DTM_VALUE').AsDateTime;
      o.TableKeyValue := ds.FieldByName('DICT_VALUE_ID').AsInteger;
      o.Comment := ds.FieldByName('VCH_COMMENT').AsString;
      ds.Next;
    end;

    ds.First;
  end;
end;

function TTestIntervalGRRParameterDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var o: TIntervalGRRParameterValue;
    ds: TDataSet;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TIntervalGRRParameterValue;

  ds.FieldByName('PARAM_VALUE_ID').AsInteger := o.ID;
  ds.FieldByName('PARAM_ID').AsInteger := o.Parameter.ID;
  ds.FieldByName('NUM_VALUE').AsFloat := o.NumValue;
  ds.FieldByName('VCH_VALUE').AsString := o.StringValue;
  ds.FieldByName('DTM_VALUE').AsDateTime := o.DateTimeValue;
  ds.FieldByName('DICT_VALUE_ID').AsInteger := o.TableKeyValue;
  ds.FieldByName('REASON_CHANGE_ID').AsInteger := TMainFacade.GetInstance.ReasonChangeID;
  ds.FieldByName('GRR_WELL_INTERVAL_ID').AsInteger := (o.Collection as TIntervalGRRParameterValues).Interval.ID;
  ds.FieldByName('VCH_COMMENT').AsString := o.Comment;
  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('PARAM_VALUE_ID').AsInteger;
end;

{ TGRRDocumentDataPoster }

constructor TGRRDocumentDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'tbl_GRRSeismic_Report';

  KeyFieldNames := 'GRRSeismic_Report_ID';
  FieldNames := 'GRRSeismic_Report_ID, vch_Seismic_Report_Name, vch_Seismic_Group_Name, num_Year, vch_Authors, Seismic_Report_Type_ID, License_Zone_ID, Version_ID, GRRParam_Group_ID';
  AccessoryFieldNames := 'GRRSeismic_Report_ID, vch_Seismic_Report_Name, vch_Seismic_Group_Name, num_Year, vch_Authors, Seismic_Report_Type_ID, License_Zone_ID, Version_ID, GRRParam_Group_ID';
  AutoFillDates := false;

  Sort := 'GRRSeismic_Report_ID';
end;

function TGRRDocumentDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TGRRDocumentDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TGRRDocument;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      case ds.FieldByName('Seismic_Report_Type_ID').AsInteger of
        SEISMIC_REPORT_TYPE_REWORK, SEISMIC_REPORT_TYPE_2D, SEISMIC_REPORT_TYPE_3D,
        GRR_PROGRAM_REPORT_TYPE, GRR_OTHER_NIR_REPORT_TYPE, SEISMIC_REPORT_TYPE_VSP,
        SEISMIC_REPORT_TYPE_MKS, SEISMIC_REPORT_TYPE_ELECTRO: o := TGRRSeismicReport.Create(AObjects);
        RESERVES_RECOUNTING_REPORT_TYPE: o := TGRRReservesRecountDocument.Create(AObjects);
        else o := TGRRSeismicReport.Create(AObjects);
      end;

      AObjects.Add(o, false, false);
      o.ID := ds.FieldByName('GRRSeismic_Report_ID').AsInteger;
      o.Name := Trim(ds.FieldByName('vch_Seismic_Report_Name').AsString);
      o.Year := ds.FieldByName('num_Year').AsInteger;
      o.Authors := Trim(ds.FieldByName('vch_Authors').AsString);
      if Assigned(AllDocumentTypes) then
        o.DocumentType := AllDocumentTypes.ItemsByID[ds.FieldByName('Seismic_Report_Type_ID').AsInteger] as TGRRDocumentType;

      if Assigned(AllParameterGroups) then
        o.ParameterGroup := AllParameterGroups.ItemsByID[ds.FieldByName('GRRParam_Group_ID').AsInteger] as TGRRParamGroup;
      ds.Next;
    end;
  end;
end;

function TGRRDocumentDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TGRRDocument;
begin
  Assert(TMainFacade.GetInstance.ActiveVersion <> nil, 'Не задана текущая версия данных');
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TGRRDocument;

  ds.FieldByName('GRRSeismic_Report_ID').AsInteger := o.ID;

  if Assigned(o.DocumentType) then
    ds.FieldByName('Seismic_Report_Type_ID').AsInteger := o.DocumentType.ID
  else
    ds.FieldByName('Seismic_Report_Type_ID').Value := null;

  ds.FieldByName('vch_Seismic_Report_Name').AsString := o.Name;
  //ds.FieldByName('vch_Seismic_Group_Name').AsString := o.SeismicGroupNumber;
  ds.FieldByName('num_Year').AsInteger := o.Year;
  ds.FieldByName('vch_Authors').AsString := o.Authors;
  ds.FieldByName('License_Zone_ID').AsInteger := o.Collection.Owner.ID;
  ds.FieldByName('Version_ID').AsInteger := TMainFacade.GetInstance.ActiveVersion.ID;
  if Assigned(o.ParameterGroup) then
    ds.FieldByName('GRRParam_Group_ID').AsInteger := o.ParameterGroup.ID;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('GRRSeismic_Report_ID').AsInteger;
end;

{ TGRRDocumentTypeDataPoster }

constructor TGRRDocumentTypeDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'tbl_GRRSeismic_Report_Type';

  KeyFieldNames := 'Seismic_Report_Type_ID';
  FieldNames := 'Seismic_Report_Type_ID, vch_Seismic_Report_Type_Name';
  AccessoryFieldNames := 'Seismic_Report_Type_ID, vch_Seismic_Report_Type_Name';
  AutoFillDates := false;

  Sort := 'Seismic_Report_Type_ID';
end;

function TGRRDocumentTypeDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TGRRDocumentTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TGRRDocumentType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TGRRDocumentType;
      o.ID := ds.FieldByName('Seismic_Report_Type_ID').AsInteger;
      o.Name := Trim(ds.FieldByName('vch_Seismic_Report_Type_Name').AsString);

      ds.Next;
    end;
  end;
end;

function TGRRDocumentTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

{ TSeismicReportGRRParameterDataPoster }

constructor TDocumentGRRParameterDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue, soSingleDataSource];
  DataSourceString := 'TBL_SRREPORT_GRRPARAM_VALUE';

  KeyFieldNames := 'PARAM_VALUE_ID';
  FieldNames := 'PARAM_VALUE_ID, PARAM_ID, GRR_SEISMIC_REPORT_ID, REASON_CHANGE_ID, NUM_VALUE, VCH_VALUE, DTM_VALUE, DICT_VALUE_ID, PARENT_PARAM_VALUE_ID, VCH_COMMENT, VERSION_ID';
  AccessoryFieldNames := 'PARAM_VALUE_ID, PARAM_ID, GRR_SEISMIC_REPORT_ID, REASON_CHANGE_ID, NUM_VALUE, VCH_VALUE, DTM_VALUE, DICT_VALUE_ID, PARENT_PARAM_VALUE_ID, VCH_COMMENT, VERSION_ID';
  AutoFillDates := false;

  Sort := 'PARAM_VALUE_ID';
end;

function TDocumentGRRParameterDataPoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TDocumentGRRParameterDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TDocumentGrrParameterValue;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TDocumentGrrParameterValue;
      o.ID := ds.FieldByName('PARAM_VALUE_ID').AsInteger;

      if Assigned(AllParameters) then
        o.Parameter := AllParameters.ItemsByID[ds.FieldByName('PARAM_ID').AsInteger] as TGRRParameter;

      o.NumValue := ds.FieldByName('NUM_VALUE').AsFloat;
      o.StringValue := ds.FieldByName('VCH_VALUE').AsString;
      o.DateTimeValue := ds.FieldByName('DTM_VALUE').AsDateTime;
      o.TableKeyValue := ds.FieldByName('DICT_VALUE_ID').AsInteger;
      o.Comment := ds.FieldByName('VCH_COMMENT').AsString;
      ds.Next;
    end;

    ds.First;
  end;
end;

function TDocumentGRRParameterDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var o: TDocumentGrrParameterValue;
    ds: TDataSet;
begin
  Assert(TMainFacade.GetInstance.ActiveVersion <> nil, 'Не задана текущая версия данных');

  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TDocumentGrrParameterValue;

  ds.FieldByName('PARAM_VALUE_ID').AsInteger := o.ID;
  ds.FieldByName('PARAM_ID').AsInteger := o.Parameter.ID;
  ds.FieldByName('NUM_VALUE').AsFloat := o.NumValue;
  ds.FieldByName('VCH_VALUE').AsString := o.StringValue;
  ds.FieldByName('DTM_VALUE').AsDateTime := o.DateTimeValue;
  ds.FieldByName('DICT_VALUE_ID').AsInteger := o.TableKeyValue;
  ds.FieldByName('REASON_CHANGE_ID').AsInteger := TMainFacade.GetInstance.ReasonChangeID;
  ds.FieldByName('GRR_SEISMIC_REPORT_ID').AsInteger := (o.Collection as TDocumentGRRParameterValues).GRRDocument.ID;
  ds.FieldByName('VCH_COMMENT').AsString := o.Comment;
  ds.FieldByName('VERSION_ID').AsInteger := TMainFacade.GetInstance.ActiveVersion.ID;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('PARAM_VALUE_ID').AsInteger;
end;

{ TGRRDocumentStructureDataPoster }

constructor TGRRDocumentStructureDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue, soSingleDataSource];
  DataSourceString := 'TBL_GRRSTRUCTURE';

  KeyFieldNames := 'GRRSTRUCTURE_ID';


  FieldNames := 'GRRSTRUCTURE_ID, VCH_GRR_STRUCTURE_NAME, STRUCTURE_ID, FUND_TYPE_ID, GRRSEISMIC_REPORT_ID, VERSION_ID';
  AccessoryFieldNames := 'GRRSTRUCTURE_ID, VCH_GRR_STRUCTURE_NAME, STRUCTURE_ID, FUND_TYPE_ID, GRRSEISMIC_REPORT_ID, VERSION_ID';
  AutoFillDates := false;

  Sort := 'GRRSTRUCTURE_ID';
end;

function TGRRDocumentStructureDataPoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TGRRDocumentStructureDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TGRRDocumentStructure;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TGRRDocumentStructure;
      o.ID := ds.FieldByName('GRRSTRUCTURE_ID').AsInteger;
      o.Name := ds.FieldByName('VCH_GRR_STRUCTURE_NAME').AsString;
      o.Structure := AllStructures.ItemsByID[ds.FieldByName('STRUCTURE_ID').AsInteger];
      o.FundType := AllFundTypes.ItemsByID[ds.FieldByName('FUND_TYPE_ID').AsInteger];
      ds.Next;
    end;

    ds.First;
  end;
end;

function TGRRDocumentStructureDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var o: TGRRDocumentStructure;
    ds: TDataSet;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TGRRDocumentStructure;

  ds.FieldByName('GRRSTRUCTURE_ID').AsInteger := o.ID;
  ds.FieldByName('VCH_GRR_STRUCTURE_NAME').AsString := o.Name;

  if Assigned(o.Structure) then
    ds.FieldByName('STRUCTURE_ID').AsInteger := o.Structure.ID;

  if Assigned(o.FundType) then
    ds.FieldByName('FUND_TYPE_ID').AsInteger := o.FundType.ID;

  ds.FieldByName('GRRSEISMIC_REPORT_ID').AsInteger := o.Report.ID;
  ds.FieldByName('VERSION_ID').AsInteger := 0;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('GRRSTRUCTURE_ID').AsInteger;
end;

{ TGRRSeismicReportDataPoster }

constructor TGRRSeismicReportDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'tbl_GRRSeismic_Report';

  KeyFieldNames := 'GRRSeismic_Report_ID';
  FieldNames := 'GRRSeismic_Report_ID, vch_Seismic_Report_Name, vch_Seismic_Group_Name, num_Year, vch_Authors, Seismic_Report_Type_ID, License_Zone_ID, Version_ID, GRRParam_Group_ID';
  AccessoryFieldNames := 'GRRSeismic_Report_ID, vch_Seismic_Report_Name, vch_Seismic_Group_Name, num_Year, vch_Authors, Seismic_Report_Type_ID, License_Zone_ID, Version_ID, GRRParam_Group_ID';
  AutoFillDates := false;

  Sort := 'GRRSeismic_Report_ID';
end;

function TGRRSeismicReportDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TGRRSeismicReportDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TGRRSeismicReport;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TGRRSeismicReport;
      o.ID := ds.FieldByName('GRRSeismic_Report_ID').AsInteger;
      o.Name := Trim(ds.FieldByName('vch_Seismic_Report_Name').AsString);
      o.SeismicGroupNumber := Trim(ds.FieldByName('vch_Seismic_Group_Name').AsString);
      o.Year := ds.FieldByName('num_Year').AsInteger;
      o.Authors := Trim(ds.FieldByName('vch_Authors').AsString);
      if Assigned(AllDocumentTypes) then
        o.DocumentType := AllDocumentTypes.ItemsByID[ds.FieldByName('Seismic_Report_Type_ID').AsInteger] as TGRRDocumentType;

      if Assigned(AllParameterGroups) then
        o.ParameterGroup := AllParameterGroups.ItemsByID[ds.FieldByName('GRRParam_Group_ID').AsInteger] as TGRRParamGroup;
      ds.Next;
    end;
  end;
end;

function TGRRSeismicReportDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TGRRSeismicReport;
begin
  Assert(TMainFacade.GetInstance.ActiveVersion <> nil, 'Не задана текущая версия данных');

  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TGRRSeismicReport;

  ds.FieldByName('GRRSeismic_Report_ID').AsInteger := o.ID;

  if Assigned(o.DocumentType) then
    ds.FieldByName('Seismic_Report_Type_ID').AsInteger := o.DocumentType.ID
  else
    ds.FieldByName('Seismic_Report_Type_ID').Value := null;

  ds.FieldByName('vch_Seismic_Report_Name').AsString := o.Name;
  ds.FieldByName('vch_Seismic_Group_Name').AsString := o.SeismicGroupNumber;
  ds.FieldByName('num_Year').AsInteger := o.Year;
  ds.FieldByName('vch_Authors').AsString := o.Authors;
  ds.FieldByName('License_Zone_ID').AsInteger := o.Collection.Owner.ID;
  ds.FieldByName('Version_ID').AsInteger := TMainFacade.GetInstance.ActiveVersion.ID;
  if Assigned(o.ParameterGroup) then
    ds.FieldByName('GRRParam_Group_ID').AsInteger := o.ParameterGroup.ID;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('GRRSeismic_Report_ID').AsInteger;
end;

{ TGRRDocumentBedDataPoster }

constructor TGRRDocumentBedDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue, soSingleDataSource];
  DataSourceString := 'TBL_GRRBED';
  KeyFieldNames := 'GRRBED_ID';
  FieldNames := 'GRRBED_ID, VCH_BED_INDEX, BED_ID, FIELD_TYPE_ID, GRRSTRUCTURE_ID, VERSION_ID, GRRSEISMIC_REPORT_ID';
  AccessoryFieldNames := 'GRRBED_ID, VCH_BED_INDEX, BED_ID, FIELD_TYPE_ID, GRRSTRUCTURE_ID, VERSION_ID, GRRSEISMIC_REPORT_ID';
  AutoFillDates := false;

  Sort := 'GRRBED_ID';
end;

function TGRRDocumentBedDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TGRRDocumentBedDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TGRRDocumentBed;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TGRRDocumentBed;
      o.ID := ds.FieldByName('GRRBED_ID').AsInteger;
      o.Name := ds.FieldByName('VCH_BED_INDEX').AsString;
      o.Bed := (o.Field.Structure as TField).Beds.ItemsByID[ds.FieldByName('BED_ID').AsInteger] as TBed;
      o.BedType := AllBedTypes.ItemsByID[ds.FieldByName('FIELD_TYPE_ID').AsInteger];

      ds.Next;
    end;

    ds.First;
  end;
end;

function TGRRDocumentBedDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var o: TGRRDocumentBed;
    ds: TDataset;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TGRRDocumentBed;

  ds.FieldByName('GRRBED_ID').AsInteger := o.ID;
  ds.FieldByName('VCH_BED_INDEX').AsString := o.Name;
  if Assigned(o.Bed) then
    ds.FieldByName('BED_ID').AsInteger := o.Bed.ID;

  if Assigned(o.BedType) then
    ds.FieldByName('FIELD_TYPE_ID').AsInteger := o.BedType.ID;

  ds.FieldByName('GRRSTRUCTURE_ID').AsInteger := o.Field.ID;
  ds.FieldByName('GRRSEISMIC_REPORT_ID').AsInteger := o.Field.Report.ID;
  ds.FieldByName('VERSION_ID').AsInteger := 0;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('GRRBED_ID').AsInteger;
end;

{ TBedGRRParameterDataPoster }

constructor TBedGRRParameterDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue, soSingleDataSource];
  DataSourceString := 'TBL_BED_GRRPARAM_VALUE';

  KeyFieldNames := 'PARAM_VALUE_ID';
  FieldNames := 'PARAM_VALUE_ID, PARAM_ID, GRRBED_ID, REASON_CHANGE_ID, NUM_VALUE, VCH_VALUE, DTM_VALUE, DICT_VALUE_ID, PARENT_PARAM_VALUE_ID';
  AccessoryFieldNames := 'PARAM_VALUE_ID, PARAM_ID, GRRBED_ID, REASON_CHANGE_ID, NUM_VALUE, VCH_VALUE, DTM_VALUE, DICT_VALUE_ID, PARENT_PARAM_VALUE_ID';
  AutoFillDates := false;

  Sort := 'PARAM_VALUE_ID';
end;

function TBedGRRParameterDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TBedGRRParameterDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TBedGrrParameterValue;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TBedGrrParameterValue;
      o.ID := ds.FieldByName('PARAM_VALUE_ID').AsInteger;

      if Assigned(AllParameters) then
        o.Parameter := AllParameters.ItemsByID[ds.FieldByName('PARAM_ID').AsInteger] as TGRRParameter;

      o.NumValue := ds.FieldByName('NUM_VALUE').AsFloat;
      o.StringValue := ds.FieldByName('VCH_VALUE').AsString;
      o.DateTimeValue := ds.FieldByName('DTM_VALUE').AsDateTime;
      o.TableKeyValue := ds.FieldByName('DICT_VALUE_ID').AsInteger;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TBedGRRParameterDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var o: TBedGrrParameterValue;
    ds: TDataSet;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TBedGRRParameterValue;

  ds.FieldByName('PARAM_VALUE_ID').AsInteger := o.ID;
  ds.FieldByName('PARAM_ID').AsInteger := o.Parameter.ID;
  ds.FieldByName('NUM_VALUE').AsFloat := o.NumValue;
  ds.FieldByName('VCH_VALUE').AsString := o.StringValue;
  ds.FieldByName('DTM_VALUE').AsDateTime := o.DateTimeValue;
  ds.FieldByName('DICT_VALUE_ID').AsInteger := o.TableKeyValue;
  ds.FieldByName('REASON_CHANGE_ID').AsInteger := TMainFacade.GetInstance.ReasonChangeID;
  ds.FieldByName('GRRBED_ID').AsInteger := (o.Collection as TDocumentGRRParameterValues).GRRDocument.ID;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('PARAM_VALUE_ID').AsInteger;
end;

{ TOilShowingDataPoster }

constructor TOilShowingDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'tbl_Oil_Showing_Type';

  KeyFieldNames := 'Oil_Showing_Type_ID';
  FieldNames := 'Oil_Showing_Type_ID, VCH_OIL_SHOWING_TYPE';
  AccessoryFieldNames := 'Oil_Showing_Type_ID, VCH_OIL_SHOWING_TYPE';
  AutoFillDates := false;

  Sort := 'Oil_Showing_Type_ID';
end;

function TOilShowingDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TOilShowingDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TOilShowingType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TOilShowingType;
      o.ID := ds.FieldByName('Oil_Showing_Type_ID').AsInteger;
      o.Name := Trim(ds.FieldByName('VCH_OIL_SHOWING_TYPE').AsString);

      ds.Next;
    end;
  end;
end;

function TOilShowingDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

{ TOrganizationGRRParameterValueDataPoster }

constructor TOrganizationGRRParameterValueDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue, soSingleDataSource];
  DataSourceString := 'VW_GRRREPORT_1';

  KeyFieldNames := 'LICENSE_ZONE_ID';

  FieldNames := 'LICENSE_ZONE_ID, VCH_LICENSE_NUM, VCH_LIC_TYPE_SHORT_NAME, VCH_LICENSE_ZONE_NAME, VCH_LICENSE_ZONE_FULL_NAME, ORGANIZATION_ID, VCH_ORG_FULL_NAME, DISTRICT_ID, VCH_DISTRICT_NAME, ' +
                'WELL_UIN, VCH_WELL_FULL_NAME, DRILLING_STR, DRILLING_EXPL, SEISM_2D_VOLUME, SEISM_2D_COST, SEISM_3D_VOLUME, SEISM_3D_COST, ' +
                'VSP_COST, MKS_SLBO_COST, ELECTRIC_PROSPECTING_VOLUME, ELECTRIC_PROSPECTING_COST, GEOCHEMICAL_METHOD_COST, NIOKR_COST, SOFTWARE_COST, OTHER_COST';

  AccessoryFieldNames := 'LICENSE_ZONE_ID, VCH_LICENSE_NUM, VCH_LIC_TYPE_SHORT_NAME, VCH_LICENSE_ZONE_NAME, VCH_LICENSE_ZONE_FULL_NAME, ORGANIZATION_ID, VCH_ORG_FULL_NAME, DISTRICT_ID, VCH_DISTRICT_NAME, ' +
                'WELL_UIN, VCH_WELL_FULL_NAME, DRILLING_STR, DRILLING_EXPL, SEISM_2D_VOLUME, SEISM_2D_COST, SEISM_3D_VOLUME, SEISM_3D_COST, ' +
                'VSP_COST, MKS_SLBO_COST, ELECTRIC_PROSPECTING_VOLUME, ELECTRIC_PROSPECTING_COST, GEOCHEMICAL_METHOD_COST, NIOKR_COST, SOFTWARE_COST, OTHER_COST';

  AutoFillDates := false;

  Sort := 'ORGANIZATION_ID, LICENSE_ZONE_ID, WELL_UIN';
end;

function TOrganizationGRRParameterValueDataPoster.GetFromDB(
  AFilter: string; AObjects: TIdObjects): integer;
var ds: TDataSet;
    o:  TOrganizationGRRParameterValue;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TOrganizationGRRParameterValue;

      if Assigned(AllLicZones) then
        o.LicZone := AllLicZones.ItemsByID[ds.FieldByName('LICENSE_ZONE_ID').AsInteger] as TLicenseZone;

      o.LicZoneFullName := Trim(ds.FieldByName('VCH_LICENSE_ZONE_FULL_NAME').AsString);

      if Assigned(AllWells) then
        o.Well := AllWells.ItemsByID[ds.FieldByName('WELL_UIN').AsInteger] as TSimpleWell;

      o.WellFullName := Trim(ds.FieldByName('VCH_WELL_FULL_NAME').AsString);

      o.DrillingStr := ds.FieldByName('DRILLING_STR').AsFloat;
      o.DrillingExpl := ds.FieldByName('DRILLING_EXPL').AsFloat;
      o.Seism2DVol := ds.FieldByName('SEISM_2D_VOLUME').AsFloat;
      o.Seism2DCost := ds.FieldByName('SEISM_2D_COST').AsFloat;
      o.Seism3DVol := ds.FieldByName('SEISM_3D_VOLUME').AsFloat;
      o.Seism3DCost := ds.FieldByName('SEISM_3D_COST').AsFloat;
      o.VSPCost := ds.FieldByName('VSP_COST').AsFloat;

      o.MksSlboCost := ds.FieldByName('MKS_SLBO_COST').AsFloat;
      o.ElectricProspectingVol := ds.FieldByName('ELECTRIC_PROSPECTING_VOLUME').AsFloat;
      o.ElectricProspectingCost := ds.FieldByName('ELECTRIC_PROSPECTING_COST').AsFloat;

      o.NiokrCost := ds.FieldByName('NIOKR_COST').AsFloat;
      o.GeochemicalMethodCost := ds.FieldByName('GEOCHEMICAL_METHOD_COST').AsFloat;
      o.SoftwareCost := ds.FieldByName('SOFTWARE_COST').AsFloat;
      o.OtherCost := ds.FieldByName('OTHER_COST').AsFloat;

      ds.Next;
    end;

    ds.First;
  end;
end;

{ TSumByOrgGRRParameterValueDataPoster }

constructor TSumByOrgGRRParameterValueDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue, soSingleDataSource];
  DataSourceString := 'VW_GRRREPORT_ORG';

  KeyFieldNames := 'ORGANIZATION_ID';

  FieldNames := 'VCH_LICENSE_NUM, VCH_LIC_TYPE_SHORT_NAME, VCH_LICENSE_ZONE_NAME, VCH_LICENSE_ZONE_FULL_NAME, ORGANIZATION_ID, VCH_ORG_FULL_NAME, DISTRICT_ID, VCH_DISTRICT_NAME, ' +
                'WELL_UIN, VCH_WELL_FULL_NAME, DRILLING_STR, DRILLING_EXPL, SEISM_2D_VOLUME, SEISM_2D_COST, SEISM_3D_VOLUME, SEISM_3D_COST, ' +
                'VSP_COST, MKS_SLBO_COST, ELECTRIC_PROSPECTING_VOLUME, ELECTRIC_PROSPECTING_COST, GEOCHEMICAL_METHOD_COST, NIOKR_COST, SOFTWARE_COST, OTHER_COST';

  AccessoryFieldNames := 'VCH_LICENSE_NUM, VCH_LIC_TYPE_SHORT_NAME, VCH_LICENSE_ZONE_NAME, VCH_LICENSE_ZONE_FULL_NAME, ORGANIZATION_ID, VCH_ORG_FULL_NAME, DISTRICT_ID, VCH_DISTRICT_NAME, ' +
                'WELL_UIN, VCH_WELL_FULL_NAME, DRILLING_STR, DRILLING_EXPL, SEISM_2D_VOLUME, SEISM_2D_COST, SEISM_3D_VOLUME, SEISM_3D_COST, ' +
                'VSP_COST, MKS_SLBO_COST, ELECTRIC_PROSPECTING_VOLUME, ELECTRIC_PROSPECTING_COST, GEOCHEMICAL_METHOD_COST, NIOKR_COST, SOFTWARE_COST, OTHER_COST';

  AutoFillDates := false;

  Sort := 'ORGANIZATION_ID';
end;

function TSumByOrgGRRParameterValueDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o:  TSumByOrgGRRParameterValue;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TSumByOrgGRRParameterValue;

      if Assigned(AllOrganizations) then
        o.Organization := AllOrganizations.ItemsByID[ds.FieldByName('ORGANIZATION_ID').AsInteger] as TOrganization;

      o.DrillingStr := ds.FieldByName('DRILLING_STR').AsFloat;
      o.DrillingExpl := ds.FieldByName('DRILLING_EXPL').AsFloat;
      o.Seism2DVol := ds.FieldByName('SEISM_2D_VOLUME').AsFloat;
      o.Seism2DCost := ds.FieldByName('SEISM_2D_COST').AsFloat;
      o.Seism3DVol := ds.FieldByName('SEISM_3D_VOLUME').AsFloat;
      o.Seism3DCost := ds.FieldByName('SEISM_3D_COST').AsFloat;
      o.VSPCost := ds.FieldByName('VSP_COST').AsFloat;

      o.MksSlboCost := ds.FieldByName('MKS_SLBO_COST').AsFloat;
      o.ElectricProspectingVol := ds.FieldByName('ELECTRIC_PROSPECTING_VOLUME').AsFloat;
      o.ElectricProspectingCost := ds.FieldByName('ELECTRIC_PROSPECTING_COST').AsFloat;

      o.NiokrCost := ds.FieldByName('NIOKR_COST').AsFloat;
      o.GeochemicalMethodCost := ds.FieldByName('GEOCHEMICAL_METHOD_COST').AsFloat;
      o.SoftwareCost := ds.FieldByName('SOFTWARE_COST').AsFloat;
      o.OtherCost := ds.FieldByName('OTHER_COST').AsFloat;

      ds.Next;
    end;

    ds.First;
  end;
end;

{ TGRRStateChangeTypeDataPoster }

constructor TGRRStateChangeTypeDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_GRRSTATE_CHANGE_TYPE';

  KeyFieldNames := 'GRRSTATE_CHANGE_TYPE_ID';
  FieldNames := 'GRRSTATE_CHANGE_TYPE_ID, VCH_GRRSTATE_NAME, VCH_GRRSTATE_SHORT_NAME';
  AccessoryFieldNames := 'GRRSTATE_CHANGE_TYPE_ID, VCH_GRRSTATE_NAME, VCH_GRRSTATE_SHORT_NAME';
  AutoFillDates := false;

  Sort := 'GRRSTATE_CHANGE_TYPE_ID';
end;

function TGRRStateChangeTypeDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TGRRStateChangeTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TGRRStateChangeType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TGRRStateChangeType;
      o.ID := ds.FieldByName('GRRSTATE_CHANGE_TYPE_ID').AsInteger;
      o.Name := Trim(ds.FieldByName('VCH_GRRSTATE_NAME').AsString);
      o.ShortName := Trim(ds.FieldByName('VCH_GRRSTATE_SHORT_NAME').AsString); 

      ds.Next;
    end;
  end;
end;

function TGRRStateChangeTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

{ TGRRStateChangeDataPoster }

constructor TGRRStateChangeDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_GRRSTATE_CHANGE';

  KeyFieldNames := 'GRRSTATE_CHANGE_ID';
  FieldNames := 'GRRSTATE_CHANGE_ID, VERSION_ID, GRRSTATE_CHANGE_TYPE_ID, GRRPARAM_GROUP_ID, LICENSE_ZONE_ID, WELL_UIN, GRR_DOCUMENT_ID';
  AccessoryFieldNames := 'GRRSTATE_CHANGE_ID, VERSION_ID, GRRSTATE_CHANGE_TYPE_ID, GRRPARAM_GROUP_ID, LICENSE_ZONE_ID, WELL_UIN, GRR_DOCUMENT_ID';
  AutoFillDates := false;

  Sort := 'GRRSTATE_CHANGE_ID';
end;

function TGRRStateChangeDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TGRRStateChangeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TGRRStateChange;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TGRRStateChange;
      o.ID := ds.FieldByName('GRRSTATE_CHANGE_ID').AsInteger;
      o.StateChangeType := AllGRRStateChangeTypes.ItemsByID[ds.FieldByName('GRRSTATE_CHANGE_TYPE_ID').AsInteger] as TGRRStateChangeType;
      o.ParamGroup := AllGRRParamGroups.ItemsByID[ds.FieldByName('GRRPARAM_GROUP_ID').AsInteger] as TGRRParamGroup;
      if (o.StateChangeType <> nil) then 
        o.Name := o.StateChangeType.Name;

      ds.Next;
    end;
  end;

end;

function TGRRStateChangeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TGRRStateChange;
begin
  Assert((AObject as TGRRStateChange).StateChangeType <> nil, 'Не задан вид изменения параметров');
  Assert(((AObject as TGRRStateChange).Owner is TLicenseZone) or
         ((AObject as TGRRStateChange).Owner is TLicenseZoneWellGRRParameterValueSet) or
         ((AObject as TGRRStateChange).Owner is TGRRDocument), 'Изменение состояния возможно по лицензионному участку или скважине');

  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TGRRStateChange;

  ds.FieldByName('GRRSTATE_CHANGE_ID').AsInteger := o.ID;
  ds.FieldByName('VERSION_ID').AsInteger := TMainFacade.GetInstance.ActiveVersion.ID;
  ds.FieldByName('GRRSTATE_CHANGE_TYPE_ID').AsInteger := o.StateChangeType.ID;

  if Assigned(o.ParamGroup) then
    ds.FieldByName('GRRPARAM_GROUP_ID').AsInteger := o.ParamGroup.ID;

  if o.Owner is TLicenseZone then
    ds.FieldByName('LICENSE_ZONE_ID').AsInteger := o.Owner.ID
  else if o.Owner is TLicenseZoneWellGRRParameterValueSet then
    ds.FieldByName('WELL_UIN').AsInteger := o.Owner.ID
  else if o.Owner is TGRRDocument then
    ds.FieldByName('GRR_DOCUMENT_ID').AsInteger := o.Owner.ID;
end;

end.







