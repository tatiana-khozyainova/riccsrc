unit RRManagerEditBedStructureFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, RRManagerMainTreeFrame, StdCtrls, ComCtrls, Buttons, RRManagerBaseObjects,
  RRManagerObjects, RRManagerLoaderCommands, ImgList, ClientCommon, RRManagerBaseGUI;

type
//  TfrmBedStructure = class(TFrame)
  TfrmBedStructure = class(TBaseFrame)
    gbxElements: TGroupBox;
    frmMainTree: TfrmMainTree;
    pnlButtons: TPanel;
    gbxUsedStructureElements: TGroupBox;
    lwBedStructure: TListView;
    sbtnLeft: TSpeedButton;
    sbtnRight: TSpeedButton;
    sbtnAllLeft: TSpeedButton;
    sbtnAllRight: TSpeedButton;
    procedure frmMainTreetrwMainDblClick(Sender: TObject);
    procedure lwBedStructureDblClick(Sender: TObject);
  private
    actnLoadLayer: TBaseAction;
    strs: TOldStructures;
    FBed: TOldBed;
    function GetBed: TOldBed;
    function GetField: TOldField;
    { Private declarations }
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
  public
    { Public declarations }
    property Bed: TOldBed read GetBed;
    property Field: TOldField read GetField;
    constructor Create(AOwner: TComponent); override;
    procedure   Save; override;
    destructor  Destroy; override;
  end;

implementation

{$R *.DFM}

type

  TBedHorizonLoadAction = class(TBedHorizonBaseLoadAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
  end;

  TBedHorizonSubstructureLoadAction = class(TBedHorizonSubstructureBaseLoadAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
  end;

  TBedLayerLoadAction = class(TBedLayerBaseLoadAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
  end;

  TRightClickAction = class(TbaseAction)
  public
    function Execute: boolean; override;
    function Update: boolean; override;
  end;

  TLeftClickAction = class(TbaseAction)
  public
    function Execute: boolean; override;
    function Update: boolean; override;
  end;

  TAllRightClickAction = class(TBaseAction)
  public
    function Execute: boolean; override;
    function Update: boolean; override;
  end;

  TAllLeftClickAction = class(TBaseAction)
  public
    function Execute: boolean; override;
    function Update: boolean; override;
  end;

{ TfrmBedStructure }

procedure TfrmBedStructure.ClearControls;
begin
  frmMainTree.ClearAction.Execute;
end;

constructor TfrmBedStructure.Create(AOwner: TComponent);
begin
  inherited;
  FBed := nil;
  strs := TOldStructures.Create(nil);
  actnLoadLayer := TBedLayerLoadAction.Create(Self);
  frmMainTree.Structures := strs;
  frmMainTree.MenuVisible := false;
  frmMainTree.ToolBarVisible := false;
  frmMainTree.UpperPanelVisible := false;

  sbtnLeft.Action := TLeftClickAction.Create(Self);
  sbtnAllLeft.Action := TAllLeftClickAction.Create(Self);
  sbtnRight.Action := TRightClickAction.Create(Self);
  sbtnAllRight.Action := TAllRightClickAction.Create(Self);
end;

destructor TfrmBedStructure.Destroy;
begin
  if Assigned(Fbed) then FBed.Free;
  FBed := nil;

  actnLoadLayer.Free;
  strs.Free;

  sbtnLeft.Action.Free;
  sbtnRight.Action.Free;
  sbtnAllLeft.Action.Free;
  sbtnAllRight.Action.Free;

  inherited;
end;

procedure TfrmBedStructure.FillControls(ABaseObject: TBaseObject);
var B: TOldBed;
    F: TOldField;
begin
  if not Assigned(ABaseObject) then
  if Assigned(Bed) then
  begin
    B := Bed;
    F := Field;
  end
  else
  begin
    if ABaseObject is TOldBed then
    begin
      B := ABaseObject as TOldBed;
      F := Field
    end
    else
    begin
      B := Bed;
      F := ABaseObject as TOldField;
    end
  end;

  // это чтобы дерево обновлялось каждый раз
  (frmMainTree.StructureLoadAction as TStructureBaseLoadAction).LastFilter := '';
  (frmMainTree.StructureLoadAction.ActionList as TMainTreeActionList).Filter := '';
  frmMainTree.StructureLoadAction.Execute(F);
  B.Layers.NeedsUpdate := true;
  actnLoadLayer.Execute(B);
end;

procedure TfrmBedStructure.FillParentControls;
begin
  frmMainTree.StructureLoadAction.Execute(Field);
end;

function TfrmBedStructure.GetBed: TOldBed;
begin
  if EditingObject is TOldBed then
  begin
    if Assigned(FBed) then
    begin
      if FBed.ID <> EditingObject.ID then
        FBed.Assign(EditingObject as TOldBed);
      Result := FBed
    end  
    else
    begin
      FBed := TOldBed.Create(nil);
      FBed.Assign(EditingObject as TOldBed);
      Result := FBed;
    end;
  end
  else Result := nil;
end;

function TfrmBedStructure.GetField: TOldField;
begin
  Result := nil;
  if EditingObject is TOldField then
    Result := EditingObject as TOldField
  else
  if EditingObject is TOldBed then
    Result := (EditingObject as TOldBed).Field;
end;

procedure TfrmBedStructure.Save;
begin
  inherited;
  (EditingObject as TOldBed).Layers.Assign(FBed.Layers);
end;

{ TBedHorizonLoadAction }

function TBedHorizonLoadAction.Execute(ABaseObject: TBaseObject): boolean;
var i: integer;
    li: TListItem;
begin
  Result := false;
  LastCollection := (ABaseObject as TOldBed).Horizons;
  if LastCollection.NeedsUpdate then
    Result := inherited Execute(ABaseObject);

  (Owner as TfrmBedStructure).lwBedStructure.Items.Clear;
  for i := 0 to LastCollection.Count - 1 do
  begin
    li := (Owner as TfrmBedStructure).lwBedStructure.Items.Add;
    li.Caption := LastCollection.Items[i].List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false);
    li.Data  := LastCollection.Items[i];
    li.ImageIndex := 5;
{    for j := 0 to (LastCollection.Items[i] as TOldHorizon).Substructures.Count - 1 do
    begin
      S := (LastCollection.Items[i] as TOldHorizon).Substructures.Items[i];
      li := (Owner as TfrmBedStructure).lwBedStructure.Items.Add;
      li.Caption := '    ' + s.List(AllOpts.Current.ListOption, false);
      li.Data  := s;
      li.ImageIndex := 4 +
                       s.StructureElementTypeID  +
                       ord(s.StructureElementTypeID = 0);
    end;}
  end;
end;

{ TBedHorizonSubstructureLoadAction }

function TBedHorizonSubstructureLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var i: integer;
    li: TListItem;
begin
  Result := false;
  LastCollection := (ABaseObject as TOldBed).Substructures;
  if LastCollection.NeedsUpdate then
    Result := inherited Execute(ABaseObject);

  for i := 0 to LastCollection.Count - 1 do
  begin
    li := (Owner as TfrmBedStructure).lwBedStructure.Items.Add;
    li.Caption := '    ' + LastCollection.Items[i].List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false);
    li.Data  := LastCollection.Items[i];
    li.ImageIndex := 4 +
                    (LastCollection.Items[i] as TOldSubstructure).StructureElementTypeID  +
                    ord((LastCollection.Items[i] as TOldSubstructure).StructureElementTypeID = 0);
  end;
end;

{ TRightClickAction }

function TRightClickAction.Execute: boolean;
var b: TBaseObject;
    o: TBaseObject;

begin
  Result := true;
  with Owner as TfrmBedStructure do
  begin
    // копируем горизонт или подструктуру в соответствующие коллекции залежи
    b := TBaseObject(frmMainTree.trwMain.Selected.Data);
    if b is TOldHorizon then
    begin
      o := Bed.Horizons.Add;
      o.Assign(b);
    end
    else
    if b is TOldSubstructure then
    begin
      o := Bed.Substructures.Add;
      o.Assign(b);
    end
    else if b is TOldLayer then
    begin
      o := Bed.Layers.Add;
      o.Assign(b);
    end;

    Bed.Horizons.NeedsUpdate := false;
    Bed.Substructures.NeedsUpdate := false;
    Bed.Layers.NeedsUpdate := false;
    // перегружаем список
    actnLoadLayer.Execute(Bed);
  end;
end;

function TRightClickAction.Update: boolean;
var lr: TOldLayer;
    i: integer;
begin
  with Owner as TfrmBedStructure do
  begin
    Result := Assigned(frmMainTree.trwMain.Selected)
              and (TObject(frmMainTree.trwMain.Selected.Data) is TOldLayer);

    if Result then
    begin
      lr := TObject(frmMainTree.trwMain.Selected.Data) as TOldLayer;
      for i := 0 to lwBedStructure.Items.Count - 1 do
      if (TObject(lwBedStructure.Items[i].Data) as TOldLayer).ID = lr.ID then
      begin
        Result := false;
        break;
      end;
    end;
  end;
  Enabled := Result;  
end;

{ TLeftClickAction }

function TLeftClickAction.Execute: boolean;
var b: TBaseObject;
begin
  Result := true;
  with Owner as TfrmBedStructure do
  begin
    // убираем из коллекции ненужный
    b := TBaseObject(lwBedStructure.Selected.Data);
    b.Free;
    // перегружаем
    actnLoadLayer.Execute(Bed);
  end;
end;

function TLeftClickAction.Update: boolean;
begin
  // только если слева что-то выделено
  with Owner as TfrmBedStructure do
    Result := Assigned(lwBedStructure.Selected);
  Enabled := Result;
end;

{ TAllRightClickAction }

function TAllRightClickAction.Execute: boolean;
var i, j, k: integer;
    lr: TOldLayer;
begin
  Result := true;
  with Owner as TfrmBedStructure do
  begin
    for i := 0 to frmMainTree.Structures.Items[0].Horizons.Count - 1 do
    begin
      // добавляем каждый продуктивный пласт каждой подструктуры каждого горизонта
      for j := 0 to frmMainTree.Structures.Items[0].Horizons.Items[i].Substructures.Count - 1 do
      begin
        for k := 0 to frmMainTree.Structures.Items[0].Horizons.Items[i].Substructures.Items[j].Layers.Count - 1 do
        if Bed.Layers.IndexOfUIN(frmMainTree.Structures.Items[0].Horizons.Items[i].Substructures.Items[j].Layers.Items[k].ID)  = -1 then
        begin
          lr := Bed.Layers.Add;
          lr.Assign(frmMainTree.Structures.Items[0].Horizons.Items[i].Substructures.Items[j].Layers.Items[k]);
        end;
      end;
    end;

    Bed.Layers.NeedsUpdate := false;
    // перегружаем
    actnLoadLayer.Execute(Bed);
  end;
end;

function TAllRightClickAction.Update: boolean;
begin
  Result := true;
  Enabled := true;
end;

{ TAllLeftClickAction }

function TAllLeftClickAction.Execute: boolean;
begin
  Result := true;
  with Owner as TfrmBedStructure do
  begin
    // чистим все
    Bed.Horizons.Clear;
    Bed.Substructures.Clear;
    Bed.Layers.Clear;
    // чистим представления
    lwBedStructure.Items.Clear;
  end;
end;

function TAllLeftClickAction.Update: boolean;
begin
  // чистим
  with Owner as TfrmBedStructure do
    Result := lwBedStructure.Items.Count > 0;
  Enabled := Result;
end;

{ TBedLayerLoadAction }

function TBedLayerLoadAction.Execute(ABaseObject: TBaseObject): boolean;
var i: integer;
    li: TListItem;
begin
  Result := false;
  LastCollection := (ABaseObject as TOldBed).Layers;
  if LastCollection.NeedsUpdate then
    Result := inherited Execute(ABaseObject);

  (Owner as TfrmBedStructure).lwBedStructure.Items.BeginUpdate;
  (Owner as TfrmBedStructure).lwBedStructure.Items.Clear;
  for i := 0 to LastCollection.Count - 1 do
  begin
    li := (Owner as TfrmBedStructure).lwBedStructure.Items.Add;
    li.Caption := LastCollection.Items[i].List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false);
    li.Data  := LastCollection.Items[i];
    li.ImageIndex := 12;
  end;
  (Owner as TfrmBedStructure).lwBedStructure.Items.EndUpdate;  
end;

procedure TfrmBedStructure.frmMainTreetrwMainDblClick(Sender: TObject);
begin
  if sbtnRight.Enabled then sbtnRight.Action.Execute;
end;

procedure TfrmBedStructure.lwBedStructureDblClick(Sender: TObject);
begin
  if sbtnLeft.Enabled then sbtnLeft.Action.Execute;
end;

end.
