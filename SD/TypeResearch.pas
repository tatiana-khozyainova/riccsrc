unit TypeResearch;

interface

uses Registrator, BaseObjects, ComCtrls, Classes, Grids;

type

  TSimpleTypeResearch = class (TRegisteredIDObject)
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TSimpleTypeResearchs = class (TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TSimpleTypeResearch;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items [Index: integer] : TSimpleTypeResearch read GetItems;

    constructor Create; override;
  end;

  TTypeResearch = class (TRegisteredIDObject)
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TTypeResearchs = class (TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TTypeResearch;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items [Index: integer] : TTypeResearch read GetItems;

    procedure   MakeList(AGrd: TStringGrid; NeedsRegistering: boolean = true; NeedsClearing: boolean = false); override;

    constructor Create; override;
  end;

  TRockSampleResearch = class (TTypeResearch)
  private
    FResearch: boolean;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    property    Research: boolean read FResearch write FResearch;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TRockSampleResearchs = class (TTypeResearchs)
  private
    function GetItems(Index: integer): TRockSampleResearch;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items [Index: integer] : TRockSampleResearch read GetItems;

    constructor Create; override;
  end;


implementation

uses Facade, BaseFacades, TypeResearchPoster, SysUtils;

{ TSimpleTypeResearchs }

procedure TSimpleTypeResearchs.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TSimpleTypeResearchs.Create;
begin
  inherited;

end;

function TSimpleTypeResearchs.GetItems(
  Index: integer): TSimpleTypeResearch;
begin
  Result := inherited Items[Index] as TSimpleTypeResearch;
end;

{ TSimpleTypeResearch }

procedure TSimpleTypeResearch.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TSimpleTypeResearch.Create(ACollection: TIDObjects);
begin
  inherited;

end;

{ TTypeResearchs }

procedure TTypeResearchs.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TTypeResearchs.Create;
begin
  inherited;

  FObjectClass := TTypeResearch;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TTypeResearchDataPoster];

  OwnsObjects := true;
end;

function TTypeResearchs.GetItems(Index: integer): TTypeResearch;
begin
  Result := inherited Items[Index] as TTypeResearch;
end;

procedure TTypeResearchs.MakeList(AGrd: TStringGrid; NeedsRegistering,
  NeedsClearing: boolean);
var i: integer;
begin
  inherited;

  for i := 0 to Count - 1 do
  begin
    AGrd.ColCount := AGrd.ColCount + 1;
    AGrd.Cells[AGrd.ColCount - 1, 0] := ' ' + Items[i].Name + '   ';
  end;

  for i := 0 to AGrd.ColCount - 1 do
    AGrd.ColWidths[i] := AGrd.Canvas.TextWidth(AGrd.Cells[i, 0]);
end;

{ TTypeResearch }

procedure TTypeResearch.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TTypeResearch.Create(ACollection: TIDObjects);
begin
  inherited;

  ClassIDString := 'Вид исследования';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TTypeResearchDataPoster];
end;

{ TRockSimpleResearchs }

procedure TRockSampleResearchs.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TRockSampleResearchs.Create;
begin
  inherited;
  FObjectClass := TRockSampleResearch;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TRockSampleResearchDataPoster];

  OwnsObjects := true;
end;

function TRockSampleResearchs.GetItems(
  Index: integer): TRockSampleResearch;
begin
  Result := inherited Items[Index] as TRockSampleResearch;
end;

{ TRockSimpleResearch }

procedure TRockSampleResearch.AssignTo(Dest: TPersistent);
var o: TRockSampleResearch;
begin
  inherited;
  o := Dest as TRockSampleResearch;

  o.Research := Research;
end;

constructor TRockSampleResearch.Create(ACollection: TIDObjects);
begin
  inherited;

  ClassIDString := 'Вид исследования для образца';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TRockSampleResearchDataPoster];

  FResearch := false;
end;

end.
