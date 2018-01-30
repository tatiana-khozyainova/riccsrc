unit CRGenSectionEditForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DialogForm, ImgList, ActnList, FramesWizard, ComCtrls, ToolWin;

type
  TfrmGenSectionEditForm = class(TCommonDialogForm)
  protected
    function  GetEditingObjectName: string; override;
    procedure NextFrame(Sender: TObject); override;
    procedure FinishClick(Sender: TObject);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmGenSectionEditForm: TfrmGenSectionEditForm;

implementation

uses CRGeneralizedSectionEditFrame, CRGenSectionContentsEdit;

{$R *.dfm}

{ TfrmGenSectionEditForm }

constructor TfrmGenSectionEditForm.Create(AOwner: TComponent);
begin
  inherited;
  dlg.AddFrame(TfrmGenSectionEdit);
  dlg.AddFrame(TfrmGenSectionContentsEdit);

  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := 0;
  Caption := 'Сводный разрез';
  dlg.OnFinishClick := FinishClick;

  //Height := 600;
  //Width := 800;
end;

destructor TfrmGenSectionEditForm.Destroy;
begin

  inherited;
end;

procedure TfrmGenSectionEditForm.FinishClick(Sender: TObject);
begin

end;

function TfrmGenSectionEditForm.GetEditingObjectName: string;
begin
  Result := 'Сводный разрез';
end;

procedure TfrmGenSectionEditForm.NextFrame(Sender: TObject);
begin
  inherited;

end;

end.
