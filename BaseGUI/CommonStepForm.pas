unit CommonStepForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, CalculationLoggerFrame, Registrator,
  ToolWin, ActnList, CalculationLogger;

type
  TOnCheckOwnerState = procedure (var IsThreadFinished: boolean; var FinishingState: string) of object;

  TfrmStep = class(TForm)
    frmCalculationLogger: TfrmCalculationLogger;
    actnStepForm: TActionList;
    actnHide: TAction;
    pnlStep: TPanel;
    tlbr: TToolBar;
    sbtnHide: TToolButton;
    prg: TProgressBar;
    prgSub: TProgressBar;
    lblStep: TStaticText;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actnHideUpdate(Sender: TObject);
    procedure actnHideExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FRegistrator: TRegistrator;
    FShowLog: boolean;
    FOnCheckOwnerState: TOnCheckOwnerState;
    FShowSubPrg: boolean;
    procedure SetRegistrator(const Value: TRegistrator);
    procedure StepAdded(Sender: TObject; StepCount: integer; ItemState: TItemState);
    procedure SetShowLog(const Value: boolean);
    procedure SetShowSubPrg(const Value: boolean);
  public
    { Public declarations }
    property  OnCheckOwnerState: TOnCheckOwnerState read FOnCheckOwnerState write FOnCheckOwnerState;
    function  CheckOwnerState: boolean;
    property  Registrator: TRegistrator read FRegistrator write SetRegistrator;
    procedure InitProgress(AMin, AMax, AStep: integer);
    procedure MakeStep(AStepName: string);

    procedure MakeSubStep(AStepName: string = '');
    procedure InitSubProgress(AMin, AMax, AStep: integer);

    procedure Clear;
    property  ShowLog: boolean read FShowLog write SetShowLog;
    property  ShowSubPrg: boolean read FShowSubPrg write SetShowSubPrg;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;


var frmStep: TfrmStep;


implementation



{$R *.dfm}

{ TfrmStep }

constructor TfrmStep.Create(AOwner: TComponent);
begin
  inherited;
  ShowLog := true;
  frmCalculationLogger.OnAddItem := StepAdded;
end;

procedure TfrmStep.InitProgress(AMin, AMax, AStep: integer);
begin
  prg.Min := AMin;
  prg.Max := AMax;
  prg.Step := AStep;
  prg.Position := 0;
  lblStep.Caption := '';
  Update;
end;

procedure TfrmStep.MakeStep(AStepName: string);
begin
  prg.StepIt;
  lblStep.Caption := AStepName;
  prg.Refresh;
  lblStep.Refresh;

  if ShowLog then
    frmCalculationLogger.lwLog.AddItem(AStepName, nil);

  Refresh;
end;

procedure TfrmStep.SetRegistrator(const Value: TRegistrator);
begin
  if FRegistrator <> Value then
  begin
    FRegistrator := Value;
  end;
end;

procedure TfrmStep.StepAdded(Sender: TObject; StepCount: integer; ItemState: TItemState);
begin
  if ItemState = isError then prg.Max := prg.Max + 1;
  if prg.Position < prg.Max then prg.StepIt;

  Visible := true;
end;

procedure TfrmStep.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide;
end;

procedure TfrmStep.Clear;
begin
  prg.Position := 0;
  frmCalculationLogger.Clear;
end;

procedure TfrmStep.SetShowLog(const Value: boolean);
begin
  FShowLog := Value;
  frmCalculationLogger.Visible := FShowLog;
  tlbr.Visible := FShowLog;
  Height := pnlStep.Height + 300 * ord(frmCalculationLogger.Visible) + 50;
end;

function TfrmStep.CheckOwnerState: boolean;
var s: string;
begin
  Result := true;
  if Assigned(FOnCheckOwnerState) then
  begin
    FOnCheckOwnerState(Result, s);
    lblStep.Caption := s;
  end;
end;

procedure TfrmStep.actnHideUpdate(Sender: TObject);
begin
  actnHide.Enabled := CheckOwnerState;
end;


procedure TfrmStep.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := CheckOwnerState;
end;

destructor TfrmStep.Destroy;
begin

  inherited;
end;


procedure TfrmStep.actnHideExecute(Sender: TObject);
begin
  Hide;
end;



procedure TfrmStep.SetShowSubPrg(const Value: boolean);
begin
  FShowSubPrg := Value;
  prgSub.Visible := FShowSubPrg;
end;

procedure TfrmStep.InitSubProgress(AMin, AMax, AStep: integer);
begin
  prgSub.Max := AMax;
  prgSub.Min := AMin;
  prgSub.Position := prgSub.Min;
  prgSub.Step := AStep;
  prgSub.Update;
  prgSub.Visible := true;
end;

procedure TfrmStep.MakeSubStep(AStepName: string = '');
begin
  prgSub.StepIt;
  if AStepName <> '' then
    lblStep.Caption := AStepName;
  prgSub.Refresh;
  Refresh;
end;

end.
