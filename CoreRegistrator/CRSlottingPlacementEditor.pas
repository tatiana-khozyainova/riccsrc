unit CRSlottingPlacementEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, ComCtrls, StdCtrls, CommonObjectSelectFrame,
  ExtCtrls, CRPartPlacementsEditorForm, Well, SlottingPlacement, BaseObjects,
  CommonComplexCombo, CommonComplexIDCombo, OrganizationSelectForm;

type
  TfrmSlottingPlacementEdit = class(TfrmCommonFrame)
    gbxSlottingPlacement: TGroupBox;
    frmSlottingPlacement: TfrmIDObjectSelect;
    edtOwnerPartPlacement: TLabeledEdit;
    edtBoxCount: TLabeledEdit;
    edtFinalBoxCount: TLabeledEdit;
    cmplxOrganization: TfrmIDObjectSelect;
    frmLastCoretransfer: TfrmIDObjectSelect;
    btnRefresh: TButton;
    procedure btnRefreshClick(Sender: TObject);
  private
    { Private declarations }
    function GetWell: TWell;
    function GetWellSlottingPlacement: TSlottingPlacement;
  protected
    procedure FillControls(ABaseObject: TIDObject); override;
    procedure ClearControls; override;
    procedure RegisterInspector; override;
    function  GetParentCollection: TIDObjects; override;
    procedure CopyEditingValues(Dest: TIDObject); override;
  public
    { Public declarations }
    property Well: TWell read GetWell;
    property WellSlottingPlacement: TSlottingPlacement read GetWellSlottingPlacement;

    constructor Create(AOwner: TComponent); override;
    procedure   Save(AObject: TIDObject = nil);  override;
  end;

var
  frmSlottingPlacementEdit: TfrmSlottingPlacementEdit;

implementation

uses CRSlottingPlacementEdit, CRCoreTransfersEditForm, BaseGUI, Facade, Organization, CoreTransfer, BaseConsts;

{$R *.dfm}

{ TfrmSlottingPlacementEdit }

procedure TfrmSlottingPlacementEdit.ClearControls;
begin
  inherited;
  frmSlottingPlacement.Clear;
  edtOwnerPartPlacement.Clear;
  edtBoxCount.Clear;
  edtFinalBoxCount.Clear;
  cmplxOrganization.Clear;
end;

procedure TfrmSlottingPlacementEdit.CopyEditingValues(Dest: TIDObject);
begin
  if Assigned(WellSlottingPlacement) then
  begin
    (Dest as TSlottingPlacement).StatePartPlacement := WellSlottingPlacement.StatePartPlacement;
    (Dest as TSlottingPlacement).OwnerPartPlacement := WellSlottingPlacement.OwnerPartPlacement;
    (Dest as TSlottingPlacement).BoxCount := WellSlottingPlacement.BoxCount;
    (Dest as TSlottingPlacement).FinalBoxCount := WellSlottingPlacement.FinalBoxCount;
    (Dest as TSlottingPlacement).Organization := WellSlottingPlacement.Organization;
    (Dest as TSlottingPlacement).LastCoreTransfer := WellSlottingPlacement.LastCoreTransfer;
    (Dest as TSlottingPlacement).LastCoreTransferTask := WellSlottingPlacement.LastCoreTransferTask;
  end;
end;

constructor TfrmSlottingPlacementEdit.Create(AOwner: TComponent);
begin
  inherited;

  EditingClass := TSlottingPlacement;
  ParentClass := TWell;

  frmSlottingPlacement.LabelCaption := 'Основное местоположение государственной части керна';
  frmSlottingPlacement.SelectiveFormClass := TfrmPartPlacementsEditor;
  frmSlottingPlacement.ObjectSelector := (frmSlottingPlacement.SelectorForm as TfrmPartPlacementsEditor);

  frmLastCoretransfer.LabelCaption := 'Дата последнего переупорядочения (переукладки)';
  frmLastCoretransfer.SelectiveFormClass :=  TfrmCoreTransfersEditForm;
  frmLastCoretransfer.ObjectSelector := (frmLastCoretransfer.SelectorForm as  TfrmCoreTransfersEditForm );


  cmplxOrganization.LabelCaption := 'Ведомственная принадлежность/владелец керна';
  cmplxOrganization.SelectiveFormClass := TfrmOrganizationSelect;
  cmplxOrganization.ObjectSelector := (cmplxOrganization.SelectorForm as TfrmOrganizationSelect);
end;

procedure TfrmSlottingPlacementEdit.FillControls(ABaseObject: TIDObject);
var s: TSlottingPlacement;
begin
  inherited;
  s := ShadeEditingObject as TSlottingPlacement;

  if Assigned(s) then
  begin
    frmSlottingPlacement.SelectedObject := s.StatePartPlacement;
    cmplxOrganization.SelectedObject := s.Organization;
    frmLastCoretransfer.SelectedObject := s.LastCoreTransfer;
    edtOwnerPartPlacement.Text := s.OwnerPartPlacement;
    edtBoxCount.Text := IntToStr(s.BoxCount);
    edtFinalBoxCount.Text := IntToStr(s.FinalBoxCount);
  end;

  FillParentControls;
end;

function TfrmSlottingPlacementEdit.GetParentCollection: TIDObjects;
begin
  Result := Well.SlottingPlacement.Collection;
end;

function TfrmSlottingPlacementEdit.GetWell: TWell;
begin
  if EditingObject is TWell then
    Result := EditingObject as TWell
  else if EditingObject is TSlottingPlacement then
    Result := (EditingObject as TSlottingPlacement).Collection.Owner as TWell
  else
    Result := nil;
end;

function TfrmSlottingPlacementEdit.GetWellSlottingPlacement: TSlottingPlacement;
begin
  Result := EditingObject as TSlottingPlacement;
end;

procedure TfrmSlottingPlacementEdit.RegisterInspector;
begin
  inherited;
  Inspector.Add(frmSlottingPlacement.edtObject, nil, ptString, 'Местонахождение государственной части керна', false);
  Inspector.Add(edtBoxCount, nil, ptInteger, 'Количество ящиков поступило', false);
  Inspector.Add(edtFinalBoxCount, nil, ptInteger, 'Количество ящиков после упорядочения', false);
end;

procedure TfrmSlottingPlacementEdit.Save;
var ct: TCoreTransferTask;
begin
  inherited;

  if FEditingObject is TWell then
    FEditingObject := Well.AddSlottingPlacement;

  WellSlottingPlacement.StatePartPlacement := frmSlottingPlacement.SelectedObject as TPartPlacement;
  WellSlottingPlacement.OwnerPartPlacement := edtOwnerPartPlacement.Text;
  WellSlottingPlacement.BoxCount := StrToInt(edtBoxCount.Text);
  WellSlottingPlacement.FinalBoxCount := StrToInt(edtFinalBoxCount.Text);
  WellSlottingPlacement.Organization := cmplxOrganization.SelectedObject as TOrganization;

  if Assigned(frmLastCoretransfer.SelectedObject) then
  with frmLastCoretransfer.SelectedObject as TCoreTransfer do
  begin
    ct := CoreTransferTasks.GetTransferTaskByWellAndType(Well, TMainFacade.GetInstance.AllCoreTransferTypes.ItemsByID[CORE_TRANSFER_TYPE_REPLACING_ID] as TCoreTransferType);
    if not Assigned(ct) then
    begin
      ct := CoreTransferTasks.Add as TCoreTransferTask;
      ct.TransferringObject := Well;
      ct.TransferType := TMainFacade.GetInstance.AllCoreTransferTypes.ItemsByID[CORE_TRANSFER_TYPE_REPLACING_ID] as TCoreTransferType;
    end;

    ct.TargetPlacement := WellSlottingPlacement.StatePartPlacement;
    ct.BoxCount := WellSlottingPlacement.Boxes.Count;
    WellSlottingPlacement.LastCoreTransferTask := ct;
    WellSlottingPlacement.LastCoreTransfer := frmLastCoretransfer.SelectedObject as TCoreTransfer;
  end;
end;

procedure TfrmSlottingPlacementEdit.btnRefreshClick(Sender: TObject);
begin
  inherited;
  edtFinalBoxCount.Text := IntToStr(Well.Slottings.Boxes.Count);
end;

end.
