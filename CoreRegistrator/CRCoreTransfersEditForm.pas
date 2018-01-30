unit CRCoreTransfersEditForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonObjectSelector, BaseObjects, StdCtrls, ToolWin, ComCtrls,
  ExtCtrls, CommonFrame, CRCoreTransferEditFrame, ActnList;

type
  TfrmCoreTransfersEditForm = class(TForm, IObjectSelector)
    gbxTransfers: TGroupBox;
    pnlButtons: TPanel;
    lbxTransfers: TListBox;
    tlbrEditTransfers: TToolBar;
    btnOK: TButton;
    btnCancel: TButton;
    spl1: TSplitter;
    frmCoreTransferEdit1: TfrmCoreTransferEdit;
    actnlstTransfersEdit: TActionList;
    actnAddTransfer: TAction;
    actnEditTransfer: TAction;
    actnDeleteTransfer: TAction;
    btnAdd: TToolButton;
    btnEditTransfer: TToolButton;
    btnDelete: TToolButton;
    actnApply: TAction;
    actnCancel: TAction;
    btnApply: TToolButton;
    btnCancelEdit: TToolButton;
    procedure lbxTransfersClick(Sender: TObject);
    procedure actnAddTransferExecute(Sender: TObject);
    procedure actnAddTransferUpdate(Sender: TObject);
    procedure actnEditTransferUpdate(Sender: TObject);
    procedure actnDeleteTransferUpdate(Sender: TObject);
    procedure actnApplyUpdate(Sender: TObject);
    procedure actnCancelUpdate(Sender: TObject);
    procedure actnApplyExecute(Sender: TObject);
    procedure actnCancelExecute(Sender: TObject);
    procedure actnEditTransferExecute(Sender: TObject);
    procedure actnDeleteTransferExecute(Sender: TObject);
  private
    FSelectOnly: boolean;
    FMultiSelect: boolean;
    FEditMode: boolean;
    procedure SetSelectOnly(const Value: boolean);
    procedure SetEditMode(const Value: boolean);
    { Private declarations }
  protected
    procedure SetSelectedObject(AValue: TIDObject);
    function  GetSelectedObject: TIDObject;
    procedure SetMultiSelect(const Value: boolean);
    function  GetMultiSelect: boolean;
    function  GetSelectedObjects: TIDObjects;
    procedure SetSelectedObjects(AValue: TIDObjects);
  public
    { Public declarations }
    property SelectOnly: boolean read FSelectOnly write SetSelectOnly;
    property MultiSelect: boolean read GetMultiSelect write SetMultiSelect;
    property SelectedObjects: TIDObjects read GetSelectedObjects write SetSelectedObjects;
    property SelectedObject: TIDObject read GetSelectedObject write SetSelectedObject;
    property EditMode: boolean read FEditMode write SetEditMode;

    procedure ReadSelectedObjects;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmCoreTransfersEditForm: TfrmCoreTransfersEditForm;

implementation

uses Facade, CoreTransfer;

{$R *.dfm}

{ TForm1 }

constructor TfrmCoreTransfersEditForm.Create(AOwner: TComponent);
begin
  inherited;
  TMainFacade.GetInstance.AllCoreTransfers.MakeList(lbxTransfers.Items, true, true);
  FEditMode := false;
end;

function TfrmCoreTransfersEditForm.GetMultiSelect: boolean;
begin
  Result := FMultiSelect;
end;

function TfrmCoreTransfersEditForm.GetSelectedObject: TIDObject;
begin
  Result := frmCoreTransferEdit1.CoreTransfer;
end;

function TfrmCoreTransfersEditForm.GetSelectedObjects: TIDObjects;
begin
  Result := nil;
end;

procedure TfrmCoreTransfersEditForm.ReadSelectedObjects;
begin

end;

procedure TfrmCoreTransfersEditForm.SetMultiSelect(const Value: boolean);
begin
  FMultiSelect := Value;
end;

procedure TfrmCoreTransfersEditForm.SetSelectedObject(AValue: TIDObject);
begin
  frmCoreTransferEdit1.EditingObject := AValue;
  lbxTransfers.ItemIndex := lbxTransfers.Items.IndexOfObject(AValue);
end;

procedure TfrmCoreTransfersEditForm.SetSelectedObjects(AValue: TIDObjects);
begin
  
end;

procedure TfrmCoreTransfersEditForm.SetSelectOnly(const Value: boolean);
begin
  FSelectOnly := Value;
  if not FSelectOnly then
  begin
    btnOK.Caption := 'Закрыть';
    btnCancel.Visible := false;
  end
  else
  begin
    btnOK.Caption := 'OK';
    btnCancel.Visible := true;
  end;
end;

procedure TfrmCoreTransfersEditForm.lbxTransfersClick(Sender: TObject);
begin
  if lbxTransfers.ItemIndex > -1 then
    SelectedObject := lbxTransfers.Items.Objects[lbxTransfers.ItemIndex] as TIDObject;

end;

procedure TfrmCoreTransfersEditForm.actnAddTransferExecute(
  Sender: TObject);
var t: TCoreTransfer;
begin
  t := TMainFacade.GetInstance.AllCoreTransfers.Add as TCoreTransfer;
  t.TransferStart := Date;
  SelectedObject := t;
  actnAddTransfer.Checked := true;
  EditMode := true;
end;

procedure TfrmCoreTransfersEditForm.SetEditMode(const Value: boolean);
begin
  if FEditMode <> Value then
  begin
    FEditMode := Value;
    
  end;
end;

procedure TfrmCoreTransfersEditForm.actnAddTransferUpdate(Sender: TObject);
begin
  actnAddTransfer.Enabled := not EditMode;
end;

procedure TfrmCoreTransfersEditForm.actnEditTransferUpdate(
  Sender: TObject);
begin
  actnEditTransfer.Enabled := Not EditMode and Assigned(SelectedObject);
end;

procedure TfrmCoreTransfersEditForm.actnDeleteTransferUpdate(
  Sender: TObject);
begin
  actnDeleteTransfer.Enabled := Assigned(SelectedObject) and not EditMode;
end;

procedure TfrmCoreTransfersEditForm.actnApplyUpdate(Sender: TObject);
begin
  actnApply.Enabled := EditMode And Assigned(SelectedObject);
end;

procedure TfrmCoreTransfersEditForm.actnCancelUpdate(Sender: TObject);
begin
  actnCancel.Enabled := EditMode And Assigned(SelectedObject);
end;

procedure TfrmCoreTransfersEditForm.actnApplyExecute(Sender: TObject);
begin
  frmCoreTransferEdit1.Save();
  SelectedObject.Update();
  EditMode := false;
end;

procedure TfrmCoreTransfersEditForm.actnCancelExecute(Sender: TObject);
begin
  TMainFacade.GetInstance.AllCoreTransfers.Remove(SelectedObject);
  SelectedObject := nil;
  EditMode := false;
end;

procedure TfrmCoreTransfersEditForm.actnEditTransferExecute(
  Sender: TObject);
begin
  actnEditTransfer.Checked := true;
  EditMode := true;
end;

procedure TfrmCoreTransfersEditForm.actnDeleteTransferExecute(
  Sender: TObject);
begin
  TMainFacade.GetInstance.AllCoreTransfers.Remove(SelectedObject);
  SelectedObject := nil;
end;

end.
