unit RRManagerEditAdditionalHorizonInfoFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RRManagerBaseObjects, RRManagerObjects,  ClientSpecificUtils, StdCtrls,
  CommonComplexCombo;

type
//  TfrmAdditionalHorizonInfo = class(TFrame)
  TfrmAdditionalHorizonInfo = class(TBaseFrame)
    gbxAll: TGroupBox;
    Label1: TLabel;
    edtClosingIsogypse: TEdit;
    cmplxTrapType: TfrmComplexCombo;
    Label2: TLabel;
    EdtPerspectiveArea: TEdit;
    edtAmplitude: TEdit;
    Label4: TLabel;
    edtControlDensity: TEdit;
    Label5: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    edtMapError: TEdit;
    cmplxLayer: TfrmComplexCombo;
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

{ TfrmHorizonAdditionalInfo }

procedure TfrmAdditionalHorizonInfo.ClearControls;
begin
  edtClosingIsogypse.Clear;
  edtPerspectiveArea.Clear;
  edtControlDensity.Clear;
  edtAmplitude.Clear;
  edtMapError.Clear;

  cmplxTrapType.Clear;
end;

constructor TfrmAdditionalHorizonInfo.Create(AOwner: TComponent);
begin
  inherited;

  EditingClass := THorizon;

  cmplxTrapType.Caption := 'Тип ловушки';
  cmplxTrapType.FullLoad := true;
  cmplxTrapType.DictName := 'TBL_TRAP_TYPE_DICT';

  cmplxLayer.Caption := 'Продуктивный горизонт';
  cmplxLayer.FullLoad := false;
  cmplxLayer.DictName := 'TBL_LAYER';
end;

procedure TfrmAdditionalHorizonInfo.FillControls;
begin
  edtClosingIsogypse.Text := trim(Format('%7.2f', [Horizon.ClosingIsoGypse]));
  edtPerspectiveArea.Text := trim(Format('%7.2f', [Horizon.PerspectiveArea]));
  edtControlDensity.Text  := trim(Format('%7.2f', [Horizon.ControlDensity]));
  edtAmplitude.Text       := trim(Format('%7.2f', [Horizon.Amplitude]));
  edtMapError.Text        := trim(Format('%7.2f', [Horizon.MapError]));

  cmplxTrapType.AddItem(Horizon.TrapTypeID, Horizon.TrapType);
end;

function TfrmAdditionalHorizonInfo.GetHorizon: THorizon;
begin
  Result := EditingObject as THorizon;
end;

procedure TfrmAdditionalHorizonInfo.Save;
begin
  Horizon.ClosingIsogypse := StrToFloat(edtClosingIsogypse.Text);
  Horizon.PerspectiveArea := StrToFloat(EdtPerspectiveArea.Text);
  Horizon.ControlDensity  := StrToFloat(edtControlDensity.Text);
  Horizon.Amplitude       := StrToFloat(edtAmplitude.Text);
  Horizon.MapError        := StrToFloat(edtMapError.Text);

  Horizon.TrapTypeID      := cmplxTrapType.SelectedElementID;
  Horizon.TrapType        := cmplxTrapType.SelectedElementName;
end;

end.
