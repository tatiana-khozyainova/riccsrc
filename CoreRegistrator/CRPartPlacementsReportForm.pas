unit CRPartPlacementsReportForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, CommonParentChildTreeFrame,
  CRPartPlacementsEditorFrame, CRPartPlacementsReportFrame, StdCtrls,
  ExtCtrls, BaseObjects;

type
  TfrmPartPlacementReportForm = class(TForm)
    frmPartPlacementsReport1: TfrmPartPlacementsReport;
    pnlButtons: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
  private
    function GetAreaTotals: boolean;
    function GetOverallTotal: boolean;
    function GetPlacementTotals: boolean;
    function GetSaveResult: boolean;
    function GetSavingPath: string;
    function GetSelectedObjects: TIDObjects;
    procedure SetSelectedObjects(const Value: TIDObjects);
    { Private declarations }
  public
    { Public declarations }
    property AreaTotals: boolean read GetAreaTotals;
    property PlacementTotals: boolean read GetPlacementTotals;
    property OverallTotal: boolean read GetOverallTotal;
    property SaveResult: boolean read GetSaveResult;
    property SavingPath: string read GetSavingPath;
    property SelectedObjects: TIDObjects read GetSelectedObjects write SetSelectedObjects;

  end;

var
  frmPartPlacementReportForm: TfrmPartPlacementReportForm;

implementation

{$R *.dfm}

{ TfrmPartPlacementReportForm }

function TfrmPartPlacementReportForm.GetAreaTotals: boolean;
begin
  Result := frmPartPlacementsReport1.AreaTotals;
end;

function TfrmPartPlacementReportForm.GetOverallTotal: boolean;
begin
  Result := frmPartPlacementsReport1.OverallTotal;
end;

function TfrmPartPlacementReportForm.GetPlacementTotals: boolean;
begin
  Result := frmPartPlacementsReport1.PlacementTotals;
end;

function TfrmPartPlacementReportForm.GetSaveResult: boolean;
begin
  Result := frmPartPlacementsReport1.SaveResult;
end;

function TfrmPartPlacementReportForm.GetSavingPath: string;
begin
  Result := frmPartPlacementsReport1.SavingPath;
end;

function TfrmPartPlacementReportForm.GetSelectedObjects: TIDObjects;
begin
  result := frmPartPlacementsReport1.SelectedObjects;
end;

procedure TfrmPartPlacementReportForm.SetSelectedObjects(
  const Value: TIDObjects);
begin
  frmPartPlacementsReport1.SelectedObjects := Value;
end;

end.
