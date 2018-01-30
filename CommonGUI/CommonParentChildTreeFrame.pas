unit CommonParentChildTreeFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, ComCtrls, ParentedObjects, BaseObjects, ImgList,
  CommonObjectSelector;

type
  TSelectableLayers = set of byte;

  TfrmParentChild = class(TfrmCommonFrame, IObjectSelector)
    trwHierarchy: TTreeView;
    imgLst: TImageList;
    procedure trwHierarchyGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure trwHierarchyMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FRoot: IParentChild;
    FSelectableLayers: TSelectableLayers;
    FSelectedObjects: TIDObjects;
    FMultiSelect: boolean;
    function FindNode(AObject: TIDObject): TTreeNode;
    procedure SetRoot(const Value: IParentChild);
    procedure SelectObject(ANode: TTreeNode);
    procedure DeselectObject(ANode: TTreeNode);
    procedure TreeNodeCheck(Node: TTreeNode);
  protected
    procedure SetSelectedObject(AValue: TIDObject);
    function  GetSelectedObject: TIDObject;
    procedure SetMultiSelect(const Value: boolean);
    function  GetMultiSelect: boolean;
    function  GetSelectedObjects: TIDObjects;
    procedure SetSelectedObjects(AValue: TIDObjects);
    procedure ReadSelectedObjects;
  public
    { Public declarations }
    property Root: IParentChild read FRoot write SetRoot;

    property MultiSelect: boolean read GetMultiSelect write SetMultiSelect;
    property SelectedObject: TIdObject read GetSelectedObject write SetSelectedObject;
    property SelectedObjects: TIdObjects read GetSelectedObjects write SetSelectedObjects;
    property SelectableLayers: TSelectableLayers read FSelectableLayers write FSelectableLayers;


    procedure LoadHierarchicalData(ACurrentRoot: IParentChild; ACurrentRootNode: TTreeNode);
  end;

var
  frmParentChild: TfrmParentChild;

implementation

uses ClientCommon;


{$R *.dfm}

{ TfrmParentChild }

procedure TfrmParentChild.DeselectObject(ANode: TTreeNode);
begin
  SelectedObjects.Remove(TObject(ANode.Data));
end;

function TfrmParentChild.FindNode(AObject: TIDObject): TTreeNode;
var Node: TTreeNode;
begin
  Node := trwHierarchy.Items.GetFirstNode;
  Result := nil;
  while Assigned(Node) do
  begin
    if TIDObject(Node.Data) = AObject then
    begin
      Result := Node;
      break;
    end;
    Node := Node.GetNext;
  end;


end;

function TfrmParentChild.GetSelectedObject: TIdObject;
begin
  Result := nil;
  if Assigned(trwHierarchy.Selected) then
    Result := TIDObject(trwHierarchy.Selected.Data);
end;

function TfrmParentChild.GetSelectedObjects: TIdObjects;
begin
  if not Assigned(FSelectedObjects) then
  begin
    FSelectedObjects := TIdObjects.Create;
    FSelectedObjects.OwnsObjects := false;
  end;

  Result := FSelectedObjects;
end;

procedure TfrmParentChild.LoadHierarchicalData(ACurrentRoot: IParentChild; ACurrentRootNode: TTreeNode);
var i: integer;
    Node: TTreeNode;
begin
  for i := 0 to ACurrentRoot.Children.Count - 1 do
  begin
    Node := trwHierarchy.Items.AddChildObject(ACurrentRootNode, ACurrentRoot.Children.Items[i].List(loBrief), ACurrentRoot.Children.Items[i]);
    LoadHierarchicalData(ACurrentRoot.ChildAsParent[i], Node);
  end;
end;

procedure TfrmParentChild.TreeNodeCheck(Node: TTreeNode);
begin
  // если отметили или разотметили ноду то нужно включить ее в список
  if Node.SelectedIndex = 0 then
    DeselectObject(Node)
  else if Node.SelectedIndex = 1 then
    SelectObject(Node);
end;

procedure TfrmParentChild.SelectObject(ANode: TTreeNode);
begin
  if ANode.Level in SelectableLayers then
    SelectedObjects.Add(TObject(ANode.Data), false, false);
end;


procedure TfrmParentChild.SetRoot(const Value: IParentChild);
begin
  if FRoot <> Value then
  begin
    FRoot := Value;
    trwHierarchy.Items.Clear;
    LoadHierarchicalData(FRoot, trwHierarchy.Items.AddObjectFirst(nil, FRoot.Me.List(loBrief), FRoot.Me));
  end;
end;

procedure TfrmParentChild.SetSelectedObject(AValue: TIdObject);
var Node: TTreeNode;
begin
  Node := FindNode(AValue);
  if Assigned(Node) then
  begin
    Node.Selected := true;
    Node.MakeVisible;
  end;
end;

procedure TfrmParentChild.trwHierarchyGetImageIndex(Sender: TObject;
  Node: TTreeNode);
begin
  inherited;
  with Node do ImageIndex:=SelectedIndex;
end;

procedure TfrmParentChild.trwHierarchyMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Node: TTreeNode;
    Rect: TRect;
begin
  inherited;
  Node := (Sender as TTreeView).GetNodeAt(X,Y);

  if (Node <> nil)
     and ((Node.Level + 1)*(Sender as TTreeView).Indent <= X)
     and (X <= ((Node.Level + 1) * (Sender as TTreeView).Indent + 10)) then
  begin
    Rect := Node.DisplayRect(False);
    if (Rect.Top <= Y) and (Y <= Rect.Bottom) then
    begin
      if Node.SelectedIndex < 2 then
        Node.SelectedIndex := 1 - Node.SelectedIndex
      else
        Node.SelectedIndex := 0;

      // если отметили или разотметили ноду то нужно включить ее в список
      if Node.SelectedIndex = 0 then
        DeselectObject(Node)
      else if Node.SelectedIndex = 1 then
        SelectObject(Node);

      CheckChildState((Sender as TTreeView), Node.Parent, TreeNodeCheck);
      DeriveParentState((Sender as TTreeView), Node, TreeNodeCheck);
      InvalidateRect((Sender as TTreeView).Handle, @Rect, true);
    end;
  end
end;

function TfrmParentChild.GetMultiSelect: boolean;
begin
  Result := FMultiSelect;
end;


procedure TfrmParentChild.SetMultiSelect(const Value: boolean);
begin
  FMultiSelect := Value;
  if not FMultiSelect then
    trwHierarchy.Images := nil
  else
    trwHierarchy.Images := imgLst;
end;

procedure TfrmParentChild.SetSelectedObjects(AValue: TIDObjects);
var i: integer;
    Node: TTreeNode;
begin
  FSelectedObjects := AValue;
  MultiSelect := true;

  for i := 0 to FSelectedObjects.Count - 1 do
  begin
    Node := FindNode(FSelectedObjects.Items[i]);
    if Assigned(Node) then
    begin
      Node.SelectedIndex := 1;
      TreeNodeCheck(Node);
    end;
  end;

  Node := trwHierarchy.Items.GetFirstNode;
  CheckChildState(trwHierarchy, Node, TreeNodeCheck);
end;

procedure TfrmParentChild.ReadSelectedObjects;
begin

end;

end.
