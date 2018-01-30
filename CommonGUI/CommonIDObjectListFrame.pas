unit CommonIDObjectListFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseGUI, UniButtonsFrame, ComCtrls, BaseObjects, Registrator,
  BaseActions, ActnList, CommonObjectSelector;

type
  TfrmIDObjectListFrame = class(TFrame, IGUIAdapter, IObjectSelector)
    frmButtons1: TfrmButtons;
    lwObjects: TListView;
    procedure lwObjectsDblClick(Sender: TObject);
    procedure frmButtons1btnAddClick(Sender: TObject);
    procedure lwObjectsCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lwObjectsColumnClick(Sender: TObject; Column: TListColumn);
  private
    { Private declarations }
    FObjectList: TIDObjects;
    FOnRegisterSubscribers: TNotifyEvent;
    FShowShortName: boolean;
    FEditActionClass: TBaseActionClass;
    FDeleteActionClass: TBaseActionClass;
    FAddActionClass: TBaseActionClass;
    FMultiSelect: boolean;
    FShowID: boolean;
    FSelectedObjects: TIDObjects;
    FShowNavigationButtons: boolean;
    FIsEditable: boolean;
    FColClicked: Boolean;
    function  IndexOfObject(AObject: TIDObject): integer;
    procedure SetObjectList(const Value: TIDObjects);
    procedure SetShowShortName(const Value: boolean);
    procedure SetAddActionClass(const Value: TBaseActionClass);
    procedure SetDeleteActionClass(const Value: TBaseActionClass);
    procedure SetEditActionClass(const Value: TBaseActionClass);
    procedure DeselectAll;
    procedure SetShowID(const Value: boolean);
    procedure SetShowNavigationButtons(const Value: boolean);
    procedure SetIsEditable(const Value: boolean);
  protected
    FGUIAdapter: TGUIAdapter;
    procedure SetMultiSelect(const Value: boolean);
    function  GetMultiSelect: boolean;
    procedure SetSelectedObject(AValue: TIDObject);
    function  GetSelectedObject: TIDObject;
    function  GetSelectedObjects: TIDObjects;
    procedure SetSelectedObjects(AValue: TIDObjects);
    function  GetOwnerObjectList: TIDObjects; virtual;
  public
    { Public declarations }
    property  MultiSelect: boolean read FMultiSelect write SetMultiSelect;
    property  ShowShortName: boolean read FShowShortName write SetShowShortName;
    property  ShowID: boolean read FShowID write SetShowID;
    property  ShowNavigationButtons: boolean read FShowNavigationButtons write SetShowNavigationButtons;

    property  GUIAdapter: TGUIAdapter read FGUIAdapter implements IGUIAdapter;
    property  ObjectList: TIDObjects read FObjectList write SetObjectList;
    property  OwnerObjectList: TIDObjects read GetOwnerObjectList;
    procedure ReloadList; virtual;

    property  SelectedObject: TIDObject read GetSelectedObject write SetSelectedObject;
    property  SelectedObjects: TIDObjects read GetSelectedObjects write SetSelectedObjects;
    procedure ReadSelectedObjects;
    property  IsEditable: boolean read FIsEditable write SetIsEditable;


    property  AddActionClass: TBaseActionClass read FAddActionClass write SetAddActionClass;
    property  EditActionClass: TBaseActionClass read FEditActionClass write SetEditActionClass;
    property  DeleteActionClass: TBaseActionClass read FDeleteActionClass write SetDeleteActionClass;


    property  OnRegisterSubscribers: TNotifyEvent read FOnRegisterSubscribers write FOnRegisterSubscribers;
    constructor Create(AOwner: TComponent); override;
  end;

  TIDObjectsGUIAdapter = class(TCollectionGUIAdapter)
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


implementation

{$R *.dfm}

uses Facade, IDObjectBaseActions;


{ TfrmIDObjectList }

constructor TfrmIDObjectListFrame.Create(AOwner: TComponent);
begin
  inherited;
  FGUIAdapter := TIDObjectsGUIAdapter.Create(Self);
  FGUIAdapter.Buttons := [abReload, abAdd, abDelete, abFind, abSort, abSelectAll, abEdit];

  FShowShortName := false;
  AddActionClass := TIDObjectAddAction;
  EditActionClass := TIDObjectEditAction;
  DeleteActionClass := TIDObjectDeleteAction;

  FIsEditable := true;
  frmButtons1.GUIAdapter := FGUIAdapter;
end;


procedure TfrmIDObjectListFrame.ReloadList;
begin
  if ObjectList is TRegisteredIDObjects then
    (ObjectList as TRegisteredIDObjects).MakeList(lwObjects.Items, true, true);
end;

procedure TfrmIDObjectListFrame.SetObjectList(const Value: TIDObjects);
begin
  FObjectList := Value;
  ReloadList;
end;

{ TIDObjectsGUIAdapter }

function TIDObjectsGUIAdapter.Add: integer;
var actn: TBaseAction;
begin
  Result := 0;
  actn := TMainFacade.GetInstance.ActionByClassType[(Frame as TfrmIDObjectListFrame).AddActionClass] as TBaseAction;
  actn.Execute((Frame as TfrmIDObjectListFrame).OwnerObjectList);

  (Frame as TfrmIDObjectListFrame).ReloadList;
end;

procedure TIDObjectsGUIAdapter.AddGroup;
begin
  inherited;
end;

procedure TIDObjectsGUIAdapter.Clear;
begin
  inherited;
end;

function TIDObjectsGUIAdapter.Delete: integer;
begin
  Result := 0;
  (TMainFacade.GetInstance.ActionByClassType[(Frame as TfrmIDObjectListFrame).DeleteActionClass] as TBaseAction).Execute(TIDObject((Frame as TfrmIDObjectListFrame).SelectedObject));
  (Frame as TfrmIDObjectListFrame).ReloadList;  
end;

function TIDObjectsGUIAdapter.Edit: integer;
var actn: TBaseAction;
begin
  Result := 0;
  actn := TMainFacade.GetInstance.ActionByClassType[(Frame as TfrmIDObjectListFrame).AddActionClass] as TBaseAction;
  actn.Execute((Frame as TfrmIDObjectListFrame).SelectedObject);
  (Frame as TfrmIDObjectListFrame).ReloadList;
end;

function TIDObjectsGUIAdapter.GetCanAdd: boolean;
begin
  Result :=  Assigned((Frame as TfrmIDObjectListFrame).ObjectList);
end;

function TIDObjectsGUIAdapter.GetCanDelete: boolean;
begin
  Result := Assigned((Frame as TfrmIDObjectListFrame).SelectedObject);
end;

function TIDObjectsGUIAdapter.GetCanEdit: boolean;
begin
  Result := Assigned((Frame as TfrmIDObjectListFrame).SelectedObject);
end;

function TIDObjectsGUIAdapter.GetCanFind: boolean;
begin
  Result :=  Assigned((Frame as TfrmIDObjectListFrame).ObjectList) and
             ((Frame as TfrmIDObjectListFrame).ObjectList.Count > 1);
end;

function TIDObjectsGUIAdapter.GetCanSort: boolean;
begin
  Result :=  inherited GetCanSort and 
             Assigned((Frame as TfrmIDObjectListFrame).ObjectList) and
             ((Frame as TfrmIDObjectListFrame).ObjectList.Count > 1);
end;

procedure TIDObjectsGUIAdapter.Reload;
begin
  inherited;

end;

function TIDObjectsGUIAdapter.Save: integer;
begin
  Result := 0;
end;

procedure TIDObjectsGUIAdapter.SelectAll;
begin
  inherited;
end;

function TIDObjectsGUIAdapter.StartFind: integer;
begin
  Result := 0;
end;

procedure TfrmIDObjectListFrame.lwObjectsDblClick(Sender: TObject);
begin
  if GUIAdapter.CanEdit then GUIAdapter.Edit;
end;

procedure TfrmIDObjectListFrame.SetShowShortName(const Value: boolean);
begin
  FShowShortName := Value;
  if FShowShortName then lwObjects.Columns[2].Width := -2
  else lwObjects.Columns[2].Width := 0;
end;

procedure TfrmIDObjectListFrame.SetAddActionClass(
  const Value: TBaseActionClass);
begin
  FAddActionClass := Value;
end;

procedure TfrmIDObjectListFrame.SetDeleteActionClass(
  const Value: TBaseActionClass);
begin
  FDeleteActionClass := Value;
end;

procedure TfrmIDObjectListFrame.SetEditActionClass(
  const Value: TBaseActionClass);
begin
  FEditActionClass := Value;
end;

procedure TfrmIDObjectListFrame.SetMultiSelect(const Value: boolean);
begin
  FMultiSelect := Value;
  lwObjects.Checkboxes := FMultiSelect;
end;

function TfrmIDObjectListFrame.GetMultiSelect: boolean;
begin
  Result := FMultiSelect;
end;

function TfrmIDObjectListFrame.GetSelectedObject: TIDObject;
begin
  Result := nil;
  if Assigned(lwObjects.Selected) then
    Result := TIDObject(lwObjects.Selected.Data);
end;

function TfrmIDObjectListFrame.GetSelectedObjects: TIDObjects;
begin
  ReadSelectedObjects;
  Result := FSelectedObjects;
end;

procedure TfrmIDObjectListFrame.SetSelectedObject(AValue: TIDObject);
var i: integer;
begin
  i := IndexOfObject(AValue);
  if i > -1 then
    lwObjects.ItemIndex := i; 
end;

procedure TfrmIDObjectListFrame.SetSelectedObjects(AValue: TIDObjects);
var i, iIndex: integer;
begin
  if not Assigned(FSelectedObjects) then
  begin
    FSelectedObjects := TIDObjects.Create;
    FSelectedObjects.OwnsObjects := false;
  end;

  FSelectedObjects.Clear;
  FSelectedObjects.AddObjects(AValue, false, False);

  DeselectAll;
  if MultiSelect then
  begin
    for i := 0 to FSelectedObjects.Count - 1 do
    begin
      iIndex := IndexOfObject(FSelectedObjects.Items[i]);
      if iIndex > -1 then
        lwObjects.Items[iIndex].Checked := true;
    end;
  end
  else if FSelectedObjects.Count = 1 then
  begin
    iIndex := IndexOfObject(FSelectedObjects.Items[0]);
    if iIndex > -1 then
      lwObjects.Items[iIndex].Selected := true;
  end;
end;

function TfrmIDObjectListFrame.IndexOfObject(AObject: TIDObject): integer;
var i: integer;
begin
  Result := -1;
  for i := 0 to lwObjects.Items.Count - 1 do
  if TIDObject(lwObjects.Items[i].Data) = AObject then
  begin
    Result := i;
    break;
  end;
end;

procedure TfrmIDObjectListFrame.DeselectAll;
var i: integer;
begin
  for i := 0 to lwObjects.Items.Count - 1 do
    lwObjects.Items[i].Checked := false;
end;

procedure TfrmIDObjectListFrame.SetShowID(const Value: boolean);
begin
  FShowID := Value;
  if FShowID then lwObjects.Columns[0].Width := -2
  else
  begin
    if MultiSelect then lwObjects.Columns[0].Width := 21
    else lwObjects.Columns[0].Width := 0;
  end;
end;



procedure TfrmIDObjectListFrame.ReadSelectedObjects;
var i: integer;
begin
  if not Assigned(FSelectedObjects) then
  begin
    FSelectedObjects := TIDObjects.Create;
    FSelectedObjects.OwnsObjects := false;
  end;

  FSelectedObjects.Clear;
  if MultiSelect then
  begin
    for i := 0 to lwObjects.Items.Count - 1 do
    if lwObjects.Items[i].Checked then
      FSelectedObjects.Add(TIDObject(lwObjects.Items[i].Data), false, false);
  end
  else
  begin
    for i := 0 to lwObjects.Items.Count - 1 do
    if lwObjects.Items[i].Selected then
      FSelectedObjects.Add(TIDObject(lwObjects.Items[i].Data), false, false);
  end;
  
  if FSelectedObjects.Count = 0 then
  begin
    if Assigned(SelectedObject) then
      FSelectedObjects.Add(SelectedObject, false, false);
  end;
end;

procedure TfrmIDObjectListFrame.SetShowNavigationButtons(
  const Value: boolean);
begin
  FShowNavigationButtons := Value;
end;

procedure TfrmIDObjectListFrame.frmButtons1btnAddClick(Sender: TObject);
begin
  frmButtons1.actnAddExecute(Sender);

end;

procedure TfrmIDObjectListFrame.SetIsEditable(const Value: boolean);
begin
  FIsEditable := Value;
  if not FIsEditable then
    frmButtons1.Visible := False
  else
    frmButtons1.Visible := true;
end;

procedure TfrmIDObjectListFrame.lwObjectsCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
//
end;

procedure TfrmIDObjectListFrame.lwObjectsColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  FColClicked := not FColClicked;
  if Column.Index = 0 then
    ObjectList.SortByID(FColClicked)
  else if Column.Index = 1 then
    ObjectList.SortByName(FColClicked);

  ReloadList;
end;

function TfrmIDObjectListFrame.GetOwnerObjectList: TIDObjects;
begin
  if FObjectList.OwnsObjects then
    Result := FObjectList
  else
    Result := nil;
end;

end.
