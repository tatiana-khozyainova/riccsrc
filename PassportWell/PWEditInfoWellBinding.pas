unit PWEditInfoWellBinding;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DialogForm, ImgList, ActnList, FramesWizard, ComCtrls, ToolWin;

type
  TfrmEditInfoWellBinding = class(TCommonDialogForm)
  private
  protected
    function  GetEditingObjectName: string; override;
    procedure NextFrame(Sender: TObject); override;
    procedure FinishClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmEditInfoWellBinding: TfrmEditInfoWellBinding;

implementation

{$R *.dfm}

uses PWInfoWellBindingFrame, Well, ReasonChange, Facade;

{ TCommonDialogForm1 }

constructor TfrmEditInfoWellBinding.Create(AOwner: TComponent);
begin
  inherited;
  dlg.AddFrame(TfrmWellBinding);

  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := 0;
  Caption := 'Редактор привязочной информации по скважине';
  dlg.OnFinishClick := FinishClick;

  Height := 580;
  Width := 710;
end;

destructor TfrmEditInfoWellBinding.Destroy;
begin

  inherited;
end;

procedure TfrmEditInfoWellBinding.FinishClick(Sender: TObject);
var w: TWell;
begin
  try
    w := EditingObject as TWell;
    Save;

    w.LastModifyDate := Date;

    w.Update;
    w.WellPosition.Update;
    w.WellOrgStatuses.Update(w.WellOrgStatuses);

    ShowMessage('Изменения успешно сохранены.');
  except

  end;
end;

function TfrmEditInfoWellBinding.GetEditingObjectName: string;
begin
  Result := 'Скважина';
end;

procedure TfrmEditInfoWellBinding.NextFrame(Sender: TObject);
begin
  inherited;

end;

end.
