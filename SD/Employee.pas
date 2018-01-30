unit Employee;

interface

uses BaseObjects, Registrator, Classes;

type 
    // должности
  TPost = class (TIDObject)
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TPosts = class (TIDObjects)
  private
    function    GetItems(Index: Integer): TPost;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;

    property    Items[Index: Integer]: TPost read GetItems;

    procedure   Reload; override;

    constructor Create; override;
  end;

    // сотрудники
  TEmployee = class (TRegisteredIDObject)
  private
    FPost: TPost;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    property    Post: TPost read FPost write FPost;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TEmployees = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TEmployee;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items[Index: Integer]: TEmployee read GetItems;

    function    ObjectsToStr (AAuthors: string): string; override;
    constructor Create; override;
  end;

    // свои сотрудники
  TEmployeeOur = class (TEmployee)
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TEmployeeOurs= class (TEmployees)
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    constructor Create; override;
  end;

    // внешние сотрудники
  TEmployeeOutside = class (TEmployee)
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TEmployeeOutsides= class (TEmployees)
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    constructor Create; override;
  end;


implementation

uses Facade, EmployeePoster;

{ TEmployee }

procedure TEmployee.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TEmployee.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Сотрудник ТП НИЦ';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TEmployeeDataPoster];
end;

{ TEmployees }

procedure TEmployees.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TEmployees.Create;
begin
  inherited;
  FObjectClass := TEmployee;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TEmployeeDataPoster];
end;

function TEmployees.GetItems(Index: Integer): TEmployee;
begin
  Result := inherited Items[Index] as TEmployee;
end;

function TEmployees.ObjectsToStr(AAuthors: string): string;
begin
  inherited ObjectsToStr(AAuthors);
end;

{ TEmployeeOur }

procedure TEmployeeOur.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TEmployeeOur.Create(ACollection: TIDObjects);
begin
  inherited;

end;

{ TEmployeeOurs }

procedure TEmployeeOurs.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TEmployeeOurs.Create;
begin
  inherited;

end;

{ TEmployeeOutside }

procedure TEmployeeOutside.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TEmployeeOutside.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Сторонний сотрудник';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TEmployeeOutsideDataPoster];
end;

{ TEmployeeOutsides }

procedure TEmployeeOutsides.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TEmployeeOutsides.Create;
begin
  inherited;
  FObjectClass := TEmployeeOutside;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TEmployeeOutsideDataPoster];
end;



{ TPost }

procedure TPost.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TPost.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Должность';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TPostDataPoster];
end;

{ TPosts }

procedure TPosts.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TPosts.Create;
begin
  inherited;
  FObjectClass := TPost;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TPostDataPoster];
end;

function TPosts.GetItems(Index: Integer): TPost;
begin
  Result := inherited Items[Index] as TPost;
end;


procedure TPosts.Reload;
begin
  if Assigned (FDataPoster) then
  begin
    FDataPoster.GetFromDB('', Self);
    FDataPoster.SaveState(PosterState);    
  end;
end;

end.
