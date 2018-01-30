unit TestIntervalActions;

interface

uses BaseActions, BaseObjects, TestInterval;

type

  TTestIntervalBaseLoadAction = class(TBaseAction)

  end;

  TTestIntervalBaseEditAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TIDObject): boolean; override;
  end;

  TTestIntervalBaseAddAction = class(TBaseAction)

  end;

  TTestIntervalDeleteAction = class(TBaseAction)

  end;

implementation

{ TTestIntervalBaseEditAction }

function TTestIntervalBaseEditAction.Execute(
  ABaseObject: TIDObject): boolean;
var t: TTestInterval;
begin
  t := ABaseObject as TTestInterval;

  

end;

end.
