unit RRManagerEditMainSubstructureInfoFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RRmanagerBaseObjects, RRManagerObjects, StdCtrls, CommonComplexCombo,
  ClientCommon, ExtCtrls, RRManagerBaseGUI;

type
//  TfrmMainSubstructureInfo = class(TFrame)
  TfrmMainSubstructureInfo = class(TBaseFrame)
    gbxAll: TGroupBox;
    cmplxTectonicBlock: TfrmComplexCombo;
    cmplxLitology: TfrmComplexCombo;
    edtSubstructureName: TEdit;
    Label1: TLabel;
    cmplxBedType: TfrmComplexCombo;
    cmplxCollectorType: TfrmComplexCombo;
    Label2: TLabel;
    cmbxSubstrucureNumber: TComboBox;
    cmplxNGK: TfrmComplexCombo;
    Bevel1: TBevel;
    procedure cmplxTectonicBlockcmbxNameChange(Sender: TObject);
  private
    function GetSubstructure: TOldSubstructure;
    function GetHorizon: TOldHorizon;
    { Private declarations }
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure FillParentControls; override;
    procedure ClearControls; override;
    procedure RegisterInspector; override;    
  public
    { Public declarations }
    property    Horizon: TOldHorizon read GetHorizon;
    property    Substructure: TOldSubstructure read GetSubstructure;
    constructor Create(AOwner: TComponent); override;
    procedure   Save; override;
  end;

implementation

uses Facade;

{$R *.DFM}

{ TfrmMainSubstructureInfo }

procedure TfrmMainSubstructureInfo.ClearControls;
begin
  cmplxNGK.Clear;
  cmplxTectonicBlock.Clear;
  edtSubstructureName.Clear;
  cmbxSubstrucureNumber.Text := '';
  cmplxBedType.Clear;
  cmplxCollectorType.Clear;
  cmplxLitology.Clear;
  if Assigned(Horizon) then
    FEditingObject := Horizon.Substructures.Add;


end;

constructor TfrmMainSubstructureInfo.Create(AOwner: TComponent);
begin
  inherited;

  EditingClass := TOldSubstructure;
  ParentClass  := TOldHorizon;

  cmplxTectonicBlock.Caption := 'Блок, купол';
  cmplxTectonicBlock.FullLoad := true;
  cmplxTectonicBlock.DictName := 'TBL_STRUCTURE_TECTONIC_ELEMENT';

  cmplxBedType.Caption := 'Тип залежи';
  cmplxBedType.FullLoad := true;
  cmplxBedType.DictName := 'TBL_BED_TYPE_DICT';

  cmplxCollectorType.Caption := 'Тип коллектора';
  cmplxCollectorType.FullLoad := true;
  cmplxCollectorType.DictName := 'TBL_COLLECTOR_TYPE_DICT';

  cmplxLitology.Caption := 'Литология коллектора';
  cmplxLitology.FullLoad := false;
  cmplxLitology.DictName := 'TBL_LITHOLOGY_DICT';

  cmplxNGK.Caption := 'Нефтегазоносный комплекс';
  cmplxNGK.FullLoad := true;
  cmplxNGK.DictName := 'TBL_OIL_COMPLEX_DICT';

  Label2.Visible := false;
  cmbxSubstrucureNumber.Visible := false;
  cmbxSubstrucureNumber.Text := '1';


end;

procedure TfrmMainSubstructureInfo.FillControls(ABaseObject: TBaseObject);
var S: TOldSubstructure;
begin
  if not Assigned(ABaseObject) then S := Substructure
  else S := ABaseObject as TOldSubstructure;

  cmplxTectonicBlock.AddItem(S.StructureElementID, S.StructureElement);
  edtSubstructureName.Text := S.RealName;
  cmbxSubstrucureNumber.Text := IntToStr(S.Order);
  cmplxBedType.AddItem(S.BedTypeID, S.BedType);
  cmplxCollectorType.AddItem(S.CollectorTypeID, S.CollectorType);
  cmplxLitology.AddItem(S.RockID, S.RockName);
  cmplxNGK.AddItem(S.SubComplexID, S.SubComplex);
end;

function TfrmMainSubstructureInfo.GetHorizon: TOldHorizon;
begin
  Result := nil;
  if EditingObject is TOldHorizon then
    Result := EditingObject as TOldHorizon
  else if EditingObject is TOldSubstructure then
    Result := (EditingObject as TOldSubstructure).Horizon;
end;

function TfrmMainSubstructureInfo.GetSubstructure: TOldSubstructure;
begin
  Result := nil;
  if EditingObject is TOldSubstructure then
    Result := EditingObject as TOldSubstructure
end;

procedure TfrmMainSubstructureInfo.Save;
begin
  inherited;
  if EditingObject is TOldHorizon then
    FEditingObject := Horizon.Substructures.Add;

  Substructure.RealName := edtSubstructureName.Text;

  if cmbxSubstrucureNumber.Text <> '' then
    Substructure.Order := StrToInt(cmbxSubstrucureNumber.Text);

  Substructure.SubComplexID := cmplxNGK.SelectedElementID;
  Substructure.SubComplex := cmplxNGK.SelectedElementName;  

  Substructure.StructureElementID := cmplxTectonicBlock.SelectedElementID;
  Substructure.StructureElement   := cmplxTectonicBlock.SelectedElementName;

  Substructure.StructureElementTypeID := GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_STRUCTURE_TECTONIC_ELEMENT'].Dict, Substructure.StructureElementID,  2);
  Substructure.StructureElementType   := GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_SUBSTRUCTURE_TYPE_DICT'].Dict, Substructure.StructureElementTypeID);

  Substructure.BedTypeID := cmplxBedType.SelectedElementID;
  Substructure.BedType   := cmplxBedType.SelectedElementName;

  Substructure.CollectorTypeID := cmplxCollectorType.SelectedElementID;
  Substructure.CollectorType   := cmplxCollectorType.SelectedElementName;

  Substructure.RockID := cmplxLitology.SelectedElementID;
  Substructure.RockName := cmplxLitology.SelectedElementName;
end;

procedure TfrmMainSubstructureInfo.cmplxTectonicBlockcmbxNameChange(
  Sender: TObject);
begin
  cmplxTectonicBlock.cmbxNameChange(Sender);
  edtSubstructureName.Text := cmplxTectonicBlock.cmbxName.Text;
end;

procedure TfrmMainSubstructureInfo.FillParentControls;
begin
  inherited;
  ClearControls;
  if Assigned(Horizon) then
    cmplxNGK.AddItem(Horizon.ComplexID, Horizon.Complex);

  if Assigned(Horizon) and (not Assigned(Substructure)) then
    FEditingObject := Horizon.Substructures.Add;  
end;

procedure TfrmMainSubstructureInfo.RegisterInspector;
begin
  inherited;
  Inspector.Add(cmplxTectonicBlock.cmbxName, nil, ptString, 'блок, купол', false);
  Inspector.Add(edtSubstructureName, nil, ptString, 'наименование подструктуры', false);
  Inspector.Add(cmplxNGK.cmbxName, nil, ptString, 'НГК', false);
end;

end.
