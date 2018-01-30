unit CalculationLoggerFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Registrator, BaseObjects,
  CalculationLogger;

type
  TOnAddProgressStep = procedure (Sender: TObject; StepCount: integer; ItemState: TItemState) of object;

  TfrmCalculationLogger = class(TFrame)
    gbxLog: TGroupBox;
    lwLog: TListView;
  private
    { Private declarations }
    FOnAddItem: TOnAddProgressStep;
  public
    { Public declarations }
    property    OnAddItem: TOnAddProgressStep read FOnAddItem write FOnAddItem;
    procedure   Clear;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation


{$R *.dfm}

{ TfrmCalculationLogger }

constructor TfrmCalculationLogger.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TfrmCalculationLogger.Destroy;
begin
  inherited;
end;

procedure TfrmCalculationLogger.Clear;
begin
  lwLog.Clear;
end;

{ TCalculationLoggerRegisteredGUI }

end.
