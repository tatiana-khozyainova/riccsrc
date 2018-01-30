unit CRPartPlacementsReportFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CRPartPlacementsEditorFrame, ImgList, CommonFrame,
  CRPartPlacementEditorFrame, ComCtrls, ExtCtrls, StdCtrls, Mask, ToolEdit, BaseObjects;

type
  TfrmPartPlacementsReport = class(TfrmPartPlacements)
    gbxSettings: TGroupBox;
    chbxAreaTotals: TCheckBox;
    chbxPlacementTotals: TCheckBox;
    chbxOverallTotal: TCheckBox;
    chbxSaveFiles: TCheckBox;
    edtReportPath: TDirectoryEdit;
    procedure chbxSaveFilesClick(Sender: TObject);
  private
    function GetAreaTotals: boolean;
    function GetPlacementTotals: boolean;
    function GetOverallTotal: boolean;
    function GetSaveResult: boolean;
    function GetSavingPath: string;
    { Private declarations }
  public
    { Public declarations }
    property AreaTotals: boolean read GetAreaTotals;
    property PlacementTotals: boolean read GetPlacementTotals;
    property OverallTotal: boolean read GetOverallTotal;
    property SaveResult: boolean read GetSaveResult;
    property SavingPath: string read GetSavingPath;

    property SelectedObjects: TIDObjects read GetSelectedObjects write SetSelectedObjects;

    constructor Create(AOwner: TComponent); override;
  end;

var
  frmPartPlacementsReport: TfrmPartPlacementsReport;

implementation

uses Facade;

{$R *.dfm}

{ TfrmPartPlacementsReport }

constructor TfrmPartPlacementsReport.Create(AOwner: TComponent);
begin
  inherited;
  Root := TMainFacade.GetInstance.CoreLibrary;

  frmPartPlacement1.Visible := false;
  edtReportPath.Enabled := chbxSaveFiles.Checked;
  MultiSelect := true;
end;

function TfrmPartPlacementsReport.GetAreaTotals: boolean;
begin
  result := chbxAreaTotals.Checked;
end;

function TfrmPartPlacementsReport.GetPlacementTotals: boolean;
begin
  result := chbxPlacementTotals.Checked;
end;

function TfrmPartPlacementsReport.GetOverallTotal: boolean;
begin
  Result := chbxOverallTotal.Checked;
end;

function TfrmPartPlacementsReport.GetSaveResult: boolean;
begin
  Result := chbxSaveFiles.Checked;
end;

function TfrmPartPlacementsReport.GetSavingPath: string;
begin
  Result := edtReportPath.Text;
end;

procedure TfrmPartPlacementsReport.chbxSaveFilesClick(Sender: TObject);
begin
  inherited;
  edtReportPath.Enabled := chbxSaveFiles.Checked;
end;


end.
