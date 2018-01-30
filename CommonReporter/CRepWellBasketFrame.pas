unit CRepWellBasketFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, JvExComCtrls, JvComCtrls, StdCtrls, JvExStdCtrls,
  JvGroupBox, Well, JvListView;

type
  TfrmWellBasket = class(TFrame)
    gbxSelectedWells: TJvGroupBox;
    tvSelectedWells: TJvTreeView;
  private
    { Private declarations }
    FSelectedWells: TSimpleWells;
    function TreeNodeByObject(AObject: TObject): TTreeNode;
    function GetBasketWells: TSimpleWells;
    function GetSelectedWells: TSimpleWells;
    function GetSelectedWell: TSimpleWell;
  public
    { Public declarations }
    procedure ReloadWells(ClearFirst: Boolean);
    property  BasketWells: TSimpleWells read GetBasketWells;
    property  SelectedWells: TSimpleWells read GetSelectedWells;
    property  SelectedWell: TSimpleWell read GetSelectedWell;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses Facade;

{ TfrmWellBasket }

constructor TfrmWellBasket.Create(AOwner: TComponent);
begin
  inherited;
  FSelectedWells := nil;
end;

function TfrmWellBasket.GetBasketWells: TSimpleWells;
begin
  Result := TMainFacade.GetInstance.SelectedWells;
end;

function TfrmWellBasket.GetSelectedWell: TSimpleWell;
begin
  if Assigned(tvSelectedWells.Selected) then
    Result := TSimpleWell(tvSelectedWells.Selected.Data)
  else
    Result := nil;
end;

function TfrmWellBasket.GetSelectedWells: TSimpleWells;
var i: integer;
begin
  if not Assigned(FSelectedWells) then
  begin
    FSelectedWells := TSimpleWells.Create();
    FSelectedWells.OwnsObjects := False;
    FSelectedWells.Poster := nil;
  end
  else FSelectedWells.Clear;


  for i := 0 to tvSelectedWells.Items.Count - 1 do
  if (tvSelectedWells.Items[i].Level = 0) and tvSelectedWells.Items[i].Selected then
    FSelectedWells.Add(TSimpleWell(tvSelectedWells.Items[i].Data), false, True);

  Result := FSelectedWells; 
end;

procedure TfrmWellBasket.ReloadWells(ClearFirst: Boolean);
var i, j: integer;
    Node: TTreeNode;
begin
  if ClearFirst then tvSelectedWells.Items.Clear;
  for i := 0 to BasketWells.Count - 1 do
  begin
    Node := TreeNodeByObject(BasketWells.Items[i]);
    if not Assigned(Node) then
      Node := tvSelectedWells.Items.AddObject(nil, BasketWells.Items[i].List(), BasketWells.Items[i]);

    for j := 0 to BasketWells.Items[i].InfoGroups.Count - 1 do
      tvSelectedWells.Items.AddChildObject(Node, BasketWells.Items[i].InfoGroups.Items[j].Name, BasketWells.Items[i].InfoGroups.Items[j]);
  end;
end;

function TfrmWellBasket.TreeNodeByObject(AObject: TObject): TTreeNode;
var i: integer;
begin
  Result := nil;
  
  for i := 0 to tvSelectedWells.Items.Count - 1 do
  if TObject(tvSelectedWells.Items[i].Data) = AObject then
  begin
    Result := tvSelectedWells.Items[i];
    Break;
  end;
end;

end.
