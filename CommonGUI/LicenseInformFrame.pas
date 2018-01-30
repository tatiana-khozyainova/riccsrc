unit LicenseInformFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, LicenseZone, Facade, StdCtrls, LicenseZonePoster;

type
  TfrmLicenseInform = class(TFrame)
    grpInform: TGroupBox;
    mmLicenseName: TMemo;
    lblLicenseName: TLabel;
    lblOrgName: TLabel;
    mmoLicenseNum: TMemo;
    lblLicenseNum: TLabel;
    mmoStartFinishDate: TMemo;
    mmoOrgName: TMemo;
    lblStrFin: TLabel;

  private
    FLicenseZone: TLicenseZone;
  //  FLicenseZonePoster : TLicenseZonePoster;

    procedure SetLicenseZone(const Value: TLicenseZone);
  public
    { Public declarations }
    property LicenseZone: TLicenseZone read FLicenseZone write SetLicenseZone;

  end;

implementation

uses BaseObjects, BaseConsts, Organization;

{$R *.dfm}

{ TfrmLicenseInform }

procedure TfrmLicenseInform.SetLicenseZone(const Value: TLicenseZone);
begin

  if FLicenseZone <> Value then
  begin
    FLicenseZone := Value;
    mmLicenseName.Text := FLicenseZone.License.Name;
    mmoOrgName.Text := FLicenseZone.OwnerOrganization.List();
    
    if Assigned(FLicenseZone.LicenzeZoneType) then
      mmoLicenseNum.Text := FLicenseZone.LicenzeZoneType.List()
    else
      mmoLicenseNum.Text := sNoDataMessage;

    mmoStartFinishDate.Text  := DateTimeToStr(FLicenseZone.RegistrationStartDate) +
                        ' - ' + DateTimeToStr(FLicenseZone.RegistrationFinishDate);

end;
end;

end.





