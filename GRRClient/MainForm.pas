unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonObjectSelectFilter, ComCtrls, ToolWin, ImgList, ActnList,
  Menus, CommonVersionSelectFrame, LicenseZoneSelectFrame, Version,
  LicenseInformFrame, DrillingPlanFrame, NirPlanFrame, SeismPlanFrame,
  ChoiceObligation;

type
  TfrmMain = class(TForm)
    actnLst: TActionList;
    actnTryConnect: TAction;
    actnCloseMainForm: TAction;
    actnHelp: TAction;
    actnEditSimpleDicts: TAction;
    imgLst: TImageList;
    ToolBar: TToolBar;
    ToolButton2: TToolButton;
    ToolButton1: TToolButton;
    ToolButton6: TToolButton;
    ToolButton5: TToolButton;
    ToolButton3: TToolButton;
    ToolButton8: TToolButton;
    ToolButton4: TToolButton;
    sbr: TStatusBar;
    frmSelectVersion1: TfrmSelectVersion;
    frmLicenseZoneSelect1: TfrmLicenseZoneSelect;
    frmlcnsnfrm1: TfrmLicenseInform;
    frmObligationChoice1: TfrmObligationChoice;
    actnSaveEdits: TAction;
    actnImport: TAction;
    actnReports: TAction;
    btnSave: TToolButton;
    btnImport: TToolButton;
    btnReports: TToolButton;
    pmReports: TPopupMenu;
    pmiGISReports: TMenuItem;
    actnXLforGIS: TAction;
    actnXMLforGIS: TAction;
    XML1: TMenuItem;
    btnExit: TToolButton;
    sp: TToolButton;
    dlgOpen1: TOpenDialog;
    procedure actnTryConnectExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure actnXLforGISExecute(Sender: TObject);
    procedure actnXMLforGISExecute(Sender: TObject);
    procedure actnReportsExecute(Sender: TObject);
    procedure actnImportExecute(Sender: TObject);
    procedure actnSaveEditsExecute(Sender: TObject);
    procedure actnSaveEditsUpdate(Sender: TObject);
    procedure actnImportUpdate(Sender: TObject);
    procedure actnEditSimpleDictsExecute(Sender: TObject);
    procedure actnHelpExecute(Sender: TObject);
    procedure actnCloseMainFormExecute(Sender: TObject);
  private
    { Private declarations }
    procedure OnVersionChanged(OldVersion, NewVersion: TVersion);
    procedure OnLicenseZoneChanged(Sender: TObject);
    procedure DoAfterImport(Sender: TObject);
  public
    { Public declarations }
    procedure   ReloadData(Sender: TObject);
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmMain: TfrmMain;

implementation

uses PasswordForm, Facade, GRRClientGISReports, GRRClientXLGISReports, GRRExcelImporter;

{$R *.dfm}


procedure TfrmMain.actnTryConnectExecute(Sender: TObject);
begin
  if TMainFacade.GetInstance.Authorize then
  begin
    TMainFacade.GetInstance.DBGates.FetchPriorities(actnLst);
    frmSelectVersion1.PrepareVersions;
    frmLicenseZoneSelect1.PrepareLicenseZones;
  end;
end;

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;

  (TMainFacade.GetInstance as TMainFacade).Filter := '';
  (TMainFacade.GetInstance as TMainFacade).OnActiveVersionChanged := OnVersionChanged;
  (TMainFacade.GetInstance as TMainFacade).OnActiveLicenseZoneChanged := OnLicenseZoneChanged;

  frmlcnsnfrm1.mmoLicenseNum.Clear;
  frmlcnsnfrm1.mmoOrgName.Clear;
  frmlcnsnfrm1.mmoStartFinishDate.Clear;
end;

procedure TfrmMain.ReloadData(Sender: TObject);
begin
  // здесь перезагружаем куда следует, что следует
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  if not TMainFacade.GetInstance.DBGates.Autorized then actnTryConnect.Execute;
end;

procedure TfrmMain.OnVersionChanged(OldVersion, NewVersion: TVersion);
begin
  frmLicenseZoneSelect1.PrepareLicenseZones;
end;

procedure TfrmMain.OnLicenseZoneChanged(Sender: TObject);
begin
  frmLicenseZoneSelect1.ActiveLicenseZone := TMainFacade.GetInstance.ActiveLicenseZone;
  frmlcnsnfrm1.LicenseZone := TMainFacade.GetInstance.ActiveLicenseZone;
  frmObligationChoice1.LicenseZone := TMainFacade.GetInstance.ActiveLicenseZone;
end;

procedure TfrmMain.actnXLforGISExecute(Sender: TObject);
begin
  if not Assigned(frmGRRClientGISXLReports) then frmGRRClientGISXLReports := TfrmGRRClientGISXLReports.Create(Self);

  frmGRRClientGISXLReports.Prepare;
  frmGRRClientGISXLReports.Show;
end;

procedure TfrmMain.actnXMLforGISExecute(Sender: TObject);
begin
  if not Assigned(frmGISReports) then frmGISReports := TfrmGISReports.Create(Self);

  frmGISReports.Prepare;
  frmGISReports.Show;
end;

procedure TfrmMain.actnReportsExecute(Sender: TObject);
begin
//
end;

procedure TfrmMain.actnImportExecute(Sender: TObject);
var imp: TGRRConditionsImporter;
begin
  if dlgOpen1.Execute then
  begin
    // проверяем, совпадает ли название участка с загруженным
    imp := TGRRConditionsImporter.GetInstance(dlgOpen1.FileName);
    imp.OnChangeActiveLicenseZone := OnLicenseZoneChanged;
    imp.OnAfterImport := DoAfterImport;
    imp.Execute;
    imp.Free;
  end;
end;

procedure TfrmMain.actnSaveEditsExecute(Sender: TObject);
begin
  frmObligationChoice1.Save;
end;

procedure TfrmMain.actnSaveEditsUpdate(Sender: TObject);
begin
  actnSaveEdits.Enabled := Assigned(frmObligationChoice1.LicenseZone) and not frmObligationChoice1.Saved;
end;

procedure TfrmMain.actnImportUpdate(Sender: TObject);
begin
  actnImport.Enabled := Assigned(frmSelectVersion1.ActiveVersion);
end;

procedure TfrmMain.actnEditSimpleDictsExecute(Sender: TObject);
begin
  //
end;

procedure TfrmMain.actnHelpExecute(Sender: TObject);
begin
  //
end;

procedure TfrmMain.actnCloseMainFormExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.DoAfterImport(Sender: TObject);
begin
  frmObligationChoice1.ShowImportedData;
end;

end.


