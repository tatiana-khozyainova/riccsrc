unit PerforatorPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, Fluid;

type
  TPerforatorDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;




implementation

uses Perforator, Facade, SysUtils;

{ TPerforatorDataPoster }

constructor TPerforatorDataPoster.Create;
begin
  inherited;

  Options := [soSingleDataSource];
  DataSourceString := 'TBL_PERFORATOR_TYPE_DICT';

  KeyFieldNames := 'PERFORATOR_TYPE_ID';
  FieldNames := 'PERFORATOR_TYPE_ID, VCH_PERFORATOR_TYPE';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_PERFORATOR_TYPE';
end;

function TPerforatorDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TPerforatorDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TPerforatorType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TPerforatorType;
      o.ID := ds.FieldByName('PERFORATOR_TYPE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_PERFORATOR_TYPE').AsString);
      ds.Next;
    end;

    ds.First;
  end;
end;

function TPerforatorDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

end.
