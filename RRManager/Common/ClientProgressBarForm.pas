unit ClientProgressBarForm;

interface

uses
  Forms,
  StdCtrls, Classes, Controls, ComCtrls;

type
  TfrmProgressBar = class(TForm)
    anmWait: TAnimate;
    Lbl: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure InitProgressBar(const AMessage: string; Avi: TCommonAVI);
  end;

var
  frmProgressBar: TfrmProgressBar;

implementation

{$R *.DFM}

procedure TFrmProgressBar.InitProgressBar(const AMessage: string; Avi: TCommonAVI);
begin
  frmProgressBar.Lbl.Caption:=AMessage;
  frmProgressBar.anmWait.CommonAVI := Avi;
  frmProgressBar.anmWait.Active:=true;
  frmProgressBar.Show();
  frmProgressBar.Update();
end;

end.
