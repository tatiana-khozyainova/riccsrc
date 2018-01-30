unit RRManagerHorizonAdditionalInfoForm;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RRManagerBaseObjects, RRManagerObjects,  ClientSpecificUtils, StdCtrls,
  CommonComplexCombo;

type
//  TfrmHorizonAdditionalInfoForm = class(TFrame)
  TfrmHorizonAdditionalInfoForm = class(TBaseFrame)
    gbxAll: TGroupBox;
    Label1: TLabel;
    edtClosingIsogypse: TEdit;
    cmplxTrapType: TfrmComplexCombo;
  private
    function GetHorizon: THorizon;
    { Private declarations }
  protected
    procedure FillControls; override;
    procedure ClearControls; override;
  public
    { Public declarations }
    property Horizon: THorizon read GetHorizon;
    procedure Save; override;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.DFM}

{ TfrmHorizonAdditionalInfoForm }

procedure TfrmHorizonAdditionalInfoForm.ClearControls;
begin

end;

constructor TfrmHorizonAdditionalInfoForm.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TfrmHorizonAdditionalInfoForm.FillControls;
begin

end;

function TfrmHorizonAdditionalInfoForm.GetHorizon: THorizon;
begin
  Result := EditingObject as  THorizon;
end;

procedure TfrmHorizonAdditionalInfoForm.Save;
begin

end;

end.
