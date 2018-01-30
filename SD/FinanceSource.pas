unit FinanceSource;

interface

uses Registrator, BaseObjects, ComCtrls, Classes, Grids, Well;

type
  // источник финансирования
  TFinanceSource = class (TRegisteredIDObject)
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TFinanceSources = class (TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TFinanceSource;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items [Index: integer] : TFinanceSource read GetItems;

    constructor Create; override;
  end;

  // источник финансирования скважины
  TFinanceSourceWell = class (TFinanceSource)
  private
    FWell: TSimpleWell;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    property    Well: TSimpleWell read FWell write FWell;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TFinanceSourcesWell = class (TFinanceSources)
  private
    function GetItems(Index: integer): TFinanceSourceWell;
  public
    property    Items [Index: integer] : TFinanceSourceWell read GetItems;
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;

    constructor Create; override;
  end;

implementation

uses Facade, FinanceSourcePoster, BaseFacades;

{ TFinanceSources }

procedure TFinanceSources.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TFinanceSources.Create;
begin
  inherited;
  FObjectClass := TFinanceSource;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TFinanceSourceDataPoster];

  OwnsObjects := true;
end;

function TFinanceSources.GetItems(Index: integer): TFinanceSource;
begin
  Result := inherited Items[Index] as TFinanceSource;
end;

{ TFinanceSource }

procedure TFinanceSource.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TFinanceSource.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Источник финансирования';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TFinanceSourceDataPoster];
end;

{ TFinanceSourceWell }

procedure TFinanceSourceWell.AssignTo(Dest: TPersistent);
var o: TFinanceSourceWell;
begin
  inherited;
  o := Dest as TFinanceSourceWell;

  o.Well := Well;
end;

constructor TFinanceSourceWell.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Источник финансирования скважины';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TFinanceSourceWellDataPoster];
end;

{ TFinanceSourcesWell }

procedure TFinanceSourcesWell.Assign(Sourse: TIDObjects;
  NeedClearing: boolean);
begin

end;

constructor TFinanceSourcesWell.Create;
begin
  inherited;
  FObjectClass := TFinanceSourceWell;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TFinanceSourceWellDataPoster];
end;

function TFinanceSourcesWell.GetItems(Index: integer): TFinanceSourceWell;
begin
  Result := inherited Items[Index] as TFinanceSourceWell;
end;

end.
