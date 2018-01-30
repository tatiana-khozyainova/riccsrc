unit GRRImportingDataInterpreter;

interface

uses BaseObjects, SysUtils;

type

  TDataInterpreter = class
  public
    function ReadInteger(const AIn: string; out AOut: integer): Boolean;
    function ReadFloat(const AIn: string; out AOut: Single): Boolean;
    function ReadDate(const AIn: string; out AOut: TDateTime): Boolean;
    function ReadObject(const AIn: string; AObjectList: TIDObjects; out AOut: TIDObject): Boolean;
  end;

implementation

{ TDataInterpreter }

function TDataInterpreter.ReadDate(const AIn: string;
  out AOut: TDateTime): Boolean;
var sDate: string;
begin
  sDate := StringReplace(Trim(AIn), ',','.',[rfReplaceAll]);
  Result := TryStrToDate(sDate, AOut);
end;

function TDataInterpreter.ReadFloat(const AIn: string;
  out AOut: Single): Boolean;
begin
  Result := TryStrToFloat(Trim(AIn), AOut);
end;

function TDataInterpreter.ReadInteger(const AIn: string;
  out AOut: integer): Boolean;
begin
  Result := TryStrToInt(Trim(AIn), AOut);
end;

function TDataInterpreter.ReadObject(const AIn: string;
  AObjectList: TIDObjects; out AOut: TIDObject): Boolean;
begin
  AOut := AObjectList.GetItemByMetaphoneName(Trim(AIn));
  Result := Assigned(AOut);
end;

end.
