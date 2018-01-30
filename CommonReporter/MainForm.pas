unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonObjectSelectFilter, ComCtrls, ToolWin, ImgList, ActnList,
  Menus, CRepWellListFrame, JvPanel, ExtCtrls, JvExExtCtrls,
  JvExtComponent, JvSplit, JvExComCtrls, JvToolBar, CRepWellBasketFrame, JVListView,
  JvComCtrls, CRepInfoGroupsFrame;

type
  TfrmMain = class(TForm)
    frmObjectSelect: TfrmObjectSelect;
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
    splt1: TJvxSplitter;
    pnlWellSet: TJvPanel;
    frmWellList1: TfrmWellList;
    jvtlbr1: TJvToolBar;
    btnDown: TToolButton;
    btnUp: TToolButton;
    actnAddWell: TAction;
    pnlBasket: TJvPanel;
    frmWellBasket1: TfrmWellBasket;
    actnDeleteWell: TAction;
    pgctlAll: TJvPageControl;
    tsWells: TTabSheet;
    tsResearch: TTabSheet;
    actnDownload: TAction;
    btnDownload: TToolButton;
    btnApplyInfoGroups: TToolButton;
    actnApplyInfoGroups: TAction;
    frmInfoGroup1: TfrmInfoGroup;
    procedure actnTryConnectExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure actnAddWellExecute(Sender: TObject);
    procedure actnDeleteWellExecute(Sender: TObject);
    procedure frmWellBasket1tvSelectedWellsDragOver(Sender,
      Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean);
    procedure frmWellBasket1tvSelectedWellsDragDrop(Sender,
      Source: TObject; X, Y: Integer);
    procedure frmWellList1lvWellsDblClick(Sender: TObject);
    procedure frmWellBasket1tvSelectedWellsDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actnDownloadExecute(Sender: TObject);
    procedure actnApplyInfoGroupsExecute(Sender: TObject);
  private
    { Private declarations }
    procedure DoOnAfterSettingsLoaded(Sender: TObject); 
  public
    { Public declarations }
    procedure   ReloadData(Sender: TObject);
    constructor Create(AOwner: TComponent); override;

  end;

var
  frmMain: TfrmMain;

implementation

uses PasswordForm, Facade, CRepDownloadForm;

{$R *.dfm}

procedure TfrmMain.actnTryConnectExecute(Sender: TObject);
begin
  if TMainFacade.GetInstance.Authorize then
  begin
    TMainFacade.GetInstance.DBGates.FetchPriorities(actnLst);
    TMainFacade.GetInstance.LoadSettings;
    frmObjectSelect.Prepare;
    frmInfoGroup1.RefreshInfoGroups;
  end;
end;

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;

  (TMainFacade.GetInstance as TMainFacade).Filter := '';


  frmObjectSelect.OnReloadData := ReloadData;
  (TMainFacade.GetInstance as TMainFacade).OnAfterSettingsLoaded := DoOnAfterSettingsLoaded;
end;



procedure TfrmMain.ReloadData(Sender: TObject);
begin
  // здесь перезагружаем куда следует, что следует
  TMainFacade.GetInstance.SkipWells;
  TMainFacade.GetInstance.Filter := frmObjectSelect.SQL;
  frmWellList1.ReloadWells;
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  if not TMainFacade.GetInstance.DBGates.Autorized then actnTryConnect.Execute;
end;

procedure TfrmMain.actnAddWellExecute(Sender: TObject);
begin
  TMainFacade.GetInstance.AddSelectedWells(frmWellList1.SelectedWells);
  frmWellBasket1.ReloadWells(false);
end;

procedure TfrmMain.actnDeleteWellExecute(Sender: TObject);
begin
  TMainFacade.GetInstance.RemoveSelectedWells(frmWellBasket1.SelectedWells);
  frmWellBasket1.ReloadWells(true);
end;

procedure TfrmMain.frmWellBasket1tvSelectedWellsDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := Source is TJvListView;
end;

procedure TfrmMain.frmWellBasket1tvSelectedWellsDragDrop(Sender,
  Source: TObject; X, Y: Integer);
begin
  actnAddWell.Execute;
end;

procedure TfrmMain.frmWellList1lvWellsDblClick(Sender: TObject);
begin
  if Assigned(frmWellList1.SelectedWell) then
    actnAddWell.Execute;
end;

procedure TfrmMain.frmWellBasket1tvSelectedWellsDblClick(Sender: TObject);
begin
  if Assigned(frmWellBasket1.SelectedWell) then
    actnDeleteWell.Execute;
end;

procedure TfrmMain.DoOnAfterSettingsLoaded(Sender: TObject);
begin
  frmWellBasket1.ReloadWells(true);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TMainFacade.GetInstance.SaveSettings;
end;

procedure TfrmMain.actnDownloadExecute(Sender: TObject);
begin
  if not Assigned(frmFileDownload) then frmFileDownload := TfrmFileDownload.Create(Self);
  frmFileDownload.Clear();
  frmFileDownload.Show();
end;

procedure TfrmMain.actnApplyInfoGroupsExecute(Sender: TObject);
begin
  TMainFacade.GetInstance.ApplyInfoGroups(frmInfoGroup1.SelectedInfoGroups);
  frmWellBasket1.ReloadWells(true);
end;

end.
