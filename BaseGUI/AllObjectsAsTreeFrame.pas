unit AllObjectsAsTreeFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Material, ComCtrls, Menus, ImgList, ActnList, StdCtrls;

type
  TfrmAllObjectsTree = class(TFrame)
    GroupBox2: TGroupBox;
    cbbLst: TComboBox;
    actnListForTree: TActionList;
    actnDelDocType: TAction;
    actnDelDocTypeWithChild: TAction;
    actnSelectObject: TAction;
    imgList: TImageList;
    pmTree: TPopupMenu;
    N4: TMenuItem;
    N2: TMenuItem;
    N1: TMenuItem;
    N3: TMenuItem;
    GroupBox1: TGroupBox;
    tvList: TTreeView;
    procedure tvListExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure tvListExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvListClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses Facade;

{$R *.dfm}

{ TfrmAllObjectsTree }

constructor TfrmAllObjectsTree.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TfrmAllObjectsTree.Destroy;
begin

  inherited;
end;

procedure TfrmAllObjectsTree.tvListExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
begin
  tvList.Selected := Node;
  (TMainFacade.GetInstance as TMainFacade).ActiveDocType := TDocumentType(Node.Data);

  if (TMainFacade.GetInstance as TMainFacade).ActiveDocType.SubDocTypes.Count > 0 then
   (TMainFacade.GetInstance as TMainFacade).ActiveDocType.SubDocTypes.MakeList(tvList, True, False)
  else Node.DeleteChildren;
end;

procedure TfrmAllObjectsTree.tvListExpanded(Sender: TObject;
  Node: TTreeNode);
begin
  if Node.Expanded then
    Node.Selected := true;
end;

procedure TfrmAllObjectsTree.tvListClick(Sender: TObject);
begin
  if Assigned (tvList.Selected) then
    (TMainFacade.GetInstance as TMainFacade).ActiveDocType := TDocumentType(tvList.Selected.Data);
end;

end.
