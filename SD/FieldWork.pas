unit FieldWork;

interface

uses Registrator, BaseObjects, ComCtrls, Classes, Grids;

type
  // ÍÀÏĞÀÂËÅÍÈÅ ĞÀÁÎÒÛ
  // ÍÀÏĞÈÌÅĞ - ĞÅÃÈÎÍÀËÜÍÛÅ ĞÀÁÎÒÛ, ÏÎÈÑÊÎÂÎ-ÎÖÅÍÎ×ÍÛÅ ĞÀÁÎÒÛ

  TFieldWork = class (TRegisteredIDObject)
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TFieldWorks = class (TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TFieldWork;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items [Index: integer] : TFieldWork read GetItems;

    constructor Create; override;
  end;

implementation

uses Facade, FieldWorkPoster, Contnrs;

{ TFieldWorks }

procedure TFieldWorks.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TFieldWorks.Create;
begin
  inherited;
  FObjectClass := TFieldWork;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TFieldWorkDataPoster];

  OwnsObjects := true;
end;

function TFieldWorks.GetItems(Index: integer): TFieldWork;
begin
  Result := inherited Items[Index] as TFieldWork;
end;

{ TFieldWork }

procedure TFieldWork.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TFieldWork.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Íàïğàâëåíèå ğàáîò';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TFieldWorkDataPoster];
end;

end.
