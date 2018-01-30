unit RRManagerBedInfoForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FramesWizard, ClientCommon, RRManagerObjects, RRManagerBaseObjects, RRManagerBaseGUI;

type
  TfrmBedInfo = class(TCommonForm)
    DialogFrame1: TDialogFrame;
  private
    { Private declarations }
  protected
    procedure SetEditingObject(const Value: TBaseObject); override;
    function  GetEditingObject: TBaseObject; override;
    function  GetDlg: TDialogFrame; override;
    function GetEditingObjectName: string; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmBedInfo: TfrmBedInfo;

implementation

uses RRManagerEditMainBedInfoFrame,      RRManagerEditBedStructureFrame, RRManagerEditParamsFrame, RRManagerEditReservesFrame;


{$R *.DFM}

{ TfrmBedInfo }

constructor TfrmBedInfo.Create(AOwner: TComponent);
begin
  inherited;
  dlg.AddFrame(TfrmMainBedInfo);
  //dlg.AddFrame(TfrmBedStructure);
  dlg.AddFrame(TfrmReserves);
  dlg.AddFrame(TfrmParams);
  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := 1;

  Width := 1000;
  Height := 700;


end;

function TfrmBedInfo.GetDlg: TDialogFrame;
begin
  Result := DialogFrame1;
end;

function TfrmBedInfo.GetEditingObject: TBaseObject;
begin
  Result := inherited GetEditingObject;
end;

function TfrmBedInfo.GetEditingObjectName: string;
begin
  Result := 'Залежь';
end;

procedure TfrmBedInfo.SetEditingObject(const Value: TBaseObject);
begin
//  DebugFileSave('FormLoadBeforeSet: ' + IntToStr(((Value as TBed).Field).UIN) + ';' + ((Value as TBed).Field).Name);
  inherited;
  if Assigned(EditingObject) then
//    DebugFileSave('FormLoadAfterSet: ' + IntToStr(((EditingObject as TBed).Field).UIN) + ';' + ((EditingObject as TBed).Field).Name);
end;

end.
