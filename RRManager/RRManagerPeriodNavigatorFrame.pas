unit RRManagerPeriodNavigatorFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, LicenseZone, ImgList, ActnList, ComCtrls, StdCtrls, Mask,
  ToolEdit, ToolWin;

type
  TfrmLicensePeriod = class(TFrame)
    ToolBar1: TToolBar;
    lblPeriod: TLabel;
    lblStart: TLabel;
    dtpStartDate: TDateEdit;
    Label3: TLabel;
    ToolButton2: TToolButton;
    dtpFinDate: TDateEdit;
    actnList: TActionList;
    actnAdd: TAction;
    imgLst: TImageList;
    actnDelete: TAction;
    actnNext: TAction;
    actnPrev: TAction;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    procedure actnAddExecute(Sender: TObject);
    procedure actnAddUpdate(Sender: TObject);
    procedure actnDeleteExecute(Sender: TObject);
    procedure actnDeleteUpdate(Sender: TObject);
    procedure actnNextExecute(Sender: TObject);
    procedure actnNextUpdate(Sender: TObject);
    procedure actnPrevExecute(Sender: TObject);
    procedure actnPrevUpdate(Sender: TObject);
  private
    { Private declarations }
    FLicenseZoneConditionValues: TLicenseConditionValues;
    FLicenseZoneCondition: TLicenseCondition;
    FSelectedConditionValue: TLicenseConditionValue;
    FOnSelectedConditionValueChange: TNotifyEvent;
    FCurrentLicenseZoneConditionValues: TLicenseConditionValues;
    procedure FillLincenseZoneConditionValues;
    procedure SetLicenseZoneCondition(const Value: TLicenseCondition);
    procedure SetLicenseZoneConditionValues(
      const Value: TLicenseConditionValues);
    procedure SetSelectedConditionValue(
      const Value: TLicenseConditionValue);
  public
    { Public declarations }
    property LicenseZoneCondition: TLicenseCondition read FLicenseZoneCondition write SetLicenseZoneCondition;
    property LicenseZoneConditionValues: TLicenseConditionValues read FLicenseZoneConditionValues write SetLicenseZoneConditionValues;
    property SelectedConditionValue: TLicenseConditionValue read FSelectedConditionValue write SetSelectedConditionValue;
    procedure Clear;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  published
    property OnSelectedConditionValueChange: TNotifyEvent read FOnSelectedConditionValueChange write FOnSelectedConditionValueChange;
  end;

implementation

uses Contnrs;

{$R *.dfm}

{ TfrmLicensePeriod }

procedure TfrmLicensePeriod.SetLicenseZoneCondition(
  const Value: TLicenseCondition);
begin
  if FLicenseZoneCondition <> Value then
  begin
    FLicenseZoneCondition := Value;
    if Assigned(FLicenseZoneCondition) then
    begin
      dtpStartDate.Enabled := ((not FLicenseZoneCondition.NonPeriodic) or (not FLicenseZoneCondition.LicenseConditionType.HasRelativeDate)) and (LicenseZoneCondition.LicenseConditionType.BoundingDates);
      dtpFinDate.Enabled := (not FLicenseZoneCondition.NonPeriodic) or (not FLicenseZoneCondition.LicenseConditionType.HasRelativeDate);



      FillLincenseZoneConditionValues;
      SelectedConditionValue := FCurrentLicenseZoneConditionValues.Items[0];      
    end;
  end;
end;

procedure TfrmLicensePeriod.SetLicenseZoneConditionValues(
  const Value: TLicenseConditionValues);
begin
  if FLicenseZoneConditionValues <> Value then
  begin
    FLicenseZoneConditionValues := Value;
    if Assigned(FLicenseZoneCondition) then
    begin
      FillLincenseZoneConditionValues;
      SelectedConditionValue := FCurrentLicenseZoneConditionValues.Items[0];
    end;
  end;
end;

procedure TfrmLicensePeriod.SetSelectedConditionValue(
  const Value: TLicenseConditionValue);
begin
  FSelectedConditionValue := Value;
  dtpStartDate.Date := FSelectedConditionValue.StartDate;
  dtpFinDate.Date := FSelectedConditionValue.FinishDate;
  if Assigned(FOnSelectedConditionValueChange) then
    FOnSelectedConditionValueChange(FSelectedConditionValue);
end;

procedure TfrmLicensePeriod.actnAddExecute(Sender: TObject);
begin
  SelectedConditionValue := LicenseZoneConditionValues.Add as TLicenseConditionValue;
  FCurrentLicenseZoneConditionValues.Add(SelectedConditionValue, false, false);
end;

procedure TfrmLicensePeriod.actnAddUpdate(Sender: TObject);
begin
  actnAdd.Enabled := Assigned(LicenseZoneCondition) and (not LicenseZoneCondition.NonPeriodic);
end;

procedure TfrmLicensePeriod.actnDeleteExecute(Sender: TObject);
var iIndex: integer;
begin
  iIndex := FCurrentLicenseZoneConditionValues.IndexOf(SelectedConditionValue);
  if iIndex > -1 then
  begin
    if iIndex < FCurrentLicenseZoneConditionValues.Count - 1 then
    begin
      FCurrentLicenseZoneConditionValues.Remove(SelectedConditionValue);
      if FCurrentLicenseZoneConditionValues.Count > 0 then
        SelectedConditionValue := FCurrentLicenseZoneConditionValues.Items[iIndex];
    end
    else
    begin
      FCurrentLicenseZoneConditionValues.Remove(SelectedConditionValue);
      if FCurrentLicenseZoneConditionValues.Count > 0 then
        SelectedConditionValue := FCurrentLicenseZoneConditionValues.Items[iIndex - 1];
    end;
  end;
  LicenseZoneConditionValues.Remove(SelectedConditionValue);
end;

procedure TfrmLicensePeriod.actnDeleteUpdate(Sender: TObject);
begin
  actnDelete.Enabled := Assigned(LicenseZoneCondition) and (not LicenseZoneCondition.NonPeriodic) and (LicenseZoneConditionValues.Count > 1);
end;

procedure TfrmLicensePeriod.actnNextExecute(Sender: TObject);
begin
  SelectedConditionValue := FCurrentLicenseZoneConditionValues.Items[FCurrentLicenseZoneConditionValues.IndexOf(SelectedConditionValue) + 1];
end;

procedure TfrmLicensePeriod.actnNextUpdate(Sender: TObject);
begin
  actnNext.Enabled := Assigned(LicenseZoneCondition) and (not LicenseZoneCondition.NonPeriodic) and (LicenseZoneConditionValues.Count > 1)
                      and Assigned(SelectedConditionValue) and (FCurrentLicenseZoneConditionValues.IndexOf(SelectedConditionValue) < LicenseZoneConditionValues.Count - 1);
end;

procedure TfrmLicensePeriod.actnPrevExecute(Sender: TObject);
begin
  SelectedConditionValue := FCurrentLicenseZoneConditionValues.Items[FCurrentLicenseZoneConditionValues.IndexOf(SelectedConditionValue) - 1];
end;

procedure TfrmLicensePeriod.actnPrevUpdate(Sender: TObject);
begin
  actnPrev.Enabled := Assigned(LicenseZoneCondition) and (not LicenseZoneCondition.NonPeriodic) and (LicenseZoneConditionValues.Count > 1)
                      and Assigned(SelectedConditionValue) and (FCurrentLicenseZoneConditionValues.IndexOf(SelectedConditionValue) > 0);
end;

constructor TfrmLicensePeriod.Create(AOwner: TComponent);
begin
  inherited;
  FCurrentLicenseZoneConditionValues := TLicenseConditionValues.Create;
  FCurrentLicenseZoneConditionValues.OwnsObjects := false;
end;

destructor TfrmLicensePeriod.Destroy;
begin
  FCurrentLicenseZoneConditionValues.Free;
  inherited;
end;

procedure TfrmLicensePeriod.FillLincenseZoneConditionValues;
var i: integer;
    lcv: TLicenseConditionValue; 
begin
  if Assigned(LicenseZoneCondition) then
  begin
    FCurrentLicenseZoneConditionValues.Clear;
    for i := 0 to LicenseZoneConditionValues.Count - 1 do
    if LicenseZoneConditionValues.Items[i].LicenseCondition = LicenseZoneCondition then
      FCurrentLicenseZoneConditionValues.Add(LicenseZoneConditionValues.Items[i], false, false);


    if FCurrentLicenseZoneConditionValues.Count = 0 then
    begin
      lcv := FLicenseZoneConditionValues.Add as TLicenseConditionValue;
      lcv.LicenseCondition := LicenseZoneCondition;
      FCurrentLicenseZoneConditionValues.Add(lcv, false, false);      
    end;

    lblPeriod.Caption := 'Ограничение по времени' + '(' + IntToStr(FCurrentLicenseZoneConditionValues.Count) + ')';
  end;
end;

procedure TfrmLicensePeriod.Clear;
begin
  dtpStartDate.Clear;
  dtpFinDate.Clear;
end;


end.
