unit RRManagerDrilledStructureInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CommonComplexCombo, RRManagerBaseObjects, RRManagerObjects,
  ExtCtrls, ComCtrls, RRManagerLoaderCommands, RRManagerBaseGUI,
  RRmanagerCommon, ActnList, RRManagerPersistentObjects, RRManagerDataPosters,
  FramesWizard;

type
//  TfrmDrilledStructureInfo = class(TFrame)
  TfrmDrilledStructureInfo = class(TBaseFrame)
    gbxAll: TGroupBox;
    cmplxOrganization: TfrmComplexCombo;
    pnl: TPanel;
    Label1: TLabel;
    lwWells: TListView;
    btnAdd: TButton;
    btnDelete: TButton;
    rgrpSelectParam: TRadioGroup;
    mmParameter: TMemo;
    actnLstWells: TActionList;
    actnAddWell: TAction;
    actnDeleteWell: TAction;
    procedure lwWellsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure rgrpSelectParamClick(Sender: TObject);
    procedure mmParameterChange(Sender: TObject);
    procedure actnAddWellExecute(Sender: TObject);
    procedure actnDeleteWellExecute(Sender: TObject);
    procedure actnDeleteWellUpdate(Sender: TObject);
  private
    actnLoadWells: TDrilledStructureWellsBaseLoadAction;
    actnLoadWellsByArea: TWellsBaseLoadAction;
    FTmpWells: TOldDrilledStructureWells;
    function GetStructure: TOldDrilledStructure;
    { Private declarations }
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure ClearControls; override;
    procedure RegisterInspector; override;
  public
    { Public declarations }
    property Structure: TOldDrilledStructure read GetStructure;
    procedure Save; override;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses RRManagerAddStructureWellForm, RRManagerStructureInfoForm, Facade;

{$R *.DFM}

type
  TOldDrilledStructureWellsLoadAction = class(TDrilledStructureWellsBaseLoadAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
  end;

  TWellsLoadAction = class(TWellsBaseLoadAction)
  public
    function Execute(ASQL: string): boolean; override;
  end;




{ TfrmDrilledStructureInfo }

procedure TfrmDrilledStructureInfo.ClearControls;
begin
  FTmpWells.Clear;
  lwWells.Items.Clear;
  cmplxOrganization.Clear;

  if ((Owner as TDialogFrame).Owner is TfrmStructureInfo) then
    actnLoadWellsByArea.Execute('Area_ID = ' + IntToStr(((Owner as TDialogFrame).Owner as TfrmStructureInfo).AreaID));
end;

constructor TfrmDrilledStructureInfo.Create(AOwner: TComponent);
begin
  inherited;

  FTmpWells := TOldDrilledStructureWells.Create(nil);;

  lwWells.ReadOnly := true;
  lwWells.HideSelection := false;
  
  btnAdd.Enabled := false;
  btnDelete.Enabled := false;

  EditingClass := TOldDrilledStructure;

  cmplxOrganization.Caption := 'Организация, производящая бурение';
  cmplxOrganization.FullLoad := false;
  cmplxOrganization.DictName := 'TBL_ORGANIZATION_DICT';

  actnLoadWells := TOldDrilledStructureWellsLoadAction.Create(Self);
  actnLoadWellsByArea := TWellsLoadAction.Create(Self);
  
  btnAdd.Action := actnAddWell;
  btnDelete.Action := actnDeleteWell;

end;

procedure TfrmDrilledStructureInfo.FillControls(ABaseObject: TBaseObject);
var s: TOldDrilledStructure;
begin
  if not Assigned(ABaseObject) then S := Structure
  else if ABaseObject is TOldDrilledStructure then
    S := ABaseObject as TOldDrilledStructure
  else if  (ABaseObject is TOldStructureHistoryElement)
       and ((ABaseObject as TOldStructureHistoryElement).HistoryStructure is TOldDrilledStructure) then
    S := (ABaseObject as TOldStructureHistoryElement).HistoryStructure as TOldDrilledStructure;


  if Assigned(S) then
  begin
    cmplxOrganization.AddItem(S.OrganizationID, S.Organization);
    if (S.AreaID = 0) then S.AreaID := ((Owner as TDialogFrame).Owner as TfrmStructureInfo).AreaID;
    actnLoadWells.Execute(S);
  end;
end;

function TfrmDrilledStructureInfo.GetStructure: TOldDrilledStructure;
begin
  Result := EditingObject as TOldDrilledStructure;
end;

procedure TfrmDrilledStructureInfo.Save;
begin
  inherited;

  if not Assigned(EditingObject) then
    // если что берем последнюю добавленную структуру из их списка
    FEditingObject := (TMainFacade.GetInstance as TMainFacade).AllStructures.Items[(TMainFacade.GetInstance as TMainFacade).AllStructures.Count - 1];

  Structure.OrganizationID := cmplxOrganization.SelectedElementID;
  Structure.Organization   := cmplxOrganization.SelectedElementName;
  // сорхраняемм скважины
  Structure.Wells.Assign(FTmpWells);
end;

procedure TfrmDrilledStructureInfo.RegisterInspector;
begin
  inherited;
  // регистрируем контролы, которые под инспектором
  Inspector.Add(cmplxOrganization.cmbxName, nil, ptString, 'организация, производящая бурение', false);
end;

destructor TfrmDrilledStructureInfo.Destroy;
begin
  FTmpWells.Free;
  if Assigned(frmAddWell) then frmAddWell.Free;
  frmAddWell := nil;
  inherited;
end;

{ TOldDrilledStructureWellsLoadAction }

function TOldDrilledStructureWellsLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var li: TListItem;
    i: integer;
begin
  LastCollection := nil;
  if Assigned(ABaseObject) then
  begin
    LastCollection := (ABaseObject as TOldDrilledStructure).Wells;
    if LastCollection.NeedsUpdate then
    begin
      Result := inherited Execute(ABaseObject)
    end
    else Result := true;
  end
  else Result := true;

  if Result then
  begin
    with Owner as TfrmDrilledStructureInfo do
    begin
      // копируем
      if (FtmpWells.Count = 0) and Assigned(LastCollection) then
        FTmpWells.Assign(LastCollection);
      // загружаем в интерфейс копию
      lwWells.Items.BeginUpdate;
      // чистим
      lwWells.Items.Clear;

      // добавляем
      for i := 0 to FtmpWells.Count - 1 do
      begin
        li := lwWells.Items.Add;
        li.Caption := FtmpWells.Items[i].List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false);
        li.Data    := FtmpWells.Items[i];
      end;
      lwWells.Items.EndUpdate;
    end;
  end;
end;

procedure TfrmDrilledStructureInfo.lwWellsChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
var dsw: TOldDrilledStructureWell;
begin
  if Assigned(Item) then
  begin
    dsw := TOldDrilledStructureWell(Item.Data);
    rgrpSelectParam.ItemIndex := 0;
    if Assigned(dsw) then
      mmParameter.Text := dsw.GISConfirmation;
  end
  else mmParameter.Clear; 
end;

procedure TfrmDrilledStructureInfo.rgrpSelectParamClick(Sender: TObject);
var dsw: TOldDrilledStructureWell;
begin
  if Assigned(lwWells.Selected) then
  begin
    dsw := TOldDrilledStructureWell(lwWells.Selected.Data);
    case rgrpSelectParam.ItemIndex of
    0: mmParameter.Text := dsw.GISConfirmation;
    1: mmParameter.Text := dsw.StructModelConfirmation;
    2: mmParameter.Text := dsw.NegativeResultReason;
    end;
  end;
end;

procedure TfrmDrilledStructureInfo.mmParameterChange(Sender: TObject);
var dsw: TOldDrilledStructureWell;
begin
  if Assigned(lwWells.Selected) then
  begin
    dsw := TOldDrilledStructureWell(lwWells.Selected.Data);
    case rgrpSelectParam.ItemIndex of
    0: dsw.GISConfirmation := mmParameter.Text;
    1: dsw.StructModelConfirmation := mmParameter.Text;
    2: dsw.NegativeResultReason := mmParameter.Text;
    end;
  end;
end;

procedure TfrmDrilledStructureInfo.actnAddWellExecute(Sender: TObject);
var w: TOldDrilledStructureWell;
    i: integer;
begin
  //
  if not Assigned(frmAddWell) then frmAddWell := TfrmAddWell.Create(nil);
  if frmAddWell.ShowModal = mrOK then
  begin
    for i := 0 to frmAddWell.SelectedWells.Count - 1 do
    begin
      w := FtmpWells.Add(frmAddWell.SelectedWells.Items[i].ID) as TOldDrilledStructureWell;
      w.Assign(frmAddWell.SelectedWells.Items[i]);
    end;
      
    actnLoadWells.Execute(Structure);
  end;
end;

procedure TfrmDrilledStructureInfo.actnDeleteWellExecute(Sender: TObject);
var w: TOldDrilledStructureWell;
    i: integer;
begin
  if lwWells.SelCount = 1 then
  begin
    w := TOldDrilledStructureWell(lwWells.Selected.Data);
    w.Free;
    actnLoadWells.Execute(Structure);
    lwWells.Selected := nil;
  end
  else
  begin
    for i := 0 to lwWells.Items.Count - 1 do
    if lwWells.Items[i].Selected then
    begin
      w := TOldDrilledStructureWell(lwWells.Items[i].Data);
      w.Free;
    end;

    actnLoadWells.Execute(Structure);
    lwWells.Selected := nil;
  end;
end;

procedure TfrmDrilledStructureInfo.actnDeleteWellUpdate(Sender: TObject);
begin
  actnDeleteWell.Enabled := Assigned(lwWells.Selected);
end;

{ TWellsLoadAction }

function TWellsLoadAction.Execute(ASQL: string): boolean;
var i: integer;
    li: TListItem;
begin
  LastCollection := (Owner as TfrmDrilledStructureInfo).FTmpWells;

  LastCollection.NeedsUpdate := false;

  Result := inherited Execute(ASQL);

  // сразу же грузим
  with (Owner as TfrmDrilledStructureInfo) do
  begin
    // загружаем в интерфейс копию
    lwWells.Items.BeginUpdate;
    // чистим
    lwWells.Items.Clear;
    // добавляем
    for i := 0 to LastCollection.Count - 1 do
    begin
      li := lwWells.Items.Add;
      li.Caption := LastCollection.Items[i].List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false);
      li.Data    := LastCollection.Items[i];
    end;
    lwWells.Items.EndUpdate;
  end;
end;

end.
