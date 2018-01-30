unit RRManagerLicenseZoneOrganizationInfoFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonComplexCombo, StdCtrls, Mask, ToolEdit, RRManagerObjects,
  RRManagerBaseObjects, RRManagerBaseGUI, FramesWizard;

type
//  TfrmLicenseZoneOrganizationInfo = class(TFrame)
  TfrmLicenseZoneOrganizationInfo = class(TBaseFrame)
    gbxOrganization: TGroupBox;
    cmplxOwner: TfrmComplexCombo;
    cmplxDeveloper: TfrmComplexCombo;
    gbxHolder: TGroupBox;
    cmplxSiteHolder: TfrmComplexCombo;
    Label1: TLabel;
    Label2: TLabel;
    edtDoc: TEdit;
    dtedtDocDate: TDateEdit;
    gbxIssuer: TGroupBox;
    cmplxIssuer: TfrmComplexCombo;
    Label3: TLabel;
    cmbxSubject: TComboBox;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    dtedtLicStart: TDateEdit;
    dtedtLicFin: TDateEdit;
  private
    { Private declarations }
    function GetLicenseZone: TOldLicenseZone;
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure FillParentControls; override;
    procedure ClearControls; override;
    procedure RegisterInspector; override;
  public
    { Public declarations }
    property    LicenseZone: TOldLicenseZone read GetLicenseZone;
    constructor Create(AOwner: TComponent); override;
    procedure   Save; override;
  end;

implementation

{$R *.dfm}

{ TfrmLicenseZoneOrganizationInfo }

procedure TfrmLicenseZoneOrganizationInfo.ClearControls;
begin
  dtedtLicStart.Clear;
  dtedtLicFin.Clear;
  cmplxOwner.Clear;
  cmplxDeveloper.Clear;
  cmplxSiteHolder.Clear;
  dtedtDocDate.Clear;
  edtDoc.Clear;
  cmplxIssuer.Clear;
  cmbxSubject.ItemIndex := -1;
end;

constructor TfrmLicenseZoneOrganizationInfo.Create(AOwner: TComponent);
begin
  inherited;

  EditingClass := TOldLicenseZone;

  cmplxOwner.Caption := '�����������-�������� ��������';
  cmplxOwner.FullLoad := true;
  cmplxOwner.DictName := 'TBL_ORGANIZATION_DICT';

  cmplxDeveloper.Caption := '�����������-�����������������';
  cmplxDeveloper.FullLoad := true;
  cmplxDeveloper.DictName := 'TBL_ORGANIZATION_DICT';

  cmplxSiteHolder.Caption := '�����, �������������� ����� �� ����������� ��������� ��������';
  cmplxSiteHolder.FullLoad := true;
  cmplxSiteHolder.DictName := 'TBL_ORGANIZATION_DICT';

  cmplxIssuer.Caption := '����� ���������� ��������������� ������ ����, �������� ��������';
  cmplxIssuer.FullLoad := true;
  cmplxIssuer.DictName := 'TBL_ORGANIZATION_DICT';

  cmbxSubject.Clear;
  cmbxSubject.Items.Add('����� ��');
  cmbxSubject.Items.Add('������������� ��');
  cmbxSubject.Items.Add('�������� ��');
end;

procedure TfrmLicenseZoneOrganizationInfo.FillControls(
  ABaseObject: TBaseObject);
var l: TOldLicenseZone;
begin
  inherited;

  if not Assigned(ABaseObject) then l := LicenseZone
  else l := ABaseObject as TOldLicenseZone;

  cmplxOwner.AddItem(l.License.OwnerOrganizationID, l.License.OwnerOrganizationName);
  cmplxDeveloper.AddItem(l.License.DeveloperOrganizationID, l.License.DeveloperOrganizationName);

  cmplxSiteHolder.AddItem(l.License.SiteHolderID, l.License.SiteHolder);

  dtedtDocDate.Date := l.License.DocHolderDate;
  edtDoc.Text := l.License.DocHolder;

  cmplxIssuer.AddItem(l.License.IssuerID, l.License.IssuerName);
  cmbxSubject.ItemIndex := cmbxSubject.Items.Add(l.License.IssuerSubject);

  dtedtLicStart.Date := l.RegistrationStartDate;
  dtedtLicFin.Date := l.RegistrationFinishDate;
end;

procedure TfrmLicenseZoneOrganizationInfo.FillParentControls;
begin

end;

function TfrmLicenseZoneOrganizationInfo.GetLicenseZone: TOldLicenseZone;
begin
  Result := nil;
  if EditingObject is TOldLicenseZone then
    Result := EditingObject as TOldLicenseZone;
end;

procedure TfrmLicenseZoneOrganizationInfo.RegisterInspector;
begin
  inherited;
  Inspector.Add(cmplxOwner.cmbxName, nil, ptString, '�����������-�������� ��������', false);
  Inspector.Add(cmplxDeveloper.cmbxName, nil, ptString, '�����������-�����������������', false);
  //Inspector.Add(cmplxSiteHolder.cmbxName, nil, ptString, '�����, �������������� ����� �� ����������� ��������� ��������', false);
  //Inspector.Add(cmplxIssuer.cmbxName, nil, ptString, '����� ���������� ��������������� ������ ����, �������� ��������', false);
  //Inspector.Add(dtedtLicStart, nil, ptDate, '���� ��������������� �����������', false);
  //Inspector.Add(dtedtLicFin, nil, ptDate, '���� ��������� ��������', false);
end;

procedure TfrmLicenseZoneOrganizationInfo.Save;
begin
  inherited;

  if not Assigned(EditingObject) then
    FEditingObject := ((Owner as TDialogFrame).Frames[0] as TBaseFrame).EditingObject;

  LicenseZone.License.OwnerOrganizationID := cmplxOwner.SelectedElementID;
  LicenseZone.License.OwnerOrganizationName := cmplxOwner.SelectedElementName;

  LicenseZone.License.DeveloperOrganizationID := cmplxDeveloper.SelectedElementID;
  LicenseZone.License.DeveloperOrganizationName := cmplxDeveloper.SelectedElementName;

  LicenseZone.License.SiteHolderID := cmplxSiteHolder.SelectedElementID;
  LicenseZone.License.SiteHolder := cmplxSiteHolder.SelectedElementName;
  LicenseZone.License.DocHolderDate := dtedtDocDate.Date;
  LicenseZone.License.DocHolder := trim(edtDoc.Text);

  LicenseZone.License.IssuerID := cmplxIssuer.SelectedElementID;
  LicenseZone.License.IssuerName := cmplxIssuer.SelectedElementName;
  LicenseZone.License.IssuerSubject := cmbxSubject.Text;

  LicenseZone.License.RegistrationStartDate := dtedtLicStart.Date;
  LicenseZone.License.RegistrationFinishDate := dtedtLicFin.Date;
end;

end.
