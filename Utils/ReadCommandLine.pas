unit ReadCommandLine;

interface

uses   DB, Forms, SysUtils;

type
  // -u username
  // -p password


  TCommandLineParams = class(TParams)
  private
    procedure ReadParameters;
  public
    procedure ShowParameters;
    class function GetInstance: TCommandLineParams;
  end;


implementation

{ TCommanLineParams }

class function TCommandLineParams.GetInstance: TCommandLineParams;
const prms: TCommandLineParams = nil;
begin
  if not Assigned(prms) then
  begin
    prms := TCommandLineParams.Create;
    prms.ReadParameters;
  end;
  
  Result := prms;
end;

procedure TCommandLineParams.ReadParameters;
var i : Integer;
    p: TParam;
begin
  i := 1;
  while i <= ParamCount do
  begin
    p := CreateParam(ftString, ParamStr(i), ptInputOutput);
    p.Value := ParamStr(i + 1);
    AddParam(p);
    i := i + 2;
  end;
end;

procedure TCommandLineParams.ShowParameters;
var i: integer;
begin
  for i := 0 to Count - 1 do
    Application.MessageBox(PChar(Format('%s = %s', [Items[i].Name, Items[i].AsString])), PChar('Info'), 0)
end;

end.
