unit RRManagerGroupReportFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, RRManagerBaseGUI, ExtCtrls, ComCtrls, ActnList, ToolWin,
  ImgList, StdCtrls, RRManagerReport, RRManagerBaseObjects, BaseObjects;

type
//  TfrmGroupReport = class(TFrame)
  TfrmGroupReport = class(TBaseFrame)
    pnlAll: TPanel;
    pnlButtons: TPanel;
    lwGroups: TListView;
    lwColumns: TListView;
    imgLst: TImageList;
    tlbrButtons: TToolBar;
    ToolButton1: TToolButton;
    actnLst: TActionList;
    actnMakeGroup: TAction;
    actnAddGroupItem: TAction;
    actnDelete: TAction;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    procedure actnMakeGroupExecute(Sender: TObject);
    procedure actnMakeGroupUpdate(Sender: TObject);
    procedure actnAddGroupItemExecute(Sender: TObject);
    procedure actnAddGroupItemUpdate(Sender: TObject);
    procedure actnDeleteUpdate(Sender: TObject);
    procedure actnDeleteExecute(Sender: TObject);
  private
    FReportColumns: TReportColumns;
    FGroups: TReportGroups;
    procedure ReloadColumns;
    procedure ReloadGroups;
    procedure SetReportColumns(const Value: TReportColumns);
    function  GetReport: TCommonReport;
    { Private declarations }
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure ClearControls; override;
    procedure RegisterInspector; override;
  public
    { Public declarations }
    property    CommonReport: TCommonReport read GetReport;
    property    Columns: TReportColumns read FReportColumns write SetReportColumns;
    procedure   Save; override;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

{$R *.dfm}

{ TfrmGroupReport }

procedure TfrmGroupReport.ClearControls;
begin
  inherited;

end;

procedure TfrmGroupReport.FillControls;
var R: TCommonReport;
begin
  if not Assigned(ABaseObject) then R := CommonReport
  else R := ABaseObject as TCommonReport;

  FGroups.Assign(R.Groups);
  ReloadGroups;
end;

procedure TfrmGroupReport.RegisterInspector;
begin
  inherited;

end;

procedure TfrmGroupReport.actnMakeGroupExecute(Sender: TObject);
var rg: TReportGroup;
begin
  rg := FGroups.Add;
  rg.GroupingColumn.Assign(TReportColumn(lwColumns.Selected.Data));
  ReloadGroups;
end;

procedure TfrmGroupReport.actnMakeGroupUpdate(Sender: TObject);
begin
  actnMakeGroup.Enabled := Assigned(lwColumns.Selected) and (FGroups.IndexOfColName(TReportColumn(lwColumns.Selected.Data).ColName) = -1);
end;

procedure TfrmGroupReport.actnAddGroupItemExecute(Sender: TObject);
var rg: TReportGroup;
    cl: TReportColumn; 
begin
  rg := TReportGroup(lwGroups.Selected.Data);
  cl := TReportColumn.Create;
  cl.Assign(TReportColumn(lwColumns.Selected.Data));
  rg.AggregateColumns.Add(cl);
  ReloadGroups;
end;

procedure TfrmGroupReport.actnAddGroupItemUpdate(Sender: TObject);
begin
  actnAddGroupItem.Enabled := Assigned(lwColumns.Selected) and Assigned(lwGroups.Selected) and
                              (TObject(lwGroups.Selected.Data) is TReportGroup) and
                              ((TObject(lwGroups.Selected.Data) as TReportGroup).AggregateColumns.IndexByName(TReportColumn(lwColumns.Selected.Data).ColName) = -1);
end;

procedure TfrmGroupReport.actnDeleteUpdate(Sender: TObject);
begin
  actnDelete.Enabled := Assigned(lwGroups.Selected);
end;

procedure TfrmGroupReport.actnDeleteExecute(Sender: TObject);
var cls: TReportColumns;
begin
  if TObject(lwGroups.Selected.Data) is TReportGroup then
    (TObject(lwGroups.Selected.Data) as TReportGroup).Free
  else
  if TObject(lwGroups.Selected.Data) is TReportColumn then
  begin
    cls := (TObject(lwGroups.Selected.Data) as TReportColumn).Columns.GroupOwner.AggregateColumns;
    cls.Delete(cls.IndexByName((TObject(lwGroups.Selected.Data) as TReportColumn).ColName));
  end;
  ReloadGroups;
end;

procedure TfrmGroupReport.SetReportColumns(const Value: TReportColumns);
var i: integer;
    cl: TReportColumn;
begin
  if FReportColumns <> Value then
  begin
    // так сделано чтобы раз установленный порядок столбцов не менялся
    // если просто присваивать, новые столбцы то старательно настроенная очередность - теряется
    for i := FReportColumns.Count - 1 downto 0 do
    if not Assigned(Value.ColByName(FReportColumns.Items[i].ColName)) then
      FReportColumns.Delete(i);

    for i := 0 to Value.Count - 1 do
    if not Assigned(FReportColumns.ColByName(Value.Items[i].ColName)) then
    begin
      cl := TReportColumn.Create;
      cl.Assign(Value.Items[i]);
      FReportColumns.Add(cl);
    end;

    ReloadColumns;
  end;
end;

procedure TfrmGroupReport.ReloadColumns;
var i: integer;
begin
  lwColumns.Items.BeginUpdate;
  lwColumns.Items.Clear;
  for i := 0 to FReportColumns.Count - 1 do
    lwColumns.AddItem(FReportColumns.Items[i].RusColName, FReportColumns.Items[i]);
  lwColumns.Items.EndUpdate;
end;

function TfrmGroupReport.GetReport: TCommonReport;
begin
  Result := EditingObject as TCommonReport;
end;

constructor TfrmGroupReport.Create(AOwner: TComponent);
begin
  inherited;
  FGroups := TReportGroups.Create(nil);
  FReportColumns := TReportColumns.Create;
  NeedCopyState := false;
end;

destructor TfrmGroupReport.Destroy;
begin
  FReportColumns.Free;
  FGroups.Free;
  inherited;
end;

procedure TfrmGroupReport.ReloadGroups;
var i, j: integer;
    li: TListItem;
begin
  // грузим группы
  lwGroups.Items.BeginUpdate;
  lwGroups.Clear;
  for i := 0 to FGroups.Count - 1 do
  begin
    li := lwGroups.Items.Add;
    li.Caption := FGroups.Items[i].List(loFull, false, false);
    li.Data := FGroups.Items[i];

    for j := 0 to FGroups.Items[i].AggregateColumns.Count - 1 do
    begin
      li := lwGroups.Items.Add;
      li.Caption := '   ' + FGroups.Items[i].AggregateColumns.Items[j].List;
      li.Data := FGroups.Items[i].AggregateColumns.Items[j];
    end;
  end;

  lwGroups.Items.EndUpdate;
end;

procedure TfrmGroupReport.Save;
begin
  if not Assigned(EditingObject) then
    FEditingObject := AllReports.Items[AllReports.Count - 1];

  CommonReport.Groups.Clear;
  CommonReport.Groups.Assign(FGroups);
end;

end.
