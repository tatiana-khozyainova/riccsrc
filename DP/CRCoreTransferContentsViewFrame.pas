unit CRCoreTransferContentsViewFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, ComCtrls, CoreTransfer, ToolWin, BaseObjects, StdCtrls,
  Ex_Grid, Registrator, ImgList, ActnList, Menus;

type
  TCoreTransferColumn = (ctpTransferType, ctpTransferringObject, ctpSource, ctpDest, ctpBoxCount, ctpBoxNumber);

  TCoreTransferColumns = set of TCoreTransferColumn;

  TfrmCoreTransferContentsView = class(TfrmCommonFrame)
    tlbr: TToolBar;
    gbxTransferTasks: TGroupBox;
    grdCoreTransfers: TGridView;
    actnlstCoreTransfers: TActionList;
    actnAdd: TAction;
    actnDelete: TAction;
    actnSave: TAction;
    imglstCoreTransfer: TImageList;
    actnRefresh: TAction;
    btnRemove: TToolButton;
    btnSave: TToolButton;
    btnREfresh: TToolButton;
    btnAddMenu: TToolButton;
    pmAdd: TPopupMenu;
    N1: TMenuItem;
    actnAddAllWellsString: TAction;
    N2: TMenuItem;
    pmDelete: TPopupMenu;
    N3: TMenuItem;
    actnDeleteByState: TAction;
    actnDeleteByTransferType: TAction;
    N4: TMenuItem;
    N5: TMenuItem;
    actnChangeTransferTypeForAll: TAction;
    actnChangeSourcePlacement: TAction;
    actnChangeTargetPlacement: TAction;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    procedure grdCoreTransfersGetCellText(Sender: TObject; Cell: TGridCell; var Value: string);
    procedure grdCoreTransfersEditCloseUp(Sender: TObject; Cell: TGridCell; ItemIndex: Integer; var Accept: Boolean);
    procedure grdCoreTransfersSetEditText(Sender: TObject; Cell: TGridCell; var Value: string);
    procedure grdCoreTransfersEditAcceptKey(Sender: TObject; Cell: TGridCell; Key: Char; var Accept: Boolean);
    procedure actnAddExecute(Sender: TObject);
    procedure actnAddUpdate(Sender: TObject);
    procedure grdCoreTransfersCellAcceptCursor(Sender: TObject; Cell: TGridCell; var Accept: Boolean);
    procedure grdCoreTransfersChange(Sender: TObject; Cell: TGridCell; Selected: Boolean);
    procedure actnDeleteExecute(Sender: TObject);
    procedure actnDeleteUpdate(Sender: TObject);
    procedure actnSaveExecute(Sender: TObject);
    procedure actnSaveUpdate(Sender: TObject);
    procedure actnRefreshExecute(Sender: TObject);
    procedure actnRefreshUpdate(Sender: TObject);
    procedure actnAddAllWellsStringExecute(Sender: TObject);
    procedure actnAddAllWellsStringUpdate(Sender: TObject);
    procedure actnDeleteByStateExecute(Sender: TObject);
    procedure actnDeleteByStateUpdate(Sender: TObject);
    procedure actnDeleteByTransferTypeExecute(Sender: TObject);
    procedure actnDeleteByTransferTypeUpdate(Sender: TObject);
    procedure actnChangeTransferTypeForAllExecute(Sender: TObject);
    procedure actnChangeTransferTypeForAllUpdate(Sender: TObject);
    procedure actnChangeSourcePlacementExecute(Sender: TObject);
    procedure actnChangeTargetPlacementExecute(Sender: TObject);
    procedure actnChangeSourcePlacementUpdate(Sender: TObject);
    procedure actnChangeTargetPlacementUpdate(Sender: TObject);
    procedure grdCoreTransfersDrawCell(Sender: TObject; Cell: TGridCell;
      var Rect: TRect; var DefaultDrawing: Boolean);
  private
    FCoreTransferColumns: TCoreTransferColumns;
    FCoreTransferTypesVisibility: TCoreTransferTypesPresence;
    FCoreTransferTasks: TCoreTransferTasks;
    FTransferringObjects: TRegisteredIDObjects;
    FCurrentTask: TCoreTransferTask;
    FCoreTransferTaskWells: TRegisteredIDObjects;
    FInternalCheckResult: Boolean;
    procedure ClearCacheObjects;
    procedure RefreshCoreTransferTasks;
    function  GetCoreTransfer: TCoreTransfer;
    procedure SetCoreTransferColumns(const Value: TCoreTransferColumns);
    function  GetCanEdit: boolean;
    function  GetShowToolBar: boolean;
    procedure SetCanEdit(const Value: boolean);
    procedure SetShowToolbar(const Value: boolean);
    function  GetCoreTransferTasks: TCoreTransferTasks;
    function  GetTransferringObjects: TRegisteredIDObjects;
    function  GetCurrentTask: TCoreTransferTask;
    procedure SetCurrentTask(const Value: TCoreTransferTask);
    function  GetCoreTransferTasksWells: TRegisteredIDObjects;
  protected
    procedure FillControls(ABaseObject: TIDObject); override;
    procedure ClearControls; override;
    procedure RegisterInspector; override;
    procedure FillParentControls; override;
    function  InternalCheck: boolean; override;

  public
    { Public declarations }
    property CoreTransfer: TCoreTransfer read GetCoreTransfer;
    property CoreTransferColumns: TCoreTransferColumns read FCoreTransferColumns write SetCoreTransferColumns;
    property CoreTransferTypesVisibility: TCoreTransferTypesPresence read FCoreTransferTypesVisibility write FCoreTransferTypesVisibility;
    property CoreTransferTasksWells: TRegisteredIDObjects read GetCoreTransferTasksWells;
    property CoreTransferTasks: TCoreTransferTasks read GetCoreTransferTasks;
    property TransferringObjects: TRegisteredIDObjects read GetTransferringObjects;
    property CurrentTask: TCoreTransferTask read GetCurrentTask write SetCurrentTask;
    property ShowToolbar: boolean read GetShowToolBar write SetShowToolbar;
    property CanEdit: boolean read GetCanEdit write SetCanEdit;
    constructor Create(AOwner: TComponent); override;
    procedure Save(AObject: TIDObject = nil); override;
    destructor Destroy; override;
  end;

var
  frmCoreTransferContentsView: TfrmCoreTransferContentsView;

implementation

uses
  DateUtils, Facade, SlottingPlacement, StringUtils, SlottingWell,
  CRSelectTransferStateForm, CRSelectPlacementForm, CommonProgressForm,
  Well;

{$R *.dfm}

{ TfrmCoreTransferContentsView }

procedure TfrmCoreTransferContentsView.ClearControls;
begin
  inherited;
  grdCoreTransfers.Rows.Count := 0;
end;

constructor TfrmCoreTransferContentsView.Create(AOwner: TComponent);
begin
  inherited;
  CoreTransferTypesVisibility := [cttvTransfer, cttvRepackaging, cttvDisposition];
end;

destructor TfrmCoreTransferContentsView.Destroy;
begin
  ClearCacheObjects;
  inherited;
end;

procedure TfrmCoreTransferContentsView.FillControls(ABaseObject: TIDObject);
begin
  inherited;

  ClearCacheObjects;
  RefreshCoreTransferTasks;
  CoreTransferColumns := [ctpTransferType, ctpTransferringObject, ctpSource, ctpDest, ctpBoxCount, ctpBoxNumber];

  grdCoreTransfers.Rows.Count := CoreTransferTasks.Count;
  grdCoreTransfers.Refresh;
end;

procedure TfrmCoreTransferContentsView.FillParentControls;
begin
  inherited;

end;

function TfrmCoreTransferContentsView.GetCoreTransfer: TCoreTransfer;
begin
  Result := EditingObject as TCoreTransfer;
end;

procedure TfrmCoreTransferContentsView.RegisterInspector;
begin
  inherited;

end;

procedure TfrmCoreTransferContentsView.Save(AObject: TIDObject);
var
  i: integer;
  ct: TCoreTransferTask;
begin
  inherited;

  for i := 0 to CoreTransferTasks.DeletedObjects.Count - 1 do
  begin
    ct := CoreTransfer.CoreTransferTasks.ItemsByID[CoreTransferTasks.DeletedObjects.Items[i].ID] as TCoreTransferTask;
    if Assigned(ct) then
      CoreTransfer.CoreTransferTasks.MarkDeleted(ct);
  end;

  for i := 0 to CoreTransferTasks.Count - 1 do
  begin
    ct := CoreTransfer.CoreTransferTasks.ItemsByID[CoreTransferTasks.Items[i].ID] as TCoreTransferTask;
    if Assigned(ct) then
      ct.Assign(CoreTransferTasks.Items[i]);
  end;

  for i := 0 to CoreTransferTasks.Count - 1 do
  begin
    ct := nil;
    if CoreTransferTasks.Items[i].ID > 0 then
      ct := CoreTransfer.CoreTransferTasks.ItemsByID[CoreTransferTasks.Items[i].ID] as TCoreTransferTask;

    if not Assigned(ct) then
      CoreTransfer.CoreTransferTasks.Add(CoreTransferTasks.Items[i], true, False);
  end;

  CoreTransfer.CoreTransferTasks.Update(nil);
  FreeAndNil(FCoreTransferTasks);
  RefreshCoreTransferTasks;
  grdCoreTransfers.Refresh;
end;

procedure TfrmCoreTransferContentsView.grdCoreTransfersGetCellText(Sender: TObject; Cell: TGridCell; var Value: string);
begin
  inherited;
  if CoreTransferTasks.Count > Cell.Row then 
  with CoreTransferTasks.Items[Cell.Row] do
    case Cell.Col of
    // тип перемещения
      0:
        if Assigned(TransferType) then
          Value := TransferType.List();
    // скважина или св. разрез
      1:
        if Assigned(TransferringObject) then
          Value := TransferringObject.List();
    // откуда
      2:
        if Assigned(SourcePlacement) then
          Value := SourcePlacement.List();
    // куда
      3:
        if Assigned(TargetPlacement) then
          Value := TargetPlacement.List();
    // кол-во ящиков
      4:
        Value := IntToStr(BoxCount);
    // номера ящиков
      5:
        Value := BoxNumbers;
    end;
end;

procedure TfrmCoreTransferContentsView.SetCoreTransferColumns(const Value: TCoreTransferColumns);
begin
  if FCoreTransferColumns <> Value then
  begin
    FCoreTransferColumns := Value;
    with grdCoreTransfers do
    begin
      Columns[0].Visible := ctpTransferType in FCoreTransferColumns;
      TMainFacade.GetInstance.AllCoreTransferTypes.MakeList(Columns[0].PickList, True, True);

      Columns[1].Visible := ctpTransferringObject in FCoreTransferColumns;
      TransferringObjects.MakeList(Columns[1].PickList, True, True);

      Columns[2].Visible := ctpSource in FCoreTransferColumns;
      TMainFacade.GetInstance.CoreLibrary.OldPlacementPlainList.MakeList(Columns[2].PickList, True, True);

      Columns[3].Visible := ctpDest in FCoreTransferColumns;
      TMainFacade.GetInstance.CoreLibrary.NewPlacementPlainList.MakeList(Columns[3].PickList, True, True);

      Columns[4].Visible := ctpBoxCount in FCoreTransferColumns;
      Columns[5].Visible := ctpBoxNumber in FCoreTransferColumns;
    end;
  end;
end;

function TfrmCoreTransferContentsView.GetCanEdit: boolean;
begin
  Result := grdCoreTransfers.AllowEdit;
end;

function TfrmCoreTransferContentsView.GetShowToolBar: boolean;
begin
  Result := tlbr.Visible;
end;

procedure TfrmCoreTransferContentsView.SetCanEdit(const Value: boolean);
begin
  grdCoreTransfers.AllowEdit := Value;
  if not CanEdit then
    ShowToolbar := false;
end;

procedure TfrmCoreTransferContentsView.SetShowToolbar(const Value: boolean);
begin
  tlbr.Visible := Value;
end;

function TfrmCoreTransferContentsView.GetCoreTransferTasks: TCoreTransferTasks;
begin
  if not Assigned(FCoreTransferTasks) then
  begin
    FCoreTransferTasks := TCoreTransferTasks.Create;
    FCoreTransferTasks.OwnsObjects := true;
  end;

  Result := FCoreTransferTasks;
end;

procedure TfrmCoreTransferContentsView.grdCoreTransfersEditCloseUp(Sender: TObject; Cell: TGridCell; ItemIndex: Integer; var Accept: Boolean);
begin
  inherited;
  if ItemIndex > -1 then
    case Cell.Col of
      0:
        CoreTransferTasks.Items[Cell.Row].TransferType := TMainFacade.GetInstance.AllCoreTransferTypes.Items[ItemIndex];
      1:
        begin
          CoreTransferTasks.Items[Cell.Row].TransferringObject := TransferringObjects.Items[ItemIndex];
          if TransferringObjects.Items[ItemIndex] is TSlottingWell then
          begin
            CoreTransferTasks.Items[Cell.Row].SourcePlacement := CoreTransferTasks.Items[Cell.Row].Well.SlottingPlacement.StatePartPlacement;
            CoreTransferTasks.Items[Cell.Row].BoxCount := CoreTransferTasks.Items[Cell.Row].Well.Boxes.Count;

          end;
        end;
      2:
        CoreTransferTasks.Items[Cell.Row].SourcePlacement := TMainFacade.GetInstance.CoreLibrary.OldPlacementPlainList.Items[ItemIndex];
      3:
        CoreTransferTasks.Items[Cell.Row].TargetPlacement := TMainFacade.GetInstance.CoreLibrary.NewPlacementPlainList.Items[ItemIndex];
    end;
  grdCoreTransfers.Refresh;
  InternalCheck;
end;

function TfrmCoreTransferContentsView.GetTransferringObjects: TRegisteredIDObjects;
begin
  if not Assigned(FTransferringObjects) then
  begin
    FTransferringObjects := TRegisteredIDObjects.Create;
    FTransferringObjects.OwnsObjects := False;

    FTransferringObjects.AddObjects(CoreTransferTasksWells, false, false);
    FTransferringObjects.AddObjects(TMainFacade.GetInstance.GeneralizedSections, false, false);
  end;

  Result := FTransferringObjects;
end;

procedure TfrmCoreTransferContentsView.grdCoreTransfersSetEditText(Sender: TObject; Cell: TGridCell; var Value: string);
begin
  inherited;
  case Cell.Col of
    4:
      CoreTransferTasks.Items[Cell.Row].BoxCount := StrToInt(Value);
    5:
      CoreTransferTasks.Items[Cell.Row].BoxNumbers := Value;
  end;
  InternalCheck;
  grdCoreTransfers.Refresh;
end;

procedure TfrmCoreTransferContentsView.grdCoreTransfersEditAcceptKey(Sender: TObject; Cell: TGridCell; Key: Char; var Accept: Boolean);
begin
  inherited;
  Accept := true;
  case Cell.Col of
    4:
      Accept := Key in NumberSet;
    5:
      Accept := Key in NumberSet + [',', '-']
  end;
end;

procedure TfrmCoreTransferContentsView.actnAddExecute(Sender: TObject);
begin
  inherited;
  CurrentTask := CoreTransferTasks.Add as TCoreTransferTask;
  InternalCheck;
  grdCoreTransfers.Rows.Count := CoreTransferTasks.Count;
  grdCoreTransfers.Refresh;
end;

function TfrmCoreTransferContentsView.GetCurrentTask: TCoreTransferTask;
begin
  Result := FCurrentTask;
end;

procedure TfrmCoreTransferContentsView.SetCurrentTask(const Value: TCoreTransferTask);
begin
  if FCurrentTask <> Value then
  begin
    FCurrentTask := Value;
    if Assigned(FCurrentTask) then
      grdCoreTransfers.Row := CoreTransferTasks.IndexOf(FCurrentTask);
  end;
end;

procedure TfrmCoreTransferContentsView.actnAddUpdate(Sender: TObject);
begin
  inherited;
  actnAdd.Enabled := Assigned(CoreTransfer) and (not Assigned(CurrentTask) or (Assigned(CurrentTask) and CurrentTask.IsDataCompleted));
end;

procedure TfrmCoreTransferContentsView.grdCoreTransfersCellAcceptCursor(Sender: TObject; Cell: TGridCell; var Accept: Boolean);
begin
  inherited;
  Accept := true; 
end;

procedure TfrmCoreTransferContentsView.grdCoreTransfersChange(Sender: TObject; Cell: TGridCell; Selected: Boolean);
begin
  inherited;
  if CoreTransferTasks.Count > Cell.Row then
    CurrentTask := CoreTransferTasks.Items[Cell.Row]
  else
    CurrentTask := nil;
end;

procedure TfrmCoreTransferContentsView.actnDeleteExecute(Sender: TObject);
var
  iRow: integer;
begin
  inherited;
  iRow := grdCoreTransfers.Row;
  if CurrentTask.ID > 0 then
    CoreTransferTasks.MarkDeleted(CurrentTask)
  else
    CoreTransferTasks.Remove(CurrentTask);

  grdCoreTransfers.Rows.Count := CoreTransferTasks.Count;
  grdCoreTransfers.Refresh;

  if iRow < CoreTransferTasks.Count then
    CurrentTask := CoreTransferTasks.Items[iRow]
  else if CoreTransferTasks.Count > 0 then
  begin
    iRow := 0;
    if CoreTransferTasks.Count > 0 then
      CurrentTask := CoreTransferTasks.Items[iRow];
  end;
  InternalCheck;
end;

procedure TfrmCoreTransferContentsView.actnDeleteUpdate(Sender: TObject);
begin
  inherited;
  actnDelete.Enabled := Assigned(CurrentTask);
end;

procedure TfrmCoreTransferContentsView.actnSaveExecute(Sender: TObject);
begin
  inherited;
  Save;
end;

procedure TfrmCoreTransferContentsView.actnSaveUpdate(Sender: TObject);
begin
  inherited;
  actnSave.Enabled := Assigned(CoreTransfer) and FInternalCheckResult;
end;

procedure TfrmCoreTransferContentsView.actnRefreshExecute(Sender: TObject);
begin
  inherited;
  FillControls(EditingObject); // мзменения потеряются

end;

procedure TfrmCoreTransferContentsView.actnRefreshUpdate(Sender: TObject);
begin
  inherited;
  actnRefresh.Enabled := Assigned(CoreTransfer);
end;

procedure TfrmCoreTransferContentsView.actnAddAllWellsStringExecute(Sender: TObject);
var
  i: integer;
  ct: TCoreTransferTask;
  w: TSlottingWell;
begin
  inherited;
  if not Assigned(frmSelectTransferStateDialog) then
    frmSelectTransferStateDialog := TfrmSelectTransferStateDialog.Create(Self);
  if frmSelectTransferStateDialog.ShowModal = mrOk then
  begin
    if not Assigned(frmProgress) then
      frmProgress := TfrmProgress.Create(Self);
    frmProgress.Min := 0;
    frmProgress.Max := TransferringObjects.Count - 1;
    frmProgress.Show;
    for i := 0 to TransferringObjects.Count - 1 do
    begin
      if TransferringObjects.Items[i] is TSlottingWell then
      begin
        w := TransferringObjects.Items[i] as TSlottingWell;
        if w.Slottings.Count > 0 then
        begin
          if not CoreTransferTasks.IsWellPresent(w) then
          begin
            ct := CoreTransferTasks.Add as TCoreTransferTask;

            ct.TransferType := frmSelectTransferStateDialog.TransferType;
            ct.TransferringObject := TransferringObjects.Items[i];
            ct.SourcePlacement := w.SlottingPlacement.StatePartPlacement;
            ct.BoxCount := w.SlottingPlacement.FinalBoxCount;
          end;
        end;
      end;
      frmProgress.StepIt;
    end;
    frmProgress.Close;
    grdCoreTransfers.Rows.Count := CoreTransferTasks.Count;
    grdCoreTransfers.Refresh;
    InternalCheck;
  end;
end;

procedure TfrmCoreTransferContentsView.actnAddAllWellsStringUpdate(Sender: TObject);
begin
  inherited;
  actnAddAllWellsString.Enabled := Assigned(CoreTransfer);
end;

procedure TfrmCoreTransferContentsView.actnDeleteByStateExecute(Sender: TObject);
var
  i: integer;
begin
  inherited;
  for i := CoreTransferTasks.Count - 1 downto 0 do
    if not CoreTransferTasks.Items[i].IsDataCompleted then
      if CoreTransferTasks.Items[i].ID > 0 then
        CoreTransferTasks.MarkDeleted(CoreTransferTasks.Items[i])
      else
        CoreTransferTasks.Remove(CoreTransferTasks.Items[i]);

  grdCoreTransfers.Rows.Count := CoreTransferTasks.Count;
  if CoreTransferTasks.Count > 0 then
    CurrentTask := CoreTransferTasks.Items[0];
  InternalCheck;
  grdCoreTransfers.Refresh;
end;

procedure TfrmCoreTransferContentsView.actnDeleteByStateUpdate(Sender: TObject);
begin
  inherited;
  actnDeleteByState.Enabled := Assigned(CoreTransfer) and (CoreTransferTasks.Count > 0);
end;

procedure TfrmCoreTransferContentsView.actnDeleteByTransferTypeExecute(Sender: TObject);
var
  i: integer;
begin
  inherited;

  if not Assigned(frmSelectTransferStateDialog) then
    frmSelectTransferStateDialog := TfrmSelectTransferStateDialog.Create(Self);
  if frmSelectTransferStateDialog.ShowModal = mrOk then
  begin
    for i := CoreTransferTasks.Count - 1 downto 0 do
    begin
      if CoreTransferTasks.Items[i].TransferType = frmSelectTransferStateDialog.TransferType then
        if CoreTransferTasks.Items[i].ID > 0 then
          CoreTransferTasks.MarkDeleted(CoreTransferTasks.Items[i])
        else
          CoreTransferTasks.Remove(CoreTransferTasks.Items[i]);
    end;

    grdCoreTransfers.Rows.Count := CoreTransferTasks.Count;
    if CoreTransferTasks.Count > 0 then
      CurrentTask := CoreTransferTasks.Items[0];

    grdCoreTransfers.Refresh;
    InternalCheck;
  end;
end;

procedure TfrmCoreTransferContentsView.actnDeleteByTransferTypeUpdate(Sender: TObject);
begin
  inherited;
  actnDeleteByTransferType.Enabled := Assigned(CoreTransfer) and (CoreTransferTasks.Count > 0);
end;

procedure TfrmCoreTransferContentsView.actnChangeTransferTypeForAllExecute(Sender: TObject);
var
  i: integer;
begin
  inherited;

  if not Assigned(frmSelectTransferStateDialog) then
    frmSelectTransferStateDialog := TfrmSelectTransferStateDialog.Create(Self);
  if frmSelectTransferStateDialog.ShowModal = mrOk then
  begin
    for i := 0 to CoreTransferTasks.Count - 1 do
      CoreTransferTasks.Items[i].TransferType := frmSelectTransferStateDialog.TransferType;
  end;
  InternalCheck;
  grdCoreTransfers.Refresh;
end;

procedure TfrmCoreTransferContentsView.actnChangeTransferTypeForAllUpdate(Sender: TObject);
begin
  inherited;
  actnChangeTransferTypeForAll.Enabled := Assigned(CoreTransfer) and (CoreTransferTasks.Count > 0);
end;

procedure TfrmCoreTransferContentsView.actnChangeSourcePlacementExecute(Sender: TObject);
var
  i: integer;
begin
  inherited;
  if not Assigned(frmSelectPlacement) then
    frmSelectPlacement := TfrmSelectPlacement.Create(Self);
  frmSelectPlacement.UseNewPlacements := false;

  if frmSelectPlacement.ShowModal = mrOk then
  begin
    if not frmSelectPlacement.FillOnlyEmpties then
      for i := 0 to CoreTransferTasks.Count - 1 do
        CoreTransferTasks.Items[i].SourcePlacement := frmSelectPlacement.PartPlacement
    else
      for i := 0 to CoreTransferTasks.Count - 1 do
        if (CoreTransferTasks.Items[i].SourcePlacement = nil) or (not (Assigned(TMainFacade.GetInstance.CoreLibrary.OldPlacementPlainList.ItemsByID[CoreTransferTasks.Items[i].SourcePlacement.ID]))) then
          CoreTransferTasks.Items[i].SourcePlacement := frmSelectPlacement.PartPlacement
  end;
  InternalCheck;
  grdCoreTransfers.Refresh;
end;

procedure TfrmCoreTransferContentsView.actnChangeTargetPlacementExecute(Sender: TObject);
var
  i: integer;
begin
  inherited;
  if not Assigned(frmSelectPlacement) then
    frmSelectPlacement := TfrmSelectPlacement.Create(Self);
  frmSelectPlacement.UseNewPlacements := true;

  if frmSelectPlacement.ShowModal = mrOk then
  begin
    if not frmSelectPlacement.FillOnlyEmpties then
      for i := 0 to CoreTransferTasks.Count - 1 do
        CoreTransferTasks.Items[i].TargetPlacement := frmSelectPlacement.PartPlacement
    else
      for i := 0 to CoreTransferTasks.Count - 1 do
        if (CoreTransferTasks.Items[i].TargetPlacement = nil) or (not (Assigned(TMainFacade.GetInstance.CoreLibrary.NewPlacementPlainList.ItemsByID[CoreTransferTasks.Items[i].TargetPlacement.ID]))) then
          CoreTransferTasks.Items[i].TargetPlacement := frmSelectPlacement.PartPlacement
  end;
  InternalCheck;
  grdCoreTransfers.Refresh;
end;

procedure TfrmCoreTransferContentsView.actnChangeSourcePlacementUpdate(Sender: TObject);
begin
  inherited;
  actnChangeSourcePlacement.Enabled := Assigned(CoreTransfer) and (CoreTransferTasks.Count > 0);
end;

procedure TfrmCoreTransferContentsView.actnChangeTargetPlacementUpdate(Sender: TObject);
begin
  inherited;
  actnChangeTargetPlacement.Enabled := Assigned(CoreTransfer) and (CoreTransferTasks.Count > 0);
end;

function TfrmCoreTransferContentsView.GetCoreTransferTasksWells: TRegisteredIDObjects;
begin
  if not Assigned(FCoreTransferTaskWells) then
  begin
    FCoreTransferTaskWells := TSlottingWells.Create;
    FCoreTransferTaskWells.OwnsObjects := true;

    FCoreTransferTaskWells.AddObjects(TMainFacade.GetInstance.AllWells, True, false);
    FCoreTransferTaskWells.AddObjects(CoreTransferTasks.Wells, True, true);
  end;

  Result := FCoreTransferTaskWells;
end;

procedure TfrmCoreTransferContentsView.ClearCacheObjects;
begin
  try
    FreeAndNil(FCoreTransferTasks);
  except

  end;

  try
    FreeAndNil(FTransferringObjects);
  except

  end;

  try
    FreeAndNil(FCoreTransferTaskWells);
  except

  end;

end;

procedure TfrmCoreTransferContentsView.RefreshCoreTransferTasks;
var i: integer;
begin
  if Assigned(EditingObject) then
  begin
    for i := 0 to (EditingObject as TCoreTransfer).CoreTransferTasks.Count - 1 do
      if (EditingObject as TCoreTransfer).CoreTransferTasks.Items[i].TransferType.CoreTransferTypePresence in CoreTransferTypesVisibility then
        CoreTransferTasks.Add((EditingObject as TCoreTransfer).CoreTransferTasks.Items[i], True, True);
  end;
end;

function TfrmCoreTransferContentsView.InternalCheck: boolean;
var i: integer;
begin
  Result := true;
  StatusBar.Panels.Items[0].Text := '';
  for i := 0 to CoreTransferTasks.Count - 1 do
  begin
    result := Result and CoreTransferTasks.Items[i].IsDataCompleted;
    if not result then
    begin
      StatusBar.Panels.Items[0].Text := 'Заполнение не завершено';
      Break;
    end;
  end;

  FInternalCheckResult := Result;
end;

procedure TfrmCoreTransferContentsView.grdCoreTransfersDrawCell(
  Sender: TObject; Cell: TGridCell; var Rect: TRect;
  var DefaultDrawing: Boolean);
var ctt: TCoreTransferTask;
    s: string;
begin
  inherited;

  if Cell.Row < CoreTransferTasks.Count  then
  begin
    ctt := CoreTransferTasks.Items[Cell.Row];
    if ctt.IsDataCompleted then
      DefaultDrawing := True
    else
    begin
      DefaultDrawing := False;
      grdCoreTransfers.Canvas.Brush.Color := clRed;
      grdCoreTransfers.Canvas.FillRect(rect);
      grdCoreTransfersGetCellText(Sender, Cell, s);
      grdCoreTransfers.Canvas.TextOut(Rect.Left + 6, Rect.Top + 2, s);

    end;
  end;

end;

end.

