unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonObjectSelectFilter, ComCtrls, ToolWin, ImgList, ActnList,
  Menus, LasClientTreeViewFrame, AllGisForm, LasFile, StdCtrls;

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
    frmWellsTree: TfrmWellsTree;
    N6: TMenuItem;
    AddLas: TMenuItem;
    actAddLas: TAction;
    btnAddLas: TToolButton;
    btn1: TToolButton;
    btnExportGis: TToolButton;
    actExportGis: TAction;
    D1: TMenuItem;
    L1: TMenuItem;
    J1: TMenuItem;
    actAllGis: TAction;
    btnViewLas: TToolButton;
    btn2: TToolButton;
    actViewLas: TAction;
    actnCropFiles: TAction;
    N7: TMenuItem;
    N8: TMenuItem;
    actnIndexFile: TAction;
    LAS1: TMenuItem;
    procedure actnTryConnectExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure AddLasClick(Sender: TObject);
    procedure actExportGisExecute(Sender: TObject);
    procedure L1Click(Sender: TObject);
    procedure actAllGisExecute(Sender: TObject);
    procedure actViewLasExecute(Sender: TObject);
    procedure actViewLasUpdate(Sender: TObject);
    procedure actnCropFilesExecute(Sender: TObject);
    procedure actnIndexFileExecute(Sender: TObject);

  private
    { Private declarations }
    procedure LoadDicts;
  public
    { Public declarations }
    procedure   ReloadData(Sender: TObject);
    constructor Create(AOwner: TComponent); override;

  end;

var
  frmMain: TfrmMain;
 // Selected: array of Boolean;

implementation

uses PasswordForm, Facade, AddLasFile, AddLasFileForm, LasForm, LasFrame,
  ExportGisForm, AddMaterialForm, ShellAPI, frmCropLasFiles,
  frmLasFileIndexer;

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
  //TMainFacade.GetInstance.LoadDicts;
  

end;



procedure TfrmMain.ReloadData(Sender: TObject);
begin
  // здесь перезагружаем куда следует, что следует

  TMainFacade.GetInstance.Filter := frmObjectSelect.SQL;
  TMainFacade.GetInstance.SkipWells;
  frmWellsTree.trwWell.Header.Columns[0].MinWidth:=350;
  frmWellsTree.LoadWells;
  frmWellsTree.LoadCurves;

end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  if not TMainFacade.GetInstance.DBGates.Autorized then actnTryConnect.Execute;

  TMainFacade.GetInstance.AllSimpleDocuments;

  {TMainFacade.GetInstance.SystemSettings.Create('C:\LasClient.ini');
  TMainFacade.GetInstance.SystemSettings.Sections.Add('CurveEditor');
  TMainFacade.GetInstance.SystemSettings.SectionByName['CurveEditor']:='121';
  TMainFacade.GetInstance.SystemSettings.SaveAllToFile;
   }
end;



procedure TfrmMain.AddLasClick(Sender: TObject);
begin
{if not Assigned (formAddLasFile) then formAddLasFile := TformAddLasFile.Create(Self);
  formAddLasFile.ShowModal;}

 {if not Assigned (Form1) then Form1 := TForm1.Create(Self);
  Form1.ShowModal;}

  {if not Assigned (Form2) then Form2 := TForm2.Create(Self);
  Form2.ShowModal;    }

  if not Assigned (Form3) then Form3 := TForm3.Create(Self)
  else
  begin
    Form3.Free;
    Form3 := TForm3.Create(Self);
  end;
  Form3.ShowModal;
end;


procedure TfrmMain.actExportGisExecute(Sender: TObject);
begin
if not Assigned (ExportGis) then ExportGis := TExportGis.Create(Self)
 else
 begin
  ExportGis.Free;
  ExportGis := TExportGis.Create(Self);
 end;
  ExportGis.ShowModal;
end;

procedure TfrmMain.L1Click(Sender: TObject);
begin
if not Assigned (AddMaterial) then AddMaterial := TAddMaterial.Create(Self)
 else
 begin
  AddMaterial.Free;
  AddMaterial := TAddMaterial.Create(Self);
 end;
  AddMaterial.ShowModal;
end;

procedure TfrmMain.LoadDicts;
begin
end;

procedure TfrmMain.actAllGisExecute(Sender: TObject);
begin
 if not Assigned (AllGis) then AllGis:= TAllGis.Create(Self)
 else
 begin
  AllGis.Free;
  AllGis := TAllGis.Create(Self);
 end;
  AllGis.ShowModal;
end;

procedure TfrmMain.actViewLasExecute(Sender: TObject);
var
  lf:TLasFile;
  s: string;
begin
  {if ((frmWellsTree.trwWL.Selected.Level=1) ) then
  begin

    lf:=TLasFile(TObject (frmWellsTree.trwWL.Selected.Data));
    s := 'C:\'+ExtractFileName(lf.OldFileName);
    CopyFile(PChar(lf.FileName), PChar(s), True);
    ShellExecute(Handle, 'open', PChar('C:\Program Files\CurveEditor\CurveEditor.exe '), PChar(S), nil, SW_MAXIMIZE );
  end; }
end;

procedure TfrmMain.actViewLasUpdate(Sender: TObject);
begin
  {actViewLas.Enabled := Assigned(frmWellsTree.trwWL.Selected);}
end;

procedure TfrmMain.actnCropFilesExecute(Sender: TObject);
begin
  if not Assigned(frmCropLasFilesForm) then frmCropLasFilesForm := TfrmCropLasFilesForm.Create(Self);
  
  
  frmCropLasFilesForm.Show();
end;

procedure TfrmMain.actnIndexFileExecute(Sender: TObject);
begin
  if not Assigned(frmLasFileIndexerForm) then frmLasFileIndexerForm := TfrmLasFileIndexerForm.Create(Self);
  frmLasFileIndexerForm.Show();
end;

end.
