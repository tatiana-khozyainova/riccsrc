unit TestIntervalParameter;

interface

uses Parameter, Fluid, BaseObjects, Classes;

type

  TTestIntervalParameter = class(TParameter)
  private
    FFluidType: TFluidType;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    property    FluidType: TFluidType read FFluidType write FFluidType;
    function    List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;

  end;


  TTestIntervalParameters = class(TParameters)
  private
    function GetItems(Index: integer): TTestIntervalParameter;
  public
    procedure Delete(Index: integer); override;
    function  Remove(AObject: TObject): Integer; override;

    property Items[Index: integer]: TTestIntervalParameter read GetItems;
    constructor Create; override;
  end;

implementation

uses Facade, TestIntervalParameterDataPoster;

{ TTestIntervalParameter }

procedure TTestIntervalParameter.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TTestIntervalParameter).FluidType := FluidType;
end;

constructor TTestIntervalParameter.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Параметр испытания';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TTestIntervalParameterDataPoster];
end;

function TTestIntervalParameter.List(AListOption: TListOption): string;
begin
  Result := inherited List;
{  if Assigned(FluidType) then
    Result := Result + '(' + FluidType.List(loBrief) + ')';}
end;

{ TTestIntervalParameters }

constructor TTestIntervalParameters.Create;
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TTestIntervalParameterDataPoster];
  FObjectClass := TTestIntervalParameter;
end;

function TTestIntervalParameters.GetItems(
  Index: integer): TTestIntervalParameter;
begin
  Result := inherited Items[Index] as TTestIntervalParameter;
end;

procedure TTestIntervalParameters.Delete(Index: integer);
begin
  if Items[Index].RefCount = 0 then
    inherited;
end;

function TTestIntervalParameters.Remove(AObject: TObject): Integer;
begin
  Result := -1;
  if (AObject as TParameter).RefCount = 0 then
    Result := inherited Remove(AObject);
end;


end.
