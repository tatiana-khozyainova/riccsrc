unit DistrictSelectForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonIDObjectListForm, CommonIDObjectListFrame, StdCtrls,
  ExtCtrls;

type
  TfrmDistrictSelect = class(TfrmIDObjectList)
    procedure frmIDObjectListFramelwObjectsDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmDistrictSelect: TfrmDistrictSelect;

implementation

uses Facade;

{$R *.dfm}

{ TfrmDistrictSelect }

constructor TfrmDistrictSelect.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Географический регион';
  IDObjects := fc.AllDistricts;
end;

procedure TfrmDistrictSelect.frmIDObjectListFramelwObjectsDblClick(
  Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
