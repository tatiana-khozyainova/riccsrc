unit RRManagerWaitForReportFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, RRManagerBaseObjects,
  StdCtrls, ComCtrls, RRManagerReport, RRManagerBaseGUI;

type
//  TfrmWaitForReport = class(TFrame)
  TfrmWaitForReport = class(TBaseFrame)
    gbxWaitForReport: TGroupBox;
    lblHeader: TLabel;
    lblData: TLabel;
    prgHeaders: TProgressBar;
    prgData: TProgressBar;
  private
    procedure MoveDataPrg(const AMin, AMax, AStep: integer);
    procedure MoveHeaderPrg(const AMin, AMax, AStep: integer);

    function GetReportFilter: TReportFilter;
    { Private declarations }
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
  public
    { Public declarations }
    property    ReportFilter: TReportFilter read GetReportFilter;
    procedure   Save; override;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

{$R *.DFM}



{ TfrmWaitForReport }

procedure TfrmWaitForReport.ClearControls;
begin
  prgHeaders.Min := 0;
  prgHeaders.Max := 200;
  prgHeaders.Position := 0;

  prgData.Min := 0;
  prgData.Max := 200;
  prgData.Position := 0;
end;

constructor TfrmWaitForReport.Create(AOwner: TComponent);
begin
  inherited;
  NeedCopyState := false;
end;

destructor TfrmWaitForReport.Destroy;
begin
  inherited;

end;

procedure TfrmWaitForReport.FillControls(ABaseObject: TBaseObject);
begin


end;

procedure TfrmWaitForReport.FillParentControls;
begin


end;

function TfrmWaitForReport.GetReportFilter: TReportFilter;
begin
  Result := EditingObject as TReportFilter;
end;

procedure TfrmWaitForReport.MoveDataPrg(const AMin, AMax,
  AStep: integer);
begin
  lblData.Visible := true;
  prgData.Visible := true;
  Update;  

  prgData.Min := AMin;
  prgData.Max := AMax;
  prgData.StepBy(AStep);
end;

procedure TfrmWaitForReport.MoveHeaderPrg(const AMin, AMax,
  AStep: integer);
begin
  lblHeader.Visible := true;
  prgHeaders.Visible := true;
  Update;

  prgHeaders.Min := AMin;
  prgHeaders.Max := AMax;
  prgHeaders.StepBy(AStep);
end;

procedure TfrmWaitForReport.Save;
begin
  inherited;
  lblHeader.Visible := false;
  prgHeaders.Visible := false;
  lblData.Visible := false;
  prgData.Visible := false;
  Update;
  prgData.Position := 0;
  prgHeaders.Position := 0;
  AllReports.MovePrg := MoveDataPrg;
  AllReports.MoveHeaderPrg := MoveHeaderPrg;
  ReportFilter.Report.MakeReport(ReportFilter.Structures);
end;

end.
