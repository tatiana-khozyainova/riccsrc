unit CommonInstrumentsFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ToolWin, ComCtrls, StdCtrls, BaseObjects, BaseActions;

type
  TInstrumentActions = class;

  TExecutionState = (esPreExecute, esExecute);

  TInstrumentAction = class(TBaseAction)
  private
    FInstrument: TIDObject;
    FOnPreExecute: TNotifyEvent;
    FExecuteState: TExecutionState;
    function  GetInstrumentActions: TInstrumentActions;
    procedure SetInstrument(const Value: TIDObject);
    procedure SetExecuteState(const Value: TExecutionState);
  protected
    function  PreExecute: boolean; virtual;
    function  MiddleExecute: boolean; virtual;
  public
    property Instrument: TIDObject read FInstrument write SetInstrument;
    property InstrumentsActionList: TInstrumentActions read GetInstrumentActions;

    property OnPreExecute: TNotifyEvent read FOnPreExecute write FOnPreExecute;

    property ExecutionState: TExecutionState read FExecuteState write SetExecuteState;
    function Execute: boolean; override;

    constructor Create(AOwner: TComponent); override;
  end;

  TInstrumentActions = class(TBaseActionList)
  private
    FOnExecuteDefault: TNotifyEvent;
    FOnPreExecuteDefault: TNotifyEvent;
    function GetActions(const Index: integer): TInstrumentAction;
    function GetActiveAction: TInstrumentAction;
  public
    property ActiveAction: TInstrumentAction read GetActiveAction;
    property OnExecuteDefault: TNotifyEvent read FOnExecuteDefault write FOnExecuteDefault;
    property OnPreExecuteDefault: TNotifyEvent read FOnPreExecuteDefault write FOnPreExecuteDefault;
    property Items[const Index: integer]: TInstrumentAction read GetActions;

    procedure Clear;
  end;


  TfrmInstruments = class(TFrame)
    gbxInstruments: TGroupBox;
    ScrollBox1: TScrollBox;
    tlbrInstruments: TToolBar;
  private
    { Private declarations }
    FObjectList: TIDObjects;
    FInstrumentActions: TInstrumentActions;
    FDefaultOnExecuteInstrumentAction: TNotifyEvent;
    FDefaultOnSelectInstrumentAction: TNotifyEvent;
    procedure SetObjectList(const Value: TIDObjects);
    procedure SetDefaultOnExecuteInstrumentAction(
      const Value: TNotifyEvent);
    procedure SetDefaultOnSelectInstrumentAction(
      const Value: TNotifyEvent);
    function GetInstrumentAction: TInstrumentAction;
    procedure ToolBarClear;
  public
    { Public declarations }
    property ObjectList: TIDObjects read FObjectList write SetObjectList;

    procedure RefreshInstruments;
    property  InstrumentActions: TInstrumentActions read FInstrumentActions write FInstrumentActions;
    property  SelectedAction: TInstrumentAction read GetInstrumentAction;

    property DefaultOnSelectInstrumentAction: TNotifyEvent read FDefaultOnSelectInstrumentAction write SetDefaultOnSelectInstrumentAction;
    property DefaultOnExecuteInstrumentAction: TNotifyEvent read FDefaultOnExecuteInstrumentAction write SetDefaultOnExecuteInstrumentAction;

    constructor Create(AOwner: TComponent); override;

  end;

implementation

uses ActnList;

{$R *.dfm}

{ TfrmInstruments }

constructor TfrmInstruments.Create(AOwner: TComponent);
begin
  inherited;
  FInstrumentActions := TInstrumentActions.Create(Self);
end;

function TfrmInstruments.GetInstrumentAction: TInstrumentAction;
begin
  Result := InstrumentActions.ActiveAction;
end;

procedure TfrmInstruments.RefreshInstruments;
var i: integer;
    actn: TInstrumentAction;
    btn: TToolButton;
begin
  FInstrumentActions.Clear;
  ToolBarClear;

  for i := 0 to FObjectList.Count - 1 do
  begin
    actn := TInstrumentAction.Create(FInstrumentActions);
    actn.Instrument := FObjectList.Items[i];
    actn.ActionList := FInstrumentActions;
    actn.Caption := actn.Instrument.List;

    btn := TToolButton.Create(tlbrInstruments);
    btn.Parent := tlbrInstruments;
    btn.AutoSize := false;
    btn.Wrap := true;
    btn.Width := tlbrInstruments.Width - 5;
    btn.Action := actn;
  end;
end;

procedure TfrmInstruments.SetDefaultOnExecuteInstrumentAction(
  const Value: TNotifyEvent);
begin
  FDefaultOnExecuteInstrumentAction := Value;
  InstrumentActions.OnExecuteDefault := FDefaultOnExecuteInstrumentAction;
end;

procedure TfrmInstruments.SetDefaultOnSelectInstrumentAction(
  const Value: TNotifyEvent);
begin
  FDefaultOnSelectInstrumentAction := Value;
  InstrumentActions.OnPreExecuteDefault := FDefaultOnSelectInstrumentAction;  
end;

procedure TfrmInstruments.SetObjectList(const Value: TIDObjects);
begin
  if FObjectList <> Value then
  begin
    FObjectList := Value;
    RefreshInstruments;
  end;
end;

procedure TfrmInstruments.ToolBarClear;
var i: integer;
begin
  for i := tlbrInstruments.ButtonCount - 1 downto 0 do
    tlbrInstruments.Buttons[i].Free;
end;

{ TInstrumentAction }

constructor TInstrumentAction.Create(AOwner: TComponent);
begin
  inherited;
  ExecutionState := esPreExecute;
  GroupIndex := 1;
end;

function TInstrumentAction.Execute: boolean;
begin
  Result := inherited Execute;

  case ExecutionState of
    esPreExecute: Result := PreExecute;
    esExecute: Result := MiddleExecute;
  end;
end;

function TInstrumentAction.GetInstrumentActions: TInstrumentActions;
begin
  Result := ActionList as TInstrumentActions;
end;


function TInstrumentAction.MiddleExecute: boolean;
begin
  Result := true;
  if Assigned(OnExecute) then
     OnExecute(Self);

  if Assigned(InstrumentsActionList.OnExecuteDefault) then
     InstrumentsActionList.OnExecuteDefault(Self);

  ExecutionState := esPreExecute;
end;

function TInstrumentAction.PreExecute: boolean;
begin
  Result := true;
  if Assigned(OnPreExecute) then
    OnPreExecute(Self);

  if Assigned(InstrumentsActionList.OnPreExecuteDefault) then
    InstrumentsActionList.OnPreExecuteDefault(Self);

  ExecutionState := esExecute;
end;

procedure TInstrumentAction.SetExecuteState(const Value: TExecutionState);
var i: integer;
begin
  if FExecuteState <> Value then
  begin
    if Value = esExecute then
    with InstrumentsActionList do
    for i := 0 to ActionCount - 1 do
      Items[i].ExecutionState := esPreExecute;

    FExecuteState := Value;
    Checked := (Value = esExecute);
  end;
end;

procedure TInstrumentAction.SetInstrument(const Value: TIDObject);
begin
  if FInstrument <> Value then
  begin
    FInstrument := Value;
    Caption := FInstrument.List;
  end;
end;

{ TInstrumentActions }

procedure TInstrumentActions.Clear;
var i: integer;
begin
  for i := ActionCount - 1 downto 0 do
    Items[i].Free;  
end;

function TInstrumentActions.GetActions(
  const Index: integer): TInstrumentAction;
begin
  Result := inherited Items[Index] as TInstrumentAction;
end;

function TInstrumentActions.GetActiveAction: TInstrumentAction;
var i: integer;
begin
  Result := nil;
  for i := 0 to ActionCount - 1 do
  if Items[i].ExecutionState = esExecute then
  begin
    Result := Items[i];
    break;
  end;
end;

end.
