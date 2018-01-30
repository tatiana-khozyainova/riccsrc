unit RRManagerEditResourceFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RRManagerBaseObjects, ComCtrls, ToolWin, StdCtrls, ActnList, ImgList,
  Mask, ToolEdit, CommonComplexCombo, ExtCtrls, RRManagerObjects,
  ClientCommon, RRManagerEditVersionFrame,
  RRManagerBaseGUI, RRManagerVersionsFrame;

type
//  TfrmResources = class(TFrame)
  TfrmResources = class(TBaseFrame)
    gbxProperties: TGroupBox;
    tlbrEdit: TToolBar;
    pgctl: TPageControl;
    tshResourceEditor: TTabSheet;
    tlbtnAdd: TToolButton;
    tlbtnBack: TToolButton;
    ToolButton4: TToolButton;
    tlbtnClear: TToolButton;
    cmplxFluidType: TfrmComplexCombo;
    cmplxResourceType: TfrmComplexCombo;
    cmplxResourceCategory: TfrmComplexCombo;
    edtValue: TEdit;
    Label4: TLabel;
    Bevel1: TBevel;
    Label5: TLabel;
    frmVersions: TfrmVersions;
    Splitter1: TSplitter;
    procedure trwResourcesChange(Sender: TObject; Node: TTreeNode);
    procedure cmplxFluidTypecmbxNameChange(Sender: TObject);
    procedure cmplxResourceCategorycmbxNameChange(Sender: TObject);
    procedure cmplxResourceTypecmbxNameChange(Sender: TObject);
    procedure edtValueChange(Sender: TObject);
    procedure trwResourcesChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure frmVersioncmbxDocNameChange(Sender: TObject);
  private
    { Private declarations }
    FLoadAction, FElementAction: TBaseAction;
    FVersions: TOldAccountVersions;
    FResource: TOldResource;
    FTempObject: TbaseObject;
    FCreatedCollection: TBaseCollection;
    FCreatedObject: TBaseObject;
    function GetBed: TOldBed;
    function GetLayer: TOldLayer;
    function GetSubstructure: TOldSubstructure;
    function  GetVersions: TOldAccountVersions;
    procedure SetResource(const Value: TOldResource);
    procedure SaveResource;
    procedure ClearOnlyControls;
    procedure OnChangeVersion(Sender: TObject);
    procedure AddVersion(Sender: TObject);
    procedure DeleteVersion(Sender: TObject);
    procedure AddResource(Sender: TObject);
    procedure DeleteResource(Sender: TObject);
    procedure SaveCurrentChecked(Sender: TObject);
    procedure MakeClear(Sender: TObject);
    procedure MakeUndo(Sender: TObject);
    procedure ViewChange(Sender: TObject);
    procedure OnSaveVersion(Sender: TObject); 
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
    procedure RegisterInspector; override;
    procedure LocalRegisterInspector;
  public
    { Public declarations }
    property Versions: TOldAccountVersions read GetVersions;
    property Layer: TOldLayer read GetLayer;
    property Bed: TOldBed read GetBed;
    property Substructure: TOldSubstructure read GetSubstructure;
    property Resource: TOldResource read FResource write SetResource;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   Save; override;
  end;

implementation

{$R *.DFM}

uses RRManagerLoaderCommands, FramesWizard;

type

  TResourceVersionLoadAction = class(TVersionBaseLoadAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
  end;

  TResourceByVersionLoadAction = class(TResourceByVersionBaseLoadAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
  end;


{ TfrmResourceReserves }

procedure TfrmResources.ClearControls;
begin
  FVersions.Free;
  FVersions := nil;
  FResource := nil;
  ClearOnlyControls;
end;

constructor TfrmResources.Create(AOwner: TComponent);
begin
  inherited;
  NeedCopyState := false;
  FCreatedCollection := TBaseCollection.Create(TBaseObject);
  FCreatedObject := FCreatedCollection.Add;

  FElementAction := TResourceByVersionLoadAction.Create(Self);
  FLoadAction := TResourceVersionLoadAction.Create(Self);
  frmVersions.Prepare(Versions, 'ресурсы', TOldResource, FElementAction);
  frmVersions.OnAddSubElement := AddResource;
  frmVersions.OnDeleteSubElement :=  DeleteResource;
  frmVersions.OnAddVersion := AddVersion;
  frmVersions.OnDeleteVersion := DeleteVersion;
  frmVersions.OnViewChanged := ViewChange;
  frmVersions.OnSaveCurrentChecked := SaveCurrentChecked;
  frmVersions.OnSaveVersion := OnSaveVersion;  
  frmVersions.OnUndo := MakeUndo;
  frmVersions.OnClear := MakeClear;


  cmplxFluidType.Caption := 'Тип флюида';
  cmplxFluidType.FullLoad := true;
  cmplxFluidType.DictName := 'TBL_FLUID_TYPE_DICT';


  cmplxResourceType.Caption := 'Тип ресурсов';
  cmplxResourceType.FullLoad := true;
  cmplxResourceType.DictName := 'TBL_RESOURSE_TYPE_DICT';


  cmplxResourceCategory.Caption := 'Категория ресурсов';
  cmplxResourceCategory.FullLoad := true;
  cmplxResourceCategory.DictName := 'TBL_RESOURCES_CATEGORY_DICT';

  tshResourceEditor.TabVisible := false;
end;

procedure TfrmResources.FillControls(ABaseObject: TBaseObject);
var actn: TResourceVersionLoadAction;
    Node: TTreeNode;
begin
  FTempObject := ABaseObject;

  FVersions.Free;
  FVersions := nil;



  actn := TResourceVersionLoadAction.Create(Self);
  if Assigned(Layer) then
    actn.Execute(Layer)
  else actn.Execute(ABaseObject);
  actn.Free;

  frmVersions.Versions := FVersions;

  if frmVersions.trw.Items.Count > 0 then
    frmVersions.trw.Selected := frmVersions.trw.Items[0];

  Node := frmVersions.trw.Items.GetFirstNode;
  if Assigned(Node) then
    Node.Expand(true);
end;

procedure TfrmResources.FillParentControls;
begin
end;

function TfrmResources.GetBed: TOldBed;
begin
  Result := nil;
  if EditingObject is TOldBed then
    Result := EditingObject as TOldBed
  else
  if EditingObject is TOldLayer then
    Result := (EditingObject as TOldLayer).Bed;
end;

function TfrmResources.GetLayer: TOldLayer;
begin
  Result := nil;
  if EditingObject is TOldLayer then
    Result := EditingObject as TOldLayer;
end;

function TfrmResources.GetSubstructure: TOldSubstructure;
begin
  Result := nil;
  if EditingObject is TOldSubstructure then
    Result := EditingObject as TOldSubstructure
  else
  if EditingObject is TOldLayer then
    Result := (EditingObject as TOldLayer).Substructure;
end;

function TfrmResources.GetVersions: TOldAccountVersions;
begin
  if not Assigned(FVersions) then 
  begin
    FVersions := TOldAccountVersions.Create(nil);

    if Assigned(Layer) then
    begin
      FVersions.Assign(Layer.Versions);
      // копируем владельца, а то запросы самих ресурсов неудобно делать
      FVersions.Owner := Layer;
    end
    else
    if Assigned(FTempObject) then
    begin
      FVersions.Assign((FTempObject as TOldLayer).Versions);
      // копируем владельца, а то запросы самих ресурсов неудобно делать
      FVersions.Owner := FTempObject;
    end
    else FVersions.Owner := FCreatedObject;
  end;
  Result := FVersions;
end;

procedure TfrmResources.Save;
var i: integer;
    actn: TBaseAction;
begin
  inherited;
  if Assigned(FVersions) then
  begin
    actn := TResourceByVersionLoadAction.Create(Self);
    for i := 0 to FVersions.Count - 1 do
    begin
      if FVersions.Items[i].Resources.NeedsUpdate then
        actn.Execute(FVersions.Items[i]);
      // копируем только ресурсы
      FVersions.Items[i].Resources.CopyCollection := true;
      FVersions.Items[i].Reserves.CopyCollection := false;
      FVersions.Items[i].Parameters.CopyCollection := false;
    end;
    
    actn.Free;

    if not Assigned(EditingObject) then
      // если что берем объект из предыдущего фрэйма
      FEditingObject := ((Owner as TDialogFrame).Frames[0] as TBaseFrame).EditingObject;

    Layer.Versions.ResourcesClear;
    Layer.Versions.AddItems(FVersions);
  end;
end;

procedure TfrmResources.SetResource(const Value: TOldResource);
begin
//  if FResource <> Value then
  begin
    FResource := Value;
    if Assigned(FResource) then
    begin
      cmplxResourceType.AddItem(FResource.ResourceTypeID, FResource.ResourceType);
      cmplxResourceCategory.AddItem(FResource.ResourceCategoryID, FResource.ResourceCategory);
      cmplxFluidType.AddItem(FResource.FluidTypeID, FResource.FluidType);
      edtValue.Text := trim(Format('%7.3f', [FResource.Value]));
    end
    else ClearOnlyControls;
  end;
end;



procedure TfrmResources.SaveResource;
begin
  if Assigned(Resource) then
  begin
    Resource.FluidTypeID := cmplxFluidType.SelectedElementID;
    Resource.FluidType := cmplxFluidType.SelectedElementName;

    Resource.ResourceTypeID := cmplxResourceType.SelectedElementID;
    Resource.ResourceType := cmplxResourceType.SelectedElementName;

    Resource.ResourceCategoryID := cmplxResourceCategory.SelectedElementID;
    Resource.ResourceCategory := cmplxResourceCategory.SelectedElementName;

    try
      Resource.Value := StrToFloat(edtValue.Text);
    except
      Resource.Value := 0;
    end;

    if TBaseObject(frmVersions.trw.Selected.Data) is TOldResource then
      frmVersions.trw.Selected.Text := Resource.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false);
  end;
end;

{ TResourceVersionLoadAction }

function TResourceVersionLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var node: TTreeNode;
    i: integer;
begin
  LastCollection := (ABaseObject as TOldLayer).Versions;
  if LastCollection.NeedsUpdate then
    Result := inherited Execute(ABaseObject)
  else Result := true;

  if Result then
  begin
    // загружаем в интерфейс
    if Assigned(LastCollection) then
    with Owner as TfrmResources do
    begin
      // получаем версии на форму
      Versions;

      frmVersions.trw.Items.BeginUpdate;
      frmVersions.trw.Selected := nil;
      // чистим

      try
        frmVersions.trw.Items.Clear;
      except

      end;


      // добавляем в дерево не реальные версии
      // а их копии, чтобы потом сохранять изменения
      for i := 0 to Versions.Count - 1 do
      if (((frmVersions.cmbxView.ItemIndex = 0) and Versions.Items[i].ContainsResources)
      or  (frmVersions.cmbxView.ItemIndex = 1)) then
      begin
        Node := frmVersions.trw.Items.AddObject(nil, Versions.Items[i].List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), Versions.Items[i]);
        Node.SelectedIndex := 10;
        frmVersions.trw.Items.AddChild(Node, 'будут ресурсы');
      end;

      frmVersions.trw.Items.EndUpdate;
    end;
  end;
end;



{ TResourceByVersionLoadAction }


function TResourceByVersionLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var ParentNode, Node: TTreeNode;
    i: integer;
begin
  LastCollection := (ABaseObject as TOldAccountVersion).Resources;
  if LastCollection.NeedsUpdate then
    Result := inherited Execute(ABaseObject)
  else Result := true;

  if Result then
  begin
    // загружаем в интерфейс
    if Assigned(LastCollection) then
    with Owner as TfrmResources do
    begin
      frmVersions.trw.Items.BeginUpdate;

      // чистим
      if Assigned(frmVersions.trw.Selected) then
      begin
        if (TBaseObject(frmVersions.trw.Selected.Data) is TOldAccountVersion) then
           ParentNode := frmVersions.trw.Selected
        else
           ParentNode := frmVersions.trw.Selected.Parent;


        Node := ParentNode.getFirstChild;
        while Assigned(Node) do
        begin
          Node.Delete;
          Node := ParentNode.getFirstChild;
        end;

        // добавляем
        (ABaseObject as TOldAccountVersion).ContainsResources := LastCollection.Count > 0;
        for i := 0 to LastCollection.Count - 1 do
        begin
          Node := frmVersions.trw.Items.AddChildObject(ParentNode, LastCollection.Items[i].List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), LastCollection.Items[i]);
          Node.SelectedIndex  := 11;
        end;
      end;

      frmVersions.trw.Items.EndUpdate;
    end;
  end;
end;

procedure TfrmResources.trwResourcesChange(Sender: TObject;
  Node: TTreeNode);
begin
  if Assigned(Node) then
  begin
    if TBaseObject(Node.data) is TOldAccountVersion then
    begin
      tshResourceEditor.TabVisible := false;
    end
    else
    if TBaseObject(Node.data) is TOldResource then
    begin
      Resource := TBaseObject(Node.data) as TOldResource;
      tshResourceEditor.TabVisible := true;
    end;
  end;
end;

procedure TfrmResources.ClearOnlyControls;
begin

  cmplxFluidType.Clear;
  cmplxResourceType.Clear;
  cmplxResourceCategory.Clear;
  edtValue.Clear;

end;

procedure TfrmResources.cmplxFluidTypecmbxNameChange(Sender: TObject);
begin
  cmplxFluidType.cmbxNameChange(Sender);
  if frmVersions.SaveCurrent.Checked then SaveResource;
end;

procedure TfrmResources.cmplxResourceCategorycmbxNameChange(
  Sender: TObject);
begin
  cmplxResourceCategory.cmbxNameChange(Sender);
  if frmVersions.SaveCurrent.Checked then SaveResource;
end;

procedure TfrmResources.cmplxResourceTypecmbxNameChange(Sender: TObject);
begin
  cmplxResourceType.cmbxNameChange(Sender);
  if frmVersions.SaveCurrent.Checked then SaveResource;
end;

procedure TfrmResources.edtValueChange(Sender: TObject);
begin
  if frmVersions.SaveCurrent.Checked then SaveResource;
end;

procedure TfrmResources.trwResourcesChanging(Sender: TObject;
  Node: TTreeNode; var AllowChange: Boolean);
begin
  if Assigned(frmVersions.trw.Selected) then
  begin
    if frmVersions.trw.Selected.Level = 1 then
      AllowChange := Inspector.Check
  end;
end;

procedure TfrmResources.RegisterInspector;
begin
  inherited;
end;

procedure TfrmResources.LocalRegisterInspector;
begin
  Inspector.Clear;

  cmplxFluidType.cmbxName.OnChange := cmplxFluidTypecmbxNameChange;
  cmplxResourceType.cmbxName.OnChange := cmplxResourceTypecmbxNameChange;
  cmplxResourceCategory.cmbxName.OnChange := cmplxResourceCategorycmbxNameChange;
  edtValue.OnChange := edtValueChange;

  Inspector.Add(cmplxFluidType.cmbxName, nil, ptString, 'тип флюида', false);
  Inspector.Add(cmplxResourceType.cmbxName, nil, ptString, 'тип ресурсов', false);
  Inspector.Add(cmplxResourceCategory.cmbxName, nil, ptString, 'категория ресурсов', false);
  Inspector.Add(edtValue, nil, ptFloat, 'высота залежи', false);
end;


procedure TfrmResources.frmVersioncmbxDocNameChange(Sender: TObject);
begin
  if Assigned(frmVersions.trw.Selected) and (TObject(frmVersions.trw.Selected.Data) is TOldAccountVersion) then
    frmVersions.trw.Selected.Text := TOldAccountVersion(frmVersions.trw.Selected.Data).List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false)
end;

procedure TfrmResources.OnChangeVersion(Sender: TObject);
var v: TOldAccountVersion;
    Node: TTreeNode;
    i: integer;
begin
  v := Versions.Items[Versions.Count - 1];

  Node := frmVersions.trw.Items.AddObject(nil, v.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), v);
  Node.SelectedIndex := 10;
  frmVersions.trw.Items.AddChild(Node, 'будут ресурсы');

  v.Resources.NeedsUpdate := false;

  i := frmVersions.FindObject(v);
  if i > -1 then
    frmVersions.trw.Items[i].Selected := true;
end;

procedure TfrmResources.AddVersion(Sender: TObject);
var i: integer;
begin
  frmVersions.Version.Resources.NeedsUpdate := false;

  i := frmVersions.FindObject(frmVersions.Version);
  if i > -1 then
    frmVersions.trw.Items[i].Selected := true;
end;

procedure TfrmResources.DeleteVersion(Sender: TObject);
begin
end;

procedure TfrmResources.AddResource(Sender: TObject);
var r: TOldResource;
    Node, NewNode: TTreeNode;
    i: integer; 
begin
  r := frmVersions.Version.Resources.Add;
  if (TBaseObject(frmVersions.trw.Selected.Data) is TOldAccountVersion) then
    Node := frmVersions.trw.Selected
  else
    Node := frmVersions.trw.Selected.Parent;


  NewNode := frmVersions.trw.Items.AddChildObject(Node, r.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), r);
  NewNode.SelectedIndex := 11;
  Node.Expand(true);
  LocalRegisterInspector;
  Resource := r;

  i := frmVersions.FindObject(Resource);
  if i > -1 then
    frmVersions.trw.Items[i].Selected := true;
end;

procedure TfrmResources.DeleteResource(Sender: TObject);
begin
  frmVersions.Version.Resources.Remove(TBaseObject(frmVersions.trw.Selected.Data));
  frmVersions.trw.Selected.Delete;
  Resource := nil;
  frmVersions.trw.Selected := nil;
  UnCheck;
end;

procedure TfrmResources.MakeClear(Sender: TObject);
begin
  ClearOnlyControls;
end;

procedure TfrmResources.MakeUndo(Sender: TObject);
begin
  with pgctl do
  case ActivePageIndex of
  0:
  begin
    Resource := nil;
    Resource := TOldResource(frmVersions.trw.Selected.Data);
  end;
  end;
end;

procedure TfrmResources.SaveCurrentChecked(Sender: TObject);
begin
  SaveResource;
end;

procedure TfrmResources.ViewChange(Sender: TObject);
begin
  Resource := nil;
  FLoadAction.Execute(Layer);
end;

procedure TfrmResources.OnSaveVersion(Sender: TObject);
begin
end;

destructor TfrmResources.Destroy;
begin
  FCreatedCollection.Free;
  inherited;
end;

end.
