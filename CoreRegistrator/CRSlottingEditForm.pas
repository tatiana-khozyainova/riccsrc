unit CRSlottingEditForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DialogForm, ToolWin, ComCtrls, FramesWizard, ImgList, ActnList;

type
  TfrmSlottingEdit = class(TCommonDialogForm)
  private
    { Private declarations }
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
  frmSlottingEdit: TfrmSlottingEdit;

implementation

uses CRIntervalEditFrame, CRSlottingBoxListFrame, CommonFrame,
     CRIntervalRockSampleSizeTypesEditFrame, Slotting;

{$R *.dfm}

{ TfrmSlottingEdit }

constructor TfrmSlottingEdit.Create(AOwner: TComponent);
begin
  inherited;

  dlg.AddFrame(TfrmCoreIntervalEdit);
  dlg.AddFrame(TfrmSlottingBoxListFrame);
  dlg.AddFrame(TfrmRockSampleSizeTypesEdit);

  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := 0;
  Caption := 'Интервал отбора керна';
  dlg.OnFinishClick := FinishClick;

  Height := 842;            
  Width := 1090;
end;

destructor TfrmSlottingEdit.Destroy;
begin
  inherited;
end;

procedure TfrmSlottingEdit.FinishClick(Sender: TObject);
var s: TSlotting;
begin
  if (not dlg.CloseAfterFinish) then
  begin
    Save;
    s := EditingObject as TSlotting;
    s.Update;
    s.Boxes.Update(nil);
    s.RockSampleSizeTypePresences.Update(nil);

    EditingObject := EditingObject.Owner;
  end;
end;

function TfrmSlottingEdit.GetEditingObjectName: string;
begin
  Result := 'Интервал отбора керна';
end;

procedure TfrmSlottingEdit.NextFrame(Sender: TObject);
begin
  inherited;
end;

end.
