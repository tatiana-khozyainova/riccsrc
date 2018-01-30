unit PetrolRegionSelectForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonIDObjectListForm, CommonIDObjectListFrame, StdCtrls,
  ExtCtrls;

type
  TfrmPetrolRegionSelect = class(TfrmIDObjectList)
    procedure frmIDObjectListFramelwObjectsDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmPetrolRegionSelect: TfrmPetrolRegionSelect;

implementation

uses Facade, SDFacade;

{$R *.dfm}

{ TfrmPetrolRegionSelect }

constructor TfrmPetrolRegionSelect.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Нефтегазоносный регион';
  IDObjects := fc.AllPetrolRegions;
end;

procedure TfrmPetrolRegionSelect.frmIDObjectListFramelwObjectsDblClick(
  Sender: TObject);
begin
  ModalResult := mrOK;
end;

end.
