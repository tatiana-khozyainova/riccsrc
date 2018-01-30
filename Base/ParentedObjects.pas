unit ParentedObjects;

interface

uses Registrator, BaseObjects, Classes, ComCtrls;

type
  IParentChild = interface
    function GetChildren: TIDObjects;
    function GetParent: TIDObject;
    function GetMe: TIDObject;
    function GetChildAsParent(const Index: integer): IParentChild;


    property Children: TIDObjects read GetChildren;
    property ChildAsParent[const Index: integer]: IParentChild read GetChildAsParent;
    property Parent: TIDObject read GetParent;
    property Me: TIDObject read GetMe;
  end;


  // классы входящие в иерархию
  TParentedIDObject = class(TRegisteredIDObject)
  private
    FParent: TParentedIDObject;
  public
    property    Parent: TParentedIDObject read FParent write FParent;
    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TParentedIDObjects = class(TRegisteredIDObjects)
  public
    function  Add(AParentObject: TParentedIDObject): TParentedIDObject; overload;
    function  Add(AObject: TParentedIDObject; AParentObject: TParentedIDObject): TParentedIDObject; overload;

    constructor Create; override;
  end;

  TParentedRegisteredIdObject = class (TParentedIDObject)
  protected
    FRegistrator: TRegistrator;
    function    GetRegistrator: TRegistrator; override;
  public
    property    Registrator: TRegistrator read GetRegistrator;
    function    Update(ACollection: TIDObjects = nil): integer; override;

    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TParentedRegisteredIDObjects = class(TRegisteredIDObjects)
  private
    function GetItems(const Index: integer): TParentedRegisteredIDObject;
  protected
    FRegistrator: TRegistrator;
    function GetRegistrator: TRegistrator;
  public
    property Items[const Index: integer]: TParentedRegisteredIDObject read GetItems;

    function  Add: TIDObject; override;
    function  Add(AObject: TObject; Copy: boolean = true; NeedsCheck: boolean = true): TIDObject; override;

    procedure   Delete(Index: integer); override;
    function    Remove(AObject: TObject): Integer; override;
    procedure   Clear; override;

    procedure   MakeList(ALst: TStrings; NeedsRegistering: boolean = true; NeedsClearing: boolean = true); override;
    procedure   MakeList(AObject: TObject; NeedsRegistering: boolean = true; NeedsClearing: boolean = false); override;

    constructor Create; override;
    destructor  Destroy; override;
  end;

  { TODO :
Этот класс - не сильно безопасный в том смысле, что транзакционность удаления в
нём не поддерживается. Если в ходе удаления ветви объектов случилась какая-нибудь ерунда, то
часть объектов будет удалена, а часть - останется. Потом как-нибудь с этим разберёмся.
И вообще - удалять объекты пачками, это, по-моему, плохо.
Так что наследовать от этого класса не рекомендуется.
Только если очень нужно.
}

  TOwnedRegisteredIDObjects = class(TParentedRegisteredIDObjects)
  public
    procedure Delete(Index: integer); override;
    function  Remove(AObject: TObject): Integer; override;
  end;

implementation

uses Facade, BasePosters;


{ TParentedIDObjects }

function TParentedRegisteredIDObjects.Add: TIDObject;
var po: TParentedIDObject;
begin
  Result := inherited Add;
  po := Result as TParentedIdObject;

  if Assigned(Registrator) and Assigned(po.Parent) then
  begin
    Registrator.Update(Result, po.Parent, ukAdd);
    Registrator.Update(Self, Result, po.Parent, ukAdd);
  end;
end;

function TParentedRegisteredIDObjects.Add(AObject: TObject; Copy: boolean = true; NeedsCheck: boolean = true): TIDObject;
var po: TParentedIDObject;
begin
  Result := inherited Add(AObject);
  po := Result as TParentedIdObject;

  if Assigned(Registrator) then
  begin
    Registrator.Update(Result, po.Parent, ukAdd);
    Registrator.Update(Self, Result, po.Parent, ukAdd);
  end;
end;

procedure TParentedRegisteredIDObjects.Clear;
begin
  if Assigned(Registrator) then
  //if Registrator.NeedRegistering then
    Registrator.Update(Self, nil, nil, ukClear);
  inherited;
end;

constructor TParentedRegisteredIDObjects.Create;
begin
  inherited;
  FObjectClass := TParentedRegisteredIDObject;
  //FDataPoster := TParentedIDObjetcsPoster.Create;
end;

procedure TParentedRegisteredIDObjects.Delete(Index: integer);
var po: TParentedIDObject;
begin
  if OwnsObjects then
  begin
    OwnsObjects := false;
    po := Items[Index];
    inherited;
    if Assigned(Registrator) then Registrator.Update(Self, po, po.Parent, ukDelete);
    po.Free;
    OwnsObjects := true;
  end
  else
  begin
    inherited;
    po := Items[Index];
    if Assigned(Registrator) then Registrator.Update(Self, po, po.Parent, ukDelete);
  end;
end;

destructor TParentedRegisteredIDObjects.Destroy;
begin
  FRegistrator := nil;
  inherited;
end;

function TParentedRegisteredIDObjects.GetItems(
  const Index: integer): TParentedRegisteredIDObject;
begin
  Result := inherited Items[Index] as TParentedRegisteredIDObject;
end;


function TParentedRegisteredIDObjects.GetRegistrator: TRegistrator;
begin
  if not Assigned (FRegistrator) then FRegistrator := TMainFacade.GetInstance.Registrator;
  Result := FRegistrator;
end;

procedure TParentedRegisteredIDObjects.MakeList(ALst: TStrings;
  NeedsRegistering: boolean; NeedsClearing: boolean);
begin
  inherited;
  if Assigned(Registrator) and NeedsRegistering then Registrator.Add(TStringsRegisteredObject, ALst, Self);
end;


procedure TParentedRegisteredIDObjects.MakeList(AObject: TObject;
  NeedsRegistering: boolean; NeedsClearing: boolean);
var cls: TRegisteredObjectClass;
    i: integer;
begin
  inherited;
  if Assigned(Registrator) and NeedsRegistering then
  begin
    cls := Registrator.AllowedControlClasses.GetClassByControlClass(AObject.ClassType, IID_ListFrame);
    Registrator.Add(cls, AObject, Self);

    for i := 0 to Count - 1 do
      Registrator.Update(Self, Items[i], Items[i].Parent, ukAdd);
  end;
end;

function TParentedRegisteredIDObjects.Remove(AObject: TObject): Integer;
var po: TParentedIDObject;
begin
  if OwnsObjects then
  begin
    OwnsObjects := false;
    po := AObject as TParentedIDObject;
    Result := inherited Remove(AObject);
    if (Result >= 0) and Assigned(Registrator) then Registrator.Update(Self, po, po.Parent, ukDelete);
    AObject.Free;
    OwnsObjects := true;
  end
  else
  begin
    po := AObject as TParentedIDObject;
    Result := inherited Remove(AObject);
    if (Result >= 0) and Assigned(Registrator) then Registrator.Update(Self, po, po.Parent, ukDelete);
  end;
end;

{ TParentedIDObjects }


function TParentedIDObjects.Add(
  AParentObject: TParentedIDObject): TParentedIDObject;
begin
  Result := inherited Add as TParentedIDObject;
  (Result as TParentedIDObject).Parent := AParentObject;
end;

function TParentedIDObjects.Add(AObject,
  AParentObject: TParentedIDObject): TParentedIDObject;
begin
  Result := inherited Add(AObject) as TParentedIDObject;
  Result.Parent := AParentObject;
end;

constructor TParentedIDObjects.Create;
begin
  inherited;
  FDataPoster := TParentedIDObjetcsPoster.Create;
  FObjectClass := TParentedIDObject;
  NeedsReloading := true;
end;

{ TParentedIdObject }

constructor TParentedIDObject.Create(ACollection: TIDObjects);
begin
  inherited;
  //FParent := TParentedIDObject.Create(ACollection);
  FDataPoster := TParentedIDObjetcsPoster.Create;
end;

destructor TParentedIdObject.Destroy;
begin
  inherited;
end;

{ TParentedRegisteredIdObject }

constructor TParentedRegisteredIdObject.Create(ACollection: TIDObjects);
begin
  inherited;
end;

destructor TParentedRegisteredIdObject.Destroy;
begin
  if Assigned(Registrator) then Registrator.Update(Self, Parent, ukDelete);
  inherited;
end;

function TParentedRegisteredIdObject.GetRegistrator: TRegistrator;
begin
  if not Assigned (FRegistrator) then FRegistrator := TMainFacade.GetInstance.Registrator;
  Result := FRegistrator;
end;

function TParentedRegisteredIdObject.Update(ACollection: TIDObjects = nil): integer;
begin
  Result := inherited Update;

  if Assigned(Registrator) then Registrator.Update(Self, Parent, ukUpdate);
end;

{ TOwnedRegisteredIDObjects }

procedure TOwnedRegisteredIDObjects.Delete(Index: integer);
var po: TParentedIDObject;
begin
  if OwnsObjects then
  begin
    OwnsObjects := false;
    po := Items[Index] as TParentedIDObject;
    if Assigned(Registrator) then Registrator.Update(Self, po, po.Parent, ukDeleteWithChildren);
    inherited;
    po.Free;
    OwnsObjects := true;
  end
  else
  begin
    po := Items[Index] as TParentedIDObject;
    if Assigned(Registrator) then Registrator.Update(Self, po, po.Parent, ukDeleteWithChildren);
    inherited;
  end;
end;

function TOwnedRegisteredIDObjects.Remove(AObject: TObject): Integer;
var po: TParentedIDObject;
begin
  if OwnsObjects then
  begin
    OwnsObjects := false;
    po := AObject as TParentedIDObject;
    if Assigned(Registrator) then Registrator.Update(Self, po, po.Parent, ukDeleteWithChildren);
    Result := inherited Remove(AObject);
    AObject.Free;
    OwnsObjects := true;
  end
  else
  begin
    po := AObject as TParentedIDObject;
    if Assigned(Registrator) then Registrator.Update(Self, po, po.Parent, ukDeleteWithChildren);
    Result := inherited Remove(AObject);
  end;
end;

end.
