unit Construction;

interface

uses Registrator, BaseObjects;

type

   TConstructionColumnType = class(TRegisteredIDObject)
   public
     function    List(AListOption: TListOption = loBrief): string; override;
     constructor Create(ACollection: TIDObjects); override;
   end;

   TConstructionColumnTypes = class(TRegisteredIdObjects)
   private
     function GetItems(Index: integer): TConstructionColumnType;
   public
     procedure Reload; override;
     property Items[Index: integer]: TConstructionColumnType read GetItems;
     constructor Create; override;
   end;

implementation

uses Facade, ConstructionPoster;

{ TPerforatorType }

constructor TConstructionColumnType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип обсадной колонны';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TConstructionColumnTypeDataPoster];
end;

function TConstructionColumnType.List(AListOption: TListOption): string;
begin
  Result := Name;
end;

{ TPerforatorTypes }

constructor TConstructionColumnTypes.Create;
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TConstructionColumnTypeDataPoster];
  FObjectClass := TConstructionColumnType;
end;

function TConstructionColumnTypes.GetItems(Index: integer): TConstructionColumnType;
begin
  result := inherited Items[index] as TConstructionColumnType;
end;

procedure TConstructionColumnTypes.Reload;
begin
  if Assigned (FDataPoster) then
  begin
    FDataPoster.GetFromDB('', Self);
    FDataPoster.SaveState(PosterState);
  end;
end;

end.

