unit BaseActions;

interface

uses ActnList, BaseObjects, Classes, SysUtils;

type

  TBaseAction = class(TAction)
  private
    FLastCollection: TIDObjects;
    FCanUndo: boolean;
    FDestroyObject: boolean;
    FDestroyCollection: boolean;
    FLastObjectCopy: TIDObject;
  protected
    FLastObject: TIDObject;
    procedure AssignTo(Dest: TPersistent); override;
  public
    // последние над которыми проводились операции
    property LastObject: TIDObject read FLastObject;
    property LastObjectCopy: TIDObject read FLastObjectCopy;
    property LastCollection: TIDObjects read FLastCollection write FLastCollection;
    // методы выполнения с контекстом и без
    function Execute: boolean; overload; override;
    function Execute(ABaseObject: TIDObject): boolean; reintroduce; overload; virtual;
    function Execute(ABaseCollection: TIDObjects): boolean; reintroduce; overload; virtual;
    function Execute(ASQL: string): boolean; reintroduce; overload; virtual;

    // может быть откат или нет
    property CanUndo: boolean read FCanUndo write FCanUndo;

    // удалять ли последнюю коллекцию или объъект при уничтожении команды
    property DestroyCollection: boolean read FDestroyCollection write FDestroyCollection;
    property DestroyObject: boolean read FDestroyObject write FDestroyObject;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

  TBaseActionClass = class of TBaseAction;

  TBaseActionList = class(TActionList)
  private
    function GetActions(const Index: integer): TBaseAction;
    function GetActionByClassType(AClass: TBAseActionClass): TBaseAction;
  public
    property ActionByClassType[AClass: TBAseActionClass]: TBaseAction read GetActionByClassType;
    property Items[const Index: integer]: TBaseAction read GetActions;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses Math;


function TBaseAction.Execute: boolean;
begin
  inherited Execute;
  Result := true;
end;

function TBaseAction.Execute(ABaseObject: TIDObject): boolean;
begin
  FLastObject := ABaseObject;
  if Assigned(FLastObjectCopy) then FreeAndNil(FLastObjectCopy);
  if Assigned(ABaseObject) then
  begin
    FLastObjectCopy := TIDObjectClass(ABaseObject.ClassType).Create(nil);
    FLastObjectCopy.Assign(ABaseObject);
  end;
  Result := true;
  //Result := Execute;
end;

constructor TBaseAction.Create(AOwner: TComponent);
begin
  inherited;
  FLastObjectCopy := nil;
  // это перенастраивается в потомках
  // коллекции унеичтожаем по умолчанию
  DestroyCollection := true;
  // объекты оставляем
  DestroyObject := false;
  // всегда разрешено
  DisableIfNoHandler := false;
end;

destructor TBaseAction.Destroy;
begin
  // LastObject и LastCollection создаются илм ассоциируются с какими-то глобальными переменными -
  // в конструкторах потомков, а уничтодаются - здесь
  if DestroyCollection then
  try
    if Assigned(LastCollection) then LastCollection.Free;
    LastCollection := nil;
  except

  end;

  if DestroyObject then
  try
    if Assigned(LastObject) then LastObject.Free;
  except

  end;

  inherited;  
end;

function TBaseAction.Execute(ABaseCollection: TIDObjects): boolean;
begin
  FLastCollection := ABaseCollection;
  Result := Execute;
end;

function TBaseAction.Execute(ASQL: string): boolean;
begin
  Result := inherited Execute;
end;

procedure TBaseAction.AssignTo(Dest: TPersistent);
var ba: TBaseAction;
begin
  inherited;
  ba := Dest as TBaseAction;
  ba.DestroyCollection := false;
  ba.DestroyObject := false;
  ba.FLastCollection := LastCollection;
  ba.FLastObject := LastObject;
  ba.CanUndo := false;
end;

{ TBaseActionList }

constructor TBaseActionList.Create(AOwner: TComponent);
begin
  inherited;

end;

function TBaseActionList.GetActionByClassType(
  AClass: TBAseActionClass): TBaseAction;
var i: integer;
begin
  Result := nil;
  for i := 0 to ActionCount - 1 do
  if Actions[i].ClassType = AClass then
  begin
    Result := Actions[i] as TBaseAction;
    break;
  end;

  if not Assigned(Result) then
  begin
    for i := 0 to ActionCount - 1 do
    if Actions[i] is AClass then
    begin
      Result := Actions[i] as TBaseAction;
      break;
    end;
  end;


  if not Assigned(Result) then
  begin
    Result := AClass.Create(Self);
    Result.ActionList := Self;
  end;
end;

function TBaseActionList.GetActions(const Index: integer): TBaseAction;
begin
  result := inherited Actions[Index] as TBaseAction;
end;



end.
