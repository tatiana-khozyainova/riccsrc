unit UniButtonsFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ToolWin, ComCtrls, BaseGUI, ActnList, Menus, StdCtrls;

type
  TfrmButtons = class(TFrame)
    tlbr: TToolBar;
    imgList: TImageList;
    actnLst: TActionList;
    actnSave: TAction;
    actnClear: TAction;
    actnReload: TAction;
    actnAutoSave: TAction;
    btnSave: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    actnAdd: TAction;
    actnDelete: TAction;
    btnAdd: TToolButton;
    ToolButton6: TToolButton;
    actnFind: TAction;
    ToolButton7: TToolButton;
    actnSort: TAction;
    ToolButton8: TToolButton;
    pmnSort: TPopupMenu;
    ToolButton9: TToolButton;
    actnSelectAll: TAction;
    actnAddGroup: TAction;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    actnEdit: TAction;
    actnCancel: TAction;
    btnCancel: TToolButton;
    procedure actnAutoSaveExecute(Sender: TObject);
    procedure actnAutoSaveUpdate(Sender: TObject);
    procedure actnSaveExecute(Sender: TObject);
    procedure actnSaveUpdate(Sender: TObject);
    procedure actnClearExecute(Sender: TObject);
    procedure actnClearUpdate(Sender: TObject);
    procedure actnReloadExecute(Sender: TObject);
    procedure actnReloadUpdate(Sender: TObject);
    procedure actnAddExecute(Sender: TObject);
    procedure actnDeleteExecute(Sender: TObject);
    procedure actnAddUpdate(Sender: TObject);
    procedure actnDeleteUpdate(Sender: TObject);
    procedure actnFindExecute(Sender: TObject);
    procedure actnFindUpdate(Sender: TObject);
    procedure pmiNameClick(Sender: TObject);
    procedure actnSortExecute(Sender: TObject);
    procedure actnSelectAllExecute(Sender: TObject);
    procedure actnSelectAllUpdate(Sender: TObject);
    procedure actnAddGroupExecute(Sender: TObject);
    procedure actnAddGroupUpdate(Sender: TObject);
    procedure actnEditExecute(Sender: TObject);
    procedure actnEditUpdate(Sender: TObject);
    procedure actnSortUpdate(Sender: TObject);
    procedure actnCancelExecute(Sender: TObject);
    procedure actnCancelUpdate(Sender: TObject);
  private
    { Private declarations }
    FGUIAdapter: TGUIAdapter;
    procedure SetGUIAdapter(const Value: TGUIAdapter);
  public
    { Public declarations }
    property GUIAdapter: TGUIAdapter read FGUIAdapter write SetGUIAdapter;
  end;

implementation

{$R *.dfm}

{ TfrmButtons }

procedure TfrmButtons.SetGUIAdapter(const Value: TGUIAdapter);
var i: integer;
    pmi: TMenuItem;
begin
  if FGUIAdapter <> Value then
  begin
    FGUIAdapter := Value;

    actnSave.Visible := abSave in GUIAdapter.Buttons;
    actnAutoSave.Visible := abAutoSave in GUIAdapter.Buttons;
    actnClear.Visible := abClear in GUIAdapter.Buttons;
    actnReload.Visible := abReload in GUIAdapter.Buttons;
    actnAdd.Visible := abAdd in GUIAdapter.Buttons;
    actnDelete.Visible := abDelete in GUIAdapter.Buttons;
    actnFind.Visible := abFind in GUIAdapter.Buttons;
    actnSort.Visible := abSort in GUIAdapter.Buttons;
    actnSelectAll.Visible := abSelectAll in GUIAdapter.Buttons;
    actnAddGroup.Visible := abAddGroup in GUIAdapter.Buttons;
    actnEdit.Visible := abEdit in GUIAdapter.Buttons;
    actnCancel.Visible := abCancel in GUIAdapter.Buttons;


    if FGUIAdapter is TCollectionGUIAdapter then
    with FGUIAdapter as TCollectionGUIAdapter do
    begin
      for i := 0 to SortOrders.Count - 1 do
      begin
        pmi := TMenuItem.Create(pmnSort);
        pmnSort.Items.Add(pmi);
        pmi.Caption := SortOrders.Items[i].Name;
        pmi.Tag := i;
        pmi.OnClick := pmiNameClick;
        pmi.ImageIndex := 8;
        pmi.RadioItem := true;
        pmi.GroupIndex := 1;
      end;
    end;
  end;
end;

procedure TfrmButtons.actnAutoSaveExecute(Sender: TObject);
begin
  actnAutoSave.Checked := not actnAutoSave.Checked;
  GUIAdapter.AutoSave := actnAutoSave.Checked;
end;

procedure TfrmButtons.actnAutoSaveUpdate(Sender: TObject);
begin
  actnAutoSave.Enabled := Assigned(GUIAdapter);
end;

procedure TfrmButtons.actnSaveExecute(Sender: TObject);
begin
  GUIAdapter.Save;
end;

procedure TfrmButtons.actnSaveUpdate(Sender: TObject);
begin
  actnSave.Enabled := Assigned(GUIAdapter) and GUIAdapter.CanSave;
end;

procedure TfrmButtons.actnClearExecute(Sender: TObject);
begin
  GUIAdapter.Clear;
end;

procedure TfrmButtons.actnClearUpdate(Sender: TObject);
begin
  actnClear.Enabled := Assigned(GUIAdapter) and GUIAdapter.CanClear;
end;

procedure TfrmButtons.actnReloadExecute(Sender: TObject);
begin
  GUIAdapter.Reload;
end;

procedure TfrmButtons.actnReloadUpdate(Sender: TObject);
begin
  actnReload.Enabled := Assigned(GUIAdapter) and GUIAdapter.CanReload;
end;

procedure TfrmButtons.actnAddExecute(Sender: TObject);
begin
  GUIAdapter.Add;
end;

procedure TfrmButtons.actnDeleteExecute(Sender: TObject);
begin
  GUIAdapter.Delete;
end;

procedure TfrmButtons.actnAddUpdate(Sender: TObject);
begin
  actnAdd.Enabled := Assigned(GUIAdapter) and GUIAdapter.CanAdd;
end;

procedure TfrmButtons.actnDeleteUpdate(Sender: TObject);
begin
  actnDelete.Enabled := Assigned(GUIAdapter) and GUIAdapter.CanDelete;
end;

procedure TfrmButtons.actnFindExecute(Sender: TObject);
begin
  GUIAdapter.StartFind;
end;

procedure TfrmButtons.actnFindUpdate(Sender: TObject);
begin
  actnFind.Enabled := Assigned(GUIAdapter) and GuiAdapter.CanFind;
end;

procedure TfrmButtons.pmiNameClick(Sender: TObject);
var bOrder: boolean;
    pmi: TMenuItem;
begin
  if GUIAdapter is TCollectionGUIAdapter then
  begin
    pmi := Sender as TMenuItem;
    bOrder := pmi.ImageIndex = 9;
    if GUIAdapter is TCollectionGUIAdapter then
    with GUIAdapter as TCollectionGUIAdapter do
    begin
      OrderBy := pmi.Tag;
      StraightOrder := bOrder;
    end;
    GUIAdapter.Reload;

    if bOrder then pmi.ImageIndex := 8
    else pmi.ImageIndex := 9;

    pmi.Checked := true;
  end;
end;

procedure TfrmButtons.actnSortExecute(Sender: TObject);
begin
  actnSort.Enabled := Assigned (GUIAdapter);
end;

procedure TfrmButtons.actnSelectAllExecute(Sender: TObject);
begin
  GUIAdapter.SelectAll;
end;

procedure TfrmButtons.actnSelectAllUpdate(Sender: TObject);
begin
  actnSelectAll.Enabled := Assigned (GUIAdapter);
end;

procedure TfrmButtons.actnAddGroupExecute(Sender: TObject);
begin
  GUIAdapter.AddGroup;
end;

procedure TfrmButtons.actnAddGroupUpdate(Sender: TObject);
begin
  actnAddGroup.Enabled := Assigned(GUIAdapter) and GUIAdapter.CanAddGroup;
end;

procedure TfrmButtons.actnEditExecute(Sender: TObject);
begin
  GUIAdapter.Edit;
end;

procedure TfrmButtons.actnEditUpdate(Sender: TObject);
begin
  actnEdit.Enabled := Assigned(GUIAdapter) and GUIAdapter.CanEdit;
end;

procedure TfrmButtons.actnSortUpdate(Sender: TObject);
begin
 actnSort.Enabled := Assigned(GUIAdapter) and (GUIAdapter is TCollectionGUIAdapter) and (GUIAdapter as TCollectionGUIAdapter).CanSort;
end;

procedure TfrmButtons.actnCancelExecute(Sender: TObject);
begin
  GUIAdapter.Cancel;
end;

procedure TfrmButtons.actnCancelUpdate(Sender: TObject);
begin
  actnCancel.Enabled := GUIAdapter.CanCancel;
end;

end.
