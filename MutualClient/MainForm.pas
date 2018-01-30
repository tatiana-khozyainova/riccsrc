unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonObjectSelectFilter, ComCtrls, ToolWin, ImgList, ActnList,
  Menus;

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
    procedure actnTryConnectExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
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
  // здесь перезагружаем куда следует, что следует
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  if not TMainFacade.GetInstance.DBGates.Autorized then actnTryConnect.Execute;
end;

end.
