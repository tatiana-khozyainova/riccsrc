unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonObjectSelectFilter, ComCtrls, ToolWin, ImgList, ActnList,
  Menus, AllObjectsAsTreeFrame, MRAllDocsFrame, ExtCtrls;

type
  TfrmMain = class(TForm)
    sbr: TStatusBar;
    imgLst: TImageList;
    MainMnu: TMainMenu;
    Start: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Materials: TMenuItem;
    N9: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N14: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N6: TMenuItem;
    N5: TMenuItem;
    N23: TMenuItem;
    Themes: TMenuItem;
    N4: TMenuItem;
    N16: TMenuItem;
    N22: TMenuItem;
    AcrView1: TMenuItem;
    Service: TMenuItem;
    N15: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    actnLst: TActionList;
    actnTryConnect: TAction;
    actnCloseMainForm: TAction;
    actnThemeEditor: TAction;
    actnHierarchicalKindMD: TAction;
    actnFilterLoad: TAction;
    actnCommonChange: TAction;
    actnCreateSimple: TAction;
    actnCreateWithMaster: TAction;
    actnCreateGroupDocs: TAction;
    actnDM: TAction;
    actnHelp: TAction;
    actnAddWithMCRList: TAction;
    actnCreateLayerAcrView: TAction;
    actnSetOptions: TAction;
    actnCreatePeriodDoc: TAction;
    actnSubscription: TAction;
    actnAllMaps: TAction;
    actnConvert: TAction;
    actnSearchDocs: TAction;
    ppMenuSubscription: TPopupMenu;
    N17: TMenuItem;
    N21: TMenuItem;
    pmSearch: TPopupMenu;
    N24: TMenuItem;
    N25: TMenuItem;
    ToolBar: TToolBar;
    ToolButton18: TToolButton;
    ToolButton1: TToolButton;
    ToolButton13: TToolButton;
    ToolButton4: TToolButton;
    ToolButton20: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton21: TToolButton;
    ToolButton9: TToolButton;
    ToolButton19: TToolButton;
    ToolButton2: TToolButton;
    ToolButton5: TToolButton;
    ToolButton23: TToolButton;
    ToolButton22: TToolButton;
    ToolButton15: TToolButton;
    ToolButton3: TToolButton;
    ToolButton16: TToolButton;
    ToolButton6: TToolButton;
    ToolButton14: TToolButton;
    ToolButton7: TToolButton;
    ToolButton17: TToolButton;
    ToolButton8: TToolButton;
    ToolButton12: TToolButton;
    frmAllObjectsTree: TfrmAllObjectsTree;
    spl1: TSplitter;
    frmAllDocs: TfrmAllDocs;
    N26: TMenuItem;
    N27: TMenuItem;
    procedure actnTryConnectExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure frmAllObjectsTreetvListClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure   ReloadData(Sender: TObject);
    constructor Create(AOwner: TComponent); override;

  end;

var
  frmMain: TfrmMain;

implementation

uses PasswordForm, Facade, Load;

{$R *.dfm}

procedure TfrmMain.actnTryConnectExecute(Sender: TObject);
begin
  if not Assigned (frmPassword) then frmPassword := TfrmPassword.Create(Self);
  frmPassword.ShowModal;

  if frmPassword.ModalResult = mrOk then
  begin
    if TMainFacade.GetInstance.DBGates.Autorized then
    if TMainFacade.GetInstance.DBGates.EmployeePriority > 0 then
    begin
      TMainFacade.GetInstance.DBGates.FetchPriorities(actnLst);

      (TMainFacade.GetInstance as TMainFacade).AllDocumentTypes.MakeList(frmAllObjectsTree.tvList);
      frmAllObjectsTree.Visible := True;
      frmAllDocs.Visible := True;

    end;
  end;
end;

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;

  (TMainFacade.GetInstance as TMainFacade).Filter := '';

end;

procedure TfrmMain.ReloadData(Sender: TObject);
begin
  // здесь перезагружаем куда следует, что следует
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  if not TMainFacade.GetInstance.DBGates.Autorized then actnTryConnect.Execute;
end;

procedure TfrmMain.frmAllObjectsTreetvListClick(Sender: TObject);
begin
  frmLoad := TfrmLoad.Create(Self);
  frmLoad.Load(aviFindFolder, 'Построение списка документов...');
  frmLoad.prgb.Step := 10;
  frmLoad.prgb.Max := 30;

  frmAllObjectsTree.tvListClick(Sender);
  frmLoad.prgb.StepIt;

  // загружаем докумены по выбранному типу документа
  if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveDocType) then
  (TMainFacade.GetInstance as TMainFacade).ActiveDocType.Documents.MakeList(frmAllDocs.frmDocsByType.lstAllObjects.Items, True, True);

  frmLoad.prgb.StepIt;

  frmLoad.BeforeClose;
  frmLoad.Free;
end;

end.

