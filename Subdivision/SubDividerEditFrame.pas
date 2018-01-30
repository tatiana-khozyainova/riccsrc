unit SubDividerEditFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, SubDividerCommonObjects,
  ExtCtrls, StdCtrls, Grids, Buttons, Menus, ImgList, ComCtrls, ToolWin,
  SubDividerComponentEditFrame, ActnList, Contnrs, Variants;

//const
//  WM_SELECTION_CHANGED = WM_APP + 131;

type
  TQuickEdition = class;
  TDecompositionResult = class;
  TDecompositionResults = class;

  {TEditingWell = class(TWell)
  private
    FRow: integer;
    procedure SetRow(const Value: integer);
  public
    property Row: integer read FRow write SetRow;
  end;

  TEditingSubDivision = class(TSubDivision)
  private
    FRow: integer;
    procedure SetRow(const Value: integer);
  public
    property Row: integer read FRow write SetRow;
  end;

  TEditingSubDivisionComponent = class(TSubDivisionComponent)
  private
    FCol, FRow: integer;
    procedure SetRow(const Value: integer);
    procedure SetCol(const Value: integer);
  public
    property Row: integer read FRow write SetRow;
    property Col: integer read FCol write SetCol;
  end;}

  TElement = class
  private
    FPlace: integer;
    FNewPlace: integer;
  public
    property Place: integer read FPlace write FPlace;
    property NewPlace: integer read FNewPlace write FNewPlace;
  end;

  PElement = ^TElement;

  TElements = class(TObjectList)
  private
    function  GetElement(const Index: integer): TElement;
  public
    property   Elements[const Index: integer]: TElement read GetElement;
    procedure  AddElement(const APlace, ANewPlace: integer);
    procedure  SortElements;
    procedure  SaveToFile;
    constructor Create; reintroduce;
    destructor Destroy; override;
  end;

  TButtonAppearance = record
    Caption: string;
    Hint: string;
    ImageIndex: integer;
  end;


  TfrmEditSubDivision = class(TFrame)
    Panel1: TPanel;
    pnlButtons: TPanel;
    gbxSubDivision: TGroupBox;
    sgrSubDivision: TStringGrid;
    tlbr: TToolBar;
    tlbtnWell: TToolButton;
    imgLst: TImageList;
    tlbtnTectonicBlock: TToolButton;
    pmnTectBlock: TPopupMenu;
    pmnWell: TPopupMenu;
    pmiAddTectBlock: TMenuItem;
    pmiDeleteTectonicBlock: TMenuItem;
    pmiAddWell: TMenuItem;
    pmiEditWell: TMenuItem;
    pmiDeleteWell: TMenuItem;
    pmiEditTectBlock: TMenuItem;
    tlbtnEdge: TToolButton;
    pmnEdge: TPopupMenu;
    pmiAddEdge: TMenuItem;
    pmiDeleteEdge: TMenuItem;
    actnLst: TActionList;
    AddWell: TAction;
    EditWell: TAction;
    DeleteWell: TAction;
    AddTectBlock: TAction;
    EditTectBlock: TAction;
    DeleteTectBlock: TAction;
    AddEdge: TAction;
    EditEdge: TAction;
    DeleteEdge: TAction;
    N1: TMenuItem;
    pnl: TPanel;
    sbtnReload: TSpeedButton;
    sbtnChangeOrder: TSpeedButton;
    sbtnVisibility: TSpeedButton;
    sbtnStratonFilter: TSpeedButton;
    pmnMain: TPopupMenu;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    frmSubComponentEdit1: TfrmSubComponentEdit;
    pnlQuickEditButtons: TPanel;
    tlbrQuickEdit: TToolBar;
    tlbtnNoData: TToolButton;
    tlbtnNotDivided: TToolButton;
    tlbtnDefault: TToolButton;
    tlbtnDelete: TToolButton;
    tlbtnEditUnverified: TToolButton;
    tlbtnEditVerified: TToolButton;
    procedure cmbxCommentChange(Sender: TObject);
    procedure sbtnDeleteWellClick(Sender: TObject);
    procedure sgrSubDivisionSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure AddWellExecute(Sender: TObject);
    procedure EditWellExecute(Sender: TObject);
    procedure DeleteWellExecute(Sender: TObject);
    procedure AddTectBlockExecute(Sender: TObject);
    procedure EditTectBlockExecute(Sender: TObject);
    procedure DeleteTectBlockExecute(Sender: TObject);
    procedure AddEdgeExecute(Sender: TObject);
    procedure EditEdgeExecute(Sender: TObject);
    procedure DeleteEdgeExecute(Sender: TObject);
    procedure AddEdgeUpdate(Sender: TObject);
    procedure EditEdgeUpdate(Sender: TObject);
    procedure DeleteEdgeUpdate(Sender: TObject);
    procedure EditWellUpdate(Sender: TObject);
    procedure DeleteWellUpdate(Sender: TObject);
    procedure AddTectBlockUpdate(Sender: TObject);
    procedure EditTectBlockUpdate(Sender: TObject);
    procedure DeleteTectBlockUpdate(Sender: TObject);
    procedure sgrSubDivisionMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure sbtnReloadClick(Sender: TObject);
    procedure sgrSubDivisionDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure actnLstUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure tlbtnNoDataClick(Sender: TObject);
    procedure tlbtnDefaultClick(Sender: TObject);
    procedure tlbtnNotDividedClick(Sender: TObject);
    procedure tlbtnDeleteClick(Sender: TObject);
    procedure sgrSubDivisionKeyPress(Sender: TObject; var Key: Char);
    procedure sgrSubDivisionMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure tlbtnEditUnverifiedClick(Sender: TObject);
    procedure tlbtnEditVerifiedClick(Sender: TObject);
  private
    { Private declarations }
    CCol, CRow: integer;
    FWells: TWells;
    FReadOnly, FChanged: boolean;
    FCurrentWell: TWell;
    FCurrentSubDivision: TSubDivision;
    FCurrentComponent: TSubDivisionComponent;
    Appearance: array [1 .. 3] of TButtonAppearance;
    Empty: boolean;
    FQuickEdition: TQuickEdition;
    FReportFormat: boolean;
    FDecompositionResults: TDecompositionResults;
    FShowProgress: boolean;
    procedure SetCurrentWell(Value: TWell);
    procedure SetCurrentSubDivision(value: TSubdivision);
    procedure SetCurrentComponent(Value: TSubdivisionComponent);
    procedure ExchangeRows(iFirst, iSecond: integer);
    procedure SetAppearance(AToolButton: TToolButton);
    procedure SortByAges(var ARow: integer);
    procedure NewWell(AWell: TWell);
    procedure GatherHierarchical;
    //function  WellExists(Source: TWells; AWell: TWell): boolean;
    procedure SetWells(Value: TWells);
    procedure SetReadOnly(const Value: boolean);
    procedure ClearCell(const ACol, ARow: integer);
    function  GetRow(AStratons: TStratons; const ADivider: string): integer;
    procedure ValidateToolButton(AToolButton: TToolButton; AAction: TAction);
    function  GetWellColumn(AWell: TWell): integer;
    function  GetFilledColumns(ARow: integer): integer;
    procedure NameRow(ARow: integer; AStratons: TStratons; const ADivider: string);
    procedure RemoveDubles;
    procedure FillEmpties;
    function  GetReport(IncludeLayers: boolean): OleVariant;
    function  GetSimpleReport: OleVariant;
    function  GetLayersReport: OleVariant;
    procedure RemoveRepeated;
    procedure SetReportFormat(const Value: boolean);
  public
    { Public declarations }
    property    ChangesMade: boolean read FChanged write FChanged;
    property    CurrentWell: TWell read FCurrentWell write SetCurrentWell;
    property    CurrentSubDivision: TSubDivision read FCurrentSubDivision write SetCurrentSubdivision;
    property    CurrentComponent: TSubDivisionComponent read FCurrentComponent write SetCurrentComponent;
    property    Report[IncludeLayers: boolean]: OleVariant read GetReport;
    property    Wells: TWells read FWells write SetWells;
    property    ReadOnly: boolean read FReadOnly write SetReadOnly;
    property    ReportFormat: boolean read FReportFormat write SetReportFormat;
    property    DecompositionResults: TDecompositionResults read FDecompositionResults;
    property    ShowProgress: boolean read FShowProgress write FShowProgress;

    procedure   ClearAll;
    procedure   MakeReport;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

  TQuickEditionType = (qeNone, qeNoData, qeNotDivided, qeDelete, qeNotVerified, qeVerified);

  TQuickEdition = class
  private
    FQuickEditionType: TQuickEditionType;
    FEditingComponent: TSubDivisionComponent;
    FRow: integer;
    FCol: integer;
    FGrid: TStringGrid;
    FSelection: TGridRect;
    procedure EditDelete;
    procedure EditNoData;
    procedure EditNotDivided;
    procedure EditNotVerified;
    procedure EditVerified;
  public
    property EditionType: TQuickEditionType read FQuickEditionType write FQuickEditionType;
    property EditingComponent: TSubDivisionComponent read FEditingComponent write FEditingComponent;
    property Col: integer read FCol;
    property Row: integer read FRow;
    property Selection: TGridRect read FSelection;
    property Grid: TStringGrid read FGrid;
    constructor Create(AGrid: TStringGrid);
    procedure Perform(ASubdivision: TSubdivision; const ACol, ARow: integer); overload;
    procedure Perform(ASubdivision: TSubdivision; const ASelection: TGridRect); overload;
  end;


  TDecompositionResult = class
  private
    FParentStratons: TStratons;
    FChildStratons: TStratons;
    FExcludedStratons: TStratons;
  public
    property ParentStratons: TStratons read FParentStratons;
    property ChildStratons: TStratons read FChildStratons;
    property ExcludedStratons: TStratons read FExcludedStratons;


    constructor Create(AParentStratons, AChildStratons, AExcludedStratons: TStratons);
  end;

  TDecompositionResults = class(TObjectList)
  private
    function GetItems(Index: integer): TDecompositionResult;
  public
    function  Add(AParentStratons, AChildStratons, AExcludedStratons: TStratons): TDecompositionResult;
    property  Items[Index: integer]: TDecompositionResult read GetItems;
    function  ItemByParentStraton(AParentStratons: TStratons): TDecompositionResult;
    constructor Create;
  end;

const crSpecialCursor = 112;

implementation

uses SubDividerCommon, SubDividerWellConfirm, SubDividerEditForm, SubDividerTectonicBlockForm,
  SubDividerProgressForm;




{$R *.DFM}

function Compare(Item1, Item2: Pointer): Integer;
var E1, E2: TElement;
begin
  Result := 0;
  E1 := TElement(Item1);
  E2 := TElement(Item2);
  if E1.NewPlace > E2.NewPlace then Result := 1
  else if E1.NewPlace < E2.NewPlace then Result := -1
  else if (E1.NewPlace = E2.NewPlace) then
       if (E1.Place > E2.Place) then result := 1
       else if (E1.Place < E2.Place) then result := -1
end;

// сократить название площади
function GetBriefAreaName(AAreaName: string; SymbolCount: integer): string;
var i: integer;
    vowels: set of char;
    s: string;
begin
  if (pos('верхне', AnsiLowerCase(AAreaName)) > 0) or
     (pos('средне', AnsiLowerCase(AAreaName)) > 0) or
     (pos('нижне',  AnsiLowerCase(AAreaName)) > 0) then SymbolCount := SymbolCount + 3;

  vowels := ['у', 'е', 'ы', 'а', 'о', 'э', 'и'];
  AAreaName := StringReplace(AAreaName, '(- ое)', '', [rfIgnoreCase]);
  AAreaName := StringReplace(AAreaName, '(-ое)', '', [rfIgnoreCase]);
  AAreaName := StringReplace(AAreaName, '(ое)', '', [rfIgnoreCase]);
  AAreaName := StringReplace(AAreaName, '-ое', '', [rfIgnoreCase]);
  
  i := pos('-', AAreaName);

  if i = 0 then
  begin
    Result := copy(AAreaName, 1, SymbolCount);
    i := SymbolCount + 1;
  end
  else
  begin
    Result := copy(AAreaName, 1, 1) + '. '  + copy (AAreaName, i + 1, SymbolCount);
    i := i + SymbolCount + 1;
  end;


  S := LowerCase(Result[Length(Result)]);
  if (S[1] in vowels) and (i <= Length(AAreaName)) then Result := Result + copy(AAreaName, i, 1) + '.'
  else Result := Result + '.';
  
end;


function  TElements.GetElement(const Index: integer): TElement;
begin
  Result := TElement(Items[Index]);
end;

procedure  TElements.AddElement(const APlace, ANewPlace: integer);
var e: TElement;
begin
  e := TElement.Create;
  e.Place := APlace;
  e.NewPlace := ANewPlace;
  Add(e);
end;

procedure  TElements.SortElements;
begin
  Sort(Compare);
end;

procedure  TElements.SaveToFile;
var Output: TStringList;
    i: integer;
begin
  Output := TStringList.Create;
  for i := 0 to Count - 1 do
    Output.Add(IntToStr(Elements[i].Place) + '=' +IntToStr(Elements[i].NewPlace));
  Output.SaveToFile(ExtractFilePath(ParamStr(0)) + 'temp.txt');
  Output.Free;
end;

destructor TElements.Destroy;
begin
  inherited Destroy;
end;



{procedure TEditingWell.SetRow(const Value: integer);
begin
  if Value <> FRow then
  begin
    FRow := Value;
    SendMessage(Application.Handle, WM_SELECTION_CHANGED, -1, FRow);
  end;
end;

procedure TEditingSubDivision.SetRow(const Value: integer);
begin
  if Value <> FRow then
  begin
    FRow := Value;
    SendMessage(Application.Handle, WM_SELECTION_CHANGED, -1, FRow);
  end;
end;

procedure TEditingSubDivisionComponent.SetRow(const Value: integer);
begin
  if Value <> FRow then
  begin
    FRow := Value;
    SendMessage(Application.Handle, WM_SELECTION_CHANGED, -1, FRow);
  end;
end;

procedure TEditingSubDivisionComponent.SetCol(const Value: integer);
begin
  if Value <> FCol then
  begin
    FCol := Value;
    SendMessage(Application.Handle, WM_SELECTION_CHANGED, FCol, -1);
  end;
end;}

procedure TFrmEditSubdivision.SetAppearance(AToolButton: TToolButton);
begin
  with AToolButton do
  begin
    Appearance[Tag].Caption := Caption;
    Appearance[Tag].Hint := Hint;
    Appearance[Tag].ImageIndex := ImageIndex;
  end;
end;

procedure TfrmEditSubDivision.SortByAges(var ARow: integer);
var i, j, iPlace, iTmp, iUps, iEx: integer;
    Elements: TElements;
    AssignedRows: array of integer;
    //lst: TStringList;
function InAssignedRows(ARow: integer): boolean;
var ii: integer;
begin
  Result := false;
  for ii := Length(AssignedRows) - 1 downto 0 do
  if AssignedRows[ii] = ARow then
  begin
    Result := true;
    break;
  end;
end;
begin
  with sgrSubDivision do
  begin
    Elements := TElements.Create;

    //lst := TStringList.Create;

    //FixedRows := 5;
    // находим соответствие текущему стратону среди всех
    iPlace := 5; SetLength(AssignedRows, 0); iTmp := 0; iUps := 0; iEx := 0;

    // устанавливаем правильный порядок стратонов
    for j := 0 to AllStratons.Count - 1 do
    for i := RowCount - 1 downto 5 do
    if not InAssignedRows(i) then
    begin
      if Assigned(Objects[0, i]) and
        (TStratons(Objects[0, i]).Items[0].StratonID = AllStratons[j].StratonID) then
      begin
        Elements.AddElement(i, iPlace);
        // сколько сделано перемещений наверх
        iUps := iUps + ord(iPlace < i);
        if i = ARow then iTmp := iPlace - iUps;
        inc(iPlace);
        SetLength(AssignedRows, Length(AssignedRows) + 1);
        //lst.Add(AllStratons[j].ListStraton(sloIndexNameAges));
        AssignedRows[High(AssignedRows)] := i;
      end
      else
      if not Assigned(Objects[0, i]) then
      begin
        Elements.AddElement(i, 0);
        inc(iEx);
        SetLength(AssignedRows, Length(AssignedRows) + 1);
        //lst.Add(AllStratons[j].ListStraton(sloIndexNameAges));
        AssignedRows[High(AssignedRows)] := i;
      end;
    end;


    {for i := 0 to Elements.Count - 1 do
    if Elements.Elements[i].NewPlace = 10000 then
    begin
      Elements.Elements[i].NewPlace := iPlace;
      inc(iPlace);
    end;}

    ARow := iTmp;
    //lst.SaveToFile(ExtractFilePath(ParamStr(0)) + 'temp.txt');
    //lst.Free;

    //Elements.SortElements;

    // увеличиваем количество строк
    // переносим все строки в том же порядке
    // в конец таблицы
    RowCount := RowCount + (RowCount - 5);
    j := Elements.Count - 1;

    for i := RowCount - 1 downto Elements.Count + 5 do
    begin
      ExchangeRows(i, j + 5);
      //if j + 5 = ARow then ARow := i;
      dec(j);
    end;

    // извлекаем строки из конца таблицы и
    // ставим каждую на свое место
    for i := 0 to Elements.Count - 1 do
    begin
      ExchangeRows(Elements.Elements[i].Place + Elements.Count, i + 5);
      //if ARow = Elements.Elements[i].Place + Elements.Count then ARow := i + 5;
    end;
    //Elements.SaveToFile;

    // уменьшаем количество строк до прежнего
    RowCount := Elements.Count + 5;
    Elements.Free;
  end;
end;

procedure TfrmEditSubDivision.ClearAll;
var i, j: integer;
begin
  with sgrSubDivision do
  begin
    for j := 0 to RowCount - 1 do
    begin
      Objects[0, j].Free;
      Objects[0, j] := nil;
      Cells[1, j] := '';
    end;

    for i := 1 to ColCount - 1 do
    for j := 0 to RowCount - 1 do
    begin
      Objects[i, j] := nil;
      Cells[i, j] := '';
    end;
    Empty := true;
    RowCount := 5;
    ColCount := 3;
  end;

  with sgrSubDivision do
  begin
    Cells[1, 0] := 'скв.';
    Cells[1, 1] := 'тект.';
    Cells[1, 2] := 'альт.';
    Cells[1, 3] := 'забой';
    Cells[0, 3] := 'стратоны';
    Cells[0, 4] := 'от';
    Cells[1, 4] := 'до';
  end;
  

  {if Assigned(FWells) then
  begin
    FWells.Free;
    FWells := nil;
  end;}
end;

procedure TfrmEditSubDivision.SetCurrentWell(Value: TWell);
begin
  if Value <> FCurrentWell then
  begin
    FCurrentWell := Value;
    if not Assigned(FCurrentWell) then
    begin
      if tlbtnWell.Action <> AddWell then ValiDateToolButton(tlbtnWell, nil);
      CurrentSubDivision := nil;
      //ValiDateToolButton(tlbtnTectonicBlock, nil);
    end;
  end;
end;

procedure TfrmEditSubDivision.SetCurrentSubDivision(value: TSubdivision);
begin
  if Value <> FCurrentSubdivision then
  begin
    FCurrentSubdivision := Value;
    if not Assigned(FCurrentSubdivision) then
    begin
      if tlbtnTectonicBlock.Action <> AddTectBlock  then ValiDateToolButton(tlbtnTectonicBlock, nil);
      CurrentComponent := nil;
      //ValiDateToolButton(tlbtnEdge, nil);
    end;
  end;
end;

procedure TfrmEditSubDivision.SetCurrentComponent(Value: TSubdivisionComponent);
begin
  if Value <> FCurrentComponent then
  begin
    FCurrentComponent := Value;
    if not Assigned(FCurrentComponent) and
         (tlbtnEdge.Action <> AddEdge) then
      ValiDateToolButton(tlbtnEdge, nil);
  end;
end;


procedure TfrmEditSubDivision.ExchangeRows(iFirst, iSecond: integer);
var S: TStrings;
begin
  with sgrSubDivision do
  begin
    S := TStringList.Create;
    S.Assign(Rows[iFirst]);
    Rows[iFirst].Assign(Rows[iSecond]);
    Rows[iSecond].Assign(S);
    S.Free;
  end;
end;

function  TfrmEditSubDivision.GetSimpleReport: OleVariant;
var i, j: integer;
    w: TWell;
    S: TStratons;
    C, LastC: TSubDivisionComponent;
begin
  with sgrSubDivision do
  begin
    Result := VarArrayCreate([0, ColCount, 0, RowCount - 1], varVariant);


    for j := 5 to RowCount - 1 do
    begin
      Result[0, j - 1] := Cells[0, j];
      S := Objects[0, j - 1] as TStratons;
      if Assigned(S) then
      Result[ColCount, j - 1] := ord((S[0].AgeOfTop = 0) and (S[0].AgeOfBase = 0));
    end;
    Result[0, RowCount - 1] := 'Забой';

    for i := 2 to ColCount - 1 do
    begin
      w := Objects[i, 0] as TWell;

      Result[i, 0] := w.AreaName;
      Result[i, 1] := w.WellNum;
      Result[i, 2] := (Objects[i, 1] as TSubDivision).TectonicBlock;
      Result[i, 3] := w.Altitude;
      LastC := nil;

      for j := RowCount - 1 downto 5 do
      if  Assigned(Objects[i, j])
      and (Objects[i, j] is TSubDivisionComponent) then
      begin
        C := (Objects[i, j] as TSubDivisionComponent);
        if {Assigned(LastC) and }Assigned(C) then
        if C.Depth < 0 then
          Result[i, j - 1] := C.SubDivisionComment
        else
        if Assigned(LastC) and
           (C.Depth = LastC.Depth) then
           Result[i, j - 1] := 'нр'
        else Result[i, j - 1] := C.Depth;
        LastC := C;
      end
      else Result[i, j - 1] := Cells[i, j];


      Result[i, RowCount - 1] := w.Depth;
    end;
  end;
end;

procedure TfrmEditSubDivision.FillEmpties;
var i, j: integer;
    Found: boolean;
begin
  with sgrSubDivision do
  for j := 2 to ColCount - 1 do
  begin
    Found := false;

    for i := RowCount - 1 downto 5 do
    if  not Assigned(Objects[j, i]) then
    if not Found then
    begin
      if Assigned(Objects[j, 1]) and ((Objects[j, 1] as TSubDivision).PropertyID  in [0, 1]) then
         Cells[j, i] := 'нв'
      else Cells[j, i] := 'отс'
    end
    else Cells[j, i] := 'отс'
    else Found := true;
  end;
end;

procedure TfrmEditSubDivision.RemoveDubles;
var i, j: integer;
    iRemovedRows: integer;
begin
  iRemovedRows := 0;
  with sgrSubDivision do
  begin
    for i := 5 to RowCount - 1 do
    if Assigned(Objects[0, i]) and Assigned(Objects[0, i - 1]) and
      (Objects[0, i] as TStratons).EqualTo(Objects[0, i - 1] as TStratons) then
    begin
      // удаляем строку
      for j := i to RowCount - 1 do
        ExchangeRows(j - 1, j);
      inc(iRemovedRows);
    end;

    for i := RowCount - iRemovedRows to RowCount - 1 do
    begin
      Objects[0, i].Free;
      Objects[0, i] := nil;
    end;
    RowCount := RowCount - iRemovedRows;
  end;
end;

procedure TfrmEditSubDivision.NameRow(ARow: integer; AStratons: TStratons; const ADivider: string);
var l: integer;
begin
  with sgrSubDivision do
  begin
    Cells[0, ARow] := '';
    if AStratons.Count > 0 then
    begin
      Cells[0, ARow] := AStratons[0].StratonIndex;// + '(' + IntToStr(AStratons[0].StratonID) + ')';
      for l := 1 to AStratons.Count - 1 do
        Cells[0, ARow] := Cells[0, ARow] + ADivider + AStratons[l].StratonIndex; //  + '(' + IntToStr(AStratons[l].StratonID) + ')';
      if not Assigned(Objects[0, ARow]) then
         Objects[0, ARow] := TStratons.Create(false);
      if Objects[0, ARow]<>AStratons then
        TStratons(Objects[0, ARow]).Assign(AStratons);
    end
    else
    begin
      Objects[0, ARow] := nil;
      Objects[0, ARow].Free;
    end;
  end;
end;


procedure TfrmEditSubDivision.NewWell(AWell: TWell);
var i, j, k, t, iStartCol, iStartRow, iCurCol: integer;
    Found: boolean;
    ChildStratons, es: TStratons;
    newSC: TSubDivisionComponent;
    dr: TDecompositionResult;
begin
  // загружаем скважину в таблицу
  with sgrSubDivision do
  begin
    for i := 0 to AWell.SubDivisions.Count - 1 do
    begin
      iStartCol := ColCount - 1;
      ColWidths[iStartCol] := 100;
      iCurCol := iStartCol;
      // титульные столбцы
      Cells[iCurCol, 0] := AWell.WellNum + '-' + GetBriefAreaName(AWell.AreaName, 5);
      Cells[iCurCol, 1] := AWell.SubDivisions[i].ShortBlockName;
      Cells[iCurCol, 2] := trim(Format('%6.2f', [AWell.Altitude]));
      Cells[iCurCol, 3] := trim(Format('%6.2f', [AWell.Depth]));
      Objects[iCurCol, 0] := AWell;
      Objects[iCurCol, 1] := AWell.SubDivisions[i];
      // загружаем разбивки
      with AWell.SubDivisions[i] do
      begin
        // проходим по всем строкам таблицы стратонов
        // и по всем компонентам разбивки скважины
        k := Content.Count - 1;
        while (k >= 0) do
        begin
          Found := false;
          for j := 4 to RowCount - 1 do
          if Assigned(Objects[0, j]) then
          begin
            if Content[k].Stratons.EqualTo(TStratons(Objects[0, j])) then
            begin
              if  (Content[k].Depth > 0)
              and ((Content[k].SubDivisionCommentID = 0)
                   or (((k = 0) or ((k > 0) and (Content[k - 1].Depth <> (Content[k].Depth)))))) then
                 Cells[iCurCol, j] := trim(Format('%6.2f', [Content[k].Depth]))
              else
                 Cells[iCurCol, j] := Content[k].SubDivisionComment;

              Objects[iCurCol, j] := Content[k];
              Found := true;
              k := k - 1;
              break;
            end
            else
            // если новые стратоны включают стратоны из таблицы
            // то новые стратоны разбить на старые и остаток
            // создать два контента
            // один приписать к сущетсвующему
            // другой добавить
            if Content[k].Stratons.Includes(TStratons(Objects[0, j])) then
            begin
              Found := true;
              newSC := Content.Insert(k) as TSubDivisionComponent;
              newSC.Assign(Content[k + 1]);
              Content[k + 1].Stratons.Assign(TStratons(Objects[0, j]));
              newSC.Stratons.Exclude(Content[k + 1].Stratons);

              if  (Content[k + 1].Depth > 0)
              and ((Content[k + 1].SubDivisionCommentID = 0)
                   or (((k = 0) or ((k > 0)
                            and (Content[k + 1].Depth <> (Content[k].Depth)))))) then
                 Cells[iCurCol, j] := trim(Format('%6.2f', [Content[k + 1].Depth]))
              else
                 Cells[iCurCol, j] := Content[k + 1].SubDivisionComment;
              Objects[iCurCol, j] := Content[k + 1];

              break;
            end
            // если стратоны из таблицы включают новые стратоны
            // добавить новую строку, перепривязать стратоны из таблицы
            // приписать часть к новому, часть оставить там где было
            else if TStratons(Objects[0, j]).Includes(Content[k].Stratons) then
            begin
              // исключаем из строки в которую входит всё,
              // те стратоны, которые будут добавлены сейчас
              TStratons(Objects[0, j]).Exclude(Content[k].Stratons);
              // переобзываем строку
              NameRow(j, TStratons(Objects[0, j]), Content[k].Divider);
              // изменяем структуру
              for t := 1 to ColCount - 2 do
              if Assigned(Objects[t, j]) then
                TSubdivisionComponent(Objects[t, j]).Stratons.Assign(TStratons(Objects[0, j]));

              // добавляем строку с остатком стратонов
              RowCount  := RowCount + 1; //ord(sgrSubDivision.RowCount > 5);
              iStartRow := RowCount - 1;
              NameRow(iStartRow, Content[k].Stratons, Content[k].Divider);
              // добавляем в структуры Content всех бывших до этого
              // скважин новый стратон с остатком
              for t := 1 to ColCount - 2 do
              if Assigned(Objects[t, j]) then
              begin
                newSC := TSubdivisionComponent(Objects[t, j]).Collection.Insert(TSubdivisionComponent(Objects[t, j]).Index) as TSubDivisionComponent;
                newSC.Assign(TSubdivisionComponent(Objects[t, j]));
                newSC.Stratons.Assign(Content[k].Stratons);
                Cells[t, RowCount - 1] := Cells[t, j];
                Objects[t, RowCount - 1] := newSC;
              end;

              if  (Content[k].Depth > -1)
              and ((Content[k].SubDivisionCommentID = 0)
                   or (((k = 0) or ((k > 0)
                            and (Content[k - 1].Depth <> (Content[k].Depth)))))) then
                Cells[iCurCol, iStartRow] := trim(Format('%6.2f', [Content[k].Depth]))
              else
                Cells[iCurCol, iStartRow] := Content[k].SubDivisionComment;
               Objects[iCurCol, iStartRow] := Content[k];




              k := k - 1;
              Found := true;
              break;
            end
          end;


          // если не нашли - добавляем новый стратон
          if not Found then
          begin
            RowCount  := RowCount + 1; //ord(sgrSubDivision.RowCount > 5);
            iStartRow := RowCount - 1;
            NameRow(iStartRow, Content[k].Stratons, Content[k].Divider);

            {Cells[0, iStartRow] := Content[k].Stratons[0].StratonIndex;
            for l := 1 to Content[k].Stratons.Count - 1 do
              Cells[0, iStartRow] := Cells[0, iStartRow] +
                                     Content[k].Divider +
                                     Content[k].Stratons[l].StratonIndex;

            Objects[0, iStartRow] := Content[k].Stratons;}
            {if Assigned(Content[k].NextStraton) then
            begin
              Cells[1, iStartRow] := Content[k].NextStraton.StratonIndex;
              Cells[0, iStartRow] := Cells[0, iStartRow] + ' - ' + Cells[1, iStartRow];
              Objects[1, iStartRow] := Content[k].NextStraton;
            end;}
            if  (Content[k].Depth > -1)
              and ((Content[k].SubDivisionCommentID = 0)
                   or (((k = 0) or ((k > 0)
                            and (Content[k - 1].Depth <> (Content[k].Depth)))))) then
              Cells[iCurCol, iStartRow] := trim(Format('%6.2f', [Content[k].Depth]))
            else
              Cells[iCurCol, iStartRow] := Content[k].SubDivisionComment;
            Objects[iCurCol, iStartRow] := Content[k];
            k := k - 1;
          end;
        end;
        ColCount  := ColCount + 1;
      end;
    end;
  end;
end;


{function  TfrmEditSubDivision.WellExists(Source: TWells; AWell: TWell): boolean;
var i: integer;
begin
  Result := false;
  for i := 0 to Source.Count - 1 do
  if AWell.WellUIN = Source[i].WellUIN then
  begin
    Result := true;
    break;
  end;
end;}

function  TfrmEditSubDivision.GetWellColumn(AWell: TWell): integer;
var i: integer;
begin
  Result := -1;
  with sgrSubDivision do
  for i := ColCount - 1 downto 2 do
  if TWell(Objects[i, 0]).WellUIN = AWell.WellUIN then
  begin
    Result := i;
    break;
  end;
end;

function  TfrmEditSubDivision.GetFilledColumns(ARow: integer): integer;
var i: integer;
begin
  Result := 0;
  with sgrSubDivision do
  for i := 0 to ColCount - 1 do inc(Result, ord(Assigned(Objects[i, ARow])));
end;



procedure TfrmEditSubDivision.ValidateToolButton(AToolButton: TToolButton; AAction: TAction);
begin
  with AToolButton do
  if Assigned(AAction) then
  begin
    Caption := AAction.Caption;
    Hint := AAction.Hint;
    ImageIndex := AAction.ImageIndex;
    OnClick := AAction.OnExecute;
    ChangesMade := true;
  end
  else
  begin
    Caption := Appearance[AToolButton.Tag].Caption;
    Hint := Appearance[AToolButton.Tag].Hint;
    ImageIndex := Appearance[AToolButton.Tag].ImageIndex;
    OnClick := nil;
  end;
end;

function  TfrmEditSubDivision.GetRow(AStratons: TStratons; const ADivider: string): integer;
var i: integer;
begin
  with sgrSubDivision do
  begin
    Result := -1;
    for i := 5 to RowCount - 1 do
{    if ((TStraton(Objects[0, i]).StratonID = ASubComponent.Straton.StratonID)
       and not(Assigned(Objects[1, i])) and not Assigned(ASubComponent.NextStraton)) or
       ((Assigned(Objects[1, i]) and Assigned(ASubComponent.NextStraton) and
       (TStraton(Objects[0, i]).StratonID = ASubComponent.NextStraton.StratonID))) then}
    if Assigned(Objects[0, i]) and AStratons.EqualTo(TStratons(Objects[0, i])) then
    begin
      Result := i;
      break;
    end;

    // добавляем новую строку
    if Result = -1 then
    begin
      RowCount := RowCount + 1;
      NameRow(RowCount - 1, AStratons, ADivider);
      {Objects[0, RowCount - 1] := ASubComponent.Stratons;
      Cells[0, RowCount - 1]   := ASubComponent.Stratons[0].StratonIndex;
      for i := 1 to ASubComponent.Stratons.Count - 1 do
        Cells[0, RowCount - 1] := Cells[0, RowCount - 1] +
                                  ASubComponent.Divider + ASubComponent.Stratons[i].StratonIndex;}
      Result := RowCount - 1;
    end;
  end;
end;


procedure TfrmEditSubDivision.ClearCell(const ACol, ARow: integer);
begin
  with sgrSubDivision do
  begin
    Cells[ACol, ARow] := 'н.в.';
    Objects[ACol, ARow] := nil;
  end;
end;

procedure TfrmEditSubDivision.SetReadOnly(const Value: boolean);
begin
  if FReadOnly <> Value then
  begin
    FReadOnly := Value;
    pnlButtons.Visible := not FReadOnly;
    pnlQuickEditButtons.Visible := not FReadOnly;
    {if FreadOnly then
       sgrSubDivision.Options := sgrSubDivision.Options + [goRowSelect]
    else  sgrSubDivision.Options := sgrSubDivision.Options - [goRowSelect];}
  end;
end;

procedure TfrmEditSubDivision.SetWells(Value: TWells);
var i, iMaxLength, iWidth: integer;
    iRow, iCol: integer;
    bResult: boolean;
    Stratons: TStratons;
begin
  iRow := CRow;
  iCol := CCol;

  ClearAll;
  FWells := Value;
  Empty := false;
  DecompositionResults.Clear;
  // добавляем скважину
  if Assigned(Value) and (Value.Count > 0) then
  begin
    // получаем разбивки по каждой скважине, предварительно
    // запросив общую колонку
    //Stratons := TExcludedStratons.Create(Value.GetFilter);
    //Value.GatherStratons(Stratons);
    if ShowProgress then
    begin
      if not Assigned(frmProgress) then frmProgress := TfrmProgress.Create(Self.Owner);
      frmProgress.SetParams(0, Value.Count - 1, 1, 'скважин');
      frmProgress.Show;
    end;

    for i := 0 to Value.Count - 1 do
    begin
      if Value[i].SubDivisions.Count = 0 then Value[i].GetSubdivisions(nil);
      NewWell(Value[i]);
      if ShowProgress then frmProgress.StepIt;
    end;


    if ShowProgress then
    begin
      frmProgress.Free;
      frmProgress := nil;
    end;

    if Wells.Count > 0 then CurrentWell := Wells[0];
    // сортируем стратоны по порядку
    sgrSubDivision.ColCount := sgrSubDivision.ColCount - 1;

    SortByAges(iRow);
    FillEmpties;
  end;
end;

procedure   TfrmEditSubDivision.MakeReport;
var i, j: integer;
    Intersections: TStratons;
    LHS, RHS: TStratons;
    sDivider: string;
    iRow: integer;

function ValidateCols(ARow: integer): boolean;
var c: integer;
begin
  Result := false;
  with sgrSubDivision do
  for c := 2 to ColCount - 1 do
  if not(Assigned(Objects[c, iRow])) then
  begin
    Cells[c, iRow] := Cells[c, ARow];
    Objects[c, iRow] := Objects[c, ARow];
    if Assigned(Objects[c, ARow]) then sDivider := (Objects[c, ARow] as TSubDivisionComponent).Divider;
    Result := true;
  end;
end;

begin
  // найти пересечения
  // добавить для них строки и пересортировать
  Intersections := TStratons.Create(false);
  with sgrSubDivision do
  for i := RowCount - 1 downto 5 do
  if  (Objects[0, i] is TStratons)
  and (pos('-', Cells[0, i]) = 0) then
  begin
    LHS := (Objects[0, i] as TStratons);
    iRow := 0;
    //if LHS.Count > 1 then
    for j := i - 1 to i - 1 do
    begin
      Intersections.Clear;
      if (Objects[0, j] is TStratons) and (j <> i) then
      begin
        RHS := (Objects[0, j] as TStratons);
        // сравниваем левую и правую часть
        // если есть пересечения собираем их
        // из исходных строк удаляем пересечения
        RHS.Intersects(LHS, Intersections, true);
        sDivider := '+';
        if Intersections.Count > 0 then
        begin
          // для каждого добавляем строку
          iRow := GetRow(Intersections, sDivider);

          // проходим по столбцам и заполняем их
          sDivider := '+';
          ValidateCols(j);
          NameRow(j, RHS, sDivider);
          NameRow(iRow, Intersections, sDivider);
        end;
      end;
    end;

    if iRow > 0 then
    begin
      ValidateCols(i);
      // удаляем пустые
      NameRow(i, LHS, sDivider);
    end;
    {if LHS.Count = 0 then
    begin
      LHS.Free;
      Objects[0, i] := nil;
    end;}
  end;
  Intersections.Free;
  SortByAges(CRow);
  RemoveDubles;
end;

constructor TfrmEditSubDivision.Create(AOwner: TComponent);
var i: integer;
    S: string;
begin
  CurrentWell := nil;
  CurrentSubDivision := nil;
  CurrentComponent := nil;

  inherited Create(AOwner);

  FDecompositionResults := TDecompositionResults.Create;
  FQuickEdition :=  TQuickEdition.Create(sgrSubDivision);
  

  SetAppearance(tlbtnWell);
  SetAppearance(tlbtnTectonicBlock);
  SetAppearance(tlbtnEdge);

  with sgrSubDivision do
  begin
    Cells[1, 0] := 'скв.';
    Cells[1, 1] := 'тект.';
    Cells[1, 2] := 'альт.';
    Cells[1, 3] := 'забой';
    Cells[0, 3] := 'стратоны';
    Cells[0, 4] := 'от';
    Cells[1, 4] := 'до';
  end;

  FReadOnly := false;
  FReportFormat := true;

  with actnLst do
  for i := 0 to ActionCount - 1 do
  begin
    S := TAction(Actions[i]).Caption;
    TAction(Actions[i]).Caption := S + StringOfChar(' ',30 - Length(S)-1);
  end;

  with sgrSubDivision do
  begin
    ColWidths[1] := -1;
    for i := 2 to FixedRows - 1 do RowHeights[i] := -1;
  end;

  
  //frmSubComponentEdit1.Update;
  //frmSubComponentEdit1.Height := frmSubComponentEdit1.Height - frmSubComponentEdit1.pnlButtons.Height;
end;

destructor  TfrmEditSubDivision.Destroy;
begin
  ClearAll;

  FQuickEdition.Free;
  FDecompositionResults.Free;

  if Assigned(frmTectBlock) then
  begin
    frmTectBlock.Free;
    frmTectBlock := nil;
  end;

  if Assigned(frmWellConfirm) then
  begin
    frmWellConfirm.Free;
    frmWellConfirm := nil;
  end;

  if Assigned(frmSubDivisionComponentEdit) then
  begin
    frmSubDivisionComponentEdit.Free;
    frmSubDivisionComponentEdit := nil;
  end;

  inherited Destroy;
end;

procedure TfrmEditSubDivision.cmbxCommentChange(Sender: TObject);
begin
 //
end;

procedure TfrmEditSubDivision.sbtnDeleteWellClick(Sender: TObject);
begin
 //
end;

procedure TfrmEditSubDivision.sgrSubDivisionSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  with sgrSubDivision do
  begin
    CCol := ACol;
    CRow := ARow;
    //LeftCol := ACol;
    if not ReadOnly and Assigned(AllStratons) and (not Empty) and ((ACol >= FixedCols) and (ARow >= FixedRows)) then
    begin
      CurrentWell := TWell(Objects[ACol, 0]);
      CurrentSubDivision := TSubDivision(Objects[ACol, 1]);
      CurrentComponent := TSubDivisionComponent(Objects[ACol, ARow]);
      CanSelect := true;
      if Assigned(CurrentComponent) then
         frmSubComponentEdit1.EditingComponent := CurrentComponent;
    end;
    Invalidate;
    //else CanSelect := false;
  end;
end;

procedure TfrmEditSubDivision.AddWellExecute(Sender: TObject);
begin
  tlbtnDefault.Down := true;
  tlbtnDefaultClick(Sender);

  // добавляем скважину
  if not Assigned(frmWellConfirm) then frmWellConfirm := TfrmWellConfirm.Create(Self);
  with frmWellConfirm do
  begin
    // переделываем кнопку по последнему действию
    ValidateToolButton(tlbtnWell, AddWell);

    ShowProblem('', '', '');

    if ShowModal = mrOk then
    begin
      CurrentWell := ActiveWells.AddWell(FoundWellUIN, cmbxArea.Text, cmbxWellNum.Text, FoundAltitude, FoundDepth, false);
      if CurrentWell.SubDivisions.Count = 0 then
        CurrentSubDivision := CurrentWell.SubDivisions.AddSubDivision(0);
      Wells := ActiveWells;

      with sgrSubDivision do
         Col := ColCount - 1;
    end;
  end;
end;

procedure TfrmEditSubDivision.EditWellExecute(Sender: TObject);
begin
  tlbtnDefault.Down := true;
  tlbtnDefaultClick(Sender);

  // редактируем скважину
  if not Assigned(frmWellConfirm) then frmWellConfirm := TfrmWellConfirm.Create(Self);
  with frmWellConfirm do
  begin
    // переделываем кнопку по последнему действию
    ValidateToolButton(tlbtnWell, EditWell);

    ShowProblem('', CurrentWell.AreaName, CurrentWell.WellNum);

    if ShowModal = mrOk then
    begin
      CurrentWell.UpdateWell(FoundWellUIN, cmbxArea.Text, cmbxWellNum.Text, FoundAltitude, FoundDepth, true);
      // просто заменяем описание - не перегружая
      with sgrSubdivision do
      begin
        Cells[Col, 0] := CurrentWell.WellNum + '-' + CurrentWell.AreaName;
        if trim(CurrentSubdivision.TectonicBlock) <> '' then
           Cells[Col, 0] := Cells[Col, 0] + '(' +
                                CurrentSubdivision.ShortBlockName + ')';

        Cells[Col, 2] := trim(Format('%6.2f', [CurrentWell.Altitude]));
        Cells[Col, 3] := trim(Format('%6.2f', [CurrentWell.Depth]));
      end;

//      Wells := ActiveWells;
    end;
  end;
end;

procedure TfrmEditSubDivision.DeleteWellExecute(Sender: TObject);
var iCol: integer;
begin
  tlbtnDefault.Down := true;
  tlbtnDefaultClick(Sender);
  
  if MessageBox(Handle, PChar('Вы действительно хотите удалить скважину ' + CurrentWell.ListWell +'?'),
                PChar('Вопрос'),
                MB_YESNO+MB_APPLMODAL+MB_ICONWARNING) = ID_YES then
  begin
    // переделываем кнопку по последнему действию
    ValidateToolButton(tlbtnWell, DeleteWell);

    ActiveWells.DeleteWell(CurrentWell.Index, true);
    iCol := CCol;

    CurrentWell.SubDivisions.Clear;
    Wells := ActiveWells;

    // выделяем нужное
    with sgrSubDivision do
    if iCol < ColCount  then Col := iCol
    else Col := iCol - 1;
  end;
end;

procedure TfrmEditSubDivision.AddTectBlockExecute(Sender: TObject);
var iCol: integer;
    sb: TSubDivision;
    cw: TWell;
begin
  tlbtnDefault.Down := true;
  tlbtnDefaultClick(Sender);
  
  if not Assigned(frmTectBlock) then frmTectBlock := TfrmTectBlock.Create(Self);
  with frmTectBlock do
  begin
    Well := CurrentWell;
    if ShowModal = mrOk then
    begin
      // переделываем кнопку по последнему действию
      ValidateToolButton(tlbtnTectonicBlock, AddTectBlock);

      cw := CurrentWell;
      sb := CurrentWell.SubDivisions.AddSubDivision(cmbxTectBlock.Text);

      Wells := ActiveWells;
      // выделяем добавленный тектонический блок
      CurrentSubDivision := sb;

      iCol := GetWellColumn(cw);
      with sgrSubDivision do
      if iCol + CurrentSubDivision.Index < ColCount then
         Col := iCol + CurrentSubDivision.Index
      else Col := ColCount - 1;
    end;
  end;
end;

procedure TfrmEditSubDivision.EditTectBlockExecute(Sender: TObject);
begin
  tlbtnDefault.Down := true;
  tlbtnDefaultClick(Sender);

  if not Assigned(frmTectBlock) then frmTectBlock := TfrmTectBlock.Create(Self);
  with frmTectBlock do
  begin
    // переделываем кнопку по последнему действию
    ValidateToolButton(tlbtnTectonicBlock, EditTectBlock);

    Well := CurrentWell;
    SubDivision := CurrentSubDivision;
    if ShowModal = mrOk then
    begin
      CurrentSubDivision.UpdateSubDivision(cmbxTectBlock.Text, true);
      // просто меняем блок, не перегружая
      with sgrSubdivision do
      begin
        Cells[Col, 0] := CurrentWell.WellNum + '-' + CurrentWell.AreaName;
        if trim(CurrentSubdivision.TectonicBlock) <> '' then
           Cells[Col, 0] := Cells[Col, 0] + '(' +
                                CurrentSubdivision.ShortBlockName + ')';
        Cells[Col, 1] := CurrentSubDivision.TectonicBlock;
      end;

      //Wells := ActiveWells;
    end;
  end;
end;

procedure TfrmEditSubDivision.DeleteTectBlockExecute(Sender: TObject);
var iCol: integer;
begin
  tlbtnDefault.Down := true;
  tlbtnDefaultClick(Sender);

  if MessageBox(Handle, PChar('Вы действительно хотите удалить тектонический блок ' + CurrentSubDivision.TectonicBlock +  ' из скважины ' + CurrentWell.ListWell +'?'),
                PChar('Вопрос'),
                MB_YESNO+MB_APPLMODAL+MB_ICONWARNING) = ID_YES then
  begin
    // переделываем кнопку по последнему действию
    ValidateToolButton(tlbtnTectonicBlock, DeleteTectBlock);

    CurrentWell.SubDivisions.DeleteSubdivision(CurrentSubDivision.Index, true);
    //if CurrentWell.Subdivisions.Count = 0 then ActiveWells.DeleteWell(CurrentWell.Index, true);

    iCol := CCol;

    CurrentWell.SubDivisions.Clear;
    Wells := ActiveWells;

    // выделяем нужное
    with sgrSubDivision do
    if iCol < ColCount  then Col := iCol
    else Col := iCol - 1;

    {with sgrSubDivision do
    if iCol < ColCount then Col := iCol
    else Col := ColCount - 1;}
  end;
end;

procedure TfrmEditSubDivision.AddEdgeExecute(Sender: TObject);
var C: TSubdivisionComponent;
    i: integer;    
begin
  tlbtnDefault.Down := true;
  tlbtnDefaultClick(Sender);

  if not Assigned(frmSubDivisionComponentEdit) then frmSubDivisionComponentEdit := TfrmSubDivisionComponentEdit.Create(Self);
  with frmSubDivisionComponentEdit.frmSubComponentEdit1 do
  begin
    EditingComponent := nil;
    AddTo := CurrentSubDivision;
    NearestComponent := nil;
    with sgrSubDivision do
    for i := Row + 1 to RowCount - 1 do
    if Assigned(Objects[Col, i]) and ((Objects[Col, i] as TSubDivisionComponent).Depth > 0) then
    begin
      NearestComponent := Objects[Col, i] as TSubDivisionComponent;
      break;
    end;

    if not Assigned(EditingComponent) then
       AdditionalStratons := sgrSubDivision.Objects[0, CRow] as TStratons;

    if frmSubDivisionComponentEdit.ShowModal = mrOk then
    begin
      // переделываем кнопку по последнему действию
      ValidateToolButton(tlbtnEdge, AddEdge);

      CurrentComponent := EditingComponent;
      C := CurrentComponent;

      with sgrSubDivision do
      begin
        if Assigned(CurrentComponent) then
        begin
          CRow := GetRow(CurrentComponent.Stratons, CurrentComponent.Divider);
          if (CurrentComponent.Depth > 0) and (CurrentComponent.SubDivisionCommentID = 0) then
            Cells[CCol, CRow] := trim(Format('%6.2f',[CurrentComponent.Depth]))
          else Cells[CCol, CRow] := CurrentComponent.SubDivisionComment;

          Objects[CCol, CRow] := CurrentComponent;
        end;

        if CRow = RowCount - 1 then
        begin
          CurrentWell.SubDivisions.Clear;
          Wells := ActiveWells;
          Row := CRow;
        end
        else Row := CRow;
      end;
    end;
  end;
end;

procedure TfrmEditSubDivision.EditEdgeExecute(Sender: TObject);
var i: integer;
    sC, unDiv: TSubDivisionComponent;
    strs: TStratons;
begin
  tlbtnDefault.Down := true;
  tlbtnDefaultClick(Sender);

  if not Assigned(frmSubDivisionComponentEdit) then frmSubDivisionComponentEdit := TfrmSubDivisionComponentEdit.Create(Self);
  with frmSubDivisionComponentEdit.frmSubComponentEdit1 do
  begin
    strs := TStratons.Create(false);
    strs.Assign(CurrentComponent.Stratons);
    EditingComponent := CurrentComponent;
    AddTo := CurrentSubDivision;
    NearestComponent := nil;    
    with sgrSubDivision do
    for i := Row + 1 to RowCount - 1 do
    if Assigned(Objects[Col, i]) then
      NearestComponent := Objects[Col, i] as TSubDivisionComponent;

    if frmSubDivisionComponentEdit.ShowModal = mrOk then
    with sgrSubDivision do
    begin
      // переделываем кнопку по последнему действию
      ValidateToolButton(tlbtnEdge, EditEdge);

      // если редактируется шаблон, или в своей строке
      // такой набор один то поменять стратоны для всех строк

      // запоминаем
      strs.Assign(EditingComponent.Stratons);

      if frmSubDivisionComponentEdit.frmSubComponentEdit1.chbxChangeUndivided.Checked then
      begin
        sC := Objects[CCol, CRow] as TSubDivisionComponent;
        i := sC.Index + 1;
        try
          unDiv := (sC.Collection as TSubDivisionComponents).Items[i];
        except
          undiv := nil;
        end;
        // пытаемся заменить все нерасчленненные, если меняется нижняя глубина
        while ((i < sC.Collection.Count)
        and Assigned(unDiv)
        and (unDiv.SubDivisionCommentID = 1)) do
        begin
          unDiv.Depth := sC.Depth;
          unDiv.PostToDB;
          inc(i);
          try
            unDiv := (sC.Collection as TSubDivisionComponents).Items[i];
          except
            undiv := nil;
          end;
        end;
      end;

      if frmSubDivisionComponentEdit.frmSubComponentEdit1.chbxTemplateEdit.Checked then
      with sgrSubDivision do
      for i := 2 to ColCount - 1 do
      if (CCol <> i) and Assigned(Objects[i, CRow]) then
      begin
        sC := (Objects[i, CRow] as TSubDivisionComponent);
        sC.Divider := EditingComponent.Divider;
        sC.Stratons.Assign(Strs);
        sC.PostToDB;
      end;

      Wells := ACtiveWells;


      frmSubComponentEdit1.ShowChanges;
    end;
    strs.Free;
  end;
end;

procedure TfrmEditSubDivision.DeleteEdgeExecute(Sender: TObject);
begin
  tlbtnDefault.Down := true;
  tlbtnDefaultClick(Sender);

  // переделываем кнопку по последнему действию
  ValidateToolButton(tlbtnEdge, DeleteEdge);
  CurrentSubDivision.DeleteComponent(CurrentComponent.Index, true);
  //if CurrentSubDivision.Content.Count = 0 then CurrentWell.SubDivisions.DeleteSubdivision(CurrentSubDivision.Index, false);
  //if CurrentWell.Subdivisions.Count = 0 then ActiveWells.DeleteWell(CurrentWell.Index, false);
  with sgrSubDivision do
  begin
    Cells[Col, Row] := 'отс';
    Objects[Col, Row] := nil;
  end;

  //with sgrSubDivision do ClearCell(Col, Row);
end;

procedure TfrmEditSubDivision.AddEdgeUpdate(Sender: TObject);
begin
  AddEdge.Enabled := Assigned(CurrentSubDivision);
end;

procedure TfrmEditSubDivision.EditEdgeUpdate(Sender: TObject);
begin
  EditEdge.Enabled := Assigned(CurrentSubDivision)
                      and Assigned(CurrentComponent);
end;

procedure TfrmEditSubDivision.DeleteEdgeUpdate(Sender: TObject);
begin
  DeleteEdge.Enabled := Assigned(CurrentSubDivision)
                        and Assigned(CurrentComponent);
end;

procedure TfrmEditSubDivision.EditWellUpdate(Sender: TObject);
begin
  EditWell.Enabled := Assigned(CurrentWell);
end;

procedure TfrmEditSubDivision.DeleteWellUpdate(Sender: TObject);
begin
  DeleteWell.Enabled := Assigned(CurrentWell);
end;

procedure TfrmEditSubDivision.AddTectBlockUpdate(Sender: TObject);
begin
  AddTectBlock.Enabled := Assigned(CurrentWell) and not(CurrentWell.SubDivisions.IsComplete);
end;

procedure TfrmEditSubDivision.EditTectBlockUpdate(Sender: TObject);
begin
  EditTectBlock.Enabled := Assigned(CurrentSubDivision) and not(CurrentWell.SubDivisions.IsComplete);
end;

procedure TfrmEditSubDivision.DeleteTectBlockUpdate(Sender: TObject);
begin
  DeleteTectBlock.Enabled := Assigned(CurrentWell)
                             and Assigned(CurrentSubDivision);
end;

procedure TfrmEditSubDivision.sgrSubDivisionMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var iRow, iCol: integer;
begin
  sgrSubDivision.MouseToCell(X, Y, iCol, iRow);
  if (Button = mbLeft) then
  begin
    if (iCol > 1) and not ReadOnly then
    begin
      if (ssDouble in Shift) then
      with sgrSubDivision do
      begin
        if (iCol > 1) and not ReadOnly then
        begin
          case iRow of
            // редактировать скважину
            //0: EditWell.Execute;
            // редактировать тектонический блок
            1: EditTectBlock.Execute;
            // редактировать границу
            else if iRow >= FixedRows then EditEdge.Execute;
          end;
        end;
        sgrSubDivision.Cursor := crDefault;
        tlbtnDefault.Down := true;
      end
      else
      if (FQuickEdition.EditionType <> qeNone) then
      begin
        if ssShift in Shift then
          FQuickEdition.Perform(CurrentSubDivision, sgrSubDivision.Selection)
        else
          FQuickEdition.Perform(CurrentSubDivision, iCol, iRow)
      end;
    end;
  end
  else pmnMain.AutoPopup := (Button = mbRight) and not ReadOnly;
end;

procedure TfrmEditSubDivision.sbtnReloadClick(Sender: TObject);
var //bmp: TBitmap;
    i: integer;
begin
{  bmp := TBitmap.Create;
  bmp.Canvas.Assign((Owner as TForm).Canvas);}
  for i := 0 to ActiveWells.Count - 1 do
    ActiveWells.Items[i].Subdivisions.Clear;

  Wells := ActiveWells;
{  bmp.SaveToFile(ExtractFilePath(ParamStr(0)) + 'test.bmp');
  bmp.Free;}
end;

procedure TfrmEditSubDivision.sgrSubDivisionDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var Obj: TStraton;
procedure FillCanvas(AColor: TColor; ARect: Trect);
begin
  with sgrSubDivision do
  begin
    Canvas.Brush.Color := AColor;
    Canvas.FillRect(ARect);
    Canvas.Font.Color := clBlack;
    //Canvas.Font.Style:=[fsBold];
    Canvas.TextOut(ARect.Left+2,ARect.Top+2,Cells[ACol, ARow]);
  end
end;

function RowAssigned: boolean;
var i: integer;
begin
  Result := false;
  with sgrSubDivision do
  for i := 2 to ColCount - 1 do
  if Cells[i, ARow] <> 'н.в.' then
  begin
    Result := true;
    break;
  end;
end;
begin
  {
    выделяем красным $00C6BFF0 - не задан сортировочный признак
    желтым $00C0EAF8 - все элементы строки не определены
    оранжевым  $00C6E3F2 - неподтвержденные
  }

  // выделяем цветом неподтвержденные
  with sgrSubDivision do
  if  (Assigned(Objects[ACol, ARow])
  and (Objects[ACol, ARow] is TSubDivisionComponent)
  and (not (Objects[ACol, ARow] as TSubDivisionComponent).Verified)) then
    FillCanvas($00C6E3F2, Rect);

  with sgrSubDivision do
  if ((ARow = CRow) and (ACol < FixedCols))
  or ((ACol = CCol) and (ARow < FixedRows)) then
  begin
    Canvas.Font.Style := [fsBold];
    Canvas.Font.Color := clHighlight;
    Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);
  end;

  with sgrSubDivision do
  if ARow >= FixedRows then
  if Assigned(Objects[0, ARow])
  and (Objects[0, ARow] is TStratons)
  and ((Objects[0, ARow] as TStratons).Count > 0) then
  begin
    Obj := (Objects[0, ARow] as TStratons).Items[0];
    if (Obj.AgeOfTop = 0) and (Obj.AgeOfBase = 0) then
      FillCanvas($00C6BFF0, rect)
    else
    if not RowAssigned then
      FillCanvas($00C0EAF8, Rect);
  end;


  // выделить поле
  with sgrSubDivision do
  if  (ACol > 1)
  and (ARow = CRow) then
  begin
    if ACol = CCol then Canvas.Font.Style:=[fsBold];
    Canvas.TextOut(Rect.Left + 2,Rect.Top+2,Cells[ACol, ARow]);
    FillCanvas($00F0D9CE, Rect);
  end;

end;

procedure TfrmEditSubDivision.actnLstUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  TAction(Action).Enabled := Parent.Visible and Visible and not ReadOnly;
  Handled := not TAction(Action).Enabled;
end;

procedure TfrmEditSubDivision.RemoveRepeated;
var i, j, k: integer;
    inStratons, outStratons, intersectStratons: TStratons;
    strlst: TStringList;
    els: TElements;
begin
  i := 5;
  strlst := TStringList.Create;

  els := TElements.Create;
  intersectStratons := TStratons.Create(false);
  with sgrSubDivision do
  while i < RowCount do
  begin
    inStratons := Objects[0, i] as TStratons;
    if i < RowCount - 1 then outStratons := Objects[0, i + 1] as TStratons
    else outStratons := nil;

    intersectStratons.Clear;
    if Assigned(outStratons) and Assigned(inStratons) then
    begin
      if inStratons.EqualTo(OutStratons) then
      begin
        OutStratons.Clear;
        NameRow(i + 1, OutStratons, '+');
        for k := 2 to ColCount - 1 do
        begin
          if Assigned(Objects[k, i + 1]) then
          begin
            Cells[k, i] := Cells[k, i + 1];
            if not Assigned(Objects[k, i]) then
              Objects[k, i] := Objects[k, i + 1];
          end
        end;
        j := i + 1;
        SortByAges(j);
      end
      else
      if inStratons.Intersects(OutStratons, intersectStratons, true) then
      begin
        //outStratons.Exclude(inStratons);
        inStratons.MakeList(strLst, sloIndexName, false);
        strlst.Add('-');
        NameRow(i, InStratons, '+');

        OutStratons.MakeList(strLst, sloIndexName, false);
        strlst.Add('-');
        NameRow(i + 1, OutStratons, '+');

        IntersectStratons.MakeList(strLst, sloIndexName, false);
        strlst.Add('-');
        j := GetRow(intersectStratons, '+');
        for k := 2 to ColCount - 1 do
        begin
          if Assigned(Objects[k, i]) and (i <> j) then
          begin
            Cells[k, j] := Cells[k, i];
            if not Assigned(Objects[k, j]) then
              Objects[k, j] := Objects[k, i];
          end
          else
          if Assigned(Objects[k, i + 1]) and (i + 1 <> j) then
          begin
            Cells[k, j] := Cells[k, i + 1];
            //if not Assigned(Objects[k, j]) then
              Objects[k, j] := Objects[k, i + 1];
          end;
        end;

        strLst.Add('____');

        j := i + 1;
        SortByAges(j);
        //i := i + 1;
        continue;
        els.AddElement(i + 1, i);
      end;
    end;

    {intersectStratons.Clear;
    if i + 2 < RowCount then
    begin
      inStratons := Objects[0, i + 2] as TStratons;
      if Assigned(outStratons) then
      if InStratons.Intersects(OutStratons, intersectStratons, true) then
      begin
        //outStratons.Exclude(inStratons);
        NameRow(i + 1, OutStratons, '+');
        nameRow(i + 2, InStratons, '+');
        els.AddElement(i + 1, i + 2);
      end;
    end;}
    i := i + 1;
  end;
  Strlst.SaveToFile(ExtractFilePath(ParamStr(0)) + '\temp.txt');
  strlst.Free;
end;

constructor TElements.Create;
begin
  inherited;
  OwnsObjects := false;
end;

procedure TfrmEditSubDivision.tlbtnNoDataClick(Sender: TObject);
begin
  Screen.Cursors[crSpecialCursor] := LoadCursor(HInstance, 'NODATA');
  sgrSubDivision.Cursor := crSpecialCursor;
  FQuickEdition.EditionType := qeNoData;  
end;

procedure TfrmEditSubDivision.tlbtnDefaultClick(Sender: TObject);
begin
  sgrSubDivision.Cursor := crDefault;
  FQuickEdition.EditionType := qeNone;
end;

procedure TfrmEditSubDivision.tlbtnNotDividedClick(Sender: TObject);
begin
  Screen.Cursors[crSpecialCursor] := LoadCursor(HInstance, 'NOTDIV');
  sgrSubDivision.Cursor := crSpecialCursor;
  FQuickEdition.EditionType := qeNotDivided;
end;

procedure TfrmEditSubDivision.tlbtnDeleteClick(Sender: TObject);
begin
  Screen.Cursors[crSpecialCursor] := LoadCursor(HInstance, 'DEL');
  sgrSubDivision.Cursor := crSpecialCursor;
  FQuickEdition.EditionType := qeDelete;
end;

procedure TfrmEditSubDivision.sgrSubDivisionKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Ord(Key) = VK_ESCAPE then
  begin
    tlbtnDefault.Down := true;
    tlbtnDefaultClick(Sender);
  end;
end;

{ TQuickEdition }

constructor TQuickEdition.Create(AGrid: TStringGrid);
begin
  inherited Create;
  FGrid := AGrid;
  FQuickEditionType := qeNone;
end;

procedure TQuickEdition.EditDelete;
begin
  if not((FEditingComponent.Collection as TSubDivisionComponents).SubDivision.PropertyID in [0, 1]) then
    Grid.Cells[Col, Row] := 'отс'
  else Grid.Cells[Col, Row] := 'нв';
  Grid.Objects[Col, Row] := nil;

  (FEditingComponent.Collection as TSubDivisionComponents).SubDivision.DeleteComponent(FEditingComponent.Index, true);
end;

procedure TQuickEdition.EditNoData;
begin
  FEditingComponent.Depth := -2;
  FEditingComponent.SubDivisionCommentID := 2;
  FEditingComponent.PostToDB;
  Grid.Cells[Col, Row] := 'нд';
end;

procedure TQuickEdition.EditNotDivided;
var i: integer;
    unDiv: TSubdivisionComponent;

begin
  // ищем первый нерасчлененный до
  for i := FEditingComponent.Index - 1 downto 0 do
  if (FEditingComponent.Collection as TSubDivisionComponents).Items[i].Depth > 0 then
  begin
    unDiv := (FEditingComponent.Collection as TSubDivisionComponents).Items[i];
    break;
  end;

  try
    FEditingComponent.Depth :=  unDiv.Depth;
  except
    FEditingComponent.Depth :=  -2;
  end;

  FEditingComponent.SubDivisionCommentID := 1;
  FEditingComponent.PostToDB;

  i := FEditingComponent.Index + 1;
  try
    unDiv := (FEditingComponent.Collection as TSubDivisionComponents).Items[i];
  except
    undiv := nil;
  end;

  // пытаемся заменить все нерасчленненные, если меняется нижняя глубина
  while ((i < FEditingComponent.Collection.Count)
    and Assigned(unDiv)
    and (unDiv.SubDivisionCommentID = 1)) do
  begin
    unDiv.Depth := FEditingComponent.Depth;
    unDiv.PostToDB;
    inc(i);
    try
      unDiv := (FEditingComponent.Collection as TSubDivisionComponents).Items[i];
    except
      undiv := nil;
    end;
  end;

  Grid.Cells[Col, Row] := 'нр';
end;

procedure TQuickEdition.Perform(ASubdivision: TSubdivision; const ACol, ARow: integer);
begin
  FCol := ACol;
  FRow := ARow;
  if Assigned(FGrid.Objects[ACol, ARow]) then
    FEditingComponent := FGrid.Objects[ACol, ARow] as TSubDivisionComponent
  else
  if Assigned(ASubDivision) then
  begin
    FEditingComponent := ASubDivision.AddComponent(Grid.Objects[0, ARow] as TStratons, '+', 0, -2, true);
    Grid.Objects[ACol, ARow] := FEditingComponent;
  end;
  
  if Assigned(FEditingComponent) then
  case FQuickEditionType of
    qeNoData: EditNoData;
    qeNotDivided: EditNotDivided;
    qeDelete: EditDelete;
    qeNotVerified: EditNotVerified;
    qeVerified: EditVerified;
  end;
end;


procedure TQuickEdition.EditNotVerified;
begin
  FEditingComponent.Verified := false;
  FEditingComponent.PostToDB;
end;

procedure TQuickEdition.Perform(ASubdivision: TSubdivision; const ASelection: TGridRect);
var i, j, iIndex: integer;
begin
  iIndex := 0;
  for j := ASelection.Bottom downto ASelection.Top do
  for i := ASelection.Right downto ASelection.Left do
  begin
    Perform(ASubdivision, i, j);
    inc(iIndex);
  end;
end;

procedure TfrmEditSubDivision.sgrSubDivisionMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var iCol, iRow: integer;
begin
  sgrSubDivision.MouseToCell(X, Y, iCol, iRow);
  if  (ssLeft in Shift) and (iCol > 1) and (iRow > 2)
  and (FQuickEdition.EditionType <> qeNone) then
    FQuickEdition.Perform(CurrentSubDivision, iCol, iRow)
end;

procedure TQuickEdition.EditVerified;
begin
  FEditingComponent.Verified := true;
  FEditingComponent.PostToDB;
end;

procedure TfrmEditSubDivision.tlbtnEditUnverifiedClick(Sender: TObject);
begin
  Screen.Cursors[crSpecialCursor] := LoadCursor(HInstance, 'NOTVER');
  sgrSubDivision.Cursor := crSpecialCursor;
  FQuickEdition.EditionType := qeNotVerified;
end;

procedure TfrmEditSubDivision.tlbtnEditVerifiedClick(Sender: TObject);
begin
  Screen.Cursors[crSpecialCursor] := LoadCursor(HInstance, 'VER');
  sgrSubDivision.Cursor := crSpecialCursor;
  FQuickEdition.EditionType := qeVerified;
end;

function TfrmEditSubDivision.GetLayersReport: OleVariant;
var i, j, iLastIndex, k, iInternalIndex, iInternalLastIndex: integer;
    w: TWell;
    S: TStratons;
    C, LastC, LastAssignedC: TSubDivisionComponent;
    fLastLayer, fLastDepth: single;
    bEnd: boolean;
begin
  with sgrSubDivision do
  begin
    Result := VarArrayCreate([0, ColCount, 0, (RowCount - 5)*2 + 5], varVariant);


    iLastIndex := 4;
    for j := 5 to RowCount - 1 do
    begin
      Result[0, iLastIndex] := Cells[0, j];
      Result[0, iLastIndex + 1] := '';
      Result[1, iLastIndex + 1] := 'мощность';

      S := Objects[0, j - 1] as TStratons;
      if Assigned(S) then
        Result[ColCount, iLastIndex] := ord((S[0].AgeOfTop = 0) and (S[0].AgeOfBase = 0));
      iLastIndex := iLastIndex + 2;
    end;
    { TODO : Все ещё неправильно считается самый первый от альтитуды стратон. }
    Result[0, varArrayHighBound(Result, 2)] := 'Забой';

    for i := 2 to ColCount - 1 do
    begin
      iLastIndex := VarArrayHighBound(Result, 2) - 3;
      LastC := nil;
      c := nil;

      w := Objects[i, 0] as TWell;

      Result[i, 0] := w.AreaName;
      Result[i, 1] := w.WellNum;
      Result[i, 2] := (Objects[i, 1] as TSubDivision).TectonicBlock;
      Result[i, 3] := w.Altitude;

      for j := RowCount - 1 downto 5 do
      begin
        c := nil;
        LastC := nil;
        if iLastIndex + 3 <= varArrayHighBound(Result, 2) then Result[i, iLastIndex + 3] := null;

        if iLastIndex + 3 <= varArrayHighBound(Result, 2) then 
        begin
          if  Assigned(Objects[i, j + 1])
          and (Objects[i, j + 1] is TSubDivisionComponent) then
            LastC := Objects[i, j + 1] as TSubDivisionComponent;

          if  Assigned(Objects[i, j])
          and (Objects[i, j] is TSubDivisionComponent) then
            C := Objects[i, j] as TSubDivisionComponent;

          if Assigned(c) then
          begin
            if c.Depth > 0 then
            begin
              if Assigned(lastC) and (LastC.Depth = C.Depth) then
              begin
                Result[i, iLastIndex] := 'нр';
                Result[i, iLastIndex + 3] := c.Thickness;
              end
              else
              begin
                Result[i, iLastIndex] := c.Depth;

                if c.Thickness > 0 then
                  Result[i, iLastIndex + 3] := c.Thickness
                else
                  Result[i, iLastIndex + 3] := null;
              end;
            end
            else
            begin
              Result[i, iLastIndex] := c.SubDivisionComment;
              Result[i, iLastIndex + 3] := null;
            end;
          end
          else
          begin
            Result[i, iLastIndex] := 'отс';
            Result[i, iLastIndex + 3] := null;
          end;
        end;
        iLastIndex := iLastIndex - 2;
      end;


      if Assigned(c) and (c.Depth >= 0) then Result[i, 5] := c.Depth - w.Altitude
      else if Assigned(lastC) and (lastC.Depth >= 0) then Result[i, 5] := lastC.Depth - w.Altitude
      else Result[i, 5] := null;

      Result[i, varArrayHighBound(Result, 2)] := w.Depth;
    end;
  end;
end;

function TfrmEditSubDivision.GetReport(IncludeLayers: boolean): OleVariant;
begin
  if Not IncludeLayers then
    Result := GetSimpleReport
  else
    Result := GetLayersReport;
end;


procedure TfrmEditSubDivision.SetReportFormat(const Value: boolean);
begin
  FReportFormat := Value;
end;


{ TDecompositionResult }

constructor TDecompositionResult.Create(AParentStratons, AChildStratons,
  AExcludedStratons: TStratons);
begin
  inherited Create;
  FParentStratons := AParentStratons;
  FChildStratons := AChildStratons;
  FExcludedStratons := AExcludedStratons;
end;

{ TDecompositionResults }

function TDecompositionResults.Add(AParentStratons, AChildStratons,
  AExcludedStratons: TStratons): TDecompositionResult;
begin
  Result := TDecompositionResult.Create(AParentStratons, AChildStratons, AExcludedStratons);
  inherited Add(Result);
end;

constructor TDecompositionResults.Create;
begin
  inherited Create(true);
end;

function TDecompositionResults.GetItems(
  Index: integer): TDecompositionResult;
begin
  Result := inherited Items[Index] as TDecompositionResult;
end;

function TDecompositionResults.ItemByParentStraton(
  AParentStratons: TStratons): TDecompositionResult;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].ParentStratons.EqualTo(AParentStratons) then
  begin
    Result := Items[i];
    break;
  end;
end;

procedure TfrmEditSubDivision.GatherHierarchical;
var i, j, t, iStartRow: integer;
    strsLeft, strsRight, strsChildren, strsExcluded: TStratons;
    newSC: TSubDivisionComponent;
    sc: TSubDivision;
begin
  with sgrSubDivision do
  begin

    i := 5;
    while i < RowCount do
    begin
      strsLeft := Objects[0, i] as TStratons;
      j := i + 1;
      while j < RowCount do
      begin
        strsRight := Objects[0, j] as TStratons;

        strsChildren := TStratons.Create(false);
        strsExcluded := TStratons.Create(false);

        if strsLeft.IsParent(strsRight, strsChildren, strsExcluded) then
        begin
          // заменяем родителя на стратоны из чайлдов
          // переобзываем строку
          if strsExcluded.Count > 0 then
          begin
            NameRow(j, strsChildren, '+');
            strsRight := strsChildren;

            // изменяем структуру по всей строке
            for t := 1 to ColCount - 2 do
            if Assigned(Objects[t, j]) then
            begin
              TSubdivisionComponent(Objects[t, j]).Stratons.Assign(TStratons(Objects[0, j]));
              TSubdivisionComponent(Objects[t, j]).Divider := '+';
            end;

            // если остались дети того же родителя, которыене вошли в es - нужно их добавить
            // добавляем строку с остатком стратонов
            NameRow(i, strsExcluded, '+');
            strsLeft := strsExcluded;

            // добавляем в структуры Content всех бывших до этого
            // скважин новый стратон с остатком
            for t := 1 to ColCount - 2 do
            if Assigned(Objects[t, i]) then
            begin
              newSC := Objects[t, i] as TSubDivisionComponent;
              newSC.Stratons.Assign(strsExcluded);
              newSC.SubDivisionCommentID := 1;
              newSc.SubDivisionComment := 'нр';
              newSC.Divider := '+';

              Cells[t, i] := newSC.ListDepth;
              Objects[t, i] := newSC;
            end;
          end
          else
          begin
            NameRow(i, strsChildren, '+');
            strsLeft := strsChildren;
            // изменяем структуру по всей строке
            for t := 1 to ColCount - 2 do
            if Assigned(Objects[t, i]) then
            begin
              TSubdivisionComponent(Objects[t, i]).Stratons.Assign(TStratons(Objects[0, i]));
              TSubdivisionComponent(Objects[t, i]).Divider := '+';
            end
            else if Assigned(Objects[t, j]) then
            begin
              Objects[t, i] := Objects[t, j];
              Cells[t, i] := (Objects[t, i] as TSubdivisionComponent).ListDepth;
            end;
          end;
        end
        else if strsRight.IsParent(strsLeft, strsChildren, strsExcluded) then
        begin
          if strsExcluded.Count > 0 then
          begin
            // заменяем родителя на стратоны из чайлдов
            // переобзываем строку
            NameRow(i, strsChildren, '+');
            strsLeft := strsChildren;
            strsRight := strsExcluded;

            // изменяем структуру по всей строке
            for t := 1 to ColCount - 2 do
            if Assigned(Objects[t, i]) then
            begin
              TSubdivisionComponent(Objects[t, i]).Stratons.Assign(TStratons(Objects[0, i]));
              TSubdivisionComponent(Objects[t, i]).Divider := '+';
            end;

            // если остались дети того же родителя, которыене вошли в es - нужно их добавить
            // добавляем строку с остатком стратонов
            NameRow(j, strsExcluded, '+');

            // добавляем в структуры Content всех бывших до этого
            // скважин новый стратон с остатком
            for t := 1 to ColCount - 2 do
            if Assigned(Objects[t, j]) then
            begin
              newSC := Objects[t, j] as TSubDivisionComponent;
              newSC.Stratons.Assign(strsExcluded);

              newSC.SubDivisionCommentID := 1;
              newSc.SubDivisionComment := 'нр';
              newSC.Divider := '+';

              Cells[t, j] := newSC.ListDepth;
              Objects[t, j] := newSC;
            end;
          end
          else
          begin
            NameRow(j, strsChildren, '+');
            strsLeft := strsChildren;
            // изменяем структуру по всей строке
            for t := 1 to ColCount - 2 do
            if Assigned(Objects[t, j]) then
            begin
              TSubdivisionComponent(Objects[t, j]).Stratons.Assign(TStratons(Objects[0, j]));
              TSubdivisionComponent(Objects[t, j]).Divider := '+';
            end
            else if Assigned(Objects[t, i]) then
            begin
              Objects[t, j] := Objects[t, i];
              Cells[t, j] := (Objects[t, j] as TSubdivisionComponent).ListDepth;
            end;
          end;
        end
        else
        begin
          strsChildren.Free;
          strsExcluded.Free;
        end;


        if strsLeft.Includes(strsRight) then
        begin
          strsLeft.Exclude(strsRight);
          NameRow(i, strsLeft, '+');

          // добавляем в структуры Content всех бывших до этого
          // скважин новый стратон с остатком
          for t := 2 to ColCount - 2 do
          begin
            if Assigned(Objects[t, i]) then
            begin
              newSC := Objects[t, i] as TSubDivisionComponent;
              newSC.Stratons.Assign(strsLeft);
              newSC.SubDivisionCommentID := 1;
              newSc.SubDivisionComment := 'нр';
              newSC.Divider := '+';

              if (strsLeft.Count > 0) and (strsRight.Count > 0) then
              begin
                if strsLeft.Items[0].AgeOfBase > strsRight.Items[0].AgeOfBase then
                  Cells[t, i] := newSC.ListDepth
                else
                  Cells[t, i] := newSC.SubDivisionComment;
              end
              else Cells[t, i] := newSC.ListDepth;

              Objects[t, i] := newSC;

              if not Assigned(Objects[t, j]) then
              begin
                sc := TSubDivision(Objects[t, 1]);

                newSC := sc.Content.Insert(0) as TSubDivisionComponent;
                newSC.Assign(Objects[t, i] as TSubDivisionComponent);

                newSC.SubDivisionCommentID := 1;
                newSc.SubDivisionComment := 'нр';
                newSC.Divider := '+';

                Cells[t, j] := newSC.ListDepth;
                Objects[t, j] := newSC;
              end;
            end;
          end;
        end
        else
        if strsRight.Includes(strsLeft) then
        begin
          strsRight.Exclude(strsLeft);
          NameRow(j, strsRight, '+');

          for t := 2 to ColCount - 2 do
          begin
            if Assigned(Objects[t, j]) then
            begin
              newSC := Objects[t, j] as TSubDivisionComponent;
              newSC.Stratons.Assign(strsRight);
              newSC.SubDivisionCommentID := 1;
              newSc.SubDivisionComment := 'нр';
              newSC.Divider := '+';


              if (strsLeft.Count > 0) and (strsRight.Count > 0) then
              begin
                if strsRight.Items[0].AgeOfBase > strsLeft.Items[0].AgeOfBase then
                  Cells[t, j] := newSC.ListDepth
                else
                  Cells[t, j] := newSC.SubDivisionComment;
              end
              else Cells[t, j] := newSC.ListDepth;

              if not Assigned(Objects[t, i]) then
              begin
                sc := TSubDivision(Objects[t, 0]);

                newSC := sc.Content.Insert(0) as TSubDivisionComponent;
                newSC.Assign(Objects[t, j] as TSubDivisionComponent);

                newSC.SubDivisionCommentID := 1;
                newSc.SubDivisionComment := 'нр';
                newSC.Divider := '+';

                Cells[t, i] := newSC.ListDepth;
                Objects[t, i] := newSC;
              end;
            end;
          end;
        end;

        inc(j);
      end;
      inc(i);
    end;
  end;



            // поискать в результатах разложения
            {else if ReportFormat and (iStartCol > 2) then
            begin
              dr := DecompositionResults.ItemByParentStraton(Content[k].Stratons);
              // если нашли результат декомпозиции
              if Assigned(dr) then
              begin
                Content[k].Stratons.Assign(dr.ChildStratons);

                newSC := Content.Insert(k) as  TSubDivisionComponent;
                newSC.Assign(Content[k]);
                newSC.Stratons.Assign(dr.ExcludedStratons);
              end
              else
              begin


              end;

              // если стратон в таблице - родитель новых стратонов
              // родителя - удалить
              // новые добавить
              begin
                ChildStratons := TStratons.Create(false);
                es := TStratons.Create(false);
                if TStratons(Objects[0, j]).IsParent(Content[k].Stratons, ChildStratons, es) then
                begin
                  // сохраняем результаты разложения
                  DecompositionResults.Add(TStratons(Objects[0, j]), ChildStratons, es);


                  // заменяем родителя на стратоны из чайлдов
                  // переобзываем строку
                  NameRow(j, ChildStratons, '+');

                  // изменяем структуру по всей строке
                  for t := 1 to ColCount - 2 do
                  if Assigned(Objects[t, j]) then
                    TSubdivisionComponent(Objects[t, j]).Stratons.Assign(TStratons(Objects[0, j]));

                  // если остались дети того же родителя, которыене вошли в es - нужно их добавить
                  // добавляем строку с остатком стратонов

                  RowCount  := RowCount + 1; //ord(sgrSubDivision.RowCount > 5);
                  iStartRow := RowCount - 1;
                  NameRow(iStartRow, es, '+');

                  // добавляем в структуры Content всех бывших до этого
                  // скважин новый стратон с остатком
                  for t := 1 to ColCount - 2 do
                  if Assigned(Objects[t, j]) then
                  begin
                    newSC := TSubdivisionComponent(Objects[t, j]).Collection.Insert(TSubdivisionComponent(Objects[t, j]).Index) as TSubDivisionComponent;
                    newSC.Assign(TSubdivisionComponent(Objects[t, j]));
                    newSC.Stratons.Assign(es);

                    newSC.SubDivisionCommentID := 1;
                    newSc.SubDivisionComment := 'нр';

                    Cells[t, RowCount - 1] := Cells[t, j];
                    Objects[t, RowCount - 1] := newSC;
                  end;

                  if  (Content[k].Depth > -1)
                  and ((Content[k].SubDivisionCommentID = 0)
                  or  (((k = 0) or ((k > 0)
                  and (Content[k - 1].Depth <> (Content[k].Depth)))))) then
                    Cells[iCurCol, iStartRow] := trim(Format('%6.2f', [Content[k].Depth]))
                  else
                    Cells[iCurCol, iStartRow] := Content[k].SubDivisionComment;
                  Objects[iCurCol, iStartRow] := Content[k];

                  k := k - 1;
                  Found := true;
                  break;
                end
                else if Content[k].Stratons.IsParent(TStratons(Objects[0, j]), ChildStratons, es) then
                begin
                  DecompositionResults.Add(TStratons(Objects[0, j]), ChildStratons, es);
                  // заменяем родителя на стратоны из чайлдов
                  // переобзываем строку
                  NameRow(j, ChildStratons, '+');

                  // изменяем структуру по всей строке
                  for t := 1 to ColCount - 2 do
                  if Assigned(Objects[t, j]) then
                    TSubdivisionComponent(Objects[t, j]).Stratons.Assign(TStratons(Objects[0, j]));

                  // если остались дети того же родителя, которыене вошли в es - нужно их добавить
                  // добавляем строку с остатком стратонов
                  RowCount  := RowCount + 1; //ord(sgrSubDivision.RowCount > 5);
                  iStartRow := RowCount - 1;
                  NameRow(iStartRow, es, '+');

                  // добавляем в структуры Content всех бывших до этого
                  // скважин новый стратон с остатком
                  for t := 1 to ColCount - 2 do
                  if Assigned(Objects[t, j]) then
                  begin
                    newSC := TSubdivisionComponent(Objects[t, j]).Collection.Insert(TSubdivisionComponent(Objects[t, j]).Index) as TSubDivisionComponent;
                    newSC.Assign(TSubdivisionComponent(Objects[t, j]));
                    newSC.Stratons.Assign(es);

                    newSC.SubDivisionCommentID := 1;
                    newSc.SubDivisionComment := 'нр';

                    Cells[t, RowCount - 1] := Cells[t, j];
                    Objects[t, RowCount - 1] := newSC;
                  end;

                  if  (Content[k].Depth > -1)
                  and ((Content[k].SubDivisionCommentID = 0)
                  or  (((k = 0) or ((k > 0)
                  and (Content[k - 1].Depth <> (Content[k].Depth)))))) then
                    Cells[iCurCol, iStartRow] := trim(Format('%6.2f', [Content[k].Depth]))
                  else
                    Cells[iCurCol, iStartRow] := Content[k].SubDivisionComment;
                  Objects[iCurCol, iStartRow] := Content[k];

                  k := k - 1;
                  Found := true;
                  break;
                end
                else
                begin
                  ChildStratons.Free;
                  es.Free;
                end;
              end;
            end;}


end;

end.
