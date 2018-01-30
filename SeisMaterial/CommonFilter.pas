unit CommonFilter;

interface

uses Classes, ComCtrls, SysUtils
     {$IFDEF VER150}
     , Variants
     {$ENDIF}
     ;


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
  FSubFilterName: string;
  FRealFilterValues: OleVariant;
  FLastFilter: string;
  FFilterTextValues: string;
  procedure    AddListItem(AData: integer; ACaption: string);
  procedure    LoadFilterValues;
  procedure    SaveFilterValues;
  procedure    LoadDictValues;
  function     GetFilterNumbers: string;
public
  SearchText:  string;
  property     RusTableName: string read FRusTableName;
  property     FilterTextValues: string read FFilterTextValues;
  property     FilterValues: OleVariant read FRealFilterValues;
  property     FilterNumbers: string read GetFilterNumbers;
  property     LastFilter: string read FLastFilter;
  property     ImageIndex: integer read FImageIndex write FImageIndex;
  property     ID: integer read FTableID write FTableID;
  constructor  Create(const ATableId, AImageIndex: integer; const ATableName, AKeyName, ARusTableName, ADictRestrict, AOrder, ASubFilterName: string; ADict: variant; ADictNameIndex: integer);
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
  FMainTableName, FOrderColumns: string;
  FWellFilters: TList;
  lsw: TListView;
  prg: TProgressBar;
  FFilterLastSelectedObjects: boolean;
  function    GetWellFilter(Index: integer): TWellFilter;
  function    AddWellFilter(const ATableId, AImageIndex: integer; const ATableName, AKeyName, ARusTableName, ADictRestrict, AOrder, ASubFilterName: string; ADict: variant; ADictNameIndex: integer): TWellFilter;
  function    GetWellFilterCount: integer;
  procedure   ClearListView;
  procedure   LoadToListView(WellFilter: TWellFilter; SavePreviousValues: boolean);
  function    CreateNewFilter(ATableID: integer): TWellFilter;
public
  CurrentFilter: TWellFilter;
  function    FindWellFilter(const ATableId: integer): TWellFilter;
  property    WellFilterCount: integer read GetWellFilterCount;
  property    WellFilters[Index: integer]: TWellFilter read GetWellFilter;
  procedure   LoadFilter(ATableID: integer; SavePreviousValues: boolean); overload;
  procedure   LoadFilter(ATableID: Integer; SavePreviousValues: boolean; Values: OleVariant); overload;
  property    FilterLastSelectedObjects: boolean read FFilterLastSelectedObjects write FFilterLastSelectedObjects;
  function    CreateSQLFilter: string;
  function    CreateSQLFilter2: string;

  constructor Create(const AMainTableName, AOrderColumns: string;
      ATables: variant; AListView: TListView; APrg: TProgressBar);
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

uses Facade, SysConst;


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
  for i:= varArrayHighBound(FFilterValues,1) downto 0 do
  begin
    FFiltersCollection.lsw.Items[FFilterValues[i]].Checked := true;
    FFiltersCollection.lsw.Items[FFilterValues[i]].MakeVisible(false);
  end;
end;

procedure TWellFilter.SaveFilterValues;
var i,j: integer;
begin
  varClear(FFilterValues);
  FFilterTextValues := '';
  FFilterValues := varArrayCreate([0,0],varInteger);
  FRealFilterValues := varArrayCreate([0,0],varInteger);
  j:=0;
  with FFiltersCollection.lsw.Items do
  for i:=0 to Count - 1 do
  if Item[i].Checked then
  begin
    varArrayRedim(FFilterValues,j);
    varArrayRedim(FRealFilterValues,j);
    FFilterValues[j] := i;
    FRealFilterValues[j] := PInteger(Item[i].Data)^;
    FFilterTextValues := FFilterTextValues + Item[i].Caption + ';';
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
    //AddListItem(varAsType(FDict[FDictIdIndex, i], varInteger),FDict[FDictNameIndex,i]);
    AddListItem(varAsType(FDict[FDictIdIndex, i], varInteger),FDict[FDictNameIndex,i]);
    FFiltersCollection.prg.Position := FFiltersCollection.prg.Position+1;
  end;

end;

constructor TWellFilter.Create(const ATableId, AImageIndex: integer;
                               const ATableName, AKeyName, ARusTableName, ADictRestrict, AOrder, ASubFilterName: string;
                               ADict: variant;
                               ADictNameIndex: integer);
var sSQL: string;
    iResult: integer;
begin
  FTableID := ATableId;
  FTableName := ATableName;
  FKeyName := AKeyName;
  FRusTableName := ARusTableName;
  FImageIndex := AImageIndex;
  FSubFilterName := ASubFilterName;

  if varIsEmpty(ADict) then
  begin
    sSQL := 'select * from ' + FTableName;
    if (trim(ADictRestrict) <> '') then sSQL := sSQL + ' where '+ ADictRestrict;
    if trim (AOrder) <> '' then sSQL := sSQL + ' order by ' + AOrder;

    iResult := TMainFacade.GetInstance.DBGates.Server.ExecuteQuery(sSQL);

    if iResult > 0 then
       FDict := TMainFacade.GetInstance.DBGates.Server.QueryResult;
    vDicts[ATableID] := FDict;
  end
  else FDict := ADict;

  FDictIdIndex := 0;
  FDictNameIndex := ADictNameIndex;
  inherited Create;
end;

destructor  TWellFilter.Destroy;
begin
  inherited Destroy;
end;

function TWellFilters.AddWellFilter(const ATableId, AImageIndex: integer; const ATableName, AKeyName, ARusTableName, ADictRestrict, AOrder, ASubFilterName: string; ADict: variant; ADictNameIndex: integer): TWellFilter;
var P: PWellFilter;
begin
  Result := TWellFilter.Create(ATableId, AImageIndex, ATableName, AKeyName, ARusTableName, ADictRestrict, AOrder, ASubFilterName, ADict, ADictNameIndex);
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


procedure TWellFilters.LoadToListView(WellFilter: TWellFilter; SavePreviousValues: boolean);
begin
  // сохраняем старый фильтр
  if Assigned(CurrentFilter) and SavePreviousValues then CurrentFilter.SaveFilterValues;
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

procedure   TWellFilters.LoadFilter(ATableID: integer; SavePreviousValues: boolean);
var fltr: TWellFilter;
begin
  fltr := FindWellFilter(ATableID);
  // если не находим, то создаем новый фильтр
  if fltr=nil then fltr:=CreateNewFilter(ATableID);
  // загружаем  все в лист
  if fltr<>nil then LoadToListView(fltr, SavePreviousValues);
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
    Result := AddWellFilter(ATableID,FTables[5,i],FTables[1,i],FTables[2,i], FTables[3,i],FTables[4,i], FTables[6,i], FTables[7,i], vDict, FTables[8,i]);
    break;
  end;
end;

function TWellFilters.CreateSQLFilter: string;
var i: integer;
    sFilter, sSubFilter, sCumulatedFilter: string;
begin
  // если нужно выбирать из выбранного
  if FilterLastSelectedObjects then
  begin
    // формируем накопленный фильтр
    sCumulatedFilter := '';
    for i := 0 to WellFilterCount - 1 do
    if  (WellFilters[i] <> CurrentFilter)
    and (trim(WellFilters[i].LastFilter) <> '') then
    begin
      sCumulatedFilter := sCumulatedFilter + ' and ' + '(' +
                          WellFilters[i].LastFilter + ')';

    end;

    sCumulatedFilter := trim(copy(sCumulatedFilter, 5, Length(sCumulatedFilter)));
  end;

  // сделать какой-нибудь запрос по умолчанию
  if CurrentFilter<>nil then
  with CurrentFilter do
  begin
    SaveFilterValues;
    if not varIsEmpty(FFilterValues) then
    begin
      // формируем список значений
      if FTableID<>0 then
      begin
        for i:=0 to varArrayHighBound(FFilterValues,1) do
          sFilter := sFilter + IntToStr(PInteger(lsw.Items[FFilterValues[i]].Data)^)+',';
        sFilter := FKeyName + ' in ('+copy(sFilter,0,Length(sFilter) - 1) + ')';
      end
      else
      begin
        for i:=0 to varArrayHighBound(FFilterValues,1) do
        begin
          if i>0 then sFilter := sFilter + ' or ';
          sFilter := sFilter + '('+FKeyName+' between '+ConvertDateToSQL(DateToStr(PInteger(lsw.Items[FFilterValues[i]].Data)^))+ ' and ';
          sFilter := sFilter + ConvertDateToSQL(DateToStr(Date + 1))+')';
        end;
      end;

      // если есть подфильтр, то используем список значений в нем
      if trim(FSubFilterName) <> '' then
      begin
        sSubFilter := Format(FSubFilterName, [sFilter]);
        sFilter := sSubFilter;
      end;

    end
    else if not FilterLastSelectedObjects then sFilter := '';
  end
  else if not FilterLastSelectedObjects then sFilter := '';

  // сохраняем последний активный фильтр
  CurrentFilter.FLastFilter := sFilter;


  if trim(sCumulatedFilter) <> '' then
  begin
    if sFilter <> '' then sFilter := sFilter + ' and ' + sCumulatedFilter
    else sFilter := sCumulatedFilter;
  end;

  Result := sFilter;
end;



constructor TWellFilters.Create(const AMainTableName, AOrderColumns: string; ATables: variant; AListView: TListView; APrg: TProgressBar);
begin
  inherited Create;
  FTables := ATables;
  SetLength(vDicts, varArrayHighBound(FTables,2)+1);
  FMainTableName := AMainTableName;
  FOrderColumns := AOrderColumns;
  
  lsw := AListView;
  FWellFilters := TList.Create;
  lsw.Checkboxes := true;
  prg := APrg;
end;


function TWellFilter.GetFilterNumbers: string;
var i: integer;
begin
  Result := '';
  if not VarIsEmpty(FFilterValues) then
  begin
    for i:=0 to varArrayHighBound(FFilterValues,1) do
      Result := Result + IntToStr(FFilterValues[i])+',';

    Result := Copy(Result, 1, Length(Result) - 1);
  end;
end;

procedure TWellFilters.LoadFilter(ATableID: Integer; SavePreviousValues: boolean; Values: OleVariant);
var fltr: TWellFilter;
begin
  fltr := FindWellFilter(ATableID);
  // если не находим, то создаем новый фильтр
  if fltr=nil then fltr:=CreateNewFilter(ATableID);
  fltr.FFilterValues := Values;
  // загружаем  все в лист
  if fltr<>nil then LoadToListView(fltr, SavePreviousValues);
  // переопределяем текущий фильтр
  CurrentFilter := fltr;
end;

function TWellFilters.CreateSQLFilter2: string;
var i: integer;
    sFilter, sSubFilter, sCumulatedFilter,str1,str2,str3,str4,str5,str6: string;
begin
  // если нужно выбирать из выбранного
  str1:='material_id in (select material_id from tbl_material_binding where Object_bind_type_id=';
  str2:=' and Object_bind_id in (';
  str3:='material_id in (select material_id from tbl_seismic_material where ';
  str4:='material_id in (select material_id from tbl_author where employee_id in (';
  str5:='material_id in (select material_id from tbl_seismic_material where seis_material_id in (select seis_material_id from tbl_seismic_profile where seis_profile_id in (';
  str6:='material_id in (select material_id from tbl_seismic_material where seis_material_id in (select seis_material_id from tbl_seismic_profile where seis_profile_type_id in (';
  if FilterLastSelectedObjects then
  begin
    // формируем накопленный фильтр
    sCumulatedFilter := '';
    for i := 0 to WellFilterCount - 1 do
    if  (WellFilters[i] <> CurrentFilter)
    and (trim(WellFilters[i].LastFilter) <> '') then
    begin
      sCumulatedFilter := sCumulatedFilter + ' and ' + '(' +
                          WellFilters[i].LastFilter + ')';

    end;

    sCumulatedFilter := trim(copy(sCumulatedFilter, 5, Length(sCumulatedFilter)));
  end;

  // сделать какой-нибудь запрос по умолчанию
  if CurrentFilter<>nil then
  with CurrentFilter do
  begin
    SaveFilterValues;
    if not varIsEmpty(FFilterValues) then
    begin
      // формируем список значений
      if FTableID<>0 then
      begin
        for i:=0 to varArrayHighBound(FFilterValues,1) do
          sFilter := sFilter + IntToStr(PInteger(lsw.Items[FFilterValues[i]].Data)^)+',';
        //sFilter := FKeyName + ' in ('+copy(sFilter,0,Length(sFilter) - 1) + ')';
        if FTableID=1 then sFilter := str1 + '2' + str2 +copy(sFilter,0,Length(sFilter) - 1) + '))'
        else
        if FTableID=2 then sFilter := str1 + '3' + str2 +copy(sFilter,0,Length(sFilter) - 1) + '))'
        else
        if FTableID=6 then sFilter := str1 + '4' + str2 +copy(sFilter,0,Length(sFilter) - 1) + '))'
        else
        if FTableID=8 then sFilter := str3 + FKeyName + ' in ('+copy(sFilter,0,Length(sFilter) - 1) + '))'
        else
        if FTableID=9 then sFilter := str3 + FKeyName + ' in ('+copy(sFilter,0,Length(sFilter) - 1) + '))'
        else
        if FTableID=10 then sFilter := str3 + FKeyName + ' in ('+copy(sFilter,0,Length(sFilter) - 1) + '))'
        else
        if FTableID=12 then sFilter := str4+copy(sFilter,0,Length(sFilter) - 1) + '))'
        else
        if FTableID=13 then sFilter := str4+copy(sFilter,0,Length(sFilter) - 1) + '))'
        else
        if FTableID=14 then sFilter := str5+copy(sFilter,0,Length(sFilter) - 1) + ')))'
        else
        if FTableID=15 then sFilter := str6+copy(sFilter,0,Length(sFilter) - 1) + ')))'
        else
        
        sFilter := FKeyName + ' in ('+copy(sFilter,0,Length(sFilter) - 1) + ')';
      end
      else
      begin
        for i:=0 to varArrayHighBound(FFilterValues,1) do
        begin
          if i>0 then sFilter := sFilter + ' or ';
          sFilter := sFilter + '('+FKeyName+' between '+ConvertDateToSQL(DateToStr(PInteger(lsw.Items[FFilterValues[i]].Data)^))+ ' and ';
          sFilter := sFilter + ConvertDateToSQL(DateToStr(Date + 1))+')';
        end;
      end;

      // если есть подфильтр, то используем список значений в нем
      if trim(FSubFilterName) <> '' then
      begin
        sSubFilter := Format(FSubFilterName, [sFilter]);
        sFilter := sSubFilter;
      end;

    end
    else if not FilterLastSelectedObjects then sFilter := '';
  end
  else if not FilterLastSelectedObjects then sFilter := '';

  // сохраняем последний активный фильтр
  CurrentFilter.FLastFilter := sFilter;


  if trim(sCumulatedFilter) <> '' then
  begin
    if sFilter <> '' then sFilter := sFilter + ' and ' + sCumulatedFilter
    else sFilter := sCumulatedFilter;
  end;

  Result := sFilter;
end;

end.
