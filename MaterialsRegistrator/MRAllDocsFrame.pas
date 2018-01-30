unit MRAllDocsFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, AllObjectsFrame, ExtCtrls, ComCtrls, ToolWin;

type
  TfrmAllDocs = class(TFrame)
    frmDocsByType: TfrmAllObjects;
    spl1: TSplitter;
    tlb: TToolBar;
    btn: TToolButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
