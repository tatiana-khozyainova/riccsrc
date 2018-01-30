unit SlottingWell;

interface

uses Well, Classes, SlottingPlacement;

type

  TSlottingWell = class(TWell)
  private
    FCorePresence: Single;
    function GetBoxes: TBoxes;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property CorePresence: Single read FCorePresence write FCorePresence;
    property Boxes: TBoxes read GetBoxes;
  end;

  TSlottingWells = class(TWells)
  private
    function GetItems(Index: integer): TSlottingWell;
    function GetCoreWellCount: integer;
  public
    property CoreWellCount: integer read GetCoreWellCount;
    property Items[Index: integer]: TSlottingWell read GetItems;
    constructor Create; override;
  end;

implementation

uses Facade, SlottingWellPoster;

{ TSlottingWells }

constructor TSlottingWells.Create;
begin
  inherited;
  FObjectClass := TSlottingWell;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSlottingWellDataPoster];
  OwnsObjects := true;
end;

function TSlottingWells.GetCoreWellCount: integer;
var i: integer;
begin
  Result := 0; 
  for i := 0 to Count - 1 do
  if Items[i].CorePresence > 0 then
    Result := Result + 1;
end;

function TSlottingWells.GetItems(Index: integer): TSlottingWell;
begin
  Result := inherited Items[Index] as TSlottingWell;
end;

{ TSlottingWell }

procedure TSlottingWell.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TSlottingWell).CorePresence := CorePresence;
end;

function TSlottingWell.GetBoxes: TBoxes;
begin
  Result := Slottings.Boxes;
end;

end.
