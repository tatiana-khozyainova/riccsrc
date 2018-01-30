unit Altitude;

interface

uses BaseObjects, Classes, Registrator, Ex_Grid;

type
  // cправочник систем альтитуд
  TMeasureSystemType = class (TRegisteredIDObject)
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TMeasureSystemTypes = class(TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TMeasureSystemType;
  public
    property  Items[Index: Integer]: TMeasureSystemType read GetItems;
    procedure Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;

    constructor Create; override;
  end;

  // Справочник типов альтитуд
  TAltitudeType = class (TRegisteredIDObject)
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TAltitudeTypes = class(TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TAltitudeType;
  public
    property  Items[Index: Integer]: TAltitudeType read GetItems;
    procedure Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;

    constructor Create; override;
  end;

  // альтитуда
  TAltitude = class (TRegisteredIDObject)
  private
    FValue: double;
    FOrder: integer;
    FAltitudeType: TAltitudeType;
    FMeasureSystemType: TMeasureSystemType;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    function    List(AListOption: TListOption = loBrief): string; override;
    // тип альтитуды
    property AltitudeType: TAltitudeType read FAltitudeType write FAltitudeType;
    // система альтитуды
    property MeasureSystemType: TMeasureSystemType read FMeasureSystemType write FMeasureSystemType;
    // значение альтитуды
    property Value: double read FValue write FValue;
    // порядок
    property Order: integer read FOrder write FOrder;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TAltitudes = class(TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TAltitude;
  public
    property  Items[Index: Integer]: TAltitude read GetItems;
    function    List(AListOption: TListOption = loBrief): string; override;
    procedure Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;

    function    AddAltitude(AAltitudeType: TAltitudeType; AMeasureSystemType: TMeasureSystemType): TAltitude;
    function    GetAltitude(AAltitudeType: TAltitudeType; AMeasureSystemType: TMeasureSystemType; const AddIfNotExists: Boolean = false): TAltitude;
    procedure   MakeList(AGrdView: TGridView; NeedsRegistering: boolean = true; NeedsClearing: boolean = false); override;

    constructor Create; override;
  end;

implementation

uses Facade, BaseFacades, AltitudePoster, SysUtils;

{ TAlititudes }

function TAltitudes.AddAltitude(AAltitudeType: TAltitudeType;
  AMeasureSystemType: TMeasureSystemType): TAltitude;
begin
  Result := inherited Add as TAltitude;
  Result.AltitudeType := AAltitudeType;
  Result.MeasureSystemType := AMeasureSystemType;
end;

procedure TAltitudes.Assign(Sourse: TIDObjects; NeedClearing: boolean);
begin
  inherited;

end;

constructor TAltitudes.Create;
begin
  inherited;
  FObjectClass := TAltitude;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TAltitudeDataPoster];
end;

function TAltitudes.GetAltitude(AAltitudeType: TAltitudeType;
  AMeasureSystemType: TMeasureSystemType; const AddIfNotExists: Boolean = false): TAltitude;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if (Items[i].AltitudeType = AAltitudeType)
  and (ITems[i].MeasureSystemType = AMeasureSystemType) then
  begin
    Result := Items[i];
    Break;
  end;

  if (not Assigned(Result)) and AddIfNotExists then
    Result := AddAltitude(AAltitudeType, AMeasureSystemType);
end;

function TAltitudes.GetItems(Index: Integer): TAltitude;
begin
  Result := inherited Items[Index] as TAltitude;
end;

{ TAlititude }

procedure TAltitude.AssignTo(Dest: TPersistent);
var o: TAltitude;
begin
  inherited;
  o := Dest as TAltitude;

  o.AltitudeType := AltitudeType;
  o.MeasureSystemType := MeasureSystemType;
  o.Value := Value;
  o.Order := Order;
end;

constructor TAltitude.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Альтитуда';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TAltitudeDataPoster];
end;

{ TMeasureSystemType }

procedure TMeasureSystemType.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TMeasureSystemType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Система альтитуд';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TMeasureSystemTypeDataPoster];
end;

{ TMeasureSystemTypes }

procedure TMeasureSystemTypes.Assign(Sourse: TIDObjects;
  NeedClearing: boolean);
begin
  inherited;

end;

constructor TMeasureSystemTypes.Create;
begin
  inherited;
  FObjectClass := TMeasureSystemType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TMeasureSystemTypeDataPoster];
end;

function TMeasureSystemTypes.GetItems(Index: Integer): TMeasureSystemType;
begin
  Result := inherited Items[Index] as TMeasureSystemType;
end;

{ TAlititudeType }

procedure TAltitudeType.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TAltitudeType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип альтитуды';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TAltitudeTypeDataPoster];
end;

{ TAlititudeTypes }

procedure TAltitudeTypes.Assign(Sourse: TIDObjects;
  NeedClearing: boolean);
begin
  inherited;

end;

constructor TAltitudeTypes.Create;
begin
  inherited;
  FObjectClass := TAltitudeType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TAltitudeTypeDataPoster];
end;

function TAltitudeTypes.GetItems(Index: Integer): TAltitudeType;
begin
  Result := inherited Items[Index] as TAltitudeType;
end;

function TAltitudes.List(AListOption: TListOption): string;
var i: integer;
begin
  Result := '';
  for i := 0 to Count - 1 do
    Result := Result + Items[i].List(AListOption) + '; ';

  Result := copy(Result, 1, Length(Result) - 1);
end;

procedure TAltitudes.MakeList(AGrdView: TGridView; NeedsRegistering,
  NeedsClearing: boolean);
var i: integer;
    edt1, edt2, edt3: TGridEdit;
begin
  inherited;
  AGrdView.Rows.Count := Count;

  for i := 0 to Count - 1 do
  begin
    //AGrdView.Cells[0, i] := Items[i].AltitudeType.Name;
    //AGrdView.Cells[1, i] := Items[i].MeasureSystemType.Name;
    //AGrdView.Cells[2, i] := FloatToStr(Items[i].Value);

    edt1 := TGridEdit.Create(AGrdView.Columns.Columns[0].Grid);
    edt1.Text := Items[i].AltitudeType.Name;

    edt2 := TGridEdit.Create(AGrdView.Columns.Columns[1].Grid);
    edt2.Text := Items[i].MeasureSystemType.Name;

    edt3 := TGridEdit.Create(AGrdView.Columns.Columns[2].Grid);
    edt3.Text := FloatToStr(Items[i].Value);
  end;
end;

function TAltitude.List(AListOption: TListOption): string;
begin
  Result := AltitudeType.List + ' = ' + FloatToStr(Value);
end;

end.
