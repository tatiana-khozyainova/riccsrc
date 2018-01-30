unit StratClientSubdivisionEditFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, SubdivisionTable, Ex_Grid, ComCtrls, Menus, ActnList, ImgList,
  ToolWin, BaseTable, SubdivisionComponent;

type
  TfrmSubdivisionEditFrame = class(TFrame)
    grdSubdivisionTable: TGridView;
    lwErrors: TListView;
    pmComments: TPopupMenu;
    tlbrButtons: TToolBar;
    btnSave: TToolButton;
    imglst1: TImageList;
    actnlst: TActionList;
    actnSavetoDB: TAction;
    actnCheck: TAction;
    btnCheck: TToolButton;
    actnExcelExport: TAction;
    btnExportToExcel: TToolButton;
    actnPlaceComment: TAction;
    actnGoToError: TAction;
    dlgOpen: TOpenDialog;
    procedure grdSubdivisionTableGetCellText(Sender: TObject;
      Cell: TGridCell; var Value: String);
    procedure grdSubdivisionTableGetHeaderColors(Sender: TObject;
      Section: TGridHeaderSection; Canvas: TCanvas);
    procedure grdSubdivisionTableGetCellColors(Sender: TObject;
      Cell: TGridCell; Canvas: TCanvas);
    procedure lwErrorsDblClick(Sender: TObject);
    procedure grdSubdivisionTableEditAcceptKey(Sender: TObject;
      Cell: TGridCell; Key: Char; var Accept: Boolean);
    procedure grdSubdivisionTableSetEditText(Sender: TObject;
      Cell: TGridCell; var Value: String);
    procedure grdSubdivisionTableMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure grdSubdivisionTableHeaderClick(Sender: TObject;
      Section: TGridHeaderSection);
    procedure actnSavetoDBUpdate(Sender: TObject);
    procedure actnSavetoDBExecute(Sender: TObject);
    procedure actnCheckExecute(Sender: TObject);
    procedure actnExcelExportExecute(Sender: TObject);
    procedure actnPlaceCommentExecute(Sender: TObject);
    procedure actnPlaceCommentUpdate(Sender: TObject);
    procedure pmCommentsPopup(Sender: TObject);
    procedure grdSubdivisionTableCellTips(Sender: TObject; Cell: TGridCell;
      var AllowTips: Boolean);
    procedure lwErrorsColumnClick(Sender: TObject; Column: TListColumn);
    procedure actnGoToErrorExecute(Sender: TObject);
    procedure actnGoToErrorUpdate(Sender: TObject);

  private
    FSubdivisionTable: TSubdivisionTable;
    FAllowEdit: boolean;
    { Private declarations }
    procedure LoadHeader;
    procedure LoadErrors;
    procedure SetProgress(Sender: TObject);
    procedure MoveProgress(Sender: TObject);
    procedure FinishProgress(Sender: TObject);
    function GetActiveCell: TBaseTableCell;
    function GetBaseTableCell(ACol, ARow: integer): TBaseTableCell;
    function CanPlaceComment(ACol, ARow: integer; AComment: TSubdivisionComment): boolean;
    function GetTableErrorListIndex(AErr: TTableError): integer;
    procedure SetAllowEdit(const Value: boolean);
    procedure PrepareCommentEditMenu;
  public
    { Public declarations }
    property SubdivisionTable: TSubdivisionTable read FSubdivisionTable write FSubdivisionTable;
    property ActiveCell: TBaseTableCell read GetActiveCell;
    property BaseTableCell[ACol, ARow: integer]: TBaseTableCell read GetBaseTableCell;
    procedure Reload;
    property  AllowEdit: boolean read FAllowEdit write SetAllowEdit;
    procedure Clear;
    procedure ExportToExcel(AFileName: string);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses BaseObjects, Well,  Facade, BaseConsts, ClientCommon,
     StratClientStratonVerifyingForm, Straton, StratClientWellConfirm, Area,
     StratClientThemeSelectForm, CommonStepForm, ComObj, FileUtils;

{$R *.dfm}

{ TfrmSubdivisionEditFrame }

procedure TfrmSubdivisionEditFrame.Reload;
begin
  LoadHeader;
  grdSubdivisionTable.Rows.Count := SubdivisionTable.RowCount - ALTITUDE_ROW_INDEX - 1;
  LoadErrors;
  PrepareCommentEditMenu;
end;

procedure TfrmSubdivisionEditFrame.LoadHeader;
var i: integer;
    s: TGridHeaderSection;
    w: TWell;
begin


  grdSubdivisionTable.Columns.Add;
  s := grdSubdivisionTable.Header.Sections.Add;
  s.Caption := 'Индекс';


  grdSubdivisionTable.Columns.Add;
  s := grdSubdivisionTable.Header.Sections.Add;
  s.Caption := 'Площадь';



  s := s.Sections.Add;
  s.Caption := 'NN скв.';
  s := s.Sections.Add;
  s.Caption := 'Тект. блок';
  s := s.Sections.Add;
  s.Caption := 'Альт., м';


  for i := SECOND_STRATON_COLUMN_INDEX + 1 to SubdivisionTable.Columns.Count - 1 do
  begin
    grdSubdivisionTable.Columns.Add;

    if Assigned(SubdivisionTable.WellRow[i].Data) then
    begin
      //if lastObject <> TIDObjectSearch(SubdivisionTable.WellRow[i].Data).IDObject then
      begin

        w := TIDObjectSearch(SubdivisionTable.WellRow[i].Data).IDObject as TWell;

        s := grdSubdivisionTable.Header.Sections.Add;
        s.Caption := w.Area.Name;

        s := s.Sections.Add;
        s.Caption := w.NumberWell;
      end;
    end
    else
    begin

      s := grdSubdivisionTable.Header.Sections.Add;
      s.Caption := SubdivisionTable.AreaRow[i].AsString;

      s := s.Sections.Add;
      s.Caption := SubdivisionTable.WellRow[i].AsString;
    end;

    s := s.Sections.Add;
    if Assigned(SubdivisionTable.TectonicBlockRow[i].Data) then
      s.Caption := TIDObjectSearch(SubdivisionTable.TectonicBlockRow[i].Data).IDObject.ShortName
    else
      s.Caption := SubdivisionTable.TectonicBlockRow[i].AsString;

    s := s.Sections.Add;
    if (SubdivisionTable.AltitudeRow[i].AsFloat > 0) then
      s.Caption := Format('%.2f', [SubdivisionTable.AltitudeRow[i].AsFloat]);
  end;

  grdSubdivisionTable.Fixed.Count := 2;  
end;

procedure TfrmSubdivisionEditFrame.grdSubdivisionTableGetCellText(
  Sender: TObject; Cell: TGridCell; var Value: String);
var o: TIDObjectSearch;
begin
  if (Assigned(SubdivisionTable)) And (Assigned(BaseTableCell[Cell.Col, Cell.Row])) then
  Case Cell.Col of
    0, 1: // первый индекс
    begin
      if Assigned(BaseTableCell[Cell.Col,Cell.Row].Data) then
        o := TIDObjectSearch(BaseTableCell[Cell.Col,Cell.Row].Data)
      else o := nil;

      if Assigned(o) then
        Value := o.IDObject.List(loBrief)
      else
        Value := BaseTableCell[Cell.Col,Cell.Row].AsString;
    end
    else
    begin
      if ((Assigned(BaseTableCell[Cell.Col,Cell.Row].Data))
         and (TObject(BaseTableCell[Cell.Col,Cell.Row].Data) is TSubdivisionComment)) then
        Value := (TObject(BaseTableCell[Cell.Col,Cell.Row].Data) as TSubdivisionComment).ShortName
      else
        Value := BaseTableCell[Cell.Col,Cell.Row].AsString;
    end;
  end;
end;

constructor TfrmSubdivisionEditFrame.Create(AOwner: TComponent);
begin
  FAllowEdit := true;
  inherited;
  FSubdivisionTable := nil;
  
end;

procedure TfrmSubdivisionEditFrame.grdSubdivisionTableGetHeaderColors(
  Sender: TObject; Section: TGridHeaderSection; Canvas: TCanvas);
var o: TIDObjectSearch;
    err: TTableError;
procedure MarkAsErrorSection(AColor: TColor);
begin
  Canvas.Brush.Color := AColor;
  Canvas.FillRect(Section.BoundsRect);
  Canvas.TextOut(Section.BoundsRect.Left + 2, Section.BoundsRect.Top + 2, Section.Caption);
end;
begin
  //
  if Assigned(SubdivisionTable) then
  begin
    MarkAsErrorSection(clBtnFace);
    if (Section.ColumnIndex > SECOND_STRATON_COLUMN_INDEX) then
    begin
      if (Section.Level = 0) then // площадь
      begin
        if Assigned(SubdivisionTable.WellRow[Section.ColumnIndex].Data) then
        begin
          if TObject(SubdivisionTable.WellRow[Section.ColumnIndex].Data) is TIDObjectSearch then
          begin
            o := TObject(SubdivisionTable.WellRow[Section.ColumnIndex].Data) as TIDObjectSearch;
            if not Assigned(o.IDObject) then
              MarkAsErrorSection(clRed);
          end;
        end
        else MarkAsErrorSection(clRed);
      end
      else if (Section.Level = 2) then
      begin
        if Assigned(SubdivisionTable.TectonicBlockRow[Section.ColumnIndex].Data) then
        begin
          if TObject(SubdivisionTable.TectonicBlockRow[Section.ColumnIndex].Data) is TIDObjectSearch then
          begin
            o := TObject(SubdivisionTable.TectonicBlockRow[Section.ColumnIndex].Data) as TIDObjectSearch;
            if not Assigned(o.IDObject) then MarkAsErrorSection(clRed);
          end;
        end
        else if not SubdivisionTable.TectonicBlockRow[Section.ColumnIndex].IsEmpty then
          MarkAsErrorSection(clRed);
      end
      else if (Section.Level = 3) then
      begin
        err := SubdivisionTable.TableErrors.GetErrorByCellAddress(ALTITUDE_ROW_INDEX, Section.ColumnIndex);
        if Assigned(err) and (err.ErrorKind = ekNoAltitude) then
          MarkAsErrorSection($0097C6F4);
      end;
    end;
  end;
end;

procedure TfrmSubdivisionEditFrame.grdSubdivisionTableGetCellColors(
  Sender: TObject; Cell: TGridCell; Canvas: TCanvas);
var o: TIDObjectSearch;
    e: TTableError;
    cl: TColor;
procedure MarkAsErrorCell(Color: TColor);
var r: TRect;
begin
  Canvas.Brush.Color := Color;
  r := grdSubdivisionTable.GetCellRect(Cell);
  Canvas.FillRect(r);
  Canvas.TextOut(r.Left + 2, r.Top + 2, grdSubdivisionTable.Cells[Cell.Col, Cell.Row]);
end;
begin
  if Assigned(SubdivisionTable) then
  if Canvas.LockCount = 1 then
  begin
    Case Cell.Col of
    0, 1:
      begin
        if (Cell.Row < grdSubdivisionTable.Rows.Count - 2) then
        begin
          if not BaseTableCell[Cell.Col,Cell.Row].IsEmpty then
          begin
            if Assigned(BaseTableCell[Cell.Col,Cell.Row].Data) then
              o := TIDObjectSearch(BaseTableCell[Cell.Col,Cell.Row].Data)
            else o := nil;

            if not Assigned(o) then
              MarkAsErrorCell(clRed);
          end;
        end;
      end
      else
      begin
        if (Cell.Row < grdSubdivisionTable.Rows.Count - 1) then
        begin
          // сначала ищем ошибки на целый столбец
          e := SubdivisionTable.TableErrors.GetErrorByCellAddress(AREA_ROW_INDEX, Cell.Col);
          if Assigned(e) then
            MarkAsErrorCell($0097C6F4);
          // потом - на целую строку
          e := SubdivisionTable.TableErrors.GetErrorByCellAddress(Cell.Row + ALTITUDE_ROW_INDEX + 1, SECOND_STRATON_COLUMN_INDEX);
          if Assigned(e) and (e.ErrorKind = ekEmptyTableRow) then
            MarkAsErrorCell($0097C6F4);

          if Assigned(e) then cl := clRed
          else cl := $008080FF;

          e := SubdivisionTable.TableErrors.GetErrorByCellAddress(Cell.Row + ALTITUDE_ROW_INDEX + 1, Cell.Col);
          if Assigned(e) then
          begin
            if (e.ErrorKind <> ekNoTotalDepth) then
              MarkAsErrorCell(cl)
            else
              MarkAsErrorCell($0097C6F4);
          end;

        end;
      end;
    end;
  end;
end;

procedure TfrmSubdivisionEditFrame.LoadErrors;
var i: integer;
    li: TListItem;
begin
  lwErrors.Items.Clear;
  for i := 0 to SubdivisionTable.TableErrors.Count - 1 do
  begin
    li := lwErrors.Items.Add;

    if SubdivisionTable.TableErrors.Items[i].ColumnAddress - SECOND_STRATON_COLUMN_INDEX > 0 then
      li.Caption := IntToStr(SubdivisionTable.TableErrors.Items[i].ColumnAddress - SECOND_STRATON_COLUMN_INDEX)
    else
      li.Caption := '';

    if SubdivisionTable.TableErrors.Items[i].RowAddress - ALTITUDE_ROW_INDEX > 0 then
      li.SubItems.Add(IntToStr(SubdivisionTable.TableErrors.Items[i].RowAddress - ALTITUDE_ROW_INDEX))
    else
      li.SubItems.Add('');

    li.SubItems.Add(SubdivisionTable.TableErrors.Items[i].Description);
    li.Data := SubdivisionTable.TableErrors.Items[i];
  end;
end;

procedure TfrmSubdivisionEditFrame.lwErrorsDblClick(Sender: TObject);
var err: TTableError;
    cell: TGridCell;
begin
  if Assigned(lwErrors.Selected) then
  begin
    err := TTableError(lwErrors.Selected.Data);
    if err.ColumnAddress > 0 then
      cell.Col := err.ColumnAddress
    else
      cell.Col := 0;

    if err.RowAddress - ALTITUDE_ROW_INDEX - 1 > 0 then
      cell.Row := err.RowAddress - ALTITUDE_ROW_INDEX - 1
    else
      cell.Row := 0;

    grdSubdivisionTable.MakeCellVisible(cell, false);
    grdSubdivisionTable.Row := cell.Row;
    grdSubdivisionTable.Col := cell.Col;

    grdSubdivisionTable.SetFocus;
  end;
end;



procedure TfrmSubdivisionEditFrame.grdSubdivisionTableEditAcceptKey(
  Sender: TObject; Cell: TGridCell; Key: Char; var Accept: Boolean);
begin
  Accept := pos(Key, '0123456789.') > 0;

  if Accept then
  if Key = '.' then Accept := Pos(Key, grdSubdivisionTable.Cells[Cell.Col, Cell.Row]) = 0;
end;

procedure TfrmSubdivisionEditFrame.grdSubdivisionTableSetEditText(
  Sender: TObject; Cell: TGridCell; var Value: String);
var fDepth: single;
begin
  // проверяем число ли в ячейке
  fDepth := StrToFloatEx(Value);

  if fDepth > -1 then
  begin
    BaseTableCell[Cell.Col,Cell.Row].Value := fDepth;
    // повторяем проверки
    SubdivisionTable.CheckSubdivisions((TMainFacade.GetInstance as TMainFacade).AllSubdivisionComments);
    SubdivisionTable.CheckEmptyRows;
    grdSubdivisionTable.Refresh;
  end;
end;

procedure TfrmSubdivisionEditFrame.grdSubdivisionTableMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var cell: TGridCell;
    ids: TIDObjectSearch;
begin

  if not AllowEdit then Exit;

  if Button = mbLeft then
  begin
    cell := grdSubdivisionTable.GetCellAt(X, Y);
    if (Cell.Col = -1) or (Cell.Row = -1) then exit;
    if cell.Col <= 1 then
    begin
      frmVerifyStratons := TfrmVerifyStratons.Create(Self);

      frmVerifyStratons.FoundStratons.Clear;
      ids := TIDObjectSearch(BaseTableCell[Cell.Col,Cell.Row].Data);
      if Assigned(ids) and Assigned(ids.IDObject) then
      begin
        frmVerifyStratons.FoundStratons.Clear;
        frmVerifyStratons.FoundStratons.Add(ids.IDObject as TSimpleStraton, false, false);
        frmVerifyStratons.LoadFoundStratons;
      end;


      if frmVerifyStratons.ShowModal = mrOk then
      begin
        if not Assigned(ids) then
        begin
          if frmVerifyStratons.CheckedStratons.Count > 0 then
          begin
            ids := SubdivisionTable.IDObjectSearches.Add(Cell.Col, Cell.Row + ALTITUDE_ROW_INDEX + 1, frmVerifyStratons.CheckedStratons.Items[0], mtExact);
            BaseTableCell[Cell.Col,Cell.Row].Data := ids;
            BaseTableCell[Cell.Col,Cell.Row].Value := ids.IDObject.List;
          end
          else
          begin
            BaseTableCell[Cell.Col,Cell.Row].Data := nil;
            BaseTableCell[Cell.Col,Cell.Row].Value := '';
          end;
        end
        else
        begin
          if frmVerifyStratons.CheckedStratons.Count > 0 then
          begin
            ids.IDObject := frmVerifyStratons.CheckedStratons.Items[0];
            BaseTableCell[Cell.Col,Cell.Row].Value := '';
          end
          else
          begin
            SubdivisionTable.IDObjectSearches.Remove(ids);
            BaseTableCell[Cell.Col,Cell.Row].Data := nil;
            BaseTableCell[Cell.Col,Cell.Row].Value := '';
          end;
        end;

        grdSubdivisionTable.Refresh;
      end;


    end;

  end;
end;

procedure TfrmSubdivisionEditFrame.grdSubdivisionTableHeaderClick(
  Sender: TObject; Section: TGridHeaderSection);
var w: TSimpleWell;
    a: TSimpleArea;
    sWellNum, sAreaName: string;
    idsArea, idsWell: TIDObjectSearch;
    err: TTableError;
begin
  if not AllowEdit then Exit;
  
  if Section.Level in [0, 1] then // для скважин
  begin
    err := SubdivisionTable.TableErrors.GetErrorByCellAddress(WELL_NUMBER_ROW_INDEX, Section.Index);

    if not Assigned(frmWellConfirm) then frmWellConfirm := TfrmWellConfirm.Create(Application.MainForm);

    w := nil; a := nil;  idsWell := nil;
    idsArea := TIDObjectSearch(SubdivisionTable.AreaRow[Section.ColumnIndex].Data);
    if Assigned(idsArea) then
    begin
      idsWell := TIDObjectSearch(SubdivisionTable.WellRow[Section.ColumnIndex].Data);
      if Assigned(idsWell.IDObject) then
      begin
        w := TIDObjectSearch(SubdivisionTable.WellRow[Section.ColumnIndex].Data).IDObject as TSimpleWell;
        a := w.Area;
      end
    end;

    if not Assigned(w) then
    begin
      if Assigned(idsArea) then
      begin
        if Assigned(idsArea.IDObject) then
          a := idsArea.IDObject as TSimpleArea;
      end;
    end;

    if Assigned(w) then sWellNum := w.NumberWell else sWellNum := SubdivisionTable.WellRow[Section.ColumnIndex].AsString;
    if Assigned(a) then sAreaName := a.Name else sAreaName := SubdivisionTable.AreaRow[Section.ColumnIndex].AsString;

    sWellNum := trim(sWellNum);

    sAreaName := trim(sAreaName); 


    frmWellConfirm.SetAreaAndWell(sAreaName, sWellNum);
    if frmWellConfirm.ShowModal = mrOk then
    begin
      if Assigned(idsArea) then idsArea.IDObject := frmWellConfirm.SelectedArea
      else idsArea := SubdivisionTable.IDObjectSearches.Add(Section.ColumnIndex, AREA_ROW_INDEX, frmWellConfirm.SelectedArea, mtExact);

      if Assigned(idsWell) then idsWell.IDObject := frmWellConfirm.SelectedWell
      else idsWell := SubdivisionTable.IDObjectSearches.Add(Section.ColumnIndex, WELL_NUMBER_ROW_INDEX, frmWellConfirm.SelectedWell, mtExact);

      SubdivisionTable.AreaRow[Section.ColumnIndex].Value := frmWellConfirm.SelectedArea.Name;
      SubdivisionTable.AreaRow[Section.ColumnIndex].Data := idsArea;
      SubdivisionTable.WellRow[Section.ColumnIndex].Value := frmWellConfirm.SelectedWell.NumberWell;
      SubdivisionTable.WellRow[Section.ColumnIndex].Data := idsWell;
      if Section.Level = 0 then
      begin
        Section.Caption := frmWellConfirm.SelectedArea.Name;
        Section.Sections[0].Caption := frmWellConfirm.SelectedWell.NumberWell;
      end
      else
      begin
        Section.Caption := frmWellConfirm.SelectedWell.NumberWell;
        Section.Parent.Caption := frmWellConfirm.SelectedArea.Name;
      end;
      if Assigned(err) then SubdivisionTable.TableErrors.Remove(err);
      grdSubdivisionTable.Refresh;
    end;
  end;
end;

procedure TfrmSubdivisionEditFrame.actnSavetoDBUpdate(Sender: TObject);
begin
  actnSavetoDB.Enabled := Assigned(SubdivisionTable) and (SubdivisionTable.TableErrors.CriticalErrorCount = 0);
end;

procedure TfrmSubdivisionEditFrame.actnSavetoDBExecute(Sender: TObject);
var i, j: integer;
    wls: TWells;
begin
  if not Assigned(frmThemeSelect) then  frmThemeSelect := TfrmThemeSelect.Create(Self);
  with frmThemeSelect do
  if  ShowModal = mrOk then
  begin
    ExportToExcel('');
    SubdivisionTable.OnSetProgress := SetProgress;
    SubdivisionTable.OnMoveProgress := MoveProgress;
    wls := TMainFacade.GetInstance.AllWells;

    SubdivisionTable.MakeSubdivisions(Theme, SiginingDate, Employee, wls);

    frmStep.InitSubProgress(0, wls.Count, 1);

    for i := 0 to wls.Count - 1 do
    begin
      wls.Items[i].Subdivisions.DeleteMarkedObjects;
      for j := 0 to wls.Items[i].Subdivisions.Count - 1 do
      if wls.Items[i].Subdivisions.Items[j].Theme.ID = Theme.ID then
         wls.Items[i].Subdivisions.Items[j].Update();

      frmStep.MakeSubStep('Сохранение разбивок в БД системы');
    end;

    frmStep.Close;
    ShowMessage('Сохранение успешно завершено!'); 
  end;
end;

procedure TfrmSubdivisionEditFrame.MoveProgress(Sender: TObject);
begin
  frmStep.MakeStep('Сохранение столбцов таблицы');
end;

procedure TfrmSubdivisionEditFrame.SetProgress(Sender: TObject);
begin
  if not Assigned(frmStep) then frmStep := TfrmStep.Create(Self);
  frmStep.ShowLog := false;
  frmStep.ShowSubPrg := true;
  frmStep.InitProgress(0, SubdivisionTable.Columns.Count - 2, 1);
  frmStep.Show;
end;

procedure TfrmSubdivisionEditFrame.actnCheckExecute(Sender: TObject);
begin
  SubdivisionTable.TableErrors.Clear;
  SubdivisionTable.CheckHeader; 
  SubdivisionTable.CheckSubdivisions((TMainFacade.GetInstance as TMainFacade).AllSubdivisionComments);
  SubdivisionTable.CheckEmptyRows;
  SubdivisionTable.CheckStratons;
  SubdivisionTable.CheckComments;
  LoadErrors;
end;

procedure TfrmSubdivisionEditFrame.actnExcelExportExecute(Sender: TObject);
begin
  if dlgOpen.Execute then ExportToExcel(dlgOpen.FileName); 
end;

procedure TfrmSubdivisionEditFrame.FinishProgress(Sender: TObject);
begin

end;

procedure TfrmSubdivisionEditFrame.actnPlaceCommentExecute(
  Sender: TObject);
var cm: TSubdivisionComment;
    i: integer;
    e: TTableError;
    iResult: Integer;
begin
  cm := TObject(actnPlaceComment.ActionComponent.Tag) as TSubdivisionComment;

  if Assigned(cm) and Assigned(ActiveCell) then
  begin
    if cm.ID = SUBDIVISION_COMMENT_NOT_CROSSED then
    begin
      if MessageDlg('Вы выставляете отметку "нв" (не вскрыто). Все последующие стратоны для данной скважины будут также маркированы ею. Вы действительно хотите поставить нв?', mtConfirmation, mbYesNoCancel, 0) = mrYes then
      begin
        ActiveCell.Data := cm;
        ActiveCell.Value := cm.ShortName;
        for i := grdSubdivisionTable.Row + 1 to grdSubdivisionTable.Rows.Count - 2 do
        if Assigned(BaseTableCell[grdSubdivisionTable.Col, i]) then
        begin
          BaseTableCell[grdSubdivisionTable.Col, i].Data := cm;
          BaseTableCell[grdSubdivisionTable.Col, i].Value := cm.ShortName;
        end;
        grdSubdivisionTable.Refresh;
      end;
    end
    else
    begin
      iResult := MessageDlg('Изменить всю ошибочную последовательность, начиная с текущей ячейки (да) или только текущую ячейку (нет)?', mtConfirmation, mbYesNoCancel, 0);
      if iResult = mrNo then
      begin;
        ActiveCell.Data := cm;
        ActiveCell.Value := cm.ShortName;
      end
      else if iResult = mrYes then
      begin
        ActiveCell.Data := cm;
        ActiveCell.Value := cm.ShortName;
        for i := grdSubdivisionTable.Row + 1 to grdSubdivisionTable.Rows.Count - 2 do
        begin
          e := SubdivisionTable.TableErrors.GetErrorByCellAddress(i + ALTITUDE_ROW_INDEX + 1, grdSubdivisionTable.Col);
          if Assigned(e) then
          begin
            BaseTableCell[grdSubdivisionTable.Col, i].Data := cm;
            BaseTableCell[grdSubdivisionTable.Col, i].Value := cm.ShortName;
          end
          else break;
        end;
      end;
      grdSubdivisionTable.Refresh;
    end;
  end;
end;

procedure TfrmSubdivisionEditFrame.actnPlaceCommentUpdate(Sender: TObject);
var cm: TSubdivisionComment;
begin
  if Assigned(actnPlaceComment.ActionComponent) then
  begin
    cm := TObject(actnPlaceComment.ActionComponent.Tag) as TSubdivisionComment;
    (actnPlaceComment.ActionComponent as TMenuItem).Enabled := CanPlaceComment(grdSubdivisionTable.Col, grdSubdivisionTable.Row, cm);
  end;
end;

function TfrmSubdivisionEditFrame.GetActiveCell: TBaseTableCell;
begin
  Result := BaseTableCell[grdSubdivisionTable.Col, grdSubdivisionTable.Row];
end;

function TfrmSubdivisionEditFrame.GetBaseTableCell(ACol,
  ARow: integer): TBaseTableCell;
begin
  try
    Result := SubdivisionTable.Columns[ACol][ARow + ALTITUDE_ROW_INDEX + 1];
  except
    Result := nil;
  end;
end;

function TfrmSubdivisionEditFrame.CanPlaceComment(ACol, ARow: integer;
  AComment: TSubdivisionComment): boolean;
begin
  Result := SubdivisionTable.CanPlaceComment(ACol, ARow + ALTITUDE_ROW_INDEX + 1, AComment);
end;

procedure TfrmSubdivisionEditFrame.pmCommentsPopup(Sender: TObject);
var i: integer;
begin
  for i := 2 to pmComments.Items.Count - 1 do
    pmComments.Items[i].Enabled := CanPlaceComment(grdSubdivisionTable.Col, grdSubdivisionTable.Row, TSubdivisionComment(pmComments.Items[i].Tag));
end;

procedure TfrmSubdivisionEditFrame.grdSubdivisionTableCellTips(
  Sender: TObject; Cell: TGridCell; var AllowTips: Boolean);
begin
  AllowTips := true;
end;

procedure TfrmSubdivisionEditFrame.lwErrorsColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  Case Column.Index of
  0: SubdivisionTable.TableErrors.SortByColumn;
  1: SubdivisionTable.TableErrors.SortByRow;
  2: SubdivisionTable.TableErrors.SortByDescription;
  end;
  LoadErrors;

end;

procedure TfrmSubdivisionEditFrame.actnGoToErrorExecute(Sender: TObject);
var err: TTableError;
    iIndex: integer;
begin
  err := SubdivisionTable.TableErrors.GetErrorByCellAddress(grdSubdivisionTable.Row + ALTITUDE_ROW_INDEX + 1, grdSubdivisionTable.Col, true);
  if Assigned(err) then
  begin
    iIndex := GetTableErrorListIndex(err);
    if iIndex > -1 then
    begin
      lwErrors.Items[iIndex].Selected := true;
      lwErrors.SetFocus;
    end;
  end;
end;

procedure TfrmSubdivisionEditFrame.actnGoToErrorUpdate(Sender: TObject);
begin
  actnGoToError.Enabled := Assigned(SubdivisionTable) and  Assigned(SubdivisionTable.TableErrors.GetErrorByCellAddress(grdSubdivisionTable.Row + ALTITUDE_ROW_INDEX + 1, grdSubdivisionTable.Col, true));
end;

function TfrmSubdivisionEditFrame.GetTableErrorListIndex(
  AErr: TTableError): integer;
var i: integer;
begin
  Result := -1;
  for i := 0 to lwErrors.Items.Count - 1 do
  if lwErrors.Items[i].Data = AErr then
  begin
    Result := i;
    break;
  end;
end;

procedure TfrmSubdivisionEditFrame.SetAllowEdit(const Value: boolean);
begin
  if FAllowEdit <> Value then
  begin
    FAllowEdit := Value;
    tlbrButtons.Visible := FAllowEdit;
    grdSubdivisionTable.AllowEdit := FAllowEdit;
    pmComments.AutoPopup := FAllowEdit;
    lwErrors.Visible := FAllowEdit;
  end;
end;

procedure TfrmSubdivisionEditFrame.PrepareCommentEditMenu;
var i: integer;
    mi: TMenuItem;
begin


  if pmComments.Items.Count = 0 then
  begin
    mi := TMenuItem.Create(pmComments);
    mi.Action := actnGoToError;
    pmComments.Items.Add(mi);


    mi := TMenuItem.Create(pmComments);
    mi.Caption := '-';
    pmComments.Items.Add(mi);

    with (TMainFacade.GetInstance as TMainFacade).AllSubdivisionComments do
    for i := 0 to Count - 1 do
    if (Items[i].ID  <> SUBDIVISION_COMMENT_NULL) and (Items[i].ID <> SUBDIVISION_COMMENT_STOP) then
    begin
      mi := TMenuItem.Create(pmComments);

      mi.Tag := Integer(Items[i]);
      mi.Action := actnPlaceComment;
      mi.Caption := Items[i].ShortName;
      pmComments.Items.Add(mi);
    end;


  end;
end;

procedure TfrmSubdivisionEditFrame.Clear;
begin
  grdSubdivisionTable.Rows.Count := 0;
  grdSubdivisionTable.Columns.Clear;
  grdSubdivisionTable.Header.Sections.Clear;
  FSubdivisionTable := nil;
end;

destructor TfrmSubdivisionEditFrame.Destroy;
begin
  Clear;
  inherited;
end;

procedure TfrmSubdivisionEditFrame.ExportToExcel(AFileName: string);
var varTable: OleVariant;
    i, j: integer;
    excel, wb: OleVariant;

    FileGUID : TGUID;
    sPath: string;

begin
  with grdSubdivisionTable do
  begin
    varTable := VarArrayCreate([0, Rows.Count + ALTITUDE_ROW_INDEX + 1 , 0, Columns.Count - 1], varVariant);


    for i := 0 to Rows.Count - 1 do
    for j := 0 to Columns.Count - 1 do
      varTable[i + ALTITUDE_ROW_INDEX + 1, j] := Cells[j, i];

    varTable[0, 0] := 'Глубина подошвы';
    for j := 0 to Columns.Count - 1 do
    begin
      varTable[1, j] := Header.Sections[j].Caption;
      if Header.Sections[j].Sections.Count > 0 then
      begin
        varTable[2, j] := Header.Sections[j].Sections[0].Caption;
        if Header.Sections[j].Sections[0].Sections.Count > 0 then
        begin
          varTable[3, j] := Header.Sections[j].Sections[0].Sections[0].Caption;
          if Header.Sections[j].Sections[0].Sections[0].Sections.Count > 0 then
            varTable[4, j] := Header.Sections[j].Sections[0].Sections[0].Sections[0].Caption;
        end;
      end;
    end;



    excel := CreateOleObject('Excel.Application');
    excel.Visible := false;
    excel.Application.EnableEvents := false;
    excel.Application.ScreenUpdating := false;

    wb := excel.WorkBooks.Add;
    wb.Worksheets[1].Range[wb.Worksheets[1].Cells[1, 1], wb.Worksheets[1].Cells[Rows.Count + ALTITUDE_ROW_INDEX + 1, Columns.Count]] := varTable;


    wb.Worksheets[1].Columns.Autofit;
    //wb.Worksheets[1].Cells.NumberFormat := '0.0';
    wb.Worksheets[1].Range['C6'].Select;
    excel.ActiveWindow.FreezePanes := True;



    for i := 7 to 12 do
    begin
      wb.Worksheets[1].UsedRange.Borders[i].LineStyle := 1;
      wb.Worksheets[1].UsedRange.Borders[i].ColorIndex := 0;
      wb.Worksheets[1].UsedRange.Borders[i].TintAndShade := 0;
      wb.Worksheets[1].UsedRange.Borders[i].Weight := 2;
    end;

    //wb.Worksheets[1].Rows[3].NumberFormat := '@';
    wb.Worksheets[1].Rows[2].Font.Bold := true;
    wb.Worksheets[1].Rows[3].Font.Bold := true;


    if trim(AFileName) = '' then
    begin
      CreateGUID(FileGUID);
      sPath := ExtractFilePath(ParamStr(0)) + 'StratReportBackups\' + GUIDToString(FileGUID) + '.xlsx';
      CreatePath(ExtractFileDir(sPath));
    end
    else
    begin
      sPath := AFileName;
      excel.Visible := true;
    end;
    
    wb.SaveAs (sPath);

    excel.Application.EnableEvents := true;
    excel.Application.ScreenUpdating := true;
  end;
end;

end.
