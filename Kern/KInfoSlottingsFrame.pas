unit KInfoSlottingsFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Well, Slotting, ImgList, CommonObjectSelectFilter,
  ToolWin, ActnList, KDescriptionKernFrame, ExtCtrls, CoreDescription,
  Menus;

type
  TfrmInfoSlottings = class(TFrame)
    tvwWells: TTreeView;
    imglst: TImageList;
    actnList: TActionList;
    actnAddDescription: TAction;
    actnEditDescription: TAction;
    actnDelDescription: TAction;
    actnLookDescription: TAction;
    actnFind: TAction;
    tb: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton7: TToolButton;
    tbSlloting: TToolBar;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    Panel1: TPanel;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    pm: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    actnAddLayer: TAction;
    actnDelLayer: TAction;
    actnEditLayer: TAction;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    procedure tvwWellsGetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure tvwWellsGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure tvwWellsCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure actnAddDescriptionExecute(Sender: TObject);
    procedure tvwWellsExpanded(Sender: TObject; Node: TTreeNode);
    procedure actnDelDescriptionExecute(Sender: TObject);
    procedure actnEditDescriptionExecute(Sender: TObject);
    procedure tvwWellsExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure actnAddLayerExecute(Sender: TObject);
    procedure tvwWellsClick(Sender: TObject);
    procedure tvwWellsDblClick(Sender: TObject);
  private
    FActiveLayer: TDescriptedLayer;

    procedure   SetNodeBoldState(Node: TTreeNode; Value: Boolean);
    function    GetActiveSlotting: TSlotting;
  public
    property    ActiveSlotting: TSlotting read GetActiveSlotting;
    property    ActiveLayer: TDescriptedLayer read FActiveLayer write FActiveLayer;

    procedure   Reload;
    procedure   SetIcons;
    procedure   SetActions(Value: boolean);

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses Facade, CommCtrl, KDescription, Math;

{$R *.dfm}

{ TfrmInfoWells }

constructor TfrmInfoSlottings.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TfrmInfoSlottings.Destroy;
begin

  inherited;
end;

procedure TfrmInfoSlottings.Reload;
begin

end;

procedure TfrmInfoSlottings.SetIcons;
var i : integer;
begin
  for i := 0 to tvwWells.Items.Count - 1 do
  if (tvwWells.Items.Item[i].Level = 1) and (tvwWells.Items.Item[i].Text = 'Долбления') then
    tvwWells.Items.Item[i].ImageIndex := 0;
end;

procedure TfrmInfoSlottings.SetNodeBoldState(Node: TTreeNode; Value: Boolean);
var TVItem: TTVItem;
begin
  if not Assigned(Node) then Exit;
  with TVItem do
  begin
    mask := TVIF_STATE or TVIF_HANDLE;
    hItem := Node.ItemId;
    stateMask := TVIS_BOLD;
    if Value then state := TVIS_BOLD else state := 0;
    TreeView_SetItem(Node.Handle, TVItem);
  end;
end;

procedure TfrmInfoSlottings.tvwWellsGetSelectedIndex(Sender: TObject;
  Node: TTreeNode);
begin
  Node.SelectedIndex := Node.ImageIndex;
end;

procedure TfrmInfoSlottings.tvwWellsGetImageIndex(Sender: TObject;
  Node: TTreeNode);
begin
  case Node.Level of
    0: Node.ImageIndex := 5;
    1: Node.ImageIndex := 7;
    //2: Node.ImageIndex := 7
    else Node.ImageIndex := -1;
  end;
end;

procedure TfrmInfoSlottings.tvwWellsCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
var i: integer;
begin
  with tvwWells do
  for i := 0 to Items.Count - 1 do
  case Items.Item[i].Level of
    0 : SetNodeBoldState(Items[i], True);
    1 : begin
          if Assigned (TSlotting(Items.Item[i].Data)) then
          if (TSlotting(Items.Item[i].Data)).TrueDescription then SetNodeBoldState(Items[i], True)
          else SetNodeBoldState(Items[i], false)
          else SetNodeBoldState(Items[i], false);
        end;
    2 : begin
          if Assigned (TSlotting(Items.Item[i].Parent.Data)) then
          if (TSlotting(Items.Item[i].Parent.Data)).TrueDescription then SetNodeBoldState(Items[i], True)
          else SetNodeBoldState(Items[i], false)
          else SetNodeBoldState(Items[i], false);
        end;
  end;
end;

procedure TfrmInfoSlottings.actnAddDescriptionExecute(Sender: TObject);
begin
  if Assigned(ActiveSlotting) then
  begin
    frmDescription := TfrmDescription.Create(Self);

    with frmDescription.frmDescriptionKern do
    begin
      ActiveObject.Slotting := Self.ActiveSlotting;
      ActiveObject.Clear;
      Clear;
    end;

    frmDescription.Reload;
    frmDescription.ShowModal;

    if Assigned(ActiveLayer.Description) then
    begin
      ActiveSlotting.TrueDescription := true;
      tvwWells.Repaint;
    end;

    frmDescription.Free;
  end
  else MessageBox(0, 'Не выбрано долбление!', 'Ошибка', MB_APPLMODAL + MB_OK + MB_ICONSTOP);
end;

procedure TfrmInfoSlottings.tvwWellsExpanded(Sender: TObject;
  Node: TTreeNode);
begin
  if Node.Expanded then
    Node.Selected := true;
end;

procedure TfrmInfoSlottings.actnDelDescriptionExecute(Sender: TObject);
var i: Integer;
    Node, NodeChild: TTreeNode;
begin
  // удалить описание
  if Assigned (ActiveSlotting) then
  if Assigned (ActiveLayer) then
    begin
    if MessageBox(0, 'Вы действительно хотите удалить выбранный слой с описанием керна ?', 'Вопрос', MB_APPLMODAL + MB_YESNO + MB_ICONQUESTION) = ID_YES then
    begin
      if Assigned (ActiveLayer.Description) then
      if ActiveLayer.Description.ID = 0 then
      begin
        ActiveLayer.ClearDescription;
        ActiveLayer.Description.Reload;
      end;

      ActiveSlotting.LayerSlottings.Remove(ActiveLayer);

      if ActiveSlotting.LayerSlottings.Count = 0 then
        ActiveSlotting.TrueDescription := false;

      tvwWells.Repaint;

      Node := tvwWells.Selected.Parent;
      NodeChild := Node.getFirstChild;

      for i := 1 to Node.Count - 1 do
      begin
        NodeChild := Node.GetNextChild(NodeChild);

        if i = Node.Count - 1 then
          NodeChild.Delete;
      end;

      ShowMessage('Слой и описание удалены.');
    end
  end
  else MessageBox(0, 'Выберите слой!', 'Ошибка', MB_APPLMODAL + MB_OK + MB_ICONSTOP)
  else MessageBox(0, 'Выберите слой!', 'Ошибка', MB_APPLMODAL + MB_OK + MB_ICONSTOP);
end;

procedure TfrmInfoSlottings.actnEditDescriptionExecute(Sender: TObject);
begin
  // редактировать описание
  if Assigned (ActiveSlotting) then
  if Assigned(ActiveLayer) then
  if Assigned(ActiveLayer.Description) then
  begin
    frmDescription := TfrmDescription.Create(Self);

    frmDescription.ActiveLayer := ActiveLayer;
    frmDescription.Reload;
    frmDescription.ShowModal;

    frmDescription.Free;
  end
  else MessageBox(0, 'По выбранному долблению нет описаний керна', 'Сообщение', MB_APPLMODAL + MB_OK + MB_ICONINFORMATION)
  else MessageBox(0, 'Выберите слой!', 'Ошибка', MB_APPLMODAL + MB_OK + MB_ICONSTOP)
  else MessageBox(0, 'Выберите слой!', 'Ошибка', MB_APPLMODAL + MB_OK + MB_ICONSTOP);
end;

procedure TfrmInfoSlottings.SetActions(Value: boolean);
begin
  actnAddDescription.Enabled := not Value;
  actnEditDescription.Enabled := Value;
  actnDelDescription.Enabled := Value;
  actnLookDescription.Enabled := Value;
  actnFind.Enabled := Value;
end;

procedure TfrmInfoSlottings.tvwWellsExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
begin
  tvwWells.Selected := Node;

  if Node.HasChildren then
  if not Assigned (Node.GetFirstChild.Data) then
  case Node.Level of
  0 : begin
        (TMainFacade.GetInstance as TMainFacade).ActiveWell := nil;
        (TMainFacade.GetInstance as TMainFacade).ActiveWell := TDescriptedWell(Node.Data);
        (TMainFacade.GetInstance as TMainFacade).ActiveWell.Slottings.MakeList(Node, true, true);
      end;
  1 : begin
        (TMainFacade.GetInstance as TMainFacade).ActiveSlotting := nil;
        (TMainFacade.GetInstance as TMainFacade).ActiveSlotting := TSlotting(Node.Data);
        (TMainFacade.GetInstance as TMainFacade).ActiveSlotting.LayerSlottings.MakeList(Node, true, true);
      end;
  2 : begin
        Node.DeleteChildren;
      end;
  end;
end;

function TfrmInfoSlottings.GetActiveSlotting: TSlotting;
begin
  Result := nil;

  case tvwWells.Selected.Level of
    1 : begin
          (TMainFacade.GetInstance as TMainFacade).ActiveWell := TDescriptedWell(tvwWells.Selected.Parent.Data);
          (TMainFacade.GetInstance as TMainFacade).ActiveSlotting := TSlotting(tvwWells.Selected.Data);

          Result := TSlotting(tvwWells.Selected.Data);
        end;
    2 : begin
          (TMainFacade.GetInstance as TMainFacade).ActiveWell := TDescriptedWell(tvwWells.Selected.Parent.Parent.Data);
          (TMainFacade.GetInstance as TMainFacade).ActiveSlotting := TSlotting(tvwWells.Selected.Parent.Data);

          Result := TSlotting(tvwWells.Selected.Parent.Data);
        end;
  end;

  if Assigned (Result) then
  if Result.TrueDescription then SetActions(true)
  else SetActions(false);
end;

procedure TfrmInfoSlottings.actnAddLayerExecute(Sender: TObject);
var Layer: TDescriptedLayer;
begin
  // добавляем слой
  if Assigned (ActiveSlotting) then
  begin
    // форма с описанием
    frmDescription := TfrmDescription.Create(Self);
    // объект нового слоя
    Layer := TDescriptedLayer.Create(ActiveSlotting.LayerSlottings);
    Layer.Name := FloatToStr((ActiveSlotting.LayerSlottings as TDescriptedLayers).GetNextNumber);

    frmDescription.ActiveLayer := Layer;

    frmDescription.ActiveLayer.Description := TDescription.Create(frmDescription.ActiveLayer.Descriptions);
    frmDescription.ActiveLayer.Description.LayerSlotting := frmDescription.ActiveLayer;

    frmDescription.Reload;
    frmDescription.ShowModal;

    ActiveLayer := frmDescription.ActiveLayer;

    if Assigned(ActiveLayer.Description) then
    begin
      ActiveSlotting.TrueDescription := true;
      tvwWells.Repaint;
    end;

    frmDescription.Free;

    ActiveLayer.ClearDescription;
  end
  else MessageBox(0, 'Выберите долбление.', 'Ошибка', MB_OK + MB_ICONERROR + MB_APPLMODAL);
end;

procedure TfrmInfoSlottings.tvwWellsClick(Sender: TObject);
begin
  if tvwWells.Items.Count > 0 then
  if tvwWells.Selected.Level = 2 then
  begin
    if Assigned (tvwWells.Selected.Data) then
      ActiveLayer := TObject(tvwWells.Selected.Data) as TDescriptedLayer;
  end
  else
  begin
    if tvwWells.Selected.Level = 1 then
    if Assigned (tvwWells.Selected.Data) then
    if ActiveSlotting.LayerSlottings.Count > 0 then
      ActiveLayer := ActiveSlotting.LayerSlottings.Items[0] as TDescriptedLayer;
  end;
end;

procedure TfrmInfoSlottings.tvwWellsDblClick(Sender: TObject);
begin
  actnEditDescription.Execute;
end;

end.

