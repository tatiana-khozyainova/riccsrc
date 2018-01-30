unit RRManageCoordEditFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RRManagerObjects;

type
  TfrmCoordsEdit = class(TFrame)
  private
    function GetCoordObjects: TOldCoordObjects;
    procedure SetCoordObjects(const Value: TOldCoordObjects);
    { Private declarations }
  public
    { Public declarations }
    procedure Clear;
    property Coords: TOldCoordObjects read GetCoordObjects write SetCoordObjects; 
  end;

implementation

{$R *.dfm}

{ TfrmCoordsEdit }

procedure TfrmCoordsEdit.Clear;
begin

end;

function TfrmCoordsEdit.GetCoordObjects: TOldCoordObjects;
begin

end;

procedure TfrmCoordsEdit.SetCoordObjects(const Value: TOldCoordObjects);
begin

end;

end.
