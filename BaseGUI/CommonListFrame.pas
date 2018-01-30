unit CommonListFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, BaseObjects, StdCtrls, ExtCtrls, ToolWin,
  ComCtrls, ActnList, Registrator, TreeNodeFrame;

type
  TCommonListEditState = (clsInitialState, clsObjectAdded, clsObjectEdited);
  TAllowedAction = (actnAdd, actnEdit, actnDelete);
  TAllowedActions = set of TAllowedAction;

  TfrmCommonList = class(TfrmCommonFrame)
  //TfrmCommonList = class(TFrame)
    tlbrEditList: TToolBar;
    pnlProperties: TPanel;
    Splitter1: TSplitter;
    actnCommonList: TActionList;
    actnAddObject: TAction;
    actnStartEdit: TAction;
    actnFinishEdit: TAction;
    actnCancelEdit: TAction;
    actnDeleteObject: TAction;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    pnlList: TPanel;
    lbxObjects: TListBox;
    sbReport: TStatusBar;
    procedure lbxObjectsClick(Sender: TObject);
    procedure actnAddObjectExecute(Sender: TObject);
    procedure actnStartEditExecute(Sender: TObject);
    procedure actnFinishEditExecute(Sender: TObject);
    procedure actnCancelEditExecute(Sender: TObject);
    procedure actnDeleteObjectExecute(Sender: TObject);
    procedure actnAddObjectUpdate(Sender: TObject);
    procedure actnStartEditUpdate(Sender: TObject);
    procedure actnFinishEditUpdate(Sender: TObject);
    procedure actnCancelEditUpdate(Sender: TObject);
    procedure actnDeleteObjectUpdate(Sender: TObject);
  private
    { Private declarations }
    FObjectList, FSelectedObjects: TRegisteredIDObjects;
    FObjectEditFrameClass: TCommonFrameClass;
    FObjectEditFrame: TfrmCommonFrame;
    FRegistrator: TRegistrator;
    FEditingObjectClass: TIDObjectClass;
    FAllowedActions: TAllowedActions;
    FOnLoadList: TNotifyEvent;
    FOnObjectEditFinished: TNotifyEvent;
    FStatusString: string;
    procedure SetObjectList(const Value: TRegisteredIDObjects);
    procedure SetObjectEditFrameClass(const Value: TCommonFrameClass);
    procedure ClearSelection;

    procedure AddItem(AObject: TIDObject);
    //procedure UpdateItem(AObject: TIDObject);
    procedure DeleteItem(AObject: TIDObject);
    function  FindItem(AObject: TIDObject): integer;
    procedure SetEditingObjectClass(const Value: TIDObjectClass);
    function  GetActiveObject: TIDObject;
    procedure CloseForm(Sender: TObject; var CanClose: Boolean);
    procedure SetStatusString(const Value: string);
    function  GetSelectedObjects: TIDObjects;
    procedure ReportStatus(S: string);
  protected
    FActiveObject: TIDObject;
    FCommonListEditState: TCommonListEditState;
    procedure SetRegistrator(const Value: TRegistrator); virtual;

    procedure AddObject; virtual;
    procedure EditObject; virtual;
    procedure FinishEditObject; virtual;
    procedure CancelEditObject; virtual;
    procedure DeleteObject; virtual;
  public
    { Public declarations }

    property  ObjectEditFrame: TfrmCommonFrame read FObjectEditFrame;
    property  ObjectEditFrameClass: TCommonFrameClass read FObjectEditFrameClass write SetObjectEditFrameClass;
    property  ObjectList: TRegisteredIDObjects read FObjectList write SetObjectList;
    property  ActiveObject: TIDObject read GetActiveObject;
    property  SelectedObjects: TIDObjects read GetSelectedObjects;

    property  Registrator: TRegistrator read FRegistrator write SetRegistrator;
    property  EditingObjectClass: TIDObjectClass read FEditingObjectClass write SetEditingObjectClass;
    procedure Clear; override;
    function  CheckInput: boolean; virtual;

    property    AllowedActions: TAllowedActions read FAllowedActions write FAllowedActions;
    property    OnLoadList: TNotifyEvent read FOnLoadList write FOnLoadList;
    property    OnObjectEditFinished: TNotifyEvent read FOnObjectEditFinished write FOnObjectEditFinished;

    property    StatusString: string read FStatusString write SetStatusString;

    property    EditState: TCommonListEditState read FCommonListEditState;
    procedure   Finish; virtual;
    procedure   Cancel; virtual;

    procedure   MakeList; virtual;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;


var
  frmCommonList: TfrmCommonList;

implementation



{$R *.dfm}




{ TfrmCommonList }

procedure TfrmCommonList.SetObjectEditFrameClass(
  const Value: TCommonFrameClass);
begin
  if FObjectEditFrameClass <> Value then
  begin
    FObjectEditFrameClass := Value;
    if Assigned(FObjectEditFrame) then FObjectEditFrame.Free;

    if Assigned(FObjectEditFrameClass) then
    begin
      FObjectEditFrame := FObjectEditFrameClass.Create(Self.Owner);
      FObjectEditFrame.Parent := pnlProperties;
      FObjectEditFrame.Align := alClient;
    end
    else FObjectEditFrame := nil;
  end;
end;

procedure TfrmCommonList.SetObjectList(const Value: TRegisteredIDObjects);
begin
  //if FObjectList <> Value then
  begin
    FObjectList := Value;
    if Assigned(FObjectList) then
    if not Assigned(FOnLoadList) then
      MakeList
    else FOnLoadList(lbxObjects);
  end;
end;

procedure TfrmCommonList.lbxObjectsClick(Sender: TObject);
begin
  inherited;
  FActiveObject := TIDObject(lbxObjects.Items.Objects[lbxObjects.ItemIndex]);
  if Assigned(FObjectEditFrame) then
  if lbxObjects.ItemIndex > -1 then
    FObjectEditFrame.EditingObject := TIDObject(lbxObjects.Items.Objects[lbxObjects.ItemIndex])
  else
    FObjectEditFrame.Clear;
end;

procedure TfrmCommonList.MakeList;
begin
  FObjectList.MakeList(lbxObjects.Items, true)
end;

constructor TfrmCommonList.Create(AOwner: TComponent);
begin
  inherited;
  FCommonListEditState := clsInitialState;
  FObjectEditFrameClass := nil;

  if (Owner is TForm) then
    (Owner as TForm).OnCloseQuery := CloseForm;

  AllowedActions := [actnAdd, actnEdit, actnDelete];
end;

procedure TfrmCommonList.actnAddObjectExecute(Sender: TObject);
begin
  inherited;
  AddObject;
end;

procedure TfrmCommonList.actnStartEditExecute(Sender: TObject);
begin
  inherited;
  EditObject;
end;

procedure TfrmCommonList.actnFinishEditExecute(Sender: TObject);
begin
  inherited;
  FinishEditObject;
end;

procedure TfrmCommonList.actnCancelEditExecute(Sender: TObject);
begin
  inherited;
  CancelEditObject;
end;

procedure TfrmCommonList.actnDeleteObjectExecute(Sender: TObject);
begin
  inherited;
  DeleteObject;
end;

procedure TfrmCommonList.AddItem(AObject: TIDObject);
var iIndex: integer;
begin
  iIndex := FindItem(AObject);
  ClearSelection;

  if iIndex = -1 then
  begin
    iIndex := lbxObjects.Items.AddObject(AObject.List, AObject);
    lbxObjects.Selected[iIndex] := true;
  end
  else
  begin
    lbxObjects.Items[iIndex] := AObject.List;
    lbxObjects.Items.Objects[iIndex] := AObject;
    lbxObjects.Selected[iIndex] := true;
  end;
end;

procedure TfrmCommonList.AddObject;
begin
  FActiveObject := ObjectList.Add;
  lbxObjects.ItemIndex := lbxObjects.Count - 1;
  FObjectEditFrame.EditingObject := FActiveObject;
  lbxObjects.Enabled := false;
  FCommonListEditState := clsObjectAdded;
  FObjectEditFrame.ViewOnly := false;
  FObjectEditFrame.Edited := not (FCommonListEditState = clsInitialState);
end;

procedure TfrmCommonList.DeleteItem(AObject: TIDObject);
var iIndex: integer;
begin
  iIndex := FindItem(AObject);
  if iIndex > -1 then lbxObjects.Items.Delete(iIndex);
end;


procedure TfrmCommonList.DeleteObject;
var i: integer;
begin
  if SelectedObjects.Count = 1 then
  begin
    FActiveObject := lbxObjects.Items.Objects[lbxObjects.ItemIndex] as TIDObject;
    if MessageBox(Handle, PChar('Вопрос'), PChar('Вы действительно хотите удалить ' + PChar(FActiveObject.List) + '?'), MB_APPLMODAL + MB_YESNO + MB_DEFBUTTON3) = mrYes then
    begin
      FActiveObject.Collection.Remove(FActiveObject);
      FActiveObject := nil;
    end;
  end
  else
  begin
    if MessageBox(Handle, PChar('Вопрос'), PChar('Вы действительно хотите удалить выделенные объекты (' + IntToStr(SelectedObjects.Count) + ')?'), MB_APPLMODAL + MB_YESNO + MB_DEFBUTTON3) = mrYes then
    begin
      for i := SelectedObjects.Count - 1 downto 0 do
        ObjectList.Remove(SelectedObjects.Items[i]);

      FActiveObject := nil;
    end;
  end;

  if Assigned(FObjectEditFrame) then
  begin
    FObjectEditFrame.Clear;
    FObjectEditFrame.ViewOnly := true;
    FObjectEditFrame.Clear;
    FObjectEditFrame.Edited := not (FCommonListEditState = clsInitialState);
  end;

  FActiveObject := nil;
  CheckInput;
  FActiveObject := nil;

  {
  if Assigned(NodeObject) then
  begin
    bExpanded := NodeObject.Node.Expanded;
    NodeObject.Refresh;
    if bExpanded then
      NodeObject.Node.Expand(false);
  end;
  }
end;

function TfrmCommonList.FindItem(AObject: TIDObject): integer;
begin
  Result := lbxObjects.Items.IndexOfObject(AObject);
end;

procedure TfrmCommonList.Finish;
begin
  if actnFinishEdit.Enabled then
    actnFinishEdit.Execute;
end;

procedure TfrmCommonList.FinishEditObject;
var iIndex: integer;
begin

  iIndex := lbxObjects.ItemIndex;
  FObjectEditFrame.Save;
  FCommonListEditState := clsInitialState;
  lbxObjects.Enabled := true;
  FObjectEditFrame.ViewOnly := true;

  {if Assigned(NodeObject) then
  begin
    bExpanded := NodeObject.Node.Expanded;
    NodeObject.Refresh;
    if bExpanded then
      NodeObject.Node.Expand(false);
  end;}

  if Assigned(FOnObjectEditFinished) then
    FOnObjectEditFinished(Self);
  FObjectEditFrame.Edited := not (FCommonListEditState = clsInitialState);


  lbxObjects.SetFocus;
  lbxObjects.ItemIndex := -1;
  lbxObjects.ItemIndex := iIndex;
  lbxObjects.Invalidate;
  lbxObjects.Refresh;
end;

{procedure TfrmCommonList.UpdateItem(AObject: TIDObject);
var iIndex: integer;
begin
  iIndex := FindItem(AObject);
  if iIndex > -1 then
  begin
    lbxObjects.Items[iIndex] := AObject.List;
    lbxObjects.Items.Objects[iIndex] := AObject;
  end;
end;}

{ TListBoxRegistrator }


procedure TfrmCommonList.SetRegistrator(const Value: TRegistrator);
begin
  if FRegistrator <> Value then
  begin
    FRegistrator := Value;
  end;
end;


procedure TfrmCommonList.SetStatusString(const Value: string);
begin
  FStatusString := Value;
  sbReport.SimpleText := FStatusString;
end;

procedure TfrmCommonList.SetEditingObjectClass(
  const Value: TIDObjectClass);
begin
  if FEditingObjectClass <> Value then
    FEditingObjectClass := Value;
end;

procedure TfrmCommonList.actnAddObjectUpdate(Sender: TObject);
begin
  inherited;
  actnAddObject.Enabled := (EditState = clsInitialState) and Assigned(ObjectList) and (actnAdd in AllowedActions);
end;

procedure TfrmCommonList.actnStartEditUpdate(Sender: TObject);
begin
  inherited;
  actnStartEdit.Enabled := (EditState = clsInitialState) and
                           (lbxObjects.SelCount = 1) and
                           (lbxObjects.ItemIndex > -1) and
                           (actnEdit in AllowedActions);
end;

procedure TfrmCommonList.actnFinishEditUpdate(Sender: TObject);
begin
  inherited;
  actnFinishEdit.Enabled := (EditState in [clsObjectAdded, clsObjectEdited])
                            and ((not Assigned(ObjectEditFrame)) or  (Assigned(ObjectEditFrame) and ObjectEditFrame.Edited and ObjectEditFrame.Check));
end;

procedure TfrmCommonList.actnCancelEditUpdate(Sender: TObject);
begin
  inherited;
  actnCancelEdit.Enabled := EditState in [clsObjectAdded, clsObjectEdited];
end;

procedure TfrmCommonList.actnDeleteObjectUpdate(Sender: TObject);
begin
  inherited;
  actnDeleteObject.Enabled := (EditState = clsInitialState) and (lbxObjects.SelCount > 0) and (lbxObjects.ItemIndex > -1) and (actnDelete in AllowedActions);
end;

function TfrmCommonList.GetActiveObject: TIDObject;
begin
  Result := FActiveObject;
end;



function TfrmCommonList.GetSelectedObjects: TIDObjects;
var i: integer;
begin
  if not Assigned(FSelectedObjects) then
  begin
    FSelectedObjects := TRegisteredIDObjects.Create;
    FSelectedObjects.OwnsObjects := false;
  end
  else FSelectedObjects.Clear;


  for i := 0 to lbxObjects.Items.Count - 1 do
  if lbxObjects.Selected[i] then
    FSelectedObjects.Add(TIDObject(lbxObjects.Items.Objects[i]), false, false);

  Result := FSelectedObjects;
end;

procedure TfrmCommonList.Clear;
begin
  inherited;
  if Assigned(ObjectEditFrame) then ObjectEditFrame.Clear;
  lbxObjects.Clear;  
end;

procedure TfrmCommonList.ClearSelection;
var i: integer;
begin
  lbxObjects.ItemIndex := -1;
  for i := 0 to lbxObjects.Count - 1 do
    lbxObjects.Selected[i] := false;
end;

procedure TfrmCommonList.Cancel;
begin
  actnCancelEdit.Execute;
end;

procedure TfrmCommonList.CancelEditObject;
begin
  if FCommonListEditState = clsObjectAdded then
  begin
    FActiveObject.Collection.Remove(FActiveObject);
    FActiveObject := nil;
    FObjectEditFrame.Clear;
  end
  else FObjectEditFrame.EditingObject := FActiveObject;

  FCommonListEditState := clsInitialState;
  lbxObjects.Enabled := true;
  FObjectEditFrame.ViewOnly := true;
  FObjectEditFrame.Clear;
  FObjectEditFrame.Edited := not (FCommonListEditState = clsInitialState);
end;

function TfrmCommonList.CheckInput: boolean;
begin
  if (EditState <> clsInitialState) and Assigned(ObjectEditFrame) then
  begin
    Result := ObjectEditFrame.Check;

    if not Result then
    begin
      //ReportStatus(ObjectEditFrame.L);
      exit;
    end;
  end;


  Result := EditState = clsInitialState;

  if not Result then
  begin
    ReportStatus('Завершите операцию добавления или редакции');
    exit;
  end;

  ReportStatus('');
end;

procedure TfrmCommonList.CloseForm(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := (EditState = clsInitialState);

  if not CanClose then ShowMessage('Сначала завершите или отмените редакцию элемента');
end;

destructor TfrmCommonList.Destroy;
begin
  if Assigned(FSelectedObjects) then FreeAndNil(FSelectedObjects);
  inherited;
end;

procedure TfrmCommonList.EditObject;
begin
  FActiveObject := lbxObjects.Items.Objects[lbxObjects.ItemIndex] as TIDObject;
  FObjectEditFrame.EditingObject := FActiveObject;
  lbxObjects.Enabled := false;
  FObjectEditFrame.Edited := not (FCommonListEditState = clsInitialState);
  FCommonListEditState := clsObjectEdited;
  FObjectEditFrame.ViewOnly := false;
end;

procedure TfrmCommonList.ReportStatus(S: string);
begin

end;

end.
