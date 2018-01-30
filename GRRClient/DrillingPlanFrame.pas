unit DrillingPlanFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Ex_Grid, Contnrs, Well, LicenseZone, LicenseZonePoster, baseObjects,
  GRRObligation, ObligationToolsFrame;

type


  TfrmDrillingPlan = class(TFrame)
    frmObligationTools1: TfrmObligationTools;
    procedure grdvwDrillingPlanGetCellText(Sender: TObject;
      Cell: TGridCell; var Value: String);
    procedure grdvwDrillingPlanGetCellColors(Sender: TObject;
      Cell: TGridCell; Canvas: TCanvas);
    procedure grdvwDrillingPlanEditAcceptKey(Sender: TObject;
      Cell: TGridCell; Key: Char; var Accept: Boolean);
    procedure grdvwDrillingPlanSetEditText(Sender: TObject;
      Cell: TGridCell; var Value: String);
    procedure grdvwDrillingPlanEditCloseUp(Sender: TObject;
      Cell: TGridCell; ItemIndex: Integer; var Accept: Boolean);
    procedure grdvwDrillingPlanChange(Sender: TObject; Cell: TGridCell;
      Selected: Boolean);
    procedure frmObligationTools1actnDeleteObligationExecute(
      Sender: TObject);

  private
    { Private declarations }
    FLicenseZone: TLicenseZone;
    FSaved: boolean;
    procedure ObligationsChanged(Sender: TObject);
    procedure SetLicenseZone(const Value: TLicenseZone);
    procedure LoadDrillingObligations;
    function  GetCurrentObligation: TObligation;
  public
    { Public declarations }
    property    LicenseZone: TLicenseZone read FLicenseZone write SetLicenseZone;
    property    CurrentObligation: TObligation read GetCurrentObligation;
    procedure   RefreshDrillingObligations;
    property    Saved: boolean read FSaved;
    procedure   Save;
    procedure   Cancel;

    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses Facade;

{$R *.dfm}

constructor TfrmDrillingPlan.Create(AOwner: TComponent);
begin
  inherited;
  FSaved := true;
  frmObligationTools1.OnObligationAdded := ObligationsChanged;
  frmObligationTools1.OnObligationRemoved := ObligationsChanged;
end;

procedure TfrmDrillingPlan.LoadDrillingObligations;
begin
  TMainFacade.GetInstance.AllWellCategories.MakeList(grdvwDrillingPlan.Columns[3].PickList, False, true);
  frmObligationTools1.Obligations := FLicenseZone.License.AllDrillObligations;
  RefreshDrillingObligations;
end;

procedure TfrmDrillingPlan.SetLicenseZone(const Value: TLicenseZone);
begin
  if FLicenseZone <> Value then
  begin

    FLicenseZone := Value;
    LoadDrillingObligations;
    FSaved := true;
  end;
end;

procedure TfrmDrillingPlan.grdvwDrillingPlanGetCellText(Sender: TObject;
  Cell: TGridCell; var Value: String);
begin
  case Cell.Col of
  0: Value := IntToStr(LicenseZone.License.AllDrillObligations.Items[Cell.Row].WellCount);
  1:
    begin
      if LicenseZone.License.AllDrillObligations.Items[Cell.Row].StartDate <> 0 then
        Value := DateToStr(LicenseZone.License.AllDrillObligations.Items[Cell.Row].StartDate)
      else
        Value := '';
    end;
  2:
     begin
       if LicenseZone.License.AllDrillObligations.Items[Cell.Row].FinishDate <> 0 then
         Value := DateToStr(LicenseZone.License.AllDrillObligations.Items[Cell.Row].FinishDate)
       else
         Value := '';
     end;
  3: Value := LicenseZone.License.AllDrillObligations.Items[Cell.Row].WellCategory.List();
  4: Value := LicenseZone.License.AllDrillObligations.Items[Cell.Row].Comment;
  5: Value  := LicenseZone.License.AllDrillObligations.Items[Cell.Row].DoneString;
  end;
end;

procedure TfrmDrillingPlan.grdvwDrillingPlanGetCellColors(Sender: TObject;
  Cell: TGridCell; Canvas: TCanvas);
var o: TDrillObligation;
begin
  o := LicenseZone.License.AllDrillObligations.Items[Cell.Row];

  if (o.FinishDate > 0) and (o.FinishDate <= TMainFacade.GetInstance.ActiveVersion.VersionFinishDate) then
  begin
    if o.Done then Canvas.Brush.Color := $00C8F9E3
    else Canvas.Brush.Color := $00DFE7FF;
  end
  else if o.Done then Canvas.Brush.Color := $00C8F9E3
end;

procedure TfrmDrillingPlan.grdvwDrillingPlanEditAcceptKey(Sender: TObject;
  Cell: TGridCell; Key: Char; var Accept: Boolean);
begin
  Accept := not(Cell.Col in [3, 5]);

  if Accept then
  begin
    // well number
    if Cell.Col = 0 then
      Accept := Pos(Key, '0123456789') > 0
    else if (Cell.Col in [1, 2]) then
      Accept := (Pos(Key, '0123456789.') > 0);
  end;
end;

procedure TfrmDrillingPlan.grdvwDrillingPlanSetEditText(Sender: TObject;
  Cell: TGridCell; var Value: String);
begin
  Value := trim(Value);

  case Cell.Col of
  0:
  begin
    LicenseZone.License.AllDrillObligations.Items[Cell.Row].WellCount := StrToInt(Value);
    FSaved := false;
  end;
  1:
  begin
    if Value <> '' then
      LicenseZone.License.AllDrillObligations.Items[Cell.Row].StartDate := StrToDateTime(Value)
    else
      LicenseZone.License.AllDrillObligations.Items[Cell.Row].StartDate := 0;
    grdvwDrillingPlan.Refresh;
    FSaved := false;
  end;
  2:
  begin
    if Value <> '' then
      LicenseZone.License.AllDrillObligations.Items[Cell.Row].FinishDate := StrToDateTime(Value)
    else
      LicenseZone.License.AllDrillObligations.Items[Cell.Row].FinishDate := 0;
    grdvwDrillingPlan.Refresh;      
    FSaved := false;
  end;
  4:
  begin
    LicenseZone.License.AllDrillObligations.Items[Cell.Row].Comment := Value;
    FSaved := false;
  end;
  end;
end;

procedure TfrmDrillingPlan.grdvwDrillingPlanEditCloseUp(Sender: TObject;
  Cell: TGridCell; ItemIndex: Integer; var Accept: Boolean);
begin
  if ItemIndex > -1 then
  begin
    if Cell.Col = 3 then
    begin
      LicenseZone.License.AllDrillObligations.Items[Cell.Row].WellCategory := TMainFacade.GetInstance.AllWellCategories.Items[ItemIndex];
      FSaved := false;
    end;
  end;
end;

procedure TfrmDrillingPlan.Cancel;
begin
  LicenseZone.License.ClearDrillObligations;
end;

procedure TfrmDrillingPlan.Save;
begin
  LicenseZone.License.AllDrillObligations.Update(nil);
end;


procedure TfrmDrillingPlan.ObligationsChanged(Sender: TObject);
begin
  grdvwDrillingPlan.Rows.Count := LicenseZone.License.AllDrillObligations.Count;
  FSaved := false;
  grdvwDrillingPlan.Refresh;
end;

procedure TfrmDrillingPlan.grdvwDrillingPlanChange(Sender: TObject;
  Cell: TGridCell; Selected: Boolean);
begin
  frmObligationTools1.SelectedObligation := CurrentObligation;
end;

function TfrmDrillingPlan.GetCurrentObligation: TObligation;
begin
  try
    Result := FLicenseZone.AllDrillObligations.Items[grdvwDrillingPlan.Row]
  except
    Result := nil;
  end;
end;

procedure TfrmDrillingPlan.frmObligationTools1actnDeleteObligationExecute(
  Sender: TObject);
begin
  frmObligationTools1.actnDeleteObligationExecute(Sender);

end;

procedure TfrmDrillingPlan.RefreshDrillingObligations;
begin
  grdvwDrillingPlan.Rows.Count := FLicenseZone.License.AllDrillObligations.Count;
  grdvwDrillingPlan.Refresh;
end;

end.
