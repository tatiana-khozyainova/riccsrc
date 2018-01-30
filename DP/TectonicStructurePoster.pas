unit TectonicStructurePoster;

interface

uses DBGate, BaseObjects, PersistentObjects;

type

  // для тектонических структур
  TTectonicStructureDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  // для тектонических структур
  TNewTectonicStructureDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;


implementation

uses TectonicStructure, DB, Facade, SysUtils;

{ TTectonicStructureDataPoster }

constructor TTectonicStructureDataPoster.Create;
begin
  inherited;
  Options := [];
  DataSourceString := 'TBL_TECTONIC_STRUCT_DICT';
  DataDeletionString := '';
  DataPostString := '';

  KeyFieldNames := 'STRUCT_ID';
  FieldNames := 'STRUCT_ID, VCH_STRUCT_FULL_NAME, VCH_STRUCT_CODE, VCH_OLD_STRUCT_CODE, NUM_STRUCT_TYPE, MAIN_STRUCT_ID';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := '';
end;

function TTectonicStructureDataPoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TTectonicStructureDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TTectonicStructure;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TTectonicStructure;

      o.ID := ds.FieldByName('STRUCT_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_STRUCT_FULL_NAME').AsString);
      o.MainTectonicStructureID := ds.FieldByName('MAIN_STRUCT_ID').AsInteger;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TTectonicStructureDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;



{ TNewTectonicStructureDataPoster }

constructor TNewTectonicStructureDataPoster.Create;
begin
  inherited;
  Options := [];
  DataSourceString := 'TBL_NEW_TECTONIC_STRUCT_DICT';
  DataDeletionString := '';
  DataPostString := '';

  KeyFieldNames := 'STRUCT_ID';
  FieldNames := 'STRUCT_ID, VCH_STRUCT_FULL_NAME, VCH_STRUCT_CODE, VCH_FORMATTED_STRUCT_CODE, NUM_STRUCT_TYPE, MAIN_STRUCT_ID, OLD_STRUCT_ID';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := '';
end;

function TNewTectonicStructureDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TNewTectonicStructureDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o:  TNewTectonicStructure;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TNewTectonicStructure;

      o.ID := ds.FieldByName('STRUCT_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_STRUCT_FULL_NAME').AsString);
      o.MainTectonicStructureID := ds.FieldByName('MAIN_STRUCT_ID').AsInteger;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TNewTectonicStructureDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

end.
