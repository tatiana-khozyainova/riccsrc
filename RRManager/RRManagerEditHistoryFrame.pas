unit RRManagerEditHistoryFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RRManagerObjects, RRManagerBaseObjects, StdCtrls, CommonComplexCombo,
  ComCtrls, Buttons, Mask, ToolEdit, RRManagerBaseGUI;

type
  TfrmHistory = class(TBaseFrame)
//  TfrmHistory = class(TFrame)
    gbxAll: TGroupBox;
    lblDisclaimer: TLabel;
    cmplxActionType: TfrmComplexCombo;
    cmplxActionReason: TfrmComplexCombo;
    mmReason: TMemo;
    lblDescription: TLabel;
    sbtnShowHistory: TSpeedButton;
    lwHistory: TListView;
    dtedtActionDate: TDateEdit;
    Label1: TLabel;
    edtWhoWhen: TEdit;
    procedure sbtnShowHistoryClick(Sender: TObject);
    procedure lwHistoryChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
  private
    { Private declarations }
    FHistory: TOldStructureHistory;
    FHistoryElement: TOldStructureHistoryElement;
    FTheOnlyActionType: boolean;
    function  GetStructure: TOldStructure;
    function  GetHistory: TOldStructureHistory;
    procedure ClearOnlyControls;
    procedure SetHistoryElement(const Value: TOldStructureHistoryElement);
    procedure SetTheOnlyActionType(const Value: boolean);
    function  GetRealHistoryElement: TOldStructureHistoryElement;
  protected
    procedure ClearControls; override;
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure RegisterInspector; override;
  public
    { Public declarations }
    property History: TOldStructureHistory read GetHistory;
    property HistoryElement: TOldStructureHistoryElement read FHistoryElement write SetHistoryElement;
    property Structure: TOldStructure read GetStructure;
    property RealHistoryElement: TOldStructureHistoryElement read GetRealHistoryElement;
    // можно ли менять тип действия
    // по умолчанию нельзя
    property TheOnlyActionType: boolean read FTheOnlyActionType write SetTheOnlyActionType;
    procedure Save; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;


implementation

uses RRManagerLoaderCommands;

const sDisclaimer = 'Вы %s. Это серьезное изменение, которое требует отдельной регистрации. Заполните, пожалуйста, регистрационную форму.';

type
   TStructureHistoryLoadAction = class(TStructureHistoryBaseLoadAction)
   public
     function Execute(ABaseObject: TBaseObject): boolean; override;
   end;

{$R *.DFM}

{ TfrmHistory }

procedure TfrmHistory.ClearControls;
begin
//  FHistory.Free;
//  FHistory := nil;
  ClearOnlyControls;
end;

procedure TfrmHistory.ClearOnlyControls;
begin
  lwHistory.Items.Clear;
  cmplxActionReason.Clear;
  mmReason.Lines.Clear;

  sbtnShowHistory.Down := false;
  lwHistory.Visible := sbtnShowHistory.Down;
end;

constructor TfrmHistory.Create(AOwner: TComponent);
begin
  inherited;

  cmplxActionType.Caption := 'Тип действия';
  cmplxActionType.FullLoad := true;
  cmplxActionType.DictName := 'TBL_ACTION_TYPE_DICT';

  cmplxActionReason.Caption := 'Причина действия (общая)';
  cmplxActionReason.FullLoad := true;
  cmplxActionReason.DictName := 'TBL_ACTION_REASON_DICT';

  TheOnlyActionType := false;
  NeedCopyState := false;
end;

procedure TfrmHistory.FillControls(ABaseObject: TBaseObject);
var actn: TBaseAction;
    RealElement, el: TOldStructureHistoryElement;
    S: TOldStructure;
begin
  s := nil;
  if not Assigned(ABaseObject) then S := Structure
  else if ABaseObject is TOldStructure then
    S := ABaseObject as TOldStructure;

  sbtnShowHistory.Down := false;
  lwHistory.Visible := sbtnShowHistory.Down;
  // сначала сохраняем элемент истории добавленный в прошлом фрэйме
  // непосредственно при изменении
  if Assigned(S) then
  begin
    RealElement := TOldStructureHistoryElement.Create(nil);
    RealElement.Assign(S.LastHistoryElement);

    // копируем историю - на случай, если не будем сохранять
    actn := TStructureHistoryLoadAction.Create(Self);
    actn.Execute(S);
    actn.Free;

    if Assigned(FHistory) then
    begin
      FHistory.Free;
      FHistory := nil;
    end;

    // добавляем реальный последний элемент
    el := History.Add;
    el.Assign(RealElement);
    // и загружаем его в интерфейс
    HistoryElement := el;

    // этот более не нужен
    RealElement.Free;
  end
  else if Assigned(ABaseObject) and (ABaseObject is TOldStructureHistoryElement)  then
  begin
    HistoryElement := ABaseObject as TOldStructureHistoryElement;
  end
  else if Assigned(RealHistoryElement) then
  begin
    HistoryElement := RealHistoryElement;
  end;

  Check;
  
{  if lwHistory.Items.Count > 0 then
    lwHistory.Selected := lwHistory.Items[0];}
end;

function TfrmHistory.GetHistory: TOldStructureHistory;
begin
  Result := nil;
  if Assigned(FHistory) then Result := FHistory
  else
  if Assigned(Structure) then
  begin
    FHistory := TOldStructureHistory.Create(nil);
    FHistory.Assign(Structure.History);
    Result := FHistory;
  end;
end;

function TfrmHistory.GetStructure: TOldStructure;
begin
  if EditingObject is TOldStructure then
    Result := EditingObject as TOldStructure
  else
    Result := nil;
end;

procedure TfrmHistory.Save;
begin
  inherited;
  FHistoryElement.ActionTypeID := cmplxActionType.SelectedElementID;
  FHistoryElement.ActionType := cmplxActionType.SelectedElementName;
  FHistoryElement.ActionReasonID := cmplxActionReason.SelectedElementID;
  FHistoryElement.ActionReason := cmplxActionReason.SelectedElementName;
  FHistoryElement.Comment := mmReason.Text; 

  if Assigned(Structure) and Assigned(History) then
  begin
    FHistoryElement.FundTypeID := Structure.StructureTypeID;
    FHistoryElement.FundType := Structure.StructureType;

    Structure.History.Assign(History)
  end
  else if Assigned(RealHistoryElement) then
    RealHistoryElement.Assign(FHistoryElement);

end;

procedure TfrmHistory.sbtnShowHistoryClick(Sender: TObject);
begin
  sbtnShowHistory.Down := not sbtnShowHistory.Down;
  lwHistory.Visible := sbtnShowHistory.Down;
end;

procedure TfrmHistory.SetHistoryElement(
  const Value: TOldStructureHistoryElement);
begin
  FHistoryElement := Value;

  if Assigned(FHistoryElement) then
  begin
    cmplxActionType.AddItem(FHistoryElement.ActionTypeID, FHistoryElement.ActionType);
    cmplxActionReason.AddItem(FHistoryElement.ActionReasonID, FHistoryElement.ActionReason);
    dtedtActionDate.Date := FHistoryElement.ActionDate;
    mmReason.Text := FHistoryElement.Comment;
    // в лэйбл пишем то, что отличает конкретный структурный элемент
    lblDisclaimer.Caption := Format(sDisclaimer, [FHistoryElement.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false)]);
    edtWhoWhen.Text := 'Изменено: ' + DateTimeToStr(FHistoryElement.RealDate) + '; автор: ' + FHistoryElement.Employee; 
  end
  else ClearOnlyControls;
end;

destructor TfrmHistory.Destroy;
begin
  inherited;
  FHistory.Free;
end;

procedure TfrmHistory.SetTheOnlyActionType(const Value: boolean);
begin
  FTheOnlyActionType := Value;
  cmplxActionType.Enabled := FTheOnlyActionType;
end;

procedure TfrmHistory.RegisterInspector;
begin
  inherited;
  Inspector.Add(cmplxActionType.cmbxName, nil, ptString, 'тип действия', false);
  Inspector.Add(cmplxActionReason.cmbxName, nil, ptString, 'причина действия', false);
end;

function TfrmHistory.GetRealHistoryElement: TOldStructureHistoryElement;
begin
  if EditingObject is TOldStructureHistoryElement then
    Result := EditingObject as TOldStructureHistoryElement
  else
    Result := nil;
end;

{ TStructureHistoryLoadAction }

function TStructureHistoryLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var i: integer;
    li: TListItem;
begin
  LastCollection := (ABaseObject as TOldStructure).History;
  if LastCollection.NeedsUpdate then
    Result := inherited Execute(ABaseObject)
  else Result := true;

  if Result then
  begin
    // загружаем в интерфейс
    if Assigned(LastCollection) then
    with Owner as TfrmHistory do
    begin
      // получаем версии на форму
      History;

      lwHistory.Items.BeginUpdate;
      lwHistory.Selected := nil;
      // чистим

      try
        lwHistory.Items.Clear;
      except

      end;


      // добавляем в дерево не реальные версии
      // а их копии, чтобы потом сохранять изменения
      for i := 0 to History.Count - 1 do
      begin
        li := lwHistory.Items.Add;
        li.Caption := History.Items[i].List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false);
        li.Data := History.Items[i];
      end;

      lwHistory.Items.EndUpdate;
    end;
  end;
end;

procedure TfrmHistory.lwHistoryChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if Change = ctState then
  begin
    if Assigned(Item) then
    begin
      Item.Selected := true;
      HistoryElement := TOldStructureHistoryElement(Item.Data);
    end
    else HistoryElement := nil;
  end
end;

end.
