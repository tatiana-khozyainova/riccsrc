unit RRManagerNewReportForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RRManagerBaseGUI, FramesWizard, RRManagerReportFrame;

type
  TfrmNewReport = class(TCommonForm)
    DialogFrame1: TDialogFrame;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  protected
    function  GetDlg: TDialogFrame; override;
    function  GetEditingObjectName: string; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmNewReport: TfrmNewReport;

implementation

{$R *.DFM}

{ TfrmNewReport }

constructor TfrmNewReport.Create(AOwner: TComponent);
var frm: TfrmSelectReport;
begin
  inherited;

  frm := dlg.AddFrame(TfrmSelectReport) as TfrmSelectReport;
  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := dlg.FrameCount - 1;
  dlg.Buttons := [btFinish, btCancel];

  frm.ShowButtons := true;
  frm.ShowRemoveEmpties := false;
end;

destructor TfrmNewReport.Destroy;
begin
  inherited;

end;

function TfrmNewReport.GetDlg: TDialogFrame;
begin
  Result := DialogFrame1;
end;

function TfrmNewReport.GetEditingObjectName: string;
begin
  Result := 'Редактировать отчёты';
end;

procedure TfrmNewReport.FormActivate(Sender: TObject);
begin
  (dlg.Frames[0] as TfrmSelectReport).Reload;
end;

end.
