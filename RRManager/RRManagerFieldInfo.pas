unit RRManagerFieldInfo;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RRManagerBaseObjects, FramesWizard;

type
  TfrmFieldInfo = class(TBaseFrame)
    DialogFrame1: TDialogFrame;
  private
    { Private declarations }
  protected
    procedure ClearControls; override;
    procedure FillControls; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure Save; override;
  end;

implementation

{$R *.DFM}

{ TfrmFieldInfo }

procedure TfrmFieldInfo.ClearControls;
begin
  inherited;

end;

constructor TfrmFieldInfo.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TfrmFieldInfo.FillControls;
begin
  inherited;

end;

procedure TfrmFieldInfo.Save;
begin
  inherited;

end;

end.
