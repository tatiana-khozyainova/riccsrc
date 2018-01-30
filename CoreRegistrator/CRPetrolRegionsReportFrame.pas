unit CRPetrolRegionsReportFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PetrolRegionsEditorForm, StdCtrls, ExtCtrls, CommonFrame,
  CommonParentChildTreeFrame, Mask, ToolEdit;

type
  TfrmPetrolRegionsReport = class(TfrmPetrolRegionsEditor)
    gbxSettings: TGroupBox;
    chbxAreaTotals: TCheckBox;
    chbxNGRTotals: TCheckBox;
    chbxNGOTotals: TCheckBox;
    chbxOverallTotal: TCheckBox;
    chbxSaveFiles: TCheckBox;
    edtReportPath: TDirectoryEdit;
    procedure chbxSaveFilesClick(Sender: TObject);
  private
    function GetAreaTotals: boolean;
    function GetNGOTotals: boolean;
    function GetNGRTotals: boolean;
    function GetOverallTotal: boolean;
    function GetSaveResult: boolean;
    function GetSavingPath: string;
    { Private declarations }
  public
    { Public declarations }
    property AreaTotals: boolean read GetAreaTotals;
    property NGRTotals: boolean read GetNGRTotals;
    property NGOTotals: boolean read GetNGOTotals;
    property OverallTotal: boolean read GetOverallTotal;
    property SaveResult: boolean read GetSaveResult;
    property SavingPath: string read GetSavingPath;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmPetrolRegionsReport: TfrmPetrolRegionsReport;

implementation

{$R *.dfm}

{ TfrmPetrolRegionsReport }

function TfrmPetrolRegionsReport.GetAreaTotals: boolean;
begin
  Result := chbxAreaTotals.Checked;
end;

function TfrmPetrolRegionsReport.GetNGOTotals: boolean;
begin
  Result := chbxNGOTotals.Checked;
end;

function TfrmPetrolRegionsReport.GetNGRTotals: boolean;
begin
  Result := chbxNGRTotals.Checked;
end;

function TfrmPetrolRegionsReport.GetOverallTotal: boolean;
begin
  Result := chbxOverallTotal.Checked;
end;

function TfrmPetrolRegionsReport.GetSaveResult: boolean;
begin
  result := chbxSaveFiles.Checked;
end;

function TfrmPetrolRegionsReport.GetSavingPath: string;
begin
  Result := edtReportPath.Text;
end;

procedure TfrmPetrolRegionsReport.chbxSaveFilesClick(Sender: TObject);
begin
  inherited;
  edtReportPath.Enabled := chbxSaveFiles.Checked;
end;

constructor TfrmPetrolRegionsReport.Create(AOwner: TComponent);
begin
  inherited;
  edtReportPath.Enabled := chbxSaveFiles.Checked;
end;

end.
