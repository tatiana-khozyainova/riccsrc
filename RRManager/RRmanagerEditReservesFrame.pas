unit RRManagerEditReservesFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RRManagerBaseObjects, ComCtrls, ToolWin, StdCtrls, ActnList, ImgList,
  Mask, ToolEdit, CommonComplexCombo, ExtCtrls, RRManagerObjects,
  ClientCommon, RRManagerEditVersionFrame, RRManagerBaseGUI,
  RRManagerVersionsFrame, Contnrs;

type
//  TfrmReserves = class(TFrame)
  TfrmReserves = class(TBaseFrame)
    gbxProperties: TGroupBox;
    pgctl: TPageControl;
    tshReserveEditor: TTabSheet;
    cmplxFluidType: TfrmComplexCombo;
    cmplxReserveKind: TfrmComplexCombo;
    cmplxReserveCategory: TfrmComplexCombo;
    edtValue: TEdit;
    Label4: TLabel;
    Bevel1: TBevel;
    frmVersions: TfrmVersions;
    Splitter1: TSplitter;
    cmplxResourceType: TfrmComplexCombo;
    btnSave: TButton;
    Label1: TLabel;
    cmplxReservesValueType: TfrmComplexCombo;
    Label2: TLabel;
    cmbxLicenseZone: TComboBox;
    lblOrganization: TLabel;
    procedure trwReservesChange(Sender: TObject; Node: TTreeNode);
    procedure cmplxFluidTypecmbxNameChange(Sender: TObject);
    procedure cmplxReserveCategorycmbxNameChange(Sender: TObject);
    procedure cmplxReserveTypecmbxNameChange(Sender: TObject);
    procedure edtValueChange(Sender: TObject);
    procedure trwReservesChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure frmVersioncmbxDocNameChange(Sender: TObject);
    procedure cmplxFluidTypecmbxNameSelect(Sender: TObject);
    procedure cmplxReserveCategorycmbxNameSelect(Sender: TObject);
    procedure cmplxReserveKindcmbxNameSelect(Sender: TObject);
    procedure cmplxResourceTypecmbxNameSelect(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure frmVersionstlbtnAddVersionClick(Sender: TObject);
    procedure frmVersionsAddVersionExecute(Sender: TObject);
    procedure frmVersionstlbtnAddReserveClick(Sender: TObject);
    procedure cmplxReservesValueTypecmbxNameChange(Sender: TObject);
    procedure cmplxResourceTypecmbxNameChange(Sender: TObject);
    procedure cmplxReservesValueTypecmbxNameSelect(Sender: TObject);
    procedure frmVersionstlbtnDeleteReserveClick(Sender: TObject);
    procedure cmbxLicenseZoneChange(Sender: TObject);
  private
    { Private declarations }
    FVersions: TOldAccountVersions;
    FReserve: TOldReserve;
    FTempObject: TbaseObject;
    FCreatedCollection: TBaseCollection;
    FCreatedObject: TBaseObject;
    FLoadAction, FElementAction: TBaseAction;
    function GetBed: TOldBed;
    function GetLayer: TOldLayer;
    function GetSubstructure: TOldSubstructure;
    function GetVersions: TOldAccountVersions;
    procedure SetReserve(const Value: TOldReserve);
    procedure SaveReserve;
    procedure ClearOnlyControls;
    procedure OnChangeVersion(Sender: TObject);
    procedure OnSaveVersion(Sender: TObject);
    procedure AddVersion(Sender: TObject);
    procedure DeleteVersion(Sender: TObject);
    procedure AddReserve(Sender: TObject);
    procedure DeleteReserve(Sender: TObject);
    procedure SaveCurrentChecked(Sender: TObject);
    procedure MakeClear(Sender: TObject);
    procedure MakeUndo(Sender: TObject);
    procedure ViewChange(Sender: TObject);
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
    property Reserve: TOldReserve read FReserve write SetReserve;
    function Check: boolean; override;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   Save; override;
  end;

implementation



{$R *.DFM}

uses RRManagerLoaderCommands, LicenseZone;

type
  TFakeObject = class
  private
    FID: integer;
  public
    property ID: integer read FID;
    constructor Create(AID: integer);
  end;

  TReserveVersionLoadAction = class(TVersionBaseLoadAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
  end;

  TReserveByVersionLoadAction = class(TReserveByVersionBaseLoadAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
  end;


{ TfrmResourceReserves }

procedure TfrmReserves.ClearControls;
begin
  FVersions.Free;
  FVersions := nil;
  FReserve := nil;
  ClearOnlyControls;
end;

constructor TfrmReserves.Create(AOwner: TComponent);
begin
  inherited;
  NeedCopyState := false;
  FCreatedCollection := TBaseCollection.Create(TBaseObject);
  FCreatedObject := FCreatedCollection.Add;


  FElementAction := TReserveByVersionLoadAction.Create(Self);
  FLoadAction := TReserveVersionLoadAction.Create(Self);
  frmVersions.Prepare(Versions, 'запасы', TOldReserve, FElementAction);
  frmVersions.OnAddSubElement := AddReserve;
  frmVersions.OnDeleteSubElement :=  DeleteReserve;
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


  cmplxReserveKind.Caption := 'Вид запасов';
  cmplxReserveKind.FullLoad := true;
  cmplxReserveKind.DictName := 'TBL_RESERVES_KIND_DICT';


  cmplxReserveCategory.Caption := 'Категория запасов';
  cmplxReserveCategory.FullLoad := true;
  cmplxReserveCategory.DictName := 'TBL_RESOURCES_CATEGORY_DICT';

  cmplxResourceType.Caption := 'Тип запасов';
  cmplxResourceType.FullLoad := true;
  cmplxResourceType.DictName := 'TBL_RESOURSE_TYPE_DICT';


  cmplxReservesValueType.Caption := 'Запасы или тип изменения балансовых запасов';
  cmplxReservesValueType.FullLoad := true;
  cmplxReservesValueType.DictName := 'TBL_RESERVES_VALUE_TYPE';




  tshReserveEditor.TabVisible := false;

end;

procedure TfrmReserves.FillControls(ABaseObject: TBaseObject);
var actn: TReserveVersionLoadAction;
    Node: TTreeNode;
begin
  FTempObject := ABaseObject;

  FVersions.Free;
  FVersions := nil;

  actn := TReserveVersionLoadAction.Create(Self);

  if Assigned(Bed) then
  begin
    cmbxLicenseZone.Clear;
    cmbxLicenseZone.AddItem('<в целом по объекту(структуре/месторождению/продуктивному пласту/залежи)>', nil);
    Bed.Field.LicenseZones.MakeList(cmbxLicenseZone.Items, true, false);
    cmbxLicenseZone.ItemIndex := 0;
    actn.Execute(Bed);
  end
  else
  begin
    actn.Execute(ABaseObject);
  end;

  frmVersions.Versions := FVersions;

  actn.Free;
  if frmVersions.trw.Items.Count > 0 then
    frmVersions.trw.Selected := frmVersions.trw.Items[0];


  Node := frmVersions.trw.Items.GetFirstNode;
  if Assigned(Node) then
    Node.Expand(true);


end;

procedure TfrmReserves.FillParentControls;
begin
end;

function TfrmReserves.GetBed: TOldBed;
begin
  Result := nil;
  if EditingObject is TOldBed then
    Result := EditingObject as TOldBed
  else
  if EditingObject is TOldLayer then
    Result := (EditingObject as TOldLayer).Bed;
end;

function TfrmReserves.GetLayer: TOldLayer;
begin
  Result := nil;
  if EditingObject is TOldLayer then
    Result := EditingObject as TOldLayer;
end;

function TfrmReserves.GetSubstructure: TOldSubstructure;
begin
  Result := nil;
  if EditingObject is TOldSubstructure then
    Result := EditingObject as TOldSubstructure
  else
  if EditingObject is TOldLayer then
    Result := (EditingObject as TOldLayer).Substructure;
end;

function TfrmReserves.GetVersions: TOldAccountVersions;
begin
  Result := nil;
  if Assigned(FVersions) then Result := FVersions
  else
  if Assigned(Layer) then
  begin
    FVersions := TOldAccountVersions.Create(nil);
    FVersions.Assign(Layer.Versions);
    Result := FVersions;
    // копируем владельца, а то запросы самих ресурсов неудобно делать
    FVersions.Owner := Layer;
  end
  else if Assigned(Bed) then
  begin
    FVersions := TOldAccountVersions.Create(nil);
    FVersions.Assign(Bed.Versions);
    Result := FVersions;
    // копируем владельца, а то запросы самих ресурсов неудобно делать
    FVersions.Owner := Bed;
  end
  else
  if Assigned(FTempObject) then
  begin
    FVersions := TOldAccountVersions.Create(nil);
    if FTempObject is TOldLayer then
      FVersions.Assign((FTempObject as TOldLayer).Versions)
    else if FTempObject is TOldBed then
      FVersions.Assign((FTempObject as TOldBed).Versions);
    Result := FVersions;
    // копируем владельца, а то запросы самих ресурсов неудобно делать
    FVersions.Owner := FTempObject;
  end
  else
  begin
    FVersions := TOldAccountVersions.Create(nil);
    FVersions.Owner := FCreatedObject;
    Result := FVersions;    
  end
end;

procedure TfrmReserves.Save;
var i: integer;
    actn: TBaseAction;
begin
  inherited;
  if Assigned(FVersions) then
  begin
    actn := TReserveByVersionLoadAction.Create(Self);
    for i := 0 to FVersions.Count - 1 do
    begin
      if FVersions.Items[i].Reserves.NeedsUpdate then
        actn.Execute(FVersions.Items[i]);
      // копируем отсюда только запасы
      FVersions.Items[i].Resources.CopyCollection := false;
      FVersions.Items[i].Reserves.CopyCollection := true;
      FVersions.Items[i].Parameters.CopyCollection := false;
    end;

    actn.Free;

    if Assigned(Layer) then
    begin
      Layer.Versions.ReservesClear;
      Layer.Versions.AddItems(Versions);
    end
    else
    begin
      Bed.Versions.ReservesClear;
      Bed.Versions.AddItems(Versions);
    end;
  end;
end;

procedure TfrmReserves.SetReserve(const Value: TOldReserve);
begin
  FReserve := Value;
  if Assigned(FReserve) then
  begin
    if FReserve.ReserveKindID > 0 then
      cmplxReserveKind.AddItem(FReserve.ReserveKindID, FReserve.ReserveKind);

    if FReserve.ReserveCategoryID > 0 then
      cmplxReserveCategory.AddItem(FReserve.ReserveCategoryID, FReserve.ReserveCategory);

    if FReserve.FluidTypeID > 0 then
      cmplxFluidType.AddItem(FReserve.FluidTypeID, FReserve.FluidType);

    if FReserve.ReserveTypeID > 0 then
      cmplxResourceType.AddItem(FReserve.ReserveTypeID, FReserve.ReserveType);

    if FReserve.ReserveValueTypeID > 0 then
      cmplxReservesValueType.AddItem(FReserve.ReserveValueTypeID, FReserve.ReserveValueTypeName);

    if Assigned(FReserve.LicenseZone) then
      cmbxLicenseZone.ItemIndex := cmbxLicenseZone.Items.IndexOfObject(FReserve.LicenseZone);
      
    edtValue.Text := trim(Format('%7.3f', [FReserve.Value]));
  end
  else ClearOnlyControls;
end;


procedure TfrmReserves.SaveReserve;
begin
  if Assigned(Reserve) then
  begin
    Reserve.FluidTypeID := cmplxFluidType.SelectedElementID;
    Reserve.FluidType := cmplxFluidType.SelectedElementName;

    Reserve.ReserveKindID := cmplxReserveKind.SelectedElementID;
    Reserve.ReserveKind := cmplxReserveKind.SelectedElementName;

    Reserve.ReserveCategoryID := cmplxReserveCategory.SelectedElementID;
    Reserve.ReserveCategory := cmplxReserveCategory.SelectedElementName;

    Reserve.ReserveTypeID := cmplxResourceType.SelectedElementID;
    Reserve.ReserveType := cmplxResourceType.SelectedElementName;

    Reserve.ReserveValueTypeID := cmplxReservesValueType.SelectedElementID;
    Reserve.ReserveValueTypeName := cmplxReservesValueType.SelectedElementName;

    if cmbxLicenseZone.ItemIndex > -1 then
      Reserve.LicenseZone := TLicenseZone(cmbxLicenseZone.Items.Objects[cmbxLicenseZone.ItemIndex])
    else
      Reserve.LicenseZone := nil;


    try
      Reserve.Value := StrToFloat(edtValue.Text);
    except
      Reserve.Value := 0;
    end;

    if TBaseObject(frmVersions.trw.Selected.Data) is TOldReserve then
      frmVersions.trw.Selected.Text := Reserve.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false);

  end;
end;

{ TResourceVersionLoadAction }

function TReserveVersionLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var node: TTreeNode;
    i: integer;
begin
  if ABaseObject is TOldLayer then
    LastCollection := (ABaseObject as TOldLayer).Versions
  else if ABaseObject is TOldBed then
    LastCollection := (ABaseObject as TOldBed).Versions;

  if LastCollection.NeedsUpdate then
    Result := inherited Execute(ABaseObject)
  else Result := true;

  if Result then
  begin
    // загружаем в интерфейс
    if Assigned(LastCollection) then
    with Owner as TfrmReserves do
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
      begin
        if (((frmVersions.cmbxView.ItemIndex = 0) and Versions.Items[i].ContainsReserves)
        or  (frmVersions.cmbxView.ItemIndex = 1)) then
        begin
          // загружаем только те в которых есть запасы
          Node := frmVersions.trw.Items.AddObject(nil, Versions.Items[i].List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), Versions.Items[i]);
          Node.SelectedIndex := 10;
          frmVersions.trw.Items.AddChild(Node, 'будут запасы');
        end;
      end;

      frmVersions.trw.Items.EndUpdate;
    end;
  end;
end;



{ TResourceByVersionLoadAction }


function TReserveByVersionLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var ParentNode, Node: TTreeNode;
    i: integer;
    r: TOldReserve;
    NodeList: TObjectList;
begin
  NodeList := TObjectList.Create(false);
  NodeList.Count := 10;
  
  LastCollection := (ABaseObject as TOldAccountVersion).Reserves;
  if LastCollection.NeedsUpdate then
    Result := inherited Execute(ABaseObject)
  else Result := true;

  if Result then
  begin
    // загружаем в интерфейс
    if Assigned(LastCollection) then
    with Owner as TfrmReserves do
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

        (ABaseObject as TOldAccountVersion).ContainsReserves := LastCollection.Count > 0;

        // добавляем
        for i := 0 to LastCollection.Count - 1 do
        begin
          r := LastCollection.Items[i] as TOldReserve;
          if not Assigned(NodeList.Items[r.ReserveValueTypeID]) then NodeList.Items[r.ReserveValueTypeID] := frmVersions.trw.Items.AddChildObject(ParentNode, r.ReserveValueTypeName, TFakeObject.Create(r.ReserveValueTypeID));


          Node := frmVersions.trw.Items.AddChildObject(NodeList.Items[r.ReserveValueTypeID] as TTreeNode, r.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), r);
          Node.SelectedIndex  := 11;
        end;
      end;

      frmVersions.trw.Items.EndUpdate;
    end;
  end;

  NodeList.Free;
end;

procedure TfrmReserves.trwReservesChange(Sender: TObject;
  Node: TTreeNode);
begin
  if Assigned(Node) then
  begin
    if TBaseObject(Node.data) is TOldAccountVersion then
    begin
      tshReserveEditor.TabVisible := false;
    end
    else
    if TBaseObject(Node.data) is TOldReserve then
    begin
      Reserve := TBaseObject(Node.data) as TOldReserve;
      tshReserveEditor.TabVisible := true;
    end;
  end;
end;

procedure TfrmReserves.cmplxFluidTypecmbxNameChange(Sender: TObject);
begin
  cmplxFluidType.cmbxNameChange(Sender);
  if frmVersions.SaveCurrent.Checked then SaveReserve;
end;

procedure TfrmReserves.cmplxReserveCategorycmbxNameChange(Sender: TObject);
begin
  cmplxReserveCategory.cmbxNameChange(Sender);
  if frmVersions.SaveCurrent.Checked then SaveReserve;
end;

procedure TfrmReserves.cmplxReserveTypecmbxNameChange(Sender: TObject);
begin
  cmplxReserveKind.cmbxNameChange(Sender);
  if frmVersions.SaveCurrent.Checked then SaveReserve;
end;

procedure TfrmReserves.edtValueChange(Sender: TObject);
begin
  if frmVersions.SaveCurrent.Checked then SaveReserve;
end;

procedure TfrmReserves.ClearOnlyControls;
begin
  cmplxFluidType.Clear;
  cmplxReserveKind.Clear;
  cmplxReserveCategory.Clear;
  edtValue.Clear;

end;

procedure TfrmReserves.trwReservesChanging(Sender: TObject;
  Node: TTreeNode; var AllowChange: Boolean);
begin
  if Assigned(frmVersions.trw.Selected) then
  begin
    if frmVersions.trw.Selected.Level = 2 then
      AllowChange := Inspector.Check
  end;
end;

procedure TfrmReserves.RegisterInspector;
begin
  inherited;
end;

procedure TfrmReserves.LocalRegisterInspector;
begin
  Inspector.Clear;
  // возвращаем исходное состояние
  // здесь не так как на других фрэймах
  // инспектор регистрится при добавлении нового параметра
  cmplxReserveKind.cmbxName.OnChange := cmplxReserveTypecmbxNameChange;
  cmplxReserveCategory.cmbxName.OnChange := cmplxReserveCategorycmbxNameChange;
  cmplxFluidType.cmbxName.OnChange := cmplxFluidTypecmbxNameChange;
  edtValue.OnChange := edtValueChange;

  Inspector.Add(cmplxFluidType.cmbxName, nil, ptString, 'тип флюида', false);
  Inspector.Add(cmplxReserveKind.cmbxName, nil, ptString, 'вид запасов', false);
  Inspector.Add(cmplxReserveCategory.cmbxName, nil, ptString, 'категория запасов', false);
  Inspector.Add(cmplxResourceType.cmbxName, nil, ptString, 'тип запасов', false);  
  Inspector.Add(edtValue, nil, ptFloat, 'значение', false);
end;

procedure TfrmReserves.frmVersioncmbxDocNameChange(Sender: TObject);
begin
  if Assigned(frmVersions.trw.Selected) and (TObject(frmVersions.trw.Selected.Data) is TOldAccountVersion) then
    frmVersions.trw.Selected.Text := TOldAccountVersion(frmVersions.trw.Selected.Data).List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false)
end;


procedure TfrmReserves.OnChangeVersion(Sender: TObject);
var v: TOldAccountVersion;
    Node: TTreeNode;
    i: integer;
begin
  v := Versions.Items[Versions.Count - 1];

  Node := frmVersions.trw.Items.AddObject(nil, v.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), v);
  Node.SelectedIndex := 10;
  frmVersions.trw.Items.AddChild(Node, 'будут запасы');

  v.Reserves.NeedsUpdate := false;

  i := frmVersions.FindObject(v);
  if i > -1 then
    frmVersions.trw.Items[i].Selected := true;
end;

procedure TfrmReserves.AddVersion(Sender: TObject);
var i: integer;
begin
  frmVersions.Version.Reserves.NeedsUpdate := false;

  i := frmVersions.FindObject(frmVersions.Version);
  if i > -1 then
    frmVersions.trw.Items[i].Selected := true;
end;

procedure TfrmReserves.DeleteVersion(Sender: TObject);
begin
end;

procedure TfrmReserves.AddReserve(Sender: TObject);
var r: TOldReserve;
    Node: TTreeNode;
    i: integer;
begin
  r := frmVersions.Version.Reserves.Add;


  if (TBaseObject(frmVersions.trw.Selected.Data) is TOldAccountVersion) then
    Node := frmVersions.trw.Selected
  else if (TBaseObject(frmVersions.trw.Selected.Data) is TOldReserve) then
    Node := frmVersions.trw.Selected.Parent
  else
  begin
    Node := frmVersions.trw.Selected.Parent;
    r.ReserveValueTypeID := TFakeObject(frmVersions.trw.Selected.Data).ID;     
  end;



  frmVersions.trw.Items.AddChildObject(Node, r.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), r).SelectedIndex := 11;
  Node.Expand(true);
  LocalRegisterInspector;
  Reserve := r;

  i := frmVersions.FindObject(Reserve);
  if i > -1 then
    frmVersions.trw.Items[i].Selected := true;
end;

procedure TfrmReserves.DeleteReserve(Sender: TObject);
var Node: TTreeNode;
begin
  Node := frmVersions.trw.Selected.Parent;
  
  frmVersions.Version.Reserves.Remove(TBaseObject(frmVersions.trw.Selected.Data));
  frmVersions.trw.Selected.Delete;
  Reserve := nil;
  frmVersions.trw.Selected := nil;
  if not Node.HasChildren then Node.Delete;
  UnCheck;
end;

procedure TfrmReserves.MakeClear(Sender: TObject);
begin
  ClearOnlyControls;
end;

procedure TfrmReserves.MakeUndo(Sender: TObject);
begin
  with pgctl do
  case ActivePageIndex of
  0:
  begin
    Reserve := nil;
    Reserve := TOldReserve(frmVersions.trw.Selected.Data);
  end;
  end;
end;

procedure TfrmReserves.SaveCurrentChecked(Sender: TObject);
begin
  SaveReserve;
end;

procedure TfrmReserves.ViewChange(Sender: TObject);
begin
  Reserve := nil;
  FLoadAction.Execute(Layer);
end;

procedure TfrmReserves.OnSaveVersion(Sender: TObject);
begin
end;

destructor TfrmReserves.Destroy;
begin
  FCreatedCollection.Free;
  inherited;
end;

procedure TfrmReserves.cmplxFluidTypecmbxNameSelect(Sender: TObject);
begin
  cmplxFluidType.cmbxNameSelect(Sender);
  if frmVersions.SaveCurrent.Checked then SaveReserve;
end;

procedure TfrmReserves.cmplxReserveCategorycmbxNameSelect(Sender: TObject);
begin
  cmplxReserveCategory.cmbxNameSelect(Sender);
  if frmVersions.SaveCurrent.Checked then SaveReserve;
end;

procedure TfrmReserves.cmplxReserveKindcmbxNameSelect(Sender: TObject);
begin
  cmplxReserveKind.cmbxNameSelect(Sender);
  if frmVersions.SaveCurrent.Checked then SaveReserve;
end;

procedure TfrmReserves.cmplxResourceTypecmbxNameSelect(Sender: TObject);
begin
  cmplxResourceType.cmbxNameSelect(Sender);
  if frmVersions.SaveCurrent.Checked then SaveReserve;
end;

procedure TfrmReserves.btnSaveClick(Sender: TObject);
begin
  SaveReserve;
end;

function TfrmReserves.Check: boolean;
var i: integer;
begin
  Result := inherited Check;

  if pgctl.Visible then
  for i := 0 to Versions.Count - 1 do
    Result := Result and Versions.Items[i].Reserves.Check;
end;

{ TFakeObject }

constructor TFakeObject.Create(AID: integer);
begin
  inherited Create;
  FID := AID;
end;

procedure TfrmReserves.frmVersionstlbtnAddVersionClick(Sender: TObject);
begin
  frmVersions.AddVersionExecute(Sender);

end;

procedure TfrmReserves.frmVersionsAddVersionExecute(Sender: TObject);
begin
  frmVersions.AddVersionExecute(Sender);

end;

procedure TfrmReserves.frmVersionstlbtnAddReserveClick(Sender: TObject);
begin
  frmVersions.AddSubElementExecute(Sender);

end;

procedure TfrmReserves.cmplxReservesValueTypecmbxNameChange(
  Sender: TObject);
begin
  cmplxReservesValueType.cmbxNameChange(Sender);
  frmVersions.trw.Selected.Parent.Expand(true);

end;

procedure TfrmReserves.cmplxResourceTypecmbxNameChange(Sender: TObject);
begin
  cmplxResourceType.cmbxNameChange(Sender);

end;

procedure TfrmReserves.cmplxReservesValueTypecmbxNameSelect(
  Sender: TObject);
var Node: TTreeNode;
    iIndex: integer;
begin
  cmplxReservesValueType.cmbxNameSelect(Sender);
  if frmVersions.SaveCurrent.Checked then SaveReserve;

  Node := frmVersions.trw.Selected;
  while Node.Level > 0 do
    Node := Node.Parent;

  Node.Expand(true);

  iIndex := frmVersions.FindObject(Reserve);
  if iIndex > -1 then
    frmVersions.trw.Items[iIndex].Selected := true;
end;

procedure TfrmReserves.frmVersionstlbtnDeleteReserveClick(Sender: TObject);
begin
  frmVersions.DeleteSubElementExecute(Sender);

end;

procedure TfrmReserves.cmbxLicenseZoneChange(Sender: TObject);
var lz: TSimpleLicenseZone;
begin
  SaveReserve;
  lz := nil;
  if cmbxLicenseZone.ItemIndex > -1 then
    lz := cmbxLicenseZone.Items.Objects[cmbxLicenseZone.ItemIndex] as TSimpleLicenseZone;

  if Assigned(lz) and Assigned(lz.OwnerOrganization) then
    lblOrganization.Caption := lz.OwnerOrganization.List
  else
    lblOrganization.Caption := '';
end;

end.
