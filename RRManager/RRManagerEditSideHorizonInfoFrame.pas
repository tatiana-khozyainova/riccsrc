unit RRManagerEditSideHorizonInfoFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RRManagerBaseObjects, RRManagerObjects, ClientSpecificUtils;

type
//  TfrmSideSubstructureInfo = class(TFrame)
 TfrmSideSubstructureInfo = class(TBaseFrame)
    gbxAll: TGroupBox;
    Label9: TLabel;
    lblReason: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    cmbxQualityRange: TComboBox;
    chbxActiveFund: TCheckBox;
    mmReason: TMemo;
    edtProbabilty: TEdit;
    edtReliability: TEdit;
  private
    { Private declarations }
    function GetSubstrucuture: TSubstructure;
    function GetHorizon: THorizon;
    function GetSubstructure: TSubstructure;
  protected
    procedure FillControls; override;
    procedure ClearControls; override;
  public
    { Public declarations }
    property Substructure: TSubstructure read GetSubstructure;
    procedure Save; override;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.DFM}

{ TfrmSideHorizonInfo }

procedure TfrmSideSubstructureInfo.ClearControls;
begin
  edtProbabilty.Clear;
  edtReliability.Clear;
  cmbxQualityRange.Text := '';
  chbxActiveFund.Checked := false;
  mmReason.Clear;
end;

constructor TfrmSideSubstructureInfo.Create(AOwner: TComponent);
begin
  inherited;
  EditingClass := THorizon;
  AllDicts.MakeList(cmbxQualityRange.Items, AllDicts.DictContentByName('SPD_GET_QUALITY_RANGES'));
  mmReason.Visible := false;
  lblReason.Visible := false;
end;

procedure TfrmSideSubstructureInfo.FillControls;
begin
  edtProbabilty.Text := Trim(Format('%7.2f', [Substructure.Probability]));
  edtReliability.Text := Trim(Format('%7.2f', [Substructure.Reliability]));
  cmbxQualityRange.Text := Substructure.QualityRange;
//  mmReason.Text := Horizon.
end;

function TfrmSideSubstructureInfo.GetHorizon: THorizon;
begin
  Result := EditingObject as THorizon;
end;


function TfrmSideSubstructureInfo.GetSubstrucuture: TSubstructure;
begin
  Result := EditingObject as TSubstructure;
end;

procedure TfrmSideSubstructureInfo.Save;
begin
  Substructure.Probability := StrToFloat(edtProbabilty.Text);
  Substructure.Reliability := StrToFloat(edtReliability.Text);
  Substructure.QualityRange := cmbxQualityRange.Text;
end;

end.
