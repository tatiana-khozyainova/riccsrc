unit CRPartPlacementsEditorForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, CommonParentChildTreeFrame,
  CRPartPlacementsEditorFrame, SlottingPlacement, StdCtrls, ExtCtrls,
  CommonObjectSelector, BaseObjects;

type
  TfrmPartPlacementsEditor = class(TForm, IObjectSelector)
    frmPartPlacements1: TfrmPartPlacements;
    pnlButtons: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
  private
    { Private declarations }
    FMainPlacement: TPartPlacement;
    FSelectOnly: boolean;
    procedure SetMainPlacement(const Value: TPartPlacement);
    procedure SetSelectOnly(const Value: boolean);
  protected
    procedure SetSelectedObject(AValue: TIDObject);
    function  GetSelectedObject: TIDObject;
    procedure SetMultiSelect(const Value: boolean);
    function  GetMultiSelect: boolean;
    function  GetSelectedObjects: TIDObjects;
    procedure SetSelectedObjects(AValue: TIDObjects);
  public
    { Public declarations }
    property SelectOnly: boolean read FSelectOnly write SetSelectOnly;
    property MultiSelect: boolean read GetMultiSelect write SetMultiSelect;
    property MainPlacement: TPartPlacement read FMainPlacement write SetMainPlacement;
    property SelectedObjects: TIDObjects read GetSelectedObjects write SetSelectedObjects;
    procedure ReadSelectedObjects;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmPartPlacementsEditor: TfrmPartPlacementsEditor;

implementation

uses Facade;

{$R *.dfm}

{ TfrmPartPlacementsEditor }

constructor TfrmPartPlacementsEditor.Create(AOwner: TComponent);
begin
  inherited;
  MainPlacement := TMainFacade.GetInstance.CoreLibrary;
end;

function TfrmPartPlacementsEditor.GetMultiSelect: boolean;
begin
  Result := frmPartPlacements1.MultiSelect;
end;

function TfrmPartPlacementsEditor.GetSelectedObject: TIDObject;
begin
  Result := frmPartPlacements1.SelectedObject;
end;

function TfrmPartPlacementsEditor.GetSelectedObjects: TIDObjects;
begin
  Result := frmPartPlacements1.SelectedObjects;
end;

procedure TfrmPartPlacementsEditor.ReadSelectedObjects;
begin

end;

procedure TfrmPartPlacementsEditor.SetMainPlacement(
  const Value: TPartPlacement);
begin
  if FMainPlacement <> Value then
  begin
    FMainPlacement := Value;
    frmPartPlacements1.Root := FMainPlacement;
  end;
end;

procedure TfrmPartPlacementsEditor.SetMultiSelect(const Value: boolean);
begin
  frmPartPlacements1.MultiSelect := Value;
end;

procedure TfrmPartPlacementsEditor.SetSelectedObject(AValue: TIDObject);
begin
  frmPartPlacements1.SelectedObject := AValue;
end;

procedure TfrmPartPlacementsEditor.SetSelectedObjects(AValue: TIDObjects);
begin
  frmPartPlacements1.SelectedObjects := AValue;
end;

procedure TfrmPartPlacementsEditor.SetSelectOnly(const Value: boolean);
begin
  FSelectOnly := Value;
  if not FSelectOnly then
  begin
    btnOK.Caption := 'Закрыть';
    btnCancel.Visible := false;
  end
  else
  begin
    btnOK.Caption := 'OK';
    btnCancel.Visible := true;
  end;
end;

end.
