unit Straton;

interface

uses Registrator, BaseObjects, Classes;

type

  TStratons = class;

  TTaxonomyType = class(TRegisteredIDObject)
  private
    FDivisionAspect: integer;
  protected
    procedure AssignTo (Dest: TPersistent); override;
  public
    property DivisionAspect: integer read FDivisionAspect write FDivisionAspect;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TTaxonomyTypes = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TTaxonomyType;
  public
    property Items[Index: integer]: TTaxonomyType read GetItems;
    constructor Create; override;
  end;



  TStratTaxonomy = class(TRegisteredIDObject)
  private
    FRange: Integer;
    FTaxonomyType: TTaxonomyType;
  protected
    procedure AssignTo (Dest: TPersistent); override;
  public
    property TaxonomyType: TTaxonomyType read FTaxonomyType write FTaxonomyType;
    property Range: Integer read FRange write FRange;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TStratTaxonomies = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TStratTaxonomy;
  public
    property Items[Index: integer]: TStratTaxonomy read GetItems;
    constructor Create; override;
  end;

  TSimpleStraton = class(TRegisteredIDObject)
  private
    FDefinition: string;
    FDecoratedIndex: string;
    FColor: string;
    FTaxonomy: TStratTaxonomy;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
    function GetColor: string; virtual;
    function GetDecoratedIndex: string; virtual;
    function GetDefinition: string; virtual;
    function GetTaxonomy: TStratTaxonomy; virtual;
    procedure SetColor(const Value: string); virtual;
    procedure SetDecoratedIndex(const Value: string); virtual;
    procedure SetDefinition(const Value: string); virtual;
    procedure SetTaxonomy(const Value: TStratTaxonomy); virtual;

  public
    property Definition: string read GetDefinition write SetDefinition;
    property DecoratedIndex: string read GetDecoratedIndex write SetDecoratedIndex;
    property Color: string read GetColor write SetColor;
    property Taxonomy: TStratTaxonomy read GetTaxonomy write SetTaxonomy;

    function    List(AListOption: TListOption = loBrief): string; override;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TSimpleStratons = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TSimpleStraton;
  public
    procedure Reload; override;
    procedure MakeMainStratonList(ALst: TStrings; NeedsRegistering: boolean = true; NeedsClearing: boolean = true);

    property  Items[Index: integer]: TSimpleStraton read GetItems;
    constructor Create; override;
  end;


  TStratigraphicScheme = class(TRegisteredIDObject)
  private
      FAffirmationYear: Integer;
      FDescription: string;
  protected
      procedure AssignTo (Dest: TPersistent); override;
  public
      property AffirmationYear: Integer read FAffirmationYear write FAffirmationYear;
      property Description: string read FDescription write FDescription;
      constructor Create(ACollection: TIDObjects); override;
  end;


  TStratigraphicSchemes = class(TRegisteredIDObjects)
  private
      function GetItems(Index: integer): TStratigraphicScheme;
  public
      property Items[Index: integer]: TStratigraphicScheme read GetItems;
      constructor Create; override;
  end;

    TStratotypeRegion = class(TRegisteredIDObject)
  private
      FSimpleStraton: TSimpleStraton;
  protected
      procedure AssignTo (Dest: TPersistent); override;
  public
      property Straton: TSimpleStraton read FSimpleStraton write FSimpleStraton;
      constructor Create(ACollection: TIDObjects); override;
  end;


  TStratotypeRegions = class(TRegisteredIDObjects)
  private
      function GetItems(Index: integer): TStratotypeRegion;
  public
      property Items[Index: integer]: TStratotypeRegion read GetItems;
      constructor Create; override;
  end;

  TStraton = class(TSimpleStraton)
  private
    FStraton: TSimpleStraton;
    FBaseStraton: TStraton;
    FTopStraton: TStraton;
    FScheme: TStratigraphicScheme;
    FRegion: TStratotypeRegion;
    FAgeOfBase: single;
    FAgeOfTop: single;
    FStratonDefSynonym: string;
    FSynonymAuthor: string;
    FDoubtFulBase: Integer;
    FDoubtFulAges: Integer;
    FNotAffirmed: Integer;
    FBase9Volume: string;
    FTop9Volume: string;
    FLastError: string;

    function GetBaseChildren: TStratons;
    function GetTopChildren: TStratons;

    function GetBaseStraton: TStraton;
    function GetTopStraton: TStraton;
    function GetError: Boolean;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
    function GetColor: string; override;
    function GetDecoratedIndex: string; override;
    function GetDefinition: string; override;
    function GetTaxonomy: TStratTaxonomy; override;
    procedure SetColor(const Value: string); override;
    procedure SetDecoratedIndex(const Value: string); override;
    procedure SetDefinition(const Value: string); override;
    procedure SetTaxonomy(const Value: TStratTaxonomy); override;

  public
    property    Straton: TSimpleStraton read FStraton write FStraton;

    property    BaseStraton: TStraton read GetBaseStraton write FBaseStraton;
    property    TopStraton: TStraton read GetTopStraton write FTopStraton;

    property    Scheme: TStratigraphicScheme read FScheme write FScheme;
    property    Region: TStratotypeRegion read FRegion write FRegion;
    property    AgeOfBase: single read FAgeOfBase write FAgeOfBase;
    property    AgeOfTop: single read FAgeOfTop write FAgeOfTop;
    property    StratonDefSynonym: string read FStratonDefSynonym write FStratonDefSynonym;
    property    SynonymAuthor: string read FSynonymAuthor write FSynonymAuthor;
    property    DoubtfulBase: Integer read FDoubtFulBase write FDoubtFulBase;
    property    DoubtfulAges: Integer read FDoubtFulAges write FDoubtFulAges;
    property    NotAffirmed: Integer read FNotAffirmed write FNotAffirmed;
    property    Base9Volume: string read FBase9Volume write FBase9Volume;
    property    Top9Volume: string read FTop9Volume write FTop9Volume;

    property    BaseChildren: TStratons read GetBaseChildren;
    property    TopChildren: TStratons read GetTopChildren;

    property    Error: Boolean read GetError;
    property    LastError: string read FLastError;

    function    List(AListOption: TListOption = loBrief): string; override;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TStratons = class(TSimpleStratons)
  private
    function GetItems(Index: integer): TStraton;
    function GetItemsByStratonID(const AStratonID: integer): TStraton;
  public
    property  Items[Index: integer]: TStraton read GetItems;
    property  ItemsByStratonID[const AStratonID: integer]: TStraton read GetItemsByStratonID;
    procedure SortByAge;
    constructor Create; override;
  end;

  TEmptyStraton = class(TStraton)
  public
    constructor Create(AID: Integer); reintroduce; 
  end;


implementation



uses Facade, StratonPoster, SysUtils, BaseConsts;

function CompareStratonAges(Item1, Item2: Pointer): integer;
var s1, s2: TStraton;
begin

  Result := 0;
  s1 := TStraton(Item1);
  s2 := TStraton(Item2);


  if s1.AgeOfBase < s2.AgeOfBase then Result := -1
  else if s1.AgeOfBase > s2.AgeOfBase then Result := 1
  else
  begin
    if s1.AgeOfTop < s2.AgeOfTop then Result := 1
    else if s1.AgeOfTop > s2.AgeOfTop then Result := -1
  end;

end;

{ TStratTaxonomies }

constructor TStratTaxonomies.Create;
begin
  inherited;
  FObjectClass := TStratTaxonomy;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TStratTaxonomyDataPoster];
  OwnsObjects := true;
end;

function TStratTaxonomies.GetItems(Index: integer): TStratTaxonomy;
begin
  Result := inherited Items[Index] as TStratTaxonomy;
end;

{ TStratTaxonomy }

procedure TStratTaxonomy.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TStratTaxonomy).Range := Range;
  (Dest as TStratTaxonomy).TaxonomyType := TaxonomyType;
end;

constructor TStratTaxonomy.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Таксономическая единница';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TStratTaxonomyDataPoster];
  ID := -1;
end;


{ TSimpleStraton }

procedure TSimpleStraton.AssignTo(Dest: TPersistent);
begin
  inherited;

  (Dest as TSimpleStraton).Definition := Definition;
  (Dest as TSimpleStraton).DecoratedIndex := DecoratedIndex;
  (Dest as TSimpleStraton).Color := Color;
  (Dest as TSimpleStraton).Taxonomy := Taxonomy;
end;

constructor TSimpleStraton.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Стратон из справочника';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSimpleStratonDataPoster];
  ID := -1;
end;

function TSimpleStraton.GetColor: string;
begin
  Result := FColor;
end;

function TSimpleStraton.GetDecoratedIndex: string;
begin
  Result := FDecoratedIndex;
end;

function TSimpleStraton.GetDefinition: string;
begin
  Result := FDefinition;
end;

function TSimpleStraton.GetTaxonomy: TStratTaxonomy;
begin
  Result := FTaxonomy;
end;

function TSimpleStraton.List(AListOption: TListOption): string;
begin
  Case AListOption of
  loBrief: Result := Inherited List;
  loMedium:
  begin
    Result := Name + ' - ' + Definition;
    if Assigned(Taxonomy) then
      Result := Result + Taxonomy.Name;
  end;
  loFull:
  begin
    Result := Name + ' - ' + Definition;
    if Assigned(Taxonomy) then
    begin
      Result := Result + ' ' + Taxonomy.Name;
      if Assigned(Taxonomy.TaxonomyType) then
        Result := Result + ' (' + Taxonomy.TaxonomyType.List(loBrief) + ')';
    end;
  end;

  end;
end;

procedure TSimpleStraton.SetColor(const Value: string);
begin
  FColor := Value;
end;

procedure TSimpleStraton.SetDecoratedIndex(const Value: string);
begin
  FDecoratedIndex := Value;
end;

procedure TSimpleStraton.SetDefinition(const Value: string);
begin
  FDefinition := Value;
end;

procedure TSimpleStraton.SetTaxonomy(const Value: TStratTaxonomy);
begin
  FTaxonomy := Value;
end;

{ TSimpleStratons }

constructor TSimpleStratons.Create;
begin
  inherited;
  FObjectClass := TSimpleStraton;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSimpleStratonDataPoster];
end;

function TSimpleStratons.GetItems(Index: integer): TSimpleStraton;
begin
  Result := inherited Items[Index] as TSimpleStraton;
end;

procedure TSimpleStratons.MakeMainStratonList(ALst: TStrings;
  NeedsRegistering, NeedsClearing: boolean);
var i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    if Assigned(Items[i].Taxonomy) then
    begin
      if Items[i].Taxonomy.ID in [SYSTEM_TAXONOMY_ID, SERIES_TAXONOMY_ID, STAGE_TAXONOMY_ID, SUBSTAGE_TAXONOMY_ID, SUPERSTAGE_TAXONOMY_ID] then
        ALst.AddObject(Items[i].List, Items[i]);
    end;
  end;

  if Assigned(Registrator) and NeedsRegistering then
    Registrator.Add(TStringsRegisteredObject, ALst, Self);
end;

procedure TSimpleStratons.Reload;
begin
  // основные стратиграфические единицы
  Reload('(VCH_STRATON_INDEX <> ' + '''' + '''' + ') AND (' + 'VCH_STRATON_DEFINITION <> ' + '''' + '''' + ')' + ' AND (Straton_ID in (select Straton_ID from tbl_Stratigraphy_Name_dict where Taxonomy_Unit_ID in (1, 2, 3, 4, 5, 6, 7, 17, 18, 19, 40,41,42,43,44,45,49,56,57,58))) or (straton_ID in (select Straton_ID from tbl_Subdivision_Component))', false);
end;

{ TStraton }

procedure TStraton.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TStraton).Scheme := Scheme;
  (Dest as TStraton).Region := Region;
  (Dest as TStraton).Straton := Straton;
  (Dest as TStraton).BaseStraton := BaseStraton;
  (Dest as TStraton).TopStraton := TopStraton;
  (Dest as TStraton).AgeOfBase := AgeOfBase;
  (Dest as TStraton).AgeOfTop := AgeOfTop;
  (Dest as TStraton).StratonDefSynonym := StratonDefSynonym;
  (Dest as TStraton).SynonymAuthor := SynonymAuthor;
  (Dest as TStraton).DoubtfulBase := DoubtfulBase;
  (Dest as TStraton).DoubtfulAges := DoubtfulAges;
  (Dest as TStraton).NotAffirmed := NotAffirmed;
  (Dest as TStraton).Base9Volume := Base9Volume;
  (Dest as TStraton).Top9Volume := Top9Volume;
end;

constructor TStraton.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Стратон';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TStratonDataPoster];
  ID := -1;
end;

function TStraton.GetBaseStraton: TStraton;
var iID: integer;
begin
  if FBaseStraton is TEmptyStraton then
  begin
    iID := FBaseStraton.ID;
    FBaseStraton.Free;
    FBaseStraton := Collection.ItemsByID[iID] as TStraton;
  end;
  Result := FBaseStraton;
end;

function TStraton.GetBaseChildren: TStratons;
begin
  Result := nil;
end;

function TStraton.GetColor: string;
begin
  Result := Straton.Color;
end;

function TStraton.GetDecoratedIndex: string;
begin
  Result := Straton.DecoratedIndex;
end;

function TStraton.GetDefinition: string;
begin
  Result := Straton.Definition;
end;

function TStraton.GetTaxonomy: TStratTaxonomy;
begin
  Result := Straton.Taxonomy;
end;


function TStraton.GetTopStraton: TStraton;
var iID: integer;
begin
  if FTopStraton is TEmptyStraton then
  begin
    iID := FTopStraton.ID;
    FTopStraton.Free;
    FTopStraton := Collection.ItemsByID[iID] as TStraton;
  end;
  Result := FTopStraton;
end;

function TStraton.List(AListOption: TListOption): string;
begin
  Result := Name;
  if AListOption <> loBrief then 
  if Assigned (Taxonomy) then
    Result := Result + ' (' + Definition  + ' ' + AnsiLowerCase(Taxonomy.Name) + ')';
  //if Assigned (TaxonomyType) then
  //  Result := Result + ' - ' + AnsiLowerCase(TaxonomyType.Name);
end;

procedure TStraton.SetColor(const Value: string);
begin
  Straton.Color := Color;

end;

procedure TStraton.SetDecoratedIndex(const Value: string);
begin
  inherited;

end;

procedure TStraton.SetDefinition(const Value: string);
begin
  inherited;

end;

procedure TStraton.SetTaxonomy(const Value: TStratTaxonomy);
begin
  inherited;

end;

function TStraton.GetTopChildren: TStratons;
begin
  Result := nil;
end;

function TStraton.GetError: Boolean;
begin
  FLastError := '';
  Result := (not Assigned(BaseStraton)) and Assigned(TopStraton);
  if Result then FLastError := 'Отсутствует родительcкий стратон';

  if not Result then
  begin
    if Assigned(BaseStraton) then
    begin
      Result := not (Pos(BaseStraton.Name, Self.Name) > 0);
      if Result then FLastError := 'Неверно выстроена иерархия для подразделения';
    end;

  end;
end;

{ TStratons }

constructor TStratons.Create;
begin
  inherited;
  FObjectClass := TStraton;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TStratonDataPoster];
end;

function TStratons.GetItems(Index: integer): TStraton;
begin
  Result := inherited Items[Index] as TStraton;
end;




procedure TTaxonomyType.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TTaxonomyType).DivisionAspect := DivisionAspect;
end;

function TStratons.GetItemsByStratonID(
  const AStratonID: integer): TStraton;
var i: integer;
begin
  result := nil;
  for i := 0 to Count - 1 do
  if (Assigned(Items[i].Straton) and (Items[i].Straton.ID = AStratonID)) then
  begin
    Result := Items[i];
    break;
  end;

end;

procedure TStratons.SortByAge;
begin
  Sort(CompareStratonAges);
end;

{ TTaxonomyTypes }

constructor TTaxonomyTypes.Create;
begin
  inherited;
  FObjectClass := TTaxonomyType;
  OwnsObjects := true;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TTaxonomyTypeDataPoster];
end;

function TTaxonomyTypes.GetItems(Index: integer): TTaxonomyType;
begin
  Result := inherited Items[Index] as TTaxonomyType;
end;

{ TTaxonomyType }

constructor TTaxonomyType.Create(ACollection: TIDObjects);
begin
  inherited;
  FClassIDString := 'Таксономическая единица';
  ID := -1;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TTaxonomyTypeDataPoster];
end;




{ TStratigraphicScheme }

procedure TStratigraphicScheme.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TStratigraphicScheme).AffirmationYear := AffirmationYear;
  (Dest as TStratigraphicScheme).Description := Description;
end;

constructor TStratigraphicScheme.Create(ACollection: TIDObjects);
begin
  inherited;
  FClassIDString := 'Стратиграфическая схема';
  ID := -1;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TStratigraphicSchemeDataPoster];
end;

{ TStratigraphicSchemes }

constructor TStratigraphicSchemes.Create;
begin
  inherited;
  FObjectClass := TStratigraphicScheme;
  OwnsObjects := true;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TStratigraphicSchemeDataPoster];
end;

function TStratigraphicSchemes.GetItems(
  Index: integer): TStratigraphicScheme;
begin
  Result := inherited Items[Index] as TStratigraphicScheme;
end;

{ TStratotypeRegion }

procedure TStratotypeRegion.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TStratotypeRegion).Straton := Straton;
end;

constructor TStratotypeRegion.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Стратотипический регион';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TStratotypeRegionDataPoster];
  ID := -1;
end;

{ TStratotypeRegions }

constructor TStratotypeRegions.Create;
begin
  inherited;
  FObjectClass := TStratotypeRegion;
  OwnsObjects := true;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TStratotypeRegionDataPoster];
end;

function TStratotypeRegions.GetItems(Index: integer): TStratotypeRegion;
begin
  Result := inherited Items[Index] as TStratotypeRegion;
end;

{ TEmptyStraton }

constructor TEmptyStraton.Create(AID: Integer);
begin
  inherited Create(nil);
  ID := AID;
end;

end.
