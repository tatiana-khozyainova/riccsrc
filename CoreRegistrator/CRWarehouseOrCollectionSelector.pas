unit CRWarehouseOrCollectionSelector;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls;

type
  TfrmCollectionOrWarehouseSelector = class(TFrame)
    gbxSelector: TGroupBox;
    Label1: TLabel;
    cmbxCoreWarehouse: TComboBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
