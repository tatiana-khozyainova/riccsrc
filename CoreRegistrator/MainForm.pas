unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonObjectSelectFilter, ComCtrls, ToolWin, ImgList, ActnList,
  Menus, CRIntervalFrame, CommonReport, XPMan,
  CRWarehouseOrCollectionSelector, ExtCtrls, CRCollectionFrame;

type
  TCoreRegistratorRegime = (crrCore, crrCollections);

  TfrmMain = class(TForm)
    MainMnu: TMainMenu;
    Start: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    nDicts: TMenuItem;
    N5: TMenuItem;
    N10: TMenuItem;
    N4: TMenuItem;
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
    N6: TMenuItem;
    actnSlottingBlankReport: TAction;
    N7: TMenuItem;
    actnMechanicalStateDict: TAction;
    actnPartPlacementDict: TAction;
    actn1: TMenuItem;
    actnPartPlacementsDict: TAction;
    N8: TMenuItem;
    actnClose: TAction;
    actnRockSampleSizeTypeEditor: TAction;
    actnRockSampleType: TAction;
    N9: TMenuItem;
    N11: TMenuItem;
    actnSlottingReport: TAction;
    N12: TMenuItem;
    actnSampleBlankReport: TAction;
    actnSampleReport: TAction;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    actnSampleResearchBlank: TAction;
    N16: TMenuItem;
    actnNGRReport: TAction;
    actnAreaReport: TAction;
    actnPlacementStatReport: TAction;
    actnPlacementReport: TAction;
    actnNGRReportWithoutAreaTotals: TAction;
    actnAreaReportWithoutAreaTotals: TAction;
    frmObjectSelect1: TfrmObjectSelect;
    Splitter1: TSplitter;
    pgctlMain: TPageControl;
    tshCore: TTabSheet;
    frmCoreRegistratorFrame1: TfrmCoreRegistratorFrame;
    tshCollections: TTabSheet;
    actnCoreRegime: TAction;
    actnCollectionsRegime: TAction;
    N24: TMenuItem;
    N25: TMenuItem;
    actnCollectionsRegime1: TMenuItem;
    frmCollections1: TfrmCollections;
    actnFossilTypesDict: TAction;
    actnCollectionTypeDict: TAction;
    N26: TMenuItem;
    N27: TMenuItem;
    actnEtiquettesReport: TAction;
    actnEtiquettesReport1: TMenuItem;
    actnEtiquettesSmallReport: TAction;
    N29: TMenuItem;
    actnGenSectionSlottingReport: TAction;
    actnGenSectionSampleReport: TAction;
    actnGenSectionSlottingBlankReport: TAction;
    N30: TMenuItem;
    N31: TMenuItem;
    N28: TMenuItem;
    actnCoreTransfer: TAction;
    actnCoreTransfer1: TMenuItem;
    N32: TMenuItem;
    N33: TMenuItem;
    N34: TMenuItem;
    N35: TMenuItem;
    N36: TMenuItem;
    N38: TMenuItem;
    N39: TMenuItem;
    N40: TMenuItem;
    N41: TMenuItem;
    N42: TMenuItem;
    N37: TMenuItem;
    N43: TMenuItem;
    N44: TMenuItem;
    N45: TMenuItem;
    N46: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    Action1: TAction;
    N19: TMenuItem;
    actnDistrictReport: TAction;
    actnDistrictReport1: TMenuItem;
    actnCoreTransferFullReport: TAction;
    actnCoreTransferFullReport1: TMenuItem;
    actnRackContentReport: TAction;
    actnRackContentReport1: TMenuItem;
    procedure actnTryConnectExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure actnSlottingBlankReportExecute(Sender: TObject);
    procedure actnMechanicalStateDictExecute(Sender: TObject);
    procedure actnPartPlacementDictExecute(Sender: TObject);
    procedure actnPartPlacementsDictExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actnCloseExecute(Sender: TObject);
    procedure actnCloseMainFormExecute(Sender: TObject);
    procedure actnRockSampleSizeTypeEditorExecute(Sender: TObject);
    procedure actnRockSampleTypeExecute(Sender: TObject);
    procedure actnSlottingReportExecute(Sender: TObject);
    procedure actnSampleReportExecute(Sender: TObject);
    procedure actnSampleBlankReportExecute(Sender: TObject);
    procedure actnSampleResearchBlankExecute(Sender: TObject);
    procedure actnNGRReportExecute(Sender: TObject);
    procedure actnPlacementStatReportExecute(Sender: TObject);
    procedure actnPlacementReportExecute(Sender: TObject);
    procedure actnRegimeSwitcherCoreExecute(Sender: TObject);
    procedure actnRegimeSwitcherCollectionsExecute(Sender: TObject);
    procedure actnCoreRegimeExecute(Sender: TObject);
    procedure actnCollectionsRegimeExecute(Sender: TObject);
    procedure actnFossilTypesDictExecute(Sender: TObject);
    procedure actnCollectionTypeDictExecute(Sender: TObject);
    procedure actnSlottingReportUpdate(Sender: TObject);
    procedure frmButtonsbtnLiqClick(Sender: TObject);
    procedure frmObjectSelect1sbtnExecuteClick(Sender: TObject);
    procedure actnEtiquettesReportExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actnEtiquettesSmallReportExecute(Sender: TObject);
    procedure actnSlottingBlankReportUpdate(Sender: TObject);
    procedure actnSampleBlankReportUpdate(Sender: TObject);
    procedure actnSampleReportUpdate(Sender: TObject);
    procedure actnSampleResearchBlankUpdate(Sender: TObject);
    procedure actnEtiquettesReportUpdate(Sender: TObject);
    procedure actnEtiquettesSmallReportUpdate(Sender: TObject);
    procedure actnGenSectionSlottingReportExecute(Sender: TObject);
    procedure actnGenSectionSlottingReportUpdate(Sender: TObject);
    procedure actnGenSectionSlottingBlankReportExecute(Sender: TObject);
    procedure actnGenSectionSlottingBlankReportUpdate(Sender: TObject);
    procedure actnCoreTransferExecute(Sender: TObject);
    procedure actnDistrictReportExecute(Sender: TObject);
    procedure actnCoreTransferFullReportExecute(Sender: TObject);
    procedure actnRackContentReportExecute(Sender: TObject);
  private
    FRegime: TCoreRegistratorRegime;
    procedure SetRegime(const Value: TCoreRegistratorRegime);
    { Private declarations }
  public
    { Public declarations }
    procedure   ReloadData(Sender: TObject);
    property    RegistratorRegime: TCoreRegistratorRegime read FRegime write SetRegime;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;

  end;

var
  frmMain: TfrmMain;

implementation

uses PasswordForm, Facade, ComObj, BaseObjects, CommonIDObjectListForm,
     CRPartPlacementsEditorForm, IDObjectBaseActions,
     CRSampleSizeTypeEditForm, CRBaseActions, CRReport,
     SDReport, PetrolRegionsEditorForm, AreaListForm, CRSlottingEditForm,
     CRSlottingReportSettings, CommonStepForm, SlottingWell,
     CRCoreLiquidationForm, CRCoreLiqidationFrame, Slotting, GeneralizedSection,
  CRCoreTransferContentsViewForm, CRPetrolRegionsReportFrame,
  CRPartPlacementsReportForm, CRDistrictReportForm,
  CRCoreTransferFullReportForm, CRRackSelectForm;

{$R *.dfm}

procedure TfrmMain.actnTryConnectExecute(Sender: TObject);
begin
  if TMainFacade.GetInstance.Authorize then
  begin
    TMainFacade.GetInstance.DBGates.FetchPriorities(actnLst);
    frmObjectSelect1.Prepare;
    Application.ProcessMessages;
    (TMainFacade.GetInstance as TMainFacade).LoadDicts;
    frmSlottingEdit := TfrmSlottingEdit.Create(Self);
  end;
end;

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;

  (TMainFacade.GetInstance as TMainFacade).Filter := '';


  frmObjectSelect1.OnReloadData := ReloadData;
  tshCore.TabVisible := false;
  tshCore.Visible := true;
  tshCollections.TabVisible := false;
  tshCollections.Visible := false;

end;



procedure TfrmMain.ReloadData(Sender: TObject);
begin
  // здесь перезагружаем куда следует, что следует
  try
    Screen.Cursor := crHourGlass;

    case RegistratorRegime of
    crrCore:
      begin
        frmCoreRegistratorFrame1.trwCoreIntervals.Items.BeginUpdate;
        (TMainFacade.GetInstance as TMainFacade).AllWells.Clear;
        (TMainFacade.GetInstance as TMainFacade).AllWells.Reload(frmObjectSelect1.SQL);
        (TMainFacade.GetInstance as TMainFacade).ClearCoreLibrary;
        frmCoreRegistratorFrame1.ReloadWells;
        frmCoreRegistratorFrame1.trwCoreIntervals.Items.EndUpdate;
      end;
      crrCollections:
      begin
        (TMainFacade.GetInstance as TMainFacade).AllCollectionWells.Clear;
        (TMainFacade.GetInstance as TMainFacade).AllCollectionWells.Reload(frmObjectSelect1.SQL);
        frmCollections1.ReloadWells;
      end
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  if not TMainFacade.GetInstance.DBGates.Autorized then actnTryConnect.Execute;
end;

procedure TfrmMain.actnSlottingBlankReportExecute(Sender: TObject);
begin
  (TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreSlottingBlankReport] as TSDReport).ReportingObject := frmCoreRegistratorFrame1.ActiveWell;
  TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreSlottingBlankReport].Execute;
end;

procedure TfrmMain.actnMechanicalStateDictExecute(Sender: TObject);
begin
  if not Assigned(frmIDObjectList) then frmIDObjectList := TfrmIDObjectList.Create(Self);
  frmIDObjectList.IDObjects := (TMainFacade.GetInstance as TMainFacade).AllMechanicalStates;
  frmIDObjectList.Caption := 'Механическое состояние керна';

  frmIDObjectList.AddActionClass := TIDObjectWithShortNameAddAction;
  frmIDObjectList.EditActionClass := TIDObjectWithShortNameEditAction;
  frmIDObjectList.ShowShortName := true;
   
  frmIDObjectList.ShowModal;
end;

procedure TfrmMain.actnPartPlacementDictExecute(Sender: TObject);
begin
  if not Assigned(frmIDObjectList) then frmIDObjectList := TfrmIDObjectList.Create(Self);
  frmIDObjectList.IDObjects := (TMainFacade.GetInstance as TMainFacade).AllPartPlacementTypes;
  frmIDObjectList.Caption := 'Типы местоположений керна';

  frmIDObjectList.AddActionClass := TIDObjectAddAction;
  frmIDObjectList.EditActionClass := TIDObjectEditAction;
  frmIDObjectList.ShowShortName := false;
  
  frmIDObjectList.ShowModal;
end;

procedure TfrmMain.actnPartPlacementsDictExecute(Sender: TObject);
begin
  if not Assigned(frmPartPlacementsEditor) then frmPartPlacementsEditor := TfrmPartPlacementsEditor.Create(Self);
  frmPartPlacementsEditor.Caption := 'Типы местоположений керна';
  frmPartPlacementsEditor.ShowModal;
end;

destructor TfrmMain.Destroy;
begin
  frmSlottingEdit.Free;
  inherited;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := true;
end;

procedure TfrmMain.actnCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.actnCloseMainFormExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.actnRockSampleSizeTypeEditorExecute(Sender: TObject);
begin
  if not Assigned(frmIDObjectList) then frmIDObjectList := TfrmIDObjectList.Create(Self);
  frmIDObjectList.IDObjects := (TMainFacade.GetInstance as TMainFacade).AllRockSampleSizeTypes;
  frmIDObjectList.Caption := 'Типоразмеры образцов';

  frmIDObjectList.AddActionClass := TRockSampleSizeTypeAddAction;
  frmIDObjectList.EditActionClass := TRockSampleSizeTypeEditAction ;
  frmIDObjectList.ShowShortName := true;

  frmIDObjectList.ShowModal;
end;

procedure TfrmMain.actnRockSampleTypeExecute(Sender: TObject);
begin
  if not Assigned(frmIDObjectList) then frmIDObjectList := TfrmIDObjectList.Create(Self);
  frmIDObjectList.IDObjects := (TMainFacade.GetInstance as TMainFacade).AllRockSampleTypes;
  frmIDObjectList.Caption := 'Типы образцов';

  frmIDObjectList.AddActionClass := TIDObjectAddAction;
  frmIDObjectList.EditActionClass := TIDObjectEditAction;
  frmIDObjectList.ShowShortName := false;

  frmIDObjectList.ShowModal;
end;

procedure TfrmMain.actnSlottingReportExecute(Sender: TObject);
var i: integer;
    frmStep: TfrmStep;
    wls: TSlottingWells;
begin
  if not Assigned(frmSlottingReportSettings) then
    frmSlottingReportSettings := TfrmSlottingReportSettings.Create(Self);

  frmSlottingReportSettings.NoGenSectionSelection := false;

  if frmSlottingReportSettings.ShowModal = mrOk then
  begin
    if (frmCoreRegistratorFrame1.trwCoreIntervals.SelectionCount = 1) then
    begin
      (TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreSlottingReport] as TSDReport).SilentMode := false;
      (TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreSlottingReport] as TSDReport).ReportingObject := frmCoreRegistratorFrame1.ActiveWell;
      (TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreSlottingReport] as TCoreSlottingReport).UseCoreRepositoryStraton := frmSlottingReportSettings.UseCoreRepositoryStrat;
      (TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreSlottingReport] as TCoreSlottingReport).ShowMetersDrilled := frmSlottingReportSettings.ShowMetersDrilled;
      (TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreSlottingReport] as TCoreSlottingReport).UseGenSection := frmSlottingReportSettings.UseGenSection;
      (TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreSlottingReport] as TCoreSlottingReport).SaveReport := frmSlottingReportSettings.SaveResult;
      (TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreSlottingReport] as TCoreSlottingReport).ReportPath := frmSlottingReportSettings.SavingPath;

       TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreSlottingReport].Execute;
    end
    else if (frmCoreRegistratorFrame1.trwCoreIntervals.SelectionCount > 1) then
    begin
      (TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreSlottingReport] as TSDReport).SilentMode := true;

      frmStep := TfrmStep.Create(Self);
      wls := frmCoreRegistratorFrame1.SelectedWells;
      frmStep.InitProgress(0, wls.Count, 1);
      frmStep.ShowLog := true;
      frmStep.Show();

      for i := 0 to wls.Count - 1 do
      begin
        frmStep.MakeStep(wls.Items[i].List(loBrief));
        frmStep.Refresh;
        (TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreSlottingReport] as TSDReport).ReportingObject := wls.Items[i];
        (TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreSlottingReport] as TCoreSlottingReport).UseCoreRepositoryStraton := frmSlottingReportSettings.UseCoreRepositoryStrat;
        (TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreSlottingReport] as TCoreSlottingReport).ShowMetersDrilled := frmSlottingReportSettings.ShowMetersDrilled;
        (TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreSlottingReport] as TCoreSlottingReport).SaveReport := frmSlottingReportSettings.SaveResult;
        (TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreSlottingReport] as TCoreSlottingReport).ReportPath := frmSlottingReportSettings.SavingPath;

        TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreSlottingReport].Execute;
      end;

      FreeAndNil(frmStep);
    end;
  end;
end;

procedure TfrmMain.actnSampleReportExecute(Sender: TObject);
begin
  (TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreSampleReport] as TSDReport).ReportingObject := frmCoreRegistratorFrame1.ActiveWell;
  TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreSampleReport].Execute;
end;

procedure TfrmMain.actnSampleBlankReportExecute(Sender: TObject);
begin
  (TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreSampleBlankReport] as TSDReport).ReportingObject := frmCoreRegistratorFrame1.ActiveWell;
  TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreSampleBlankReport].Execute;
end;

procedure TfrmMain.actnSampleResearchBlankExecute(Sender: TObject);
begin
  (TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreSampleResearchBlankReport] as TSDReport).ReportingObject := frmCoreRegistratorFrame1.ActiveWell;
  TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreSampleResearchBlankReport].Execute;
end;

procedure TfrmMain.actnNGRReportExecute(Sender: TObject);
var repo: TCorePetrolRegionStatReport;
begin
  if not Assigned(frmPetrolRegionsReport) then frmPetrolRegionsReport := TfrmPetrolRegionsReport.Create(Self);

  if frmPetrolRegionsReport.ShowModal = mrOk then
  begin
    repo := TMainFacade.GetInstance.AllReports.ReportByClassType[TCorePetrolRegionStatReport] as TCorePetrolRegionStatReport;
    repo.AreaTotals := frmPetrolRegionsReport.AreaTotals;
    repo.NGRTotals := frmPetrolRegionsReport.NGRTotals;
    repo.NGOTotals := frmPetrolRegionsReport.NGOTotals;
    repo.OverallTotals := frmPetrolRegionsReport.OverallTotal;

    repo.ReportingObjects.Clear;
    repo.ReportingObjects.AddObjects(frmPetrolRegionsReport.SelectedObjects, false, false);
    repo.SaveReport := frmPetrolRegionsReport.SaveResult;
    repo.ReportPath := frmPetrolRegionsReport.SavingPath;
    repo.Execute;
  end;
end;

procedure TfrmMain.actnPlacementStatReportExecute(Sender: TObject);
var repo: TCorePlacementStatReport;
begin
  if not Assigned(frmPartPlacementReportForm) then frmPartPlacementReportForm := TfrmPartPlacementReportForm.Create(Self);
  frmPartPlacementReportForm.Position := poScreenCenter;

  if frmPartPlacementReportForm.ShowModal = mrOk then
  begin
    repo := TMainFacade.GetInstance.AllReports.ReportByClassType[TCorePlacementStatReport] as TCorePlacementStatReport;

    repo.AreaTotals := frmPartPlacementReportForm.AreaTotals;
    repo.PlacementTotals := frmPartPlacementReportForm.PlacementTotals;
    repo.OverallTotals := frmPartPlacementReportForm.OverallTotal;
    
    repo.ReportingObjects.Clear;
    repo.ReportingObjects.AddObjects(frmPartPlacementReportForm.SelectedObjects, false, false);
    repo.SaveReport := frmPartPlacementReportForm.SaveResult;
    repo.ReportPath := frmPartPlacementReportForm.SavingPath;
    repo.Execute;
  end;
end;

procedure TfrmMain.actnPlacementReportExecute(Sender: TObject);
begin
  if not Assigned(frmPartPlacementsEditor) then frmPartPlacementsEditor := TfrmPartPlacementsEditor.Create(Self);
  frmPartPlacementsEditor.Caption := 'Выберите место хранения';
  frmPartPlacementsEditor.MultiSelect := true;
  if frmPartPlacementsEditor.ShowModal = mrOk then
  begin
    (TMainFacade.GetInstance.AllReports.ReportByClassType[TCorePlacementReport] as TSDSQLCollectionReport).ReportingObjects.Clear;
    (TMainFacade.GetInstance.AllReports.ReportByClassType[TCorePlacementReport] as TSDSQLCollectionReport).ReportingObjects.AddObjects(frmPartPlacementsEditor.SelectedObjects, false, false);
    TMainFacade.GetInstance.AllReports.ReportByClassType[TCorePlacementReport].Execute;
  end;
end;

procedure TfrmMain.actnRegimeSwitcherCoreExecute(Sender: TObject);
begin
{  tshCore.Visible := true;
  tshCollections.Visible := false;}
end;

procedure TfrmMain.actnRegimeSwitcherCollectionsExecute(Sender: TObject);
begin
{  tshCore.Visible := false;
  tshCollections.Visible := true;}
end;

procedure TfrmMain.SetRegime(const Value: TCoreRegistratorRegime);
begin
  if FRegime <> Value then
  begin
    FRegime := Value;
    case FRegime of
    crrCore:
    begin
      tshCore.TabVisible := true;
      tshCore.Visible := true;
      tshCollections.TabVisible := false;
      tshCollections.Visible := false;
    end;
    crrCollections:
    begin
      tshCore.TabVisible := false;
      tshCore.Visible := false;
      tshCollections.TabVisible := true;
      tshCollections.Visible := true;

      frmCollections1.PrepareCollections;
    end;
    end;
  end;
end;

procedure TfrmMain.actnCoreRegimeExecute(Sender: TObject);
begin
  RegistratorRegime := crrCore;
end;

procedure TfrmMain.actnCollectionsRegimeExecute(Sender: TObject);
begin
  RegistratorRegime := crrCollections;
end;

procedure TfrmMain.actnFossilTypesDictExecute(Sender: TObject);
begin
  if not Assigned(frmIDObjectList) then frmIDObjectList := TfrmIDObjectList.Create(Self);
  frmIDObjectList.IDObjects := (TMainFacade.GetInstance as TMainFacade).AllFossilTypes;
  frmIDObjectList.Caption := 'Тип органических остатков';

  frmIDObjectList.AddActionClass := TIDObjectEditAction;
  frmIDObjectList.EditActionClass := TIDObjectEditAction;
  frmIDObjectList.ShowShortName := true;

  frmIDObjectList.ShowModal;
end;

procedure TfrmMain.actnCollectionTypeDictExecute(Sender: TObject);
begin
  if not Assigned(frmIDObjectList) then frmIDObjectList := TfrmIDObjectList.Create(Self);
  frmIDObjectList.IDObjects := (TMainFacade.GetInstance as TMainFacade).AllCollectionTypes;
  frmIDObjectList.Caption := 'Тип коллекции';

  frmIDObjectList.AddActionClass := TIDObjectEditAction;
  frmIDObjectList.EditActionClass := TIDObjectEditAction;
  frmIDObjectList.ShowShortName := true;

  frmIDObjectList.ShowModal;
end;

procedure TfrmMain.actnSlottingReportUpdate(Sender: TObject);
begin
  actnSlottingReport.Enabled := Assigned(frmCoreRegistratorFrame1.ActiveWell);
end;

procedure TfrmMain.frmButtonsbtnLiqClick(Sender: TObject);
begin
  if not Assigned(frmCoreLiquidationForm) then
    frmCoreLiquidationForm := TfrmCoreLiquidationForm.Create(Self);

  (frmCoreLiquidationForm.dlg.Frames[0] as TfrmCoreLiquidaton).EditingObject := frmCoreRegistratorFrame1.ActiveWell;

  frmCoreLiquidationForm.ShowModal;
  frmCoreLiquidationForm.Free;
end;

procedure TfrmMain.frmObjectSelect1sbtnExecuteClick(Sender: TObject);
begin
  frmObjectSelect1.sbtnExecuteClick(Sender);

end;

procedure TfrmMain.actnEtiquettesReportExecute(Sender: TObject);
var slts: TSlottings;
begin
  TMainFacade.GetInstance.AllReports.ReportByClassType[TBigEtiquettesReport].SilentMode := false;
  slts := frmCoreRegistratorFrame1.SelectedPresentSlottings;
  TMainFacade.GetInstance.AllReports.ReportByClassType[TBigEtiquettesReport].ReportingObjects.Clear;
  TMainFacade.GetInstance.AllReports.ReportByClassType[TBigEtiquettesReport].ReportingObjects.AddObjects(slts, false, false);
  TMainFacade.GetInstance.AllReports.ReportByClassType[TBigEtiquettesReport].SaveReport := False;
  TMainFacade.GetInstance.AllReports.ReportByClassType[TBigEtiquettesReport].Execute;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TMainFacade.GetInstance.SaveSettings;
end;

procedure TfrmMain.actnEtiquettesSmallReportExecute(Sender: TObject);
var slts: TSlottings;
begin
  TMainFacade.GetInstance.AllReports.ReportByClassType[TSmallEtiquettesReport].SilentMode := false;
  slts := frmCoreRegistratorFrame1.SelectedPresentSlottings;
  TMainFacade.GetInstance.AllReports.ReportByClassType[TSmallEtiquettesReport].ReportingObjects.Clear;
  TMainFacade.GetInstance.AllReports.ReportByClassType[TSmallEtiquettesReport].ReportingObjects.AddObjects(slts, false, false);
  TMainFacade.GetInstance.AllReports.ReportByClassType[TSmallEtiquettesReport].SaveReport := False;
  TMainFacade.GetInstance.AllReports.ReportByClassType[TSmallEtiquettesReport].Execute;
end;

procedure TfrmMain.actnSlottingBlankReportUpdate(Sender: TObject);
begin
  actnSlottingBlankReport.Enabled := Assigned(frmCoreRegistratorFrame1.ActiveWell);
end;

procedure TfrmMain.actnSampleBlankReportUpdate(Sender: TObject);
begin
  actnSampleBlankReport.Enabled := Assigned(frmCoreRegistratorFrame1.ActiveWell);
end;

procedure TfrmMain.actnSampleReportUpdate(Sender: TObject);
begin
  actnSampleReport.Enabled := Assigned(frmCoreRegistratorFrame1.ActiveWell);
end;

procedure TfrmMain.actnSampleResearchBlankUpdate(Sender: TObject);
begin
  actnSampleResearchBlank.Enabled := Assigned(frmCoreRegistratorFrame1.ActiveWell);
end;

procedure TfrmMain.actnEtiquettesReportUpdate(Sender: TObject);
begin
  actnEtiquettesReport.Enabled := Assigned(frmCoreRegistratorFrame1.ActiveWell) or Assigned(frmCoreRegistratorFrame1.ActiveGenSection);
end;

procedure TfrmMain.actnEtiquettesSmallReportUpdate(Sender: TObject);
begin
  actnEtiquettesSmallReport.Enabled := Assigned(frmCoreRegistratorFrame1.ActiveWell) or Assigned(frmCoreRegistratorFrame1.ActiveGenSection);
end;

procedure TfrmMain.actnGenSectionSlottingReportExecute(Sender: TObject);
var gss: TGeneralizedSections;
    i: integer;
begin
  if not Assigned(frmSlottingReportSettings) then
    frmSlottingReportSettings := TfrmSlottingReportSettings.Create(Self);

  frmSlottingReportSettings.NoGenSectionSelection := true;

  if frmSlottingReportSettings.ShowModal = mrOk then
  begin
    if (frmCoreRegistratorFrame1.trwCoreIntervals.SelectionCount = 1) then
    begin
      (TMainFacade.GetInstance.AllReports.ReportByClassType[TGeneralizedSectionCoreSlottingReport] as TSDReport).SilentMode := false;
      (TMainFacade.GetInstance.AllReports.ReportByClassType[TGeneralizedSectionCoreSlottingReport] as TSDReport).ReportingObject := frmCoreRegistratorFrame1.ActiveGenSection;
      (TMainFacade.GetInstance.AllReports.ReportByClassType[TGeneralizedSectionCoreSlottingReport] as TGeneralizedSectionCoreSlottingReport).UseCoreRepositoryStraton := frmSlottingReportSettings.UseCoreRepositoryStrat;
      (TMainFacade.GetInstance.AllReports.ReportByClassType[TGeneralizedSectionCoreSlottingReport] as TGeneralizedSectionCoreSlottingReport).ShowMetersDrilled := frmSlottingReportSettings.ShowMetersDrilled;
      (TMainFacade.GetInstance.AllReports.ReportByClassType[TGeneralizedSectionCoreSlottingReport] as TGeneralizedSectionCoreSlottingReport).SaveReport := frmSlottingReportSettings.SaveResult;
      (TMainFacade.GetInstance.AllReports.ReportByClassType[TGeneralizedSectionCoreSlottingReport] as TGeneralizedSectionCoreSlottingReport).ReportPath := frmSlottingReportSettings.SavingPath;

       TMainFacade.GetInstance.AllReports.ReportByClassType[TGeneralizedSectionCoreSlottingReport].Execute;
    end
    else if (frmCoreRegistratorFrame1.trwCoreIntervals.SelectionCount > 1) then
    begin
      (TMainFacade.GetInstance.AllReports.ReportByClassType[TGeneralizedSectionCoreSlottingReport] as TSDReport).SilentMode := true;

      frmStep := TfrmStep.Create(Self);
      gss := frmCoreRegistratorFrame1.SelectedGenSections;
      frmStep.InitProgress(0, gss.Count, 1);
      frmStep.ShowLog := true;
      frmStep.Show();

      for i := 0 to gss.Count - 1 do
      begin
        frmStep.MakeStep(gss.Items[i].List(loBrief));
        frmStep.Refresh;
        (TMainFacade.GetInstance.AllReports.ReportByClassType[TGeneralizedSectionCoreSlottingReport] as TSDReport).ReportingObject := gss.Items[i];
        (TMainFacade.GetInstance.AllReports.ReportByClassType[TGeneralizedSectionCoreSlottingReport] as TGeneralizedSectionCoreSlottingReport).UseCoreRepositoryStraton := frmSlottingReportSettings.UseCoreRepositoryStrat;
        (TMainFacade.GetInstance.AllReports.ReportByClassType[TGeneralizedSectionCoreSlottingReport] as TGeneralizedSectionCoreSlottingReport).ShowMetersDrilled := frmSlottingReportSettings.ShowMetersDrilled;
        (TMainFacade.GetInstance.AllReports.ReportByClassType[TGeneralizedSectionCoreSlottingReport] as TGeneralizedSectionCoreSlottingReport).SaveReport := frmSlottingReportSettings.SaveResult;
        (TMainFacade.GetInstance.AllReports.ReportByClassType[TGeneralizedSectionCoreSlottingReport] as TGeneralizedSectionCoreSlottingReport).ReportPath := frmSlottingReportSettings.SavingPath;

        TMainFacade.GetInstance.AllReports.ReportByClassType[TGeneralizedSectionCoreSlottingReport].Execute;
      end;

      FreeAndNil(frmStep);
    end;
  end;
end;

procedure TfrmMain.actnGenSectionSlottingReportUpdate(Sender: TObject);
begin
  actnGenSectionSlottingReport.Enabled := Assigned(frmCoreRegistratorFrame1.ActiveGenSection);
end;

procedure TfrmMain.actnGenSectionSlottingBlankReportExecute(
  Sender: TObject);
begin
  (TMainFacade.GetInstance.AllReports.ReportByClassType[TGeneralizedSectionCoreSlottingBlankReport] as TSDReport).ReportingObject := frmCoreRegistratorFrame1.ActiveGenSection;
  TMainFacade.GetInstance.AllReports.ReportByClassType[TGeneralizedSectionCoreSlottingBlankReport].Execute;
end;

procedure TfrmMain.actnGenSectionSlottingBlankReportUpdate(
  Sender: TObject);
begin
  actnGenSectionSlottingBlankReport.Enabled := Assigned(frmCoreRegistratorFrame1.ActiveGenSection);
end;

procedure TfrmMain.actnCoreTransferExecute(Sender: TObject);
begin
  if not Assigned(frmContentsViewForm) then frmContentsViewForm := TfrmContentsViewForm.Create(Self);
  frmContentsViewForm.Position := poMainFormCenter;

  frmContentsViewForm.ShowModal;
end;

procedure TfrmMain.actnDistrictReportExecute(Sender: TObject);
var repo: TCoreDistrictStatReport;
begin

  if not Assigned(frmDistrictReportForm) then frmDistrictReportForm := TfrmDistrictReportForm.Create(Self);

  if frmDistrictReportForm.ShowModal = mrOk then
  begin
    repo := TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreDistrictStatReport] as TCoreDistrictStatReport;
    repo.AreaTotals := frmDistrictReportForm.AreaTotals;
    repo.DistrictTotals := frmDistrictReportForm.DistrictTotals;
    repo.OverallTotals := frmDistrictReportForm.OverallTotal;

    repo.ReportingObjects.Clear;
    repo.ReportingObjects.AddObjects(frmDistrictReportForm.SelectedObjects, false, false);
    repo.SaveReport := frmDistrictReportForm.SaveResult;
    repo.ReportPath := frmDistrictReportForm.SavingPath;
    repo.Execute;
  end;
end;

procedure TfrmMain.actnCoreTransferFullReportExecute(Sender: TObject);
var repo: TCoreTransferFullReport;
begin
  if not Assigned(frmCoreTransferFullReport) then frmCoreTransferFullReport := TfrmCoreTransferFullReport.Create(Self);


  if frmCoreTransferFullReport.ShowModal = mrOk then
  begin
    if frmCoreTransferFullReport.UseFilterWells then
    begin
      repo := TMainFacade.GetInstance.AllReports.ReportByClassType[ TCoreTransferFullReportForWells] as TCoreTransferFullReport;
      repo.ReportingObjects.Clear;
      repo.ReportingObjects.AddObjects(TMainFacade.GetInstance.AllWells, false, false);
    end
    else
    begin
      repo := TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreTransferFullReport] as TCoreTransferFullReport;

    end;

    repo.SaveReport := frmCoreTransferFullReport.SaveResult;
    repo.ReportPath := frmCoreTransferFullReport.SavingPath;
    repo.Execute;
  end;
end;

procedure TfrmMain.actnRackContentReportExecute(Sender: TObject);
var repo: TRackContentBlankReport;
begin
  if not Assigned(frmRackSelectForm) then frmRackSelectForm := TfrmRackSelectForm.Create(Self);

  if frmRackSelectForm.ShowModal = mrOk then
  begin
    if frmRackSelectForm.NeedsBlank then
      repo := TMainFacade.GetInstance.AllReports.ReportByClassType[TRackContentBlankReport] as TRackContentBlankReport
    else
      repo := TMainFacade.GetInstance.AllReports.ReportByClassType[TRackContentReport] as TRackContentBlankReport;

    repo.SaveReport := frmRackSelectForm.SaveResult;
    repo.ReportPath := frmRackSelectForm.SavingPath;
    repo.EmptyReportingObjects := true;
    repo.RackNum := frmRackSelectForm.SelectedRack;
    repo.RackRomanNum := frmRackSelectForm.SelectedRackRomanNumber;
    repo.Execute;
  end;
end;

end.


