unit Theme;

interface

uses Registrator, BaseObjects, Classes, ComCtrls, Employee;

type
  TTheme = class (TRegisteredIDObject)
  private
    FNumber: string;
    FFolder: string;
    FActualPeriodStart: TDateTime;
    FActualPeriodFinish: TDateTime;
    FPerformer: TEmployee;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    // номер темы
    property Number: string read FNumber write FNumber;
    // период актуальности темы
    property ActualPeriodStart: TDateTime read FActualPeriodStart write FActualPeriodStart;
    property ActualPeriodFinish: TDateTime read FActualPeriodFinish write FActualPeriodFinish;
    // ответсвтвенный исполнитель
    property Performer: TEmployee read FPerformer write FPerformer;
    // папка
    property Folder: string read FFolder write FFolder;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TThemes = class (TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TTheme;
  public
    procedure Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property Items[Index: Integer]: TTheme read GetItems;
    constructor Create; override;
  end;


implementation

uses ThemePoster, Facade;

{ TTheme }

procedure TTheme.AssignTo(Dest: TPersistent);
var o: TTheme;
begin
  inherited;
  o := Dest as TTheme;

  o.FNumber := Number;
  o.FFolder := Folder;
  o.FActualPeriodStart := ActualPeriodStart;
  o.FActualPeriodFinish := ActualPeriodFinish;
  o.FPerformer := Performer;
end;

constructor TTheme.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тема документа';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TThemeDataPoster];
end;

{ TThemes }

procedure TThemes.Assign(Sourse: TIDObjects; NeedClearing: boolean);
begin
  inherited;

end;

constructor TThemes.Create;
begin
  inherited;
  FObjectClass := TTheme;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TThemeDataPoster];
end;

function TThemes.GetItems(Index: Integer): TTheme;
begin
  Result := inherited Items[index] as TTheme;
end;

end.
  
