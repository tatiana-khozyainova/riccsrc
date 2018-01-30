unit CRCoreTransferFullReportForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask, ToolEdit;

type
  TfrmCoreTransferFullReport = class(TForm)
    pnlButtons: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    gbxParameters: TGroupBox;
    chbxUseCurrentWells: TCheckBox;
    chbxSaveFiles: TCheckBox;
    edtReportPath: TDirectoryEdit;
  private
    function GetUseFilterWells: boolean;
    function GetSaveResult: boolean;
    function GetSavingPath: string;
    { Private declarations }
  public
    { Public declarations }
    property UseFilterWells: boolean read GetUseFilterWells;
    property SaveResult: boolean read GetSaveResult;
    property SavingPath: string read GetSavingPath;

  end;

var
  frmCoreTransferFullReport: TfrmCoreTransferFullReport;

implementation

{$R *.dfm}

{ TfrmCoreTransferFullReport }

function TfrmCoreTransferFullReport.GetSaveResult: boolean;
begin
  result := chbxSaveFiles.Checked;
end;

function TfrmCoreTransferFullReport.GetSavingPath: string;
begin
  Result := edtReportPath.Text;
end;

function TfrmCoreTransferFullReport.GetUseFilterWells: boolean;
begin
  Result := chbxUseCurrentWells.Checked;
end;

end.
