unit Perforator;

interface

uses Registrator, BaseObjects;

type

   TPerforatorType = class(TRegisteredIDObject)
   public
     function    List(AListOption: TListOption = loBrief): string; override;
     constructor Create(ACollection: TIDObjects); override;
   end;

   TPerforatorTypes = class(TRegisteredIdObjects)
   private
     function GetItems(Index: integer): TPerforatorType;
   public
     procedure Reload; override;
     property Items[Index: integer]: TPerforatorType read GetItems;
     constructor Create; override;
   end;

implementation

uses Facade, PerforatorPoster;

{ TPerforatorType }

constructor TPerforatorType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип перфоратора';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TPerforatorDataPoster];
end;

function TPerforatorType.List(AListOption: TListOption): string;
begin
  Result := Name;
end;

{ TPerforatorTypes }

constructor TPerforatorTypes.Create;
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TPerforatorDataPoster];
  FObjectClass := TPerforatorType;
end;

function TPerforatorTypes.GetItems(Index: integer): TPerforatorType;
begin
  result := inherited Items[index] as TPerforatorType;
end;

procedure TPerforatorTypes.Reload;
begin
  if Assigned (FDataPoster) then
  begin
    FDataPoster.GetFromDB('', Self);
    FDataPoster.SaveState(PosterState);
  end;
end;

end.
