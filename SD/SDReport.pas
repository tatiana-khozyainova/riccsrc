unit SDReport;

interface

uses
  CommonReport, BaseObjects, Classes, Contnrs;

type

  TCollectionReportSubTotal = class;
  TCollectionReportSubTotals = class;
  TStringArray = array of string;
  TIntArray = array of integer;

  TSDReport = class(TBaseReport)
  private
    FBaseObject: TIDObject;
    procedure SetBaseObject(const Value: TIDObject);
  public
    property ReportingObject: TIDObject read FBaseObject write SetBaseObject;
  end;

  TWatchingField = class
  private
    FReportFieldLastValue: OleVariant;
    FReportField: OleVariant;
    FWatchAfterFieldName: string;
    procedure SetReportField(const Value: OleVariant);
  public
    property WatchAfterFieldName: string read FWatchAfterFieldName write FWatchAfterFieldName;
    property ReportField: OleVariant read FReportField write SetReportField;
    property ReportFieldLastValue: OleVariant read FReportFieldLastValue write FReportFieldLastValue;
    constructor Create;
  end;

  TWatchingFields = class(TObjectList)
  private
    FOwner: TCollectionreportSubTotal;
    function GetItems(Index: integer): TWatchingField;
    function GetFieldByName(const AFieldName: string): TWatchingField;
    function FindFieldByName(const AFieldName: string; const FirstOnly: boolean): TWatchingField;

  public
    property Items[Index: integer]: TWatchingField read GetItems;
    function Add(AWatchAfterFieldName: string): TWatchingField;
    property Owner: TCollectionreportSubTotal read FOwner;

    procedure GetFields(AQueryBlock: OleVariant);
    procedure SetFieldValues;
    function  ValueChanged: boolean;
    function  GetFormattedQuery(AQueryToFormat: string): string;
    property  FieldByName[const AFieldName: string]: TWatchingField read GetFieldByName;
    constructor Create(AOwner: TCollectionReportSubTotal);
  end;


  TCollectionReportSubTotal = class
  private
    FSubTotalQueryTemplate: string;
    FQueryBlock: OleVariant;
    FCollection: TCollectionReportSubTotals;
    FWatchingFields: TWatchingFields;
    FExternalSubTotal: boolean;
    FRows: TIntArray;
    function GetWatchingFields: TWatchingFields;
  public
    property Rows: TIntArray read FRows;
    procedure AddRow(ARow: integer);
    procedure ClearRows;

    property WatchingFields: TWatchingFields read GetWatchingFields;


    property SubTotalQueryTemplate: string read FSubTotalQueryTemplate write FSubTotalQueryTemplate ;
    property Collection: TCollectionReportSubTotals read FCollection;

    function  ValueChanged: boolean;
    property  ExternalSubTotal: boolean read FExternalSubTotal write FExternalSubTotal;
    procedure Prepare;

    property  QueryBlock: OleVariant read FQueryBlock;
    procedure ClearLastResults;
    destructor Destroy; override;

  end;

  TCollectionReportSubTotals = class(TObjectList)
  private
    function GetItems(Index: integer): TCollectionReportSubTotal;
  public
    property Items[Index: integer]: TCollectionReportSubTotal read GetItems;

    function AddSubTotal(AWatchAfterFieldName: string;
                         ASubTotalQueryTemplate: string; AExternal: boolean = false): TCollectionReportSubTotal; overload;
    function AddSubTotal(AWatchAfterFieldName1, AWatchAfterFieldName2: string;
                         ASubTotalQueryTemplate: string; AExternal: boolean = false): TCollectionReportSubTotal; overload;

    function GetSubtotalByName(AWatchAfterFieldName, AWatchAfterFieldName2: string): TCollectionReportSubTotal;
    procedure DeleteSubtotal(AWatchAfterFieldName, AWatchAfterFieldName2: string);

    procedure ClearLastResults;
    procedure ClearRows;
  end;

  TSDSQLCollectionReport = class(TBaseReport)
  private
    FSQLQueries: TStrings;
    FSQLTotalQueries: TStrings;
    FGeneralTotalQueryTemplate: string;
    FReportQueryTemplate: string;
    FNextrange: OleVariant;
    FSubTotals: TCollectionReportSubTotals;
    FGeneralTotalQuery: string;
    FIsHorizontal: Boolean;
    FCurrentRow, FCurrentColumn, FCurrentArrayRow: Integer;
    FCurrentObject: TObject;
    FSubTotalsColorFill: boolean;
    FNextArray: OleVariant;
    procedure SetReportQueryTemplate(const Value: string);
    procedure ProcessQueryBlock(AQueryBlock: OleVariant);
    function  GetCollectionReportSubTotals: TCollectionReportSubTotals;
    procedure FillSubtotals;
    function GetNextArray: OleVariant;
    procedure SetNextRange(const Value: OleVariant);
    procedure SetNextArray(const Value: OleVariant);
 protected
    procedure InternalMoveData; override;
    procedure PreProcessQueryBlock(AQueryBlock: OleVariant); virtual;
    procedure PostProcessQueryBlock(AQueryBlock: OleVariant); virtual;

    procedure ProcessHorizontalQueryBlock(AQueryBlock: OleVariant); virtual;
    procedure ProcessVerticalQueryBlock(AQueryBlock: OleVariant); virtual;
    procedure ProcessVerticalReportRow(AQueryBlock: OleVariant; ARow: integer; IsFirstBlock: boolean); virtual;

    procedure ProcessSubTotalBlock(ASubTotalBlock: OleVariant); virtual;
    procedure ProcessTotalBlock(ATotalBlock: OleVariant); virtual;
    procedure PostFormat; override;
    function  GetReportQueryTemplateForThisObject(AReportingObject: TIDObject): string; virtual;

  public
    property  SubtotalsColorFill: boolean read FSubTotalsColorFill write FSubTotalsColorFill;
    // параметры отчета - методом подготовки превращаютс€ в SQL-запросы
    property  ReportQueryTemplate: string read FReportQueryTemplate write SetReportQueryTemplate;
    procedure PrepareReport; override;

    // очередной блок
    property  NextRange: OleVariant read FNextrange write SetNextRange;
    property  NextArray: OleVariant read GetNextArray write SetNextArray;

    // запросы к выполнению
    property SQLQueries: TStrings read FSQLQueries;
    property CurrentObject: TObject read FCurrentObject;
    // подитоги
    property SubTotals: TCollectionReportSubTotals read GetCollectionReportSubTotals;
    property GeneralTotalQueryTemplate: string read FGeneralTotalQueryTemplate write FGeneralTotalQueryTemplate;
    property GeneralTotalQuery: string read FGeneralTotalQuery;

    property IsHorizontal: Boolean read FIsHorizontal write FIsHorizontal;
    property CurrentColumn: Integer  read FCurrentColumn;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;



implementation

uses Facade, SysUtils, Variants, MaskUtils, BaseConsts, ADOInt;

{ TSDSQLCollectionReport }

constructor TSDSQLCollectionReport.Create(AOwner: TComponent);
begin
  inherited;
  FSQLQueries := TStringList.Create;
  FSQLTotalQueries := TStringList.Create;
  SilentMode := false;
  IsHorizontal := True;
  FCurrentRow := 1;
  FCurrentColumn := 1;
end;

destructor TSDSQLCollectionReport.Destroy;
begin
  FSQLQueries.Free;
  FSQLTotalQueries.Free;
  FSubTotals.Free;
  inherited;
end;

procedure TSDSQLCollectionReport.FillSubtotals;
var i, j: integer;
    Cell1, Cell2, Range: OleVariant;
begin
  for i := 0 to SubTotals.Count - 1 do
  for j := 0 to Length(SubTotals.Items[i].Rows) - 1 do
  begin
    Cell1 := FXLWorksheet.Cells.Item[SubTotals.Items[i].Rows[j] + FirstRowIndex - 1, FirstColIndex];
    Cell2 := FXLWorksheet.Cells.Item[SubTotals.Items[i].Rows[j] + FirstRowIndex - 1, LastColIndex];
    Range := FXLWorksheet.Range[Cell1,Cell2];
    Range.Interior.Pattern := EXCEL_XL_SOLID;
    Range.Interior.PatternColorIndex := EXCEL_XL_AUTOMATIC;
    Range.Interior.ThemeColor := EXCEL_XL_ThemeColorDark1;
    if not SubTotals.Items[i].ExternalSubTotal then
      Range.Interior.TintAndShade := -0.1 - 0.05*i
    else
      Range.Interior.TintAndShade := -0.3;
    Range.Font.Bold := true;
  end;

  if GeneralTotalQueryTemplate <> '' then
  begin
    Cell1 := FXLWorksheet.Cells.Item[LastRowIndex, FirstColIndex];
    Cell2 := FXLWorksheet.Cells.Item[LastRowIndex, LastColIndex];
    Range := FXLWorksheet.Range[Cell1,Cell2];
    Range.Interior.Pattern := EXCEL_XL_SOLID;
    Range.Interior.PatternColorIndex := EXCEL_XL_AUTOMATIC;
    Range.Interior.ThemeColor := EXCEL_XL_ThemeColorDark1;
    Range.Interior.TintAndShade := -0.4;
    Range.Font.Bold := true;
  end;
end;

function TSDSQLCollectionReport.GetCollectionReportSubTotals: TCollectionReportSubTotals;
begin
  if not Assigned(FSubTotals) then
    FSubTotals := TCollectionReportSubTotals.Create;

  Result := FSubTotals;
end;

function TSDSQLCollectionReport.GetNextArray: OleVariant;
begin
  if (varIsEmpty(FNextArray) or varIsNull(FNextArray)) then
  begin
    if not (varIsEmpty(NextRange) or varIsNull(NextRange)) then
      FNextArray := VarArrayCreate([1, NextRange.Rows.Count, 1, NextRange.Columns.Count], varVariant)
    else
      FNextArray := varEmpty;
  end;
  result := FNextArray;
end;

function TSDSQLCollectionReport.GetReportQueryTemplateForThisObject(
  AReportingObject: TIDObject): string;
begin
  Result := ReportQueryTemplate; 
end;

procedure TSDSQLCollectionReport.InternalMoveData;
var i, j, k: integer;
    vQueryResult: OleVariant;
begin
  inherited;
  FCurrentRow := 1;
  FCurrentColumn := 1;

  SubTotals.ClearRows;

  // пробегаем по всем имеющимс€ запросам
  // выполн€ем каждый, выполн€ем соответствующий итог

  if not SilentMode then
     FStepForm.InitSubProgress(0, SQLQueries.Count + Ord(IsHorizontal) * SubTotals.Count + 1, 1);



  for i := 0 to SQLQueries.Count - 1 do
  begin
    if not SilentMode then FStepForm.MakeSubStep();
    FCurrentObject := SQLQueries.Objects[i];
    if (trim(SQLQueries.Strings[i]) <> '') then
    begin
      if TMainFacade.GetInstance.DBGates.ExecuteQuery(SQLQueries.Strings[i], vQueryResult, true) >= 0 then
      begin
        ProcessQueryBlock(vQueryResult);
        NextRange.Value := NextArray;
      end;
    end;
  end;
  
  if IsHorizontal then
  begin
    i := FCurrentArrayRow;
    for j := 0 to SubTotals.Count - 1 do
    begin
      if not SilentMode then FStepForm.MakeSubStep();
      if (SubTotals.Items[j].ExternalSubTotal) then
      begin
        SubTotals.Items[j].ClearLastResults;
        SubTotals.Items[j].Prepare;
        for k := 0 to SubTotals.Items[j].QueryBlock.Fields.Count - 1 do
          FNextArray[i, k + 1] := trim(SubTotals.Items[j].QueryBlock.Fields[k].Value);
        SubTotals.Items[j].AddRow(FCurrentRow);
        inc(i);
        FLastRowIndex := FLastRowIndex + 1;
        FCurrentRow := FCurrentRow + 1;
      end;
    end;
    FCurrentArrayRow := i;
    if not varIsEmpty(NextRange) then NextRange.Value := NextArray;
  end;




  if not (trim(GeneralTotalQuery) = '') then
  if TMainFacade.GetInstance.DBGates.ExecuteQuery(GeneralTotalQuery, vQueryResult, true) >= 0 then
    ProcessTotalBlock(vQueryResult);



  if not SilentMode then FStepForm.MakeSubStep();


end;


procedure TSDSQLCollectionReport.PostFormat;
begin
  inherited;
  if SubtotalsColorFill then FillSubtotals;
end;

procedure TSDSQLCollectionReport.PostProcessQueryBlock(
  AQueryBlock: OleVariant);
begin

end;

procedure TSDSQLCollectionReport.PrepareReport;
var sTemplate: string;
    i: integer;
    inReportingObjects: TIDObjects;
begin

  SQLQueries.Clear;
  if not UseAllReportingObjectsAsOne then
  begin
    for i := 0 to ReportingObjects.Count - 1 do
    begin
      sTemplate := StringReplace(GetReportQueryTemplateForThisObject(ReportingObjects.Items[i]), '%s', IntToStr(ReportingObjects.Items[i].ID), [rfReplaceAll]);
      sTemplate := StringReplace(sTemplate, '%a', AllObjects.IDList, [rfReplaceAll]);
      SQLQueries.AddObject(sTemplate, ReportingObjects.Items[i]);
    end;
  end
  else
  begin
    inReportingObjects := TIDObjects.Create;
    inReportingObjects.OwnsObjects := false;

    for i := 0 to ReportingObjects.Count - 1 do
    begin
      inReportingObjects.Add(ReportingObjects.Items[i], false, false);
      if inReportingObjects.Count > 249 then
      begin
        sTemplate := StringReplace(ReportQueryTemplate, '%s', inReportingObjects.IDList, [rfReplaceAll]);
        SQLQueries.AddObject(sTemplate, ReportingObjects);
        inReportingObjects.Clear;
      end;
    end;

    sTemplate := StringReplace(ReportQueryTemplate, '%s', inReportingObjects.IDList, [rfReplaceAll]);
    SQLQueries.AddObject(sTemplate, ReportingObjects);
    FreeAndNil(inReportingObjects);
  end;

  if (EmptyReportingObjects and (ReportingObjects.Count = 0)) then
      SQLQueries.AddObject(ReportQueryTemplate, nil);

  FGeneralTotalQuery := StringReplace(GeneralTotalQueryTemplate, '%s', ReportingObjects.IDList, [rfReplaceAll])
end;


procedure TSDSQLCollectionReport.PreProcessQueryBlock(
  AQueryBlock: OleVariant);
begin

end;


procedure TSDSQLCollectionReport.ProcessHorizontalQueryBlock(
  AQueryBlock: OleVariant);
var i, j, k, ii: integer;
begin
  if not AQueryBlock.Eof then
  begin
    AQueryBlock.MoveFirst;
    SubTotals.ClearLastResults;

    i := FCurrentRow;  ii := 1;

    // находим дл€ всех сабтоталов пол€ в датасете
    for j := 0 to SubTotals.Count - 1 do
      SubTotals.Items[j].WatchingFields.GetFields(AQueryBlock);

    if (SQLQueries.IndexOfObject(CurrentObject) > 0) then
    begin
      for j := 0 to SubTotals.Count - 1 do
      if (SubTotals.Items[j].ExternalSubTotal and SubTotals.Items[j].ValueChanged) then
      begin
        SubTotals.Items[j].ClearLastResults;
        SubTotals.Items[j].Prepare;
        for k := 0 to SubTotals.Items[j].QueryBlock.Fields.Count - 1 do
          FNextArray[ii, k + 1] := trim(SubTotals.Items[j].QueryBlock.Fields[k].Value);


        SubTotals.Items[j].AddRow(i);
        SubTotals.Items[j].WatchingFields.SetFieldValues;
        inc(i);
        inc(ii);
      end;
    end;

    while not AQueryBlock.Eof do
    begin
      // если предыдущие значени€ сабтотальных полей не равны, то нужно отработать подблок
      for j := 0 to SubTotals.Count - 1 do
      if (not SubTotals.Items[j].ExternalSubTotal) and SubTotals.Items[j].ValueChanged then
      begin
        SubTotals.Items[j].ClearLastResults;
        SubTotals.Items[j].Prepare;
        for k := 0 to SubTotals.Items[j].QueryBlock.Fields.Count - 1 do
          FNextArray[ii, k + 1] := trim(SubTotals.Items[j].QueryBlock.Fields[k].Value);

        SubTotals.Items[j].AddRow(i);
        SubTotals.Items[j].WatchingFields.SetFieldValues;
        inc(i);
        inc(ii);
      end;

      for j := 0 to AQueryBlock.Fields.Count - 1 do
      if not (varIsNull(AQueryBlock.Fields[j].Value) or varIsEmpty(AQueryBlock.Fields[j].Value)) then
      begin
        if AQueryBlock.Fields[j].Type = adWChar then
          FNextArray[ii, j + 1] := trim(AQueryBlock.Fields[j].Value)
        else
          FNextArray[ii, j + 1] := AQueryBlock.Fields[j].Value;
      end;



      AQueryBlock.MoveNext;
      //if not AQueryBlock.Eof then
      inc (i);
      inc(ii);
    end;


    for j := 0 to SubTotals.Count - 1 do
    if (not SubTotals.Items[j].ExternalSubTotal) then
    begin
      SubTotals.Items[j].ClearLastResults;
      SubTotals.Items[j].Prepare;
      for k := 0 to SubTotals.Items[j].QueryBlock.Fields.Count - 1 do
        FNextArray[ii, k + 1] := trim(SubTotals.Items[j].QueryBlock.Fields[k].Value);

      SubTotals.Items[j].AddRow(i);
      inc(i);
      inc(ii);
    end;
    PostProcessQueryBlock(AQueryBlock);
    LastRowIndex := LastRowIndex + ii - 1;
    FCurrentRow := i;
    FCurrentArrayRow := ii;
  end;
end;

procedure TSDSQLCollectionReport.ProcessQueryBlock(
  AQueryBlock: OleVariant);
begin
  PreProcessQueryBlock(AQueryBlock);
  GetNextArray;
  if IsHorizontal then
    ProcessHorizontalQueryBlock(AQueryBlock)
  else
    ProcessVerticalQueryBlock(AQueryBlock);
  PostProcessQueryBlock(AQueryBlock);
end;

procedure TSDSQLCollectionReport.ProcessSubTotalBlock(
  ASubTotalBlock: OleVariant);
begin

end;

procedure TSDSQLCollectionReport.ProcessTotalBlock(
  ATotalBlock: OleVariant);
var k: integer;
begin
  GetNextArray;
  for k := 0 to ATotalBlock.Fields.Count - 1 do
    FNextArray[1, k + 1] := ATotalBlock.Fields[k].Value;

  NextRange.Value := FNextArray;
end;


procedure TSDSQLCollectionReport.ProcessVerticalQueryBlock(
  AQueryBlock: OleVariant);
var i: integer;
    IsFirstBlock: Boolean;
begin
  if not AQueryBlock.Eof then
  begin
    AQueryBlock.MoveFirst;

    i := 1;
    IsFirstBlock := SQLQueries.IndexOfObject(CurrentObject) = 0;
    while not AQueryBlock.Eof do
    begin
      ProcessVerticalReportRow(AQueryBlock, i, IsFirstBlock);

      AQueryBlock.MoveNext;
      if not AQueryBlock.Eof then inc (i);
      if not SilentMode then
        FStepForm.MakeSubStep();
    end;

    FCurrentColumn := FCurrentColumn + AQueryBlock.Fields.Count - ord(not IsFirstBlock) - 1;
    LastRowIndex := LastRowIndex + i - 1;
  end;
end;

procedure TSDSQLCollectionReport.ProcessVerticalReportRow(AQueryBlock: OleVariant; ARow: integer; IsFirstBlock: boolean);
var j: integer;
begin
  for j := 1 + ord(not IsFirstBlock) to AQueryBlock.Fields.Count - 1 do
    FNextArray[ARow, j + FCurrentColumn - ord(not IsFirstBlock) - 1] := AQueryBlock.Fields[j].Value;
end;

procedure TSDSQLCollectionReport.SetNextArray(const Value: OleVariant);
begin
  FNextArray := Value
end;

procedure TSDSQLCollectionReport.SetNextRange(const Value: OleVariant);
begin
  FNextrange := Value;
  VarClear(FNextArray);
end;

procedure TSDSQLCollectionReport.SetReportQueryTemplate(
  const Value: string);
begin
  FReportQueryTemplate := Value;
end;


{ TSDReport }

procedure TSDReport.SetBaseObject(const Value: TIDObject);
begin
  FBaseObject := Value;
  ReportingObjects.Clear;
  ReportingObjects.Add(FBaseObject, false, false);
end;

{ TCollectionReportSubTotals }

function TCollectionReportSubTotals.AddSubTotal(AWatchAfterFieldName,
  ASubTotalQueryTemplate: string; AExternal: boolean = false): TCollectionReportSubTotal;
begin
  Result := GetSubtotalByName(AWatchAfterFieldName, '');
  if not Assigned(Result) then
  begin
    Result := TCollectionReportSubTotal.Create;
    Result.FCollection := Self;
    inherited Add(Result);
  end;

  with Result do
  begin
    SubTotalQueryTemplate := ASubTotalQueryTemplate;
    WatchingFields.Add(AWatchAfterFieldName);
    ExternalSubTotal := AExternal;
  end;
end;

function TCollectionReportSubTotals.AddSubTotal(AWatchAfterFieldName1,
  AWatchAfterFieldName2,
  ASubTotalQueryTemplate: string; AExternal: boolean = false): TCollectionReportSubTotal;
begin
  Result := GetSubtotalByName(AWatchAfterFieldName1, AWatchAfterFieldName2);
  if not Assigned(Result) then
  begin
    Result := TCollectionReportSubTotal.Create;
    Result.FCollection := Self;
    inherited Add(Result);
  end;

  with Result do
  begin
    SubTotalQueryTemplate := ASubTotalQueryTemplate;
    WatchingFields.Add(AWatchAfterFieldName1);
    WatchingFields.Add(AWatchAfterFieldName2);
    ExternalSubTotal := AExternal;
  end;
end;

procedure TCollectionReportSubTotals.ClearLastResults;
var i: integer;
begin
  for i := 0 to Count - 1 do
    Items[i].ClearLastResults;
end;

procedure TCollectionReportSubTotals.ClearRows;
var i: integer;
begin
  for i := 0 to Count - 1 do
    Items[i].ClearRows;
end;

procedure TCollectionReportSubTotals.DeleteSubtotal(AWatchAfterFieldName,
  AWatchAfterFieldName2: string);
var s: TCollectionReportSubTotal;
begin
  s := GetSubtotalByName(AWatchAfterFieldName, AWatchAfterFieldName2);
  if Assigned(s) then Remove(s);
end;

function TCollectionReportSubTotals.GetItems(
  Index: integer): TCollectionReportSubTotal;
begin
  Result := inherited Items[Index] as TCollectionReportSubTotal;
end;


function TCollectionReportSubTotals.GetSubtotalByName(
  AWatchAfterFieldName, AWatchAfterFieldName2: string): TCollectionReportSubTotal;
var i: integer;
begin
  Result := nil;
  if AWatchAfterFieldName2 = '' then
  begin
    for i := 0 to Count - 1 do
    if Assigned(Items[i].WatchingFields.FieldByName[AWatchAfterFieldName]) then
    begin
      Result := Items[i];
      break;
    end;
  end
  else
  for i := 0 to Count - 1 do
  if  (Assigned(Items[i].WatchingFields.FieldByName[AWatchAfterFieldName])
  and Assigned(Items[i].WatchingFields.FieldByName[AWatchAfterFieldName2]))  then
  begin
    Result := Items[i];
    break;
  end;
end;

{ TCollectionReportSubTotal }

procedure TCollectionReportSubTotal.ClearLastResults;
begin
  VarClear(FQueryBlock);
end;

procedure TCollectionReportSubTotal.Prepare;
var iResult: integer;
begin
  if varIsEmpty(FQueryBlock) then
  begin
    iResult := TMainFacade.GetInstance.DBGates.ExecuteQuery(WatchingFields.GetFormattedQuery(SubTotalQueryTemplate), FQueryBlock, true);
    if iResult >= 0 then FQueryBlock.MoveFirst;
  end
  else FQueryBlock.MoveNext;
end;


function TCollectionReportSubTotal.GetWatchingFields: TWatchingFields;
begin
  if not Assigned(FWatchingFields) then
    FWatchingFields := TWatchingFields.Create(Self);

  Result := FWatchingFields;
end;



function TCollectionReportSubTotal.ValueChanged: boolean;
begin
  Result := WatchingFields.ValueChanged;
end;

destructor TCollectionReportSubTotal.Destroy;
begin
  FWatchingFields.Free;
  inherited;
end;

procedure TCollectionReportSubTotal.AddRow(ARow: integer);
begin
  SetLength(FRows, Length(FRows) + 1);
  FRows[Length(FRows) - 1] := ARow;
end;

procedure TCollectionReportSubTotal.ClearRows;
begin
  SetLength(FRows, 0);
end;

{ TWatchingField }

constructor TWatchingField.Create;
begin
  FReportFieldLastValue := -1;
end;

procedure TWatchingField.SetReportField(const Value: OleVariant);
begin
  FReportField := Value;
  if (FReportFieldLastValue = -1) then FReportFieldLastValue := FReportField.Value;
end;

{ TWatchingFields }

function TWatchingFields.Add(AWatchAfterFieldName: string): TWatchingField;
begin
  Result := TWatchingField.Create;
  Result.WatchAfterFieldName := AWatchAfterFieldName;
  inherited Add(Result);
end;

constructor TWatchingFields.Create(AOwner: TCollectionReportSubTotal);
begin
  inherited Create(True);
  FOwner :=  AOwner;
end;

function TWatchingFields.FindFieldByName(const AFieldName: string;
  const FirstOnly: boolean): TWatchingField;
var i: integer;
begin
  Result := nil;
  if FirstOnly then
  begin
    if AnsiUpperCase(Items[0].WatchAfterFieldName) = AnsiUpperCase(AFieldName) then
      Result := Items[0];
  end
  else
  begin
    for i := 0 to Count - 1 do
    if AnsiUpperCase(Items[i].WatchAfterFieldName) = AnsiUpperCase(AFieldName) then
    begin
      Result := Items[i];
      break;
    end;
  end;
end;

function TWatchingFields.GetFieldByName(
  const AFieldName: string): TWatchingField;
begin
  Result := FindFieldByName(AFieldName, true);
end;

procedure TWatchingFields.GetFields(AQueryBlock: OleVariant);
var i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if not Owner.ExternalSubTotal then Items[i].FReportFieldLastValue := -1;
    Items[i].ReportField := AQueryBlock.Fields.Item(Items[i].WatchAfterFieldName);
  end;
end;

function TWatchingFields.GetFormattedQuery(AQueryToFormat: string): string;
var sQuery: string;
    i: integer;
begin
  sQuery := AQueryToFormat;

  for i := 0 to Count - 1 do
  begin
    try
      sQuery := StringReplace(sQuery, '%s', varAsType(Items[i].ReportFieldLastValue, varOleStr), []);
    except

    end;
  end;

  Result := sQuery;
end;

function TWatchingFields.GetItems(Index: integer): TWatchingField;
begin
  Result := inherited Items[Index] as TWatchingField;
end;



procedure TWatchingFields.SetFieldValues;
var i: integer;
begin
  for i := 0 to Count - 1 do
    Items[i].ReportFieldLastValue := Items[i].ReportField.Value;
end;

function TWatchingFields.ValueChanged: boolean;
var i: integer;
    s: OleVariant;
begin
  Result := false;
  for i := 0 to Count - 1 do
  begin
    s := Items[i].ReportField.Value;
    Result := Result or (s <> Items[i].ReportFieldLastValue);
  end;
end;

end.
