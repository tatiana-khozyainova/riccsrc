unit ReasonChange;

interface

uses Registrator, BaseObjects, Employee, Classes;

type
  TReasonChange = class (TRegisteredIDObject)
  private
    FDtmChange: TDateTime;
    FEmployee: TEmployee;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    // дата изменений
    property DtmChange: TDateTime read FDtmChange write FDtmChange;
    // сотрудник, внесший последние изменени€
    property Employee: TEmployee read FEmployee write FEmployee;

    constructor Create (ACollection: TIDObjects); override;
  end;

  TReasonChanges = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TReasonChange;
  public
    property    Items[Index: Integer]: TReasonChange read GetItems;
    Constructor Create; override;
  end;

implementation

uses ReasonChangePoster, Facade;

{ TReasonChange }

procedure TReasonChange.AssignTo(Dest: TPersistent);
var o: TReasonChange;
begin
  inherited;
  o := Dest as TReasonChange;

  o.DtmChange := DtmChange;
  o.Employee := Employee;
end;

constructor TReasonChange.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'ѕричина изменений';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TReasonChangeDataPoster];
end;

{ TReasonChanges }

constructor TReasonChanges.Create;
begin
  inherited;
  FObjectClass := TReasonChange;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TReasonChangeDataPoster];
end;

function TReasonChanges.GetItems(Index: Integer): TReasonChange;
begin
  Result := inherited Items[Index] as TReasonChange;
end;

end.
 