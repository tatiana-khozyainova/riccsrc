unit RRManagerEditMainBedInfoFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RRManagerBaseObjects, CommonComplexCombo, RRManagerObjects, ClientCommon, RRManagerBaseGUI,
  ExtCtrls;

type
  TfrmMainBedInfo = class(TBaseFrame)
//  TfrmMainBedInfo = class(TFrame)
    gbxAll: TGroupBox;
    Label1: TLabel;
    edtBedIndex: TEdit;
    cmplxNGK: TfrmComplexCombo;
    cmplxCollectorType: TfrmComplexCombo;
    cmplxLithology: TfrmComplexCombo;
    cmplxFluidType: TfrmComplexCombo;
    cmplxBedType: TfrmComplexCombo;
    cmplxStructureElementType: TfrmComplexCombo;
    Bevel1: TBevel;
    edtDepth: TEdit;
    Label2: TLabel;
    edtComment: TEdit;
    Label3: TLabel;
    chbxIsBalanced: TCheckBox;
  private
    { Private declarations }
    function GetBed: TOldBed;
    function GetField: TOldField;
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
    procedure RegisterInspector; override;
  public
    { Public declarations }
    property Bed: TOldBed read GetBed;
    property Field: TOldField read GetField;

    constructor Create(AOwner: TComponent); override;
    procedure   Save; override;
  end;

implementation

{$R *.DFM}

{ TfrmMainBedInfo }

procedure TfrmMainBedInfo.ClearControls;
begin
  edtBedIndex.Clear;
  cmplxNGK.Clear;
  cmplxBedType.Clear;
  cmplxCollectorType.Clear;
  cmplxLithology.Clear;
  cmplxFluidType.Clear;
  edtDepth.Clear;

  if Assigned(Field) then
    FEditingObject := Field.Beds.Add;

end;

constructor TfrmMainBedInfo.Create(AOwner: TComponent);
begin
  inherited;
  EditingClass := TOldBed;

  cmplxStructureElementType.Caption := 'Блок, купол';
  cmplxStructureElementType.FullLoad := true;
  cmplxStructureElementType.DictName := 'TBL_STRUCTURE_TECTONIC_ELEMENT';



  cmplxNGK.Caption := 'Нефтегазоносный комплекс';
  cmplxNGK.FullLoad := true;
  cmplxNGK.DictName := 'TBL_OIL_COMPLEX_DICT';

  cmplxBedType.Caption := 'Тип залежи по геологическому строению';
  cmplxBedType.FullLoad := true;
  cmplxBedType.DictName := 'TBL_BED_TYPE_DICT';

  cmplxCollectorType.Caption := 'Тип коллектора';
  cmplxCollectorType.FullLoad := true;
  cmplxCollectorType.DictName := 'TBL_COLLECTOR_TYPE_DICT';


  cmplxLithology.Caption := 'Литология коллектора';
  cmplxLithology.FullLoad := true;
  cmplxLithology.DictName := 'TBL_LITHOLOGY_DICT';

  cmplxFluidType.Caption := 'Тип залежи по типу флюида';
  cmplxFluidType.FullLoad := true;
  cmplxFluidType.DictName := 'TBL_FIELD_TYPE_DICT';


end;

procedure TfrmMainBedInfo.FillControls(ABaseObject: TBaseObject);
var b: TOldBed;
begin
  if not Assigned(ABaseObject) then B := Bed
  else B := ABaseObject as TOldBed;

//  DebugFileSave('FillFirstFrame: ' + IntToStr(Bed.Field.UIN) + '; ' + Bed.Field.Name);
  edtBedIndex.Text := B.BedIndex;

  cmplxNGK.AddItem(B.ComplexID, B.ComplexName);
  cmplxBedType.AddItem(B.BedTypeID, B.BedType);
  cmplxStructureElementType.AddItem(B.StructureElementID, B.StructureElement);
  cmplxCollectorType.AddItem(B.CollectorTypeID, B.CollectorType);
  cmplxLithology.AddItem(B.RockID, B.RockName);
  cmplxFluidType.AddItem(B.FluidTypeID, B.FluidType);

  if b.Depth <> -1 then
    edtDepth.Text := Trim(Format('%8.2f', [B.Depth]));

  edtComment.Text := Bed.Name;
  chbxIsBalanced.Checked := Bed.IsBalanced;
end;

procedure TfrmMainBedInfo.FillParentControls;
begin
  cmplxFluidType.AddItem(Field.FieldTypeID, Field.FieldType);
end;

function TfrmMainBedInfo.GetBed: TOldBed;
begin
  if EditingObject is TOldBed then
    Result := EditingObject as TOldBed
  else Result := nil;
end;

function TfrmMainBedInfo.GetField: TOldField;
begin
  Result := nil;
  if EditingObject is TOldField then
    Result := EditingObject as TOldField
  else
  if EditingObject is TOldBed then
    Result := (EditingObject as TOldBed).Field;
end;

procedure TfrmMainBedInfo.RegisterInspector;
begin
  inherited;
  Inspector.Add(edtBedIndex, nil, ptString, 'индекс залежи', false);
  Inspector.Add(cmplxNGK.cmbxName, nil, ptString, 'НГК', false);
  Inspector.Add(cmplxFluidType.cmbxName, nil, ptString, 'тип флюида', false);
  Inspector.Add(edtDepth, nil, ptFloat, 'глубина кровли залежи', true);
end;

procedure TfrmMainBedInfo.Save;
begin
  inherited;
  if FEditingObject is TOldField then
    FEditingObject := Field.Beds.Add;

  Bed.BedIndex := edtBedIndex.Text;

  Bed.RockID := cmplxLithology.SelectedElementID;
  Bed.RockName := cmplxLithology.SelectedElementName;

  Bed.CollectorTypeID := cmplxCollectorType.SelectedElementID;
  Bed.CollectorType := cmplxCollectorType.SelectedElementName;

  Bed.BedTypeID := cmplxBedType.SelectedElementID;
  Bed.BedType := cmplxBedType.SelectedElementName;

  Bed.ComplexID := cmplxNGK.SelectedElementID;
  Bed.ComplexName := cmplxNGK.SelectedElementName;


  Bed.FluidTypeID := cmplxFluidType.SelectedElementID;
  Bed.FluidType := cmplxFluidType.SelectedElementName;

  Bed.StructureElementID := cmplxStructureElementType.SelectedElementID;
  Bed.StructureElement := cmplxStructureElementType.SelectedElementName;

  Bed.Name := edtComment.Text;




  try
    Bed.Depth := StrToFloat(edtDepth.Text);
  except
    Bed.Depth := -1;
  end;

  Bed.IsBalanced := chbxIsBalanced.Checked;
end;

end.
