unit CRBoxEditFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, ComCtrls, StdCtrls, ExtCtrls,
  CommonObjectSelectFrame, SlottingPlacement, BaseObjects, CRPartPlacementsEditorForm,
  jpeg, UniButtonsFrame, CRBoxPictureFrame;

type
  TfrmBoxProperties = class(TfrmCommonFrame)
    gbxBoxProperties: TGroupBox;
    edtBoxNumber: TLabeledEdit;
    Panel1: TPanel;
    lblRack: TLabel;
    cmbxRack: TComboBox;
    lblAll: TLabel;
    procedure cmbxRackChange(Sender: TObject);
    procedure edtBoxNumberExit(Sender: TObject);
  private
    FBoxes: TBoxes;
    FSlottingPlacement: TSlottingPlacement;
    { Private declarations }
    function  GetBox: TBox;
    function  GetPartPlacement: TPartPlacement;
    procedure SetBoxes(const Value: TBoxes);
    procedure SetSlottingPlacement(const Value: TSlottingPlacement);
  protected
    procedure FillControls(ABaseObject: TIDObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
    procedure RegisterInspector; override;
    function  GetParentCollection: TIDObjects; override;

  public
    { Public declarations }

    property    Boxes: TBoxes read FBoxes write SetBoxes;
    property    SlottingPlacement: TSlottingPlacement read FSlottingPlacement write SetSlottingPlacement;
    property    Box: TBox read GetBox;
    property    PartPlacement: TPartPlacement read GetPartPlacement;

    procedure   Save(AObject: TIDObject = nil);  override;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmBoxProperties: TfrmBoxProperties;

implementation

uses BaseGUI, Facade, Math, BaseConsts;

{$R *.dfm}

{ TfrmBoxEdit }

procedure TfrmBoxProperties.ClearControls;
begin
  inherited;
  edtBoxNumber.Clear;
  cmbxRack.ItemIndex := -1;
end;

constructor TfrmBoxProperties.Create(AOwner: TComponent);
begin
  inherited;

  EditingClass := TBox;
  ParentClass := TPartPlacement;
  NeedsShadeEditing := false;
  TMainFacade.GetInstance.CoreLibrary.MainGarage.Racks.MakeList(cmbxRack.Items);
end;

destructor TfrmBoxProperties.Destroy;
begin

  inherited;
end;

procedure TfrmBoxProperties.FillControls(ABaseObject: TIDObject);
var b: TBox;
begin
  inherited;

  b := ShadeEditingObject as TBox;

  if Assigned(b) then
  begin
    edtBoxNumber.Enabled := true;
    edtBoxNumber.Text := b.BoxNumber;
    cmbxRack.ItemIndex := cmbxRack.Items.IndexOfObject(b.Rack);
  end;

  FillParentControls;
end;

procedure TfrmBoxProperties.FillParentControls;
begin
  inherited;
end;

function TfrmBoxProperties.GetBox: TBox;
begin
  Result := EditingObject as TBox;
end;

function TfrmBoxProperties.GetParentCollection: TIDObjects;
begin
  Result := PartPlacement.Boxes;
end;

function TfrmBoxProperties.GetPartPlacement: TPartPlacement;
begin
  Result := nil;
  if EditingObject is TPartPlacement then
    Result := EditingObject as TPartPlacement;

end;


procedure TfrmBoxProperties.RegisterInspector;
begin
  inherited;
  Inspector.Add(edtBoxNumber, nil, ptString, 'Номер ящика', false);
end;

procedure TfrmBoxProperties.Save;
var i: integer;
begin
  inherited;

  if Assigned(EditingObject) then
  begin

    if FEditingObject is TPartPlacement then
      FEditingObject := PartPlacement.Boxes.Add;

    Box.BoxNumber := edtBoxNumber.Text;
    if cmbxRack.ItemIndex > -1 then
      Box.Rack := cmbxRack.Items.Objects[cmbxRack.ItemIndex] as TRack
    else
      Box.Rack := TNullRack.GetInstance;


    Box.Update;
  end
  else
  begin
    if Assigned(FBoxes) then
    begin
      for i := 0 to FBoxes.COunt - 1 do
      begin
        if cmbxRack.ItemIndex > -1 then
          FBoxes.Items[i].Rack := cmbxRack.Items.Objects[cmbxRack.ItemIndex] as TRack
        else
          FBoxes.Items[i].Rack := TNullRack.GetInstance;

        FBoxes.Items[i].Update;
      end;
    end;
  end;
end;

procedure TfrmBoxProperties.cmbxRackChange(Sender: TObject);
begin
  inherited;
  Save();
end;

procedure TfrmBoxProperties.edtBoxNumberExit(Sender: TObject);
begin
  inherited;
  Save;
end;

procedure TfrmBoxProperties.SetBoxes(const Value: TBoxes);
begin
  FBoxes := Value;
  FEditingObject := nil;
  edtBoxNumber.Clear;
  edtBoxNumber.Enabled := false;
  
end;

procedure TfrmBoxProperties.SetSlottingPlacement(
  const Value: TSlottingPlacement);
begin
  if FSlottingPlacement <> Value then
  begin
    FSlottingPlacement := Value;

    if FSlottingPlacement.StatePartPlacement.ID = CORE_MAIN_GARAGE_ID then
    begin
      cmbxRack.Enabled := true;
      lblRack.Enabled := true;
    end
    else
    begin
      cmbxRack.ItemIndex := -1;
      lblRack.Enabled := false;      
      cmbxRack.Enabled := false;
    end;
  end;
end;

end.
