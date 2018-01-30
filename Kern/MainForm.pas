unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, KDescriptionKernFrame, Menus, ExtCtrls, ComCtrls,
  ToolWin, ImgList, ActnList, KDictionary, CommonObjectSelectFilter,
  KInfoObjectFrame, KImportWords, KInfoSlottingsFrame, KInfoPropertiesFrame, 
  Slotting, CoreDescription, KFindProperties, Load;

type
  TfrmMain = class(TForm)
    MainMnu: TMainMenu;
    Start: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    Service: TMenuItem;
    N10: TMenuItem;
    actnLst: TActionList;
    actnTryConnect: TAction;
    actnExit: TAction;
    actnFilterLoad: TAction;
    actnHelp: TAction;
    actnSetOptions: TAction;
    imgLst: TImageList;
    ToolBar: TToolBar;
    ToolButton1: TToolButton;
    ToolButton8: TToolButton;
    N3: TMenuItem;
    N4: TMenuItem;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    frmObjectSelect: TfrmObjectSelect;
    sbr: TStatusBar;
    nDicts: TMenuItem;
    actnDictionary: TAction;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    N5: TMenuItem;
    N6: TMenuItem;
    actnDictImportValues: TAction;
    Splitter2: TSplitter;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    actnReportWell: TAction;
    actnReportArea: TAction;
    actnReport: TAction;
    ToolButton7: TToolButton;
    ToolButton9: TToolButton;
    pmReport: TPopupMenu;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    actnFind: TAction;
    N15: TMenuItem;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    pmFind: TPopupMenu;
    N11: TMenuItem;
    actnReportSlotting: TAction;
    N16: TMenuItem;
    N17: TMenuItem;
    frmInfoObject: TfrmInfoObject;
    N18: TMenuItem;
    procedure FormActivate(Sender: TObject);
    procedure actnTryConnectExecute(Sender: TObject);
    procedure actnDictionaryExecute(Sender: TObject);
    procedure actnSetOptionsExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actnDictImportValuesExecute(Sender: TObject);
    procedure frmInfoSlottingstvwWellsGetImageIndex(Sender: TObject;
      Node: TTreeNode);
    procedure actnReportWellExecute(Sender: TObject);
    procedure actnReportAreaExecute(Sender: TObject);
    procedure frmInfoSlottingstvwWellsClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actnFindExecute(Sender: TObject);
    procedure actnExitExecute(Sender: TObject);
    procedure actnReportSlottingExecute(Sender: TObject);
  private
    FActiveWell: TDescriptedWell;
    FActiveSlotting: TSlotting;
  public
    property    ActiveWell: TDescriptedWell read FActiveWell write FActiveWell;
    property    ActiveSlotting: TSlotting read FActiveSlotting write FActiveSlotting;

    procedure   ReloadWells(Sender: TObject);

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmMain: TfrmMain;

implementation

uses Facade, PasswordForm, KDictDescriptions, KOptions, Buttons, KReport,
  Math;

{$R *.dfm}

{ TForm1 }

constructor TfrmMain.Create(AOwner: TComponent);
begin
  (TMainFacade.GetInstance as TMainFacade).Filter := '';

  inherited;

  frmObjectSelect.OnReloadData := ReloadWells;
end;

destructor TfrmMain.Destroy;
begin

  inherited;
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  if TMainFacade.GetInstance.DBGates.Autorized then
  begin

  end
  else actnTryConnect.Execute;
end;

procedure TfrmMain.actnTryConnectExecute(Sender: TObject);
begin
  frmPassword := TfrmPassword.Create(Self);

  if frmPassword.ShowModal = mrOk then
  if TMainFacade.GetInstance.DBGates.Autorized then
  begin
    if TMainFacade.GetInstance.DBGates.EmployeePriority > 0 then
    begin
      frmLoad := TfrmLoad.Create(Self);
      frmLoad.Load(aviFindFolder, 'Загрузка справочников...');

      TMainFacade.GetInstance.DBGates.FetchPriorities(actnLst);

      // временно
      actnSetOptions.Visible := false;

      frmObjectSelect.Prepare;

      TMainFacade.GetInstance.SettingsFileName := 'C:\Documents and Settings\' + TMainFacade.GetInstance.DBGates.EmployeeTabNumber + '\Мои документы\' + TMainFacade.GetInstance.DBGates.ClientName + '\Settings.ini';

      if not Assigned (FActiveWell) then FActiveWell := TDescriptedWell.Create(TMainFacade.GetInstance.AllWells);
      if not Assigned (FActiveSlotting) then FActiveSlotting := TSlotting.Create(FActiveWell.Slottings);

      frmLoad.prgb.StepIt;
      (TMainFacade.GetInstance as TMainFacade).AllWords.Reload;
      frmLoad.prgb.StepIt;

      frmLoad.BeforeClose;
      frmLoad.Free;
    end;
  end;

  frmPassword.Free;
end;

procedure TfrmMain.actnDictionaryExecute(Sender: TObject);
begin
  frmDicts := TfrmDicts.Create(Self);
  frmDicts.ShowModal;
  frmDicts.Free;
end;

procedure TfrmMain.actnSetOptionsExecute(Sender: TObject);
begin
  frmOptions := TfrmOptions.Create(Self);
  frmOptions.Reload;

  if frmOptions.ShowModal = mrOK then
  begin

  end;

  frmOptions.Free;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  nDicts.ImageIndex := -1;
end;

procedure TfrmMain.ReloadWells(Sender: TObject);
begin
  TMainFacade.GetInstance.AllWells.Clear;

  if (Assigned(TMainFacade.GetInstance.AllWells.Poster)) and (frmObjectSelect.SQL <> '') then
    TMainFacade.GetInstance.AllWells.Poster.GetFromDB(frmObjectSelect.SQL, TMainFacade.GetInstance.AllWells);

  TMainFacade.GetInstance.AllWells.MakeList(frmInfoObject.frmInfoSlottings.tvwWells, true, true);
  frmInfoObject.frmInfoSlottings.SetIcons;
end;

procedure TfrmMain.actnDictImportValuesExecute(Sender: TObject);
begin
  // импортировать данные в справочники
  frmImportWords := TfrmImportWords.Create(Self);
  frmImportWords.ShowModal;
  frmImportWords.Free;
end;

procedure TfrmMain.frmInfoSlottingstvwWellsGetImageIndex(Sender: TObject;
  Node: TTreeNode);
begin
  frmInfoObject.frmInfoSlottingstvwWellsGetImageIndex(Sender, Node);

  if Node.Level = 0 then Node.ImageIndex := frmObjectSelect.ActiveImageIndex;
end;

procedure TfrmMain.actnReportWellExecute(Sender: TObject);
var i : integer;
    ExistsDesc: boolean;
begin
  if Assigned (frmInfoObject.ActiveWell) then
  begin
    ExistsDesc := false;

    frmReport := TfrmReport.Create(Self);

    for i := 0 to frmInfoObject.ActiveWell.Slottings.Count - 1 do
    if ((TMainFacade.GetInstance as TMainFacade).ActiveWell.Slottings.Items[i].LayerSlottings as TDescriptedLayers).ExistsDescription then
    begin
      ExistsDesc := true;

      frmReport.ActiveObject := frmInfoObject.ActiveWell;

      frmLoad := TfrmLoad.Create(Self);
      frmLoad.Load(aviFindFolder, 'Формирование отчета...');
      frmLoad.prgb.StepIt;

      frmReport.Reload;

      frmLoad.prgb.StepIt;
      frmLoad.BeforeClose;
      frmLoad.Free;

      frmReport.ShowModal;

      break;
    end;

    frmReport.Free;

    if not ExistsDesc then MessageBox(0, 'По выбранной скважине нет описаний керна', 'Информация', MB_OK + MB_ICONINFORMATION + MB_APPLMODAL);
  end
  else MessageBox(0, 'Скважина не указана', 'Ошибка', MB_OK + MB_ICONERROR + MB_APPLMODAL);
end;

procedure TfrmMain.actnReportAreaExecute(Sender: TObject);
var i, j: integer;
    ExistsDesc: boolean;
begin
  if TMainFacade.GetInstance.AllWells.Count > 0 then
  begin
    ExistsDesc := false;

    frmReport := TfrmReport.Create(Self);

    for i := 0 to TMainFacade.GetInstance.AllWells.Count - 1 do
    for j := 0 to TMainFacade.GetInstance.AllWells.Items[i].Slottings.Count - 1 do
    if (TMainFacade.GetInstance.AllWells.Items[i].Slottings.Items[j].LayerSlottings as TDescriptedLayers).ExistsDescription then
    begin
      ExistsDesc := true;

      actnReport.Execute;
      frmReport.ActiveObjects.Assign(TMainFacade.GetInstance.AllWells);

      frmReport.Reload;
      frmReport.ShowModal;

      break;
    end;

    frmReport.Free;

    if not ExistsDesc then MessageBox(0, 'По выбранной площади нет описаний керна', 'Информация', MB_OK + MB_ICONINFORMATION + MB_APPLMODAL);
  end
  else MessageBox(0, 'Площадь не указана или по данной площади нет скважин', 'Ошибка', MB_OK + MB_ICONERROR + MB_APPLMODAL);
end;

procedure TfrmMain.frmInfoSlottingstvwWellsClick(Sender: TObject);
begin
  if TMainFacade.GetInstance.AllWells.Count > 0 then
    frmInfoObject.frmInfoSlottingstvwWellsClick(Sender);
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  try
    if Assigned((TMainFacade.GetInstance as TMainFacade).AllWords) then
    if (TMainFacade.GetInstance as TMainFacade).AllWords.ChangeMade then
    if MessageBox(0, 'В словари были добавлены новые слова, которые необходимо проверить. Перейти в редактор справочников?',
                  'Вопрос', MB_YESNO + MB_ICONWARNING + MB_APPLMODAL) = ID_YES then
    begin
      actnDictionary.Execute;
      (TMainFacade.GetInstance as TMainFacade).AllWords.ChangeMade := false;
      CanClose := false;
    end;
  except

  end;
end;
                                  
procedure TfrmMain.actnFindExecute(Sender: TObject);
begin
  if not Assigned (frmFind) then frmFind := TfrmFind.Create(Self);
  frmFind.frmFindProperties.Reload;
  frmFind.Show;
end;

procedure TfrmMain.actnExitExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMain.actnReportSlottingExecute(Sender: TObject);
begin
  if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWell) then
  if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveSlotting) then
  if (TMainFacade.GetInstance as TMainFacade).ActiveSlotting.TrueDescription then
  begin
    frmReport := TfrmReport.Create(Self);
    frmLoad := TfrmLoad.Create(Self);         

    frmReport.ActiveObject := (TMainFacade.GetInstance as TMainFacade).ActiveWell;
    frmReport.ActiveSlotting := (TMainFacade.GetInstance as TMainFacade).ActiveSlotting;

    frmLoad.Load(aviFindFolder, 'Формирование отчета...');
    frmLoad.prgb.StepIt;

    frmReport.AddSlottingToReport;

    frmLoad.prgb.StepIt;
    frmLoad.BeforeClose;

    frmReport.ShowModal;

    frmLoad.Free;
    frmReport.Free;
  end
  else MessageBox(0, 'По указанному долблению нет описания', 'Информация', MB_OK + MB_ICONINFORMATION + MB_APPLMODAL)
  else MessageBox(0, 'Долбление не указано', 'Информация', MB_OK + MB_ICONERROR + MB_APPLMODAL)
  else MessageBox(0, 'Скважина не указана', 'Ошибка', MB_OK + MB_ICONERROR + MB_APPLMODAL);
end;

end.


