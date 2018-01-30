 {#Author fmarakasov@ugtu.net}
unit UIActions;

interface

uses
  SysUtils, Classes, DBClientActns, DBActns, BandActn, ExtActns, StdActns,
  ListActns, ActnList, ImgList, Controls;

const
   TREEVIEW_CATEGORY = 'Дерево объектов';
   PLAN_CATEGORY = 'Дерево объектов';

type
  TUIActionsModule = class(TDataModule)
    MainActionList: TActionList;
    aExpand: TAction;
    aCollapse: TAction;
    aRefresh: TAction;
    MainImageList: TImageList;
    procedure aExpandExecute(Sender: TObject);
    procedure aCollapseExecute(Sender: TObject);
    procedure aRefreshExecute(Sender: TObject);
    procedure aNewMNPlanExecute(Sender: TObject);
  public
   { Public declarations }
    constructor Create(AOwner : TComponent);override;
    class function GetInstance: TUIActionsModule;
  end;

var
  UIActionsModule: TUIActionsModule;

implementation

uses Forms, ExceptionExt, Facade;

{$R *.dfm}
procedure TUIActionsModule.aCollapseExecute(Sender: TObject);
begin
  if Assigned((TMainFacade.GetInstance as TMainFacade).MainTreeFrame.CurrentNode) then
  (TMainFacade.GetInstance as TMainFacade).MainTreeFrame.CurrentNode.Node.Collapse(true);
end;

procedure TUIActionsModule.aExpandExecute(Sender: TObject);
begin
  if Assigned((TMainFacade.GetInstance as TMainFacade).MainTreeFrame.CurrentNode) then
    (TMainFacade.GetInstance as TMainFacade).MainTreeFrame.CurrentNode.Node.Expand(true);
end;

procedure TUIActionsModule.aNewMNPlanExecute(Sender: TObject);
begin
  TExceptionsFactory.RaiseNotImplemented;
end;

procedure TUIActionsModule.aRefreshExecute(Sender: TObject);
begin
  if Assigned((TMainFacade.GetInstance as TMainFacade).MainTreeFrame.CurrentNode) then
  begin
    (TMainFacade.GetInstance as TMainFacade).MainTreeFrame.CurrentNode.TreeView.SuspendDeletion := false;
    try
      (TMainFacade.GetInstance as TMainFacade).MainTreeFrame.CurrentNode.Refresh;
    finally
      (TMainFacade.GetInstance as TMainFacade).MainTreeFrame.CurrentNode.TreeView.SuspendDeletion := true;
    end;
  end;
end;

constructor TUIActionsModule.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
end;

class function TUIActionsModule.GetInstance: TUIActionsModule;
const FInstance: TUIActionsModule = nil;
begin
  If FInstance = nil Then
  begin
    FInstance := UIActions.TUIActionsModule.Create(nil);
  end;
  Result := FInstance;
end;

initialization
   UIActionsModule := TUIActionsModule.GetInstance();
end.
