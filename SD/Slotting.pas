unit Slotting;

interface

uses Registrator, BaseObjects, ComCtrls, Classes, RockSample, BaseWellInterval,
     CoreMechanicalState, Straton, SlottingPlacement, LayerSlotting;


type

  TSimpleSlotting = class;
  TSimpleSlottings = class;

  // простое долбление  - с базовыми свойствами
  TSimpleSlotting = class (TBaseWellInterval)
  private
    FBottom: double;
    FTop: double;
    FCoreFinalYield: double;
    FCoreYield: double;
    FDigging: double;
    FTrueDescription: boolean;
    FDiameter: double;
    FCoreMechanicalStates: TSlottingCoreMechanicalStates;
    FStraton: TSimpleStraton;
    FCoreTakeDate: TDateTime;
    FSubdivisionStratonName: string;
    function GetCoreMechanicalStates: TSlottingCoreMechanicalStates;
    function GetDigging: double;
  protected
    function    GetOwner: TIDObject; reintroduce;
    procedure   AssignTo(Dest: TPersistent); override;
  public
    // принимаем посетителей
    procedure   Accept(Visitor: IVisitor); override;
    // проходка
    property   Digging: double read GetDigging;
    // выход керна
    property   CoreYield: double read FCoreYield write FCoreYield;
    // фактический выход керна
    property   CoreFinalYield: double read FCoreFinalYield write FCoreFinalYield;

    // наличие описания
    property   TrueDescription: boolean read FTrueDescription write FTrueDescription;
    // диаметр
    property   Diameter: double read FDiameter write FDiameter;
    // механическое состояние
    property   CoreMechanicalStates: TSlottingCoreMechanicalStates read GetCoreMechanicalStates;
    // стратиграфия, указанная прямо
    property   Straton: TSimpleStraton read FStraton write FStraton;
    // стратиграфия по разбивкам - считается в представлении
    property   SubDivisionStratonName: string read FSubdivisionStratonName write FSubdivisionStratonName;
    // дата отбора керна
    property   CoreTakeDate: TDateTime read FCoreTakeDate write FCoreTakeDate;


    function   Update(ACollection: TIDObjects = nil): integer; override;

    function   List(AListOption: TListOption = loBrief): string; override;

    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TSimpleSlottings = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: integer): TSimpleSlotting;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items [Index: integer] : TSimpleSlotting read GetItems;
    function    GetInCore(UseGenSection: Boolean): single; virtual;
    function    GetFinalCore(UseGenSection: Boolean): single; virtual;

    procedure   MakeList(AListView: TListItems; NeedsRegistering: boolean = true; NeedsClearing: boolean = false); override;
    procedure   MakeList(ATreeNodes: TTreeNodes; NeedsRegistering: boolean = true; NeedsClearing: boolean = false; CreateFakeNode: Boolean = true); override;

    procedure   Sort;

    constructor Create; override;
  end;


  // долбление со всей возможной информацией о долблении
  // которая в зависимости от типа клиента может быть доступна
  // или использоваться не полностью
  // в случае отсутствия прав будет генериться специальное исключение
  TSlotting = class(TSimpleSlotting)
  private
    FRockSamples: TRockSamples;
    FSlottingBoxes: TBoxes;
    FLayerSlottings: TSimpleLayerSlottings;
    FRockSampleSizeTypePresences: TRockSampleSizeTypePresences;
    FGenSection: TIDObject;
    function GetRockSamples: TRockSamples;
    function GetSlottingBoxes: TBoxes;
    function GetLayerSlottings: TSimpleLayerSlottings;
    function GetRockSampleSizeTypePresences: TRockSampleSizeTypePresences;
    function GetIsInGenSection: boolean;
    function GetGenSection: TIDObject;
    function GetBoxesLoaded: Boolean;
  protected
    procedure   InitSubCollections; override;
    procedure   AssignTo(Dest: TPersistent); override;
    procedure   SetName(const Value: string); override;
  public
    property    IsInGenSection: boolean read GetIsInGenSection;
    property    GenSection: TIDObject read GetGenSection;
    procedure   RefreshGenSection;




    // слои долбления
    property    LayerSlottings: TSimpleLayerSlottings read GetLayerSlottings write FLayerSlottings;
    // образцы
    property    RockSamples: TRockSamples read GetRockSamples;
    //  в каких ящиках находятся
    property    Boxes: TBoxes read GetSlottingBoxes;
    property    BoxesLoaded: Boolean read GetBoxesLoaded;
    
    function    ListBoundaryBoxes: string;
    // наличие образцов по типоразмерам
    property    RockSampleSizeTypePresences: TRockSampleSizeTypePresences read GetRockSampleSizeTypePresences;

    function    MakeHeader: string;

    procedure   MakeList(AListView: TListItems; NeedsClearing: boolean = false); override;
    function    List(AListOption: TListOption = loBrief): string; override;


    procedure   Clear;

    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TSlottings = class(TSimpleSlottings)
  private
    FBoxes: TBoxes;
    function GetItems(Index: integer): TSlotting;
    function GetSampleCountInCoreLib: integer;
    function GetBoxes: TBoxes;
    function GetBoxesCount: integer;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items [Index: integer] : TSlotting read GetItems;

    procedure   Delete(Index: integer); override;
    function    Remove(AObject: TObject): Integer; override;

    function    GetMaxSlottingNumber: integer;
    property    Boxes: TBoxes read GetBoxes;
    property    BoxesCount: integer read GetBoxesCount;

    // сколько всего образцов в кернохранилище
    property    SampleCountInCoreLib: integer read GetSampleCountInCoreLib;

    function    GetInCore(UseGenSection: Boolean): single; override;
    function    GetFinalCore(UseGenSection: Boolean): single; override;
    function    GetBoxCount(UseGenSection: Boolean): Integer;
    function    GetSlottingsCount(UseGenSection: Boolean): Integer;

    constructor Create; override;
    destructor  Destroy; override;
  end;


implementation

uses Facade, SlottingPoster, SysUtils, CoreDescription, Comparers, ClientCommon, GeneralizedSection;



{ TSlotting }

procedure TSimpleSlotting.Accept(Visitor: IVisitor);
begin
  Visitor.VisitSlotting(Self);
end;

procedure TSimpleSlotting.AssignTo(Dest: TPersistent);
var o: TSimpleSlotting;
begin
  inherited;
  o := Dest as TSimpleSlotting;

  o.Bottom := Bottom;
  o.Top := Top;
  o.CoreFinalYield := CoreFinalYield;
  o.CoreYield := CoreYield;
  o.TrueDescription := TrueDescription;
  o.Diameter := Diameter;
  o.CoreTakeDate := CoreTakeDate;
  o.SubDivisionStratonName := SubDivisionStratonName;

  o.CoreMechanicalStates.Clear;
  o.CoreMechanicalStates.AddObjects(CoreMechanicalStates, true, true);

  o.Straton := Straton;
end;

constructor TSimpleSlotting.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Долбление';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSlottingDataPoster];
end;

procedure TSlotting.AssignTo(Dest: TPersistent);
var o: TSlotting;
begin
  inherited;

  o := Dest as TSlotting;
  o.InitSubCollections;

  o.RockSamples.Assign(RockSamples);
  o.Boxes.Assign(Boxes);
  o.RockSampleSizeTypePresences.Assign(RockSampleSizeTypePresences);
end;

procedure TSlotting.Clear;
begin

end;


constructor TSlotting.Create(ACollection: TIDObjects);
begin
  inherited;

  CountFields := 15;
end;

destructor TSlotting.Destroy;
begin
  if Assigned(FSlottingBoxes) then FSlottingBoxes.Free;
  inherited;
end;

procedure TSlotting.SetName(const Value: string);
begin
  inherited;
end;

function TSlotting.List(AListOption: TListOption): string;
begin
  Result := inherited List(AListOption);
  if IsInGenSection then
    Result := Result + '[св.р.' + GenSection.Name + ']';
end;

function TSlotting.GetGenSection: TIDObject;
var iResult, iID: integer;
    vID: OleVariant;
begin
  if not Assigned(FGenSection) then
  begin
    iResult := TMainFacade.GetInstance.DBGates.ExecuteQuery('Select max(Section_ID) from tbl_Gen_Section_Slotting where Slotting_UIN = ' + IntToStr(ID), vID);
    if iResult > 0 then
    begin
      iID := vID[0, 0];
      //FGenSection := TMainFacade.GetInstance.GeneralizedSections.ItemsByID[iID];
    end;
  end;
  Result := FGenSection;
end;


procedure TSlotting.RefreshGenSection;
begin
  FGenSection := nil;
end;

function TSlotting.ListBoundaryBoxes: string;
var sQuery, sMin, sMax: string;
    iResult: Integer;
    vResult: OleVariant;
begin
  if Assigned(FSlottingBoxes) and (FSlottingBoxes.Count > 0) then
  with Boxes do
  begin
    SortByNumbers;
    Result := '';
    if Count > 0 then
    begin
      if Count > 1 then
        Result := Items[0].BoxNumber + ' - ' + Items[Count - 1].BoxNumber
      else
        Result := Items[Count - 1].BoxNumber;
    end;
  end
  else
  begin
    sQuery := 'select min(vch_Box_Number), max(vch_Box_Number) from tbl_box b, tbl_slotting_box sb  where b.Box_UIN = sb.Box_UIN and Slotting_UIN in (' + IntToStr(ID) + ')';
    iResult := TMainFacade.GetInstance.DBGates.ExecuteQuery(sQuery, vResult);
    if iResult > 0 then
    begin
      sMin := trim(vResult[0,0]);
      sMax := Trim(vResult[1,0]);
    end;

    if sMin = sMax then
      Result := sMin
    else
      Result := sMin + ' - ' + sMax;
  end;
end;



function TSlotting.GetBoxesLoaded: Boolean;
begin
  Result := Assigned(FSlottingBoxes);
end;

{ TSlottings }

procedure TSimpleSlottings.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
var os: TSimpleSlottings;
begin
  inherited;

  os := Sourse as TSimpleSlottings;
  os.Owner := Owner;
end;

constructor TSimpleSlottings.Create;
begin
  inherited;
  FObjectClass := TSimpleSlotting;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSlottingDataPoster];
end;

function TSimpleSlottings.GetFinalCore(UseGenSection: Boolean): single;
var i: integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
    Result := Result + Items[i].CoreFinalYield;
end;

function TSimpleSlottings.GetInCore(UseGenSection: Boolean): single;
var i: integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
    Result := Result + Items[i].CoreYield;
end;

function TSimpleSlottings.GetItems(Index: integer): TSimpleSlotting;
begin
  Result := inherited Items[Index] as TSimpleSlotting;
end;

procedure TSimpleSlottings.MakeList(AListView: TListItems; NeedsRegistering,
  NeedsClearing: boolean);
var i : integer;
begin
  inherited;

  for i := 0 to Count - 1 do
  begin
    AListView.Item[i].SubItems.Add(FloatToStr(Items[i].Top));
    AListView.Item[i].SubItems.Add(FloatToStr(Items[i].Bottom));
    AListView.Item[i].SubItems.Add(FloatToStr(Items[i].Digging));
    AListView.Item[i].SubItems.Add(FloatToStr(Items[i].CoreYield));
    AListView.Item[i].SubItems.Add(FloatToStr(Items[i].CoreFinalYield));
    AListView.Item[i].SubItems.Add(BoolToStr(Items[i].TrueDescription));
  end;
end;



procedure TSimpleSlottings.MakeList(ATreeNodes: TTreeNodes;
  NeedsRegistering, NeedsClearing, CreateFakeNode: boolean);
begin
  Sort;
  inherited;
end;

destructor TSimpleSlotting.Destroy;
begin
  FCoreMechanicalStates.Free;
  inherited;
end;

function TSimpleSlotting.GetCoreMechanicalStates: TSlottingCoreMechanicalStates;
begin
  if not Assigned(FCoreMechanicalStates) then
  begin
    FCoreMechanicalStates := TSlottingCoreMechanicalStates.Create;
    FCoreMechanicalStates.Owner := Self;
    FCoreMechanicalStates.OwnsObjects := false;

    if FCoreMechanicalStates.Count = 0 then
      FCoreMechanicalStates.Reload('SLOTTING_UIN = ' + IntToStr(ID), false);
  end;

  Result := FCoreMechanicalStates;
end;

function TSimpleSlotting.GetDigging: double;
begin
  Result :=  Bottom - Top;
end;

function TSimpleSlotting.GetOwner: TIDObject;
begin
  Result := Collection.Owner;
end;

function TSimpleSlotting.List(AListOption: TListOption = loBrief): string;
var s: string;
begin
  // формат ***: интервал ****.** - ****.**
  Result := StringOfChar(' ', 3 - Length(trim(Name))) + trim(Name) + ': интервал ';

  s := Format('%.2f', [Top]);
  Result := Result + StringOfChar(' ', 7 - Length(s)) + s + ' - ';

  s := Format('%.2f', [Bottom]);
  Result := Result + StringOfChar(' ', 7 - Length(s)) + s;

  Result := Result + ' м.';
end;

function TSlotting.GetIsInGenSection: boolean;
begin
  Result := Assigned(GenSection);
end;

function TSlotting.GetLayerSlottings: TSimpleLayerSlottings;
begin
  if not Assigned (FLayerSlottings) then
  begin
    FLayerSlottings := TDescriptedLayers.Create;
    FLayerSlottings.Owner := Self;
    FLayerSlottings.Reload('Slotting_Uin = ' + IntToStr(ID));
  end;

  Result := FLayerSlottings;
end;

function TSlotting.GetRockSamples: TRockSamples;
begin
  if not Assigned (FRockSamples) then
  begin
    FRockSamples := TRockSamples.Create;
    FRockSamples.Owner := Self;
    FRockSamples.Reload('Slotting_Uin = ' + IntToStr(ID));
  end;

  Result := FRockSamples;
end;

function TSlotting.GetRockSampleSizeTypePresences: TRockSampleSizeTypePresences;
begin
  if not Assigned(FRockSampleSizeTypePresences) then
  begin
    FRockSampleSizeTypePresences := TRockSampleSizeTypePresences.Create;
    FRockSampleSizeTypePresences.Owner := Self;
    FRockSampleSizeTypePresences.OwnsObjects := true;
    FRockSampleSizeTypePresences.Reload('Slotting_UIN = ' + IntToStr(ID));
  end;

  Result := FRockSampleSizeTypePresences;
end;

function TSlotting.GetSlottingBoxes: TBoxes;
begin
  if not Assigned(FSlottingBoxes) then
  begin
    FSlottingBoxes := TSlottingBoxes.Create;
    FSlottingBoxes.OwnsObjects := true;
    FSlottingBoxes.Owner := Self;
    FSlottingBoxes.Reload('Slotting_UIN = ' + IntToStr(ID));
  end;

  Result := FSlottingBoxes;
end;

procedure TSlotting.InitSubCollections;
begin
  inherited;

  FLayerSlottings := TDescriptedLayers.Create;
  FLayerSlottings.Owner := Self;

  FRockSamples := TRockSamples.Create;
  FRockSamples.Owner := Self;
  FRockSamples.OwnsObjects := true;

  FSlottingBoxes := TSlottingBoxes.Create;
  FSlottingBoxes.Owner := Self;
  FSlottingBoxes.OwnsObjects := true;


  FRockSampleSizeTypePresences := TRockSampleSizeTypePresences.Create;
  FRockSampleSizeTypePresences.Owner := Self;
  FRockSampleSizeTypePresences.OwnsObjects := true;
end;

function TSlotting.MakeHeader: string;
var lst: TStringList;
    i: integer;
begin
  Result := '';

  lst := TStringList.Create;
  // долбление
  lst.Add('Долбление ' + Name);
  // интервал
  lst.Add('Интервал ' + FloatToStr(Top) + '-' + FloatToStr(Bottom) + ' м');
  // проходка
  lst.Add('Проходка ' + FloatToStr(Digging) + ' м');
  // выход керна
  if CoreYield <> 0 then lst.Add('Выход керна ' + FloatToStr(CoreYield) + ' м');
  // пустая строка
  lst.Add(' ');

  for i := 0 to lst.Count - 1 do
    Result := Result + lst.Strings[i] + #13;

  lst.Free;
end;

procedure TSlotting.MakeList(AListView: TListItems;
  NeedsClearing: boolean);
var Index : integer;
begin
  inherited;

  Index := AListView.Count - 1 - CountFields;

  AListView.Item[Index + 1].Caption := 'Долбление';
  AListView.Item[Index + 1].Data := nil;
  AListView.Item[Index + 1].Data := TObject;

  AListView.Item[Index + 2].Caption := 'Номер долбления: ';
  AListView.Item[Index + 2].Data := nil;
  AListView.Item[Index + 3].Caption := '     ' + FName;

  AListView.Item[Index + 4].Caption := 'Глубина от :';
  AListView.Item[Index + 4].Data := nil;
  AListView.Item[Index + 5].Caption := '     ' + FloatToStr(FTop);

  AListView.Item[Index + 6].Caption := 'Глубина до :';
  AListView.Item[Index + 6].Data := nil;
  AListView.Item[Index + 7].Caption := '     ' + FloatToStr(FBottom);

  AListView.Item[Index + 8].Caption := 'Проходка :';
  AListView.Item[Index + 8].Data := nil;
  AListView.Item[Index + 9].Caption := '     ' + FloatToStr(FDigging);

  AListView.Item[Index + 10].Caption := 'Выход керна :';
  AListView.Item[Index + 10].Data := nil;
  if FCoreYield > 0 then AListView.Item[Index + 11].Caption := '     ' + FloatToStr(FCoreYield)
  else AListView.Item[Index + 11].Caption := '     <информация отсутствует>';

  AListView.Item[Index + 12].Caption := 'Фактический выход керна :';
  AListView.Item[Index + 12].Data := nil;
  if FCoreFinalYield > 0 then AListView.Item[Index + 13].Caption := '     ' + FloatToStr(FCoreFinalYield)
  else AListView.Item[Index + 13].Caption := '     <информация отсутствует>';

  AListView.Item[Index + 14].Caption := 'Наличие описания в базе :';
  AListView.Item[Index + 14].Data := nil;
  if FTrueDescription then AListView.Item[Index + 15].Caption := '     Да'
  else AListView.Item[Index + 15].Caption := '     Нет';
end;

procedure TSlottings.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;
  
end;


constructor TSlottings.Create;
begin
  inherited;
  FObjectClass := TSlotting;
  OwnsObjects := true;
end;

function TSlottings.GetSampleCountInCoreLib: integer;
var i: integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
    Result := Result + Items[i].RockSampleSizeTypePresences.GetSampleCount;
end;

function TSlottings.GetBoxes: TBoxes;
var i: integer;
begin
  if not Assigned(FBoxes) then
  begin
    FBoxes := TBoxes.Create;
    FBoxes.OwnsObjects := false;

    for i := 0 to Count - 1 do
      FBoxes.AddObjects(Items[i].Boxes, false, true);
  end;
  Result := FBoxes;
end;

destructor TSlottings.Destroy;
begin
  FreeAndNil(FBoxes);
  inherited;
end;

function TSlottings.GetBoxesCount: integer;
var i: integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
    Result := Result + Items[i].Boxes.Count;
end;

function TSlottings.GetMaxSlottingNumber: integer;
var i: Integer;
begin
  Result := 0;
  if Count > 0 then
  begin
    Result := ExtractInt(Items[0].Number);
    for i := 1 to Count - 1 do
    if Result < ExtractInt(Items[i].Number) then
      Result := ExtractInt(Items[i].Number);
  end;
end;

procedure TSlottings.Delete(Index: integer);
var slt: TSlotting;
    sltg: TIDObject;
begin
  slt := Items[Index];
  if Assigned(slt.FGenSection) then
  begin
    sltg := (slt.GenSection as TGeneralizedSection).Slottings.ItemsByID[slt.ID];
    if Assigned(sltg) then
      (slt.GenSection as TGeneralizedSection).Slottings.Remove(sltg);
  end;

  inherited Delete(Index);
end;

function TSlottings.Remove(AObject: TObject): Integer;
var slt: TSlotting;
    sltg: TIDObject;
begin
  slt := AObject as TSlotting;
  if Assigned(slt.FGenSection) then
  begin
    sltg := (slt.GenSection as TGeneralizedSection).Slottings.ItemsByID[slt.ID];
    if Assigned(sltg) then
      (slt.GenSection as TGeneralizedSection).Slottings.Remove(sltg);
  end;

  Result := inherited Remove(AObject);
end;

function TSlottings.GetFinalCore(UseGenSection: Boolean): single;
var i: integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
  if UseGenSection or (not UseGenSection and not Items[i].IsInGenSection) then
    Result := Result + Items[i].CoreFinalYield;
end;

function TSlottings.GetInCore(UseGenSection: Boolean): single;
var i: integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
  if UseGenSection or (not UseGenSection and not Items[i].IsInGenSection) then
    Result := Result + Items[i].CoreYield;
end;

function TSlottings.GetBoxCount(UseGenSection: Boolean): Integer;
var sQuery: string;
begin

  sQuery := 'select distinct b.vch_box_number from tbl_box b, tbl_slotting_box sb ' +
            'where sb.slotting_uin in (' + IDList + ')' +
            'and sb.box_uin = b.box_uin';

  if not UseGenSection then
    sQuery := sQuery + ' and (sb.slotting_uin not in (select slotting_UIN from tbl_gen_section_slotting))';


  Result := TMainFacade.GetInstance.DBGates.ExecuteQuery(sQuery)

end;

function TSlottings.GetSlottingsCount(UseGenSection: Boolean): Integer;
var i: integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
  if UseGenSection or (not UseGenSection and not Items[i].IsInGenSection) then
    Result := Result + 1;
end;

{ TSlottings }

function TSlottings.GetItems(Index: integer): TSlotting;
begin
  Result := inherited Items[Index] as TSlotting;
end;

procedure TSimpleSlottings.Sort;
begin
  inherited Sort(CompareSlottings);
end;

function TSimpleSlotting.Update(ACollection: TIDObjects = nil): integer;
begin
  Result := inherited Update;
  // если мы постили весь интервал
  if Poster is TSlottingDataPoster then CoreMechanicalStates.Update(nil);
end;

end.


