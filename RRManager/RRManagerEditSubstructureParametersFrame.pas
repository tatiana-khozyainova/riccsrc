unit RRManagerEditSubstructureParametersFrame;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, RRManagerBaseObjects, RRManagerObjects,
  CommonComplexCombo, ClientSpecificUtils, ExtCtrls;

type
  //TfrmSubstructureParameters = class(TFrame)
  TfrmSubstructureParameters = class(TBaseFrame)
    gbxAll: TGroupBox;
    pgctlStructureParams: TPageControl;
    tshAllParams: TTabSheet;
    tshEnteredParams: TTabSheet;
    trwSelectedParams: TTreeView;
    trwAllParams: TTreeView;
    pnlParams: TPanel;
    cmplxFluidType: TfrmComplexCombo;
    Label1: TLabel;
    edtValue: TEdit;
    cmplxMeasureUnit: TfrmComplexCombo;
  private
    { Private declarations }
  protected
    procedure FillControls; override;
    procedure ClearControls; override;
  public
    { Public declarations }
    procedure Save; override;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.DFM}

{ TfrmSubstructureParameters }

procedure TfrmSubstructureParameters.ClearControls;
begin
  inherited;

end;

constructor TfrmSubstructureParameters.Create(AOwner: TComponent);
var i, iID: integer;
    Node: TTreeNode;
begin
  inherited;

  cmplxFluidType.Caption  := 'Тип флюида';
  cmplxFluidType.FullLoad := true;
  cmplxFluidType.Dict := AllDicts.FluidTypeDict;

  cmplxmeasureUnit.Caption := 'Единица измерения';
  cmplxMeasureUnit.FullLoad := true;
  cmplxMeasureUnit.Dict := AllDicts.MeasureUnitDict;

  // загрузка параметров
  for i := 0 to varArrayHighBound(AllDicts.ParamTypeDict, 2) do
  begin
    iID := AllDicts.ParamTypeDict[0, i];
    Node := trwAllParams.Items.AddObject(nil, AllDicts.ParamTypeDict[1, i], Pointer(iID));
    trwAllParams.Items.AddChildObject(Node, 'будут параметры', nil);
  end;

  trwSelectedParams.Items.Assign(trwAllParams.Items);
end;

procedure TfrmSubstructureParameters.FillControls;
begin
  inherited;

end;

procedure TfrmSubstructureParameters.Save;
begin
  inherited;

end;

end.
