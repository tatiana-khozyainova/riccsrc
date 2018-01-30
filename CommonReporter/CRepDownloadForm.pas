unit CRepDownloadForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonStepForm, StdCtrls, JvExStdCtrls, JvButton, JvCtrls, Mask,
  JvExMask, JvToolEdit, JvGroupBox, ActnList, CalculationLoggerFrame,
  ComCtrls, ToolWin, ExtCtrls;

type
  TfrmFileDownload = class(TfrmStep)
    gbxFile: TJvGroupBox;
    edtDirectory: TJvDirectoryEdit;
    btnGo: TJvImgBtn;
    chkDeleteDirIfExists: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnGoClick(Sender: TObject);
  private
    { Private declarations }
    procedure DoBeforeDownload(Sender: TObject);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmFileDownload: TfrmFileDownload;

implementation

uses Facade, Well;

{$R *.dfm}

{ TfrmStep1 }

constructor TfrmFileDownload.Create(AOwner: TComponent);
var sFileName: string;
begin
  inherited;

  sFileName := ExtractFilePath(ParamStr(0));
  edtDirectory.Text := copy(sFileName, 1, Length(sFileName) - 1);
  tlbr.Visible := false;
end;

procedure TfrmFileDownload.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action := caHide;
end;

procedure TfrmFileDownload.btnGoClick(Sender: TObject);
begin
  inherited;
  frmCalculationLogger.Clear;
  InitProgress(0, TMainFacade.GetInstance.SelectedWells.Count, 1);
  TMainFacade.GetInstance.OnBeforeDownload := DoBeforeDownload;
  TMainFacade.GetInstance.DownloadFiles(edtDirectory.Directory, chkDeleteDirIfExists.Checked);
end;

procedure TfrmFileDownload.DoBeforeDownload(Sender: TObject);
begin
  MakeStep((Sender as TSimpleWell).List());
end;

end.
