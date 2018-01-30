unit GRRClientGISReports;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, CheckLst, ExtCtrls, Mask, ToolEdit;

type
  TfrmGISReports = class(TForm)
    pnlButtons: TPanel;
    btnOK: TButton;
    btnClose: TButton;
    gbxAll: TGroupBox;
    pbQueryProgress: TProgressBar;
    pnlPath: TPanel;
    edtPath: TDirectoryEdit;
    lblPath: TLabel;
    chbxXLReports: TCheckBox;
    pnlAll: TPanel;
    chklstQueries: TCheckListBox;
    chklstVersions: TCheckListBox;
    spl1: TSplitter;
    procedure btnOKClick(Sender: TObject);
    procedure chklstQueriesClickCheck(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure edtPathChange(Sender: TObject);
  private
    { Private declarations }
    procedure ReportProgress(Sender: TObject);     
  public
    { Public declarations }

    procedure Prepare;
  end;

var
  frmGISReports: TfrmGISReports;

implementation

uses Facade, GRRClientGISQueries;

{$R *.dfm}

{ TfrmGISReports }

procedure TfrmGISReports.Prepare;
begin
  chklstQueries.Items.Clear;
  TMainFacade.GetInstance.AllVersions.MakeList(chklstVersions.Items);
  TMainFacade.GetInstance.GRRReportConcreteQueries.MakeList(chklstQueries.Items);
  TMainFacade.GetInstance.GRRReportConcreteQueries.OnExcecute := ReportProgress;
end;

procedure TfrmGISReports.ReportProgress(Sender: TObject);
begin
  Sleep(6000);
  pbQueryProgress.StepIt;
end;

procedure TfrmGISReports.btnOKClick(Sender: TObject);
begin
  pbQueryProgress.Min := 0;
  pbQueryProgress.Max := TMainFacade.GetInstance.GRRReportConcreteQueries.SelectedCount;
  TMainFacade.GetInstance.GRRReportConcreteQueries.Execute(edtPath.Text);  
end;

procedure TfrmGISReports.chklstQueriesClickCheck(Sender: TObject);
begin
  (chklstQueries.Items.Objects[chklstQueries.ItemIndex] as TGRRReportQuery).Selected := chklstQueries.Checked[chklstQueries.ItemIndex];
end;

procedure TfrmGISReports.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmGISReports.edtPathChange(Sender: TObject);
begin
  btnOK.Enabled := true;
end;

end.
