unit AllUnits;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, AllObjectsFrame, Registrator;

type
  TfrmAllUnits = class(TForm)
    frmAllObjects: TfrmAllObjects;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmAllUnits: TfrmAllUnits;

implementation

uses Facade;

{$R *.dfm}

{ TfrmAllUnits }

constructor TfrmAllUnits.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TfrmAllUnits.Destroy;
begin

  inherited;
end;

end.
