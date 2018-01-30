unit SubDividerNGRExportForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ToolEdit, ExtCtrls;

type
  TfrmNGRExport = class(TForm)
    pnlButtons: TPanel;
    Button1: TButton;
    Button2: TButton;
    gbxFileExport: TGroupBox;
    edtDirectory: TDirectoryEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNGRExport: TfrmNGRExport;

implementation

{$R *.dfm}

end.
