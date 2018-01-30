unit RRManagerLicenseZoneConditionListEditFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RRManagerBaseGUI, RRManagerLicenseConditionTreeFrame, ExtCtrls,
  RRManagerBaseObjects, RRManagerLicenseZoneConditionEditFrame, RRManagerObjects,
  ComCtrls;

type
  TfrmLicenseZoneConditions = class(TBaseFrame)
  //TfrmLicenseZoneConditions = class(TFrame)
    frmLicenseConditionTree: TfrmLicenseConditionTree;
    splt: TSplitter;
    frmLicenseZoneConditionEditFrame1: TfrmLicenseZoneConditionEditFrame;
    procedure frmLicenseConditionTreetrwConditionsChange(Sender: TObject;
      Node: TTreeNode);
  private
    function GetLicenseZone: TOldLicenseZone;
    { Private declarations }
  protected
    procedure PreloadObject(ABaseObject: TBaseObject); override;
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
    procedure RegisterInspector; override;
    procedure CheckEvent(Sender: TObject);
  public
    { Public declarations }
    property    LicenseZone: TOldLicenseZone read GetLicenseZone;
    constructor Create(AOwner: TComponent); override;
    procedure   Save; override;
    procedure   CancelEdit; override;
  end;

implementation

{$R *.dfm}

{ TfrmLicenseZoneConditions }

procedure TfrmLicenseZoneConditions.CheckEvent(Sender: TObject);
begin

end;

procedure TfrmLicenseZoneConditions.ClearControls;
begin
  inherited;

end;

constructor TfrmLicenseZoneConditions.Create(AOwner: TComponent);
begin
  inherited;
  frmLicenseConditionTree.MakeTree;
end;

procedure TfrmLicenseZoneConditions.FillControls(ABaseObject: TBaseObject);
begin
  inherited;
  frmLicenseZoneConditionEditFrame1.LicenseConditionValues := LicenseZone.LicenseConditionValues;
end;

procedure TfrmLicenseZoneConditions.FillParentControls;
begin
  inherited;

end;

function TfrmLicenseZoneConditions.GetLicenseZone: TOldLicenseZone;
begin
  Result := EditingObject as TOldLicenseZone;
end;

procedure TfrmLicenseZoneConditions.PreloadObject(
  ABaseObject: TBaseObject);
begin
  inherited;
end;

procedure TfrmLicenseZoneConditions.RegisterInspector;
begin
  inherited;

end;

procedure TfrmLicenseZoneConditions.frmLicenseConditionTreetrwConditionsChange(
  Sender: TObject; Node: TTreeNode);
begin
  frmLicenseZoneConditionEditFrame1.Visible := Node.Level > 0;
  frmLicenseZoneConditionEditFrame1.LicenseCondition := frmLicenseConditionTree.ActiveLicenseCondition;
end;

procedure TfrmLicenseZoneConditions.CancelEdit;
begin
  inherited;
  LicenseZone.LicenseConditionValues.Reload;
end;

procedure TfrmLicenseZoneConditions.Save;
begin
  inherited;
end;

end.
