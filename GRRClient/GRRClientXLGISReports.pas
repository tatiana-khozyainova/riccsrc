unit GRRClientXLGISReports;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, Mask, ToolEdit, ExtCtrls, ComCtrls, Version;

type
  TfrmGRRClientGISXLReports = class(TForm)
    gbxAll: TGroupBox;
    pbQueryProgress: TProgressBar;
    pnlPath: TPanel;
    lblPath: TLabel;
    edtPath: TDirectoryEdit;
    pnlAll: TPanel;
    chklstVersions: TCheckListBox;
    pnlButtons: TPanel;
    btnOK: TButton;
    btnClose: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure edtPathChange(Sender: TObject);
  private
    { Private declarations }
    FVersions: TVersions;
    procedure ReportProgress(Sender: TObject);
    function GetSelectedVersions: TVersions;
  public
    { Public declarations }
    property  SelectedVersions: TVersions read GetSelectedVersions;
    procedure Prepare;
    destructor Destroy; override;
  end;

var
  frmGRRClientGISXLReports: TfrmGRRClientGISXLReports;

implementation

uses Facade;

{$R *.dfm}

{ TfrmGRRClientGISXLReports }

procedure TfrmGRRClientGISXLReports.Prepare;
begin
  TMainFacade.GetInstance.AllVersions.MakeList(chklstVersions.Items, False, True);
  TMainFacade.GetInstance.GRRReportGISXLQueries.OnExcecute := ReportProgress;
end;

procedure TfrmGRRClientGISXLReports.ReportProgress(Sender: TObject);
begin
  Sleep(300);
  pbQueryProgress.StepIt;
end;

function TfrmGRRClientGISXLReports.GetSelectedVersions: TVersions;
var i: integer;
begin
  if not Assigned(FVersions) then
  begin
    FVersions := TVersions.Create;
    FVersions.OwnsObjects := false;
  end
  else FVersions.Clear;

  for i := 0 to chklstVersions.Count - 1 do
  if chklstVersions.Selected[i] then
    FVersions.Add(TVersion(chklstVersions.Items.Objects[i]), False, False);


  Result := FVersions;
end;

destructor TfrmGRRClientGISXLReports.Destroy;
begin
  FreeAndNil(FVersions);
  inherited;
end;

procedure TfrmGRRClientGISXLReports.btnOKClick(Sender: TObject);
begin
  TMainFacade.GetInstance.GRRReportGISXLQueries.Versions := SelectedVersions;

  pbQueryProgress.Min := 0;
  pbQueryProgress.Max := SelectedVersions.Count;
  TMainFacade.GetInstance.GRRReportGISXLQueries.Execute(edtPath.Text);
end;

procedure TfrmGRRClientGISXLReports.edtPathChange(Sender: TObject);
begin
  btnOK.Enabled := true;
end;

end.
