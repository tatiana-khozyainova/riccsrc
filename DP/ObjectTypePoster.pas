unit ObjectTypePoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, BaseObjectType;

type
  TObjectTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses Facade, SysUtils;

{ TClassTypeObjectDataPoster }

constructor TObjectTypeDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_OBJECT_TYPE_DICT';

  KeyFieldNames := 'OBJECT_TYPE_ID';
  FieldNames := 'OBJECT_TYPE_ID, VCH_OBJECT_TYPE_NAME';

  AccessoryFieldNames := 'OBJECT_TYPE_ID, VCH_OBJECT_TYPE_NAME';
  AutoFillDates := false;

  Sort := 'OBJECT_TYPE_ID';
end;

function TObjectTypeDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; 
begin
  Result := 0;
end;

function TObjectTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TObjectType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TObjectType;

      o.ID := ds.FieldByName('OBJECT_TYPE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_OBJECT_TYPE_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TObjectTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

end.
