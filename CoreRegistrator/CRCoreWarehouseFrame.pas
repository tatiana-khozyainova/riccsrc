unit CRCoreWarehouseFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, CRIntervalFrame, CommonObjectSelectFilter;

type
  TfrmCoreWarehouse = class(TFrame)
    frmObjectSelect: TfrmObjectSelect;
    frmCoreRegistratorFrame: TfrmCoreRegistratorFrame;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
