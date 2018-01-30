unit RRManagerSubstructureInfoForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FramesWizard, RRmanagerEditMainSubstructureInfoFrame,
  RRManagerEditSideSubstructureInfoFrame,
  RRManagerEditNextSubstructureInfoFrame, RRManagerEditParamsFrame,
  RRManagerBaseGUI, RRManagerEditDocumentsFrame;

type
  TfrmSubstructureInfo = class(TCommonForm)
    DialogFrame1: TDialogFrame;
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
  frmSubstructureInfo: TfrmSubstructureInfo;

implementation

{$R *.DFM}

{ TfrmSubstructureInfo }

constructor TfrmSubstructureInfo.Create(AOwner: TComponent);
begin
  inherited;
  dlg.AddFrame(TfrmMainSubstructureInfo);
  dlg.AddFrame(TfrmNextSubstructureInfo);
  dlg.AddFrame(TfrmSideSubstructureInfo);
  dlg.AddFrame(TfrmParams);
  //dlg.AddFrame(TfrmDocuments);
    
  
  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := 2;
end;

function TfrmSubstructureInfo.GetDlg: TDialogFrame;
begin
  Result := DialogFrame1;
end;

function TfrmSubstructureInfo.GetEditingObjectName: string;
begin
  Result := 'Подструктура';
end;

end.
