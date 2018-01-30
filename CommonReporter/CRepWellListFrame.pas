unit CRepWellListFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Well, ComCtrls, JvExComCtrls, JvListView, StdCtrls,
  JvExStdCtrls, JvGroupBox;

type
  TfrmWellList = class(TFrame)
    gbxWells: TJvGroupBox;
    lvWells: TJvListView;
  private
    FSelectedWells: TSimpleWells;
    function GetSeletedWells: TSimpleWells;
    function GetSelectedWell: TSimpleWell;
    { Private declarations }
  public
    { Public declarations }
    property  SelectedWells: TSimpleWells read GetSeletedWells;
    property  SelectedWell: TSimpleWell read GetSelectedWell;
    procedure ReloadWells();
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses Facade, SDFacade, BaseObjects;

{ TfrmWellList }

destructor TfrmWellList.Destroy;
begin
  FreeAndNil(FSelectedWells);
  inherited;
end;

function TfrmWellList.GetSelectedWell: TSimpleWell;
begin
  if Assigned(lvWells.Selected) then
    Result := TSimpleWell(lvWells.Selected.Data)
  else
    Result := nil;
end;

function TfrmWellList.GetSeletedWells: TSimpleWells;
var i: integer;
begin
  if not Assigned(FSelectedWells) then
  begin
    FSelectedWells := TSimpleWells.Create;
    FSelectedWells.OwnsObjects := false;
    FSelectedWells.Poster := nil;
  end
  else FSelectedWells.Clear;


  for i := 0 to lvWells.Items.Count - 1 do
  if lvWells.Items[i].Selected then
    FSelectedWells.Add(TSimpleWell(lvWells.Items[i].Data), False, True);


  Result := FSelectedWells;
end;

procedure TfrmWellList.ReloadWells;
var i: integer;
    li: TListItem;
    lg: TJvListViewGroup;
begin
  lvWells.Items.Clear;
  with TMainFacade.GetInstance.AllWells do
  for i := 0 to Count - 1 do
  begin
    li := lvWells.Items.Add;
    li.Caption := Items[i].Area.Name;
    li.SubItems.Add(Items[i].NumberWell);
    li.Data := Items[i];
  end;
end;

end.
