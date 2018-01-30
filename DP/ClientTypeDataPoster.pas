unit ClientTypeDataPoster;

interface

uses PersistentObjects, BaseObjects, DBGate, DB;


type

  TClientTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses ClientType, Facade;

{ TVersionDataPoster }

constructor TClientTypeDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_CLIENT_APP_TYPE';

  KeyFieldNames := 'CLIENT_APP_TYPE_ID';
  FieldNames := 'CLIENT_APP_TYPE_ID, VCH_CLIENT_APP_TYPE';
  AccessoryFieldNames := FieldNames;
  AutoFillDates := false;

  Sort := '';
end;

function TClientTypeDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TClientTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    ct: TClientType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  if Assigned(AObjects) then
  begin
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    if not ds.Eof then
    begin
      ds.First;

      while not ds.Eof do
      begin
        ct := AObjects.Add as TClientType;
        ct.ID := ds.FieldByName('CLIENT_APP_TYPE_ID').AsInteger;
        ct.Name := ds.FieldByName('VCH_CLIENT_APP_TYPE').AsString; 
        ds.Next;
      end;

      ds.First;
    end;
  end;
end;

function TClientTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

end.
