unit TypeWork;

interface

uses Registrator, ComCtrls, Classes, Grids, MeasureUnits, Forms,
     Controls, BaseObjects;

type
  TTypeWork = class;
  TTypeWorks = class;

  TStateWork = class (TRegisteredIdObject)
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TStateWorks = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: integer): TStateWork;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items [Index: integer] : TStateWork read GetItems;

    constructor Create; override;
  end;

  TTypeWork = class (TRegisteredIDObject)
  private
    FSWorks: TStateWorks;
    FMeasureUnit: TMeasureUnit;
    FOwner: TTypeWork;
    FSubTypeWorks: TTypeWorks;
    FVisible: boolean;
    FLevel: integer;
    FNumber: integer;
    FNumberPP: integer;

    function    GetWorks: TStateWorks;
    function    GetSubTypeWorks: TTypeWorks;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    // единица измерения
    property    MeasureUnit: TMeasureUnit read FMeasureUnit write FMeasureUnit;
    // набор состояний работ
    property    SWorks: TStateWorks read GetWorks;
    // коллекция подтипов
    property    SubTypeWorks: TTypeWorks read GetSubTypeWorks;
    // уровень
    property    Level: integer read FLevel write FLevel;
    // если имеет подтипы, то не показывать
    property    Visible: boolean read FVisible write FVisible;
    // номер
    property    Number: integer read FNumber write FNumber;

    property    NumberPP: integer read FNumberPP write FNumberPP;

    function    GetCountChildren: integer;
    function    Update(ACollection: TIDObjects = nil): integer; override;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TTypeWorks = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: integer): TTypeWork;
    function    GetItemsByID(AID: integer): TIdObject;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items [Index: integer] : TTypeWork read GetItems;
    property    ItemsByID[AID: integer]: TIdObject read GetItemsByID;

    // получить уровень вложенности
    function    GetCountLevels (ALevel: integer): integer;
    // построить дерево (используется для построения для справочников)
    procedure   MakeTree(ATreeView: TTreeView; Parent: TTreeNode; NeedsRegistering: boolean = true; NeedsClearing: boolean = false);

    procedure   Reload(AFilter: string; UseEmptyFilter: boolean = false); reintroduce; overload;  virtual;
    // получить тип работ по порядковому номеру
    function    GetItemByNN (ANN: integer): TTypeWork;
    // получить список уинов для запроса
    function    GetFilterUINs (AIgnorTW: string = ''; AFilterStart: string = ''; AFilterEnd: string = ''; AParCount: integer = 0): string;

    constructor Create; override;
  end;

implementation

uses Facade, BaseFacades, TypeWorkPoster, SysUtils, Contnrs,
  Graphics, Math;

{ TStateWorks }

procedure TStateWorks.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TStateWorks.Create;
begin
  inherited;
  FObjectClass := TStateWork;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TStateWorkDataPoster];

  OwnsObjects := true;
end;

function TStateWorks.GetItems(Index: integer): TStateWork;
begin
  Result := inherited Items[Index] as TStateWork;
end;

{ TTypeWorks }

procedure TTypeWorks.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TTypeWorks.Create;
begin
  inherited;
  OwnsObjects := true;

  FObjectClass := TTypeWork;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TTypeWorkDataPoster];
end;

function TTypeWorks.GetCountLevels (ALevel: integer): integer;
var i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if ALevel < Items[i].Level then ALevel := Items[i].Level;
    if ALevel < Items[i].SubTypeWorks.GetCountLevels(ALevel) then ALevel := Items[i].SubTypeWorks.GetCountLevels (ALevel);
  end;

  Result := ALevel;
end;

function TTypeWorks.GetFilterUINs(AIgnorTW, AFilterStart, AFilterEnd: string;
  AParCount: integer): string;
var i : integer;
begin
  Result := AFilterStart;

  for i := 0 to Count - 1 - AParCount do
  if trim(Items[i].Name) <> AIgnorTW then
  begin
    Result := Result + IntToStr(Items[i].ID) + ', ';

    if Items[i].FSubTypeWorks.Count > 0 then
      Result := Result + Items[i].FSubTypeWorks.GetFilterUINs;
  end;

  //'TYPE_WORKS_ID in (6, 14, 22, , 59, 35, 36, 37, , 49, 50, 51, , 52, 53, 54, 55, '

  Result := Result + AFilterEnd;
end;

function TTypeWorks.GetItemByNN(ANN: integer): TTypeWork;
var i: integer;
begin
  Result := nil;

  for i := 0 to Count - 1 do
  if Items[i].Number = ANN then
  begin
    Result := Items[i];
    break;
  end
  else if Assigned(Items[i].SubTypeWorks.GetItemByNN(ANN)) then
  begin
    Result := Items[i].SubTypeWorks.GetItemByNN(ANN);
    break;
  end;
end;

function TTypeWorks.GetItems(Index: integer): TTypeWork;
begin
  Result := inherited Items[Index] as TTypeWork;
end;

{ TStateWork }

procedure TStateWork.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TStateWork.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Состояние работы';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TStateWorkDataPoster];
end;

{ TTypeWork }

procedure TTypeWork.AssignTo(Dest: TPersistent);
var o: TTypeWork;
begin
  inherited;
  o := Dest as TTypeWork;

  o.FMeasureUnit := MeasureUnit;
  o.FSWorks.Assign(SWorks);
  o.FNumber := Number;
  o.FNumberPP := NumberPP;
  o.FVisible := Visible;
  o.FLevel := Level;
  o.FSubTypeWorks.Assign(SubTypeWorks);
end;

constructor TTypeWork.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип работы';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TTypeWorkDataPoster];

  FVisible := true;
  FLevel := 1;
  FNumber := 0;
end;

function TTypeWork.GetCountChildren: integer;
var i: integer;
begin
  Result := SubTypeWorks.Count;

  for i := 0 to SubTypeWorks.Count - 1 do
    Result := Result + SubTypeWorks.Items[i].GetCountChildren;
end;

function TTypeWork.GetSubTypeWorks: TTypeWorks;
var i: integer;
    o : TTypeWork;
begin
  if not Assigned (FSubTypeWorks) then
  begin
    FSubTypeWorks := TTypeWorks.Create;
    FSubTypeWorks.Owner := Self;

    for i := 0 to TMainFacade.GetInstance.AllTypeWorks.Count - 1 do
    if Assigned (TMainFacade.GetInstance.AllTypeWorks.Items[i].FOwner) then
    if Self = TMainFacade.GetInstance.AllTypeWorks.Items[i].FOwner then
    begin
      o := TMainFacade.GetInstance.AllTypeWorks.Items[i];
      o.FLevel := (FSubTypeWorks.Owner as TTypeWork).FLevel + 1;
      FSubTypeWorks.Add(o, false, false);
    end;
  end;

  Result := FSubTypeWorks;
end;

function TTypeWork.GetWorks: TStateWorks;
begin
  if not Assigned (FSWorks) then
  begin
    FSWorks := TStateWorks.Create;
    FSWorks.Owner := Self;
    FSWorks.Reload('ID_TYPE_WORKS = ' + IntToStr(ID));
  end;

  Result := FSWorks;
end;

function TTypeWorks.GetItemsByID(AID: integer): TIdObject;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].ID = AID then
  begin
    Result := Items[i];
    break;
  end
  else if Assigned (Items[i].FSubTypeWorks.ItemsByID[AID]) then
  begin
    Result := Items[i].FSubTypeWorks.ItemsByID[AID];
    Break;
  end
end;

procedure TTypeWorks.MakeTree(ATreeView: TTreeView; Parent: TTreeNode; NeedsRegistering: boolean;
  NeedsClearing: boolean);
var i : integer;
    Node : TTreeNode;
begin
  if NeedsClearing then ATreeView.Items.Clear;

  for i := 0 to Count - 1 do
  begin
    if Items[i].Visible then
    begin
      Node := ATreeView.Items.AddChildObject(Parent, Items[i].Name, Items[i]);
      Items[i].SubTypeWorks.MakeTree(ATreeView, Node);
    end;
  end;

  if Assigned(Registrator) and NeedsRegistering then Registrator.Add(TTreeViewRegisteredObject, ATreeView, Self);
end;

procedure TTypeWorks.Reload(AFilter: string; UseEmptyFilter: boolean);
var i: integer;
begin
  inherited;

  for i := 0 to Count - 1 do
  begin
    Items[i].SubTypeWorks.Owner := Items[i];
    Items[i].SubTypeWorks.Reload('ID_PARENT_WORK_TYPE = ' + IntToStr(Items[i].Id));
  end;
end;

function TTypeWork.Update(ACollection: TIDObjects = nil): integer;
begin
  Result := 0;

  if Assigned(Collection) and Assigned(Collection.Poster) then
    Result := Collection.Poster.PostToDB(Self, Collection);
end;

end.
