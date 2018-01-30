unit RRManagerEditAdditionalSubstructureInfoFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RRManagerObjects, RRManagerbaseObjects, CommonComplexCombo;

type
//  TfrmAdditionalSubstructureInfo = class(TFrame)
  TfrmAdditionalSubstructureInfo = class(TBaseFrame)
    gbxAll: TGroupBox;
    Label3: TLabel;
    edtBedHeight: TEdit;
    Label4: TLabel;
    edtArea: TEdit;
    cmplxNGK: TfrmComplexCombo;
    cmplxTrapType: TfrmComplexCombo;
    cmplxLayer: TfrmComplexCombo;
  private
    function GetSubstructure: TSubstructure;
    function GetHorizon: THorizon;
    { Private declarations }
  protected
    procedure FillControls; override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
  public
    { Public declarations }
    property    Horizon: THorizon read GetHorizon;    
    property    Substructure: TSubstructure read GetSubstructure;
    constructor Create(AOwner: TComponent); override;
    procedure   Save; override;
  end;

implementation

{$R *.DFM}

{ TfrmAdditionalSubstructureInfo }

procedure TfrmAdditionalSubstructureInfo.ClearControls;
begin
  cmplxNGK.Clear;
  edtBedHeight.Clear;
  edtArea.Clear;
  cmplxTrapType.Clear;
  cmplxLayer.Clear;
end;

constructor TfrmAdditionalSubstructureInfo.Create(AOwner: TComponent);
begin
  inherited;

  cmplxNGK.Caption := 'Нефтегазоносный подкомплекс';
  cmplxNGK.FullLoad := true;
  cmplxNGK.DictName := 'TBL_OIL_COMPLEX_DICT';

  cmplxTrapType.Caption := 'Тип ловушки';
  cmplxTrapType.FullLoad := true;
  cmplxTrapType.DictName := 'TBL_TRAP_TYPE_DICT';

  cmplxLayer.Caption := 'Продуктивный горизонт';
  cmplxLayer.FullLoad := false;
  cmplxLayer.DictName := 'TBL_LAYER';
  

  EditingClass := TSubstructure;
  ParentClass  := THorizon; 
end;

procedure TfrmAdditionalSubstructureInfo.FillControls;
begin
  cmplxNGK.AddItem(Substructure.SubComplexID, Substructure.SubComplex);
  cmplxTrapType.AddItem(Substructure.TrapTypeID, Substructure.TrapType);
end;

procedure TfrmAdditionalSubstructureInfo.FillParentControls;
begin
  inherited;
  cmplxNGK.AddItem(horizon.ComplexID, horizon.Complex);
end;

function TfrmAdditionalSubstructureInfo.GetHorizon: THorizon;
begin
  Result := nil;
  if EditingObject is THorizon then
    Result := EditingObject as THorizon
  else if EditingObject is TSubstructure then
    Result := (EditingObject as TSubstructure).Horizon;
end;

function TfrmAdditionalSubstructureInfo.GetSubstructure: TSubstructure;
begin
  Result := EditingObject as TSubstructure;
end;

procedure TfrmAdditionalSubstructureInfo.Save;
begin
  if Assigned(Substructure) then
  begin
    Substructure.SubComplexID := cmplxNGK.SelectedElementID;
    Substructure.SubComplex   := cmplxNGK.SelectedElementName;

    Substructure.TrapTypeID := cmplxTrapType.SelectedElementID;
    Substructure.TrapType   := cmplxTrapType.SelectedElementName;
  end;
end;

end.
