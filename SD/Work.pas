unit Work;

interface

uses Registrator, Classes, BaseObjects;

type

  TWork = class;
  TWorks = class;

  TWork = class (TRegisteredIDObject)
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TWorks = class (TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TWork;
  public
    property    Items [Index: integer] : TWork read GetItems;
    constructor Create; override;
  end;

implementation

uses Facade, WorkDataPoster;

{ TWork }

procedure TWork.AssignTo(Dest: TPersistent);
begin
  inherited;
end;

constructor TWork.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Работа';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TWorkDataPoster];
end;

{ TWorks }


constructor TWorks.Create;
begin
  inherited;
  FObjectClass := TWork;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TWorkDataPoster];
end;

function TWorks.GetItems(Index: integer): TWork;
begin
  Result := inherited Items[Index] as TWork;
end;

end.
