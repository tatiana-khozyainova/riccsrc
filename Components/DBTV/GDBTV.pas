unit GDBTV;
   {#Author fmarakasov@ugtu.net}
interface

uses
  SysUtils, Classes, Controls, ComCtrls, DBTV;

type
  TDBBasicTreeView = class(TDBTreeView)
  private

    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

  procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('DBTV', [TDBBasicTreeView]);
end;

end.
