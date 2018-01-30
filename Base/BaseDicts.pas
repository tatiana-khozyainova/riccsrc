unit BaseDicts;

interface

uses Classes, ClientCommon, SysUtils, Contnrs, Forms
  {$IFDEF VER150}
  , Variants
  {$ENDIF}
  ;


type
  // в фильтре справочники отдельно - а здесь только те, которые нужны для работы
  TDict = class;
  TDicts = class;

  TColumn = class
  private
    FID: integer;
    FRusColName: string;
    FColName: string;
    FIsKey: boolean;
    FValue: variant;
    FReferDict: TDict;
    FOwner: TDict;
    function GetNameValue: string;
    function GetIsForeignKey: boolean;
    function GetReferDict: TDict;
  public
    property ColName: string read FColName;
    property RusColName: string read FRusColName;
    property ID: integer read FID;
    property IsKey: boolean read FIsKey;
    property IsForeignKey: boolean read GetIsForeignKey;
    property ReferDict: TDict read GetReferDict;
    property Owner: TDict read FOwner write FOwner;
    // значение (при работе с таблицей)
    property Value: variant read FValue write FValue;
    property NameValue: string read GetNameValue;
    constructor Create(const AID: integer; const AColName, ARusColName: string; const AKey: boolean);
  end;

  TColumns = class(TObjectList)
  private
    FOwner: TDict;
    FKey: TColumn;
    function GetItem(const Index: integer): TColumn;
    function GetSelectiveColumns: string;
    function GetKey: TColumn;
  public
    // ключ
    property Key: TColumn read GetKey;
    property Items[const Index: integer]: TColumn read GetItem; default;
    property Owner: TDict read FOwner;
    property SelectiveColumns: string read GetSelectiveColumns;
    function GetColumnValues(StartWith: integer = 0): variant;
    function GetColumnNames(StartWith: integer = 0): variant;
    procedure ClearValues;
    // загружает столбцы в структуру
    constructor Create(AOwner: TDict);
  end;

  TDictEditForm = class(TForm)
  protected
    FDict: TDict;
    procedure SetDict(const Value: TDict); virtual; abstract;
  public
    property Dict: TDict read FDict write SetDict;
    procedure ClearControls; virtual;
    procedure SaveValues; virtual;
    procedure AdditionalSave; virtual;
  end;

  TDictEditFormClass = class of TDictEditForm;



  TDict = class
  private
    FRusName: string;
    FName: string;
    FColumns: TColumns;
    FFilter: string;
    FSelectiveColumns: string;
    FID: integer;
    FDicts: TDicts;
    FNeedsUpdate: boolean;
    FRowCount: integer;
    FIsEditable: boolean;
    FExcludedColumns: string;
    FDictEditFormClass: TDictEditFormClass;
    FReferTable: string;
    FReferColumn: string;
    FIsVisible: boolean;
    procedure SetNeedsUpdate(const Value: boolean);
  public
    // содержимое
    Dict: variant;
    // идентификатор
    property ID: integer read FID;
    // название
    property Name: string read FName;
    // столбцы
    property SelectiveColumns: string read FSelectiveColumns;
    // порядок сортировки
    property Filter: string read FFilter;
    // загруженные столбцы
    property Columns: TColumns read FColumns;
    // русское название
    property RusName: string read FRusName write FRusName;
    // исключенные столбцы
    property ExcludedColumns: string read FExcludedColumns write FExcludedColumns;
    // ссылающаяся таблица (при множественной связи)
    // и ее столбцы
    // заполняется при вызове Reference
    property ReferTable: string read FReferTable;
    property ReferColumn: string read FReferColumn;


    // изменен и требует обновления
    property NeedsUpdate: boolean read FNeedsUpdate write SetNeedsUpdate;
    // перегружает
    procedure Update(const ReassignColumns, SelectImmediately: boolean);
    // количество строк
    property RowCount: integer read FRowCount write FRowCount;
    // является редактируемым или просто для простмотра
    property IsEditable: boolean read FIsEditable write FIsEditable;
    // является видимым в списке
    property IsVisible: boolean read FIsVisible write FIsVisible;
    // владелец
    property Collection: TDicts read FDicts;
    // добавляет строку
    function    InsertRow: integer;
    // редактирует строку
    function    UpdateRow: integer;
    // удаляет строку
    function    DeleteRow: integer;
    // выбирает из ссылающейся таблицы
    function    Reference(const ATable, AColumn: string): variant;
    // записывает в ссылающуюся таблицу
    function   SetRefer(AStrings: TStrings): integer;
    // дополнительная форма редактирования
    property    DictEditFormClass: TDictEditFormClass read FDictEditFormClass write FDictEditFormClass;
    // осуществляет полную загрузку
    constructor Create(ACollection: TDicts; const AName: string; const SelectImmediately: boolean; AColumns: string = '*'; AFilter: string = ''; ExcludedColumns: string = '');
    destructor  Destroy; override;
  end;

  // вот отсюда наследуют конкретные плоские справочники
  TDicts = class(TObjectList)
  private
    function GetDictByName(const AName: string): TDict;
    function GetItems(const Index: integer): TDict;
  public
    TableDict: variant;
    procedure   MakeList(ALst: TStrings; ADict: variant); overload;
    // фильтр - одномерный или двумерные массив вариантов
    procedure   MakeList(ALst: TStrings; ADict, AFilter: variant; AFilteringColumnIndex: integer); overload;

    procedure   MakeDictList(ALst: TStrings; EditableOnly: boolean);
    function    DictContentByName(const AName: string): variant;
    property    DictByName[const AName: string]: TDict read GetDictByName;
    property    Items[const Index: integer]: TDict read GetItems;
    constructor Create; virtual;
  end;

  function PosAfter(Substr, Str: string; APos: integer):integer;
  function StrRev(S: string): String;
  function PosBefore(Substr, Str: string; APos: integer):integer;
  procedure SplitInto2Parts(Substr, S: string; var Left, Right: string);



implementation

uses Facade, BaseFacades;


procedure SplitInto2Parts(Substr, S: string; var Left, Right: string);
var iPos: integer;
begin
  iPos := pos(Substr, S);
  if iPos > 0 then
  begin
    Left := trim(copy(S, 1, iPos));
    Right := trim(copy(S, iPos + Length(Substr), Length(S)));
  end
  else
  begin
    Left := S;
    Right := '';
  end;
end;

function PosBefore(Substr, Str: string; APos: integer):integer;
var iStrLen: integer;
begin
  Substr := StrRev(Substr);
  Str := StrRev(Str);
  iStrLen := Length(Str);

  Result := PosAfter(Substr, Str, iStrLen - APos + 1);
  if Result > 0 then
    Result := iStrLen - Result + 1;
end;

function PosAfter(Substr, Str: string; APos: integer):integer;
begin
  Str := copy(Str, APos + 1, Length(Str));
  if Pos(Substr, Str) > 0 then
    Result := APos + Pos(Substr, Str)
  else Result := 0;
end;

function StrRev(S: string): String;
var i: integer;
begin
  Result := '';
  for i := Length(S) downto 1 do
    Result := Result + S[i];
end;



procedure   TDicts.MakeList(ALst: TStrings; ADict: variant);
var i, iID: integer;
begin
  if not varIsEmpty(ADict) then
  if VarArrayHighBound(ADict, 1) > 0 then
  for i := 0 to varArrayHighBound(ADict, 2) do
  begin
    iID := ADict[0, i];
    ALst.AddObject(ADict[1, i], TObject(iID));
  end
  else
  for i := 0 to varArrayHighBound(ADict, 2) do
    ALst.Add(ADict[0, i]);
end;

constructor TDicts.Create;
var vCols, vValues: OleVariant;
    iRes: integer;
begin
  inherited Create;

  vCols := varArrayOf(['distinct Table_ID', 'vch_Table_Name', 'vch_Rus_Table_Name']);
  vValues := varArrayOf([TMainFacade.GetInstance.DBGates.ClientAppTypeID, TMainFacade.GetInstance.DBGates.GroupID, 2]);

  iRes := TMainFacade.GetInstance.DBGates.Server.SelectRows('SPD_GET_TABLES', vCols, '', vValues);

  if iRes > 0 then
    TableDict:=TMainFacade.GetInstance.DBGates.Server.QueryResult;
end;



{ TDict }

constructor TDict.Create(ACollection: TDicts; const AName: string; const SelectImmediately: boolean; AColumns: string = '*'; AFilter: string = ''; ExcludedColumns: string = '');
begin
  inherited Create;
  FName := AName;
  FSelectiveColumns := AColumns;
  FExcludedColumns := ExcludedColumns;
  FFilter := AFilter;
  FDicts := ACollection;
  IsEditable := true;
  IsVisible := true;
  FID := GetObjectId(Collection.TableDict, Name);
  FRusName := GetObjectName(Collection.TableDict, ID, 2);

  Update(true, SelectImmediately);
  FDicts.Add(Self);
end;

function TDict.DeleteRow: integer;
begin
  Result := TMainFacade.GetInstance.DBGates.Server.DeleteRow(Name,
                              'WHERE ' + Columns.Key.NameValue);
  NeedsUpdate := Result > 0;                              
end;

destructor TDict.Destroy;
begin
  FColumns.Free;
  inherited;
end;

function TColumns.GetKey: TColumn;
var i: integer;
begin
  if FKey = nil then
  for i:= 0 to Count - 1 do
  if Items[i].IsKey  then
  begin
    FKey := Items[i];
    if i <> 0 then Move(i, 0);
  end;
  Result := FKey;
end;

function TDict.InsertRow: integer;
var vQR: variant;
    sQuery: string;
begin
  sQuery := 'select ' + 'MAX(' + Columns.Key.ColName + ')' + ' from ' + Name;
  TMainFacade.GetInstance.DBGates.Server.NeedAdoRecordset := false;
  Result := TMainFacade.GetInstance.DBGates.Server.ExecuteQuery(sQuery);

  if Result > 0 then
  begin
    vQR:= TMainFacade.GetInstance.DBGates.Server.QueryResult;
    if not varIsEmpty(GetSingleValue(vQR)) then
      Columns.Key.Value := GetSingleValue(vQR) + 1
    else
      Columns.Key.Value := 1;

    Result := TMainFacade.GetInstance.DBGates.Server.InsertRow(Name,
                                Columns.GetColumnNames,
                                Columns.GetColumnValues);
    NeedsUpdate := true;
  end;
end;

function TDict.Reference(const ATable, AColumn: string): variant;
var iResult: integer;
begin
  FReferTable := ATable;
  FReferColumn := AColumn;
   
  varClear(Result);
  if not varIsEmpty(Columns.Key.Value) then
  begin
    iResult := TMainFacade.GetInstance.DBGates.Server.SelectRows(ATable, AColumn,  Columns.Key.NameValue, null);
    if iResult > 0 then
    begin
      FReferTable := ATable;
      Result := TMainFacade.GetInstance.DBGates.Server.QueryResult;
    end;
  end;
end;

procedure TDict.SetNeedsUpdate(const Value: boolean);
begin
  if FNeedsUpdate <> Value then
  begin
    FNeedsUpdate := Value;
    if FNeedsUpdate then Update(false, true);
    FNeedsUpdate := false;
  end;
end;

function   TDict.SetRefer(AStrings: TStrings): integer;
var i: integer;
begin
  Result := TMainFacade.GetInstance.DBGates.Server.DeleteRow(ReferTable,
                             'WHERE ' + Columns.Key.NameValue);
  if Result >= 0 then
  for i := 0 to AStrings.Count - 1 do
  begin
    Result := TMainFacade.GetInstance.DBGates.Server.InsertRow(ReferTable,
                                ReferColumn + ', ' + Columns.Key.ColName,
                                varArrayOf([Integer(AStrings.Objects[i]), Columns.Key.Value]));

    if Result < 0 then break;
  end;
end;

procedure TDict.Update(const ReassignColumns, SelectImmediately: boolean);
begin
  if ReassignColumns then
  begin
    if Assigned(FColumns) then FColumns.Free;
    FColumns := TColumns.Create(Self);
  end;

  if SelectImmediately then
  begin
    if FSelectiveColumns <> '*' then
      Dict := GetDictEx(Name, FSelectiveColumns, Filter)
    else Dict := GetDictEx(Name, '*', Filter);

    if not varIsEmpty(Dict) then
      FRowCount := varArrayHighBound(Dict, 2) + 1;
  end;
end;

function TDict.UpdateRow: integer;
begin
  Result := TMainFacade.GetInstance.DBGates.Server.UpdateRow(Name,
                              Columns.GetColumnNames(1),
                              Columns.GetColumnValues(1),
                              'WHERE ' + Columns.Key.NameValue);
  NeedsUpdate := Result > 0;                              
end;

{ TColumn }

constructor TColumn.Create(const AID: integer; const AColName,
  ARusColName: string; const AKey: boolean);
begin
  inherited Create;
  FID := AID;
  FColName := AColName;
  FRusColName := ARusColName;
  FIsKey := AKey;
end;

function TColumn.GetIsForeignKey: boolean;
var sReferDictName: string;
    vResult: variant;
    iResult: integer;
begin
  Result := (not IsKey) and (pos('_ID', ColName) > 0) ;
  if Result  then
  if not Assigned(FReferDict) then
  begin
    // ищем ссылочный стправочник
    iResult := TMainFacade.GetInstance.DBGates.Server.ExecuteQuery('select  distinct t.vch_Table_Name' +
                                    ' from tbl_Table t, tbl_Table_Attribute tbat ' +
                                    ' where tbat.Attribute_ID = ' + IntToStr(ID) +
                                    ' and tbat.Table_ID = t.Table_ID ' +
                                    ' and tbat.num_is_key = 1 ' + 
                                    ' and t.Table_ID in ' +
                                      ' (select distinct Table_ID ' +
                                      ' from SPD_GET_TABLES(' +
                                      IntToStr(TMainFacade.GetInstance.DBGates.ClientAppTypeID) + ', ' +
                                      IntToStr(TMainFacade.GetInstance.DBGates.GroupID) +', 2))');
    if iResult > 0 then
    begin
      vResult := TMainFacade.GetInstance.DBGates.Server.QueryResult;
      sReferDictName := vResult[0, 0];
      FReferDict := Owner.Collection.DictByName[sReferDictName];
    end;
  end;
end;

function TColumn.GetNameValue: string;
begin
  Result := ColName + ' = ' + varAsType(Value, varOleStr);
end;

function TColumn.GetReferDict: TDict;
begin
  IsForeignKey;
  Result := FReferDict;
end;

{ TColumns }

constructor TColumns.Create(AOwner: TDict);
var iRes, i: integer;
    vRes: variant;
    c: TColumn;
    sName: string;
begin
  inherited Create;
  FOwner := AOwner;
  iRes:= TMainFacade.GetInstance.DBGates.Server.ExecuteQuery('select distinct att.ATTRIBUTE_ID, att.VCH_ATTRIBUTE_NAME, att.VCH_RUS_ATTRIBUTE_NAME, tbat.num_Is_Key ' +
                              ' from tbl_Attribute att, tbl_Table_Attribute tbat ' +
                              ' where tbat.Table_ID = ' + IntToStr(FOwner.ID) +
                              ' and tbat.Attribute_ID = att.Attribute_ID' +
                              ' order by 2 desc');
  if iRes > 0 then
  begin
    vRes := TMainFacade.GetInstance.DBGates.Server.QueryResult;
    for i := 0 to iRes - 1 do
    begin
      sName := vRes[1, i];
      sName := UpperCase(trim(sName));
      if ((pos(', ' + sName, UpperCase(FOwner.SelectiveColumns)) > 0) or
          (pos(sName + ', ', UpperCase(FOwner.SelectiveColumns)) > 0))or
          (sName = UpperCase(FOwner.ExcludedColumns)) then
      begin
        c := TColumn.Create(vRes[0, i], sName, vRes[2, i], (not varIsEmpty(vRes[3, i])) and (vRes[3, i] = 1));
        Add(c);
        c.Owner := Self.Owner;
      end
      else if  (trim(FOwner.SelectiveColumns) = '*') and
           (not ((pos(', ' + sName, UpperCase(FOwner.ExcludedColumns)) > 0) or
                 (pos(sName + ', ', UpperCase(FOwner.ExcludedColumns)) > 0)) and
                 (sName <> UpperCase(FOwner.ExcludedColumns))) then
      begin
        c := TColumn.Create(vRes[0, i], sName, vRes[2, i], (not varIsEmpty(vRes[3, i])) and (vRes[3, i] = 1));
        Add(c);
        c.Owner := Self.Owner;
      end;
    end;

    Key;
    for i := 0 to Count - 1 do
    if  (pos('_NAME', Items[i].ColName) > 0)
    and (pos('_SHORT_NAME', Items[i].ColName) <= 0) then
    begin
      Move(i, 1);
      break;
    end;
  end;
end;

function TColumns.GetItem(const Index: integer): TColumn;
begin
  Result := inherited Items[Index] as TColumn;
end;

function TDicts.DictContentByName(const AName: string): variant;
begin
  Result := DictByName[AName].Dict;
end;

function TDicts.GetDictByName(const AName: string): TDict;
var i: integer;
begin
  Result := nil;

  for i := 0 to Count - 1 do
  if AnsiUpperCase(Items[i].Name) = AnsiUpperCase(AName) then
  begin
    Result := Items[i];
    break;
  end;

  if not Assigned(Result) then
    Result := TDict.Create(Self, AName, true);
end;

function TDicts.GetItems(const Index: integer): TDict;
begin
  Result := inherited Items[Index] as TDict;  
end;

function TColumns.GetSelectiveColumns: string;
var i: integer;
begin
  if Assigned(Key) then
    Result := Key.ColName
  else Result := '';

  for i := 1 to Count - 1 do
    Result := Result + ', ' + Items[i].ColName;

  if Result = '' then Result := '*';
end;

function TColumns.GetColumnValues(StartWith: integer = 0): variant;
var i: integer;
begin
  Key;
  Result := varArrayCreate([0, Count - 1 - StartWith], varVariant);
  for i := StartWith to Count - 1 do
    Result[i - StartWith]:= Items[i].Value;
end;

function TColumns.GetColumnNames(StartWith: integer = 0): variant;
var i: integer;
begin
  Key;
  Result := varArrayCreate([0, Count - 1 - StartWith], varOleStr);
  for i := StartWith to Count - 1 do
    Result[i - StartWith]:= Items[i].ColName;
end;

procedure TDicts.MakeDictList(ALst: TStrings; EditableOnly: boolean);
var i: integer;
begin
  ALst.Clear;
  for i := 0 to Count - 1 do
  if  (Items[i].IsVisible)
      and ((not EditableOnly) or (EditableOnly and Items[i].IsEditable))
      and (Items[i].RusName <> '') then
    ALst.AddObject(Items[i].RusName, Items[i]);
end;


procedure TDicts.MakeList(ALst: TStrings; ADict, AFilter: variant; AFilteringColumnIndex: integer);
var i, j, iID: integer;
begin
  if (not varIsEmpty(ADict)) then
  begin
    if (not varIsEmpty(AFilter)) and (VarArrayHighBound(ADict, 1) > 0) then
    begin
      if varArrayDimCount(AFilter) = 2 then
      begin
        for i := 0 to varArrayHighBound(ADict, 2) do
        for j := 0 to varArrayHighBound(AFilter, 2) do
        if ADict[AFilteringColumnIndex, i] = AFilter[0, j] then
        begin
          iID := ADict[0, i];
          ALst.AddObject(ADict[1, i], TObject(iID));
           break;
        end
      end
      else
      if varArrayDimCount(AFilter) = 1 then
      begin
        for i := 0 to varArrayHighBound(ADict, 2) do
        for j := 0 to varArrayHighBound(AFilter, 1) do
        if ADict[AFilteringColumnIndex, i] = AFilter[j] then
        begin
          iID := ADict[0, i];
          ALst.AddObject(ADict[1, i], TObject(iID));
          break;
        end
      end
    end
    else MakeList(ALst, ADict);
  end;
end;

procedure TColumns.ClearValues;
var i: integer;
begin
  for i := 0 to Count - 1 do
    varClear(Items[i].FValue);
end;

{ TDictEditForm }

procedure TDictEditForm.AdditionalSave;
begin

end;

procedure TDictEditForm.ClearControls;
begin

end;

procedure TDictEditForm.SaveValues;
begin

end;

end.
