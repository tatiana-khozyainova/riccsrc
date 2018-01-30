unit RRManagerBasicLicenseZoneInfoForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FramesWizard, RRManagerBaseGUI, RRManagerMainLicenseZoneInfoFrame,
  RRManagerLicenseZoneSitingInfoFrame, RRManagerLicenseZoneOrganizationInfoFrame;

type
  TfrmBasicLicenseZone = class(TCommonForm)
    DialogFrame1: TDialogFrame;
  private
    { Private declarations }
    function  GetDlg: TDialogFrame; override;
    function  GetEditingObjectName: string; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;    
  end;

var
  frmBasicLicenseZone: TfrmBasicLicenseZone;

implementation

{$R *.dfm}

{ TfrmBasicLicenseZone }

constructor TfrmBasicLicenseZone.Create(AOwner: TComponent);
var frm: TfrmLicenseZoneMainInfo;
    frmOrg: TfrmLicenseZoneOrganizationInfo;
begin
  inherited;
  frm := dlg.AddFrame(TfrmLicenseZoneMainInfo) as TfrmLicenseZoneMainInfo;
  frm.DefaultLicenseZoneStateID := 2;
  frm.cmplxLicenseZoneState.Enabled := false;

  dlg.AddFrame(TfrmLicenseZoneSitingInfo);
  frmOrg := dlg.AddFrame(TfrmLicenseZoneOrganizationInfo) as TfrmLicenseZoneOrganizationInfo;
  frmOrg.gbxOrganization.Caption := frmOrg.gbxOrganization.Caption + '(заполняется только для НП)'; 

  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := 1;

  Width := 900;
  Height := 600;
end;

function TfrmBasicLicenseZone.GetDlg: TDialogFrame;
begin
  Result := DialogFrame1;
end;

function TfrmBasicLicenseZone.GetEditingObjectName: string;
begin
  Result := 'Лицензионный участок';
end;


end.
