unit RRManagerVersionsFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ToolWin, ImgList, ActnList, RRManagerObjects,
  ClientCommon, RRManagerBaseGUI, RRManagerBaseObjects;

type
  TfrmVersions = class(TFrame)
    actnLst: TActionList;
    AddVersion: TAction;
    DeleteVersion: TAction;
    AddSubElement: TAction;
    DeleteSubElement: TAction;
    SaveCurrent: TAction;
    Undo: TAction;
    Clear: TAction;
    imgLst: TImageList;
    gbxLeft: TGroupBox;
    tlbr: TToolBar;
    tlbtnAddVersion: TToolButton;
    tlbtnDeleteVersion: TToolButton;
    ToolButton3: TToolButton;
    tlbtnAddReserve: TToolButton;
    tlbtnDeleteReserve: TToolButton;
    cmbxView: TComboBox;
    ToolButton1: TToolButton;
    trw: TTreeView;
    tlbtnSave: TToolButton;
    tlbtnUndo: TToolButton;
    ToolButton5: TToolButton;
    ToolButton2: TToolButton;
    procedure AddVersionExecute(Sender: TObject);
    procedure AddSubElementExecute(Sender: TObject);
    procedure DeleteSubElementExecute(Sender: TObject);
    procedure cmbxViewChange(Sender: TObject);
    procedure SaveCurrentExecute(Sender: TObject);
    procedure UndoExecute(Sender: TObject);
    procedure ClearExecute(Sender: TObject);
    procedure DeleteVersionUpdate(Sender: TObject);
    procedure AddSubElementUpdate(Sender: TObject);
    procedure DeleteSubElementUpdate(Sender: TObject);
    procedure UndoUpdate(Sender: TObject);
    procedure DeleteVersionExecute(Sender: TObject);
    procedure actnLstUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure trwGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure trwExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure trwAdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: Boolean);
  private
    { Private declarations }
    FOnAddSubElement: TNotifyEvent;
    FOnDeleteSubElement: TNotifyEvent;
    FVersions: TOldAccountVersions;
    FOnAddVersion: TNotifyEvent;
    FOnDeleteVersion: TNotifyEvent;
    FOnViewChanged: TNotifyEvent;
    FOnSaveVersion: TNotifyEvent;
    FVersion: TOldAccountVersion;
    FOnSaveCurrentChecked: TNotifyEvent;
    FOnUndo: TNotifyEvent;
    FOnClear: TNotifyEvent;
    FEditingClass: TBaseObjectClass;
    FElementLoadAction: TBaseAction;
    function GetVersion: TOldAccountVersion;
  public
    { Public declarations }
    property  Versions: TOldAccountVersions read FVersions write FVersions;
    property  Version: TOldAccountVersion read GetVersion;
    property  EditingClass: TBaseObjectClass read FEditingClass write FEditingClass;
    property  ElementLoadAction: TBaseAction read FElementLoadAction write FElementLoadAction;
    procedure SaveVersion;
    procedure Prepare(AVersions: TOldAccountVersions; AElementName: string; AEditingClass: TBaseObjectClass;
                      AElementLoadAction: TBaseAction);


    property OnAddSubElement: TNotifyEvent read FOnAddSubElement write FOnAddSubElement;
    property OnDeleteSubElement: TNotifyEvent read FOnDeleteSubElement write FOnDeleteSubElement;
    property OnAddVersion: TNotifyEvent read FOnAddVersion write FOnAddVersion;
    property OnDeleteVersion: TNotifyEvent read FOnDeleteVersion write FOnDeleteVersion;
    property OnViewChanged: TNotifyEvent read FOnViewChanged write FOnViewChanged;
    property OnSaveVersion: TNotifyEvent read FOnSaveVersion write FOnSaveVersion;
    property OnSaveCurrentChecked: TNotifyEvent read FOnSaveCurrentChecked write FOnSaveCurrentChecked;
    property OnUndo: TNotifyEvent read FOnUndo write FOnUndo;
    property OnClear: TNotifyEvent read FOnClear write FOnClear;

    function  FindObject(AObject: TBaseObject): integer;
    procedure FindSelection(const ADocID, ATypeID, AElementID: integer);
  end;



implementation

uses Facade;



{$R *.dfm}

procedure TfrmVersions.AddVersionExecute(Sender: TObject);
var v: TOldAccountVersion;
    Node: TTreeNode;
begin
  v := Versions.Add;
  v.DocTypeID := 1;
  v.DocName := GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_COUNT_DOCUMENT_TYPE_DICT'].Dict, v.DocTypeID);

  v.VersionID := 1;
  v.Version := GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_COUNT_VERSION_DICT'].Dict, v.VersionID);

  v.CreationDate := Now;
  v.AffirmationDate := Now;

  // 0 - организация не указана
  v.CreatorOrganizationID := 0;
  v.CreatorOrganization := GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_ORGANIZATION_DICT'].Dict, v.CreatorOrganizationID);

  Node := trw.Items.AddObject(nil, v.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), v);
  Node.SelectedIndex := 10;
  //trw.Items.AddChildObject(Node, '<без категории>', TValue.Create(0));

  if Assigned(FOnAddVersion) then FOnAddVersion(Sender);
end;

procedure TfrmVersions.AddSubElementExecute(Sender: TObject);
var Node: TTreeNode;
begin
  Node := trw.Selected;
  if Node.Level > 0 then
  while Assigned(Node.Parent) do
    Node := Node.Parent;


  if Assigned(Node) then
  if Assigned(FOnAddSubElement) then OnAddSubElement(Sender);

  {if Assigned(Node) then
    Node.GetLastChild.Selected := true;}
end;

procedure TfrmVersions.DeleteSubElementExecute(Sender: TObject);
begin
  if Assigned(FOnDeleteSubElement) then OnDeleteSubElement(Sender);
end;


procedure TfrmVersions.Prepare(AVersions: TOldAccountVersions;
  AElementName: string; AEditingClass: TBaseObjectClass;
  AElementLoadAction: TBaseAction);
begin
  FVersions := AVersions;
  FEditingClass := AEditingClass;
  FElementLoadAction := AElementLoadAction;
  cmbxView.Items.Add(AElementName);
  cmbxView.Items.Add('<все>');
  cmbxView.ItemIndex := 1;
end;

procedure TfrmVersions.cmbxViewChange(Sender: TObject);
begin
  trw.Selected := nil;
  if Assigned(FOnViewChanged) then OnViewChanged(Sender);
end;

procedure TfrmVersions.SaveVersion;
begin
  if Assigned(FOnSaveVersion) then FOnSaveVersion(nil);

  if Assigned(Version) then
  if TBaseObject(trw.Selected.Data) is TOldAccountVersion then
     trw.Selected.Text := Version.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false);
end;

procedure TfrmVersions.SaveCurrentExecute(Sender: TObject);
begin
  SaveCurrent.Checked := not SaveCurrent.Checked;

  if SaveCurrent.Checked then
  begin
    if TObject(trw.Selected.Data) is TOldAccountVersion then
      SaveVersion
    else
    if Assigned(FOnSaveCurrentChecked) then FOnSaveCurrentChecked(Sender);
  end;
end;

procedure TfrmVersions.UndoExecute(Sender: TObject);
begin
  if Assigned(FOnUndo) then FOnUndo(Sender);
end;

procedure TfrmVersions.ClearExecute(Sender: TObject);
begin
  if Assigned(FOnClear) then FOnClear(Sender); 
end;

procedure TfrmVersions.DeleteVersionUpdate(Sender: TObject);
begin
  DeleteVersion.Enabled := Assigned(trw.Selected) and (TObject(trw.Selected.Data) is TOldAccountVersion);
end;

procedure TfrmVersions.AddSubElementUpdate(Sender: TObject);
begin
  AddSubElement.Enabled := Assigned(trw.Selected);
end;

procedure TfrmVersions.DeleteSubElementUpdate(Sender: TObject);
begin
  try
    DeleteSubElement.Enabled := Assigned(trw.Selected) and (TBaseObject(trw.Selected.Data) is EditingClass);
  except
    DeleteSubElement.Enabled := false;
  end;
end;

procedure TfrmVersions.UndoUpdate(Sender: TObject);
begin
  Undo.Enabled := Assigned(trw.Selected) and (not SaveCurrent.Checked);
end;

procedure TfrmVersions.DeleteVersionExecute(Sender: TObject);
begin
  TBaseObject(trw.Selected.Data).Free;
  trw.Selected.Delete;
  if Assigned(FOnDeleteVersion) then FOnDeleteVersion(Sender);
end;

procedure TfrmVersions.actnLstUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  Handled := not (Assigned(Versions) and Versions.Renewable);
end;

procedure TfrmVersions.trwGetImageIndex(Sender: TObject; Node: TTreeNode);
begin
  with Node do ImageIndex:=SelectedIndex;
end;

procedure TfrmVersions.trwExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  Node.Selected := true;
  if Node.Level = 0 then
    FElementLoadAction.Execute(TOldAccountVersion(Node.Data));
end;

function TfrmVersions.FindObject(AObject: TBaseObject): integer;
var i: integer;
begin
  Result := -1;
  for i := 0 to trw.Items.Count - 1 do
  if  trw.Items[i].Data = AObject then
  begin
    Result := i;
    break;
  end;
end;

procedure TfrmVersions.FindSelection(const ADocID, ATypeID,
  AElementID: integer);
var Node, Child, GrandChild: TTreeNode;
begin
{  Node := trw.Items.GetFirstNode;

  while Assigned(Node) do
  begin
    // ищем документ который был выделен
    if TOldAccountVersion(Node.Data).UIN = ADocID then
    begin
      Node.Selected := true;
      // загружаем параметры для него
      Node.Expand(true);
      // ищем тип параметра который был выделен
      Child := Node.getFirstChild;

      while Assigned(Child) do
      begin
        if TValue(Child.Data).Value = ATypeID then
        begin
          // ищем параметр, который был выделен
          GrandChild := Child.GetFirstChild;
          while Assigned(GrandChild) do
          begin
            if TBaseObject(GrandChild.Data).UIN = AElementID then
            begin
              GrandChild.Selected := true;
              exit;
            end;
            GrandChild := Child.GetNextChild(GrandChild)
          end;
        end;
        Child := Node.GetNextChild(Child);
      end;
    end;
    Node := Node.GetNext;
  end;
  // до сюда вряд ли доберемся, просто на всякий случай  }
end;

function TfrmVersions.GetVersion: TOldAccountVersion;
begin
  Result := nil;
  case trw.Selected.Level of
  0: Result := TOldAccountVersion(trw.Selected.Data);
  1: Result := TOldAccountVersion(trw.Selected.Parent.Data);
  2: Result := TOldAccountVersion(trw.Selected.Parent.Parent.Data);
  end;
end;

procedure TfrmVersions.trwAdvancedCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
  var PaintImages, DefaultDraw: Boolean);
begin
  if TObject(Node.Data) is TBaseObject then
    if not TBaseObject(Node.Data).Check then trw.Canvas.Font.Color := clRed;
end;

end.
