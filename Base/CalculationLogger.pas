unit CalculationLogger;

interface

uses Registrator, Classes, SysUtils, BaseObjects;

type
  TItemState = (isNormal, isError);

  TCalculationLoggerItem = class(TRegisteredIDObject)
  private
    FTitle: string;
    FMsg: string;
    FTimeStamp: TDateTime;
    FState: TItemState;
  public
    property Title: string read FTitle write FTitle;
    property Msg: string read FMsg write FMsg;
    property TimeStamp: TDateTime read FTimeStamp write FTimeStamp;
    property State: TItemState read FState write FState;

    function    List(AListOption: TListOption = loBrief): string; override;
  end;

  TCalculationLogger = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TCalculationLoggerItem;
  public
    property Items[Index: integer]: TCalculationLoggerItem read GetItems;
    function AddItem(ATitle, AMsg: string; AState: TItemState): TCalculationLoggerItem;
    procedure SaveToFile(AFileName: string);
    constructor Create; override;
  end;

implementation



{ TCalculationLoggerItems }

function TCalculationLogger.AddItem(ATitle,
  AMsg: string; AState: TItemState): TCalculationLoggerItem;
begin
  Result := TCalculationLoggerItem.Create(Self);

  Result.Title := ATitle;
  Result.Msg := AMsg;
  Result.TimeStamp := Now;

  Add(Result, false, false);
  Result.Registrator.Update(Result, nil, ukAdd);
end;

constructor TCalculationLogger.Create;
begin
  inherited Create;
  FObjectClass := TCalculationLoggerItem;
end;

function TCalculationLogger.GetItems(
  Index: integer): TCalculationLoggerItem;
begin
  Result := inherited Items[Index] as TCalculationLoggerItem;
end;

procedure TCalculationLogger.SaveToFile(AFileName: string);
var lst: TStringList;
    i: integer;
begin
  lst := TStringList.Create;

  for i := 0 to Count - 1 do
    lst.Add(Items[i].List);

  lst.SaveToFile(AFileName);

  lst.Free;
end;

{ TCalculationLoggerItem }

function TCalculationLoggerItem.List(AListOption: TListOption = loBrief): string;
begin
  Result := '[' + TimeToStr(TimeStamp) + '] ' + Title;
  if trim(Msg) <> '' then
    Result := Result + ':' + Msg;
end;

end.
