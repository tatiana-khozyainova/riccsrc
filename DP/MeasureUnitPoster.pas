unit MeasureUnitPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, MeasureUnits;

type

  TMeasureUnitDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses Facade, SysUtils;

{ TUnitDataPoster }

constructor TMeasureUnitDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_MEASURE_UNIT_DICT';

  KeyFieldNames := 'MEASURE_UNIT_ID';
  FieldNames := 'MEASURE_UNIT_ID, VCH_MEASURE_UNIT_NAME';

  AccessoryFieldNames := 'MEASURE_UNIT_ID, VCH_MEASURE_UNIT_NAME';
  AutoFillDates := false;

  Sort := 'VCH_MEASURE_UNIT_NAME';
end;

function TMeasureUnitDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TMeasureUnitDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TMeasureUnit;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TMeasureUnit;

      o.ID := ds.FieldByName('MEASURE_UNIT_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_MEASURE_UNIT_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TMeasureUnitDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TMeasureUnit;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := TMeasureUnit(AObject);

  ds.FieldByName('MEASURE_UNIT_ID').AsInteger := o.ID;
  ds.FieldByName('VCH_MEASURE_UNIT_NAME').AsString := trim (o.Name);

  ds.Post;

  o.ID := ds.FieldByName('MEASURE_UNIT_ID').AsInteger;
  //if o.ID <= 0 then o.ID := (ds as TCommonServerDataSet).CurrentRecordFilterValues[0];
end;

end.
