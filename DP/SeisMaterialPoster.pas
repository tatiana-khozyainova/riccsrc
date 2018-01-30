unit SeisMaterialPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, SeisMaterial,Material,Structure;

type

TSeisWorkTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TSeisWorkMethodDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TSeisCrewDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TSeismicMaterialDataPoster = class(TImplementedDataPoster)
  private
    FAllSeisWorkTypes: TSeisWorkTypes;
    FAllSeisWorkMethods: TSeisWorkMethods;
    FAllSeisCrews: TSeisCrews;
    FAllSimpleDocuments: TSimpleDocuments;
    //FAllStructures: TStructures;
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    property AllSeisWorkTypes: TSeisWorkTypes read FAllSeisWorkTypes write FAllSeisWorkTypes;
    property AllSeisWorkMethods: TSeisWorkMethods read FAllSeisWorkMethods write FAllSeisWorkMethods;
    property AllSeisCrews: TSeisCrews read FAllSeisCrews write FAllSeisCrews;
    property AllSimpleDocuments: TSimpleDocuments read FAllSimpleDocuments write FAllSimpleDocuments;
    //property AllStructures: TStructures read FAllStructures write FAllStructures;
    constructor Create; override;
  end;

implementation

uses Facade, SysUtils,DateUtils;

{ TSeisWorkTypeDataPoster }

constructor TSeisWorkTypeDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_SEIS_WORK_TYPE';
  DataDeletionString := 'TBL_SEIS_WORK_TYPE';
  DataPostString := 'TBL_SEIS_WORK_TYPE';

  KeyFieldNames := 'SEIS_WORK_TYPE_ID';
  FieldNames := 'SEIS_WORK_TYPE_ID, VCH_SEIS_WORK_TYPE_NAME';

  AccessoryFieldNames := 'SEIS_WORK_TYPE_ID, VCH_SEIS_WORK_TYPE_NAME';
  AutoFillDates := false;

  Sort := 'VCH_SEIS_WORK_TYPE_NAME';
end;

function TSeisWorkTypeDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  inherited DeleteFromDB(AObject, ACollection);
end;

function TSeisWorkTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TSeisWorkType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TSeisWorkType;
      o.ID := ds.FieldByName('SEIS_WORK_TYPE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_SEIS_WORK_TYPE_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;

end;

function TSeisWorkTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    w: TSeisWorkType;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  w := AObject as TSeisWorkType;

  ds.FieldByName('SEIS_WORK_TYPE_ID').AsInteger := w.ID;
  ds.FieldByName('VCH_SEIS_WORK_TYPE_NAME').AsString := w.Name;

  ds.Post;

  if w.ID = 0 then
    Result := ds.FieldByName('SEIS_WORK_TYPE_ID').AsInteger;
end;

{ TSeisWorkMethodDataPoster }

constructor TSeisWorkMethodDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_SEIS_WORK_METHOD';
  DataDeletionString := 'TBL_SEIS_WORK_METHOD';
  DataPostString := 'TBL_SEIS_WORK_METHOD';

  KeyFieldNames := 'SEIS_WORK_METHOD_ID';
  FieldNames := 'SEIS_WORK_METHOD_ID, VCH_SEIS_WORK_METHOD_NAME';

  AccessoryFieldNames := 'SEIS_WORK_METHOD_ID, VCH_SEIS_WORK_METHOD_NAME';
  AutoFillDates := false;

  Sort := 'VCH_SEIS_WORK_METHOD_NAME';
end;

function TSeisWorkMethodDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  inherited DeleteFromDB(AObject, ACollection);
  //Result:=0;
end;

function TSeisWorkMethodDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TSeisWorkMethod;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TSeisWorkMethod;
      o.ID := ds.FieldByName('SEIS_WORK_METHOD_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_SEIS_WORK_METHOD_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;

end;

function TSeisWorkMethodDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    w: TSeisWorkMethod;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  w := AObject as TSeisWorkMethod;

  ds.FieldByName('SEIS_WORK_METHOD_ID').value := w.ID;
  ds.FieldByName('VCH_SEIS_WORK_METHOD_NAME').value := trim(w.Name);

  ds.Post;

  if w.ID = 0 then
  Result:= ds.FieldByName('SEIS_WORK_METHOD_ID').AsInteger;

end;


{ TSeisCrewDataPoster }

constructor TSeisCrewDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_SEIS_Crews';
  DataDeletionString := 'TBL_SEIS_Crews';
  DataPostString := 'TBL_SEIS_Crews';

  KeyFieldNames := 'SEIS_Crews_ID';
  FieldNames := 'SEIS_Crews_ID, num_SEIS_Crews_NUMBER';

  AccessoryFieldNames := 'SEIS_Crews_ID, num_SEIS_Crews_NUMBER';
  AutoFillDates := false;

  Sort := 'num_SEIS_Crews_NUMBER';
end;

function TSeisCrewDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  inherited DeleteFromDB(AObject, ACollection);
end;

function TSeisCrewDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TSeisCrew;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TSeisCrew;
      o.ID := ds.FieldByName('SEIS_Crews_ID').AsInteger;
      o.SeisCrewNumber := ds.FieldByName('num_SEIS_Crews_NUMBER').AsInteger;

      ds.Next;
    end;

    ds.First;
  end;

end;

function TSeisCrewDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    w: TSeisCrew;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  w := AObject as TSeisCrew;

  ds.FieldByName('SEIS_CREWS_ID').AsInteger := w.ID;
  ds.FieldByName('NUM_SEIS_CREWS_NUMBER').AsInteger := w.SeisCrewNumber;

  ds.Post;

  if w.ID = 0 then
    Result := ds.FieldByName('SEIS_CREWS_ID').AsInteger;
end;

{ TSeismicMaterialDataPoster }

constructor TSeismicMaterialDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_SEISMIC_MATERIAL';
  DataDeletionString := 'TBL_SEISMIC_MATERIAL';
  DataPostString := 'TBL_SEISMIC_MATERIAL';

  KeyFieldNames := 'SEIS_MATERIAL_ID';
  FieldNames := 'SEIS_MATERIAL_ID,MATERIAL_ID,DTM_BEGIN_WORKS_DATE,DTM_END_WORKS_DATE,SEIS_WORK_TYPE_ID,SEIS_CREWS_ID,VCH_REFERENCE_COMPOSITION,SEIS_WORK_METHOD_ID,NUM_SEIS_WORK_SCALE,VCH_STRUCT_MAP_REFLECT_HORIZON,VCH_CROSS_SECTION, STRUCTURE_ID, VERSION_ID';

  AccessoryFieldNames := 'SEIS_MATERIAL_ID,MATERIAL_ID,DTM_BEGIN_WORKS_DATE,DTM_END_WORKS_DATE,SEIS_WORK_TYPE_ID,SEIS_CREWS_ID,VCH_REFERENCE_COMPOSITION,SEIS_WORK_METHOD_ID,NUM_SEIS_WORK_SCALE,VCH_STRUCT_MAP_REFLECT_HORIZON,VCH_CROSS_SECTION, STRUCTURE_ID, VERSION_ID';
  AutoFillDates := false;

  Sort := 'SEIS_MATERIAL_ID';
end;

function TSeismicMaterialDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  inherited DeleteFromDB(AObject, ACollection);
end;

function TSeismicMaterialDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TSeismicMaterial;
    i:Integer;

begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TSeismicMaterial;
      o.ID := ds.FieldByName('SEIS_Material_ID').AsInteger;
      o.BeginWorksDate := ds.FieldByName('DTM_BEGIN_WORKS_DATE').asDateTime;
      o.EndWorksDate := ds.FieldByName('DTM_END_WORKS_DATE').asDateTime;
      o.ReferenceComposition := ds.FieldByName('VCH_REFERENCE_COMPOSITION').AsString;
      o.SeisWorkScale := ds.FieldByName('NUM_SEIS_WORK_SCALE').AsInteger;
      o.StructMapReflectHorizon := ds.FieldByName('VCH_STRUCT_MAP_REFLECT_HORIZON').AsString;
      o.CrossSection := ds.FieldByName('VCH_CROSS_SECTION').asString;
      if Assigned(AllSeisWorkTypes) then //FAllSeisWorkTypes:=AllSeisWorkTypes.Create;
      o.SeisWorkType := AllSeisWorkTypes.ItemsByID[ds.FieldByName('SEIS_WORK_TYPE_ID').AsInteger] as TSeisWorkType;
      if Assigned(AllSeisCrews) then //FAllSeisCrews:=AllSeisCrews.Create;
      o.SeisCrew := AllSeisCrews.ItemsByID[ds.FieldByName('SEIS_CREWS_ID').AsInteger] as TSeisCrew;
      if Assigned(AllSeisWorkMethods) then //FAllSeisWorkMethods:=AllSeisWorkMethods.Create;
      o.SeisWorkMethod := AllSeisWorkMethods.ItemsByID[ds.FieldByName('SEIS_WORK_METHOD_ID').AsInteger] as TSeisWorkMethod;
      if Assigned(AllSimpleDocuments) then //FAllSimpleDocuments:=AllSimpleDocuments.Create;
      o.SimpleDocument := AllSimpleDocuments.ItemsByID[ds.FieldByName('MATERIAL_ID').AsInteger] as TSimpleDocument;
      //if Assigned(AllStructures) then //FAllSimpleDocuments:=AllSimpleDocuments.Create;
     // o.Structure := AllStructures.ItemsByIdStruct[ds.FieldByName('STRUCTURE_ID').AsInteger,ds.FieldByName('Version_ID').AsInteger] as TStructure;
      ds.Next;
    end;

    ds.First;
  end;

end;

function TSeismicMaterialDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    w: TSeismicMaterial;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  w := AObject as TSeismicMaterial;

  ds.FieldByName('SEIS_MATERIAL_ID').AsInteger := w.ID;
  ds.FieldByName('DTM_BEGIN_WORKS_DATE').asDateTime:= DateOf(w.BeginWorksDate);
  ds.FieldByName('DTM_END_WORKS_DATE').asDateTime:= DateOf(w.EndWorksDate);
  ds.FieldByName('VCH_REFERENCE_COMPOSITION').AsString:= w.ReferenceComposition;
  ds.FieldByName('NUM_SEIS_WORK_SCALE').AsInteger:= w.SeisWorkScale;
  ds.FieldByName('VCH_STRUCT_MAP_REFLECT_HORIZON').AsString:= w.StructMapReflectHorizon;
  ds.FieldByName('VCH_CROSS_SECTION').AsString:= w.CrossSection;
  ds.FieldByName('SEIS_WORK_TYPE_ID').AsInteger:= w.SeisWorkType.Id;
  ds.FieldByName('SEIS_CREWS_ID').AsInteger:= w.SeisCrew.Id;
  ds.FieldByName('SEIS_WORK_METHOD_ID').AsInteger:= w.SeisWorkMethod.Id;
  ds.FieldByName('MATERIAL_ID').AsInteger:= w.SimpleDocument.Id;
 // ds.FieldByName('STRUCTURE_ID').AsInteger:= w.Structure.ID;
 // ds.FieldByName('Version_ID').AsInteger:= w.Structure.Version;

  ds.Post;

  if w.ID = 0 then
    Result := ds.FieldByName('SEIS_MATERIAL_ID').AsInteger;
end;

end.


