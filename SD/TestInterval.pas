unit TestInterval;

interface

uses Registrator, BaseObjects, ComCtrls, Classes,
     BaseWellInterval, Straton, Parameter, Variants,
     Fluid;


type
  TTestIntervalFluidCharacteristic = class(TRegisteredIDObject)
  private
    FFluidType: TFluidType;
    FFluidCharacteristics: TFluidCharacteristics;
    function  GetFluidCharacteristics: TFluidCharacteristics;
    procedure SetFluidType(const Value: TFluidType);
  protected
    procedure   AssignTo(Dest: TPersistent); override;
    function    GetPropertyValue(APropertyID: integer): OleVariant; override;
  public
    function    List(AListOption: TListOption = loBrief): string; override;
    property    FluidType: TFluidType read FFluidType write SetFluidType;
    property    FluidCharacteristics: TFluidCharacteristics read GetFluidCharacteristics;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TTestIntervalFluidCharacteristics = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TTestIntervalFluidCharacteristic;
  public
    property Items[Index: integer]: TTestIntervalFluidCharacteristic read GetItems;
    function GetCharacteristicByFluidType(AFluidType: TFluidType): TTestIntervalFluidCharacteristic;
    function Add(AFluidType: TFluidType): TTestIntervalFluidCharacteristic;
    constructor Create; override;
  end;


  TTestingAttitude = class(TRegisteredIDObject)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TTestingAttitudes = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TTestingAttitude;
  public
    property Items[Index: integer]: TTestingAttitude read GetItems;

    constructor Create; override;
  end;

  TSimpleTestIntervalDepths = class(TDepths)
  public
    constructor Create; override;

  end;

  TSimpleTestInterval = class(TAbsoluteWellInterval)
  private
    FDescription: string;
    FSimpleStraton: TSimpleStraton;
    FTestingAttitude: TTestingAttitude;
    FParameterValues: TParameterValues;
    FTestIntervalCharacteristics: TTestIntervalFluidCharacteristics;
    function GetParameterValues: TParameterValues;
    function GetTestIntervalCharacteristics: TTestIntervalFluidCharacteristics;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
    function    GetPropertyValue(APropertyID: integer): OleVariant; override;
    function    GetDepths: TDepths; override;
  public
    property Description: string read FDescription write FDescription;
    property Straton: TSimpleStraton read FSimpleStraton write FSimpleStraton;
    property Attitude: TTestingAttitude read FTestingAttitude write FTestingAttitude;
    property ParameterValues: TParameterValues read GetParameterValues;
    property TestIntervalCharacteristics: TTestIntervalFluidCharacteristics read GetTestIntervalCharacteristics;


    procedure Accept(Visitor: IVisitor); override;


    function List(AListOption: TListOption = loBrief): string; override;
    function Update(ACollection: TIDObjects = nil): integer; override;


    constructor Create(ACollection: TIDObjects); override;
  end;

  TSimpleTestIntervals = class(TBaseWellIntervals)
  private
    function GetItems(Index: integer): TSimpleTestInterval;
  public
    property Items[Index: integer]: TSimpleTestInterval read GetItems;

    constructor Create; override;
  end;

  TTestInterval = class(TSimpleTestInterval)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TTestIntervals = class(TSimpleTestIntervals)
  private
    function GetItems(Index: integer): TTestInterval;
  public
    property Items[Index: integer]: TTestInterval read GetItems;
    constructor Create; override;
  end;


implementation

uses Facade, TestIntervalPoster, SysUtils;



{ TSimpleTestIntervals }

constructor TSimpleTestIntervals.Create;
begin
  inherited;
  FObjectClass := TSimpleTestInterval;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TTestIntervalDataPoster];
end;

function TSimpleTestIntervals.GetItems(
  Index: integer): TSimpleTestInterval;
begin
  Result := inherited Items[Index] as TSimpleTestInterval;
end;

{ TTestIntervals }

constructor TTestIntervals.Create;
begin
  inherited;
  FObjectClass := TTestInterval;

  OwnsObjects := true;
end;

function TTestIntervals.GetItems(Index: integer): TTestInterval;
begin
  Result := inherited Items[Index] as TTestInterval;
end;

{ TTestInterval }

procedure TSimpleTestInterval.Accept(Visitor: IVisitor);
begin
  inherited;
  IVisitor(Visitor).VisitTestInterval(Self);
end;

procedure TSimpleTestInterval.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TTestInterval).Description := Description;
  (Dest as TTestInterval).Straton := Straton;
  (Dest as TTestInterval).Attitude := Attitude;
  (Dest as TTestInterval).Depths.Assign(Depths);
  (Dest as TTestInterval).TestIntervalCharacteristics.Assign(TestIntervalCharacteristics);
  (Dest as TTestInterval).ParameterValues.Assign(ParameterValues);
end;

constructor TSimpleTestInterval.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Долбление';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TTestIntervalDataPoster];
  FTestIntervalCharacteristics := nil;
end;

{ TTestInterval }

constructor TTestInterval.Create(ACollection: TIDObjects);
begin
  inherited;
end;

{ TTestingAttitude }

constructor TTestingAttitude.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Характер опробования';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TTestingAttitudeDataPoster];
end;

{ TTestingAttitudes }

constructor TTestingAttitudes.Create;
begin
  inherited;
  FObjectClass := TTestingAttitude;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TTestingAttitudeDataPoster];
end;

function TTestingAttitudes.GetItems(Index: integer): TTestingAttitude;
begin
  Result := inherited Items[Index] as TTestingAttitude;
end;


function TSimpleTestInterval.GetDepths: TDepths;
begin
  if not Assigned(FDepths) then
  begin
    FDepths := TSimpleTestIntervalDepths.Create;
    FDepths.Owner := Self;
    FDepths.Reload('TESTING_INTERVAL_UIN = ' + IntToStr(ID));
    if FDepths.Count = 0 then FDepths.Add;
  end;

  Result := FDepths;
end;

function TSimpleTestInterval.GetParameterValues: TParameterValues;
begin
  if not Assigned(FParameterValues) then
  begin
    FParameterValues := TParameterValues.Create;
    FParameterValues.Owner := Self;
    FParameterValues.Reload('Testing_Interval_UIN = ' + IntToStr(ID));
  end;

  Result := FParameterValues;
end;

function TSimpleTestInterval.GetPropertyValue(
  APropertyID: integer): OleVariant;
begin
  Result := null;

  case APropertyID of
  1:  Result := Number;
  2:  Result := AbsoluteTop;
  3:  Result := AbsoluteBottom;
  4:  Result := List;
  5:  Result := Format('%.2f', [AbsoluteTop]) + ' - ' + Format('%.2f', [AbsoluteBottom]);
  6:  Result := Straton.List;
  7:  Result := Attitude.List;
  8:  Result := Description;
  end;
end;

function TSimpleTestInterval.GetTestIntervalCharacteristics: TTestIntervalFluidCharacteristics;
begin
  if not Assigned(FTestIntervalCharacteristics) then
  begin
    FTestIntervalCharacteristics := TTestIntervalFluidCharacteristics.Create;
    FTestIntervalCharacteristics.OwnsObjects := false;
    FTestIntervalCharacteristics.Owner := Self;
    FTestIntervalCharacteristics.Reload('TESTING_INTERVAL_UIN = ' + IntToStr(ID), false);
  end;

  Result := FTestIntervalCharacteristics;
end;

function TSimpleTestInterval.List(AListOption: TListOption = loBrief): string;
var sInterval: string;
    i: integer;
begin
  Result := inherited List;

  sInterval := '';
  for i := 0 to Depths.Count - 1 do
    sInterval := sInterval + '[' + Format('%.2f', [Depths.Items[i].AbsoluteTop]) + ' - ' + Format('%.2f', [Depths.Items[i].AbsoluteBottom]) + ']';

  if AListOption <> loFull then
    Result := Result + sInterval
  else
    Result := (Collection as TIDObjects).Owner.List + ' ' + Result + sInterval; 


end;

function TSimpleTestInterval.Update(ACollection: TIDObjects = nil): integer;
begin
  Result := inherited Update;

  Depths.Update(ACollection);
  TestIntervalCharacteristics.Update(nil);
  ParameterValues.Update(nil);
end;

{ TSimpleTestIntervalDepths }

constructor TSimpleTestIntervalDepths.Create;
begin
  inherited;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TTestIntervalAdditionalDepthPoster];
end;


{ TTestIntervalFluidCharacteristic }

procedure TTestIntervalFluidCharacteristic.AssignTo(Dest: TPersistent);
var tifc: TTestIntervalFluidCharacteristic;
    i: integer;
begin
  inherited;
  tifc := Dest as TTestIntervalFluidCharacteristic;

  tifc.FluidType := FluidType;
  for i := 0 to FluidCharacteristics.Count - 1 do
    tifc.FluidCharacteristics.Add(FluidCharacteristics.Items[i], false, false);
end;

constructor TTestIntervalFluidCharacteristic.Create(
  ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Характеристика типа флюида интервала опробования';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TTestingIntervalFluidCharacteristicDataPoster];
end;

function TTestIntervalFluidCharacteristic.GetFluidCharacteristics: TFluidCharacteristics;
begin
  if not Assigned(FFluidCharacteristics) then
  begin
    FFluidCharacteristics := TFluidCharacteristics.Create;
    FFluidCharacteristics.OwnsObjects := false;
    FFluidCharacteristics.Owner := Self;
  end;

  Result := FFluidCharacteristics;
end;

function TTestIntervalFluidCharacteristic.GetPropertyValue(
  APropertyID: integer): OleVariant;
begin
  Result := null;

  case APropertyID of
  1:  Result := FluidType.List(loBrief);
  2:  Result := FluidCharacteristics.List(loBrief);
  end;
end;

function TTestIntervalFluidCharacteristic.List(
  AListOption: TListOption): string;
begin
  if Assigned(FFluidType) then Result := FluidType.List(loBrief)
  else Result := inherited List(AListOption);
end;

procedure TTestIntervalFluidCharacteristic.SetFluidType(
  const Value: TFluidType);
begin
  if FFluidType <> Value then
  begin
    FFluidType := Value;
    Registrator.Update(Self, Self.Collection.Owner, ukUpdate);
  end;
end;

{ TTestIntervalFluidCharacteristics }

function TTestIntervalFluidCharacteristics.Add(
  AFluidType: TFluidType): TTestIntervalFluidCharacteristic;
begin
  Result := GetCharacteristicByFluidType(AFluidType);
  if not Assigned(Result) then
  begin
    Result := inherited Add as TTestIntervalFluidCharacteristic;
    Result.FluidType := AFluidType;
  end;
end;

constructor TTestIntervalFluidCharacteristics.Create;
begin
  inherited;
  FObjectClass := TTestIntervalFluidCharacteristic;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TTestingIntervalFluidCharacteristicDataPoster];
end;

function TTestIntervalFluidCharacteristics.GetCharacteristicByFluidType(
  AFluidType: TFluidType): TTestIntervalFluidCharacteristic;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].FluidType = AFluidType then
  begin
    Result := Items[i];
    break;
  end;
end;

function TTestIntervalFluidCharacteristics.GetItems(
  Index: integer): TTestIntervalFluidCharacteristic;
begin
  Result := inherited Items[Index] as TTestIntervalFluidCharacteristic;
end;

end.

