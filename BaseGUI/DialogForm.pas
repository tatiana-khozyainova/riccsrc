unit DialogForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FramesWizard, ToolWin, ComCtrls, BaseObjects, CommonFrame,
  ImgList, ActnList;

type
  TCommonDialogForm = class(TForm)
    tlbr: TToolBar;
    dlg: TDialogFrame;
    ActionList1: TActionList;
    actnDoNotClose: TAction;
    actnLoadNext: TAction;
    tlbtnCloseAfterFinish: TToolButton;
    ToolButton2: TToolButton;
    imgLst: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure actnDoNotCloseExecute(Sender: TObject);
    procedure actnLoadNextExecute(Sender: TObject);
    procedure actnLoadNextUpdate(Sender: TObject);
  private
    { Private declarations }
    FEditingObjectCopy: TIDObject;
    FOnAfterBasketClosed: TNotifyEvent;
    FToolBarVisible: boolean;
    FLoadNextAfterFinish: boolean;
    procedure SetToolBarVisible(const Value: boolean);
    procedure SetEditingObject(const Value: TIDObject); virtual;
    function  GetEditingObject: TIDObject; virtual;

  protected
    function  GetEditingObjectName: string; virtual;
    procedure NextFrame(Sender: TObject); virtual;
  public
    { Public declarations }
    property  EditingObject: TIDObject read GetEditingObject write SetEditingObject;
    property  EditingObjectCopy: TIDObject read FEditingObjectCopy;

    property  EditingObjectName: string read GetEditingObjectName;
    property  OnAfterBasketClosed: TNotifyEvent read FOnAfterBasketClosed write FOnAfterBasketClosed;
    procedure Save(AObject: TIDObject = nil); virtual;
    procedure CancelEdit;
    procedure Clear;

    property  ToolBarVisible: boolean read FToolBarVisible write SetToolBarVisible;
    property  LoadNextAfterFinish: boolean read FLoadNextAfterFinish write FLoadNextAfterFinish;


    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

  TCommonDialogFormSimpleInstantiator = class(TCommonDialogForm)
  protected
    procedure SetEditingObject(const Value: TIDObject); override;
    function  GetEditingObject: TIDObject; override;
  public
    class function GetInstance(AFrameClass: TFrameClass): TCommonDialogForm;
  end;


var
  CommonDialogForm: TCommonDialogForm;

implementation

uses Contnrs;

{$R *.dfm}

procedure TCommonDialogForm.FormCreate(Sender: TObject);
begin
//
end;


procedure TCommonDialogForm.CancelEdit;
var i: integer;
begin
  for i := 0 to dlg.FrameCount - 1 do
    (dlg.Frames[i] as TfrmCommonFrame).CancelEdit;
end;

constructor TCommonDialogForm.Create(AOwner: TComponent);
begin
  inherited;
  dlg.OnBeforePageChange := NextFrame;
  Width := 718;
  Height := 527;
  Position := poMainFormCenter;

  { TODO : тулбар - на будущее }
  ToolBarVisible := false;
end;

destructor TCommonDialogForm.Destroy;
begin

  inherited;
end;

function TCommonDialogForm.GetEditingObject: TIDObject;
begin
  Result := (dlg.Frames[0] as TfrmCommonFrame).EditingObject;
end;

function TCommonDialogForm.GetEditingObjectName: string;
begin
  Result := '';
end;

procedure TCommonDialogForm.NextFrame(Sender: TObject);
begin
  if Dlg.LastActiveFrameIndex < Dlg.NextActiveFrameIndex then
  begin
    // проверка при переходе от фрэйма к фрэйму
    (dlg.Frames[dlg.ActiveFrameIndex + 1] as TfrmCommonFrame).EditingObject := EditingObject;
    (dlg.Frames[dlg.ActiveFrameIndex + 1] as TfrmCommonFrame).Check;
  end
  else
  begin
    (dlg.Frames[dlg.ActiveFrameIndex - 1] as TfrmCommonFrame).EditingObject := EditingObject;
    (dlg.Frames[dlg.ActiveFrameIndex - 1] as TfrmCommonFrame).Check;
  end;
  Caption := EditingObjectName + ' (шаг ' + IntToStr(dlg.NextActiveFrameIndex + 1) + ' из ' + IntToStr(dlg.FrameCount) + ')';


end;


procedure TCommonDialogForm.Save(AObject: TIDObject = nil);
var i, iIndex: integer;
    frm: TfrmCommonFrame;
    oNext: TIDObject;
begin
  for i := 0 to dlg.FrameCount - 1 do
  begin
    // если не было ничего загружено
    // то при сохранении может получиться так,
    // что данные будут почищены
    // поэтому прежде чем сохранить
    // обязательно загрузить инфу
    // с другой стороны может быть случай,
    // когда этого как раз делать не надо
    // добавиль новый элемент
    // editingObject не назначен
    // в результате переназначения теряется редактирование
    // поэтому переназначаем только в том случае,
    // если это не вновь добавленный объект
    frm := dlg.Frames[i] as TfrmCommonFrame;
    if (not Assigned(frm.EditingObject))
        and Assigned(EditingObjectCopy)
        and (EditingObjectCopy.ID > 0) then
      frm.EditingObject := EditingObjectCopy;
    (dlg.Frames[i] as TfrmCommonFrame).Save(AObject);
  end;

  if not LoadNextAfterFinish then
    dlg.ActiveFrameIndex := 0;

  if LoadNextAfterFinish then
  begin
    iIndex := EditingObject.Collection.IndexOf(EditingObject);
    if iIndex + 1 < EditingObject.Collection.Count then iIndex := iIndex + 1
    else iIndex := 0;

    if iIndex >= EditingObject.Collection.Count then dlg.CloseAfterFinish := true
    else
    begin
      oNext := EditingObject.Collection.Items[iIndex];

      for i := 0 to dlg.FrameCount - 1 do
        (dlg.Frames[i] as TfrmCommonFrame).EditingObject := nil;

      EditingObject := oNext;

      dlg.ActiveFrameIndex := 0;
    end;
  end;
end;

procedure TCommonDialogForm.SetEditingObject(const Value: TIDObject);
begin
  Clear;
  (dlg.Frames[0] as TfrmCommonFrame).EditingObject := Value;
end;



procedure TCommonDialogForm.SetToolBarVisible(const Value: boolean);
begin
  FToolBarVisible := Value;
  tlbr.Visible := FToolBarVisible;
end;

procedure TCommonDialogForm.Clear;
var i: integer;
begin
  FEditingObjectCopy := nil;
  for i := 0 to dlg.FrameCount - 1 do
    (dlg.Frames[i] as TfrmCommonFrame).Clear;
end;


procedure TCommonDialogForm.actnDoNotCloseExecute(Sender: TObject);
begin
  actnDoNotClose.Checked := not actnDoNotClose.Checked;
  dlg.CloseAfterFinish := not actnDoNotClose.Checked;
end;

procedure TCommonDialogForm.actnLoadNextExecute(Sender: TObject);
begin
  actnLoadNext.Checked := not actnLoadNext.Checked;
  LoadNextAfterFinish := actnLoadNext.Checked;
end;

procedure TCommonDialogForm.actnLoadNextUpdate(Sender: TObject);
begin
  actnLoadNext.Enabled := not dlg.CloseAfterFinish;
end;

function TCommonDialogFormSimpleInstantiator.GetEditingObject: TIDObject;
begin
  Assert(dlg.FrameCount > 0, 'FrameCount не может быть равен 0');
  Result := (dlg.Frames[0] as TfrmCommonFrame).EditingObject; 
end;

class function TCommonDialogFormSimpleInstantiator.GetInstance(
  AFrameClass: TFrameClass): TCommonDialogForm;
const FSimpleInstance: TCommonDialogForm = nil;
begin
  if not Assigned(FSimpleInstance) then
  begin
    FSimpleInstance := TCommonDialogFormSimpleInstantiator.Create(Application.MainForm);
    FSimpleInstance.ToolBarVisible := false;
    FSimpleInstance.dlg.Buttons := [btFinish, btCancel];
    FSimpleInstance.dlg.ActiveFrameIndex := 0;
  end;

  FSimpleInstance.dlg.Clear;
  FSimpleInstance.dlg.AddFrame(AFrameClass);

  Result := FSimpleInstance;
end;

procedure TCommonDialogFormSimpleInstantiator.SetEditingObject(
  const Value: TIDObject);
begin
  Clear;
  (dlg.Frames[0] as TfrmCommonFrame).EditingObject := Value;
end;

end.
