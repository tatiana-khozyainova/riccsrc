unit RRManagerCreateReportForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FramesWizard, RRManagerCreateReportFrame, RRManagerReport,
  RRManagerBaseGUI, RRManagerArrangeReportColumnsFrame, RRManagerBaseObjects,
  RRManagerGroupReportFrame;

type
  TQuerySaveAction = class;

  TfrmEditReport = class(TCommonForm)
    DialogFrame1: TDialogFrame;
  private
    { Private declarations }
    frmCreateReport: TfrmCreateReport;
    frmArrangeColumns: TfrmArrangeColumnsFrame;
    frmGroupReport: TfrmGroupReport;
  protected
    FQuerySaveAction: TBaseAction;
    function  GetDlg: TDialogFrame; override;
    function  GetEditingObjectName: string; override;
    procedure NextFrame(Sender: TObject); override;
    procedure ChangeLevel(Sender: TObject);
  public
    { Public declarations }
    procedure   Save; override;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;


  TQuerySaveAction = class(TBaseAction)
  public
    function Execute: boolean; override;
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;
var
  frmEditReport: TfrmEditReport;

implementation

uses RRManagerPersistentObjects,  ExtCtrls, ComCtrls;

{$R *.DFM}





{ TfrmEditReport }

procedure TfrmEditReport.ChangeLevel(Sender: TObject);
begin
  FQuerySaveAction.Execute;
end;

constructor TfrmEditReport.Create(AOwner: TComponent);
begin
  inherited;

  frmCreateReport := dlg.AddFrame(TfrmCreateReport) as TfrmCreateReport;
  frmCreateReport.OnChangeLevel := ChangeLevel;
  frmArrangeColumns := dlg.AddFrame(TfrmArrangeColumnsFrame) as TfrmArrangeColumnsFrame;
  frmGroupReport := dlg.AddFrame(TfrmGroupReport) as TfrmGroupReport;

  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := dlg.FrameCount - 1;

  FQuerySaveAction := TQuerySaveAction.Create(frmCreateReport);
end;

destructor TfrmEditReport.Destroy;
begin
  FQuerySaveAction.Free;
  inherited;
end;

function TfrmEditReport.GetDlg: TDialogFrame;
begin
  Result := DialogFrame1;
end;

function TfrmEditReport.GetEditingObjectName: string;
begin
  Result := 'Новый отчёт';
end;

procedure TfrmEditReport.NextFrame(Sender: TObject);
var rCols: TReportColumns;
begin
  if (Dlg.LastActiveFrameIndex < Dlg.NextActiveFrameIndex) then
  begin
    if (Dlg.NextActiveFrameIndex = 1) then
    begin
      rCols := TReportColumns.Create;
      frmCreateReport.GetSelectedColumns(rCols);
      frmArrangeColumns.Columns := rCols;
      rCols.Free;
    end
    else
    if (Dlg.NextActiveFrameIndex = 2) then
    begin
      rCols := TReportColumns.Create;
      frmCreateReport.GetSelectedColumns(rCols);
      frmGroupReport.Columns := rCols;
      rCols.Free;
    end
  end;

  inherited;

end;

procedure TfrmEditReport.Save;
begin
  inherited;
  FQuerySaveAction.Execute;
end;


{ TQuerySaveAction }

constructor TQuerySaveAction.Create(AOwner: TComponent);
begin
  inherited;

end;

function TQuerySaveAction.Execute: boolean;
begin
  Result := Execute((Owner as TfrmCreateReport).CommonReport);
end;

function TQuerySaveAction.Execute(ABaseObject: TBaseObject): boolean;
var dp: TStringPoster;
    cr: TCommonReport;
    mt, rt: TReportTable;
    Node: TTreeNode;
    jn: TJoin;
procedure AddNode(ANode: TTreeNode; ART, AMT: TReportTable);
var Child: TTreeNode;
begin
  Child := ANode.getFirstChild;
  while Assigned(Child) do
  begin
    if Child.HasChildren and (Child.SelectedIndex > 0) then
    begin
      if not Assigned(AMt) then
      begin
        AMt := cr.ReportTables.Add as TReportTable;
        AMt.Assign(TReportTable(Child.Data));
      end
      else
      begin
        ARt := cr.ReportTables.Add as TReportTable;
        ARt.Assign(TReportTable(Child.Data));

        jn := Amt.Joins.Add;
        jn.LeftTable := AMt;
        jn.RightTable := ARt;
        jn.LeftColumn := AMt.Key;
        jn.RightColumn := AMt.Key;
        AMt := ARt;
        AddNode(Child, ART, AMT);
      end;
    end
    else
    if Assigned(Art) and (Child.SelectedIndex = 1) then
      Art.Add(TReportColumn(Child.Data));

    Child := ANode.getNextChild(Child);
  end;
end;
begin
  Result := true;
  mt:= nil;
  cr := ABaseObject as TCommonReport;
  dp := TQueryTablesDataPoster.Create;
  cr.ReportTables.Clear;
  // собираем отмеченные в дереве столбцы
  // в структуру ReportTables
  with  Owner as TfrmCreateReport do
  begin
    rt := nil;
    Node := trwQuery.Items.GetFirstNode;
    while Assigned(Node) do
    begin
      if Node.HasChildren and (Node.SelectedIndex > 0) then
      begin
        if (not Assigned(mt)) then
        begin
          mt := cr.ReportTables.Add as TReportTable;
          mt.Assign(TReportTable(Node.Data));
          rt := mt;
          AddNode(Node, rt, mt);          
        end
        else
        begin
          mt := rt;
          AddNode(Node, rt, mt);
          {rt := cr.ReportTables.Add as TReportTable;
          rt.Assign(TReportTable(Node.Data));
          jn := mt.Joins.Add;
          jn.LeftTable := mt;
          jn.RightTable := rt;
          jn.LeftColumn := mt.Key;
          jn.RightColumn := mt.Key;
          mt := rt;}
        end;
      end
      else
      if Assigned(rt) and (Node.SelectedIndex = 1) then
        rt.Add(TReportColumn(Node.Data));

      Node := Node.getNextSibling;
    end;
  end;
  cr.Query := dp.PostToString(cr);
  dp.Free;
end;


end.
