unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Ex_Grid, ToolWin, ComCtrls;

type
  TFrame1 = class(TFrame)
    pgcDrillingFact: TPageControl;
    tsDrill: TTabSheet;
    tlbButtons: TToolBar;
    grdvwDrill: TGridView;
    tsTest: TTabSheet;
    grdvwTest_IP: TGridView;
    grdvwTest_Col: TGridView;
    tsMore: TTabSheet;
    grdvwMore: TGridView;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
