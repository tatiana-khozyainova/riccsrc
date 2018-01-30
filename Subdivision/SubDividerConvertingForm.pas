unit SubDividerConvertingForm;

interface

uses
  Windows, Messages, SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs, SubDividerCommonObjects, OleServer,
  ExtCtrls, ComCtrls, StdCtrls, Mask, ToolEdit, SubDividerWellConfirm,
  Grids, SubDividerEditFrame, Buttons, Menus, ToolWin, ImgList, ShellApi,
  Excel2000, Variants, ExcelXP;


const

  WM_WELL_ADDED = WM_APP + 333;
  WM_NEW_STRATON = WM_APP + 444;
  WM_INIT_PROGRESS = WM_APP + 250;

type
  TReadSubDivision = class(TSubDivision)
  public
    ColumnIndex: integer;
    procedure AddComponent(AStratons: TStratons; AEdge: string; ADepth: string); overload;
    procedure AddComponent(AStraton, ANextStraton: TStraton; AEdge: string; ADepth: string); overload;
  end;

  TReadWell = class(TWell)
  private
    FAccepted: boolean;
  public
    StartColumnIndex: integer;
    property    Accepted: boolean read FAccepted write FAccepted;
    procedure   ReadWell(ATectonicBlock: string);
  end;

  PReadWell = ^TReadWell;

  TDataFile = class;

  TReadWells = class(TWells)
  private
    function GetItem(const Index: integer): TReadWell;
  protected
    FDataFile:  TDataFile;
  public
    function    AddWell(AColIndex: integer; AAreaName, AWellNum: string; const AAltitude, ADepth: single): TReadWell; reintroduce;
    property    Items[const Index: integer]: TReadWell read GetItem;
    constructor Create(ADataFile: TDataFile);
  end;

  TSplitBy  = (sbNone, sbPlus, sbMinus);

  TStratonsAtRow = class
  public
    Row:      integer;
    Name:     string;
    SplitBy:  TSplitBy;
    Stratons: TStratons;
    constructor Create;
    function    ReportFoundStratons(Full: boolean = false): string;
    destructor  Destroy; override;
  end;

  TStratonsAtRowArray = array of TStratonsAtRow;

  TDataFile = class(TCollectionItem)
  private
    FShortFileName: string;
    FWells: TReadWells;
    FirstStraton: string;
    FPrepared: boolean;
    procedure  ReadStratonsCol(NewStratons: TStratons; FirstString, S: string);
    procedure  RemoveEmptyCols;
    procedure  SetPrepared(const Value: boolean);
    procedure  PrepareDataFile;
    procedure  UnprepareDataFile;
  protected
    wb: _WorkBook;
    vbc: OleVariant;
    FAreaRow,  FWellNumRow, FPropRow, FAltRow, FDepthRow: integer;
    FStratonsCol1, FStratonsCol2: integer;
  public
    Stratons:   TStratonsAtRowArray;
    property    Prepared: boolean read FPrepared write SetPrepared;
    procedure   ReadStratons;
    function    ErrorsCount: integer;
    procedure   MakeTable(ASgr: TStringGrid);
    procedure   ReadFile(out WellFound: variant);
    procedure   FreeStratons;
    function    StratonsAtRow(const ARow: integer; out ASplitBy: TSplitBy): TStratons;
    procedure   AddStratonsAtRow(ARow: integer; AName: string; AStratons: TStratons; ASplitBy: TSplitBy);
    property    ShortFileName: string read FShortFileName;
    property    Wells: TReadWells read FWells write FWells;
    constructor Create(Collection: TCollection); override;
    destructor  Destroy; override;
  end;

  TDataFiles = class(TCollection)
  private
    FFolderName, FCopiesFolderName: string;
    function     GetItem(const Index: integer): TDataFile;
  protected
    FExcel:      TExcelApplication;
  public
    property     FolderName: string read FFolderName write FFolderName;
    property     CopiesFolderName: string read FCopiesFolderName write FCopiesFolderName;
    property     Items[const Index: integer]: TDataFile read GetItem;default;
    function     DataFileByName(const AFileName: string): TDataFile;
    procedure    ReadStratons;
    function     AddDataFile(const AShortFileName: string): TDataFile;
    constructor  Create(const AFolderName,
                        ACopiesFolderName: string;
                        AExcel: TExcelApplication); reintroduce;
    destructor   Destroy; override;
  end;

  PDataFile = ^TDataFile;


  TfrmConvert = class(TForm)
    Excel: TExcelApplication;
    gbxDirectory: TGroupBox;
    pnlButtons: TPanel;
    gbxContent: TGroupBox;
    pnlWells: TPanel;
    pnlProperties: TPanel;
    btnClear: TButton;
    pgctlFolderContent: TPageControl;
    tshFiles: TTabSheet;
    tshWells: TTabSheet;
    pnl: TPanel;
    lwFiles: TListView;
    pnlStratons: TPanel;
    pnlFileName: TPanel;
    sgrStratons: TStringGrid;
    pnl2: TPanel;
    btnClose: TButton;
    pnlWellProps: TPanel;
    edtFolder: TDirectoryEdit;
    pnlDescription: TPanel;
    stxtError: TStaticText;
    stxtWarning: TStaticText;
    frmEditSubDivision1: TfrmEditSubDivision;
    gbxWells: TGroupBox;
    lwWells: TListView;
    pnlButton: TPanel;
    prg: TProgressBar;
    pmnSelect: TPopupMenu;
    SelectAll: TMenuItem;
    UnselectAll: TMenuItem;
    SelectAccepted: TMenuItem;
    SelectNonAccepted: TMenuItem;
    imgList: TImageList;
    tlbr: TToolBar;
    tlbtnSelect: TToolButton;
    tlbtnReload: TToolButton;
    pmnReload: TPopupMenu;
    ReloadAll: TMenuItem;
    ReloadNonAccepted: TMenuItem;
    ReloadSelected: TMenuItem;
    sbtnShow: TSpeedButton;
    sbtnToDB: TSpeedButton;
    pnlFileSave: TPanel;
    flnmSaveFile: TFilenameEdit;
    sbtnSaveErrors: TSpeedButton;
    rgrpSaveOpts: TRadioGroup;
    procedure edtFolderAfterDialog(Sender: TObject; var Name: String;
      var Action: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lwFilesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure pgctlFolderContentChange(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure sgrStratonsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sgrStratonsDblClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure SelectAllClick(Sender: TObject);
    procedure UnselectAllClick(Sender: TObject);
    procedure SelectAcceptedClick(Sender: TObject);
    procedure SelectNonAcceptedClick(Sender: TObject);
    procedure ReloadAllClick(Sender: TObject);
    procedure ReloadNonAcceptedClick(Sender: TObject);
    procedure ReloadSelectedClick(Sender: TObject);
    procedure sbtnToDBClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbtnSaveErrorsClick(Sender: TObject);
    procedure flnmSaveFileChange(Sender: TObject);
  private
    { Private declarations }
    dfsCommon: TDataFiles;
    FilterRegs: TRegions;
    sCopiesFolderName: string;
    FActiveDataFile: TDataFile;
    FErrorCount: integer;
    procedure SetActiveDataFile(Value: TDataFile);
    procedure SetErrorCount(Value: integer);
    procedure ClearListView(lsw: TListView);
    procedure ClearTable;
    procedure Clear;
    procedure WellAdded(var AMessage: TMessage); message WM_WELL_ADDED;
    procedure SmbNew(var AMessage: TMessage); message WM_NEW_STRATON;
    procedure InitProgress(var AMessage: TMessage); message WM_INIT_PROGRESS;
    procedure ValidateToolButton(AToolButton: TToolButton; AAction: TMenuItem);
    procedure SetEqualCaptions(APmn: TPopupMenu);     
  public
    { Public declarations }
    property  ActiveDataFile: TDataFile read FActiveDataFile write SetActiveDataFile;
    property  ErrorCount: integer read FErrorCount write SetErrorCount;
  end;

var
  frmConvert: TfrmConvert;

implementation

uses SubDividerCommon, ClientCommon, SubDividerStratonVerifyingForm;

{$R *.DFM}


procedure TReadSubDivision.AddComponent(AStraton, ANextStraton: TStraton; AEdge: string; ADepth: string);
var fReadDepth: single;
    C: TSubDivisionComponent;
begin
  // проверяем - передается правильная глубина или свойство границы
  try
    fReadDepth := StrToFloat(ADepth);
  except
  on EConvertError do
  begin
    ADepth := Trim(RusTransLetter(ADepth));

    ADepth := StringReplace(ADepth, ',', '', [rfReplaceAll]);
    ADepth := StringReplace(ADepth, '.', '', [rfReplaceAll]);

    ADepth := AnsiLowerCase(ADepth);

    if ADepth = 'нр' then
      fReadDepth := LastDepth
    else fReadDepth := -2;

    AEdge  := ADepth;
  end;
  end;

  // добавляем первый компонент
  C := Content.Add as TSubDivisionComponent;
  with C do
  begin
    Stratons.AddStratonRef(AStraton);
    Depth  := fReadDepth;
    Stratons.AddStratonRef(ANextStraton);
    Divider := '-';
    if trim(AEdge)<>'' then
       c.SubDivisionComment := AEdge;
  end;

  // добавляем второй компонент
  {C := Content.Add as TSubDivisionComponent;
  with C do
  begin
    Straton := ANextStraton;
    Depth  := fReadDepth;
    {if trim(AEdge)<>'' then
       c.AddComment(AEdge);
  end;}
end;


procedure TReadSubDivision.AddComponent(AStratons: TStratons; AEdge: string; ADepth: string);
var fDepth: single;
    C: TSubDivisionComponent;
    i: integer;
begin
  // проверяем - передается правильная глубина или свойство границы
  try
    fDepth := StrToFloat(ADepth);
  except
  on EConvertError do
  begin
    ADepth := Trim(RusTransLetter(ADepth));

    ADepth := StringReplace(ADepth, ',', '', [rfReplaceAll]);
    ADepth := StringReplace(ADepth, '.', '', [rfReplaceAll]);

    ADepth := AnsiLowerCase(ADepth);


    if ADepth = 'нр' then
      fDepth := LastDepth
    else fDepth := -2;
    AEdge  := ADepth;
  end;
  end;

  // добавляем стратоны
  if GatherComponents then
  begin
    C := Content.Add as TSubDivisionComponent;
    with C do
    begin
      for i := 0 to AStratons.Count - 1 do
        Stratons.AddStratonRef(AStratons[i]);
      Depth  := fDepth;
      Divider := '+';
    end;
  end
  else
  for i := 0 to AStratons.Count - 1 do
  begin
    C := Content.Add as TSubDivisionComponent;
    with C do
    begin
      Stratons.AddStratonRef(AStratons[i]);
      Depth  := fDepth;
      Divider := '+';
    end;
  end;

  if trim(AEdge)<>'' then
     C.SubDivisionComment := AEdge;

  LastDepth := fDepth;
end;



procedure   TReadWell.ReadWell(ATectonicBlock: string);
var i, iLB, iHB: integer;
    sD: TReadSubDivision;
    df: TDataFile;
    S: TStratons;
    sEdge, sDepth, sTemp: string;
    sb: TSplitBy;
begin
  df  := TReadWells(Collection).FDataFile;
  iLB := df.FAltRow + 1;
  iHB := df.FDepthRow - 1;

  sD := TReadSubDivision(SubDivisions.AddSubDivision(ATectonicBlock));

  for i := iHB downto iLB do
  begin
    sEdge := (df.Collection as TDataFiles).FExcel.Cells.Item[i, StartColumnIndex];

    sTemp := Trim(RusTransLetter(sEdge));

    sTemp := StringReplace(sTemp, ',', '', [rfReplaceAll]);
    sTemp := StringReplace(sTemp, '.', '', [rfReplaceAll]);

    sTemp := AnsiUpperCase(sTemp);

{    if  (sTemp <> 'ОТС')
    and (sTemp <> 'НД')
    and (sTemp <> 'НВ')
    and (sTemp <> '') then}
    if  (sTemp <> '')
    and (sTemp <> 'ОТС') then
    begin
      sDepth := sEdge;
      S := df.StratonsAtRow(i, sb);
      if (sb = sbMinus) and (S.Count = 2) then sd.AddComponent(S[0], S[1], AnsiLowerCase(sEdge), sDepth)
      else sd.AddComponent(S, sEdge, sDepth);
    end;
  end;
end;

constructor TStratonsAtRow.Create;
begin
  inherited Create;
end;

function    TStratonsAtRow.ReportFoundStratons(Full: boolean = false): string;
var i: integer;
    sSplitter: char;
begin
  Result := ''; sSplitter := char(32);

  case SplitBy of
  sbPlus: sSplitter := '+';
  sbMinus: sSplitter := '-';
  end;

  if not Full then
  for i := 0 to Stratons.Count - 1 do
    Result := Result + sSplitter +  Stratons[i].StratonIndex
  else
  for i := 0 to Stratons.Count - 1 do
    Result := Result + ';' +  Stratons[i].ListStraton(sloIndexName);

  if trim(Result) <> '' then
     Result := copy(Result, 2, Length(Result));
end;

destructor  TStratonsAtRow.Destroy;
begin
  Stratons.Free;
  inherited Destroy;
end;

constructor TReadWells.Create(ADataFile: TDataFile);
begin
  inherited Create(TReadWell);
  FDataFile := ADataFile;
end;


function    TReadWells.GetItem(const Index: integer): TReadWell;
begin
  Result := TReadWell(inherited Items[Index]);
end;


function TReadWells.AddWell(AColIndex: integer; AAreaName, AWellNum: string; const AAltitude, ADepth: single): TReadWell;
var Found: variant;
procedure ShowConfirmForm;
begin
  with frmWellConfirm do
  if ShowModal = mrOk then
  begin
    Result := TReadWell(inherited AddWell(cmbxArea.Text, cmbxWellNum.Text,
                                          AAreaName, AWellNum,
                                          AAltitude, ADepth, Found));
    Result.Accepted := (Result.WellUIN > 0);
  end
  else
  begin
    Result := TReadWell(inherited AddWell(AAreaName, AWellNum, AAltitude, ADepth));
    Result.Accepted := false;
  end;
end;

begin
  try
    Result := inherited AddWell(AAreaName, AWellNum, AAreaName, AWellNum, AAltitude, ADepth, Found) as TReadWell;
    Result.Accepted := (Result.WellUIN > 0);
  except
  on E: EWellNotFound do
  begin
    frmWellConfirm.ShowProblem(E.Message, AAreaName, AWellNum);
    ShowConfirmForm;
  end;
  on E: EWellFoundByAltitude do
  begin
    frmWellConfirm.ShowProblem(E.Message, Found);
    ShowConfirmForm;
  end;
  end;

  if Assigned (Result) then
    Result.StartColumnIndex := AColIndex;
end;

function   TDataFile.StratonsAtRow(const ARow: integer; out ASplitBy: TSplitBy): TStratons;
var i: integer;
begin
  Result := nil; ASplitBy := sbNone;
  for i := 0 to High(Stratons) do
  if Stratons[i].Row = ARow then
  begin
    Result := Stratons[i].Stratons;
    ASplitBy := Stratons[i].SplitBy;
    break;
  end;
end;


procedure   TDataFile.AddStratonsAtRow(ARow: integer; AName: string; AStratons: TStratons; ASplitBy: TSplitBy);
var iHB: integer;
begin
  iHB := Length(Stratons);
  inc(iHB);
  SetLength(Stratons, iHB);
  Stratons[iHB - 1] := TStratonsAtRow.Create;
  with Stratons[iHB - 1] do
  begin
    Row := ARow;
    Stratons := AStratons;
    Name := AName;
    SplitBy := ASplitBy;
  end;
end;

constructor TDataFile.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FWells := TReadWells.Create(Self);
end;

procedure TDataFile.ReadStratonsCol(NewStratons: TStratons; FirstString, S: string);
var iDepth: integer;
    sTmp: string;
begin
  iDepth := 1; sTmp := S;
  while not (AllStratons.FirstStratonsOfIndex(sTmp, NewStratons))
        and  (iDepth<=Length(FirstString)) do
  begin
    sTmp := Copy(FirstString, 1, iDepth) + S;
    inc(iDepth);
  end;

  //if not AllStratons.StratonsOfIndex(sTmp, NewStratons) then
  //raise  EStratonNotFound.Create('Не удалось найти стратон ' + sTmp);
end;

function   TDataFile.ErrorsCount: integer;
var i: integer;
begin
  Result := 0;
  for i := 0 to High(Stratons) do
  if (Stratons[i].Stratons.Count = 0)
  or ((Stratons[i].Stratons.Count = 2) and (Stratons[i].SplitBy in [sbNone]))
  or ((Stratons[i].Stratons.Count > 2) and (Stratons[i].SplitBy in [sbNone, sbMinus])) then
  {if  (Stratons[i].Stratons.Count <> 1)
  and (Stratons[i].SplitBy in [sbNone]) then}
    inc(Result);
end;

procedure  TDataFile.ReadStratons;
var i, j: integer;
    Str: TStratons;
    Arr: TStrArr;
begin
  Prepared := true;
  SetLength(Arr, 0);

  SendMessage(frmConvert.Handle, WM_INIT_PROGRESS, FAltRow + 1, FDepthRow + 1);
  with (Collection as TDataFiles) do
  for i := FDepthRow - 1 downto FAltRow + 1 do
  begin
    Str := TStratons.Create(false);

    FirstStraton := FullTrim(FExcel.Cells.Item[i, FStratonsCol1]);

    if AllStratons.FirstStratonsOfIndex(FirstStraton, Str) then
      AddStratonsAtRow(i, FirstStraton, Str, sbNone)
    else
    if pos('-', FirstStraton) > 0 then
    begin
      // разделяем
      Arr := Split(FirstStraton, '-');
      AllStratons.FirstStratonsOfIndex(Arr[0], Str);
      ReadStratonsCol(Str, Arr[0], Arr[1]);
      AddStratonsAtRow(i, FirstStraton, Str, sbMinus);
    end
    else
    if pos('+', FirstStraton) > 0 then
    begin
      // разделяем
      Arr := Split(FirstStraton, '+');
      AllStratons.FirstStratonsOfIndex(Arr[0], Str);
      for j := 1 to High(Arr) do
        ReadStratonsCol(Str, Arr[0], Arr[j]);
      AddStratonsAtRow(i, FirstStraton, Str, sbPlus);
    end
    // если ничего не находим, то тоже добавляем
    else AddStratonsAtRow(i, FirstStraton, Str, sbNone);
    SendMessage(frmConvert.Handle,WM_NEW_STRATON, 0, 0);
  end;
  Prepared := false;
end;

procedure  TDataFile.RemoveEmptyCols;
var i: integer;
    S: string;
begin
  for i := 200 downto 3 do
  with (Collection as TDataFiles) do
  begin
    S := FExcel.Cells.Item[FWellNumRow, i].Value;
    if trim(S) = '' then FExcel.Run('DeleteColumn', i);
  end;
end;

procedure  TDataFile.PrepareDataFile;
begin
  with Collection as TDataFiles do
  begin
    // открываем файл
    wb:=FExcel.Workbooks.Add(FolderName + '\'+ ShortFileName,0);
    // снимаем закрепление областей
    FExcel.Visible[0] := true;
    FExcel.ActiveWindow.FreezePanes := false;
    FExcel.ActiveWindow.SplitColumn := 0;
    FExcel.ActiveWindow.SplitRow := 0;
    // задаем координаты строк
    FAreaRow    := 2;
    FWellNumRow := 3;
    FPropRow    := 4;
    FAltRow     := 5;
    FDepthRow   := FExcel.Cells.Item[1, 1].CurrentRegion.Rows.Count;
    FStratonsCol1 := 1;
    FStratonsCol2 := 2;

    // добавляем макросы
    vbc:=wb.VBProject.VBComponents.Add(1);
    vbc.Name := 'macro';
    vbc.Codemodule.AddFromString('Sub DeleteColumn(Index as integer)'+#13+#10+
                                 'Columns(Index).Delete'+#13+#10+
                                 'End Sub');
 end;
end;

procedure  TDataFile.UnprepareDataFile;
begin
  with Collection as TDataFiles do
  begin
    // если все нормально
    // удаляем макросы
    wb.VBProject.VBComponents.Remove(wb.VBProject.VBComponents.Item('macro'));
    // сохраняем в папку прочитанных
    //wb.Saved[0] := false;
    wb.Close(false,null,false,0);
    //DeleteFile(FileName);
    //RenameFile(sNewFileName, FileName);
  end;
end;

procedure  TDataFile.SetPrepared(const Value: boolean);
begin
  if Value <> FPrepared then
  begin
    FPrepared := Value;
    if FPrepared then PrepareDataFile
    else UnprepareDataFile;
  end
end;

procedure TDataFile.MakeTable(ASgr: TStringGrid);
var i, iHB, j: integer;
begin
  iHB := High(Stratons);
  ASgr.RowCount  := iHB + 2;
  ASgr.Visible   := true; j := 1;
  for i := iHB downto 0 do
  with ASgr do
  begin
    Objects[0, j] := Stratons[i];
    Cells[0, j] := IntToStr(j);
    Cells[1, j] := Stratons[i].Name;
    Cells[2, j] := Stratons[i].ReportFoundStratons;
    inc(j);
  end;
end;

procedure TDataFile.FreeStratons;
var i: integer;
begin
  for i := 0 to High(Stratons) do
  if Assigned(Stratons[i]) then
     Stratons[i].Free;
end;

procedure TDataFile.ReadFile(out WellFound: variant);
var i, iHB, iPreCount: integer;
    sAreaName, sWellNum, sProperty: string;
    fAltitude, fDepth: single;
    W: TReadWell;
begin
  Prepared := true;
  // удаляем пустые столбцы
  // RemoveEmptyCols;
  // читаем скважины
  iHB := (Collection as TDataFiles).FExcel.Cells.Item[FWellNumRow, 2].CurrentRegion.Columns.Count;
  SendMessage(frmConvert.Handle, WM_INIT_PROGRESS, FStratonsCol2, iHB + 1);
  for i := FStratonsCol2 + 1 to iHB do
  begin
    sAreaName := FullTrim((Collection as TDataFiles).FExcel.Cells.Item[FAreaRow, i].Value);
    sWellNum  := FullTrim((Collection as TDataFiles).FExcel.Cells.Item[FWellNumRow, i].Value);
    sProperty := FullTrim((Collection as TDataFiles).FExcel.Cells.Item[FPropRow, i].Value);

    try
      fAltitude  := (Collection as TDataFiles).FExcel.Cells.Item[FAltRow, i].Value;
    except
      fAltitude := 0;
    end;

    try
      fDepth     := (Collection as TDataFiles).FExcel.Cells.Item[FDepthRow, i].Value;
    except
      fDepth  := 0;
    end;
    iPreCount := Wells.Count + 1;
    W := Wells.AddWell(i, sAreaName, sWellNum, fAltitude, fDepth);
    SendMessage(frmConvert.Handle, WM_WELL_ADDED, W.Index, ord(Wells.Count = iPreCount));
    sProperty := AnsiLowerCase(RusTransLetter(sProperty));
    {if W.Accepted then} W.ReadWell(sProperty);
  end;

  Prepared := false;
end;


destructor  TDataFile.Destroy;
begin
  FreeStratons;
  FWells.Free;
  inherited Destroy;
end;

constructor  TDataFiles.Create(const AFolderName, ACopiesFolderName: string;
                               AExcel: TExcelApplication);
var f: integer;
    Found: TSearchRec;
begin
  inherited Create(TDataFile);


  FFolderName := AFolderName;
  FCopiesFolderName := ACopiesFolderName;

  FExcel := AExcel;
  // проходим по всем файлам
  // и создаем их
  f:=FindFirst(AFolderName + '\*.xls', 0, Found);
  while f=0 do
  begin
     AddDataFile(Found.Name);
     f:=FindNext(Found);
  end;
  FindClose(Found);
end;

function     TDataFiles.GetItem(const Index: integer): TDataFile;
begin
  Result := TDataFile(inherited Items[Index]);
end;

function     TDataFiles.DataFileByName(const AFileName: string): TDataFile;
var i: integer;
begin
  Result := nil; 
  for i := 0 to Count - 1 do
  if Items[i].ShortFileName = AFileName then
  begin
    Result := Items[i];
    break;
  end;
end;


function     TDataFiles.AddDataFile(const AShortFileName: string): TDataFile;
begin
  Result := Add as TDataFile;
  with Result do
    FShortFileName := AShortFileName;
end;

procedure TDataFiles.ReadStratons;
var i: integer;
begin
  for i := 0 to Count - 1 do
    Items[i].ReadStratons;
end;

destructor   TDataFiles.Destroy;
var i: integer;
begin
  for i := Count - 1 downto 0 do
    Items[i].Free;
  inherited Destroy;
end;


procedure TfrmConvert.edtFolderAfterDialog(Sender: TObject;
  var Name: String; var Action: Boolean);
var i: integer;
    lstItem: TListItem;
    P: PDataFile;
begin
  // создаем объект
  if not Assigned(dfsCommon)
     or (Assigned(dfsCommon)
         and (dfsCommon.FolderName <> Name)) then
  begin
    Clear;

    dfsCommon := TDataFiles.Create(Name, sCopiesFolderName, Excel);
    Update;
    for i := 0 to dfsCommon.Count - 1 do
    begin
      dfsCommon[i].ReadStratons;
      lstItem := lwFiles.Items.Add;
      lstItem.Caption := dfsCommon[i].ShortFileName;
      New(P);
      P^ := dfsCommon[i];
      lstItem.Data := P;
      Update;
    end;
    Action := true;
  end
  else Action := false;
end;

procedure TfrmConvert.FormCreate(Sender: TObject);

begin
  if not Assigned(frmWellConfirm) then frmWellConfirm := TfrmWellConfirm.Create(Self);
  frmVerifyStratons := TfrmVerifyStratons.Create(Self);
  sCopiesFolderName := ExtractFilePath(ParamStr(0)) + 'Made';
  with sgrStratons do
  begin
    Cells[0, 0] := '№';
    Cells[1, 0] := 'Что искали';
    Cells[2, 0] := 'Что найдено';
    Cells[3, 0] := 'Изменить';
  end;

  frmEditSubDivision1.ReadOnly := true;
  SetEqualCaptions(pmnSelect);
  SetEqualCaptions(pmnReload);
  flnmSaveFile.InitialDir := ExtractFilePath(ParamStr(0));
  sbtnSaveErrors.Enabled := false;
end;

procedure TfrmConvert.SetErrorCount(Value: integer);
begin
  if Value <> FErrorCount then
    FErrorCount := Value;
  tshWells.TabVisible := (FErrorCount = 0);
end;


procedure TfrmConvert.SetActiveDataFile(Value: TDataFile);
var i: integer;
    lstItem: TListItem;
    P: PReadWell;
begin
  if Value <> FActiveDataFile then
  begin
    if Assigned(FilterRegs) then
    begin
      FilterRegs.Free;
      FilterRegs := nil;
    end;

    FActiveDataFile := Value;
    pnlFileName.Caption := FActiveDataFile.ShortFileName;
    ClearListView(lwWells);
    frmEditSubDivision1.ClearAll;

    // загружаем скважины
    if ActiveDataFile.Wells.Count > 0 then
    for i := 0 to ActiveDataFile.Wells.Count - 1 do
    begin
      lstItem := lwWells.Items.Add;
      with lstItem do
      begin
        Caption := ActiveDataFile.Wells[i].ListWell;
        New(P);
        P^ := TReadWell(ActiveDataFile.Wells[i]);
        Data := P;
      end;
    end;
    sbtnSaveErrors.Enabled := (flnmSaveFile.Text <> '') and Assigned(FActiveDataFile);    
  end;
end;


procedure TfrmConvert.ClearTable;
var i, j: integer;
begin
  with sgrStratons do
  begin
    for j := 0 to ColCount - 1 do
    for i := 1 to RowCount - 1 do
    begin
      Cells[j, i] := '';
      Objects[j, i] := nil;
    end;
    RowCount := 2;
  end;
end;

procedure TfrmConvert.ClearListView(lsw: TListView);
var i: integer;
begin
  lsw.Items.BeginUpdate;
  for i := 0 to lsw.Items.Count - 1 do
    Dispose(lsw.Items[i].Data);
  lsw.Items.Clear;
  lsw.Items.EndUpdate;  
end;

procedure TfrmConvert.SetEqualCaptions(APmn: TPopupMenu);
var i: integer;
begin
  with APmn do
  for i := 0 to Items.Count - 1 do
    Items[i].Caption :=  Items[i].Caption + StringOfChar(' ',30 - Length(Items[i].Caption) - 1);
end;

procedure TfrmConvert.ValidateToolButton(AToolButton: TToolButton; AAction: TMenuItem);
begin
  with AToolButton do
  begin
    Caption := AAction.Caption;
    Hint := AAction.Hint;
    //ImageIndex := AAction.ImageIndex;
    OnClick := AAction.OnClick;
  end;
end;


procedure TfrmConvert.InitProgress(var AMessage: TMessage);
begin
  with prg do
  begin
    Min := 0;
    Max := 10000;
    Position := 0;
    Min := AMessage.WParam;
    Max := AMessage.LParam;
  end;
end;

procedure TfrmConvert.smbNew(var AMessage: TMessage);
begin
  prg.Position := prg.Position + 1;
end;


procedure TfrmConvert.WellAdded(var AMessage: TMessage);
var lstItem: TListItem;
    iIndex: integer;
    P: PReadWell;
begin
  iIndex  := AMessage.WParam;
  if AMessage.LParam = 1 then
  begin
    lstItem := lwWells.Items.Add;
    with lstItem do
    begin
      Caption := ActiveDataFile.Wells[iIndex].ListWell;
      New(P);
      P^ := TReadWell(ActiveDataFile.Wells[iIndex]);
      Data := P;
    end;
  end;
  prg.Position := prg.Position + 1;
  Update;
end;

procedure TfrmConvert.Clear;
begin
  //frmWellConfirm.Free;


  if Assigned(dfsCommon) then
  begin
    dfsCommon.Free;
    dfsCommon := nil;
  end;

  ClearListView(lwFiles);
  ClearListView(lwWells);
  ClearTable;
  edtFolder.DialogText := '';
  frmEditSubDivision1.ClearAll;
  pgctlFolderContent.ActivePageIndex := 0;
  tshWells.TabVisible := false;
end;

procedure TfrmConvert.btnClearClick(Sender: TObject);
begin
  Clear;
end;

procedure TfrmConvert.Button1Click(Sender: TObject);
var Act: boolean;
    sName: string;
begin
  //
  sName := ExtractFilePath(ParamStr(0)) + 'test';
  edtFolderAfterDialog(Sender, sName, Act);
end;

procedure TfrmConvert.FormDestroy(Sender: TObject);
begin
  {if Assigned(frmWellConfirm) then
  begin
    frmWellConfirm.Free;
    frmWellConfirm := nil;
  end; }
  Clear;

  if Assigned(frmVerifyStratons) then
  begin
    frmVerifyStratons.Free;
    frmVerifyStratons := nil;
  end;
end;

procedure TfrmConvert.lwFilesSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected then
  begin

    ActiveDataFile := PDataFile(Item.Data)^;
    // чистим таблицу
    ClearTable;
    // загружаем в таблицу новые данные
    ActiveDataFile.MakeTable(sgrStratons);
    ErrorCount := ActiveDataFile.ErrorsCount;
    
  end;
end;

procedure TfrmConvert.pgctlFolderContentChange(Sender: TObject);
var WellFound: variant;
begin
  if Assigned(dfsCommon) and Assigned(lwFiles.Selected) then
  if pgctlFolderContent.ActivePageIndex = 1 then
  begin
    Update;
    // очищаем таблицу от прежних скважин
    if not Assigned(ActiveDataFile) then ActiveDataFile := PDataFile(lwFiles.Selected)^;
    // читаем скважины
    if ActiveDataFile.Wells.Count = 0 then
      ActiveDataFile.ReadFile(WellFound)
  end;
end;

procedure TfrmConvert.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmConvert.sgrStratonsDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var Obj: TStratonsATRow;
procedure FillCanvas(AColor: TColor);
begin
  with sgrStratons do
  begin
    Canvas.Brush.Color := AColor;
    Canvas.FillRect(Rect);
    Canvas.Font.Color := clBlack;
    Canvas.Font.Style:=[fsBold];
    Canvas.TextOut(Rect.Left+2,Rect.Top+2,Cells[ACol, ARow]);
  end
end;
begin
  {
    выделяем красным - вообще ничего не найдено
    или больше 2
    желтым - не похоже на исходник
  }

  if ARow > 0 then
  with sgrStratons do
  if Assigned(Objects[0, ARow]) then
  begin
    Obj := (Objects[0, ARow] as TStratonsAtRow);
    if (Obj.Stratons.Count = 0)
    or ((Obj.Stratons.Count = 2) and (Obj.SplitBy in [sbNone]))
    or ((Obj.Stratons.Count > 2) and (Obj.SplitBy in [sbNone, sbMinus])) then
      FillCanvas($00C6BFF0)
    else
    if Length(sgrStratons.Cells[2, ARow])<>Length(sgrStratons.Cells[1, ARow]) then
      FillCanvas($00C0EAF8);
  end
end;

procedure TfrmConvert.sgrStratonsDblClick(Sender: TObject);
var Obj: TStratonsAtRow;
begin
  with sgrStratons do
  if Assigned(ActiveDataFile)
  and (Col = 2) then
  begin
    // появляется форма
    Obj := TStratonsAtRow(Objects[0, Row]);

    // определить регион по уинам скважин
    if not Assigned(frmVerifyStratons.FilterRegions) then
    begin
      FilterRegs := TRegions.Create(false);
      FilterRegs.Assign(AllRegions);
      frmVerifyStratons.FilterRegions := FilterRegs;
    end;

    frmVerifyStratons.FoundStratons := Obj.Stratons;
    frmVerifyStratons.Caption := 'Найденные стратоны - строка поиска ' + Cells[1, Row];
    case Obj.SplitBy of
     sbPlus: frmVerifyStratons.Splitter := '+';
     sbMinus: frmVerifyStratons.Splitter := '-';
     sbNone: frmVerifyStratons.Splitter := ',';
    end;

    if frmVerifyStratons.ShowModal = mrOk then
    begin
      Cells[Col, Row] := frmVerifyStratons.edtStratons.Text;
      case frmVerifyStratons.Splitter of
      '+': Obj.SplitBy := sbPlus;
      '-': Obj.SplitBy := sbMinus;
      end;
    end;
    // пересчитываем ошибки
    ErrorCount := ActiveDataFile.ErrorsCount;
  end;
end;

procedure TfrmConvert.btnRefreshClick(Sender: TObject);
var SelectedWells: TWells;
    i: integer;
    Found: boolean;
begin
  SelectedWells := TWells.Create(TWell);
  Found := false;
  for i := 0 to lwWells.Items.Count - 1 do
  if lwWells.Items[i].Checked then
  begin
    SelectedWells.AddWell(PReadWell(lwWells.Items[i].Data)^, true);
    Found := true;
  end;

  if Found then
    frmEditSubDivision1.Wells := SelectedWells
  else
  begin
    SelectedWells.Free;
    frmEditSubDivision1.ClearAll;
  end;
end;

procedure TfrmConvert.SelectAllClick(Sender: TObject);
var i: integer;
begin
  for i := 0 to lwWells.Items.Count - 1 do
    lwWells.Items[i].Checked := true;
  ValidateToolButton(tlbtnSelect, SelectAll);
end;


procedure TfrmConvert.UnselectAllClick(Sender: TObject);
var i: integer;
begin
  for i := 0 to lwWells.Items.Count - 1 do
      lwWells.Items[i].Checked := false;
  ValidateToolButton(tlbtnSelect, UnSelectAll);
end;

procedure TfrmConvert.SelectAcceptedClick(Sender: TObject);
var i: integer;
    w: TReadWell;
begin
 for i := 0 to lwWells.Items.Count - 1 do
 begin
   w := PReadWell(lwWells.Items[i].Data)^;
   lwWells.Items[i].Checked := w.Accepted
 end;
  ValidateToolButton(tlbtnSelect, SelectAccepted);
end;

procedure TfrmConvert.SelectNonAcceptedClick(Sender: TObject);
var i: integer;
    w: TReadWell;
begin
 for i := 0 to lwWells.Items.Count - 1 do
 begin
   w := PReadWell(lwWells.Items[i].Data)^;
   lwWells.Items[i].Checked := not w.Accepted;
 end;

  ValidateToolButton(tlbtnSelect, SelectNonAccepted); 
end;

procedure TfrmConvert.ReloadAllClick(Sender: TObject);
var WellFound: variant;
    i: integer;
begin
  if Assigned(dfsCommon) and Assigned(lwFiles.Selected) then
  begin
    Update;
    // очищаем таблицу от прежних скважин
    for i := ActiveDataFile.Wells.Count - 1 downto 0 do
      ActiveDataFile.Wells[i].Free;

    ClearListView(lwWells);
    frmEditSubDivision1.ClearAll;

    // читаем скважины
    ActiveDataFile.ReadFile(WellFound)
  end;

  ValidateToolButton(tlbtnReload, ReloadAll);
end;

procedure TfrmConvert.ReloadNonAcceptedClick(Sender: TObject);
var WellFound: variant;
    i: integer;
    w: TReadWell;
begin
  if Assigned(dfsCommon) and Assigned(lwFiles.Selected) then
  if pgctlFolderContent.ActivePageIndex = 1 then
  begin
    Update;
    // очищаем таблицу от прежних скважин
    if not Assigned(ActiveDataFile) then ActiveDataFile := PDataFile(lwFiles.Selected)^;
    for i := lwWells.Items.Count - 1 downto 0 do
    begin
      W := PReadWell(lwWells.Items[i].Data)^;
      if not W.Accepted then
      begin
        W.Free;
        Dispose(lwWells.Items[i].Data);
        lwWells.Items[i].Delete;
      end;
    end;
    frmEditSubDivision1.ClearAll;
    // читаем скважины
    ActiveDataFile.ReadFile(WellFound)
  end;

  ValidateToolButton(tlbtnReload, ReloadNonAccepted);  
end;

procedure TfrmConvert.ReloadSelectedClick(Sender: TObject);
var WellFound: variant;
    i: integer;
    w: TReadWell;
begin
  if Assigned(dfsCommon) and Assigned(lwFiles.Selected) then
  if pgctlFolderContent.ActivePageIndex = 1 then
  begin
    Update;
    // очищаем таблицу от прежних скважин
    if not Assigned(ActiveDataFile) then ActiveDataFile := PDataFile(lwFiles.Selected)^;
    for i := lwWells.Items.Count - 1 downto 0 do
    begin
      W := PReadWell(lwWells.Items[i].Data)^;
      if lwWells.Items[i].Checked then
      begin
        W.Free;
        Dispose(lwWells.Items[i].Data);
        lwWells.Items[i].Delete;
      end;
    end;
    frmEditSubDivision1.ClearAll;
    // читаем скважины
    ActiveDataFile.ReadFile(WellFound)
  end;

  ValidateToolButton(tlbtnReload, ReloadSelected);
end;

procedure TfrmConvert.sbtnToDBClick(Sender: TObject);
var i, j: integer;
    w: TReadWell;
    vValue: variant;
    bDelete: boolean;
begin
  bDelete := MessageBox(Handle, PChar('Заменить разбивку в БД? Нажав "Да" Вы инициируете полную замену всех разбивок по скважинам. В случае нажатия "Нет" будут заменены только стратоны, присутствующие в разбивке.'),
                        PChar('Вопрос'), MB_YESNO+MB_APPLMODAL+MB_ICONQUESTION+MB_DEFBUTTON2) = IDYES;

  prg.Min := 0;
  prg.Max := lwWells.Items.Count;
  for i := 0 to lwWells.Items.Count - 1 do
  begin
    W := PReadWell(lwWells.Items[i].Data)^;
    if W.Accepted then
    begin
      vValue := varArrayOf([w.WellUIN]);
      if bDelete then j := IServer.InsertRow('SPD_DELETE_SUBDIV_WELL', null, vValue);
      if j >= 0 then
      begin
        prg.Max := prg.Max + W.SubDivisions.Count;
        for j := 0 to W.SubDivisions.Count - 1 do
        begin
          W.SubDivisions[j].PostToDB;
          prg.Position := prg.Position + 1;
        end
      end;
    end;
    prg.Position := prg.Position + 1;
  end;
end;

procedure TfrmConvert.FormShow(Sender: TObject);
begin
  pgctlFolderContent.ActivePageIndex := 0;
end;

procedure TfrmConvert.sbtnSaveErrorsClick(Sender: TObject);
var strlst: TStringList;
    i: integer;
    S: string;
begin
  //
  strlst := TStringList.Create;
  with FActiveDataFile do
  for i := High(Stratons) downto Low(Stratons) do
  begin
    if  (Stratons[i].Stratons.Count = 0)
    or ((Stratons[i].Stratons.Count = 2) and (Stratons[i].SplitBy in [sbNone]))
    or ((Stratons[i].Stratons.Count > 2) and (Stratons[i].SplitBy in [sbNone, sbMinus])) then
    begin
      if (rgrpSaveOpts.ItemIndex in [0, 1]) then
      begin
        S := '!!! Ошибка: в файле  ' + Stratons[i].Name +
             ', соответствий в справочнике ' + IntToStr(Stratons[i].Stratons.Count);
        if Stratons[i].Stratons.Count > 0 then
        begin
          S := S + ', в базе найдено ' +
                   Stratons[i].ReportFoundStratons +
                   '(' + Stratons[i].ReportFoundStratons(true) + ')';
        end;
      end
    end
    else
    if (Length(Stratons[i].Name) <> Length(Stratons[i].ReportFoundStratons)) then
    if (rgrpSaveOpts.ItemIndex in [0, 2]) then
    begin
      S := '??? Предупреждение: искомое (' + Stratons[i].Name +
           ', соответствий в справочнике ' + IntToStr(Stratons[i].Stratons.Count) + ')';
      if Stratons[i].Stratons.Count > 0 then S := S + ', не похоже на найденное '
                                                    + Stratons[i].ReportFoundStratons +
                                                    '(' + Stratons[i].ReportFoundStratons(true) + ')';
    end;
    if strlst.IndexOf(S) = -1 then strlst.Add(S);
  end;


  strlst.SaveToFile(flnmSaveFile.Text);
  strlst.Free;

  if FileExists(flnmSaveFile.Text) then
    ShellExecute(0, 'open',
                     PChar('notepad.exe'),
                     PChar(flnmSaveFile.Text),
                     PChar(ExtractFilePAth(ParamStr(0))),
                     SW_SHOWNORMAL);

end;

procedure TfrmConvert.flnmSaveFileChange(Sender: TObject);
begin
  sbtnSaveErrors.Enabled := (flnmSaveFile.Text <> '') and Assigned(FActiveDataFile);
  flnmSaveFile.Text := StringReplace(flnmSaveFile.Text, '"', '', [rfReplaceAll]);
end;

end.
