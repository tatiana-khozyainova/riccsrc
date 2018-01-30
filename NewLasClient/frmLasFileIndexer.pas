unit frmLasFileIndexer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, JvExComCtrls, JvProgressBar, Mask,
  JvExMask, JvToolEdit;

type
  TfrmLasFileIndexerForm = class(TForm)
    gbxMain: TGroupBox;
    lblSelectFolder: TLabel;
    edtSelectDirectory: TJvDirectoryEdit;
    prg: TJvProgressBar;
    pnlButtons: TPanel;
    btnStart: TButton;
    btnClose: TButton;
    lblIndexerFilePath: TLabel;
    edtIndexerFilePath: TJvDirectoryEdit;
    chbxExcludeFileName: TCheckBox;
    procedure btnCloseClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure edtSelectDirectoryChange(Sender: TObject);
  private
    { Private declarations }
    procedure DoOnMoveData(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmLasFileIndexerForm: TfrmLasFileIndexerForm;

implementation

uses Facade, ClientCommon, LasFileIndexerReport, SDReport;


{$R *.dfm}

procedure TfrmLasFileIndexerForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmLasFileIndexerForm.btnStartClick(Sender: TObject);
begin
  with TMainFacade.GetInstance do
  begin
    ReadContents(edtSelectDirectory.Directory, true);
    prg.Min := 0;
    prg.Max := FolderContents.Count;
    prg.Position := 0;
    prg.Step := 1;
    prg.Refresh;

    (TMainFacade.GetInstance.AllReports.ReportByClassType[TLasFileIndexerReport] as TLasFileIndexerReport).LasFileContents := FolderContents;
    if chbxExcludeFileName.Checked then
      (TMainFacade.GetInstance.AllReports.ReportByClassType[TLasFileIndexerReport] as TLasFileIndexerReport).ExcludeFromFilePath := edtIndexerFilePath.Directory
    else
      (TMainFacade.GetInstance.AllReports.ReportByClassType[TLasFileIndexerReport] as TLasFileIndexerReport).ExcludeFromFilePath := '';
    (TMainFacade.GetInstance.AllReports.ReportByClassType[TLasFileIndexerReport]).SaveReport := true;
    (TMainFacade.GetInstance.AllReports.ReportByClassType[TLasFileIndexerReport]).ReportPath := edtIndexerFilePath.Directory;
     TMainFacade.GetInstance.AllReports.ReportByClassType[TLasFileIndexerReport].Execute(DoOnMoveData);
  end;
end;

procedure TfrmLasFileIndexerForm.DoOnMoveData(Sender: TObject);
begin
  prg.StepIt;
  prg.Update;
end;

procedure TfrmLasFileIndexerForm.edtSelectDirectoryChange(Sender: TObject);
begin
  edtIndexerFilePath.Directory := edtSelectDirectory.Directory;
end;

end.
