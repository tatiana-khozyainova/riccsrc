unit RRManagerEditSideSubstructureInfoFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RRManagerBaseObjects, RRManagerObjects, RRManagerBaseGUI;

type
// TfrmSideSubstructureInfo = class(TFrame)
 TfrmSideSubstructureInfo = class(TBaseFrame)
    gbxAll: TGroupBox;
    Label9: TLabel;
    lblReason: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    cmbxQualityRange: TComboBox;
    chbxActiveFund: TCheckBox;
    mmReason: TMemo;
    edtProbability: TEdit;
    edtReliability: TEdit;
  private
    { Private declarations }
    function GetSubstructure: TOldSubstructure;
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure ClearControls; override;
    procedure RegisterInspector; override;    
  public
    { Public declarations }
    property Substructure: TOldSubstructure read GetSubstructure;
    procedure Save; override;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.DFM}

{ TfrmSideSubstructureInfo }

procedure TfrmSideSubstructureInfo.ClearControls;
begin
  edtProbability.Clear;
  edtReliability.Clear;
  cmbxQualityRange.Text := '';
  chbxActiveFund.Checked := false;
  mmReason.Clear;

end;

constructor TfrmSideSubstructureInfo.Create(AOwner: TComponent);
begin
  inherited;
  EditingClass := TOldSubstructure;
//  AllDicts.MakeList(cmbxQualityRange.Items, AllDicts.DictContentByName('SPD_GET_QUALITY_RANGES'));
  mmReason.Visible := false;
  lblReason.Visible := false;
end;

procedure TfrmSideSubstructureInfo.FillControls(ABaseObject: TBaseObject);
var S: TOldSubstructure;
begin
  if not Assigned(ABaseObject) then S := Substructure
  else S := ABaseObject as TOldSubstructure;

  edtProbability.Text := Trim(Format('%7.2f', [S.Probability]));
  edtReliability.Text := Trim(Format('%7.2f', [S.Reliability]));
  cmbxQualityRange.Text := S.QualityRange;
//  mmReason.Text := Horizon.
end;


function TfrmSideSubstructureInfo.GetSubstructure: TOldSubstructure;
begin
  Result := EditingObject as TOldSubstructure;
end;

procedure TfrmSideSubstructureInfo.RegisterInspector;
begin
  inherited;
  Inspector.Add(edtProbability, nil, ptFloat, 'вероятность существования', true);
  Inspector.Add(edtReliability, nil, ptFloat, 'надежность', true);
  Inspector.Add(cmbxQualityRange,  nil, ptString, 'оценка качества', true);
end;

procedure TfrmSideSubstructureInfo.Save;
begin
  inherited;
  if Assigned(Substructure) then
  begin
    try
      Substructure.Probability := StrToFloat(edtProbability.Text);
    except
      Substructure.Probability := 0;
    end;

    try
      Substructure.Reliability := StrToFloat(edtReliability.Text);
    except
      Substructure.Reliability := 0;
    end;

    Substructure.QualityRange := cmbxQualityRange.Text;
  end;
end;

end.
