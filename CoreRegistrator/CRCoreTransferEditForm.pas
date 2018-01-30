unit CRCoreTransferEditForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DialogForm, ImgList, ActnList, FramesWizard, ComCtrls, ToolWin, BaseObjects;

type
  TfrmCoreTransferForm = class(TCommonDialogForm)
  private
    { Private declarations }
  protected
    function  GetEditingObjectName: string; override;

  public
    { Public declarations }
    procedure Save(AObject: TIDObject = nil); override;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmCoreTransferForm: TfrmCoreTransferForm;

implementation

uses CRCoreTransferEditFrame;

{$R *.dfm}

{ TfrmCoreTransferForm }

constructor TfrmCoreTransferForm.Create(AOwner: TComponent);
begin
  inherited;
  dlg.AddFrame(TfrmCoreTransferEdit);
  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := 0;
  Caption := 'Перемещение керна';
end;

function TfrmCoreTransferForm.GetEditingObjectName: string;
begin
  Result := 'перемещение керна';
end;

procedure TfrmCoreTransferForm.Save(AObject: TIDObject);
begin
  inherited;

  (dlg.Frames[0] as TfrmCoreTransferEdit).EditingObject.Update();
end;

end.
