unit CRIntervalFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseGUI, UniButtonsFrame, ComCtrls, BaseObjects, Well, Slotting,
  ImgList, SlottingWell, CRWellQuickInfoViewFrame, ExtCtrls, StdCtrls,
  CommonFrame, CRSlottingBoxListFrame, CRBoxEditFrame, ActnList, ToolWin, SlottingPlacement,
  Menus, GeneralizedSection;

type
  TfrmCoreRegistratorFrame = class(TFrame, IGUIAdapter)
    imgLst: TImageList;
    frmWellSlottingInfoQuickView1: TfrmWellSlottingInfoQuickView;
    Splitter1: TSplitter;
    sbInterval: TStatusBar;
    pgInterval: TPageControl;
    tshIntervals: TTabSheet;
    trwCoreIntervals: TTreeView;
    tshBoxes: TTabSheet;
    gbxWells: TGroupBox;
    cmbxWells: TComboBox;
    lwBoxes: TListView;
    tlbrBoxes: TToolBar;
    actnlstBoxPhotos: TActionList;
    actnAddSlottingPhoto: TAction;
    actnAddWellPhoto: TAction;
    actnRemovePhoto: TAction;
    btnRemovePhoto: TToolButton;
    btnAddSelector: TToolButton;
    pmAddSelector: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    tlbrInterval: TToolBar;
    actnShowGenSection: TAction;
    btnShowGenSection: TToolButton;
    actnEditGenSection: TAction;
    actnAddGenSection: TAction;
    btnGenSections: TToolButton;
    pmGenSections: TPopupMenu;
    actnAddGenSection1: TMenuItem;
    actnEditGenSection1: TMenuItem;
    actnRemoveGenSection: TAction;
    actnRemoveGenSection1: TMenuItem;
    actnViewPhoto: TAction;
    btnViewImage: TToolButton;
    actnAddInterval: TAction;
    actnEditInterval: TAction;
    actnDeleteInterval: TAction;
    actnEditPlacement: TAction;
    btnAddInterval: TToolButton;
    btnEditInterval: TToolButton;
    btnDeleteInterval: TToolButton;
    btnEditPlacement: TToolButton;
    pmInterval: TPopupMenu;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    pmPhoto: TPopupMenu;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    procedure trwCoreIntervalsExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure trwCoreIntervalsGetImageIndex(Sender: TObject;
      Node: TTreeNode);
    procedure trwCoreIntervalsDblClick(Sender: TObject);
    procedure trwCoreIntervalsExpanded(Sender: TObject; Node: TTreeNode);
    procedure trwCoreIntervalsMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure frmButtonstlbrClick(Sender: TObject);
    procedure trwCoreIntervalsCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure trwCoreIntervalsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure trwBoxesExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure cmbxWellsChange(Sender: TObject);
    procedure actnAddSlottingPhotoExecute(Sender: TObject);
    procedure actnAddWellPhotoExecute(Sender: TObject);
    procedure actnAddSlottingPhotoUpdate(Sender: TObject);
    procedure actnAddWellPhotoUpdate(Sender: TObject);
    procedure lwBoxesGetImageIndex(Sender: TObject; Item: TListItem);
    procedure actnRemovePhotoExecute(Sender: TObject);
    procedure actnRemovePhotoUpdate(Sender: TObject);
    procedure actnShowGenSectionExecute(Sender: TObject);
    procedure actnEditGenSectionExecute(Sender: TObject);
    procedure actnEditGenSectionUpdate(Sender: TObject);
    procedure actnAddGenSectionExecute(Sender: TObject);
    procedure actnRemoveGenSectionExecute(Sender: TObject);
    procedure actnRemoveGenSectionUpdate(Sender: TObject);
    procedure actnViewPhotoExecute(Sender: TObject);
    procedure actnAddIntervalExecute(Sender: TObject);
    procedure actnAddIntervalUpdate(Sender: TObject);
    procedure actnEditIntervalExecute(Sender: TObject);
    procedure actnEditIntervalUpdate(Sender: TObject);
    procedure actnDeleteIntervalExecute(Sender: TObject);
    procedure actnDeleteIntervalUpdate(Sender: TObject);
    procedure actnEditPlacementExecute(Sender: TObject);
    procedure actnEditPlacementUpdate(Sender: TObject);
    procedure actnViewPhotoUpdate(Sender: TObject);
  private
    { Private declarations }
    FGUIAdapter: TGUIAdapter;
    FSelectedWells: TSlottingWells;
    FSelectedBoxes: TBoxes;
    FSelectedSlottings, FSelectedPresentSlottings: TSlottings;
    FSelectedGenSections: TGeneralizedSections;
    FRemovePhotoSilently: boolean;
    FShowGeneralizedSection: boolean;
    function  GetActiveObject: TIDObject;
    function  GetWell: TSlottingWell;
    function  GetSlotting: TSlotting;
    procedure OnWellViewAdd(AView: TObject; AObject: TIdObject);
    function  GetSelectedWells: TSlottingWells;
    function  GetSelectedSlottings: TSlottings;
    function  GetSelectedPresentSlottings: TSlottings;
    function  GetActiveBoxWell: TSlottingWell;
    function  GetActiveBox: TBox;
    function  GetSelectedBoxes: TBoxes;
    function  GetSelecteBoxesHasPictures: Boolean;
    function  GetGeneralizedSection: TGeneralizedSection;
    procedure SetShowGeneralizedSection(const Value: boolean);
    function  GetBoxGenSection: TGeneralizedSection;
    function  GetSelectedGenSections: TGeneralizedSections;
  public
    { Public declarations }
    property    ActiveObject: TIDObject read GetActiveObject;
    property    ActiveWell: TSlottingWell read GetWell;
    property    ActiveGenSection: TGeneralizedSection read GetGeneralizedSection;

    property    ActiveBoxWell: TSlottingWell read GetActiveBoxWell;
    property    ActiveBoxGenSection: TGeneralizedSection read GetBoxGenSection;
    property    ActiveSlotting: TSlotting read GetSlotting;
    property    ActiveBox: TBox read GetActiveBox;
    property    SelectedBoxes: TBoxes read GetSelectedBoxes;
    property    SelectedBoxesHasPictures: Boolean read GetSelecteBoxesHasPictures;
    property    RemovePhotoSilently: boolean read FRemovePhotoSilently write FRemovePhotoSilently;

    property    SelectedWells: TSlottingWells read GetSelectedWells;
    property    SelectedGenSections: TGeneralizedSections read GetSelectedGenSections;
    property    SelectedSlottings: TSlottings read GetSelectedSlottings;
    property    SelectedPresentSlottings: TSlottings read GetSelectedPresentSlottings;
    // отображать сводные разрезы
    property    ShowGeneralizedSection: boolean read FShowGeneralizedSection write SetShowGeneralizedSection;
    procedure   ReloadWells;

    property    GUIAdapter: TGUIAdapter read FGUIAdapter implements IGUIAdapter;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

{$R *.dfm}

uses Facade, CRBaseActions, BaseActions, CRCoreLiquidationForm,
  CRBoxPictureForm, CRBoxPictureFrame, CRGenSectionEditForm, Registrator;

type

  TCoreIntervalListAdapter = class(TCollectionGUIAdapter)
  protected
    function    GetCanAdd: boolean; override;
    function    GetCanDelete: boolean; override;
    function    GetCanEdit: boolean; override;
    function    GetCanAddGroup: boolean; override;
    function    GetCanFind: boolean; override;
    function    GetCanSort: boolean; override;
  public
    procedure   Clear; override;
    procedure   SelectAll; override;
    function    Save: integer; override;
    procedure   Reload; override;
    function    Add (): integer; override;
    function    Edit: integer; override;
    procedure   AddGroup; override;
    function    Delete: integer; override;
    function    StartFind: integer; override;
  end;

{ TfrmCoreRegistratorFrame }

constructor TfrmCoreRegistratorFrame.Create(AOwner: TComponent);
begin
  inherited;
  FGUIAdapter := TCoreIntervalListAdapter.Create(Self);
  FGUIAdapter.Buttons := [abAdd, abDelete, abSelectAll, abEdit, abAddGroup];


  FSelectedBoxes := TBoxes.Create;
  FSelectedBoxes.OwnsObjects := False;

  btnGenSections.Enabled := FShowGeneralizedSection;
  pgInterval.ActivePageIndex := 0;
end;

function TfrmCoreRegistratorFrame.GetActiveObject: TIDObject;
begin

  if Assigned(trwCoreIntervals.Selected) then
  begin
    if TObject(trwCoreIntervals.Selected.Data) is TIDObject then
      Result := TObject(trwCoreIntervals.Selected.Data) as TIDObject
    else
      Result := nil;
  end
  else Result := nil;
end;

function TfrmCoreRegistratorFrame.GetSlotting: TSlotting;
begin
  if ActiveObject is TSlotting then
    Result := ActiveObject as TSlotting
  else Result := nil;
end;

function TfrmCoreRegistratorFrame.GetWell: TSlottingWell;
begin
  if ActiveObject is TSlottingWell then
    Result := ActiveObject as TSlottingWell
  else if (ActiveObject is TSlotting) and not (ActiveObject is TGeneralizedSectionSlotting) then
    Result := (ActiveObject as TSlotting).Collection.Owner as TSlottingWell
  else
    Result := nil;
end;

procedure TfrmCoreRegistratorFrame.OnWellViewAdd(AView: TObject;
  AObject: TIdObject);
begin
  if AView is TTreeNode then
  begin
    if (AView as TTreeNode).Level = 0 then
      (AView as TTreeNode).ImageIndex := 0
    else if (AView as TTreeNode).Level = 1 then
      (AView as TTreeNode).ImageIndex := 1
  end;
end;

procedure TfrmCoreRegistratorFrame.ReloadWells;
begin


  (TMainFacade.GetInstance as TMainFacade).AllWells.OnObjectViewAdd := OnWellViewAdd;
  (TMainFacade.GetInstance as TMainFacade).AllWells.MakeList(trwCoreIntervals, true, true);
  (TMainFacade.GetInstance as TMainFacade).AllWells.MakeList(cmbxWells.Items, True, true);
  sbInterval.Panels[1].Text := Format('—кважин %s, из них с керном %s', [IntToStr((TMainFacade.GetInstance as TMainFacade).AllWells.Count), IntToStr(((TMainFacade.GetInstance as TMainFacade).AllWells as TSlottingWells).CoreWellCount)]);
  lwBoxes.Items.Clear;

  if ShowGeneralizedSection then
  begin
    TMainFacade.GetInstance.GeneralizedSections.RefreshIntervals;
    TMainFacade.GetInstance.GeneralizedSections.MakeList(trwCoreIntervals, True, False);
    TMainFacade.GetInstance.GeneralizedSections.MakeList(cmbxWells.Items, True, False);
  end;
end;

procedure TfrmCoreRegistratorFrame.trwCoreIntervalsExpanding(
  Sender: TObject; Node: TTreeNode; var AllowExpansion: Boolean);
begin
  trwCoreIntervals.Selected := Node;

  try
    trwCoreIntervals.Enabled := false;
    if (not Assigned(Node.GetFirstChild.Data)) and (Node.Level = 0) then
    begin
      Node.DeleteChildren;
      if Assigned(ActiveWell) then
      begin
        ActiveWell.Slottings.OnObjectViewAdd := OnWellViewAdd;
        ActiveWell.Slottings.MakeList(Node, true, true, false);
      end
      else if Assigned(ActiveGenSection) then
      begin
        ActiveGenSection.Slottings.OnObjectViewAdd := OnWellViewAdd;
        ActiveGenSection.Slottings.MakeList(Node, True, True, False);
      end;
    end;
  finally
    trwCoreIntervals.Enabled := true;
  end;
end;

procedure TfrmCoreRegistratorFrame.trwCoreIntervalsGetImageIndex(
  Sender: TObject; Node: TTreeNode);
begin
  Node.SelectedIndex := Node.ImageIndex;
end;

procedure TfrmCoreRegistratorFrame.trwCoreIntervalsDblClick(
  Sender: TObject);
begin
  if GUIAdapter.CanEdit then GUIAdapter.Edit;
end;

function TfrmCoreRegistratorFrame.GetSelectedWells: TSlottingWells;
var i: integer;
begin
  if not Assigned(FSelectedWells) then
  begin
    FSelectedWells := TSlottingWells.Create;
    FSelectedWells.OwnsObjects := false;
  end
  else FSelectedWells.Clear;

  for i := 0 to trwCoreIntervals.SelectionCount - 1 do
  if (trwCoreIntervals.Selections[i].Level = 0) and (TIDObject(trwCoreIntervals.Selections[i].Data) is TSlottingWell) then
    FSelectedWells.Add(TIDObject(trwCoreIntervals.Selections[i].Data), false, false);

  Result := FSelectedWells;
end;

destructor TfrmCoreRegistratorFrame.Destroy;
begin
  FreeAndNil(FSelectedWells);
  FreeAndNil(FSelectedSlottings);
  FreeAndNil(FSelectedBoxes);
  FreeAndNil(FSelectedGenSections);
  FreeAndNil(FSelectedPresentSlottings);
  inherited;
end;

function TfrmCoreRegistratorFrame.GetSelectedSlottings: TSlottings;
var i: integer;
begin
  if not Assigned(FSelectedSlottings) then
  begin
    FSelectedSlottings := TSlottings.Create;
    FSelectedSlottings.OwnsObjects := false;
  end
  else FSelectedSlottings.Clear;

  for i := 0 to trwCoreIntervals.SelectionCount - 1 do
  if trwCoreIntervals.Selections[i].Level = 1 then
    FSelectedSlottings.Add(TIDObject(trwCoreIntervals.Selections[i].Data), false, true)
  else if trwCoreIntervals.Selections[i].Level = 0 then
    FSelectedSlottings.AddObjects(TWell(trwCoreIntervals.Selections[i].Data).Slottings, False, true);

  FSelectedSlottings.Sort;
  Result := FSelectedSlottings;
end;

function TfrmCoreRegistratorFrame.GetSelectedPresentSlottings: TSlottings;
var i, j: integer;
begin
  if not Assigned(FSelectedPresentSlottings) then
  begin
    FSelectedPresentSlottings := TSlottings.Create;
    FSelectedPresentSlottings.OwnsObjects := false;
  end
  else FSelectedPresentSlottings.Clear;

  for i := 0 to trwCoreIntervals.SelectionCount - 1 do
  if (trwCoreIntervals.Selections[i].Level = 1) and (TSlotting(trwCoreIntervals.Selections[i].Data).CoreYield > 0) and (TSlotting(trwCoreIntervals.Selections[i].Data).CoreFinalYield > 0) then
    FSelectedPresentSlottings.Add(TIDObject(trwCoreIntervals.Selections[i].Data), false, true)
  else if trwCoreIntervals.Selections[i].Level = 0 then
  begin
    if (TIDObject(trwCoreIntervals.Selections[i].Data) is TWell) then
    begin
      with TWell(trwCoreIntervals.Selections[i].Data) do
      for j := 0 to Slottings.Count - 1 do
      if (TSlotting(Slottings[j]).CoreYield > 0) and (TSlotting(Slottings[j]).CoreFinalYield > 0) then
        FSelectedPresentSlottings.Add(Slottings[j], false, true)
    end
    else if (TIDObject(trwCoreIntervals.Selections[i].Data) is TGeneralizedSection) then
    begin
      with TGeneralizedSection(trwCoreIntervals.Selections[i].Data) do
      for j := 0 to Slottings.Count - 1 do
      if (TSlotting(Slottings[j]).CoreYield > 0) and (TSlotting(Slottings[j]).CoreFinalYield > 0) then
        FSelectedPresentSlottings.Add(Slottings[j], false, true)
    end;
  end;

  FSelectedPresentSlottings.Sort;
  Result := FSelectedPresentSlottings;
end;

function TfrmCoreRegistratorFrame.GetActiveBoxWell: TSlottingWell;
begin
  if cmbxWells.ItemIndex > -1 then
  begin
    if cmbxWells.Items.Objects[cmbxWells.ItemIndex] is TSlottingWell then
      Result := cmbxWells.Items.Objects[cmbxWells.ItemIndex] as TSlottingWell
    else
      Result := nil;
  end
  else
    Result := nil;
end;

function TfrmCoreRegistratorFrame.GetActiveBox: TBox;
begin
  Result := nil;
  if lwBoxes.Selected <> nil then
  begin
    if TObject(lwBoxes.Selected.Data) is TBox then
      Result := TObject(lwBoxes.Selected.Data) as TBox; 
  end;
end;

function TfrmCoreRegistratorFrame.GetSelectedBoxes: TBoxes;
var i: Integer;
begin
  if not Assigned(FSelectedBoxes) then
  begin
    FSelectedBoxes := TBoxes.Create;
    FSelectedBoxes.OwnsObjects := False;
  end;

  FSelectedBoxes.Clear;
  for i := 0 to lwBoxes.Items.Count - 1 do
  if lwBoxes.Items[i].Checked then
    FSelectedBoxes.Add(TBox(lwBoxes.Items[i].Data), False, False);

  if FSelectedBoxes.Count = 0 then
  begin
    if Assigned(lwBoxes.Selected) then
    for i := 0 to lwBoxes.Items.Count - 1 do
    if lwBoxes.Items[i].Selected then
      FSelectedBoxes.Add(TBox(lwBoxes.Items[i].Data), False, False);
  end;

  if FSelectedBoxes.Count = 0 then
  if Assigned(ActiveBoxWell) then
    for i := 0 to ActiveBoxWell.Boxes.Count - 1 do
      FSelectedBoxes.Add(ActiveBoxWell.Boxes.Items[i], False, False);

  Result := FSelectedBoxes;

end;

function TfrmCoreRegistratorFrame.GetSelecteBoxesHasPictures: Boolean;
var i: integer;
begin
  Result := False;
  for i := 0 to SelectedBoxes.Count - 1 do
    Result := Result or SelectedBoxes.Items[i].HasPicture;
end;

function TfrmCoreRegistratorFrame.GetGeneralizedSection: TGeneralizedSection;
begin
  if ActiveObject is TGeneralizedSection then
    Result := ActiveObject as TGeneralizedSection
  else if ActiveObject is TGeneralizedSectionSlotting then
    Result := (ActiveObject as TGeneralizedSectionSlotting).Owner as TGeneralizedSection
  else
    Result := nil;
end;

procedure TfrmCoreRegistratorFrame.SetShowGeneralizedSection(
  const Value: boolean);
begin
  FShowGeneralizedSection := Value;
  btnGenSections.Enabled := FShowGeneralizedSection;
end;

function TfrmCoreRegistratorFrame.GetBoxGenSection: TGeneralizedSection;
begin
  if cmbxWells.ItemIndex > -1 then
  begin
    if cmbxWells.Items.Objects[cmbxWells.ItemIndex] is TGeneralizedSection then
      Result := cmbxWells.Items.Objects[cmbxWells.ItemIndex] as TGeneralizedSection
    else
      Result := nil;
  end
  else
    Result := nil;
end;

function TfrmCoreRegistratorFrame.GetSelectedGenSections: TGeneralizedSections;
var i: integer;
begin
  if not Assigned(FSelectedWells) then
  begin
    FSelectedGenSections := TGeneralizedSections.Create;
    FSelectedGenSections.OwnsObjects := false;
  end
  else FSelectedGenSections.Clear;

  for i := 0 to trwCoreIntervals.SelectionCount - 1 do
  if (trwCoreIntervals.Selections[i].Level = 0) and ((TObject(trwCoreIntervals.Selections[i].Data)) is TGeneralizedSection) then
    FSelectedGenSections.Add(TIDObject(trwCoreIntervals.Selections[i].Data), false, false);

  Result := FSelectedGenSections;
end;

{ TCoreIntervalListAdapter }

function TCoreIntervalListAdapter.Add: integer;
begin
  Result := 0;
  (TMainFacade.GetInstance.ActionByClassType[TSlottingBaseAddAction] as TBaseAction).Execute((Frame as TfrmCoreRegistratorFrame).ActiveWell);
end;

procedure TCoreIntervalListAdapter.AddGroup;
begin
  inherited;
  if not Assigned((Frame as TfrmCoreRegistratorFrame).ActiveWell.SlottingPlacement) then
    (TMainFacade.GetInstance.ActionByClassType[TSlottingPlacementBaseAddAction] as TBaseAction).Execute((Frame as TfrmCoreRegistratorFrame).ActiveWell)
  else
    (TMainFacade.GetInstance.ActionByClassType[TSlottingPlacementBaseAddAction] as TBaseAction).Execute((Frame as TfrmCoreRegistratorFrame).ActiveWell.SlottingPlacement)  
end;

procedure TCoreIntervalListAdapter.Clear;
begin
  inherited;

end;

function TCoreIntervalListAdapter.Delete: integer;
begin
  Result := 0;
  (TMainFacade.GetInstance.ActionByClassType[TSlottingDeleteAction] as TBaseAction).Execute((Frame as TfrmCoreRegistratorFrame).ActiveSlotting);
end;

function TCoreIntervalListAdapter.Edit: integer;
begin
  Result := 0;
  (TMainFacade.GetInstance.ActionByClassType[TSlottingBaseEditAction] as TBaseAction).Execute((Frame as TfrmCoreRegistratorFrame).ActiveSlotting);
end;

function TCoreIntervalListAdapter.GetCanAdd: boolean;
begin
  Result := Assigned((Frame as TfrmCoreRegistratorFrame).ActiveWell);
end;

function TCoreIntervalListAdapter.GetCanAddGroup: boolean;
begin
  Result := Assigned((Frame as TfrmCoreRegistratorFrame).ActiveWell);
end;

function TCoreIntervalListAdapter.GetCanDelete: boolean;
begin
  with (Frame as TfrmCoreRegistratorFrame) do
    Result := Assigned(ActiveSlotting) and not (ActiveSlotting is TGeneralizedSectionSlotting) ;
end;

function TCoreIntervalListAdapter.GetCanEdit: boolean;
begin
  with (Frame as TfrmCoreRegistratorFrame) do
    Result := Assigned(ActiveSlotting) and not (ActiveSlotting is TGeneralizedSectionSlotting) ;
end;

function TCoreIntervalListAdapter.GetCanFind: boolean;
begin
  Result := (TMainFacade.GetInstance.AllWells.Count > 0);
end;

function TCoreIntervalListAdapter.GetCanSort: boolean;
begin
  Result := (inherited GetCanSort) and (TMainFacade.GetInstance.AllWells.Count > 0);
end;

procedure TCoreIntervalListAdapter.Reload;
begin
  inherited;

end;

function TCoreIntervalListAdapter.Save: integer;
begin
  Result := 0;
end;

procedure TCoreIntervalListAdapter.SelectAll;
begin
  inherited;

end;

function TCoreIntervalListAdapter.StartFind: integer;
begin
  Result := 0;
end;

procedure TfrmCoreRegistratorFrame.trwCoreIntervalsExpanded(
  Sender: TObject; Node: TTreeNode);
begin
  if Node.Expanded then
    Node.Selected := true;
end;

procedure TfrmCoreRegistratorFrame.trwCoreIntervalsMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var Node: TTreeNode;
begin
  Node := trwCoreIntervals.GetNodeAt(X, Y);
  if Assigned(Node) and Assigned(Node.Data) and (TObject(Node.Data) is TIDObject) and (Button = mbLeft) then
    TIDObject(Node.Data).Accept(frmWellSlottingInfoQuickView1)
  else
    frmWellSlottingInfoQuickView1.Clear
end;

procedure TfrmCoreRegistratorFrame.frmButtonstlbrClick(Sender: TObject);
begin
//  frmCoreLiquidationForm.Show;
end;

procedure TfrmCoreRegistratorFrame.trwCoreIntervalsCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var s: TSlottingWell;
begin
  if Node.Level = 0 then
  begin
    if TObject(Node.Data) is TSlottingWell then
    begin
      s := TSlottingWell(Node.Data);
      if s.CorePresence = 0 then
        Sender.Canvas.Font.Color := clGrayText;
    end;
  end
  else DefaultDraw := true;
end;

procedure TfrmCoreRegistratorFrame.trwCoreIntervalsKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var Node: TTreeNode;
begin
  Node := trwCoreIntervals.Selected;
  if Assigned(Node) and Assigned(Node.Data) and (TObject(Node.Data) is TIDObject) then
    TIDObject(Node.Data).Accept(frmWellSlottingInfoQuickView1)
  else
    frmWellSlottingInfoQuickView1.Clear
end;

procedure TfrmCoreRegistratorFrame.trwBoxesExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
begin
  trwCoreIntervals.Selected := Node;

  try
    trwCoreIntervals.Enabled := false;
    if (not Assigned(Node.GetFirstChild.Data)) and (Node.Level = 0) then
    begin
      Node.DeleteChildren;
      ActiveWell.Slottings.OnObjectViewAdd := OnWellViewAdd;
      ActiveWell.Slottings.MakeList(Node, true, true, false);
    end;
  finally
    trwCoreIntervals.Enabled := true;
  end;
end;

procedure TfrmCoreRegistratorFrame.cmbxWellsChange(Sender: TObject);
begin
  if Assigned(ActiveBoxWell) then ActiveBoxWell.Boxes.MakeList(lwBoxes.Items, True, true)
  else if Assigned(ActiveBoxGenSection) then ActiveBoxGenSection.Boxes.MakeList(lwBoxes.Items, True, true);
end;

procedure TfrmCoreRegistratorFrame.actnAddSlottingPhotoExecute(
  Sender: TObject);
var iDialogResult: integer;
    bRemove: Boolean;
begin
  iDialogResult := mrOk;
  bRemove := false;

  if SelectedBoxesHasPictures then
  begin
    iDialogResult := MessageDlg('ѕо меньшей мере дл€ одного из выделенных €щиков фото уже загружены. ƒл€ продолжени€ подтвердите удаление ранее загруженных фото.', mtConfirmation, mbOKCancel, 0);
    bRemove := true;
  end;

  if iDialogResult = mrOk then
  begin
    if bRemove then
    begin
      RemovePhotoSilently := True;
      actnRemovePhotoExecute(Sender);
      RemovePhotoSilently := False;
    end;
    
    if not Assigned(frmBoxPictureForm) then
      frmBoxPictureForm := TfrmBoxPictureForm.Create(Self);

    frmBoxPictureForm.Well := ActiveBoxWell;
    frmBoxPictureForm.Boxes := SelectedBoxes;

    frmBoxPictureForm.Reload;
    frmBoxPictureForm.ShowModal;
  end;
end;

procedure TfrmCoreRegistratorFrame.actnAddWellPhotoExecute(
  Sender: TObject);
var iDialogResult: integer;
    bRemove: Boolean;
begin
  iDialogResult := mrOk;
  bRemove := false;

  if SelectedBoxesHasPictures then
  begin
    iDialogResult := MessageDlg('ѕо меньшей мере дл€ одного из выделенных €щиков фото уже загружены. ƒл€ продолжени€ подтвердите удаление ранее загруженных фото.', mtConfirmation, mbOKCancel, 0);
    bRemove := true;
  end;

  if iDialogResult = mrOk then
  begin
    if bRemove then
    begin
      RemovePhotoSilently := True;
      actnRemovePhotoExecute(Sender);
      RemovePhotoSilently := False;
    end;

    if not Assigned(frmBoxPictureForm) then
      frmBoxPictureForm := TfrmBoxPictureForm.Create(Self);

    frmBoxPictureForm.Well := ActiveBoxWell;
    frmBoxPictureForm.Boxes := ActiveBoxWell.Boxes;

    frmBoxPictureForm.Reload;
    frmBoxPictureForm.ShowModal;
  end;
end;

procedure TfrmCoreRegistratorFrame.actnAddSlottingPhotoUpdate(
  Sender: TObject);
begin
  actnAddSlottingPhoto.Enabled := (Assigned(ActiveBoxWell) or Assigned(ActiveBoxGenSection)) and Assigned(ActiveBox);
end;

procedure TfrmCoreRegistratorFrame.actnAddWellPhotoUpdate(Sender: TObject);
begin
  actnAddWellPhoto.Enabled := Assigned(ActiveBoxWell);
end;

procedure TfrmCoreRegistratorFrame.lwBoxesGetImageIndex(Sender: TObject;
  Item: TListItem);
begin
  if Assigned(Item) and Assigned(Item.Data) and (TObject(Item.Data) is TBox) then
  begin
    if TBox(Item.Data).HasPicture then
      Item.ImageIndex := 2
    else
      Item.ImageIndex := -1;
  end;
end;

procedure TfrmCoreRegistratorFrame.actnRemovePhotoExecute(Sender: TObject);
var iDialogResult: integer;
begin
  //
  if SelectedBoxesHasPictures then
  begin
    iDialogResult := mrOk;
    if not RemovePhotoSilently then
      iDialogResult := MessageDlg('ѕодтвердите удаление фото керна дл€ выбранных €щиков.', mtConfirmation, mbOKCancel, 0);

    if iDialogResult = mrOk then
      TMainFacade.GetInstance.ClearBoxPictures(SelectedBoxes);
  end;
end;

procedure TfrmCoreRegistratorFrame.actnRemovePhotoUpdate(Sender: TObject);
begin
  actnRemovePhoto.Enabled := ((SelectedBoxes.Count > 0) or Assigned(ActiveBoxWell)) and SelectedBoxesHasPictures;
end;

procedure TfrmCoreRegistratorFrame.actnShowGenSectionExecute(
  Sender: TObject);
begin
  ShowGeneralizedSection := actnShowGenSection.Checked;
  ReloadWells;
end;

procedure TfrmCoreRegistratorFrame.actnEditGenSectionExecute(
  Sender: TObject);
begin
  if not Assigned(frmGenSectionEditForm) then frmGenSectionEditForm := TfrmGenSectionEditForm.Create(Self);

  frmGenSectionEditForm.Clear;
  frmGenSectionEditForm.EditingObject := ActiveGenSection;

  frmGenSectionEditForm.dlg.ActiveFrameIndex := 0;

  if frmGenSectionEditForm.ShowModal = mrOK then
  begin
    frmGenSectionEditForm.Save;
    frmGenSectionEditForm.EditingObject.Update(nil);
    //TMainFacade.GetInstance.Registrator.Update(ActiveGenSection, nil, ukUpdate);
  end;
end;

procedure TfrmCoreRegistratorFrame.actnEditGenSectionUpdate(
  Sender: TObject);
begin
  actnEditGenSection.Enabled := Assigned(ActiveGenSection);
end;

procedure TfrmCoreRegistratorFrame.actnAddGenSectionExecute(
  Sender: TObject);
begin
  if not Assigned(frmGenSectionEditForm) then frmGenSectionEditForm := TfrmGenSectionEditForm.Create(Self);

  frmGenSectionEditForm.Clear;
  frmGenSectionEditForm.EditingObject := nil;

  frmGenSectionEditForm.dlg.ActiveFrameIndex := 0;

  if frmGenSectionEditForm.ShowModal = mrOK then
  begin
    frmGenSectionEditForm.Save;
    frmGenSectionEditForm.EditingObject.Update(nil);
  end;
end;

procedure TfrmCoreRegistratorFrame.actnRemoveGenSectionExecute(
  Sender: TObject);
begin
  TMainFacade.GetInstance.GeneralizedSections.Remove(ActiveGenSection);
  TMainFacade.GetInstance.AllWells.RefreshIntervals;
  ReloadWells;
end;

procedure TfrmCoreRegistratorFrame.actnRemoveGenSectionUpdate(
  Sender: TObject);
begin
  actnRemoveGenSection.Enabled := Assigned(ActiveGenSection);
end;

procedure TfrmCoreRegistratorFrame.actnViewPhotoExecute(Sender: TObject);
begin

  if SelectedBoxesHasPictures then
  begin
    if not Assigned(frmBoxPictureViewForm) then
      frmBoxPictureViewForm := TfrmBoxPictureForm.Create(Self);

    frmBoxPictureViewForm.Caption := 'ѕросмотреть фото керна';
    frmBoxPictureViewForm.ViewOnly := True;
    frmBoxPictureViewForm.Well := ActiveBoxWell;
    frmBoxPictureViewForm.Boxes := ActiveBoxWell.Boxes;


    frmBoxPictureViewForm.Reload;
    frmBoxPictureViewForm.ShowModal;
  end;

end;

procedure TfrmCoreRegistratorFrame.actnAddIntervalExecute(Sender: TObject);
begin
  GUIAdapter.Add;
end;

procedure TfrmCoreRegistratorFrame.actnAddIntervalUpdate(Sender: TObject);
begin
  actnAddInterval.Enabled := GUIAdapter.CanAdd;
end;

procedure TfrmCoreRegistratorFrame.actnEditIntervalExecute(
  Sender: TObject);
begin
  GUIAdapter.Edit;
end;

procedure TfrmCoreRegistratorFrame.actnEditIntervalUpdate(Sender: TObject);
begin
  actnEditInterval.Enabled := GUIAdapter.CanEdit;
end;

procedure TfrmCoreRegistratorFrame.actnDeleteIntervalExecute(
  Sender: TObject);
begin
  GUIAdapter.Delete;
end;

procedure TfrmCoreRegistratorFrame.actnDeleteIntervalUpdate(
  Sender: TObject);
begin
  actnDeleteInterval.Enabled := GUIAdapter.CanDelete;
end;

procedure TfrmCoreRegistratorFrame.actnEditPlacementExecute(
  Sender: TObject);
begin
  GUIAdapter.AddGroup;
end;

procedure TfrmCoreRegistratorFrame.actnEditPlacementUpdate(
  Sender: TObject);
begin
  actnEditPlacement.Enabled := GUIAdapter.CanAddGroup;
end;

procedure TfrmCoreRegistratorFrame.actnViewPhotoUpdate(Sender: TObject);
begin
  actnViewPhoto.Enabled :=  ((SelectedBoxes.Count > 0) or Assigned(ActiveBoxWell)) and SelectedBoxesHasPictures;
end;

end.

