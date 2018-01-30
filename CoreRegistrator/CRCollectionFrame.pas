unit CRCollectionFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, BaseGUI, UniButtonsFrame, ComCtrls, ActnList, StdCtrls, ExtCtrls,
  CoreCollection, BaseObjects, ImgList, CRWellQuickInfoViewFrame;

type
  TCollectionCurrentView = (ccvWells, ccvDenudations, ccvWellCandidates);

  TfrmCollections = class(TFrame, IGUIAdapter)
    frmButtons1: TfrmButtons;
    pnlAll: TPanel;
    gbxSelectCollection: TGroupBox;
    cmbxCollections: TComboBox;
    Label1: TLabel;
    actnLst: TActionList;
    actnAddCollection: TAction;
    imgLst: TImageList;
    frmQuickView: TfrmWellSlottingInfoQuickView;
    spltProps: TSplitter;
    pgctrlCollection: TPageControl;
    tshWells: TTabSheet;
    gbxCollectionContent: TGroupBox;
    trwCollectionContent: TTreeView;
    tshDenudation: TTabSheet;
    trwDenudation: TTreeView;
    tshWellCandidates: TTabSheet;
    trwWellCandidates: TTreeView;
    procedure trwCollectionContentAdvancedCustomDrawItem(
      Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
      Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
    procedure cmbxCollectionsChange(Sender: TObject);
    procedure trwCollectionContentExpanding(Sender: TObject;
      Node: TTreeNode; var AllowExpansion: Boolean);
    procedure trwCollectionContentClick(Sender: TObject);
    procedure pgctrlCollectionChange(Sender: TObject);
    procedure trwDenudationExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure trwDenudationClick(Sender: TObject);
    procedure trwDenudationAdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: Boolean);
    procedure trwWellCandidatesClick(Sender: TObject);
    procedure trwWellCandidatesAdvancedCustomDrawItem(
      Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
      Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
    procedure trwWellCandidatesExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
  private
    { Private declarations }
    FGUIAdapter: TGUIAdapter;
    FCurrentView: TCollectionCurrentView;
    function  GetActiveCollection: TCoreCollection;
    procedure OnWellViewAdd(AView: TObject; AObject: TIdObject);
    procedure SetCurrentView(const Value: TCollectionCurrentView);
  public
    { Public declarations }
    // выбранная коллекция
    property    ActiveCollection: TCoreCollection read GetActiveCollection;
    // загрузить список коллекций
    procedure   PrepareCollections;
    // загрузить скважины коллекции (по фильтру)
    procedure   ReloadWells;
    procedure   ReloadDenudations;
    procedure   ReloadWellCandidates;
    procedure   ReloadCurrentView;

    property    CurrentView: TCollectionCurrentView read FCurrentView write SetCurrentView;
    property    GUIAdapter: TGUIAdapter read FGUIAdapter implements IGUIAdapter;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses Facade, CRBaseActions, BaseActions, CRAddSelectorForm;


{$R *.dfm}

type
  TCoreIntervalListAdapter = class(TCollectionGUIAdapter)
  protected
    function    GetCanAdd: boolean; override;
    function    GetCanDelete: boolean; override;
    function    GetCanEdit: boolean; override;
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


{ TfrmCollections }

constructor TfrmCollections.Create(AOwner: TComponent);
begin
  inherited;
  FGUIAdapter := TCoreIntervalListAdapter.Create(Self);
  FGUIAdapter.Buttons := [abReload, abAdd, abDelete, abFind, abSort, abSelectAll, abEdit, abAddGroup];

  frmButtons1.GUIAdapter := FGUIAdapter;

  pgctrlCollection.ActivePageIndex := 0;
  FCurrentView := ccvWells;
end;

function TfrmCollections.GetActiveCollection: TCoreCollection;
begin
  Result := nil;

  if cmbxCollections.ItemIndex > -1 then
    Result := TCoreCollection(cmbxCollections.Items.Objects[cmbxCollections.ItemIndex]);
end;

procedure TfrmCollections.OnWellViewAdd(AView: TObject;
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

procedure TfrmCollections.PrepareCollections;
begin
  (TMainFacade.GetInstance as TMainFacade).AllCoreCollections.MakeList(cmbxCollections.Items);
end;

procedure TfrmCollections.ReloadWells;
begin
  if Assigned(ActiveCollection) then
  begin
    (TMainFacade.GetInstance as TMainFacade).AllCollectionWells.OnObjectViewAdd := OnWellViewAdd;
    (TMainFacade.GetInstance as TMainFacade).AllCollectionWells.MakeList(trwCollectionContent, true, true);
  end;
end;


procedure TfrmCollections.ReloadDenudations;
begin
  if Assigned(ActiveCollection) then
  begin
    (TMainFacade.GetInstance as TMainFacade).AllDenudations.OnObjectViewAdd := OnWellViewAdd;
    (TMainFacade.GetInstance as TMainFacade).AllDenudations.MakeList(trwDenudation, true, true);
  end;
end;

procedure TfrmCollections.SetCurrentView(
  const Value: TCollectionCurrentView);
begin
  if FCurrentView <> Value then
  begin
    FCurrentView := Value;
    ReloadCurrentView;
  end;
end;

procedure TfrmCollections.ReloadCurrentView;
begin
  case FCurrentView of
  ccvWells: ReloadWells;
  ccvDenudations: ReloadDenudations;
  ccvWellCandidates: ReloadWellCandidates;
  end;
end;

procedure TfrmCollections.ReloadWellCandidates;
begin
  if Assigned(ActiveCollection) then
  begin
    (TMainFacade.GetInstance as TMainFacade).AllWellCandidates.OnObjectViewAdd := OnWellViewAdd;
    (TMainFacade.GetInstance as TMainFacade).AllWellCandidates.MakeList(trwWellCandidates, true, true);
  end;
end;

{ TCoreIntervalListAdapter }

function TCoreIntervalListAdapter.Add: integer;
begin
  Result := 0;

  if Assigned((Owner as TfrmCollections).ActiveCollection) then 
  begin
    if not Assigned(frmAddSelector) then frmAddSelector := TfrmAddSelector.Create(Self);
    if not frmAddSelector.SaveSelection then frmAddSelector.ShowModal;
    case frmAddSelector.Selection of
    asCollection: (TMainFacade.GetInstance.ActionByClassType[TCollectionAddAction] as TBaseAction).Execute(TIDObject(nil));
    asExponate: (TMainFacade.GetInstance.ActionByClassType[TCollectionSampleEditAction] as TBaseAction).Execute(TIDObject(nil)); 
    asNone:;
    end;
  end // если активной коллекции нет, то экспонаты добавлять некуда
  else (TMainFacade.GetInstance.ActionByClassType[TCollectionAddAction] as TBaseAction).Execute(TIDObject(nil));
end;

procedure TCoreIntervalListAdapter.AddGroup;
begin
  inherited;

end;

procedure TCoreIntervalListAdapter.Clear;
begin
  inherited;

end;

function TCoreIntervalListAdapter.Delete: integer;
begin
  Result := 0;
end;

function TCoreIntervalListAdapter.Edit: integer;
begin
  Result := 0;
  (TMainFacade.GetInstance.ActionByClassType[TCollectionAddAction] as TBaseAction).Execute((Frame as TfrmCollections).ActiveCollection);
end;

function TCoreIntervalListAdapter.GetCanAdd: boolean;
begin
  Result := true;
end;

function TCoreIntervalListAdapter.GetCanDelete: boolean;
begin
  Result := true;
end;

function TCoreIntervalListAdapter.GetCanEdit: boolean;
begin
  Result := true;
end;

function TCoreIntervalListAdapter.GetCanFind: boolean;
begin
  Result := true;
end;

function TCoreIntervalListAdapter.GetCanSort: boolean;
begin
  Result := true;
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

procedure TfrmCollections.trwCollectionContentAdvancedCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
begin
  if Node.Level = 0 then
  begin
    if (TObject(Node.Data) is TCollectionWell) then
    begin
      if (TObject(Node.Data) as TCollectionWell).IsSamplesPresent then
        trwCollectionContent.Canvas.Font.Style := [fsBold];
    end;
  end;
end;

procedure TfrmCollections.cmbxCollectionsChange(Sender: TObject);
begin
  (TMainFacade.GetInstance as TMainFacade).ActiveCollection := ActiveCollection;
  ReloadCurrentView;
end;

procedure TfrmCollections.trwCollectionContentExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
var w: TCollectionWell;
    i: integer;
begin
  // разворачиваем ветку образцов
  if Node.Level = 0 then
  begin
    Node.DeleteChildren;

    w := TCollectionWell(Node.Data);
    for i := 0 to w.CollectionSamples.Count - 1 do
      trwCollectionContent.Items.AddChildObject(Node, w.CollectionSamples.Items[i].List(loBrief), w.CollectionSamples.Items[i]);

    AllowExpansion := true;
  end;
end;

procedure TfrmCollections.trwCollectionContentClick(Sender: TObject);
var Node: TTreeNode;
begin
  Node := trwCollectionContent.Selected;
  if Assigned(Node) and (not(Node.Deleting)) and Assigned(Node.Data) and (TObject(Node.Data) is TIDObject) then
    TIDObject(Node.Data).Accept(frmQuickView)
end;

procedure TfrmCollections.pgctrlCollectionChange(Sender: TObject);
begin
  case pgctrlCollection.ActivePageIndex of
  0: CurrentView := ccvWells;
  1: CurrentView := ccvDenudations;
  2: CurrentView := ccvWellCandidates;
  end;
end;

procedure TfrmCollections.trwDenudationExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
var d: TDenudation;
    i: integer;
begin
  // разворачиваем ветку образцов
  if Node.Level = 0 then
  begin
    Node.DeleteChildren;

    d := TDenudation(Node.Data);
    for i := 0 to d.DenudationSamples.Count - 1 do
      trwDenudation.Items.AddChildObject(Node, d.DenudationSamples.Items[i].List(loBrief), d.DenudationSamples.Items[i]);

    AllowExpansion := true;
  end;
end;

procedure TfrmCollections.trwDenudationClick(Sender: TObject);
var Node: TTreeNode;
begin
  Node := trwDenudation.Selected;
  if Assigned(Node) and (not(Node.Deleting)) and Assigned(Node.Data) and (TObject(Node.Data) is TIDObject) then
    TIDObject(Node.Data).Accept(frmQuickView)
end;

procedure TfrmCollections.trwDenudationAdvancedCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
begin
  if Node.Level = 0 then
  begin
    if (TObject(Node.Data) is TDenudation) then
    begin
      if (TObject(Node.Data) as TDenudation).IsSamplesPresent then
        trwDenudation.Canvas.Font.Style := [fsBold];
    end;
    { TODO : Очень долго прорисовываются обнажения с образцами }
  end;
end;

procedure TfrmCollections.trwWellCandidatesClick(Sender: TObject);
var Node: TTreeNode;
begin
  Node := trwWellCandidates.Selected;
  if Assigned(Node) and (not(Node.Deleting)) and Assigned(Node.Data) and (TObject(Node.Data) is TIDObject) then
    TIDObject(Node.Data).Accept(frmQuickView)
end;

procedure TfrmCollections.trwWellCandidatesAdvancedCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
begin
  if Node.Level = 0 then
  begin
    if (TObject(Node.Data) is TWellCandidate) then
    begin
      if (TObject(Node.Data) as TWellCandidate).IsSamplesPresent then
        trwWellCandidates.Canvas.Font.Style := [fsBold];
    end;
  end;
end;

procedure TfrmCollections.trwWellCandidatesExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
var w: TWellCandidate;
    i: integer;
begin
  // разворачиваем ветку образцов
  if Node.Level = 0 then
  begin
    Node.DeleteChildren;

    w := TWellCandidate(Node.Data);
    for i := 0 to w.WellCandidateSamples.Count - 1 do
      trwWellCandidates.Items.AddChildObject(Node, w.WellCandidateSamples.Items[i].List(loBrief), w.WellCandidateSamples.Items[i]);

    AllowExpansion := true;
  end;
end;

end.

