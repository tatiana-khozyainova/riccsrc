unit Lithology;

interface

uses Registrator, Classes, BaseObjects;

type

  TLithology = class (TRegisteredIDObject)
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TLithologies = class(TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TLithology;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items[Index: Integer]: TLithology read GetItems;

    constructor Create; override;
  end;


implementation

uses LithologyPoster, Facade, BaseFacades;

{ TLithologies }

procedure TLithologies.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TLithologies.Create;
begin
  inherited;
  FObjectClass := TLithology;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TLithologyDataPoster];
end;

function TLithologies.GetItems(Index: Integer): TLithology;
begin
  Result := inherited Items[Index] as TLithology;
end;

{ TLithology }

procedure TLithology.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TLithology.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Литология';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TLithologyDataPoster];
end;

end.
 