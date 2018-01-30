unit RRManagerLicenseZoneInfoForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FramesWizard, RRManagerBaseGUI, RRManagerMainLicenseZoneInfoFrame,
  RRManagerLicenseZoneSitingInfoFrame, RRManagerLicenseZoneOrganizationInfoFrame,
  RRManagerLicenseZoneAdditionalInfoFrame, RRManagerLicenseZoneConditionListEditFrame;

type
  TfrmLicenseZoneInfo = class(TCommonForm)
    DialogFrame1: TDialogFrame;
  private
    { Private declarations }
    FMainFrm: TfrmLicenseZoneMainInfo;
    procedure RegisterMainInspector(Sender: TObject);
  protected
    function  GetDlg: TDialogFrame; override;
    procedure NextFrame(Sender: TObject); override;
    function  GetEditingObjectName: string; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmLicenseZoneInfo: TfrmLicenseZoneInfo;

implementation

{$R *.dfm}

{ TfrmLicenseZoneInfo }

constructor TfrmLicenseZoneInfo.Create(AOwner: TComponent);
begin
  inherited;
  FMainFrm := dlg.AddFrame(TfrmLicenseZoneMainInfo) as TfrmLicenseZoneMainInfo;
  FMainFrm.DefaultLicenseZoneStateID := 1;
  FMainFrm.OnLicenseZoneRegisterInspector := RegisterMainInspector;

  dlg.AddFrame(TfrmLicenseZoneOrganizationInfo);
  dlg.AddFrame(TfrmLicenseZoneSitingInfo);
  dlg.AddFrame(TfrmLicenceZoneAdditionalInfo);
  dlg.AddFrame(TfrmLicenseZoneConditions);

  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := 1;


  Width := 900;
  Height := 600;
end;

function TfrmLicenseZoneInfo.GetDlg: TDialogFrame;
begin
  Result := DialogFrame1;
end;

function TfrmLicenseZoneInfo.GetEditingObjectName: string;
begin
  Result := 'Лицензионный участок';
end;

procedure TfrmLicenseZoneInfo.NextFrame(Sender: TObject);
{var frmMainInfo: TfrmLicenseZoneMainInfo;
    frmSiteInfo: TfrmLicenseZoneOrganizationInfo;}
begin
  inherited;
{  if dlg.ActiveFrameIndex = 0 then
  begin
    frmMainInfo := dlg.Frames[0] as TfrmLicenseZoneMainInfo;
    frmSiteInfo := dlg.Frames[1] as TfrmLicenseZoneOrganizationInfo;

    frmSiteInfo.cmplxOwner.AddItem(frmMainInfo.cmplxOwner.SelectedElementID, frmMainInfo.cmplxOwner.SelectedElementName);
    frmSiteInfo.cmplxDeveloper.AddItem(frmMainInfo.cmplxDeveloper.SelectedElementID, frmMainInfo.cmplxDeveloper.SelectedElementName);
  end}
end;

procedure TfrmLicenseZoneInfo.RegisterMainInspector(Sender: TObject);
begin
  with FMainFrm do
  begin
    Inspector.Add(edtNumber, nil, ptString, 'номер участка', false);
    Inspector.Add(cmbxSeria, nil, ptString, 'серия', false);
    Inspector.Add(cmplxLicenseType.cmbxName, nil, ptString, 'вид лицензии', false);
    Inspector.Add(mmGoal, nil, ptString, 'целевое назначение и вид работ', false);
  end;
end;

end.
