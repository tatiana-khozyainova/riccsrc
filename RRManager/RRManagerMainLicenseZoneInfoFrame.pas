unit RRManagerMainLicenseZoneInfoFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonComplexCombo, StdCtrls, Mask, ToolEdit, RRManagerBaseGUI,
  RRManagerObjects, RRManagerBaseObjects, RRManagerCommon, 
  ClientCommon;

type
  TfrmLicenseZoneMainInfo = class(TBaseFrame)
//  TfrmLicenseZoneMainInfo = class(TFrame)
    gbxAll: TGroupBox;
    Label1: TLabel;
    mmGoal: TMemo;
    GroupBox1: TGroupBox;
    edtNumber: TEdit;
    Label2: TLabel;
    cmplxLicenseType: TfrmComplexCombo;
    Label3: TLabel;
    Label4: TLabel;
    edtName: TEdit;
    cmplxLicenseZoneType: TfrmComplexCombo;
    cmbxSeria: TComboBox;
    cmplxLicenseZoneState: TfrmComplexCombo;
    gbxPerspective: TGroupBox;
    Label6: TLabel;
    dtmCompetitionDate: TDateEdit;
    cmplxConcursType: TfrmComplexCombo;
    procedure mmGoalChange(Sender: TObject);
  private
    { Private declarations }
    FDefaultLicenseZoneStateID: integer;
    FOnLicenseZoneRegisterInspector: TNotifyEvent;
    function GetLicenseZone: TOldLicenseZone;
    procedure SetDefaultLicenseZoneStateID(const Value: integer);
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure FillParentControls; override;
    procedure ClearControls; override;
    procedure RegisterInspector; override;
  public
    { Public declarations }
    property    OnLicenseZoneRegisterInspector: TNotifyEvent read FOnLicenseZoneRegisterInspector write FOnLicenseZoneRegisterInspector;
    property    LicenseZone: TOldLicenseZone read GetLicenseZone;
    property    DefaultLicenseZoneStateID: integer read FDefaultLicenseZoneStateID write SetDefaultLicenseZoneStateID;
    constructor Create(AOwner: TComponent); override;
    procedure   Save; override;
  end;

implementation

uses Facade;

{$R *.dfm}

{ TfrmLicenseZoneMainInfo }

procedure TfrmLicenseZoneMainInfo.ClearControls;
begin
  inherited;
  edtNumber.Clear;
  edtName.Clear;

  cmplxLicenseType.Clear;
  cmplxLicenseZoneType.Clear;

  cmbxSeria.ItemIndex := 0;
  mmGoal.Clear;

  cmplxConcursType.Clear;
  dtmCompetitionDate.Clear;
  cmplxConcursType.cmbxName.ItemIndex := 0;  
end;

constructor TfrmLicenseZoneMainInfo.Create(AOwner: TComponent);
begin
  inherited;
  EditingClass := TOldLicenseZone;

  cmplxLicenseType.Caption := 'Вид лицензии';
  cmplxLicenseType.FullLoad := true;
  cmplxLicenseType.DictName := 'TBL_LICENSE_TYPE_DICT';

  cmplxLicenseZoneType.Caption := 'Тип участка';
  cmplxLicenseZoneType.FullLoad := true;
  cmplxLicenseZoneType.DictName := 'TBL_LICENSE_ZONE_TYPE_DICT';
  //cmplxLicenseZoneType.Enabled := false;

  cmplxLicenseZoneState.Caption := 'Статус участка';
  cmplxLicenseZoneState.FullLoad := true;
  cmplxLicenseZoneState.DictName := 'TBL_LICENSE_ZONE_STATE_DICT';

  cmplxConcursType.Caption := 'Тип конкурса';
  cmplxConcursType.FullLoad := true;
  cmplxConcursType.DictName := 'TBL_COMPETITION_TYPE_DICT';
  cmplxConcursType.cmbxName.ItemIndex := 0;


  cmbxSeria.Items.Clear;
  cmbxSeria.Items.Add('СЫК');
  cmbxSeria.Items.Add('НРМ');
  cmbxSeria.ItemIndex := 0;
end;

procedure TfrmLicenseZoneMainInfo.FillControls(ABaseObject: TBaseObject);
var l: TOldLicenseZone;
begin
  if not Assigned(ABaseObject) then l := LicenseZone
  else l := ABaseObject as TOldLicenseZone;

  edtNumber.Text := l.LicenseZoneNum;
  cmplxLicenseType.AddItem(l.License.LicenseTypeID, l.License.LicenseType);
  cmbxSeria.ItemIndex := cmbxSeria.Items.IndexOf(l.License.Seria);

  edtName.Text := l.LicenseZoneName;
  cmplxLicenseZoneType.AddItem(l.License.LicenzeZoneTypeID, l.License.LicenzeZoneType);
  mmGoal.Text := l.License.LicenseTitle;

  //cmplxLicenseZoneState.AddItem(l.LicenseZoneStateID, l.LicenseZoneState);
  cmplxConcursType.AddItem(l.CompetitionID, l.CompetitionName);

  dtmCompetitionDate.Date := l.CompetitionDate;
end;

procedure TfrmLicenseZoneMainInfo.FillParentControls;
begin

end;

function TfrmLicenseZoneMainInfo.GetLicenseZone: TOldLicenseZone;
begin
  Result := nil;
  if EditingObject is TOldLicenseZone then
    Result := EditingObject as TOldLicenseZone;
end;

procedure TfrmLicenseZoneMainInfo.RegisterInspector;
begin
  inherited;
  // регистрируем контролы, которые под инспектором
  Inspector.Add(cmplxLicenseZoneType.cmbxName, nil, ptString, 'тип участка', false);
  Inspector.Add(edtName, nil, ptString, 'название участка', false);
 

  if Assigned(FOnLicenseZoneRegisterInspector) then OnLicenseZoneRegisterInspector(nil);


end;

procedure TfrmLicenseZoneMainInfo.Save;
begin
  inherited;

  if not Assigned(FEditingObject) then
    FEditingObject := (TMainFacade.GetInstance as TMainFacade).AllOldLicenseZones.Add;



  LicenseZone.License.LicenseZoneNum := trim(edtNumber.Text);

  LicenseZone.License.LicenzeZoneTypeID := cmplxLicenseZoneType.SelectedElementID;
  LicenseZone.License.LicenzeZoneType := cmplxLicenseZoneType.SelectedElementName;

  LicenseZone.License.Seria := trim(cmbxSeria.Text);

  LicenseZone.License.LicenseTypeID := cmplxLicenseType.SelectedElementID;
  LicenseZone.License.LicenseType := cmplxLicenseType.SelectedElementName;

  LicenseZone.LicenseZoneName := trim(edtName.Text);
  LicenseZone.License.LicenseTitle := trim(mmGoal.Text);

  LicenseZone.LicenseZoneStateID := cmplxLicenseZoneState.SelectedElementID;
  LicenseZone.LicenseZoneState := cmplxLicenseZoneState.SelectedElementName;

  LicenseZone.CompetitionID := cmplxConcursType.SelectedElementID;
  LicenseZone.CompetitionName := cmplxConcursType.SelectedElementName;
  LicenseZone.CompetitionDate := dtmCompetitionDate.Date;




end;

procedure TfrmLicenseZoneMainInfo.mmGoalChange(Sender: TObject);
begin
  Check;
end;

procedure TfrmLicenseZoneMainInfo.SetDefaultLicenseZoneStateID(
  const Value: integer);
begin
  if FDefaultLicenseZoneStateID <> Value then
  begin
    FDefaultLicenseZoneStateID := Value;
    gbxPerspective.Visible := FDefaultLicenseZoneStateID > 1;
    cmplxLicenseZoneState.cmbxName.ItemIndex := cmplxLicenseZoneState.AddItem(FDefaultLicenseZoneStateID,  GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_LICENSE_ZONE_STATE_DICT'].Dict, FDefaultLicenseZoneStateID));
    cmplxLicenseZoneState.Enabled := false;


  end;
end;

end.
