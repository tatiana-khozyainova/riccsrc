unit RRManagerHorizonInfoForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RRmanagerBaseObjects,  RRManagerEditMainHorizonInfoFrame,
  FramesWizard, RRManagerEditParamsFrame, RRManagerBaseGUI,
  RRManagerHorizonVersionFrame, RRManagerEditDocumentsFrame;

type
  TfrmHorizonInfo = class(TCommonForm)
    DialogFrame1: TDialogFrame;
  private
    { Private declarations }
  protected
    function  GetDlg: TDialogFrame; override;
    function  GetEditingObjectName: string; override;
  public
    { Public declarations }
    procedure Prepare; 
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmHorizonInfo: TfrmHorizonInfo;


implementation

{$R *.DFM}


{ TfrmHorizonInfo }

constructor TfrmHorizonInfo.Create(AOwner: TComponent);
begin
  inherited;

  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := 0;
end;

function TfrmHorizonInfo.GetDlg: TDialogFrame;
begin
  Result := DialogFrame1;
end;

function TfrmHorizonInfo.GetEditingObjectName: string;
begin
  Result := 'Горизонт';
end;

procedure TfrmHorizonInfo.Prepare;
begin
  dlg.Clear;
  dlg.AddFrame(TfrmMainHorizonInfo);
  dlg.AddFrame(TfrmHorizonVersion);
  dlg.AddFrame(TfrmParams);
  //dlg.AddFrame(TfrmDocuments);
  dlg.ActiveFrameIndex := 0;
end;

end.
