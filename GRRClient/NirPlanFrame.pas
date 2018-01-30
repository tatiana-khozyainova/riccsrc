unit NirPlanFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Ex_Grid, GRRObligation, GRRObligationPoster, LicenseZone,
  ObligationToolsFrame;

type
  TfrmNirPlan = class(TFrame)
    frmObligationTools1: TfrmObligationTools;
    procedure grdvwNirPlanGetCellText(Sender: TObject; Cell: TGridCell;
      var Value: String);
    procedure grdvwNirPlanGetCellColors(Sender: TObject; Cell: TGridCell;
      Canvas: TCanvas);
    procedure grdvwNirPlanSetEditText(Sender: TObject; Cell: TGridCell;
      var Value: String);
    procedure grdvwNirPlanEditAcceptKey(Sender: TObject; Cell: TGridCell;
      Key: Char; var Accept: Boolean);
    procedure grdvwNirPlanEditCloseUp(Sender: TObject; Cell: TGridCell;
      ItemIndex: Integer; var Accept: Boolean);
    procedure grdvwNirPlanChange(Sender: TObject; Cell: TGridCell;
      Selected: Boolean);
   private
    FLicenseZone: TLicenseZone;
    FSaved: boolean;
    procedure ObligationsChanged(Sender: TObject);
    function GetCurrentObligation: TNIRObligation;
    procedure SetLicenseZone(const Value: TLicenseZone);
    procedure LoadNirObligations;
  public
    property CurrentObligation: TNIRObligation read GetCurrentObligation;
    property LicenseZone: TLicenseZone read FLicenseZone write SetLicenseZone;
    property Saved: boolean read FSaved;
    procedure   RefreshNIRObligations;    

    procedure Save;
    procedure Cancel;

    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses Facade;

{$R *.dfm}

procedure TfrmNirPlan.Cancel;
begin
  LicenseZone.License.ClearNirObligations;
end;

constructor TfrmNirPlan.Create(AOwner: TComponent);
begin
  inherited;
  FSaved := true;
  frmObligationTools1.OnObligationAdded := ObligationsChanged;
  frmObligationTools1.OnObligationRemoved := ObligationsChanged;
end;

function TfrmNirPlan.GetCurrentObligation: TNIRObligation;
begin
  try
    Result := FLicenseZone.AllNirObligations.Items[grdvwNirPlan.Row]
  except
    Result := nil;
  end;
end;

procedure TfrmNirPlan.Save;
begin
  LicenseZone.License.AllNirObligations.Update(nil);
end;

procedure TfrmNirPlan.SetLicenseZone(const Value: TLicenseZone);
begin
  if FLicenseZone <> Value then
  begin

    FLicenseZone := Value;
    LoadNirObligations;
    FSaved := true;
  end;
end;

procedure TfrmNirPlan.grdvwNirPlanGetCellText(Sender: TObject;
  Cell: TGridCell; var Value: String);
begin
  with LicenseZone.License.AllNirObligations.Items[Cell.Row] do
  case Cell.Col of
  0: if Assigned(NirType) then Value := NirType.List else Value := '';
  1:
    begin
      if FinishDate <> 0 then
        Value := DateToStr(FinishDate)
      else
        Value := '';
    end;
  2: Value := Comment;
  3: Value := Name;
  4: Value  := DoneString;
  end;
end;

procedure TfrmNirPlan.grdvwNirPlanGetCellColors(Sender: TObject;
  Cell: TGridCell; Canvas: TCanvas);
var o: TNIRObligation;
begin
  o := LicenseZone.License.AllNirObligations.Items[Cell.Row];

  if (o.FinishDate > 0) and (o.FinishDate <= TMainFacade.GetInstance.ActiveVersion.VersionFinishDate) then
  begin
    if o.Done then Canvas.Brush.Color := $00C8F9E3
    else Canvas.Brush.Color := $00DFE7FF;
  end
  else if o.Done then Canvas.Brush.Color := $00C8F9E3
end;

procedure TfrmNirPlan.grdvwNirPlanSetEditText(Sender: TObject;
  Cell: TGridCell; var Value: String);
begin
  Value := Trim(Value);
  with LicenseZone.License.AllNirObligations.Items[Cell.Row] do
  case Cell.Col of
  1:
  begin
    if Value <> '' then FinishDate := StrToDate(Value) else FinishDate := 0;
    grdvwNirPlan.Refresh;
  end;
  2: Comment := Value;
  3: Name := Value;
  end;
  FSaved := false;
end;

procedure TfrmNirPlan.grdvwNirPlanEditAcceptKey(Sender: TObject;
  Cell: TGridCell; Key: Char; var Accept: Boolean);
begin
  Accept := not(Cell.Col in [0, 4]);

  if Accept then
  begin
    // date
    if Cell.Col in [1] then
      Accept := (Pos(Key, '0123456789.') > 0);
  end;
end;

procedure TfrmNirPlan.grdvwNirPlanEditCloseUp(Sender: TObject;
  Cell: TGridCell; ItemIndex: Integer; var Accept: Boolean);
begin
  if ItemIndex > -1 then
  begin
    if Cell.Col = 0 then
    begin
      LicenseZone.License.AllNirObligations.Items[Cell.Row].NirType := TMainFacade.GetInstance.AllNirTypes.Items[ItemIndex];
      FSaved := false;
    end;
  end;
end;

procedure TfrmNirPlan.grdvwNirPlanChange(Sender: TObject; Cell: TGridCell;
  Selected: Boolean);
begin
  frmObligationTools1.SelectedObligation := CurrentObligation;
end;

procedure TfrmNirPlan.ObligationsChanged(Sender: TObject);
begin
  grdvwNirPlan.Rows.Count := LicenseZone.License.AllNirObligations.Count;
  FSaved := false;
  grdvwNirPlan.Refresh;
end;

procedure TfrmNirPlan.LoadNirObligations;
begin
  TMainFacade.GetInstance.AllNirTypes.MakeList(grdvwNirPlan.Columns[0].PickList, False, true);
  frmObligationTools1.Obligations := FLicenseZone.License.AllNirObligations;
  RefreshNIRObligations;
end;

procedure TfrmNirPlan.RefreshNIRObligations;
begin
  grdvwNirPlan.Rows.Count := FLicenseZone.License.AllNirObligations.Count;
  grdvwNirPlan.Refresh;
end;

end.
