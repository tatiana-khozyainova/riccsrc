unit Parameter;

interface

uses Registrator, BaseObjects, Classes, ClientCommon, SysUtils, MeasureUnits, ComCtrls;

type
  TParameterValuesByWell = class;

  TParameter = class(TRegisteredIDObject)
  private
    FRefCount: integer;
    FMeasureUnit: TMeasureUnit;
    procedure SetMeasureUnit(const Value: TMeasureUnit);
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    property    RefCount: integer read FRefCount write FRefCount;
    property    MeasureUnit: TMeasureUnit read FMeasureUnit write SetMeasureUnit;

    function    List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TParameters = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TParameter;
  public
    property Items[Index: integer]: TParameter read GetItems;
    constructor Create; override;
  end;

  TParameterValue = class(TRegisteredIDObject)
  private
    FValue: variant;
    FParameter: TParameter;
    FNumValue: single;
    FNumber: integer;
    procedure   SetParameter(const Value: TParameter);
    procedure   SetValue(const Value: variant);
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    property    Number: integer read FNumber write FNumber;
    property    Parameter: TParameter read FParameter write SetParameter;
    property    Value: variant read FValue write SetValue;
    property    NumValue: single read FNumValue write FNumValue;
    function    List(AListOption: TListOption = loBrief): string; override;

    function    AsString: string;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TParameterValues = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TParameterValue;
  public
    procedure Delete(Index: integer); override;
    function  Remove(AObject: TObject): Integer; override;
    function  Add: TIDObject; override;

    function ParameterValueByParameter(AParameter: TParameter): TParameterValue;
    property Items[Index: integer]: TParameterValue read GetItems;
    constructor Create; override;
  end;

  // параметры по скважине
  TParameterByWell = class(TRegisteredIDObject)
  private
    FValues:    TParameterValuesByWell;
    FMeasureUnit: TMeasureUnit;

    function    GetValues: TParameterValuesByWell;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    property    MeasureUnit: TMeasureUnit read FMeasureUnit write FMeasureUnit;
    property    Values: TParameterValuesByWell read GetValues write FValues;

    function    List(AListOption: TListOption = loBrief): string; override;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TParametersByWell = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TParameterByWell;
  public
    property Items[Index: integer]: TParameterByWell read GetItems;

    constructor Create; override;
  end;

  // группы параметров по скважине
  TParametersGroupByWell = class(TRegisteredIDObject)
  private
    FParameters: TParametersByWell;

    function GetParameters: TParametersByWell;
  public
    property    Parameters: TParametersByWell read GetParameters;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TParametersGroupsByWell = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TParametersGroupByWell;
  public
    property Items[Index: integer]: TParametersGroupByWell read GetItems;

    procedure   MakeList(ATreeView: TTreeView; NeedsRegistering: boolean = true; NeedsClearing: boolean = false; CreateFakeNode: Boolean = true); override;

    constructor Create; override;
  end;

  TParameterValueByWell = class(TRegisteredIDObject)
  private
    FINTValue: integer;
    FVCHValue: String;
    FDTMValue: TDateTime;
    FParametrWell: TParameterByWell;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    // числовое значение
    property INTValue: integer read FINTValue write FINTValue;
    // строковое значение
    property VCHValue: String read FVCHValue write FVCHValue;
    // дата
    property DTMValue: TDateTime read FDTMValue write FDTMValue;
    // тип параметра
    property ParametrWell: TParameterByWell read FParametrWell write FParametrWell;

    //WELL_UIN,
    //REASON_CHANGE_ID,
    //DICT_VALUE_ID,
    //TABLE_ID

    function    List(AListOption: TListOption = loBrief): string; override;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TParameterValuesByWell = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TParameterValueByWell;
  public
    property Items[Index: integer]: TParameterValueByWell read GetItems;

    constructor Create; override;
  end;

implementation

uses Facade, ParameterPoster, Variants, Contnrs;

{ TParameter }

procedure TParameter.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TParameter).FMeasureUnit := FMeasureUnit;
end;

constructor TParameter.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Параметр';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TParameterDataPoster];
end;

function TParameter.List(AListOption: TListOption = loBrief): string;
begin
  Result := Name;
  if Assigned(MeasureUnit) then
    Result := Result  + '(' + MeasureUnit.Name + ')';
end;

procedure TParameter.SetMeasureUnit(const Value: TMeasureUnit);
begin
  if FMeasureUnit <> Value then
  begin
    FMeasureUnit := Value;
    if Assigned(Registrator) then Registrator.Update(Self, Self.Collection.Owner, ukUpdate);
  end;
end;

{ TParameters }

constructor TParameters.Create;
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TParameterDataPoster];
  FObjectClass := TParameter;
end;

function TParameters.GetItems(Index: integer): TParameter;
begin
  Result := inherited Items[Index] as TParameter;
end;

{ TParameterValue }

procedure TParameterValue.AssignTo(Dest: TPersistent);
var pv: TParameterValue;
begin
  inherited;

  pv := Dest as TParameterValue;
  pv.Value := Value;
  pv.Parameter := Parameter;
  pv.NumValue := NumValue;
  pv.Number := Number;
end;

function TParameterValue.AsString: string;
begin
  Result := varAsType(Value, varOleStr);
end;

constructor TParameterValue.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Значение параметра';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TParameterValueDataPoster];
end;

{ TParamterValues }

function TParameterValues.Add: TIDObject;
begin
  Result := inherited Add as TIDObject;

end;

constructor TParameterValues.Create;
begin
  inherited;
  FObjectClass := TParameterValue;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TParameterValueDataPoster];
end;

procedure TParameterValues.Delete(Index: integer);
begin
  if Assigned(Items[Index].Parameter) then Items[Index].Parameter.RefCount := Items[Index].Parameter.RefCount - 1;
  inherited;
end;

function TParameterValues.GetItems(Index: integer): TParameterValue;
begin
  Result := inherited Items[Index] as TParameterValue;
end;

function TParameterValues.ParameterValueByParameter(
  AParameter: TParameter): TParameterValue;
var i: integer;
begin
  Result := nil;

  for i := 0 to Count - 1 do
  if Items[i].Parameter = AParameter then
  begin
    Result := Items[i];
    break;
  end;
end;

function TParameterValue.List(AListOption: TListOption = loBrief): string;
begin
  if Assigned(Parameter) then
    Result := Parameter.List + '[' + IntToStr(Number) + ']' + ' = ' + AsString
  else
    Result := '';
end;

procedure TParameterValue.SetParameter(const Value: TParameter);
var i, iNum: integer; 
begin
  if FParameter <> Value then
  begin
    FParameter := Value;
    FParameter.RefCount := FParameter.RefCount + 1;

    if Assigned(Collection) then
    begin
      iNum := 0;
      for i := 0 to Collection.Count - 1 do
      if (Collection.Items[i] as TParameterValue).Parameter = FParameter then 
        inc(iNum);

      Number := iNum + 1;
    end;
  end;
end;

function TParameterValues.Remove(AObject: TObject): Integer;
begin
  if Assigned((AObject as TParameterValue).Parameter) then (AObject as TParameterValue).Parameter.RefCount := (AObject as TParameterValue).Parameter.RefCount - 1;
  Result := inherited Remove(AObject);
end;

procedure TParameterValue.SetValue(const Value: variant);
begin
  if FValue <> Value then
  begin
    FValue := Value;
    FNumValue := ExtractFloat(FValue);
  end;
end;

{ TParameterValuesByWell }

constructor TParameterValuesByWell.Create;
begin
  inherited;
  FObjectClass := TParameterValueByWell;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TParameterValueByWellDataPoster];
end;

function TParameterValuesByWell.GetItems(
  Index: integer): TParameterValueByWell;
begin
  Result := inherited Items[Index] as TParameterValueByWell;
end;

{ TParameterValueByWell }

procedure TParameterValueByWell.AssignTo(Dest: TPersistent);
var p: TParameterValueByWell;
begin
  inherited;

  p := Dest as TParameterValueByWell;
  p.INTValue := INTValue;
  p.VCHValue := VCHValue;
  p.DTMValue := DTMValue;
  p.ParametrWell := ParametrWell;
end;

constructor TParameterValueByWell.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Значение параметра по скважине';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TParameterValueByWellDataPoster];
end;

function TParameterValueByWell.List(AListOption: TListOption): string;
begin
  Result := Name;
end;

{ TParametersByWell }

constructor TParametersByWell.Create;
begin
  inherited;
  FObjectClass := TParameterByWell;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TParameterByWellDataPoster];
end;

function TParametersByWell.GetItems(Index: integer): TParameterByWell;
begin
  Result := inherited Items[Index] as TParameterByWell;
end;

{ TParameterByWell }

procedure TParameterByWell.AssignTo(Dest: TPersistent);
var o : TParameterByWell;
begin
  inherited;
  o := Dest as TParameterByWell;

  o.FMeasureUnit := MeasureUnit;
end;

constructor TParameterByWell.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Параметр скважины';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TParameterByWellDataPoster];
end;

function TParameterByWell.GetValues: TParameterValuesByWell;
begin
  if not Assigned (FValues) then
  begin
    FValues := TParameterValuesByWell.Create;
    FValues.Owner := Self;
    FValues.Reload('PARAMETR_ID = ' + IntToStr(ID));
  end;

  Result := FValues;
end;

function TParameterByWell.List(AListOption: TListOption): string;
begin
  Result := Name;
end;

{ TParametersGroupByWell }

constructor TParametersGroupByWell.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Группа параметров';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TParametersGroupByWellDataPoster];
end;

function TParametersGroupByWell.GetParameters: TParametersByWell;
begin
  if not Assigned (FParameters) then
  begin
    FParameters := TParametersByWell.Create;
    FParameters.Owner := Self;
    FParameters.OwnsObjects := true;
    FParameters.Reload('PARAMETR_GROUPS_ID = ' + IntToStr(ID));
  end;

  Result := FParameters;
end;

{ TParametersGroupsByWell }

constructor TParametersGroupsByWell.Create;
begin
  inherited;
  FObjectClass := TParametersGroupByWell;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TParametersGroupByWellDataPoster];
end;

function TParametersGroupsByWell.GetItems(
  Index: integer): TParametersGroupByWell;
begin
  Result := inherited Items[Index] as TParametersGroupByWell;
end;

procedure TParametersGroupsByWell.MakeList(ATreeView: TTreeView;
  NeedsRegistering, NeedsClearing, CreateFakeNode: boolean);
var i, j : integer;
    Node: TTreeNode;
begin
  if NeedsClearing then ATreeView.Items.Clear;

  for i := 0 to Count - 1 do
  begin
    Node := ATreeView.Items.AddObject(nil, Items[i].List, Items[i]);
    
    for j := 0 to Items[i].Parameters.Count - 1 do
      ATreeView.Items.AddChildObject(Node, Items[i].Parameters.Items[j].List, Items[i].Parameters.Items[j]);

    // if Assigned(FOnObjectViewAdd) then FOnObjectViewAdd(Node, Items[i]);
  end;

  if Assigned(Registrator) and NeedsRegistering then Registrator.Add(TTreeViewRegisteredObject, ATreeView, Self);
end;

end.
