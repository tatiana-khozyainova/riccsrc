unit PWEditInfoWell;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Well, DialogForm, ImgList, ActnList, FramesWizard, ComCtrls,
  ToolWin, PWInfoWellFrame;

type
  TfrmEditInfoWell = class(TCommonDialogForm)
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
  frmEditInfoWell: TfrmEditInfoWell;

implementation

uses ReasonChange, Facade;

{$R *.dfm}

{ TCommonDialogForm1 }

constructor TfrmEditInfoWell.Create(AOwner: TComponent);
begin
  inherited;
  dlg.AddFrame(TfrmInfoWell);

  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := 0;
  Caption := 'Редактор основной инфомарции по скважине';
  dlg.OnFinishClick := FinishClick;

  Height := 573;
  Width := 710;
end;

destructor TfrmEditInfoWell.Destroy;
begin

  inherited;
end;

procedure TfrmEditInfoWell.FinishClick(Sender: TObject);
var w: TWell;
begin
  try
    w := EditingObject as TWell;
    Save;

    w.LastModifyDate := Date;

    w.Update;

    ShowMessage('Изменения успешно сохранены.');
  except

  end;
end;

function TfrmEditInfoWell.GetEditingObjectName: string;
begin
  Result := 'Скважина';
end;

procedure TfrmEditInfoWell.NextFrame(Sender: TObject);
begin
  inherited;

end;

end.
 