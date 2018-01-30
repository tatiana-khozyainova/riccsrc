unit Load;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls;

type
  TfrmLoad = class(TForm)
    anmWait: TAnimate;
    prgb: TProgressBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLoad: TfrmLoad;

implementation

{$R *.dfm}

end.
