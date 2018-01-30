unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, Menus, ImgList, ActnList,
  CommonObjectSelectFilter, InfoObjectFrame;

type
  TfrmMain = class(TForm)
    actnLst: TActionList;
    actnTryConnect: TAction;
    actnExit: TAction;
    actnHelp: TAction;
    actnAddWell: TAction;
    actnDelWell: TAction;
    actnOptions: TAction;
    imgLst: TImageList;
    mm: TMainMenu;
    Gky1: TMenuItem;
    N15: TMenuItem;
    N17: TMenuItem;
    N2: TMenuItem;
    N4: TMenuItem;
    ToolBar: TToolBar;
    ToolButton2: TToolButton;
    ToolButton1: TToolButton;
    ToolButton11: TToolButton;
    ToolButton3: TToolButton;
    ToolButton6: TToolButton;
    ToolButton4: TToolButton;
    N1: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    sbr: TStatusBar;
    frmObjectSelect: TfrmObjectSelect;
    frmInfoObject: TfrmInfoObject;
    actnAreaDict: TAction;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    actnStateDict: TAction;
    actnCategoryDict: TAction;
    actnAddCoord: TAction;
    N11: TMenuItem;
    actnEditWell: TAction;
    N12: TMenuItem;
    N18: TMenuItem;
    N16: TMenuItem;
    actnEditInfoWell: TAction;
    actnEditInfoWellBinding: TAction;
    actnEditInfoWellParametrs: TAction;
    N19: TMenuItem;
    N20: TMenuItem;
    ToolButton5: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    actnShowDinamics: TAction;
    btnWellDinamic: TToolButton;
    btn2: TToolButton;
    btn3: TToolButton;
    actnWellDinamic: TAction;
    btnFind: TToolButton;
    actnFind: TAction;
    actnSourseCoordDict: TAction;
    N22: TMenuItem;
    N23: TMenuItem;
    btn1: TToolButton;
    btnReport: TToolButton;
    actnReport: TAction;
    N21: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    actnRebindWells: TAction;
    ArcGis1: TMenuItem;
    actnLoadCoords: TAction;
    N26: TMenuItem;
    N27: TMenuItem;
    procedure FormActivate(Sender: TObject);
    procedure actnTryConnectExecute(Sender: TObject);
    procedure actnAddWellExecute(Sender: TObject);
    procedure actnAreaDictExecute(Sender: TObject);
    procedure actnStateDictExecute(Sender: TObject);
    procedure actnCategoryDictExecute(Sender: TObject);
    procedure actnAddCoordExecute(Sender: TObject);
    procedure actnEditWellExecute(Sender: TObject);
    procedure actnEditInfoWellExecute(Sender: TObject);
    procedure actnEditInfoWellBindingExecute(Sender: TObject);
    procedure actnEditInfoWellParametrsExecute(Sender: TObject);
    procedure actnShowDinamicsExecute(Sender: TObject);
    procedure frmInfoWellstvwWellsDblClick(Sender: TObject);
    procedure actnFindExecute(Sender: TObject);
    procedure actnDelWellExecute(Sender: TObject);
    procedure actnSourseCoordDictExecute(Sender: TObject);
    procedure actnReportExecute(Sender: TObject);
    procedure actnDelWellUpdate(Sender: TObject);
    procedure actnEditWellUpdate(Sender: TObject);
    procedure actnEditInfoWellUpdate(Sender: TObject);
    procedure actnEditInfoWellBindingUpdate(Sender: TObject);
    procedure actnEditInfoWellParametrsUpdate(Sender: TObject);
    procedure actnAddCoordUpdate(Sender: TObject);
    procedure actnExitExecute(Sender: TObject);
  private
    { Private declarations }
  public
    procedure   ReloadWells(Sender: TObject);

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmMain: TfrmMain;

implementation

uses Facade, PasswordForm, PWEditorWell, AllObjectsFrame, AllUnits,
     SDFacade, PWEditInfoCoordWell, PWEditInfoWell, PWEditInfoWellBinding,
     PWEditInfoWellParametrs, Well, Load,
     PWInfoWellFrame, PWSearchingWell, PWReportWells, Area;

{$R *.dfm}

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  if TMainFacade.GetInstance.DBGates.Autorized then
  begin

  end
  else actnTryConnect.Execute;
end;

procedure TfrmMain.actnTryConnectExecute(Sender: TObject);
begin
  if TMainFacade.GetInstance.Authorize then
  begin
    if TMainFacade.GetInstance.DBGates.EmployeePriority > 0 then
    begin
      frmLoad := TfrmLoad.Create(Self);
      frmLoad.Load(aviFindFolder, 'Загрузка справочников...');
      frmLoad.prgb.Step := 10;
      frmLoad.prgb.Max := 200;

      TMainFacade.GetInstance.DBGates.FetchPriorities(actnLst);
      TMainFacade.GetInstance.SettingsFileName := 'C:\Documents and Settings\' + TMainFacade.GetInstance.DBGates.EmployeeTabNumber + '\Мои документы\' + TMainFacade.GetInstance.DBGates.ClientName + '\Settings.ini';

      frmLoad.prgb.StepIt;
      TMainFacade.GetInstance.AllAreas;
      frmLoad.prgb.StepIt;
      TMainFacade.GetInstance.AllNGOs;
      frmLoad.prgb.StepIt;
      TMainFacade.GetInstance.AllNGPs;
      frmLoad.prgb.StepIt;
      TMainFacade.GetInstance.AllNGRs;
      frmLoad.prgb.StepIt;
      TMainFacade.GetInstance.AllFields;
      frmLoad.prgb.StepIt;
      TMainFacade.GetInstance.AllLicenseZones;
      frmLoad.prgb.StepIt;
      TMainFacade.GetInstance.AllTectonicStructures;
      frmLoad.prgb.StepIt;
      TMainFacade.GetInstance.AllNewTectonicStructures;
      frmLoad.prgb.StepIt;
      TMainFacade.GetInstance.AllStructures;
      frmLoad.prgb.StepIt;
      TMainFacade.GetInstance.AllDistricts;
      frmLoad.prgb.StepIt;
      TMainFacade.GetInstance.AllOrganizations;
      frmLoad.prgb.StepIt;
      TMainFacade.GetInstance.AllCategoriesWells;
      frmLoad.prgb.StepIt;
      TMainFacade.GetInstance.AllStatesWells;
      frmLoad.prgb.StepIt;
      TMainFacade.GetInstance.AllFluidTypes;
      frmLoad.prgb.StepIt;
      (TMainFacade.GetInstance as TMainFacade).AllFluidTypesByBalance;
      frmLoad.prgb.StepIt;
      (TMainFacade.GetInstance as TMainFacade).AllProfiles;
      frmLoad.prgb.StepIt;
      (TMainFacade.GetInstance as TMainFacade).AllAbandonReasons;
      frmLoad.prgb.StepIt;
      (TMainFacade.GetInstance as TMainFacade).AllSimpleStratons;
      frmLoad.prgb.StepIt;
      (TMainFacade.GetInstance as TMainFacade).AllFinanceSources;
      frmLoad.prgb.StepIt;
      (TMainFacade.GetInstance as TMainFacade).AllMeasureUnits;

      frmObjectSelect.Prepare;

      TMainFacade.GetInstance.SettingsFileName := 'C:\Documents and Settings\' + TMainFacade.GetInstance.DBGates.EmployeeTabNumber + '\Мои документы\' + TMainFacade.GetInstance.DBGates.ClientName + '\Settings.ini';

      frmLoad.BeforeClose;
      frmLoad.Free;
    end;
  end;

  frmPassword.Free;
end;

constructor TfrmMain.Create(AOwner: TComponent);
begin
  (TMainFacade.GetInstance as TMainFacade).Filter := '';

  inherited;

  frmObjectSelect.OnReloadData := ReloadWells;

  // настроиваем внешний вид формы (только для паспорта такое отображение)
  frmInfoObject.frmInfoProperties.Align := alBottom;

  frmInfoObject.frmInfoProperties.lstInfoPropertiesWell.Columns[0].Width := Width - frmObjectSelect.Width;
  frmInfoObject.frmInfoProperties.Height := Height div 2 + 100;

  frmInfoObject.frmInfoProperties.lstInfoPropertiesWell.Columns[0].Caption := 'Подробная информация по скважине';
end;

destructor TfrmMain.Destroy;
begin

  inherited;
end;

procedure TfrmMain.ReloadWells(Sender: TObject);
begin
  frmInfoObject.frmInfoWells.tvwWells.Items.BeginUpdate;
  TMainFacade.GetInstance.AllWells.Clear;

  if (Assigned(TMainFacade.GetInstance.AllWells.Poster)) and (frmObjectSelect.SQL <> '') then
  begin
    TMainFacade.GetInstance.AllWells.Reload(frmObjectSelect.SQL);
    TMainFacade.GetInstance.AllWells.SortByWellNumAndArea;
    //TMainFacade.GetInstance.AllWells.LocalFilterByID;
  end;

  TMainFacade.GetInstance.AllWells.MakeList(frmInfoObject.frmInfoWells.tvwWells, true, true);
  frmInfoObject.frmInfoWells.SetIcons;
  frmInfoObject.frmInfoWells.tvwWells.Items.EndUpdate;
end;

procedure TfrmMain.actnAddWellExecute(Sender: TObject);
var w: TWell;
begin
  frmEditorWell := TfrmEditorWell.Create(Self);

  (TMainFacade.GetInstance as TMainFacade).EditingWells.Reload('Well_UIN = 0');
  w := (TMainFacade.GetInstance as TMainFacade).EditingWells.Add as TWell;
  frmEditorWell.EditingObject := w;

  if trim(frmObjectSelect.ActiveObjectName) <> '' then
  begin
    (frmEditorWell.EditingObject as TWell).Area := TMainFacade.GetInstance.AllAreas.GetItemByName(trim(frmObjectSelect.ActiveObjectName)) as TSimpleArea;
    (frmEditorWell.dlg.Frames[0] as TfrmInfoWell).FillControls(frmEditorWell.EditingObject);
  end;

  if frmEditorWell.ShowModal = mrOK then
    ReloadWells(Sender);

  frmEditorWell.Free;
end;

procedure TfrmMain.actnAreaDictExecute(Sender: TObject);
begin
  frmAllUnits := TfrmAllUnits.Create(Self);

  with frmAllUnits do
  begin
    frmAllObjects.AllObjects := TMainFacade.GetInstance.AllAreas;
    frmAllObjects.ObjectClass := TMainFacade.GetInstance.AllAreas.ObjectClass;
    frmAllObjects.AllObjects.MakeList(frmAllObjects.lstAllObjects.Items);
    Caption := 'Справочник "Площади"';
  end;

  frmAllUnits.ShowModal;
  frmAllUnits.Free;
end;

procedure TfrmMain.actnStateDictExecute(Sender: TObject);
begin
  frmAllUnits := TfrmAllUnits.Create(Self);

  with frmAllUnits do
  begin
    frmAllObjects.AllObjects := TMainFacade.GetInstance.AllStatesWells;
    frmAllObjects.ObjectClass := TMainFacade.GetInstance.AllStatesWells.ObjectClass;
    frmAllObjects.AllObjects.MakeList(frmAllObjects.lstAllObjects.Items);
    Caption := 'Справочник "Состояния скважин"';
  end;

  frmAllUnits.ShowModal;
  frmAllUnits.Free;
end;

procedure TfrmMain.actnCategoryDictExecute(Sender: TObject);
begin
  frmAllUnits := TfrmAllUnits.Create(Self);

  with frmAllUnits do
  begin
    frmAllObjects.AllObjects := TMainFacade.GetInstance.AllCategoriesWells;
    frmAllObjects.ObjectClass := TMainFacade.GetInstance.AllCategoriesWells.ObjectClass;
    frmAllObjects.AllObjects.MakeList(frmAllObjects.lstAllObjects.Items);
    Caption := 'Справочник "Категории скважин"';
  end;

  frmAllUnits.ShowModal;
  frmAllUnits.Free;
end;

procedure TfrmMain.actnAddCoordExecute(Sender: TObject);
begin
  if Assigned (frmInfoObject.ActiveWell) then
  begin
    frmEditInfoCoordWell := TfrmEditInfoCoordWell.Create(Self);
    frmEditInfoCoordWell.EditingObject := frmInfoObject.ActiveWell;

    frmEditInfoCoordWell.ShowModal;
    frmEditInfoCoordWell.Free;
  end
  else MessageBox(0, 'Скважина не выбрана.', 'Ошибка', MB_OK + MB_APPLMODAL + MB_ICONERROR);
end;

procedure TfrmMain.actnEditWellExecute(Sender: TObject);
var iID: integer;
    Node: TTreeNode;
begin
  if Assigned (frmInfoObject.ActiveWell) then
  begin
    frmEditorWell := TfrmEditorWell.Create(Self);
    iID := frmInfoObject.ActiveWell.ID;
    (TMainFacade.GetInstance as TMainFacade).EditingWells.Reload('Well_UIN = ' + IntToStr(iID));

    frmEditorWell.EditingObject := (TMainFacade.GetInstance as TMainFacade).EditingWells.Items[0];


    if frmEditorWell.ShowModal = mrOK then
    begin
      ReloadWells(Sender);
      Node := frmInfoObject.GetNodeByID(iID);
      if Assigned(Node) then
        Node.Selected := true;
    end;

    frmEditorWell.Free;
  end
  else MessageBox(0, 'Скважина не выбрана.', 'Ошибка', MB_OK + MB_APPLMODAL + MB_ICONERROR);
end;

procedure TfrmMain.actnEditInfoWellExecute(Sender: TObject);
begin
  if Assigned (frmInfoObject.ActiveWell) then
  begin
    frmEditInfoWell := TfrmEditInfoWell.Create(Self);
    frmEditInfoWell.EditingObject := frmInfoObject.ActiveWell;

    if frmEditInfoWell.ShowModal = mrOK then
    begin

    end;

    frmEditInfoWell.Free;
  end
  else MessageBox(0, 'Скважина не выбрана.', 'Ошибка', MB_OK + MB_APPLMODAL + MB_ICONERROR);
end;

procedure TfrmMain.actnEditInfoWellBindingExecute(Sender: TObject);
begin
  if Assigned (frmInfoObject.ActiveWell) then
  begin
    frmEditInfoWellBinding := TfrmEditInfoWellBinding.Create(Self);
    frmEditInfoWellBinding.EditingObject := frmInfoObject.ActiveWell;

    if frmEditInfoWellBinding.ShowModal = mrOK then
    begin

    end;

    frmEditInfoWellBinding.Free;
  end
  else MessageBox(0, 'Скважина не выбрана.', 'Ошибка', MB_OK + MB_APPLMODAL + MB_ICONERROR);
end;

procedure TfrmMain.actnEditInfoWellParametrsExecute(Sender: TObject);
begin
  if Assigned (frmInfoObject.ActiveWell) then
  begin
    frmEditInfoWellParameters := TfrmEditInfoWellParameters.Create(Self);
    frmEditInfoWellParameters.EditingObject := frmInfoObject.ActiveWell;

    frmEditInfoWellParameters.ShowModal;
    frmEditInfoWellParameters.Free;
  end
  else MessageBox(0, 'Скважина не выбрана.', 'Ошибка', MB_OK + MB_APPLMODAL + MB_ICONERROR);
end;

procedure TfrmMain.actnShowDinamicsExecute(Sender: TObject);
begin
  if Assigned (frmInfoObject.ActiveWell) then
  begin

  end
  else MessageBox(0, 'Скважина не выбрана.', 'Ошибка', MB_OK + MB_APPLMODAL + MB_ICONERROR);
end;

procedure TfrmMain.frmInfoWellstvwWellsDblClick(Sender: TObject);
begin
  actnEditWell.Execute;
end;

procedure TfrmMain.actnFindExecute(Sender: TObject);
begin
  if not Assigned (frmFindWell) then frmFindWell := TfrmFindWell.Create(Self);
  frmFindWell.Show;
end;

procedure TfrmMain.actnDelWellExecute(Sender: TObject);
begin
  if Assigned (frmInfoObject.ActiveWell) then
  begin
    if MessageBox(0, PChar('Вы уверены, что хотите удалить скважину: "' + frmInfoObject.ActiveWell.List + '"?'),
                PChar('Предупреждение'), MB_YESNO	+ MB_ICONWARNING + MB_DEFBUTTON2	+ MB_APPLMODAL) = ID_YES then
      frmLoad := TfrmLoad.Create(Self);
      frmLoad.Load(aviDeleteFile, 'Удаление элементов...');
      frmLoad.prgb.Step := 25;
      frmLoad.prgb.Max := 100;

      frmLoad.prgb.StepIt;
      TMainFacade.GetInstance.AllWells.Remove(frmInfoObject.ActiveWell);
      frmLoad.prgb.StepIt;
      TMainFacade.GetInstance.AllWells.MakeList(frmInfoObject.frmInfoWells.tvwWells, true, true);
      frmLoad.prgb.StepIt;
      frmInfoObject.frmInfoWells.SetIcons;
      frmLoad.prgb.StepIt;

      frmLoad.BeforeClose;
      frmLoad.Free;
  end
  else MessageBox(0, 'Скважина не выбрана.', 'Ошибка', MB_OK + MB_APPLMODAL + MB_ICONERROR);
end;

procedure TfrmMain.actnSourseCoordDictExecute(Sender: TObject);
begin
  frmAllUnits := TfrmAllUnits.Create(Self);

  with frmAllUnits do
  begin
    frmAllObjects.AllObjects := (TMainFacade.GetInstance as TMainFacade).AllSourcesCoord;
    frmAllObjects.ObjectClass := (TMainFacade.GetInstance as TMainFacade).AllSourcesCoord.ObjectClass;
    frmAllObjects.AllObjects.MakeList(frmAllObjects.lstAllObjects.Items);
    Caption := 'Справочник "Источник координат"';
  end;

  frmAllUnits.ShowModal;
  frmAllUnits.Free;
end;

procedure TfrmMain.actnReportExecute(Sender: TObject);
begin
  if Assigned (frmInfoObject.ActiveWell) then
  begin
    frmReportByWells := TfrmReportByWells.Create(Self);
    (TMainFacade.GetInstance as TMainFacade).ActiveWells := frmInfoObject.ActiveWells;
    frmReportByWells.ShowModal;
    frmReportByWells.Free;
  end
  else MessageBox(0, 'Ни одна скважина не выбрана.', 'Ошибка', MB_OK + MB_APPLMODAL + MB_ICONERROR);
end;

procedure TfrmMain.actnDelWellUpdate(Sender: TObject);
begin
  actnDelWell.Enabled := Assigned(frmInfoObject.ActiveWell);
end;

procedure TfrmMain.actnEditWellUpdate(Sender: TObject);
begin
  actnEditWell.Enabled := Assigned(frmInfoObject.ActiveWell);
end;

procedure TfrmMain.actnEditInfoWellUpdate(Sender: TObject);
begin
  actnEditInfoWell.Enabled := Assigned(frmInfoObject.ActiveWell);
end;

procedure TfrmMain.actnEditInfoWellBindingUpdate(Sender: TObject);
begin
  actnEditInfoWellBinding.Enabled := Assigned(frmInfoObject.ActiveWell);
end;

procedure TfrmMain.actnEditInfoWellParametrsUpdate(Sender: TObject);
begin
  actnEditInfoWellParametrs.Enabled := Assigned(frmInfoObject.ActiveWell);
end;

procedure TfrmMain.actnAddCoordUpdate(Sender: TObject);
begin
  actnAddCoord.Enabled := Assigned(frmInfoObject.ActiveWell);
end;

procedure TfrmMain.actnExitExecute(Sender: TObject);
begin
  Close;
end;

end.

