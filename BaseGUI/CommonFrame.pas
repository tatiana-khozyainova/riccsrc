unit CommonFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseObjects, BaseGUI, ComCtrls, FramesWizard, CoreInterfaces, LoggerImpl;

type
  TfrmCommonFrame = class;
  TCommonFrameClass = class of TfrmCommonFrame;

  TfrmCommonFrame = class(TFrame, ILogger)
    StatusBar: TStatusBar;
    procedure StatusBarDrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
  private
    FEditingClass: TIDObjectClass;
    FParentClass: TIDObjectClass;
    FInspector: THintManager;
    FNeedCopyState: boolean;
    FShadeEditingObject: TIDObject;
    FNeedsShadeEditing: boolean;
    FShowStatus: boolean;
    FViewOnly: Boolean;
    FDataLoaded: boolean;
    procedure SetEditingObject(const Value: TIDObject);
    function  GetShadeEditingObject: TIDObject;
    procedure SetShowStatus(const Value: boolean);
    function  GetLogger: TMemoLogger;
  protected
    FEditingObject: TIDObject;
    FSaved: boolean;
    FEdited: boolean;
    procedure FillControls(ABaseObject: TIDObject); virtual;
    procedure ClearControls; virtual;
    procedure FillParentControls; virtual;
    procedure RegisterInspector; virtual;
    procedure CheckEvent(Sender: TObject);
    function  InternalCheck: boolean; virtual;
    function  GetParentCollection: TIDObjects; virtual;
    procedure CopyEditingValues(Dest: TIDObject); virtual;
    procedure SetViewOnly(const Value: Boolean); virtual;
    function  GetEditingObject: TIDObject;
  public
    property DataLoaded: boolean read FDataLoaded write FDataLoaded; 
    property Logger: TMemoLogger read GetLogger implements ILogger;
    property Inspector: THintManager read FInspector write FInspector;
    function Check: boolean; virtual;
    function UnCheck: boolean;
    property EditingClass: TIDObjectClass read FEditingClass write FEditingClass;
    property ParentClass: TIDObjectClass read FParentClass write FParentClass;

    property EditingObject: TIDObject read GetEditingObject write SetEditingObject;
    property ShadeEditingObject: TIDObject read GetShadeEditingObject;
    property NeedsShadeEditing: boolean read FNeedsShadeEditing write FNeedsShadeEditing;
    property ShowStatus: boolean read FShowStatus write SetShowStatus;

    property ParentCollection: TIDObjects read GetParentCollection;

    property Edited: boolean read FEdited write FEdited;
    property Saved: boolean read FSaved;
    property ViewOnly: Boolean read FViewOnly write SetViewOnly;

    procedure Clear; virtual;

    procedure Save(AObject: TIDObject = nil); virtual;
    procedure CancelEdit; virtual;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

{$R *.dfm}

{ TBaseFrame }

procedure TfrmCommonFrame.CancelEdit;
begin
end;

function TfrmCommonFrame.Check: boolean;
begin
  Result := FInspector.Check and InternalCheck;

  if Owner is TDialogFrame then
  with Owner as TDialogFrame do
  begin
    btnNext.Enabled :=  (NextActiveFrameIndex < FrameCount - 1) and Result;

    if FinishEnableIndex > -1 then
       btnFinish.Enabled := (FrameCount > 0) and (NextActiveFrameIndex >= FinishEnableIndex)
    else btnFinish.Enabled := (FrameCount > 0) and not btnNext.Enabled;

    btnFinish.Enabled := btnFinish.Enabled and Result;
  end;
end;

procedure TfrmCommonFrame.CheckEvent(Sender: TObject);
begin
  Check;
end;


procedure TfrmCommonFrame.Clear;
begin
  FEditingObject := nil;
  FShadeEditingObject := nil;
  ClearControls;
end;

procedure TfrmCommonFrame.ClearControls;
begin
  FEditingObject := nil;
  FShadeEditingObject := nil;
  FDataLoaded := false;
end;

procedure TfrmCommonFrame.CopyEditingValues(Dest: TIDObject);
begin
  
end;

constructor TfrmCommonFrame.Create(AOwner: TComponent);
begin
  inherited;
  FEdited := false;
  FSaved := false;
  FNeedCopyState := true;

  FEditingClass := TIDObject;
  FNeedsShadeEditing := true;
  FShowStatus := true;


  FInspector := THintManager.Create(StatusBar);
  FInspector.CheckEvent := CheckEvent;
end;

destructor TfrmCommonFrame.Destroy;
begin
  FInspector.Free;
  inherited;
end;

procedure TfrmCommonFrame.FillControls(ABaseObject: TIDObject);
begin
  FShadeEditingObject := nil;
  DataLoaded := Assigned(EditingObject);
end;

procedure TfrmCommonFrame.FillParentControls;
begin
  DataLoaded := Assigned(EditingObject);
end;

function TfrmCommonFrame.GetEditingObject: TIDObject;
begin
  Result := FEditingObject;
end;

function TfrmCommonFrame.GetLogger: TMemoLogger;
begin
  Result := TMemoLogger.GetInstance;
end;

function TfrmCommonFrame.GetParentCollection: TIDObjects;
begin
  Result := nil;
end;

function TfrmCommonFrame.GetShadeEditingObject: TIDObject;
begin
  if NeedsShadeEditing then
  begin
    if not Assigned(FShadeEditingObject) then
    begin
      if Assigned(EditingObject) and (EditingObject is EditingClass) then
        FShadeEditingObject := EditingClass.Create(ParentCollection)
      else
      if Assigned(EditingObject) and (EditingObject is ParentClass) then
        FShadeEditingObject := EditingClass.Create(ParentCollection) as TIDObject
      else
        FShadeEditingObject := EditingClass.Create(nil) as TIDObject;
    end;

    Result := FShadeEditingObject;
  end
  else Result := FEditingObject;

  CopyEditingValues(Result);
end;

function TfrmCommonFrame.InternalCheck: boolean;
begin
  Result := true;
end;

procedure TfrmCommonFrame.RegisterInspector;
begin
  FInspector.Clear;
end;

procedure TfrmCommonFrame.Save(AObject: TIDObject = nil);
begin
  FEdited := false;
  FSaved := true;
end;

procedure TfrmCommonFrame.SetEditingObject(const Value: TIDObject);
begin
  if (Value = nil) and ((not Edited) or Saved) then ClearControls;
  RegisterInspector;

  if FEditingObject <> Value then
  begin
    FEditingObject := Value;
    if  Assigned(FEditingObject) and (FEditingObject.ID > 0) and (FEditingObject is EditingClass) then
      FillControls(nil)
    else if (Assigned(FEditingObject) and
            (FEditingObject.ID <= 0) and (FEditingObject is EditingClass)) then
    begin
      FillControls(nil);
      FillParentControls;
    end
    else if (Assigned(FEditingObject) and Assigned(ParentClass) and (FEditingObject is ParentClass)) then
      FillParentControls
    else ClearControls;

    if Assigned(FEditingObject) then
    begin
      StatusBar.Panels[1].Text := FEditingObject.List;//(loBrief, false, true);
      StatusBar.Hint := StatusBar.Panels[1].Text;
      Caption := StatusBar.Panels[1].Text;
      StatusBar.ShowHint := true;
    end
  end;

  FEdited := true;
  FSaved := false;
  Check;
end;

procedure TfrmCommonFrame.SetShowStatus(const Value: boolean);
begin
  FShowStatus := Value;
  StatusBar.Visible := FShowStatus;
end;

procedure TfrmCommonFrame.SetViewOnly(const Value: Boolean);
begin
  FViewOnly := Value;
end;

function TfrmCommonFrame.UnCheck: boolean;
var i: integer;
begin
  Result := true;
  if Owner is TDialogFrame then
  with Owner as TDialogFrame do
  begin
    btnNext.Enabled := (ActiveFrameIndex < FrameCount);


    if FinishEnableIndex > -1 then
       btnFinish.Enabled := (FrameCount > 0) and (ActiveFrameIndex >= FinishEnableIndex)
    else btnFinish.Enabled := (FrameCount > 0) and not btnNext.Enabled;

    for i := 0 to StatusBar.Panels.Count - 2 do
      StatusBar.Panels[i].Text := '';
  end;
end;


procedure TfrmCommonFrame.StatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
  with StatusBar.Canvas do
  begin
     case Panel.Index of
     0: //fist panel
     begin
       if Panel.Text <> '' then
         Brush.Color := clRed
       else
         Brush.Color := clGreen;

       FillRect(Rect) ;
       TextRect(Rect, 1 + Rect.Left, 1 + Rect.Top,Panel.Text) ;
     end;
  end;
end;

end;
end.
