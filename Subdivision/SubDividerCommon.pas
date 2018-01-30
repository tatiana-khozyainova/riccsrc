unit SubDividerCommon;


interface

uses Classes, ClientCommon, SubDividerCommonObjects, SysUtils, Variants;


type

  TDicts = class
  public
    EdgesDict: variant;
    //EdgeRangesDict: variant;
    TectBlockDict: variant;
    CommentDict: variant;
    FullCommentDict: variant;
    StratonsDict: variant;
    AreaDict: variant;
    AreaSynonyms: variant;
    StrRegions: variant;
    PetrolRegions: variant;
    procedure   ReloadStratons;
    procedure   MakeList(ALst: TStringList; ADict: variant);
    procedure   AddAreaSynonym(AAreaID: integer; AAreaName, AAreaSynonym: string);
    constructor Create;
  end;

function Split(const S: string; const Splitter: char): TStrArr;
function EngTransLetter(const S: string): string;
function RusTransLetter(const S: string): string;
function FullTrim(const S: string): string;
function DigitPos(S: string): integer;

var AllDicts:    TDicts;
    AllStratons: TStratons;
    AllSynonyms: TSynonymStratons;
    Allregions: TRegions;
    AllWells:    TWells;
    ActiveWells: TWells;
    ConvertedWells: TWells;
    GatherComponents: boolean = true;
implementation

function FullTrim(const S: string): string;
var i: integer;
begin
  Result := '';
  for i := 1 to Length(S) do
  if S[i] <> ' ' then
    Result := Result + S[i];
end;

function DigitPos(S: string): integer;
var i: char;
    iPos: integer;
begin
  S := trim(S);
  Result := pos('-', S) - 1;
  if Result <= 0 then Result := Length(S);
  for i := '1' to '9' do
  begin
    iPos := pos(i, S);
    if  iPos in [1 .. Result - 1] then
      Result := iPos;
  end;
end;

function RusTransLetter(const S: string): string;
begin
  //Result := AnsiUpperCase(S);
  Result := S;
  Result := StringReplace(Result,'E','Е',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'T','Т',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'Y','У',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'D','Д',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'O','О',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'P','Р',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'A','А',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'H','Н',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'K','К',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'X','Х',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'C','С',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'B','В',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'M','М',[rfReplaceAll,rfIgnoreCase]);
end;

function EngTransLetter(const S: string): string;
begin
  Result := AnsiUpperCase(S);
  Result := StringReplace(Result,'Е','E',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'Т','T',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'З','3',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'У','Y',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'Д','D',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'О','O',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'Р','P',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'А','A',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'Н','H',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'К','K',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'Х','X',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'С','C',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'В','B',[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,'М','M',[rfReplaceAll,rfIgnoreCase]);
end;

function Split(const S: string; const Splitter: char): TStrArr;
var i, iLen, iPrev: integer;
begin
  SetLength(Result, 0); iLen := 0; iPrev := 1;
  for i := 1 to Length(S) do
  if (S[i] = Splitter) or (i = Length(S)) then
  begin
    inc(iLen);
    SetLength(Result, iLen);
    Result[iLen - 1] := Copy(S, iPrev, i - iPrev + ord(i = Length(S)));
    iPrev := i + 1;
  end;
end;


procedure   TDicts.MakeList(ALst: TStringList; ADict: variant);
var i, id: integer;
begin
  for i := 0 to varArrayHighBound(ADict, 2) do
  begin
    id := ADict[0, i];
    ALst.AddObject(ADict[1, i], TObject(id));
  end;
end;

procedure   TDicts.AddAreaSynonym(AAreaID: integer; AAreaName, AAreaSynonym: string);
var iHB: integer;
begin
  iHB := VarArrayHighBound(AreaSynonyms, 2);
  inc(iHB);
  VarArrayRedim(AreaSynonyms, iHB);
  AreaSynonyms[0, iHB] := AAreaID;
  AreaSynonyms[1, iHB] := AAreaName;
  AreaSynonyms[2, iHB] := AAreaSynonym;
end;

constructor TDicts.Create;
var iResult: integer;
begin
  inherited Create;
  CommentDict := GetDictEx('TBL_SUBDIVISION_COMMENT', '*', '(COMMENT_ID <> 3) and (Comment_ID <> 4)');
  FullCommentDict := GetDictEx('TBL_SUBDIVISION_COMMENT');

  TectBlockDict := GetDictEx('TBL_TECTONIC_BLOCK');
  iResult := IServer.ExecuteQuery('select sr.region_id, sr.straton_id, sr.vch_region_name, ' +
                                  'sn.vch_straton_index from tbl_stratotype_region_dict sr, ' +
                                  'tbl_stratigraphy_name_dict sn ' +
                                  'where sn.straton_id = sr.straton_id');
  if iResult > 0 then
     StrRegions := IServer.QueryResult;

  //GetDictEx('TBL_STRATOTYPE_REGION_DICT');
  PetrolRegions := GetDictEx('TBL_PETROLIFEROUS_REGION_DICT', '*', ' where NUM_REGION_TYPE = 3');

  // такой таблицы покамест нету
  // EdgeRangesDict := GetDictEx('TBL_EDGES_RANGES_DICT');

  //SubDivisionProperties := GetDictEx('TBL_SUBDIVISION_COMMENT_DICT');

{  iResult := IServer.ExecuteQuery('SELECT distinct s.straton_id, s.vch_straton_index, ' +
                                  's.vch_straton_definition, s.vch_taxonomy_unit_name, ' +
                                  's.num_Age_Of_Base, s.num_Age_Of_Top, ' +
                                  's.vch_Straton_Def_Synonym, s.num_taxonomy_unit_range ' +
                                  'FROM VW_STRATIGRAPHY_DICT s ' +
                                  'where ((s.num_taxonomy_unit_range < 9) or ' +
                                  's.num_taxonomy_unit_range  in (15, 16, 17, 35, 36)) ' +
                                  'and s.vch_straton_index<>"" ' +
                                  'order by s.num_age_of_base, s.num_range desc, s.num_taxonomy_unit_range');
  iResult := IServer.ExecuteQuery('SELECT distinct s.straton_Region_id, s.vch_straton_index, ' +
                                  's.vch_straton_definition, s.vch_taxonomy_unit_name, ' +
                                  's.num_Age_Of_Base, s.num_Age_Of_Top, ' +
                                  's.vch_Straton_Def_Synonym, s.num_taxonomy_unit_range ' +
                                  'FROM VW_STRATIGRAPHY_DICT s ' +
                                  'where s.Scheme_ID = 1 ' +
                                  'order by s.num_age_of_base, s.num_range desc, s.num_taxonomy_unit_range');}
  {iResult := IServer.ExecuteQuery('SELECT distinct s.straton_id, max(s.vch_straton_index), ' +
                                  'max(s.vch_straton_definition), max(s.vch_taxonomy_unit_name), ' +
                                  'max(s.num_Age_Of_Base), min(s.num_Age_Of_Top), ' +
                                  'max(s.vch_Straton_Def_Synonym), max(s.num_taxonomy_unit_range) ' +
                                  'FROM VW_STRATIGRAPHY_DICT s ' +
                                  'where s.Scheme_ID = 1 ' +
  // не выводим биозоны
                                  'and not((s.vch_Taxonomy_Unit_Name containing ' + '''' + 'зона' + ''''+') or ' +
                                          '(s.vch_Taxonomy_Unit_Name containing ' + '''' + 'лона' + ''''+') or ' +
                                          '(s.vch_Taxonomy_Unit_Name containing ' + '''' + 'шкала'+ ''''+') or ' +
                                          '(s.vch_Taxonomy_Unit_Name containing ' + '''' + 'слой' + ''''+') or ' +
                                          '(s.vch_Taxonomy_Unit_Name containing ' + '''' + 'слои' + ''''+')) ' +
                                  'group by s.Straton_ID ' +
                                  'order by 5, 6, 8');

  if iResult > 0 then
     StratonsDict  := IServer.QueryResult;}
  ReloadStratons;   

  AreaDict := GetDictEx('TBL_AREA_DICT');

  // создаем справочник синонимов площадей
  // ID площади
  // её правильное название
  // встетившийся синоним
  AreaSynonyms := VarArrayCreate([0, 2, 0, 0], varVariant);
end;

procedure TDicts.ReloadStratons;
var iResult: integer;
begin
  iResult := IServer.ExecuteQuery ('Select * from spd_Get_Straton_For_Subdivision(0)');

  if iResult > 0 then
     StratonsDict  := IServer.QueryResult;
end;

end.

