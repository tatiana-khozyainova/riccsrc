unit AddUnits;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AddObjectFrame, MeasureUnits;

type
  TfrmEditor = class(TForm)
    frmAddObject: TfrmAddObject;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmEditor: TfrmEditor;

implementation

{$R *.dfm}

{ TfrmEditorUnits }

constructor TfrmEditor.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TfrmEditor.Destroy;
begin

  inherited;
end;

end.


