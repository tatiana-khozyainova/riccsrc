unit InfoWellsFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Well, Slotting, ImgList, CommonObjectSelectFilter,
  ToolWin, ActnList, ExtCtrls, CoreDescription,
  Menus;

type
  TfrmInfoWells = class(TFrame)
    tvwWells: TTreeView;
    imglst: TImageList;
    tbr: TToolBar;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    Panel1: TPanel;
    ToolButton10: TToolButton;
    actnLst: TActionList;
    actnAdd: TAction;
    actnEdit: TAction;
    actnDel: TAction;
    procedure tvwWellsGetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure tvwWellsGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure tvwWellsExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvwWellsExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure actnAddExecute(Sender: TObject);
    procedure actnEditExecute(Sender: TObject);
    procedure actnDelExecute(Sender: TObject);
    procedure tvwWellsClick(Sender: TObject);
    procedure tvwWellsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    function    GetActiveWell: TWell;
  public
    property    ActiveWell: TWell read GetActiveWell;

    procedure   Reload;
    procedure   SetIcons;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses Facade, CommCtrl, Math;

{$R *.dfm}

{ TfrmInfoWells }

constructor TfrmInfoWells.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TfrmInfoWells.Destroy;
begin

  inherited;
end;

procedure TfrmInfoWells.Reload;
begin

end;

procedure TfrmInfoWells.SetIcons;
var i : integer;
begin
  for i := 0 to tvwWells.Items.Count - 1 do
  if (tvwWells.Items.Item[i].Level = 1) and (tvwWells.Items.Item[i].Text = 'Долбления') then
    tvwWells.Items.Item[i].ImageIndex := 0;
end;

procedure TfrmInfoWells.SetNodeBoldState(Node: TTreeNode; Value: Boolean);

procedure TfrmInfoWells.tvwWellsGetSelectedIndex(Sender: TObject;
  Node: TTreeNode);
begin
  Node.SelectedIndex := Node.ImageIndex;
end;

procedure TfrmInfoWells.tvwWellsGetImageIndex(Sender: TObject;
  Node: TTreeNode);
begin
  case Node.Level of
    0: Node.ImageIndex := 5;
    else Node.ImageIndex := -1;
  end;
end;

procedure TfrmInfoWells.tvwWellsExpanded(Sender: TObject;
  Node: TTreeNode);
begin
  if Node.Expanded then
    Node.Selected := true;
end;

procedure TfrmInfoWells.tvwWellsExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
begin
  tvwWells.Selected := Node;

  if Node.HasChildren then
  if not Assigned (Node.GetFirstChild.Data) then
  case Node.Level of
  0 : begin
        (TMainFacade.GetInstance as TMainFacade).ActiveWell := nil;
        (TMainFacade.GetInstance as TMainFacade).ActiveWell := TWell(Node.Data);

        Node.DeleteChildren;
      end;
  1 : begin
        Node.DeleteChildren;
      end;
  end;
end;

procedure TfrmInfoWells.tvwWellsClick(Sender: TObject);
begin
  if tvwWells.Items.Count > 0 then
  if Assigned (tvwWells.Selected.Data) then
    (TMainFacade.GetInstance as TMainFacade).ActiveWell := TObject(tvwWells.Selected.Data) as TWell;
end;

function TfrmInfoWells.GetActiveWell: TWell;
begin
  Result := nil;
end;

procedure TfrmInfoWells.actnAddExecute(Sender: TObject);
begin
  if Assigned(ActiveWell) then
  begin

  end
  else MessageBox(0, 'Не указана площадь.', 'Ошибка', MB_APPLMODAL + MB_OK + MB_ICONSTOP);
end;

procedure TfrmInfoWells.actnEditExecute(Sender: TObject);
begin
  if Assigned (ActiveWell) then
  begin

  end
  else MessageBox(0, 'Скважина не выбрана.', 'Ошибка', MB_APPLMODAL + MB_OK + MB_ICONSTOP);
end;

procedure TfrmInfoWells.actnDelExecute(Sender: TObject);
begin
  if Assigned (ActiveWell) then
  if MessageBox(0, 'Вы действительно хотите удалить выбранную скважину?', 'Вопрос', MB_APPLMODAL + MB_YESNO + MB_ICONQUESTION) = ID_YES then
  begin


    ShowMessage('Скважина удалена.');
  end
  else MessageBox(0, 'Скважина не выбрана.', 'Ошибка', MB_APPLMODAL + MB_OK + MB_ICONSTOP);
end;

procedure TfrmInfoWells.tvwWellsKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Ord(Key) = 40) or (Ord(Key) = 38) then
    tvwWellsClick(Sender);
end;

end.
