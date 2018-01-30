unit RRManagerReservesLayerInfoForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FramesWizard, RRManagerEditMainLayerInfoFrame,
  RRmanagerEditAdditionalLayerInfoFrame, RRManagerEditResourceFrame,
  RRManagerEditReservesFrame, RRManagerEditParamsFrame, RRManagerBaseGUI;

type
  TfrmReservesLayerInfo = class(TCommonForm)
    DialogFrame1: TDialogFrame;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  protected
    function  GetDlg: TDialogFrame; override;
    function GetEditingObjectName: string; override;    
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmReservesLayerInfo: TfrmReservesLayerInfo;

implementation

{$R *.DFM}

constructor TfrmReservesLayerInfo.Create(AOwner: TComponent);
begin
  inherited;
  dlg.AddFrame(TfrmMainLayerInfo);
  dlg.AddFrame(TfrmAdditionalLayerInfo);
  dlg.AddFrame(TfrmReserves);
//  dlg.AddFrame(TfrmParams);


  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := 0;
end;

procedure TfrmReservesLayerInfo.FormShow(Sender: TObject);
begin
  (dlg.Frames[0] as TBaseFrame).Check;
end;

function TfrmReservesLayerInfo.GetDlg: TDialogFrame;
begin
  Result := DialogFrame1;
end;

function TfrmReservesLayerInfo.GetEditingObjectName: string;
begin
  Result := 'Продуктивный пласт';
end;

end.
