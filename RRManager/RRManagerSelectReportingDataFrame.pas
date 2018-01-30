unit RRManagerSelectReportingDataFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RRManagerMainTreeFrame, CommonObjectSelectFilter, RRManagerBaseObjects,
  RRManagerReport, RRmanagerObjects, StdCtrls, ExtCtrls, ComCtrls, Contnrs, RRManagerBaseGUI,
  ToolWin, Buttons, ImgList, ActnList, ClientProgressBarForm;

type
  TNodesRelations = class;

//  TfrmSelectReportingData = class(TFrame)
  TfrmSelectReportingData = class(TBaseFrame)
    frmObjectSelect: TfrmObjectSelect;
    pnl: TPanel;
    gbxSelected: TGroupBox;
    frmMainTree: TfrmMainTree;
    trwSelected: TTreeView;
    splt: TSplitter;
    pnlButtons: TPanel;
    actnLst: TActionList;
    actnAdd: TAction;
    actnDelete: TAction;
    actnAddAll: TAction;
    actnDeleteAll: TAction;
    imgList: TImageList;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    procedure frmMainTreetrwMainDblClick(Sender: TObject);
    procedure trwSelectedDblClick(Sender: TObject);
    procedure trwSelectedGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure actnAddExecute(Sender: TObject);
    procedure actnDeleteExecute(Sender: TObject);
    procedure actnAddAllExecute(Sender: TObject);
    procedure actnDeleteAllExecute(Sender: TObject);
    procedure actnAddUpdate(Sender: TObject);
    procedure actnDeleteUpdate(Sender: TObject);
    procedure actnAddAllUpdate(Sender: TObject);
    procedure actnDeleteAllUpdate(Sender: TObject);
  private
    FSelectedLoadAction: TBaseAction;
    FRelations: TNodesRelations;
    FPreSelectedStructures: TOldStructures;
    FAccessibleStructures: TOldStructures;
    FImmediateReload: boolean;
    procedure OnReloadStructures(Sender: TObject);
    function  GetReportFilter: TReportFilter;
    function  GetSelectedStructures: TOldStructures;
    procedure onChangeLevel(Sender: TObject);
    function  GetReport: TCommonReport;
    { Private declarations }
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
    procedure RegisterInspector; override;
  public
    { Public declarations }
    // структуры, которые показываются для выбора
    property    AccessibleStructures: TOldStructures read FAccessibleStructures;
    // структуры, которые выбрал пользователь
    property    SelectedStructures: TOldStructures read GetSelectedStructures;
    property    ReportFilter: TReportFilter read GetReportFilter;

    property    Report: TCommonReport read GetReport;

    property    ImmediateReload: boolean read FImmediateReload write FImmediateReload;


    procedure   Save; override;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;



  TNodesRelation = class
  private
    FDestNode: TTreeNode;
    FSourceNode: TTreeNode;
  public
    property SourceNode: TTreeNode read FSourceNode write FSourceNode;
    property DestNode: TTreeNode read FDestNode write FDestNode;
  end;

  TNodesRelations = class(TObjectList)
  private
    function GetItems(const Index: integer): TNodesRelation;
  public
    property Items[const Index: integer]: TNodesRelation read GetItems;
    function Add(ASourceNode, ADestNode: TTreeNode): TNodesRelation;
    function GetItemBySource(ASourceObject: TObject): TNodesRelation;
    function GetItemByDest(ADestObject: TObject): TNodesRelation;
    constructor Create;
  end;




implementation

uses RRManagerCommon, Facade;

{$R *.DFM}


type

   TSelectionLoadAction = class(TBaseAction)
   public
     function Execute: boolean; override;
   end;

{ TfrmSelectReportingData }

procedure TfrmSelectReportingData.ClearControls;
begin
  frmObjectSelect.Clear;
  frmMainTree.Clear;
  if Assigned(SelectedStructures) then
    SelectedStructures.Clear;
  trwSelected.Items.Clear;
end;

constructor TfrmSelectReportingData.Create(AOwner: TComponent);
begin
  inherited;
  ImmediateReload := true;
  FSelectedLoadAction := TSelectionLoadAction.Create(Self); 
  FPreSelectedStructures := TOldStructures.Create(nil);
  FRelations := TNodesRelations.Create;
  frmObjectSelect.AllowSelectAll := true;
  frmObjectSelect.Prepare;
  frmObjectSelect.OnReloadData := onReloadStructures;
  frmMainTree.OnChangeLevel := onChangeLevel;
  frmMainTree.MenuVisible := false;
  frmMainTree.ToolBarVisible := false;
  frmMainTree.UpperPanelVisible := true;  

  FAccessibleStructures := TOldStructures.Create(nil);

  NeedCopyState := false;
end;

procedure TfrmSelectReportingData.FillControls(ABaseObject: TBaseObject);
begin
  frmMainTree.Structures := AccessibleStructures;
  ClearControls;
  AllOpts.Current.Represent := Report.Level;
  frmMainTree.ChangeLevel;
end;

procedure TfrmSelectReportingData.FillParentControls;
begin
end;

function TfrmSelectReportingData.GetReportFilter: TReportFilter;
begin
  Result := EditingObject as TReportFilter;
end;

function TfrmSelectReportingData.GetSelectedStructures: TOldStructures;
begin
  if Assigned(ReportFilter) then
    Result := ReportFilter.Structures
  else
    Result := nil;
end;

procedure TfrmSelectReportingData.OnreloadStructures(Sender: TObject);
var sFilterSQL: string;
begin
  sFilterSQL := frmObjectSelect.SQL;

  if Assigned((TMainFacade.GetInstance as TMainFacade).ActiveVersion)  then
  if trim(sFilterSQL) <> '' then
    sFilterSQL := '(' + sFilterSQL + ')' + ' and ' + '(Version_ID = ' + IntToStr((TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID) + ')'
  else
    sFilterSQL := '(Version_ID = ' + IntToStr((TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID) + ')';  


  frmMainTree.DeselectAllAction.Execute;
  frmMainTree.StructureLoadAction.Execute(sFilterSQL);
end;

procedure TfrmSelectReportingData.Save;
var s, h, subs, b: integer;
begin
  SelectedStructures.Clear;
  SelectedStructures.Assign(FPreSelectedStructures);
  // сохраняем все

  for s := 0 to SelectedStructures.Count - 1 do
  begin
    SelectedStructures.Items[s].Horizons.Assign(FPreSelectedStructures.Items[s].Horizons);
    for h := 0 to SelectedStructures.Items[s].Horizons.Count - 1 do
    begin
      SelectedStructures.Items[s].Horizons.Items[h].Substructures.Assign(FPreSelectedStructures.Items[s].Horizons.Items[h].Substructures);
      for subs := 0 to SelectedStructures.Items[s].Horizons.Items[h].Substructures.Count - 1 do
        SelectedStructures.Items[s].Horizons.Items[h].Substructures.Items[subs].Layers.Assign(FPreSelectedStructures.Items[s].Horizons.Items[h].Substructures.Items[subs].Layers);
    end;

    if SelectedStructures.Items[s] is TOldField then
    begin
      (SelectedStructures.Items[s] as TOldField).Beds.Assign((FPreSelectedStructures.Items[s] as TOldField).Beds);

      for b := 0 to (SelectedStructures.Items[s] as TOldField).Beds.Count - 1 do
        (SelectedStructures.Items[s] as TOldField).Beds.Items[b].Layers.Assign((FPreSelectedStructures.Items[s] as TOldField).Beds.Items[b].Layers);

    end;
  end
end;

{procedure TfrmSelectReportingData.frmMainTreetrwMainDblClick(
  Sender: TObject);
var r: TNodesRelation;
    O: TObject;
    Node: TTreeNode;
function CheckNode(ANode: TTreeNode): TNodesRelation;
var sr: TNodesRelation;
    AlternateNode: TTreeNode;
begin
  if Assigned(ANode.Parent) then
  begin
    // ищем и добавляем предка
    sr := FRelations.GetItemBySource(TObject(ANode.Parent.Data));
    // если не находим - ищем его предка
    if not Assigned(sr) then
      sr := CheckNode(ANode.Parent);

    // в конце концов - добавляем
    if Assigned(sr) then
    begin
      // предка к какой-либо ветке
      AlternateNode := trwSelected.Items.AddChild(sr.DestNode, '');
      AlternateNode.Assign(ANode);
      Result := FRelations.Add(ANode, AlternateNode);
    end
    else
    begin
      // или самую первую ветку
      AlternateNode := trwSelected.Items.Add(nil, '');
      AlternateNode.Assign(ANode);
      result := FRelations.Add(ANode, AlternateNode);
    end;
  end
  else
  begin
    // или самую первую ветку
    AlternateNode := trwSelected.Items.Add(nil, '');
    AlternateNode.Assign(ANode);
    result := FRelations.Add(ANode, AlternateNode);
  end;
end;


begin
  if  Assigned(frmMainTree.trwMain.Selected) then
  begin
    o := TObject(frmMainTree.trwMain.Selected.Data);
    frmMainTree.trwMain.Selected.Expand(true);

    // возвращаем выделение
    Node := frmMainTree.trwMain.Items.GetFirstNode;
    While Assigned(Node) do
    begin
      if TObject(Node.Data) = o then
      begin
        Node.Selected := true;
        break;
      end;
      Node := Node.GetNext;
    end;

    // ищем не выбрали ли уже такую ветку
    // в фильтр для отчета
    r := FRelations.GetItemBySource(TBaseObject(frmMainTree.trwMain.Selected.Data));

    // если нет
    // то выбираем - вместе со всеми предками той ветки
    // соотвественно, надо проверить - если предки есть
    // то добавлять к ним
    if not Assigned(r) then
    begin
      r := CheckNode(frmMainTree.trwMain.Selected);
      // копируем всех детей
      Node := frmMainTree.trwMain.Selected.getFirstChild;
      while Assigned(Node)
        and (Node.Level > frmMainTree.trwMain.Selected.Level) do
      begin
        CheckNode(Node);
        Node := Node.GetNext;
      end;
    end;

    // выделяем найденный узел
    r.DestNode.Selected := true;
    r.DestNode.MakeVisible;

  end;
end;}

destructor TfrmSelectReportingData.Destroy;
begin
  FPreSelectedStructures.Free;
  FSelectedLoadAction.Free;
  FRelations.Free;
  FAccessibleStructures.Free;
  inherited;
end;

procedure TfrmSelectReportingData.onChangeLevel(Sender: TObject);
begin
  FRelations.Clear;
  trwSelected.Items.Clear;
end;


procedure TfrmSelectReportingData.RegisterInspector;
begin
  inherited;
  Inspector.Add(trwSelected, nil, ptNonEmptyList, 'выбранные объекты', false);
end;

function TfrmSelectReportingData.GetReport: TCommonReport;
begin
  Result := ReportFilter.Report;
end;

procedure TfrmSelectReportingData.frmMainTreetrwMainDblClick(
  Sender: TObject);
begin
  actnAdd.Execute;
end;

{ TNodesRelations }

function TNodesRelations.Add(ASourceNode, ADestNode: TTreeNode): TNodesRelation;
begin
  Result := TNodesRelation.Create;
  Result.SourceNode := ASourceNode;
  Result.DestNode := ADestNode;
  inherited Add(Result);
end;

constructor TNodesRelations.Create;
begin
  inherited;
  OwnsObjects := false;
end;

function TNodesRelations.GetItemByDest(
  ADestObject: TObject): TNodesRelation;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if TBaseObject(Items[i].DestNode.Data) = ADestObject then
  begin
    Result := Items[i];
    break;
  end;
end;

function TNodesRelations.GetItemBySource(
  ASourceObject: TObject): TNodesRelation;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if TBaseObject(Items[i].SourceNode.Data) = ASourceObject then
  begin
    Result := Items[i];
    break;
  end;
end;

function TNodesRelations.GetItems(const Index: integer): TNodesRelation;
begin
  Result := inherited Items[Index] as TNodesRelation;
end;

procedure TfrmSelectReportingData.trwSelectedDblClick(Sender: TObject);
begin
  actnDelete.Execute;
end;

{ TSelectionLoadAction }

function TSelectionLoadAction.Execute: boolean;
var iStr, iH, iSubs, iL, iB: integer;
    S: TOldStructure;
    H: TOldHorizon;
    SubS: TOldSubstructure;
    L: TOldLayer;
    B: TOldBed;
    MainNode, StrNode, HNode, SubStrNode, BedNode, LayerNode: TTreeNode;
begin
  Result := true;
  with (Owner as TfrmSelectReportingData) do
  begin
    trwSelected.Items.BeginUpdate;
    trwSelected.Items.Clear;

    for iStr := 0 to FPreSelectedStructures.Count - 1 do
    begin
      S := FPreSelectedStructures.Items[iStr];

      MainNode := trwSelected.Items.AddChildObject(nil, S.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), S);

      if S is TOldDiscoveredStructure then
         MainNode.SelectedIndex := 4
      else if S is TOldPreparedStructure then
         MainNode.SelectedIndex := 5
      else if S is TOldDrilledStructure then
         MainNode.SelectedIndex := 6
      else if S is TOldField then
         MainNode.SelectedIndex := 7;

      StrNode := trwSelected.Items.AddChildObject(MainNode, 'Горизонты', S.Horizons);
      StrNode.SelectedIndex := 3;
            
      for iH := 0 to S.Horizons.Count - 1 do
      begin
        H := S.Horizons.Items[iH];

        HNode := trwSelected.Items.AddChildObject(StrNode, H.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), H);
        HNode.SelectedIndex  := 8;

        for iSubs := 0 to H.Substructures.Count - 1 do
        begin
          Subs := H.Substructures.Items[iSubs];
          SubStrNode := trwSelected.Items.AddChildObject(HNode, Subs.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), Subs);
          SubStrNode.SelectedIndex := 7 + Subs.StructureElementTypeID  + ord(Subs.StructureElementTypeID = 0);
          for iL := 0 to Subs.Layers.Count - 1 do
          begin
            L := Subs.Layers.Items[iL];
            LayerNode := trwSelected.Items.AddChildObject(SubStrNode, L.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), L);
            LayerNode.SelectedIndex := 12;
          end;
        end
      end;

      if S is TOldField then
      begin
        BedNode := trwSelected.Items.AddChildObject(MainNode, 'Залежи', (S as TOldField).Beds);
        BedNode.SelectedIndex := 11;

        for iB := 0 to (S as TOldField).Beds.Count - 1 do
        begin
          B := (S as TOldField).Beds.Items[iB];
          for iL := 0 to B.Layers.Count - 1 do
          begin
            L := B.Layers.Items[iL];
            LayerNode := trwSelected.Items.AddChildObject(BedNode, L.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), L);
            LayerNode.SelectedIndex := 12;
          end;
        end;
      end;
    end;

    trwSelected.Items.EndUpdate;
  end;
end;

procedure TfrmSelectReportingData.trwSelectedGetImageIndex(Sender: TObject;
  Node: TTreeNode);
begin
  with Node do
    ImageIndex := SelectedIndex;
end;

procedure TfrmSelectReportingData.actnAddExecute(Sender: TObject);
var bo: TBaseObject;
    F: TOldField;
    S: TOldStructure;
    H: TOldHorizon;
    Subs: TOldSubstructure;
    B: TOldBed;

function AppendStructures(AStructures: TOldStructures; AStructure: TOldStructure): TOldStructure;
begin
  Result := AStructures.ItemsByUIN[AStructure.ID] as TOldStructure;
  if not Assigned(Result) then
  begin
    Result := AStructures.Add(TOldStructureClass(AStructure.ClassType));
    Result.Assign(AStructure);
  end;
end;

function AppendCollection(ACollection: TBaseCollection; AObject: TBaseObject): TBaseObject;
begin
  Result := ACollection.ItemsByUIN[AObject.ID];
  if not Assigned(Result) then
  begin
    Result := ACollection.Add;
    Result.Assign(AObject)
  end;
end;

begin
  if Assigned(frmMainTree.trwMain.Selected) then
  begin
    bo := nil;
    if TObject(frmMainTree.trwMain.Selected.Data) is TBaseObject then
       bo := TBaseObject(frmMainTree.trwMain.Selected.Data);

    // загрузить объект целиком
    frmMainTree.trwMain.Selected.Expand(true);

    if Assigned(bo) then
    begin
      if bo is TOldStructure then
      begin
        S := AppendStructures(FPreSelectedStructures, (bo as TOldStructure));
        s.AssignCollections(bo as TOldStructure);
      end
      else
      if bo is TOldBed then
      begin
        F := AppendStructures(FPreSelectedStructures, (bo as TOldBed).Field) as TOldField;
        B := AppendCollection(F.Beds, bo) as TOldBed;
        b.AssignCollections(bo as TOldBed);
      end
      else
      if bo is TOldHorizon then
      begin
        S := AppendStructures(FPreSelectedStructures, (bo as TOldHorizon).Structure) as TOldStructure;
        H := AppendCollection(S.Horizons, bo) as TOldHorizon;
        h.AssignCollections(bo as TOldHorizon);
      end
      else
      if bo is TOldSubstructure then
      begin
        S := AppendStructures(FPreSelectedStructures, (bo as TOldSubstructure).Horizon.Structure) as TOldStructure;
        H := AppendCollection(S.Horizons, (bo as TOldSubstructure).Horizon) as TOldHorizon;
        subs := AppendCollection(H.Substructures, bo) as TOldSubstructure;
        subs.AssignCollections(bo as TOldSubstructure);
      end
      else
      if bo is TOldLayer then
      begin
        if not Assigned((bo as TOldLayer).Bed) then
        begin
          S := AppendStructures(FPreSelectedStructures, (bo as TOldLayer).Substructure.Horizon.Structure) as TOldStructure;
          H := AppendCollection(S.Horizons, (bo as TOldLayer).Substructure.Horizon) as TOldHorizon;
          Subs := AppendCollection(H.Substructures,(bo as TOldLayer).Substructure) as TOldSubstructure;
          AppendCollection(Subs.Layers, (bo as TOldLayer));
        end
        else
        begin
          F := AppendStructures(FPreSelectedStructures, (bo as TOldLayer).Bed.Structure) as TOldField;
          B := AppendCollection(F.Beds, (bo as TOldLayer).Bed) as TOldBed;
          AppendCollection(B.Layers, (bo as TOldLayer));
        end;
      end;
    end;
    if ImmediateReload then FSelectedLoadAction.Execute;
  end;
  Check;
end;

procedure TfrmSelectReportingData.actnDeleteExecute(Sender: TObject);
procedure DeleteRelations(Node: TTreeNode);
var Child: TTreeNode;
    r: TNodesRelation;

begin
  Child := Node.getFirstChild;
  while Assigned(Child) do
  begin
    r := FRelations.GetItemByDest(TObject(Child.Data));
    FRelations.Remove(r);
    Child := Node.GetNextChild(Child);
  end;

  r := FRelations.GetItemByDest(TObject(Node.Data));
  FRelations.Remove(r);
end;

begin
  // удаляем выделенное
  if Assigned(trwSelected.Selected) then
  begin
    if TObject(trwSelected.Selected.Data) is TBaseObject then
    begin
      TBaseObject(trwSelected.Selected.Data).Free;
      trwSelected.Selected.Delete;
    end;
  end;
  Check;  
end;

procedure TfrmSelectReportingData.actnAddAllExecute(Sender: TObject);
var Node: TTreeNode;
begin
  //
  if not Assigned(frmProgressBar) then frmProgressBar := TfrmProgressBar.Create(Self);

  frmProgressBar.InitProgressBar('Формируется фильтр отчёта', aviCopyFiles);
  frmProgressBar.Show;


  frmMainTree.trwMain.Items.BeginUpdate;
  Node := frmMainTree.trwMain.Items.GetFirstNode;

  ImmediateReload := false;
  while Assigned(Node) do
  begin
    Node.Selected := true;
    actnAdd.Execute;
    Node := Node.getNextSibling;
    frmProgressBar.Update();
    Update;
  end;
  FSelectedLoadAction.Execute;
  ImmediateReload := true;
  frmMainTree.trwMain.Items.EndUpdate;
  Check;

  frmProgressBar.Hide;
end;

procedure TfrmSelectReportingData.actnDeleteAllExecute(Sender: TObject);
var i: integer;
begin
  trwSelected.Items.BeginUpdate;
  for i := trwSelected.Items.Count - 1 downto 0 do
  if trwSelected.Items[i].Level = 0 then
  begin
    trwSelected.Items[i].Selected := true;
    actnDelete.Execute;
  end;
  trwSelected.Items.EndUpdate;  
  Check;
end;

procedure TfrmSelectReportingData.actnAddUpdate(Sender: TObject);
begin
  actnAdd.Enabled := Assigned(frmMainTree.trwMain.Selected);
end;

procedure TfrmSelectReportingData.actnDeleteUpdate(Sender: TObject);
begin
  actnDelete.Enabled := Assigned(trwSelected.Selected);
end;

procedure TfrmSelectReportingData.actnAddAllUpdate(Sender: TObject);
begin
//
end;

procedure TfrmSelectReportingData.actnDeleteAllUpdate(Sender: TObject);
begin
//
end;

end.
