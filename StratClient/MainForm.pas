unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonObjectSelectFilter, ComCtrls, ToolWin, ImgList, ActnList,
  Menus, StdCtrls, StratClientWellsFrame, ExtCtrls;

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
    sbr: TStatusBar;
    actnImportSubdivisions: TAction;
    N6: TMenuItem;
    N7: TMenuItem;
    gbxMain: TGroupBox;
    spl1: TSplitter;
    frmWells1: TfrmWells;
    actnViewSubdivisions: TAction;
    actnViewSubdivisions1: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    actnEditSubdivisions: TAction;
    N8: TMenuItem;
    N9: TMenuItem;
    N17: TMenuItem;
    MSExcel1: TMenuItem;
    procedure actnTryConnectExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure frmWells1actnViewSubs1Click(Sender: TObject);
    procedure actnViewSubdivisionsExecute(Sender: TObject);
    procedure actnViewSubdivisionsUpdate(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure frmWells1btnThemeSelecClick(Sender: TObject);
    procedure MSExcel1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure   ReloadData(Sender: TObject);
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;

  end;

var
  frmMain: TfrmMain;

implementation

uses PasswordForm, Facade;

{$R *.dfm}

procedure TfrmMain.actnTryConnectExecute(Sender: TObject);
begin
  if TMainFacade.GetInstance.Authorize then
  begin
    TMainFacade.GetInstance.DBGates.FetchPriorities(actnLst);
    frmObjectSelect.Prepare;
  end;
end;

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;

  (TMainFacade.GetInstance as TMainFacade).Filter := '';


  frmObjectSelect.OnReloadData := ReloadData;
end;



procedure TfrmMain.ReloadData(Sender: TObject);
begin
  (TMainFacade.GetInstance as TMainFacade).AllWells.Clear;

  (TMainFacade.GetInstance as TMainFacade).AllWells.Reload(frmObjectSelect.SQL);
   frmWells1.ReloadWells;

end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  if not TMainFacade.GetInstance.DBGates.Autorized then actnTryConnect.Execute;
end;

procedure TfrmMain.frmWells1actnViewSubs1Click(Sender: TObject);
begin
  frmWells1.actnViewSubsExecute(Sender);

end;

destructor TfrmMain.Destroy;
begin

  inherited;
end;

procedure TfrmMain.actnViewSubdivisionsExecute(Sender: TObject);
begin
  frmWells1.LoadSubdivisions;
end;

procedure TfrmMain.actnViewSubdivisionsUpdate(Sender: TObject);
begin
  actnViewSubdivisions.Enabled := frmWells1.CheckedWellsCount > 0;
end;

procedure TfrmMain.N7Click(Sender: TObject);
begin
  frmWells1.actnImportSubsExecute(Sender);

end;

procedure TfrmMain.frmWells1btnThemeSelecClick(Sender: TObject);
begin
  frmWells1.actnThemeSelectExecute(Sender);

end;

procedure TfrmMain.MSExcel1Click(Sender: TObject);
begin
  frmWells1.actnExcelExportExecute(Sender);

end;

end.
