unit ChoiceObligation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DrillingFact, ComCtrls, NirPlanFrame, SeismPlanFrame,
  DrillingPlanFrame, LicenseZone;

type
  TfrmObligationChoice = class(TFrame)
    pgctlObligations: TPageControl;
    tshDrilling: TTabSheet;
    tshSeismic: TTabSheet;
    tshNir: TTabSheet;
    frmDrilling: TfrmDrillingPlan;
    frmSeismPlan1: TfrmSeismPlan;
    frmNirPlan1: TfrmNirPlan;
  private
    FLicenseZone: TLicenseZone;
    FJustImported: boolean;
    procedure SetLicenseZone(const Value: TLicenseZone);
    procedure QuerySave;
    function GetSaved: Boolean;
    { Private declarations }
  public
    { Public declarations }
    property LicenseZone: TLicenseZone read FLicenseZone write SetLicenseZone;

    property Saved: Boolean read GetSaved;

    property JustImported: boolean read FJustImported;
    procedure ShowImportedData;

    procedure Save;
    procedure Cancel;
  end;

implementation

uses Facade, BaseObjects;

{$R *.dfm}

{ TfrmObligationChoice }

procedure TfrmObligationChoice.Cancel;
begin
  frmDrilling.Cancel;
  frmSeismPlan1.Cancel;
  frmNirPlan1.Cancel;
end;

function TfrmObligationChoice.GetSaved: Boolean;
begin
  Result := (frmDrilling.Saved and frmSeismPlan1.Saved and frmNirPlan1.Saved) and not JustImported;
end;

procedure TfrmObligationChoice.QuerySave;
begin
  if (MessageBox(Handle, PChar(Format('Имеются несохраненные изменения по лицензионному участку %s. Сохранить?', [FLicenseZone.List(loBrief)])), PChar('Вопрос'),  MB_ICONQUESTIOn + MB_APPLMODAL + MB_YESNOCANCEL) = ID_YES) then
    Save
  else
    Cancel;
end;

procedure TfrmObligationChoice.Save;
begin
  frmDrilling.Save;
  frmSeismPlan1.Save;
  frmNirPlan1.Save;
end;

procedure TfrmObligationChoice.SetLicenseZone(const Value: TLicenseZone);
begin
  if FLicenseZone <> Value then
  begin
    if not Saved then QuerySave;
    FLicenseZone := Value;
    frmDrilling.LicenseZone := FLicenseZone;
    frmSeismPlan1.LicenseZone := FLicenseZone;
    frmNirPlan1.LicenseZone := FLicenseZone;
  end;
end;

procedure TfrmObligationChoice.ShowImportedData;
begin
  FJustImported := true;
  frmDrilling.RefreshDrillingObligations;
  frmSeismPlan1.RefreshSeismicObligations;
  frmNirPlan1.RefreshNIRObligations;
end;

end.
