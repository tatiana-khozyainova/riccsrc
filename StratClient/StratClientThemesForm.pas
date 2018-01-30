unit StratClientThemesForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Theme, ToolWin;

type
  TfrmThemes = class(TForm)
    pnlButtons: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    gbxTheme: TGroupBox;
    lwTheme: TListView;
    btnReloadThemes: TButton;
    tlbrTools: TToolBar;
    btnSelectAll: TToolButton;
    edtSearch: TEdit;
    btnCheckSelected: TToolButton;
    btn1: TToolButton;

    procedure btnReloadThemesClick(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure edtSearchEnter(Sender: TObject);
    procedure edtSearchExit(Sender: TObject);
    procedure btnCheckSelectedClick(Sender: TObject);
  private
    { Private declarations }
    FSelectedThemes: TThemes;
    FSearchInvite: string;
    function GetSelectedThemes: TThemes;
    function GetAllThemesSelected: boolean;
    function GetCheckedCount: integer;
  public
    { Public declarations }

    procedure  SearchByNumberOrName;
    property   CheckedCount: integer read GetCheckedCount;
    property   AllThemesSelected: boolean read GetAllThemesSelected;
    property   SelectedThemes: TThemes read GetSelectedThemes;
    procedure  LoadThemes;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;


var
  frmThemes: TfrmThemes;

implementation


uses Facade;

{$R *.dfm}

{ TForm1 }

procedure TfrmThemes.LoadThemes;
var i: integer;
    li: TListItem;
begin
  lwTheme.Items.BeginUpdate;
  lwTheme.Items.Clear;

  with (TMainFacade.GetInstance as TMainFacade).SubdivisionThemes do
  for i := 0 to Count - 1 do
  begin
    li := lwTheme.Items.Add;
    li.Caption := Items[i].Number;
    li.SubItems.Add(Items[i].Name);
    li.Data := Items[i];
    li.Checked := true;
  end;

  lwTheme.Items.EndUpdate;

end;

procedure TfrmThemes.btnReloadThemesClick(Sender: TObject);
begin
  (TMainFacade.GetInstance as TMainFacade).RefreshSubdivisionThemes;
  LoadThemes;
end;

function TfrmThemes.GetSelectedThemes: TThemes;
var i: integer;
begin
  if not Assigned(FSelectedThemes) then
  begin
    FSelectedThemes := TThemes.Create;
    FSelectedThemes.OwnsObjects := false;
  end
  else FSelectedThemes.Clear;

  with lwTheme do
  for i := 0 to Items.Count - 1 do
  if Items[i].Checked then
    FSelectedThemes.Add(TTheme(Items[i].Data), false, false);


  Result := FSelectedThemes;
end;

destructor TfrmThemes.Destroy;
begin
  FreeAndNil(FSelectedThemes);
  inherited;
end;

function TfrmThemes.GetAllThemesSelected: boolean;
begin
  REsult := CheckedCount = (TMainFacade.GetInstance as TMainFacade).SubdivisionThemes.Count;  
end;

function TfrmThemes.GetCheckedCount: integer;
var i: integer;
begin
  Result := 0;
  with lwTheme do
  for i := 0 to Items.Count - 1 do
    Result := Result + ord(Items[i].Checked);
end;

procedure TfrmThemes.btnSelectAllClick(Sender: TObject);
var i: integer;
begin
  //btnSelectAll.Down := not btnSelectAll.Down;
  for i := 0 to lwTheme.Items.Count - 1 do
    lwTheme.Items[i].Checked := btnSelectAll.Down;

end;

constructor TfrmThemes.Create(AOwner: TComponent);
begin
  inherited;
  FSearchInvite := 'введите часть номера или названия темы';
  edtSearch.Text := FSearchInvite;
end;

procedure TfrmThemes.edtSearchChange(Sender: TObject);
begin
  if edtSearch.Text = FSearchInvite then edtSearch.Font.Color := clGrayText
  else edtSearch.Font.Color := clWindowText;

  SearchByNumberOrName;
end;

procedure TfrmThemes.edtSearchEnter(Sender: TObject);
begin
  if edtSearch.Text = FSearchInvite then
    edtSearch.Text := '';
end;

procedure TfrmThemes.edtSearchExit(Sender: TObject);
begin
  if trim(edtSearch.Text) = '' then edtSearch.Text := FSearchInvite;
end;

procedure TfrmThemes.SearchByNumberOrName;
var i: integer;
begin
  if edtSearch.Text <> FSearchInvite then
  begin
    for i := 0 to lwTheme.Items.Count - 1 do
      lwTheme.Items[i].Selected := (pos(AnsiUpperCase(edtSearch.Text), AnsiUpperCase(lwTheme.Items[i].Caption)) > 0) or (pos(AnsiUpperCase(edtSearch.Text), AnsiUpperCase(lwTheme.Items[i].SubItems[0])) > 0);
  end;
end;

procedure TfrmThemes.btnCheckSelectedClick(Sender: TObject);
var i: integer;
begin

  with lwTheme do
  for i := 0 to Items.Count - 1 do
    Items[i].Checked := Items[i].Selected;

end;

end.
