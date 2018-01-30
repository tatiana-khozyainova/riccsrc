unit BaseWellInterval;

interface

uses Registrator, BaseObjects, Classes, Straton;

type
  TDepth = class(TIDObject)
  private
    FAbsoluteTop: double;
    FTop: double;
    FAbsoluteBottom: double;
    FBottom: double;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    // глубина от
    property   Top: double read FTop write FTop;
    // глубина до
    property   Bottom: double read FBottom write FBottom;
    // абсолютная глубина от
    property   AbsoluteTop: double read FAbsoluteTop write FAbsoluteTop;
    // абсолютная глубина до
    property   AbsoluteBottom: double read FAbsoluteBottom write FAbsoluteBottom;

    procedure  ArrangeAbsoluteDepths;
    procedure  ArrangeDepths;
  end;

  TDepths = class(TIDObjects)
  private
    function GetItems(Index: integer): TDepth;
  public
    function Add(ATop, ABottom: double): TDepth; overload;
    function AddAbsolute(AAbsoluteTop, AAbsoluteBottom: double): TDepth; overload;
    property Items[Index: integer]: TDepth read GetItems;
    function Update(ACollection: TIDObjects): integer; override;
    constructor Create; override;
  end;

  TBaseWellInterval = class(TRegisteredIDObject)
  private
    function GetNumber: string;
    function GetOwner: TIDObject; reintroduce;
    // получаем стратон по глубинам
    function GetStraton: TSimpleStraton;
  protected
    FDepths: TDepths;

    procedure   AssignTo(Dest: TPersistent); override;

    function  GetAbsoluteBottom: double; virtual;
    function  GetAbsoluteTop: double; virtual;
    function  GetBottom: double; virtual;
    function  GetTop: double; virtual;
    procedure SetAbsoluteBottom(const Value: double); virtual;
    procedure SetAbsoluteTop(const Value: double); virtual;
    procedure SetBottom(const Value: double); virtual;
    procedure SetTop(const Value: double); virtual;
    function  GetDepths: TDepths; virtual;
  public
    property   Number: string read GetNumber;
    // глубина от
    property   Top: double read GetTop write SetTop;
    // глубина до
    property   Bottom: double read GetBottom write SetBottom;

    // абсолютная глубина от
    property   AbsoluteTop: double read GetAbsoluteTop write SetAbsoluteTop;
    // абсолютная глубина до
    property   AbsoluteBottom: double read GetAbsoluteBottom write SetAbsoluteBottom;

    // скважина
    property   Owner: TIDObject read GetOwner;
    // один интервал может соединять несколько 
    property   Depths: TDepths read GetDepths;

    // возраст по стратиграфии
    property   DepthStraton: TSimpleStraton read GetStraton;


    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TBaseWellIntervals = class(TRegisteredIDObjects)
  private
    function    GetItems(Index: integer): TBaseWellInterval;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items [Index: integer] : TBaseWellInterval read GetItems;
  end;

  TSimpleWellInterval = class(TBaseWellInterval)
  protected
    function  GetAbsoluteBottom: double; override;
    function  GetAbsoluteTop: double; override;
    procedure SetAbsoluteBottom(const Value: double); override;
    procedure SetAbsoluteTop(const Value: double); override;
  end;

  TAbsoluteWellInterval = class(TBaseWellInterval)
  protected
    function  GetBottom: double; override;
    function  GetTop: double; override;
    procedure SetBottom(const Value: double); override;
    procedure SetTop(const Value: double); override;
  end;

implementation

uses Well, Contnrs;

{ TBaseWellInterval }

procedure TBaseWellInterval.AssignTo(Dest: TPersistent);
var wi: TBaseWellInterval;
begin
  inherited;

  wi := Dest as TBaseWellInterval;

  wi.Top := Top;
  wi.Bottom := Bottom;
  wi.AbsoluteTop := AbsoluteTop;
  wi.AbsoluteBottom := AbsoluteBottom;
end;

constructor TBaseWellInterval.Create(ACollection: TIDObjects);
begin
  inherited;
  FDepths := nil;
end;

destructor TBaseWellInterval.Destroy;
begin
  inherited;
end;

function TBaseWellInterval.GetAbsoluteBottom: double;
begin
  Result := Depths.Items[0].AbsoluteBottom;
end;

function TBaseWellInterval.GetAbsoluteTop: double;
begin
  Result := Depths.Items[0].AbsoluteTop;
end;

function TBaseWellInterval.GetBottom: double;
begin
  Result := Depths.Items[0].Bottom;
end;

function TBaseWellInterval.GetDepths: TDepths;
begin
  if not Assigned(FDepths) then
  begin
    FDepths := TDepths.Create;
    FDepths.Add;
  end;

  Result := FDepths;
end;

function TBaseWellInterval.GetNumber: string;
begin
  Result := Name;
end;

function TBaseWellInterval.GetOwner: TIDObject;
begin
  Result := Collection.Owner as  TIDObject;
end;

function TBaseWellInterval.GetStraton: TSimpleStraton;
begin
  Result := nil;
end;

function TBaseWellInterval.GetTop: double;
begin
  Result := Depths.Items[0].Top;
end;


procedure TBaseWellInterval.SetAbsoluteBottom(const Value: double);
begin
  Depths.Items[0].AbsoluteBottom := Value;
end;

procedure TBaseWellInterval.SetAbsoluteTop(const Value: double);
begin
  Depths.Items[0].AbsoluteTop := Value;
end;

procedure TBaseWellInterval.SetBottom(const Value: double);
begin
  Depths.Items[0].Bottom := Value;
end;

procedure TBaseWellInterval.SetTop(const Value: double);
begin
  Depths.Items[0].Top := Value;
end;

{ TBaseWellIntervals }

procedure TBaseWellIntervals.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;


function TBaseWellIntervals.GetItems(Index: integer): TBaseWellInterval;
begin
  Result := inherited Items[Index] as TBaseWellInterval;
end;



{ TSimpleWellInterval }

function TSimpleWellInterval.GetAbsoluteBottom: double;
begin
  try
    Result := Bottom - (Owner as TWell).Altitude
  except
    Result := Bottom;
  end;
end;

function TSimpleWellInterval.GetAbsoluteTop: double;
begin
  try
    Result := Top - TWell(Owner).Altitude;
  except
    Result := Top;
  end;
end;

procedure TSimpleWellInterval.SetAbsoluteBottom(const Value: double);
begin
end;

procedure TSimpleWellInterval.SetAbsoluteTop(const Value: double);
begin
end;

{ TAbsoluteWellInterval }

function TAbsoluteWellInterval.GetBottom: double;
begin
  Result := AbsoluteBottom + (Owner as TWell).Altitude;
end;

function TAbsoluteWellInterval.GetTop: double;
begin
  Result := AbsoluteTop + (Owner as TWell).Altitude;
end;

procedure TAbsoluteWellInterval.SetBottom(const Value: double);
begin

end;

procedure TAbsoluteWellInterval.SetTop(const Value: double);
begin

end;

{ TDepths }

function TDepths.Add(ATop, ABottom: double): TDepth;
begin
  Result := TDepth.Create(Self);
  inherited Add(Result);

  Result.Top := ATop;
  Result.Bottom := ABottom;
end;

function TDepths.AddAbsolute(AAbsoluteTop, AAbsoluteBottom: double): TDepth;
begin
  Result := TDepth.Create(Self);
  inherited Add(Result);

  Result.AbsoluteTop := AAbsoluteTop;
  Result.AbsoluteBottom := AAbsoluteBottom;
end;

constructor TDepths.Create;
begin
  inherited;
  FObjectClass := TDepth;
  OwnsObjects := true;
end;

function TDepths.GetItems(Index: integer): TDepth;
begin
  Result := inherited Items[Index] as TDepth;
end;

function TDepths.Update(ACollection: TIDObjects): integer;
begin
  // здесь нету суррогатного ключа и поэтому мы
  // удаляем весь вал глубин, а потом вносим заново
  // в качестве суррогатного ключа используем часть ключа
  if Count > 0 then Poster.DeleteFromDB(Items[0], Self);
  Result := inherited Update(ACollection);
end;

{ TDepth }

procedure TDepth.ArrangeAbsoluteDepths;
begin
  Top := AbsoluteTop - (Collection.Owner.Collection.OWner as TWell).Altitude;
  Bottom := AbsoluteBottom - (Collection.Owner.Collection.OWner as TWell).Altitude  
end;

procedure TDepth.ArrangeDepths;
begin
  AbsoluteTop := Top + (Collection.Owner.Collection.OWner as TWell).Altitude;
  AbsoluteBottom := Bottom + (Collection.Owner.Collection.OWner as TWell).Altitude
end;

procedure TDepth.AssignTo(Dest: TPersistent);
var d: TDepth;
begin
  inherited;

  d := Dest as TDepth;
  d.Top := Top;
  d.Bottom := Bottom;
  d.AbsoluteTop := AbsoluteTop;
  d.AbsoluteBottom := AbsoluteBottom;
end;

end.
