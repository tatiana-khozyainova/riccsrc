unit DistrictPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, District;

type
  TDistrictDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses Facade, SysUtils;

{ TDistrictDataPoster }

constructor TDistrictDataPoster.Create;
begin
  inherited;
  Options := [];
  DataSourceString := 'TBL_DISTRICT_DICT';
  DataDeletionString := '';
  DataPostString := '';

  KeyFieldNames := 'DISTRICT_ID';
  FieldNames := 'DISTRICT_ID, VCH_DISTRICT_NAME, MAIN_DISTRICT_ID, NUM_DISTRICT_TYPE';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_DISTRICT_NAME';
end;

function TDistrictDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TDistrictDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TDistrict;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TDistrict;
      o.ID := ds.FieldByName('DISTRICT_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_DISTRICT_NAME').AsString);
      if not ds.FieldByName('MAIN_DISTRICT_ID').IsNull then
        o.MainDistrictID := ds.FieldByName('MAIN_DISTRICT_ID').AsInteger
      else
        o.MainDistrictID := -1;
        
      o.DistrictType := TDistrictType(ds.FieldByName('NUM_DISTRICT_TYPE').AsInteger);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TDistrictDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

end.
