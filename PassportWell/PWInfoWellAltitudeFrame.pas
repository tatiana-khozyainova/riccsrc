unit PWInfoWellAltitudeFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ActnList, ExtCtrls, ComCtrls, Ex_Grid, Well,
  Altitude;

type
  TfrmAltitudesWell = class(TFrame)
    Panel1: TPanel;
    actnLst: TActionList;
    actnAddAltitude: TAction;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    actnDelAltitude: TAction;
    actnOk: TAction;
    grdAltitudes: TGridView;
    procedure actnOkExecute(Sender: TObject);
    procedure actnAddAltitudeExecute(Sender: TObject);
    procedure actnDelAltitudeExecute(Sender: TObject);
    procedure grdAltitudesDrawCell(Sender: TObject; Cell: TGridCell;
      var Rect: TRect; var DefaultDrawing: Boolean);
    procedure grdAltitudesGetEditText(Sender: TObject; Cell: TGridCell;
      var Value: String);

    procedure BeginScreenUpdate(hwnd: THandle);
    procedure EndScreenUpdate(hwnd: THandle; erase: Boolean);
    procedure grdAltitudesChanging(Sender: TObject; var Cell: TGridCell;
      var Selected: Boolean);
    procedure grdAltitudesSetEditText(Sender: TObject; Cell: TGridCell;
      var Value: String);
    procedure grdAltitudesCellClick(Sender: TObject; Cell: TGridCell;
      Shift: TShiftState; X, Y: Integer);
  private
    FWell: TWell;
    FChanging: boolean;
    FActiveAltitude: TAltitude;
  public
    property    Changing: boolean read FChanging write FChanging;
    property    ActiveAltitude: TAltitude read FActiveAltitude write FActiveAltitude;

    property    Well: TWell read FWell write FWell;

    procedure   Reload;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses Facade, Registrator, Math, Contnrs, BaseObjects;

{$R *.dfm}

{ TfrmAltitudesWell }

constructor TfrmAltitudesWell.Create(AOwner: TComponent);
begin
  inherited;
  (TMainFacade.GetInstance as TMainFacade).AllAltitudeTypes.MakeList(grdAltitudes.Columns[0].PickList);
  (TMainFacade.GetInstance as TMainFacade).AllMeasureSystemTypes.MakeList(grdAltitudes.Columns[1].PickList);

  FChanging := false;
end;

destructor TfrmAltitudesWell.Destroy;
begin

  inherited;
end;

procedure TfrmAltitudesWell.actnOkExecute(Sender: TObject);
var i, iIndex: integer;
    text: string;
    o : TAltitude;
begin
  if FChanging then
  with Well.Altitudes do
  for i := 0 to grdAltitudes.Rows.Count - 1 do
  begin
    o := Items[i];

    grdAltitudesGetEditText(grdAltitudes, GridCell(0, i), text);
    iIndex := grdAltitudes.Columns.Columns[0].PickList.IndexOf(text);
    o.AltitudeType := grdAltitudes.Columns.Columns[0].PickList.Objects[iIndex] as TAltitudeType;

    grdAltitudesGetEditText(grdAltitudes, GridCell(1, i), text);
    iIndex := grdAltitudes.Columns.Columns[1].PickList.IndexOf(text);
    o.MeasureSystemType := grdAltitudes.Columns.Columns[1].PickList.Objects[iIndex] as TMeasureSystemType;

    grdAltitudesGetEditText(grdAltitudes, GridCell(2, i), text);
    o.Value := StrToFloat(text);

    o.Order := i + 1;
  end;

  FChanging := false;
end;

procedure TfrmAltitudesWell.actnAddAltitudeExecute(Sender: TObject);
var o : TAltitude;
begin
  grdAltitudes.Rows.Count := grdAltitudes.Rows.Count + 1;
  
  o := TAltitude.Create(Well.Altitudes);
  Well.Altitudes.Add(o);
end;

procedure TfrmAltitudesWell.actnDelAltitudeExecute(Sender: TObject);
begin
  // 1) удалить из коллекции
  Well.Altitudes.Remove(ActiveAltitude);
  // 2) перестроить таблицу
  grdAltitudes.Rows.Count := grdAltitudes.Rows.Count - 1;
end;

procedure TfrmAltitudesWell.grdAltitudesDrawCell(Sender: TObject;
  Cell: TGridCell; var Rect: TRect; var DefaultDrawing: Boolean);
var text: string;
begin
  if Assigned (Well.Altitudes) then
    grdAltitudesGetEditText(Sender, Cell, text);

  with Sender as TGridView, Canvas do
  begin
    Font.Color := clBlack;
    TextRect(Rect, Rect.Left, Rect.Top, text);
  end;

  DefaultDrawing := False;
end;

procedure TfrmAltitudesWell.Reload;
begin
  grdAltitudes.Rows.Count := Well.Altitudes.Count;
end;

procedure TfrmAltitudesWell.grdAltitudesGetEditText(Sender: TObject;
  Cell: TGridCell; var Value: String);
begin
  if Assigned (Well) then
  case Cell.col of
    0 : if Assigned (Well.Altitudes.Items[Cell.Row].AltitudeType) then Value := Well.Altitudes.Items[Cell.Row].AltitudeType.Name;
    1 : if Assigned (Well.Altitudes.Items[Cell.Row].MeasureSystemType) then Value := Well.Altitudes.Items[Cell.Row].MeasureSystemType.Name;
    2 : Value := FloatToStr(Well.Altitudes.Items[Cell.Row].Value);
  end
end;

procedure TfrmAltitudesWell.BeginScreenUpdate(hwnd: THandle);
begin
  if (hwnd = 0) then hwnd := Application.MainForm.Handle;
  SendMessage(hwnd, WM_SETREDRAW, 0, 0);
end;

procedure TfrmAltitudesWell.EndScreenUpdate(hwnd: THandle; erase: Boolean);
begin
  if (hwnd = 0) then
    hwnd := Application.MainForm.Handle;
  SendMessage(hwnd, WM_SETREDRAW, 1, 0);
  RedrawWindow(hwnd, nil, 0, RDW_FRAME + RDW_INVALIDATE +
    RDW_ALLCHILDREN + RDW_NOINTERNALPAINT);
  if (erase) then
    Windows.InvalidateRect(hwnd, nil, True);
end;

procedure TfrmAltitudesWell.grdAltitudesChanging(Sender: TObject;
  var Cell: TGridCell; var Selected: Boolean);
begin
  FChanging := true;
end;

procedure TfrmAltitudesWell.grdAltitudesSetEditText(Sender: TObject;
  Cell: TGridCell; var Value: String);
begin
  if Assigned (well) then
  case Cell.col of
    0 : Well.Altitudes.Items[Cell.Row].AltitudeType := grdAltitudes.Columns.Columns[0].PickList.Objects[Cell.Row] as TAltitudeType;
    1 : Well.Altitudes.Items[Cell.Row].MeasureSystemType := grdAltitudes.Columns.Columns[1].PickList.Objects[Cell.Row] as TMeasureSystemType;
    2 : if Assigned (Well.Altitudes.Items[Cell.Row]) then Well.Altitudes.Items[Cell.Row].Value := StrToFloat(Value);
  end
end;

procedure TfrmAltitudesWell.grdAltitudesCellClick(Sender: TObject;
  Cell: TGridCell; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned (Well.Altitudes.Items[Cell.Row]) then
    ActiveAltitude := Well.Altitudes.Items[Cell.Row];
end;

end.
