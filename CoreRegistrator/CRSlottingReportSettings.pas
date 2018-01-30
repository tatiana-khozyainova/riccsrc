unit CRSlottingReportSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask, ToolEdit;

type
  TfrmSlottingReportSettings = class(TForm)
    pnlButtons: TPanel;
    gbxElements: TGroupBox;
    btnOK: TButton;
    btnCancel: TButton;
    chbxUseStrat: TCheckBox;
    chbxShowMetersDrilled: TCheckBox;
    chbxSaveFiles: TCheckBox;
    edtReportPath: TDirectoryEdit;
    chbxUseGenSection: TCheckBox;
    procedure chbxSaveFilesClick(Sender: TObject);
  private
    function GetUseCoreRepositoryStrat: boolean;
    function GetShowMetersDrilled: boolean;
    function GetSaveResult: boolean;
    function GetSavingPath: string;
    function GetUseGenSection: Boolean;
    function GetNoGenSectionSelection: boolean;
    procedure SetNoGenSectionSelection(const Value: boolean);
    { Private declarations }
  public
    { Public declarations }
    property NoGenSectionSelection: boolean read GetNoGenSectionSelection write SetNoGenSectionSelection;

    property UseCoreRepositoryStrat: boolean read GetUseCoreRepositoryStrat;
    property ShowMetersDrilled: boolean read GetShowMetersDrilled;
    property SaveResult: boolean read GetSaveResult;
    property UseGenSection: Boolean read GetUseGenSection;
    property SavingPath: string read GetSavingPath;
  end;

var
  frmSlottingReportSettings: TfrmSlottingReportSettings;

implementation

{$R *.dfm}

function TfrmSlottingReportSettings.GetSaveResult: boolean;
begin
  Result := chbxSaveFiles.Checked;
end;

function TfrmSlottingReportSettings.GetShowMetersDrilled: boolean;
begin
  Result := chbxShowMetersDrilled.Checked;
end;

function TfrmSlottingReportSettings.GetUseCoreRepositoryStrat: boolean;
begin
  Result := chbxUseStrat.Checked;
end;

procedure TfrmSlottingReportSettings.chbxSaveFilesClick(Sender: TObject);
begin
  edtReportPath.Enabled := SaveResult;
end;

function TfrmSlottingReportSettings.GetSavingPath: string;
begin
  Result := edtReportPath.Text;
end;

function TfrmSlottingReportSettings.GetUseGenSection: Boolean;
begin
  Result := chbxUseGenSection.Checked;
end;

function TfrmSlottingReportSettings.GetNoGenSectionSelection: boolean;
begin
  Result := not chbxUseGenSection.Visible;
end;

procedure TfrmSlottingReportSettings.SetNoGenSectionSelection(
  const Value: boolean);
begin
  chbxUseGenSection.Visible := not Value;
end;

end.
