unit CoreTransfer;

interface

uses Registrator, BaseObjects, ComCtrls, Classes, SlottingWell, Slotting, SlottingPlacement, GeneralizedSection, Well;

type
  TCoreTransferType = class;
  TCoreTransferTypes = class;
  TCoreTransfer = class;
  TCoreTransfers = class;
  TCoreTransferTask = class;
  TCoreTransferTasks = class;

  TCoreTransferTypePresence = (cttvTransfer, cttvRepackaging, cttvDisposition, cttvIntake);
  TCoreTransferTypesPresence = set of TCoreTransferTypePresence;


  TCoreTransferType = class(TRegisteredIDObject)
  private
    function GetCoreTransferTypePresence: TCoreTransferTypePresence;
  public
    property CoreTransferTypePresence: TCoreTransferTypePresence read GetCoreTransferTypePresence;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TCoreTransferTypes = class(TRegisteredIDObjects)
  private
    function GetItems(const Index: Integer): TCoreTransferType;
  public
    property Items[const Index: Integer]: TCoreTransferType read GetItems;
    constructor Create; override;
  end;

  TCoreTransfer = class(TRegisteredIDObject)
  private
    FTransferStart: TDateTime;
    FTransferFinish: TDateTime;
    FCoreTransferTasks: TCoreTransferTasks;
    function GetCoreTransferTasks: TCoreTransferTasks;
    procedure SetTransferStart(const Value: TDateTime);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property TransferStart: TDateTime read FTransferStart write SetTransferStart;
    property TransferFinish: TDateTime read FTransferFinish write FTransferFinish;
    property CoreTransferTasks: TCoreTransferTasks read GetCoreTransferTasks;

    function    List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TCoreTransfers = class(TRegisteredIDObjects)
  private
    function GetItems(const Index: Integer): TCoreTransfer;
  public
    property Items[const Index: Integer]: TCoreTransfer read GetItems;
    constructor Create; override;
  end;

  TCoreTransferTask = class(TRegisteredIDObject)
  private
    FBoxCount: integer;
    FBoxNumbers: string;
    FTransferType: TCoreTransferType;
    FSourcePlacement: TPartPlacement;
    FTargetPlacement: TPartPlacement;
    FWell: TSlottingWell;
    FGenSection: TGeneralizedSection;
    function GetCoreTransfer: TCoreTransfer;
    function GetTransferringObject: TIDObject;
    procedure SetTransferringObject(const Value: TIDObject);
    function GetIsDataCompleted: Boolean;
    function GetCoreYield: single;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property Well: TSlottingWell read FWell;
    property GenSection: TGeneralizedSection read FGenSection;
    property TransferringObject: TIDObject read GetTransferringObject write SetTransferringObject;

    property SourcePlacement: TPartPlacement read FSourcePlacement write FSourcePlacement;
    property TargetPlacement: TPartPlacement read FTargetPlacement write FTargetPlacement;
    property TransferType: TCoreTransferType read FTransferType write FTransferType;
    property BoxCount: integer read FBoxCount write FBoxCount;
    property CoreYield: single read GetCoreYield;
    property BoxNumbers: string read FBoxNumbers write FBoxNumbers;
    property CoreTransfer: TCoreTransfer read GetCoreTransfer;


    property    IsDataCompleted: Boolean read GetIsDataCompleted;
    function    List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TCoreTransferTasks = class(TRegisteredIDObjects)
  private
    FWells: TSlottingWells;
    function GetItems(const Index: integer): TCoreTransferTask;
    function GetCoreTransfer: TCoreTransfer;
    function GetWells: TSlottingWells;
  public
    function CountOfType(CoreTransferType: TCoreTransferType): integer;
    function GetTransferTypeString: string;
    property Wells: TSlottingWells read GetWells;
    property CoreTransfer: TCoreTransfer read GetCoreTransfer;
    property Items[const Index: integer]: TCoreTransferTask read GetItems;
    function IsWellPresent(AWell: TWell): Boolean;
    function GetTransferTaskByWell(AWell: TWell): TCoreTransferTask;
    function GetTransferTaskByWellAndType(AWell: TWell; ATransferType: TCoreTransferType): TCoreTransferTask;
    procedure SortByTransferType;
    constructor Create; override;
    destructor  Destroy; override;

  end;


implementation


uses CoreTransferDataPoster, Facade, SysUtils, BaseConsts, Comparers;

{ TCoreTransferTypes }

constructor TCoreTransferTypes.Create;
begin
  inherited;
  FObjectClass := TCoreTransferType;
  OwnsObjects := true;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TCoreTransferTypeDataPoster];
end;

function TCoreTransferTypes.GetItems(
  const Index: Integer): TCoreTransferType;
begin
  Result := inherited Items[Index] as TCoreTransferType;
end;

{ TCoreTransferType }

constructor TCoreTransferType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип перемещения керна';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TCoreTransferTypeDataPoster];
end;

function TCoreTransferType.GetCoreTransferTypePresence: TCoreTransferTypePresence;
begin
  Result := TCoreTransferTypePresence(ID);
end;

{ TCoreTransfers }

constructor TCoreTransfers.Create;
begin
  inherited;
  FObjectClass := TCoreTransfer;
  OwnsObjects := true;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TCoreTransferDataPoster];
end;

function TCoreTransfers.GetItems(const Index: Integer): TCoreTransfer;
begin
  Result := inherited Items[Index] as TCoreTransfer;  
end;

{ TCoreTransfer }

procedure TCoreTransfer.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TCoreTransfer).TransferStart := TransferStart;
  (Dest as TCoreTransfer).TransferFinish := TransferFinish;
end;

constructor TCoreTransfer.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'перемещение керна';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TCoreTransferDataPoster];
end;

destructor TCoreTransfer.Destroy;
begin
  FreeAndNil(FCoreTransferTasks);
  inherited;
end;

function TCoreTransfer.GetCoreTransferTasks: TCoreTransferTasks;
begin
  if not Assigned(FCoreTransferTasks) then
  begin
    FCoreTransferTasks := TCoreTransferTasks.Create;
    FCoreTransferTasks.Owner := Self;
    FCoreTransferTasks.Reload('CORE_TRANSFER_ID = ' + IntToStr(ID));
  end;

  Result := FCoreTransferTasks;
end;

function TCoreTransfer.List(AListOption: TListOption): string;
begin
  if TransferStart < TransferFinish then
    Result := DateToStr(TransferStart) + ' - ' + DateToStr(TransferFinish)
  else
    Result := DateToStr(TransferStart);
end;

procedure TCoreTransfer.SetTransferStart(const Value: TDateTime);
begin
  if FTransferStart <> Value then
  begin
    FTransferStart := Value;
    TMainFacade.GetInstance.Registrator.Update(Self, nil, ukUpdate);
  end;
end;

{ TCoreTransferTasks }

function TCoreTransferTasks.CountOfType(
  CoreTransferType: TCoreTransferType): integer;
var i: Integer;
begin
  Assert(Assigned(CoreTransferType), 'Не передан необходимый тип перемещения');
  Result := 0;
  for i := 0 to Count - 1 do
  if Assigned(Items[i].TransferType) and (Items[i].TransferType.ID = CoreTransferType.ID) then
    Result := Result + 1;
end;

constructor TCoreTransferTasks.Create;
begin
  inherited;
  FObjectClass := TCoreTransferTask;
  OwnsObjects := true;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TCoreTransferTaskDataPoster];
end;

destructor TCoreTransferTasks.Destroy;
begin
  FreeAndNil(FWells);
  inherited;
end;

function TCoreTransferTasks.GetCoreTransfer: TCoreTransfer;
begin
  Result := Owner as TCoreTransfer;
end;

function TCoreTransferTasks.GetItems(
  const Index: integer): TCoreTransferTask;
begin
  Result := inherited Items[Index] as TCoreTransferTask;
end;

function TCoreTransferTasks.GetTransferTaskByWell(
  AWell: TWell): TCoreTransferTask;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].TransferringObject is TSlottingWell then
  begin
    if Items[i].Well.ID = AWell.ID then
    begin
      Result := Items[i];
      Break;
    end;
  end;
end;

function TCoreTransferTasks.GetTransferTaskByWellAndType(AWell: TWell;
  ATransferType: TCoreTransferType): TCoreTransferTask;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if (Items[i].TransferringObject is TSlottingWell) and Assigned(Items[i].TransferType) then
  begin
    if (Items[i].Well.ID = AWell.ID) and (Items[i].TransferType = ATransferType) then
    begin
      Result := Items[i];
      Break;
    end;
  end;
end;

function TCoreTransferTasks.GetTransferTypeString: string;
var i: Integer;
    ctts: TCoreTransferTypes;

begin
  ctts := TCoreTransferTypes.Create;
  ctts.OwnsObjects := false;

  for i := 0 to Count - 1 do
    ctts.Add(Items[i].TransferType, False, True);

  if Assigned(ctts.ItemsByID[CORE_TRANSFER_TYPE_TRANSFER_ID]) then
    Result := Result + '; ' + 'перемещения';

  if Assigned(ctts.ItemsByID[CORE_TRANSFER_TYPE_REPLACING_ID]) then
    Result := Result + '; ' + 'переукладки';

  if Assigned(ctts.ItemsByID[CORE_TRANSFER_TYPE_LIC_ID]) then
    Result := Result + '; ' + 'ликвидации';

  if Assigned(ctts.ItemsByID[CORE_TRANSFER_TYPE_ARRIVE_ID]) then
    Result := Result + '; ' + 'поступления';

  if Assigned(ctts.ItemsByID[CORE_TRANSFER_TYPE_PASS_ID]) then
    Result := Result + '; ' + 'перевозки';

  Result := Trim(Copy(Result, 2, Length(Result)));


end;

function TCoreTransferTasks.GetWells: TSlottingWells;
var i: Integer;
begin
  if not Assigned(FWells) then
  begin
    FWells := TSlottingWells.Create;
    FWells.OwnsObjects := false;

    for i := 0 to Count - 1 do
    if Assigned(Items[i].Well) then
      FWells.Add(Items[i].Well, false, True);
  end;

  Result := FWells;
end;

function TCoreTransferTasks.IsWellPresent(AWell: TWell): Boolean;
begin
  Result := Assigned(GetTransferTaskByWell(AWell));
end;

procedure TCoreTransferTasks.SortByTransferType;
begin
  Sort(CoreTransferTaskCompare);
end;

{ TCoreTransferTask }

procedure TCoreTransferTask.AssignTo(Dest: TPersistent);
var d: TCoreTransferTask;
begin
  inherited;

  d := Dest as TCoreTransferTask;
  if Assigned(Well) then
  begin
    d.TransferringObject := TSlottingWell.Create(nil);
    d.Well.ID := Well.ID;
    d.Well.NumberWell := Well.NumberWell;
    d.Well.TrueDepth := Well.TrueDepth;
    d.Well.Area := Well.Area;
    d.Well.Category := Well.Category;
  end
  else
    d.TransferringObject := GenSection;
    
  d.SourcePlacement := SourcePlacement;
  d.TargetPlacement := TargetPlacement;
  d.TransferType := TransferType;
  d.BoxCount := BoxCount;
  d.BoxNumbers := BoxNumbers;

end;

constructor TCoreTransferTask.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'единица перемещения керна';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TCoreTransferTaskDataPoster];
end;

destructor TCoreTransferTask.Destroy;
begin
  FreeAndNil(FWell);
  inherited;
end;

function TCoreTransferTask.GetCoreTransfer: TCoreTransfer;
begin
  Result := Collection.Owner as TCoreTransfer;
end;

function TCoreTransferTask.GetCoreYield: single;
var iFinalBoxCount: integer;
    fCoreFinalYield: single;
begin
  Result := 0;
  iFinalBoxCount := 0;
  fCoreFinalYield := 0;
  if Assigned(Well) then
  begin
    iFinalBoxCount := Well.SlottingPlacement.FinalBoxCount;
    fCoreFinalYield := Well.SlottingPlacement.CoreFinalYield;
  end
  else if Assigned(GenSection) then
  begin
    iFinalBoxCount := GenSection.SlottingPlacement.FinalBoxCount;
    fCoreFinalYield := GenSection.SlottingPlacement.CoreFinalYield;
  end;

  if iFinalBoxCount > 0 then
    Result := fCoreFinalYield * BoxCount/iFinalBoxCount;
end;

function TCoreTransferTask.GetIsDataCompleted: Boolean;
begin
  Result := Assigned(TransferType) and Assigned(TransferringObject) and Assigned(TargetPlacement) and (BoxCount > 0);
end;

function TCoreTransferTask.GetTransferringObject: TIDObject;
begin
  if Assigned(Well) then Result := Well
  else Result := GenSection;
end;

function TCoreTransferTask.List(AListOption: TListOption): string;
begin
  Assert(Assigned(TransferType), 'Не задан тип перемещения');
  Assert(Assigned(TransferringObject), 'Не задан перемещаемый объект');

  Result := TransferType.Name + ' ' + TransferringObject.List + ' ' +  IntToStr(BoxCount) + ' ящ.';
  if Assigned(SourcePlacement) and Assigned(TargetPlacement) then
    Result := Result + ' (' + SourcePlacement.Name + '->' +  TargetPlacement.Name + ')'
  else if Assigned(TargetPlacement) then
    Result := Result + ' (->' + TargetPlacement.Name + ')';
end;

procedure TCoreTransferTask.SetTransferringObject(const Value: TIDObject);
begin
  if Value is TSlottingWell then
  begin

    FWell := TSlottingWell.Create(nil);
    FWell.Assign(Value as TSlottingWell);
    FGenSection := nil;
  end
  else if Value is TGeneralizedSection then
  begin
    FWell := nil;
    FGenSection := Value as TGeneralizedSection;
  end;
end;

end.
