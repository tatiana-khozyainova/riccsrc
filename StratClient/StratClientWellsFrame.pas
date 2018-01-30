unit StratClientWellsFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, StratClientSubdivisionEditFrame, Well,
  ActnList, Menus, SubdivisionTable;

type
  TfrmWells = class(TFrame)
    pnlThemes: TPanel;
    gbxWells: TGroupBox;
    lwWells: TListView;
    lblThemesSelected: TLabel;
    btnThemeSelec: TButton;
    spl1: TSplitter;
    frmSubdivisionEditFrame1: TfrmSubdivisionEditFrame;
    pmTools: TPopupMenu;
    actnlstWells: TActionList;
    actnSelectAll: TAction;
    actnDeselectAll: TAction;
    actnViewSubs: TAction;
    actnSwitchSelection: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    actnSwitchSelection1: TMenuItem;
    N3: TMenuItem;
    actnViewSubs1: TMenuItem;
    actnThemeSelect: TAction;
    actnExcelExport: TAction;
    dlgOpen: TOpenDialog;
    N4: TMenuItem;
    actnExcelExport1: TMenuItem;
    actnEditSubs: TAction;
    actnEditSubs1: TMenuItem;
    actnImportSubs: TAction;
    procedure actnSelectAllExecute(Sender: TObject);
    procedure actnDeselectAllExecute(Sender: TObject);
    procedure actnSwitchSelectionExecute(Sender: TObject);
    procedure actnViewSubsExecute(Sender: TObject);
    procedure actnSelectAllUpdate(Sender: TObject);
    procedure actnDeselectAllUpdate(Sender: TObject);
    procedure actnViewSubsUpdate(Sender: TObject);
    procedure actnSwitchSelectionUpdate(Sender: TObject);
    procedure actnThemeSelectExecute(Sender: TObject);
    procedure actnExcelExportExecute(Sender: TObject);
    procedure actnExcelExportUpdate(Sender: TObject);
    procedure actnEditSubsExecute(Sender: TObject);
    procedure actnEditSubsUpdate(Sender: TObject);
    procedure actnImportSubsExecute(Sender: TObject);
  private
    FSelectedWells: TWells;
    FSt, FImportSt: TSubdivisionTable;

    function GetSelectedWells: TWells;
    function GetCheckedCount: integer;
    procedure ShowEditForm(ASubdivisionTable: TSubdivisionTable);
    { Private declarations }
  public
    { Public declarations }
    procedure ReloadWells;
    procedure LoadSubdivisions;
    procedure LoadFile(const AFileName: string);
    property  CheckedWellsCount: integer read GetCheckedCount;
    property  SelectedWells: TWells read GetSelectedWells;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses Facade, StratClientThemesForm, BaseObjects, Theme,
  StratClientSubdivisionEditForm;

{$R *.dfm}

{ TfrmWells }

procedure TfrmWells.ReloadWells;
var i: integer;
    li: TListItem;
begin
  frmSubdivisionEditFrame1.Clear;
  lwWells.Items.BeginUpdate;
  lwWells.Items.Clear;
  with TMainFacade.GetInstance.AllWells  do
  for i := 0 to Count - 1 do
  begin
    li := lwWells.Items.Add;
    li.Caption := Items[i].Area.List;
    li.SubItems.Add(Items[i].NumberWell);
    li.SubItems.Add(Format('%.2f', [Items[i].TrueDepth]));
    li.SubItems.Add(Format('%.2f', [Items[i].Altitude]));
    li.Data := Items[i];
  end;
  lwWells.Items.EndUpdate;
end;

procedure TfrmWells.LoadSubdivisions;
var ths: TThemes;
    i: integer;
begin
  ths := nil;
  if Assigned(frmThemes) then ths := frmThemes.SelectedThemes;

  FreeAndNil(FSt);
  FSt := TSubdivisionTable.Create;
  FSt.LoadSubdivisions(ths, SelectedWells);

  for i := 0 to SelectedWells.Count  - 1 do
  if SelectedWells.Items[i].Subdivisions.Count > 0 then
    FSt.FoundWells.Add(SelectedWells.Items[i], true, true);

  FSt.LoadSubdivisionTable(TMainFacade.GetInstance.AllSimpleStratons, (TMainFacade.GetInstance as TMainFacade).AllSubdivisionComments, (TMainFacade.GetInstance as TMainFacade).AllTectonicBlocks);
  frmSubdivisionEditFrame1.Clear;
  frmSubdivisionEditFrame1.SubdivisionTable := FSt;
  frmSubdivisionEditFrame1.Reload;
end;

function TfrmWells.GetSelectedWells: TWells;
var i: integer;
begin
  if not Assigned(FSelectedWells) then
  begin
    FSelectedWells := TWells.Create;
    FSelectedWells.OwnsObjects := false;
  end
  else FSelectedWells.Clear;

  for i := 0 to lwWells.Items.Count - 1 do
  if lwWells.Items[i].Checked then
    FSelectedWells.Add(TWell(lwWells.Items[i].Data), false, false);

  Result := FSelectedWells;
end;

procedure TfrmWells.actnSelectAllExecute(Sender: TObject);
var i: integer;
begin
  for i := 0 to lwWells.Items.Count - 1 do
    lwWells.Items[i].Checked := true;

end;

procedure TfrmWells.actnDeselectAllExecute(Sender: TObject);
var i: integer;
begin
  for i := 0 to lwWells.Items.Count - 1 do
    lwWells.Items[i].Checked := true;

end;

procedure TfrmWells.actnSwitchSelectionExecute(Sender: TObject);
var i: integer;
begin
  for i := 0 to lwWells.Items.Count - 1 do
    lwWells.Items[i].Checked := not lwWells.Items[i].Checked;

end;

procedure TfrmWells.actnViewSubsExecute(Sender: TObject);
begin
  LoadSubdivisions;
end;

procedure TfrmWells.actnSelectAllUpdate(Sender: TObject);
begin
  actnSelectAll.Enabled := lwWells.Items.Count > 0;
end;

procedure TfrmWells.actnDeselectAllUpdate(Sender: TObject);
begin
  actnDeSelectAll.Enabled := lwWells.Items.Count > 0;
end;

procedure TfrmWells.actnViewSubsUpdate(Sender: TObject);
begin
  actnViewSubs.Enabled := (lwWells.Items.Count > 0) and (CheckedWellsCount > 0);
end;

function TfrmWells.GetCheckedCount: integer;
var i: integer;
begin
  Result := 0;
  for i := 0 to lwWells.Items.Count - 1 do
    Result := Result + Ord(lwWells.Items[i].Checked);
end;

constructor TfrmWells.Create(AOwner: TComponent);
begin
  inherited;
  frmSubdivisionEditFrame1.AllowEdit := false;
end;

procedure TfrmWells.actnSwitchSelectionUpdate(Sender: TObject);
begin
  actnSwitchSelection.Enabled := lwWells.Items.Count > 0;
end;

destructor TfrmWells.Destroy;
begin
  frmSubdivisionEditFrame1.SubdivisionTable := nil;
  FreeAndNil(FSt);
  FreeAndNil(FImportSt);
  inherited;
end;

procedure TfrmWells.actnThemeSelectExecute(Sender: TObject);
begin
  if not Assigned(frmThemes) then
  begin
    frmThemes := TfrmThemes.Create(Self);
    frmThemes.LoadThemes;
  end;

  if frmThemes.ShowModal = mrOk then
  begin
    if not frmThemes.AllThemesSelected then
      lblThemesSelected.Caption := '¬ыбранные темы: ' + frmThemes.SelectedThemes.List(loBrief)
    else
      lblThemesSelected.Caption := '¬ыбранные темы: все темы';
  end;
end;

procedure TfrmWells.actnExcelExportExecute(Sender: TObject);
begin
  if dlgOpen.Execute then
    frmSubdivisionEditFrame1.ExportToExcel(dlgOpen.FileName);
end;

procedure TfrmWells.actnExcelExportUpdate(Sender: TObject);
begin
  actnExcelExport.Enabled := Assigned(FSt);
end;

procedure TfrmWells.actnEditSubsExecute(Sender: TObject);
begin
  LoadSubdivisions;
  ShowEditForm(FSt);
end;

procedure TfrmWells.actnEditSubsUpdate(Sender: TObject);
begin
  actnEditSubs.Enabled := (lwWells.Items.Count > 0) and (CheckedWellsCount > 0);
end;

procedure TfrmWells.actnImportSubsExecute(Sender: TObject);
begin
  if dlgOpen.Execute then
  begin
    LoadFile(dlgOpen.FileName);
    ShowEditForm(FImportSt);
  end

end;

procedure TfrmWells.LoadFile(const AFileName: string);
begin
  FreeAndNil(FImportSt);
  FImportSt := TSubdivisionTable.Create;
  FImportSt.FirstCol := 1;
  FImportSt.FirstRow := 1;
  // загрузилс€ ли
  FImportSt.LoadFromFile(AFileName);
  // разобрались ли разбивки
  FImportSt.LoadSubdivisionTable(TMainFacade.GetInstance.AllSimpleStratons, (TMainFacade.GetInstance as TMainFacade).AllSubdivisionComments, (TMainFacade.GetInstance as TMainFacade).AllTectonicBlocks);
end;

procedure TfrmWells.ShowEditForm(ASubdivisionTable: TSubdivisionTable);
begin
  if Assigned(frmSubdivisionEditForm) then frmSubdivisionEditForm.Free;

  frmSubdivisionEditForm := TfrmSubdivisionEditForm.Create(Application.MainForm);
  with frmSubdivisionEditForm.frmSubdivisionEditFrame1 do
  begin
    SubdivisionTable := ASubdivisionTable;
    Reload;
  end;
  frmSubdivisionEditForm.ShowModal;
end;

end.
