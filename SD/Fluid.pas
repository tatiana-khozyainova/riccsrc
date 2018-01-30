unit Fluid;

interface

uses Registrator, BaseObjects, Classes;

type
  TFluidCharacteristic = class(TRegisteredIDObject)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TFluidCharacteristics = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TFluidCharacteristic;
  public
    property    Items[Index: integer]: TFluidCharacteristic read GetItems;
    constructor Create; override;
  end;

  TFluidType = class(TRegisteredIDObject)
  private
    FBalanceFluid: integer;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    property    BalanceFluid: integer read FBalanceFluid write FBalanceFluid;

    function    List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
  end;


  TFluidTypes = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TFluidType;
  public
    procedure Reload; override;
    property Items[Index: integer]: TFluidType read GetItems;
    constructor Create; override;
  end;

implementation

uses Facade, FluidPoster;

{ TFluidType }

procedure TFluidType.AssignTo(Dest: TPersistent);
var o : TFluidType;
begin
  inherited;
  o := Dest as TFluidType;

  o.BalanceFluid := BalanceFluid;
end;

constructor TFluidType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип флюида';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TFluidTypeDataPoster];
  BalanceFluid := 0;
end;

function TFluidType.List(AListOption: TListOption): string;
begin
  Result := Name;
end;

{ TFluidTypes }

constructor TFluidTypes.Create;
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TFluidTypeDataPoster];
  FObjectClass := TFluidType;
end;

function TFluidTypes.GetItems(Index: integer): TFluidType;
begin
  Result := inherited Items[Index] as TFluidType;
end;

procedure TFluidTypes.Reload;
begin
  if Assigned (FDataPoster) then
  begin
    FDataPoster.GetFromDB('', Self);
    FDataPoster.SaveState(PosterState);
  end;
end;


{ TTestIntervalFluidCharacteristics }

constructor TFluidCharacteristics.Create;
begin
  inherited;
  FObjectClass := TFluidCharacteristic;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TFluidCharacteristicDataPoster];
end;

function TFluidCharacteristics.GetItems(
  Index: integer): TFluidCharacteristic;
begin
  Result := inherited Items[Index] as TFluidCharacteristic;
end;

{ TTestIntervalFluidCharacteristic }

constructor TFluidCharacteristic.Create(
  ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Характеристика типа флюида интервала испытания';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TFluidCharacteristicDataPoster];
end;


end.
