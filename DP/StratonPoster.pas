unit StratonPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, Straton;

type
  TTaxonomyTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TStratTaxonomyDataPoster = class(TImplementedDataPoster)
  private
    FAllTaxonomyTypes: TTaxonomyTypes;
    procedure SetAllTaxonomyTypes(const Value: TTaxonomyTypes);
  public
    property AllTaxonomyTypes: TTaxonomyTypes read FAllTaxonomyTypes write SetAllTaxonomyTypes;
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TSimpleStratonDataPoster = class(TImplementedDataPoster)
  private
    FAllStratTaxonomies: TStratTaxonomies;
    procedure SetAllStratTaxonomies(const Value: TStratTaxonomies);
  public
    property AllStratTaxonomies: TStratTaxonomies read FAllStratTaxonomies write SetAllStratTaxonomies;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TStratigraphicSchemeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TStratotypeRegionDataPoster = class(TImplementedDataPoster)
  private
    FAllSimpleStratons: TSimpleStratons;
    procedure SetAllSimpleStratons(const Value: TSimpleStratons);
  public
    property AllSimpleStratons: TSimpleStratons read FAllSimpleStratons write SetAllSimpleStratons;
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TStratonDataPoster = class(TImplementedDataPoster)
  private
    FAllStratigraphicSchemes: TStratigraphicSchemes;
    FAllStratotyRegions: TStratotypeRegions;
    FAllSimpleStratons: TSimpleStratons;
    FAllChild: TStratons;
    FAllStratTaxonomies: TStratTaxonomies;

    procedure SetAllSimplStratons(const Value: TSimpleStratons);
    procedure SetAllStratigraphicSchemes(const Value: TStratigraphicSchemes);
    procedure SetAllStratotyRegions(const Value: TStratotypeRegions);
    procedure SetAllChild(const Value: TStratons);
    procedure SetAllStratTaxonomies(const Value: TStratTaxonomies);

  public
    property AllStratigraphicSchemes: TStratigraphicSchemes read FAllStratigraphicSchemes write SetAllStratigraphicSchemes;
    property AllStratotypeRegions: TStratotypeRegions read FAllStratotyRegions write SetAllStratotyRegions;
    property AllSimpleStratons: TSimpleStratons read FAllSimpleStratons write SetAllSimplStratons;
    
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  

implementation

uses Facade, SysUtils, SDFacade;

var flag: Boolean;

{ TSimpleStratonDataPoster }

constructor TSimpleStratonDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_STRATIGRAPHY_NAME_DICT';
  //DataDeletionString := '';
  //DataPostString := '';

  KeyFieldNames := 'STRATON_ID';
  FieldNames := 'STRATON_ID, TAXONOMY_UNIT_ID, VCH_STRATON_INDEX, VCH_STRATON_DEFINITION, VCH_COLOR, VCH_DECORATED_STRATON_INDEX';

  AccessoryFieldNames := 'STRATON_ID, TAXONOMY_UNIT_ID, VCH_STRATON_INDEX, VCH_STRATON_DEFINITION, VCH_COLOR, VCH_DECORATED_STRATON_INDEX';
  AutoFillDates := false;

  Sort := 'VCH_STRATON_INDEX';
end;

function TSimpleStratonDataPoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TSimpleStratonDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TSimpleStraton;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    if Assigned(AObjects) then
    while not ds.Eof do
    begin
      o := AObjects.Add as TSimpleStraton;

      o.ID := ds.FieldByName('STRATON_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_STRATON_INDEX').AsString);
      o.DecoratedIndex := ds.FieldByName('VCH_DECORATED_STRATON_INDEX').AsString;
      o.Definition := ds.FieldByName('VCH_STRATON_DEFINITION').AsString;
      o.Color := ds.FieldByName('VCH_COLOR').AsString;
      o.Taxonomy := (TMainFacade.GetInstance as TMainFacade).AllStratTaxonomies.ItemsByID[ds.FieldByName('TAXONOMY_UNIT_ID').AsInteger] as TStratTaxonomy;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TSimpleStratonDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TSimpleStraton;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TSimpleStraton;

  ds.FieldByName('STRATON_ID').Value := o.ID;
  ds.FieldByName('VCH_STRATON_INDEX').Value := o.Name;
  ds.FieldByName('VCH_DECORATED_STRATON_INDEX').Value := o.DecoratedIndex;
  ds.FieldByName('VCH_STRATON_DEFINITION').Value := o.Definition;
  ds.FieldByName('VCH_COLOR').Value := o.Color;
  ds.FieldByName('TAXONOMY_UNIT_ID').Value := o.Taxonomy.ID;

  ds.Post;

  o.ID := ds.FieldByName('STRATON_ID').AsInteger;
end;

procedure TSimpleStratonDataPoster.SetAllStratTaxonomies(
  const Value: TStratTaxonomies);
begin
  if FAllStratTaxonomies <> Value then
    FAllStratTaxonomies := Value;
end;

{ TStratTaxonomyDataPoster }

constructor TStratTaxonomyDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_TAXONOMY_DICT';

  KeyFieldNames := 'TAXONOMY_UNIT_ID';
  FieldNames := 'TAXONOMY_UNIT_ID, VCH_TAXONOMY_UNIT_NAME, TAXONOMY_UNIT_TYPE_ID, NUM_RANGE';

  AccessoryFieldNames := 'TAXONOMY_UNIT_ID, VCH_TAXONOMY_UNIT_NAME,  TAXONOMY_UNIT_TYPE_ID, NUM_RANGE';
  AutoFillDates := false;

  Sort := 'VCH_TAXONOMY_UNIT_NAME';
end;

function TStratTaxonomyDataPoster.DeleteFromDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TStratTaxonomyDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TStratTaxonomy;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    if Assigned(AObjects) then
    while not ds.Eof do
    begin
      o := AObjects.Add as TStratTaxonomy;

      o.ID := ds.FieldByName('TAXONOMY_UNIT_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_TAXONOMY_UNIT_NAME').AsString);
      o.TaxonomyType := (TMainFacade.GetInstance as TMainFacade).AllStratTaxonomyTypes.ItemsByID[ds.FieldByName('TAXONOMY_UNIT_TYPE_ID').AsInteger] as TTaxonomyType;
      o.Range := ds.FieldByName('NUM_RANGE').AsInteger;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TStratTaxonomyDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    a: TStratTaxonomy;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  a := AObject as TStratTaxonomy;

  ds.FieldByName('TAXONOMY_UNIT_ID').Value := a.ID;
  ds.FieldByName('VCH_TAXONOMY_UNIT_NAME').Value := trim(a.Name);
  ds.FieldByName('TAXONOMY_UNIT_TYPE_ID').Value := a.TaxonomyType.ID;
  ds.FieldByName('NUM_RANGE').Value := a.Range;


  ds.Post;

  a.ID := ds.FieldByName('TAXONOMY_UNIT_ID').AsInteger;
end;

procedure TStratTaxonomyDataPoster.SetAllTaxonomyTypes(
  const Value: TTaxonomyTypes);
begin
  if FAllTaxonomyTypes <> Value then
    FAllTaxonomyTypes := Value;
end;

{ TStratonDataPoster }

constructor TStratonDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_STRATON_PROPERTIES';

//  DataPostString := 'TBL_STRATON_PROPERTIES';
//  DataDeletionString :=  'TBL_STRATON_PROPERTIES';

  KeyFieldNames := 'STRATON_REGION_ID';
  FieldNames := 'STRATON_REGION_ID, SCHEME_ID, REGION_ID, STRATON_ID, NUM_AGE_OF_BASE, ' +
  'NUM_AGE_OF_TOP, VCH_STRATON_DEF_SYNONYM, VCH_SYNONYM_AUTHOR, NUM_DOUBTFUL_BASE, NUM_DOUBTFUL_AGES, NUM_NOT_AFFIRMED, VCH_BASE9_VOLUME, VCH_TOP9_VOLUME, BASE_STRATON_REGION_ID, TOP_STRATON_REGION_ID';

  AccessoryFieldNames := 'STRATON_REGION_ID, SCHEME_ID, REGION_ID, STRATON_ID, NUM_AGE_OF_BASE' +
  ' NUM_AGE_OF_TOP, VCH_STRATON_DEF_SYNONYM, VCH_SYNONYM_AUTHOR, NUM_DOUBTFUL_BASE, NUM_DOUBTFUL_AGES, NUM_NOT_AFFIRMED, VCH_BASE9_VOLUME, VCH_TOP9_VOLUME, BASE_STRATON_REGION_ID, TOP_STRATON_REGION_ID';
  AutoFillDates := false;

  Sort := 'NUM_AGE_OF_BASE';
end;

function TStratonDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TStratonDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TStraton;
begin
  Assert(Assigned(AllSimpleStratons));
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if flag = false then

  if not ds.Eof then
  begin
    ds.First;

    if Assigned(AObjects) then
    while not ds.Eof do
    begin
      o := AObjects.Add as TStraton;
      // AObjects.Add(Found, False, False) - это для ChildStratonPoster - после того как мы нашли Found по Straton_Region_ID
      o.Name := (AllSimpleStratons.ItemsByID[ds.FieldByName('STRATON_ID').AsInteger] as TSimpleStraton).Name;
      o.ID := ds.FieldByName('STRATON_REGION_ID').AsInteger;
      o.Straton := AllSimpleStratons.ItemsByID[ds.FieldByName('STRATON_ID').AsInteger] as TSimpleStraton;
      o.BaseStraton := TEmptyStraton.Create(ds.FieldByName('BASE_STRATON_REGION_ID').AsInteger);
      o.TopStraton := TEmptyStraton.Create(ds.FieldByName('TOP_STRATON_REGION_ID').AsInteger);
      if Assigned(AllStratigraphicSchemes) then
        o.Scheme := AllStratigraphicSchemes.ItemsByID[ds.FieldByName('SCHEME_ID').AsInteger] as TStratigraphicScheme;
      if Assigned(AllStratotypeRegions) then
        o.Region := AllStratotypeRegions.ItemsByID[ds.FieldByName('REGION_ID').AsInteger] as TStratotypeRegion;
      o.AgeOfBase := ds.FieldByName('NUM_AGE_OF_BASE').AsFloat;
      o.AgeOfTop := ds.FieldByName('NUM_AGE_OF_TOP').AsFloat;
      o.StratonDefSynonym := ds.FieldByName('VCH_STRATON_DEF_SYNONYM').AsString;
      o.SynonymAuthor := ds.FieldByName('VCH_SYNONYM_AUTHOR').AsString;
      o.DoubtfulBase := ds.FieldByName('NUM_DOUBTFUL_BASE').AsInteger;
      o.DoubtfulAges := ds.FieldByName('NUM_DOUBTFUL_AGES').AsInteger;
      o.NotAffirmed := ds.FieldByName('NUM_NOT_AFFIRMED').AsInteger;
      o.Base9Volume := ds.FieldByName('VCH_BASE9_VOLUME').AsString;
      o.Top9Volume := ds.FieldByName('VCH_TOP9_VOLUME').AsString;

      ds.Next;
    end;

    ds.First;
  end;

  flag := False;
end;

function TStratonDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    a: TStraton;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  a := AObject as TStraton;

  ds.FieldByName('STRATON_REGION_ID').Value := a.ID;
  ds.FieldByName('STRATON_ID').Value := a.Straton.ID;
  ds.FieldByName('BASE_STRATON_REGION_ID').Value := a.BaseStraton.ID;

  ds.FieldByName('TOP_STRATON_REGION_ID').Value := a.TopStraton.ID;
  ds.FieldByName('SCHEME_ID').Value := a.Scheme.ID;
  ds.FieldByName('REGION_ID').Value := a.Region.ID;
  ds.FieldByName('NUM_AGE_OF_BASE').Value := a.AgeOfBase;
  ds.FieldByName('NUM_AGE_OF_TOP').Value := a.AgeOfTop;
  ds.FieldByName('VCH_STRATON_DEF_SYNONYM').Value := a.StratonDefSynonym;
  ds.FieldByName('VCH_SYNONYM_AUTHOR').Value := a.SynonymAuthor;
  ds.FieldByName('NUM_DOUBTFUL_BASE').Value := a.DoubtfulBase;
  ds.FieldByName('NUM_DOUBTFUL_AGES').Value := a.DoubtfulAges;
  ds.FieldByName('NUM_NOT_AFFIRMED').Value := a.NotAffirmed;
  ds.FieldByName('VCH_BASE9_VOLUME').Value := a.Base9Volume;
  ds.FieldByName('VCH_TOP9_VOLUME').Value := a.Top9Volume;

  ds.Post;

  a.ID := ds.FieldByName('STRATON_REGION_ID').AsInteger;
end;

procedure TStratonDataPoster.SetAllChild(const Value: TStratons);
begin
  if FAllChild <> Value then
    FAllChild := Value;
end;

procedure TStratonDataPoster.SetAllSimplStratons(
  const Value: TSimpleStratons);
begin
  if FAllSimpleStratons <> Value then
    FAllSimpleStratons := Value;
end;

procedure TStratonDataPoster.SetAllStratigraphicSchemes(
  const Value: TStratigraphicSchemes);
begin
  if FAllStratigraphicSchemes <> Value then
    FAllStratigraphicSchemes := Value;
end;

procedure TStratonDataPoster.SetAllStratotyRegions(
  const Value: TStratotypeRegions);
begin
  if FAllStratotyRegions <> Value then
    FAllStratotyRegions := Value;
end;

{procedure TStratonDataPoster.SetAllTaxonomies(
  const Value: TStratTaxonomies);
begin
  if FAllTaxonomies <> Value then
    FAllTaxonomies := Value;
end;
 }

 {
procedure TStratonDataPoster.SetAllTaxonomyTypes(
  const Value: TTaxonomyTypes);
begin
  if FAllTaxonomyTypes <> Value then
    FAllTaxonomyTypes := Value;
end;
}
constructor TTaxonomyTypeDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_TAXONOMY_TYPE_DICT';

  KeyFieldNames := 'TAXONOMY_UNIT_TYPE_ID';
  FieldNames := 'TAXONOMY_UNIT_TYPE_ID, VCH_TAXONOMY_UNIT_TYPE_NAME, NUM_DIVISION_ASPECT';

  AccessoryFieldNames := 'TAXONOMY_UNIT_TYPE_ID, VCH_TAXONOMY_UNIT_TYPE_NAME, NUM_DIVISION_ASPECT';
  AutoFillDates := false;

  Sort := 'VCH_TAXONOMY_UNIT_TYPE_NAME';
end;

function TTaxonomyTypeDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TTaxonomyTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TTaxonomyType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    if Assigned(AObjects) then
    while not ds.Eof do
    begin
      o := AObjects.Add as TTaxonomyType;

      o.ID := ds.FieldByName('TAXONOMY_UNIT_TYPE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_TAXONOMY_UNIT_TYPE_NAME').AsString);
      o.DivisionAspect := ds.FieldByName('NUM_DIVISION_ASPECT').AsInteger;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TTaxonomyTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    a: TTaxonomyType;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  a := AObject as TTaxonomyType;

  ds.FieldByName('TAXONOMY_UNIT_TYPE_ID').Value := a.ID;
  ds.FieldByName('VCH_TAXONOMY_UNIT_TYPE_NAME').Value := trim(a.Name);
  ds.FieldByName('NUM_DIVISION_ASPECT').Value := a.DivisionAspect;

  ds.Post;

  a.ID := ds.FieldByName('TAXONOMY_UNIT_TYPE_ID').AsInteger;
end;


procedure TStratonDataPoster.SetAllStratTaxonomies(
  const Value: TStratTaxonomies);
begin
  FAllStratTaxonomies := Value;
end;

{ TStratigraphicSchemeDataPoster }

constructor TStratigraphicSchemeDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_STRATIGRAPHIC_SCHEME_DICT';

  KeyFieldNames := 'SCHEME_ID';
  FieldNames := 'SCHEME_ID, VCH_SCHEME_NAME, NUM_AFFIRMATION_YEAR, VCH_DESCRIPTION';

  AccessoryFieldNames := 'SCHEME_ID, VCH_SCHEME_NAME, NUM_AFFIRMATION_YEAR, VCH_DESCRIPTION';
  AutoFillDates := false;

  Sort := 'SCHEME_ID';
end;

function TStratigraphicSchemeDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TStratigraphicSchemeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TStratigraphicScheme;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    if Assigned(AObjects) then
    while not ds.Eof do
    begin
      o := AObjects.Add as TStratigraphicScheme;

      o.ID := ds.FieldByName('SCHEME_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_SCHEME_NAME').AsString);
      o.AffirmationYear := ds.FieldByName('NUM_AFFIRMATION_YEAR').AsInteger;
      o.Description := trim(ds.FieldByName('VCH_DESCRIPTION').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TStratigraphicSchemeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    a: TStratigraphicScheme;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  a := AObject as TStratigraphicScheme;

  ds.FieldByName('SCHEME_ID').Value := a.ID;
  ds.FieldByName('VCH_SCHEME_NAME').Value := trim(a.Name);
  ds.FieldByName('NUM_AFFIRMATION_YEAR').Value := a.AffirmationYear;
  ds.FieldByName('VCH_DESCRIPTION').Value := trim(a.Description);;

  ds.Post;

  a.ID := ds.FieldByName('SCHEME_ID').AsInteger;
end;

{ TStratotypeRegionDataPoster }

constructor TStratotypeRegionDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_STRATOTYPE_REGION_DICT';

  KeyFieldNames := 'REGION_ID';
  FieldNames := 'REGION_ID, STRATON_ID, VCH_REGION_NAME';

  AccessoryFieldNames := 'REGION_ID, STRATON_ID, VCH_REGION_NAME';
  AutoFillDates := false;

  Sort := 'REGION_ID';
end;

function TStratotypeRegionDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TStratotypeRegionDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TStratotypeRegion;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    if Assigned(AObjects) then
    while not ds.Eof do
    begin
      o := AObjects.Add as TStratotypeRegion;

      o.ID := ds.FieldByName('REGION_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_REGION_NAME').AsString);
      o.Straton := (TMainFacade.GetInstance as TMainFacade).AllSimpleStratons.ItemsByID[ds.FieldByName('STRATON_ID').AsInteger] as TSimpleStraton;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TStratotypeRegionDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    a: TStratotypeRegion;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  a := AObject as TStratotypeRegion;

  ds.FieldByName('REGION_ID').Value := a.ID;
  ds.FieldByName('VCH_REGION_NAME').Value := trim(a.Name);
  ds.FieldByName('STRATON_ID').Value := a.Straton.ID;


  ds.Post;

  a.ID := ds.FieldByName('REGION_ID').AsInteger;
end;

procedure TStratotypeRegionDataPoster.SetAllSimpleStratons(
  const Value: TSimpleStratons);
begin
  if FAllSimpleStratons <> Value then
    FAllSimpleStratons := Value;
end;


end.

