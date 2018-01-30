unit Master;

interface

uses BaseObjects, ComCtrls;

type
  TMasterCreate = class (TIDObject)
  private
    FStepCount: integer;
    FSteps: TPageControl;
    FNewObject: TIDObject;
  public
    // количество шагов
    property StepCount: integer read FStepCount write FStepCount;
    property Steps: TPageControl read FSteps write FSteps;

    property NewObject: TIDObject read FNewObject write FNewObject;

    function    SetOptions (N: integer): integer;

    constructor Create (ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TMasterCreates = class(TIdObjects)
  private
    function GetItems(Index: Integer): TMasterCreate;
  public
    property Items[Index: Integer]: TMasterCreate read GetItems;
    constructor Create; override;
  end;


implementation

{ TMasterCreate }

constructor TMasterCreate.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'ћастер добавлени€ новых обектов';

  FNewObject := TIDObject.Create(nil);
end;

destructor TMasterCreate.Destroy;
begin

  inherited;
end;

function TMasterCreate.SetOptions(N: integer): integer;
var i: integer;
begin
  for i := 0 to Steps.PageCount - 1 do
    Steps.Pages[i].TabVisible := false;

  Steps.Pages[N - 1].TabVisible := true;

  Result := N - 1;
end;

{ TMasterCreates }

constructor TMasterCreates.Create;
begin
  inherited;
  FObjectClass := TMasterCreate;
end;

function TMasterCreates.GetItems(Index: Integer): TMasterCreate;
begin
  Result := INHERITED Items[Index] as TMasterCreate;
end;

end.
 