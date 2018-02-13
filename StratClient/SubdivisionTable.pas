unit SubdivisionTable;

interface

uses ExcelTable, BaseTable, Contnrs, Straton, BaseObjects, Area, SubdivisionComponent, Well, Classes, Employee, Theme;

const
  ALTITUDE_ROW_INDEX = 4;
  AREA_ROW_INDEX = 1;
  WELL_NUMBER_ROW_INDEX = 2;
  TECTONIC_BLOCK_ROW_INDEX = 3;
  MAIN_STRATON_COLUMN_INDEX = 0;
  SECOND_STRATON_COLUMN_INDEX = 1;

type
  TIntegerList = class(TList)
  private
    function GetItems(const Index: integer): integer;
  public
    property Items[const Index: integer]: integer read GetItems;
    function Add(AValue: integer): integer;
  end;

  TErrorKind = (ekStratonNotFound, ekTectonicBlockNotFound, ekWellNotFound, ekNoRsingDepths, ekNoNumberDepths, ekInconsistentSubdivision, ekNoAltitude, ekNoTotalDepth, ekEmptyTableRow, ekCommentNotAllowed);
  TErrorKinds = set of TErrorKind;

  TTableError = class
  private
    FIsCritical: boolean;
    FColumnAddress: integer;
    FRowAddress: integer;
    FBaseTableCell: TBaseTableCell;
    FErrorKind: TErrorKind;
    function GetDescription: string;
  public
    property IsCritical: boolean read FIsCritical write FIsCritical;
    property ErrorKind: TErrorKind read FErrorKind write FErrorKind;
    property RowAddress: integer read FRowAddress write FRowAddress;
    property ColumnAddress: integer read FColumnAddress write FColumnAddress;
    property Cell: TBaseTableCell read FBaseTableCell write FBaseTableCell;
    property Description: string read GetDescription;

  end;

  TTableErrors = class(TObjectList)
  private
    function GetItems(const Index: integer): TTableError;
  public
    property Items[const Index: integer]: TTableError read GetItems;


    function CriticalErrorCount: integer;
    function GetErrorByCellAddress(ARow, ACol: integer; const ColOrRowOk: boolean = false): TTableError;
    function AddError(AErrorKind: TErrorKind; ARowAddress, AColumnAddress: integer; ACell: TBaseTableCell; AIsCritical: boolean): TTableError;
    procedure DeleteErrorsByKind(AErrorKind: TErrorKind);
    procedure DeleteErrorsByKinds(AErrorKinds: TErrorKinds);
    procedure SortByRow;
    procedure SortByColumn;
    procedure SortByDescription;
    constructor Create;
  end;

  TMatchType = (mtExact, mtExactWithCompletion, mtPartial);

  TIDObjectSearch = class
  private
    FAddressRow: integer;
    FAddressCol: integer;
    FIDObject: TIDObject;
    FStratonMatchType: TMatchType;
    FAreAdditionalParametersEqual: boolean;
  public
    property IDObject: TIDObject read FIDObject write FIDObject;
    property MatchType: TMatchType read FStratonMatchType write FStratonMatchType;
    property AreAdditionalParametersEqual: boolean read FAreAdditionalParametersEqual write FAreAdditionalParametersEqual;
    property AddressRow: integer read FAddressRow write FAddressRow;
    property AddressCol: integer read FAddressCol write FAddressCol;

    constructor Create;
  end;

  TIDObjectSearches = class(TObjectList)
  private
    function GetItems(const Index: integer): TIDObjectSearch;
  public
    function Add: TIDObjectSearch; overload;
    function Add(ACol, ARow: integer): TIDObjectSearch; overload;
    function Add(ACol, ARow: integer; AIDObject: TIDObject; AMatchType: TMatchType): TIDObjectSearch; overload;
    property Items[const Index: integer]: TIDObjectSearch read GetItems;

    constructor Create;
  end;




  TSubdivisionTable = class(TExcelTable)
  private
    FIDObjectSearches: TIDObjectSearches;
    FFoundWells: TWells;
    FUINs: TIntegerList;
    FTableErrors: TTableErrors;
    FOnSetProgress: TNotifyEvent;
    FOnMoveProgress: TNotifyEvent;
    function GetAltitudeRow: TBaseTableCells;
    function GetAreaRow: TBaseTableCells;
    function GetIDObjectSeraches: TIDObjectSearches;
    function GetStratonMainColumn: TBaseTableCells;
    function GetStratonSecondColumn: TBaseTableCells;
    function GetTectonicBlockRow: TBaseTableCells;
    function GetTotalDepthRow: TBaseTableCells;
    function GetWellRow: TBaseTableCells;

    procedure FillStratonColumn(AColumnIndex: integer; AStratons: TSimpleStratons);
    procedure FindStratons(AStratons: TSimpleStratons);

    procedure FillTectonicBlockRow(ATectonicBlocks: TTectonicBlocks);
    procedure LoadWells;

    procedure FillWellNumbersRow;

    function  GetFoundWells: TWells;
    function  GetTableErrors: TTableErrors;

    procedure GatherStratons(AWell: TWell; ATheme: TTheme; AStratons: TStratons; const NeedsSorting: boolean = true); overload;
    procedure GatherStratons(AWell: TWell; AThemes: TThemes; AStratons: TStratons); overload;
    procedure GatherStratons(AWells: TWells; ATheme: TTheme; AStratons: TStratons); overload;
    procedure GatherStratons(AWells: TWells; AThemes: TThemes; AStratons: TStratons); overload;

    procedure PlaceSubdivisionStratonCells(ASubdivision: TSubdivision; AStraton: TSimpleStraton; ARow: TBaseTableCells; const AColumnIndex: integer);
    function  GetWellAndTectonicBlockColumn(AWell: TWell; ATectonicBlock: TTectonicBlock): TBaseTableCells;
    procedure PrepareHeader;
    procedure AddTotalDepth(ATheme: TTheme; AWells: TWells); overload;
    procedure AddTotalDepth(AThemes: TThemes; AWells: TWells); overload;
    procedure AddTotalDepth(ATheme: TTheme; AWell: TWell); overload;
    procedure AddTotalDepth(AThemes: TThemes; AWell: TWell); overload;

    procedure FillEmpties(AComments: TSubdivisionComments; ABlocks: TTectonicBlocks);
  public
    function  CanPlaceComment(ACol, ARow: integer; AComment: TSubdivisionComment): boolean;

    property StratonMainColumn: TBaseTableCells read GetStratonMainColumn;
    property StratonSecondColumn: TBaseTableCells read GetStratonSecondColumn;
    property AreaRow: TBaseTableCells read GetAreaRow;
    property WellRow: TBaseTableCells read GetWellRow;
    property TectonicBlockRow: TBaseTableCells read GetTectonicBlockRow;
    property AltitudeRow: TBaseTableCells read GetAltitudeRow;
    property TotalDepthRow: TBaseTableCells read GetTotalDepthRow;

    property FoundWells: TWells read GetFoundWells;


    property IDObjectSearches: TIDObjectSearches read GetIDObjectSeraches;

    procedure LoadSubdivisionTable(AStratons: TSimpleStratons; AComments: TSubdivisionComments; ATectonicBlocks: TTectonicBlocks);
    procedure MakeSubdivisions(ATheme: TTheme; ASigningDate: TDateTime; ASigningEmployee: TEmployee; AWells: TWells);

    procedure LoadSubdivisions(ATheme: TTheme; AWells: TWells); overload;
    procedure LoadSubdivisions(AThemes: TThemes; AWells: TWells); overload;
    procedure LoadSubdivisions(AWells: TWells); overload;
    procedure LoadSubdivisions(AWell: TWell); overload;
    procedure LoadSubdivisions(ATheme: TTheme; AWell: TWell); overload;
    procedure LoadSubdivisions(AThemes: TThemes; AWell: TWell); overload;


    procedure ExportToExcel(AFileName: string);

    property  OnSetProgress: TNotifyEvent read FOnSetProgress write FOnSetProgress;
    property  OnMoveProgress: TNotifyEvent read FOnMoveProgress write FOnMoveProgress;

    procedure CheckSubdivisions(AComments: TSubdivisionComments);
    procedure CheckComments;
    procedure CheckEmptyRows;
    procedure CheckStratons;
    procedure CheckWells;
    procedure CheckHeader;

    property  TableErrors: TTableErrors read GetTableErrors;
    destructor Destroy; override;
  end;



implementation

uses TypInfo, SysUtils, Facade, BaseConsts, Types, Variants, ClientCommon, StringUtils,
  Math, ComObj;

var sCurrentAreaNamePart: string;

function CompareTableErrorsRow(Item1, Item2: Pointer): integer;
var e1, e2: TTableError;
begin
  e1 := TTableError(Item1);
  e2 := TTableError(Item2);

  if e1.RowAddress > e2.RowAddress then Result := 1
  else if e1.RowAddress < e2.RowAddress then Result := -1
  else
  begin
    if e1.ColumnAddress > e2.ColumnAddress then Result := 1
    else if e1.ColumnAddress < e2.ColumnAddress then Result := -1
    else
    begin
      if e1.Description > e2.Description then Result := 1
      else if e1.Description < e2.Description then Result := -1
      else Result := 0;
    end;
  end;
end;

function CompareTableErrorsColumn(Item1, Item2: Pointer): integer;
var e1, e2: TTableError;
begin
  e1 := TTableError(Item1);
  e2 := TTableError(Item2);

  if e1.ColumnAddress > e2.ColumnAddress then Result := 1
  else if e1.ColumnAddress < e2.ColumnAddress then Result := -1
  else
  begin
    if e1.RowAddress > e2.RowAddress then Result := 1
    else if e1.RowAddress < e2.RowAddress then Result := -1
    else
    begin
      if e1.Description > e2.Description then Result := 1
      else if e1.Description < e2.Description then Result := -1
      else Result := 0;
    end;
  end;
end;

function CompareTableErrorsDescription(Item1, Item2: Pointer): integer;
var e1, e2: TTableError;
begin
  e1 := TTableError(Item1);
  e2 := TTableError(Item2);

  if e1.Description > e2.Description then Result := 1
  else if e1.Description < e2.Description then Result := -1
  else
  begin
    if e1.RowAddress > e2.RowAddress then Result := 1
    else if e1.RowAddress < e2.RowAddress then Result := -1
    else
    begin
      if e1.ColumnAddress > e2.ColumnAddress then Result := 1
      else if e1.ColumnAddress < e2.ColumnAddress then Result := -1
      else Result := 0;
    end;
  end;
end;


function CompareAreas(Item1, Item2: Pointer): integer;
var a1, a2: TIDObject;
    iLen: integer;
    sName1, sName2: string;
begin
  a1 := TIDObject(Item1);
  a2 := TIDObject(Item2);
  iLen := Length(sCurrentAreaNamePart);

  sName1 := trim(StringReplace(a1.Name, '(-ое)', '', [rfReplaceAll]));
  sName2 := trim(StringReplace(a2.Name, '(-ое)', '', [rfReplaceAll]));

  if Length(sName1)/iLen > Length(sName2)/iLen then
    Result := LessThanValue
  else if Length(sName1)/iLen < Length(sName2)/iLen then
    Result := GreaterThanValue
  else
    Result := EqualsValue;
end;

{ TIDObjectSearches }

function TIDObjectSearches.Add: TIDObjectSearch;
begin
  Result := TIDObjectSearch.Create;
  inherited Add(Result);
end;

function TIDObjectSearches.Add(ACol, ARow: integer): TIDObjectSearch;
begin
  Result := Add;
  Result.AddressRow := ARow;
  Result.AddressCol := ACol;
end;

function TIDObjectSearches.Add(ACol, ARow: integer; AIDObject: TIDObject;
  AMatchType: TMatchType): TIDObjectSearch;
begin
  Result := Add(ACol, ARow);
  Result.IDObject := AIDObject;
  Result.MatchType := AMatchType;
end;

constructor TIDObjectSearches.Create;
begin
  inherited Create(true);
end;

function TIDObjectSearches.GetItems(const Index: integer): TIDObjectSearch;
begin
  Result := inherited Items[Index] as TIDObjectSearch;
end;

{ TSubdivisionTable }

function TSubdivisionTable.CanPlaceComment(ACol, ARow: integer;
  AComment: TSubdivisionComment): boolean;
var i: integer;
begin
  Result := true;
  if Assigned(AComment) then
  begin
    if (ARow >  Rows.Count - 2) then
    begin
      Result := false;
      exit;
    end;

    if (ARow = Rows.Count - 2) and (AComment.ID = SUBDIVISION_COMMENT_NOT_DIVIDED) then // не бывает последним не расчленено
    begin
      Result := false;
      exit;
    end;

    if (AComment.ID = SUBDIVISION_COMMENT_NOT_DIVIDED) then
    if  (Assigned(Rows[ARow + 1][ACol]) and Assigned(Rows[ARow + 1][ACol].Data)) then
    if  ((TIDObject(Rows[ARow + 1][ACol].Data).ID = SUBDIVISION_COMMENT_NOT_CROSSED)) then
    begin
      Result := false;
      exit;
    end;

    if AComment.ID = SUBDIVISION_COMMENT_NOT_DIVIDED then
    begin
      Result := false;
      i := ARow + 1;
      if Assigned(Columns[ACol][i]) and (Columns[ACol][i].AsString <> '') then
      begin
        if (not Assigned(Columns[ACol][i].Data)) and ((Columns[ACol][i].AsFloat > 0)) then
        begin
          Result := true;
          exit;
        end
        else if Assigned(Columns[ACol][i].Data) then
        begin
          Result := CanPlaceComment(ACol, i, AComment);
          if Result then exit;
        end;
      end;
    end
    else if AComment.ID in [SUBDIVISION_COMMENT_NO_DATA, SUBDIVISION_COMMENT_NOT_CROSSED, SUBDIVISION_COMMENT_NOT_PRESENT] then
    begin
      if Assigned(Columns[ACol][ARow - 1]) then
      begin
        if (not Assigned(Columns[ACol][ARow - 1].Data)) and (Columns[ACol][ARow - 1].AsFloat > 0) then
        begin
          Result := true;
          exit;
        end
        else if Assigned(Columns[ACol][ARow - 1].Data) then
        begin
          if TIDObject(Columns[ACol][ARow - 1].Data).ID = SUBDIVISION_COMMENT_NOT_DIVIDED then
          begin
            Result := false;
            exit;
          end;
        end;
      end;
    end;
  end;
end;

procedure TSubdivisionTable.CheckComments;
var i, j: integer;
    cm: TSubdivisionComment;
begin
  for i := ALTITUDE_ROW_INDEX  + 1 to RowCount - 1 do
  for j := SECOND_STRATON_COLUMN_INDEX + 1 to ColumnCount - 1 do
  if Assigned(Rows[i][j].Data) and (TObject(Rows[i][j].Data) is TSubdivisionComment) then
  begin
    cm := TObject(Rows[i][j].Data) as TSubdivisionComment;
    if TIDObject(Rows[i][j].Data).ID in [SUBDIVISION_COMMENT_NOT_PRESENT, SUBDIVISION_COMMENT_NOT_DIVIDED, SUBDIVISION_COMMENT_NO_DATA] then
    begin
      if not CanPlaceComment(j, i, cm) then
        TableErrors.AddError(ekCommentNotAllowed, i, j, Rows[i][j], false)
    end;
  end;
end;

procedure TSubdivisionTable.CheckEmptyRows;
var i, j: integer;
    bIsEmptyRow: boolean;
    err: TTableError;
begin
  TableErrors.DeleteErrorsByKind(ekEmptyTableRow); 
  for i := ALTITUDE_ROW_INDEX + 1 to RowCount - 1 do
  begin
    bIsEmptyRow := true;
    for j := SECOND_STRATON_COLUMN_INDEX + 1 to ColumnCount - 1 do
    if ((Rows[i][j].AsFloat > 0) or
       (Assigned(Rows[i][j].Data) and (TObject(Rows[i][j].Data) is TSubdivisionComment)
        and not ((TObject(Rows[i][j].Data) as TSubdivisionComment).Id   in [SUBDIVISION_COMMENT_NOT_PRESENT, SUBDIVISION_COMMENT_NOT_CROSSED, SUBDIVISION_COMMENT_NULL]))) then
    begin
      bIsEmptyRow := false;
      break;
    end;

    if bIsEmptyRow then
    begin
      // добавляем ошибку (пустая строка)
      TableErrors.AddError(ekEmptyTableRow, i, SECOND_STRATON_COLUMN_INDEX, Rows[i][SECOND_STRATON_COLUMN_INDEX], false);
      // если стратон в этой строке не найден - делаем ошибку некритичной
      err := TableErrors.GetErrorbyCellAddress(i, MAIN_STRATON_COLUMN_INDEX);
      if (Assigned(err) and (err.ErrorKind = ekStratonNotFound)) then
        err.IsCritical := false;
    end;
  end;
end;

procedure TSubdivisionTable.CheckStratons;
var i: integer;
begin
  TableErrors.DeleteErrorsByKind(ekStratonNotFound);
  for i := ALTITUDE_ROW_INDEX + 1 to StratonMainColumn.Count  - 2 do
  begin
    if (StratonMainColumn.Items[i].AsString <> '') and (not Assigned(StratonMainColumn.Items[i].Data)) then
      TableErrors.AddError(ekStratonNotFound, i, MAIN_STRATON_COLUMN_INDEX, StratonMainColumn[i], true);

    if (StratonSecondColumn.Items[i].AsString <> '') and (not Assigned(StratonSecondColumn.Items[i].Data)) then
      TableErrors.AddError(ekStratonNotFound, i, SECOND_STRATON_COLUMN_INDEX, StratonSecondColumn[i], true);
  end;
end;

procedure TSubdivisionTable.CheckSubdivisions(AComments: TSubdivisionComments);
var i, j, iTectBlockID: integer;
    s: string;
    f, lastf, firstf, lastPositivef: single;
    comment: TSubdivisionComment;
    alt, td: single;
begin
  TableErrors.DeleteErrorsByKinds([ekNoRsingDepths, ekNoNumberDepths, ekNoAltitude, ekNoTotalDepth, ekInconsistentSubdivision]);
  //f := 0;
  for i := SECOND_STRATON_COLUMN_INDEX + 1 to Columns.Count - 1 do
  begin
    firstf := 0;
    f := 0;
    lastPositivef := 0;
    for j := ALTITUDE_ROW_INDEX + 1 to Columns[i].Count - 2 do
    begin
      s := Columns[i][j].AsString;

      lastf := f;
      if f > -1 then lastPositivef := f;
      f := StrToFloatEx(s);
      if (firstf = 0) then firstf := f;

      if f > -1 then
      begin
        iTectBlockID := TIDObjectSearch(TectonicBlockRow[i].Data).IDObject.ID;
        if (iTectBlockID <> PODV_TECTONIC_BLOCK_ID) then
        begin
          // проверяем возрастание
          if f < lastf then
            TableErrors.AddError(ekNoRsingDepths, j, i, Columns[i][j], true);
        end;
      end
      else
      begin
        // проверяем и привязываем комментарий
        s := StringReplace(s, '.', '', [rfReplaceAll]);
        s := StringReplace(s, ',', '', [rfReplaceAll]);
        // ищем среди комментариев
        comment := AComments.GetItemByShortName(s) as TSubdivisionComment;
        if Assigned(comment) then
          Columns[i][j].Data := comment
        else
          TableErrors.AddError(ekNoNumberDepths, j, i, Columns[i][j], true);
      end;
    end;

    if f > -1 then lastPositivef := f;

    // проверяем целая ли разбивка
    s := AltitudeRow[i].AsString;
    alt := StrToFloatEx(s);
    if alt = -1 then TableErrors.AddError(ekNoAltitude, ALTITUDE_ROW_INDEX, i, AltitudeRow[i], false);

    s := Rows[RowCount - 1][i].AsString;
    td := StrToFloatEx(s);
    if td = -1 then TableErrors.AddError(ekNoTotalDepth, RowCount - 1 , i, Rows[RowCount - 1][i], false);

    // разница между альтитудой и забоем и началом и концом разбивки не должна быть слишком большой (10%)
    if (alt > -1) and (td > -1) and ((not Assigned(TectonicBlockRow[i].Data)) or (TTectonicBlock(TectonicBlockRow[i].Data).ID = NO_TECTONIC_BLOCK_ID)) then
      if (lastPositivef - firstf)/(td - alt) < 0.8 then
        TableErrors.AddError(ekInconsistentSubdivision, AREA_ROW_INDEX, i, AreaRow[i], false);

  end;
end;

procedure TSubdivisionTable.CheckWells;
var i: integer;
    w: TWell;
    s: TIDObjectSearch;
    sAreaName: string;
begin
  for i := 0 to FUINs.Count - 1 do
  if FUINs.Items[i] > 0 then
  begin
    w := FoundWells.ItemsByID[FUINs.Items[i]] as TWell;
    if Assigned(w) then
    begin
      s := IDObjectSearches.Add(i, WELL_NUMBER_ROW_INDEX, w, mtPartial);
      sAreaName := trim(StringReplace(AreaRow[i].AsString, '(-ое)', '', [rfReplaceAll, rfIgnoreCase]));

      // если площадь начинается с тех же букв и номер совпадает - это mtExact
      if ((pos(AnsiUpperCase(sAreaName), AnsiUpperCase(w.Area.Name)) = 1) and (AnsiUpperCase(WellRow[i].AsString) = AnsiUpperCase(trim(w.NumberWell)))) then
        s.MatchType := mtExact
      // если площадь просто содержит эти буквы, и номер совпадает - это mtExactWithCompletion
      else if ((pos(AnsiUpperCase(sAreaName), AnsiUpperCase(w.Area.Name)) > 1) and (AnsiUpperCase(WellRow[i].AsString) = AnsiUpperCase(trim(w.NumberWell)))) then
        s.MatchType := mtExactWithCompletion
      else
      begin

      end;
      // сверяем альтитуду и забой
      if (w.Altitude <> 0) and (w.TrueDepth <> 0) then
        s.AreAdditionalParametersEqual :=  (Abs(w.Altitude - AltitudeRow[i].AsFloat)/w.Altitude <= 0.1) and (Abs(w.TrueDepth - TotalDepthRow[i].AsFloat)/w.TrueDepth <= 0.1)
      else
        s.AreAdditionalParametersEqual :=  false;

      WellRow[i + SECOND_STRATON_COLUMN_INDEX + 1].Data := s;
    end
    else WellRow[i + SECOND_STRATON_COLUMN_INDEX + 1].Data := nil;
  end
  else WellRow[i + SECOND_STRATON_COLUMN_INDEX + 1].Data := nil;
end;

destructor TSubdivisionTable.Destroy;
begin
  FreeAndNil(FIDObjectSearches);
  FreeAndNil(FTableErrors);
  FreeAndNil(FFoundWells);
  FreeAndNil(FUINs);

  inherited;
end;


procedure TSubdivisionTable.ExportToExcel(AFileName: string);
var varTable: OleVariant;
    i, j: integer;
    excel, wb: OleVariant;
begin
  varTable := VarArrayCreate([0, Rows.Count - 1, 0, Columns.Count - 1], varVariant);

  for i := 0 to Rows.Count - 1 do
  for j := 0 to Columns.Count - 1 do
    varTable[i, j] := Rows[i][j].Value;



  excel := CreateOleObject('Excel.Application');
  excel.Visible := true;
  excel.Application.EnableEvents := false;
  excel.Application.ScreenUpdating := false;

  wb := excel.WorkBooks.Add;
  wb.Worksheets[1].Range[wb.Worksheets[1].Cells[1, 1], wb.Worksheets[1].Cells[Rows.Count, Columns.Count]] := varTable;

  excel.Visible := true;
  excel.Application.EnableEvents := true;
  excel.Application.ScreenUpdating := true;

end;

procedure TSubdivisionTable.FillStratonColumn(
  AColumnIndex: integer; AStratons: TSimpleStratons);
var i: integer;
    StratonColumn: TBaseTableCells;
    FoundStratons: TSimpleStratons;
    Straton: TSimpleStraton;
    sStratonName: string;

function GetStratonOfTaxonomyType(ATaxonomyType: TTaxonomyType): TSimpleStraton;
var j: integer;
begin
  Result := nil;
  with FoundStratons do
  for j := 0 to Count - 1 do
  if Assigned(Items[j].Taxonomy) and
     (Items[j].Taxonomy.TaxonomyType = ATaxonomyType) then
  begin
    result := Items[j];
    break;
  end;
end;

begin
  FoundStratons := TSimpleStratons.Create;
  FoundStratons.OwnsObjects := false;
  StratonColumn := Columns[AColumnIndex];

  for i := ALTITUDE_ROW_INDEX + 1 to StratonColumn.Count - 2 do
  if StratonColumn.Items[i].AsString <> '' then
  begin
    FoundStratons.Clear;
    StratonColumn.Items[i].Data := nil;
    sStratonName := StringReplace(StratonColumn.Items[i].AsString, '.', '', [rfReplaceAll]);
    
    AStratons.GetItemsByName(sStratonName, FoundStratons);
    if FoundStratons.Count >= 1 then
    begin
      // выбираем из найденных стратонов наиболее общее подразделение
      Straton := GetStratonOfTaxonomyType(TMainFacade.GetInstance.AllStratTaxonomyTypes.ItemsByID[GENERAL_TAXONOMY_TYPE_ID] as TTaxonomyType);
      if Assigned(Straton) then
        StratonColumn.Items[i].Data := IDObjectSearches.Add(i, AColumnIndex, Straton, mtExact)
      else
      begin
        Straton := GetStratonOfTaxonomyType(TMainFacade.GetInstance.AllStratTaxonomyTypes.ItemsByID[REGIONAL_TAXONOMY_TYPE_ID] as TTaxonomyType);
        if Assigned(Straton) then
          StratonColumn.Items[i].Data := IDObjectSearches.Add(i, AColumnIndex, Straton, mtExact)
        else
        begin
          Straton := GetStratonOfTaxonomyType(TMainFacade.GetInstance.AllStratTaxonomyTypes.ItemsByID[SUBREGIONAL_TAXONOMY_TYPE_ID] as TTaxonomyType);
          if Assigned(Straton) then
            StratonColumn.Items[i].Data := IDObjectSearches.Add(i, AColumnIndex, Straton, mtExact)
          else
          begin
            Straton := GetStratonOfTaxonomyType(TMainFacade.GetInstance.AllStratTaxonomyTypes.ItemsByID[LOCAL_TAXONOMY_TYPE_ID] as TTaxonomyType);
            if Assigned(Straton) then
              StratonColumn.Items[i].Data := IDObjectSearches.Add(i, AColumnIndex, Straton, mtPartial)
            else
            begin
              Straton := GetStratonOfTaxonomyType(TMainFacade.GetInstance.AllStratTaxonomyTypes.ItemsByID[UNKNOWN_TAXONOMY_TYPE_ID] as TTaxonomyType);
              if Assigned(Straton) then
                StratonColumn.Items[i].Data := IDObjectSearches.Add(i, AColumnIndex, Straton, mtPartial)
              else
              begin
                Straton := FoundStratons.Items[0];
                StratonColumn.Items[i].Data := IDObjectSearches.Add(i, AColumnIndex, Straton, mtPartial)
              end;
            end;
          end;
        end;
      end;
    end
    else if not Assigned(StratonColumn.Items[i].Data) then
      TableErrors.AddError(ekStratonNotFound, i, AColumnIndex, StratonColumn[i], true);
  end;

  FreeAndNil(FoundStratons);
end;

procedure TSubdivisionTable.FillTectonicBlockRow(
  ATectonicBlocks: TTectonicBlocks);
var i, j: integer;
    sBlock: string;
    bFound: boolean;
begin
  for i := SECOND_STRATON_COLUMN_INDEX + 1 to TectonicBlockRow.Count - 1 do
  begin
    sBlock := trim(AnsiUpperCase(TectonicBlockRow[i].AsString));
    if (sBlock <> '') then
    begin
      bFound := false;

      for j := 0 to ATectonicBlocks.Count - 1 do
      if AnsiUpperCase(ATectonicBlocks.Items[j].ShortName) = sBlock then
      begin
        TectonicBlockRow[i].Data := IDObjectSearches.Add(i, TECTONIC_BLOCK_ROW_INDEX, ATectonicBlocks.Items[j], mtExact);
        bFound := true;
        break;
      end;

      if bFound then continue;


      for j := 1 to 6 do
      if pos(IntToStr(j), sBlock) > 0 then
      begin
        bFound := true;
        sBlock := copy(sBlock, 1, 4) + '(' + IntToStr(j) + ')';
      end;

      if not bFound then
        sBlock := copy(sBlock, 1, 4);

      bFound := false;
      for j := 0 to ATectonicBlocks.Count - 1 do
      if AnsiUpperCase(ATectonicBlocks.Items[j].ShortName) = sBlock then
      begin
        TectonicBlockRow[i].Data := IDObjectSearches.Add(i, TECTONIC_BLOCK_ROW_INDEX, ATectonicBlocks.Items[j], mtExact);
        bFound := true;
        break;
      end;

      if not bFound then
      begin
        for j := 0 to ATectonicBlocks.Count - 1 do
        if Pos(AnsiUpperCase(ATectonicBlocks.Items[j].ShortName), sBlock) = 1 then
        begin
          TectonicBlockRow[i].Data := IDObjectSearches.Add(i, TECTONIC_BLOCK_ROW_INDEX, ATectonicBlocks.Items[j], mtExactWithCompletion);
          bFound := true;
          break;
        end;
      end;

      if not bFound then
      begin
        TableErrors.AddError(ekTectonicBlockNotFound, TECTONIC_BLOCK_ROW_INDEX, i, TectonicBlockRow[i], true);
        TectonicBlockRow[i].Data := IDObjectSearches.Add(i, TECTONIC_BLOCK_ROW_INDEX, ATectonicBlocks.ItemsByID[NO_TECTONIC_BLOCK_ID], mtExactWithCompletion);        
      end;
    end
    else
      TectonicBlockRow[i].Data := IDObjectSearches.Add(i, TECTONIC_BLOCK_ROW_INDEX, ATectonicBlocks.ItemsByID[NO_TECTONIC_BLOCK_ID], mtExactWithCompletion);
  end;
end;




procedure TSubdivisionTable.FillWellNumbersRow;
begin
  FUINs := TIntegerList.Create;
  LoadWells;
  CheckWells;
  FreeAndNil(FUINs);
end;

procedure TSubdivisionTable.FindStratons(AStratons: TSimpleStratons);
begin
  FillStratonColumn(MAIN_STRATON_COLUMN_INDEX, AStratons);
  FillStratonColumn(SECOND_STRATON_COLUMN_INDEX, AStratons);
end;

function TSubdivisionTable.GetAltitudeRow: TBaseTableCells;
begin
  Result := Rows[ALTITUDE_ROW_INDEX];
end;

function TSubdivisionTable.GetAreaRow: TBaseTableCells;
begin
  Result := Rows[AREA_ROW_INDEX];
end;


function TSubdivisionTable.GetFoundWells: TWells;
begin
  if not Assigned(FFoundWells) then
    FFoundWells := TWells.Create;

  Result := FFoundWells;
end;

function TSubdivisionTable.GetIDObjectSeraches: TIDObjectSearches;
begin
  if not Assigned(FIDObjectSearches) then
    FIDObjectSearches := TIDObjectSearches.Create;

  Result := FIDObjectSearches;
end;

function TSubdivisionTable.GetStratonMainColumn: TBaseTableCells;
begin
  Result := Columns[MAIN_STRATON_COLUMN_INDEX];
end;

function TSubdivisionTable.GetStratonSecondColumn: TBaseTableCells;
begin
  Result := Columns[SECOND_STRATON_COLUMN_INDEX];
end;

function TSubdivisionTable.GetTableErrors: TTableErrors;
begin
  if not Assigned(FTableErrors) then
    FTableErrors := TTableErrors.Create;

  result := FTableErrors;
end;

function TSubdivisionTable.GetTectonicBlockRow: TBaseTableCells;
begin
  Result := Rows[TECTONIC_BLOCK_ROW_INDEX];
end;

function TSubdivisionTable.GetTotalDepthRow: TBaseTableCells;
begin
  Result := Rows[RowCount - 1]; 
end;

function TSubdivisionTable.GetWellRow: TBaseTableCells;
begin
  Result := Rows[WELL_NUMBER_ROW_INDEX];
end;

procedure TSubdivisionTable.LoadSubdivisions(ATheme: TTheme;
  AWells: TWells);
var i, j, k: integer;
    Stratons: TStratons;
    ss: TSimpleStraton;
    row: TBaseTableCells;
    cell: TBaseTableCell;
    iColumn: integer;
begin
  Assert(Assigned(AWells));
  Stratons := TStratons.Create;
  Stratons.OwnsObjects := false;
  GatherStratons(AWells, ATheme, Stratons);
  PrepareHeader;

  for i := 0 to Stratons.Count - 1 do
  begin
    row := Rows.Add;
    cell := row.Add;
    cell.Value := Stratons.Items[i].List(loBrief);
    ss := Stratons.Items[i].Straton;
    columns[0].Add(cell);

    cell := row.Add;
    if Assigned(Stratons.Items[i].TempLink) then
      cell.Value := Stratons.Items[i].TempLink.List(loBrief);
    columns[1].Add(cell);

    iColumn := 0;

    for j := 0 to AWells.Count - 1 do
    begin
      for k := 0 to AWells.Items[j].Subdivisions.Count - 1 do
      if ((ATheme = nil) or (AWells.Items[j].Subdivisions.Items[k].Theme = ATheme)) then
      begin
        PlaceSubdivisionStratonCells(AWells.Items[j].Subdivisions.Items[k], ss, row, iColumn + SECOND_STRATON_COLUMN_INDEX + 1);
        inc(iColumn, AWells.Items[j].Subdivisions.Items[k].SubdivisionComponents.BlockCount);
      end;


    end;
  end;
  AddTotalDepth(ATheme, AWells);
  FillEmpties((TMainFacade.GetInstance as TMainFacade).AllSubdivisionComments, (TMainFacade.GetInstance as TMainFacade).AllTectonicBlocks);
  FreeAndNil(Stratons);

end;

procedure TSubdivisionTable.LoadSubdivisions(AWells: TWells);
begin
  LoadSubdivisions(TTheme(nil), AWells);
end;

procedure TSubdivisionTable.LoadSubdivisions(AWell: TWell);
begin
  LoadSubdivisions(TTheme(nil), AWell);
end;

procedure TSubdivisionTable.LoadSubdivisionTable(AStratons: TSimpleStratons;
  AComments: TSubdivisionComments; ATectonicBlocks: TTectonicBlocks);
begin
  TableErrors.Clear;
  FindStratons(AStratons);
  FillTectonicBlockRow(ATectonicBlocks);
  FillWellNumbersRow;
  CheckSubdivisions(AComments);
  CheckEmptyRows;
  CheckComments;
end;

procedure TSubdivisionTable.LoadWells;
var i, j, iUIN: integer;
    sAreaName: string;
    Areas: TSimpleAreas;
    vQueryResult: OleVariant;
    sQueryArea, sQueryArea2, sQuerySynonym, sQuerySynonym2, sFilter: string;
    bWellFound: boolean;
    lstAreas: TStrings;
begin
  if FoundWells.Count = 0 then
  begin
    sQueryArea := 'select w.Well_UIN from vw_Well w where w.Area_ID = %d and rf_rupper(vch_Well_NUM) = rf_rupper(''%s'')';
    sQueryArea2 := 'select w.Well_UIN from vw_Well w where w.Area_ID = %d and rf_rupper(vch_Well_NUM) starting with rf_rupper(''%s'')';

    sQuerySynonym := 'select w.Well_UIN from vw_Well w where rf_rupper(w.vch_Well_Name) containing rf_rupper(''%s'') and rf_rupper(vch_Well_NUM) = rf_rupper(''%s'')';
    sQuerySynonym2 := 'select w.Well_UIN from vw_Well w where rf_rupper(w.vch_Well_Name) containing rf_rupper(''%s'') and rf_rupper(vch_Well_NUM) starting with rf_rupper(''%s'')';

    sFilter := '';


    Areas := TSimpleAreas.Create;
    Areas.OwnsObjects := false;
    lstAreas := TStringList.Create;
    // находим площади по вхождению наименования
    for i := SECOND_STRATON_COLUMN_INDEX + 1 to AreaRow.Count - 1 do
    begin
      Areas.Clear;
      lstAreas.Clear;

      sAreaName := ImproveAreaName(AreaRow[i].AsString);

      if pos('.', sAreaName) > 0 then
      begin
        Split(sAreaName, ['.'], lstAreas);
        for j := lstAreas.Count - 1 downto 0 do
          if trim(lstAreas[j]) = '' then lstAreas.Delete(j);
      end;

      if pos('-', sAreaName) > 0 then
      begin
        if lstAreas.Count = 1 then
          Split(sAreaName, ['-'], lstAreas);
        for j := lstAreas.Count - 1 downto 0 do
          if trim(lstAreas[j]) = '' then lstAreas.Delete(j);
      end;

      if lstAreas.Count = 0 then lstAreas.Add(sAreaName);

      if lstAreas.Count = 2 then
      begin
        if AnsiUpperCase(lstAreas[0][1]) = 'Ю' then
          lstAreas[0] := 'Южно'
        else if AnsiUpperCase(lstAreas[0][1]) = 'C' then
          lstAreas[0] := 'Северо'
        else if AnsiUpperCase(lstAreas[0][1]) = 'З' then
          lstAreas[0] := 'Западно'
        else if AnsiUpperCase(lstAreas[0][1]) = 'В' then
          lstAreas[0] := 'Восточно'
        else if AnsiUpperCase(lstAreas[0][1]) = 'Ц' then
          lstAreas[0] := 'Центрально';

        sAreaName := lstAreas[0] + '-' + lstAreas[1];
        sCurrentAreaNamePart := sAreaName;

        sAreaName := lstAreas[1];
        TMainFacade.GetInstance.AllAreas.GetItemsByPartialName(sAreaName, Areas);

        Areas.Sort(CompareAreas)

      end
      else if lstAreas.Count = 1 then
      begin
        sAreaName := lstAreas[0];
        TMainFacade.GetInstance.AllAreas.GetItemsByPartialName(sAreaName, Areas);
        // сортируем площади
        sCurrentAreaNamePart := sAreaName;
        Areas.Sort(CompareAreas)
      end;



  ;

      bWellFound := false;
      // для каждой площади, начиная с наиболее подходяших делаем запрос скважины
      for j := 0 to Areas.Count - 1 do
      begin
        if (TMainFacade.GetInstance.DBGates.ExecuteQuery(Format(sQueryArea, [Areas.Items[j].ID, WellRow[i].AsString]), vQueryResult) > 0) then
        begin
          iUin := vQueryResult[0,0];
          sFilter := sFilter + ',' + IntToStr(iUIN);
          bWellFound := true;
          FUINs.Add(iUIN);
          break;
        end;
      end;

      if not bWellFound then
      begin
        for j := 0 to Areas.Count - 1 do
        begin
          if (TMainFacade.GetInstance.DBGates.ExecuteQuery(Format(sQuerySynonym, [trim(StringReplace(Areas.Items[j].Name, '(-ое)', '', [rfReplaceAll])), WellRow[i].AsString]), vQueryResult) > 0) then
          begin
            iUin := vQueryResult[0,0];
            sFilter := sFilter + ',' + IntToStr(iUIN);
            bWellFound := true;
            FUINs.Add(iUIN);
            break;
          end;
        end;
      end;

      if not bWellFound then
      begin
        for j := 0 to Areas.Count - 1 do
        begin
          if (TMainFacade.GetInstance.DBGates.ExecuteQuery(Format(sQueryArea2, [Areas.Items[j].ID, WellRow[i].AsString]), vQueryResult) > 0) then
          begin
            iUin := vQueryResult[0,0];
            sFilter := sFilter + ',' + IntToStr(iUIN);
            bWellFound := true;
            FUINs.Add(iUIN);
            break;
          end;
        end;
      end;

      if not bWellFound then
      begin
        for j := 0 to Areas.Count - 1 do
        begin
          if (TMainFacade.GetInstance.DBGates.ExecuteQuery(Format(sQuerySynonym2, [trim(StringReplace(Areas.Items[j].Name, '(-ое)', '', [rfReplaceAll])), WellRow[i].AsString]), vQueryResult) > 0) then
          begin
            iUin := vQueryResult[0,0];
            sFilter := sFilter + ',' + IntToStr(iUIN);
            bWellFound := true;
            FUINs.Add(iUIN);
            break;
          end;
        end;
      end;


      if not bWellFound then
      begin
        if (TMainFacade.GetInstance.DBGates.ExecuteQuery(Format(sQuerySynonym, [sAreaName, WellRow[i].AsString]), vQueryResult) > 0) then
        begin
          iUin := vQueryResult[0,0];
          sFilter := sFilter + ',' + IntToStr(iUIN);
          FUINs.Add(iUIN);
          break;
        end;
      end;

      if not bWellFound then
      begin
        FUINs.Add(0);
        TableErrors.AddError(ekWellNotFound, WELL_NUMBER_ROW_INDEX, i, WellRow[i], true);
      end;
    end;

    sFilter := copy(sFilter, 2, Length(sFilter));
    FoundWells.Reload('Well_UIN in (' + sFilter + ')');

    FreeAndNil(Areas);
    FreeAndNil(lstAreas);
  end
  else
  begin
    for i := SECOND_STRATON_COLUMN_INDEX + 1 to WellRow.Count - 1 do
    if Assigned(WellRow.Items[i].Data) then 
      FUINs.Add(Integer(WellRow.Items[i].Data));
  end;
end;

procedure TSubdivisionTable.MakeSubdivisions(ATheme: TTheme; ASigningDate: TDateTime; ASigningEmployee: TEmployee; AWells: TWells);
var i, j: integer;
    w: TWell;
    s: TSubdivision;
    sc: TSubdivisionComponent;
    ido: TIDObjectSearch;
begin
  AWells.Clear;
  AWells.Reload('Well_UIN in (' + FoundWells.IDList + ')');

  if Assigned(FOnSetProgress) then FOnSetProgress(nil);

  for i := 2 to Columns.Count - 1 do
  begin
    ido := TIDObjectSearch(WellRow[i].Data);
    if Assigned(ido) and Assigned(ido.IDObject) then
    begin
      w := AWells.ItemsByID[ido.IdObject.ID] as TWell;
      if Assigned(w) then
      begin
        // удаляем старую разбивку или несколько если они существовали
        s := w.Subdivisions.GetSubdivisionByTheme(ATheme);
        while Assigned(s) do
        begin
          w.Subdivisions.MarkDeleted(s);
          s := w.Subdivisions.GetSubdivisionByTheme(ATheme);
        end;

        s := w.Subdivisions.Add as TSubdivision;
        s.Theme := ATheme;
        s.SingingDate := ASigningDate;
        s.SigningEmployee := ASigningEmployee;

        for j := ALTITUDE_ROW_INDEX + 1 to Columns[i].Count - 2 do
        if Columns[i][j].AsString <> '' then
        begin
          if (Assigned(Columns[i][j].Data) and not(TIDObject(Columns[i][j].Data).ID in [SUBDIVISION_COMMENT_NOT_CROSSED, SUBDIVISION_COMMENT_NOT_PRESENT])) or
             (not Assigned(Columns[i][j].Data) and not Columns[i][j].IsEmpty)  then
          begin
            sc := s.SubdivisionComponents.Add as TSubdivisionComponent;
            sc.Straton := TStraton(TIDObjectSearch(StratonMainColumn.Items[j].Data).IDObject);
            if Assigned(StratonSecondColumn.Items[j].Data) then
              sc.NextStraton := TStraton(TIDObjectSearch(StratonSecondColumn.Items[j].Data).IDObject);

            if Assigned(TectonicBlockRow[i].Data) then
              sc.Block := TTectonicBlock(TIDObjectSearch(TectonicBlockRow[i].Data).IDObject);


            sc.Depth := Columns[i][j].AsFloat;


            if Assigned(Columns[i][j].Data) then
            begin
              if not (TSubdivisionComment(Columns[i][j].Data).ID in [SUBDIVISION_COMMENT_NULL, SUBDIVISION_COMMENT_STOP, SUBDIVISION_COMMENT_NOT_PRESENT]) then
                sc.Comment := TSubdivisionComment(Columns[i][j].Data);
            end;

            sc.Verified := 1;

          end;
        end;
      end;
    end;
    if Assigned(FOnMoveProgress) then FOnMoveProgress(nil);
  end;
end;

procedure TSubdivisionTable.LoadSubdivisions(ATheme: TTheme;
  AWell: TWell);
var i, j, iColumn: integer;
    Stratons: TStratons;
    ss: TSimpleStraton;
    row: TBaseTableCells;
    cell: TBaseTableCell;
begin

  Stratons := TStratons.Create;
  Stratons.OwnsObjects := false;
  GatherStratons(AWell, ATheme, Stratons);
  PrepareHeader;
  for i := 0 to Stratons.Count - 1 do
  begin
    row := Rows.Add;
    cell := row.Add;
    cell.Value := Stratons.Items[i].List(loBrief);
    ss := Stratons.Items[i].Straton;
    columns[0].Add(cell);

    cell := row.Add;
    if Assigned(Stratons.Items[i].TempLink) then
      cell.Value := Stratons.Items[i].TempLink.List(loBrief);
    columns[1].Add(cell);

    iColumn := 0;
    for j := 0 to AWell.Subdivisions.Count - 1 do
    if ((ATheme = nil) or (AWell.Subdivisions.Items[j].Theme = ATheme)) then
    begin
      PlaceSubdivisionStratonCells(AWell.Subdivisions.Items[j], ss, row, iColumn + SECOND_STRATON_COLUMN_INDEX + 1);
      inc(iColumn, AWell.Subdivisions.Items[j].SubdivisionComponents.BlockCount);
    end;
  end;
  AddTotalDepth(ATheme, AWell);
  FillEmpties((TMainFacade.GetInstance as TMainFacade).AllSubdivisionComments, (TMainFacade.GetInstance as TMainFacade).AllTectonicBlocks);
  FreeAndNil(Stratons);
end;

procedure TSubdivisionTable.GatherStratons(AWell: TWell; ATheme: TTheme;
  AStratons: TStratons; const NeedsSorting: boolean = true);
var i, j: integer;
    s: TStraton;
begin
  Assert(Assigned(AStratons));
  Assert(Assigned(AWell));

  with AWell.Subdivisions do
  begin
    for i := 0 to Count - 1 do
    if ((ATheme = nil) or (Items[i].Theme = ATheme)) then
    for j := 0 to Items[i].SubdivisionComponents.Count - 1 do
    if Assigned(Items[i].SubdivisionComponents.Items[j].Straton)  then
    begin
      s := (TMainFacade.GetInstance as TMainFacade).AllStratons.ItemsByStratonID[Items[i].SubdivisionComponents.Items[j].Straton.ID];
      if Assigned(s) then
      begin
        AStratons.Add(s, false, true);
        if Assigned(Items[i].SubdivisionComponents.Items[j].NextStraton) then
        if Items[i].SubdivisionComponents.Items[j].NextStraton.ID <> s.Straton.ID then 
          s.TempLink := Items[i].SubdivisionComponents.Items[j].NextStraton;
      end;
    end;
  end;

  if NeedsSorting then AStratons.SortByAge;
end;

procedure TSubdivisionTable.GatherStratons(AWells: TWells; ATheme: TTheme;
  AStratons: TStratons);
var i: integer;
begin
  Assert(Assigned(AStratons));
  Assert(Assigned(AWells));
  for i := 0 to AWells.Count - 1 do
    GatherStratons(AWells.Items[i], ATheme, AStratons, false);
  AStratons.SortByAge;
end;

procedure TSubdivisionTable.PlaceSubdivisionStratonCells(ASubdivision: TSubdivision; AStraton: TSimpleStraton; ARow: TBaseTableCells; const AColumnIndex: integer);
var sc: TSubdivisionComponent;
    k: integer;
    column: TBaseTableCells;
    cell: TBaseTableCell;
begin
  for k := 0 to ASubdivision.SubdivisionComponents.BlockCount - 1 do
  begin
    Rows[0].AddToIndex(AColumnIndex + k);

    if AColumnIndex + k > Columns.Count - 1 then
      while AColumnIndex + k > Columns.Count - 1 do
      begin
        column := columns.Add;
        column.add;
      end;

    column := columns[AColumnIndex + k];

    AreaRow.AddToIndex(AColumnIndex + k);
    cell := AreaRow[AColumnIndex + k];
    cell.Value := (ASubdivision.Owner as TWell).Area.List();
    if column.Count = 1 then column.Add(cell);

    WellRow.AddToIndex(AColumnIndex + k);
    cell := WellRow[AColumnIndex + k];
    cell.Value := (ASubdivision.Owner as TWell).NumberWell;
    cell.Data := Pointer((ASubdivision.Owner as TWell).ID);
    if column.Count = 2 then column.Add(cell);

    TectonicBlockRow.AddToIndex(AColumnIndex + k);
    cell := TectonicBlockRow[AColumnIndex + k];
    cell.Value := ASubdivision.SubdivisionComponents.BlockSubdivisionComponents[k].Block.List();
    if column.Count = 3 then column.Add(cell);

    AltitudeRow.AddToIndex(AColumnIndex + k);
    cell := AltitudeRow[AColumnIndex + k];
    cell.Value := Format('%.2f', [(ASubdivision.Owner as TWell).Altitude]);
    if column.Count = 4 then column.Add(cell);

    sc := ASubdivision.SubdivisionComponents.BlockSubdivisionComponents[k].GetComponentByStraton(AStraton);
    ARow.AddToIndex(AColumnIndex + k);
    cell := ARow[AColumnIndex + k];
    if Assigned(sc) then
      cell.Value := sc.List();
    column.Add(cell);  

  end;
end;

procedure TSubdivisionTable.PrepareHeader;
var row, column: TBaseTableCells;
    c: TBaseTableCell;
    i, j: integer;
begin
  for i := 0 to ALTITUDE_ROW_INDEX  do
  begin
    row := Rows.Add();
    for j := 0 to SECOND_STRATON_COLUMN_INDEX do
    begin
      if Columns.Count - 1 < j then
        column := Columns.Add()
      else
        column := Columns[j];

      c := row.Add;
      column.Add(c);
    end;
  end;

  Rows[0][0].Value := 'Глубина подошвы';
  Rows[1][0].Value := 'Индекс';
  Rows[1][1].Value := 'Площадь';
  Rows[2][1].Value := '№№ скв.';
  Rows[3][1].Value := 'Тект. блок';
  Rows[4][1].Value := 'Альт., м';


end;

function TSubdivisionTable.GetWellAndTectonicBlockColumn(AWell: TWell;
  ATectonicBlock: TTectonicBlock): TBaseTableCells;
var i: integer;
begin
  Result := nil;
  for i := SECOND_STRATON_COLUMN_INDEX + 1 to Columns.Count - 1 do
  if (TIDObjectSearch(WellRow[i].Data).IDObject.ID = AWell.ID) and
     (TIDObjectSearch(TectonicBlockRow[i].Data).IDObject.ID = ATectonicBlock.ID) then
  begin
    Result := Columns[i];
    break;
  end;
end;

procedure TSubdivisionTable.AddTotalDepth(ATheme: TTheme; AWells: TWells);
var row: TBaseTableCells;
    iColumn, j, k, i: integer;
    cell: TBaseTableCell;
begin
  iColumn := SECOND_STRATON_COLUMN_INDEX + 1;
  row := rows.Add;
  cell := row.Add;
  StratonMainColumn.Add(cell);
  cell.Value := 'Забой';

  cell := row.Add;
  StratonSecondColumn.Add(cell);
  for j := 0 to AWells.Count - 1 do
  begin
    for k := 0 to AWells.Items[j].Subdivisions.Count - 1 do
    if ((ATheme = nil) or (AWells.Items[j].Subdivisions.Items[k].Theme = ATheme)) then
    begin
      for i := 0 to AWells.Items[j].Subdivisions.Items[k].SubdivisionComponents.BlockCount - 1 do
      begin
        row.AddToIndex(iColumn + i);
        cell := row[iColumn + i];
        cell.Value := Format('%.2f', [AWells.Items[j].TrueDepth]);
        Columns.AddToIndex(iColumn + i, False);
        Columns[iColumn + i].Add(Cell);
      end;
      inc(iColumn, AWells.Items[j].Subdivisions.Items[k].SubdivisionComponents.BlockCount);
    end;
  end;
end;

procedure TSubdivisionTable.AddTotalDepth(ATheme: TTheme; AWell: TWell);
var row: TBaseTableCells;
    iColumn, k, i: integer;
    cell: TBaseTableCell;
begin
  iColumn := SECOND_STRATON_COLUMN_INDEX + 1;
  row := rows.Add;
  cell := row.Add;
  StratonMainColumn.Add(cell);
  cell.Value := 'Забой';

  for k := 0 to AWell.Subdivisions.Count - 1 do
  if ((ATheme = nil) or (AWell.Subdivisions.Items[k].Theme = ATheme)) then
  begin
    for i := 0 to AWell.Subdivisions.Items[k].SubdivisionComponents.BlockCount - 1 do
    begin
      row.AddToIndex(iColumn + i);
      cell := row[iColumn + i];
      cell.Value := Format('%.2f', [AWell.TrueDepth]);
      Columns.AddToIndex(iColumn + i, False);

      Columns[iColumn + i].Add(Cell);
    end;
    inc(iColumn, AWell.Subdivisions.Items[k].SubdivisionComponents.BlockCount);
  end;
end;

procedure TSubdivisionTable.FillEmpties(AComments: TSubdivisionComments; ABlocks: TTectonicBlocks);
var i, j, iLastRow: integer;
begin
  for j := SECOND_STRATON_COLUMN_INDEX + 1 to ColumnCount - 1 do
  begin
    iLastRow := 0;
    // нв для всех, кто не является тектоническим блоком
    if (TectonicBlockRow[j].IsEmpty or (TectonicBlockRow[j].AsString =  ABlocks.ItemsByID[NO_TECTONIC_BLOCK_ID].List(loBrief))) then
    begin
      for i := RowCount - 2 downto ALTITUDE_ROW_INDEX + 1 do
      if Rows[i][j].IsEmpty then
        Rows[i][j].Value := AComments.ItemsByID[SUBDIVISION_COMMENT_NOT_CROSSED].List(loBrief)
      else
      begin
        iLastRow := i - 1;
        break;
      end;
    end
    else iLastRow := RowCount - 2;

    // отсутствует
    for i := iLastRow downto ALTITUDE_ROW_INDEX + 1 do
    if Rows[i][j].IsEmpty then
      Rows[i][j].Value := AComments.ItemsByID[SUBDIVISION_COMMENT_NOT_PRESENT].List(loBrief)
  end;
end;

procedure TSubdivisionTable.LoadSubdivisions(AThemes: TThemes;
  AWells: TWells);
var i, j, k: integer;
    Stratons: TStratons;
    ss: TSimpleStraton;
    row: TBaseTableCells;
    cell: TBaseTableCell;
    iColumn: integer;
begin
  if not Assigned(AThemes) then
  begin
    LoadSubdivisions(TTheme(nil), AWells);
    Exit;
  end;
  Assert(Assigned(AWells));

  Stratons := TStratons.Create;
  Stratons.OwnsObjects := false;
  GatherStratons(AWells, AThemes, Stratons);
  PrepareHeader;

  for i := 0 to Stratons.Count - 1 do
  begin
    row := Rows.Add;
    cell := row.Add;
    cell.Value := Stratons.Items[i].List(loBrief);
    ss := Stratons.Items[i].Straton;
    columns[0].Add(cell);

    cell := row.Add;
    if Assigned(Stratons.Items[i].TempLink) then
      cell.Value := Stratons.Items[i].TempLink.List(loBrief);
    columns[1].Add(cell);

    iColumn := 0;

    for j := 0 to AWells.Count - 1 do
    begin
      for k := 0 to AWells.Items[j].Subdivisions.Count - 1 do
      if Assigned(AThemes.ItemsByID[AWells.Items[j].Subdivisions.Items[k].Theme.ID]) then
      begin
        PlaceSubdivisionStratonCells(AWells.Items[j].Subdivisions.Items[k], ss, row, iColumn + SECOND_STRATON_COLUMN_INDEX + 1);
        inc(iColumn, AWells.Items[j].Subdivisions.Items[k].SubdivisionComponents.BlockCount);
      end;


    end;
  end;
  AddTotalDepth(AThemes, AWells);
  FillEmpties((TMainFacade.GetInstance as TMainFacade).AllSubdivisionComments, (TMainFacade.GetInstance as TMainFacade).AllTectonicBlocks);
  FreeAndNil(Stratons);
end;

procedure TSubdivisionTable.LoadSubdivisions(AThemes: TThemes;
  AWell: TWell);
var i, j, iColumn: integer;
    Stratons: TStratons;
    ss: TSimpleStraton;
    row: TBaseTableCells;
    cell: TBaseTableCell;
begin
  if not Assigned(AThemes) then
  begin
    LoadSubdivisions(TTheme(nil), AWell);
    Exit;
  end;
  
  Stratons := TStratons.Create;
  Stratons.OwnsObjects := false;
  GatherStratons(AWell, AThemes, Stratons);
  PrepareHeader;
  for i := 0 to Stratons.Count - 1 do
  begin
    row := Rows.Add;
    cell := row.Add;
    cell.Value := Stratons.Items[i].List(loBrief);
    ss := Stratons.Items[i].Straton;
    columns[0].Add(cell);

    cell := row.Add;
    if Assigned(Stratons.Items[i].TempLink) then
      cell.Value := Stratons.Items[i].TempLink.List(loBrief);
    columns[1].Add(cell);

    iColumn := 0;
    for j := 0 to AWell.Subdivisions.Count - 1 do
    if Assigned(AThemes.ItemsByID[AWell.Subdivisions.Items[j].Theme.ID]) then
    begin
      PlaceSubdivisionStratonCells(AWell.Subdivisions.Items[j], ss, row, iColumn + SECOND_STRATON_COLUMN_INDEX + 1);
      inc(iColumn, AWell.Subdivisions.Items[j].SubdivisionComponents.BlockCount);
    end;
  end;
  AddTotalDepth(AThemes, AWell);
  FillEmpties((TMainFacade.GetInstance as TMainFacade).AllSubdivisionComments, (TMainFacade.GetInstance as TMainFacade).AllTectonicBlocks);
  FreeAndNil(Stratons);
end;

procedure TSubdivisionTable.GatherStratons(AWells: TWells;
  AThemes: TThemes; AStratons: TStratons);
var i, j: integer;
begin
  Assert(Assigned(AStratons));
  Assert(Assigned(AWells));
  Assert(Assigned(AThemes));
  for i := 0 to AWells.Count - 1 do
  for j := 0 to AThemes.Count - 1 do
    GatherStratons(AWells.Items[i], AThemes.Items[j], AStratons, false);
  AStratons.SortByAge;
end;

procedure TSubdivisionTable.AddTotalDepth(AThemes: TThemes;
  AWells: TWells);
var row: TBaseTableCells;
    iColumn, j, k, i: integer;
    cell: TBaseTableCell;
begin
  iColumn := SECOND_STRATON_COLUMN_INDEX + 1;
  row := rows.Add;
  cell := row.Add;
  StratonMainColumn.Add(cell);
  cell.Value := 'Забой';

  cell := row.Add;
  StratonSecondColumn.Add(cell);
  for j := 0 to AWells.Count - 1 do
  begin
    for k := 0 to AWells.Items[j].Subdivisions.Count - 1 do
    if Assigned(AThemes.ItemsByID[AWells.Items[j].Subdivisions.Items[k].Theme.ID]) then
    begin
      for i := 0 to AWells.Items[j].Subdivisions.Items[k].SubdivisionComponents.BlockCount - 1 do
      begin
        row.AddToIndex(iColumn + i);
        cell := row[iColumn + i];
        cell.Value := Format('%.2f', [AWells.Items[j].TrueDepth]);
        Columns.AddToIndex(iColumn + i, False);
        Columns[iColumn + i].Add(Cell);
      end;
      inc(iColumn, AWells.Items[j].Subdivisions.Items[k].SubdivisionComponents.BlockCount);
    end;
  end;
end;

procedure TSubdivisionTable.GatherStratons(AWell: TWell; AThemes: TThemes;
  AStratons: TStratons);
var i: integer;
begin
  Assert(Assigned(AStratons));
  Assert(Assigned(AWell));
  Assert(Assigned(AThemes));
  for i := 0 to AThemes.Count - 1 do
    GatherStratons(AWell, AThemes.Items[i], AStratons, false);
  AStratons.SortByAge;
end;

procedure TSubdivisionTable.AddTotalDepth(AThemes: TThemes; AWell: TWell);
var row: TBaseTableCells;
    iColumn, k, i: integer;
    cell: TBaseTableCell;
begin
  iColumn := SECOND_STRATON_COLUMN_INDEX + 1;
  row := rows.Add;
  cell := row.Add;
  StratonMainColumn.Add(cell);
  cell.Value := 'Забой';

  for k := 0 to AWell.Subdivisions.Count - 1 do
  if (Assigned(AThemes.ItemsByID[AWell.Subdivisions.Items[k].Theme.ID])) then
  begin
    for i := 0 to AWell.Subdivisions.Items[k].SubdivisionComponents.BlockCount - 1 do
    begin
      row.AddToIndex(iColumn + i);
      cell := row[iColumn + i];
      cell.Value := Format('%.2f', [AWell.TrueDepth]);
      Columns.AddToIndex(iColumn + i, False);
      Columns[iColumn + i].Add(Cell);
    end;
    inc(iColumn, AWell.Subdivisions.Items[k].SubdivisionComponents.BlockCount);
  end;
end;

procedure TSubdivisionTable.CheckHeader;
var j: Integer;
    obj: TIDObjectSearch;
begin
  for j := SECOND_STRATON_COLUMN_INDEX + 1 to ColumnCount - 1 do
  if Assigned(WellRow[j].Data) and (TObject(WellRow[j].Data) is TIDObjectSearch) then
  begin
    obj := TObject(WellRow[j].Data) as TIDObjectSearch;
    if not Assigned(obj.IDObject) then
      TableErrors.AddError(ekWellNotFound, WELL_NUMBER_ROW_INDEX, j, WellRow[j], true)
  end
  else TableErrors.AddError(ekWellNotFound, WELL_NUMBER_ROW_INDEX, j, WellRow[j], true);

  for j := SECOND_STRATON_COLUMN_INDEX + 1 to ColumnCount - 1 do
  if Assigned(TectonicBlockRow[j].Data) and (TObject(TectonicBlockRow[j].Data) is TIDObjectSearch) then
  begin
    obj := TObject(TectonicBlockRow[j].Data) as TIDObjectSearch;
    if not Assigned(obj.IDObject) then
      TableErrors.AddError(ekWellNotFound, TECTONIC_BLOCK_ROW_INDEX, j, TectonicBlockRow[j], true)
  end
  else TableErrors.AddError(ekWellNotFound, WELL_NUMBER_ROW_INDEX, j, WellRow[j], true);

end;

{ TIDObjectSearch }

constructor TIDObjectSearch.Create;
begin
  inherited;
  FAreAdditionalParametersEqual := true;
end;

{ TIntegerList }

function TIntegerList.Add(AValue: integer): integer;
begin
  Result := Inherited Add(Pointer(AValue));
end;

function TIntegerList.GetItems(const Index: integer): integer;
begin
  Result := Integer(inherited Items[Index]);
end;


{ TTableErrors }

function TTableErrors.AddError(AErrorKind: TErrorKind; ARowAddress,
  AColumnAddress: integer; ACell: TBaseTableCell;
  AIsCritical: boolean): TTableError;
begin
  Result := TTableError.Create;
  inherited Add(Result);

  Result.IsCritical := AIsCritical;
  Result.ErrorKind := AErrorKind;
  Result.RowAddress := ARowAddress;
  Result.ColumnAddress := AColumnAddress;
  Result.Cell := ACell;
end;

constructor TTableErrors.Create;
begin
  inherited Create(true);
end;

function TTableErrors.CriticalErrorCount: integer;
var i: integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
    Result := Result + ord(Items[i].ErrorKind in [ekStratonNotFound, ekTectonicBlockNotFound, ekWellNotFound, ekNoRsingDepths, ekNoNumberDepths]);
end;

procedure TTableErrors.DeleteErrorsByKind(AErrorKind: TErrorKind);
var i: integer;
begin
  for i := Count - 1 downto 0 do
  if Items[i].ErrorKind = AErrorKind then
  begin
    Delete(i);
  end;
end;

procedure TTableErrors.DeleteErrorsByKinds(AErrorKinds: TErrorKinds);
var i: integer;
begin
  for i := Count - 1 downto 0 do
  if Items[i].ErrorKind in AErrorKinds then
  begin
    Delete(i);
  end;
end;

function TTableErrors.GetErrorByCellAddress(ARow,
  ACol: integer; const ColOrRowOk: boolean = false): TTableError;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if ((Items[i].ColumnAddress = ACol) and (Items[i].RowAddress = ARow)) then
  begin
    Result := Items[i];
    break;
  end;

  if (not Assigned(Result)) and ColOrRowOk then
  for i := 0 to Count - 1 do
  if ((Items[i].ColumnAddress = ACol) or (Items[i].RowAddress = ARow)) then
  begin
    Result := Items[i];
    break;
  end;
end;

function TTableErrors.GetItems(const Index: integer): TTableError;
begin
  Result := inherited Items[Index] as TTableError;
end;

procedure TTableErrors.SortByColumn;
begin
  Sort(CompareTableErrorsColumn);
end;

procedure TTableErrors.SortByDescription;
begin
  Sort(CompareTableErrorsDescription);
end;

procedure TTableErrors.SortByRow;
begin
  Sort(CompareTableErrorsRow);
end;

{ TTableError }

function TTableError.GetDescription: string;
begin
  case ErrorKind of
  ekStratonNotFound: Result := 'Стратон не найден';
  ekTectonicBlockNotFound: Result := 'Тектонический блок не найден';
  ekWellNotFound: Result := 'Скважина не найдена';
  ekNoRsingDepths: Result := 'Последовательность глубин не возрастает';
  ekNoNumberDepths: Result := 'Нечисловая глубина';
  ekInconsistentSubdivision: Result := 'Разбивка не полная';
  ekNoAltitude: Result := 'Не указана альтитуда';
  ekNoTotalDepth: Result := 'Не указан забой';
  ekEmptyTableRow: Result := 'Пустая строка';
  ekCommentNotAllowed: Result := 'Неверный комментарий';
  end;
end;

end.






