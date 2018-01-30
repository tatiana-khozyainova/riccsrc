unit GeneralizedSection;

interface

uses Registrator, BaseObjects, ComCtrls, Classes, RockSample, BaseWellInterval,
     Straton, SlottingWell, Slotting, SlottingPlacement;


type
  TGeneralizedSectionSlotting = class;
  TGeneralizedSectionSlottings = class;
  TGeneralizedSection = class;
  TGeneralizedSections = class;

  TGeneralizedSectionSlotting = class(TSlotting)
  private
    FWell: TSlottingWell;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    // принимаем посетителей
    procedure   Accept(Visitor: IVisitor); override;

    function   List(AListOption: TListOption = loBrief): string; override;


    property    Well: TSlottingWell read FWell write FWell;
    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TGeneralizedSectionSlottings = class(TSlottings)
  private
    function GetItems(const Index: Integer): TGeneralizedSectionSlotting;
    function GetSection: TGeneralizedSection;
  public
    procedure   Delete(Index: integer); override;
    function    Remove(AObject: TObject): Integer; override;
    procedure   MarkAllDeleted; override;
    procedure   RefreshIntervals;

    property    Section: TGeneralizedSection read GetSection;
    property    Items[const Index: Integer]: TGeneralizedSectionSlotting read GetItems;
    constructor Create; override;
  end;

  TGeneralizedSectionSlottingPlacement = class(TRegisteredIDObject)
  private
    FFinalBoxCount: integer;
    FCoreYield: Single;
    FCoreFinalYield: Single;
    FRackList: string;
    FTransferHistory: string;
    function GetGenSection: TGeneralizedSection;
    function GetCoreFinalYield: single;
    function GetCoreYield: Single;
    function GetFinalBoxCount: Integer;
    function GetRackList: string;
    function QueryRackList: string;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property GeneralizedSection: TGeneralizedSection read GetGenSection;
    property CoreFinalYield: Single read GetCoreFinalYield write FCoreFinalYield;
    property CoreYield: Single read GetCoreYield write FCoreYield;
    property FinalBoxCount: integer read GetFinalBoxCount write FFinalBoxCount;
    property RackList: string read GetRackList write FRackList;
    property TransferHistory: string read FTransferHistory write FTransferHistory;

    function   List(AListOption: TListOption = loBrief): string; override;


    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TNullGeneralizedSectionSlottingPlacement = class(TGeneralizedSectionSlottingPlacement)
  public
    class function GetInstance: TGeneralizedSectionSlottingPlacement;
  end;

  TGeneralizedSectionSlottingPlacements = class(TRegisteredIDObjects)
  private
    function GetItems(
      const Index: Integer): TGeneralizedSectionSlottingPlacement;
    function GetSection: TGeneralizedSection;
  public
    property    Section: TGeneralizedSection read GetSection;
    property    Items[const Index: Integer]: TGeneralizedSectionSlottingPlacement read GetItems;
    constructor Create; override;
  end;

  TGeneralizedSection = class(TRegisteredIDObject)
  private
    FSlottings: TGeneralizedSectionSlottings;
    FWells: TSlottingWells;
    FTopStraton: TSimpleStraton;
    FBaseStraton: TSimpleStraton;
    FBoxes: TBoxes;
    FSampleBoxNumbers: string;
    FSlottingPlacements: TGeneralizedSectionSlottingPlacements;
    function GetSlottings: TGeneralizedSectionSlottings;
    function GetSlottingWells: TSlottingWells;
    function GetBoxes: TBoxes;
    function GetSlottingPlacement: TGeneralizedSectionSlottingPlacement;
    function GetSlottingsLoaded: boolean;
    function GetBoxesLoaded: Boolean;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    // принимаем посетителей
    procedure   Accept(Visitor: IVisitor); override;

    property  Wells: TSlottingWells read GetSlottingWells;
    function  GetWellNames: string;
    property  Slottings: TGeneralizedSectionSlottings read GetSlottings;
    property  SlottingsLoaded: boolean read GetSlottingsLoaded;
    property  SampleBoxNumbers: string read FSampleBoxNumbers write FSampleBoxNumbers;
    procedure RefreshIntervals;

    property  Boxes: TBoxes read GetBoxes;
    property  BoxesLoaded: Boolean read GetBoxesLoaded;
    property  BaseStraton: TSimpleStraton read FBaseStraton write FBaseStraton;
    property  TopStraton: TSimpleStraton read FTopStraton write FTopStraton;
    function  Stratigraphy: string;
    property  SlottingPlacement: TGeneralizedSectionSlottingPlacement read GetSlottingPlacement;



    function    Update(ACollection: TIDObjects = nil): integer; override;

    function    List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TGeneralizedSections = class(TRegisteredIDObjects)
  private
    function GetItems(const Index: Integer): TGeneralizedSection;
  public
    procedure RefreshIntervals;
    property  Items[const Index: Integer]: TGeneralizedSection read GetItems;
    constructor Create; override;
    destructor  Destroy; override;
  end;


implementation

uses SysUtils, GeneralizedSectionDataPoster, Facade;

{ TGeneralizedSection }

procedure TGeneralizedSection.Accept(Visitor: IVisitor);
begin
  Visitor.VisitGenSection(Self);

end;

procedure TGeneralizedSection.AssignTo(Dest: TPersistent);
var gs: TGeneralizedSection;
begin
  inherited;

  gs := Dest as TGeneralizedSection;
  gs.TopStraton := TopStraton;
  gs.BaseStraton := BaseStraton;
  gs.SampleBoxNumbers := SampleBoxNumbers;
end;

constructor TGeneralizedSection.Create(ACollection: TIDObjects);
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGeneralizedSectionDataPoster];
  ClassIDString := '—водный разрез';
end;

destructor TGeneralizedSection.Destroy;
begin
  FreeAndNil(FWells);
  FreeAndNil(FSlottings);
  FreeAndNil(FSlottingPlacements);
  inherited;
end;

function TGeneralizedSection.GetBoxes: TBoxes;
var i: integer;
begin
  if not Assigned(FBoxes) then
  begin
    FBoxes := TBoxes.Create;
    FBoxes.OwnsObjects := false;
  end
  else FBoxes.Clear;

  for i := 0 to Slottings.Count - 1 do
    FBoxes.AddObjects(Slottings.Items[i].Boxes, True, True);
     
  Result := FBoxes;
end;

function TGeneralizedSection.GetBoxesLoaded: Boolean;
begin
  Result := Assigned(FBoxes);
end;

function TGeneralizedSection.GetSlottingPlacement: TGeneralizedSectionSlottingPlacement;
begin
  if not Assigned(FSlottingPlacements) then
  begin
    FSlottingPlacements := TGeneralizedSectionSlottingPlacements.Create;
    FSlottingPlacements.Owner := Self;
    FSlottingPlacements.Reload('SECTION_ID = ' + IntToStr(ID));
  end;

  if FSlottingPlacements.Count > 0 then
    Result := FSlottingPlacements.Items[0]
  else
  begin
    FSlottingPlacements.Add(TNullGeneralizedSectionSlottingPlacement.GetInstance, True, False);
    Result := FSlottingPlacements.Items[0]
  end;
end;

function TGeneralizedSection.GetSlottings: TGeneralizedSectionSlottings;
begin
  if not Assigned(FSlottings) then
  begin
    FSlottings := TGeneralizedSectionSlottings.Create;
    FSlottings.Owner := Self;
    FSlottings.Reload('Section_ID = ' + IntToStr(ID));
  end;

  Result := FSlottings;
end;

function TGeneralizedSection.GetSlottingsLoaded: boolean;
begin
  Result := Assigned(FSlottings);
end;

function TGeneralizedSection.GetSlottingWells: TSlottingWells;
var i: integer;
begin
  if not Assigned(FWells) then
  begin
    FWells := TSlottingWells.Create;
    FWells.OwnsObjects := false;
  end
  else FWells.Clear;

  for i := 0 to Slottings.Count - 1 do
    FWells.Add(Slottings.Items[i].Well, false, True);

  Result := FWells;
end;

function TGeneralizedSection.GetWellNames: string;
var lst: TStringList;
    i, j, iIndex: integer;
    wls: TSlottingWells;
begin
  lst := TStringList.Create;
  wls := TSlottingWells.Create;
  wls.OwnsObjects := false;

  for i := 0 to Slottings.Count - 1 do
    wls.Add(Slottings.Items[i].Well, false, True);
  wls.SortByWellNumAndArea;

  for i := 0 to wls.Count - 1 do
  begin
    iIndex := -1;
    for j := 0 to lst.Count - 1 do
    if lst.Objects[j] = wls.Items[i].Area then
    begin
      iIndex := j;
      if (Pos(',' + wls.Items[i].NumberWell, lst[j]) = 0) and (wls.Items[i].NumberWell <> lst[j]) then
        lst[j] := lst[j] + ',' + wls.Items[i].NumberWell;
      break;
    end;

    if iIndex = -1 then lst.AddObject(wls.Items[i].NumberWell, wls.Items[i].Area);
  end;


  for i := 0 to lst.Count - 1 do
   Result := Result + ';' + lst[i] + '-' + (lst.Objects[i] as TIDObject).Name;

  Result := StringReplace(Result, ';', '', []);
  FreeAndNil(lst);
  FreeAndNil(wls);
end;

function TGeneralizedSection.List(AListOption: TListOption): string;
begin
  Result := '—в. разрез ' + Name;
end;



procedure TGeneralizedSection.RefreshIntervals;
var i: integer;
    w: TSlottingWell;
    slt: TSlotting;
begin
  for i := 0 to Slottings.Count - 1 do
  begin
    w := TMainFacade.GetInstance.AllWells.ItemsByID[Slottings.Items[i].Well.ID] as TSlottingWell;
    if Assigned(w) then
    begin
      slt := w.Slottings.ItemsByID[Slottings.Items[i].ID] as TSlotting;
      if Assigned(slt) then
        slt.RefreshGenSection;

      TMainFacade.GetInstance.Registrator.Update(w, nil, ukUpdate);
    end;

  end;

  FreeAndNil(FSlottings);
end;

function TGeneralizedSection.Stratigraphy: string;
begin
  Result := '';
  if Assigned(BaseStraton) then
  begin
    Result := BaseStraton.Name;
    if Assigned(TopStraton) then
      Result := TopStraton.Name + ' - ' + Result;
  end
  else if Assigned(TopStraton) then Result := TopStraton.Name;
  
end;

function TGeneralizedSection.Update(ACollection: TIDObjects): integer;
begin
  Result := inherited Update(ACollection);
  Slottings.Update(nil);
end;

{ TGeneralizedSectionSlottings }

constructor TGeneralizedSectionSlottings.Create;
begin
  inherited;
  FObjectClass := TGeneralizedSectionSlotting;
  OwnsObjects := true;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGeneralizedSectionSlottingDataPoster];
end;

procedure TGeneralizedSectionSlottings.Delete(Index: integer);
var slt: TSlotting;
    i: Integer;
begin
  slt := nil;
  with TMainFacade.GetInstance.AllWells do
  for i := 0 to Count - 1 do
  begin
    slt := Items[i].Slottings.ItemsByID[Items[i].ID] as TSlotting;
    if Assigned(slt) then Break;
  end;

  if Assigned(slt) then
    slt.RefreshGenSection;

  inherited;
end;

function TGeneralizedSectionSlottings.GetItems(
  const Index: Integer): TGeneralizedSectionSlotting;
begin
  Result := inherited Items[index] as TGeneralizedSectionSlotting;
end;

function TGeneralizedSectionSlottings.GetSection: TGeneralizedSection;
begin
  Result := Owner as TGeneralizedSection;
end;

procedure TGeneralizedSectionSlottings.MarkAllDeleted;
begin
  RefreshIntervals;
  inherited;

end;

procedure TGeneralizedSectionSlottings.RefreshIntervals;
var i: integer;
    w: TSlottingWell;
    slt: TSlotting;
    ws: TIDObjects;
    sltg: TGeneralizedSectionSlotting;
begin
  ws := TIDObjects.Create();
  ws.OwnsObjects := False;
  for i := 0 to DeletedObjects.Count - 1 do
  begin
    sltg := DeletedObjects.Items[i] as TGeneralizedSectionSlotting;
    w := TMainFacade.GetInstance.AllWells.ItemsByID[sltg.Well.ID] as TSlottingWell;
    if Assigned(w) then
    begin
      slt := w.Slottings.ItemsByID[sltg.ID] as TSlotting;
      if Assigned(slt) then
        slt.RefreshGenSection;

      ws.Add(w, false, true);
    end;
  end;

  for i := 0 to Count - 1 do
  begin
    sltg := Items[i];
    w := TMainFacade.GetInstance.AllWells.ItemsByID[sltg.Well.ID] as TSlottingWell;
    if Assigned(w) and not Assigned(ws.ItemsByID[w.ID])then
    begin
      slt := w.Slottings.ItemsByID[sltg.ID] as TSlotting;
      if Assigned(slt) then
        slt.RefreshGenSection;

      ws.Add(w, false, true);
    end;
  end;

  for i := 0 to ws.Count - 1 do
    TMainFacade.GetInstance.Registrator.Update(ws.Items[i], nil, ukUpdate);

  FreeAndNil(ws);
end;

function TGeneralizedSectionSlottings.Remove(AObject: TObject): Integer;
var slt: TSlotting;
    i: Integer;
begin
  slt := nil;
  with TMainFacade.GetInstance.AllWells do
  for i := 0 to Count - 1 do
  begin
    slt := Items[i].Slottings.ItemsByID[(AObject as TIDObject).ID] as TSlotting;
    if Assigned(slt) then Break;
  end;

  if Assigned(slt) then
    slt.RefreshGenSection;

  Result := inherited Remove(AObject);
end;

{ TGeneralizedSectionSlotting }

procedure TGeneralizedSectionSlotting.Accept(Visitor: IVisitor);
begin
  Visitor.VisitGenSectionSlotting(Self);
end;

procedure TGeneralizedSectionSlotting.AssignTo(Dest: TPersistent);
begin
  inherited;


end;

constructor TGeneralizedSectionSlotting.Create(ACollection: TIDObjects);
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGeneralizedSectionSlottingDataPoster];
end;

destructor TGeneralizedSectionSlotting.Destroy;
begin
  FreeAndNil(FWell);
  inherited;
end;

function TGeneralizedSectionSlotting.List(
  AListOption: TListOption): string;
var s: string;
begin
  // формат ***: интервал ****.** - ****.**
  Result := StringOfChar(' ', 3 - Length(trim(Name))) + trim(Name) + ': интервал ';

  s := Format('%.2f', [Top]);
  Result := Result + StringOfChar(' ', 7 - Length(s)) + s + ' - ';

  s := Format('%.2f', [Bottom]);
  Result := Result + StringOfChar(' ', 7 - Length(s)) + s;

  Result := Result + ' м.';

  Result := Result + '(' + Well.List() + ')';
end;

{ TGeneralizedSections }

constructor TGeneralizedSections.Create;
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGeneralizedSectionDataPoster];
  FObjectClass := TGeneralizedSection;
  OwnsObjects := true;
end;

destructor TGeneralizedSections.Destroy;
begin

  inherited;
end;

function TGeneralizedSections.GetItems(
  const Index: Integer): TGeneralizedSection;
begin
  Result := inherited Items[index] as TGeneralizedSection;
end;



procedure TGeneralizedSections.RefreshIntervals;
var i: integer;
begin
  for i := 0 to Count - 1 do
    Items[i].RefreshIntervals;
end;

{ TGeneralizedSectionSlottingPlacement }

procedure TGeneralizedSectionSlottingPlacement.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TGeneralizedSectionSlottingPlacement).CoreFinalYield := CoreFinalYield;
  (Dest as TGeneralizedSectionSlottingPlacement).CoreYield := CoreYield;
  (Dest as TGeneralizedSectionSlottingPlacement).FinalBoxCount := FinalBoxCount;
  (Dest as TGeneralizedSectionSlottingPlacement).TransferHistory := TransferHistory;
end;

constructor TGeneralizedSectionSlottingPlacement.Create(
  ACollection: TIDObjects);
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGeneralizedSectionSlottingPlacementDataPoster];
end;

destructor TGeneralizedSectionSlottingPlacement.Destroy;
begin

  inherited;
end;

function TGeneralizedSectionSlottingPlacement.GetCoreFinalYield: single;
begin
  if not GeneralizedSection.SlottingsLoaded then
    Result := FCoreFinalYield
  else
    Result := GeneralizedSection.Slottings.GetFinalCore(true);
end;

function TGeneralizedSectionSlottingPlacement.GetCoreYield: Single;
begin
  if not GeneralizedSection.SlottingsLoaded then
    Result := FCoreFinalYield
  else
    Result := GeneralizedSection.Slottings.GetInCore(true);
end;

function TGeneralizedSectionSlottingPlacement.GetFinalBoxCount: Integer;
begin
  if not GeneralizedSection.SlottingsLoaded then
    Result := FFinalBoxCount
  else
    Result := GeneralizedSection.Slottings.GetBoxCount(True);
end;

function TGeneralizedSectionSlottingPlacement.GetGenSection: TGeneralizedSection;
begin
  Result := (Collection as TGeneralizedSectionSlottingPlacements).Section;
end;

function TGeneralizedSectionSlottingPlacement.GetRackList: string;
begin
  if GeneralizedSection.BoxesLoaded then
    Result := FRackList
  else
    Result := QueryRackList;
end;

function TGeneralizedSectionSlottingPlacement.List(
  AListOption: TListOption): string;
begin
  Result := inherited List(AListOption);
end;

function TGeneralizedSectionSlottingPlacement.QueryRackList: string;
var sQuery: string;
    iResult: integer;
    vResult: OleVariant;
begin
  Result := '';

  sQuery := 'select vch_Rack_List from spd_get_rack_list_gen_section(' + IntToStr(Owner.ID) + ')';



  iResult := TMainFacade.GetInstance.DBGates.ExecuteQuery(sQuery, vResult);
  if iResult > 0 then
    Result := vResult[0, 0];
end;

{ TGeneralizedSectionSlottingPlacements }

constructor TGeneralizedSectionSlottingPlacements.Create;
begin
  inherited;
  FObjectClass := TGeneralizedSectionSlottingPlacement;
  OwnsObjects := true;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TGeneralizedSectionSlottingPlacementDataPoster];
end;

function TGeneralizedSectionSlottingPlacements.GetItems(
  const Index: Integer): TGeneralizedSectionSlottingPlacement;
begin
  Result := inherited Items[index] as TGeneralizedSectionSlottingPlacement;
end;

function TGeneralizedSectionSlottingPlacements.GetSection: TGeneralizedSection;
begin
  Result := Owner as TGeneralizedSection;
end;

{ TNullGeneralizedSectionSlottingPlacement }

class function TNullGeneralizedSectionSlottingPlacement.GetInstance: TGeneralizedSectionSlottingPlacement;
const inst: TGeneralizedSectionSlottingPlacement = nil;
begin
  if not Assigned(inst) then
    inst := TGeneralizedSectionSlottingPlacement.Create(nil);

  Result := inst;  

end;

end.
