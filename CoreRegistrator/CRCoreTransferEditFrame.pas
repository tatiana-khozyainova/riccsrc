unit CRCoreTransferEditFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, ComCtrls, StdCtrls, CoreTransfer, BaseObjects;

type
  TfrmCoreTransferEdit = class(TfrmCommonFrame)
    gbxCoreTransfer: TGroupBox;
    dtpTransferStart: TDateTimePicker;
    dtpTransferFinish: TDateTimePicker;
    chbxTransferFinish: TCheckBox;
    lblTransferStart: TStaticText;
    lblTransferFinish: TStaticText;
    procedure chbxTransferFinishClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure FillControls(ABaseObject: TIDObject); override;
    procedure ClearControls; override;
    procedure RegisterInspector; override;
    procedure CopyEditingValues(Dest: TIDObject); override;
    function  InternalCheck: Boolean; override;
    function  GetCoreTransfer: TCoreTransfer;
  public
    { Public declarations }
    property    CoreTransfer: TCoreTransfer read GetCoreTransfer;
    constructor Create(AOwner: TComponent); override;
    procedure   Save(AObject: TIDObject = nil);  override;
  end;

var
  frmCoreTransferEdit: TfrmCoreTransferEdit;

implementation

uses BaseGUI, Facade;

{$R *.dfm}

procedure TfrmCoreTransferEdit.chbxTransferFinishClick(Sender: TObject);
begin
  inherited;
  lblTransferFinish.Enabled := chbxTransferFinish.Checked;
  dtpTransferFinish.Enabled := chbxTransferFinish.Checked;
end;

procedure TfrmCoreTransferEdit.ClearControls;
begin
  inherited;
  //dtpTransferStart.Date := null;
  chbxTransferFinish.Checked := false;
  chbxTransferFinishClick(chbxTransferFinish);
  //dtpTransferFinish.Date := null;
end;

procedure TfrmCoreTransferEdit.CopyEditingValues(Dest: TIDObject);
begin
  inherited;
  with Dest as TCoreTransfer do
  begin
    Name := CoreTransfer.Name;
    TransferStart := CoreTransfer.TransferStart;
    TransferFinish := CoreTransfer.TransferFinish;
  end;
end;

constructor TfrmCoreTransferEdit.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TfrmCoreTransferEdit.FillControls(ABaseObject: TIDObject);
begin
  inherited;
  dtpTransferStart.Date := CoreTransfer.TransferStart;
  if CoreTransfer.TransferFinish > CoreTransfer.TransferStart then
  begin
    chbxTransferFinish.Checked := True;
    chbxTransferFinishClick(chbxTransferFinish);
    dtpTransferFinish.Date := CoreTransfer.TransferFinish;
  end
  else
  begin
    chbxTransferFinish.Checked := False;
    chbxTransferFinishClick(chbxTransferFinish);
  end;
end;

function TfrmCoreTransferEdit.GetCoreTransfer: TCoreTransfer;
begin
  Result := EditingObject as TCoreTransfer;
end;

function TfrmCoreTransferEdit.InternalCheck: Boolean;
begin
  Result := true;
  if chbxTransferFinish.Checked then
  begin
    Result := dtpTransferStart.Date < dtpTransferFinish.Date;
    if not Result then
    begin
      StatusBar.Panels[0].Text := 'ƒата начала больше даты окончани€';
      exit;
    end;
  end;
end;

procedure TfrmCoreTransferEdit.RegisterInspector;
begin
  inherited;
  //Inspector.Add(dtpTransferStart, nil, ptDate, 'дата начала', false);
end;

procedure TfrmCoreTransferEdit.Save(AObject: TIDObject);
begin
  inherited;
  
  EditingClass := TCoreTransfer;
  if  FEditingObject = nil  then
    FEditingObject := TMainFacade.GetInstance.AllCoreTransfers.Add;

  CoreTransfer.TransferStart := dtpTransferStart.Date;
  if chbxTransferFinish.Checked then
    CoreTransfer.TransferFinish := dtpTransferFinish.Date
  else
    CoreTransfer.TransferFinish := CoreTransfer.TransferStart;
end;

end.
