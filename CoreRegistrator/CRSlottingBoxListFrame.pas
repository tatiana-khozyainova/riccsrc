unit CRSlottingBoxListFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, ComCtrls, BaseObjects, Slotting, Well, ExtCtrls,
  StdCtrls, CRBoxEditFrame, UniButtonsFrame, BaseGUI,  SlottingPlacement,
  ActnList;

type
  TfrmSlottingBoxListFrame = class(TfrmCommonFrame, IGUIAdapter)
    gbxBoxEdit: TGroupBox;
    gbxList: TGroupBox;
    pnlBoxList: TPanel;
    Splitter1: TSplitter;
    frmButtons1: TfrmButtons;
    lwBoxes: TListView;
    Splitter2: TSplitter;
    frmBoxEdit1: TfrmBoxProperties;
    procedure lwBoxesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure frmButtons1ToolButton5Click(Sender: TObject);
    procedure frmButtons1btnAddClick(Sender: TObject);
    procedure frmButtons1actnSaveExecute(Sender: TObject);
    procedure lwBoxesClick(Sender: TObject);
  private
    { Private declarations }
    FGUIAdapter: TGUIAdapter;
    FNewBox: TBox;
    FMultiBoxes: TBoxes;
    function  GetWell: TWell;
    function  GetActiveBox: TBox;
    function  ListItemByObject(AObject: TIDObject): TListItem;
    procedure UncheckAll;
    function  GetActiveSlottingBox: TBox;
    function  GetSlotting: TSlotting;
    function  GetMultiBoxes: TBoxes;
    function  GetCheckedListViewItemCount: Integer;
  protected
    procedure FillControls(ABaseObject: TIDObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
    procedure RegisterInspector; override;
    function  GetParentCollection: TIDObjects; override;
    function  InternalCheck: boolean; override;
    procedure CopyEditingValues(Dest: TIDObject); override;
  public
    { Public declarations }
    property  Well: TWell read GetWell;


    // добавляемый ящик
    property  NewBox: TBox read FNewBox;
    property  ActiveBox: TBox read GetActiveBox;
    property  ActiveSlottingBox: TBox read GetActiveSlottingBox;
    property  Slotting: TSlotting read GetSlotting;
    property  MultiselectionBoxes: TBoxes read GetMultiBoxes;

    property    GUIAdapter: TGUIAdapter read FGUIAdapter implements IGUIAdapter;
    constructor Create(AOwner: TComponent); override;
    procedure   Save(AObject: TIDObject = nil);  override;
    destructor Destroy; override;    
  end;

var
  frmSlottingBoxListFrame: TfrmSlottingBoxListFrame;

implementation

uses DateUtils, Facade, Registrator, Math;




type

  TSlottingBoxListGUIAdapter = class(TGUIAdapter)
  protected
    function    GetCanAdd: boolean; override;
    function    GetCanDelete: boolean; override;
    function    GetCanCancel: boolean; override;
    function    GetCanSave: boolean; override;

  public
    procedure   Clear; override;
    procedure   SelectAll; override;
    procedure   Reload; override;

    function    Add (): integer; override;
    function    Save: integer; override;
    function    Delete: integer; override;
    function    Cancel: boolean; override;
  end;

{$R *.dfm}

{ TfrmSlottingBoxListFrame }

procedure TfrmSlottingBoxListFrame.ClearControls;
begin
  inherited;
  lwBoxes.Items.Clear;
  frmBoxEdit1.Clear;
end;

constructor TfrmSlottingBoxListFrame.Create(AOwner: TComponent);
begin
  inherited;
  NeedsShadeEditing := true;

  EditingClass := TSlotting;
  ParentClass := TWell;

  FGUIAdapter := TSlottingBoxListGUIAdapter.Create(Self);
  FGUIAdapter.Buttons := [abReload, abAdd, abDelete, abCancel, abSave];
  frmButtons1.GUIAdapter := GUIAdapter;

  FMultiBoxes := TBoxes.Create;
  FMultiBoxes.OwnsObjects := false;

end;

procedure TfrmSlottingBoxListFrame.FillControls(ABaseObject: TIDObject);
var i: integer;
    b: TBox;
    li: TListItem;
begin
  inherited;
  ((EditingObject as TSlotting).Collection.Owner as TWell).SlottingPlacement.Boxes.MakeList(lwBoxes.Items, true, true);

  UncheckAll;
  for i := 0 to (ShadeEditingObject as TSlotting).Boxes.Count - 1 do
  begin
    b := ((EditingObject as TSlotting).Collection.Owner as TWell).SlottingPlacement.Boxes.ItemsByID[(ShadeEditingObject as TSlotting).Boxes.Items[i].ID] as TBox;
    if Assigned(b) then
    begin
      li := ListItemByObject(b);
      li.Checked := true;
      li.Selected := true;
    end;
  end;


//  (ShadeEditingObject as TSlotting).Boxes.MakeList();
end;

procedure TfrmSlottingBoxListFrame.FillParentControls;
begin
  inherited;
  if (EditingObject is TWell) then
    (EditingObject as TWell).SlottingPlacement.Boxes.MakeList(lwBoxes.Items, true, true)
  else if (EditingObject is TSlotting) then
    (EditingObject.Owner as TWell).SlottingPlacement.Boxes.MakeList(lwBoxes.Items, true, true)
end;

function TfrmSlottingBoxListFrame.GetParentCollection: TIDObjects;
begin
  Result := nil;
end;

procedure TfrmSlottingBoxListFrame.RegisterInspector;
begin
  inherited;
  
end;

procedure TfrmSlottingBoxListFrame.Save;
var i: integer;
begin
  inherited;
  if DataLoaded then
  begin
    if Assigned(FNewBox) then GUIAdapter.Save;


    // подменяем на настоящий интервал отбора керна
    if ((not Assigned(EditingObject)) or (EditingObject is ParentClass)) and (Well.Slottings.Count > 0) then
      FEditingObject := Well.Slottings.Items[Well.Slottings.Count - 1];



    if EditingObject is TSlotting then
    begin
      (EditingObject as TSlotting).Boxes.MarkAllDeleted;
      for i := 0 to lwBoxes.Items.Count - 1 do
      if lwBoxes.Items[i].Checked then
        (EditingObject as TSlotting).Boxes.Add(TIDObject(lwBoxes.Items[i].Data), true, false);
    end;
  end;
end;

procedure TfrmSlottingBoxListFrame.lwBoxesChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  inherited;
  if Assigned(Item) then
  begin
    if (TObject(Item.Data) is TBox) and Assigned(Well) then
    begin
      frmBoxEdit1.SlottingPlacement := Well.SlottingPlacement;
      frmBoxEdit1.EditingObject := TBox(Item.Data);
    end;

    if lwBoxes.SelCount > 1 then frmBoxEdit1.Boxes := MultiselectionBoxes;
  end;
  Check;
end;

function TfrmSlottingBoxListFrame.InternalCheck: boolean;
begin
  Result := (lwBoxes.Items.Count > 0) and not Assigned(FNewBox);
  if not Result then
  begin
    StatusBar.Panels[0].Text := 'Отсутствуют ящики';
    exit;
  end;

  Result := GetCheckedListViewItemCount > 0;
  if not Result then
  begin
    StatusBar.Panels[0].Text := 'Керн не распределен в ящики';
    exit;
  end;

  StatusBar.Panels[0].Text := '';
end;


function TfrmSlottingBoxListFrame.GetWell: TWell;
begin
  Result := nil;

  if EditingObject is TWell then
    Result := EditingObject as TWell
  else if EditingObject is TSlotting then
    Result := (EditingObject as TSlotting).Collection.Owner as TWell
end;

function TfrmSlottingBoxListFrame.GetActiveBox: TBox;
begin
  Result := nil;
  if Assigned(lwBoxes.Selected) then
    Result := TBox(lwBoxes.Selected.Data);
end;


function TfrmSlottingBoxListFrame.ListItemByObject(
  AObject: TIDObject): TListItem;
var i: integer;
begin
  Result := nil;
  with lwBoxes do
  for i := 0 to Items.Count - 1 do
  if TObject(Items[i].Data) = AObject then
  begin
    Result := Items[i];
    break;
  end;
end;

procedure TfrmSlottingBoxListFrame.UncheckAll;
var i: integer;
begin
  for i := 0 to lwBoxes.Items.Count - 1 do
    lwBoxes.Items[i].Checked := false;
end;

function TfrmSlottingBoxListFrame.GetActiveSlottingBox: TBox;
begin
  Result := (ShadeEditingObject as TSlotting).Boxes.ItemsByID[ActiveBox.ID] as TBox;
end;

destructor TfrmSlottingBoxListFrame.Destroy;
begin
  FMultiBoxes.Free;
  inherited;
end;

procedure TfrmSlottingBoxListFrame.CopyEditingValues(Dest: TIDObject);
begin
  inherited;
  with Dest as TSlotting do
  begin
    Boxes.Clear;
    if Assigned(Slotting) then
      Boxes.AddObjects(Slotting.Boxes, true, true);
  end;
end;

function TfrmSlottingBoxListFrame.GetSlotting: TSlotting;
begin
  if EditingObject is TSlotting then
    Result := EditingObject as TSlotting
  else
    Result := nil;

end;

function TfrmSlottingBoxListFrame.GetMultiBoxes: TBoxes;
var i: integer;
begin
  FMultiBoxes.Clear;

  with lwBoxes do
  for i := 0 to Items.Count - 1 do
  if Items[i].Selected then
    FMultiBoxes.Add(TIDObject(Items[i].Data), false, False);

  Result := FMultiBoxes;
end;

function TfrmSlottingBoxListFrame.GetCheckedListViewItemCount: Integer;
var i: integer;
begin
  Result := 0;

  for i := 0 to lwBoxes.Items.Count - 1 do
    Result := Result + Ord(lwBoxes.Items[i].Checked);
end;

{ TSlottingBoxListGUIAdapter }

function TSlottingBoxListGUIAdapter.Add: integer;
var iBoxNumber: Integer;
begin
  Result := 0;

  with Owner as TfrmSlottingBoxListFrame do
  begin
    FNewBox := Well.SlottingPlacement.Boxes.Add as TBox;
    if Well.SlottingPlacement.Boxes.Count > 1 then FNewBox.Rack := (FNewBox.Prev as TBox).Rack;
     
    if not Assigned(Well.SlottingPlacement.StatePartPlacement) then
      Well.SlottingPlacement.StatePartPlacement := TMainFacade.GetInstance.CoreLibrary;

    // искусственно генерируем идентификатор
    Randomize;
    FNewBox.ID := -RandomRange(100000, 200000);

    iBoxNumber := -1;
    if Well.SlottingPlacement.Boxes.Count > 1 then
    begin
      try
        iBoxNumber := StrToInt((Well.SlottingPlacement.Boxes[Well.SlottingPlacement.Boxes.Count - 2] as TIDObject).Name);
      except
        iBoxNumber := -1;
      end;
    end
    else if Well.SlottingPlacement.Boxes.Count = 1 then iBoxNumber := 0;

    if iBoxNumber > -1 then
    begin
      FNewBox.Name := IntToStr(iBoxNumber + 1);
    end;
      
    frmBoxEdit1.EditingObject := FNewBox;
    Self.Save();

    if lwBoxes.Items.Count > 0 then 
    lwBoxes.Items[lwBoxes.Items.Count - 1].Selected := true;
    Check;
  end;
end;

function TSlottingBoxListGUIAdapter.Cancel: boolean;
begin
  Result := true;
  with Owner as TfrmSlottingBoxListFrame do
  begin
    Well.SlottingPlacement.Boxes.Remove(FNewBox);
    frmBoxEdit1.Clear;
    FNewBox := nil;
    Check;    
  end;
end;

procedure TSlottingBoxListGUIAdapter.Clear;
begin
  inherited;
  (Owner as TfrmSlottingBoxListFrame).Clear;
end;

function TSlottingBoxListGUIAdapter.Delete: integer;
var b: TBox;
begin
  Result := 0;
  with Owner as TfrmSlottingBoxListFrame do
  begin
    if (ActiveBox.Slottings.Count = 0) or
       (MessageBox(Handle,
                   PChar('Ящик ' + ActiveBox.List() + ' содержит интервалы: ' + ActiveBox.Slottings.List() +
                   '. Вы действительно хотите удалить ящик?'),
                   PChar('Внимание - удаляется ящик'), MB_ICONQUESTION + MB_YESNO + MB_APPLMODAL) = ID_YES) then
    begin
      b := ActiveSlottingBox;
      Well.SlottingPlacement.Boxes.Remove(ActiveBox);
      if Assigned(b) then (ShadeEditingObject as TSlotting).Boxes.MarkDeleted(b);

      frmBoxEdit1.Clear;
      if lwBoxes.Items.Count > 0 then
        lwBoxes.Items[lwBoxes.Items.Count - 1].Selected := true;
      Check;
    end;
  end;
end;

function TSlottingBoxListGUIAdapter.GetCanAdd: boolean;
begin
  Result := not Assigned((Owner as TfrmSlottingBoxListFrame).NewBox);
end;

function TSlottingBoxListGUIAdapter.GetCanCancel: boolean;
begin
  Result := Assigned((Owner as TfrmSlottingBoxListFrame).NewBox);
end;

function TSlottingBoxListGUIAdapter.GetCanDelete: boolean;
begin
  Result := (not Assigned((Owner as TfrmSlottingBoxListFrame).NewBox)) and Assigned((Owner as TfrmSlottingBoxListFrame).ActiveBox);
end;

function TSlottingBoxListGUIAdapter.GetCanSave: boolean;
begin
  with Owner as TfrmSlottingBoxListFrame do
    Result := Assigned(ActiveBox);
end;

procedure TSlottingBoxListGUIAdapter.Reload;
begin
  inherited;
  with (Owner as TfrmSlottingBoxListFrame) do
    FillControls(EditingObject);
end;

function TSlottingBoxListGUIAdapter.Save: integer;
begin
  Result := 0;
  with Owner as TfrmSlottingBoxListFrame do
  begin
    frmBoxEdit1.Save;
    if Assigned (FNewBox) then
    begin
      TMainFacade.GetInstance.Registrator.Update(FNewBox, FNewBox.Owner, ukUpdate);
      FNewBox := nil;
    end;
    Check;
  end;
end;

procedure TSlottingBoxListGUIAdapter.SelectAll;
begin
  inherited;

end;

procedure TfrmSlottingBoxListFrame.frmButtons1ToolButton5Click(
  Sender: TObject);
begin
  inherited;
  frmButtons1.actnAddExecute(Sender);

end;

procedure TfrmSlottingBoxListFrame.frmButtons1btnAddClick(Sender: TObject);
begin
  inherited;
  frmButtons1.actnAddExecute(Sender);

end;

procedure TfrmSlottingBoxListFrame.frmButtons1actnSaveExecute(
  Sender: TObject);
begin
  inherited;
  frmButtons1.actnSaveExecute(Sender);

end;

procedure TfrmSlottingBoxListFrame.lwBoxesClick(Sender: TObject);
begin
  inherited;
  Check;
end;

end.
