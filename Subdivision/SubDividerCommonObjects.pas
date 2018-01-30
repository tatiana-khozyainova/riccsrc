unit SubDividerCommonObjects;

interface

uses Classes, SysUtils, Controls, ClientCommon, Windows, Contnrs, Variants;

type
  TSubDivision = class;
  EAreaNotFound = class(Exception);
  EWellNotFound = class(Exception);
  EWellFoundByAltitude = class(Exception);
  EStratonNotFound = class(Exception);
  ESubDivisionExists = class(Exception);
  ESubDivisionAddingError = class(Exception);
  ECantRemoveWell = class(Exception);
  ECantRemoveComponent = class(Exception);
  ECantRemoveSubdivision = class(Exception);


  TComponentType = (ctCommon, ctGathered);
  TStratonListOption = (sloIndexName, sloIndexNameAges, sloIndexNameReplacement);
  TStrArr = array of string;
  TIntArr = array of integer;


  TWell  = class;
  TStratons = class;
  TStraton = class;

  TRegion = class(TCollectionItem)
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    RegionID: integer;
    Straton:  TStraton;
    StratonName: string;
    RegionName:  string;
    function ListRegion: string;
  end;

  TRegions = class(TCollection)
  private
    function GetItem(const Index: integer): TRegion;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property Items[const Index: integer]: TRegion read GetItem;
    function RegionOfID(ARegionID: integer) : TRegion;
    function AddRegionRef(ARegion: TRegion): TRegion;
    constructor Create(const AFromDB: boolean);
    destructor  Destroy; override;
  end;


  // элементарное стратиграфическое подразделение
  // создается при скачивании соответствующего справочника
  TStraton = class(TCollectionItem)
  private
    FParentStraton: TStraton;
    FChildren: TStratons;
    FParentStratonID: integer;
    function GetChildren: TStratons;
    function GetParentStraton: TStraton;
  protected
    FStratonID, FSynonymID:    integer;
    FStratonIndex: string;
    FStratonDef:   string;
    FTaxonomy:     string;
    FAgeOfBase, FAgeOfTop: single;
    FSynonym: string;
    FTaxRange: integer;
    FRegionID: integer;
    FRegion: string;
    FReplacement: TStratons;
    //function  GetRegion: string;
  public
    procedure   AssignTo(Dest: TPersistent); override;
    property    RegionID: integer read FRegionID;
    property    Region: string read FRegion;
    property    StratonID:    integer read FStratonID;
    property    ParentStratonID: integer read FParentStratonID;

    property    TaxRange: integer read FTaxRange;
    property    StratonIndex: string read FStratonIndex;
    property    StratonDef:   string read FStratonDef;
    property    AgeOfTop: single read FAgeOfTop;
    property    AgeOfBase: single read FAgeOfBase;
    property    Synonym: string read FSynonym;
    property    Replacement: TStratons read FReplacement;
    property    Taxonomy:     string read FTaxonomy;
    property    SynonymID: integer read FSynonymID;
    property    ParentStraton:  TStraton read GetParentStraton;
    property    Children: TStratons read GetChildren;
    function    IsIn(AStratons: TStratons): boolean;


    function    Majority(Value: TStraton): integer;
    function    ListStraton(const What: TStratonListOption): string;
    constructor Create(Collection: TCollection); override;
  end;


  // список стратонов соостветствующий справочнику
  TStratons = class(TCollection)
  private
    function    GetItem(const Index: integer): TStraton;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    property    Items[const Index: Integer]: TStraton read GetItem; default;
{    function    StratonsOfIndex(AStratonIndex: string;                // поиск стратона по индексу
                                OutStratons: TStratons): boolean;     // возвращает стратоны с неповторяющимися идентификаторами}
    function    FirstStratonsOfIndex(AStratonIndex: string;            // возвращает старший по таксономическому рангу стратон(ы)
                                OutStratons: TStratons): boolean;     // с неповторяющимимся ИД и индексами

    function    StratonOfID(const AStratonID: integer): TStraton;

    function    AddStratonRef(AStraton: TStraton): TStraton;
    procedure   AssignFromVariant(AFrom: variant);
    procedure   MakeList(ALst: TStringList; What: TStratonListOption; Clear: boolean = true);
    function    MakeFilter: string;

    function    EqualTo(AStratons: TStratons): boolean;
    function    Includes(AInStratons: TStratons): boolean;
    function    IsParent(AStratons: TStratons; AChildren, ARest: TStratons): boolean;

    procedure   Exclude(AInStratons: TStratons);
    function    Intersects(AStratons: TStratons; AIntersections: TStratons; const Remove: boolean): boolean;

    constructor Create(const FromDB: boolean);  reintroduce;
    destructor  Destroy; override;
  end;

  // стратоны, которые нельзя объединять в колонке, хотя для некоторых скважин и хотелось бы
  TExcludedStratons = class(TStratons)
  public
    constructor Create(const Filter: string); reintroduce;
  end;


  TSynonymStratons = class (TStratons)
  public
    constructor Create(ACommonStratons: TStratons); reintroduce;
  end;



  // одна строка таблицы разбивок
  TSubDivisionComponent = class(TCollectionItem)
  private
    FStratons: TStratons;
    FDepth: single;
    FDivider: string;
    //FEdges:       TStringList;
    FSubDivisionComment: string;
    FSubDivisionCommentID: integer;
    FStratonIndex: integer;
    DividerChanged: boolean;
    FAssociative: boolean;
    FVerified: boolean;
    FLastStratons: TStratons;
    //FComponentType: TComponentType;
    procedure   SetCommonBuffer(Value: TStratons);
    procedure   SetGatheredBuffer(Value: TStratons);
    function    CommonPost: smallint;
    function    GatheredPost: smallint;
    procedure   SetSubdivisionComment(const Value: string);
    procedure   SetCommentID(const Value: integer);
    procedure   SetBuffer(Value: TStratons);
    function GetStratons: TStratons;
    function GetListDepth: string;
    function GetInverseThickness: single;
    function GetThickness: single;
  protected
    function    GetDivider: string;
    procedure   SetDivider(const Value: string);
    procedure   AssignTo(Dest: TPersistent); override;
  public
    //property    Edges: TStringList read FEdges write FEdges;
    //property    ComponentType: TComponentType read FComponentType write FComponentType;
    property    Divider: string read GetDivider write SetDivider;
    property    Buffer: TStratons write SetBuffer;
    property    Stratons: TStratons read GetStratons ;
    property    LastStratons: TStratons read FLastStratons;
    //property    Straton: TStraton read GetStraton;
    //property    NextStraton: TStraton read GetNextStraton;
    //property    PrevStraton: TStraton read GetPrevStraton;
    property    Depth: single read FDepth write FDepth;
    property    ListDepth: string read GetListDepth;

    property    SubDivisionCommentID: integer read FSubDivisionCommentID write SetCommentID;
    property    SubDivisionComment: string read FSubDivisionComment write SetSubdivisionComment;
    // уверены или нет
    property    Verified: boolean read FVerified write FVerified;


    function    Next: TSubdivisionComponent;
    function    Prev: TSubdivisionComponent;

    property    Thickness: single read GetThickness;
    property    InverseThickness: single read GetInverseThickness;  

    function    PostToDB: smallint; virtual;
    constructor Create(Collection: TCollection); override;
    destructor  Destroy; override;

    property    Associative: boolean read FAssociative write FAssociative;
  end;

  TSubdivisionComponentList = class(TObjectList)
  private
    function GetItems(const Index: integer): TSubdivisionComponent;
  public
    property Items[const Index: integer]: TSubdivisionComponent read GetItems; default;
    constructor Create;
  end;


  // упорядоченный элемент разбивки
  // ему сответствует один несколько обычных
  // причем при редактируются упорядоченные, а в базу пишутся обычные
  // так что все изменения в упорядоченном отражаются на обычных
  TOrderedSubdivisionComponent = class(TSubDivisionComponent)
  private
    FSCList: TSubdivisionComponentList;
  public
    // настоящие, которые соответствуют данному элементу
    property    SCList: TSubdivisionComponentList read FSCList;
    function    PostToDB: smallint; override;
    constructor Create(Collection: TCollection); override;
    destructor  Destroy; override;
  end;


  // содержимое таблицы разбивок для скважины
  TSubDivisionComponents = class(TCollection)
  private
    FSubDivision: TSubDivision;
    function    GetItem(const Index: integer): TSubDivisionComponent;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    property    SubDivision: TSubDivision read FSubDivision;
    // неупорядоченные компоненты
    property    Items[const Index: Integer]: TSubDivisionComponent read GetItem; default;
    function    ComponentByStratons(AStratons: TStratons; const ADivider: string): TSubDivisionComponent;
    function    ComponentByID(AStratonID: integer): TSubDivisionComponent;
    constructor Create(ASubDivision: TSubDivision); reintroduce;
    destructor  Destroy; override;
  end;


  TSubDivisions = class;

  // стратиграфическая разбивка
  TSubDivision = class(TCollectionItem)
  private
    FProperty: string;
    FLastDepth: single;
    FPropertyID: integer;
    FShortBlockName: string;
    FContent: TSubDivisionComponents;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    property    Content: TSubDivisionComponents read FContent;
    // свойство - аллохтон, автохтон и т.п.
    property    TectonicBlock: string read FProperty write FProperty;
    property    ShortBlockName: string read FShortBlockName write FShortBlockName;
    property    PropertyID: integer read FPropertyID write FPropertyID;
    // глубина последнего подразделения
    // она же будет проставляться и для всех
    // н.в. н.р.

    property    LastDepth: single read FLastDepth write FLastDepth;
    function    AddComponent(AStratonIDs: variant; const ADivider: char; ACommentID: integer; ADepth: single; AVerified: boolean): TSubDivisionComponent; overload;
    function    AddComponent(AStratons: TStratons; const ADivider: char; ACommentID: integer; ADepth: single; AVerified: boolean): TSubDivisionComponent; overload;
    procedure   DeleteComponent(const Index: integer; const DB: boolean);
    procedure   UpdateSubDivision(AProperty: string; DB: boolean);
    function    PostToDB: smallint;
    constructor Create(Collection: TCollection); override;
    destructor  Destroy; override;
  end;

  // список стратиграфических разбивок
  // при инициализации если задана скважина
  // список создается из базы данных
  TSubDivisions = class(TCollection)
  private
    FWell: TWell;
    function    GetItem(const Index: integer): TSubDivision;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    property    Well: TWell read FWell;
    property    Items[const Index: Integer]: TSubDivision read GetItem; default;
    function    IsComplete: boolean;
    function    AddSubDivision(const AProperty: string): TSubDivision; overload;
    function    AddSubDivision(const APropertyID: integer): TSubDivision; overload;
    {function    AddSubDivisionFromFile(const ASubDivisionID: integer;
                                       const ADesc, AAuthors: string;
                                       AStartDate: TDate;
                                       AProperty: string): TSubDivision;
    procedure   LoadSubDivisions;}
    function    SubDivisionByID(APropertyID: integer): TSubDivision;
    procedure   DeleteSubdivision(const Index: integer; DB: boolean);
    constructor Create(AWell: TWell); reintroduce;
    destructor  Destroy; override;
  end;


  // скважина может обладать
  // несколькими разбивками
  TWell = class(TCollectionItem)
  protected
    FAreaID:                   integer;
    FWellUIN:                  integer;
    FDepth, FAltitude:         single;
    FAreaName, FWellNum,
    FOldAreaName, FOldWellNum: string;
    FChanged:                  boolean;
    FSubDivisions:             TSubDivisions;
    procedure   AssignTo(Dest: TPersistent); override;
  public
    property    ChangesMade: boolean read FChanged write FChanged;
    property    SubDivisions: TSubDivisions read FSubDivisions;
    property    OldAreaName: string read FOldAreaName;
    property    OldWellNum: string read FOldWellNum;
    property    WellUIN:  integer read FWellUIN;
    property    AreaName: string read FAreaName;
    property    WellNum:  string read FWellNum;
    property    Altitude: single read FAltitude;
    property    Depth:    single read FDepth;
    function    ListWell: string;
    function    UpdateWell(AWellUIN: integer; AAreaName, AWellNum: string; const AAltitude, ADepth: single; DB: boolean): integer; virtual;
    procedure   GetSubdivisions(ExcludedStratons: TStratons);
    constructor Create(Collection: TCollection); override;
    destructor  Destroy; override;
  end;

  PWell = ^TWell;

  TWells = class(TCollection)
  private
    FActiveWell: TWell;
    function GetItem(const Index: integer): TWell;
  public
    property    ActiveWell: TWell read FActiveWell write FActiveWell;
    property    Items[const Index: integer]: TWell read GetItem; default;
    function    WellByName(AWellNum, AAreaName: string): TWell; overload;
    function    WellByName(const AWellNum: string; const AAreaID: integer): TWell; overload;
    function    WellByAltitudeDepth(const AAreaName: string; AAltitude, ADepth: single): TWell;
    function    WellByUIN(const AWellUIN: integer): TWell;
    function    AddWell(AAreaName, AWellNum, AOldAreaName, AOldWellNum: string; const AAltitude, ADepth: single; out Found: variant): TWell; overload; virtual;
    function    AddWell(AAreaName, AWellNum: string; const AAltitude, ADepth: single): TWell; overload; virtual;
    function    AddWell(AWell: TWell; const Copy: boolean): TWell; overload; virtual;
    function    AddWell(AWellUIN: integer; AAreaName, AWellNum: string; const AAltitude, ADepth: single; const WithSubdivisions: boolean): TWell; overload; virtual;
    function    StratonsCount(AStratons: TStratons): integer;
    function    GetFilter: string;
    procedure   GetStratRegions(ARegions: TRegions);
    function    DeleteWell(const Index: integer; DB: boolean): integer; virtual;
    procedure   GatherStratons(Stratons: TStratons);
    destructor  Destroy; override;
  end;

  TMainSubDivisionListOption = (msdNameAuthors, msdFull);


{  TMainSubDivision = class
  private
    FSubDivisions: TSubDivisions;
    FDesc, FAuthors: string;
    FStartDate: TDate;
    FSubDivisionID, FNewSubdivisionID: integer;
  public
    // свойства файла разбивки
    property    Desc: string read FDesc write FDesc;
    property    Authors: string read FAuthors write FAuthors;
    property    StartDate: TDate read FStartDate write FStartDate;
    property    SubDivisions: TSubDivisions read FSubDivisions;
    function    PostToDB: integer;
    function    ListSubDivision(What: TMainSubDivisionListOption): string;
  end;}



implementation

uses SubDividerCommon;

{function  TMainSubDivision.PostToDB: integer;
var vValues: variant;
begin
  // сначала записываем шапку
  vValues := varArrayOf([FSubDivisionID, Desc, Authors, StartDate]);
  Result := IServer.SelectRows('SPD_ADD_SUBDIVISION', '*', '', vValues);
end;


function  TMainSubDivision.ListSubDivision(What: TMainSubDivisionListOption): string;
begin
  Result := 'Разбивка: ' + Desc + '; ';
  Result := Result + ' авторы: ' + Authors + '; ';
  if What = msdFull then
    Result := Result + 'дата вступления в силу ' + DateToStrEx(StartDate);
end;}

procedure TRegions.AssignTo(Dest: TPersistent);
var i: integer;
begin
  for i := 0 to Self.Count - 1 do
    (Dest as TRegions).AddRegionRef(Self.Items[i]);
end;


function TRegions.GetItem(const Index: integer): TRegion;
begin
  Result := TRegion (inherited Items[Index]);
end;

procedure TRegion.AssignTo(Dest: TPersistent);
begin
  with Dest as TRegion do
  begin
    RegionID := Self.RegionID;
    RegionName := Self.RegionName;
    Straton := Self.Straton;
  end;
end;


function TRegion.ListRegion: string;
begin
  Result := '';
  if Assigned(Straton) then
    Result := Straton.StratonIndex + ' - '
  else Result := StratonName + ' - ';

  Result := Result + RegionName;  
end;

function TRegions.RegionOfID(ARegionID: integer) : TRegion;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if ARegionID = Items[i].RegionID then
  begin
    Result := Items[i];
    break;
  end;
end;


function TRegions.AddRegionRef(ARegion: TRegion): TRegion;
begin
  Result := nil;
  if Assigned(Aregion) then
  begin
    Result := RegionOfID(Aregion.RegionID);
    if not Assigned(Result) then
    begin
      Result := Add as TRegion;
      Result.Assign(ARegion);
    end;
  end;
end;

destructor  TRegions.Destroy;
var i: integer;
begin
  for i := Count - 1 downto 0 do
    Items[i].Free;
  inherited Destroy;
end;

constructor TRegions.Create(const AFromDB: boolean);
var i: integer;
    R: TRegion;
begin
  inherited Create(TRegion);
  with AllDicts do
  for i := 0 to varArrayHighBound(StrRegions, 2) do
  begin
    R := Add as TRegion;
    with R do
    begin
      RegionID := StrRegions[0, i];
      Straton  := AllStratons.StratonOfID(StrRegions[1, i]);
      StratonName := StrRegions[3, i];
      RegionName := StrRegions[2, i];  
    end;
  end;
end;




// TStraton - одно стратиграфическое подразделение
constructor TStraton.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FReplacement := TStratons.Create(false);
end;

{function    TStraton.GetReplacement: TStratons;
var iResult, i, iDim, iHB, j: integer;
    vInput, vResult: variant;
begin
  if FReplacement.Count = 0 then
  begin
    varClear(vResult);
    vInput := (Collection as TStratons).Replacements;
    if not varIsEmpty(vInput) then
    begin
      iDim := 1;
      iHB  := varArrayHighBound(vInput, 1);
      for i := 0 to VarArrayHighBound(vInput, 2) do
      if (vInput[9, i] = StratonID) then
      begin
        if varIsEmpty(vResult) then vResult := varArrayCreate([0, iHB - 1, 0, 0], varVariant)
        else
        begin
          varArrayRedim(vResult, iDim);
          inc(iDim);
        end;

        for j := 0 to iHB - 1 do
          vResult[j, iDim - 1] := vInput[j, i];
      end;

      if not varIsEmpty(vResult) then
      FReplacement.AssignFromVariant(vResult);
    end;
  end;
  Result := FReplacement;
end;}


{function    TStraton.GetRegion: string;
begin
  Result := FRegion;
  if FRegion = '' then
    FRegion := GetObjectName(AllDicts.StrRegions, FRegionID, 2);
  Result := FRegion;
end;}



procedure   TStraton.AssignTo(Dest: TPersistent);
begin
  //Dest := Self;
  with Dest as TStraton do
  begin
    FStratonID := Self.FStratonID;
    FStratonIndex := Self.FStratonIndex;
    FStratonDef := Self.FStratonDef;
    FTaxonomy := Self.FTaxonomy;
    FAgeOfBase := Self.FAgeOfBase;
    FAgeOfTop := Self.AgeOfTop;
    FSynonym := Self.FSynonym;
    FTaxRange := Self.FTaxRange;
    //FRegionID := Self.FRegionID;
    FRegion := Self.FRegion;
    FReplacement.Assign(Self.Freplacement);
    FParentStratonID := Self.FParentStratonID;
  end;
end;

function TStraton.Majority(Value: TStraton): integer;
begin
  if StratonIndex = Value.StratonIndex then Result := 0
  else if Pos(Value.StratonIndex, StratonIndex) > 0 then Result := 1
  else Result := -1;
end;

function TStraton.ListStraton(const What: TStratonListOption): string;
var i: integer;
    S: string;
begin
  Result := StratonIndex + ' - ' + StratonDef + ' ' + AnsiLowerCase(Taxonomy);
  if FSynonym <> '' then
     Result := Result + '; Cиноним ' + Synonym;

  if What = sloIndexNameAges then
  begin
    Result := Result + '; ' + Format('%5.2f', [AgeOfBase]) + ' - ' +
              Format('%5.2f', [AgeOfTop]) + ' млн. лет'
  end;

  Result := Result + '; ' + Region;

  if What = sloIndexNameReplacement then
  begin
    S := '';
    for i := 0 to Replacement.Count - 1 do
      S := S  + '; ' + Replacement.Items[i].ListStraton(sloIndexName);
    Result := Result +  S;
  end;
end;

constructor TSynonymStratons.Create(ACommonStratons: TStratons);
var vResult: variant;
    iResult, i: integer;
    S: TStraton;
begin
  inherited Create(false);
  iResult := IServer.ExecuteQuery('select distinct s.straton_id, s.vch_straton_index, ' +
                                  's.vch_straton_definition, s.vch_taxonomy_unit_name, ' +
                                  's.num_Age_Of_Base, s.num_Age_Of_Top, ' +
                                  's.vch_Straton_Def_Synonym, s.num_taxonomy_unit_range, ' +
                                  's.Region_ID, p.straton_id ' +
                                  'from vw_stratigraphy_dict s, ' +
                                  'tbl_straton_synonym syn, ' +
                                  'tbl_straton_properties p ' +
                                  'where syn.straton_region_id = s.straton_region_id ' +
                                  'and p.straton_region_id = syn.syn_straton_region_id');

  if iResult > 0 then
  begin
    vResult := IServer.QueryResult;
    for i := 0 to varArrayHighBound(vResult, 2) do
    begin
      // получаем стратон по идентификатору стратона
      S := StratonOfID(vResult[0, i]);
      if not Assigned(S) then
      begin
        S := Add as TStraton;
        with S do
        begin
          FStratonID    := vResult[0, i];
          FStratonIndex := vResult[1, i];
          FStratonDef   := vResult[2, i];
          FTaxonomy     := vResult[3, i];
          FAgeOfBase    := vResult[4, i];
          FAgeOfTop     := vResult[5, i];
          FSynonym      := vResult[6, i];
          FTaxRange     := vResult[7, i];
          FRegionID     := vResult[8, i];
          //FRegion       := '';
        end;
      end;
      S.Replacement.AddStratonRef(ACommonStratons.StratonOfID(vResult[9, i]));
    end;
  end;
end;

// TStratons - список стратиграфических подразделений
constructor TStratons.Create(const FromDB: boolean);
begin
  inherited Create(TStraton);

  if FromDB then
    AssignFromVariant(AllDicts.StratonsDict);
end;

function  TStratons.Intersects(AStratons: TStratons; AIntersections: TStratons; const Remove: boolean): boolean;
var i: integer;
    Found: TStraton;
begin
  Result := false;
  for i := Count-1  downto 0 do
  begin
    Found := AStratons.StratonOfID(Items[i].StratonID);  
    if Assigned(Found) then
    begin
      AInterSections.AddStratonRef(Found);
      Result := true;

      if Remove then
      begin
        if Count > 1 then Delete(i);
        if AStratons.Count > 1 then AStratons.Delete(Found.Index);
      end;
    end;
  end;
end;

procedure   TStratons.AssignTo(Dest: TPersistent);
var i: integer;
begin
  (Dest as TStratons).Clear;
  for i := 0 to Count - 1 do
    (Dest as TStratons).AddStratonRef(Self[i]);
end;


function    TStratons.EqualTo(AStratons: TStratons): boolean;
var FilterSet, AFilterSet: TStringList;
    i: integer;
begin
  FilterSet := TStringList.Create;
  AFilterSet := TStringList.Create;
  for i := 0 to Count - 1 do
    FilterSet.Add(IntToStr(Items[i].StratonID));

  FilterSet.Sort;

  for i := 0 to AStratons.Count - 1 do
    AFilterSet.Add(IntToStr(AStratons[i].StratonID));

  AFilterSet.Sort;

  Result := AFilterSet.Count = FilterSet.Count;
  if Result then
  for i := 0 to AFilterSet.Count - 1 do
  if AFilterSet[i] <> FilterSet[i] then
  begin
    Result := false;
    break;
  end;

  AFilterSet.Free;
  FilterSet.Free;
end;


function    TStratons.MakeFilter: string;
var i: integer;
begin
  Result := '';
  for i := 0 to Count - 1 do
    Result := Result + ', ' + IntToStr(Items[i].StratonID);
  if Result <> '' then
    Result := copy(Result, 2, Length(Result));
end;


procedure   TStratons.MakeList(ALst: TStringList; What: TStratonListOption; Clear: boolean = true);
var i: integer;
begin
  if Clear then ALst.Clear;
  for i := 0 to Count - 1 do
    ALst.AddObject(Items[i].ListStraton(What), Items[i]);
end;

{function    TStratons.GetReplacements: TStratons;
var i, iResult: integer;
    vResult: variant;
    S: TStraton;
begin
  if (not FNoReplacement) then
  begin
    iResult := IServer.ExecuteQuery('select distinct s.straton_Region_id, s.vch_straton_index, ' +
                                    's.vch_straton_definition, s.vch_taxonomy_unit_name, ' +
                                    's.num_Age_Of_Base, s.num_Age_Of_Top, ' +
                                    's.vch_Straton_Def_Synonym, s.num_taxonomy_unit_range, ' +
                                    's.Region_ID, syn.syn_straton_region_id ' +
                                    'from vw_stratigraphy_dict s, ' +
                                    'tbl_straton_synonym syn '+
                                    'where syn.straton_region_id = s.straton_region_id ');

    if iResult > 0 then
    begin
      vResult := IServer.QueryResult;
      for i := 0 to varArrayHighBound(vResult, 2) do
      begin
        S := FReplacements.StratonOfID(vResult[0, i]);
        if not Assigned(S) then
        begin
          S := FReplacements.Add as TStraton;
          with S do
          begin
            FStratonID    := vResult[0, i];
            FStratonIndex := vResult[1, i];
            FStratonDef   := vResult[2, i];
            FTaxonomy     := vResult[3, i];
            FAgeOfBase    := vResult[4, i];
            FAgeOfTop     := vResult[5, i];
            FSynonym      := vResult[6, i];
            FTaxRange     := vResult[7, i];
            FRegionID     := vResult[8, i];
            FRegion       := '';
          end;
        end;
        S.Replacement.AddStratonRef(StratonOfID(vResult[9, i]));
      end;
    end
    else FNoReplacement := true;
  end;
  Result := FReplacements;
end;}

function    TStratons.GetItem(const Index: integer): TStraton;
begin
  Result := TStraton(inherited Items[Index]);
end;

function    TStratons.StratonOfID(const AStratonID: integer): TStraton;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if AStratonID = Items[i].StratonID then
  begin
    Result := Items[i];
    break;
  end;
end;

function    TStratons.FirstStratonsOfIndex(AStratonIndex: string; OutStratons: TStratons): boolean;
var i, j: integer;
    bFound: boolean;
begin
  AStratonIndex := EngTransLetter(AStratonIndex);
  Result := false;
  for i := 0 to Count - 1 do
  if AStratonIndex = EngTransLetter(Items[i].StratonIndex) then
  begin
    bFound := false;
    Result := true;

    for j := OutStratons.Count - 1 downto 0 do
    if  (OutStratons[j].StratonID = Items[i].StratonID)
    or  (OutStratons[j].TaxRange  < Items[i].TaxRange) then
    begin
      bFound := true;
      Result := true;
      break;
    end;


    if not bFound then OutStratons.AddStratonRef(Items[i]);
  end;
end;

{function TStratons.StratonsOfIndex(AStratonIndex: string; OutStratons: TStratons): boolean;
var i, j: integer;
    bFound: boolean;
begin
  AStratonIndex := EngTransLetter(AStratonIndex);
  Result := false;
  for i := 0 to Count - 1 do
  if AStratonIndex = EngTransLetter(Items[i].StratonIndex) then
  begin
    bFound := false;
    Result := true;

    for j := OutStratons.Count - 1 downto 0 do
    if  OutStratons[j].StratonID =
        Items[i].StratonID then
    begin
      bFound := true;
      Result := true;
      break;
    end;


    if not bFound then OutStratons.AddStratonRef(Items[i]);
  end;
end;}

procedure   TStratons.AssignFromVariant(AFrom: variant);
var S: TStraton;
    i: integer;
begin
  for i := 0 to varArrayHighBound(AFrom, 2) do
  begin
    S := Add as TStraton;
    with S do
    begin
      FStratonID    := AFrom[0, i];
      FStratonIndex := AFrom[1, i];
      FStratonDef   := AFrom[2, i];
      FTaxonomy     := AFrom[3, i];
      FAgeOfBase    := AFrom[4, i];
      FAgeOfTop     := AFrom[5, i];
      FSynonym      := AFrom[6, i];
      FTaxRange     := AFrom[7, i];
      //FRegionID     := AFrom[8, i];
      FRegion       := AFrom[8, i];
      FSynonymID    := AFrom[9, i];
      FSynonym      := AFrom[10, i];
      FParentStratonID := AFrom[12, i];  
    end;
  end;
end;

function    TStratons.AddStratonRef(AStraton: TStraton): TStraton;
begin
  Result := StratonOfID(AStraton.StratonID);
  if not Assigned(Result) then
  begin
    Result := Add As TStraton;
    Result.Assign(AStraton);
  end;
end;


destructor  TStratons.Destroy;
var i: integer;
begin
  for i := Count - 1 downto 0 do
    Items[i].Free;
  inherited Destroy;
end;

// TAbstractSubDivisionComponent - строка таблицы разбивок представленная по разному
// или строкой с границами стратонов или плюсовиком

// TSubDivisionComponent - одна строка таблицы tbl_SubDivision_Component
constructor TSubDivisionComponent.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  Verified := true;
  FAssociative := true;
  FStratons := TStratons.Create(false);
  FLastStratons := TStratons.Create(false);
  FStratonIndex := 1;

  //if GatherComponents then FComponentType := ctGathered
  //else FComponentType := ctCommon;
  //FEdges := TStringList.Create;
end;

function    TSubDivisionComponent.PostToDB: smallint;
begin
  //if GatherComponents then
  Result := GatheredPost;
  DividerChanged := false;
  //else
  //Result := CommonPost;
  ((Collection as TSubDivisionComponents).FSubDivision.Collection as TSubDivisions).FWell.ChangesMade := true;
end;




{function    TSubDivisionComponent.GetStraton: TStraton;
begin
  Result := Stratons[0];
end;

function    TSubdivisionComponent.GetPrevStraton: TStraton;
begin
  if FStratonIndex > 0 then
  begin
    dec(FStratonIndex);
    Result := Stratons[FStratonIndex];
  end
  else Result := nil;
end;

function    TSubdivisionComponent.GetNextStraton: TStraton;
begin
  if Stratons.Count > FStratonIndex then
  begin
    inc(FStratonIndex);
    Result := Stratons[FStratonIndex];
  end
  else
  if Stratons.Count > 1 then Result := Stratons[Stratons.Count - 1]
  else Result := nil;
end;}

procedure   TSubDivisionComponent.SetCommentID(const Value: integer);
begin
  FSubDivisionCommentID := Value;
  if FSubDivisionCommentID > 0 then
     FSubDivisionComment := GetObjectName(AllDicts.FullCommentDict, FSubDivisionCommentID, 2);
end;

procedure   TSubDivisionComponent.SetSubdivisionComment(const Value: string);
var S: string;
begin
  if FSubDivisionComment <> Value then
  begin
    S := AnsiLowerCase(StringReplace(Value, '.', '', [rfReplaceAll]));
    FSubDivisionCommentID := GetObjectId(AllDicts.FullCommentDict, S);
    if FSubDivisionCommentID <= 0 then
      FSubDivisionCommentID := GetObjectId(AllDicts.FullCommentDict, S, 2);

    if FSubDivisionCommentID > 0 then
      FSubDivisionComment := S;
  end;
end;

procedure   TSubDivisionComponent.AssignTo(Dest: TPersistent);
begin
  with Dest as TSubDivisionComponent do
  begin
    //FStratons := Self.FStratons;
    FStratons.Assign(Self.FStratons);
    //FNextStraton := Self.FNextStraton;
    FDepth := Self.FDepth;
    FSubDivisionComment := Self.FSubDivisionComment;
    FSubDivisionCommentID := Self.FSubDivisionCommentID;
    //FEdges := Self.FEdges;
    FDivider := Self.Divider;
  end;
end;


destructor  TSubDivisionComponent.Destroy;
begin
  //FEdges := TStringList.Create;
  FLastStratons.Free;
  FStratons.Free;
  inherited Destroy;
end;



{procedure   TSubDivisionComponent.AddComment(const AComment: string);
var iID: integer;
begin
  iID := GetObjectId(AllDicts.EdgesDict, AComment);
  if iID > 0 then
    FEdges.Add(inttostr(iID) + '=' + AComment)
  else
  begin
    // поиск по краткому названию
    iID := GetObjectId(AllDicts.EdgesDict, AComment, 2);
    if iID > 0 then
      FEdges.Add(inttostr(iID) + '=' + AComment)
  end;
end;}

procedure   TSubDivisionComponent.SetDivider(const Value: string);
begin
  if Value <> FDivider then
  begin
    DividerChanged := (trim(FDivider) <> '');
    FDivider := Value;
  end;
end;

function    TSubDivisionComponent.GetDivider: string;
begin
  Result := FDivider;
end;

procedure   TSubDivisionComponent.SetCommonBuffer(Value: TStratons);
var i, {iLastID,} iID, iResult, iWellUIN, iBlockID: integer;
    s, nS: TStraton;
    sFilter: string;
begin
  nS := nil;
  S := Value[0];
  if Value.Count > 1 then nS := Value[1];
  iWellUIN := ((Collection as TSubDivisionComponents).FSubDivision.Collection as TSubDivisions).FWell.WellUIN;
  iBlockID := (Collection as TSubDivisionComponents).FSubDivision.FPropertyID;

  if  (DividerChanged and (Ns<>nil)) or (not Stratons.EqualTo(Value)) then
  begin
    iID := 0;
    if Assigned(nS) then iID := nS.StratonID;
    {iLastID := 0;
    if Stratons.Count > 1 then iLastID := Stratons[1].StratonID;}
    sFilter := StringReplace('(' + Stratons.MakeFilter + ')', IntToStr(Stratons[0].StratonID)+',','', [rfReplaceAll]);

    // удаляем все кроме первого
    iResult := IServer.DeleteRow('TBL_SUBDIVISION_COMPONENT',
                                 'where WELL_UIN = ' + IntToStr(iWellUIN) +
                                 ' and BLOCK_ID = ' + IntToStr(iBlockID) +
                                 ' and STRATON_ID in ' + sFilter);



    // обновляем первый
    if iResult >= 0 then
      iResult := IServer.UpdateRow('TBL_SUBDIVISION_COMPONENT',
                                    varArrayOf(['STRATON_ID', 'NEXT_STRATON_ID']),
                                    varArrayOf([S.StratonID, iID]),
                                    'WELL_UIN = '
                                    + IntToStr(iWellUIN) +
                                    ' AND BLOCK_ID = '
                                    + IntToStr(iBlockID) +
                                    ' AND STRATON_ID = '
                                    + IntToStr(Stratons[0].StratonID));
    if iResult >= 0 then
    begin
      FStratons.Clear;
      for i := 0 to Value.Count - 1 do
       FStratons.AddStratonRef(Value[i]);
    end;
  end;
  //else iResult := 1;

  // if iResult >= 0 then iResult := PostToDB;
  ((Collection as TSubDivisionComponents).FSubDivision.Collection as TSubDivisions).FWell.ChangesMade := true;
end;





{procedure   TSubDivisionComponent.UpdateComponent(AStraton, ANextStraton: TStraton; AComment: string; ADepth: single; const DB: boolean);
var iResult: integer;
begin
  NextStraton := ANextStraton;
  SubDivisionComment := AComment;
  Depth := ADepth;
  if DB then
  begin
    if Assigned(Straton) and (AStraton.StratonID <> Straton.StratonID) then
    begin
      iResult := IServer.UpdateRow('TBL_SUBDIVISION_COMPONENT',
                                   'STRATON_ID', AStraton.StratonID,
                                   'WELL_UIN = ' + IntToStr(((Collection as TSubDivisionComponents).FSubDivision.Collection as TSubDivisions).FWell.WellUIN) +
                                   ' AND BLOCK_ID = ' + IntToStr((Collection as TSubDivisionComponents).FSubDivision.FPropertyID) +
                                   ' AND STRATON_ID = ' + IntToStr(Straton.StratonID));
    end
    else iResult := 1;

    Straton := AStraton;

    if iResult >=0 then PostToDB;
  end;
end; }

procedure   TSubDivisionComponent.SetBuffer(Value: TStratons);
begin
  if Divider = '+' then
    SetGatheredBuffer(Value)
  else
    SetCommonBuffer(Value);
  DividerChanged := true;  
end;



function    TSubDivisionComponent.CommonPost: smallint;
var vValues: variant;
    iWellUIN, iBlockID, iNextStraton: integer;
begin

  iWellUIN := ((Collection as TSubDivisionComponents).FSubDivision.Collection as TSubDivisions).FWell.FWellUIN;
  iBlockID := (Collection as TSubDivisionComponents).FSubDivision.FPropertyID;

  {

    WELL_UIN INTEGER,
    STRATON_ID SMALLINT,
    NEXT_STRATON_ID SMALLINT,
    BLOCK_ID INTEGER,
    EDGE_COMMENT_ID INTEGER,
    COMMENT_ID SMALLINT,
    NUM_DEPTH NUMERIC(8,3)
  }

  iNextStraton := 0;
  if Stratons.Count > 1 then
    iNextStraton := Stratons[1].StratonID;

  vValues := varArrayOf([iWellUIN, Stratons[0].StratonID, iNextStraton, iBlockID, 0, FSubdivisionCommentID, Depth]);

  Result := IServer.SelectRows('SPD_ADD_SUBDIVISION_COMPONENT', '*', '', vValues);

  // записываем в отдельную таблицу границ
  {if FEdges.Count > 0 then
  begin
    vValues := VarArrayCreate([0, 1, 0, FEdges.Count - 1], varVariant);
    for i := 0 to FEdges.Count - 1 do
    begin
      vValues[0, i] := FSubDivisionComponentID;
      vValues[1, i] := StrToInt(FEdges.Names[i]);
    end;
    Result := IServer.InsertRow('TBL_SUBDIVISION_COMMENT', 'SUBDIVISION_COMPONENT_ID, COMMENT_ID', vValues);
  end;}
end;



procedure   TSubdivisionComponent.SetGatheredBuffer(Value: TStratons);
var i, iResult, iWellUIN, iBlockID: integer;
    S: TStraton;
    //ToRemove, ToAdd: TStratons;
    sFilter: string;
begin
  // Value это копия изменений в подразделениях, сделанных
  // при редактировании разбивки
  iResult := 1;
  // сравниваем Value с FStratons
  {ToRemove := TStratons.Create(false);
  ToAdd    := TStratons.Create(false);}
  if  DividerChanged  or (not Stratons.EqualTo(Value)) then
  begin
    iWellUIN := ((Collection as TSubDivisionComponents).FSubDivision.Collection as TSubDivisions).FWell.WellUIN;
    iBlockID := (Collection as TSubDivisionComponents).FSubDivision.FPropertyID;

    sFilter := FStratons.MakeFilter;
    // набираем стратоны которые подлежат удалению
    for i := FStratons.Count - 1 downto 0 do
    begin
      S := Value.StratonOfID(FStratons[i].StratonID);
      if not Assigned(S) then
      begin
        //ToRemove.AddStratonRef(FStratons[i]);
        FStratons.Delete(i);
      end;
    end;

    // набираем стратоны которые подлежат добавлению
    for i := 0 to Value.Count - 1 do
    begin
      S := FStratons.StratonOfID(Value[i].StratonID);
      if (not Assigned(S)) then
      begin
        //ToAdd.AddStratonRef(Value[i]);
        FStratons.AddStratonRef(Value[i]);
      end;
    end;

    // удаляем
    //sFilter := ToRemove.MakeFilter;
    if sFilter <> '' then
    begin
      sFilter := '(' + sFilter + ')';
      iResult := IServer.DeleteRow('TBL_SUBDIVISION_COMPONENT',
                                   'where WELL_UIN = ' + IntToStr(iWellUIN) +
                                   ' and BLOCK_ID = ' + IntToStr(iBlockID) +
                                   ' and STRATON_ID in ' + sFilter);
    end;

    // добавляем
{    if iResult >= 0 then
    begin
      for i := 0 to Value.Count - 1 do
      begin
        iResult := IServer.InsertRow('TBL_SUBDIVISION_COMPONENT',
                                      varArrayOf(['STRATON_ID',
                                                  'NEXT_STRATON_ID',
                                                  'WELL_UIN',
                                                  'BLOCK_ID',
                                                  'COMMENT_ID',
                                                  'EDGE_COMMENT_ID',
                                                  'NUM_DEPTH']),
                                      varArrayOf([Value.Items[i].StratonID, 0,
                                                  iWellUIN,
                                                  iBlockID,
                                                  FSubDivisionCommentID,
                                                  0,
                                                  Depth]));
        if iResult < 0 then break;
      end;
    end;  }
  end;

  //if iResult >= 0 then iResult := PostToDB;

  {if iResult >= 0 then
  for i := 0 to Value.Count - 1 do
    FStratons.AddStratonRef(Value[i]);}

  {ToAdd.Free;
  ToRemove.Free;}
  ((Collection as TSubDivisionComponents).FSubDivision.Collection as TSubDivisions).FWell.ChangesMade := true;
end;

function    TSubdivisionComponent.GatheredPost: smallint;
var vValues: variant;
    i, iWellUIN, iBlockID, iNextStraton, iLastSubdivisionComponent: integer;
    sFilter: string;
begin
  Result := 0;
  iWellUIN := ((Collection as TSubDivisionComponents).FSubDivision.Collection as TSubDivisions).FWell.FWellUIN;
  iBlockID := (Collection as TSubDivisionComponents).FSubDivision.FPropertyID;

  {

    WELL_UIN INTEGER,
    STRATON_ID SMALLINT,
    NEXT_STRATON_ID SMALLINT,
    BLOCK_ID INTEGER,
    EDGE_COMMENT_ID INTEGER,
    COMMENT_ID SMALLINT,
    NUM_DEPTH NUMERIC(8,3)
  }
  for i := 0 to LastStratons.Count - 1 do
  begin
    vValues := varArrayOf([iWellUIN, iBlockID, LastStratons[i].StratonID]);
    Result := IServer.InsertRow('SPD_DELETE_SUBDIV_COMPONENT', NULL, vValues);
  end;


  {  Result := IServer.DeleteRow('TBL_SUBDIVISION_COMPONENT',
                                'where WELL_UIN = ' + IntToStr(iWellUIN) +
                                ' and BLOCK_ID = ' + IntToStr(iBlockID) +
                                ' and STRATON_ID in ' + '(' + sFilter + ')');}

  for i := 0 to Stratons.Count - 1 do
  begin
    iNextStraton := 0;
    if (Stratons.Count = 2) and (Divider = '-') then
       iNextStraton := Stratons[1].StratonID;

    iLastSubdivisionComponent := FSubdivisionCommentID;
    if (FSubdivisionCommentID = 0) and (Stratons.Count > 1) and (i <> Stratons.Count - 1) and (Divider = '+') then
      FSubdivisionCommentID := 1;
    if (FSubdivisionCommentID = 1) and (Stratons.Count > 1) and (i = 0) then
      FSubdivisionCommentID := 0;


    vValues := varArrayOf([iWellUIN, Stratons[i].StratonID, iNextStraton, iBlockID, 0, FSubdivisionCommentID, Depth, ord(Verified)]);

    Result := IServer.SelectRows('SPD_ADD_SUBDIVISION_COMPONENT', '*', '', vValues);

    FSubdivisionCommentID := iLastSubdivisionComponent;
    if (Result < 0) or (iNextStraton > 0)  then break;
  end;
end;


// TSubDivisionComponents

constructor TSubDivisionComponents.Create(ASubDivision: TSubDivision);
begin
  inherited Create(TSubDivisionComponent);
  FSubDivision := ASubDivision;
end;

function    TSubDivisionComponents.ComponentByStratons(AStratons: TStratons; const ADivider: string): TSubDivisionComponent;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if  (((Items[i].Stratons.Count > 1) and (Items[i].Divider = ADivider))
  or  (Items[i].Stratons.Count = 1)) and Items[i].Stratons.EqualTo(AStratons) then
  begin
    Result := Items[i];
    break;
  end;
end;

function    TSubDivisionComponents.ComponentByID(AStratonID: integer): TSubDivisionComponent;
var i, j: integer;
    Found: boolean;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  begin
    Found := false;
    for j := 0 to Items[i].Stratons.Count - 1 do
    if Items[i].Stratons[j].StratonID = AStratonID then
    begin
      Result := Items[i];
      Found := true;
      break;
    end;
    if Found then Break;
  end;
end;



procedure TSubDivisionComponents.AssignTo(Dest: TPersistent);
var i: integer;
begin
  for i := 0 to Count - 1 do
    (Dest as TSubDivisionComponents).Items[i].Assign(Items[i]);
end;


function TSubDivisionComponents.GetItem(const Index: integer): TSubDivisionComponent;
begin
  Result := TSubDivisionComponent(inherited Items[Index]);
end;

destructor TSubDivisionComponents.Destroy;
var i: integer;
begin
  for i := Count - 1 downto 0 do
    Items[i].Free;
  inherited Destroy;
end;

// TSubDivision - стратиграфическая разбивка

constructor TSubDivision.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FContent := TSubDivisionComponents.Create(Self);
end;

procedure   TSubDivision.AssignTo(Dest: TPersistent);
begin
  with Dest as TSubDivision do
  begin
    FLastDepth := Self.LastDepth;
    FProperty  := Self.FProperty;
    FPropertyID := Self.FPropertyID;
    FShortBlockName := Self.FShortBlockName;
    FContent.Assign(Self.FContent);
  end;
end;

procedure   TSubDivision.UpdateSubDivision(AProperty: string; DB: boolean);
var iResult, iNewPropertyID: integer;
begin
  iNewPropertyID := GetObjectId(AllDicts.TectBlockDict, AProperty);
  if iNewPropertyID <> FPropertyID then
  begin
    iResult := 1;
    if DB then
    begin
      iResult := IServer.UpdateRow('TBL_SUBDIVISION_COMPONENT',
                                   'BLOCK_ID', iNewPropertyId,
                                   'WELL_UIN = ' + IntToStr((Collection as TSubDivisions).FWell.WellUIN) +
                                   ' AND BLOCK_ID = ' + IntToStr(FPropertyID));
    end;

    if iResult >= 0 then
    begin
      TectonicBlock := AProperty;
      FPropertyID := iNewPropertyID;
      (Collection as TSubDivisions).FWell.ChangesMade := true;
      ShortBlockName := GetObjectName(AllDicts.TectBlockDict, FPropertyID, 2);
    end;
  end;
end;

procedure   TSubDivision.DeleteComponent(const Index: integer; const DB: boolean);
var iWellUIN, iBlockID, iNextStratonID, iResult: integer;
    sFilter: string;
begin
  iResult := 0;
  if DB then
  begin
    iNextStratonID := 0;
    if  (Content.Items[Index].Stratons.Count = 2)
    and (Content.Items[Index].Divider = '-') then
    begin
      sFilter := IntToStr(Content.Items[Index].Stratons[0].StratonId);
      iNextStratonID := Content.Items[Index].Stratons[1].StratonID
    end
    else sFilter := Content.Items[Index].Stratons.MakeFilter;

    sFilter := '(' + sFilter +')';
    iWellUIN := (Collection as TSubDivisions).FWell.WellUIN;
    iBlockID := FPropertyID;
    iResult := IServer.DeleteRow('TBL_SUBDIVISION_COMPONENT',
                                 'WHERE WELL_UIN = ' + IntToStr(iWellUIN) +
                                ' AND STRATON_ID in ' + sFilter + 
                                ' AND NEXT_STRATON_ID = ' + IntToStr(iNextStratonID) +
                                ' AND BLOCK_ID = ' + IntToStr(iBlockID));

  end;

  //Content.Items[Index].Free;
  if iResult > 0 then 
  try
   (Collection as TSubDivisions).FWell.ChangesMade := true;
    Content.Delete(Index);
  except
    Exit;
  end;
  //else raise ECantRemoveComponent.Create('Не удалось удалить границу!');
end;

function    TSubDivision.AddComponent(AStratons: TStratons; const ADivider: char; ACommentID: integer; ADepth: single; AVerified: boolean): TSubDivisionComponent;
var i: integer;
begin
  Result :=  Content.Add As TSubDivisionComponent;
  Result.Divider := ADivider;
  if (ADivider = '+') then
  begin
    with Result do
    begin
      for i := 0 to AStratons.Count - 1 do
        Stratons.AddStratonRef(AStratons.Items[i]);
      FDepth  := ADepth;
      FSubDivisionCommentID := ACommentID;
      FSubDivisionComment := GetObjectName(AllDicts.FullCommentDict, ACommentID, 2);
      FVerified := AVerified;
      // набираем коментарии
      // запросом из БД
    end;
  end
  else
  begin
    for i := 0 to AStratons.Count - 1 do
    with Result do
    begin
      Stratons.AddStratonRef(AStratons[i]);
      FDepth  := ADepth;
      FSubDivisionCommentID := ACommentID;
      FSubDivisionComment := GetObjectName(AllDicts.FullCommentDict, ACommentID, 2);
      FVerified := AVerified;
    end;
  end
end;


function    TSubDivision.AddComponent(AStratonIDs: variant; const ADivider: char; ACommentID: integer; ADepth: single; AVerified: boolean): TSubDivisionComponent;
var i: integer;
    S: TStraton;
begin
  Result := nil;
  if (GatherComponents) or (ADivider = '-') then
  begin
    Result :=  Content.Add As TSubDivisionComponent;
    Result.Divider := ADivider;
    with Result do
    begin
      for i := 0 to varArrayHighBound(AStratonIDs, 1) do
      begin
        S := AllStratons.StratonOfId(AStratonIds[i]);
        if Assigned(S) then Stratons.AddStratonRef(S);
      end;
      FDepth  := ADepth;
      FSubDivisionComment := GetObjectName(AllDicts.FullCommentDict, ACommentID,2);
      SubDivisionCommentID := ACommentID;
      FVerified := AVerified;
      // набираем коментарии
      // запросом из БД
    end;
  end
  else
  begin
    for i := 0 to varArrayHighBound(AStratonIDs, 1) do
    begin
      Result :=  Content.Add As TSubDivisionComponent;
      Result.Divider := ADivider;
      with Result do
      begin
        S := AllStratons.StratonOfId(AStratonIds[i]);
        if Assigned(S) then Stratons.AddStratonRef(S);
        FDepth  := ADepth;
        FSubDivisionComment := GetObjectName(AllDicts.FullCommentDict, ACommentID, 2);
        FSubDivisionCommentID := ACommentID;
        FVerified := AVerified;
      end;
    end;
  end
end;

function    TSubDivision.PostToDB: smallint;
var i, iResult: integer;
begin
  Result := 0;
  // добавляем компоненты
  for i := 0 to Content.Count - 1 do
  begin
    iResult := Content[i].PostToDB;
    if iResult = 1 then Result := Result + iResult
    else break;
  end;
  (Collection as TSubDivisions).FWell.ChangesMade := true;
end;

destructor  TSubDivision.Destroy;
begin
  Content.Free;
  inherited Destroy;
end;


// список стратиграфических разбивок для некой скважины
constructor TSubDivisions.Create(AWell: TWell);
begin
  inherited Create(TSubDivision);
  FWell := AWell;
end;

function    TSubDivisions.SubDivisionByID(APropertyID: integer): TSubDivision;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].FPropertyID = APropertyID then
  begin
    Result := Items[i];
    break;
  end;
end;

procedure   TSubDivisions.DeleteSubdivision(const Index: integer; DB: boolean);
var iResult: integer;
begin
  iResult := 0;
  if DB then
    iResult := IServer.DeleteRow('TBL_SUBDIVISION_COMPONENT',
                                 'WHERE WELL_UIN = ' + IntToStr((Items[Index].Collection as TSubDivisions).FWell.WellUIN) +
                                 ' AND BLOCK_ID = ' + IntToStr(Items[Index].FPropertyID));


  if iResult >= 0 then Items[Index].Free;
  FWell.ChangesMade := true;

  {try
    Delete(Index);
  except
    exit;
  end;
  raise ECantRemoveSubdivision.Create('Не удалось удалить разбивку ' +
                                      Items[Index].FProperty + '(' + (Items[Index].Collection as TSubDivisions).FWell.ListWell + ') из базы данных разбивок!!! ');}
end;

{procedure   TSubDivisions.LoadSubDivisions;
var i, iResult: integer;
    vResult: variant;
begin
  // запрашиваем из БД список разбивок для данной скважины
  if Assigned(FWell) then
  begin
    // задать поля
    iResult := IServer.SelectRows('TBL_SUBDIVISION', '*', 'WELL_UIN = ' + IntToStr(FWell.FWellUIN), null);
    if iResult > 0 then
    begin
      vResult := IServer.QueryResult;
      for i := 0 to varArrayHighBound(vResult, 2) do
          AddSubDivision(vResult[0, i], vResult[1, i], vResult[2, i], vResult[3, i], vResult[4, i]);
    end;
  end;
end;}

procedure   TSubDivisions.AssignTo(Dest: TPersistent);
var i: integer;
begin
  for i := 0 to Count - 1 do
    (Dest as TSubDivisions).Items[i].Assign(Items[i]);
end;

function    TSubDivisions.GetItem(const Index: integer): TSubDivision;
begin
  Result := TSubDivision(inherited Items[Index]);
end;


function    TSubDivisions.AddSubDivision(const APropertyID: integer): TSubDivision;
var i, iOrderID: integer;
    S: TSubdivision;
begin
  Result := SubDivisionByID(APropertyID);
  iOrderID := GetObjectName(AllDicts.TectBlockDict, APropertyID, 3);
  if not Assigned(Result) then
  begin
    i := 1;
    S := nil;
    repeat
      S := SubDivisionByID(iOrderID);
      inc(i);
    until (i > iOrderID) or Assigned(S);

    if Assigned(s) then
      Result := Insert(s.Index + 1) as TSubDivision
    else Result := Add as TSubDivision;

    with Result do
    begin
      FProperty :=   GetObjectName(AllDicts.TectBlockDict, APropertyID);
      FPropertyId := APropertyID;
      ShortBlockName := GetObjectName(AllDicts.TectBlockDict, FPropertyID, 2);
      FWell.ChangesMade := true;
      {if FPropertyId = 0 then
      begin
        FPropertyId := GetObjectId(AllDicts.CommentDict, FProperty, 2);
        if FPropertyId > 0 then
          FProperty := GetObjectName(AllDicts.CommentDict, FPropertyID);;
      end;}
    end;
  end;
end;

function    TSubDivisions.IsComplete: boolean;
begin
  Result := (Count = varArrayHighBound(AllDicts.TectBlockDict, 2) + 1);
end;

function    TSubDivisions.AddSubDivision(const AProperty: string): TSubDivision;
var i, iPropertyID, iOrderID, iIndex: integer;
    s: TSubdivision;
begin
  iPropertyId := GetObjectId(AllDicts.TectBlockDict, AProperty, 2);
  iOrderID := GetObjectName(AllDicts.TectBlockDict, iPropertyID, 3);
  Result := SubDivisionByID(iPropertyID);
  if not Assigned(Result) then
  begin
    i := 1;
    repeat
      S := SubDivisionByID(iOrderID);
      inc(i);
    until (i > iOrderID) or Assigned(S);

    if Assigned(S) then
      Result := Insert(s.Index + 1) as TSubDivision
    else Result := Add as TSubdivision;
    with Result do
    begin
      FProperty := AProperty;
      FPropertyId := iPropertyID;
      ShortBlockName := GetObjectName(AllDicts.TectBlockDict, FPropertyID, 2);
      FWell.ChangesMade := true;
      {if FPropertyId = 0 then
      begin
        FPropertyId := GetObjectId(AllDicts.CommentDict, FProperty, 2);
        if FPropertyId > 0 then
          FProperty := GetObjectName(AllDicts.CommentDict, FPropertyID);;
      end;}
    end;
  end;
end;

{function    TSubDivisions.AddSubDivisionFromFile(const ASubDivisionID: integer;
                                                 const ADesc, AAuthors: string;
                                                 AStartDate: TDate;
                                                 AProperty: string): TSubDivision;
begin
  Result := Add as TSubDivision;
  with Result do
  begin
    FSubDivisionID := ASubDivisionID;
    FDesc := ADesc;
    FAuthors := AAuthors;
    FStartDate := AStartDate;
    FProperty := AProperty;
    FPropertyID := GetObjectID(AllDicts.SubDivisionProperties, FProperty);
  end;
end;}


destructor  TSubDivisions.Destroy;
var i: integer;
begin
  for i := Count - 1 downto 0 do
    Items[i].Free;
  inherited Destroy;
end;


function   TWell.UpdateWell(AWellUIN: integer; AAreaName, AWellNum: string; const AAltitude, ADepth: single; DB: boolean): integer;
begin


  if DB then
    Result := IServer.UpdateRow('TBL_SUBDIVISION_COMPONENT',
                                 'WELL_UIN', AWellUIN,
                                 'WELL_UIN = ' + IntToStr(WellUIN))
  else Result := 1;

  if Result >= 0 then
  begin
    FAreaID   := GetObjectID(AllDicts.AreaDict, AAreaName);
    FWellNum  := AWellNum;
    FAreaName := AAreaName;
    FAltitude := AAltitude;
    FDepth    := ADepth;
    FOldAreaName := AAreaName;
    FOldWellNum  := AWellNum;
    FWellUIN  := AWellUIN;
    ChangesMade := true;
  end;
end;

function    TWell.ListWell: string;
begin
  Result := 'скв. ' + WellNum + ' - ' + AreaName;
  Result := Result + ' альт.: ' + Format('%6.2f', [Altitude]);
  Result := Result + ' забой: ' + Format('%7.2f', [Depth]);
end;

procedure TWell.AssignTo(Dest: TPersistent); 
begin
  with Dest as TWell do
  begin
    FAreaID := Self.FAreaID;
    FWellUIN := Self.WellUIN;
    FDepth := Self.Depth;
    FAltitude := Self.Altitude;
    FAreaName := Self.AreaName;
    FWellNum  := Self.WellNum;
    FOldAreaName := Self.OldAreaName;
    FOldWellNum := Self.OldWellNum;
    FSubDivisions.Assign(Self.FSubDivisions);
  end;
end;

constructor TWell.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  // создаем список разбивок для скважины
  FSubDivisions := TSubDivisions.Create(Self);
  FChanged := false;
end;

destructor  TWell.Destroy;
begin
  SubDivisions.Free;
  inherited Destroy;
end;

// список скважин
function TWells.GetItem(const Index: integer): TWell;
begin
  Result := TWell(inherited Items[Index]);
end;

function  TWells.GetFilter: string;
var i: integer;
begin
  Result := '';
  for i := 0 to Count - 1 do
    Result := Result + ', ' + IntToStr(Items[i].WellUIN);
  if Result <> '' then
  Result := '(' + copy(Result, 2, Length(Result)) + ')';
end;

function TWells.WellByName(AWellNum, AAreaName: string): TWell;
var i: integer;
begin
  Result := nil;
  AAreaName := RusTransletter(AAreaName);
  for i := 0 to Count - 1 do
  if ((Items[i].WellNum = AWellNum) and
     (AnsiUpperCase(Items[i].AreaName) = AAreaName)) or
     ((Items[i].OldWellNum = AWellNum) and
     (RusTransLetter(Items[i].OldAreaName) = AAreaName)) then
  begin
    Result := Items[i];
    break;
  end;
end;

function TWells.WellByName(const AWellNum: string; const AAreaID: integer): TWell;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if ((Items[i].WellNum = AWellNum) or
     (Items[i].OldWellNum = AWellNum)) and
     (Items[i].FAreaID = AAreaID) then
  begin
    Result := Items[i];
    break;
  end;
end;

function TWells.WellByAltitudeDepth(const AAreaName: string; AAltitude, ADepth: single): TWell;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if (pos(AAreaName, Items[i].AreaName) > 0) and
     (AAltitude = Items[i].Altitude) and
     (ADepth = Items[i].Depth) then
  begin
    Result := Items[i];
    break;
  end;
end;

function TWells.WellByUIN(const AWellUIN: integer): TWell;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].FWellUIN = AWellUIN then
  begin
    Result := Items[i];
    break;
  end;
end;

function    TWells.AddWell(AWell: TWell; const Copy: boolean): TWell;
begin
  if Copy then
  begin
    Result := WellByUIN(AWell.WellUIN);
    if not Assigned(Result) then
    begin
      Result := Add as TWell;
      Result.Assign(AWell);
    end
  end
  else Result := AddWell(AWell.WellUIN, AWell.AreaName, AWell.WellNum, AWell.Altitude, AWell.Depth, AWell.SubDivisions.Count = 0);
end;

procedure TWells.GetStratRegions(ARegions: TRegions);
var vResult: variant;
    i, iResult: integer;
    sQuery, sFilter: string;
begin

  sQuery := 'select distinct m.Region_ID  ' +
            'from tbl_well_position p, ' +
            'tbl_stratotype_region_member m ' +
            'where m.struct_id = p.struct_id ';

  sFilter := GetFilter;

  if sFilter <> '' then sQuery := sQuery + ' and ' + sFilter;

  iResult := IServer.ExecuteQuery(sQuery);
  if iResult > 0 then
  begin
    vResult := IServer.QueryResult;
    for i := 0 to varArrayHighBound(vResult, 2) do
      ARegions.AddRegionRef(AllRegions.RegionOfID(vResult[0, i]));
  end;
end;


function   TWells.DeleteWell(const Index: integer; DB: boolean): integer;
var vValue: variant;
begin
  Result := 0;
  if DB then
  begin
    vValue := varArrayOf([Items[Index].WellUIN]);
    Result := IServer.InsertRow('SPD_DELETE_SUBDIV_WELL', null, vValue);
  end;

  if Result >=0 then Items[Index].Free;
  {try
    Delete(Index);
  except
    exit;
  end;
  raise ECantRemoveWell.Create('Не удалось удалить скважину ' + Items[Index].ListWell + ' из базы данных разбивок!!! ');}
end;

function    TWells.StratonsCount(AStratons: TStratons): integer;
var w, s, c: integer;
begin
  Result := 0;
  for w := 0 to Count - 1 do
  for s := 0 to Items[w].SubDivisions.Count - 1 do
  for c := 0 to Items[w].SubDivisions[s].Content.Count - 1 do
  if Items[w].SubDivisions[s].Content[c].Stratons.EqualTo(AStratons) then
  begin
    inc(Result);
    break;
  end;
end;



function    TWells.AddWell(AWellUIN: integer; AAreaName, AWellNum: string; const AAltitude, ADepth: single; const WithSubdivisions: boolean): TWell;
var i, iResult, iBlockID, iLastBlockID, iLastCommentID: integer;
    fLastDepth: single;
    sD: TSubDivision;
    sC: TSubDivisionComponent;
    vResult: variant;
begin
  Result := WellByUIN(AWellUIN);

  // если не нашли
  // спрашиваем в БД и добавляем
  if not Assigned(Result) then
  begin
    Result := Add as TWell;
    with Result do
    begin
      FWellUIN  := AWellUIN;
      FAreaID   := GetObjectID(AllDicts.AreaDict, AAreaName);
      FWellNum  := AWellNum;
      FAreaName := AAreaName;
      FAltitude := AAltitude;
      FDepth    := ADepth;
      FOldAreaName := AAreaName;
      FOldWellNum  := AWellNum;
    end;
  end;


//  if (WithSubdivisions) or (Result.SubDivisions.Count = 0) then
//  begin
//    Result.SubDivisions.Clear;
//    Result.GetSubDivisions(nil);
//  end;
end;

function    TWells.AddWell(AAreaName, AWellNum: string; const AAltitude, ADepth: single): TWell;
begin
  Result := Add as TWell;
  with Result do
  begin
    FWellUIN  := 0;
    FAreaID   := 0;
    FWellNum  := AWellNum;
    FAreaName := AAreaName;
    FAltitude := AAltitude;
    FDepth    := ADepth;

    FOldAreaName := AAreaName;
    FOldWellNum  := AWellNum;
  end;
end;

function    TWells.AddWell(AAreaName, AWellNum, AOldAreaName, AOldWellNum: string; const AAltitude, ADepth: single; out Found: variant): TWell;
var iAreaID, iResult: integer;
begin
  // сначала тщательно ищем
  // может быть такая скважина уже есть
  Result := nil;
  iAreaId := GetObjectId(AllDicts.AreaSynonyms, AAreaName, 2);
  if iAreaId > 0 then
    Result := WellByName(AWellNum, iAreaID)
  else
    Result := WellByName(AWellNum, AAreaName);

  if not Assigned(Result) then
  begin
    iAreaID := GetObjectID(AllDicts.AreaDict, AAreaName);
    if iAreaID > 0 then  Result := WellByName(AWellNum, iAreaID)
  end;


  // если не нашли
  // спрашиваем в БД и добавляем
  if not Assigned(Result) then
  begin
    if iAreaID <= 0 then
       iResult := IServer.ExecuteQuery('select w.Well_UIN, w.Area_ID, w.vch_Well_Num, ' +
                                       'vch_Area_Name, '+
                                       'num_Rotor_Altitude, num_True_Depth ' +
//                                       'from vw_Well_Main_Info ' +
                                       'from vw_Well w ' +
                                       'where UPPER(vch_Area_Name) = UPPER(' + '''' +
                                       AAreaName + '''' + ') and vch_Well_Num = ' + '''' + AWellNum + '''')
    else
       iResult := IServer.ExecuteQuery('select w.Well_UIN, w.Area_ID, w.vch_Well_Num, ' +
                                       'w.vch_Area_Name, '+
                                       'w.num_Rotor_Altitude, w.num_True_Depth ' +
//                                       'from vw_Well_Main_Info ' +
                                       'from vw_Well w ' +
                                       'where Area_ID = ' + IntToStr(iAreaID) +
                                       ' and vch_Well_Num = ' + '''' + AWellNum + '''');

    if iResult = 0 then
    begin
      // выводить несовпадения по альтитудам и забою
      iResult := IServer.ExecuteQuery('select w.Well_UIN, w.Area_ID, w.vch_Well_Num, ' +
                                      'w.vch_Area_Name, '+
                                      'w.num_Rotor_Altitude, w.num_True_Depth ' +
//                                      'from vw_Well_ Main_Info ' +
                                       'from vw_Well w ' +
                                      'where vch_Area_Name containing ' + ''''  + AAreaName
                                      + '''' + ' and (num_Rotor_Altitude = ' + StringReplace(trim(Format('%6.2f', [AAltitude])), ',', '.', []) +
                                      ' or num_True_Depth = ' + StringReplace(trim(Format('%6.2f', [ADepth])), ',', '.', []) + ')');

      if iResult = 0 then
         raise EWellNotFound.Create('Скважина ' + AWellNum + ' - ' + AAreaName + ' не найдена.' +
                                    'Альтитуда искомой: '+ Format('%6.2f', [AAltitude]) +
                                    ', забой: ' + Format('%6.2f', [ADepth]) + '.')
      else
      begin
        Found := IServer.QueryResult;
        raise EWellFoundByAltitude.Create('Скважина ' + AWellNum + ' - ' + AAreaName
                                          + ' найдена по косвенным признакам: альтитуда = ' + Format('%6.2f', [AAltitude])
                                          + '; забой = ' + Format('%6.2f', [ADepth]) +
                                          '. Требуется подтверждение.');
      end;
    end
    else
    begin
      Found := IServer.QueryResult;
      Result := Add as TWell;
      with Result do
      begin
        FWellUIN  := Found[0, 0];
        FAreaID   := Found[1, 0];
        FWellNum  := Found[2, 0];
        FAreaName := Found[3, 0];
        FAltitude := Found[4, 0];
        FDepth    := Found[5, 0];

        FOldAreaName := AOldAreaName;
        FOldWellNum  := AOldWellNum;

        if (FOldAreaName <> FAreaName) and (FAreaID > 0) then
           AllDicts.AddAreaSynonym(FAreaId, FAreaName, FOldAreaName);
      end;
    end;
  end;
end;

destructor  TWells.Destroy;
var i: integer;
begin
  for i := Count - 1 downto 0 do
    Items[i].Free;
  inherited Destroy;
end;

function TStratons.Includes(AInStratons: TStratons): boolean;
var i: integer;
begin
  if (AInStratons.Count > 0) and (Count > 0) then Result := true
  else Result := false;
  for i := 0 to AInStratons.Count - 1 do
  if not Assigned(StratonOfID(AInStratons[i].StratonID)) then
  begin
    Result := false;
    break;
  end;
end;

{ TOrderedSubdivisionComponent }

constructor TOrderedSubdivisionComponent.Create;
begin
  FSCList := TSubdivisionComponentList.Create;
end;

destructor TOrderedSubdivisionComponent.Destroy;
begin
  FSCList.Free;
  inherited;
end;

function TOrderedSubdivisionComponent.PostToDB: smallint;
var i: integer;
begin
  for i := 0 to SCList.Count - 1 do
  begin
    SCList[i].Depth := Depth;
    SCList[i].SubDivisionCommentID := SubDivisionCommentID;
    SCList[i].SubDivisionComment := SubDivisionComment;
    SCList[i].PostToDB;
  end;
end;

{ TSubdivisionComponentList }

constructor TSubdivisionComponentList.Create;
begin
  inherited;
  OwnsObjects := false;
end;

function TSubdivisionComponentList.GetItems(
  const Index: integer): TSubdivisionComponent;
begin
  Result := TSubDivisionComponent(inherited Items[Index]);
end;

procedure TWells.GatherStratons(Stratons: TStratons);
begin

end;

procedure TWell.GetSubdivisions(ExcludedStratons: TStratons);
var iResult, iLastBlockID, iLastCommentID, i, iBlockID, iLastSynonymID: integer;
    vResult: variant;
    sD: TSubdivision;
    sC: TSubDivisionComponent;
    s: TStraton;
    fLastDepth: single;
    bLastAssigned: boolean;

begin
    // спрашиваем разбивки и добавляем их
{    iResult := IServer.ExecuteQuery('select s.Straton_ID, s.Next_Straton_ID, s.block_id, ' +
                                    's.num_depth, s.comment_id ' +
                                    'from tbl_subdivision_component s ' +
                                    'left join tbl_Tectonic_Block t on (s.Block_ID = t.Block_ID) ' +
                                    'where s.Well_UIN = ' + IntToStr(WellUIN) +
                                    ' order by t.num_Order, s.num_depth desc, s.Comment_ID');}

    iResult := IServer.ExecuteQuery('select distinct sn.Straton_ID, s.Next_Straton_ID, s.block_id, ' +
                                    's.num_depth, s.comment_id, s.num_Verified ' +
                                    'from tbl_subdivision_component s, ' +
                                    'vw_stratigraphy_dict sn, ' +
                                    'tbl_Tectonic_Block t ' +
                                    'where s.Well_UIN = ' + IntToStr(WellUIN) +
                                    'and s.Block_ID = t.Block_ID ' +
                                    'and s.straton_id = sn.straton_id ' +
                                    'and (s.comment_id <> 3) ' +
                                    'and (s.Comment_ID <> 4) ' +
                                    'order by t.num_Order, sn.num_age_of_base desc, s.Num_depth desc, s.Comment_ID');
    if iResult > 0 then
    begin
      vResult := IServer.QueryResult;
      iLastBlockID := -1; sD := nil; sC := nil; fLastDepth := -1; iLastCommentID := vResult[4, 0]; iLastSynonymID := 0;
      bLastAssigned := false;
      for i := 0 to varArrayHighBound(vResult, 2) do
      begin
        s := AllStratons.StratonOfId(vResult[0, i]);
        if  Assigned(sC) and
            GatherComponents and
            ((not varIsEmpty(vResult[3, i])) and (abs(fLastDepth - vResult[3, i]) < 0.0001)) and
//            (iLastCommentID = vResult[4, i]) and
            (iLastSynonymID > 0) and
            (iLastSynonymID = s.SynonymID)

//            (sC.Stratons.Items[sC.Stratons.Count - 1].TaxRange = s.TaxRange)

//            (vResult[3, i] > 0)
//            and sc.Associative
//            and ((not Assigned(ExcludedStratons)) or (not Assigned(ExcludedStratons.StratonOfID(vResult[0, i]))))
            then
        begin
          sC.Stratons.AddStratonRef(s);
          sC.SubDivisionCommentID :=  vResult[4, i];
          // если идет такое добавление, то это точно плюсовик
          sC.Divider := '+';
        end
        else
        begin
          iBlockID := vResult[2, i];
          if iLastBlockID <> iBlockID then
            sD := SubDivisions.AddSubDivision(iBlockID);

          sC := sD.AddComponent(varArrayOf([vResult[0, i], vResult[1, i]]), '-', vResult[4, i], vResult[3, i], varAsType(vResult[5, i], varInteger) = 1);
//          if Assigned(ExcludedStratons.StratonOfID(vResult[0, i])) then sc.Associative := false;
          iLastBlockId := iBlockID;
        end;

        iLastCommentID := vResult[4, i];
        fLastDepth := vResult[3, i];
        iLastSynonymID := s.SynonymID;
        if Assigned(ExcludedStratons) then
          bLastAssigned := Assigned(ExcludedStratons.StratonOfID(vResult[0, i]));
      end;
    end;
end;

{ TExcludedStratons }

constructor TExcludedStratons.Create(const Filter: string);
var iResult: integer;
    vResult: variant;
begin
  inherited Create(false);

  iResult := IServer.ExecuteQuery('select sn.STRATON_ID, ' +
                                  'max(VCH_STRATON_INDEX), ' +
                                  'max(VCH_STRATON_DEFINTION), ' +
                                  'max(VCH_TAXONOMY_UNIT_NAME), ' +
                                  'max(NUM_AGE_OF_BASE), ' +
                                  'max(NUM_AGE_OF_TOP), ' +
                                  'max(VCH_STRATON_DEF_SYNONYM), ' +
                                  'max(NUM_TAXONOMY_UNIT_RANGE), ' +
                                  'max(VCH_REGION_NAME) ' +
//                                  'sum(Comment_ID) - count(Well_UIN)' +
                                  'from tbl_subdivision_component sc, ' +
                                  'spd_get_straton_for_subdivision sn ' +
                                  'where Well_UIN in ' + Filter + ''+
                                  'and sn.straton_id = sc.straton_id ' +
                                  'and Comment_ID <= 1 ' +
                                  'group by sn.straton_id ' +
                                  'having (sum(Comment_ID)  <> (count (Distinct Block_ID))) ' +
                                  'and sum(Comment_ID) > 0 ' +
                                  'order by sc.num_depth desc, sc.Comment_ID');

  if iResult > 0 then
  begin
    vResult := IServer.QueryResult;
    AssignFromVariant(vResult);
  end;
end;

procedure TStratons.Exclude(AInStratons: TStratons);
var s: TStraton;
    i: integer;
begin
  for i := 0 to AInStratons.Count - 1 do
  begin
    s := StratonOfID(AInStratons[i].StratonID);
    if Assigned(s) then
     s.Free;
  end;
end;

function TSubDivisionComponent.GetStratons: TStratons;
begin
  // перед тем, как сятнули на себя - скопировали в LastStratons
  // а то мало ли что
  FLastStratons.Assign(FStratons);
  Result := FStratons;
end;

function TStratons.IsParent(AStratons: TStratons; AChildren, ARest: TStratons): boolean;
var i, j: integer;
begin
  Result := false;

  AChildren.Clear;
  for i := 0 to AStratons.Count - 1 do
  if   Assigned(AStratons.Items[i].ParentStraton)
  and (Assigned(StratonOfID(AStratons.Items[i].ParentStraton.StratonID))) then
  begin
    AChildren.AddStratonRef(AStratons.Items[i]);
    Result := true;
  end;
  //else ARest.AddStratonRef(AStratons.Items[i]);

  // в рест остаются те, которые подчинены этому же стратону
  // это не совсем правильно поскольку в таком случае в одну коллекцию объединяются
  // потомки разных стратонов
  if Result then
  begin
    for i := 0 to AStratons.Count - 1 do
    if Assigned(AStratons.Items[i].ParentStraton) and Assigned(StratonOfID(AStratons.Items[i].ParentStraton.StratonID)) then
    for j := 0 to AStratons.Items[i].ParentStraton.Children.Count - 1 do
      ARest.AddStratonRef(AStratons.Items[i].ParentStraton.Children.Items[j]);

    ARest.Exclude(AChildren);
  end;
end;

function TStraton.IsIn(AStratons: TStratons): boolean;
var i: integer;
begin
  Result := false;
  for i := 0 to AStratons.Count - 1 do
  if AStratons.Items[i].ID = ID then 
  begin
    Result := true;
    break;
  end;
end;

function TStraton.GetChildren: TStratons;
var iResult: integer;
    vDict: variant;
begin
  if not Assigned(FChildren) then
  begin
    FChildren := TStratons.Create(false);

    iResult := IServer.ExecuteQuery ('Select * from spd_Get_Straton_For_Subdivision('+IntToStr(StratonID)+')');

    if iResult > 0 then
    begin
      vDict  := IServer.QueryResult;
      FChildren.AssignFromVariant(vDict);
    end;
  end;

  Result := FChildren;
end;

function TStraton.GetParentStraton: TStraton;
begin
  if (not Assigned(FParentStraton)) and (FParentStratonID > 0) then
    FParentStraton := AllStratons.StratonOfID(FParentStratonID);

  Result := FParentStraton;
end;

function TSubDivisionComponent.GetListDepth: string;
begin
  if  (Depth > -1)
  and ((SubDivisionCommentID = 0)
  or  (((Index = 0) or ((Index > 0)
  and ((Collection as TSubDivisionComponents).Items[Index - 1].Depth <> Depth))))) then
    Result := trim(Format('%6.2f', [Depth]))
  else
    Result := SubDivisionComment;
end;


function TSubDivisionComponent.Next: TSubdivisionComponent;
begin
  if Index < (Collection as TSubDivisionComponents).Count - 1 then
    Result := (Collection as TSubDivisionComponents).Items[Index + 1]
  else
    Result := nil;
end;

function TSubDivisionComponent.Prev: TSubdivisionComponent;
begin
  if Index > 0 then
    Result := (Collection as TSubDivisionComponents).Items[Index - 1]
  else
    Result := nil;
end;

function TSubDivisionComponent.GetInverseThickness: single;
begin
  try
    Result := Depth - Next.Depth;
  except
    Result := -1;
  end;
end;

function TSubDivisionComponent.GetThickness: single;
var p: TSubDivisionComponent;
begin
  try
    if Index < Collection.Count - 1 then
    begin
      p := Prev;
      while Assigned(p) and
      (p.Depth = Depth) 
      do p := p.Prev;

      if Assigned(p) then
        Result := p.Depth - Depth
      else
        Result := -1;
    end
    else
      Result := Depth - ((Collection as TSubDivisionComponents).SubDivision.Collection as TSubDivisions).Well.Altitude; 
  except
    Result := -1;
  end;
end;

end.
