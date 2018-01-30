unit State;

interface

uses Registrator, BaseObjects, Classes;

type
  // причины ликвидации
  TAbandonReason = class (TRegisteredIDObject)
  public
    constructor Create (ACollection: TIDObjects); override;
  end;

  TAbandonReasons = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TAbandonReason;
  public
    property    Items[Index: Integer]: TAbandonReason read GetItems;
    Constructor Create; override;
  end;

  // причины ликвидации скважины
  TAbandonReasonWell = class (TAbandonReason)
  private
    FDtLiquidation: TDateTime;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    // дата ликвидации
    property    DtLiquidation: TDateTime read FDtLiquidation write FDtLiquidation;

    constructor Create (ACollection: TIDObjects); override;
  end;

  TAbandonReasonWells = class (TAbandonReasons)
  private
    function    GetItems(Index: Integer): TAbandonReasonWell;
  public
    property    Items[Index: Integer]: TAbandonReasonWell read GetItems;
    Constructor Create; override;
  end;

  // cосто€ние скважины
  TState = class (TRegisteredIDObject)
  public
    constructor Create (ACollection: TIDObjects); override;
  end;

  TStates = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TState;
  public
    property    Items[Index: Integer]: TState read GetItems;
    Constructor Create; override;
  end;

implementation

uses Facade, StatePoster;

{ TWellState }

constructor TState.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := '—осто€ние скважины';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TStateDataPoster];
end;

{ TWellStates }

constructor TStates.Create;
begin
  inherited;
  FObjectClass := TState;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TStateDataPoster];
end;

function TStates.GetItems(Index: Integer): TState;
begin
  Result := inherited Items[Index] as TState;
end;

{ TAbandonReasons }

constructor TAbandonReasons.Create;
begin
  inherited;
  FObjectClass := TAbandonReason;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TAbandonReasonDataPoster];
end;

function TAbandonReasons.GetItems(Index: Integer): TAbandonReason;
begin
  Result := inherited Items[Index] as TAbandonReason;
end;

{ TAbandonReason }

constructor TAbandonReason.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'ѕричина ликвидации';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TAbandonReasonDataPoster];
end;

{ TAbandonReasonWells }

constructor TAbandonReasonWells.Create;
begin
  inherited;
  FObjectClass := TAbandonReasonWell;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TAbandonReasonWellDataPoster];
end;

function TAbandonReasonWells.GetItems(Index: Integer): TAbandonReasonWell;
begin
  Result := inherited Items[Index] as TAbandonReasonWell;
end;

{ TAbandonReasonWell }

procedure TAbandonReasonWell.AssignTo(Dest: TPersistent);
var o: TAbandonReasonWell;
begin
  inherited;
  o := Dest as TAbandonReasonWell;

  o.DtLiquidation := DtLiquidation;
end;

constructor TAbandonReasonWell.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'ѕричина ликвидации скважины';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TAbandonReasonWellDataPoster];
end;

end.
