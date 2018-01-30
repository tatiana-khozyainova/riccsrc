unit PWEditInfoWellParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DialogForm, ImgList, ActnList, FramesWizard, ComCtrls, ToolWin;

type
  TfrmEditInfoWellParams = class(TCommonDialogForm)
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
  frmEditInfoWellParams: TfrmEditInfoWellParams;

implementation

uses PWInfoWellParamsFrame, Well;

{$R *.dfm}

{ TCommonDialogForm3 }

constructor TfrmEditInfoWellParams.Create(AOwner: TComponent);
begin
  inherited;
  dlg.AddFrame(TfrmInfoWellParams);

  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := 0;
  Caption := 'Редактор параметров по скважине';
  dlg.OnFinishClick := FinishClick;

  Height := 573;
  Width := 710;
end;

destructor TfrmEditInfoWellParams.Destroy;
begin

  inherited;
end;

procedure TfrmEditInfoWellParams.FinishClick(Sender: TObject);
var w: TDinamicWell;
begin
  //if (not dlg.CloseAfterFinish) then
  begin
    w := EditingObject as TDinamicWell;
    Save;
    w.ParametrValues.Update(w.ParametrValues);
  end;
end;

function TfrmEditInfoWellParams.GetEditingObjectName: string;
begin
  Result := 'Скважина';
end;

procedure TfrmEditInfoWellParams.NextFrame(Sender: TObject);
begin
  inherited;

end;

end.
