unit CommonFilter;

interface

uses Classes, ClientCommon, ComCtrls, SysUtils, Variants;

type
TWellFilters = class;

TWellFilter = class
private
  FTableID:   integer;
  FTableName: string;
  FRusTableName: string;
  FKeyName:   string;
  FFiltersCollection: TWellFilters;
  FFilterValues: OleVariant;
  FDict: variant;
  FDictIDIndex: integer;
  FDictNameIndex: integer;
  FImageIndex: integer;
  procedure    AddListItem(AData: integer; ACaption: string);
  procedure    LoadFilterValues;
  procedure    SaveFilterValues;
  procedure    LoadDictValues;
public
  SearchText:  string;
  constructor  Create(const ATableId, AImageIndex: integer; const ATableName, AKeyName, ARusTableName, ADictRestrict, AOrder: string; ADict: variant);
  destructor   Destroy; override;
end;

PWellFilter = ^ TWellFilter;
PInteger = ^ integer;
PMyString = ^ string;

TWellFilters = class
private
  // таблица задействованных таблиц
  // 0 - идентификатор
  // 1 - аглицкое название
  // 2 - название ключа
  // 3 - русское название
  FTables: variant;
  FMainTableName: string;
  FWellFilters: TList;
  lsw: TListView;
  prg: TProgressBar;
  function    GetWellFilter(Index: integer): TWellFilter;
  function    AddWellFilter(const ATableId, AImageIndex: integer; const ATableName, AKeyName, ARusTableName, ADictRestrict, AOrder: string; ADict: variant): TWellFilter;
  function    GetWellFilterCount: integer;
  function    FindWellFilter(const ATableId: integer): TWellFilter;
  procedure   ClearListView;
  procedure   LoadToListView(WellFilter: TWellFilter);
  function    CreateNewFilter(ATableID: integer): TWellFilter;
public
  CurrentFilter: TWellFilter;
  property    WellFilterCount: integer read GetWellFilterCount;
  property    WellFilters[Index: integer]: TWellFilter read GetWellFilter;
  procedure   LoadFilter(ATableID: integer);
  function    CreateSQLFilter: string;
  constructor Create(const AMainTableName: string; ATables: variant; AListView: TListView; APrg: TProgressBar);
  destructor  Destroy; override;
end;



function ConvertDateToSQL(const sDelphiDate: Shortstring): Shortstring;
function CreateTimeDict: variant;


const SQLShortMonthNames:array[1..12] of string=
          ('jan','feb','mar','apr','may','jun',
           'jul','aug','sep','oct','nov','dec');

var //vTimeDict: variant;
    vDicts: array of Variant;



implementation


function ConvertDateToSQL(const sDelphiDate: Shortstring): Shortstring;
var s,subs: Shortstring; //
    i: byte;
begin
  if sDelphiDate<>'' then
  begin
    //Форматируем в системный вид ("01-янв-2001", если Windows - русский)
    s:=FormatDateTime('dd-mmm-yyyy', StrToDateTime(sDelphiDate));
    //Копируем сокращение меяца
    subs:=Copy(s,4,3);
    //Ищем в системной таблице сокращений месяцев полученный...
    for i:=1 to 12 do
      //... и если находим, то в своей таблице находим
      //месяц с таким же номером
      if ShortMonthNames[i] = subs then
      begin
        subs:=SQLShortMonthNames[i];
        break;
      end;
    //Заменяем русское сокращение на английское
    Delete(s,4,3);
    Insert(subs,s,4);
    Result:=''''+s+'''';
  end
  else Result:='NULL';
end;


function CreateTimeDict: variant;
begin
  Result := varArrayCreate([0,2,0,4], varVariant);

  Result[0,0] := Date-7;
  Result[1,0] := 'За последнюю неделю';

  Result[0,1] := IncMonth(Date, -1);
  Result[1,1] := 'За последний месяц';

  Result[0,2] := IncMonth(Date, -3);
  Result[1,2] := 'За последние 3 месяца';

  Result[0,3] := IncMonth(Date, -6);
  Result[1,3] := 'За последние полгода';

  Result[0,4] := IncMonth(Date, -12);
  Result[1,4] := 'За последний год';

  vDicts[0] := Result;
end;


procedure TWellFilter.LoadFilterValues;
var i: integer;
begin
  for i:=0 to varArrayHighBound(FFilterValues,1) do
    FFiltersCollection.lsw.Items[FFilterValues[i]].Checked := true;
end;

procedure TWellFilter.SaveFilterValues;
var i,j: integer;
begin
  varClear(FFilterValues);
  FFilterValues := varArrayCreate([0,0],varInteger);
  j:=0;
  with FFiltersCollection.lsw.Items do
  for i:=0 to Count - 1 do
  if Item[i].Checked then
  begin
    varArrayRedim(FFilterValues,j);
    FFilterValues[j] := i;
    inc(j);
  end;
  if j=0 then varClear(FFilterValues);
end;


procedure   TWellFilter.LoadDictValues;
var i, iHB: integer;
begin
  iHB := varArrayHighBound(FDict,2);
  with FFiltersCollection.prg do
  begin
    Min :=0;
    Max :=iHB;
    Position := 0;
  end;

  for i:=0 to iHB do
  begin
    AddListItem(varAsType(FDict[FDictIdIndex, i], varInteger),FDict[FDictNameIndex,i]);
    FFiltersCollection.prg.Position := FFiltersCollection.prg.Position+1;
  end;
end;

constructor TWellFilter.Create(const ATableId, AImageIndex: integer; const ATableName, AKeyName, ARusTableName, ADictRestrict, AOrder: string; ADict: variant);
var sSQL: string;
begin
  FTableID:=ATableId;
  FTableName := ATableName;
  FKeyName := AKeyName;
  FRusTableName := ARusTableName;
  FImageIndex := AImageIndex;
  if varIsEmpty(ADict) then
  begin
    sSQL := 'select * from '+FTableName;
    if (trim(ADictRestrict)<>'') then sSQL := sSQL + ' where '+ ADictRestrict;
    if trim (AOrder)<>'' then sSQL :=sSQL+' order by '+AOrder;
    if IServer.ExecuteQuery(sSQL)>0 then
       FDict := IServer.QueryResult;
    vDicts[ATableID] := FDict;
  end
  else FDict := ADict;
  FDictIdIndex := 0;
  FDictNameIndex := 1;
  inherited Create;
end;

destructor  TWellFilter.Destroy;
begin
  inherited Destroy;
end;

function TWellFilters.AddWellFilter(const ATableId, AImageIndex: integer; const ATableName, AKeyName, ARusTableName, ADictRestrict, AOrder: string; ADict: variant): TWellFilter;
var P: PWellFilter;
begin
  Result := TWellFilter.Create(ATableId, AImageIndex, ATableName, AKeyName, ARusTableName, ADictRestrict, AOrder,ADict);
  Result.FFiltersCollection := Self;
  New(P);
  P^:=Result;
  FWellFilters.Add(P);
end;

procedure TWellFilters.ClearListView;
var i: integer;
begin
  with lsw do
  begin
    for i:=0 to Items.Count - 1 do
      Dispose(Items.Item[i].Data);
    Items.Clear;
  end;
end;

procedure TWellFilter.AddListItem(AData: integer; ACaption: string);
var lstItm: TListItem;
    P: PInteger;
begin
  New(P);
  P^:=AData;
  lstItm := FFiltersCollection.lsw.Items.Add;
  lstItm.Caption := ACaption;
  lstItm.Data := P;
  lstItm.ImageIndex := FImageIndex;
end;


procedure TWellFilters.LoadToListView(WellFilter: TWellFilter);
begin
  // сохраняем старый фильтр
  if Assigned(CurrentFilter) then CurrentFilter.SaveFilterValues;
  with WellFilter do
  begin
    lsw.Items.BeginUpdate;
    // очищаем список
    ClearListView;
    // загружаем новый список
    if not varIsEmpty(FDict) then
    begin
      lsw.Checkboxes := true;
      LoadDictValues;
      // если есть фильтр отмечаем
      if not varIsEmpty(FFilterValues) then
        LoadFilterValues;
    end
    else
    begin
      lsw.Checkboxes := false;
      AddListItem(-1, 'Нет данных...');
    end;
    lsw.Items.EndUpdate;
  end;
end;

function TWellFilters.FindWellFilter(const ATableId: integer): TWellFilter;
var i: integer;
begin
  Result := nil;
  for i:=FWellFilters.Count - 1 downto 0 do
  if (PWellFilter(FWellFilters[i])^.FTableID = ATableID) then
  begin
    Result := PWellFilter(FWellFilters[i])^;
    break;
  end;
end;

function TWellFilters.GetWellFilterCount: integer;
begin
  Result := FWellFilters.Count;
end;

function TWellFilters.GetWellFilter(Index: integer): TWellFilter;
begin
  Result:=nil;
  if Index<FWellFilters.Count then Result := PWellFilter(FWellFilters[Index])^;
end;


destructor  TWellFilters.Destroy;
var i: integer;
begin
  for i:=FWellFilters.Count - 1 downto 0 do
  begin
    PWellFilter(FWellFilters[i])^.Free;
    Dispose(FWellFilters[i]);
    FWellFilters.Delete(i);
  end;
  FWellFilters.Free;
  inherited Destroy;
end;

procedure   TWellFilters.LoadFilter(ATableID: integer);
var fltr: TWellFilter;
begin
  fltr := FindWellFilter(ATableID);
  // если не находим, то создаем новый фильтр
  if fltr=nil then fltr:=CreateNewFilter(ATableID);
  // загружаем  все в лист
  if fltr<>nil then LoadToListView(fltr);
  // переопределяем текущий фильтр
  CurrentFilter := fltr;
end;

function  TWellFilters.CreateNewFilter(ATableID: integer): TWellFilter;
var i: integer;
    vDict: variant;
begin
  Result := nil;
  // если TableID = 0, то это время
  if (ATableID>0) then vDict := vDicts[ATableID]
  else if varIsEmpty(vDicts[0]) then vDict := CreateTimeDict else vDict := vDicts[ATableID];
  // ищем все атрибуты в таблице
  for i:=0 to varArrayHighBound(FTables,2) do
  if FTables[0,i] = ATableID then
  begin
    // находим и создаем фильтр
    Result := AddWellFilter(ATableID,FTables[5,i],FTables[1,i],FTables[2,i], FTables[3,i],FTables[4,i], FTables[6,i], vDict);
    break;
  end;
end;

function TWellFilters.CreateSQLFilter: string;
var i: integer;
    sFilter: string;
begin
  // сделать какой-нибудь запрос по умолчанию
  if CurrentFilter<>nil then
  with CurrentFilter do
  begin
    SaveFilterValues;
    if not varIsEmpty(FFilterValues) then
    begin
      if FTableID<>0 then
      begin
        for i:=0 to varArrayHighBound(FFilterValues,1) do
          sFilter := sFilter + IntToStr(PInteger(lsw.Items[FFilterValues[i]].Data)^)+',';
        sFilter := FKeyName+' in ('+copy(sFilter,0,Length(sFilter)-1)+')';
      end
      else
      begin
        for i:=0 to varArrayHighBound(FFilterValues,1) do
        begin
          if i>0 then sFilter := sFilter + ' or ';
          sFilter := sFilter + '('+FKeyName+' between '+ConvertDateToSQL(DateToStr(PInteger(lsw.Items[FFilterValues[i]].Data)^))+ ' and ';
          sFilter := sFilter + ConvertDateToSQL(DateToStr(Date))+')';
        end;
      end;

      if pos('select',FMainTableName)>0 then
      if pos('where', FMainTableName)>0 then
      Result := FMainTableName +' and '+sFilter
      else Result := FMainTableName +' where '+sFilter
      else
      if pos('where', FMainTableName)>0 then
      Result := 'select * from '+FMainTableName +' and '+sFilter
      else Result := 'select * from '+FMainTableName+' where '+sFilter;
      Result := Result + ' order by vch_Area_Name, w.vch_Well_Num';
    end
  end;
end;



constructor TWellFilters.Create(const AMainTableName: string; ATables: variant; AListView: TListView; APrg: TProgressBar);
begin
  inherited Create;
  FTables := ATables;
  SetLength(vDicts, varArrayHighBound(FTables,2)+1);
  FMainTableName := AMainTableName;
  lsw := AListView;
  FWellFilters := TList.Create;
  lsw.Checkboxes := true;
  prg := APrg;
end;

end.
