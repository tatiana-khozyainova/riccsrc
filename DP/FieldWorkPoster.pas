unit FieldWorkPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, FieldWork;

type

  TFieldWorkDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses Facade, SysUtils;

{ TFieldWorkDataPoster }

constructor TFieldWorkDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_FIELD_WORKS_DICT';

  KeyFieldNames := 'FIELD_WORKS_ID';
  FieldNames := 'FIELD_WORKS_ID, VCH_FIELD_WORKS_NAME';

  AccessoryFieldNames := 'FIELD_WORKS_ID, VCH_FIELD_WORKS_NAME';
  AutoFillDates := false;

  Sort := 'VCH_FIELD_WORKS_NAME';
end;

function TFieldWorkDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TFieldWorkDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o:  TFieldWork;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TFieldWork;

      o.ID := ds.FieldByName('FIELD_WORKS_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_FIELD_WORKS_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TFieldWorkDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o:  TFieldWork;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := TFieldWork(AObject);

  ds.FieldByName('FIELD_WORKS_ID').AsInteger := o.ID;
  ds.FieldByName('VCH_FIELD_WORKS_NAME').AsString := trim (o.Name);

  ds.Post;

  o.ID := ds.FieldByName('FIELD_WORKS_ID').AsInteger;
end;

end.
