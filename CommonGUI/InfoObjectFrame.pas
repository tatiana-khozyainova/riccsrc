unit InfoObjectFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, ActnList, Buttons,
  ToolWin, StdCtrls, ImgList, Well, Slotting, CoreDescription,
  InfoPropertiesFrame, InfoWellsFrame;

type
  TfrmInfoObject = class(TFrame)
    Splitter1: TSplitter;
    frmInfoProperties: TfrmInfoProperties;
    frmInfoWells: TfrmInfoWells;
    procedure frmInfoWellstvwWellsCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure frmInfoWellstvwWellsClick(Sender: TObject);
    procedure frmInfoWellstvwWellsExpanding(Sender: TObject;
      Node: TTreeNode; var AllowExpansion: Boolean);
    procedure frmInfoWellstvwWellsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FActiveWells: TWells;

    function    GetActiveWell: TWell;
    function    GetActiveWells: TWells;
  public
    property    ActiveWell: TWell read GetActiveWell;
    property    ActiveWells: TWells read GetActiveWells;
    function    GetNodeByID(AID: integer): TTreeNode;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses Facade, Area, Math, BaseObjects;

{$R *.dfm}

{ TfrmInfoObject }

constructor TfrmInfoObject.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TfrmInfoObject.Destroy;
begin

  inherited;
end;

function TfrmInfoObject.GetActiveWell: TWell;
begin
  Result := nil;

  if Assigned (frmInfoWells.tvwWells.Selected) then
  case frmInfoWells.tvwWells.Selected.Level of
    0 : Result := TWell(frmInfoWells.tvwWells.Selected.Data);
  end;
end;

procedure TfrmInfoObject.frmInfoWellstvwWellsCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  frmInfoWells.tvwWellsGetImageIndex(Sender, Node);
end;

procedure TfrmInfoObject.frmInfoWellstvwWellsClick(Sender: TObject);
begin
  if frmInfoWells.tvwWells.Items.Count > 0 then
  begin
    frmInfoWells.tvwWellsClick(Sender);

    (TMainFacade.GetInstance as TMainFacade).ActiveWell := ActiveWell;

    frmInfoProperties.lstInfoPropertiesWell.Items.BeginUpdate;

    frmInfoProperties.ActiveWell := ActiveWell;

    ActiveWell.CountFields := 92;

    if Assigned (ActiveWell) then
      ActiveWell.MakeList(frmInfoProperties.lstInfoPropertiesWell, true);

    frmInfoProperties.lstInfoPropertiesWell.Items.EndUpdate;
  end;
end;

procedure TfrmInfoObject.frmInfoWellstvwWellsExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
begin
  frmInfoWells.tvwWellsExpanding(Sender, Node, AllowExpansion);

end;

procedure TfrmInfoObject.frmInfoWellstvwWellsKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Ord(Key) = 40) or (Ord(Key) = 38) then
  begin
    frmInfoWells.tvwWellsKeyUp(Sender, Key, Shift);
    frmInfoWellstvwWellsClick(Sender);
  end;
end;

function TfrmInfoObject.GetActiveWells: TWells;
var i : Integer;
    o : TWell;
begin
  if not Assigned (FActiveWells) then
    FActiveWells := TWells.Create;
  FActiveWells.Clear;

  for i := 0 to frmInfoWells.tvwWells.SelectionCount - 1 do
  if frmInfoWells.tvwWells.Selections[i].Level = 0 then
    begin
      o := TWell(frmInfoWells.tvwWells.Selections[i].Data);
      FActiveWells.Add(o, False, False);
    end;

  Result := FActiveWells;
end;

function TfrmInfoObject.GetNodeByID(AID: integer): TTreeNode;
var i: integer;
begin
  Result := nil;
  for i := 0 to frmInfoWells.tvwWells.Items.Count - 1 do
  If Assigned(frmInfoWells.tvwWells.Items[i].Data) and (TIDObject(frmInfoWells.tvwWells.Items[i].Data).ID = AID) then
  begin
    Result := frmInfoWells.tvwWells.Items[i];
    break;
  end;

end;

end.
