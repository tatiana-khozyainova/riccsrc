unit PWEditInfoWellParametrs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DialogForm, ImgList, ActnList, FramesWizard, ComCtrls, ToolWin;

type
  TfrmEditInfoWellParameters = class(TCommonDialogForm)
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
  frmEditInfoWellParameters: TfrmEditInfoWellParameters;

implementation

uses PWInfoWellParametrsFrame, Well, Facade, ReasonChange;

{$R *.dfm}

{ TCommonDialogForm2 }

constructor TfrmEditInfoWellParameters.Create(AOwner: TComponent);
begin
  inherited;
  dlg.AddFrame(TfrmInfoWellParametrs);

  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := 0;
  Caption := 'Редактор проектных и фактических параметров по скважине';
  dlg.OnFinishClick := FinishClick;

  Height := 573;
  Width := 715;
end;

destructor TfrmEditInfoWellParameters.Destroy;
begin

  inherited;
end;

procedure TfrmEditInfoWellParameters.FinishClick(Sender: TObject);
var w: TWell;
begin
  w := EditingObject as TWell;
  Save;

  w.LastModifyDate := Date;

  w.Update;

  w.IstFinances.Update(w.IstFinances);
  w.AbandonReasons.Update(w.AbandonReasons);
  w.Altitudes.Update(w.Altitudes);
end;

function TfrmEditInfoWellParameters.GetEditingObjectName: string;
begin
  Result := 'Скважина';
end;

procedure TfrmEditInfoWellParameters.NextFrame(Sender: TObject);
begin
  inherited;

end;

end.
