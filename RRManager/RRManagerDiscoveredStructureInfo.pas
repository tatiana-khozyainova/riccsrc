unit RRManagerDiscoveredStructureInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CommonComplexCombo, RRManagerBaseObjects, RRManagerObjects,
  RRManagerBaseGUI, RRManagerCommon;

type
//  TfrmDiscoveredStructureInfo = class(TFrame)
  TfrmDiscoveredStructureInfo = class(TBaseFrame)
    gbxAll: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cmplxMethod: TfrmComplexCombo;
    cmplxOrganization: TfrmComplexCombo;
    edtPreparationYear: TEdit;
    cmbxReportAuthor: TComboBox;
    cmbxSeismoGroupName: TComboBox;
  private
    function GetStructure: TOldDiscoveredStructure;
    { Private declarations }
  protected
    procedure ClearControls; override;
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure RegisterInspector; override;
  public
    { Public declarations }
    property Structure: TOldDiscoveredStructure read getStructure;
    constructor Create(AOwner: TComponent); override;
    procedure Save; override;
  end;

implementation

uses Facade;

{$R *.DFM}

procedure TfrmDiscoveredStructureInfo.ClearControls;
begin
  cmplxMethod.Clear;
  cmplxOrganization.Clear;
  edtPreparationYear.Clear;

  cmbxReportAuthor.Clear;
  (TMainFacade.GetInstance as TMainFacade).AllDicts.MakeList(cmbxReportAuthor.Items, (TMainFacade.GetInstance as TMainFacade).AllDicts.DictContentByName('SPD_GET_REPORT_AUTHORS'));
  cmbxSeismoGroupName.Clear;
  (TMainFacade.GetInstance as TMainFacade).AllDicts.MakeList(cmbxSeismoGroupName.Items, (TMainFacade.GetInstance as TMainFacade).AllDicts.DictContentByName('SPD_GET_SEISMOGROUP_NUMBER'));
end;

constructor TfrmDiscoveredStructureInfo.Create(AOwner: TComponent);
begin
  inherited;
  EditingClass := TOldDiscoveredStructure;

  cmplxMethod.Caption := 'ћетод вы€влени€';
  cmplxMethod.FullLoad := true;
  cmplxMethod.DictName := 'TBL_PREPDIS_METHOD_DICT';

  cmplxOrganization.Caption := 'ќрганизаци€, вы€вивша€ структуру';
  cmplxOrganization.FullLoad := false;
  cmplxOrganization.DictName := 'TBL_ORGANIZATION_DICT';

end;

procedure TfrmDiscoveredStructureInfo.FillControls(ABaseObject: TBaseObject);
var s: TOldDiscoveredStructure;
begin
  cmbxReportAuthor.Clear;
  (TMainFacade.GetInstance as TMainFacade).AllDicts.MakeList(cmbxReportAuthor.Items, (TMainFacade.GetInstance as TMainFacade).AllDicts.DictContentByName('SPD_GET_REPORT_AUTHORS'));
  cmbxSeismoGroupName.Clear;
  (TMainFacade.GetInstance as TMainFacade).AllDicts.MakeList(cmbxSeismoGroupName.Items, (TMainFacade.GetInstance as TMainFacade).AllDicts.DictContentByName('SPD_GET_SEISMOGROUP_NUMBER'));

  if not Assigned(ABaseObject) then S := Structure
  else if ABaseObject is TOldDiscoveredStructure then
    S := ABaseObject as TOldDiscoveredStructure
  else if  (ABaseObject is TOldStructureHistoryElement)
       and ((ABaseObject as TOldStructureHistoryElement).HistoryStructure is TOldDiscoveredStructure) then
    S := (ABaseObject as TOldStructureHistoryElement).HistoryStructure as TOldDiscoveredStructure;

  if Assigned(S) then
  begin
    cmplxMethod.AddItem(S.MethodID, S.Method);
    cmplxOrganization.AddItem(S.OrganizationID, S.Organization);
    edtPreparationYear.Text := S.Year;
    cmbxReportAuthor.Text := S.ReportAuthor;
    cmbxSeismoGroupName.Text := S.SeismoGroupName;
  end;
end;


function TfrmDiscoveredStructureInfo.GetStructure: TOldDiscoveredStructure;
begin
  Result := EditingObject as TOldDiscoveredStructure;
end;


procedure TfrmDiscoveredStructureInfo.RegisterInspector;
begin
  inherited;
  // регистрируем контролы, которые под инспектором
  Inspector.Add(cmplxMethod.cmbxName, nil, ptString, 'метод вы€влени€', false);
  Inspector.Add(cmplxOrganization.cmbxName, nil, ptString, 'организаци€, вы€вивша€ структуру', false);
  Inspector.Add(edtPreparationYear, nil, ptInteger, 'год вы€влени€', true);
end;

procedure TfrmDiscoveredStructureInfo.Save;
begin
  inherited;

  if not Assigned(EditingObject) then
    // если что берем последнюю добавленную структуру из их списка
    FEditingObject := (TMainFacade.GetInstance as TMainFacade).AllStructures.Items[(TMainFacade.GetInstance as TMainFacade).AllStructures.Count - 1];

  Structure.MethodID := cmplxMethod.SelectedElementID;
  Structure.Method   := cmplxMethod.SelectedElementName;

  Structure.Year := edtPreparationYear.Text;

  Structure.OrganizationID := cmplxOrganization.SelectedElementID;
  Structure.Organization   := cmplxOrganization.SelectedElementName;

  Structure.SeismoGroupName := cmbxSeismoGroupName.Text;
  Structure.ReportAuthor    := cmbxReportAuthor.Text;


end;


end.
