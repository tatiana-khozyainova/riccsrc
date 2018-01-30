unit CRSelectPlacementForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CoreTransfer, SlottingPlacement;

type
  TfrmSelectPlacement = class(TForm)
    gbxAll: TGroupBox;
    lblState: TLabel;
    cmbxPlacement: TComboBox;
    pnlButtons: TPanel;
    btnSelect: TButton;
    btnClose: TButton;
    chbxFillOnlyEmpties: TCheckBox;
  private
    { Private declarations }
    FUseNewPlacements: boolean;
    procedure SetUseNewPlacements(const Value: boolean);
    function  GetPartPlacement: TPartPlacement;
    function  GetFillOnlyEmpties: boolean;
  public
    { Public declarations }
    property UseNewPlacements: boolean read FUseNewPlacements write SetUseNewPlacements;
    property PartPlacement: TPartPlacement read GetPartPlacement;
    property FillOnlyEmpties: boolean read GetFillOnlyEmpties;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmSelectPlacement: TfrmSelectPlacement;

implementation

uses Facade;

{$R *.dfm}

{ TfrmSelectPlacement }

constructor TfrmSelectPlacement.Create(AOwner: TComponent);
begin
  inherited;
  TMainFacade.GetInstance.CoreLibrary.OldMainPlacementPlainList.MakeList(cmbxPlacement.Items, true, false);
  cmbxPlacement.ItemIndex := 0;
end;

function TfrmSelectPlacement.GetFillOnlyEmpties: boolean;
begin                      
  Result := chbxFillOnlyEmpties.Checked;
end;

function TfrmSelectPlacement.GetPartPlacement: TPartPlacement;
begin
  Result := cmbxPlacement.Items.Objects[cmbxPlacement.ItemIndex] as TPartPlacement;
end;

procedure TfrmSelectPlacement.SetUseNewPlacements(const Value: boolean);
begin
  if FUseNewPlacements <> Value then
  begin
    FUseNewPlacements := Value;
    if FUseNewPlacements then
      TMainFacade.GetInstance.CoreLibrary.NewPlacementPlainList.MakeList(cmbxPlacement.Items, true, true)
    else
      TMainFacade.GetInstance.CoreLibrary.OldMainPlacementPlainList.MakeList(cmbxPlacement.Items, True, true);
    cmbxPlacement.ItemIndex := 0;
  end;
end;

end.
