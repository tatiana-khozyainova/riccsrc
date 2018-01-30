unit WorkDataPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, Work;

type

   TWorkDataPoster = class (TImplementedDataPoster)
   public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    constructor Create; override;
  end;

implementation

uses Facade, SysUtils;

{ TWorkDataPoster }

constructor TWorkDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_TABLE';
  KeyFieldNames := 'TABLE_ID';
  FieldNames := 'TABLE_ID, VCH_TABLE_NAME, VCH_RUS_TABLE_NAME';
  AccessoryFieldNames := '';
end;

function TWorkDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TWorkDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var
  ds: TDataSet;
  o: TWork;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);
  if not ds.Eof then
  begin
    ds.First;
    while not ds.Eof do
    begin
      o := AObjects.Add as TWork;
      o.ID := ds.FieldByName('TABLE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_RUS_TABLE_NAME').AsString);
      ds.Next;
    end;
    ds.First;
  end;
end;

function TWorkDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited PostToDB(AObject, ACollection);
//  ds.F
end;

end.
