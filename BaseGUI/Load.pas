unit Load;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TfrmLoad = class(TForm)
    anmWait: TAnimate;
    prgb: TProgressBar;
    stMessage: TStaticText;
  public
    class function GetInstance: TfrmLoad;
    procedure   Load(ACommonAVI: TCommonAVI; ACaption: TCaption = 'Пожалуйста, подождите'; AStep: integer = 50; AMax: integer = 100);
    procedure   BeforeClose;
    procedure   MakeStep(AStepName: string = '');

    // функции отключения мерчания формы при загрузке массива данных
    procedure   BeginScreenUpdate(hwnd: THandle);
    procedure   EndScreenUpdate(hwnd: THandle; erase: Boolean);

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmLoad: TfrmLoad;

implementation

{$R *.dfm}

{ TfrmLoad }

procedure TfrmLoad.BeforeClose;
begin
  anmWait.Visible := false;
  anmWait.Active := false;
  Close;
end;

procedure TfrmLoad.BeginScreenUpdate(hwnd: THandle);
begin
  if (hwnd = 0) then hwnd := Application.MainForm.Handle;
  SendMessage(hwnd, WM_SETREDRAW, 0, 0);
end;

constructor TfrmLoad.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TfrmLoad.Destroy;
begin

  inherited;
end;

procedure TfrmLoad.EndScreenUpdate(hwnd: THandle; erase: Boolean);
begin
  if (hwnd = 0) then hwnd := Application.MainForm.Handle;
  SendMessage(hwnd, WM_SETREDRAW, 1, 0);
  RedrawWindow(hwnd, nil, 0, RDW_FRAME + RDW_INVALIDATE + RDW_ALLCHILDREN + RDW_NOINTERNALPAINT);
  if (erase) then Windows.InvalidateRect(hwnd, nil, True);
end;

class function TfrmLoad.GetInstance: TfrmLoad;
const FInstance: TfrmLoad = nil;
begin
  if not Assigned(FInstance) then
    FInstance := TfrmLoad.Create(Application.MainForm);

  Result := FInstance;
end;

procedure TfrmLoad.Load(ACommonAVI: TCommonAVI; ACaption: TCaption; AStep: integer; AMax: integer);
begin
  Caption := ACaption;
  anmWait.CommonAVI := ACommonAVI;
  anmWait.Visible := true;
  anmWait.Active := true;
  anmWait.Update;

  prgb.Step := AStep;
  prgb.Max := AMax;

  Show;
end;

procedure TfrmLoad.MakeStep(AStepName: string = '');
begin
  prgb.StepIt;
  stMessage.Caption := '    ' + AStepName;
  Update;
end;

end.
