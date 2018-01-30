unit TypeResearchPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, TypeResearch;

type

  TTypeResearchDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;override;

    constructor Create; override;
  end;

  TRockSampleResearchDataPoster = class(TImplementedDataPoster)
  private
    FTypeResearchs: TTypeResearchs;
    procedure SetTypeResearchs(const Value: TTypeResearchs);
  public
    property TypeResearchs: TTypeResearchs read FTypeResearchs write SetTypeResearchs;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;

    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function PostToDB(ACollection: TIDObjects; AOwner: TIDObject): integer; overload; override;

    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;override;
    function DeleteFromDB(ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses facade, SysUtils, RockSample, Classes, Variants;

{ TTypeResearchDataPoster }

constructor TTypeResearchDataPoster.Create;
begin
  inherited;
  Options := [soKeyInsert];
  DataSourceString := 'TBL_RESEARCH_DICT';

  KeyFieldNames := 'RESEARCH_ID';
  FieldNames := 'RESEARCH_ID, VCH_RESEARCH_NAME';

  AccessoryFieldNames := 'RESEARCH_ID, VCH_RESEARCH_NAME';
  AutoFillDates := false;

  Sort := 'RESEARCH_ID';
end;

function TTypeResearchDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TTypeResearchDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TTypeResearch;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TTypeResearch;

      o.ID := ds.FieldByName('RESEARCH_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_RESEARCH_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TTypeResearchDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

{ TRockSimpleResearchDataPoster }

constructor TRockSampleResearchDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_ROCK_SAMPLE_RESEARCH';

  KeyFieldNames := 'ROCK_SAMPLE_UIN; RESEARCH_ID';
  FieldNames := 'ROCK_SAMPLE_UIN, RESEARCH_ID';

  AccessoryFieldNames := 'ROCK_SAMPLE_UIN, RESEARCH_ID';
  AutoFillDates := false;

  Sort := 'RESEARCH_ID';
end;

function TRockSampleResearchDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TRockSampleResearchDataPoster.DeleteFromDB(
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TRockSampleResearchDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o : TRockSampleResearch;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TRockSampleResearch;

      o.Assign(TypeResearchs.ItemsByID[ds.FieldByName('RESEARCH_ID').asInteger]);
      o.Research := true;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TRockSampleResearchDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TRockSampleResearch;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TRockSampleResearch;

  while not varIsNull(ds.FieldByName('ROCK_SAMPLE_UIN').Value) do ds.Append;

  ds.FieldByName('ROCK_SAMPLE_UIN').Value := o.Collection.Owner.ID;
  ds.FieldByName('RESEARCH_ID').Value := o.ID;

  ds.Post;
end;

function TRockSampleResearchDataPoster.PostToDB(ACollection: TIDObjects;
  AOwner: TIDObject): integer;
var ds: TDataSet;
    i: integer;
    o: TRockSample;
    os: TRockSampleResearchs;
begin
  Result := 0;
  ds := TMainFacade.GetInstance.DBGates.Add(Self);
  if not ds.Active then ds.Open;

  o := AOwner as TRockSample;
  os := ACollection as TRockSampleResearchs;

  try
    while ds.Locate('ROCK_SAMPLE_UIN', o.ID, []) do
      ds.Delete;
  except
    on E: Exception do
    begin
      //
    end;
  end;

  for i := 0 to os.Count - 1 do
  begin
    ds.Append;

    while not varIsNull(ds.FieldByName('ROCK_SAMPLE_UIN').Value) do ds.Append;

    ds.FieldByName('ROCK_SAMPLE_UIN').Value := o.ID;
    ds.FieldByName('RESEARCH_ID').Value := os.Items[i].ID;

    ds.Post;
  end
end;

procedure TRockSampleResearchDataPoster.SetTypeResearchs(
  const Value: TTypeResearchs);
begin
  if FTypeResearchs <> Value then
    FTypeResearchs := Value;
end;

end.
