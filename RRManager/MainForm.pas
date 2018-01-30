unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, ToolWin, ComCtrls, Menus, ComObj, StdCtrls, Buttons, ExtCtrls,
  CommonFilter, ImgList, RRmanagerLoaderCommands,
  RRManagerPersistentObjects, RRManagerMainTreeFrame, RRManagerBaseObjects,
  RRManagerCommon, RRManagerObjects, CommonObjectSelectFilter,
  RRManagerQuickViewFrame, RRManagerMapViewForm,
  RRManagerStructureHistoryFrame, RRManagerQuickMapViewFrame,
  ClientCommon, RRManagerObjectVersionFrame, RRManagerComplexQuickViewFrame,
  RRManagerLicenseZoneListFrame, RRManagerBaseGUI, BaseObjects, Version
  {$IFDEF VER150}
  ,Variants, CommonVersionSelectFrame
  {$ENDIF}
  ;
  { TODO :
    Версии потом надо будет нормально разделить - чтобы была видимость отдельного
    клиента для структур и месторождений и для лицензионных участков }
  {$DEFINE LIC}
  //{$DEFINE STRUCT}


type
  TfrmMain = class(TForm)
    mnu: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    actnlst: TActionList;
    TryToConnect: TAction;
    CloseForm: TAction;
    N4: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    gbxAll: TGroupBox;
    pnlRight: TPanel;
    ReloadAction: TAction;
    N8: TMenuItem;
    SelectAll: TAction;
    N10: TMenuItem;
    pmiSelectAll: TMenuItem;
    About: TAction;
    DeselectAll: TAction;
    imgLst: TImageList;
    N12: TMenuItem;
    pmiDeselectAll: TMenuItem;
    pmn: TPopupMenu;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    spltRight: TSplitter;
    ShowLevel: TAction;
    pmiLevel: TMenuItem;
    ShowStructures: TAction;
    ShowHorizons: TAction;
    ShowSubstructures: TAction;
    ShowLayers: TAction;
    Level: TAction;
    ShowBeds: TAction;
    pmiItem: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    sbr: TStatusBar;
    pnlMiddle: TPanel;
    ShowHistory: TAction;
    N9: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    pnlAllRight: TPanel;
    frmQuickView1: TfrmQuickView;
    QuickViewMap1: TMenuItem;
    ViewBasket: TAction;
    N27: TMenuItem;
    ViewBasket1: TMenuItem;
    frmObjectSelect: TfrmObjectSelect;
    spltLic: TSplitter;
    pnlAll: TPanel;
    pgctlMainView: TPageControl;
    tshStructures: TTabSheet;
    pnlStruct: TPanel;
    frmMainTree1: TfrmMainTree;
    frmViewHistory: TfrmViewHistory;
    tshLicenseList: TTabSheet;
    frmLicenseZoneList: TfrmLicenseZoneList;
    tbbr: TToolBar;
    tlbrMain: TToolBar;
    ToolButton3: TToolButton;
    ToolButton7: TToolButton;
    ToolButton5: TToolButton;
    tlbrReload: TToolBar;
    ToolButton1: TToolButton;
    ToolButton4: TToolButton;
    ToolButton2: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    tlbrReport: TToolBar;
    pnlSettings: TPanel;
    Label2: TLabel;
    sbtnFix: TSpeedButton;
    sbtnUIN: TSpeedButton;
    cmbxListOption: TComboBox;
    actnShowVersion: TAction;
    N5: TMenuItem;
    N11: TMenuItem;
    actnBlankLicense: TAction;
    N13: TMenuItem;
    actnBlankDrillingResults: TAction;
    actnSeismicResults: TAction;
    actnNIRResults: TAction;
    N21: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    N30: TMenuItem;
    frmObjectVersion1: TfrmSelectVersion;
    actnLicenseHolderReport: TAction;
    N31: TMenuItem;
    actnLicenseHolderReport1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure TryToConnectExecute(Sender: TObject);
    procedure CloseFormExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ReloadActionExecute(Sender: TObject);
    procedure AboutExecute(Sender: TObject);
    procedure SelectAllExecute(Sender: TObject);
    procedure DeselectAllExecute(Sender: TObject);
    procedure WordReportExecute(Sender: TObject);
    procedure lwWellsCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lwWellsColumnClick(Sender: TObject; Column: TListColumn);
    procedure SelectAllUpdate(Sender: TObject);
    procedure DeselectAllUpdate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ShowLevelExecute(Sender: TObject);
    procedure ShowStructuresExecute(Sender: TObject);
    procedure ShowHorizonsExecute(Sender: TObject);
    procedure ShowSubstructuresExecute(Sender: TObject);
    procedure ShowLayersExecute(Sender: TObject);
    procedure ShowBedsExecute(Sender: TObject);
    procedure LevelExecute(Sender: TObject);
    procedure ShowHistoryExecute(Sender: TObject);
    procedure ViewMapExecute(Sender: TObject);
    procedure ViewMapHide(Sender: TObject);
    procedure QuickViewMapExecute(Sender: TObject);
    procedure ViewBasketExecute(Sender: TObject);
    procedure cmbxListOptionChange(Sender: TObject);
    procedure sbtnFixClick(Sender: TObject);
    procedure sbtnUINClick(Sender: TObject);
    procedure actnShowVersionExecute(Sender: TObject);
    procedure frmMainTree1cmbxFilterChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure frmMainTree1chbxShowBalancedOnlyClick(Sender: TObject);
    procedure actnBlankLicenseExecute(Sender: TObject);
    procedure actnBlankLicenseUpdate(Sender: TObject);
    procedure actnBlankDrillingResultsExecute(Sender: TObject);
    procedure actnBlankDrillingResultsUpdate(Sender: TObject);
    procedure actnSeismicResultsExecute(Sender: TObject);
    procedure actnSeismicResultsUpdate(Sender: TObject);
    procedure actnNIRResultsExecute(Sender: TObject);
    procedure actnNIRResultsUpdate(Sender: TObject);
    procedure actnLicenseHolderReportExecute(Sender: TObject);

  private
    { Private declarations }

    //vWells: variant;
    //AllWells: TWells;
    //procedure ClearWells;
    FOnChangeListOption: TNotifyEvent;
    procedure onReloadStructures(Sender: TObject);
    procedure onChangeStructures(Sender: TObject);
    procedure FormsFree;
    procedure CreateAll;
    procedure actnListDisable;
    //procedure ResendMesage(var Message: TMessage); message WM_SELECTION_CHANGED;
    function  CheckedCount: integer;
    procedure ItemChanged(Sender: TObject);
    procedure ArchiveCreated(Sender: TObject);
    procedure SimpleFormHide(Sender: TObject);
    procedure VersionChanged(OldVersion, NewVersion: TVersion);
  public
    { Public declarations }
    ColumnToSort: integer;
    property OnChangeListOption: TNotifyEvent read FOnChangeListOption write FOnChangeListOption;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmMain: TfrmMain;

implementation

uses PasswordForm, Facade,
     ClientProgressBarForm,  AboutForm, RRManagerDictEditor,
     RRManagerReportForm, RRManagerBasketForm,
     RRManagerObjectVersionCreationForm, Load, LicenseZoneReports;


{$R *.DFM}

function CompareFloat(const F1, F2: single): integer;
begin
  Result := 0;
  if F1 > F2 then Result := 1
  else if F1 = F2 then Result := 0
  else if F1 < F2 then Result := -1;
end;

function CompareWellNum(const S1, S2: string): integer;
var I1, I2: integer;
begin
  Result := 0;
  try
    I1 := StrToInt(S1)
  except
    Result := -1;
    exit;
  end;

  try
    I2 := StrToInt(S2)
  except
    Result := 1;
    exit;
  end;


  if I1 > I2 then Result := 1
  else if I1 = I2 then Result := 0
  else if I1 < I2 then Result := -1;
end;



{procedure TfrmSubDividerMain.ResendMesage(var Message: TMessage);
begin
  SendMessage(frmEditAll.Handle, WM_SELECTION_CHANGED, Message.WParam, Message.LParam);
end;}


procedure TfrmMain.actnListDisable;
var i: integer;
begin
  for i:=0 to actnLst.ActionCount - 1 do
  with actnLst.Actions[i] as TAction do
  if Tag>0 then
  begin
    Visible:=false;
    Enabled:=false;
  end;
end;

procedure TfrmMain.CreateAll;
//    sFrom: string;
begin
  cmbxListOption.ItemIndex := 1;
  AllOpts.Current.ListOption := loMedium;

  // загрузить все версии
  //frmObjectVersion1.OnChangeVersion := onReloadStructures;




  frmObjectSelect.Prepare;
  frmObjectSelect.OnReloadData := onReloadStructures;
  gbxAll.Enabled := true;

  {$IFDEF STRUCT}
  frmMainTree1.Structures := (TMainFacade.GetInstance as TMainFacade).AllStructures;
  frmMainTree1.OnChangeStructures := onChangeStructures;
  frmMainTree1.AddExternalToolbar(tlbrReport);
  frmMainTree1.FillExternalToolBars;
  frmMainTree1.OnCreateArchive := ArchiveCreated;

  frmReport := TfrmReport.Create(Self);
  frmReport.AfterHide := SimpleFormHide;


  mnu.Merge(frmMainTree1.Menus['mnActions'] as TMainMenu);
  frmMainTree1.OnChangeItem := ItemChanged;

  frmVersionInfo := TfrmVersionInfo.Create(Self);
  frmVersionInfo.OnHide := SimpleFormHide;
  {$ENDIF}


  {$IFDEF LIC}
  frmLicenseZoneList.LicenseZones := (TMainFacade.GetInstance as TMainFacade).AllOldLicenseZones;
  frmLicenseZoneList.OnChangeItem := ItemChanged;
  mnu.Merge(frmLicenseZoneList.Menus['mnLicenseActions'] as TMainMenu);
  ShowHistory.Visible := false;
  pmiItem.Visible := false;
  pmiLevel.Visible := false;
  pmiSelectAll.Visible := false;
  pmiDeselectAll.Visible := false;

  {$ENDIF}
end;



{procedure TfrmMain.ClearWells;
begin
  //AllWells.Clear;
end;}




procedure TfrmMain.FormsFree;
begin

  gbxAll.Enabled := false;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  tshLicenseList.TabVisible := false;
  tshStructures.TabVisible := false;

  {$IFDEF STRUCT}
  tshLicenseList.Visible := false;
  pgctlMainView.ActivePage := tshStructures;
  {$ENDIF}

  {$IFDEF LIC}
  tshStructures.Visible := false;
  pgctlMainView.ActivePage := tshLicenseList;


  //pnlSettings.Visible := false;
  {$ENDIF}

  frmViewHistory.Visible := false;
  frmObjectVersion1.Visible := true;
end;

procedure TfrmMain.TryToConnectExecute(Sender: TObject);
var iErrorCode: integer;
begin
  if TMainFacade.GetInstance.Authorize then
  begin
    TMainFacade.GetInstance.DBGates.FetchPriorities(actnLst);


     Application.ProcessMessages;
     TfrmLoad.GetInstance.Load(aviFindFile, 'Пожалуйста, подождите', 1, 3);
    (TMainFacade.GetInstance as TMainFacade).LoadDicts;
     TfrmLoad.GetInstance.MakeStep('Загрузка вспомогательных справочников');
     CreateAll;
     TfrmLoad.GetInstance.MakeStep('Подготовка к работе');
     frmObjectSelect.Reload(-1);
     frmObjectVersion1.PrepareVersions;
     TfrmLoad.GetInstance.Hide;
  end;

end;


procedure TfrmMain.CloseFormExecute(Sender: TObject);
begin
  Close;
end;



procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FormsFree;
end;

procedure TfrmMain.ReloadActionExecute(Sender: TObject);
begin
  frmObjectSelect.Reload(-1);
end;

procedure TfrmMain.AboutExecute(Sender: TObject);
begin
 if not Assigned(frmAbout) then frmAbout := TfrmAbout.Create(Self);
 frmAbout.ShowModal;
end;

procedure TfrmMain.SelectAllExecute(Sender: TObject);
//var i: integer;
begin
{  for i := 0 to lwWells.Items.Count - 1 do
    lwWells.Items[i].Checked := true;}
end;

procedure TfrmMain.DeselectAllExecute(Sender: TObject);
//var i: integer;
begin
{  for i := 0 to lwWells.Items.Count - 1 do
    lwWells.Items[i].Checked := false;}
end;



procedure TfrmMain.WordReportExecute(Sender: TObject);
begin
//
end;

function  TfrmMain.CheckedCount: integer;
//var i: integer;
begin
  Result := 0;
{  for i := 0 to lwWells.Items.Count - 1 do
    Result := Result + ord(lwWells.Items[i].Checked);}
end;


procedure TfrmMain.lwWellsCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var i: integer;
begin
  i := ColumnToSort - 1;
  if ColumnToSort = 0 then
    Compare := CompareWellNum(Item1.Caption,Item2.Caption)
  else
  if ColumnToSort = 1 then
    Compare := CompareText(Item1.Caption,Item2.Caption)
  else
  if ColumnToSort in [2, 3] then
    Compare := CompareFloat(StrToFloat(Item1.SubItems[i]), StrToFloat(Item2.SubItems[i]))
end;

procedure TfrmMain.lwWellsColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  ColumnToSort := Column.Index;
//  lwWells.AlphaSort;
end;

procedure TfrmMain.SelectAllUpdate(Sender: TObject);
begin
//  SelectAll.Enabled := lwWells.Items.Count > 0;
end;

procedure TfrmMain.DeselectAllUpdate(Sender: TObject);
begin
  DeselectAll.Enabled := CheckedCount > 0;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  Caption := Application.Title; 
end;

procedure TfrmMain.onReloadStructures(Sender: TObject);
var sFilterSQL: string;
begin
  //frmComplexMapQuickView1.Clear;
  sFilterSQL := frmObjectSelect.SQL;

  {$IFDEF STRUCT}
  frmMainTree1.cmbxFilter.ItemIndex := 0;
  frmMainTree1.DeselectAllAction.Execute;

  if sFilterSQL <> '' then frmMainTree1.StructureLoadAction.Execute('(' + sFilterSQL + ') and (' + frmObjectVersion1.SQL + ')')
  else frmMainTree1.StructureLoadAction.Execute('');

  frmMainTree1.FilterID := frmObjectSelect.FilterID;
  frmMainTree1.FilterValues := frmObjectSelect.FilterValues;

  sbr.Panels[1].Text := 'Cтруктур: ' + IntToStr(TMainFacade.GetInstance.AllStructures.Count);
  {$ENDIF STRUCT}

  {$IFDEF LIC}
  frmLicenseZoneList.DeselectAllAction.Execute;

  if sFilterSQL <> '' then frmLicenseZoneList.LicenseZoneLoadAction.Execute('(' + sFilterSQL + ') and (Version_ID = ' + IntToStr(TMainFacade.GetInstance.ActiveVersion.Id) + ')')
  else frmLicenseZoneList.LicenseZoneLoadAction.Execute('');

  frmLicenseZoneList.FilterID := frmObjectSelect.FilterID;
  frmLicenseZoneList.FilterValues := frmObjectSelect.FilterValues;

  sbr.Panels[1].Text := 'Лицензионных участков: ' + IntToStr(TMainFacade.GetInstance.AllLicenseZones.Count);

  {$ENDIF LIC}
end;

procedure TfrmMain.ItemChanged(Sender: TObject);
var bo: TBaseObject;
begin
  if Assigned(Sender) then
  begin
    if Sender is TBaseObject then
    begin
      bo := Sender as TBaseObject;
      bo.Accept(IConcreteVisitor(frmQuickView1));
      bo.Accept(IConcreteVisitor(frmViewHistory));
      if Assigned(frmViewFundMap) and frmViewFundMap.Visible then
        bo.Accept(IConcreteVisitor(frmViewFundMap));
    end
    else
    begin
      frmQuickView1.Clear;
      frmViewHistory.Clear;
    end;
  end
  else
  begin
    frmQuickView1.Clear;
    frmViewHistory.Clear;
  end;
end;

procedure TfrmMain.ShowLevelExecute(Sender: TObject);
begin
  ShowLevel.Checked := not ShowLevel.Checked;
end;

procedure TfrmMain.ShowStructuresExecute(Sender: TObject);
begin
  ShowStructures.Checked := true;
  ShowHorizons.Checked := false;
  ShowSubstructures.Checked := false;
  ShowLayers.Checked := false;
  ShowBeds.Checked := false;

end;

procedure TfrmMain.ShowHorizonsExecute(Sender: TObject);
begin
  ShowStructures.Checked := false;
  ShowHorizons.Checked := true;
  ShowSubstructures.Checked := false;
  ShowLayers.Checked := false;
  ShowBeds.Checked := false;

end;

procedure TfrmMain.ShowSubstructuresExecute(Sender: TObject);
begin
  ShowStructures.Checked := false;
  ShowHorizons.Checked := false;
  ShowSubstructures.Checked := true;
  ShowLayers.Checked := false;
  ShowBeds.Checked := false;

end;

procedure TfrmMain.ShowLayersExecute(Sender: TObject);
begin
  ShowStructures.Checked := false;
  ShowHorizons.Checked := false;
  ShowSubstructures.Checked := false;
  ShowLayers.Checked := true;
  ShowBeds.Checked := false;

end;

procedure TfrmMain.ShowBedsExecute(Sender: TObject);
begin
  ShowStructures.Checked := false;
  ShowHorizons.Checked := false;
  ShowSubstructures.Checked := false;
  ShowLayers.Checked := false;
  ShowBeds.Checked := true;

end;

procedure TfrmMain.LevelExecute(Sender: TObject);
begin
 //
end;

procedure TfrmMain.onChangeStructures(Sender: TObject);
begin
  sbr.Panels[1].Text := 'Cтруктур: ' + IntToStr(TMainFacade.GetInstance.AllStructures.Count);
end;

procedure TfrmMain.ShowHistoryExecute(Sender: TObject);
begin
  //
  ShowHistory.Checked := not ShowHistory.Checked;
  frmViewHistory.Visible := ShowHistory.Checked;

end;

procedure TfrmMain.ViewMapExecute(Sender: TObject);
begin
  //ViewMap.Checked := not ViewMap.Checked;

  {if ViewMap.Checked then
  if not Assigned(frmViewFundMap) then frmViewFundMap := TfrmViewFundMap.Create(Self);

  frmViewFundMap.Visible := ViewMap.Checked;
  frmViewFundMap.OnHide := ViewMapHide;}
  ItemChanged(nil);
end;


procedure TfrmMain.ViewMapHide(Sender: TObject);
begin
  //ViewMap.Checked := false;
end;

procedure TfrmMain.QuickViewMapExecute(Sender: TObject);
begin
  (* if Assigned(frmMainTree1.Structure) then frmMainTree1.Structure.Accept(IConcreteVisitor(frmComplexMapQuickView1))
  else frmComplexMapQuickView1.Clear; *)
end;

procedure TfrmMain.ViewBasketExecute(Sender: TObject);
begin
  //
  if not Assigned(frmBasketView) then frmBasketView := TfrmBasketView.Create(self);
  frmBasketView.ShowModal;
end;


procedure TfrmMain.ArchiveCreated(Sender: TObject);
begin
  //frmObjectVersion1.Reload;
end;


procedure TfrmMain.SimpleFormHide(Sender: TObject);
begin
  mnu.Merge(frmMainTree1.Menus['mnActions'] as TMainMenu);
end;

procedure TfrmMain.cmbxListOptionChange(Sender: TObject);
begin
  if cmbxListOption.ItemIndex <> ord(AllOpts.Current.ListOption) then
  begin

    case cmbxListOption.ItemIndex of
    0: AllOpts.Current.ListOption := loBrief;
    1: AllOpts.Current.ListOption := loMedium;
    2: AllOpts.Current.ListOption := loFull;
    end;
  end;

  if Assigned(FOnChangeListOption) then FOnChangeListOption(Sender);
end;

procedure TfrmMain.sbtnFixClick(Sender: TObject);
begin
  AllOpts.Current.FixVisualization := sbtnFix.Down;
end;

procedure TfrmMain.sbtnUINClick(Sender: TObject);
begin
  AllOpts.Current.ShowUINs := sbtnUIN.Down;
end;

procedure TfrmMain.actnShowVersionExecute(Sender: TObject);
begin
  frmObjectVersion1.Visible := actnShowVersion.Checked;
end;

procedure TfrmMain.frmMainTree1cmbxFilterChange(Sender: TObject);
begin
  frmMainTree1.cmbxFilterChange(Sender);

end;

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;
  TMainFacade.GetInstance.OnActiveVersionChanged := VersionChanged;
  TMainFacade.GetInstance.VersionFilter := '(VERSION_ID in (SELECT VERSION_ID from TBL_LICENSE_ZONE_DICT))';
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  if not TMainFacade.GetInstance.DBGates.Autorized then
    TryToConnect.Execute;
end;

procedure TfrmMain.frmMainTree1chbxShowBalancedOnlyClick(Sender: TObject);
begin
  frmMainTree1.cmbxFilterChange(Sender);
  frmObjectSelect.Reload(-1);
end;

procedure TfrmMain.actnBlankLicenseExecute(Sender: TObject);
var LR: TLicenseZoneBlankReport;
begin
  LR := TLicenseZoneBlankReport.Create(nil);
  LR.ReportPath := ExtractFileDir(ParamStr(0));
  LR.MakeVisible := false;
  LR.ReportingObjects.Clear;
  LR.ReportingObjects.Add(frmLicenseZoneList.ActiveLivenseZone, False, False);
  LR.Execute;
  LR.Free;
end;

procedure TfrmMain.actnBlankLicenseUpdate(Sender: TObject);
begin
  actnBlankLicense.Enabled := Assigned(frmLicenseZoneList.ActiveLivenseZone);
end;

procedure TfrmMain.actnBlankDrillingResultsExecute(Sender: TObject);
var LR: TDrillingResultBlankReport;
begin
  LR := TDrillingResultBlankReport.Create(nil);
  LR.ReportPath := ExtractFileDir(ParamStr(0));
  LR.MakeVisible := false;
  LR.ReportingObjects.Clear;
  LR.ReportingObjects.Add(frmLicenseZoneList.ActiveLivenseZone, False, False);
  LR.Execute;
  LR.Free;
end;

procedure TfrmMain.actnBlankDrillingResultsUpdate(Sender: TObject);
begin
  actnBlankDrillingResults.Enabled := Assigned(frmLicenseZoneList.ActiveLivenseZone);
end;

procedure TfrmMain.actnSeismicResultsExecute(Sender: TObject);
var LR: TSeismicResultBlankReport;
begin
  LR := TSeismicResultBlankReport.Create(nil);
  LR.ReportPath := ExtractFileDir(ParamStr(0));
  LR.MakeVisible := false;
  LR.ReportingObjects.Clear;
  LR.ReportingObjects.Add(frmLicenseZoneList.ActiveLivenseZone, False, False);
  LR.Execute;
  LR.Free;
end;

procedure TfrmMain.actnSeismicResultsUpdate(Sender: TObject);
begin
  actnSeismicResults.Enabled := Assigned(frmLicenseZoneList.ActiveLivenseZone);
end;

procedure TfrmMain.actnNIRResultsExecute(Sender: TObject);
var LR: TNIRResultBlankReport;
begin
  LR := TNIRResultBlankReport.Create(nil);
  LR.ReportPath := ExtractFileDir(ParamStr(0));
  LR.MakeVisible := false;
  LR.ReportingObjects.Clear;
  LR.ReportingObjects.Add(frmLicenseZoneList.ActiveLivenseZone, False, False);
  LR.Execute;
  LR.Free;
end;

procedure TfrmMain.actnNIRResultsUpdate(Sender: TObject);
begin
  actnNIRResults.Enabled := Assigned(frmLicenseZoneList.ActiveLivenseZone);
end;

procedure TfrmMain.VersionChanged(OldVersion, NewVersion: TVersion);
begin
  frmObjectSelect.Reload(-1);
  onReloadStructures(Self);
  onChangeStructures(Self);
end;

procedure TfrmMain.actnLicenseHolderReportExecute(Sender: TObject);
var LR: TLicenseHolderReport;
begin
  LR := TLicenseHolderReport.Create(nil);
  LR.ReportPath := ExtractFileDir(ParamStr(0));
  LR.MakeVisible := false;
  LR.ReportingObjects.Clear;
  LR.ReportingObjects.Add(TMainFacade.GetInstance.ActiveVersion, False, False);
  LR.Execute;
  LR.Free;
end;

end.
