unit BaseComponent;

interface

uses BaseObjects, Contnrs, ExceptionExt;


type
  TSetting = class
  private
    FValue: OleVariant;
    FName: string;
  public
    property Name: string read FName write FName;
    property Value: OleVariant read FValue write FValue;
  end;


  TSettingsObject = class(TObjectList)
  private
    function GetItemByName(AName: string): TSetting;
    function GetItems(Index: Integer): TSetting;
  public
    property Items[Index: Integer]: TSetting read GetItems;
    property ItemByName[AName: string]: TSetting read GetItemByName;
    constructor Create;
  end;

  IBaseComponent = interface
    function  GetInputObjects: TIDObjects;
    function  GetOutputObjects: TIDObjects;
    function  GetOutputRecordSet: OleVariant;
    function  GetSQLInput: string;
    procedure SetInputObjects(const Value: TIDObjects);
    procedure SetSQLInput(const Value: string);
    function  GetSettings: TSettingsObject;

    // входная часть
    // передаем SQL-запрос
    property InputSQL: string read GetSQLInput write SetSQLInput;
    // передаем один или несколько входных объектов
    property InputObjects: TIDObjects read GetInputObjects write SetInputObjects;
    // передаем объект настройки
    property Settings: TSettingsObject read GetSettings;

    // получаем набор объектов по результатам обработки компонентом
    property OutputObjects: TIDObjects read GetOutputObjects;
    // получаем выходной набор данных (в случае необходимости)
    property OutputRecordset: OleVariant read GetOutputRecordSet;
  end;




  TBaseComponentImplementor = class(TInterfacedObject, IBaseComponent)
  protected
    FInputObjects: TIDObjects;
    FSQL: string;

    function  GetInputObjects: TIDObjects; virtual;
    function  GetOutputObjects: TIDObjects; virtual; 
    function  GetOutputRecordSet: OleVariant; virtual;
    function  GetSettings: TSettingsObject; virtual;
    function  GetSQLInput: string; virtual;

    procedure SetInputObjects(const Value: TIDObjects); virtual;
    procedure SetSQLInput(const Value: string); virtual;

    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;


implementation

uses SysUtils;

{ IBaseComponent }


{ TSettingsObject }

constructor TSettingsObject.Create;
begin
  inherited Create(True);
end;

function TSettingsObject.GetItemByName(AName: string): TSetting;
var i: Integer;
begin
  Result := nil;

  for i := 0 to Count - 1 do
  if AnsiUpperCase(Items[i].Name) = AnsiUpperCase(AName) then
  begin
    Result := Items[i];
    break;
  end;
end;

function TSettingsObject.GetItems(Index: Integer): TSetting;
begin
  Result := inherited Items[Index] as TSetting;
end;

{ TBaseComponentImplementor }

function TBaseComponentImplementor.GetInputObjects: TIDObjects;
begin
  Result := FInputObjects;
end;


function TBaseComponentImplementor.GetOutputObjects: TIDObjects;
begin
  raise ENotImplemented.Create;
end;

function TBaseComponentImplementor.GetOutputRecordSet: OleVariant;
begin
  raise ENotImplemented.Create;
end;

function TBaseComponentImplementor.GetSettings: TSettingsObject;
begin
  raise ENotImplemented.Create;
end;

function TBaseComponentImplementor.GetSQLInput: string;
begin
  Result := FSQL;
end;

procedure TBaseComponentImplementor.SetInputObjects(
  const Value: TIDObjects);
begin
  if FInputObjects <> Value then
    FInputObjects := Value;
end;

procedure TBaseComponentImplementor.SetSQLInput(const Value: string);
begin
  if FSQL <> Value then
    FSQL := Value;
end;

function TBaseComponentImplementor._AddRef: Integer;
begin
  Result := 1;
end;

function TBaseComponentImplementor._Release: Integer;
begin
  Result := 1;
end;

end.
