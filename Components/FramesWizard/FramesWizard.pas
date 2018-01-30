unit FramesWizard;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ActnList;

type
  TFrameClass = class of TFrame;
  TButtons = set of (btPrev, btNext, btFinish, btCancel);
  TButtonStateValidateEvent = procedure(Sender: TObject; var EnabledState: boolean) of object;


  TDialogFrame = class(TFrame)
    pnlButtons: TPanel;
    btnPrev: TButton;
    btnNext: TButton;
    btnFinish: TButton;
    btnCancel: TButton;
    actnLst: TActionList;
    actnFinish: TAction;
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure actnFinishExecute(Sender: TObject);
    procedure actnFinishUpdate(Sender: TObject);
  private
    { Private declarations }
    FList: TList;
    FActiveFrameIndex: integer;
    FOnFinishClick: TNotifyEvent;
    FFinishEnableIndex: integer;
    FOnCancelClick: TNotifyEvent;
    FOnBeforePageChangeEvent: TNotifyEvent;
    FOnAfterPageChangeEvent: TNotifyEvent;
    FButtons: TButtons;
    FLastActiveFrameIndex: integer;
    FNextActiveFrameIndex: integer;
    FCloseAfterFinish: boolean;
    FOnFinishValidate: TButtonStateValidateEvent;
    function  GetFrames(const Index: integer): TFrame;
    function  GetFrameCount: integer;
    procedure HideAll;
    procedure SetActiveFrameIndex(const Value: integer);
    procedure SyncButtons; overload;
    procedure SyncButtons(APageIndex: integer); overload;
    procedure SetButtons(const Value: TButtons);

    procedure SetFinishEnableIndex(const Value: integer);
    procedure SetCloseAfterFinish(const Value: boolean);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    property    Frames[const Index: integer]: TFrame read GetFrames;
    function    AddFrame(AFrame: TFrame): TFrame; overload;
    function    AddFrame(AFrameClass: TFrameClass): TFrame; overload;
    procedure   Delete(const Index: integer);
    procedure   Clear;
    property    ActiveFrameIndex: integer read FActiveFrameIndex write SetActiveFrameIndex;
    property    LastActiveFrameIndex: integer read FLastActiveFrameIndex;
    property    NextActiveFrameIndex: integer read FNextActiveFrameIndex;
    property    FrameCount: integer read GetFrameCount;
    property    CloseAfterFinish: boolean read FCloseAfterFinish write SetCloseAfterFinish;
  published
    property    FinishEnableIndex: integer  read FFinishEnableIndex write SetFinishEnableIndex;
    property    OnFinishClick: TNotifyEvent read FOnFinishClick write FOnFinishClick;
    property    OnCancelClick: TNotifyEvent read FOnCancelClick write FOnCancelClick;
    property    OnBeforePageChange: TNotifyEvent read FOnBeforePageChangeEvent write FOnBeforePageChangeEvent;
    property    OnAfterPageChange: TNotifyEvent read FOnAfterPageChangeEvent write FOnAfterPageChangeEvent;
    property    OnFinishValidate: TButtonStateValidateEvent read FOnFinishValidate write FOnFinishValidate;

    property    Buttons: TButtons read FButtons write SetButtons;
  end;

  procedure Register;

implementation

{$R *.DFM}



{ TDialogFrame }

procedure Register;
begin
  RegisterComponents('MyOwn', [TDialogFrame]);
end;


function TDialogFrame.AddFrame(AFrame: TFrame): TFrame; 
begin
  Result := AFrame;
  FList.Add(AFrame);
  Result.Visible := true;
  Result.Align := alClient;
  SyncButtons;
end;

function TDialogFrame.AddFrame(AFrameClass: TFrameClass): TFrame;
begin
  Result := AFrameClass.Create(Self);
  Result.Name := Copy(AFrameClass.ClassName, 2, Length(AFrameClass.ClassName)) + IntToStr(FrameCount);
  Result.Parent := Self;
  AddFrame(Result);
end;

constructor TDialogFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CloseAfterFinish := true;
  FActiveFrameIndex := -1;
  FList := TList.Create;
  SyncButtons;
  Buttons := [btPrev, btNext, btCancel, btFinish];
end;

destructor TDialogFrame.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TDialogFrame.GetFrameCount: integer;
begin
  Result := FList.Count;
end;

function TDialogFrame.GetFrames(const Index: integer): TFrame;
begin
  Result := TFrame(FList.Items[Index]);
end;

procedure TDialogFrame.HideAll;
var i: integer;
begin
  for i := 0 to FrameCount - 1 do
    Frames[i].Visible := false;
end;

procedure TDialogFrame.SetActiveFrameIndex(const Value: integer);
begin
  if (FActiveFrameIndex <> Value) and (Value < FrameCount) then
  begin
    FLastActiveFrameIndex := FActiveFrameIndex;
    FNextActiveFrameIndex := Value;

    SyncButtons(Value);

    if Assigned(FOnBeforePageChangeEvent)
       and (Value in [0..FrameCount -1]) then FOnBeforePageChangeEvent(Frames[FNextActiveFrameIndex]);

    FActiveFrameIndex := Value;
    HideAll;

    Frames[FActiveFrameIndex].Visible := true;

    if FLastActiveFrameIndex > -1 then
      if Assigned(FOnAfterPageChangeEvent) then FOnAfterPageChangeEvent(Frames[FLastActiveFrameIndex]);
  end;
end;

procedure TDialogFrame.btnPrevClick(Sender: TObject);
begin
  ActiveFrameIndex := ActiveFrameIndex - 1;
  //SyncButtons;
end;

procedure TDialogFrame.btnNextClick(Sender: TObject);
begin
  ActiveFrameIndex := ActiveFrameIndex + 1;
  //SyncButtons;
end;

procedure TDialogFrame.SyncButtons;
begin
  SyncButtons(ActiveFrameIndex);
end;

procedure TDialogFrame.btnCancelClick(Sender: TObject);
begin
  if Assigned(FOnCancelClick) then FOnCancelClick(Sender);
end;

procedure TDialogFrame.SetButtons(const Value: TButtons);
begin
  if FButtons <> Value then
  begin
    FButtons := Value;
    btnCancel.Visible := btCancel in FButtons;
   // btnCancel.Left := Self.Width - (btnCancel.Width + 5);

    btnFinish.Visible := btFinish in FButtons;
   // btnFinish.Left := Self.Width - 2*(btnCancel.Width + 5);

    btnNext.Visible := btNext in FButtons;
    //btnNext.Left := Self.Width - 3*(btnCancel.Width + 5);

    btnPrev.Visible := btPrev in FButtons;
    //btnPrev.Left := Self.Width - 4*(btnCancel.Width + 5);
  end;
end;

procedure TDialogFrame.Delete(const Index: integer);
begin
  Frames[Index].Free;
  FList.Delete(Index);
end;

procedure TDialogFrame.Clear;
var i: integer;
begin
  FActiveFrameIndex := -1;
  for i := FrameCount - 1 downto 0 do
    Delete(i);
  FLIst.Clear;  
end;

procedure TDialogFrame.SetFinishEnableIndex(const Value: integer);
begin
  if FFinishEnableIndex <> Value then
  begin
    FFinishEnableIndex := Value;
    SyncButtons;
  end;
end;

procedure TDialogFrame.SyncButtons(APageIndex: integer);
begin
  btnPrev.Enabled := (FrameCount > 0) and not(APageIndex = 0);
  btnNext.Enabled := (FrameCount > 0) and not(APageIndex = FrameCount - 1);
  if FinishEnableIndex > -1 then
     btnFinish.Enabled := (FrameCount > 0) and (APageIndex >= FinishEnableIndex)
  else btnFinish.Enabled := (FrameCount > 0) and not btnNext.Enabled;
end;

procedure TDialogFrame.SetCloseAfterFinish(const Value: boolean);
begin
  FCloseAfterFinish := Value;
  if FCloseAfterFinish then
  begin
    btnFinish.ModalResult := mrOK;
    btnCancel.Caption := 'Отмена';
  end
  else
  begin
    btnFinish.ModalResult := mrNone;
    btnCancel.Caption := 'Закрыть';    
  end;
end;

procedure TDialogFrame.actnFinishExecute(Sender: TObject);
begin
  if Assigned(FOnFinishClick) then FOnFinishClick(Sender);
end;

procedure TDialogFrame.actnFinishUpdate(Sender: TObject);
var bResult: boolean;
begin
  bResult := true;
  if Assigned(FOnFinishValidate) then FOnFinishValidate(Sender, bResult);

  if FinishEnableIndex > -1 then
     actnFinish.Enabled  := bResult and (FrameCount > 0) and (NextActiveFrameIndex >= FinishEnableIndex)
  else actnFinish.Enabled := bResult and (FrameCount > 0) and not btnNext.Enabled;
end;

end.
