unit CRCoreTransferContentsViewForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, CRCoreTransferContentsViewFrame,
  CRCoreTransferNavigator;

type
  TfrmContentsViewForm = class(TForm)
    frmCoreTransferNavigator1: TfrmCoreTransferNavigator;
    frmCoreTransferContentsView1: TfrmCoreTransferContentsView;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure ActiveCoretransferChanged(Sender: TObject); 
  public
    { Public declarations }

    constructor Create(AOwner: TComponent); override;
  end;

var
  frmContentsViewForm: TfrmContentsViewForm;

implementation

{$R *.dfm}

{ TfrmContentsViewForm }

procedure TfrmContentsViewForm.ActiveCoretransferChanged(Sender: TObject);
begin
  if Assigned(Sender) then
    if Assigned(frmCoreTransferContentsView1.CoreTransfer) then frmCoreTransferContentsView1.CoreTransfer.CoreTransferTasks.Update(nil);

  frmCoreTransferContentsView1.EditingObject := frmCoreTransferNavigator1.ActiveCoreTransfer;
end;

constructor TfrmContentsViewForm.Create(AOwner: TComponent);
begin
  inherited;
  frmCoreTransferNavigator1.ActiveCoreTransferChanged := ActiveCoretransferChanged;
  frmCoreTransferContentsView1.CanEdit := True;
end;

procedure TfrmContentsViewForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Assigned(frmCoreTransferContentsView1.CoreTransfer) then frmCoreTransferContentsView1.CoreTransfer.CoreTransferTasks.Update(nil);
  frmCoreTransferContentsView1.EditingObject  := nil;
end;

procedure TfrmContentsViewForm.FormShow(Sender: TObject);
begin
  frmCoreTransferContentsView1.EditingObject := frmCoreTransferNavigator1.ActiveCoreTransfer;
end;

end.
