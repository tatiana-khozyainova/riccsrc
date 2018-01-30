unit RRManagerLicenseConditionTypeEditFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonIDObjectEditFrame, StdCtrls, ExtCtrls, ComCtrls, LicenseZone,
  BaseObjects;

type
  TfrmLicenseConditionTypeEditFrame = class(TfrmIDObjectEditFrame)
    chbxRelativeDates: TCheckBox;
    chbxBoundingDates: TCheckBox;
  private
    { Private declarations }
  protected
    procedure FillControls(ABaseObject: TIDObject); override;
    procedure ClearControls; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure   Save(AObject: TIDObject = nil); override;
  end;

var
  frmLicenseConditionTypeEditFrame: TfrmLicenseConditionTypeEditFrame;

implementation

uses DateUtils, CommonFrame;

{$R *.dfm}

{ TfrmLicenseConditionTypeEditFrame }

procedure TfrmLicenseConditionTypeEditFrame.ClearControls;
begin
  inherited;
  chbxRelativeDates.Checked := false;
  chbxBoundingDates.Checked := false;
end;

constructor TfrmLicenseConditionTypeEditFrame.Create(AOwner: TComponent);
begin
  inherited;
  EditingClass := TLicenseConditionType;
  ShowShortName := false;
end;

procedure TfrmLicenseConditionTypeEditFrame.FillControls(
  ABaseObject: TIDObject);         
begin
  inherited;
  with EditingObject as TLicenseConditionType do
  begin
    chbxRelativeDates.Checked := HasRelativeDate;
    chbxBoundingDates.Checked := BoundingDates;
  end; 
end;

procedure TfrmLicenseConditionTypeEditFrame.Save;
begin
  inherited;
  with EditingObject as TLicenseConditionType do
  begin
    HasRelativeDate := chbxRelativeDates.Checked;
    BoundingDates := chbxBoundingDates.Checked;
  end;
end;

end.
