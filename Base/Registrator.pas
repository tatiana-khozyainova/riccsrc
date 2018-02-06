unit Registrator;

interface

uses BaseObjects, Classes, Contnrs, ComCtrls, StdCtrls, Menus, Grids, Forms, Ex_Grid;

const
  IID_NULLInterface: TGUID = '{00000000-0000-0000-0000-000000000000}';
  IID_RegisteredGUI: TGUID = '{9FE660C8-1848-48B2-A538-C554FC2A17E6}';
  IID_ListFrame: TGUID = '{4FA77E7D-80CB-4424-9C30-01B43FBC36BF}';


type


  TUpdateKind = (ukUnk, ukAdd, ukUpdate, ukDelete, ukDeleteWithChildren, ukClear);

  IRegisteredGUI = interface;

  IRegisteredGUI = interface
  ['{9FE660C8-1848-48B2-A538-C554FC2A17E6}']
    function    GetRegistered: boolean;
    procedure   SetRegistered(const Value: boolean);
    function  GetClassList: TClassList;
    property  ClassList: TClassList read GetClassList;
    procedure MakeListUpdate(ACollection: TIDObjects; AUpdate: TUpdateKind); overload;
    procedure MakeUpdate(AObject: TIDObject; AUpdate: TUpdateKind); overload;
    property  Registered: boolean read GetRegistered write SetRegistered;
    procedure RefreshLists;
  end;


  TRegisteredObject = class
  private
    FControl: TObject;
    FIDObjects: TIDObjects;
  public
    property  Control: TObject read FControl write FControl;
    property  IDObjects: TIDObjects read FIDObjects write FIDObjects;
    function  Update(AObject, AParentObject: TIDObject; UpdateKind: TUpdateKind): integer; overload; virtual; abstract;
    function  Update(AObjects: TIDObjects; AObject, AParentObject: TIDObject; UpdateKind: TUpdateKind): integer; overload; virtual; abstract;

    class function GetControlClass: TClass; virtual;
    class function GetControlInterface: TGuid; virtual;
  end;

  TRegisteredObjectClass = class of TRegisteredObject;

  TStringsRegisteredObject = class(TRegisteredObject)
  private
    function GetStrings: TStrings;
  public
    property  Strings: TStrings read GetStrings;
    class function  GetControlClass: TClass; override;
    function  Update(AObject, AParentObject: TIDObject; UpdateKind: TUpdateKind): integer; override;
    function  Update(AObjects: TIDObjects; AObject, AParentObject: TIDObject; UpdateKind: TUpdateKind): integer; override;
  end;

  TTreeViewRegisteredObject = class(TRegisteredObject)
  private
    function GetNodes: TTreeNodes;
  public
    property  Nodes: TTreeNodes read GetNodes;

    class function  GetControlClass: TClass; override;
    function  FindNode(AObject: TIDObject): TTreeNode;
    function  Update(AObject, AParentObject: TIDObject; UpdateKind: TUpdateKind): integer; override;
    function  Update(AObjects: TIDObjects; AObject, AParentObject: TIDObject; UpdateKind: TUpdateKind): integer; override;
  end;

  TListViewRegisteredObject = class(TRegisteredObject)
  private
    function GetListItems: TListItems;
  public
    property ListItems: TListItems read GetListItems;
    class function  GetControlClass: TClass; override;
    function  FindItem(AObject: TIDObject): TListItem;
    function  Update(AObject, AParentObject: TIDObject; UpdateKind: TUpdateKind): integer; override;
    function  Update(AObjects: TIDObjects; AObject, AParentObject: TIDObject; UpdateKind: TUpdateKind): integer; override;
  end;


  IListFrame = interface
   ['{4FA77E7D-80CB-4424-9C30-01B43FBC36BF}']
    procedure ReloadList(AUpdateKind: TUpdateKind);
    procedure ReloadItem(AObject: TIDObject; AUpdateKind: TUpdateKind);
    function  FindItem(AObject: TIDObject): integer;

  end;

  TListFrameRegisteredObject = class(TRegisteredObject)
  private
    function GetFrame: IListFrame;
  public
    property Frame: IListFrame read GetFrame;
    class function  GetControlClass: TClass; override;
    class function  GetControlInterface: TGUID; override;

    function  FindItem(AObject: TIDObject): integer;
    function  Update(AObject, AParentObject: TIDObject; UpdateKind: TUpdateKind): integer; override;
    function  Update(AObjects: TIDObjects; AObject, AParentObject: TIDObject; UpdateKind: TUpdateKind): integer; override;
  end;



  TRegisteredObjectClassList = class(TClassList)
  private
    function GetItems(Index: integer): TRegisteredObjectClass;
  public
    property Items[Index: integer]: TRegisteredObjectClass read GetItems; default;
    function GetClassByControlClass(AControlClass: TClass; AControlInterface: TGuid): TRegisteredObjectClass;

  end;

  TRegistrator = class(TObjectList)
  private
    FAllowedClassList: TRegisteredObjectClassList;
    FNeedRegistering: boolean;
    function GetItems(Index: Integer): TRegisteredObject;
  public
    property  AllowedControlClasses: TRegisteredObjectClassList read FAllowedClassList;
    property  Items[Index: Integer]: TRegisteredObject read GetItems;

    property  NeedRegistering: boolean read FNeedRegistering write FNeedRegistering;

    function  Add(RegisteredObjectClass: TRegisteredObjectClass; AControl: TObject; AObjects: TIDObjects): TRegisteredObject;

    function  GetRegisteredObject(AControl: TComponent; AObject: TIDObject): TRegisteredObject; overload;
    function  GetRegisteredObject(AControl: TComponent; AObjects: TIDObjects): TRegisteredObject; overload;
    function  GetRegisteredObject(var StartAt: integer; AObjects: TIDObjects): TRegisteredObject; overload;
    function  GetRegisteredObject(var StartAt: integer; AObject: TIDObject): TRegisteredObject; overload;

    procedure Update(AObject, AParentObject: TIDObject; UpdateKind: TUpdateKind); overload;
    procedure Update(ACollection: TIDObjects; AObject, AParentObject: TIDObject; UpdateKind: TUpdateKind); overload;

    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TRegisteredIDObject = class(TIDObject)
  private
    FOnLoadDataItem: TNotifyEvent;
    FOnInitDataLoading: TNotifyEvent;
  protected
    FRegistrator: TRegistrator;
    function GetRegistrator: TRegistrator; virtual;
    procedure AssignTo(Dest: TPersistent); override;
  public
    property    Registrator: TRegistrator read GetRegistrator;
    function    Update(ACollection: TIDObjects = nil): integer; override;

    property    OnLoadCollectionDataItem: TNotifyEvent read FOnLoadDataItem write FOnLoadDataItem;
    property    OnInitCollectionDataLoading: TNotifyEvent read FOnInitDataLoading write FOnInitDataLoading;


    function    List(AListOption: TListOption = loBrief): string; override;

    procedure   MakeList(AListItems: TListItems; NeedsClearing: boolean = false); overload; virtual;
    procedure   MakeList(AListView: TListView; NeedsClearing: boolean = false); overload; virtual;

    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TObjectViewAdd = procedure (AView: TObject; AObject: TIdObject) of object;


  TRegisteredIDObjects = class(TIDObjects)
  private
    FOnObjectViewAdd: TObjectViewAdd;
    FOnLoadDataItem: TNotifyEvent;
    FOnInitDataLoading: TNotifyEvent;
  protected
    FRegistrator: TRegistrator;
    function GetRegistrator: TRegistrator;

  public
    procedure Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Registrator: TRegistrator read GetRegistrator write FRegistrator;

    function    Add: TIDObject; override;
    function    Add(AObject: TObject; Copy: boolean = true; NeedsCheck: boolean = true): TIDObject; reintroduce; overload; virtual;
    function    Add(AID: integer): TIDObject; override;
    function    Add(AID: integer; AName: string): TIDObject; override;
    function    Add(AID: integer; AName, AShortName: string): TIDObject; override;

    procedure   Delete(Index: integer); override;
    function    Remove(AObject: TObject): Integer; override;
    procedure   Clear; override;
    procedure   Refresh; override;

    procedure   MakeList(AListItems: TListItems; NeedsRegistering: boolean = true; NeedsClearing: boolean = false); overload; virtual;
    procedure   MakeList(ALst: TStrings; NeedsRegistering: boolean = true; NeedsClearing: boolean = true); overload; virtual;
    procedure   MakeList(AObject: TObject; NeedsRegistering: boolean = true; NeedsClearing: boolean = false); overload; virtual;
    procedure   MakeList(ATreeView: TTreeView; NeedsRegistering: boolean = true; NeedsClearing: boolean = false; CreateFakeNode: Boolean = true); overload; virtual;
    procedure   MakeList(ATreeNodes: TTreeNodes; NeedsRegistering: boolean = true; NeedsClearing: boolean = false; CreateFakeNode: Boolean = true); overload; virtual;
    procedure   MakeList(ANodeParent: TTreeNode; NeedsRegistering: boolean = true; NeedsClearing: boolean = false; CreateFakeNode: Boolean = true); overload; virtual;
    procedure   MakeList(AListColumns: TListColumns; NeedsRegistering: boolean = true; NeedsClearing: boolean = false); overload; virtual;
    procedure   MakeList(ACbx: TComboBox; NeedsRegistering: boolean = true; NeedsClearing: boolean = true); overload; virtual;
    procedure   MakeList(AMenu: TMenuItem; NeedsRegistering: boolean = true; NeedsClearing: boolean = true); overload; virtual;
    procedure   MakeList(AGrd: TStringGrid; NeedsRegistering: boolean = true; NeedsClearing: boolean = false); overload; virtual;
    procedure   MakeList(AFrame: TFrame; NeedsRegistering: boolean = true; NeedsClearing: boolean = false); overload; virtual;
    procedure   MakeList(ACaption: WideString; NeedsRegistering: boolean = true; NeedsClearing: boolean = true); overload; virtual;
    procedure   MakeList(AGrdView: TGridView; NeedsRegistering: boolean = true; NeedsClearing: boolean = false); overload; virtual;

    property    OnObjectViewAdd: TObjectViewAdd read FOnObjectViewAdd write FOnObjectViewAdd;
    property    OnLoadDataItem: TNotifyEvent read FOnLoadDataItem write FOnLoadDataItem;
    property    OnInitDataLoading: TNotifyEvent read FOnInitDataLoading write FOnInitDataLoading;


    function    ObjectsToStr (AAuthors: string): string; override;

    constructor Create; override;
    destructor  Destroy; override;
  end;



implementation

uses Facade, Options, SysUtils;

{ TRegistrator }

function TRegistrator.Add(RegisteredObjectClass: TRegisteredObjectClass; AControl: TObject;
  AObjects: TIDObjects): TRegisteredObject;
begin
  Result := RegisteredObjectClass.Create;
  inherited Add(Result);

  Result.Control := AControl;
  Result.IDObjects := AObjects;
end;

constructor TRegistrator.Create;
begin
  inherited Create(true);
  FAllowedClassList := TRegisteredObjectClassList.Create;
  FNeedRegistering := true;
  OwnsObjects := true;
end;

destructor TRegistrator.Destroy;
begin
  FAllowedClassList.Free;
  inherited;
end;

function TRegistrator.GetItems(Index: Integer): TRegisteredObject;
begin
  Result := inherited Items[Index] as TRegisteredObject;
end;

function TRegistrator.GetRegisteredObject(AControl: TComponent;
  AObject: TIDObject): TRegisteredObject;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if (Items[i].Control = AControl) and (Items[i].IDObjects.IndexOf(AObject) > -1) then 
  begin
    Result := Items[i];
    break;
  end;
end;

function TRegistrator.GetRegisteredObject(var StartAt: integer;
  AObjects: TIDObjects): TRegisteredObject;
var i: integer;
begin
  Result := nil;
  for i := StartAt to Count - 1 do
  begin
    StartAt := i;
    if (Items[i].IDObjects = AObjects) then
    begin
      Result := Items[i];
      break;
    end
  end;
  StartAt := StartAt + 1;
end;

function TRegistrator.GetRegisteredObject(var StartAt: integer;
  AObject: TIDObject): TRegisteredObject;
var i: integer;
begin
  Result := nil;
  for i := StartAt to Count - 1 do
  if (Items[i].IDObjects.IndexOf(AObject) > -1) then
  begin
    Result := Items[i];
    StartAt := i + 1;
    break;
  end;
end;

function TRegistrator.GetRegisteredObject(AControl: TComponent;
  AObjects: TIDObjects): TRegisteredObject;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if (Items[i].Control = AControl) and (Items[i].IDObjects = AObjects) then 
  begin
    Result := Items[i];
    break;
  end;
end;

procedure TRegistrator.Update(AObject, AParentObject: TIDObject; UpdateKind: TUpdateKind);
var i: integer;
begin
  for i := 0 to Count - 1 do
  if AObject.Collection = Items[i].IDObjects then
    Items[i].Update(AObject, AParentObject, UpdateKind);
end;

procedure TRegistrator.Update(ACollection: TIDObjects; AObject, AParentObject: TIDObject;
  UpdateKind: TUpdateKind);
var i: integer;
begin
  for i := 0 to Count - 1 do
  if ACollection = Items[i].IDObjects then
    Items[i].Update(ACollection, AObject, AParentObject, UpdateKind);
end;

{ TRegisteredIDObject }

procedure TRegisteredIDObject.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TRegisteredIDObject.Create;
begin
  inherited;
end;

destructor TRegisteredIDObject.Destroy;
begin
  if Assigned(Registrator) then Registrator.Update(Self, nil, ukDelete);
  inherited;
end;

function TRegisteredIDObject.GetRegistrator: TRegistrator;
begin
  if not Assigned (FRegistrator) then FRegistrator := TMainFacade.GetInstance.Registrator;
  Result := FRegistrator;
end;

function TRegisteredIDObject.List(AListOption: TListOption = loBrief): string;
begin
  Result := Name;  
end;

procedure TRegisteredIDObject.MakeList(AListItems: TListItems;
  NeedsClearing: boolean);
var i: integer;
    o : TListItem;
begin
  if NeedsClearing then AListItems.Clear;

  for i := 0 to CountFields - 1 do
  begin
    o := AListItems.Add;
    o.Data := Self;
  end;
end;

procedure TRegisteredIDObject.MakeList(AListView: TListView;
  NeedsClearing: boolean);
var i: integer;
    o : TListItem;
begin
  if NeedsClearing then AListView.Items.Clear;

  for i := 0 to CountFields - 1 do
  begin
    o := AListView.Items.Add;
    o.Data := Self;
  end;
end;

function TRegisteredIDObject.Update(ACollection: TIDObjects = nil): integer;
begin
  Result := inherited Update(ACollection);

  if Assigned(Registrator) then Registrator.Update(Self, Self.Collection.Owner, ukUpdate);
end;

{ TRegisteredIDObjects }

function TRegisteredIDObjects.Add: TIDObject;
begin
  Result := inherited Add;

  if Assigned(Registrator) then Registrator.Update(Result, Owner, ukAdd);
end;

function TRegisteredIdObjects.Add(AObject: TObject; Copy: boolean = true; NeedsCheck: boolean = true): TIDObject;
begin
  Result := inherited Add(AObject, Copy, NeedsCheck);
  if Copy then Registrator.Update(Result, Owner, ukAdd);
end;

procedure TRegisteredIDObjects.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

procedure TRegisteredIDObjects.Clear;
begin
  try
    if Assigned(Registrator) then
      Registrator.Update(Self, nil, nil, ukClear);
  except

  end;
  inherited;
end;

constructor TRegisteredIDObjects.Create;
begin
  inherited;
  FObjectClass := TRegisteredIDObject;
end;

procedure TRegisteredIDObjects.Delete(Index: integer);
var o: TIDObject;
begin
  o := Items[Index];

  if OwnsObjects then
  begin
    OwnsObjects := false;
    inherited;
    if Assigned(Registrator) then Registrator.Update(Self, o, o.Collection.Owner, ukDelete);
    o.Free;
    OwnsObjects := true;
  end
  else
  begin
    inherited;
    if (Assigned(Registrator)) and (Assigned (o.Collection)) then Registrator.Update(Self, Items[Index], o.Collection.Owner, ukDelete);
  end;
end;

destructor TRegisteredIDObjects.Destroy;
var iStart: integer;
    ro: TRegisteredObject;
begin
  iStart := 0;

  // перед удалением надо дерегистрировать
  // а то при автоматическом вызове очистки получаетс€ ерунда
  if Assigned(FRegistrator) then
  begin
    while (iStart > -1) and (iStart < FRegistrator.Count) do
    begin
      ro := FRegistrator.GetRegisteredObject(iStart, Self);
      if Assigned(ro) then
      begin
        FRegistrator.Remove(ro);
        dec(iStart);
      end
      else break;
    end;
  end;

  FRegistrator := nil;
  inherited;
end;

function TRegisteredIDObjects.GetRegistrator: TRegistrator;
begin
  if not Assigned (FRegistrator) then FRegistrator := TMainFacade.GetInstance.Registrator;
  Result := FRegistrator;
end;

procedure TRegisteredIDObjects.MakeList(ACbx: TComboBox; NeedsRegistering,
  NeedsClearing: boolean);
begin
  inherited;

  if NeedsClearing then ACbx.Clear;
end;


function TRegisteredIDObjects.Remove(AObject: TObject): Integer;
begin
  Result := 0;
  if OwnsObjects then
  begin
    try
      if Assigned(Registrator) then
         Registrator.Update(Self,
                           (AObject as TIDObject),
                           (AObject as TIDObject).Collection.Owner,
                            ukDelete);

      Result := inherited Remove(AObject);
    except
      Raise EObjectDeletingException.Create(AObject as TIDObject);
    end;
  end
  else
  begin
    MarkDeleted(AObject);
    if (Result >= 0) and Assigned(Registrator) then
        Registrator.Update(Self, (AObject as TIDObject),
                           (AObject as TIDObject).Collection.Owner, ukDelete);
    //Result := inherited Remove(AObject);
  end;
end;


procedure TRegisteredIDObjects.MakeList(AGrd: TStringGrid;
  NeedsRegistering, NeedsClearing: boolean);
begin

end;

function TRegisteredIDObjects.ObjectsToStr(AAuthors: string): string;
begin
  inherited ObjectsToStr (AAuthors);
end;


function TRegisteredIDObjects.Add(AID: integer; AName: string): TIDObject;
begin
  Result := inherited Add(AID, AName);
  Registrator.Update(Result, Owner, ukUpdate);
end;

function TRegisteredIDObjects.Add(AID: integer): TIDObject;
begin
  Result := inherited Add(AID);
  Registrator.Update(Result, Owner, ukUpdate);
end;

function TRegisteredIDObjects.Add(AID: integer; AName,
  AShortName: string): TIDObject;
begin
  Result := inherited Add(AID, AName, AShortName);
  Registrator.Update(Result, Owner, ukUpdate);
end;

procedure TRegisteredIDObjects.MakeList(AFrame: TFrame; NeedsRegistering,
  NeedsClearing: boolean);
begin
  
end;

procedure TRegisteredIDObjects.MakeList(ACaption: WideString; NeedsRegistering,
  NeedsClearing: boolean);
begin
  if NeedsClearing then ACaption := '';
end;

procedure TRegisteredIDObjects.MakeList(AGrdView: TGridView;
  NeedsRegistering, NeedsClearing: boolean);
var i: integer;
begin
  if NeedsClearing then
  with AGrdView do
  begin
    Rows.Count := 1;

    for i := 0 to Columns.Count - 1 do
      Cells[i, 0] := '';
  end;
end;

procedure TRegisteredIDObjects.Refresh;
begin
  if Assigned(Registrator) then
    Registrator.Update(Self, nil, nil, ukClear);
  inherited;
end;



{ TStringsRegisteredObject }

class function TStringsRegisteredObject.GetControlClass: TClass;
begin
  Result := TStrings;
end;

function TStringsRegisteredObject.GetStrings: TStrings;
begin
  Result := Control as TStrings;
end;

function TStringsRegisteredObject.Update(AObject, AParentObject: TIDObject;
  UpdateKind: TUpdateKind): integer;
var i: integer;
begin
  i := Strings.IndexOfObject(AObject);

  case UpdateKind of
    ukAdd, ukUnk, ukUpdate:
      if i > -1 then
      begin
        Strings[i] := AObject.List
      end
      else i := Strings.AddObject(AObject.List,
                          AObject);
    ukDelete, ukDeleteWithChildren: if i > -1 then Strings.Delete(i);
  end;

  Result := i;
end;

function TStringsRegisteredObject.Update(AObjects: TIDObjects; AObject, AParentObject: TIDObject;
  UpdateKind: TUpdateKind): integer;
var i: integer;
begin
  if Assigned(AObject) then
    Result := Update(AObject, AParentObject, UpdateKind)
  else
  begin
    Result := 0;
    if UpdateKind <> ukClear then
      for i := 0 to AObjects.Count - 1 do
      begin
        Result := Update(AObjects.Items[i], AParentObject, UpdateKind);
        if Result < 0 then break;
      end
    else Strings.Clear;
  end;
end;

{ TTreeViewRegisteredObject }

function TTreeViewRegisteredObject.FindNode(AObject: TIDObject): TTreeNode;
var Node: TTreeNode;
begin
  Result := nil;
  Node := Nodes.GetFirstNode;

  while Assigned(Node) do
  begin
    if TIdObject(Node.Data) = AObject then
    begin
      Result := Node;
      break;
    end;
    Node := Node.GetNext;
  end;
end;

class function TTreeViewRegisteredObject.GetControlClass: TClass;
begin
  Result := TTreeView;
end;

function TTreeViewRegisteredObject.GetNodes: TTreeNodes;
begin
  Result := (Control as TTreeView).Items;
end;

function TTreeViewRegisteredObject.Update(AObject, AParentObject: TIDObject;
  UpdateKind: TUpdateKind): integer;
var Node, ParentNode, ChildNode: TTreeNode;
begin
  Node := FindNode(AObject);

  case UpdateKind of
    ukAdd, ukUnk, ukUpdate:
    begin
      if Assigned(Node) then
      begin
        if Node.HasChildren then
        begin
          Node.DeleteChildren;
          Nodes.AddChildObject(Node, 'там что-то есть', nil)
        end;

        if not Assigned(AParentObject) then
          Node.Text := AObject.List
        else
        begin
          ParentNode := FindNode(AParentObject);
          if ParentNode <> Node.Parent then
          begin
            Node.Delete;
            Node := Nodes.AddChildObject(ParentNode, AObject.List, AObject)
          end
          else Node.Text := AObject.List;
        end
      end
      else
      if not Assigned(AParentObject) then
      begin
        Node := Nodes.AddObject(nil, AObject.List, AObject);
        Nodes.AddChildObject(Node, 'там что-то есть', nil)
      end
      else
      begin
        ParentNode := FindNode(AParentObject);
        Node := Nodes.AddChildObject(ParentNode, AObject.List, AObject)
      end;

      if Assigned((AObject.Collection as TRegisteredIDObjects).FOnObjectViewAdd) then
        (AObject.Collection as TRegisteredIDObjects).FOnObjectViewAdd(Node, AObject);
    end;
    ukDelete:
       if Assigned(Node) then
       begin
         Node.Delete;
         Node := nil;
       end;
    ukDeleteWithChildren:
       if Assigned(Node) then
       begin
         ChildNode := Node.getFirstChild;
         while Assigned(ChildNode) do
         begin
           TIDObject(ChildNode.Data).Collection.Remove(TIDObject(ChildNode.Data));
           ChildNode := Node.getFirstChild;
         end;
         Node.Delete;
         Node := nil;
       end;
  end;

  if Assigned(Node) then
    Result := Node.Index
  else
    Result := -1;
end;

function TTreeViewRegisteredObject.Update(AObjects: TIDObjects; AObject, AParentObject: TIDObject;
  UpdateKind: TUpdateKind): integer;
var i: integer;
begin
  Nodes.BeginUpdate;

  if Assigned(AObject) then
    Result := Update(AObject, AParentObject, UpdateKind)
  else
  begin
    Result := 0;
    if UpdateKind <> ukClear then
      for i := 0 to AObjects.Count - 1 do
      begin
        Result := Update(AObjects.Items[i], AParentObject, UpdateKind);
        if Result < 0 then break;
      end
    else Nodes.Clear;
  end;

  Nodes.EndUpdate;
end;

{ TRegisteredObject }

class function TRegisteredObject.GetControlClass: TClass;
begin
  Result := nil;
end;

class function TRegisteredObject.GetControlInterface: TGuid;
begin
  Result := IID_NULLInterface;
end;

{ TRegisteredObjectClassList }

function TRegisteredObjectClassList.GetClassByControlClass(
  AControlClass: TClass; AControlInterface: TGuid): TRegisteredObjectClass;
var i: integer;
begin
  Result := TStringsRegisteredObject;
  for i := 0 to Count - 1 do
  if Items[i].GetControlClass = AControlClass then
  begin
    if (GUIDToString(Items[i].GetControlInterface) = GUIDToString(IID_NULLInterface)) then
    begin
      Result := Items[i];
      break;
    end
    else if (GUIDToString(Items[i].GetControlInterface) = GUIDToString(AControlInterface)) then
    begin
      Result := Items[i];
      break;
    end;
  end;
end;

function TRegisteredObjectClassList.GetItems(
  Index: integer): TRegisteredObjectClass;
begin
  Result := TRegisteredObjectClass(inherited Items[Index]);
end;


procedure TRegisteredIdObjects.MakeList(ALst: TStrings; NeedsRegistering: boolean = true; NeedsClearing: boolean = true);
var i: integer;
begin
  if (NeedsClearing) then ALst.Clear;
  for i := 0 to Count - 1 do
    ALst.AddObject(Items[i].List, Items[i]);

  if Assigned(Registrator) and NeedsRegistering then
    Registrator.Add(TStringsRegisteredObject, ALst, Self);
end;

procedure TRegisteredIdObjects.MakeList(AObject: TObject; NeedsRegistering: boolean; NeedsClearing: boolean);
var cls: TRegisteredObjectClass;
begin
  if Assigned(Registrator) and NeedsRegistering then
  begin
    cls := Registrator.AllowedControlClasses.GetClassByControlClass(AObject.ClassType, IID_ListFrame);
    Registrator.Add(cls, AObject, Self);
  end;
end;

procedure TRegisteredIdObjects.MakeList(AMenu: TMenuItem; NeedsRegistering,
  NeedsClearing: boolean);
var i: integer;
    mi: TMenuItem;
begin
  if (NeedsClearing) then AMenu.Clear;
  for i := 0 to Count - 1 do
  begin
    mi := NewItem(Items[i].List, 0, false, true, nil, 0, AMenu.Name);
    mi.Tag := Items[i].ID;
    AMenu.Add(mi);
  end;
end;

procedure TRegisteredIdObjects.MakeList(AListItems: TListItems; NeedsRegistering,
  NeedsClearing: boolean);
var i: integer;
    o: TListItem;
begin
  AListItems.BeginUpdate;
  if (NeedsClearing) then AListItems.Clear;

  for i := 0 to Count - 1 do
  begin
    o := AListItems.Add;
    o.Caption := IntToStr(Items[i].ID);
    o.SubItems.Add(Items[i].List());
    o.SubItems.Add(Items[i].ShortName);
    o.Data := Items[i];

    if Assigned(FOnObjectViewAdd) then FOnObjectViewAdd(o, Items[i]);
  end;

  if Assigned(Registrator) and NeedsRegistering then
    Registrator.Add(TListViewRegisteredObject, AListItems, Self);

  AListItems.EndUpdate;

  // при первом показе долга€ инициализаци€, уж лучше посто€нные ширины
  //for i := 0 to lv.Columns.Count - 1 do
  //  lv.Columns[i].Width := -2;
end;

procedure TRegisteredIdObjects.MakeList(ATreeView: TTreeView; NeedsRegistering,
  NeedsClearing, CreateFakeNode: boolean);
var Node: TTreeNode;
    i: integer;
begin
  ATreeView.Items.BeginUpdate;
  if NeedsClearing then ATreeView.Items.Clear;

  for i := 0 to Count - 1 do
  begin
    Node := ATreeView.Items.AddObject(nil, Items[i].List, Items[i]);

    if CreateFakeNode then ATreeView.Items.AddChildObject(Node, '“ам что-то есть', nil);
    if Assigned(FOnObjectViewAdd) then FOnObjectViewAdd(Node, Items[i]);
  end;

  if Assigned(Registrator) and NeedsRegistering then Registrator.Add(TTreeViewRegisteredObject, ATreeView, Self);
  ATreeView.Items.EndUpdate;
end;

procedure TRegisteredIdObjects.MakeList(ANodeParent: TTreeNode; NeedsRegistering,
  NeedsClearing, CreateFakeNode: boolean);
var i: integer;
    Node: TTreeNode;
begin
  if NeedsClearing then
    ANodeParent.DeleteChildren;

  for i := 0 to Count - 1 do
  begin
    Node := (ANodeParent.TreeView as TTreeView).Items.AddChildObject(ANodeParent, Items[i].List, Items[i]);
    if CreateFakeNode then (Node.TreeView as TTreeView).Items.AddChildObject(Node, '“ам что-то есть', nil);
    if Assigned(FOnObjectViewAdd) then FOnObjectViewAdd(Node, Items[i]);
  end;

  if Assigned(Registrator) and NeedsRegistering then Registrator.Add(TTreeViewRegisteredObject, ANodeParent.TreeView, Self);
end;

procedure TRegisteredIdObjects.MakeList(ATreeNodes: TTreeNodes; NeedsRegistering,
  NeedsClearing, CreateFakeNode: boolean);
var i : integer;
    Node: TTreeNode;
begin
  ATreeNodes.BeginUpdate;
  if NeedsClearing then ATreeNodes.Clear;

  for i := 0 to Count - 1 do
  begin
    Node := ATreeNodes.AddObject(nil, Items[i].List, Items[i]);
    if CreateFakeNode then ATreeNodes.AddChildObject(Node, '“ам что-то есть', nil);
  end;

  if Assigned(Registrator) and NeedsRegistering then Registrator.Add(TTreeViewRegisteredObject, ATreeNodes.Owner, Self);
  ATreeNodes.EndUpdate;
end;


procedure TRegisteredIdObjects.MakeList(AListColumns: TListColumns; NeedsRegistering,
  NeedsClearing: boolean);
var i: integer;
    o: TListColumn;
begin
  for i := 0 to Count - 1 do
  begin
    o := AListColumns.Add;
    o.Caption := Items[i].Name;
    o.Width := ColumnHeaderWidth;
  end;
end;

{ TListViewRegisteredObject }

function TListViewRegisteredObject.FindItem(AObject: TIDObject): TListItem;
var i: integer;
begin
  Result := nil;

  for i := 0 to ListItems.Count - 1 do
  begin
    if TIdObject(ListItems.Item[i].Data) = AObject then
    begin
      Result := ListItems.Item[i];
      break;
    end;
  end;
end;

class function TListViewRegisteredObject.GetControlClass: TClass;
begin
  Result := TListItems;
end;

function TListViewRegisteredObject.GetListItems: TListItems;
begin
  Result := (Control as TListItems);
end;

function TListViewRegisteredObject.Update(AObject,
  AParentObject: TIDObject; UpdateKind: TUpdateKind): integer;
var li: TListItem;
begin
  li := FindItem(AObject);

  case UpdateKind of
    ukAdd, ukUnk, ukUpdate:
    begin
      if Assigned(li) then
      begin
        li.Caption := IntToStr(AObject.ID);
        li.SubItems.Clear;
        li.SubItems.Add(AObject.List);
        li.SubItems.Add(AObject.ShortName);
      end
      else
      begin
        li := ListItems.Add;
        li.Caption := IntToStr(AObject.ID);
        li.SubItems.Add(AObject.List);
        li.SubItems.Add(AObject.ShortName);        
        li.Data := AObject;
      end;
      if Assigned((AObject.Collection as TRegisteredIDObjects).FOnObjectViewAdd) then
        (AObject.Collection as TRegisteredIDObjects).FOnObjectViewAdd(li, AObject);
    end;
    ukDelete:
    if Assigned(li) then
    begin
      li.Delete;
      li := nil;
    end;
  end;

  if Assigned(li) then
    Result := li.Index
  else
    Result := -1;
end;

function TListViewRegisteredObject.Update(AObjects: TIDObjects; AObject,
  AParentObject: TIDObject; UpdateKind: TUpdateKind): integer;
var i: integer;
begin
  if Assigned(AObject) then
    Result := Update(AObject, AParentObject, UpdateKind)
  else
  begin
    Result := 0;
    if UpdateKind <> ukClear then
      for i := 0 to AObjects.Count - 1 do
      begin
        Result := Update(AObjects.Items[i], AParentObject, UpdateKind);
        if Result < 0 then break;
      end
    else ListItems.Clear;
  end;
end;


{ TFrameRegisteredObject }

function TListFrameRegisteredObject.FindItem(AObject: TIDObject): integer;
begin
  Result := Frame.FindItem(AObject);
end;


function TListFrameRegisteredObject.Update(AObject, AParentObject: TIDObject;
  UpdateKind: TUpdateKind): integer;
begin
  Frame.ReloadItem(AObject, UpdateKind);
  Result := 0;
end;

class function TListFrameRegisteredObject.GetControlInterface: TGUID;
begin
  Result := IListFrame;
end;

function TListFrameRegisteredObject.Update(AObjects: TIDObjects; AObject,
  AParentObject: TIDObject; UpdateKind: TUpdateKind): integer;
begin
  Frame.ReloadList(UpdateKind);
  Result := 0;
end;

class function TListFrameRegisteredObject.GetControlClass: TClass;
begin
  Result := TFrame;
end;

function TListFrameRegisteredObject.GetFrame: IListFrame;
begin
  Control.GetInterface(IListFrame, Result);
end;

end.

