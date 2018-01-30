unit RRManagerReportForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FramesWizard, RRManagerReportFrame, RRManagerSelectReportingDataFrame, RRManagerReport,
  RRManagerWaitForReportFrame, RRManagerBaseGUI;

type
//  TfrmReport = class(TForm)
  TfrmReport = class(TCommonForm)
    DialogFrame1: TDialogFrame;
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
    FAfterHide: TNotifyEvent;
  protected
    function  GetDlg: TDialogFrame; override;
    function  GetEditingObjectName: string; override;
    procedure OnFinishClick(Sender: TObject);
    procedure OnCancelClick(Sender: TObject);      
  public
    { Public declarations }
    property     AfterHide: TNotifyEvent read FAfterHide write FAfterHide;
    constructor  Create(AOwner: TComponent); override;
    destructor   Destroy; override;
  end;

var
  frmReport: TfrmReport;

implementation

{$R *.DFM}

{ TfrmReport }

constructor TfrmReport.Create(AOwner: TComponent);
var actn: TBaseAction;
begin
  inherited;
  actn := TReportTablesBaseLoadAction.Create(Self);
  actn.Execute;

  dlg.CloseAfterFinish := false;
  dlg.AddFrame(TfrmSelectReport);
  dlg.AddFrame(TfrmSelectReportingData);
  dlg.AddFrame(TfrmWaitForReport);
  dlg.OnFinishClick := OnFinishClick;
  dlg.OnCancelClick := OnCancelClick;

  dlg.FinishEnableIndex := 2;
end;

destructor TfrmReport.Destroy;
begin
  inherited;
end;

function TfrmReport.GetDlg: TDialogFrame;
begin
  Result := DialogFrame1;
end;

procedure TfrmReport.FormActivate(Sender: TObject);
begin
  (dlg.Frames[0] as TfrmSelectReport).Reload;
end;

function TfrmReport.GetEditingObjectName: string;
begin
  Result := 'Отчёт о структуре';
end;

procedure TfrmReport.FormShow(Sender: TObject);
begin
  AllOpts.Push;
end;

procedure TfrmReport.FormHide(Sender: TObject);
begin
  AllOpts.Pop;
  if Assigned(FAfterHide) then FAfterHide(Sender);
end;

procedure TfrmReport.OnFinishClick(Sender: TObject);
begin
  // выдача отчета
  frmReport.Save;
end;

procedure TfrmReport.OnCancelClick(Sender: TObject);
begin
  Close;
end;

end.
