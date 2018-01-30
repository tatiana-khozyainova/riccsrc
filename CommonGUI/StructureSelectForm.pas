unit StructureSelectForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonIDObjectListForm, CommonIDObjectListFrame, StdCtrls,
  ExtCtrls;

type
  TfrmStructureSelect = class(TfrmIDObjectList)
    procedure frmIDObjectListFramelwObjectsDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmStructureSelect: TfrmStructureSelect;

implementation

uses Facade, SDFacade;

{$R *.dfm}

constructor TfrmStructureSelect.Create(AOwner: TComponent);
begin
  inherited;
  IDObjects := fc.AllStructures;
  Caption := 'Нефтегазоперспективная структура';
end;

procedure TfrmStructureSelect.frmIDObjectListFramelwObjectsDblClick(
  Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
