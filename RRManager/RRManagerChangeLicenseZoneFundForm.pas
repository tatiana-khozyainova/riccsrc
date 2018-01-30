unit RRManagerChangeLicenseZoneFundForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FramesWizard, RRManagerBaseGUI, RRManagerChangeLicenseZoneFundFrame;

type
  //TfrmChangeState = class(TForm)
  TfrmChangeState = class(TCommonForm)  
    dlg: TDialogFrame;
  private
    { Private declarations }
  protected
    function  GetDlg: TDialogFrame; override;
    function  GetEditingObjectName: string; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;    
  end;

var
  frmChangeState: TfrmChangeState;

implementation

{$R *.dfm}

{ TForm1 }

constructor TfrmChangeState.Create(AOwner: TComponent);
begin
  inherited;
  dlg.AddFrame(TfrmChangeLicenseZoneFrame);
  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := 0;
  dlg.Buttons := [btFinish, btCancel]
end;

function TfrmChangeState.GetDlg: TDialogFrame;
begin
  Result := dlg;
end;

function TfrmChangeState.GetEditingObjectName: string;
begin
  Result := 'Лицензионный участок';
end;

end.
