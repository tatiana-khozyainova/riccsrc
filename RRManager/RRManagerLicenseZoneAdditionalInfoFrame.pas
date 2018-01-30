unit RRManagerLicenseZoneAdditionalInfoFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RRManagerBaseGUI, RRManagerObjects, RRManagerBaseObjects, RRManagerCommon,
  StdCtrls, FramesWizard;

type
  //TfrmLicenceZoneAdditionalInfo = class(TFrame)
  TfrmLicenceZoneAdditionalInfo = class(TBaseFrame)
    gbxAll: TGroupBox;
    Label1: TLabel;
    edtArea: TEdit;
    Label2: TLabel;
    edtDepthFrom: TEdit;
    Label3: TLabel;
    edtDepthTo: TEdit;
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

{ TfrmLicenceZoneAdditionalInfo }

procedure TfrmLicenceZoneAdditionalInfo.ClearControls;
begin
  edtArea.Clear;
  edtDepthFrom.Clear;
  edtDepthTo.Clear;
end;

constructor TfrmLicenceZoneAdditionalInfo.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TfrmLicenceZoneAdditionalInfo.FillControls(
  ABaseObject: TBaseObject);
var l: TOldLicenseZone;
begin
  if not Assigned(ABaseObject) then l := LicenseZone
  else l := ABaseObject as TOldLicenseZone;

  edtArea.Text := Format('%.2f', [l.Area]);
  edtDepthFrom.Text := Format('%.2f', [l.DepthFrom]);
  edtDepthTo.Text := Format('%.2f', [l.DepthTo]);
end;

procedure TfrmLicenceZoneAdditionalInfo.FillParentControls;
begin

end;

function TfrmLicenceZoneAdditionalInfo.GetLicenseZone: TOldLicenseZone;
begin
  Result := nil;
  if EditingObject is TOldLicenseZone then
    Result := EditingObject as TOldLicenseZone;
end;

procedure TfrmLicenceZoneAdditionalInfo.RegisterInspector;
begin
  inherited;
  Inspector.Add(edtArea, nil, ptFloat, 'площадь участка', true);
  Inspector.Add(edtDepthFrom, nil, ptFloat, 'глубина от', true);
  Inspector.Add(edtDepthFrom, nil, ptFloat, 'глубина до', true);
end;

procedure TfrmLicenceZoneAdditionalInfo.Save;
begin
  inherited;
  if not Assigned(EditingObject) then
    FEditingObject := ((Owner as TDialogFrame).Frames[0] as TBaseFrame).EditingObject;

  try
    LicenseZone.Area := StrToFloat(edtArea.Text);
  except
    LicenseZone.Area := 0;
  end;

  try
    LicenseZone.DepthFrom := StrToFloat(edtDepthFrom.Text);
  except
    LicenseZone.DepthFrom := 0; 
  end;

  try
    LicenseZone.DepthTo := StrToFloat(edtDepthTo.Text);
  except
    LicenseZone.DepthTo := 0;
  end
end;

end.
