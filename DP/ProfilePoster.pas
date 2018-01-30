unit ProfilePoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, Profile;

type
  TProfileDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses Facade, SysUtils;

{ TProfileDataPoster }

constructor TProfileDataPoster.Create;
begin
  inherited;
  Options := [];
  DataSourceString := 'TBL_PROFILE_DICT';
  DataDeletionString := '';
  DataPostString := '';

  KeyFieldNames := 'PROFILE_ID';
  FieldNames := 'PROFILE_ID, VCH_PROFILE_NAME';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_PROFILE_NAME';
end;

function TProfileDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TProfileDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TProfile;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TProfile;

      o.ID := ds.FieldByName('PROFILE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_PROFILE_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TProfileDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

end.
