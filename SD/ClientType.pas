unit ClientType;

interface

uses BaseObjects;

type

  TClientType = class(TIDObject)

  end;

  TClientTypes = class(TIDObjects)
  private
    function GetItems(Index: integer): TClientType;
  public
    property Items[Index: integer]: TClientType read GetItems;
    constructor Create; override;
  end;

implementation

uses Facade, ClientTypeDataPoster;

{ TClientTypes }

constructor TClientTypes.Create;
begin
  inherited;
  FObjectClass := TClientType;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TClientTypeDataPoster];
  OwnsObjects := true;
end;

function TClientTypes.GetItems(Index: integer): TClientType;
begin
  Result := inherited Items[Index] as TClientType;
end;

end.
