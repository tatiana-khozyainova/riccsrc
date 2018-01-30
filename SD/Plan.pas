unit Plan;

interface

uses Registrator, BaseObjects, ComCtrls, Classes, Grids, LicenseZone, Forms,
     Well, FinanceSource, FieldWork, TypeWork, Organization;

type
  TOrganizationGRR  = class;
  TOrganizationGRRs = class;
  TLinePlan = class;
  TLinePlans = class;
  TComposite = class;
  TComposites = class;

  // параметр плана (например - затраты, объем, прирост)
  TParametr = class (TRegisteredIDObject)
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TParametrs = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: integer): TParametr;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items [Index: integer] : TParametr read GetItems;

    constructor Create; override;
  end;

  // значение параметра
  TParametrValue = class (TRegisteredIDObject)
  private
    FTypeParametr: TParametr;
    FState: TStateWork;
    FValueParam: double;
    FTypeWork: TTypeWork;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    // тип параметра
    property    TypeParametr: TParametr read FTypeParametr write FTypeParametr;
    // состояние (от вида работ)
    property    State: TStateWork read FState write FState;
    // тип работ
    property    TypeWork: TTypeWork read FTypeWork write FTypeWork;
    // значение параметра
    property    ValueParam: double read FValueParam write FValueParam;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TParametrValues = class (TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TParametrValue;
    function GetItemsByTypeWorkAndTypeParamID(ATWorkID, ATParam: integer): TIdObject;
    function GetItemsObject(AObject: TParametrValue): TIdObject;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items [Index: integer] : TParametrValue read GetItems;
    // объект по идентификатору типа работ
    property    ItemsByTypeWorkAndTypeParamID[ATWorkID, ATParam: integer]: TIdObject read GetItemsByTypeWorkAndTypeParamID;
    // объект по через тип работ и тип параметра конктретного объекта
    property    ItemsByObject[AObject: TParametrValue]: TIdObject read GetItemsObject;

    function    GetIDByItems(AObject: TParametrValue): integer;
    procedure   Union(ACollection: TParametrValues);

    constructor Create; override;
  end;

  // объекты композита
  TCompositeObject = class (TRegisteredIDObject)
  private
    FCompositeID: Integer;
    FComposite: TComposite;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    property    CompositeID: Integer read FCompositeID write FCompositeID;
    property    Composite: TComposite read FComposite write FComposite;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TCompositeObjects = class (TRegisteredIDObjects)
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    constructor Create; override;
  end;

  // набор объектов строки
  TComposite = class (TRegisteredIDObject)
  private
    FObjects:   TCompositeObjects;
    function    GetObjects: TCompositeObjects;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    // список объектов
    property    Objects: TCompositeObjects read GetObjects write FObjects;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TComposites = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: integer): TComposite;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items [Index: integer] : TComposite read GetItems;

    constructor Create; override;
  end;

  // строка плана
  TLinePlan = class (TRegisteredIDObject)
  private
    FFinanceSource: TFinanceSource;
    FFieldWork: TFieldWork;
    FParametrValues: TParametrValues;
    FLicZone: TSimpleLicenseZone;
    FOrganizationGRR: TOrganization;
    FComposites: TComposites;
    FTrueRecord: boolean;
    FTrueTerritoryActivity: boolean;
    FCompositeID: integer;
    function    GetParametrValues: TParametrValues;
    function    GetComposite: TComposite;
    function    GetComposites: TComposites;
    function    GetTerritoryActivity: string;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    // организация
    property    OrganizationGRR: TOrganization read FOrganizationGRR write FOrganizationGRR;
    // источник финансирования
    property    FinanceSource: TFinanceSource read FFinanceSource write FFinanceSource;
    // направление работ
    property    FieldWork: TFieldWork read FFieldWork write FFieldWork;
    // лицензионный участок
    property    LicZone: TSimpleLicenseZone read FLicZone write FLicZone;


    // набор композитных объектов
    property    CompositeID: integer read FCompositeID write FCompositeID;
    property    Composites: TComposites read GetComposites;
    property    Composite: TComposite read GetComposite;
    // значение параметров
    property    ParametrValues: TParametrValues read GetParametrValues write FParametrValues;
    // подтвержденная строка или нет
    property    TrueRecord: boolean read FTrueRecord write FTrueRecord;

    // территория деятельности
    property    TerritoryActivity: string read GetTerritoryActivity;
    // подтвержденная строка или нет
    property    TrueTerritoryActivity: boolean read FTrueTerritoryActivity write FTrueTerritoryActivity;

    function    GetParametrValueByIndex(AIndex: integer; AObject: TParametrValue): TParametrValue;

    procedure   ClearComposite;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TLinePlans = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: integer): TLinePlan;
    function    GetItemsByFinIstID(AFinIID: integer): TIdObject;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items [Index: integer] : TLinePlan read GetItems;
    // объект по идентификатору источника финансирования
    property    ItemsByFinIstID[AFinIID: integer]: TIdObject read GetItemsByFinIstID;

    procedure   SortByOrganization;

    constructor Create; override;
  end;

  // для отчетов
  TParamReport = class (TLinePlan)
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TParamsReport = class (TLinePlans)
  private
    function    GetItems(Index: integer): TParamReport;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items [Index: integer] : TParamReport read GetItems;

    constructor Create; override;
  end;

  // для отчетов
  TCountParamReport = class (TParamReport)
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TCountParamsReport = class (TParamsReport)
  private
    function    GetItems(Index: integer): TCountParamReport;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items [Index: integer] : TCountParamReport read GetItems;

    constructor Create; override;
  end;

  TOrganizationGRR = class (TOrganization)
  public
    constructor Create (ACollection: TIDObjects); override;
  end;

  TOrganizationGRRs = class (TOrganizations)
  private
    function    GetItems(Index: integer): TOrganizationGRR;
  public
    property    Items[Index: integer]: TOrganizationGRR read GetItems;

    constructor Create; override;
  end;

  TTypePlan = class (TRegisteredIDObject)
  public
    constructor Create (ACollection: TIDObjects); override;
  end;

  TTypePlans = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: integer): TTypePlan;
  public
    property    Items[Index: integer]: TTypePlan read GetItems;

    constructor Create; override;
  end;

  // план
  TObjectPlanGRR = class (TRegisteredIDObject)
  private
    FDateBegining: TDateTime;
    FDateEnding: TDateTime;
    FComment: string;
    FNotDraft: boolean;
    FAllLines: TLinePlans;
    FTypePlan: TTypePlan;
    function    GetAllLines: TLinePlans;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    // дата начала периода
    property    DateBegining: TDateTime read FDateBegining write FDateBegining;
    // дата окончания периода
    property    DateEnding: TDateTime read FDateEnding write FDateEnding;
    // комментарий
    property    Comment: string read FComment write FComment;
    // черновик или нет
    property    NotDraft: boolean read FNotDraft write FNotDraft;
    // набор строк со значениями параметров
    property    AllLines: TLinePlans read GetAllLines write FAllLines;
    // тип плана
    property    TypePlan: TTypePlan read FTypePlan write FTypePlan;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TObjectPlanGRRs = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: integer): TObjectPlanGRR;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items [Index: integer] : TObjectPlanGRR read GetItems;

    procedure   MakeList(AGrd: TStringGrid; NeedsRegistering: boolean = true; NeedsClearing: boolean = false); override;

    constructor Create; override;
  end;

implementation

uses Facade, PlanPoster, BaseFacades, Contnrs, SysUtils;

{ TParametrs }

procedure TParametrs.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TParametrs.Create;
begin
  inherited;
  FObjectClass := TParametr;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TParametrDataPoster];

  OwnsObjects := true;
end;

function TParametrs.GetItems(Index: integer): TParametr;
begin
  Result := inherited Items[Index] as TParametr;
end;

{ TParametr }

procedure TParametr.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TParametr.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Параметр плана';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TParametrDataPoster];
end;

{ TPlanGRRs }

procedure TObjectPlanGRRs.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TObjectPlanGRRs.Create;
begin
  inherited;
  FObjectClass := TObjectPlanGRR;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TObjectPlanDataPoster];

  OwnsObjects := true;
end;

function TObjectPlanGRRs.GetItems(Index: integer): TObjectPlanGRR;
begin
  Result := inherited Items[Index] as TObjectPlanGRR;
end;

{ TPlanGRR }

procedure TObjectPlanGRR.AssignTo(Dest: TPersistent);
var o: TObjectPlanGRR;
begin
  inherited;
  o := Dest as TObjectPlanGRR;

  o.DateBegining := DateBegining;
  o.DateEnding := DateEnding;
  o.Comment := Comment;
  o.NotDraft := NotDraft;

  o.TypePlan := TypePlan;
  //o.AllLines.Assign(AllLines);
end;

constructor TObjectPlanGRR.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Обеъкт плана ГРР';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TObjectPlanDataPoster];

  NotDraft := true;
end;

procedure TObjectPlanGRRs.MakeList(AGrd: TStringGrid; NeedsRegistering,
  NeedsClearing: boolean);
var i, j: integer;
begin
  if NeedsClearing then
  for i := 1 to AGrd.ColCount - 1 do
  for j := 1 to AGrd.RowCount - 1 do
    AGrd.Cells[i, j] := '';

  AGrd.RowCount := Count + 1;

  for i := 0 to Count - 1 do
  begin
    AGrd.Cells[0, i + 1] := IntToStr(i + 1);
    AGrd.Cells[1, i + 1] := trim(Items[i].FName);
    AGrd.Cells[2, i + 1] := DateToStr(Items[i].FDateBegining);
    AGrd.Cells[3, i + 1] := DateToStr(Items[i].FDateEnding);
    AGrd.Cells[4, i + 1] := trim(Items[i].FComment);

    AGrd.Objects[1, i + 1] := Items[i];
  end;
end;

{ TLinePlans }

procedure TLinePlans.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TLinePlans.Create;
begin
  inherited;
  FObjectClass := TLinePlan;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TLinePlanDataPoster];

  OwnsObjects := true;
end;

function TLinePlans.GetItems(Index: integer): TLinePlan;
begin
  Result := inherited Items[Index] as TLinePlan;
end;

function TLinePlans.GetItemsByFinIstID(AFinIID: integer): TIdObject;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].FFinanceSource.ID = AFinIID then
  begin
    Result := Items[i];
    Break;
  end;
end;

procedure TLinePlans.SortByOrganization;
begin
  Clear;

  Poster.Sort := 'ORGANIZATION_ID, LICENSE_ZONE_ID, FINANCE_SOURCE_ID, FIELD_WORKS_ID';
  Self.Poster.GetFromDB('PLAN_ID = ' + IntToStr(Owner.ID), Self);
end;

{ TLinePlan }

procedure TLinePlan.AssignTo(Dest: TPersistent);
var o: TLinePlan;
begin
  inherited;
  o := Dest as TLinePlan;

  o.LicZone := LicZone;
  o.FinanceSource := FinanceSource;
  o.FieldWork := FieldWork;
  o.OrganizationGRR := OrganizationGRR;
  o.TrueRecord := TrueRecord;
  o.CompositeID := CompositeID;
  o.TrueTerritoryActivity := TrueTerritoryActivity;

  if o.ParametrValues <> ParametrValues then
    o.ParametrValues.Assign(ParametrValues);
end;

procedure TLinePlan.ClearComposite;
begin
  //FComposite.Objects.Clear;
  //FreeAndNil(FComposite);
end;

constructor TLinePlan.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Строка плана';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TLinePlanDataPoster];

  TrueRecord := true;
end;

function TLinePlan.GetComposite: TComposite;
begin
  Result := nil;

  if Composites.Count > 0 then
    Result := Composites.Items[0]
end;

function TLinePlan.GetComposites: TComposites;
begin
  if not Assigned (FComposites) then
  begin
    FComposites := TComposites.Create;
    FComposites.Owner := Self;
    FComposites.Reload('ID_COMPOSITE = ' + IntToStr(CompositeID));
  end;

  Result := FComposites;
end;

function TLinePlan.GetParametrValueByIndex(
  AIndex: integer; AObject: TParametrValue): TParametrValue;
var i: integer;
begin
  Result := nil;

  for i := 0 to AIndex - 1 do
  if AObject.TypeParametr = ParametrValues.Items[i].TypeParametr then
    Result := ParametrValues.Items[i];
end;

function TLinePlan.GetParametrValues: TParametrValues;
begin
  if not Assigned (FParametrValues) then
  begin
    FParametrValues := TParametrValues.Create;
    FParametrValues.Owner := Self;
    FParametrValues.Reload('RECORD_PLAN_ID = ' + IntToStr(ID));
  end;

  Result := FParametrValues;
end;

function TLinePlan.GetTerritoryActivity: string;
begin
  Result := 'Территория деятельности ' + OrganizationGRR.Name;
end;

{ TParametrValue }

procedure TParametrValue.AssignTo(Dest: TPersistent);
var o: TParametrValue;
begin
  inherited;
  o := Dest as TParametrValue;

  o.TypeParametr := TypeParametr;
  o.State := State;
  o.ValueParam := ValueParam;
  o.TypeWork := TypeWork;
end;

constructor TParametrValue.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Значение параметра';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TParametrValueDataPoster];
end;

{ TParametrValues }

procedure TParametrValues.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TParametrValues.Create;
begin
  inherited;
  FObjectClass := TParametrValue;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TParametrValueDataPoster];

  OwnsObjects := true;
end;

function TParametrValues.GetIDByItems(AObject: TParametrValue): integer;
var i: integer;
begin
  Result := 0;

  for i := 0 to Count - 1 do
  begin
    if Items[i].FTypeParametr = AObject.FTypeParametr then
    if Items[i].FState = AObject.FState then
    if Items[i].FTypeWork = AObject.FTypeWork then
    begin
      Result := Items[i].ID;
      Break;
    end;
  end;
end;

function TParametrValues.GetItems(Index: integer): TParametrValue;
begin
  Result := inherited Items[Index] as TParametrValue;
end;

function TParametrValues.GetItemsByTypeWorkAndTypeParamID(ATWorkID, ATParam: integer): TIdObject;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if (Items[i].FTypeWork.ID = ATWorkID) and (Items[i].FTypeParametr.ID = ATParam) then
  begin
    Result := Items[i];
    Break;
  end;
end;

function TParametrValues.GetItemsObject(
  AObject: TParametrValue): TIdObject;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if (Items[i].FTypeWork = AObject.FTypeWork) and (Items[i].FTypeParametr = AObject.FTypeParametr) then
  begin
    Result := Items[i];
    Break;
  end;
end;

procedure TParametrValues.Union(ACollection: TParametrValues);
var i: integer;
    o : TParametrValue;
begin
  for i := 0 to ACollection.Count - 1 do
  if GetIDByItems(ACollection.Items[i]) > 0 then
  begin
    (ItemsByID[GetIDByItems(ACollection.Items[i])] as TParametrValue).FValueParam :=
      (ItemsByID[GetIDByItems(ACollection.Items[i])] as TParametrValue).FValueParam + ACollection.Items[i].FValueParam;
  end
  else
  begin
    o := ACollection.Items[i];
    Add(o);
  end;
end;

{ TComposites }

procedure TComposites.Assign(Sourse: TIDObjects; NeedClearing: boolean);
begin
  inherited;

end;

constructor TComposites.Create;
begin
  inherited;
  FObjectClass := TComposite;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TCompositeDataPoster];

  OwnsObjects := true;
end;

function TComposites.GetItems(Index: integer): TComposite;
begin
  Result := inherited Items[Index] as TComposite;
end;

{ TComposite }

procedure TComposite.AssignTo(Dest: TPersistent);
var o: TComposite;
begin
  inherited;
  o := Dest as TComposite;

  o.Objects.Assign(Objects);
end;

constructor TComposite.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Набор строк параметров';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TCompositeDataPoster];
end;

function TComposite.GetObjects: TCompositeObjects;
begin
  if not Assigned (FObjects) then
  begin
    FObjects := TCompositeObjects.Create;
    FObjects.Owner := Self;
    FObjects.Reload ('ID_COMPOSITE = ' + IntToStr(ID));
  end;

  Result := FObjects;
end;

{ TOrganizationGRR }

constructor TOrganizationGRR.Create(ACollection: TIDObjects);
begin
  inherited;
end;

{ TOrganizationGRRs }

constructor TOrganizationGRRs.Create;
begin
  inherited;
  FObjectClass := TOrganizationGRR;
end;

function TOrganizationGRRs.GetItems(Index: integer): TOrganizationGRR;
begin
  Result := inherited Items[Index] as TOrganizationGRR;
end;

function TObjectPlanGRR.GetAllLines: TLinePlans;
begin
  if not Assigned (FAllLines) then
  begin
    FAllLines := TLinePlans.Create;
    FAllLines.Owner := Self;
    FAllLines.Reload('PLAN_ID = ' + IntToStr(ID));
  end;

  Result := FAllLines;
end;

{ TCompositeObjects }

procedure TCompositeObjects.Assign(Sourse: TIDObjects;
  NeedClearing: boolean);
begin
  inherited;

end;

constructor TCompositeObjects.Create;
begin
  inherited;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TCompositeObjectsDataPoster];

  OwnsObjects := true;
end;

{ TCompositeObject }

procedure TCompositeObject.AssignTo(Dest: TPersistent);
var o: TCompositeObject;
begin
  inherited;
  o := Dest as TCompositeObject;

  o.CompositeID := CompositeID;
  o.Composite := Composite;
end;

constructor TCompositeObject.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Объект композита';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TCompositeObjectsDataPoster];
end;

{ TTypePlans }

constructor TTypePlans.Create;
begin
  inherited;
  FObjectClass := TTypePlan;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TTypePlanPoster];
end;

function TTypePlans.GetItems(Index: integer): TTypePlan;
begin
  Result := inherited Items[Index] as TTypePlan;
end;

{ TTypePlan }

constructor TTypePlan.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип плана';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TTypePlanPoster];
end;

{ TParamsReport }

procedure TParamsReport.Assign(Sourse: TIDObjects; NeedClearing: boolean);
begin
  inherited;

end;

constructor TParamsReport.Create;
begin
  inherited;
  FObjectClass := TParamReport;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TParamReportDataPoster];

end;

function TParamsReport.GetItems(Index: integer): TParamReport;
begin
  Result := inherited Items[Index] as TParamReport;
end;

{ TParamReport }

procedure TParamReport.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TParamReport.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Отчет с параметрами';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TParamReportDataPoster];
end;

{ TCountParamsReport }

procedure TCountParamsReport.Assign(Sourse: TIDObjects;
  NeedClearing: boolean);
begin
  inherited;

end;

constructor TCountParamsReport.Create;
begin
  inherited;
  FObjectClass := TCountParamReport;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TCountParamReportDataPoster];
end;

function TCountParamsReport.GetItems(Index: integer): TCountParamReport;
begin
  Result := inherited Items[Index] as TCountParamReport;
end;

{ TCountParamReport }

procedure TCountParamReport.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TCountParamReport.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Отчет с расчетными параметрами';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TCountParamReportDataPoster];
end;

end.
