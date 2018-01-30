unit RRManagerEditMainLayerInfoFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RRManagerBaseObjects, RRManagerObjects, CommonComplexCombo, StdCtrls, ExtCtrls, ClientCommon,
  RRManagerBaseGUI;

type
//  TfrmMainLayerInfo = class(TFrame)
  TfrmMainLayerInfo = class(TBaseFrame)
    gbxAll: TGroupBox;
    cmplxLayer: TfrmComplexCombo;
    cmplxLithology: TfrmComplexCombo;
    cmplxCollector: TfrmComplexCombo;
    edtPower: TEdit;
    edtEffectivePower: TEdit;
    edtFillingCoef: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Bevel1: TBevel;
    cmplxBedType: TfrmComplexCombo;
  private
    function GetBed: TOldBed;
    function GetLayer: TOldLayer;
    function GetSubstructure: TOldSubstructure;
    function GetLayers: TOldLayers;
    { Private declarations }
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
    procedure RegisterInspector; override;
  public
    { Public declarations }
    property    Layer: TOldLayer read GetLayer;
    property    Bed: TOldBed read GetBed;
    property    Substructure: TOldSubstructure read GetSubstructure;
    property    Layers: TOldLayers read GetLayers;

    constructor Create(AOwner: TComponent); override;
    procedure   Save; override;
  end;

implementation

{$R *.DFM}

{ TfrmMainLayerInfo }

procedure TfrmMainLayerInfo.ClearControls;
begin
  cmplxLayer.Clear;
  cmplxLithology.Clear;
  cmplxCollector.Clear;
  cmplxBedType.Clear;

  edtPower.Clear;
  edtEffectivePower.Clear;
  edtFillingCoef.Clear;
end;

constructor TfrmMainLayerInfo.Create(AOwner: TComponent);
begin
  inherited;
  EditingClass := TOldLayer;
  ParentClass := TOldSubstructure;

  cmplxLayer.Caption := 'Наименование продуктивного пласта';
  cmplxLayer.FullLoad := true;
  cmplxLayer.DictName := 'TBL_LAYER';

  cmplxLithology.Caption := 'Литология коллектора';
  cmplxLithology.FullLoad := false;
  cmplxLithology.DictName := 'TBL_LITHOLOGY_DICT';

  cmplxCollector.Caption := 'Тип коллектора';
  cmplxCollector.FullLoad := true;
  cmplxCollector.DictName := 'TBL_COLLECTOR_TYPE_DICT';

  cmplxBedType.Caption := 'Тип залежи';
  cmplxBedType.FullLoad := true;
  cmplxBedType.DictName := 'TBL_BED_TYPE_DICT';

end;

procedure TfrmMainLayerInfo.FillControls(ABaseObject: TBaseObject);
var L: TOldLayer;
begin
  if not Assigned(ABaseObject) then L := Layer
  else L := ABaseObject as TOldLayer;

  cmplxLayer.AddItem(L.LayerID, L.LayerIndex);
  cmplxLithology.AddItem(L.RockID, L.RockName);
  cmplxCollector.AddItem(L.CollectorTypeID, L.CollectorType);
  cmplxBedType.AddItem(L.BedTypeID, L.BedType);

  edtPower.Text := Trim(Format('%7.2f', [L.Power]));
  edtEffectivePower.Text := Trim(Format('%7.2f', [L.EffectivePower]));
  edtFillingCoef.Text := Trim(Format('%7.2f', [L.FillingCoef]));

end;

procedure TfrmMainLayerInfo.FillParentControls;
begin
  inherited;
  ClearControls;
    
  if not Assigned(Layer) then
  if Assigned(Layers) then
    FEditingObject := Layers.Add;

  if Assigned(Substructure) then
  begin
    cmplxLithology.AddItem(Substructure.RockID, Substructure.RockName);
    cmplxCollector.AddItem(Substructure.CollectorTypeID, Substructure.CollectorType);
    cmplxBedType.AddItem(Substructure.BedTypeID, Substructure.BedType);
  end
  else
  if Assigned(Bed) then
  begin
    cmplxLithology.AddItem(Bed.RockID, Bed.RockName);
    cmplxCollector.AddItem(Bed.CollectorTypeID, Bed.CollectorType);
    cmplxBedType.AddItem(Bed.BedTypeID, Bed.BedType);
  end;
end;

function TfrmMainLayerInfo.GetBed: TOldBed;
begin
  Result := nil;
  if EditingObject is TOldBed then
    Result := EditingObject as TOldBed
  else
  if EditingObject is TOldLayer then
    Result := (EditingObject as TOldLayer).Bed;
end;

function TfrmMainLayerInfo.GetLayer: TOldLayer;
begin
  Result := nil;
  if EditingObject is TOldLayer then
    Result := EditingObject as TOldLayer;
end;

function TfrmMainLayerInfo.GetLayers: TOldLayers;
begin
  Result := nil;
  if Assigned(Substructure) then
    Result := Substructure.Layers
  else
  if Assigned(Bed) then
    Result := Bed.Layers;
end;

function TfrmMainLayerInfo.GetSubstructure: TOldSubstructure;
begin
  Result := nil;
  if EditingObject is TOldSubstructure then
    Result := EditingObject as TOldSubstructure
  else
  if EditingObject is TOldLayer then
    Result := (EditingObject as TOldLayer).Substructure;
end;

procedure TfrmMainLayerInfo.RegisterInspector;
begin
  inherited;
  Inspector.Add(cmplxLayer.cmbxName, nil, ptString, 'наименование продуктивного пласта', false);

  Inspector.Add(edtPower, nil, ptFloat, 'мощность', true);
  Inspector.Add(edtEffectivePower, nil, ptFloat, 'эффективная мощность', true);
  Inspector.Add(edtFillingCoef, nil, ptFloat, 'коэффициент заполнения', true);
end;

procedure TfrmMainLayerInfo.Save;
begin
  inherited;
  if not Assigned(Layer) then
  if Assigned(Layers) then
    FEditingObject := Layers.Add;

  if Assigned(Layer) then
  begin
    Layer.RockID := cmplxLithology.SelectedElementID;
    Layer.RockName := cmplxLithology.SelectedElementName;

    Layer.LayerID := cmplxLayer.SelectedElementID;
    Layer.LayerIndex := cmplxLayer.SelectedElementName;

    Layer.CollectorTypeID := cmplxCollector.SelectedElementID;
    Layer.CollectorType := cmplxCollector.SelectedElementName;

    Layer.BedTypeID := cmplxBedType.SelectedElementID;
    Layer.BedType := cmplxBedType.SelectedElementName;

    Layer.Power := StrToFloatEx(edtPower.Text);
    Layer.EffectivePower := StrToFloatEx(edtEffectivePower.Text);
    Layer.FillingCoef := StrToFloatEx(edtFillingCoef.Text);
  end;
end;

end.
