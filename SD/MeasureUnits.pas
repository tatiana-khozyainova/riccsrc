unit MeasureUnits;

interface

uses Registrator, BaseObjects, ComCtrls, Classes, Grids;

type

  TMeasureUnit = class (TRegisteredIDObject)
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TMeasureUnits = class (TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TMeasureUnit;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items [Index: integer] : TMeasureUnit read GetItems;

    constructor Create; override;
  end;

implementation

uses MeasureUnitPoster, Facade, Contnrs;

{ TUnit }

procedure TMeasureUnit.AssignTo(Dest: TPersistent);
begin
  inherited;


end;

constructor TMeasureUnit.Create(ACollection: TIDObjects);
begin
  inherited;

  ClassIDString := 'Единица измерения';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TMeasureUnitDataPoster];
end;

{ TUnits }

procedure TMeasureUnits.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TMeasureUnits.Create;
begin
  inherited;
  FObjectClass := TMeasureUnit;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TMeasureUnitDataPoster];

  OwnsObjects := true;
end;

function TMeasureUnits.GetItems(Index: integer): TMeasureUnit;
begin
  Result := inherited Items[Index] as TMeasureUnit;
end;

end.
