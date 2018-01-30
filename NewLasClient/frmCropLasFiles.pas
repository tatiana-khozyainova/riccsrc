unit frmCropLasFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Mask, JvExMask, JvToolEdit, ComCtrls,
  JvExComCtrls, JvProgressBar;

type
  TfrmCropLasFilesForm = class(TForm)
    gbxMain: TGroupBox;
    pnlButtons: TPanel;
    btnStart: TButton;
    btnClose: TButton;
    edtSelectDirectory: TJvDirectoryEdit;
    lblSelectFolder: TLabel;
    pgctlAll: TPageControl;
    tshByDepths: TTabSheet;
    edtStart: TEdit;
    edtFinish: TEdit;
    lblStart: TLabel;
    lblToDepth: TLabel;
    prg: TJvProgressBar;
    procedure btnCloseClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
  private
    function GetFinishDepth: Single;
    function GetStartDepth: Single;
    { Private declarations }
  public
    { Public declarations }
    property StartDepth: Single read GetStartDepth;
    property FinishDepth: Single read GetFinishDepth;
  end;

var
  frmCropLasFilesForm: TfrmCropLasFilesForm;

implementation

uses Facade, ClientCommon;

{$R *.dfm}

procedure TfrmCropLasFilesForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCropLasFilesForm.btnStartClick(Sender: TObject);
var i: Integer;
begin
  with TMainFacade.GetInstance do
  begin
    ReadContents(edtSelectDirectory.Directory, true);
    prg.Min := 0;
    prg.Max := FolderContents.Count;
    prg.Position := 0;
    prg.Step := 1;
    prg.Refresh;
    for i := 0 to FolderContents.Count - 1 do
    begin
      FolderContents.Items[i].CropByDepths(StartDepth, FinishDepth);
      prg.StepIt;
      prg.Update;
    end;
  end;
end;

function TfrmCropLasFilesForm.GetFinishDepth: Single;
begin
  Result := StrToFloatEx(edtFinish.Text);
end;

function TfrmCropLasFilesForm.GetStartDepth: Single;
begin
  Result := StrToFloatEx(edtStart.Text);
end;

end.
