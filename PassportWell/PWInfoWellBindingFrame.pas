unit PWInfoWellBindingFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, ComCtrls, Well, BaseObjects, ActnList, StdCtrls,
  Buttons, ExtCtrls, CommonValueDictFrame, Mask, ToolEdit, Organization;

type
  //TfrmWellBinding = class(TFrame)


  TfrmWellBinding = class(TfrmCommonFrame)
    frmFilterNGP: TfrmFilter;
    Panel1: TPanel;
    frmFilterNGO: TfrmFilter;
    frmFilterNGR: TfrmFilter;
    Panel3: TPanel;
    frmFilterStruct: TfrmFilter;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    frmFilterSearchingExpedition: TfrmFilter;
    frmFilterSearchingTrust: TfrmFilter;
    frmFilterSearchingMinistry: TfrmFilter;
    frmFilterExploitingMinistry: TfrmFilter;
    frmFilterExploitingTrust: TfrmFilter;
    frmFilterExploitingExpedition: TfrmFilter;
    GroupBox6: TGroupBox;
    edtPassportNum: TEdit;
    Panel2: TPanel;
    Panel4: TPanel;
    pnl1: TPanel;
    frmFilterNewNGR: TfrmFilter;
    frmFilterNewNGO: TfrmFilter;
    frmFilterNewNGP: TfrmFilter;
    Panel6: TPanel;
    frmFilterDistrict: TfrmFilter;
    frmFilterNewStruct: TfrmFilter;
    frmFilterTopolist: TfrmFilter;
    procedure frmFilterNGRcbxActiveObjectButtonClick(Sender: TObject);
    procedure frmFilterNGRcbxActiveObjectChange(Sender: TObject);
    procedure frmFilterNewNGRcbxActiveObjectButtonClick(Sender: TObject);
    procedure frmFilterNewNGRcbxActiveObjectChange(Sender: TObject);
  private
    function  GetWell: TWell;
  protected
    procedure FillControls(ABaseObject: TIDObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
    procedure RegisterInspector; override;
    function  GetParentCollection: TIDObjects; override;

    procedure GetOrganizationByStatus (AID: Integer; AfrmFilter: TfrmFilter);
  public
    property  Well: TWell read GetWell;

    procedure   Save(AObject: TIDObject = nil); override;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmWellBinding: TfrmWellBinding;

implementation

uses Facade, District, PetrolRegion, Structure, SDFacade, LicenseZone, TectonicStructure, Topolist;

{$R *.dfm}

{ TfrmCommonFrame1 }

procedure TfrmWellBinding.ClearControls;
begin
  inherited;

  edtPassportNum.Text := '';

  frmFilterNGO.AllObjects := TMainFacade.GetInstance.AllNGOs;
  frmFilterNGP.AllObjects := TMainFacade.GetInstance.AllNGPs;
  frmFilterNGR.AllObjects := TMainFacade.GetInstance.AllNGRs;
  frmFilterStruct.AllObjects := TMainFacade.GetInstance.AllTectonicStructures;
  frmFilterDistrict.AllObjects := TMainFacade.GetInstance.AllDistricts;
  frmFilterSearchingExpedition.AllObjects := TMainFacade.GetInstance.AllOrganizations;
  frmFilterSearchingTrust.AllObjects := TMainFacade.GetInstance.AllOrganizations;
  frmFilterSearchingMinistry.AllObjects := TMainFacade.GetInstance.AllOrganizations;
  frmFilterExploitingExpedition.AllObjects := TMainFacade.GetInstance.AllOrganizations;
  frmFilterExploitingTrust.AllObjects := TMainFacade.GetInstance.AllOrganizations;
  frmFilterExploitingMinistry.AllObjects := TMainFacade.GetInstance.AllOrganizations;

  frmFilterNewNGP.AllObjects := TMainFacade.GetInstance.AllNewNGPs;
  frmFilterNewNGO.AllObjects := TMainFacade.GetInstance.AllNewNGOs;
  frmFilterNewNGR.AllObjects := TMainFacade.GetInstance.AllNewNGRs;
  frmFilterNewStruct.AllObjects := TMainFacade.GetInstance.AllNewTectonicStructures;
  frmFilterTopolist.AllObjects := TMainFacade.GetInstance.AllTopolists;

  frmFilterNewNGP.cbxActiveObject.Text := '<не указана>';
  frmFilterNewNGO.cbxActiveObject.Text := '<не указана>';
  frmFilterNewNGR.cbxActiveObject.Text := '<не указан>';
  frmFilterNewStruct.cbxActiveObject.Text := '<не указана>';
  frmFilterTopolist.cbxActiveObject.Text := '<не указан>';

  frmFilterNGO.cbxActiveObject.Text := '<не указана>';
  frmFilterNGP.cbxActiveObject.Text := '<не указана>';
  frmFilterNGR.cbxActiveObject.Text := '<не указан>';
  frmFilterStruct.cbxActiveObject.Text := '<не указана>';
  frmFilterDistrict.cbxActiveObject.Text := '<не указан>';
  frmFilterSearchingExpedition.cbxActiveObject.Text := '<не указана>';
  frmFilterSearchingTrust.cbxActiveObject.Text := '<не указано>';
  frmFilterSearchingMinistry.cbxActiveObject.Text := '<не указано>';
  frmFilterExploitingExpedition.cbxActiveObject.Text := '<не указана>';
  frmFilterExploitingTrust.cbxActiveObject.Text := '<не указано>';
  frmFilterExploitingMinistry.cbxActiveObject.Text := '<не указано>';

  {
  Организации:
  1)	Кто бурил (разведывающая
  2)	Кто заказал,
  3)	недропользователь;
  у кого на балансе
  }
end;

constructor TfrmWellBinding.Create(AOwner: TComponent);
begin
  inherited;

  EditingClass := TWell;
end;

destructor TfrmWellBinding.Destroy;
begin

  inherited;
end;

procedure TfrmWellBinding.FillControls(ABaseObject: TIDObject);
var i: Integer;
begin
  inherited;

  with Well do
  begin
    edtPassportNum.Text := PassportNumberWell;

    if Assigned (WellPosition) then
    begin

      if Assigned (WellPosition.District) then
        frmFilterDistrict.ActiveObject := WellPosition.District;

      if Assigned (WellPosition.NGR) then
        frmFilterNGR.ActiveObject := WellPosition.NGR;


      if Assigned (WellPosition.TectonicStructure) then
        frmFilterStruct.ActiveObject := WellPosition.TectonicStructure;

      if Assigned (WellPosition.NewTectonicStructure) then
        frmFilterNewStruct.ActiveObject := WellPosition.NewTectonicStructure;

      if Assigned (WellPosition.NewNGR) then
        frmFilterNewNGR.ActiveObject := WellPosition.NewNGR;

      if Assigned(WellPosition.Topolist) then
        frmFilterTopolist.ActiveObject := WellPosition.Topolist;
    end;

    if WellOrgStatuses.Count > 0 then
    for i := 0 to WellOrgStatuses.Count - 1 do
    case WellOrgStatuses.Items[i].StatusOrganization.ID of
      3 : frmFilterSearchingMinistry.ActiveObject := WellOrgStatuses.Items[i].Organization;
      4 : frmFilterExploitingMinistry.ActiveObject := WellOrgStatuses.Items[i].Organization;
      5 : frmFilterSearchingTrust.ActiveObject := WellOrgStatuses.Items[i].Organization;
      6 : frmFilterExploitingTrust.ActiveObject := WellOrgStatuses.Items[i].Organization;
      7 : frmFilterSearchingExpedition.ActiveObject := WellOrgStatuses.Items[i].Organization;
      8 : frmFilterExploitingExpedition.ActiveObject := WellOrgStatuses.Items[i].Organization;
    end;
  end;
end;

procedure TfrmWellBinding.FillParentControls;
begin
  inherited;
end;

function TfrmWellBinding.GetParentCollection: TIDObjects;
begin
  Result := nil;
end;

function TfrmWellBinding.GetWell: TWell;
begin
  Result := EditingObject as TWell;
end;

procedure TfrmWellBinding.RegisterInspector;
begin
  inherited;

end;

procedure TfrmWellBinding.Save(AObject: TIDObject = nil); 
var wp: TWellPosition;
begin
  inherited;

  if Assigned (Well) then
  begin
    Well.PassportNumberWell := trim(edtPassportNum.Text);

    if not Assigned (Well.WellPosition) then
    begin
      wp := TWellPosition.Create(well.WellPositions);
      Well.WellPositions.Add(wp);
    end;

    with Well.WellPosition do
    begin
      District := frmFilterDistrict.ActiveObject as TDistrict;
      NGR := frmFilterNGR.ActiveObject as TPetrolRegion;
      TectonicStructure := frmFilterStruct.ActiveObject as TTectonicStructure;
      NewTectonicStructure := frmFilterNewStruct.ActiveObject as TNewTectonicStructure;
      NewNGR := frmFilterNewNGR.ActiveObject as TNewPetrolRegion;
      Topolist := frmFilterTopolist.ActiveObject as TTopographicalList;
    end;

    with Well do
    begin
      // разведывающее министерство
      GetOrganizationByStatus(3, frmFilterSearchingMinistry);
      // разведывающий трест
      GetOrganizationByStatus(5, frmFilterSearchingTrust);
      // разведывающая организация
      GetOrganizationByStatus(7, frmFilterSearchingExpedition);
      // эксплуатирующее министерство
      GetOrganizationByStatus(4, frmFilterExploitingMinistry);
      // эксплуатирующий трест
      GetOrganizationByStatus(6, frmFilterExploitingTrust);
      // эксплуатирующая организация
      GetOrganizationByStatus(8, frmFilterExploitingExpedition);
    end;
  end;
end;

procedure TfrmWellBinding.frmFilterNGRcbxActiveObjectButtonClick(
  Sender: TObject);
begin
  inherited;
  frmFilterNGR.cbxActiveObjectButtonClick(Sender);
end;

procedure TfrmWellBinding.frmFilterNGRcbxActiveObjectChange(
  Sender: TObject);
var sSQL: string;
    iResult, PN: integer;
    vResult: variant;
    i: integer;
begin
  inherited;

  if frmFilterNGR.cbxActiveObject.Text <> '<не указан>' then
  if Assigned((frmFilterNGR.ActiveObject as TPetrolRegion).MainPetrolRegion) then
  begin
    frmFilterNGO.ActiveObject := (frmFilterNGR.ActiveObject as TPetrolRegion).MainPetrolRegion;

    frmFilterNGO.Enabled := False;
    frmFilterNGP.Enabled := False;

    if Assigned(frmFilterNGO.ActiveObject) then
    if Assigned((frmFilterNGO.ActiveObject as TPetrolRegion).MainPetrolRegion) then
      frmFilterNGP.ActiveObject := (frmFilterNGO.ActiveObject as TPetrolRegion).MainPetrolRegion
    else frmFilterNGP.Enabled := True;

    // считаем паспортный номер скважины
    if (not Assigned(Well)) or (Assigned(Well) and (trim(Well.PassportNumberWell) = '')) then
    begin
      sSQL := 'select first 10 skip 0 v.vch_passport_num from vw_well_coord v where v.OLD_NGR_ID = ' + IntToStr(frmFilterNGR.ActiveObject.ID) + ' order by v.vch_passport_num desc';
      iResult := TMainFacade.GetInstance.DBGates.Server.ExecuteQuery(sSQL);

      if iResult > 0 then
      begin
        vResult := TMainFacade.GetInstance.DBGates.Server.QueryResult;
        for i := 0 to varArrayHighBound(vResult, 2) do
        begin
          try
            PN := vResult[0, i] + 1;
            edtPassportNum.Text := IntToStr(PN);
            break;
          except

          end;
        end;
      end;
    end;
  end
  else
  begin
    frmFilterNGO.Enabled := True;
    frmFilterNGP.Enabled := True;
  end;
end;

procedure TfrmWellBinding.GetOrganizationByStatus(AID: Integer;
  AfrmFilter: TfrmFilter);
var wo: TWellOrganizationStatus;
begin
  with Well do
  if Assigned (AfrmFilter.ActiveObject) then
  begin
    if not Assigned (WellOrgStatuses.ItemsByIDStatus[AID]) then
    begin
      wo := TWellOrganizationStatus.Create(WellOrgStatuses);
      wo.StatusOrganization := TMainFacade.GetInstance.AllOrgStatuses.ItemsByID[AID] as TOrganizationStatus;
      WellOrgStatuses.Add (wo, False, False);
    end
    else wo := WellOrgStatuses.ItemsByIDStatus[AID];

    wo.Organization := AfrmFilter.ActiveObject as TOrganization;
  end;
end;

procedure TfrmWellBinding.frmFilterNewNGRcbxActiveObjectButtonClick(
  Sender: TObject);
begin
  inherited;
  frmFilterNewNGR.cbxActiveObjectButtonClick(Sender);
end;

procedure TfrmWellBinding.frmFilterNewNGRcbxActiveObjectChange(
  Sender: TObject);
begin
  inherited;

  if frmFilterNewNGR.cbxActiveObject.Text <> '<не указан>' then
  if Assigned((frmFilterNewNGR.ActiveObject as TPetrolRegion).MainPetrolRegion) then
  begin
    frmFilterNewNGO.ActiveObject := (frmFilterNewNGR.ActiveObject as TPetrolRegion).MainPetrolRegion;

    if Assigned(frmFilterNewNGO.ActiveObject) then
    if Assigned((frmFilterNewNGO.ActiveObject as TPetrolRegion).MainPetrolRegion) then
      frmFilterNewNGP.ActiveObject := (frmFilterNewNGO.ActiveObject as TPetrolRegion).MainPetrolRegion;
  end;
end;

end.

