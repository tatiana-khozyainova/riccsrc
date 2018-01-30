unit CommonReport;

interface

uses Classes, Contnrs, CommonStepForm, Variants, ComObj, BaseObjects, ActnList, SysUtils;

type
  EReportQueryBuildingError = Exception;
  TBaseReport = class;

  TReportStepProc = procedure (AReport: TBaseReport) of object;

  TReportStep = class
  private
    FName: string;
    FReportStepProc: TReportStepProc;
  public
    property Name: string read FName write FName;
    property Proc: TReportStepProc read FReportStepProc write FReportStepProc;
  end;

  TReportSteps = class(TObjectList)
  private
    function GetItems(Index: integer): TReportStep;
  public
    property    Items[Index: integer]: TReportStep read GetItems; default;
    procedure   AddStep(AName: string; AProc: TReportStepProc);
    constructor Create;
  end;


  TReplacementRange = class
  private
    FLeft: integer;
    FTop: integer;
    FRight: integer;
    FBottom: integer;
    FReplacementText: string;
    FText: string;
  public
    property Top: integer read FTop write FTop;
    property Left: integer read FLeft write FLeft;
    property Bottom: integer read FBottom write FBottom;
    property Right: integer read FRight write FRight;

    property Text: string read FText write FText;
    property ReplacementText: string read FReplacementText write FReplacementText;
  end;

  TReplacementRanges = class(TObjectList)
  private
    function GetItems(Index: Integer): TReplacementRange;
  public
    property Items[Index: Integer]: TReplacementRange read GetItems;
    function AddReplacementColumn(AColumn, AColumnTop: integer; AText, AReplacementText: string): TReplacementRange;
    function AddReplacementRow(ARow, ARowLeft: Integer; AText, AReplacementText: string): TReplacementRange;
    function AddReplacementRange(ATop, ALeft, ABottom, ARight: integer; AText, AReplacementText: string): TReplacementRange;


    constructor Create;
  end;

  TColumnGroup = class(TObjectList)
  private
    FName: string;
    function GetItems(Index: integer): Integer;
  public
    property Name: string read FName write FName;
    property Items[Index: integer]: Integer read GetItems;
    function Add(ACol: Integer): integer;
    procedure AddRange(AStart, AFin: integer);
    constructor Create; 
  end;

  TColumnGroups = class(TObjectList)
  private
    function GetItems(const Index: integer): TColumnGroup;
  public
    property Items[const Index: integer]: TColumnGroup read GetItems;
    function Add(const AName: string): TColumnGroup;
    function GetGroupByColumn(AColumn: Integer): TColumnGroup;
    constructor Create;  
  end;

  TAutoNumber = (anColumns, anRows);
  TAutoNumbers = set of TAutoNumber;

  TBaseReport = class(TComponent)
  private
    FReportSteps: TReportSteps;
    FSilentMode: boolean;
    FNeedsExcel: boolean;
    FReportingObjects: TIDObjects;
    FSaveReport: boolean;
    FReportSavePath: string;
    FMakeVisible: boolean;
    FReportName: string;
    FRemoveEmptyCols: boolean;
    FAutoNumber: TAutoNumbers;
    FAutoNumberColumn: Integer;
    FMakeReplacements: boolean;
    FReplacements: TReplacementRanges;
    FDrawBorders: boolean;
    FAutoNumberRow: integer;
    FColumnGroups: TColumnGroups;
    FAllObjects: TIDObjects;
    FAutofitRows: boolean;
    FAdjustPrintArea: Boolean;
    FOnMoveData: TNotifyEvent;
    FEmptyReportingObjects: boolean;
    FUseAllReportingObjectsAsOne: boolean;
    function GetReplacements: TReplacementRanges;
    function GetColumnGroups: TColumnGroups;
  protected
    FStepForm: TfrmStep;
    FExcel: OleVariant;
    FXLWorkBook: OleVariant;
    FXLWorksheet: OleVariant;
    FFirstColIndex: integer;
    FLastRowIndex: integer;
    FLastColIndex: integer;
    FFirstRowIndex: Integer;

    procedure InternalOpenTemplate; virtual;
    procedure InternalMoveData; virtual;
    procedure PostFormat; virtual;
    procedure InternalShowReport; virtual;
    procedure SaveReportAs;
    function  GetReportFileName: string; virtual;
    procedure DoAutoNumberRows(); virtual;
    procedure DoAutoNumberColumns(); virtual;
    procedure DoRemoveEmptyCols(); virtual;
    procedure DoMakeReplacements(); virtual;
    procedure DoAutoFitRows(); virtual;
    procedure DoAdjustPrintArea(); virtual;
    procedure DrawBorder(); virtual;
    function  IsEmpty(AColIndex: Integer; UseColumnGroups: boolean = true): Boolean;
    procedure  CopyRange(ASheetName: string; ATop: integer; ALeft: Integer; ARight: Integer; ABottom, ADestTop, ADestLeft: Integer);
  public
    procedure OpenTemplate(AReport: TBaseReport);
    procedure MoveData(AReport: TBaseReport);
    procedure ShowReport(AReport: TbaseReport);
    procedure PrepareReport; virtual;

    property    EmptyReportingObjects: boolean read FEmptyReportingObjects write FEmptyReportingObjects;
    property    ReportingObjects: TIDObjects read FReportingObjects;
    property    UseAllReportingObjectsAsOne: boolean read FUseAllReportingObjectsAsOne write FUseAllReportingObjectsAsOne;
    property    AllObjects: TIDObjects read FAllObjects;

    property    NeedsExcel: boolean read FNeedsExcel write FNeedsExcel;
    property    SilentMode: boolean read FSilentMode write FSilentMode;
    property    SaveReport: boolean read FSaveReport write FSaveReport;
    property    MakeVisible: boolean read FMakeVisible write FMakeVisible;
    property    AutoNumber: TAutoNumbers read FAutoNumber write FAutoNumber;
    property    RemoveEmptyCols: boolean read FRemoveEmptyCols write FRemoveEmptyCols;
    property    MakeReplacements: boolean read FMakeReplacements write FMakeReplacements;
    property    DrawBorders: boolean read FDrawBorders write FDrawBorders;
    property    AutofitRows: boolean read FAutofitRows write FAutofitRows;
    property    AdjustPrintArea: Boolean read FAdjustPrintArea write FAdjustPrintArea;

    property    AutonumberColumn: Integer read FAutoNumberColumn write FAutoNumberColumn;
    property    AutonumberRow: integer read FAutoNumberRow write FAutoNumberRow;

    property    ReportPath: string read FReportSavePath write FReportSavePath;
    property    ReportName: string read FReportName write FReportName;
    property    ReportFileName: string read GetReportFileName;

    property    OnMoveData: TNotifyEvent read FOnMoveData write FOnMoveData;

    // положение на странице
    property FirstRowIndex: Integer read FFirstRowIndex write FFirstRowIndex;
    property LastRowIndex: integer read FLastRowIndex write FLastRowIndex;

    property FirstColIndex: integer read FFirstColIndex write FFirstColIndex;
    property LastColIndex: integer read FLastColIndex write FLastColIndex;

    // замены
    property Replacements: TReplacementRanges read GetReplacements;
    // группы колонок
    property ColumnGroups: TColumnGroups read GetColumnGroups;


    property    ReportSteps: TReportSteps read FReportSteps;
    procedure   Execute(); overload; virtual;
    procedure   Execute(DoOnExec: TNotifyEvent); overload; virtual;
    procedure   ShowDetails(AMasterObject: TIDObject); virtual;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

  TBaseSQLReport = class(TBaseReport)
  private
    FSQL: string;
  protected
    procedure InternalMoveData; override;
  public
    property SQL: string read FSQL write FSQL;
  end;

  TBaseReportClass = class of TBaseReport;

  TBaseReports = class(TComponentList)
  private
    FOwner: TComponent;
    function GetItems(const Index: integer): TBaseReport;
    function GetReportByClassType(
      AClassType: TBaseReportClass): TBaseReport;
  public
    property Owner: TComponent read FOwner;
    property ReportByClassType[AClassType: TBaseReportClass]: TBaseReport read GetReportByClassType;
    property Items[const Index: integer]: TBaseReport read GetItems;
    constructor Create(AOwner: TComponent);
  end;

implementation

uses Windows, Dialogs, StrUtils;

{ TReportSteps }

procedure TReportSteps.AddStep(AName: string; AProc: TReportStepProc);
var s: TReportStep;
begin
  s := TReportStep.Create;
  s.Name := AName;
  s.Proc := AProc;

  Add(s);
end;

constructor TReportSteps.Create;
begin
  inherited Create(true);
end;

function TReportSteps.GetItems(Index: integer): TReportStep;
begin
  Result := inherited Items[Index] as TReportStep;
end;

{ TBaseReport }

procedure TBaseReport.CopyRange(ASheetName: string; ATop, ALeft, ARight,
  ABottom, ADestTop, ADestLeft: Integer);
var FSourceWorkSheet: OleVariant;
    Cell1, Cell2, Range1, Range2: OleVariant;
begin
  FSourceWorksheet := FExcel.ActiveWorkbook.Sheets.Item[ASheetName];
  Cell1 := FSourceWorksheet.Cells.Item[ATop, ALeft];
  Cell2 := FSourceWorksheet.Cells.Item[ABottom, ARight];
  Range1 := FSourceWorksheet.Range[Cell1,Cell2];


  Cell1 := FXLWorksheet.Cells.Item[ADestTop, ADestLeft];
  Cell2 := FXLWorksheet.Cells.Item[ADestTop + ABottom - ATop, ADestLeft + ARight - ALeft];
  Range2 := FXLWorksheet.Range[Cell1,Cell2];
  Range1.Copy(Range2);
end;

constructor TBaseReport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FReportSteps := TReportSteps.Create;
  FNeedsExcel := false;
  FReportingObjects := TIDObjects.Create();
  FReportingObjects.OwnsObjects := false;

  FAllObjects := TIDObjects.Create();
  FAllObjects.OwnsObjects := false;

  FAutoNumberColumn := 1;
  FAutoNumberRow := 2;
  MakeReplacements := true;
  MakeVisible := true;
  AutofitRows := true;
  AdjustPrintArea := True;

  ReportSteps.AddStep('Открываем шаблон отчета', OpenTemplate);
  ReportSteps.AddStep('Экспортируем данные', MoveData);
  ReportSteps.AddStep('Показываем отчет', ShowReport);
end;

destructor TBaseReport.Destroy;
begin
  FReportingObjects.Free;
  FAllObjects.Free;
  FReportSteps.Free;
  FReplacements.Free;
  FColumnGroups.Free;
  if not varIsNull(FExcel) then FExcel := null;
  inherited;
end;

procedure TBaseReport.DoAdjustPrintArea;
var Cell1, Cell2, Range: OleVariant;
begin
  if (FirstRowIndex > 0) and (FirstColIndex > 0) then
  begin
    Cell1 := FXLWorksheet.Cells.Item[1, FirstColIndex];
    Cell2 := FXLWorksheet.Cells.Item[LastRowIndex, LastColIndex];
    Range := FXLWorksheet.Range[Cell1,Cell2];
    FXLWorksheet.PageSetup.PrintArea := Range.Address;
  end;
end;

procedure TBaseReport.DoAutoFitRows;
var Cell1, Cell2, Range: OleVariant;
begin
  if (FirstRowIndex > 0) and (FirstColIndex > 0) then
  begin
    Cell1 := FXLWorksheet.Cells.Item[FirstRowIndex, FirstColIndex];
    Cell2 := FXLWorksheet.Cells.Item[LastRowIndex, LastColIndex];
    Range := FXLWorksheet.Range[Cell1,Cell2];
    Range.Rows.AutoFit;
  end;
end;

procedure TBaseReport.DoAutoNumberColumns;
var i, iNum: integer;
begin
  iNum := 1;
  for i := FirstColIndex to LastColIndex  do
  begin
    FXLWorksheet.Cells.Item[AutonumberRow, i].Value := iNum;
    iNum := iNum + 1;
  end;
end;

procedure TBaseReport.DoAutoNumberRows;
var i, iNum: integer;
begin
  iNum := 1;
  for i := FirstRowIndex to LastRowIndex  do
  begin
    FXLWorksheet.Cells.Item[i, AutonumberColumn].Value := iNum;
    iNum := iNum + 1;
  end;
end;

procedure TBaseReport.DoMakeReplacements;
var i, iRight, iBottom: integer;
    Range, Cell1, Cell2: OleVariant;
begin
  for i := 0 to Replacements.Count - 1 do
  begin
    Cell1 := FXLWorksheet.Cells.Item[Replacements.Items[i].Top, Replacements.Items[i].Left];
    iRight := LastColIndex;
    iBottom := LastRowIndex;

    if Replacements.Items[i].Bottom < iBottom then iBottom := Replacements.Items[i].Bottom;
    if Replacements.Items[i].Right < iRight then iRight := Replacements.Items[i].Right;

    Cell2 := FXLWorksheet.Cells.Item[iBottom, iRight];
    Range := FXLWorksheet.Range[Cell1,Cell2];
    Range.Select;


    //Find := Range.Find(Replacements.Items[i].Text, Cell1, -4123, 2, 1, 1, False, False);
    //if not (VarIsNull(Find) or VarIsEmpty(Find) or VarIsClear(Find)) then
    try
      Range.Replace(Replacements.Items[i].Text, Replacements.Items[i].ReplacementText);
    except

    end;
  end;
end;

procedure TBaseReport.DoRemoveEmptyCols;
var i: integer;
    cg: TColumnGroup;
begin
  for i := LastColIndex downto FirstColIndex do
  if IsEmpty(i) then
  begin
    FXLWorksheet.Columns.Item[i].Delete();
    cg := ColumnGroups.GetGroupByColumn(i);
    if Assigned(cg) then cg.Remove(TObject(i));

    LastColIndex := LastColIndex - 1;
  end;

end;

procedure TBaseReport.DrawBorder;
var Cell1, Cell2, Range: OleVariant;
    i: Integer;
begin
  Cell1 := FXLWorksheet.Cells.Item[FirstRowIndex, FirstColIndex];
  Cell2 := FXLWorksheet.Cells.Item[LastRowIndex, LastColIndex];
  Range := FXLWorksheet.Range[Cell1,Cell2];

  for  i :=  7 to 12 do
    Range.Borders.Item[i].LineStyle := 1;
end;

procedure TBaseReport.Execute;
var i: integer;
begin
  if (ReportingObjects.Count = 0) and (not EmptyReportingObjects) then
  begin
    ShowMessage('Не указаны исходные данные для формирования отчета');
    Exit;
  end;

  if NeedsExcel and varIsEmpty(FExcel) then FExcel := CreateOleObject('Excel.Application');

  if not MakeVisible then FExcel.Visible := false;

  
  FExcel.Visible := false;
  FExcel.Application.EnableEvents := false;
  FExcel.Application.ScreenUpdating := false;

  {$IFDEF D+}
  FExcel.Visible := true;
  FExcel.Application.EnableEvents := true;
  FExcel.Application.ScreenUpdating := true;
  {$ENDIF}

  if not SilentMode then
  begin
    try
      FStepForm.Free;
    finally
      FStepForm := nil;
    end;

    FStepForm := TfrmStep.Create(Self);
    FStepForm.ShowLog := false;
    FStepForm.InitProgress(0, FReportSteps.Count - 1, 1);
    FStepForm.Show;
  end;

  for i := 0 to FReportSteps.Count - 1 do
  begin
    if not SilentMode then FStepForm.MakeStep(FReportSteps.Items[i].Name);
    FReportSteps.Items[i].Proc(Self);
  end;


  if not SilentMode then
  begin
    FStepForm.Close;
    FStepForm.Free;
    FStepForm := nil;
  end;

  if SaveReport then SaveReportAs;

  if not MakeVisible then
  begin
    try
      if not FXLWorkBook.Saved then
        FXLWorkBook.Close(true, ReportPath + '\' + ReportFileName)
      else
        FXLWorkBook.Close();
    except
      FExcel.Visible := true;
    end
  end;
  FExcel.Application.EnableEvents := true;
  FExcel.Application.ScreenUpdating := true;
end;

procedure TBaseReport.Execute(DoOnExec: TNotifyEvent);
begin
  FOnMoveData := DoOnExec;
  Execute;
end;

function TBaseReport.GetColumnGroups: TColumnGroups;
begin
  if not Assigned(FColumnGroups) then
    FColumnGroups := TColumnGroups.Create;

  Result := FColumnGroups;
end;

function TBaseReport.GetReplacements: TReplacementRanges;
begin
  if not Assigned(FReplacements) then
    FReplacements := TReplacementRanges.Create;

  Result := FReplacements;
end;

function TBaseReport.GetReportFileName: string;
begin
  Result := StringReplace(StringReplace(ReportingObjects.List(loBrief) + '.xls', ',', '_', [rfReplaceAll]), ';', '_', [rfReplaceAll]);
  Result := StringReplace(Result, '/', '', [rfReplaceAll]);
  Result := StringReplace(Result, '\', '', [rfReplaceAll]);
  Result := StringReplace(Result, ' ', '', [rfReplaceAll]);

  if trim(ReportName) <> '' then Result := ReportName + '_' + Result;

  Result := trim(Result);
end;

procedure TBaseReport.InternalMoveData;
begin
  if ((ReportingObjects.Count > 0) or EmptyReportingObjects) then PrepareReport;
end;

procedure TBaseReport.InternalOpenTemplate;
begin
end;

procedure TBaseReport.InternalShowReport;
begin
  PostFormat;
  if MakeVisible then FExcel.Visible := true;
end;

function TBaseReport.IsEmpty(AColIndex: Integer; UseColumnGroups: boolean = true): Boolean;
var i: Integer;
    cg: TColumnGroup;
    s: string;
begin
  cg := nil;
  if UseColumnGroups then
    cg := ColumnGroups.GetGroupByColumn(AColIndex);

  if not Assigned(cg) then
  begin
    Result := true;
    for i := FirstRowIndex to LastRowIndex  do
    if not (VarIsEmpty(FXLWorksheet.Cells.Item[i, AColIndex].Value) or VarIsNull(FXLWorksheet.Cells.Item[i, AColIndex].Value)) then
    begin
      s := FXLWorksheet.Cells.Item[i, AColIndex].Value;
      if trim(s) <> '' then
      begin
        Result := false;
        Break;
      end;
    end;
  end
  else
  begin
    Result := true;
    for i :=  cg.Count - 1 downto 0 do
    begin
      Result := Result and IsEmpty(cg.Items[i], false);
      if not Result then break;
    end;
  end;
end;

procedure TBaseReport.MoveData(AReport: TBaseReport);
begin
  InternalMoveData;
end;

procedure TBaseReport.OpenTemplate(AReport: TBaseReport);
begin
  InternalOpenTemplate;
end;



procedure TBaseReport.PostFormat;
begin
  try

    if (anRows in AutoNumber) then DoAutoNumberRows;
    if MakeReplacements then DoMakeReplacements;
    if DrawBorders then DrawBorder;
    if RemoveEmptyCols then DoRemoveEmptyCols;
    if (anColumns in AutoNumber) then DoAutoNumberColumns;
    if AutofitRows then DoAutoFitRows;
    if AdjustPrintArea  then DoAdjustPrintArea;
  except

  end;
end;

procedure TBaseReport.PrepareReport;
begin

end;

procedure TBaseReport.SaveReportAs;
var sReportFileName: string;
begin
  if SaveReport and (trim(ReportPath) <> '') and (trim(ReportFileName) <> '') then
  begin
    try
      sReportFileName := copy(ReportFileName, 1, 100);
      if Trim(FExcel.Version) = '12' then
        FXLWorkBook.SaveAs(VarAsType(ReportPath + '\' + sReportFileName, varOleStr), 56)
      else
        FXLWorkBook.SaveAs(VarAsType(ReportPath + '\' + sReportFileName, varOleStr));

      FXLWorkBook.Saved := True;
    except
      on E:Exception do
      begin
        ShowMessage(e.Message);
        FXLWorkBook.Saved := false;
      end;
    end;
  end;
end;
                                                  
procedure TBaseReport.ShowDetails;
begin

end;

procedure TBaseReport.ShowReport(AReport: TbaseReport);
begin
  InternalShowReport;
end;

{ TBaseReports }

constructor TBaseReports.Create(AOwner: TComponent);
begin
  inherited Create(true);
  FOwner := AOwner;
end;

function TBaseReports.GetItems(const Index: integer): TBaseReport;
begin
  Result := inherited Items[Index] as TBaseReport;
end;

function TBaseReports.GetReportByClassType(
  AClassType: TBaseReportClass): TBaseReport;
var i: integer;
begin
  Result := nil;

  for i := 0 to Count - 1 do
  if Items[i].ClassType = AClassType then
  begin
    Result := Items[i];
    break;
  end;


  if not Assigned(Result) then
  begin
    Result := AClassType.Create(Owner);
    Add(Result);
  end;
end;


{ TBaseSQLReport }

procedure TBaseSQLReport.InternalMoveData;
begin
  inherited;

end;

{ TReplacementRanges }

function TReplacementRanges.AddReplacementColumn(AColumn,
  AColumnTop: integer; AText, AReplacementText: string): TReplacementRange;
begin
  Result := AddReplacementRange(AColumnTop, AColumn, 100000, AColumn, AText, AReplacementText);
end;

function TReplacementRanges.AddReplacementRange(ATop, ALeft, ABottom,
  ARight: integer; AText, AReplacementText: string): TReplacementRange;
begin
  Result := TReplacementRange.Create;
  with Result do
  begin
    Top := ATop;
    Left := ALeft;
    Right := ARight;
    Bottom := ABottom;

    Text := AText;
    ReplacementText := AReplacementText;
  end;

  inherited Add(Result);
end;

function TReplacementRanges.AddReplacementRow(ARow, ARowLeft: Integer;
  AText, AReplacementText: string): TReplacementRange;
begin
  Result := AddReplacementRange(ARow, ARowLeft, ARow, 100000, AText, AReplacementText);
end;

constructor TReplacementRanges.Create;
begin
  inherited Create(true);
end;

function TReplacementRanges.GetItems(Index: Integer): TReplacementRange;
begin
  Result := inherited Items[Index] as TReplacementRange;
end;

{ TColumnGroup }

function TColumnGroup.Add(ACol: Integer): integer;
begin
  Result := inherited Add(TObject(ACol));
end;

procedure TColumnGroup.AddRange(AStart, AFin: integer);
var i: integer;
begin
  for i := AStart to AFin do
    Add(i);
end;

constructor TColumnGroup.Create;
begin
  inherited Create(False);
end;

function TColumnGroup.GetItems(Index: integer): Integer;
begin
  Result := Integer(inherited Items[Index]);
end;

{ TColumnGroups }

function TColumnGroups.Add(const AName: string): TColumnGroup;
begin
  Result := TColumnGroup.Create;
  inherited Add(Result);
end;

constructor TColumnGroups.Create;
begin
  inherited Create(True);
end;

function TColumnGroups.GetGroupByColumn(AColumn: Integer): TColumnGroup;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  begin
    if Items[i].IndexOf(TObject(AColumn)) > -1 then
    begin
      Result := Items[i];
      break;
    end;
  end;
end;

function TColumnGroups.GetItems(const Index: integer): TColumnGroup;
begin
  Result := inherited Items[Index] as TColumnGroup;
end;

end.
