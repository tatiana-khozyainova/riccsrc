unit AddLasFile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, Menus, StdCtrls, Well, Facade, BaseObjects, Area,
  ComCtrls, LasFile,   TrwLasFilesFrame, ToolWin,
  Buttons, ImgList, ChangeLasFileFrame, CurveDictForm;

type
  TformAddLasFile = class(TForm)
    TopMainMenu: TMainMenu;
    mbtn1: TMenuItem;
    mbtn11: TMenuItem;
    TopToolBar: TToolBar;
    TBOpen: TToolButton;
    ImageList: TImageList;
    Actionlist: TActionList;
    TBJoin: TToolButton;
    frmTrwLasFiles: TfrmTrwLasFiles;
    frmChangeLasFile1: TfrmChangeLasFile;
    openDialog: TOpenDialog;
    TBSep1: TToolButton;
    TBSep2: TToolButton;
    TBSep3: TToolButton;
    actOpenLas: TAction;
    TBDel: TToolButton;
    TBSep4: TToolButton;
    actViewAreas: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    actOpenCurveDict: TAction;
   

    procedure TBOpenClick(Sender: TObject);
    procedure TBDelClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure frmChangeLasFile1actJoinToWellExecute(Sender: TObject);





  private
    { Private declarations }
    FreeLasFiles : TLasFiles;

    procedure SelectedWellChanged(Sender: TObject);
    procedure LasFileCollectionChanged(Sender: TObject);
    procedure SelectedLasFileChanged(Sender: TObject);


  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    
  end;

var
  formAddLasFile: TformAddLasFile;

implementation



{$R *.dfm}

constructor TformAddLasFile.Create(AOwner: TComponent);
begin
  inherited;
  frmChangeLasFile1.OnWellSelected := SelectedWellChanged;
  frmTrwLasFiles.OnLasFileChanged := LasFileCollectionChanged;
  frmTrwLasFiles.OnSelectedLasFileChanged := SelectedLasFileChanged;
end;

procedure TformAddLasFile.SelectedWellChanged(Sender: TObject);
begin
  frmTrwLasFiles.SelectedWell := Sender as TWell;
end;


procedure TformAddLasFile.TBOpenClick(Sender: TObject);
var
  i:Integer;
  lf:TLasFile;
begin
  FreeAndNil(FreeLasFiles);
  FreeLasFiles:=TLasFiles.Create;
  openDialog := TOpenDialog.Create(self);
  openDialog.InitialDir := GetCurrentDir;
  openDialog.Filter :='ֲסו פאיכû|*.*|Las-פאיכû|*.las';
  openDialog.FilterIndex := 2;

  if (not (ofAllowMultiSelect in openDialog.Options)) then
  openDialog.Options := openDialog.Options + [ofAllowMultiSelect];

  if openDialog.Execute then
  begin
    if not DirectoryExists(ExtractFileDir(openDialog.Files.Strings[0])+'\temp') then
    ForceDirectories(ExtractFileDir(openDialog.Files.Strings[0])+'\temp');

    for i:=0 to openDialog.Files.Count-1 do
      begin
        if FileExists(ExtractFileDir(openDialog.Files.Strings[i])+'\temp\'+ExtractFileName(openDialog.Files.Strings[i])) then
          DeleteFile(ExtractFileDir(openDialog.Files.Strings[i])+'\temp\'+ExtractFileName(openDialog.Files.Strings[i]));
        CopyFile(Pchar(openDialog.Files.Strings[i]), Pchar(ExtractFileDir(openDialog.Files.Strings[i])+'\temp\'+ExtractFileName(openDialog.Files.Strings[i])), true);
        openDialog.Files.Strings[i]:=ExtractFileDir(openDialog.Files.Strings[i])+'\temp\'+ExtractFileName(openDialog.Files.Strings[i]);
      end;

      openDialog.InitialDir:=ExtractFileDir(openDialog.Files.Strings[0]);

      for i :=0 to openDialog.Files.Count -1 do
      begin
        lf := FreeLasFiles.Add as TLasFile;
        lf.OldFileName := openDialog.Files.Strings[i];
        frmTrwLasFiles.trwLasFiles.Items.AddObject(nil,ExtractFileName(lf.OldFileName), lf );
      end;

      TMainFacade.GetInstance.AllAreas.MakeList(frmChangeLasFile1.lstBoxArea.Items);
      frmChangeLasFile1.pgcMain.ActivePageIndex:=0;
  end;
end;

procedure TformAddLasFile.TBDelClick(Sender: TObject);
begin
frmTrwLasFiles.DelSelectedLasFiles;
end;

procedure TformAddLasFile.N2Click(Sender: TObject);
begin
if not Assigned (frmCurveDict) then frmCurveDict := TfrmCurveDict.Create(Self);
  frmCurveDict.ShowModal;
end;

procedure TformAddLasFile.LasFileCollectionChanged(Sender: TObject);
begin
  frmChangeLasFile1.LasFiles := Sender as TLasFiles;
end;

procedure TformAddLasFile.SelectedLasFileChanged(Sender: TObject);
begin
  frmChangeLasFile1.SelectedLasFile := Sender as TLasFile;
end;

procedure TformAddLasFile.frmChangeLasFile1actJoinToWellExecute(
  Sender: TObject);
begin
  frmChangeLasFile1.actJoinToWellExecute(Sender);

end;

end.
