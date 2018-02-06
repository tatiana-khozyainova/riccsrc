unit MaterialPoster;

interface

uses DBGate, BaseObjects, PersistentObjects, Material,Table, DB, Organization, Employee,
LasFile;


type
  // для типов документов
  TDocTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

    // для документов
  TSimpleDocumentDataPoster = class(TImplementedDataPoster)
  private
    FAllDocTypes:TDocumentTypes;
    FAllMaterialLocations: TMaterialLocations;
    FAllOrganizations:TOrganizations;
    FAllEmployees:TEmployees;
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    property AllDocTypes:TDocumentTypes read FAllDocTypes write FAllDocTypes;
    property AllMaterialLocations:TMaterialLocations read FAllMaterialLocations write FAllMaterialLocations;
    property AllOrganizations:TOrganizations read FAllOrganizations write FAllOrganizations;
    property AllEmployees:TEmployees read FAllEmployees write FAllEmployees;
    constructor Create; override;
  end;

  TMaterialLocationDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TObjectBindTypeDataPoster = class(TImplementedDataPoster)
  private
    FAllRiccTables: TRiccTables;
    FAllRiccAttributes: TRICCAttributes;
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    property AllRiccTables: TRiccTables read FAllRiccTables write FAllRiccTables;
    property AllRiccAttributes: TRICCAttributes read FAllRiccAttributes write FAllRiccAttributes;
    constructor Create; override;
  end;

    TMaterialBindingDataPoster = class(TImplementedDataPoster)
  private
    FAllSimpleDocuments: TSimpleDocuments;
    FAllObjectBindTypes: TObjectBindTypes;
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    property AllSimpleDocuments: TSimpleDocuments read FAllSimpleDocuments write FAllSimpleDocuments;
    property AllObjectBindTypes: TObjectBindTypes read FAllObjectBindTypes write FAllObjectBindTypes;
    constructor Create; override;
  end;


  TMaterialCurveDataPoster = class(TImplementedDataPoster)
  private
    FAllSimpleDocuments: TSimpleDocuments;
    FAllCurveCategoryes: TCurveCategories;
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    property AllSimpleDocuments: TSimpleDocuments read FAllSimpleDocuments write FAllSimpleDocuments;
    property AllCurveCategoryes: TCurveCategories read FAllCurveCategoryes write FAllCurveCategoryes;
    constructor Create; override;
  end;


    TMaterialAuthorDataPoster = class(TImplementedDataPoster)
  private
    FAllSimpleDocuments: TSimpleDocuments;
   // FAllEmployees: TEmployees;
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    property AllSimpleDocuments: TSimpleDocuments read FAllSimpleDocuments write FAllSimpleDocuments;
   // property AllEmployees: TEmployees read FAllEmployees write FAllEmployees;
    constructor Create; override;
  end;

    TObjectBindMaterialTypeDataPoster = class(TImplementedDataPoster)
  private
    FAllObjectBindTypes: TObjectBindTypes;
    FAllDocumentTypes:TDocumentTypes;
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    property AllObjectBindTypes: TObjectBindTypes read FAllObjectBindTypes write FAllObjectBindTypes;
    property AllDocumentTypes: TDocumentTypes read FAllDocumentTypes write FAllDocumentTypes;
    constructor Create; override;
  end;

implementation

uses Facade,SysUtils,DateUtils, Variants;

{ TDocTypesCategoryDataPoster }

constructor TDocTypeDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'VW_MATERIAL_TYPES';
  DataDeletionString := '';
  DataPostString := 'SPD_ADD_MATERIAL_TYPE';

  KeyFieldNames := 'MATERIAL_TYPE_ID';

  FieldNames := 'MATERIAL_TYPE_ID, VCH_MATERIAL_TYPE_NAME, PARENTS_MATERIAL_TYPE_ID, BOOL_ARCHOV, LEVEL_ACCESS_ID';
  AccessoryFieldNames := 'MATERIAL_TYPE_ID, VCH_MATERIAL_TYPE_NAME, PARENTS_MATERIAL_TYPE_ID, BOOL_ARCHOV, LEVEL_ACCESS_ID';

  AutoFillDates := false;
  Sort := 'VCH_MATERIAL_TYPE_NAME';
end;

function TDocTypeDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TDocTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TDocumentType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TDocumentType;

      o.ID := ds.FieldByName('MATERIAL_TYPE_ID').AsInteger;
      o.Name := ds.FieldByName('VCH_MATERIAL_TYPE_NAME').AsString;

      //BOOL_ARCHOV,
      //LEVEL_ACCESS_ID

      ds.Next;
    end;

    ds.First;
  end;
end;

function TDocTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

{ TDocumentDataPoster }

constructor TSimpleDocumentDataPoster.Create;
begin
  inherited;
  Options := [soKeyInsert];
  DataSourceString := 'VW_MATERIALS__NEW';
  DataPostString:= 'SPD_ADD_MATERIAL_V3';

  KeyFieldNames := 'MATERIAL_ID';

  FieldNames := 'MATERIAL_ID, VCH_MATERIAL_NAME, MATERIAL_TYPE_ID, DTM_ENTERING_DATE, VCH_LOCATION,DTM_CREATION_DATE,NUM_INVENTORY_NUMBER,NUM_TGF_NUMBER,ORGANIZATION_ID,EMPLOYEE_ID,LOCATION_ID,VCH_COMMENTS,VCH_AUTHORS,VCH_BIND_ATTRIBUTES';
  AccessoryFieldNames := 'MATERIAL_ID, VCH_MATERIAL_NAME, MATERIAL_TYPE_ID, DTM_ENTERING_DATE, VCH_LOCATION,DTM_CREATION_DATE,NUM_INVENTORY_NUMBER,NUM_TGF_NUMBER,ORGANIZATION_ID,EMPLOYEE_ID,LOCATION_ID,VCH_COMMENTS,VCH_AUTHORS,VCH_BIND_ATTRIBUTES';

  AutoFillDates := false;

  Sort := 'NUM_INVENTORY_NUMBER, VCH_MATERIAL_NAME';
end;

function TSimpleDocumentDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TSimpleDocumentDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TSimpleDocument;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TSimpleDocument;

      o.ID := ds.FieldByName('MATERIAL_ID').AsInteger;
      o.Name := o.StrToCorrect(ds.FieldByName('VCH_MATERIAL_NAME').AsString);
      o.LocationPath := ds.FieldByName('VCH_LOCATION').AsString;
      o.InventNumber:=ds.FieldByName('NUM_INVENTORY_NUMBER').AsInteger;
      o.TGFNumber:=ds.FieldByName('NUM_TGF_NUMBER').AsInteger;
      o.Authors:=ds.FieldByName('VCH_AUTHORS').AsString;
      o.Bindings:=ds.FieldByName('VCH_BIND_ATTRIBUTES').AsString;
      o.CreationDate:=ds.FieldByName('DTM_CREATION_DATE').AsDateTime;
      o.EnteringDate:=ds.FieldByName('DTM_ENTERING_DATE').AsDateTime;
      o.MaterialComment:=ds.FieldByName('VCH_COMMENTS').AsString;
      if Assigned(AllDocTypes) then
      o.DocType := AllDocTypes.ItemsByID[ds.FieldByName('MATERIAL_TYPE_ID').AsInteger] as TDocumentType;
      if Assigned(AllMaterialLocations) then
      o.MaterialLocation := AllMaterialLocations.ItemsByID[ds.FieldByName('LOCATION_ID').AsInteger] as TMaterialLocation;
      if Assigned(AllOrganizations) then
      o.Organization := AllOrganizations.ItemsByID[ds.FieldByName('ORGANIZATION_ID').AsInteger] as TOrganization;
      if Assigned(AllEmployees) then
      o.Employee := AllEmployees.ItemsByID[ds.FieldByName('EMPLOYEE_ID').AsInteger] as TEmployee;
      ds.Next;
    end;

    ds.First;
  end;
end;

function TSimpleDocumentDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    w: TSimpleDocument;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  w := AObject as TSimpleDocument;

  ds.FieldByName('MATERIAL_ID').AsInteger := w.ID;
  ds.FieldByName('VCH_MATERIAL_NAME').AsString:= w.Name;
  ds.FieldByName('DTM_CREATION_DATE').asDateTime:= DateOf(w.CreationDate);
  ds.FieldByName('DTM_ENTERING_DATE').asDateTime:= DateOf(w.EnteringDate);
  ds.FieldByName('NUM_INVENTORY_NUMBER').AsInteger:= w.InventNumber;
  ds.FieldByName('NUM_TGF_NUMBER').AsInteger:= w.TGFNumber;
  ds.FieldByName('VCH_LOCATION').AsString:= w.VCHLocation;
  ds.FieldByName('VCH_AUTHORS').AsString:= w.Authors;
  ds.FieldByName('VCH_BIND_ATTRIBUTES').AsString:= w.Bindings;
  ds.FieldByName('VCH_COMMENTS').AsString:= w.MaterialComment;
  ds.FieldByName('MATERIAL_TYPE_ID').AsInteger:= w.DocType.Id;
  ds.FieldByName('LOCATION_ID').AsInteger:= w.MaterialLocation.Id;
  ds.FieldByName('ORGANIZATION_ID').AsInteger:= w.Organization.Id;
  ds.FieldByName('EMPLOYEE_ID').AsInteger:= 775;//w.Employee.Id;

 // ds.FieldByName('STRUCTURE_ID').AsInteger:= w.Structure.ID;
 // ds.FieldByName('Version_ID').AsInteger:= w.Structure.Version;

  ds.Post;

  if w.ID = 0 then
    Result := ds.FieldByName('MATERIAL_ID').AsInteger;

end;

{ TMaterialLocationDataPoster }

constructor TMaterialLocationDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_Location';
  DataDeletionString := 'TBL_Location';
  DataPostString := 'TBL_Location';

  KeyFieldNames := 'Location_ID';
  FieldNames := 'Location_ID, VCH_Location_NAME';

  AccessoryFieldNames := 'Location_ID, VCH_Location_NAME';
  AutoFillDates := false;

  Sort := 'VCH_Location_NAME';
end;

function TMaterialLocationDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
   Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TMaterialLocationDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TMaterialLocation;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TMaterialLocation;
      o.ID := ds.FieldByName('Location_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_Location_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;

end;

function TMaterialLocationDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    w: TMaterialLocation;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  w := AObject as TMaterialLocation;

  ds.FieldByName('Location_ID').AsInteger := w.ID;
  ds.FieldByName('VCH_Location_NAME').AsString := w.Name;

  ds.Post;

  if w.ID = 0 then
    Result := ds.FieldByName('Location_ID').AsInteger;
end;

{ TTObjectBindTypeDataPoster }

constructor TObjectBindTypeDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_OBJECT_BIND_TYPES';
  DataDeletionString := 'TBL_OBJECT_BIND_TYPES';
  DataPostString := 'TBL_OBJECT_BIND_TYPES';

  KeyFieldNames := 'OBJECT_BIND_TYPE_ID';
  FieldNames := 'OBJECT_BIND_TYPE_ID,VCH_OBJECT_BIND_TYPE_NAME,table_id,attribute_id';

  AccessoryFieldNames := 'OBJECT_BIND_TYPE_ID,VCH_OBJECT_BIND_TYPE_NAME,table_id,attribute_id';
  AutoFillDates := false;

  Sort := 'VCH_OBJECT_BIND_TYPE_NAME';
end;

function TObjectBindTypeDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TObjectBindTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TObjectBindType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TObjectBindType;
      o.ID := ds.FieldByName('Object_Bind_Type_ID').AsInteger;
      o.Name:=ds.FieldByName('VCH_Object_Bind_Type_Name').AsString;
      if Assigned(AllRiccTables) then
      o.RiccTable := AllRiccTables.ItemsByID[ds.FieldByName('TABLE_ID').AsInteger] as TRiccTable;
      if Assigned(AllRiccAttributes) then
      o.RiccAttribute := AllRiccAttributes.ItemsByID[ds.FieldByName('ATTRIBUTE_ID').AsInteger] as TRiccAttribute;
      ds.Next;
    end;

    ds.First;
  end;

end;

function TObjectBindTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result:=0;
end;

{ TMaterialBindingDataPoster }

constructor TMaterialBindingDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_Material_Binding';
  DataDeletionString := 'TBL_Material_Binding';
  DataPostString := 'SPD_ADD_MATERIAL_BIND';

  KeyFieldNames := 'MATERIAL_ID;OBJECT_BIND_TYPE_ID;OBJECT_BIND_ID';
  FieldNames := 'MATERIAL_ID,OBJECT_BIND_TYPE_ID,OBJECT_BIND_ID';

  AccessoryFieldNames := 'MATERIAL_ID,OBJECT_BIND_TYPE_ID,OBJECT_BIND_ID';
  AutoFillDates := false;

  Sort := 'MATERIAL_ID';
end;

function TMaterialBindingDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TCommonServerDataSet;
    mb: TMaterialBinding;
begin
  Assert(DataDeletionString <> '', 'Не задан приемник данных ' + ClassName);
  Result := 0;
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  try
    // находим строку соответствующую ключу
    //ds.Refresh;
    mb := AObject as  TMaterialBinding;
    ds.First;
    if ds.Locate(ds.KeyFieldNames, varArrayOf([mb.SimpleDocument.ID,mb.ObjectBindType.ID,AObject.ID]), []) then
      ds.Delete
  except
    Result := -1;
  end;
end;

function TMaterialBindingDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TMaterialBinding;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TMaterialBinding;
      if Assigned(AllSimpleDocuments) then
      o.SimpleDocument := AllSimpleDocuments.ItemsByID[ds.FieldByName('MATERIAL_ID').AsInteger] as TSimpleDocument;
      if Assigned(AllObjectBindTypes) then
      o.ObjectBindType := AllObjectBindTypes.ItemsByID[ds.FieldByName('OBJECT_BIND_TYPE_ID').AsInteger] as TObjectBindType;
      o.ID:=ds.FieldByName('OBJECT_BIND_ID').AsInteger;
      ds.Next;
    end;

    ds.First;
  end;
end;

function TMaterialBindingDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    w: TMaterialBinding;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  w := AObject as TMaterialBinding;

  ds.FieldByName('Material_id').AsInteger := w.SimpleDocument.id;
  ds.FieldByName('OBJECT_BIND_TYPE_ID').AsInteger := w.ObjectBindType.id;
  ds.FieldByName('OBJECT_BIND_ID').AsInteger := w.ID;

  ds.Post;

  //if w.ID = 0 then
  //  Result := ds.FieldByName('Location_ID').AsInteger;
end;


{ TMaterialCurveDataPoster }

constructor TMaterialCurveDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_MATERIAL_CURVE';
  DataDeletionString := 'TBL_MATERIAL_CURVE';
  DataPostString := 'TBL_MATERIAL_CURVE';

  KeyFieldNames := 'MATERIAL_ID; CURVE_CATEGORY_ID';
  FieldNames := 'MATERIAL_ID, CURVE_CATEGORY_ID';

  AccessoryFieldNames := 'MATERIAL_ID, CURVE_CATEGORY_ID';
  AutoFillDates := false;

  Sort := 'MATERIAL_ID';
end;

function TMaterialCurveDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TCommonServerDataSet;
    mc: TMaterialCurve;
begin
  Assert(DataDeletionString <> '', 'Не задан приемник данных ' + ClassName);
  Result := 0;
  ds := TMainFacade.GetInstance.DBGates.Add(Self);
  try
    // находим строку соответствующую ключу
    //ds.Refresh;
    mc := AObject as  TMaterialCurve;
    ds.First;
    if ds.Locate(ds.KeyFieldNames, varArrayOf([mc.SimpleDocument.ID, mc.CurveCategory.ID]), []) then
      ds.Delete
  except
    Result := -1;
  end;
end;

function TMaterialCurveDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TMaterialCurve;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TMaterialCurve;
      if Assigned(AllSimpleDocuments) then
      o.SimpleDocument := AllSimpleDocuments.ItemsByID[ds.FieldByName('MATERIAL_ID').AsInteger] as TSimpleDocument;
      o.CurveCategory :=AllCurveCategoryes.ItemsByID[ds.FieldByName('CURVE_CATEGORY_ID').AsInteger] as TCurveCategory;
    end;

    ds.First;
  end;
end;

function TMaterialCurveDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
   var ds: TDataSet;
    mc: TMaterialCurve;
begin
  {Result := 0;
  mc := AObject as TMAterialCurve;
  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    if not ds.Active then
      ds.Open;
    if ds.Locate(KeyFieldNames, varArrayOf([mc.SimpleDocument.ID, mc.CurveCategory.ID]), []) then
      ds.Edit
    else ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;
  }
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  mc := AObject as TMaterialCurve;
  //if Assigned(o.Owner) then
  //ds.FieldByName('WELL_UIN').Value:= o.Owner.ID;
  ds.FieldByName('MATERIAL_ID').Value:= mc.SimpleDocument.ID;
  ds.FieldByName('CURVE_CATEGORY_ID').Value := mc.CurveCategory.ID;
  ds.Post;


  //ds.FieldByName('MATERIAL_ID').Value := mc.SimpleDocument.ID;
  //ds.FieldByName('CURVE_CATEGORY_ID').Value := mc.CurveCategory.ID;

  //ds.Post;

end;

{ TMaterialAuthorDataPoster }

constructor TMaterialAuthorDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_AUTHOR';
  DataDeletionString := 'TBL_AUTHOR';
  DataPostString := 'SPD_ADD_AUTHOR';

  KeyFieldNames := 'employee_id; MATERIAL_ID';
  FieldNames := 'employee_id,MATERIAL_ID,role_ID';

  AccessoryFieldNames := 'employee_id,MATERIAL_ID,role_ID';
  AutoFillDates := false;

  Sort := 'MATERIAL_ID';
end;

function TMaterialAuthorDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TCommonServerDataSet;
    ma: TMaterialAuthor;
begin
  Assert(DataDeletionString <> '', 'Не задан приемник данных ' + ClassName);
  Result := 0;
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  try
    // находим строку соответствующую ключу
    //ds.Refresh;
    ma := AObject as  TMaterialAuthor;
    ds.First;
    if ds.Locate(ds.KeyFieldNames, varArrayOf([AObject.ID, ma.SimpleDocument.ID]), []) then
      ds.Delete
  except
    Result := -1;
  end;
end;

function TMaterialAuthorDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TMaterialAuthor;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TMaterialAuthor;
      if Assigned(AllSimpleDocuments) then
      o.SimpleDocument := AllSimpleDocuments.ItemsByID[ds.FieldByName('MATERIAL_ID').AsInteger] as TSimpleDocument;
      o.ID :=ds.FieldByName('EMPLOYEE_ID').AsInteger;
      o.Role := TAuthorRole(ds.FieldByName('ROLE_ID').AsInteger);
      ds.Next;
    end;

    ds.First;
  end;
end;

function TMaterialAuthorDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    w: TMaterialAuthor;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  w := AObject as TMaterialAuthor;

  ds.FieldByName('EMPLOYEE_ID').AsInteger := w.ID;
  ds.FieldByName('Material_id').AsInteger := w.SimpleDocument.id;
  ds.FieldByName('Role_ID').AsInteger := ord(w.Role);

  ds.Post;
end;

{ TObjectBindMaterialTypeDataPoster }

constructor TObjectBindMaterialTypeDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_OBJECT_BIND_MATERIAL_TYPE';
  DataDeletionString := 'TBL_OBJECT_BIND_MATERIAL_TYPE';
  DataPostString := 'TBL_OBJECT_BIND_MATERIAL_TYPE';

  KeyFieldNames := 'OBJECT_BIND_TYPE_ID,MATERIAL_TYPE_ID';
  FieldNames := 'OBJECT_BIND_TYPE_ID,MATERIAL_TYPE_ID';

  AccessoryFieldNames := 'OBJECT_BIND_TYPE_ID,MATERIAL_TYPE_ID';
  AutoFillDates := false;

  Sort := 'MATERIAL_TYPE_ID';
end;

function TObjectBindMaterialTypeDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TObjectBindMaterialTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TObjectBindMaterialType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TObjectBindMaterialType;
      if Assigned(AllObjectBindTypes) then
      o.ObjectBindType := AllObjectBindTypes.ItemsByID[ds.FieldByName('OBJECT_BIND_TYPE_ID').AsInteger] as TObjectBindType;
      if Assigned(AllDocumentTypes) then
      o.DocumentType := AllDocumentTypes.ItemsByID[ds.FieldByName('MATERIAL_TYPE_ID').AsInteger] as TDocumentType;
      ds.Next;
    end;

    ds.First;
  end;
end;

function TObjectBindMaterialTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result:=0;
end;







end.
