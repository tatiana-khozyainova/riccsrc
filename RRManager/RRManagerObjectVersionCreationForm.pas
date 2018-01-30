unit RRManagerObjectVersionCreationForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FramesWizard, RRManagerBaseGUI, RRManagerWaitForArchiveFrame;

type
  TfrmVersionInfo = class(TCommonForm)
    DialogFrame1: TDialogFrame;
  private
    FOnAfterFinishClick: TNotifyEvent;
    { Private declarations }
  protected
    function  GetDlg: TDialogFrame; override;
    function  GetEditingObjectName: string; override;
    procedure OnFinishClick(Sender: TObject);
    procedure OnCancelClick(Sender: TObject);
  public
    { Public declarations }
    property    OnAfterFinishClick: TNotifyEvent read FOnAfterFinishClick write FOnAfterFinishClick;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmVersionInfo: TfrmVersionInfo;

implementation

uses RRManagerEditObjectVersionFrame, RRManagerCommon, RRManagerObjects, Facade;

{$R *.dfm}

{ Tfrm }

constructor TfrmVersionInfo.Create(AOwner: TComponent);
begin
  inherited;
  ToolBarVisible := false;
  dlg.AddFrame(TfrmEditObjectVersion);
  dlg.AddFrame(TfrmWaitForArchive);


  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := 1;

  dlg.OnCancelClick := OnCancelClick;
  dlg.OnFinishClick := OnFinishClick;

  dlg.btnCancel.Caption := 'Закрыть';
end;

function TfrmVersionInfo.GetDlg: TDialogFrame;
begin
  Result := DialogFrame1;
end;

function TfrmVersionInfo.GetEditingObjectName: string;
begin
  Result := 'Версия документа';
end;

procedure TfrmVersionInfo.OnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmVersionInfo.OnFinishClick(Sender: TObject);
var iActiveVersionUIN: integer;
begin
  iActiveVersionUIN := (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID;
  frmVersionInfo.Save;

  ///(TMainFacade.GetInstance as TMainFacade).ActiveVersion := (TMainFacade.GetInstance as TMainFacade).AllVersions.ItemsByUIN[iActiveVersionUIN] as TVersion; 

  if Assigned(FOnAfterFinishClick) then FOnAfterFinishClick(Sender); 
end;

end.
