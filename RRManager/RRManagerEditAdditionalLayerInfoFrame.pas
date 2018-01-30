unit RRManagerEditAdditionalLayerInfoFrame;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CommonComplexCombo, ExtCtrls, RRManagerObjects, RRManagerBaseOBjects,
  ClientCommon, RRManagerBaseGUI;

type
  TfrmAdditionalLayerInfo = class(TBaseFrame)
//  TfrmAdditionalLayerInfo = class(TFrame)
    gbxAll: TGroupBox;
    cmplxTrapType: TfrmComplexCombo;
    edtTrapHeight: TEdit;
    edtTrapArea: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    Label3: TLabel;
    edtBedHeight: TEdit;
    Label4: TLabel;
    edtBedArea: TEdit;
    Label5: TLabel;
  private
    function GetLayer: TOldLayer;
    function GetBed: TOldBed;
    function GetSubstructure: TOldSubstructure;
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
    constructor Create(AOwner: TComponent); override;
    procedure   Save; override;
  end;

implementation

{$R *.DFM}

{ TfrmAdditionalLayerInfo }

procedure TfrmAdditionalLayerInfo.ClearControls;
begin
  cmplxTrapType.Clear;
  edtTrapHeight.Clear;
  edtTrapArea.Clear;
  edtBedHeight.Clear;
  edtBedArea.Clear;
end;

constructor TfrmAdditionalLayerInfo.Create(AOwner: TComponent);
begin
  inherited;
  EditingClass := TOldLayer;
  cmplxTrapType.Caption  := 'Тип ловушки';
  cmplxTrapType.FullLoad := true;
  cmplxTrapType.DictName := 'TBL_TRAP_TYPE_DICT';
end;

procedure TfrmAdditionalLayerInfo.FillControls(ABaseObject: TBaseObject);
var L: TOldLayer;
begin
  if not Assigned(ABaseObject) then L := Layer
  else L := ABaseObject as TOldLayer;

  edtTrapHeight.Text := trim(Format('%7.2f', [L.TrapHeight]));
  edtTrapArea.Text := trim(Format('%7.2f', [L.TrapArea]));
  cmplxTrapType.AddItem(L.TrapTypeID, L.TrapType);

  edtBedHeight.Text := trim(Format('%7.2f', [L.BedHeight]));
  edtBedArea.Text := trim(Format('%7.2f', [L.BedArea]));

end;

procedure TfrmAdditionalLayerInfo.FillParentControls;
begin

end;

function TfrmAdditionalLayerInfo.GetBed: TOldBed;
begin
  Result := nil;
  if EditingObject is TOldBed then
    Result := EditingObject as TOldBed
  else
  if EditingObject is TOldLayer then
    Result := (EditingObject as TOldLayer).Bed;
end;

function TfrmAdditionalLayerInfo.GetLayer: TOldLayer;
begin
  Result := nil;
  if EditingObject is TOldLayer then
    Result := EditingObject as TOldLayer;
end;

function TfrmAdditionalLayerInfo.GetSubstructure: TOldSubstructure;
begin
  Result := nil;
  if EditingObject is TOldSubstructure then
    Result := EditingObject as TOldSubstructure
  else
  if EditingObject is TOldLayer then
    Result := (EditingObject as TOldLayer).Substructure;
end;

procedure TfrmAdditionalLayerInfo.RegisterInspector;
begin
  inherited;

  Inspector.Add(edtTrapHeight, nil, ptFloat, 'высота ловушки', true);
  Inspector.Add(edtTrapArea, nil, ptFloat, 'площадь ловушки', true);

  Inspector.Add(edtBedHeight, nil, ptFloat, 'высота залежи', true);
  Inspector.Add(edtBedArea, nil, ptFloat, 'площадь залежи', true);
end;

procedure TfrmAdditionalLayerInfo.Save;
begin
  inherited;
  Layer.TrapTypeID := cmplxTrapType.SelectedElementID;
  Layer.TrapType := cmplxTrapType.SelectedElementName;

  Layer.TrapHeight := StrToFloatEx(edtTrapHeight.Text);
  Layer.TrapArea := StrToFloatEx(edtTrapArea.Text);

  Layer.BedHeight := StrToFloatEx(edtBedHeight.Text);
  Layer.BedArea := StrToFloatEx(edtBedArea.Text);
end;

end.
