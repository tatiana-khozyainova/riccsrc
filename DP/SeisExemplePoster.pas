unit SeisExemplePoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, SeisExemple,SeisMaterial,Material;

type

TExempleTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TExempleLocationDataPoster = class(TImplementedDataPoster)
  FAllMaterialLocations:TMaterialLocations;
  public
    property AllMaterialLocations:TMaterialLocations read FAllMaterialLocations write FAllMaterialLocations;
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TElementTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TExempleSeismicMaterialDataPoster = class(TImplementedDataPoster)
  private
    FAllSeismicMaterials: TSeismicMaterials;
    FAllExempleTypes: TExempleTypes;
    FAllExempleLocations: TExempleLocations;

  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    property AllSeismicMaterials: TSeismicMaterials read FAllSeismicMaterials write FAllSeismicMaterials;
    property AllExempleTypes: TExempleTypes read FAllExempleTypes write FAllExempleTypes;
    property AllExempleLocations: TExempleLocations read FAllExempleLocations write FAllExempleLocations;
    constructor Create; override;
  end;

    TElementExempleDataPoster = class(TImplementedDataPoster)
  private
    FAllExempleSeismicMaterials: TExempleSeismicMaterials;
    FAllElementTypes: TElementTypes;

  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    property AllExempleSeismicMaterials: TExempleSeismicMaterials read FAllExempleSeismicMaterials write FAllExempleSeismicMaterials;
    property AllElementTypes: TElementTypes read FAllElementTypes write FAllElementTypes;
    constructor Create; override;
  end;

implementation

uses Facade, SysUtils;

{ TExempleTypeDataPoster }

constructor TExempleTypeDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_exemple_TYPE';
  DataDeletionString := 'TBL_exemple_TYPE';
  DataPostString := 'TBL_exemple_TYPE';

  KeyFieldNames := 'EXEMPLE_TYPE_ID';
  FieldNames := 'EXEMPLE_TYPE_ID, VCH_EXEMPLE_TYPE_NAME';

  AccessoryFieldNames := 'EXEMPLE_TYPE_ID, VCH_EXEMPLE_TYPE_NAME';
  AutoFillDates := false;

  Sort := 'VCH_EXEMPLE_TYPE_NAME';
end;

function TExempleTypeDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result :=inherited DeleteFromDB(AObject, ACollection);
end;

function TExempleTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TExempleType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TExempleType;
      o.ID := ds.FieldByName('EXEMPLE_TYPE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_EXEMPLE_TYPE_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;

end;

function TExempleTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    w: TExempleType;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  w := AObject as TExempleType;

  ds.FieldByName('EXEMPLE_TYPE_ID').AsInteger := w.ID;
  ds.FieldByName('VCH_EXEMPLE_TYPE_NAME').AsString := w.Name;

  ds.Post;

  if w.ID = 0 then
    Result := ds.FieldByName('EXEMPLE_TYPE_ID').AsInteger;
end;

{ TExempleLocationDataPoster }

constructor TExempleLocationDataPoster.Create;
begin

  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_exemple_Location';
  DataDeletionString := 'TBL_exemple_Location';
  DataPostString := 'TBL_exemple_Location';

  KeyFieldNames := 'EXEMPLE_Location_ID';
  FieldNames := 'EXEMPLE_Location_ID, VCH_EXEMPLE_Location_NAME,Location_ID';

  AccessoryFieldNames := 'EXEMPLE_Location_ID, VCH_EXEMPLE_Location_NAME,Location_ID';
  AutoFillDates := false;

  Sort := 'VCH_EXEMPLE_Location_NAME';
end;

function TExempleLocationDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result :=inherited DeleteFromDB(AObject, ACollection);
end;

function TExempleLocationDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TExempleLocation;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TExempleLocation;
      o.ID := ds.FieldByName('EXEMPLE_Location_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_EXEMPLE_Location_NAME').AsString);
      //if not Assigned(AllMaterialLocations) then FAllMaterialLocations:=AllMaterialLocations.Create;
      if Assigned(AllMaterialLocations) then
      o.MaterialLocation := AllMaterialLocations.ItemsByID[ds.FieldByName('Location_ID').AsInteger] as TMaterialLocation;
               
      ds.Next;
    end;

    ds.First;
  end;
  end;

function TExempleLocationDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    w: TExempleLocation;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  w := AObject as TExempleLocation;

  ds.FieldByName('EXEMPLE_Location_ID').AsInteger := w.ID;
  ds.FieldByName('VCH_EXEMPLE_Location_NAME').AsString := w.Name;
  ds.FieldByName('Location_ID').AsInteger := w.MaterialLocation.ID;


  ds.Post;

  if w.ID = 0 then
    Result := ds.FieldByName('EXEMPLE_Location_ID').AsInteger;
end;

{ TElementTypeDataPoster }

constructor TElementTypeDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_Element_TYPE';
  DataDeletionString := 'TBL_Element_TYPE';
  DataPostString := 'TBL_Element_TYPE';

  KeyFieldNames := 'Element_TYPE_ID';
  FieldNames := 'Element_TYPE_ID, VCH_Element_TYPE_NAME';

  AccessoryFieldNames := 'Element_TYPE_ID, VCH_Element_TYPE_NAME';
  AutoFillDates := false;

  Sort := 'VCH_Element_TYPE_NAME';
end;

function TElementTypeDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result :=inherited DeleteFromDB(AObject, ACollection);
end;

function TElementTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TElementType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TElementType;
      o.ID := ds.FieldByName('Element_TYPE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_Element_TYPE_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;

end;

function TElementTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    w: TElementType;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  w := AObject as TElementType;

  ds.FieldByName('Element_TYPE_ID').AsInteger := w.ID;
  ds.FieldByName('VCH_Element_TYPE_NAME').AsString := w.Name;

  ds.Post;

  if w.ID = 0 then
    Result := ds.FieldByName('Element_TYPE_ID').AsInteger;
end;

{ TExempleSeismicMaterialDataPoster }

constructor TExempleSeismicMaterialDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_Exemple_SEIS_MATERIAL';
  DataDeletionString := 'TBL_Exemple_SEIS_MATERIAL';
  DataPostString := 'TBL_Exemple_SEIS_MATERIAL';

  KeyFieldNames := 'EXEMPLE_SEIS_MATERIAL_ID';
  FieldNames := 'EXEMPLE_SEIS_MATERIAL_ID,SEIS_MATERIAL_ID,EXEMPLE_TYPE_ID,EXEMPLE_LOCATION_ID,NUM_EXEMPLE_SUM,VCH_EXEMPLE_COMMENT';

  AccessoryFieldNames := 'EXEMPLE_SEIS_MATERIAL_ID,SEIS_MATERIAL_ID,EXEMPLE_TYPE_ID,EXEMPLE_LOCATION_ID,NUM_EXEMPLE_SUM,VCH_EXEMPLE_COMMENT';
  AutoFillDates := false;

  Sort := 'EXEMPLE_SEIS_MATERIAL_ID';
end;

function TExempleSeismicMaterialDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result :=inherited DeleteFromDB(AObject, ACollection);
end;

function TExempleSeismicMaterialDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TExempleSeismicMaterial;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TExempleSeismicMaterial;
      o.ID := ds.FieldByName('EXEMPLE_SEIS_MATERIAL_ID').AsInteger;
      o.ExempleSum := ds.FieldByName('NUM_EXEMPLE_SUM').AsInteger;
      o.ExempleComment := ds.FieldByName('VCH_EXEMPLE_COMMENT').AsString;
      if Assigned(AllExempleTypes) then //FAllExempleTypes:=AllExempleTypes.Create;
      o.ExempleType := AllExempleTypes.ItemsByID[ds.FieldByName('EXEMPLE_TYPE_ID').AsInteger] as TExempleType;
      if Assigned(AllExempleLocations) then //FAllExempleLocations:=AllExempleLocations.Create;
      o.ExempleLocation := AllExempleLocations.ItemsByID[ds.FieldByName('Exemple_Location_ID').AsInteger] as TExempleLocation;
      if Assigned(AllSeismicMaterials) then //FAllSeismicMaterials:=AllSeismicMaterials.Create;
      o.SeismicMaterial := AllSeismicMaterials.ItemsByID[ds.FieldByName('SEIS_Material_ID').AsInteger] as TSeismicMaterial;

      ds.Next;
    end;

    ds.First;
  end;

end;

function TExempleSeismicMaterialDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    w: TExempleSeismicMaterial;
    i:Integer;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  w := AObject as TExempleSeismicMaterial;

  ds.FieldByName('EXEMPLE_SEIS_MATERIAL_ID').AsInteger := w.ID;
  ds.FieldByName('NUM_Exemple_SUM').AsInteger:= w.ExempleSum;
  ds.FieldByName('VCH_Exemple_COMMENT').AsString:= w.ExempleComment;
  ds.FieldByName('EXEMPLE_TYPE_ID').AsInteger:= w.ExempleType.Id;
  ds.FieldByName('Exemple_Location_ID').AsInteger:= w.ExempleLocation.Id;
  ds.FieldByName('SEIS_Material_ID').AsInteger:= w.SeismicMaterial.Id;


  ds.Post;

  if w.ID <= 0 then
    Result := ds.FieldByName('EXEMPLE_SEIS_MATERIAL_ID').AsInteger;
  i:=Result;
end;

{ TElementExempleDataPoster }

constructor TElementExempleDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_Element_Exemple';
  DataDeletionString := 'TBL_Element_Exemple';
  DataPostString := 'TBL_Element_Exemple';

  KeyFieldNames := 'Element_Exemple_ID';
  FieldNames := 'Element_Exemple_ID,EXEMPLE_SEIS_MATERIAL_ID,ELEMENT_TYPE_ID,NUM_ELEMENT_NUMBER,VCH_ELEMENT_COMMENT,VCH_ELEMENT_EXEMPLE_NAME,VCH_ELEMENT_LOCATION';

  AccessoryFieldNames := 'Element_Exemple_ID,EXEMPLE_SEIS_MATERIAL_ID,ELEMENT_TYPE_ID,NUM_ELEMENT_NUMBER,VCH_ELEMENT_COMMENT,VCH_ELEMENT_EXEMPLE_NAME,VCH_ELEMENT_LOCATION';
  AutoFillDates := false;

  Sort := 'EXEMPLE_SEIS_MATERIAL_ID';
end;

function TElementExempleDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result :=inherited DeleteFromDB(AObject, ACollection);
end;

function TElementExempleDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TElementExemple;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TElementExemple;
      o.ID := ds.FieldByName('ELEMENT_Exemple_ID').AsInteger;
      o.Name := ds.FieldByName('VCH_ELEMENT_EXEMPLE_NAME').AsString;
      o.ElementNumber := ds.FieldByName('NUM_ELEMENT_NUMBER').AsInteger;
      o.ElementComment := ds.FieldByName('VCH_ELEMENT_COMMENT').AsString;
      o.ElementLocation := ds.FieldByName('VCH_ELEMENT_LOCATION').AsString;
      if  Assigned(AllElementTypes) then //FAllElementTypes:=AllElementTypes.Create;
      o.ElementType := AllElementTypes.ItemsByID[ds.FieldByName('ELEMENT_TYPE_ID').AsInteger] as TElementType;
      if  Assigned(AllExempleSeismicMaterials) then //FAllExempleSeismicMaterials:=AllExempleSeismicMaterials.Create;
      o.ExempleSeismicMaterial := AllExempleSeismicMaterials.ItemsByID[ds.FieldByName('Exemple_SEIS_MATERIAL_ID').AsInteger] as TExempleSeismicMaterial;
      
      ds.Next;
    end;

    ds.First;
  end;

end;

function TElementExempleDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    w: TElementExemple;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  w := AObject as TElementExemple;

  ds.FieldByName('Element_Exemple_ID').AsInteger := w.ID;
  ds.FieldByName('VCH_ELEMENT_EXEMPLE_NAME').AsString:= w.Name;
  ds.FieldByName('NUM_ELEMENT_NUMBER').AsInteger:= w.ElementNumber;
  ds.FieldByName('VCH_ELEMENT_COMMENT').AsString:= w.ElementComment;
  ds.FieldByName('VCH_ELEMENT_LOCATION').AsString:= w.ElementLocation;
  ds.FieldByName('ELEMENT_TYPE_ID').AsInteger:= w.ElementType.Id;
  ds.FieldByName('EXEMPLE_SEIS_Material_ID').AsInteger:= w.ExempleSeismicMaterial.Id;


  ds.Post;

  if w.ID <= 0 then
    Result := ds.FieldByName('Element_Exemple_ID').AsInteger;
end;

end.
