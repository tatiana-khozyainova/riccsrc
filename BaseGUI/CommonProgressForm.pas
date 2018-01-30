unit CommonProgressForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls;

type
  TfrmProgress = class(TForm)
    prg: TProgressBar;
  private
    function GetMax: integer;
    function GetMin: integer;
    procedure SetMax(const Value: integer);
    procedure SetMin(const Value: integer);
    { Private declarations }
  public
    { Public declarations }
    property Min: integer read GetMin write SetMin;
    property Max: integer read GetMax write SetMax;
    procedure StepIt;
  end;

var
  frmProgress: TfrmProgress;

implementation

{$R *.dfm}

{ TfrmProgress }

function TfrmProgress.GetMax: integer;
begin
  Result := prg.Max;
end;

function TfrmProgress.GetMin: integer;
begin
  Result := prg.Max;
end;

procedure TfrmProgress.SetMax(const Value: integer);
begin
  prg.Max := Value;
end;

procedure TfrmProgress.SetMin(const Value: integer);
begin
  prg.Min := Value;
end;

procedure TfrmProgress.StepIt;
begin
  prg.StepIt;
end;

end.
