unit SubDividerProgressForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TfrmProgress = class(TForm)
    prg: TProgressBar;
    lblStatus: TLabel;
  private
    FObjectName: string;
    { Private declarations }
  public
    { Public declarations }
    property  ObjectName: string read FObjectName write FObjectName;
    procedure SetParams(AMin, AMax, AStep: integer; const AName: string);
    procedure StepIt;
  end;

var
  frmProgress: TfrmProgress;

implementation

{$R *.dfm}

const sLoadingMessage = 'Загружено %d из %d %s';

procedure TfrmProgress.SetParams(AMin, AMax, AStep: integer; const AName: string);
begin
  prg.Max := AMax;
  prg.Min := AMin;
  prg.Position := 0;
  prg.Step := AStep;
  lblStatus.Caption := '';
  FObjectName := AName;
  (prg.Owner as TWinControl).Update;
end;

procedure TfrmProgress.StepIt;
begin
  prg.StepIt;
  lblStatus.Caption := Format(sLoadingMessage, [prg.Position, prg.Max, FObjectName]);
  lblStatus.Update;
  prg.Update;
end;

end.
