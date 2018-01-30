unit ConstructionPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, Fluid;

type
  TConstructionColumnTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;




implementation

uses Construction, Facade, SysUtils;

{ TPerforatorDataPoster }

constructor TConstructionColumnTypeDataPoster.Create;
begin
  inherited;

  Options := [soSingleDataSource];
  DataSourceString := 'TBL_CONSTR_COLUMN_TYPE_DICT';

  KeyFieldNames := 'CONSTR_COLUMN_TYPE_ID';
  FieldNames := 'CONSTR_COLUMN_TYPE_ID, VCH_CONSTR_COLUMN_TYPE_NAME';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_CONSTR_COLUMN_TYPE_NAME';
end;

function TConstructionColumnTypeDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TConstructionColumnTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TConstructionColumnType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TConstructionColumnType;
      o.ID := ds.FieldByName('CONSTR_COLUMN_TYPE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_CONSTR_COLUMN_TYPE_NAME').AsString);
      ds.Next;
    end;

    ds.First;
  end;
end;

function TConstructionColumnTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

end.

