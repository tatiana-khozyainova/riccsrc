unit AreaPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, SysUtils;

type
  TAreaDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses Area, Facade;

{ TAreaDataPoster }

constructor TAreaDataPoster.Create;
begin
  inherited;
  Options := [];
  DataSourceString := 'TBL_AREA_DICT';
  DataPostString := '';
  DataDeletionString := '';

  KeyFieldNames := 'AREA_ID';
  FieldNames := 'AREA_ID, VCH_AREA_NAME';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_AREA_NAME';
end;

function TAreaDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TAreaDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TSimpleArea;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TSimpleArea;

      o.ID := ds.FieldByName('AREA_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_AREA_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TAreaDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    a: TArea;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  a := AObject as TArea;

  ds.FieldByName('AREA_ID').Value := a.ID;
  ds.FieldByName('VCH_AREA_NAME').Value := trim(a.Name);

  ds.Post;

  a.ID := ds.FieldByName('AREA_ID').AsInteger;
end;

end.
