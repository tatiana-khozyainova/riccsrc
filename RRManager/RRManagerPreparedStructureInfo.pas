unit RRManagerPreparedStructureInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CommonComplexCombo, RRManagerBaseObjects, RRManagerObjects,
  RRManagerBaseGUI, RRmanagerCommon;

type
//  TfrmPreparedStructureInfo = class(TFrame)
  TfrmPreparedStructureInfo = class(TBaseFrame)
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
    function GetStructure: TOldPreparedStructure;
    { Private declarations }
  protected
    procedure ClearControls; override;
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure RegisterInspector; override;
  public
    { Public declarations }
    property Structure: TOldPreparedStructure read getStructure;
    constructor Create(AOwner: TComponent); override;
    procedure Save; override;
  end;

implementation

uses Facade;

{$R *.DFM}

procedure TfrmPreparedStructureInfo.ClearControls;
begin

  cmplxMethod.Clear;
  cmplxOrganization.Clear;
  edtPreparationYear.Clear;
  cmbxReportAuthor.Clear;
  (TMainFacade.GetInstance as TMainFacade).AllDicts.MakeList(cmbxReportAuthor.Items, (TMainFacade.GetInstance as TMainFacade).AllDicts.DictContentByName('SPD_GET_REPORT_AUTHORS'));
  cmbxSeismoGroupName.Clear;
  (TMainFacade.GetInstance as TMainFacade).AllDicts.MakeList(cmbxSeismoGroupName.Items, (TMainFacade.GetInstance as TMainFacade).AllDicts.DictContentByName('SPD_GET_SEISMOGROUP_NUMBER'));
end;

constructor TfrmPreparedStructureInfo.Create(AOwner: TComponent);
begin
  inherited;
  EditingClass := TOldPreparedStructure;

  cmplxMethod.Caption := '����� ����������';
  cmplxMethod.FullLoad := true;
  cmplxMethod.DictName := 'TBL_PREPDIS_METHOD_DICT';

  cmplxOrganization.Caption := '�����������, ������������� ���������';
  cmplxOrganization.FullLoad := false;
  cmplxOrganization.DictName := 'TBL_ORGANIZATION_DICT';
end;

procedure TfrmPreparedStructureInfo.FillControls(ABaseObject: TBaseObject);
var s: TOldPreparedStructure;
begin
  cmbxReportAuthor.Clear;
  (TMainFacade.GetInstance as TMainFacade).AllDicts.MakeList(cmbxReportAuthor.Items, (TMainFacade.GetInstance as TMainFacade).AllDicts.DictContentByName('SPD_GET_REPORT_AUTHORS'));
  cmbxSeismoGroupName.Clear;
  (TMainFacade.GetInstance as TMainFacade).AllDicts.MakeList(cmbxSeismoGroupName.Items, (TMainFacade.GetInstance as TMainFacade).AllDicts.DictContentByName('SPD_GET_SEISMOGROUP_NUMBER'));
  S := nil;
  if not Assigned(ABaseObject) then S := Structure
  else if ABaseObject is TOldPreparedStructure then
    S := ABaseObject as TOldPreparedStructure
  else if  (ABaseObject is TOldStructureHistoryElement)
       and ((ABaseObject as TOldStructureHistoryElement).HistoryStructure is TOldPreparedStructure) then
    S := (ABaseObject as TOldStructureHistoryElement).HistoryStructure as TOldPreparedStructure;

  if Assigned(S) then
  begin
    cmplxMethod.AddItem(S.MethodID, S.Method);
    cmplxOrganization.AddItem(S.OrganizationID, S.Organization);
    edtPreparationYear.Text := S.Year;
    cmbxReportAuthor.Text := S.ReportAuthor;
    cmbxSeismoGroupName.Text := S.SeismoGroupName;
  end;
end;

function TfrmPreparedStructureInfo.GetStructure: TOldPreparedStructure;
begin
  Result := EditingObject as TOldPreparedStructure;
end;


procedure TfrmPreparedStructureInfo.RegisterInspector;
begin
  inherited;
  // ������������ ��������, ������� ��� �����������
  Inspector.Add(cmplxMethod.cmbxName, nil, ptString, '����� ����������', false);
  Inspector.Add(cmplxOrganization.cmbxName, nil, ptString, '�����������, ������������� ���������', false);
  Inspector.Add(edtPreparationYear, nil, ptInteger, '��� ����������', true);
end;

procedure TfrmPreparedStructureInfo.Save;
begin
  inherited;

  if not Assigned(EditingObject) then
    // ���� ��� ����� ��������� ����������� ��������� �� �� ������
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
