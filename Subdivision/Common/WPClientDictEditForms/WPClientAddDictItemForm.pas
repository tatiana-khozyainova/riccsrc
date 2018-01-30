unit WPClientAddDictItemForm;

interface

uses
  Classes, Forms, stdctrls, Controls;

type
  TfrmWPClientAddDictItem = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
    arrEdit: array of TWinControl;
    arrLabel: array of TLabel;
    btnOK: TButton;
    btnCancel: TButton;
  end;

var
  frmWPClientAddDictItem: TfrmWPClientAddDictItem;

implementation

{$R *.DFM}

end.
