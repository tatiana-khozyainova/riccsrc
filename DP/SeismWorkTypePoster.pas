unit SeismWorkTypePoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, SysUtils;

type
  TSeismWorkTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses SeismWorkType, Facade;

{ TSeismWorkTypeDataPoster }

constructor TSeismWorkTypeDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_SEISWORK_TYPE';

  KeyFieldNames := 'SEIS_WORK_TYPE_ID';
  FieldNames := 'SEIS_WORK_TYPE_ID, VCH_SEISWORK_TYPE_NAME';

  AccessoryFieldNames := 'SEIS_WORK_TYPE_ID, VCH_SEISWORK_TYPE_NAME';
  AutoFillDates := false;

  Sort := 'VCH_SEISWORK_TYPE_NAME';
end;

function TSeismWorkTypeDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TSeismWorkTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TSimpleSeismWorkType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if Assigned(AObjects) and (not ds.Eof) then
  begin
    ds.First;


    while not ds.Eof do
    begin
      o := AObjects.Add as TSimpleSeismWorkType;

      o.ID := ds.FieldByName('SEIS_WORK_TYPE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_SEISWORK_TYPE_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TSeismWorkTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    a: TSeismWorkType;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  a := AObject as TSeismWorkType;

  ds.FieldByName('SEIS_WORK_TYPE_ID').Value := a.ID;
  ds.FieldByName('VCH_SEISWORK_TYPE_NAME').Value := trim(a.Name);

  ds.Post;

  a.ID := ds.FieldByName('SEIS_WORK_TYPE_ID').AsInteger;
end;

end.
