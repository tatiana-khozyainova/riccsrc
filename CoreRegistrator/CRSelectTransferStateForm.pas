unit CRSelectTransferStateForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CoreTransfer, Facade;

type
  TfrmSelectTransferStateDialog = class(TForm)
    gbxAll: TGroupBox;
    pnlButtons: TPanel;
    btnSelect: TButton;
    btnClose: TButton;
    lblState: TLabel;
    cmbxState: TComboBox;
  private
    function GetCoreTransferType: TCoreTransferType;
    { Private declarations }
  public
    { Public declarations }
    property    TransferType: TCoreTransferType read GetCoreTransferType;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmSelectTransferStateDialog: TfrmSelectTransferStateDialog;

implementation



{$R *.dfm}

{ TfrmSelectTransferStateDialog }

constructor TfrmSelectTransferStateDialog.Create(AOwner: TComponent);
begin
  inherited;
  TMainFacade.GetInstance.AllCoreTransferTypes.MakeList(cmbxState.Items, True, false);
  cmbxState.ItemIndex := 0;
end;

function TfrmSelectTransferStateDialog.GetCoreTransferType: TCoreTransferType;
begin
  Result := cmbxState.Items.Objects[cmbxState.ItemIndex] as TCoreTransferType;
end;

end.
