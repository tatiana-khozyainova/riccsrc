unit CommonIDObjectEditForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DialogForm, ToolWin, ComCtrls, FramesWizard, BaseObjects;

type
  TfrmIDObjectEdit = class(TCommonDialogForm)
  private
    { Private declarations }
    FIDObjects: TIDObjects;
    FShowNavigationButtons: boolean;
    procedure SetIDObjects(const Value: TIDObjects);
    procedure SetShowNavigationButtons(const Value: boolean);
  protected
    function GetEditingObjectName: string; override;
  public
    { Public declarations }
    property    ShowNavigationButtons: boolean read FShowNavigationButtons write SetShowNavigationButtons;
    property    IDObjects: TIDObjects read FIDObjects write SetIDObjects;
    constructor Create(AOwner: TComponent); override;
  end;

  TfrmIDObjectEditClass = class of TfrmIDObjectEdit;


implementation

uses CommonIDObjectEditFrame;

{$R *.dfm}

{ TfrmIDObjectEdit }

constructor TfrmIDObjectEdit.Create(AOwner: TComponent);
begin
  inherited;
  dlg.AddFrame(TfrmIDObjectEditFrame);

  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := 0;
  Caption := 'Свойства объекта';

  FShowNavigationButtons := true;
end;

function TfrmIDObjectEdit.GetEditingObjectName: string;
begin
  Result := 'Свойства объекта';
end;

procedure TfrmIDObjectEdit.SetIDObjects(const Value: TIDObjects);
begin
  if FIDObjects <> Value then
  begin
    FIDObjects := Value;
    if (dlg.Frames[0] is TfrmIDObjectEditFrame) then
      (dlg.Frames[0] as TfrmIDObjectEditFrame).ParentIDObjects := FIDObjects;
  end;
end;

procedure TfrmIDObjectEdit.SetShowNavigationButtons(const Value: boolean);
begin
  FShowNavigationButtons := Value;
  if not FShowNavigationButtons then
    dlg.Buttons := [btFinish, btCancel];
end;

end.
