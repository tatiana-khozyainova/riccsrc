unit PWEditInfoCoordWell;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DialogForm, ImgList, ActnList, FramesWizard, ComCtrls, ToolWin,
  StdCtrls;

type
  TfrmEditInfoCoordWell = class(TCommonDialogForm)
    btnDelCoord: TButton;
    procedure btnDelCoordClick(Sender: TObject);
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
  frmEditInfoCoordWell: TfrmEditInfoCoordWell;

implementation

uses PWInfoCoordWell, Well, ReasonChange, Facade;

{$R *.dfm}

constructor TfrmEditInfoCoordWell.Create(AOwner: TComponent);
begin
  inherited;
  dlg.AddFrame(TfrmInfoCoordWell);

  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := 0;
  Caption := 'Редактор координат по скважине';
  dlg.OnFinishClick := FinishClick;

  btnDelCoord.Parent := dlg.pnlButtons;
  btnDelCoord.Top := 10;

  Height := 270;
  Width := 470;
end;

destructor TfrmEditInfoCoordWell.Destroy;
begin

  inherited;
end;

procedure TfrmEditInfoCoordWell.FinishClick(Sender: TObject);
var w: TWell;
begin
  try
    w := EditingObject as TWell;
    Save;



    //w.LastModifyDate := Date;
    w.Update;
    w.Coord.Update;

    // 65°48'33,984''

    ShowMessage('Изменения успешно сохранены.');
  except

  end;
end;

function TfrmEditInfoCoordWell.GetEditingObjectName: string;
begin
  Result := 'Скважина';
end;

procedure TfrmEditInfoCoordWell.NextFrame(Sender: TObject);
begin
  inherited;

end;

procedure TfrmEditInfoCoordWell.btnDelCoordClick(Sender: TObject);
begin
  inherited;

  (dlg.Frames[0] as TfrmInfoCoordWell).Remove;
  {
  
   }
  Close;
end;

end.
