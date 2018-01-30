unit RRManagerBasketForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RRManagerBasketFrame, ExtCtrls, StdCtrls;

type
  TfrmBasketView = class(TForm)
    frmBasket: TfrmBasket;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBasketView: TfrmBasketView;

implementation

{$R *.dfm}

procedure TfrmBasketView.FormShow(Sender: TObject);
begin
  //
  frmBasket.btnClose.ModalResult := mrCancel;
end;

end.
