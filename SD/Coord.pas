unit Coord;

interface

uses Registrator, BaseObjects;

type
    // источник координат скважины
  TSourceCoord = class (TRegisteredIDObject)
  public
    constructor Create (ACollection: TIDObjects); override;
  end;

  TSourceCoords = class (TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TSourceCoord;
  public
    property    Items[Index: Integer]: TSourceCoord read GetItems;

    Constructor Create; override;
  end;

    // координаты скважины
  TWellCoord = class (TRegisteredIDObject)
  private
    FcoordY: double;
    FcoordX: double;
    FNUM_OBJECT_SUBTYPE: Integer;
    FNUM_ZONE_NUMBER: Integer;
    FdtmEnteringDate: TDateTime;
    FSourceCoord: TSourceCoord;
  protected

  public
    property NUM_OBJECT_SUBTYPE: Integer read FNUM_OBJECT_SUBTYPE write FNUM_OBJECT_SUBTYPE;
    property NUM_ZONE_NUMBER: Integer read FNUM_ZONE_NUMBER write FNUM_ZONE_NUMBER;

    property coordX: double read FcoordX write FcoordX;
    property coordY: double read FcoordY write FcoordY;

    property dtmEnteringDate: TDateTime read FdtmEnteringDate write FdtmEnteringDate;

    property SourceCoord: TSourceCoord read FSourceCoord write FSourceCoord;

    function X_grad: Integer;
    function X_min:  Integer;
    function X_sec:  Double;

    function Y_grad: Integer;
    function Y_min:  Integer;
    function Y_sec:  Double;

    constructor Create (ACollection: TIDObjects); override;
  end;

  TWellCoords = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TWellCoord;
  public
    property    Items[Index: Integer]: TWellCoord read GetItems;

    Constructor Create; override;
  end;

implementation

uses CoordPoster, Facade, BaseFacades, Math, Variants;

{ TWellCoords }

constructor TWellCoords.Create;
begin
  inherited;
  FObjectClass := TWellCoord;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TWellCoordDataPoster];
end;

function TWellCoords.GetItems(Index: Integer): TWellCoord;
begin
  Result := inherited Items[index] as TWellCoord;
end;

{ TWellCoord }

constructor TWellCoord.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Координаты скважины';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TWellCoordDataPoster];

end;

function TWellCoord.X_grad: Integer;
begin
  Result := Trunc(coordX) div 3600;
end;

function TWellCoord.X_min: Integer;
begin
  Result := (Trunc(coordX) - X_grad * 3600) div 60;
end;

function TWellCoord.X_sec: Double;
begin
  Result := coordX - X_grad * 3600 - X_min * 60;
end;

//67 20 50.311

function TWellCoord.Y_grad: Integer;
begin
  Result := Trunc(coordY) div 3600;
end;

function TWellCoord.Y_min: Integer;
begin
  Result := (Trunc(coordY) - Y_grad * 3600) div 60;
end;

function TWellCoord.Y_sec: Double;
begin
  Result := coordY - Y_grad * 3600 - Y_min * 60;
end;

{ TSourceCoords }

constructor TSourceCoords.Create;
begin
  inherited;
  FObjectClass := TSourceCoord;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSourceCoordDataPoster];
end;

function TSourceCoords.GetItems(Index: Integer): TSourceCoord;
begin
  Result := inherited Items[Index] as TSourceCoord;
end;

{ TSourceCoord }

constructor TSourceCoord.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Источник координат скважины';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSourceCoordDataPoster];
end;

end.
