unit ExportGisForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, CheckLst, Menus, ComCtrls, Facade, ActnList,
  Area,Well, Buttons;

type
  TExportGis = class(TForm)
    mm1: TMainMenu;
    A1: TMenuItem;
    N1: TMenuItem;
    pnlWells: TPanel;
    spl1: TSplitter;
    pnl1: TPanel;
    gbxWells: TGroupBox;
    lstWells: TListBox;
    pnlArea: TPanel;
    spl2: TSplitter;
    pnlAddedWells: TPanel;
    chklstAreas: TCheckListBox;
    lstAddedWells: TListBox;
    actlst1: TActionList;
    actMakeWells: TAction;
    actWellsForExport: TAction;
    actBrose: TAction;
    dlgOpen: TOpenDialog;
    actExport: TAction;
    pbExport: TProgressBar;
    pgc2: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    lblLas: TLabel;
    chkLAS: TCheckBox;
    chkScans: TCheckBox;
    gbxTypes: TGroupBox;
    gbxPath: TGroupBox;
    btnBrose: TBitBtn;
    edtPath: TEdit;
    gbxAddedWells: TGroupBox;
    gbxAreas: TGroupBox;
    btnDel: TSpeedButton;
    btnExport: TSpeedButton;
    actDelSelectedWells: TAction;
    procedure FormCreate(Sender: TObject);
    procedure actMakeWellsExecute(Sender: TObject);
    procedure actWellsForExportExecute(Sender: TObject);
    procedure actBroseExecute(Sender: TObject);
    procedure actExportExecute(Sender: TObject);
    procedure actDelSelectedWellsExecute(Sender: TObject);
  private
    { Private declarations }
    FAddedWell: TSimpleWell;
    function GetAddedWell : TSimpleWell;
  public
    { Public declarations }
    property AddedWell : TSimpleWell read GetAddedWell;
  end;

var
  ExportGis: TExportGis;

implementation

uses Math;

{$R *.dfm}

procedure TExportGis.FormCreate(Sender: TObject);
var
  query:string;
  Aresult:OleVariant;
  i:Integer;
begin
edtPath.Text:='C:\';
for i:=0 to TMainFacade.GetInstance.AllAreas.Count-1 do
  chklstAreas.Items.AddObject(TMainFacade.GetInstance.AllAreas.Items[i].Name,  TMainFacade.GetInstance.AllAreas.Items[i]);
end;

procedure TExportGis.actMakeWellsExecute(Sender: TObject);
var
  i,k:Integer;
  Area:TArea;
begin
  lstAddedWells.Items.Clear;
  for i:=0 to chklstAreas.Count-1 do
    if (chklstAreas.Checked[i]) then
      begin
        Area:=TArea (chklstAreas.Items.Objects[i]);
        TMainFacade.GetInstance.SkipWells;
         for k:=0 to Area.Wells.Count-1 do
          lstAddedWells.Items.AddObject(Area.Wells.Items[k].NumberWell+'-'+Area.Name, Area.Wells.Items[k]);
      end;
end;

procedure TExportGis.actWellsForExportExecute(Sender: TObject);
var
  i,k:integer;
begin
  if Assigned(AddedWell) then
  if (lstWells.Count=0) then
    begin
      for i:=0 to TMainFacade.GetInstance.AllAreas.Count-1 do
        if Assigned(TMainFacade.GetInstance.AllAreas.Items[i].Wells.ItemsByID[AddedWell.ID]) then
          begin
            lstWells.Items.AddObject(AddedWell.NumberWell+' - '+TMainFacade.GetInstance.AllAreas.Items[i].Name, AddedWell);
            Break;
          end;
    end
  else
    for i:=0 to lstWells.Count-1 do
      begin
        if (TSimpleWell(lstWells.Items.Objects[i])=AddedWell) then Break;
        if (i=lstWells.Count-1) then
          begin
            for k:=0 to TMainFacade.GetInstance.AllAreas.Count-1 do
              if Assigned(TMainFacade.GetInstance.AllAreas.Items[k].Wells.ItemsByID[AddedWell.ID]) then
              begin
                lstWells.Items.AddObject(AddedWell.NumberWell+' - '+TMainFacade.GetInstance.AllAreas.Items[k].Name, AddedWell);
                Break;
              end;
          end;
      end;
end;

function TExportGis.GetAddedWell: TSimpleWell;
begin
  if lstAddedWells.ItemIndex > -1 then
    Result := TSimpleWell(lstAddedWells.Items.Objects[lstAddedWells.ItemIndex])
  else
    Result := nil;
end;

procedure TExportGis.actBroseExecute(Sender: TObject);
begin
  dlgOpen := TOpenDialog.Create(self);
  dlgOpen.InitialDir := GetCurrentDir;
  if dlgOpen.Execute then
  begin
    dlgOpen.InitialDir:=ExtractFileDir(dlgOpen.FileName);
    edtPath.Text:=ExtractFileDir(dlgOpen.FileName);
  end;
end;

procedure TExportGis.actExportExecute(Sender: TObject);
var
  i,k:integer;
  Well:TSimpleWell;
  f:file of integer;
  s,q:string;
begin
  pbExport.Max:=0;
  pbExport.Position:=1;
  TMainFacade.GetInstance.SkipExportWells;
  if (chkLAS.Checked) then
  begin
    TMainFacade.GetInstance.ExportFilter:='well_uin in (';
    for i:=0 to lstWells.Count-1 do
      begin
        Well:=TSimpleWell(lstWells.Items.Objects[i]);
        TMainFacade.GetInstance.ExportFilter:=TMainFacade.GetInstance.ExportFilter+IntToStr(Well.ID)+',';
      end;
    s:=TMainFacade.GetInstance.ExportFilter;
    s[length(s)]:=')';
    TMainFacade.GetInstance.ExportFilter:=s;
    for i:=0 to TMainFacade.GetInstance.AllExportWells.Count-1 do
      pbExport.Max:=pbExport.Max+TMainFacade.GetInstance.AllExportWells.Items[i].LasFiles.Count;

    for i:=0 to TMainFacade.GetInstance.AllExportWells.Count-1 do
      begin
        s:=edtPath.Text+ string(TMainFacade.GetInstance.AllExportWells.Items[i].Area.Name)+'\'+TMainFacade.GetInstance.AllExportWells.Items[i].NumberWell+'-'+TMainFacade.GetInstance.AllExportWells.Items[i].Area.Name+'\LAS-файлы';
        if not DirectoryExists(s) then ForceDirectories(s);
        if (Assigned(TMainFacade.GetInstance.AllExportWells.Items[i].LasFiles)) then
        for k:=0 to TMainFacade.GetInstance.AllExportWells.Items[i].LasFiles.Count-1 do
          begin
            AssignFile(f,s+'\'+ExtractFileName(TMainFacade.GetInstance.AllExportWells.Items[i].LasFiles.Items[k].OldFileName));
            Rewrite(f);
            closeFile(f);
            pbExport.Position:=pbExport.Position+1;
          end;
      end;
  end;
  MessageDlg('Данные ГИС успешно выгружены.', mtInformation, [mbOK],0);
end;

procedure TExportGis.actDelSelectedWellsExecute(Sender: TObject);
var
  i:Integer;
begin
lstWells.Items.Delete(lstWells.ItemIndex);
end;

end.
