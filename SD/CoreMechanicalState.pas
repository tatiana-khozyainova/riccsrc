unit CoreMechanicalState;

interface

uses BaseObjects, Registrator, Classes;

type

  TCoreMechanicalState = class(TRegisteredIdObject)
  private
    FIsVisible: boolean;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    property  IsVisible: boolean read FIsVisible write FIsVisible;
    function List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TCoreMechanicalStates = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TCoreMechanicalState;
  public
    property Items[Index: integer]: TCoreMechanicalState read GetItems;
    constructor Create; override;
  end;

  TSlottingCoreMechanicalState = class(TRegisteredIDObject)
  private
    FMechanicalState: TCoreMechanicalState;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    property MechanicalState: TCoreMechanicalState read FMechanicalState write FMechanicalState;
    function   List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TSlottingCoreMechanicalStates = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TSlottingCoreMechanicalState;
  public
    property  Items[Index: integer]: TSlottingCoreMechanicalState read GetItems;
    function  AddCoreMechanicalState(ACoreMechanicalState: TCoreMechanicalState): TSlottingCoreMechanicalState;
    function  GetCoreMechanicalState(ACoreMechanicalState: TCoreMechanicalState): TSlottingCoreMechanicalState;
    procedure RemoveCoreMechanicalState(ACoreMechanicalState: TCoreMechanicalState);

    function    List(AListOption: TListOption = loBrief): string; override;

    constructor Create; override;
  end;


implementation

uses Facade, CoreMechanicalStatePoster, Contnrs, SysUtils;

{ TCoreMechanicalState }

procedure TCoreMechanicalState.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TCoreMechanicalState).IsVisible := IsVisible;
end;

constructor TCoreMechanicalState.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Механическое состояние керна';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TCoreMechanicalStateDataPoster];
end;

function TCoreMechanicalState.List(AListOption: TListOption): string;
begin
  if AListOption = loBrief then
    Result := ShortName
  else
    Result := Name;
end;

{ TCoreMechanicalStates }

constructor TCoreMechanicalStates.Create;
begin
  inherited;
  FObjectClass := TCoreMechanicalState;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TCoreMechanicalStateDataPoster];
end;

function TCoreMechanicalStates.GetItems(
  Index: integer): TCoreMechanicalState;
begin
  Result := inherited Items[Index] as TCoreMechanicalState;
end;

{ TSlottingCoreMechanicalStates }

function TSlottingCoreMechanicalStates.AddCoreMechanicalState(
  ACoreMechanicalState: TCoreMechanicalState): TSlottingCoreMechanicalState;
begin
  Result := GetCoreMechanicalState(ACoreMechanicalState);
  if not Assigned(Result) then
    Result := inherited Add as TSlottingCoreMechanicalState;

  Result.MechanicalState := ACoreMechanicalState;
  Result.ID := ACoreMechanicalState.ID;
end;

constructor TSlottingCoreMechanicalStates.Create;
begin
  inherited;
  FObjectClass := TSlottingCoreMechanicalState;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSlottingCoreMechanicalStateDataPoster];
  OwnsObjects := true;
end;



function TSlottingCoreMechanicalStates.GetCoreMechanicalState(
  ACoreMechanicalState: TCoreMechanicalState): TSlottingCoreMechanicalState;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].MechanicalState = ACoreMechanicalState then
  begin
    Result := Items[i];
    break;
  end;
end;

function TSlottingCoreMechanicalStates.GetItems(
  Index: integer): TSlottingCoreMechanicalState;
begin
  Result := inherited Items[Index] as TSlottingCoreMechanicalState;
end;

function TSlottingCoreMechanicalStates.List(
  AListOption: TListOption): string;
var i: integer;
begin
  Result := '';

  if Count > 1 then
  begin
    for i := 0 to Count - 1 do
      Result := Result + '; ' + Items[i].MechanicalState.List(AListOption);

    Result := trim(copy(Result, 2, Length(Result)));
  end
  else
  begin
    if Count = 1 then
    begin
      if Items[0].MechanicalState.IsVisible then
        Result := Items[0].List();
    end;
  end;
end;

procedure TSlottingCoreMechanicalStates.RemoveCoreMechanicalState(
  ACoreMechanicalState: TCoreMechanicalState);
var s: TSlottingCoreMechanicalState;
begin
  s := GetCoreMechanicalState(ACoreMechanicalState);
  if Assigned(s) then
    MarkDeleted(s);
end;

{ TSlottingCoreMechanicalState }

procedure TSlottingCoreMechanicalState.AssignTo(Dest: TPersistent);
var o: TSlottingCoreMechanicalState;
begin
  inherited;
  o := Dest as TSlottingCoreMechanicalState;
  o.MechanicalState := MechanicalState;
end;

constructor TSlottingCoreMechanicalState.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Механическое состояние керна для долбления';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSlottingCoreMechanicalStateDataPoster];
end;

function TSlottingCoreMechanicalState.List(
  AListOption: TListOption): string;
begin
  Result := MechanicalState.List(AListOption)
end;

end.
