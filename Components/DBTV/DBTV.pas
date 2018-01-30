(*
  Модуль    : DBTV
  Категория : ..
  Версия: 3.0
  Автор : Маракасов Ф. В.

  22/07/09
    +Поддержка IActionsProvider
*)

{ --- Последняя модификация: 01.05.2009  23:20:20 --- }
  {#Author fmarakasov@ugtu.net}
unit DBTV;

interface

uses
  Windows, comctrls, classes, db, ShEvent, Graphics,
  Variants, ActnList, Menus, CoreInterfaces, Contnrs;
type
  TDBTreeView = class;
  TDBNodeObject = class;
  TDBNodeObjectList = class;

  // Типы операций над узлом
  TNodeAction = (taAdd, taDelete, taUpdate, taCopy, taPaste, taCut);

  // Класс типа узла
  TDBNodeClass = class of TDBNodeObject;

  // Делегат функции фильтрации узла дерева.
  TNodeFilterFunc = function(NodeObject : TDBNodeObject) : Boolean;

  TActionObjectList = class(TObjectList)
  private
    function GetItems(Index: integer): TAction;
  public
    property    Items[Index: integer]: TAction read GetItems;
    constructor Create;
  end;



  ///
  ///  Класс, объекты которого сопоставляются
  ///  с узлами дерева и
  ///  управляют загрузкой
  ///  дочерних узлов по требованию и
  ///  обработкой событий.
  ///
  TDBNodeObject = class (TInterfacedObject, IActionsProvider)
  private
    FDataSet: TDataSet;
    FFont: TFont;
    FID: Integer;
    FNode: TTreeNode;
    FParent: TDBNodeObject;
    FTreeView: TDBTreeView;
    FValue: Variant;
    FTerminal : Boolean;
    FAssosiatedClass : TClass;
    FFilter : TNodeFilterFunc;
    FPopupMenu : TPopupMenu;
    FLazyLoaded : Boolean;
    FActionCatigories : TStrings;

    function GetCanAddExecute: Boolean;
    function GetCanCopyExecute: Boolean;
    function GetCanCutExecute: Boolean;
    function GetCanDeleteExecute: Boolean;
    function GetCanPasteExecute: Boolean;
    function GetCanUpdateExecute: Boolean;
    function GetNodeActionCaption(NodeAction:TNodeAction): string;
    function GetNodeActions : TActionObjectList;
    function GetLogger : ILogger;

    procedure BuildPopupMenu;
  protected
    FChildAdded: Boolean;
    FName: string;
    function DoAddChildNodes:Boolean;virtual;
    function DoCanAddExecute: Boolean; virtual;
    function DoCanCopyExecute: Boolean; virtual;
    function DoCanCutExecute: Boolean; virtual;
    function DoCanDeleteExecute: Boolean; virtual;
    function DoCanPasteExecute: Boolean; virtual;
    function DoCanUpdateExecute: Boolean; virtual;
    function DoNodeActionCaption(NodeAction:TNodeAction): string; virtual;
    function GetActionList : TActionList;virtual;
    function CreateTreeNode(Caption:String; TNodeClass:TDBNodeClass; TerminalNode : Boolean = false) : TTreeNode; overload;
    function GetNodeObjects : TDBNodeObjectList;
    function GetPopupMenu : TPopupMenu;
    procedure SetFont(const Font: TFont);
    procedure SetFiltered(Value : TNodeFilterFunc);
    property ActionList : TActionList read GetActionList;

    // Реализация IActionProvider
    function GetMyActions : TActionList;
    function GetMyCategories : TStrings;

    property ActionCategories : TStrings read GetMyCategories;
  public

    class function GetNodeObject(Node : TTreeNode) : TDBNodeObject;overload;

    /// Создаёт экземпляр класса
    /// Node - узел дерева, с которым связан экземпляр
    /// TreeView - дерево, с которым связан экземпляр
    /// TerminalNode - истина, если узул является терминальным в дереве
    constructor Create(Node:TTreeNode; TreeView:TDBTreeView; TerminalNode:Boolean); virtual;
    destructor Destroy; override;

    function AddChildNodes: Boolean;
    function ToString : String;

    procedure AddExecute(Sender:TObject); virtual;
    procedure CopyExecute(Sender:TObject); virtual;
    procedure CutExecute(Sender:TObject); virtual;
    procedure DeleteExecute(Sender:TObject); virtual;
    procedure PasteExecute(Sender:TObject); virtual;
    procedure Refresh;
    procedure Invalidate;
    procedure UpdateExecute(Sender:TObject); virtual;

    property CanAddExecute: Boolean read GetCanAddExecute;
    property CanCopyExecute: Boolean read GetCanCopyExecute;
    property CanCutExecute: Boolean read GetCanCutExecute;
    property CanDeleteExecute: Boolean read GetCanDeleteExecute;
    property CanPasteExecute: Boolean read GetCanPasteExecute;
    property CanUpdateExecute: Boolean read GetCanUpdateExecute;
    property DataSet: TDataSet read FDataSet write FDataSet;
    property Font: TFont read FFont write SetFont;
    property ID: Integer read FID write FID;
    property Name: string read FName write FName;
    property Node: TTreeNode read FNode write FNode;
    property NodeActionCaption[NodeAction:TNodeAction]: string read
            GetNodeActionCaption;
    property Parent: TDBNodeObject read FParent write FParent;
    property TreeView: TDBTreeView read FTreeView write FTreeView;
    property Value: Variant read FValue write FValue;
    property IsTerminal : Boolean read FTerminal;
    property AssosiatedClass : TClass read FAssosiatedClass write FAssosiatedClass;
    property NodeActions : TActionObjectList read GetNodeActions;
    property Filter : TNodeFilterFunc read FFilter write SetFiltered;
    property NodeObjects : TDBNodeObjectList read GetNodeObjects;
    property PopupMenu : TPopupMenu read GetPopupMenu;
    property Logger : ILogger read GetLogger;
    property LazyLoad : Boolean read FLazyLoaded write FLazyLoaded;
  end;

  TDBNodeObjectList = class(TObjectList)
  private
    function GetItems(Index: integer): TDBNodeObject;
  public
    property    Items[Index: integer]: TDBNodeObject read GetItems;
    constructor Create;
  end;
  

  // Событие до вызова AddChildNodes
  TBeforeAddChildEvent = procedure (Sender : TDBNodeObject; var Allow:Boolean) of
          object;
  // Событие после вызова AddChildNodes
  TAfterAddChildEvent = procedure (Sender:TDBNodeObject) of object;

  TDBActionsDictionaryItem = class
  private
    FActionObjectList: TActionObjectList;
    FNodeClass: TDBNodeClass;
  public
    property NodeClass: TDBNodeClass read FNodeClass write FNodeClass;
    property ActionObjectList: TActionObjectList read FActionObjectList write FActionObjectList;
  end;

  TDBActionsDictionary = class(TObjectList)
  private
    FActionsDictionary: TDBActionsDictionary;
    constructor Create;
    function GetItemsByIndex(Index: integer): TDBActionsDictionaryItem;
  public
    class function GetInstance : TDBActionsDictionary;
    destructor Destroy;override;

    function ContainsKey(Key : TDBNodeClass): boolean;
    function GetItem(Key : TDBNodeClass): TActionObjectList;
    function Add(Key: TDBNodeClass; AActionList: TActionObjectList): TDBActionsDictionaryItem;

    property ItemsByIndex[Index: integer]: TDBActionsDictionaryItem read GetItemsByIndex;
    property Items[Key : TDBNodeClass] : TActionObjectList read GetItem; default;
  end;

  ///
  ///  Базовый класс деревьев, поддерживающих
  ///  узлы, сопоставленные с типом TDBNodeObject
  ///  с загрузкой дочерних узлов в
  ///  режиме "по требованию"
  ///
  TDBTreeView = class (TTreeView)
  private
    FAfterAdd: TAfterAddChildEvent;
    FBeforeAdd: TBeforeAddChildEvent;
    FOnCanAddExecute: TCanActionEvent;
    FOnCanCopyExecute: TCanActionEvent;
    FOnCanCutExecute: TCanActionEvent;
    FOnCanDeleteExecute: TCanActionEvent;
    FOnCanPasteExecute: TCanActionEvent;
    FOnCanSelectAllExecute: TCanActionEvent;
    FOnCanUpdateExecute: TCanActionEvent;
    FLogger : ILogger;
    FSuspendDeletion : Boolean;

    //FNodeObjects : TObjectList<TDBNodeObject>;
    FActionList : TActionList;
    FOnActivate : TNotifyEvent;
    FActive : Boolean;
    procedure SetActive(Value : Boolean);
    function GetCanActionEvent(FEvent:TCanActionEvent; bCan:boolean): Boolean;
    function GetCanAdd: Boolean;
    function GetCanCopy: Boolean;
    function GetCanCut: Boolean;
    function GetCanDelete: Boolean;
    function GetCanPaste: Boolean;
    function GetCanSelectAll: Boolean;
    function GetCanUpdate: Boolean;
    function GetNodeActionCaption(NodeAction:TNodeAction): string;

    class function GetNodeActions(NodeClass : TDBNodeClass) : TActionObjectList;
    function GetMainOfSelectedObject: TDBNodeObject;

  protected
    function GetLogger : ILogger;
    procedure OnActivate;virtual;

    function CanExpand(Node: TTreeNode): Boolean; override;
    function GetObject: TDBNodeObject; virtual;
    function GetNodeObjects : TDBNodeObjectList;
    procedure Delete(Node: TTreeNode);override;
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy;override;

    procedure AddExecute(Sender:TObject); virtual;
    procedure CopyExecute(Sender:TObject); virtual;

    function CreateTreeNode(ParentNode:TTreeNode; Caption:String;
            TNodeClass:TDBNodeClass; TerminalNode:Boolean = false) : TTreeNode; overload;


    function GetNodeObject(Node:TTreeNode): TDBNodeObject; overload;
    function GetNodeObjectByName(AName: string; FirstNode: TTreeNode = nil; Expand: Boolean = false): TDBNodeObject; overload;

    procedure CutExecute(Sender:TObject); virtual;
    procedure DeleteExecute(Sender:TObject); virtual;
    procedure PasteExecute(Sender:TObject); virtual;
    procedure RefreshExecute(Sender:TObject); virtual;
    procedure SelectAllExecute(Sender:TObject); virtual;
    procedure UpdateExecute(Sender:TObject); virtual;

    procedure TryShowPopupMenuOnSelectedNode;
    procedure InvalidateRoots;

    property CanAdd: Boolean read GetCanAdd;
    property CanCopy: Boolean read GetCanCopy;
    property CanCut: Boolean read GetCanCut;
    property CanDelete: Boolean read GetCanDelete;
    property CanPaste: Boolean read GetCanPaste;
    property CanSelectAll: Boolean read GetCanSelectAll;
    property CanUpdate: Boolean read GetCanUpdate;
    property NodeActionCaption[NodeAction:TNodeAction]: string read
            GetNodeActionCaption;
    property NodeObject[Node:TTreeNode]: TDBNodeObject read GetNodeObject;
    property SelectedObject: TDBNodeObject read GetObject;
    property MainOfSelectedObject: TDBNodeObject read GetMainOfSelectedObject; 
    property NodeObjects : TDBNodeObjectList read GetNodeObjects;
    property ActionList : TActionList read FActionList write FActionList;
    property Active : Boolean read FActive write SetActive;
    property Logger : ILogger read GetLogger write FLogger;

    property SuspendDeletion : Boolean read FSuspendDeletion write FSuspendDeletion;

  published
    property OnAfterAddChild: TAfterAddChildEvent read FAfterAdd write
            FAfterAdd;
    property OnBeforeAddChild: TBeforeAddChildEvent read FBeforeAdd write
            FBeforeAdd;
    property OnCanAddExecute: TCanActionEvent read FOnCanAddExecute write
            FOnCanAddExecute;
    property OnCanCopyExecute: TCanActionEvent read FOnCanCopyExecute write
            FOnCanCopyExecute;
    property OnCanCutExecute: TCanActionEvent read FOnCanCutExecute write
            FOnCanCutExecute;
    property OnCanDeleteExecute: TCanActionEvent read FOnCanDeleteExecute write
            FOnCanDeleteExecute;
    property OnCanPasteExecute: TCanActionEvent read FOnCanPasteExecute write
            FOnCanPasteExecute;
    property OnCanSelectAllExecute: TCanActionEvent read FOnCanSelectAllExecute
            write FOnCanSelectAllExecute;
    property OnCanUpdateExecute: TCanActionEvent read FOnCanUpdateExecute write
            FOnCanUpdateExecute;
    property Activated : TNotifyEvent read FOnActivate write FOnActivate;

  end;
implementation

uses
  Controls, SysUtils, ExceptionExt, LoggerImpl;


///////////////////////////////////////////////////////////////////////////

{
********************************* TDBTreeView **********************************
}
constructor TDBTreeView.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  ChangeDelay := 0;
  ReadOnly:=true;
  FActive := false;
  //FNodeObjects := TObjectList<TDBNodeObject>.Create(true);
end;

procedure TDBTreeView.AddExecute(Sender:TObject);
begin
  if Selected <> nil then
    SelectedObject.AddExecute(Sender);
end;

function TDBTreeView.CanExpand(Node: TTreeNode): Boolean;
var
  Obj: TDBNodeObject;
  Allow: Boolean;
begin
  // Получаем ссылку на объект узла
  Obj:=TDBNodeObject(Node.Data);
  Cursor:=crHourGlass;
  // По умолчанию позволяем вызов функции AddChildNodes
  Allow:=true;
  try
    if Assigned(Obj) then
    begin
      // Событие до добавления
      if Assigned (FBeforeAdd) then FBeforeAdd(Obj, Allow);
      // Если позволено вызывать AddChildNodes
      if (Allow) then begin
        Obj.AddChildNodes;
        // Событие после добавления
        if Assigned (FAfterAdd) then FAfterAdd(Obj);
      end;
    end;
    Result:=inherited CanExpand(Node);
  finally
    Node.HasChildren:=(Node.Count >0);
    Cursor:=crDefault;
  end;
end;

procedure TDBTreeView.CopyExecute(Sender:TObject);
begin
  if Selected <> nil then
    SelectedObject.CopyExecute(Sender);
end;

function TDBTreeView.CreateTreeNode(ParentNode:TTreeNode; Caption:String;
        TNodeClass:TDBNodeClass; TerminalNode:Boolean): TTreeNode;
begin
  Assert(TNodeClass <> nil, 'TDBTreeView.CreateTreeNode: TNodeClass can not be null!');
  Result := Items.AddChild(ParentNode, Caption);
  Result.Data := TNodeClass.Create(Result, Self, TerminalNode);
  //TDBNodeObject(Result.Data)._AddRef;
end;


procedure TDBTreeView.CutExecute(Sender:TObject);
begin
  if Selected <> nil then
    SelectedObject.CutExecute(Sender);
end;

procedure TDBTreeView.Delete(Node: TTreeNode);
var
  NodeObj : TDBNodeObject;
begin
  if SuspendDeletion then Exit;

  if (Assigned(Node)) then
  begin
    NodeObj := TDBNodeObject(Node.Data);
    if Assigned(NodeObj) then
    begin
      Logger.LogMessage('Deleting ' + NodeObj.ClassName + ' of TreeNode ' + Node.Text);
      //NodeObj.Free;
      Node.Data := nil;
    end;
  end;
  inherited;
end;

procedure TDBTreeView.DeleteExecute(Sender:TObject);
begin
  if Selected <> nil then
    SelectedObject.DeleteExecute(Sender);
end;

destructor TDBTreeView.Destroy;
begin
  Logger.LogMessage(Self.ClassName + ' destructor called!');
  inherited;
end;

function TDBTreeView.GetCanActionEvent(FEvent:TCanActionEvent; bCan:boolean):
        Boolean;
begin
  if Assigned(FEvent) then FEvent(Self, bCan);
  Result:=bCan;
end;

function TDBTreeView.GetCanAdd: Boolean;
begin
  if Selected <> nil then Result:=SelectedObject.CanAddExecute
  else Result:=true;
  Result:=GetCanActionEvent(FOnCanAddExecute, Result);
end;
                                        function TDBTreeView.GetCanCopy: Boolean;
begin
  if Selected <> nil then Result:=SelectedObject.CanCopyExecute
  else Result:=true;
  Result:=GetCanActionEvent(FOnCanCopyExecute, Result);
end;

function TDBTreeView.GetCanCut: Boolean;
begin
  if Selected <> nil then Result:=SelectedObject.CanCutExecute
  else Result:=true;
  Result:=GetCanActionEvent(FOnCanCutExecute, Result);
end;

function TDBTreeView.GetCanDelete: Boolean;
begin
  if Selected <> nil then Result:=SelectedObject.CanDeleteExecute
  else Result:=true;
  Result:=GetCanActionEvent(FOnCanDeleteExecute, Result);
end;

function TDBTreeView.GetCanPaste: Boolean;
begin
  if Selected <> nil then Result:=SelectedObject.CanPasteExecute
  else Result:=true;
  Result:=GetCanActionEvent(FOnCanPasteExecute, Result);
end;

function TDBTreeView.GetCanSelectAll: Boolean;
begin
  Result:=Selected<>nil;
end;

function TDBTreeView.GetCanUpdate: Boolean;
begin
  if Selected <> nil then Result:=SelectedObject.CanUpdateExecute
  else Result:=true;
  Result:=GetCanActionEvent(FOnCanUpdateExecute, Result);
end;

function TDBTreeView.GetLogger: ILogger;
begin
  if FLogger = nil then FLogger := TNullLogger.GetInstance;
  Result := FLogger;
end;

function TDBTreeView.GetNodeActionCaption(NodeAction:TNodeAction): string;
begin
  if Assigned(Selected) then
    Result:=SelectedObject.NodeActionCaption[NodeAction]
  else Result:='';
end;

class function TDBTreeView.GetNodeActions(
  NodeClass: TDBNodeClass): TActionObjectList;
begin
  Result := TDBActionsDictionary.GetInstance[NodeClass];
end;

function TDBTreeView.GetNodeObject(Node:TTreeNode): TDBNodeObject;
begin
  Result:=nil;
  if Assigned(Node) then
    if Assigned(Node.Data) then Result:=TDBNodeObject(Node.Data);
end;



function TDBTreeView.GetNodeObjects: TDBNodeObjectList;
begin
  raise ENotImplemented.Create;
end;

function TDBTreeView.GetObject: TDBNodeObject;
begin
  Result:=nil;
  if Assigned(Selected) then
    if Assigned(Selected.Data) then
       Result:=TDBNodeObject(Selected.Data);
end;




procedure TDBTreeView.OnActivate;
begin
  if Assigned(FOnActivate) then
    FOnActivate(Self);
end;

procedure TDBTreeView.PasteExecute(Sender:TObject);
begin
  if Selected <> nil then
    SelectedObject.PasteExecute(Sender);
end;

procedure TDBTreeView.RefreshExecute(Sender:TObject);
var
  NodeObj: TDBNodeObject;
  NodeText: string;
  NodeIndex: Integer;
  Expanded: Boolean;
begin
  if Selected <> nil then
  begin
    // Запомним текст и индекс обновляемого узла
    NodeText:=Selected.Text;
    NodeIndex:=Selected.Index;

    // Определяем, что будет обновляемым узлом: текущий или родительский
    if (Selected.Expanded) or (Selected.Parent = nil) then
      NodeObj:=SelectedObject
    else
      NodeObj:=SelectedObject.Parent;

    // Запомним состояние узла до обновления
    Expanded:=NodeObj.Node.Expanded;
    NodeObj.Refresh;

    if Expanded then
    begin
      NodeObj.Node.Expand(false);
      // Переход к запомненному узлу (если он существует)
      if NodeObj.Node.Count > NodeIndex then
        if CompareStr(NodeObj.Node[NodeIndex].Text, NodeText) = 0 then
          NodeObj.Node[NodeIndex].Selected:=true;
    end;
  end;

end;

procedure TDBTreeView.InvalidateRoots;
var
  I: Integer;
  ListToInvalidate : TList;
begin
  ListToInvalidate := TList.Create;
  for I := 0 to Items.Count - 1 do
  begin
    if (Self.Items[I].Parent = nil) then
        ListToInvalidate.Add(Self.Items[I]);
  end;

  for I := 0 to ListToInvalidate.Count - 1 do
    GetNodeObject(TTreeNode(ListToInvalidate[I])).Invalidate;

end;

procedure TDBTreeView.SelectAllExecute(Sender:TObject);
var
  i: Integer;
  Node: TTreeNode;
begin
  if MultiSelect then
  begin
    if Selected <> nil then
    begin
      if Selected.Expanded then Node:=Selected
      else
        if Selected.Parent <> nil then
           Node:=Selected.Parent
        else
           Node:=nil;
        if Assigned(Node) then
        begin
          for i:=0 to Node.Count - 1 do
             Subselect(Node.Item[i]);
        end
        else
          for i:=0 to Items.Count - 1 do
             Subselect(Items[i]);
    end;
  end;
end;

procedure TDBTreeView.SetActive(Value: Boolean);
begin
  if (Value = FActive)then
    Exit;

  Self.Items.Clear;

  if Value then
    OnActivate;
  FActive := Value;
end;

procedure TDBTreeView.TryShowPopupMenuOnSelectedNode;
var
  PopupMenu : TPopupMenu;
  Point : TPoint;
begin
  if SelectedObject = nil then Exit;
  PopupMenu := SelectedObject.GetPopupMenu;
  if (PopupMenu <> nil) then
  begin
    Selected.MakeVisible;
    Point := Mouse.CursorPos;
    PopupMenu.Popup(Point.X, Point.Y);
  end;
end;

procedure TDBTreeView.UpdateExecute(Sender:TObject);
begin
  if Selected <> nil then
    SelectedObject.UpdateExecute(Sender);
end;

{
******************************** TDBNodeObject *********************************
}
procedure TDBNodeObject.CopyExecute(Sender: TObject);
begin

end;

constructor TDBNodeObject.Create(Node: TTreeNode; TreeView: TDBTreeView;
  TerminalNode: Boolean);
begin
  inherited Create;
  Assert(Assigned(Node), 'TDBNodeObject.Create: Node can not be null!');
  Assert(Assigned(TreeView), 'TDBNodeObject.Create: TreeView cant be null!');
  FID:=-1;
  FNode:=Node;
  FDataSet:=nil;
  FChildAdded:=false;
  FValue:=Unassigned;
  FFont:=TFont.Create;
  FTreeView:=TreeView;
  FName:=Node.Text;
  if Assigned(Node.Parent) then
    FParent:=TDBNodeObject(Node.Parent.Data);
  FTerminal := TerminalNode;
  Node.HasChildren := not TerminalNode;
  if not TerminalNode then
    TreeView.Items.AddChild(Node, 'Идет загрузка подчиненных узлов');
  FActionCatigories := TStringList.Create;
  Logger.LogMessage(Format('constructor %s.Create(Node=%s, TreeView=%s, TerminalNode=%s', [Self.ClassName, Node.Text, TreeView.Name, BoolToStr(TerminalNode)]));
end;

function TDBNodeObject.CreateTreeNode(Caption: String;
  TNodeClass: TDBNodeClass; TerminalNode : Boolean): TTreeNode;
begin
  Assert(TNodeClass <> nil, TDBNodeClass.ClassName + 'Can not be null!');
  Result := TreeView.CreateTreeNode(Self.Node, Caption, TNodeClass, TerminalNode);
end;


procedure TDBNodeObject.CutExecute(Sender: TObject);
begin

end;

destructor TDBNodeObject.Destroy;
begin
  Logger.LogMessage(Format('destructor %s.Destroy', [Self.ClassName]));
  FreeAndNil(FFont);
  FreeAndNil(FActionCatigories);
  inherited;
end;

function TDBNodeObject.AddChildNodes: Boolean;
begin
  Result := FChildAdded;
  if Result then Exit;
  FChildAdded := DoAddChildNodes;
  Result := FChildAdded;
end;

procedure TDBNodeObject.DeleteExecute(Sender:TObject);
begin
end;

function TDBNodeObject.DoCanAddExecute: Boolean;
begin
  Result:=true;
end;

function TDBNodeObject.DoCanCopyExecute: Boolean;
begin
  Result:=true;
end;

function TDBNodeObject.DoCanCutExecute: Boolean;
begin
  Result:=true;
end;

function TDBNodeObject.DoCanDeleteExecute: Boolean;
begin
  Result:=true;
end;

function TDBNodeObject.DoCanPasteExecute: Boolean;
begin
  Result:=true;
end;

function TDBNodeObject.DoCanUpdateExecute: Boolean;
begin
  Result:=true;
end;

{{
Возвращает символьные имена операций над узлом дерева.
--- Переопределите массив в производных классах ---
}
function TDBNodeObject.DoNodeActionCaption(NodeAction:TNodeAction): string;

  const
    NodeCaptionArray:array[Low(TNodeAction)..High(TNodeAction)] of string =
      ('Добавить объект', 'Удалить объект',
       'Редактировать объект', 'Копировать объект', 'Вырезать объект',
               'Вставить объект');

begin
  Result:=NodeCaptionArray[NodeAction];
end;

function TDBNodeObject.GetActionList: TActionList;
begin
  Result := nil;
end;

function TDBNodeObject.GetCanAddExecute: Boolean;
begin
  Result:=DoCanAddExecute;
end;

function TDBNodeObject.GetCanCopyExecute: Boolean;
begin
  Result:=DoCanCopyExecute;
end;

function TDBNodeObject.GetCanCutExecute: Boolean;
begin
  Result:=DoCanCutExecute;
end;

function TDBNodeObject.GetCanDeleteExecute: Boolean;
begin
  Result:=DoCanDeleteExecute;
end;

function TDBNodeObject.GetCanPasteExecute: Boolean;
begin
  Result:=DoCanPasteExecute;
end;

function TDBNodeObject.GetCanUpdateExecute: Boolean;
begin
  Result:=DoCanUpdateExecute;
end;

function TDBNodeObject.GetLogger: ILogger;
begin
  Assert(Assigned(TreeView), 'Объект TreeView не может быть null!');
  Result := TreeView.Logger;
end;

function TDBNodeObject.GetMyActions: TActionList;
begin
  Result := ActionList;
end;

function TDBNodeObject.GetMyCategories: TStrings;
begin
  Result := FActionCatigories;
end;

function TDBNodeObject.GetNodeActionCaption(NodeAction:TNodeAction): string;
begin
  Result:=DoNodeActionCaption(NodeAction);
end;

function TDBNodeObject.GetNodeActions: TActionObjectList;
begin
  Result := TDBTreeView.GetNodeActions(TDBNodeClass(Self.ClassType));
end;

class function TDBNodeObject.GetNodeObject(Node: TTreeNode): TDBNodeObject;
begin
  Assert(Node<>nil, 'TDBNodeObject.GetNodeObject: Node parameter can not be null!');
  Result := TDBNodeObject(Node.Data);
end;


function TDBNodeObject.GetNodeObjects: TDBNodeObjectList;
begin
  raise ENotImplemented.Create;
end;

function TDBNodeObject.GetPopupMenu: TPopupMenu;
begin
  Result := nil;
  if ActionList = nil then Exit;
  if not Assigned(FPopupMenu)
    then FPopupMenu := TPopupMenu.Create(TreeView);
  BuildPopupMenu;
  Result := FPopupMenu;
end;

procedure TDBNodeObject.Invalidate;
begin
  if Assigned(Node) then
  begin
    Node.DeleteChildren;
    if not IsTerminal then
      TreeView.Items.AddChild(Node, 'Идет загрузка');

    Node.Expanded := false;
  end;
  FChildAdded:=false;
end;

procedure TDBNodeObject.PasteExecute(Sender:TObject);
begin
end;

procedure TDBNodeObject.Refresh;
begin
  Invalidate;
  AddChildNodes;
end;

procedure TDBNodeObject.SetFiltered(Value: TNodeFilterFunc);
begin
  raise ENotImplemented.Create;
  //if Value = FFilter then Exit;
  FFilter := Value;
  Self.Refresh;
end;

procedure TDBNodeObject.SetFont(const Font: TFont);
begin
  if Assigned(FFont) then FFont.Assign(Font);
end;

function TDBNodeObject.ToString: String;
begin
  Result := Node.Text;
end;

procedure TDBNodeObject.UpdateExecute(Sender:TObject);
begin

end;

procedure TDBNodeObject.AddExecute(Sender: TObject);
begin

end;

procedure TDBNodeObject.BuildPopupMenu;
var
  MenuItem: TMenuItem;
  Action: TBasicAction;
  I: Integer;
begin
  FPopupMenu.Items.Clear;
  for I := 0 to ActionList.ActionCount - 1 do
  begin
    Action := nil;
    begin
      if Self.ActionCategories.IndexOf(ActionList[I].Category) > -1 then
        Action := ActionList[I];
    end;
    if Action <> nil then
    begin
      MenuItem := TMenuItem.Create(FPopupMenu);
      MenuItem.Action := Action;
      FPopupMenu.Items.Add(MenuItem);
    end;
  end;
end;

{ TDBActionsDictionary }

function TDBActionsDictionary.Add(Key: TDBNodeClass;
  AActionList: TActionObjectList): TDBActionsDictionaryItem;
begin
  Result := TDBActionsDictionaryItem.Create;
  Result.NodeClass := Key;
  Result.ActionObjectList := AActionList;

  inherited Add(Result);
end;

function TDBActionsDictionary.ContainsKey(Key: TDBNodeClass): boolean;
var i: integer;
begin
  Result := false;
  for i := 0 to Count - 1 do
  if ItemsByIndex[i].NodeClass = Key then
  begin
    Result := true;
    break;
  end;
end;

constructor TDBActionsDictionary.Create;
begin
  FActionsDictionary := TDBActionsDictionary.Create;
end;

destructor TDBActionsDictionary.Destroy;
begin
  FActionsDictionary.Free;
  inherited;
end;

class function TDBActionsDictionary.GetInstance: TDBActionsDictionary;
const
  inst : TDBActionsDictionary = nil;
begin
  if (inst = nil) then
    inst := TDBActionsDictionary.Create;
  Result := inst;
end;

function TDBActionsDictionary.GetItem(Key: TDBNodeClass): TActionObjectList;
begin
  if not FActionsDictionary.ContainsKey(Key) then
    FActionsDictionary.Add(Key, TActionObjectList.Create);
  Result := FActionsDictionary[Key];
end;

function TDBActionsDictionary.GetItemsByIndex(
  Index: integer): TDBActionsDictionaryItem;
begin
  Result := inherited Items[Index] as TDBActionsDictionaryItem;
end;

{ TActionObjectList }

constructor TActionObjectList.Create;
begin
  inherited Create(False);
end;

function TActionObjectList.GetItems(Index: integer): TAction;
begin
  Result := inherited Items[Index] as TAction;
end;

{ TDBNodeObjectList }

constructor TDBNodeObjectList.Create;
begin
  inherited Create(false); 
end;

function TDBNodeObjectList.GetItems(Index: integer): TDBNodeObject;
begin
  Result := TDBNodeObject(inherited Items[Index]);
end;

function TDBNodeObject.DoAddChildNodes: Boolean;
begin
  Result := true;
  Self.Node.DeleteChildren;
end;

function TDBTreeView.GetNodeObjectByName(AName: string; FirstNode: TTreeNode = nil; Expand: Boolean = false): TDBNodeObject;
var Node: TTreeNode;
begin
  Result := nil;

  if not Assigned(FirstNode) then
    Node := Items.GetFirstNode
  else
    Node := FirstNode;
    
  while Assigned(Node) do
  begin
    if trim(Node.Text) = AName then
    begin
      Result := TDBNodeObject(Node.Data);
      break;
    end;

    if Expand then Node.Expand(false);
    Node := Node.GetNext;
  end;
end;

function TDBTreeView.GetMainOfSelectedObject: TDBNodeObject;
var Node, NodeParent: TTreeNode;
begin
  Node := SelectedObject.Node;
  while Assigned(Node) do
  begin
    NodeParent := Node;
    Node := Node.Parent;
  end;

  Result := TDBNodeObject(NodeParent.Data);
end;

end.


