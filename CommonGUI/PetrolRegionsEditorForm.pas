unit PetrolRegionsEditorForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CommonFrame, CommonParentChildTreeFrame,
  PetrolRegion, BaseObjects;

type
  TfrmPetrolRegionsEditor = class(TForm)
    frmPetrolRegions: TfrmParentChild;
    pnlButtons: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
  private
    { Private declarations }
    FMainRegion: TNewPetrolRegion;
    procedure SetMainRegion(const Value: TNewPetrolRegion);
    function  GetSelectedObject: TIDObject;
    function  GetSelectedObjects: TIDObjects;
  public
    { Public declarations }
    property MainRegion: TNewPetrolRegion read FMainRegion write SetMainRegion;
    property SelectedObject: TIDObject read GetSelectedObject;
    property SelectedObjects: TIDObjects read GetSelectedObjects;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmPetrolRegionsEditor: TfrmPetrolRegionsEditor;

implementation

uses Facade, SDFacade;

{$R *.dfm}

{ TfrmPetrolRegionsEditor }

constructor TfrmPetrolRegionsEditor.Create(AOwner: TComponent);
begin
  inherited;
  MainRegion := TMainFacade.GetInstance.AllNewPetrolRegions.ItemsByID[0] as TNewPetrolRegion;
  frmPetrolRegions.MultiSelect := true;
  frmPetrolRegions.SelectableLayers := [2];
end;

function TfrmPetrolRegionsEditor.GetSelectedObject: TIDObject;
begin
  Result := frmPetrolRegions.SelectedObject;
end;

function TfrmPetrolRegionsEditor.GetSelectedObjects: TIDObjects;
begin
  Result := frmPetrolRegions.SelectedObjects;
end;

procedure TfrmPetrolRegionsEditor.SetMainRegion(
  const Value: TNewPetrolRegion);
begin
  if FMainRegion <> Value then
  begin
    FMainRegion := Value;
    frmPetrolRegions.Root := FMainRegion;
  end;
end;



end.
