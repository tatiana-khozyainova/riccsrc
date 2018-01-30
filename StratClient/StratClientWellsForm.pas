unit StratClientWellsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TfrmWells = class(TFrame)
    pnlThemes: TPanel;
    gbxWells: TGroupBox;
    lwWells: TListView;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
