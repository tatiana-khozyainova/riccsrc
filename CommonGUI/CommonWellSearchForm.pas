unit CommonWellSearchForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ExtCtrls, Menus;

type
  TfrmWellSearch = class(TForm)
    pnlButtons: TPanel;
    btnClose: TButton;
    btnResultsToFilter: TButton;
    gbxName: TGroupBox;
    lblAreaName: TLabel;
    edtAreaName: TEdit;
    lblWellNum: TLabel;
    edtWellNum: TEdit;
    chbxStrictAreaSearch: TCheckBox;
    chbxStrictWellSearch: TCheckBox;
    gbxAreaList: TGroupBox;
    chklstAreaList: TCheckListBox;
    btnSearch: TButton;
    pmListOperations: TPopupMenu;
    pmiSelectAll: TMenuItem;
    pmiDeselectAll: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    pmiDeleteAll: TMenuItem;
    procedure btnSearchClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnResultsToFilterClick(Sender: TObject);
    procedure pmiSelectAllClick(Sender: TObject);
    procedure pmiDeselectAllClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure pmiDeleteAllClick(Sender: TObject);
  private
    { Private declarations }
    FAreaList: TStrings;
    function GetAreaList: TStrings;
    procedure ChangeListState(AChecked: boolean);
  public
    { Public declarations }
    property  AreaList: TStrings read GetAreaList;
    destructor Destroy; override;
  end;

var
  frmWellSearch: TfrmWellSearch;

implementation


{$R *.dfm}

uses WellSearchController;

procedure TfrmWellSearch.btnSearchClick(Sender: TObject);
begin
  with TWellSearchController.GetInstance do
  begin
    AreaName := edtAreaName.Text;
    WellNum := edtWellNum.Text;
    StrictAreaSearch := chbxStrictAreaSearch.Checked;
    StrictWellSearch := chbxStrictWellSearch.Checked;
    ExecuteQuery;

    chklstAreaList.Items.Clear;
    chklstAreaList.Items.AddStrings(AreaList);
  end;
end;

procedure TfrmWellSearch.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmWellSearch.btnResultsToFilterClick(Sender: TObject);
var i: integer;
begin
  AreaList.Clear;
  for i := 0 to chklstAreaList.Items.Count - 1 do
  if chklstAreaList.Checked[i] then
    AreaList.AddObject(chklstAreaList.Items[i], chklstAreaList.Items.Objects[i]); 
end;

function TfrmWellSearch.GetAreaList: TStrings;
begin
  if not Assigned(FAreaList) then
     FAreaList := TStringList.Create;
  Result := FAreaList;
end;

destructor TfrmWellSearch.Destroy;
begin
  FreeAndNil(FAreaList); 
  inherited;
end;

procedure TfrmWellSearch.pmiSelectAllClick(Sender: TObject);
begin
  ChangeListState(true)
end;

procedure TfrmWellSearch.ChangeListState(AChecked: boolean);
var i: integer;
begin
  for i := 0 to chklstAreaList.Items.Count - 1 do
    chklstAreaList.Checked[i] := AChecked;
end;

procedure TfrmWellSearch.pmiDeselectAllClick(Sender: TObject);
begin
  ChangeListState(false);
end;

procedure TfrmWellSearch.N1Click(Sender: TObject);
var i: integer;
begin
  for i := 0 to chklstAreaList.Items.Count - 1 do
    chklstAreaList.Checked[i] := not chklstAreaList.Checked[i];
end;

procedure TfrmWellSearch.pmiDeleteAllClick(Sender: TObject);
begin
  chklstAreaList.Clear;
end;

end.
