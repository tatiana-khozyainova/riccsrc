unit Topolist;

interface

uses BaseObjects, Registrator;

type

  // топографический лист
  TTopographicalList = class(TRegisteredIDObject)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TTopographicalLists = class(TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TTopographicalList;
  public
    property    Items[Index: Integer]: TTopographicalList read GetItems;
    constructor Create; override;
  end;

implementation

uses TopolistDataPoster, Facade;

{ TTopographicalList }

constructor TTopographicalList.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Топографический лист';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TTopoListDataPoster];
end;

{ TTopographicalLists }

constructor TTopographicalLists.Create;
begin
  inherited;
  FObjectClass := TTopographicalList;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TTopoListDataPoster];
end;

function TTopographicalLists.GetItems(Index: Integer): TTopographicalList;
begin
  Result := inherited Items[Index] as TTopographicalList;
end;

end.
