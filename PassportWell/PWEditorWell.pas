unit PWEditorWell;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DialogForm, ImgList, ActnList, FramesWizard, ComCtrls, ToolWin, Well;

type
  TfrmEditorWell = class(TCommonDialogForm)
  private
    FCategory: TWellCategory;
  protected
    function  GetEditingObjectName: string; override;
    procedure NextFrame(Sender: TObject); override;
    procedure FinishClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmEditorWell: TfrmEditorWell;

implementation

uses PWInfoWellFrame, PWInfoWellBindingFrame, PWInfoWellParametrsFrame,
     PWInfoChangesWellFrame, Facade;

{$R *.dfm}

{ TCommonDialogForm1 }

constructor TfrmEditorWell.Create(AOwner: TComponent);
begin
  inherited;
  dlg.AddFrame(TfrmInfoWell);
  dlg.AddFrame(TfrmInfoWellParametrs);
  dlg.AddFrame(TfrmWellBinding);
  //dlg.AddFrame(TInfoChangesWell);

  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := 1;
  Caption := 'Редактор скважины';
  dlg.OnFinishClick := FinishClick;

  Height := 600;
  Width := 820;
end;

destructor TfrmEditorWell.Destroy;
begin

  inherited;
end;

procedure TfrmEditorWell.FinishClick(Sender: TObject);
var wd: TWell;
    IsWellPosition: Boolean;
begin
  wd := EditingObject as TWell;
  IsWellPosition := False;

  Save;
  // основная информация
  wd.Update;

  wd.WellDynamicParametersSet.Update(wd.WellDynamicParametersSet);
  
  // организации
  wd.WellOrgStatuses.Update(wd.WellOrgStatuses);

  // альтитуды
  wd.Altitudes.Update(wd.Altitudes);
  if Assigned(wd.WellPosition) then
  begin
    // привязка скважины
    if wd.WellPosition.ID = 0 then begin
      if Assigned (wd.WellPosition.TectonicStructure) then IsWellPosition := True
      else if Assigned (wd.WellPosition.District) then IsWellPosition := True
      else if Assigned (wd.WellPosition.NGR) then IsWellPosition := True
      else if Assigned (wd.WellPosition.NewTectonicStructure) then IsWellPosition := True
      else if Assigned (wd.WellPosition.NewNGR) then IsWellPosition := True
      else if Assigned (wd.WellPosition.Topolist) then IsWellPosition := True;
    end;
    if (IsWellPosition) or (wd.WellPosition.ID > 0) then
      wd.WellPosition.Update;
  end;


end;

function TfrmEditorWell.GetEditingObjectName: string;
begin
  Result := 'Скважина';
end;

procedure TfrmEditorWell.NextFrame(Sender: TObject);
begin
  inherited;
  if (dlg.ActiveFrameIndex = 0) then
  begin
    FCategory := (dlg.Frames[0] as TfrmInfoWell).frmFilterCategory.ActiveObject as TWellCategory;
    (dlg.Frames[1] as TfrmInfoWellParametrs).actnStartEdit.Execute;
    (dlg.Frames[1] as TfrmInfoWellParametrs).frmFilterCategory.ActiveObject := FCategory;
    (dlg.Frames[1] as TfrmInfoWellParametrs).actnFinishEdit.Execute;
  end;
end;

end.
 