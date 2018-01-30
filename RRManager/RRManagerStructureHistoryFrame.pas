unit RRManagerStructureHistoryFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RRManagerObjects, RRManagerBaseGUI, RRManagerLoaderCommands,
  RRManagerBaseObjects, ToolWin, ComCtrls, StdCtrls, ImgList, RRManagerPersistentObjects,
  RRManagerDataPosters, BaseObjects;

type
  TfrmViewHistory = class(TFrame, IConcreteVisitor)
    gbxStructHistory: TGroupBox;
    tlbrHistory: TToolBar;
    lwStructureHistory: TListView;
    imgList: TImageList;
    procedure lwStructureHistoryAdvancedCustomDrawItem(
      Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
      Stage: TCustomDrawStage; var DefaultDraw: Boolean);
  private
    FStructure: TOldStructure;
    FActnLst: TBaseActionList;
    FPerfHistory: TOldStructureHistory;
    procedure SetStructure(const Value: TOldStructure);
    function  GetStructureHistoryElement: TOldStructureHistoryElement;
    function GetPerfectStructureHistoryElement: TOldStructureHistoryElement;
    { Private declarations }
  protected
    function  GetActiveObject: TIDObject;
    procedure SetActiveObject(const Value: TIDObject);
  public
    { Public declarations }
    property Structure: TOldStructure read FStructure write SetStructure;
    property HistoryElement: TOldStructureHistoryElement read GetStructureHistoryElement;
    property PerfectHistoryElement: TOldStructureHistoryElement read GetPerfectStructureHistoryElement;

    procedure VisitVersion(AVersion: TOldVersion);
    procedure VisitStructure(AStructure: TOldStructure);
    procedure VisitDiscoveredStructure(ADiscoveredStructure: TOldDiscoveredStructure);
    procedure VisitPreparedStructure(APreparedStructure: TOldPreparedStructure);
    procedure VisitDrilledStructure(ADrilledStructure: TOldDrilledStructure);
    procedure VisitField(AField: TOldField);
    procedure VisitHorizon(AHorizon: TOldHorizon);
    procedure VisitSubstructure(ASubstructure: TOldSubstructure);
    procedure VisitLayer(ALayer: TOldLayer);
    procedure VisitBed(ABed: TOldBed);
    procedure VisitAccountVersion(AAccountVersion: TOldAccountVersion);
    procedure VisitStructureHistoryElement(AHistoryElement: TOldStructureHistoryElement);
    procedure VisitOldLicenseZone(ALicenseZone: TOldLicenseZone);

    procedure VisitWell(AWell: TIDObject);
    procedure VisitTestInterval(ATestInterval: TIDObject);
    procedure VisitLicenseZone(ALicenseZone: TIDObject);
    procedure VisitSlotting(ASlotting: TIDObject);

    procedure VisitCollectionWell(AWell: TIDObject);
    procedure VisitCollectionSample(ACollectionSample: TIDObject);
    procedure VisitDenudation(ADenudation: TIDObject);
    procedure VisitWellCandidate(AWellCandidate: TIDObject);
    
    


    procedure   Clear;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;



implementation

uses ActnList, RRManagerStructureHistoryEditForm, Facade;

{$R *.dfm}

type

  TStructureHistoryActionList = class(TBaseActionList)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TStructureHistoryLoadAction = class(TStructureHistoryBaseLoadAction)
  public
    function Execute: boolean; overload; override;
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TStructureHistoryElementEditAction = class(TBaseAction)
  public
    function Execute: boolean; overload; override;
    function Execute(ABaseObject: TBaseObject): boolean; override;
    function Update: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TStructureHistoryElementAddAction = class(TStructureHistoryElementEditAction)
  public
    function Execute: boolean; overload; override;
    function Execute(ABaseObject: TBaseObject): boolean; override;
    function Update: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TStructureHistoryElementStateSpecificParams = class(TBaseAction)

  end;



{ TfrmViewHistory }

procedure TfrmViewHistory.Clear;
begin
  lwStructureHistory.Items.BeginUpdate;
  lwStructureHistory.Clear;
  lwStructureHistory.Items.EndUpdate;
end;

constructor TfrmViewHistory.Create(AOwner: TComponent);
var i: integer;
begin
  inherited;
  FPerfHistory := TOldPerfectStructureHistory.Create(nil);
  FActnLst := TStructureHistoryActionList.Create(Self);
  FActnLst.Images := imgList;

  for i := 0 to FActnLst.ActionCount - 1 do
  begin
    if (FActnLst.Actions[i] as TAction).Visible then
      AddToolButton(tlbrHistory, FActnLst.Actions[i] as TBaseAction)
  end;
end;

destructor TfrmViewHistory.Destroy;
begin
  FPerfHistory.Free;
  FActnLst.Free;
  inherited;
end;

procedure TfrmViewHistory.SetStructure(const Value: TOldStructure);
begin
  if not Assigned(Value) then Clear;

  if FStructure <> Value then
  begin
    FStructure := Value;
    // загружаем историю
    if Assigned(FStructure) then
      FActnLst.ActionByClassType[TStructureHistoryLoadAction].Execute;
  end;
end;

procedure TfrmViewHistory.VisitBed(ABed: TOldBed);
begin

end;

procedure TfrmViewHistory.VisitDiscoveredStructure(
  ADiscoveredStructure: TOldDiscoveredStructure);
begin
  Structure := ADiscoveredStructure;
end;

procedure TfrmViewHistory.VisitDrilledStructure(
  ADrilledStructure: TOldDrilledStructure);
begin
  Structure := ADrilledStructure;
end;

procedure TfrmViewHistory.VisitField(AField: TOldField);
begin
  Structure := AField;
end;

procedure TfrmViewHistory.VisitHorizon(AHorizon: TOldHorizon);
begin
  Structure := AHorizon.Structure;
end;

procedure TfrmViewHistory.VisitLayer(ALayer: TOldLayer);
begin
  if Assigned(ALayer.Substructure) then
    Structure := ALayer.Substructure.Horizon.Structure
  else if Assigned(ALayer.Bed) then
    Structure := ALayer.Bed.Structure;
end;

procedure TfrmViewHistory.VisitPreparedStructure(
  APreparedStructure: TOldPreparedStructure);
begin
  Structure := APreparedStructure;
end;

procedure TfrmViewHistory.VisitStructure(AStructure: TOldStructure);
begin
  Structure := AStructure;
end;

procedure TfrmViewHistory.VisitSubstructure(ASubstructure: TOldSubstructure);
begin
  Structure := ASubstructure.Horizon.Structure;
end;

function TfrmViewHistory.GetStructureHistoryElement: TOldStructureHistoryElement;
begin
  if Assigned(lwStructureHistory.Selected) then
  begin
    if TObject(lwStructureHistory.Selected.Data) is TOldPerfectStructureHistoryElement then
      Result := (TObject(lwStructureHistory.Selected.Data) as TOldPerfectStructureHistoryElement).RealStructureHistoryElement
    else
      Result := nil;
  end;
end;

function TfrmViewHistory.GetPerfectStructureHistoryElement: TOldStructureHistoryElement;
begin
  if Assigned(lwStructureHistory.Selected) then
  begin
    if TObject(lwStructureHistory.Selected.Data) is TOldPerfectStructureHistoryElement then
      Result := (TObject(lwStructureHistory.Selected.Data) as TOldPerfectStructureHistoryElement)
    else
      Result := nil;
  end;
end;

procedure TfrmViewHistory.VisitAccountVersion(
  AAccountVersion: TOldAccountVersion);
begin
  Structure := AAccountVersion.Structure;
end;

procedure TfrmViewHistory.VisitStructureHistoryElement(
  AHistoryElement: TOldStructureHistoryElement);
begin

end;

procedure TfrmViewHistory.VisitVersion(AVersion: TOldVersion);
begin
  { TODO : 
совокупность изменений произошедших между версиями можно выводить.
только тогда нужно ввести типизацию какую-то изменений. }
end;

procedure TfrmViewHistory.VisitOldLicenseZone(ALicenseZone: TOldLicenseZone);
begin

end;

function TfrmViewHistory.GetActiveObject: TIDObject;
begin
  Result := Structure;
end;

procedure TfrmViewHistory.SetActiveObject(const Value: TIDObject);
begin

end;

procedure TfrmViewHistory.VisitLicenseZone(ALicenseZone: TIDObject);
begin

end;

procedure TfrmViewHistory.VisitSlotting(ASlotting: TIDObject);
begin

end;

procedure TfrmViewHistory.VisitTestInterval(ATestInterval: TIDObject);
begin

end;

procedure TfrmViewHistory.VisitWell(AWell: TIDObject);
begin

end;

procedure TfrmViewHistory.VisitCollectionSample(
  ACollectionSample: TIDObject);
begin

end;

procedure TfrmViewHistory.VisitCollectionWell(AWell: TIDObject);
begin

end;

procedure TfrmViewHistory.VisitDenudation(ADenudation: TIDObject);
begin

end;

procedure TfrmViewHistory.VisitWellCandidate(AWellCandidate: TIDObject);
begin

end;

{ TStructureHistoryLoadAction }

constructor TStructureHistoryLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Загрузить историю';
  Visible := false;
  Enabled := false;
end;

function TStructureHistoryLoadAction.Execute: boolean;
begin
  Result := Execute((ActionList.Owner as TfrmViewHistory).Structure);
end;

function TStructureHistoryLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var i, j: integer;
    s: TOldStructure;
    h: TOldStructureHistoryElement;
    psh: TOldPerfectStructureHistory;
    li: TListItem;
begin
  Result := inherited Execute(ABaseObject);

  if Result then
  begin
    // мы знаем, в каком порядке должны следовать элементы истории
    // поэтому сначала составляем список идеальных элементов истории
    // а затем, заменяем реальными всё что можно

    s := ABaseObject as TOldStructure;
    with (ActionList.Owner as TfrmViewHistory) do
    begin
      lwStructureHistory.Items.BeginUpdate;
      lwStructureHistory.Items.Clear;

      psh := FPerfHistory as TOldPerfectStructureHistory;
      psh.RestoreState;
      for i := 0 to psh.Count - 1 do
      begin
        li := lwStructureHistory.Items.Add;
        li.Caption := psh.Items[i].List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false);
        li.Data := psh.Items[i];
        //li.StateIndex := psh.Items[i].FundTypeID - 1;
        li.ImageIndex := psh.Items[i].FundTypeID + 7;
      end;

      lwStructureHistory.Items.EndUpdate;
    end;

    // загружаем в список
    with (ActionList.Owner as TfrmViewHistory).lwStructureHistory do
    begin
      for i := 0 to psh.Count - 1 do
      for j := 0 to s.History.Count - 1 do
      if s.History.Items[j].FundTypeID = psh.Items[i].FundTypeID then
      begin
        psh.Items[i].ActionDate := s.History.Items[j].ActionDate;
        psh.Items[i].ActionReasonID := s.History.Items[j].ActionReasonID;
        psh.Items[i].ActionReason  := s.History.Items[j].ActionReason;
        psh.Items[i].Comment := s.History.Items[j].Comment;

        psh.Items[i].EmployeeID := s.History.Items[j].EmployeeID;
        psh.Items[i].Employee := s.History.Items[j].Employee;
        psh.Items[i].RealDate := s.History.Items[j].RealDate;
        psh.Items[i].ID := s.History.Items[j].ID;

        psh.Items[i].RealStructureHistoryElement := s.History.Items[j];

        Items[i].ImageIndex := psh.Items[i].FundTypeID;
      end;
    end;
  end;
end;

{ TStructureHistoryActionList }

constructor TStructureHistoryActionList.Create(AOwner: TComponent);
var actn: TBaseAction;
begin
  inherited;

  actn := TStructureHistoryLoadAction.Create(Self);
  actn.ActionList := Self;

  actn := TStructureHistoryElementEditAction.Create(Self);
  actn.ActionList := Self;

  actn := TStructureHistoryElementAddAction.Create(Self);
  actn.ActionList := Self;
end;

procedure TfrmViewHistory.lwStructureHistoryAdvancedCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
var h: TOldPerfectStructureHistoryElement;
begin
  h := TOldPerfectStructureHistoryElement(Item.Data);
  // меняем цвет на серый
  if not Assigned(h.RealStructureHistoryElement) then
  begin
    lwStructureHistory.Canvas.Font.Color := clGrayText;
  end
  else
  begin
    //lwStructureHistory.Canvas.Font.Style := [fsBold];
  end;

end;


{ TStructureHistoryElementEditAction }

constructor TStructureHistoryElementEditAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Редактировать элемент истории';
  Visible := true;
  Enabled := true;
  ImageIndex := 15;
end;

function TStructureHistoryElementEditAction.Execute: boolean;
begin
  Result := Execute((ActionList.Owner as TfrmViewHistory).HistoryElement);
end;

function TStructureHistoryElementEditAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: RRManagerPersistentObjects.TDataPoster;
    h: TOldStructureHistoryElement;
    lw: TListView;
begin
  Result := true;
  if not Assigned(frmStructureHistoryEdit) then frmStructureHistoryEdit := TfrmStructureHistoryEdit.Create(Self);
  frmStructureHistoryEdit.Prepare((ABaseObject as TOldStructureHistoryElement).FundTypeID);
  frmStructureHistoryEdit.EditingObject := ABaseObject;
  frmStructureHistoryEdit.RealStructure := (ActionList.Owner as TfrmViewHistory).FStructure;

  if frmStructureHistoryEdit.ShowModal = mrOK then
  begin
    frmStructureHistoryEdit.Save;
    ABaseObject := frmStructureHistoryEdit.EditingObject;
    h := ABaseObject as TOldStructureHistoryElement;

    // берем постер для структуры
    dp := nil;
    if h.HistoryStructure is TOldDiscoveredStructure then
      dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TDiscoveredStructureDataPoster]
    else if h.HistoryStructure is TOldPreparedStructure then
      dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TPreparedStructureDataPoster]
    else if h.HistoryStructure is TOldDrilledStructure then
      dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TDrilledStructureDataPoster]
    else if h.HistoryStructure is TOldField then
      dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TFieldDataPoster];
    // сохраняем старое состояние
    if Assigned(dp) then dp.PostToDB(h.HistoryStructure);


    // берем постер
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TStructureHistoryDataPoster];
    // инициализируем коллекцию
    dp.PostToDB(ABaseObject);


    // обновляем представление
    lw := (ActionList.Owner as TfrmViewHistory).lwStructureHistory;
    if TObject(lw.Selected.Data) is TOldPerfectStructureHistoryElement then
      lw.Selected.Caption := ABaseObject.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false);
  end;
end;

function TStructureHistoryElementEditAction.Update: boolean;
var lw: TListView;
    pfsh: TOldPerfectStructureHistoryElement;
begin
  inherited Update;
  lw := (ActionList.Owner as TfrmViewHistory).lwStructureHistory;
  Result :=  Assigned(lw.Selected) and Assigned((ActionList.Owner as TfrmViewHistory).HistoryElement);

  Enabled := Result;
end;

{ TStructureHistoryElementAddAction }

constructor TStructureHistoryElementAddAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Добавить элемент истории';
  Visible := true;
  Enabled := true;
  ImageIndex := 16;
end;

function TStructureHistoryElementAddAction.Execute: boolean;
begin
  Result := Execute((ActionList.Owner as TfrmViewHistory).PerfectHistoryElement);
end;

function TStructureHistoryElementAddAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: RRManagerPersistentObjects.TDataPoster;
    h: TOldStructureHistoryElement;
    lw: TListView;
begin
  Result := true;
  if not Assigned(frmStructureHistoryEdit) then frmStructureHistoryEdit := TfrmStructureHistoryEdit.Create(Self);
  frmStructureHistoryEdit.Prepare((ABaseObject as TOldStructureHistoryElement).FundTypeID);
  frmStructureHistoryEdit.EditingObject := ABaseObject;
  frmStructureHistoryEdit.RealStructure := (ActionList.Owner as TfrmViewHistory).FStructure;  

  if frmStructureHistoryEdit.ShowModal = mrOK then
  begin
    frmStructureHistoryEdit.Save;
    ABaseObject := frmStructureHistoryEdit.EditingObject;
    // создаем объект
    with (ActionList.Owner as TfrmViewHistory) do
    begin
      h := Structure.History.Add;
      h.Assign(ABaseObject);
      (ABaseObject as TOldPerfectStructureHistoryElement).RealStructureHistoryElement := h;
    end;
    // берем постер
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TStructureHistoryDataPoster];
    // инициализируем коллекцию
    dp.PostToDB(h);

    // обновляем представление
    lw := (ActionList.Owner as TfrmViewHistory).lwStructureHistory;
    if TObject(lw.Selected.Data) is TOldPerfectStructureHistoryElement then
    begin
      lw.Selected.Caption := ABaseObject.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false);
      lw.Selected.ImageIndex := lw.Selected.ImageIndex - 7;
    end;
  end;
end;

function TStructureHistoryElementAddAction.Update: boolean;
var lw: TListView;
begin
  inherited Update;
  lw := (ActionList.Owner as TfrmViewHistory).lwStructureHistory;
  Result :=  Assigned(lw.Selected) and Assigned((ActionList.Owner as TfrmViewHistory).PerfectHistoryElement) and not Assigned((ActionList.Owner as TfrmViewHistory).HistoryElement)
             and ((ActionList.Owner as TfrmViewHistory).Structure.StructureTypeID > (ActionList.Owner as TfrmViewHistory).PerfectHistoryElement.LastFundTypeID);

  Enabled := Result;
end;

end.
