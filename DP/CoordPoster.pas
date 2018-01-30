unit CoordPoster;

interface

uses DBGate, BaseObjects, PersistentObjects, DB, Coord;

type
    // для источника координат скважин
  TSourceCoordDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  // для координат скважин
  TWellCoordDataPoster = class(TImplementedDataPoster)
  private
    FAllSourcesCoord: TSourceCoords;
    procedure SetAllSourcesCoord(const Value: TSourceCoords);
  public
    property AllSourcesCoord: TSourceCoords read FAllSourcesCoord write SetAllSourcesCoord;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses Facade, SysUtils;

{ TWellCoordDataPoster }

constructor TWellCoordDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_OBJECT_RESEARCH';

  KeyFieldNames := 'OBJECT_UIN';
  FieldNames := 'OBJECT_UIN, NUM_OBJECT_TYPE, NUM_OBJECT_SUBTYPE, NUM_ZONE_NUMBER, NUM_RESEARCH_RESULT_X, NUM_RESEARCH_RESULT_Y, DTM_ENTERING_DATE, SOURCE_ID';

  AccessoryFieldNames := 'OBJECT_UIN, NUM_OBJECT_TYPE, NUM_OBJECT_SUBTYPE, NUM_ZONE_NUMBER, NUM_RESEARCH_RESULT_X, NUM_RESEARCH_RESULT_Y, SOURCE_ID';
  AutoFillDates := false;

  Sort := 'OBJECT_UIN';
end;

function TWellCoordDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  inherited DeleteFromDB(AObject, ACollection);
end;

function TWellCoordDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TWellCoord;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TWellCoord;

      o.ID := ds.FieldByName('OBJECT_UIN').AsInteger;
      o.NUM_OBJECT_SUBTYPE := ds.FieldByName('NUM_OBJECT_SUBTYPE').AsInteger;
      o.NUM_ZONE_NUMBER := ds.FieldByName('NUM_ZONE_NUMBER').AsInteger;
      o.coordX := ds.FieldByName('NUM_RESEARCH_RESULT_X').AsFloat;
      o.coordY := ds.FieldByName('NUM_RESEARCH_RESULT_Y').AsFloat;
      o.dtmEnteringDate := ds.FieldByName('DTM_ENTERING_DATE').AsDateTime;

      if Assigned (FAllSourcesCoord) then
        o.SourceCoord := FAllSourcesCoord.ItemsByID[ds.FieldByName('SOURCE_ID').AsInteger] as TSourceCoord;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TWellCoordDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TWellCoord;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TWellCoord;

  ds.FieldByName('OBJECT_UIN').Value := o.Collection.Owner.ID;
  ds.FieldByName('NUM_OBJECT_TYPE').Value := 1;
  ds.FieldByName('NUM_RESEARCH_RESULT_X').Value := o.coordX;
  ds.FieldByName('NUM_RESEARCH_RESULT_Y').Value := o.coordY;
  ds.FieldByName('NUM_ZONE_NUMBER').Value := 10;

  if Assigned (o.SourceCoord) then
    ds.FieldByName('SOURCE_ID').Value := o.SourceCoord.ID;

  ds.Post;
end;

procedure TWellCoordDataPoster.SetAllSourcesCoord(
  const Value: TSourceCoords);
begin
  if FAllSourcesCoord <> Value then
    FAllSourcesCoord := Value;
end;

{ TSourceCoordDataPoster }

constructor TSourceCoordDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soKeyInsert];
  DataSourceString := 'TBL_SOURCE_DICT';

  KeyFieldNames := 'SOURCE_ID';
  FieldNames := 'SOURCE_ID, VCH_SOURCE_NAME';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_SOURCE_NAME';
end;

function TSourceCoordDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TSourceCoordDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TSourceCoord;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TSourceCoord;

      o.ID := ds.FieldByName('SOURCE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_SOURCE_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TSourceCoordDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

end.
