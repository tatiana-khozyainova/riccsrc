unit TopoListDataPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, Topolist;


type

  TTopolistDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses Facade, SysUtils;

{ TTopolistDataPoster }

constructor TTopolistDataPoster.Create;
begin
  inherited;
  Options := [];
  DataSourceString := 'TBL_TOPOGRAPHICAL_LIST_DICT';
  DataDeletionString := '';
  DataPostString := '';

  KeyFieldNames := 'TOPOGRAPHICAL_LIST_ID';
  FieldNames := 'TOPOGRAPHICAL_LIST_ID, VCH_TOPOGRAPHICAL_LIST_NAME';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_TOPOGRAPHICAL_LIST_NAME';

end;

function TTopolistDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TTopolistDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TTopographicalList;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TTopographicalList;

      o.ID := ds.FieldByName('TOPOGRAPHICAL_LIST_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_TOPOGRAPHICAL_LIST_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;

end;

function TTopolistDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

end.
