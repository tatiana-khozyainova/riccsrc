unit RRManagerLicenseZoneConditionEditFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RRManagerBaseGUI, LicenseZone, StdCtrls, ExtCtrls,
  RRManagerPeriodNavigatorFrame;

type
  //TfrmLicenseZoneConditionEditFrame = class(TFrame)
  TfrmLicenseZoneConditionEditFrame = class(TFrame)
    gbxCondition: TGroupBox;
    frmLicensePeriod1: TfrmLicensePeriod;
    Bevel1: TBevel;
    stConditionType: TStaticText;
    pnlVolume: TPanel;
    edtMinVolume: TLabeledEdit;
    edtMaxVolume: TLabeledEdit;
    stMeasureUnit: TStaticText;
    pnlRelativeDate: TPanel;
    stDateMeasureUnit: TStaticText;
    edtRelativeDate: TLabeledEdit;
    procedure edtMinVolumeKeyPress(Sender: TObject; var Key: Char);
    procedure edtMaxVolumeKeyPress(Sender: TObject; var Key: Char);
    procedure frmLicensePeriod1ToolButton3Click(Sender: TObject);
    procedure frmLicensePeriod1dtpStartDateKeyPress(Sender: TObject;
      var Key: Char);
    procedure frmLicensePeriod1dtpFinDateKeyPress(Sender: TObject;
      var Key: Char);
    procedure frmLicensePeriod1dtpStartDateButtonClick(Sender: TObject);
    procedure frmLicensePeriod1dtpFinDateButtonClick(Sender: TObject);
    procedure edtRelativeDateKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FDataChanged: boolean;
    FLicenseCondition: TLicenseCondition;
    FLicenseConditionValue: TLicenseConditionValue;
    FLicenseConditionValues: TLicenseConditionValues;
    procedure SetLicenseCondition(const Value: TLicenseCondition);
    procedure SetLicenseConditionValue(
      const Value: TLicenseConditionValue);
    procedure SetLicenseConditionValues(
      const Value: TLicenseConditionValues);
    procedure LicenseConditionValueChanged(Sender: TObject);
  public
    { Public declarations }
    property LicenseCondition: TLicenseCondition read FLicenseCondition write SetLicenseCondition;
    property LicenseConditionValue: TLicenseConditionValue read FLicenseConditionValue write SetLicenseConditionValue;
    property LicenseConditionValues: TLicenseConditionValues read FLicenseConditionValues write SetLicenseConditionValues;
    procedure Save;
    procedure Clear;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

{ TfrmLicenseZoneConditionEditFrame }

procedure TfrmLicenseZoneConditionEditFrame.Clear;
begin
  frmLicensePeriod1.Clear;
  edtMinVolume.Clear;
  edtMaxVolume.Clear;
  edtRelativeDate.Clear;
end;

constructor TfrmLicenseZoneConditionEditFrame.Create(AOwner: TComponent);
begin
  inherited;
  frmLicensePeriod1.OnSelectedConditionValueChange := LicenseConditionValueChanged;
  FDataChanged := false;
end;

procedure TfrmLicenseZoneConditionEditFrame.LicenseConditionValueChanged(
  Sender: TObject);
begin
  LicenseConditionValue := frmLicensePeriod1.SelectedConditionValue;
end;

procedure TfrmLicenseZoneConditionEditFrame.Save;
begin
  // сохраняем только в том случае, если изменения были
  if FDataChanged then
  begin
    try
      LicenseConditionValue.StartVolume := StrToFloat(edtMinVolume.Text);
      LicenseConditionValue.FinishVolume := StrToFloat(edtMaxVolume.Text);
      LicenseConditionValue.DaysAfterRegistration := StrToInt(edtRelativeDate.Text);
      LicenseConditionValue.StartDate := frmLicensePeriod1.dtpStartDate.Date;
      LicenseConditionValue.FinishDate := frmLicensePeriod1.dtpFinDate.Date;
    except

    end;
    FDataChanged := false;
  end
  else
  begin
    frmLicensePeriod1.actnDelete.Execute;
    FDataChanged := false;
  end;
end;

procedure TfrmLicenseZoneConditionEditFrame.SetLicenseCondition(
  const Value: TLicenseCondition);
begin
  if FLicenseCondition <> Value then
  begin
    if Assigned(FLicenseCondition) then Save;

    FLicenseCondition := Value;
    if Assigned(LicenseCondition) then
    begin
      stConditionType.Caption := FLicenseCondition.List + ' ' + FLicenseCondition.LicenseConditionType.List;

      if Assigned(FLicenseCondition.VolumeMeasureUnit) then
        stMeasureUnit.Caption := FLicenseCondition.VolumeMeasureUnit.List;

      if Assigned(FLicenseCondition.DateMeasureUnit) then
       stDateMeasureUnit.Caption := FLicenseCondition.DateMeasureUnit.List;

      pnlVolume.Visible := FLicenseCondition.HasVolume;
      pnlRelativeDate.Visible := FLicenseCondition.HasRelativeDate;
      frmLicensePeriod1.LicenseZoneCondition := FLicenseCondition;
    end
    else
    begin
      Clear;
      frmLicensePeriod1.LicenseZoneCondition := FLicenseCondition;
    end;
  end;
end;

procedure TfrmLicenseZoneConditionEditFrame.SetLicenseConditionValue(
  const Value: TLicenseConditionValue);
begin
  if FLicenseConditionValue <> Value then
  begin
    FLicenseConditionValue := Value;
    if Assigned(FLicenseConditionValue) then
    begin
      edtMinVolume.Text := FloatToStr(FLicenseConditionValue.StartVolume);
      edtMaxVolume.Text := FloatToStr(FLicenseConditionValue.FinishVolume);
      edtRelativeDate.Text := IntToStr(FLicenseConditionValue.DaysAfterRegistration);
    end;
    frmLicensePeriod1.SelectedConditionValue := FLicenseConditionValue;
  end;
end;

procedure TfrmLicenseZoneConditionEditFrame.SetLicenseConditionValues(
  const Value: TLicenseConditionValues);
begin
  if FLicenseConditionValues <> Value then
  begin
    FLicenseConditionValues := Value;
    frmLicensePeriod1.LicenseZoneConditionValues := FLicenseConditionValues;
  end;
end;

procedure TfrmLicenseZoneConditionEditFrame.edtMinVolumeKeyPress(
  Sender: TObject; var Key: Char);
begin
  FDataChanged := true;
end;

procedure TfrmLicenseZoneConditionEditFrame.edtMaxVolumeKeyPress(
  Sender: TObject; var Key: Char);
begin
  FDataChanged := true;
end;

procedure TfrmLicenseZoneConditionEditFrame.frmLicensePeriod1ToolButton3Click(
  Sender: TObject);
begin
  frmLicensePeriod1.actnDeleteExecute(Sender);

end;

procedure TfrmLicenseZoneConditionEditFrame.frmLicensePeriod1dtpStartDateKeyPress(
  Sender: TObject; var Key: Char);
begin
  FDataChanged := true;
end;

procedure TfrmLicenseZoneConditionEditFrame.frmLicensePeriod1dtpFinDateKeyPress(
  Sender: TObject; var Key: Char);
begin
  FDataChanged := true;
end;

procedure TfrmLicenseZoneConditionEditFrame.frmLicensePeriod1dtpStartDateButtonClick(
  Sender: TObject);
begin
  FDataChanged := true;
end;

procedure TfrmLicenseZoneConditionEditFrame.frmLicensePeriod1dtpFinDateButtonClick(
  Sender: TObject);
begin
  FDataChanged := true;
end;

procedure TfrmLicenseZoneConditionEditFrame.edtRelativeDateKeyPress(
  Sender: TObject; var Key: Char);
begin
  FDataChanged := true;
end;

end.
