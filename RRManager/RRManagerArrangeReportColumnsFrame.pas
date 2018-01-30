unit RRManagerArrangeReportColumnsFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RRManagerBaseGUI, ImgList, Buttons, ExtCtrls, ComCtrls, RRManagerReport,
  ActnList, RRManagerBaseObjects;

type
//  TfrmArrangeColumnReports = class(TFrame)
  TfrmArrangeColumnsFrame = class(TBaseFrame)
    lwColumns: TListView;
    pnlButtons: TPanel;
    sbtnUp: TSpeedButton;
    sbtnDown: TSpeedButton;
    sbtnAllDown: TSpeedButton;
    sbtnAllUp: TSpeedButton;
    imgList: TImageList;
    actnList: TActionList;
    actnUp: TAction;
    actnDown: TAction;
    actnAllUp: TAction;
    actnAllDown: TAction;
    procedure actnUpExecute(Sender: TObject);
    procedure actnUpUpdate(Sender: TObject);
    procedure actnDownExecute(Sender: TObject);
    procedure actnDownUpdate(Sender: TObject);
    procedure actnAllUpExecute(Sender: TObject);
    procedure actnAllUpUpdate(Sender: TObject);
    procedure actnAllDownExecute(Sender: TObject);
    procedure actnAllDownUpdate(Sender: TObject);
    procedure lwColumnsAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
  private
    FReportColumns: TReportColumns;
    { Private declarations }
    procedure ReloadColumns;
    function  GetReport: TCommonReport;
    procedure SetReportColumns(const Value: TReportColumns);
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure ClearControls; override;
    procedure RegisterInspector; override;
  public
    { Public declarations }
    procedure   Save; override;
    property    Columns: TReportColumns read FReportColumns write SetReportColumns;
    property    Report: TCommonReport read GetReport;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

{$R *.dfm}

{ TfrmArrangeColumnReports }

procedure TfrmArrangeColumnsFrame.ClearControls;
begin
  inherited;
  lwColumns.Items.Clear;
end;

constructor TfrmArrangeColumnsFrame.Create(AOwner: TComponent);
begin
  inherited;
  FReportColumns := TReportColumns.Create;
  NeedCopyState := false;
end;

destructor TfrmArrangeColumnsFrame.Destroy;
begin
  FReportColumns.Free;
  inherited;
end;

procedure TfrmArrangeColumnsFrame.FillControls(ABaseObject: TBaseObject);
begin

end;

function TfrmArrangeColumnsFrame.GetReport: TCommonReport;
begin
  Result := EditingObject as TCommonReport;
end;

procedure TfrmArrangeColumnsFrame.RegisterInspector;
begin
  inherited;

end;

procedure TfrmArrangeColumnsFrame.SetReportColumns(
  const Value: TReportColumns);
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

procedure TfrmArrangeColumnsFrame.actnUpExecute(Sender: TObject);
var iIndex: integer;
begin
  iIndex := lwColumns.Selected.Index - 1;
  FReportColumns.Exchange(lwColumns.Selected.Index, lwColumns.Selected.Index - 1);
  ReloadColumns;
  lwColumns.Items[iIndex].Selected := true;
end;

procedure TfrmArrangeColumnsFrame.actnUpUpdate(Sender: TObject);
begin
  actnUp.Enabled := Assigned(lwColumns.Selected) and (lwColumns.Selected.Index > 0);
end;

procedure TfrmArrangeColumnsFrame.actnDownExecute(Sender: TObject);
var iIndex: integer;
begin
  iIndex := lwColumns.Selected.Index + 1;
  FReportColumns.Exchange(lwColumns.Selected.Index, lwColumns.Selected.Index + 1);
  ReloadColumns;
  lwColumns.Items[iIndex].Selected := true;
end;

procedure TfrmArrangeColumnsFrame.actnDownUpdate(Sender: TObject);
begin
  actnDown.Enabled := Assigned(lwColumns.Selected) and (lwColumns.Selected.Index < lwColumns.Items.Count - 1);
end;

procedure TfrmArrangeColumnsFrame.actnAllUpExecute(Sender: TObject);
begin
  FReportColumns.Exchange(lwColumns.Selected.Index, 0);
  ReloadColumns;
  lwColumns.Items[0].Selected := true;
end;

procedure TfrmArrangeColumnsFrame.actnAllUpUpdate(Sender: TObject);
begin
  actnAllUp.Enabled := Assigned(lwColumns.Selected) and (lwColumns.Selected.Index > 0);
end;

procedure TfrmArrangeColumnsFrame.actnAllDownExecute(Sender: TObject);
begin
  FReportColumns.Exchange(lwColumns.Selected.Index, lwColumns.Items.Count - 1);
  ReloadColumns;
  lwColumns.Items[lwColumns.Items.Count - 1].Selected := true;
end;

procedure TfrmArrangeColumnsFrame.actnAllDownUpdate(Sender: TObject);
begin
  actnAllDown.Enabled := Assigned(lwColumns.Selected) and (lwColumns.Selected.Index < lwColumns.Items.Count - 1);
end;

procedure TfrmArrangeColumnsFrame.ReloadColumns;
var i: integer;
begin
  lwColumns.Items.BeginUpdate;
  lwColumns.Items.Clear;
  for i := 0 to FReportColumns.Count - 1 do
    lwColumns.AddItem(FReportColumns.Items[i].RusColName, FReportColumns.Items[i]);
  lwColumns.Items.EndUpdate;
end;

procedure TfrmArrangeColumnsFrame.lwColumnsAdvancedCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
//var R: TRect;
begin
  {if (TReportColumn(Item.Data).Order = 1000) and not(cdsSelected in State) then
  begin
    R := Item.DisplayRect(drBounds);
    // новые обозначаем
    Sender.Canvas.Font.Style := Sender.Canvas.Font.Style + [fsBold];
    Sender.Canvas.TextOut(R.Left + 2, R.Top + 1, Item.Caption);
  end;}
end;

procedure TfrmArrangeColumnsFrame.Save;
begin
  if not Assigned(EditingObject) then
    FEditingObject := AllReports.Items[AllReports.Count - 1];

  Report.ArrangedColumns.Clear;
  Report.ArrangedColumns.Assign(FReportColumns);
end;

end.
