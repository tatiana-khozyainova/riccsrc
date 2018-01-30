unit RRManagerLayerInfoForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FramesWizard, RRManagerEditMainLayerInfoFrame,
  RRmanagerEditAdditionalLayerInfoFrame, RRManagerEditResourceFrame,
  RRManagerEditReservesFrame, RRManagerEditParamsFrame, RRManagerBaseGUI,
  RRManagerEditDocumentsFrame;

type
  TfrmLayerInfo = class(TCommonForm)
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
  frmLayerInfo: TfrmLayerInfo;

implementation

{$R *.DFM}

{ TfrmLayerInfo }

constructor TfrmLayerInfo.Create(AOwner: TComponent);
begin
  inherited;
  dlg.AddFrame(TfrmMainLayerInfo);
  dlg.AddFrame(TfrmResources);
  dlg.AddFrame(TfrmParams);
  //dlg.AddFrame(TfrmDocuments);

  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := 0;
end;

function TfrmLayerInfo.GetDlg: TDialogFrame;
begin
  Result := DialogFrame1;
end;

function TfrmLayerInfo.GetEditingObjectName: string;
begin
  Result := 'Продуктивный пласт';
end;

procedure TfrmLayerInfo.FormShow(Sender: TObject);
begin
  (dlg.Frames[0] as TBaseFrame).Check;
end;

end.
