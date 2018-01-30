unit SeismPlanFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Ex_Grid, LicenseZone, GRRObligation, ObligationToolsFrame;

type
  TfrmSeismPlan = class(TFrame)
    frmObligationTools1: TfrmObligationTools;
    procedure grdvwSeismPlanGetCellText(Sender: TObject; Cell: TGridCell;
      var Value: String);
    procedure grdvwSeismPlanGetCellColors(Sender: TObject; Cell: TGridCell;
      Canvas: TCanvas);
    procedure grdvwSeismPlanEditAcceptKey(Sender: TObject; Cell: TGridCell;
      Key: Char; var Accept: Boolean);
    procedure grdvwSeismPlanSetEditText(Sender: TObject; Cell: TGridCell;
      var Value: String);
    procedure grdvwSeismPlanEditCloseUp(Sender: TObject; Cell: TGridCell;
      ItemIndex: Integer; var Accept: Boolean);
    procedure grdvwSeismPlanChange(Sender: TObject; Cell: TGridCell;
      Selected: Boolean);
  private
    { Private declarations }
    FLicenseZone: TLicenseZone;
    FSaved: Boolean;
    procedure SetLicenseZone(const Value: TLicenseZone);
    procedure LoadSeismicObligations;
    function  GetCurrentObligation: TObligation;
    procedure ObligationsChanged(Sender: TObject);
  public
    { Public declarations }
    property Saved: Boolean read FSaved;
    property LicenseZone: TLicenseZone read FLicenseZone write SetLicenseZone;
    property CurrentObligation: TObligation read GetCurrentObligation;
    procedure   RefreshSeismicObligations;


    procedure Save;
    procedure Cancel;

    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses Facade, BaseObjects, BaseConsts;

{$R *.dfm}

{ TfrmSeismPlan }

procedure TfrmSeismPlan.Cancel;
begin
  LicenseZone.License.ClearSeismicObligations;
end;

constructor TfrmSeismPlan.Create(AOwner: TComponent);
begin
  inherited;
  FSaved := true;
  frmObligationTools1.OnObligationAdded := ObligationsChanged;
  frmObligationTools1.OnObligationRemoved := ObligationsChanged;
end;

function TfrmSeismPlan.GetCurrentObligation: TObligation;
begin
  try
    Result := FLicenseZone.AllSeismicObligations.Items[grdvwSeismPlan.Row]
  except
    Result := nil;
  end;
end;

procedure TfrmSeismPlan.LoadSeismicObligations;
begin
  TMainFacade.GetInstance.AllSeisWorkTypes.MakeList(grdvwSeismPlan.Columns[0].PickList, False, true);
  frmObligationTools1.Obligations := FLicenseZone.License.AllSeismicObligations;
  RefreshSeismicObligations;
end;

procedure TfrmSeismPlan.ObligationsChanged(Sender: TObject);
begin
  grdvwSeismPlan.Rows.Count := LicenseZone.License.AllSeismicObligations.Count;
  FSaved := false;
  grdvwSeismPlan.Refresh;
end;

procedure TfrmSeismPlan.Save;
begin
  LicenseZone.License.AllSeismicObligations.Update(nil);
end;

procedure TfrmSeismPlan.SetLicenseZone(const Value: TLicenseZone);
begin
  if FLicenseZone <> Value then
  begin
    FLicenseZone := Value;
    LoadSeismicObligations;
    FSaved := True;
  end;
end;

procedure TfrmSeismPlan.grdvwSeismPlanGetCellText(Sender: TObject;
  Cell: TGridCell; var Value: String);
begin
  with LicenseZone.AllSeismicObligations.Items[Cell.Row] do
  case Cell.Col of
  0: if Assigned(SeisWorkType) then Value := SeisWorkType.List(loBrief);
  1: Value := FloatToStr(Volume);
  2:
  begin
    if Assigned(SeisWorkType) then
    case SeisWorkType.ID of
    SEISWORK_TYPE_2D: Value := 'пог. м';
    SEISWORK_TYPE_3D: Value := 'кв. км'
    else
      Value := '';
    end;
  end;
  3: if StartDate <> 0 then Value := DateToStr(StartDate) else Value := '';
  4: if FinishDate <> 0 then Value := DateToStr(FinishDate) else Value := '';
  5: Value := Comment;
  6: Value := DoneString;
  end;
end;

procedure TfrmSeismPlan.grdvwSeismPlanGetCellColors(Sender: TObject;
  Cell: TGridCell; Canvas: TCanvas);
var o: TObligation;
begin
  o := LicenseZone.License.AllSeismicObligations.Items[Cell.Row];

  if (o.FinishDate > 0) and (o.FinishDate <= TMainFacade.GetInstance.ActiveVersion.VersionFinishDate) then
  begin
    if o.Done then Canvas.Brush.Color := $00C8F9E3
    else Canvas.Brush.Color := $00DFE7FF;
  end
  else if o.Done then Canvas.Brush.Color := $00C8F9E3
end;

procedure TfrmSeismPlan.grdvwSeismPlanEditAcceptKey(Sender: TObject;
  Cell: TGridCell; Key: Char; var Accept: Boolean);
begin
  Accept := not(Cell.Col in [2, 6]);

  if Accept then
  begin
    // well number
    if (Cell.Col in [1, 3, 4]) then
      Accept := (Pos(Key, '0123456789.') > 0);
  end;
end;

procedure TfrmSeismPlan.grdvwSeismPlanSetEditText(Sender: TObject;
  Cell: TGridCell; var Value: String);
begin
  Value := trim(Value);

  case Cell.Col of
  1:
  begin
    if Value <> '' then
      LicenseZone.License.AllSeismicObligations.Items[Cell.Row].Volume := StrToFloat(Value)
    else
      LicenseZone.License.AllSeismicObligations.Items[Cell.Row].StartDate := 0;
    FSaved := false;
  end;
  3:
  begin
    if Value <> '' then
      LicenseZone.License.AllSeismicObligations.Items[Cell.Row].StartDate := StrToDateTime(Value)
    else
      LicenseZone.License.AllSeismicObligations.Items[Cell.Row].StartDate := 0;
    grdvwSeismPlan.Refresh;      
    FSaved := false;
  end;
  4:
  begin
    if Value <> '' then
      LicenseZone.License.AllSeismicObligations.Items[Cell.Row].FinishDate := StrToDateTime(Value)
    else
      LicenseZone.License.AllSeismicObligations.Items[Cell.Row].FinishDate := 0;
    FSaved := false;
    grdvwSeismPlan.Refresh;
  end;
  5:
  begin
    LicenseZone.License.AllSeismicObligations.Items[Cell.Row].Comment := Value;
    FSaved := false;
  end;
  end;
end;

procedure TfrmSeismPlan.grdvwSeismPlanEditCloseUp(Sender: TObject;
  Cell: TGridCell; ItemIndex: Integer; var Accept: Boolean);
begin
  if ItemIndex > -1 then
  begin
    if Cell.Col = 0 then
    begin
      LicenseZone.License.AllSeismicObligations.Items[Cell.Row].SeisWorkType := TMainFacade.GetInstance.AllSeisWorkTypes.Items[ItemIndex];
      FSaved := false;
    end;
  end;
end;

procedure TfrmSeismPlan.grdvwSeismPlanChange(Sender: TObject;
  Cell: TGridCell; Selected: Boolean);
begin
  frmObligationTools1.SelectedObligation := CurrentObligation;
end;

procedure TfrmSeismPlan.RefreshSeismicObligations;
begin
  grdvwSeismPlan.Rows.Count := FLicenseZone.License.AllSeismicObligations.Count;
  grdvwSeismPlan.Refresh;
end;

end.
