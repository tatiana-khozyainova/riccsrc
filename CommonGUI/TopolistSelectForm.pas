unit TopolistSelectForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonIDObjectListForm, CommonIDObjectListFrame, StdCtrls,
  ExtCtrls;

type
  TfrmTopolistSelect = class(TfrmIDObjectList)
    procedure frmIDObjectListFramelwObjectsDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmTopolistSelect: TfrmTopolistSelect;

implementation

uses Facade, SDFacade;

{$R *.dfm}

{ TfrmTopolistSelect }

constructor TfrmTopolistSelect.Create(AOwner: TComponent);
begin
  inherited;
  IDObjects := fc.AllTopolists;
  Caption := 'Топографический лист';
end;

procedure TfrmTopolistSelect.frmIDObjectListFramelwObjectsDblClick(
  Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
