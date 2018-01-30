unit LithologyPoster;

interface

uses DB, PersistentObjects, DBGate, BaseObjects, SysUtils;

type

  TLithologyDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses Lithology, Facade;

{ TLithologyDataPoster }

constructor TLithologyDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_LITHOLOGY_DICT';

  KeyFieldNames := 'ROCK_ID';
  FieldNames := 'ROCK_ID, VCH_ROCK_NAME';

  AccessoryFieldNames := 'ROCK_ID, VCH_ROCK_NAME';
  AutoFillDates := false;

  Sort := 'VCH_ROCK_NAME';
end;

function TLithologyDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TLithologyDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TLithology;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TLithology;

      o.ID := ds.FieldByName('ROCK_ID').AsInteger;
      o.Name := AnsiLowerCase(trim(ds.FieldByName('VCH_ROCK_NAME').AsString));

      ds.Next;
    end;

    ds.First;
  end;
end;

function TLithologyDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

end.
